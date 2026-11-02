/* gheap_core.h : the Kobold guest heap, one copy of the allocator shared by
   both platform layers (rt_free.c, the freestanding guest; rt_host.c, the
   hosted JIT/AOT driver).  The two differ only in where the heap region comes
   from, so everything but that memory source lives here.

   It is a binned segregated-fit allocator.  A request that matches an
   exact-size bin is an O(1) pop with no split; larger requests take the one
   `large` list by first fit with a split; anything else is a fresh block cut
   from the region.  A freed block files back into its bin (or the large list).

   Deliberately there is no coalescing and no boundary-tag footer, so a block's
   only metadata is its header and the guest payload is never used by the
   allocator, even while the block is free.  That matters because the guest
   object runtime tolerates a stray read or write of a just-freed payload (a
   pattern the header-only layout has always absorbed); a footer or payload
   free-list link would turn such a stray access into heap corruption.  The
   trade-off is that a long run with a varied size mix can fragment, which the
   fixed region bounds anyway.

   Guest addresses are 32-bit (the object model's handles; a block address fits
   the sub-4 GB region both platforms map), so sizes are uint32_t.  The
   allocator works on native block pointers internally and the platform wrappers
   convert a payload to and from the 32-bit guest address.

   The includer defines, before including this file:

     GH_SBRK(incr)  grow the heap region's break by `incr` bytes and return the
                    old break as a uint8_t*, or (uint8_t *)-1 if the region
                    cannot grow that far.

   and gets the static entry points gh_alloc / gh_free / gh_realloc / gh_live.
   The platform wrappers (gheap_alloc and friends) add the guest-address
   conversion and the out-of-memory trap. */

#include <stdint.h>
#include <string.h>

#define GH_ALIGN   16u
#define GH_NBINS   512u         /* bins cover total sizes up to GH_NBINS*ALIGN (8 KiB) */

struct gh_block {
    uint32_t         size;      /* total bytes including this header, a multiple of ALIGN */
    uint32_t         is_free;   /* 1 while on a free list, a double-free guard */
    struct gh_block *next;      /* free-list link when free (kept in the header) */
};

/* Header rounded up to ALIGN so the payload stays 16-aligned; the link is a
   native pointer, so the header is 16 bytes on both the 32-bit guest and the
   64-bit host. */
#define GH_HDR  (((uint32_t)sizeof(struct gh_block) + GH_ALIGN - 1u) & ~(GH_ALIGN - 1u))

static struct gh_block *gh_bins[GH_NBINS];      /* exact-size free lists, indexed by size/ALIGN */
static struct gh_block *gh_large;               /* free blocks too big for a bin */
static uint32_t         gh_live_bytes;          /* bytes in handed-out blocks (incl. overhead) */

static uint32_t
gh_round_up(uint32_t n, uint32_t a)
{
    return (n + a - 1u) & ~(a - 1u);
}

/* File a free block into its bin (or the large list). */
static void
gh_push_free(struct gh_block *b)
{
    uint32_t idx = b->size / GH_ALIGN;

    b->is_free = 1;
    if (idx < GH_NBINS) {
        b->next = gh_bins[idx];
        gh_bins[idx] = b;
    } else {
        b->next = gh_large;
        gh_large = b;
    }
}

static void *
gh_payload(struct gh_block *b)
{
    return (uint8_t *)b + GH_HDR;
}

static struct gh_block *
gh_block_of(void *payload)
{
    return (struct gh_block *)((uint8_t *)payload - GH_HDR);
}

/* Write-after-free detection (GH_POISON, a hosted debug build only).  On free a
   block's payload is filled with a poison byte and its last-seen object kind is
   recorded; when the block is next handed out, the payload is checked to be
   still all poison.  A disturbed byte means the guest wrote the block while it
   was free, which the header-only free-list layout tolerates silently but which
   a coalescing layout would corrupt, so this is how that latent bug is hunted. */
#ifdef GH_POISON
#include <stdio.h>
#define GH_PBYTE  0xDFu
#define GH_PSLOTS 262144u               /* open-addressing table of freed blocks */

static void         *gh_p_ptr[GH_PSLOTS];
static uint32_t      gh_p_kind[GH_PSLOTS];
static unsigned long gh_p_seq[GH_PSLOTS];
static unsigned long gh_p_now;

static unsigned
gh_p_slot(void *p)
{
    return (unsigned)(((uintptr_t)p >> 4) & (GH_PSLOTS - 1u));
}

static void
gh_p_record(struct gh_block *b, uint32_t kind)
{
    unsigned h = gh_p_slot(b), i, j;

    for (i = 0; i < GH_PSLOTS; i++) {
        j = (h + i) & (GH_PSLOTS - 1u);
        if (gh_p_ptr[j] == NULL || gh_p_ptr[j] == b) {
            gh_p_ptr[j] = b;
            gh_p_kind[j] = kind;
            gh_p_seq[j] = ++gh_p_now;
            return;
        }
    }
}

