/* dynarr.c : the guest-owned dynamic-array object (array of T), shared by the hosted
   VM and the freestanding sandbox through rt_glue.h. */

#include "dynarr.h"
#include "rt_glue.h"

/* A dynamic array is a guest-heap object: a {refcount, kind} header, then the element count,
   the element width, and two guest addresses. The value the front end holds is the object's
   guest address. Only the element storage (`base`, a separate guest-heap block) holds the
   elements guest code addresses inline; the descriptor object stays put across a resize even
   though `base` may move, so the value is stable. `layout` is the guest address of the
   handle-field map (a count then that many byte offsets of managed fields within one
   element), 0 when the element type owns no references. */
struct kp_dynarr {
    uint32_t refcount;
    uint32_t kind;      /* KP_OBJ_ARRAY */
    int32_t  len;       /* element count */
    int32_t  elemsize;  /* element width in bytes */
    kp_gptr  layout;    /* guest address of the handle-field map, 0 when none */
    kp_gptr  base;      /* guest address of the element storage, 0 when len == 0 */
};

/* The array object at a guest address, or NULL for nil. */
static struct kp_dynarr *
arr_ptr(KP_VM_P kp_gptr a)
{
    return a ? (struct kp_dynarr *)RT_PTR(a) : (struct kp_dynarr *)0;
}

/* Read the int32 at word index idx of a guest-address blob (the layout map). The blob is
   an i8 global, so it may be unaligned; copy the bytes out. */
static int32_t
blob_i32(KP_VM_P kp_gptr addr, int32_t idx)
{
    int32_t v;

    memcpy(&v, (char *)RT_PTR(addr) + (unsigned long)idx * 4, sizeof(v));
    return v;
}

/* The real address of element i's storage. */
static void *
elem_ptr(KP_VM_P struct kp_dynarr *d, int32_t i)
{
    return (char *)RT_PTR(d->base) + (unsigned long)i * (unsigned long)d->elemsize;
}

/* Release the handle-field references in elements [lo, hi), per the layout map. The map is
   a count followed by that many byte offsets of handle ids within one element. */
static void
release_elems(KP_VM_P struct kp_dynarr *d, int32_t lo, int32_t hi)
{
    int32_t i, j, nfld;

    if (d->layout == 0)
        return;
    nfld = blob_i32(KP_VM_A d->layout, 0);
    for (i = lo; i < hi; i++) {
        char *e = elem_ptr(KP_VM_A d, i);
        for (j = 0; j < nfld; j++)
            RT_RELEASE(*(kp_gptr *)(e + blob_i32(KP_VM_A d->layout, 1 + j)));
    }
}

/* Retain the handle-field references in elements [lo, hi), per the layout map. Used when a
   shared array is cloned: the copied elements name handles the original still holds too, so
   each new owner takes its own reference. */
static void
retain_elems(KP_VM_P struct kp_dynarr *d, int32_t lo, int32_t hi)
{
    int32_t i, j, nfld;

    if (d->layout == 0)
        return;
    nfld = blob_i32(KP_VM_A d->layout, 0);
    for (i = lo; i < hi; i++) {
        char *e = elem_ptr(KP_VM_A d, i);
        for (j = 0; j < nfld; j++)
            RT_RETAIN(*(kp_gptr *)(e + blob_i32(KP_VM_A d->layout, 1 + j)));
    }
}

/* The KP_OBJ_ARRAY reclaimer, run by kp_release at refcount zero. Release the element
   references first, then return the storage block and the object to the guest heap. */
static void
arr_finalize(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A a);

    release_elems(KP_VM_A d, 0, d->len);
    if (d->base)
        RT_FREE(d->base);
    RT_FREE(a);
}

/* Create an array object at refcount 1 and grow it to len (zero-filled) elements. The
   element storage is a separate guest-heap block, so a later resize can move it while the
   object address the caller holds stays put. */
static kp_gptr
arr_new(KP_VM_P int32_t len, int32_t elemsize, kp_gptr layout)
{
    kp_gptr a;
    struct kp_dynarr *d;

    RT_REGISTER(KP_OBJ_ARRAY, arr_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_dynarr));
    d = arr_ptr(KP_VM_A a);
    d->refcount = 1;
    d->kind = KP_OBJ_ARRAY;
    d->len = 0;
    d->elemsize = elemsize;
    d->layout = layout;
    d->base = 0;
    if (len > 0) {
        d->base = RT_ALLOC((uint32_t)len * (uint32_t)elemsize);
        memset(RT_PTR(d->base), 0, (unsigned long)len * (unsigned long)elemsize);
        d->len = len;
    }
    return a;
}

