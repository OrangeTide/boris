/* lowmem.h : allocate memory in the low 4 GB of the address space.
 *
 * The front end models every address as 32 bits, so all guest-reachable memory
 * (globals, JITed code, execution and coroutine stacks) must live where a 32-bit
 * value names it. This hides the per-target way of getting such a mapping: x86-64
 * Linux has MAP_32BIT; AArch64 has no such flag, so hints are probed low. */

#ifndef LOWMEM_H
#define LOWMEM_H

#include <stddef.h>
#include <stdint.h>
#include "obj.h"       /* kp_gptr: a guest address is pointer-width (64-bit under LP64) */

/* Map `len` bytes readable/writable (or as `prot` asks) in the low 4 GB.
   Returns the mapping, or NULL on failure. Release with munmap. Used for the
   JIT code cache; guest data goes through the arena below. */
void *kp_map_low(size_t len, int prot);

/* A guest-address arena: the region a guest's 32-bit pointers name. All guest
   data lives in one contiguous reservation the arena bumps regions from. On the
   identity targets (x86-64, rv32) the guest data base is 0, so a guest pointer is
   its real low address; on base-relative aarch64 the base is the reservation
   start and a guest pointer is an offset into it. The callers below are the same
   either way. */
struct kp_arena;
struct kp_arena *kp_arena_new(void);
void kp_arena_free(struct kp_arena *a);

/* The guest data base: 0 under the identity model, the reservation start under
   base-relative. A guest pointer's real address is this plus the pointer. */
uintptr_t kp_arena_base(struct kp_arena *a);

/* Translate between a guest address and its real host address: kp_arena_ptr maps
   a 32-bit guest pointer to base + addr, and kp_arena_addr maps a real pointer
   back to its 32-bit guest offset. Under the identity model (base 0) both are the
   plain cast. The caller checks for nil (0); these do not special-case it. */
void    *kp_arena_ptr(struct kp_arena *a, kp_gptr addr);
kp_gptr  kp_arena_addr(struct kp_arena *a, const void *p);

/* True when the guest byte range [addr, addr + len) lies within the arena's
   allocated span, so a host access through it cannot escape guest memory. A
   whole-arena guard the buffer FFI accessors add on top of a per-object length
   check, to catch a descriptor whose base or length was corrupted. */
int kp_arena_contains(struct kp_arena *a, kp_gptr addr, size_t len);

/* A one-shot region (globals, the main execution stack). With low_guard, a
   PROT_NONE guard page is placed below it, for a downward-growing stack. Writes
   the mapped length to *map_len; returns the usable base, or NULL. */
void *kp_arena_region(struct kp_arena *a, size_t usable, int low_guard, size_t *map_len);
void kp_arena_region_free(struct kp_arena *a, void *base, size_t map_len);

/* A reclaimable coroutine stack: a low-guarded region that can be freed and its
   space reused by a later stack. */
void *kp_arena_stack(struct kp_arena *a, size_t usable, size_t *map_len);
void kp_arena_stack_free(struct kp_arena *a, void *base, size_t map_len);

#endif /* LOWMEM_H */