/* True if the block backing `payload` is currently on a free list.  Used by the
   refcount layer to catch a retain/release of an already-freed object. */
static int
gh_is_freed(void *payload)
{
    return gh_block_of(payload)->is_free;
}

static void
gh_poison(struct gh_block *b)
{
    uint8_t *pay = (uint8_t *)b + GH_HDR;
    uint32_t usable = b->size - GH_HDR;

    gh_p_record(b, usable >= 8 ? *(uint32_t *)(pay + 4) : 0);    /* kp_obj_hdr.kind */
    memset(pay, (int)GH_PBYTE, usable);
}

static void
gh_verify(struct gh_block *b, const char *where)
{
    uint8_t *pay = (uint8_t *)b + GH_HDR;
    uint32_t usable = b->size - GH_HDR;
    uint32_t i, k, kind = 0;
    unsigned h = gh_p_slot(b), s;
    unsigned long seq = 0;

    for (i = 0; i < usable; i++) {
        if (pay[i] == GH_PBYTE)
            continue;
        for (s = 0; s < GH_PSLOTS; s++) {       /* recover the freed kind/seq */
            unsigned j = (h + s) & (GH_PSLOTS - 1u);
            if (gh_p_ptr[j] == b) { kind = gh_p_kind[j]; seq = gh_p_seq[j]; break; }
            if (gh_p_ptr[j] == NULL) break;
        }
        fprintf(stderr, "GH_WAF %s block=%p size=%u off=%u byte=0x%02x "
                "freed-kind=%u freed-seq=%lu\n   bytes:",
                where, (void *)b, b->size, i, pay[i], kind, seq);
        for (k = (i >= 8 ? i - 8 : 0); k < usable && k < i + 24; k++)
            fprintf(stderr, " %02x", pay[k]);
        fprintf(stderr, "\n");
        return;                                 /* one report per reused block */
    }
}
#else
#define gh_poison(b)        ((void)0)
#define gh_verify(b, where) ((void)0)
#endif

static void *
gh_alloc(uint32_t nbytes)
{
    struct gh_block *b, *prev, *rem;
    uint32_t need, idx;
    uint8_t *raw;

    if (nbytes == 0)
        return NULL;
    need = gh_round_up(nbytes + GH_HDR, GH_ALIGN);
    idx = need / GH_ALIGN;

    if (idx < GH_NBINS) {
        b = gh_bins[idx];                       /* exact-size bin: O(1) pop */
        if (b) {
            gh_verify(b, "bin");
            gh_bins[idx] = b->next;
            b->is_free = 0;
            b->next = NULL;
            gh_live_bytes += b->size;
            return gh_payload(b);
        }
    } else {
        prev = NULL;                            /* oversize: first fit, split */
        for (b = gh_large; b; prev = b, b = b->next) {
            if (b->size < need)
                continue;
            gh_verify(b, "large");
            if (prev)
                prev->next = b->next;
            else
                gh_large = b->next;
            if (b->size - need >= GH_HDR + GH_ALIGN) {
                rem = (struct gh_block *)((uint8_t *)b + need);
                rem->size = b->size - need;
                b->size = need;
                gh_push_free(rem);
                gh_poison(rem);
            }
            b->is_free = 0;
            b->next = NULL;
            gh_live_bytes += b->size;
            return gh_payload(b);
        }
    }

    raw = GH_SBRK((long)need);                  /* cut a fresh block from the region */
    if (raw == (uint8_t *)-1)
        return NULL;
    b = (struct gh_block *)raw;
    b->size = need;
    b->is_free = 0;
    b->next = NULL;
    gh_live_bytes += need;
    return gh_payload(b);
}

static void
gh_free(void *payload)
{
    struct gh_block *b;

    if (payload == NULL)
        return;
    b = gh_block_of(payload);
    if (b->is_free)                             /* ignore a double free */
        return;
    gh_live_bytes -= b->size;
    gh_push_free(b);
    gh_poison(b);
}

static void *
gh_realloc(void *payload, uint32_t nbytes)
{
    struct gh_block *b;
    uint32_t need, oldpayload, copy;
    void *np;

    if (payload == NULL)
        return gh_alloc(nbytes);
    if (nbytes == 0) {
        gh_free(payload);
        return NULL;
    }
    b = gh_block_of(payload);
    need = gh_round_up(nbytes + GH_HDR, GH_ALIGN);
    if (need <= b->size)
        return payload;                         /* fits in place (same size or shrink) */
    oldpayload = b->size - GH_HDR;
    np = gh_alloc(nbytes);
    if (np == NULL)
        return NULL;
    copy = (oldpayload < nbytes) ? oldpayload : nbytes;
    memcpy(np, payload, copy);
    gh_free(payload);
    return np;
}

static uint32_t
gh_live(void)
{
    return gh_live_bytes;
}