int32_t
kp_arr_len(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A a);

    return d ? d->len : 0;
}

/* Deep-copy an array so the result is independent of the source: value elements are
   copied bitwise, reference elements are retained (their own copy shares by refcount).
   This is the eager copy a value-array assignment performs for a borrowed source, so a
   later element write to either array cannot be seen through the other. Returns a fresh
   owned id (0 for a nil source). */
kp_gptr
kp_arr_clone(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d, *nd;
    kp_gptr id;

    if (a == 0)
        return 0;
    d = arr_ptr(KP_VM_A a);
    id = arr_new(KP_VM_A d->len, d->elemsize, d->layout);
    nd = arr_ptr(KP_VM_A id);
    if (d->len > 0) {
        memcpy(RT_PTR(nd->base), RT_PTR(d->base),
               (unsigned long)d->len * (unsigned long)d->elemsize);
        retain_elems(KP_VM_A nd, 0, d->len);
    }
    return id;
}

kp_gptr
kp_arr_base(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A a);

    return d ? d->base : 0;
}

/* Resize the storage of array object d to len elements, in place. Only the separate storage
   block reallocs, so the object address (the value every owner holds) stays put. A shrink
   releases the elements that fall off; a grow zero-fills the new tail. */
static void
arr_resize_inplace(KP_VM_P struct kp_dynarr *d, int32_t len)
{
    uint32_t es;
    kp_gptr nbase;

    if (len == d->len)
        return;
    es = (uint32_t)d->elemsize;
    if (len < d->len)
        release_elems(KP_VM_A d, len, d->len);    /* drop the shrunk-away elements */
    nbase = RT_REALLOC(d->base, (uint32_t)len * es);
    if (len > d->len)       /* zero-fill the grown tail */
        memset((char *)RT_PTR(nbase) + (unsigned long)d->len * es, 0,
               (unsigned long)(len - d->len) * es);
    d->base = nbase;
    d->len = len;
}

kp_gptr
kp_arr_setlen(KP_VM_P kp_gptr a, int32_t len, int32_t elemsize, kp_gptr layout)
{
    struct kp_dynarr *d;

    if (len < 0)
        len = 0;
    if (a == 0)
        return arr_new(KP_VM_A len, elemsize, layout);

    d = arr_ptr(KP_VM_A a);
    if (d->refcount > 1) {
        /* shared: clone at the new length so other owners are unaffected, matching an
           FPC dynamic array where SetLength makes a held array unique before it resizes */
        struct kp_dynarr *nd;
        kp_gptr id =arr_new(KP_VM_A len, elemsize, layout);
        int32_t keep = len < d->len ? len : d->len;

        nd = arr_ptr(KP_VM_A id);
        if (keep > 0) {
            memcpy(RT_PTR(nd->base), RT_PTR(d->base),
                   (unsigned long)keep * (unsigned long)d->elemsize);
            retain_elems(KP_VM_A nd, 0, keep);
        }
        return id;
    }
    arr_resize_inplace(KP_VM_A d, len);
    d->refcount++;              /* return an owned reference; the caller releases the old value */
    return a;
}

/* Remove count elements at index from array object d, in place: release the removed handles,
   shift the tail down over the gap, then shrink the storage. The shrink must not release the
   stale tail copies the shift left behind: those name handles that moved down into the kept
   range, whose ownership is now the kept range's, so it reallocs without a second release. */
static void
arr_delete_inplace(KP_VM_P struct kp_dynarr *d, int32_t index, int32_t count)
{
    uint32_t es = (uint32_t)d->elemsize;
    int32_t newlen = d->len - count;

    release_elems(KP_VM_A d, index, index + count);
    if (d->len - index - count > 0)
        memmove(elem_ptr(KP_VM_A d, index), elem_ptr(KP_VM_A d, index + count),
                (unsigned long)(d->len - index - count) * es);
    if (newlen == 0) {
        if (d->base)
            RT_FREE(d->base);
        d->base = 0;
    }
    else
        d->base = RT_REALLOC(d->base, (uint32_t)newlen * es);
    d->len = newlen;
}

