/* rt_host.c : the platform layer that lets the Kobold guest-owned object
   runtimes (str_core.c, later dynarr.c and map.c) run under the Skjegg
   in-process JIT.

   It supplies the freestanding primitives rt_glue.h expects: a guest heap, the
   reference counter, the finalizer registry, and a trap.  The JIT maps guest
   data in the low 2 GB and models a guest address as that real address
   truncated to 32 bits, so here a guest address is a real pointer with its high
   bits zero (identity addressing, RT_PTR(a) == (void *)(uintptr_t)a).  The heap
   therefore lives in a low mapping of its own so every block address fits the
   32 bits the guest uses.

   This mirrors what rt_sandbox.c does for the rv32 sandbox, but over a real
   mmap with libc available, rather than a brk heap with none. */

#define _GNU_SOURCE
#include "obj.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

/****************************************************************
 * The guest heap
 *
 * The allocator itself is gheap_core.h, shared with the freestanding guest
 * platform (rt_free.c); only the memory source differs here.  This tier reserves
 * a 256 MiB region below 4 GB with mmap, committed on demand, so a block address
 * fits the 32-bit guest address model (identity addressing, no vm).  GH_SBRK
 * reserves that region on first use and then bumps a cursor in it.
 ****************************************************************/

#define GHEAP_CAP   ((size_t)256u << 20)        /* 256 MiB reservation, committed on demand */

static uint8_t *g_base;         /* region base (a real low pointer) */
static uint32_t g_cap;          /* region size in bytes */
static uint32_t g_brk;          /* bytes handed out from the region */

static void rt_oom(const char *what)
{
    fprintf(stderr, "skj-kp-jit: runtime: %s\n", what);
    exit(70);
}

/* Map `len` bytes of read/write memory for the guest heap.  A guest address is
   pointer-width on every target (64-bit under LP64, 32-bit on rv32/ColdFire), so
   it names a full host pointer and the heap can live wherever the kernel places
   an anonymous mapping.  A 32-bit host is low by construction; no target needs a
   low-memory constraint.  Mirrors jit/jit_arena.c:kp_map_low. */
