#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

/* A boundary-tag, segregated-fit allocator over the __libc_sbrk seam.

   Reuse is an exact-size bin pop in the common case: free blocks of a given
   total size share a bin, so a request that matches one is served in O(1) with
   no search and no split (the scheme kobold's guest heap uses).  Blocks too
   large for the bins go on one list reused by first fit with a split.  On top
   of that, every block carries a size in both a header and a footer, so free()
   finds its physical neighbours and coalesces with any that are also free,
   which keeps a varied mix of sizes from fragmenting the arena the way a
   bin-only allocator would.

   Layout of one block, all sizes a multiple of ALIGN:

       +--------- header: total size | in-use bit
       |            +---- payload (16-aligned), or the free-list links
       v            v                              footer: total size ---+
       [ size|flag ][ .... usable bytes / fwd,bwd .... ][ size ]         |
       ^                                                                 v
       block                                                      block + size

   The header's low bit is the in-use flag (a size is a multiple of ALIGN, so
   the low bits are spare); free() consults it as a best-effort double-free
   guard.  A free block keeps its forward and backward free-list links at the
   start of the otherwise-unused payload.  The footer lets the next block reach
   back to this one's header during coalescing. */

extern void *__libc_sbrk(long incr);

#define ALIGN   16u
#define IN_USE  1u
#define NBINS   512u            /* bins cover total sizes up to NBINS*ALIGN (8 KiB) */

/* Payload offset: ALIGN so the payload stays 16-aligned.  Footer: one size_t
   at the block's tail.  Smallest block holds the two free-list links. */
#define HDR     ALIGN
#define FOOT    (sizeof(size_t))
#define MINBLK  (((HDR + 2u * sizeof(void *) + FOOT) + (ALIGN - 1u)) \
                 & ~(size_t)(ALIGN - 1u))

#define BSIZE(b)  (*(size_t *)(b) & ~(size_t)(ALIGN - 1u))
#define BUSED(b)  (*(size_t *)(b) & IN_USE)
#define FWD(b)    (*(char **)((char *)(b) + HDR))
#define BWD(b)    (*(char **)((char *)(b) + HDR + sizeof(void *)))

static char  *bins[NBINS];      /* exact-size free lists, indexed by size / ALIGN */
static char  *large;            /* free blocks too big for a bin */
static char  *arena_lo;         /* first block's address, the arena's lower bound */
static char  *brk_end;          /* one past the last block, the arena's upper bound */
static size_t live;             /* bytes in handed-out blocks (incl. overhead) */
static size_t peak;             /* high-water mark of live */

static size_t
round_up(size_t n, size_t a)
{
    return (n + a - 1u) & ~(a - 1u);
}

/* Write a block's header and matching footer. */
static void
set_hdr(char *b, size_t size, unsigned used)
{
    *(size_t *)b = size | (used ? IN_USE : 0u);
    *(size_t *)(b + size - FOOT) = size;
}

static char **
bin_head(size_t size)
{
    size_t idx = size / ALIGN;

    return idx < NBINS ? &bins[idx] : &large;
}

/* Insert a free block at the front of its bin (or the large list). */
static void
push_free(char *b)
{
    char **head = bin_head(BSIZE(b));

    FWD(b) = *head;
    BWD(b) = NULL;
    if (*head)
        BWD(*head) = b;
    *head = b;
}

/* Remove a free block from whichever list holds it. */
static void
unlink_free(char *b)
{
    char **head = bin_head(BSIZE(b));
    char *f = FWD(b);
    char *p = BWD(b);

    if (p)
        FWD(p) = f;
    else
        *head = f;
    if (f)
        BWD(f) = p;
}

/* Find and unlink a free block of at least `need` bytes, or NULL.  An exact-bin
   hit is O(1); otherwise first fit over the large list, then the smallest
   larger bin (which reuse coalesced blocks that climbed into a higher bin). */
static char *
take_fit(size_t need)
{
    size_t idx = need / ALIGN;
    char *b;
    size_t i;

    if (idx < NBINS && bins[idx]) {
        b = bins[idx];
        unlink_free(b);
        return b;
    }
    for (b = large; b; b = FWD(b)) {
        if (BSIZE(b) >= need) {
            unlink_free(b);
            return b;
        }
    }
    if (idx < NBINS) {
        for (i = idx + 1; i < NBINS; i++) {
            if (bins[i]) {
                b = bins[i];
                unlink_free(b);
                return b;
            }
        }
    }
    return NULL;
}