/* Open count zero-filled element slots at index in array object d, in place: grow the storage,
   shift the tail up to make the gap, then zero the gap. The shifted elements keep their handles
   (ownership is unchanged by a move), and the gap is reference-free, so no retain or release is
   needed. */
static void
arr_insert_inplace(KP_VM_P struct kp_dynarr *d, int32_t index, int32_t count)
{
    uint32_t es = (uint32_t)d->elemsize;
    int32_t newlen = d->len + count;

    d->base = RT_REALLOC(d->base, (uint32_t)newlen * es);
    if (d->len - index > 0)
        memmove(elem_ptr(KP_VM_A d, index + count), elem_ptr(KP_VM_A d, index),
                (unsigned long)(d->len - index) * es);
    memset(elem_ptr(KP_VM_A d, index), 0, (unsigned long)count * es);
    d->len = newlen;
}

/* Delete count elements at index from array a (0-based), copy-on-write. A shared array is cloned
   first so other owners are unaffected. index and count are clamped to the live range, so a
   count past the end deletes only to the end. Returns an owned reference (a fresh array when
   shared, else the same id retained), the handle-assignment discipline kp_arr_setlen uses: the
   caller stores it back and releases the previous value. */
kp_gptr
kp_arr_delete(KP_VM_P kp_gptr a, int32_t index, int32_t count)
{
    struct kp_dynarr *d;
    int32_t len;

    if (a == 0)
        return 0;
    d = arr_ptr(KP_VM_A a);
    len = d->len;
    if (index < 0)
        index = 0;
    if (index > len)
        index = len;
    if (count < 0)
        count = 0;
    if (count > len - index)
        count = len - index;
    if (count == 0) {
        d->refcount++;          /* nothing to remove: hand back an owned reference unchanged */
        return a;
    }
    if (d->refcount > 1) {
        kp_gptr id =kp_arr_clone(KP_VM_A a);
        arr_delete_inplace(KP_VM_A arr_ptr(KP_VM_A id), index, count);
        return id;              /* the clone is already a fresh owned reference */
    }
    arr_delete_inplace(KP_VM_A d, index, count);
    d->refcount++;
    return a;
}

/* Insert count zero-filled element slots at index into array a (0-based), copy-on-write; the
   caller fills the opened slots with ordinary element assignments. index is clamped to [0, len].
   Inserting into nil builds a fresh zero-filled array of count elements, so elemsize and layout
   describe the element type for that case (and match the array object when a is not nil).
   Returns an owned reference, like kp_arr_delete. */
kp_gptr
kp_arr_insert(KP_VM_P kp_gptr a, int32_t index, int32_t count, int32_t elemsize, kp_gptr layout)
{
    struct kp_dynarr *d;
    int32_t len;

    if (count < 0)
        count = 0;
    if (a == 0)
        return arr_new(KP_VM_A count, elemsize, layout);
    d = arr_ptr(KP_VM_A a);
    len = d->len;
    if (index < 0)
        index = 0;
    if (index > len)
        index = len;
    if (count == 0) {
        d->refcount++;
        return a;
    }
    if (d->refcount > 1) {
        kp_gptr id =kp_arr_clone(KP_VM_A a);
        arr_insert_inplace(KP_VM_A arr_ptr(KP_VM_A id), index, count);
        return id;
    }
    arr_insert_inplace(KP_VM_A d, index, count);
    d->refcount++;
    return a;
}

/* A multidimensional buffer keeps its shape in a small VM-owned blob whose guest address sits
   in the descriptor's `layout` field (0 for a 1D buffer, which needs none). The blob is an
   int32 array: [ndim, dims[0..ndim-1], strides[0..ndim-1]], the strides in bytes. A dense
   buffer's strides are extent-derived (stride of the last axis is the element size); a pitched
   surface overrides the outer stride (the row pitch), which is the whole point of a buffer.
   The extents and strides are host-set: only the host, which places the backing, knows them. */

/* The KP_OBJ_BUFFER reclaimer. A buffer's element backing is host-owned, so unlike an array it
   frees only the descriptor object and, for a multidimensional buffer, its shape blob, never
   `base`: tearing the backing down is the host's job. A buffer element is reference-free data
   (the front end enforces this), so there is nothing to release. */
