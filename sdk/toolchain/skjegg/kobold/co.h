/* co.h : stackful coroutine runtime, platform-neutral core */

#ifndef KP_CO_H
#define KP_CO_H

#include <stdint.h>
#include "obj.h"   /* kp_gptr: a coroutine id is a pointer-width guest handle */

/* The coroutine helpers carry a kp_vm pointer for ABI compatibility with the
   calls the front end emits, but the core does not dereference it. */
#ifndef KP_VM_FWD
#define KP_VM_FWD
typedef struct kp_vm kp_vm;
#endif

/* A coroutine entry point. The front end passes the body routine's address plus a
   buffer of nargs by-value seed arguments (each an 8-byte cell); the entry reads
   them as int64 slots and returns its completion value. This is the runtime-side
   convention, bridged to the JIT's routine calling convention by the shim. */
typedef int64_t (*kp_co_entry)(kp_vm *vm, const int64_t *args, int nargs);

/* The operators start / resume / yield / bind / release lower to these. A coroutine
   id is a KP_H_CONT handle id (a small nonzero integer, 0 is "none"): kp_co_new
   interns the coroutine in the VM handle table, and release is an ordinary kp_release
   on that id. kp_co_drop is not called directly by the front end; it is the reclaimer
   the handle table runs at refcount zero, so its signature matches kp_finalize. */
kp_gptr  kp_co_new(kp_vm *vm, void *entry, const void *args, int nargs);
kp_gptr  kp_co_self(kp_vm *vm);
int64_t  kp_co_resume(kp_vm *vm, kp_gptr co, int64_t value);
int64_t  kp_co_yield(kp_vm *vm, int64_t value);
void     kp_co_drop(kp_vm *vm, void *obj);

/* Nonzero while the current coroutine is being torn down (cancel-by-unwind). The front
   end tests it after each yield and branches to the routine's scope-exit release code,
   so dropping a suspended coroutine releases the handles its frames own. */
int      kp_co_cancelling(kp_vm *vm);

/* A saved machine context is just the stack pointer: the callee-saved registers and
   the return address live on the switched-to stack. The switch primitive is the one
   architecture-specific piece, supplied per backend (here x86-64, SysV). */
struct co_ctx {
    void *sp;
};

/* Save the current context into `from` and load `to`, returning (on a later switch
   back) as an ordinary function. Defined in co_switch_<arch>.S. */
void co_switch(struct co_ctx *from, struct co_ctx *to);

#endif /* KP_CO_H */
