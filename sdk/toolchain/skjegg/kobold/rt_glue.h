/* rt_glue.h : the thin tier layer that lets the guest-owned object runtimes
   (str_core.c, dynarr.c) compile once for both the hosted JIT VM and the
   freestanding rv32 sandbox.

   The two tiers differ only in how they reach the guest heap and the reference
   counter, not in the object model or the algorithms. The hosted VM threads a
   kp_vm and reaches the heap through the arena; the sandbox has no vm and, being
   freestanding over a flat address space, treats a guest address as a real
   pointer. The core code is written against the primitives below so a single
   source serves both.

   The number formatting and parsing helpers (Str, Val) are NOT shared: the hosted
   build uses libc (snprintf, strtod) and native 64-bit math, while the sandbox
   hand-rolls them with no libc and no libgcc. They stay in str_fmt.c (hosted) and
   rt_sandbox.c (freestanding). */

#ifndef KP_RT_GLUE_H
#define KP_RT_GLUE_H

#include <stdint.h>
#include <stddef.h>
#include "obj.h"

#ifdef KP_FREESTANDING

/* The sandbox platform (rt_sandbox.c) provides these: a brk-backed guest heap over
   a flat address space (a guest address is a real pointer), an ecall trap, a
   reference counter that dispatches a gheap object's teardown by kind, and a
   finalizer registry the runtimes populate. */
/* size_t keeps these consistent with libc across data models: it is unsigned long
   on an LP64 host and unsigned int on an ILP32 one (rv32), where a plain
   `unsigned long` would clash with the C library's own declarations. */
void *memcpy(void *dst, const void *src, size_t n);
void *memmove(void *dst, const void *src, size_t n);
void *memset(void *dst, int c, size_t n);
int   rt_memcmp(const void *a, const void *b, size_t n);

kp_gptr  gheap_alloc(uint32_t nbytes);
void     gheap_free(kp_gptr addr);
kp_gptr  gheap_realloc(kp_gptr addr, uint32_t nbytes);
uint32_t kp_gheap_live(void);          /* live heap bytes, for a guest leak check */
void     kp_retain(kp_gptr v);
void     kp_release(kp_gptr v);
void     rt_register_final(uint32_t kind, void (*fn)(kp_gptr addr));
void     rt_trap(uint32_t kind);

#define KP_TRAP_INDEX      4u        /* the sandbox trap-kind space (see rt_sandbox.c) */

/* Real is f32 on the rv32 sandbox (no D hardware), but the platform can override
   it: the Skjegg JIT host runs this freestanding runtime with f64 reals and
   passes -DKP_REAL=double. */
#ifndef KP_REAL
#define KP_REAL            float
#endif
#define KP_VM_P                      /* no vm parameter */
#define KP_VM_A
#define KP_VM_UNUSED()               /* no vm to mark used */
#define RT_PTR(a)          ((void *)(uintptr_t)(a))
#define RT_ALLOC(n)        gheap_alloc(n)
#define RT_FREE(a)         gheap_free(a)
#define RT_REALLOC(a, n)   gheap_realloc((a), (n))
#define RT_RETAIN(v)       kp_retain(v)
#define RT_RELEASE(v)      kp_release(v)
#define RT_REGISTER(k, fn) rt_register_final((k), (fn))
#define RT_MEMCMP(a, b, n) rt_memcmp((a), (b), (n))
#define RT_TRAP_INDEX()    rt_trap(KP_TRAP_INDEX)
#define RT_TRAP_KEY()      rt_trap(KP_TRAP_INDEX)
#define RT_TRAP_CONCMOD()  rt_trap(KP_TRAP_INDEX)
/* The sandbox has no arena to bound-check against; the emulator's guard pages and
   bus faults are the memory-safety boundary, and these host-FFI accessors are not
   on the sandbox's host path, so the whole-arena guard is a no-op here. */
#define RT_CONTAINS(a, n)  ((void)(a), (void)(n), 1)

#else /* the hosted JIT VM */

#include <string.h>
#include "handle.h"
#include "gheap.h"
#include "lowmem.h"

#define KP_REAL            double    /* Real is f64 on the hosted VM */
#define KP_VM_P            kp_vm *vm,
#define KP_VM_A            vm,
#define KP_VM_UNUSED()     ((void)vm)
#define RT_PTR(a)          kp_arena_ptr(kp_vm_arena(vm), (a))
#define RT_ALLOC(n)        kp_gheap_alloc(vm, (n))
#define RT_FREE(a)         kp_gheap_free(vm, (a))
#define RT_REALLOC(a, n)   kp_gheap_realloc(vm, (a), (n))
#define RT_RETAIN(v)       kp_retain(vm, (v))
#define RT_RELEASE(v)      kp_release(vm, (v))
#define RT_REGISTER(k, fn) kp_set_obj_finalizer(vm, (k), (fn))
#define RT_MEMCMP(a, b, n) memcmp((a), (b), (n))
#define RT_TRAP_INDEX()    kp_raise(vm, KP_TRAP_INDEX_RANGE, "string index out of bounds")
#define RT_TRAP_KEY()      kp_raise(vm, KP_TRAP_INDEX_RANGE, "map key not found")
#define RT_TRAP_CONCMOD()  kp_raise(vm, KP_TRAP_INDEX_RANGE, "map changed during iteration")
#define RT_CONTAINS(a, n)  kp_arena_contains(kp_vm_arena(vm), (a), (n))

#endif

#endif /* KP_RT_GLUE_H */