static void
buf_finalize(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A a);

    if (d->layout)
        RT_FREE(d->layout);
    RT_FREE(a);
}

/* Create a buffer object over a host-owned element region. `base` is the guest address of that
   region, which the host placed and continues to own; `len` is its element count and `elemsize`
   the element width in bytes. The buffer is a reference array (share on assign, alias on write,
   indexed exactly like an array through kp_arr_base/kp_arr_len), but ARC never frees `base`.
   Returns a fresh owned id. The host creates buffers; guest code cannot. */
kp_gptr
kp_buf_new(KP_VM_P kp_gptr base, int32_t len, int32_t elemsize)
{
    kp_gptr a;
    struct kp_dynarr *d;

    if (len < 0)
        len = 0;
    RT_REGISTER(KP_OBJ_BUFFER, buf_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_dynarr));
    d = arr_ptr(KP_VM_A a);
    d->refcount = 1;
    d->kind = KP_OBJ_BUFFER;
    d->len = len;
    d->elemsize = elemsize;
    d->layout = 0;              /* reference-free elements: no managed-field map */
    d->base = base;
    return a;
}

/* Create a multidimensional buffer over a host-owned region. `base` is the region's guest
   address; `ndim` is the dimension count; `dims` are the per-axis extents and `strides` the
   per-axis byte strides (so a pitched 2D surface passes strides {pitch, elemsize}); `elemsize`
   is the element width. The shape is copied into a VM-owned blob the descriptor points at. The
   value the front end holds for element k of axis j is base + sum(index_j * strides[j]); the
   host owns the backing, so ARC frees the descriptor and the blob but never `base`. ndim < 1
   falls back to a 1D buffer. Returns a fresh owned id; the host creates buffers, not the guest. */
kp_gptr
kp_buf_new_nd(KP_VM_P kp_gptr base, int32_t ndim, const int32_t *dims,
              const int32_t *strides, int32_t elemsize)
{
    kp_gptr a, blob;
    struct kp_dynarr *d;
    int32_t i;

    if (ndim < 1)
        return kp_buf_new(KP_VM_A base, 0, elemsize);
    RT_REGISTER(KP_OBJ_BUFFER, buf_finalize);   /* idempotent */
    a = RT_ALLOC((uint32_t)sizeof(struct kp_dynarr));
    blob = RT_ALLOC((uint32_t)(1 + 2 * ndim) * 4u);
    d = arr_ptr(KP_VM_A a);
    d->refcount = 1;
    d->kind = KP_OBJ_BUFFER;
    d->len = dims[0];           /* the outer extent, what kp_arr_len reports */
    d->elemsize = elemsize;
    d->layout = blob;
    d->base = base;
    {
        int32_t *b = (int32_t *)RT_PTR(blob);
        b[0] = ndim;
        for (i = 0; i < ndim; i++) {
            b[1 + i] = dims[i];
            b[1 + ndim + i] = strides[i];
        }
    }
    return a;
}

/* A 2D buffer of `rows` by `cols` elements with a byte row pitch `pitch` (>= cols * elemsize
   when the host pads rows for alignment). The column stride is the element size. This is the
   texture-surface case; kp_buf_new_nd covers the general shape. */
kp_gptr
kp_buf_new_2d(KP_VM_P kp_gptr base, int32_t rows, int32_t cols, int32_t pitch,
              int32_t elemsize)
{
    int32_t dims[2], strides[2];

    dims[0] = rows;    strides[0] = pitch;
    dims[1] = cols;    strides[1] = elemsize;
    return kp_buf_new_nd(KP_VM_A base, 2, dims, strides, elemsize);
}

/* The buffer's dimension count: the shape blob's ndim, or 1 for a 1D buffer (no blob). */
int32_t
kp_buf_ndim(KP_VM_P kp_gptr buf)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A buf);

    if (!d || d->layout == 0)
        return 1;
    return blob_i32(KP_VM_A d->layout, 0);
}

/* The extent of axis k. For a 1D buffer axis 0 is the length; higher axes are 1. */
int32_t
kp_buf_dim(KP_VM_P kp_gptr buf, int32_t k)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A buf);

    if (!d)
        return 0;
    if (d->layout == 0)
        return k == 0 ? d->len : 1;
    return blob_i32(KP_VM_A d->layout, 1 + k);
}

