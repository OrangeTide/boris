/* handle.h : the VM handle table, id -> object with reference counts */

#ifndef KP_HANDLE_H
#define KP_HANDLE_H

#include <setjmp.h>
#include <stdint.h>
#include "obj.h"       /* kp_gptr: a guest value is pointer-width (8 bytes under LP64) */

#ifndef KP_VM_FWD
#define KP_VM_FWD
typedef struct kp_vm kp_vm;
#endif

/* The kind of object an id names. It fixes who reclaims the id at refcount zero and
   is not visible in the language. */
enum kp_handle_kind {
    KP_H_HOST,      /* a host object, freed by its type's or the default finalizer */
    KP_H_STRING,    /* a VM-owned string */
    KP_H_CONT,      /* a stackful coroutine (process) */
    KP_H_ARRAY,     /* a VM-owned dynamic array (array of T) */
};

/* An object's finalizer, run when its last reference is released. */
typedef void (*kp_finalize)(kp_vm *vm, void *obj);

/* A host function or method entry, called through the value-stack FFI. It reads its
   arguments off the value stack, pushes its results, and returns the result count. */
typedef int (*kp_hostfn)(kp_vm *vm);

kp_vm *kp_vm_new(void);
void   kp_vm_free(kp_vm *vm);

/* The default finalizer for host ids created without a registered type. */
void kp_set_finalize(kp_vm *vm, kp_finalize finalize);

/* Register a plain host function under an import name. A module that imports the name
   resolves to `fn` at link time. Registering a name again replaces its function. */
void kp_register_func(kp_vm *vm, const char *name, kp_hostfn fn);

/* Register a host type: its name, its method table in interface order, and the
   finalizer an id of the type is reclaimed with (NULL falls back to the default).
   Returns a nonzero type id for kp_handle_new_typed and method dispatch. */
kp_gptr kp_register_type(kp_vm *vm, const char *name,
                          const kp_hostfn *methods, int nmethods,
                          kp_finalize finalize);

/* Create a host handle (refcount 1). The plain form binds the VM default finalizer;
   the typed form binds the finalizer registered for `type`. */
kp_gptr kp_handle_new(kp_vm *vm, void *obj);
kp_gptr kp_handle_new_typed(kp_vm *vm, void *obj, kp_gptr type);

/* Intern an object of any kind with an explicit finalizer. The string and coroutine
   runtimes use this to add their KP_H_STRING and KP_H_CONT ids. Returns the id. */
kp_gptr kp_handle_intern(kp_vm *vm, enum kp_handle_kind kind, void *obj,
                          kp_finalize finalize);

/* Retain and release any managed value; nil (0) is a no-op. A value with low bit 1 is
   a host-handle table id (release at zero frees the slot and runs its reclaimer); a
   value with low bit 0 is a guest-owned gheap object, and release at zero runs the
   reclaimer registered for the kind in its header (kp_set_obj_finalizer). */
void kp_retain(kp_vm *vm, kp_gptr id);
void kp_release(kp_vm *vm, kp_gptr id);

/* Register the reclaimer for a guest-owned gheap-object kind (kp_obj_kind). The
   string, dynamic-array, and coroutine runtimes register their own; the reclaimer
   frees the object and any storage it owns. */
void kp_set_obj_finalizer(kp_vm *vm, uint32_t kind,
                          void (*fn)(kp_vm *vm, kp_gptr addr));

/* The number of handle-table slots still live (refcount >= 1): coroutines, strings,
   dynamic arrays, and host objects. A guest leak check snapshots this around a scope
   and compares before and after. */
uint32_t kp_live_handle_count(kp_vm *vm);

/* The host-facing accessor: the object a host id names, or NULL for nil, a freed id,
   or a non-host id. The VM's own runtimes use kp_handle_ptr with the expected kind,
   which also rejects a mismatched kind. */