/* Pull `need` bytes (a multiple of ALIGN, at least MINBLK) from the seam as a
   fresh free block, coalescing it with the old top block when that was free.
   Returns 0 when the seam is exhausted. */
static int
grow(size_t need)
{
    char *p, *nb, *prev;
    size_t psz, mis;

    if (arena_lo == NULL) {             /* first use: align the break to ALIGN */
        p = __libc_sbrk(0);
        if (p == (char *)-1)
            return 0;
        mis = (uintptr_t)p & (ALIGN - 1u);
        if (mis && __libc_sbrk((long)(ALIGN - mis)) == (char *)-1)
            return 0;
        arena_lo = brk_end = __libc_sbrk(0);
    }

    p = __libc_sbrk((long)need);
    if (p == (char *)-1)
        return 0;
    brk_end = p + need;
    set_hdr(p, need, 0);
    nb = p;
    if (p > arena_lo) {                 /* contiguous: coalesce with the old top */
        psz = *(size_t *)(p - FOOT);
        prev = p - psz;
        if (!BUSED(prev)) {
            unlink_free(prev);
            nb = prev;
            set_hdr(nb, psz + need, 0);
        }
    }
    push_free(nb);
    return 1;
}

void *
malloc(size_t nbytes)
{
    size_t need, bs;
    char *b, *rem;

    if (nbytes == 0)
        return NULL;
    need = round_up(nbytes + HDR + FOOT, ALIGN);
    if (need < MINBLK)
        need = MINBLK;

    for (;;) {
        b = take_fit(need);
        if (b)
            break;
        if (!grow(need)) {
            errno = ENOMEM;
            return NULL;
        }
    }

    bs = BSIZE(b);
    if (bs - need >= MINBLK) {           /* split, returning the tail to a list */
        rem = b + need;
        set_hdr(rem, bs - need, 0);
        push_free(rem);
        set_hdr(b, need, 1);
    } else {
        set_hdr(b, bs, 1);
    }
    live += BSIZE(b);
    if (live > peak)
        peak = live;
    return b + HDR;
}

void
free(void *ap)
{
    char *b, *next, *prev;
    size_t sz, psz;

    if (ap == NULL)
        return;
    b = (char *)ap - HDR;
    if (!BUSED(b))                       /* already free: ignore the double free */
        return;
    *(size_t *)b &= ~(size_t)IN_USE;     /* mark free now, so a repeat is caught */
    sz = BSIZE(b);
    live -= sz;

    next = b + sz;                       /* coalesce forward */
    if (next < brk_end && !BUSED(next)) {
        unlink_free(next);
        sz += BSIZE(next);
    }
    if (b > arena_lo) {                  /* coalesce backward */
        psz = *(size_t *)(b - FOOT);
        prev = b - psz;
        if (!BUSED(prev)) {
            unlink_free(prev);
            b = prev;
            sz += psz;
        }
    }
    set_hdr(b, sz, 0);
    push_free(b);
}

void *
calloc(size_t n, size_t size)
{
    size_t total = n * size;
    void *p;

    if (n != 0 && total / n != size)     /* multiply overflowed */
        return NULL;
    p = malloc(total);
    if (p != NULL)
        memset(p, 0, total);
    return p;
}

void *
realloc(void *ap, size_t nbytes)
{
    char *b;
    size_t usable;
    void *np;

    if (ap == NULL)
        return malloc(nbytes);
    if (nbytes == 0) {
        free(ap);
        return NULL;
    }
    b = (char *)ap - HDR;
    usable = BSIZE(b) - HDR - FOOT;
    if (usable >= nbytes)
        return ap;                       /* fits in place (same size or shrink) */
    np = malloc(nbytes);
    if (np == NULL)
        return NULL;
    memcpy(np, ap, usable);
    free(ap);
    return np;
}

/* Footprint accounting for leak hunting (see doc/tools/libc.md).  `live` is the
   bytes in blocks handed out and not yet freed, including per-block overhead;
   it rises and falls, so a balanced scope returns it to where it started.
   `peak` is the high-water mark since startup. */
size_t
__libc_malloc_live(void)
{
    return live;
}

size_t
__libc_malloc_peak(void)
{
    return peak;
}
