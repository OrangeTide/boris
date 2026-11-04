/* rt_free.c : the freestanding platform for a Kobold guest with no host OS.

   It is the re-bottoming of rt_host.c for a downstream host (boris and the like)
   whose seam to the guest is only write, read, and exit, with the guest heap
   handed in at entry rather than mapped by the runtime.  The guest-owned object
   runtimes (str_core.c, dynarr.c, map.c) are the same source the hosted JIT
   compiles, built here against rt_glue.h with KP_FREESTANDING; this file supplies
   what that glue needs with no libc: the guest heap, the reference counter and its
   per-kind finalizer registry, the freestanding memory primitives, and the trap.

   The heap is a binned allocator, the same design as rt_host.c, but over a region
   the host hands in through kp_rt_init instead of an mmap of its own.  A guest
   address is a real pointer (flat address space, identity addressing), so a block
   address is the pointer truncated to 32 bits; the host arranges that the region
   sits below 4 GB so that truncation is lossless.

   This source is target-neutral C; it issues no syscall itself.  write and exit,
   which the trap needs, come from the crt (io_free.c / kp_crt_rv.S). */

#include "obj.h"
#include "kp_abi.h"

#include <stdint.h>
#include <stddef.h>

/* The entry-ABI version marker (kp_abi.h).  The crt references kp_guest_abi_v<N>,
   so an archive of one version linked against a crt of another fails to link; the
   plain value is there for a host that prefers to read it. */
#define KP_ABI_CAT2(a, b) a##b
#define KP_ABI_CAT(a, b) KP_ABI_CAT2(a, b)
const uint32_t KP_ABI_CAT(kp_guest_abi_v, KP_GUEST_ABI_VERSION) = KP_GUEST_ABI_VERSION;
const uint32_t kp_guest_abi_version = KP_GUEST_ABI_VERSION;

/* write and _exit reach the host over the unified syscall seam (the same
   POSIX-named wrappers the C libc links; runtime/io_free_*.S here). */
int write(int fd, const void *buf, int len);
void _exit(int code) __attribute__((noreturn));

/* Ask the host for a symbolized backtrace before a fatal exit.  The crt
   provides it: the skj-run RV_SYS_FATAL ecall on RISC-V, a no-op elsewhere
   (and a no-op off skj-run, where the ecall is -ENOSYS), so trap_die then falls
   through to its own _exit. */
void __skj_trap_backtrace(int code);

/****************************************************************
 * Freestanding memory primitives (the glue's memcpy/memset/rt_memcmp)
 ****************************************************************/

void *
memcpy(void *dst, const void *src, size_t n)
{
    uint8_t *d = dst;
    const uint8_t *s = src;

    while (n--)
        *d++ = *s++;
    return dst;
}

void *
memset(void *dst, int c, size_t n)
{
    uint8_t *d = dst;

    while (n--)
        *d++ = (uint8_t)c;
    return dst;
}

void *
memmove(void *dst, const void *src, size_t n)
{
    uint8_t *d = dst;
    const uint8_t *s = src;

    /* Overlap-safe: copy back to front when the destination is above the source,
       so an overlapping move (a dynamic-array Delete or Insert) is correct. */
    if (d <= s) {
        while (n--)
            *d++ = *s++;
    } else {
        d += n;
        s += n;
        while (n--)
            *--d = *--s;
    }
    return dst;
}

int
rt_memcmp(const void *a, const void *b, size_t n)
{
    const uint8_t *x = a, *y = b;

    while (n--) {
        if (*x != *y)
            return *x < *y ? -1 : 1;
        x++, y++;
    }
    return 0;
}

/* The standard-named string primitives the shared fs/ layer uses (memcmp,
   strcmp, strlen, strncpy).  The freestanding tier has no libc string.c, so
   they live here next to memcpy/memset. */
int
memcmp(const void *a, const void *b, size_t n)
{
    return rt_memcmp(a, b, n);
}

size_t
strlen(const char *s)
{
    const char *p = s;
    while (*p)
        p++;
    return (size_t)(p - s);
}

int
strcmp(const char *a, const char *b)
{
    while (*a && *a == *b)
        a++, b++;
    return (unsigned char)*a - (unsigned char)*b;
}

char *
strncpy(char *dst, const char *src, size_t n)
{
    size_t i = 0;
    for (; i < n && src[i]; i++)
        dst[i] = src[i];
    for (; i < n; i++)
        dst[i] = 0;
    return dst;
}

/****************************************************************
 * Traps
 *
 * Every runtime fault on this tier is fatal: the trap writes a one-line
 * diagnostic to standard error and exits 70, the convention the hosted AOT crt
 * uses.  There is no recovery and no landing pad.
 ****************************************************************/

static void
trap_die(const char *msg)
{
    const char *p = msg;
    long n = 0;

    while (p[n])
        n++;
    write(2, msg, n);
    write(2, "\n", 1);
    __skj_trap_backtrace(70);           /* under skj-run: a symbolized stack */
    _exit(70);
}

/* The index/key/concurrent-modification trap the shared string and map cores
   raise through rt_glue.h's RT_TRAP_*.  KP_TRAP_INDEX is their only kind. */
void
rt_trap(uint32_t kind)
{
    (void)kind;
    trap_die("skj-kp: runtime fault: index out of bounds");
}