void *kp_obj(kp_vm *vm, kp_gptr id);
void *kp_handle_ptr(kp_vm *vm, kp_gptr id, enum kp_handle_kind kind);

/* The value-stack FFI. A host entry reads its arguments by index (0..kp_argc-1) and
   pushes its results. Cells carry no tags; the type of each is fixed by the routine's
   declared signature. A handle or string is its u32 id, a real its bit pattern. */
int      kp_argc(kp_vm *vm);
int32_t  kp_to_i32(kp_vm *vm, int i);
int64_t  kp_to_i64(kp_vm *vm, int i);
double   kp_to_f64(kp_vm *vm, int i);
kp_gptr kp_to_handle(kp_vm *vm, int i);   /* a handle or string id */
void    *kp_to_obj(kp_vm *vm, int i);      /* id -> registered host object, or NULL */
void kp_push_i32(kp_vm *vm, int32_t v);
void kp_push_i64(kp_vm *vm, int64_t v);
void kp_push_f64(kp_vm *vm, double v);
void kp_push_handle(kp_vm *vm, kp_gptr id);

/* Runtime-internal: pop and return the top result cell, used by the guest-to-host
   thunk to take the host's single result after kp_call_host. */
int64_t kp_take_i64(kp_vm *vm);
double  kp_take_f64(kp_vm *vm);

/* Runtime-internal: snapshot and restore the value-stack top and frame base, so kp_call
   can rebalance the stack if a trap unwinds out of a guest entry. */
void kp_vstack_save(kp_vm *vm, uint32_t *vtop, uint32_t *vbase);
void kp_vstack_restore(kp_vm *vm, uint32_t vtop, uint32_t vbase);

/* Runtime-internal, not host-facing: the call/dispatch path sets up a host-call frame
   around the pushed arguments. kp_frame_enter marks the top `nargs` cells as the frame
   and returns the previous base; kp_frame_leave collapses the host's `nret` results over
   the arguments and restores that base. */
uint32_t kp_frame_enter(kp_vm *vm, int nargs);
void     kp_frame_leave(kp_vm *vm, uint32_t prev_base, int nret);

/* Runtime-internal: resolve an import name to its registered function (kp_link uses
   this), and the guest-side bridge that invokes a host function over a value-stack
   frame. The caller pushes the arguments; kp_call_host returns the result count with
   the results left on the stack. */
kp_hostfn kp_find_func(kp_vm *vm, const char *name);
int       kp_call_host(kp_vm *vm, kp_hostfn fn, int nargs);

/* Runtime-internal: the id of a registered type by name, or 0 if none (kp_link uses
   this to check a module's type imports resolve). */
kp_gptr   kp_find_type(kp_vm *vm, const char *name);

/* Runtime-internal: dispatch to a method resolved at link time (patched slots). kp_link
   binds a call site whose static receiver type is known directly to that type's method for
   the slot, so this validates only the receiver and calls fn; a nil or invalid receiver
   still traps NIL_DISPATCH. kp_type_method resolves a type's slot to its method. */
int       kp_dispatch_to(kp_vm *vm, kp_hostfn fn, int nargs);
kp_hostfn kp_type_method(kp_vm *vm, kp_gptr type, int slot);

/* Traps: a recoverable fatal error the VM raises, distinct from an ordinary result.
   For now a bad coroutine resume and a yield outside any coroutine, joined by the
   {$R+} range and overflow checks. The host guards a region with a landing pad
   and the runtime jumps back to it; with no pad installed a trap prints and aborts. */
enum kp_trap_code {
    KP_TRAP_UNCONSUMED = 1,     /* resumed a running, completed, or unknown coroutine */
    KP_TRAP_NO_COROUTINE = 2,   /* yield with no coroutine current */
    KP_TRAP_OOM = 3,            /* a runtime allocation failed */
    KP_TRAP_NIL_DISPATCH = 4,   /* a method call on a nil or invalid handle */
    KP_TRAP_DIV_ZERO = 5,       /* integer division or modulo by zero */
    KP_TRAP_INDEX_RANGE = 6,    /* array index out of bounds ({$R+}) */
    KP_TRAP_OVERFLOW = 7,       /* checked arithmetic overflow ({$Q+}) */
    KP_TRAP_STACK_OVERFLOW = 8, /* a coroutine ran past its private stack guard page */
    KP_TRAP_USER = 9,          /* a guest program raised its own trap (see kp_panic) */
};

