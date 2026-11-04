/* co_shim.c : the host primitives the ported coroutine runtime (co.c) needs,
   provided vm-lessly for the Skjegg JIT.

   co.c is copied unchanged from the Kobold tree.  It threads a kp_vm pointer
   through its calls but never dereferences it (co.h: "the core does not
   dereference it yet"), so here a dummy NULL vm flows through and these shims
   ignore it.  They supply three things co.c leans on:

     - a handle table, where a coroutine lives as a KP_H_CONT entry (an id with
       low bit 1, disjoint from a gheap object; see obj.h and rt_host.c);
     - low-memory guarded stacks, so a coroutine frame address is a valid 32-bit
       guest pointer and an overflow faults in a guard page;
     - a minimal trap/landing layer (setjmp pad + kp_raise), the recoverable-trap
       mechanism co_run uses to catch a fault inside a coroutine.

   The guest calls the coroutine operators without a vm (kp_co_new takes three
   arguments, not four), so the small wrappers at the end add the dummy vm. */

#define _GNU_SOURCE
#include "handle.h"
#include "lowmem.h"
#include "co.h"
#include "target.h"

#include <setjmp.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

/****************************************************************
 * The handle table
 *
 * A coroutine id is a table id: low bit 1, the untagged value a 1-based slot
 * index (matching src/handle.c's HV_TAG/HV_UNTAG).  rt_host.c's kp_retain and
 * kp_release route a table-id value here through co_table_retain/release.
 ****************************************************************/

struct ht_entry {
    uint32_t refcount;          /* 0 marks a free slot */
    int kind;
    void *obj;
    kp_finalize fin;
};

static struct ht_entry *ht;
static int ht_cap;

#define HV_TAG(i)    (((uint32_t)(i) << 1) | 1u)   /* i is 1-based */
#define HV_UNTAG(v)  ((v) >> 1)

static struct ht_entry *
ht_lookup(kp_gptr id)
{
    uint32_t u = (uint32_t)HV_UNTAG(id);   /* a small 1-based slot index */

    if (u == 0 || (int)u > ht_cap)
        return NULL;
    return &ht[u - 1];
}

kp_gptr
kp_handle_intern(kp_vm *vm, enum kp_handle_kind kind, void *obj, kp_finalize fin)
{
    int i;

    (void)vm;
    for (i = 0; i < ht_cap; i++)
        if (ht[i].refcount == 0)
            break;
    if (i == ht_cap) {
        int ncap = ht_cap ? ht_cap * 2 : 16;
        struct ht_entry *n = realloc(ht, (size_t)ncap * sizeof(*n));

        if (!n)
            return 0;
        memset(n + ht_cap, 0, (size_t)(ncap - ht_cap) * sizeof(*n));
        ht = n;
        ht_cap = ncap;
    }
    ht[i].refcount = 1;
    ht[i].kind = (int)kind;
    ht[i].obj = obj;
    ht[i].fin = fin;
    return HV_TAG(i + 1);
}

void *
kp_handle_ptr(kp_vm *vm, kp_gptr id, enum kp_handle_kind kind)
{
    struct ht_entry *e = ht_lookup(id);

    (void)vm;
    if (!e || e->refcount == 0 || e->kind != (int)kind)
        return NULL;
    return e->obj;
}

/* Run the finalizer of every handle still live, at program teardown, so a host
   object left interned (a global handle never explicitly released) and a
   coroutine left suspended are reclaimed, matching src/handle.c's kp_vm_free
   sweep.  The slot is cleared before its finalizer runs, and the scan re-reads
   each slot, so a finalizer that frees or adds handles (a coroutine cancel-unwind
   does) is handled. */
void
kp_handle_sweep(void)
{
    int i;

    for (i = 0; i < ht_cap; i++) {
        if (ht[i].refcount != 0) {
            kp_finalize fin = ht[i].fin;
            void *obj = ht[i].obj;

            ht[i].refcount = 0;
            ht[i].obj = NULL;
            ht[i].fin = NULL;
            ht[i].kind = 0;
            if (fin)
                fin(NULL, obj);
        }
    }
}

