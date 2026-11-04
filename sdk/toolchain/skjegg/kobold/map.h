/* map.h : the guest-owned string-keyed associative array (map of T), shared by the hosted VM
   and the freestanding sandbox through rt_glue.h. */

#ifndef KP_MAP_H
#define KP_MAP_H

#include <stdint.h>
#include "rt_glue.h"

/* A map is a guest-heap object: a {refcount, kind} header, then the entry count, the dead-slot
   (tombstone) count, the slot capacity, the value width, the value's handle-field layout, two
   guest addresses (the key-handle table and the value storage), and a modification counter. The
   value the front end holds is the object's guest address. The key table and value storage are
   separate guest-heap blocks that a rehash may move, while the descriptor stays put, so the held
   value is stable. `layout` is the guest address of the value type's handle-field map (a count
   then that many element-relative byte offsets of managed handles), 0 when the value owns none,
   exactly the layout a dynamic array uses. Keys are retained string handles; a slot key of 0 is
   empty and 1 is a tombstone (both impossible for a real string handle, which is an even heap
   address). The map has value (eager-copy) assignment semantics, like a dynamic array. */

/* kp_map_new creates an empty map (refcount 1). kp_map_reserve ensures `key` is present, growing
   or creating the map as needed, and returns an owned reference the caller stores back and whose
   previous value it releases (the kp_arr_setlen discipline); a newly inserted value is zeroed.
   kp_map_get returns the guest address of a key's value slot and traps if the key is absent (the
   read path, used for the write path only after reserve). kp_map_tryget copies a present key's
   value to the guest address `vaddr` (managed fields retained) and returns 1, else 0. kp_map_has
   tests membership. kp_map_del removes a key, returning an owned reference like kp_map_reserve.
   kp_map_len is the entry count. kp_map_clone is an independent copy (value assignment). The slot
   address kp_map_get returns is valid only until the next structural change to the map. */
kp_gptr  kp_map_new(KP_VM_P int32_t elemsize, kp_gptr layout);
kp_gptr  kp_map_reserve(KP_VM_P kp_gptr m, kp_gptr key, int32_t elemsize, kp_gptr layout);
kp_gptr  kp_map_get(KP_VM_P kp_gptr m, kp_gptr key);
int32_t  kp_map_tryget(KP_VM_P kp_gptr m, kp_gptr key, kp_gptr vaddr);
int32_t  kp_map_has(KP_VM_P kp_gptr m, kp_gptr key);
kp_gptr  kp_map_del(KP_VM_P kp_gptr m, kp_gptr key);
int32_t  kp_map_len(KP_VM_P kp_gptr m);
kp_gptr  kp_map_clone(KP_VM_P kp_gptr m);

/* An iterator is a separate guest-heap object that holds the map (retained), the next slot to
   scan, and a snapshot of the map's modification counter. kp_mapiter_new makes one; kp_mapiter_next
   writes the next entry's key (an owned string handle) and value (an owned copy) to the guest
   addresses `kaddr` and `vaddr` and returns 1, or 0 at the end. It traps if the map was structurally
   changed (a key inserted or removed) since the iterator was made; updating an existing key's value
   is allowed. */
kp_gptr  kp_mapiter_new(KP_VM_P kp_gptr m);
int32_t  kp_mapiter_next(KP_VM_P kp_gptr it, kp_gptr kaddr, kp_gptr vaddr);

/* kp_imap_* : the ordinal-keyed sibling (map[K] of T, where K is an integer, int64, char, enum,
   or boolean). The key is passed by value as a 64-bit integer: the front end widens an ordinal
   key to int64 consistently per key type, so equality holds and a key of any ordinal width works
   on every target regardless of pointer width. Keys are plain values, never retained; a slot's
   occupancy lives in a parallel states block (0 empty, 1 tombstone, 2 live), since 0 and 1 are
   valid keys and cannot double as sentinels the way an even string-handle address can. The value
   storage, handle-field layout, value (eager-copy) assignment, clone, and iterator model all match
   kp_map_*. kp_imapiter_next writes the key as an int64 to `kaddr`, which the front end narrows to
   the binder's ordinal width; it is not a handle, so it is not retained. */
kp_gptr  kp_imap_new(KP_VM_P int32_t elemsize, kp_gptr layout);
kp_gptr  kp_imap_reserve(KP_VM_P kp_gptr m, int64_t key, int32_t elemsize, kp_gptr layout);
kp_gptr  kp_imap_get(KP_VM_P kp_gptr m, int64_t key);
int32_t  kp_imap_tryget(KP_VM_P kp_gptr m, int64_t key, kp_gptr vaddr);
int32_t  kp_imap_has(KP_VM_P kp_gptr m, int64_t key);
kp_gptr  kp_imap_del(KP_VM_P kp_gptr m, int64_t key);
int32_t  kp_imap_len(KP_VM_P kp_gptr m);
kp_gptr  kp_imap_clone(KP_VM_P kp_gptr m);
kp_gptr  kp_imapiter_new(KP_VM_P kp_gptr m);
int32_t  kp_imapiter_next(KP_VM_P kp_gptr it, kp_gptr kaddr, kp_gptr vaddr);

#endif /* KP_MAP_H */