static void *rt_map_low(size_t len)
{
    return mmap(NULL, len, PROT_READ | PROT_WRITE,
                MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
}

/* The core's memory source: reserve the low region on first use, then grow the
   break by `incr`, returning the old break or (uint8_t *)-1 if it cannot grow. */
static uint8_t *
gh_sbrk(long incr)
{
    uint8_t *old;

    if (g_base == NULL) {
        void *p = rt_map_low(GHEAP_CAP);
        if (p == MAP_FAILED)
            rt_oom("guest heap mmap failed");
        g_base = p;
        g_cap = (uint32_t)GHEAP_CAP;
        g_brk = 0;
    }
    old = g_base + g_brk;
    if (incr < 0) {
        if ((uint32_t)(-incr) > g_brk)
            return (uint8_t *)-1;
        g_brk -= (uint32_t)(-incr);
    } else {
        if (g_brk + (uint32_t)incr > g_cap || g_brk + (uint32_t)incr < g_brk)
            return (uint8_t *)-1;
        g_brk += (uint32_t)incr;
    }
    return old;
}

#define GH_SBRK(incr) gh_sbrk((long)(incr))
#include "gheap_core.h"

/* The guest-address wrappers rt_glue.h declares: convert a native payload
   pointer to and from a 32-bit guest address, and turn exhaustion into exit 70. */
kp_gptr gheap_alloc(uint32_t nbytes)
{
    void *p = gh_alloc(nbytes);

    if (p == NULL && nbytes != 0)
        rt_oom("guest heap exhausted");
    return (kp_gptr)(uintptr_t)p;
}

void gheap_free(kp_gptr addr)
{
    gh_free((void *)(uintptr_t)addr);
}

kp_gptr gheap_realloc(kp_gptr addr, uint32_t nbytes)
{
    void *p = gh_realloc((void *)(uintptr_t)addr, nbytes);

    if (p == NULL && nbytes != 0)
        rt_oom("guest heap exhausted");
    return (kp_gptr)(uintptr_t)p;
}

/* Live guest-heap bytes (allocated, not freed).  A guest leak check snapshots
   this around a scope and diffs it, so only symmetric alloc/free matters. */
uint32_t kp_gheap_live(void)
{
    return gh_live();
}

/****************************************************************
 * Reference counting and finalizers
 ****************************************************************/

static void (*g_final[KP_OBJ_NKINDS])(kp_gptr addr);

void rt_register_final(uint32_t kind, void (*fn)(kp_gptr addr))
{
    if (kind < KP_OBJ_NKINDS)
        g_final[kind] = fn;
}

/* A managed value is nil (0), a gheap object (low bit 0), or a handle-table id
   (low bit 1).  A gheap object is reference-counted through its header here; a
   table id (currently a coroutine, KP_H_CONT) routes to the handle table in
   co_shim.c.  Host opaque handles will route the same way once ported. */
void co_table_retain(kp_gptr id);
void co_table_release(kp_gptr id);

/* GH_POISON (off by default) is the guest-heap write-after-free instrument;
   gheap_core.h documents the poison/verify half (the GH_WAF report).  This half
   catches a retain or release of an already-freed gheap object and prints a
   backtrace (GH_UAF).  Build with -DGH_POISON, or set it once here, then
   run a hosted tier: `skj-kp-jit prog.pas 2>&1 | grep GH_`.  See
   doc/internals/kobold-heap.md for how to read the output and isolate user
   codegen from the embedded compiler's. */
#ifdef GH_POISON
#include <execinfo.h>
static void gh_uaf(const char *op, kp_gptr v)
{
    void *bt[32];
    int n = backtrace(bt, 32);
    fprintf(stderr, "GH_UAF %s on freed object v=%08llx (refcount=%u)\n",
            op, (unsigned long long)v, ((struct kp_obj_hdr *)(uintptr_t)v)->refcount);
    backtrace_symbols_fd(bt, n, 2);
    fflush(stderr);
}
/* Only a real gheap block can be use-after-freed; a static string lives in the
   module image, outside the region, so bound the check to [g_base, g_base+g_brk)
   to avoid reading a non-gheap address's bytes as a header. */
#define GH_IN_REGION(v) \
    (g_base && (uintptr_t)(v) >= (uintptr_t)g_base \
             && (uintptr_t)(v) < (uintptr_t)g_base + g_brk)
#define GH_UAF_CHECK(op, v) \
    do { if ((v) && !KP_VAL_IS_TABLE(v) && GH_IN_REGION(v) \
             && gh_is_freed((void *)(uintptr_t)(v))) \
             gh_uaf((op), (v)); } while (0)
#else
#define GH_UAF_CHECK(op, v) ((void)0)
#endif

void kp_retain(kp_gptr v)
{
    struct kp_obj_hdr *h;

    if (v == 0)
        return;
    if (KP_VAL_IS_TABLE(v)) {
        co_table_retain(v);
        return;
    }
    GH_UAF_CHECK("retain", v);
    h = (struct kp_obj_hdr *)(uintptr_t)v;
    if (h->refcount > 0 && h->refcount != KP_RC_STATIC)
        h->refcount++;
}

void kp_release(kp_gptr v)
{
    struct kp_obj_hdr *h;
    void (*fin)(kp_gptr);

    if (v == 0)
        return;
    if (KP_VAL_IS_TABLE(v)) {
        co_table_release(v);
        return;
    }
    GH_UAF_CHECK("release", v);
    h = (struct kp_obj_hdr *)(uintptr_t)v;
    if (h->refcount == 0 || h->refcount == KP_RC_STATIC)
        return;
    if (--h->refcount > 0)
        return;
    fin = (h->kind < KP_OBJ_NKINDS) ? g_final[h->kind] : NULL;
    if (fin)
        fin(v);                 /* the reclaimer frees the block and any storage it owns */
}

/****************************************************************
 * Misc primitives rt_glue.h routes through the platform
 ****************************************************************/

int rt_memcmp(const void *a, const void *b, size_t n)
{
    return memcmp(a, b, (size_t)n);
}

void rt_trap(uint32_t kind)
{
    (void)kind;
    rt_oom("runtime trap (index out of bounds)");
}