/* Called by rt_host.c's ARC for a value whose low bit is 1 (a table id). */
void
co_table_retain(kp_gptr id)
{
    struct ht_entry *e = ht_lookup(id);

    if (e && e->refcount > 0)
        e->refcount++;
}

void
co_table_release(kp_gptr id)
{
    struct ht_entry *e = ht_lookup(id);
    kp_finalize fin;
    void *obj;

    if (!e || e->refcount == 0)
        return;
    if (--e->refcount > 0)
        return;
    /* Free the slot before running the reclaimer, matching src/handle.c: the
       reclaimer (kp_co_drop) may run cancel-unwind code that itself touches the
       table, and must not see this id live. */
    fin = e->fin;
    obj = e->obj;
    e->obj = NULL;
    e->fin = NULL;
    e->kind = 0;
    if (fin)
        fin(NULL, obj);
}

/****************************************************************
 * Low-memory guarded stacks (lowmem.h, identity addressing)
 ****************************************************************/

struct kp_arena *
kp_vm_arena(kp_vm *vm)
{
    (void)vm;
    return NULL;                 /* the shim ignores the arena handle */
}

uintptr_t kp_arena_base(struct kp_arena *a) { (void)a; return 0; }
void *kp_arena_ptr(struct kp_arena *a, kp_gptr addr) { (void)a; return (void *)(uintptr_t)addr; }
kp_gptr kp_arena_addr(struct kp_arena *a, const void *p) { (void)a; return (kp_gptr)(uintptr_t)p; }

/* Map `len` bytes of read/write memory for a coroutine stack (see
   rt_host.c:rt_map_low): a coroutine stack address is a pointer-width guest
   pointer on every target, so the stack can live wherever the kernel places an
   anonymous mapping. */
static void *co_map_low(size_t len)
{
    return mmap(NULL, len, PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
}

/* A reclaimable coroutine stack in the low 2 GB: a PROT_NONE guard page at the
   low end, then `usable` writable bytes.  The base is the guard page, as co.c
   expects (it checks a fault address against [base, base + pagesize)). */
void *
kp_arena_stack(struct kp_arena *a, size_t usable, size_t *map_len)
{
    size_t pg = (size_t)sysconf(_SC_PAGESIZE);
    size_t total = ((usable + pg - 1) / pg) * pg + pg;
    void *p;

    (void)a;
    p = co_map_low(total);
    if (p == MAP_FAILED)
        return NULL;
    if (mprotect(p, pg, PROT_NONE) != 0) {   /* the low-end guard page */
        munmap(p, total);
        return NULL;
    }
    *map_len = total;
    return p;
}

void
kp_arena_stack_free(struct kp_arena *a, void *base, size_t map_len)
{
    (void)a;
    if (base)
        munmap(base, map_len);
}

/****************************************************************
 * Minimal recoverable-trap layer (handle.h)
 ****************************************************************/

static jmp_buf *g_landing;
static const char *g_trap_msg = "";

void
kp_trap_landing(kp_vm *vm, jmp_buf *env)
{
    (void)vm;
    g_landing = env;
}

jmp_buf *
kp_trap_landing_get(kp_vm *vm)
{
    (void)vm;
    return g_landing;
}

const char *
kp_trap_message(kp_vm *vm)
{
    (void)vm;
    return g_trap_msg;
}

void
kp_raise(kp_vm *vm, enum kp_trap_code code, const char *msg)
{
    (void)vm;
    g_trap_msg = msg;
    if (g_landing)
        longjmp(*g_landing, (int)code);
    fprintf(stderr, "skj-kp-jit: trap: %s\n", msg ? msg : "");
    exit(70);
}

/****************************************************************
 * Guest-facing operators: the front end calls these without a vm.
 ****************************************************************/

kp_gptr kp_co_new_g(void *entry, const void *args, int nargs)
{
    return kp_co_new(NULL, entry, args, nargs);
}
int64_t kp_co_resume_g(kp_gptr co, int64_t value) { return kp_co_resume(NULL, co, value); }
int64_t kp_co_yield_g(int64_t value) { return kp_co_yield(NULL, value); }
kp_gptr kp_co_self_g(void) { return kp_co_self(NULL); }
int kp_co_cancelling_g(void) { return kp_co_cancelling(NULL); }