/* The guarded-arithmetic traps the backend emits (backend/rv_select.c). */
void kp_trap_div_zero(void) { trap_die("skj-kp: runtime fault: divide by zero"); }
void kp_trap_overflow(void) { trap_die("skj-kp: runtime fault: integer overflow"); }
void kp_trap_index(void)    { trap_die("skj-kp: runtime fault: array index out of bounds"); }

/* The language fatals: abort() ends the program, assert(cond) ends it unless
   cond holds.  Both route through trap_die, so under skj-run they print the
   same symbolized backtrace the arithmetic and index traps do. */
void kp_abort(void) { trap_die("skj-kp: aborted"); }
void kp_assert(uint32_t cond) { if (!cond) trap_die("skj-kp: assertion failed"); }

/****************************************************************
 * Guest heap: the shared coalescing allocator over the program break
 *
 * The allocator itself is gheap_core.h, shared with the hosted platform layer
 * (rt_host.c); only the memory source differs here.  This tier grows the Linux
 * program break (the brk syscall, the same seam libc's malloc uses), so the
 * heap grows on demand within the host's task arena rather than from a fixed
 * reservation.  The host moves one break for the guest; it need not hand in a
 * region (boris A3).
 ****************************************************************/

/* The core's memory source is __libc_sbrk (libc/sbrk.c): the one brk-bump both
   runtimes grow their heap through, over the shared __sys_brk seam.  It queries
   the break lazily, guards address wrap, and returns the old break or (void *)-1
   when the host cannot satisfy the request, which is exactly gheap's GH_SBRK
   contract.  The freestanding skj-cc defines __skj_ilp32__, so sbrk.c takes its
   brk path (not the LP64 fixed-region path); this tier is rv/cf only. */
extern void *__libc_sbrk(long incr);

/* Install the guest heap.  The break is the memory source now, so a host no
   longer hands in a region; this is retained as a no-op for hosts still calling
   it during migration (the arguments are ignored). */
void
kp_rt_init(uint32_t base, uint32_t size)
{
    (void)base;
    (void)size;
}

#define GH_SBRK(incr) ((uint8_t *)__libc_sbrk((long)(incr)))
#include "gheap_core.h"

/* The guest-address wrappers rt_glue.h declares: convert a native payload
   pointer to and from a 32-bit guest address, and turn exhaustion into a fatal
   trap (the guest has no way to recover). */
kp_gptr
gheap_alloc(uint32_t nbytes)
{
    void *p = gh_alloc(nbytes);

    if (p == NULL && nbytes != 0)
        rt_trap(0);             /* heap exhausted (or not installed): fatal */
    return (kp_gptr)(uintptr_t)p;
}

void
gheap_free(kp_gptr addr)
{
    gh_free((void *)(uintptr_t)addr);
}

kp_gptr
gheap_realloc(kp_gptr addr, uint32_t nbytes)
{
    void *p = gh_realloc((void *)(uintptr_t)addr, nbytes);

    if (p == NULL && nbytes != 0)
        rt_trap(0);
    return (kp_gptr)(uintptr_t)p;
}

/* Live guest-heap bytes (allocated, not freed); a guest leak check diffs it. */
uint32_t
kp_gheap_live(void)
{
    return gh_live();
}

/* Standard malloc/free/realloc over the same native heap (gh_*), for shared
   code that expects them (the fs/ ramfs backend's file bytes).  free(NULL) and
   realloc(NULL, n) follow the C contract. */
void *
malloc(size_t n)
{
    return gh_alloc((uint32_t)n);
}

void
free(void *p)
{
    if (p)
        gh_free(p);
}

void *
realloc(void *p, size_t n)
{
    return p ? gh_realloc(p, (uint32_t)n) : gh_alloc((uint32_t)n);
}

/****************************************************************
 * Reference counting and the per-kind finalizer registry
 *
 * Every managed value is a gheap object with a {refcount, kind} header (obj.h);
 * nil is address 0.  A release at zero runs the reclaimer the object's kind
 * registered.  Unlike the hosted VM there is no handle table: a coroutine on this
 * tier is an ordinary gheap object, counted here like any other.
 ****************************************************************/

static void (*g_final[KP_OBJ_NKINDS])(kp_gptr addr);

void
rt_register_final(uint32_t kind, void (*fn)(kp_gptr addr))
{
    if (kind < KP_OBJ_NKINDS)
        g_final[kind] = fn;
}

void
kp_retain(kp_gptr v)
{
    struct kp_obj_hdr *h;

    if (v == 0)
        return;
    h = (struct kp_obj_hdr *)(uintptr_t)v;
    if (h->refcount > 0 && h->refcount != KP_RC_STATIC)
        h->refcount++;
}

void
kp_release(kp_gptr v)
{
    struct kp_obj_hdr *h;
    void (*fin)(kp_gptr);

    if (v == 0)
        return;
    h = (struct kp_obj_hdr *)(uintptr_t)v;
    if (h->refcount == 0 || h->refcount == KP_RC_STATIC)
        return;
    if (--h->refcount > 0)
        return;
    fin = (h->kind < KP_OBJ_NKINDS) ? g_final[h->kind] : NULL;
    if (fin)
        fin(v);
}
