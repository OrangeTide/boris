/* dynarr.h : the VM dynamic-array runtime (array of T) */

#ifndef KP_DYNARR_H
#define KP_DYNARR_H

#include <stdint.h>
#include "rt_glue.h"

#ifndef KP_VM_FWD
#define KP_VM_FWD
typedef struct kp_vm kp_vm;
#endif

/* A dynamic array (`array of T`) is a guest-heap object: a {refcount, kind} header, then
   the element count, the element width, and the storage. Its value is the object's guest
   address; 0 is nil, counted as the empty array. The element storage is a separate
   guest-heap block, so guest code addresses an element inline: the code generator takes the
   base with kp_arr_base and the length with kp_arr_len and indexes directly, bounds-checking
   against the length at the index site. The object stays put across a resize even though the
   storage block may move, so the value is stable.

   kp_arr_setlen resizes the storage. `elemsize` is the element width in bytes (any size, so
   a record element works). `layout` is a guest address of a handle-field map, or 0 when an
   element holds no handles: a count (int32) followed by that many int32 byte offsets, the
   position of each refcounted handle id within one element. The runtime releases those
   handles when a shrink drops elements and when the array is reclaimed. `elemsize` and
   `layout` are read only when the array is created from nil.

   It returns an owned reference (fresh from nil, else the same id retained), so the caller
   stores the result and releases the previous value under the ordinary handle-assignment
   discipline. */
int32_t  kp_arr_len(KP_VM_P kp_gptr a);
kp_gptr kp_arr_base(KP_VM_P kp_gptr a);   /* guest address of the storage, 0 if empty */
kp_gptr kp_arr_setlen(KP_VM_P kp_gptr a, int32_t len, int32_t elemsize,
                       kp_gptr layout);
kp_gptr kp_arr_clone(KP_VM_P kp_gptr a);  /* independent deep copy (value assignment) */
/* Delete/Insert edit a `array of T` in place, copy-on-write, returning an owned reference the
   caller stores back (like kp_arr_setlen). Delete removes count elements at index (0-based,
   clamped to the live range) and shifts the tail down. Insert opens count zero-filled slots at
   index and shifts the tail up; elemsize and layout build a fresh array when a is nil. */
kp_gptr kp_arr_delete(KP_VM_P kp_gptr a, int32_t index, int32_t count);
kp_gptr kp_arr_insert(KP_VM_P kp_gptr a, int32_t index, int32_t count,
                       int32_t elemsize, kp_gptr layout);

/* Create a `buffer of T` over a host-owned element region: `base` is the guest address of the
   region the host placed and owns, `len` its element count, `elemsize` the element width. The
   buffer indexes like an array (kp_arr_base/kp_arr_len) and shares on assignment, but ARC frees
   only the descriptor on release, never `base`. The host creates buffers; guest code cannot. */
kp_gptr kp_buf_new(KP_VM_P kp_gptr base, int32_t len, int32_t elemsize);

/* A multidimensional buffer over a host-owned region: one strided region, not nested handles.
   kp_buf_new_nd takes per-axis extents (`dims`) and byte strides (`strides`); element (i0,..)
   is base + sum(ij * strides[j]). kp_buf_new_2d is the texture-surface convenience: `rows` by
   `cols` with byte row `pitch` (>= cols*elemsize when rows are padded) and the element size as
   the column stride. ARC frees the descriptor and its shape blob on release, never the backing.
   kp_buf_ndim/kp_buf_dim/kp_buf_stride report the shape (also the guest's per-axis index path). */
kp_gptr kp_buf_new_nd(KP_VM_P kp_gptr base, int32_t ndim, const int32_t *dims,
                       const int32_t *strides, int32_t elemsize);
kp_gptr kp_buf_new_2d(KP_VM_P kp_gptr base, int32_t rows, int32_t cols, int32_t pitch,
                       int32_t elemsize);
int32_t kp_buf_ndim(KP_VM_P kp_gptr buf);
int32_t kp_buf_dim(KP_VM_P kp_gptr buf, int32_t k);
int32_t kp_buf_stride(KP_VM_P kp_gptr buf, int32_t k);

/* The buffer FFI accessors: the checked boundary a host function crosses to read or write a
   buffer (or any dynamic array) it received as an argument. The host works in element indices,
   never a raw guest pointer, and every access is bounds checked against the object's element
   count. kp_buf_len returns the count (-1 if the id is nil or not an array/buffer). kp_buf_read
   copies n elements [off, off+n) out to dst, kp_buf_write copies n elements from src in; each
   returns 1 on success, 0 when the range is out of bounds or the id is invalid. kp_buf_map is
   the opt-in zero-copy escape hatch: it bounds checks once and returns a direct host pointer to
   the element range, or NULL when out of range. A string or coroutine id is rejected. */
int32_t kp_buf_len(KP_VM_P kp_gptr buf);
int  kp_buf_read(KP_VM_P kp_gptr buf, int32_t off, int32_t n, void *dst);
int  kp_buf_write(KP_VM_P kp_gptr buf, int32_t off, int32_t n, const void *src);
void *kp_buf_map(KP_VM_P kp_gptr buf, int32_t off, int32_t n);

#endif /* KP_DYNARR_H */