/* The byte stride of axis k. For a 1D buffer axis 0 is the element size; higher axes are 0. */
int32_t
kp_buf_stride(KP_VM_P kp_gptr buf, int32_t k)
{
    struct kp_dynarr *d = arr_ptr(KP_VM_A buf);
    int32_t ndim;

    if (!d)
        return 0;
    if (d->layout == 0)
        return k == 0 ? d->elemsize : 0;
    ndim = blob_i32(KP_VM_A d->layout, 0);
    return blob_i32(KP_VM_A d->layout, 1 + ndim + k);
}

/* The buffer FFI accessors, the checked boundary a host function crosses to reach a buffer's
   bytes. A host that receives a buffer argument (its id, via kp_to_handle) reads or writes it
   by element index through these, never with a raw guest pointer, and every access is bounds
   checked against the buffer's element count. These accept any dynamic-array-shaped object (an
   array, a reference array, or a buffer), so a host may also read or write a guest array passed
   to it; a string or coroutine id is rejected. */

/* The array/buffer descriptor at a valid guest id, or NULL when the id is nil or names a
   different kind of object. Guards the accessors against a misused id. */
static struct kp_dynarr *
arr_or_buf(KP_VM_P kp_gptr a)
{
    struct kp_dynarr *d;

    if (a == 0)
        return (struct kp_dynarr *)0;
    d = arr_ptr(KP_VM_A a);
    if (d->kind != KP_OBJ_ARRAY && d->kind != KP_OBJ_BUFFER)
        return (struct kp_dynarr *)0;
    return d;
}

/* True when [off, off + n) is a valid element range of d and n is non-negative. The sum is
   formed in 64 bits so a large off + n cannot overflow past the length check. */
static int
range_ok(struct kp_dynarr *d, int32_t off, int32_t n)
{
    if (off < 0 || n < 0)
        return 0;
    return (int64_t)off + (int64_t)n <= (int64_t)d->len;
}

/* True when the n-element range at off maps to bytes wholly inside guest memory. This is a
   second guard beyond range_ok's per-object length check: range_ok trusts the descriptor's
   len, while this validates the actual byte span against the whole guest arena, so a
   descriptor whose base or len was corrupted cannot steer a host copy outside guest memory.
   On the sandbox tier RT_CONTAINS is a no-op (the emulator's guard pages are the boundary). */
static int
span_in_guest(KP_VM_P struct kp_dynarr *d, int32_t off, int32_t n)
{
    kp_gptr start = d->base + (kp_gptr)((int64_t)off * (int64_t)d->elemsize);
    unsigned long bytes = (unsigned long)((int64_t)n * (int64_t)d->elemsize);

    return RT_CONTAINS(start, bytes);
}

int32_t
kp_buf_len(KP_VM_P kp_gptr buf)
{
    struct kp_dynarr *d = arr_or_buf(KP_VM_A buf);

    return d ? d->len : -1;
}

int
kp_buf_read(KP_VM_P kp_gptr buf, int32_t off, int32_t n, void *dst)
{
    struct kp_dynarr *d = arr_or_buf(KP_VM_A buf);

    if (!d || !range_ok(d, off, n) || !span_in_guest(KP_VM_A d, off, n))
        return 0;
    if (n > 0)
        memcpy(dst, elem_ptr(KP_VM_A d, off),
               (unsigned long)n * (unsigned long)d->elemsize);
    return 1;
}

int
kp_buf_write(KP_VM_P kp_gptr buf, int32_t off, int32_t n, const void *src)
{
    struct kp_dynarr *d = arr_or_buf(KP_VM_A buf);

    if (!d || !range_ok(d, off, n) || !span_in_guest(KP_VM_A d, off, n))
        return 0;
    if (n > 0)
        memcpy(elem_ptr(KP_VM_A d, off), src,
               (unsigned long)n * (unsigned long)d->elemsize);
    return 1;
}

void *
kp_buf_map(KP_VM_P kp_gptr buf, int32_t off, int32_t n)
{
    struct kp_dynarr *d = arr_or_buf(KP_VM_A buf);

    if (!d || !range_ok(d, off, n) || !span_in_guest(KP_VM_A d, off, n))
        return (void *)0;
    return elem_ptr(KP_VM_A d, off);
}