/* Raise the divide-by-zero trap. The JIT emits a guard before each integer division
   that calls this (through a vm-baked thunk) when the divisor is zero, so a malformed
   or well-formed module alike traps rather than faulting the host with SIGFPE. It never
   returns. */
void kp_trap_div_zero(kp_vm *vm);

/* Raise the array-index-out-of-bounds trap. The front end emits a guard before a checked
   array access ({$R+}) that calls this when the index is outside the declared bounds. It
   is a runtime helper the module imports; it never returns. */
void kp_trap_index(kp_vm *vm);

/* Raise the arithmetic-overflow trap. The JIT emits a guard after each checked
   ({$Q+}) add, subtract, or multiply that calls this (through a vm-baked thunk)
   when the signed 32-bit result overflows. It never returns. */
void kp_trap_overflow(kp_vm *vm);

/* Install the landing pad for traps raised from here on, or NULL to clear it. `env`
   is a jmp_buf the host has just set with setjmp, and it must outlive the guarded
   region. The value setjmp returns on a trap is the kp_trap_code. This is the low
   level mechanism; kp_call will own a landing pad at each call boundary once it lands,
   and the reporting hook (kp_set_trap, kp-abi.md) will layer on top of it. */
void kp_trap_landing(kp_vm *vm, jmp_buf *env);

/* The landing pad currently installed, or NULL. A runtime that switches stacks (the
   coroutine runtime) saves this across a switch and restores it, so a trap raised
   inside re-raises to the pad that was in effect outside. */
jmp_buf *kp_trap_landing_get(kp_vm *vm);

/* Raise a trap: record its code and message, then jump to the installed landing pad.
   With none installed, print to stderr and abort. It never returns to its caller. */
void kp_raise(kp_vm *vm, enum kp_trap_code code, const char *msg);

/* The message of the most recent trap, or NULL if none has been raised. */
const char *kp_trap_message(kp_vm *vm);

/* Install the host reporting hook. kp_raise invokes it before it unwinds, with the
   trap kind and the source line, file, and routine name resolved from the module's
   address-to-line table. A module built without -g, or a trap raised from the runtime
   with no guest pc, reports line 0 and NULL file/name. NULL clears the hook. */
void kp_set_trap(kp_vm *vm, void (*trap)(int kind, int line,
                                         const char *file, const char *name));

/* Runtime-internal: the load/link/call layer (load.c) hangs its per-VM state here. */
void  kp_vm_set_loader(kp_vm *vm, void *loader);
void *kp_vm_loader(kp_vm *vm);

/* Runtime-internal: the guest heap (gheap.c) hangs its per-VM state here, with the
   teardown kp_vm_free runs after the handle sweep. The teardown is a function pointer so
   the handle table links without the guest heap (the unit tests). */
void  kp_vm_set_gheap(kp_vm *vm, void *gheap, void (*teardown)(void *gheap));
void *kp_vm_gheap(kp_vm *vm);

struct kp_arena;
struct kp_arena *kp_vm_arena(kp_vm *vm);

/* Install the address-to-line resolver (load.c). kp_raise calls it with the guest
   pc a guard recorded to fill the trap's line, file, and routine for the hook. It
   returns nonzero when the pc falls in a known module. NULL leaves traps unlocated. */
void kp_vm_set_loc_lookup(kp_vm *vm,
                          int (*fn)(void *loader, void *pc, int *line,
                                    const char **file, const char **routine));

#endif /* KP_HANDLE_H */
