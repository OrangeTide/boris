# Kobold-Pascal Host ABI

This document specifies the binary contract between JIT-compiled Kobold code and the
C host: how values are represented, how the guest calls the host, how handles live
and die, and how a host loads and runs a program. It is the companion to
`kp-module-format.md` (the serialized IR) and `kobold.md` (the architecture).

Kobold compiles to four backends: **x86-64**, **AArch64**, **RISC-V RV32**, and
**ColdFire** (m68k). The ABI is defined for all four. The value representation, the
handle model, the value-stack FFI, the lifetime rules, and the trap model are
identical on every target; only the register-level calling convention differs. This
document describes x86-64 in most detail as the reference, and collects the
per-backend differences under "The guest-internal convention across backends" below.

Much of this follows a runtime model proven earlier in the Skjegg suite:
handles as object-table indices, a length+bytes string, stackful coroutines
on private stacks, and trap descriptors.

## Two calling worlds

There are two distinct call conventions, and keeping them apart is the key to the
whole ABI:

- **Guest-internal calls** (Kobold routine to Kobold routine) use the **native
  calling convention of the target**: the platform psABI on x86-64 (System V),
  AArch64 (AAPCS64), and RISC-V RV32 (ILP32), and the toolkit stack convention on
  ColdFire. On x86-64 that is integer/handle args in `rdi, rsi, …`, `real` in
  `xmm0..7`, results in `rax`/`xmm0`, which is what `regalloc_x86` and the JIT emit.
  The per-target registers are tabulated under "The guest-internal convention across
  backends" below.
- **Guest-to-host calls** (imports and methods) use a **value-stack FFI**, Lua in
  spirit: the guest pushes typed arguments onto a VM value stack, calls a uniform
  host entry, and reads results back off the stack. This is the single mechanism for
  both plain host functions and handle methods.

Runtime helpers the compiler emits (retain/release, string ops, coroutine
spawn/resume/yield/drop) are part of the backend runtime and are called natively, not
through the value stack. Only host-provided code uses the value stack.

### Arguments past the registers, and float-argument staging (x86-64)

This subsection details the x86-64 stack-overflow and float-staging handling. The
equivalent rules for the other backends are summarized under "The guest-internal
convention across backends" below.

The SysV register sequences are six integer/handle registers and eight `xmm`
registers. A call with more integer or float arguments than that passes the
overflow on the stack, in argument order, at increasing addresses from `rsp`;
the caller reserves a 16-byte-aligned area, writes the overflow there, makes the
call, and releases the area afterward. The callee reads a stack argument at
`[rbp + 16 + 8*k]` (return address at `rbp+8`, saved `rbp` at `rbp+0`).

Float register arguments get one extra step. The allocator's float temp homes
are `xmm1..7`, which overlap the `xmm0..7` argument registers, so loading the
arguments one at a time would clobber a source that a later argument still
needs. (Integer arguments never hit this: the integer temp homes `rbx,r12..r15`
are disjoint from the argument registers `rdi..r9`.) The current backend handles
it the simple way: when a call has two or more float register arguments, it
stages them through a small scratch area on the stack (reserved just above
the overflow arguments). Each float source is read into `xmm8` and stored to
that scratch before any `xmm0..7` argument register is written, then the
argument registers are loaded back from the scratch. A single float register
argument, which cannot clobber anything, still loads directly.

This costs a memory round trip on float-heavy calls. The logic lives in
`marshal` in `src/jit_x86.c`.

## The guest-internal convention across backends

A guest-internal call uses the target's native convention. The four backends assign
registers as follows:

| Target   | integer / handle args          | `int64` arg        | `real` arg          | int result | float result   | `int64` result |
|----------|--------------------------------|--------------------|---------------------|------------|----------------|----------------|
| x86-64   | `rdi rsi rdx rcx r8 r9`         | one register       | `xmm0`-`xmm7`       | `rax`      | `xmm0`         | `rax`          |
| AArch64  | `x0`-`x7`                       | one register       | `d0`-`d7`           | `x0`       | `d0`           | `x0`           |
| RV32     | `a0`-`a7`                       | register pair      | integer regs (note) | `a0`       | `a0` / `a0:a1` | `a0:a1`        |
| ColdFire | stack (caller pops)             | two stack words    | stack               | `d0`       | `fp0`          | `d0:d1`        |

**Arguments past the registers.** On the register targets, arguments beyond the
listed registers go on the stack in source order, lowest address leftmost, in a
caller-reserved, suitably aligned block the caller releases after the call. ColdFire
passes every argument on the stack, right to left, 32 bits each. In all cases the
caller pops.

**`int64`.** On x86-64 and AArch64 an `int64` is one native register. On RV32 it is
a pair of the next two argument registers, low word first, with no even-register
alignment, splitting low-in-register and high-on-stack when only one register
remains; the result is `a0:a1`. On ColdFire it is two stack words, the high word at
the lower address; the result is `d0:d1`.

**`real`.** x86-64 and AArch64 pass and return a `real` in a float register. RV32
does **not** use its float argument registers on this path: a `real` (f64) is moved
through a memory stage slot into the integer argument pair, and returned the same way
through `a0:a1`, because RV32 cannot move the halves of an f-register to integer
registers directly; a `single` rides one integer register (its bits moved with
`fmv.x.w`), and a `single` result comes back in `a0`. ColdFire passes a `real` on
the stack (`fmove.d`) and returns it in `fp0`.

**Aggregates.** A record, fixed array, or large set is passed **by reference**: the
caller passes its address as an ordinary integer argument. It is returned through a
hidden, caller-allocated buffer whose address is passed as the **trailing** ordinary
integer argument. This is the same mechanism on every target. Kobold does not use the
platform's by-value struct classification (the System V eightbyte rules or the
AArch64 homogeneous-aggregate rules) even where the C compiler for the same target
does; in particular AArch64 passes the sret pointer as an ordinary `x`-register
argument, never in `x8`. A failable routine with a wide result (a `real`, an
`int64`, or a record) returns the value through this same buffer, with the error in
the integer return register (see "Declaring failability" in `kp-errors.md`).

**The failable register pair.** An integer-class failable result returns the value
and the error signal in two registers: `rax`/`rdx` (x86-64), `x0`/`x1` (AArch64),
`a0`/`a1` (RV32), `d0`/`d1` (ColdFire). The error is a plain register value the
caller branches on, never a condition flag. The full rule, including the wide-result
path above, is in `kp-errors.md`, "The ABI across backends".

**Float-argument staging** is an x86-64 concern only. Its float temp homes
(`xmm1`-`xmm7`) overlap the `xmm0`-`xmm7` argument registers, so a call with two or
more float register arguments stages them through scratch, as described above.
AArch64's argument registers (`x0`-`x7`, `d0`-`d7`) are disjoint from its
callee-saved temp homes (`x19`-`x28`, `d8`-`d15`), so float arguments move in place;
RV32 and ColdFire carry floats through integer registers or the stack, so neither
stages.

## Value representation

Every Kobold value has a fixed machine width. There are no runtime type tags.

| Kobold type                              | Width / representation          |
|------------------------------------------|---------------------------------|
| `integer`, `boolean`, `char`, enum, subrange | 32-bit (`i32`)              |
| `longint`                                | 64-bit (`i64`)                  |
| `real`                                   | 64-bit IEEE 754 (`f64`)         |
| handle (any interface type, `string`)    | 32-bit id (`u32`), `0` = `nil`  |
| `process`                                | 32-bit id (`u32`)               |
| small `set` (≤ 64 elements)              | a 64-bit word (`i64`)           |
| large `set`, `array`, `record`           | address of the value (by ref)   |

`boolean` is 0/1; `char` is a byte in a 32-bit word. Structured values (arrays,
records, large sets) are passed and returned by reference. By-value structured FFI
is deferred until the language needs it.

A handle and a pointer follow the target's data model: 32-bit on RV32 and ColdFire
(ILP32), 64-bit on x86-64 and AArch64 (LP64). On the 64-bit targets a handle or address
is a full 64-bit value and the JIT and AOT runtimes use the whole address space. A
module records its width class on the `.target` line (`ilp32`/`lp64`), and the backend
rejects a module whose width does not match.

## The value-stack FFI

Each VM has a **value stack**: an array of raw 64-bit cells with a top pointer.
Because Kobold is statically typed, cells carry **no tags**; the guest and host agree
on each argument's type from the routine's declared signature. Handles and strings ride
the stack as their `u32` ids.

A host function or method has one uniform signature:

```c
typedef int (*kp_hostfn)(kp_vm *vm);   /* read args, push results, return result count */
```

At a host-call site the JIT emits: push each argument, call the resolved entry, then
read results off the stack (0 or 1 for now). A host entry reads its arguments by
index and pushes its result:

```c
int argc  = kp_argc(vm);
int32_t  kp_to_i32(kp_vm *vm, int i);
int64_t  kp_to_i64(kp_vm *vm, int i);
double   kp_to_f64(kp_vm *vm, int i);
uint32_t kp_to_handle(kp_vm *vm, int i);   /* a handle or string id */
void    *kp_to_obj(kp_vm *vm, int i);      /* id -> registered object, or NULL */

void kp_push_i32(kp_vm *vm, int32_t v);
void kp_push_i64(kp_vm *vm, int64_t v);
void kp_push_f64(kp_vm *vm, double v);
void kp_push_handle(kp_vm *vm, uint32_t id);
```

Example. For `procedure printInt(n: integer); external;` and a method
`move(dx, dy: integer)` on `Entity`:

```c
int printInt(kp_vm *vm) {              /* named import */
    printf("%d\n", kp_to_i32(vm, 0));
    return 0;                          /* no result */
}

int Entity_move(kp_vm *vm) {           /* method slot: receiver is arg 0 */
    Entity *self = kp_to_obj(vm, 0);
    self->x += kp_to_i32(vm, 1);
    self->y += kp_to_i32(vm, 2);
    return 0;
}
```

The same stack carries arguments and results the other way too: to call an exported
entry, the host pushes arguments and reads results back off the stack (see
[VM and modules](#vm-and-modules)).

### Buffer arguments

A `buffer of T` argument arrives as an id, read with `kp_to_handle`, like any handle. The
host reaches its bytes through the checked buffer accessors, never a raw guest pointer: it
works in element indices, and each access is bounds checked twice. The first check is against
the buffer's element count. The second validates the access's real byte span against the whole
guest arena, so a descriptor whose base or length was corrupted cannot steer a copy outside
guest memory. The same accessors read or write any dynamic `array of T` the host is handed; a
string or coroutine id is rejected.

```c
int32_t kp_buf_len(kp_vm *vm, uint32_t buf);   /* element count, -1 if not an array/buffer */
int  kp_buf_read (kp_vm *vm, uint32_t buf, int32_t off, int32_t n, void *dst);
int  kp_buf_write(kp_vm *vm, uint32_t buf, int32_t off, int32_t n, const void *src);
void *kp_buf_map (kp_vm *vm, uint32_t buf, int32_t off, int32_t n);   /* zero-copy, or NULL */
```

`kp_buf_read` copies `n` elements `[off, off+n)` out to `dst`; `kp_buf_write` copies `n`
elements from `src` in; each returns 1 on success, 0 when the range is out of bounds or the
id is invalid. `kp_buf_map` is the opt-in zero-copy escape hatch: it bounds checks once and
returns a direct host pointer to the element range (or NULL out of range), for a host that
hands the region straight to a real system call.

```c
int blit(kp_vm *vm) {                  /* procedure blit(px: buffer of integer); external */
    uint32_t px = kp_to_handle(vm, 0);
    int32_t  n  = kp_buf_len(vm, px);
    uint32_t *pixels = kp_buf_map(vm, px, 0, n);   /* the whole surface, zero-copy */
    if (pixels) surface_upload(pixels, (size_t)n);
    return 0;
}
```

## Handles

A handle is a **32-bit unsigned id**. The VM keeps an **id → `void *` object table**;
`0` is `nil`. Inside the VM a handle is only ever an id; the host registers the
`void *` an id stands for and resolves ids back to objects across the FFI. The guest
never holds or dereferences a host pointer.

The **object system is owned by the host**. The VM tracks only the id → `void *`
mapping and a reference count per id; a handle's table entry is just the object, with
no per-handle vtable.

Not every id names a host object, though. `string` and `process` are also
handle types (32-bit ids in the same table), and the VM owns those. So each table
entry carries a small **kind** that says who reclaims it when its count reaches zero:

| Kind         | What the id names        | Reclaimed by                        |
|--------------|--------------------------|-------------------------------------|
| `KP_H_HOST`  | a host object (`void *`) | the finalizer for its host type     |
| `KP_H_STRING`| a VM-owned string        | the string runtime (frees the descriptor) |
| `KP_H_CONT`  | a process (stackful coroutine) | the coroutine runtime (frees the private stack) |

The kind is set when the id is created and is not visible in the language; it exists
so `kp_release` routes to the right reclaimer (see [Handle lifetime](#handle-lifetime)).

```c
uint32_t kp_handle_new(kp_vm *vm, void *obj);   /* KP_H_HOST, default finalizer, refcount 1 */
void    *kp_obj(kp_vm *vm, uint32_t id);         /* id -> obj, or NULL for nil (non-host id -> NULL) */
```

`kp_handle_new` tags the entry `KP_H_HOST` and binds it to the finalizer of the type
the object was registered under, falling back to the VM's default finalizer. The
string and coroutine runtimes create their own ids with the matching kind; a host
never asks for those kinds directly.

## Method dispatch

A method call is a **(handle, slot)** pair plus arguments, delivered through the
value-stack FFI: the guest pushes the receiver handle as argument 0, then the other
arguments, and calls the host method for that slot. The receiver reaches the host as
its object via `kp_to_obj(vm, 0)`.

The **slot** comes from the interface declaration (`kp-grammar.md`): the script's
`interface` lists methods in order, which numbers them, and the VM carries that
method-to-slot metadata. The host registers a type's methods as a table of
`kp_hostfn`, in interface order:

```c
static const kp_hostfn entity_methods[] = { Entity_move, Entity_alive };
kp_register_type(vm, "Entity", entity_methods, 2, entity_finalize);
```

The trailing finalizer is the one an `Entity` id is reclaimed with when its count
reaches zero; pass `NULL` to fall back to the VM default (`kp_set_finalize`).

The slot becomes concrete in one of two ways, the second preferred:

- **Host translation.** The VM presents (handle, slot) and the host lines the
  script's numbering up with its own.
- **Patched slots (preferred).** A later compilation or link stage patches the
  concrete slot into the bytecode once the registered layout is known, so a call
  site reaches `entity_methods[slot]` directly with no runtime translation. This is
  what the interface hooks are for.

Because the receiver's static type is known at the call site (Kobold is statically
typed), the JIT binds that type's method table and the patched slot indexes it.
Polymorphism across different concrete host objects behind one interface is handled
inside the host method body. Calling a method on `nil` traps.

The patched-slot form is implemented as follows. A method call lowers to a named call
(`Type.method`) whose first argument is the receiver. Because the static receiver type is
known at the call site, `kp_link` resolves the slot to that type's concrete method at link
time and binds the name to a method thunk that carries the method function as an immediate.
The thunk marshals the receiver and the declared arguments onto the value stack and calls
`kp_dispatch_to`, which validates the receiver (trapping `NIL_DISPATCH` on a nil, freed, or
untyped one) and calls the method directly, with no runtime type-table lookup. A type whose
registration lacks an imported method fails at link, naming the method, rather than trapping
at the call. There is no runtime-typed dispatch primitive: `kp_link` resolves every slot to
its method with `kp_type_method`, and `kp_dispatch_to` is the only dispatch path.

## Handle lifetime

Handles are reference-counted, with the front end emitting the calls and the runtime
holding the count:

```c
void kp_retain(kp_vm *vm, uint32_t id);
void kp_release(kp_vm *vm, uint32_t id);   /* at 0: reclaims by the entry's kind */
void kp_set_finalize(kp_vm *vm, void (*finalize)(void *obj));  /* default for host ids */
```

`kp_retain`/`kp_release` work on any id regardless of kind; the front end emits them
for handles, strings, and processes alike. When a count reaches zero,
`kp_release` reclaims by the entry's kind:

- `KP_H_HOST` calls the object's finalizer: the one registered for its type with
  `kp_register_type`, or the VM default set by `kp_set_finalize` if the type
  registered none. The host frees the object there.
- `KP_H_STRING` frees the string descriptor through the string runtime.
- `KP_H_CONT` frees the coroutine's private stack through the coroutine runtime,
  which first releases the handles its suspended frames hold (see
  [Coroutines](#coroutines)).

A per-type finalizer (passed alongside the method table at `kp_register_type`) is
preferred over the single default, so different host types free differently without
a central switch. The script never frees anything directly.

Ownership discipline the front end compiles to:

- **Locals and fields own** a reference.
- **Parameters are borrowed:** a callee neither retains nor releases a handle
  parameter; the caller's reference covers the call.
- **Returns transfer** ownership: a routine that returns a handle hands the caller a
  reference. A host function that returns a handle (via `kp_handle_new`, refcount 1)
  likewise transfers it.
- **Assignment** `a := b` compiles to `kp_retain(b); kp_release(old_a); a := b`.
- **Scope exit** releases every owning handle local.

`kp_retain` and `kp_release` are runtime helpers, called natively, not through the
value stack.

## Strings

`string` is a handle type. The VM ships a **minimal string runtime**, enough for what
the code generator emits and no more: create a string from a module literal,
concatenate for `+`, and take a length. It is not a full string library; richer
operations are a host or library concern.

```c
uint32_t kp_str_new(kp_vm *vm, const char *bytes, int len);  /* from a literal (u32 id) */
uint32_t kp_str_concat(kp_vm *vm, uint32_t a, uint32_t b);
int32_t  kp_str_len(kp_vm *vm, uint32_t s);
```

A string is stored as a length+bytes descriptor (UTF-8, byte length). These
are runtime helpers, called natively. A host that wants host-owned
strings can expose them as an ordinary handle type instead. Module string literals
are created at load and held for the module's life; `writeln(someString)` is an
overloaded call to the host's registered output routine.

## Coroutines

A `process` is a **32-bit id** (kind `KP_H_CONT`) naming a **stackful
coroutine**: a runtime object with its own heap-allocated private stack, reference
counted like a handle. Suspend and resume are a **context switch** between the
caller's stack and the coroutine's private stack, not a copy of the native stack.
Because the coroutine's frames live at fixed private-stack addresses, it can be
resumed from any caller depth and stored between ticks.

The runtime is a small C-callable helper set plus one per-backend assembly
context-switch routine. The surface operators `start`/`yield`/`bind`/resume
(`kp-grammar.md`) lower to ordinary calls to these, and `release` lowers to the
generic `kp_release`; there are no coroutine-specific IR opcodes:

```c
uint32_t kp_co_new(kp_vm *vm, void *entry, const void *args, int nargs);
                                       /* spawn; returns a coroutine id (refcount 1) */
uint32_t kp_co_self(kp_vm *vm);        /* the running coroutine's id (borrowed) */
int64_t  kp_co_resume(kp_vm *vm, uint32_t co, int64_t value);  /* run to next yield */
int64_t  kp_co_yield(kp_vm *vm, int64_t value);   /* suspend the current coroutine */
int      kp_co_cancelling(kp_vm *vm);             /* nonzero while unwinding on drop */
void     kp_co_drop(kp_vm *vm, void *obj);        /* KP_H_CONT reclaimer, see below */
```

`bind k in E` lowers to `k := kp_co_self()` followed by `kp_co_yield(E)`. The id
`kp_co_self` returns is **borrowed**: it names the coroutine that is already running,
so the coroutine neither retains nor releases it. It is the same stable id the spawner
holds, suitable for handing to a scheduler within `E`.

`start worker(a, b)` lowers to `kp_co_new` with `entry` the address of `worker` and
`args` a pointer to a small caller-stack buffer of `nargs` 8-byte slots holding the
by-value seed arguments in order. The runtime copies them into the new coroutine's
initial frame for `entry`. `nargs` is zero and `args` is null when there are no
arguments. The coroutine is created **suspended**: the body first runs on the first
`kp_co_resume` (see the lazy handle model in `kp-grammar.md`), and that first
resume's `value` is ignored because the entry's parameters were already seeded here.

Semantics:

- A coroutine is **resumed repeatedly**, advancing to each `yield`, so its id is
  stable across resumes rather than replaced on every yield.
- It is **not forkable**: resuming a suspension twice in parallel, or resuming a
  coroutine that is already running or has completed, traps (`UNCONSUMED`).
- It follows the **same lifetime discipline as a handle**: owning locals and fields,
  borrowed parameters, transfer on return, released at scope exit. It also **owns the
  handles its suspended frames hold**.

The `release(p)` operator does not call `kp_co_drop` directly. It lowers to the
generic `kp_release`, which drops the caller's reference. Early abort of a coroutine
you will not resume is simply releasing your reference to it: if another holder can
still resume it, the coroutine survives. When the last reference goes, `kp_release`
runs the `KP_H_CONT` reclaimer `kp_co_drop` (registered as the entry's finalizer, so
it takes the object, not the id), which frees the private stack.

Releasing the handles a suspended frame still owns uses **cancel-by-unwind**: the drop
path resumes the coroutine in a cancel mode that runs the
front end's ordinary scope-exit release code and returns, rather than walking a
per-suspend-point stack map. In cancel mode `kp_co_yield` does not suspend; the front
end tests `kp_co_cancelling` after each yield, and after each call to a routine that can
suspend, and branches to the routine's cleanup label. Both stages are implemented: a
dropped coroutine unwinds each suspended frame, single- or multi-frame, running its
scope-exit releases. The remaining stage-1 residue (runs some code, still leak-free) is a
yielding call in a control-flow condition or a sub-expression, and an indirect call
through a procedure value.

The private stack is never copied or relocated, so no address fixup is ever needed,
and a coroutine may suspend with a host callback frame live on its private stack.

## VM and modules

A VM is **single-threaded**: it is used from one thread at a time and holds no locks.
A host that wants parallelism runs multiple VMs; handles belong to the VM that
created them.

One VM holds the host registrations and the handle table, and a host loads **one or
more modules** into it. Loading and running is a four-step sequence, with an explicit
**link** phase after all modules are loaded and before any call:

```c
kp_vm *vm = kp_new();

/* 1. register what the modules import */
kp_register_func(vm, "printInt", printInt);
kp_register_type(vm, "Entity", entity_methods, 2, entity_finalize);
kp_set_finalize(vm, default_finalize);   /* fallback for types that pass NULL */
kp_set_trap(vm, on_trap);

/* 2. load each module: parse KPM1 and register it (JIT is deferred to link) */
kp_module *a = kp_load(vm, kpm_a, len_a);
kp_module *b = kp_load(vm, kpm_b, len_b);

/* 3. link: resolve imports and cross-module calls, patch method slots */
if (kp_link(vm) != KP_OK) { /* a required import was not registered */ }

/* 4. call exported entries (args and results ride the value stack) */
int rc = kp_call(a, "main");
```

`kp_link` is separate from `kp_load` because slot patching and cross-module symbol
resolution need every module and every registration present first. `kp_load` only
parses and registers a module; `kp_link` resolves its imports and JITs it, so codegen
sees every module and registration. A module names its imports in its table
(`kp-module-format.md`), so `kp_link` reports a missing import rather than crashing at
a call.

A guest-to-host call keeps the JIT's ordinary native register call (the target's
convention from the table above): the compiled code does not carry a `vm` pointer.
Instead `kp_link` binds each import name to a small generated thunk that supplies `vm`
(baked as an immediate). A func import's thunk marshals the register arguments onto
the value stack, calls `kp_call_host`, and takes the result; a helper import's thunk prepends `vm` and tail-jumps to the runtime helper.

A cross-module call (a bare call to a name another module exports) is also a direct
machine call. Because the JIT bakes an absolute callee address that is not known until
that module is compiled, `kp_link` emits a per-export trampoline at a stable address
before any module is JITed, binds the call to it, and patches the trampoline to the real
entry once every module is compiled. The resolution is therefore order-independent, so a
mutual cross-module cycle links. Duplicate export names across modules (for example each
program's own `main`, which the host reaches by module, not by cross-call) bind to the
first module loaded; a cross-call to an ambiguous name is not well-defined.

A host-to-guest call is the mirror of the import thunk. The host pushes the arguments onto
the value stack, and `kp_call` marshals them into the native registers the guest reads
(integer and handle cells into the integer registers, float cells into the float registers,
in declared order, taken from the export's parameter classes, following the target's
convention from the table above) and runs the entry on the module's low-2GB execution stack
through the reusable `kp_call_guest` trampoline. The guest
runs there because it stores addresses of locals in 32-bit slots. The return value is left
on the value stack for the host to take, so a call is: push arguments, `kp_call`, take the
result.

## Faults

A trap is a recoverable fatal error the runtime raises, distinct from an ordinary
result. The mechanism is `setjmp`/`longjmp`: the runtime raises a trap with

```c
void kp_raise(kp_vm *vm, enum kp_trap_code code, const char *msg);
```

which records the code and message and jumps to the installed landing pad, a
`jmp_buf` the enclosing frame set with `setjmp` and handed to the runtime:

```c
void        kp_trap_landing(kp_vm *vm, jmp_buf *env);  /* install, or NULL to clear */
const char *kp_trap_message(kp_vm *vm);                /* the last trap's message */
```

`setjmp` returns the `kp_trap_code` on a trap. With no landing pad installed a trap
prints and aborts. `kp_call` owns a landing pad at its host-to-guest boundary
(`src/load.c`): a trap raised in the guest unwinds back to `kp_call`, which returns the
trap code instead of letting it abort the process. An embedder that raises outside a
`kp_call` (the coroutine tests do) still installs a pad directly.

A trap raised while a coroutine is running would otherwise `longjmp` past the stack
switch that entered it, so the coroutine runtime brackets each resume: it saves the
landing pad in effect outside, and if a trap unwinds out of the coroutine it restores the
running coroutine to its resumer and re-raises to that outer pad. The coroutine's C frames
are abandoned mid-flight, so it is not cancel-unwound; it is marked done, and a later
release just frees its stack. The handles its abandoned frames held cannot be identified
(they lived in register-allocated frames), so they stay live until `kp_vm_free`, which
sweeps the whole table and
runs every remaining finalizer as a teardown backstop. `kp_trap_landing_get` returns the
currently installed pad for runtimes that need to save and restore it across a stack
switch. Dropping a coroutine whose cleanup itself traps is a special case: the cancel path
swallows that trap instead of re-raising it, since it runs from a finalizer where a
propagating trap would escape `kp_release` (leaking the object and, at teardown with no pad
installed, aborting).

The landing pad is a single VM-wide pointer, so it does not model a per-coroutine chain: a
pad installed on a coroutine's own stack and spanning a `yield` would not survive the
suspension, since the resumer frame it chains to is gone by the next resume. The resolution
is an invariant, not machinery: **no landing pad may span a `yield`.** It holds for free
under the current design. Script has no `try`/`except`, so script never installs a pad.
Every script-to-script call (intra-module, cross-module, or indirect) is a direct machine
call: cross-module symbols are resolved at link time by `kp_link`, not routed through
`kp_call`, so no in-guest call installs a per-call pad. `kp_call` is the host-to-guest
entry only, and its pad sits on the host stack, where `co_run` already saves and restores
it around a resume. The one residual is a host method (C on the coroutine's stack via the
value-stack FFI) that re-enters script which then yields across it; the invariant forbids
that. Per-coroutine pad chains become necessary only if a future call form deliberately
installs a pad on the guest side; until then this stays a design constraint, owned by
`kp_call`, not a coroutine-runtime change.

The host-facing reporting hook is layered on this mechanism:

```c
void kp_set_trap(kp_vm *vm, void (*trap)(int kind, int line,
                                         const char *file, const char *name));
```

`kp_raise` invokes it before it jumps, so the handler can log or decide. The source
line, file, and routine name come from a debug-line section: compiled with `-g`, the
front end emits a `.file` directive and a per-statement `LOC` marker, and the JIT turns
them into a per-module table mapping code offset to line (no per-statement runtime cost).
A guard records the guest return address, which `kp_raise` maps through that table. A
trap raised from the runtime with no guest address, or a module built without `-g`,
passes line 0 with file and name NULL.

Trap kinds:

| Kind           | Cause                                          |
|----------------|------------------------------------------------|
| `INDEX_RANGE`  | array index out of bounds (`{$R+}`/safe mode)  |
| `UNCONSUMED`   | resuming a coroutine that is running, completed, or forked |
| `NO_COROUTINE` | `yield` with no coroutine current              |
| `OOM`          | a runtime allocation failed                    |
| `DIV_ZERO`     | integer divide by zero                         |
| `OVERFLOW`     | checked arithmetic overflow                    |
| `NIL_DISPATCH` | a method call on a `nil` handle                |
| `STACK_OVERFLOW` | a coroutine ran past its private stack       |

In the trusted-now model (`kobold.md`) the compiler may omit the bounds and
overflow checks; the structural traps (nil dispatch, unconsumed process, divide
by zero) are cheap and always on. `UNCONSUMED` is live now: `kp_co_resume` raises it through
`kp_raise` when a coroutine is running, completed, forked, or an unknown id.
`NO_COROUTINE` is also live: `kp_co_yield` raises it when no coroutine is
current, so a malformed module cannot take the host process down. Well-formed
front-end output never triggers it, since `yield` in the main program body is a
compile error. `OOM` is live for the coroutine runtime: `kp_co_new` raises it on
a failed allocation, first freeing whatever it had allocated, so an out-of-memory
condition is recoverable at the landing pad rather than a hard abort. `NIL_DISPATCH`
is live: `kp_dispatch_to` raises it for a method call whose receiver is nil, freed,
or untyped, so there is no object to dispatch on (an unbound slot is caught at link,
not the call). `DIV_ZERO`
is live: the JIT emits a guard before every integer division that calls the
`kp_trap_div_zero` helper (through a vm-baked thunk `kp_link` provides) when the
divisor is zero, so a division that would fault the host with `SIGFPE` traps instead,
for any module. `INDEX_RANGE` is live under `{$R+}`: the front end stamps each array
access with the range-check state at its source position and lowers a stamped access to
a per-dimension bounds check that calls the `kp_trap_index` runtime helper on failure;
it is off by default (trusted-now). `OVERFLOW` is live under `{$Q+}`: the front end stamps
each add, subtract, and multiply with the overflow-check state at its source position and
lowers a stamped operation to a checked opcode (`ADDO`, `SUBO`, `MULO`). These are part of
the shared skjegg IR opcode set (specified in `doc/internals/ir.md`). The JIT
runs a checked operation 32-bit and, on the CPU overflow flag, calls the `kp_trap_overflow`
helper through a vm-baked thunk `kp_link` provides; it is off by default (trusted-now).
The `{$Q+}` checks cover 32-bit add, subtract, and multiply only: `int64`
arithmetic and unary negation are never checked. Integer division has one
overflow case, the most negative 32-bit value divided by `-1` (true quotient
2^31, unrepresentable), and that `OVERFLOW` is always checked, independent
of `{$Q+}`, like divide-by-zero: under the guarded policy every backend tests
the operand pair before the signed divide (or its `mod`) and calls
`kp_trap_overflow`, since the hardware behavior is unusable (x86 `#DE`,
qemu-m68k `SIGFPE` on the divide, arm64/rv return the wrapped value). The one
case still unguarded is the `int64` minimum divided by `-1`: it is
target-dependent, faulting the process on one target and yielding an unspecified
value on another, so a program must avoid it. See `kp-evaluation.md`.
`STACK_OVERFLOW` is live and always on: each coroutine's private stack has a `PROT_NONE`
guard page at its low end, and a `SIGSEGV` handler on a `sigaltstack` (installed with the
first coroutine) recognizes a fault inside the running coroutine's guard page and unwinds it
into this trap, so a runaway recursion recovers at the landing pad instead of killing the
host. A fault anywhere else is left to the previous handler, so real bugs still surface.

## Symbols and overloading

Overloading is resolved in the front end, before the IR, so the module already
carries distinct symbols for overloaded routines; internal mangling is a front-end
detail. **Names that cross the FFI are the plain declared names**: an `external`
routine is imported under the name the host registers, an `export` is the source name,
and neither is mangled or overloaded across the boundary.

## Host API summary

```c
/* lifecycle */
kp_vm     *kp_new(void);
void       kp_destroy(kp_vm *vm);
kp_module *kp_load(kp_vm *vm, const void *kpm, size_t len);
int        kp_link(kp_vm *vm);
int        kp_call(kp_module *m, const char *export_name);

/* registration */
void kp_register_func(kp_vm *vm, const char *name, kp_hostfn fn);
void kp_register_type(kp_vm *vm, const char *name,
                      const kp_hostfn *methods, int nmethods,
                      void (*finalize)(void *obj));   /* NULL -> VM default */
void kp_set_finalize(kp_vm *vm, void (*finalize)(void *obj));  /* host-id default */
void kp_set_trap(kp_vm *vm, void (*trap)(int, int, const char *, const char *));

/* handles */
uint32_t kp_handle_new(kp_vm *vm, void *obj);
void    *kp_obj(kp_vm *vm, uint32_t id);

/* value stack (host functions and methods) */
int      kp_argc(kp_vm *vm);
int32_t  kp_to_i32(kp_vm *vm, int i);
int64_t  kp_to_i64(kp_vm *vm, int i);
double   kp_to_f64(kp_vm *vm, int i);
uint32_t kp_to_handle(kp_vm *vm, int i);
void    *kp_to_obj(kp_vm *vm, int i);
void     kp_push_i32(kp_vm *vm, int32_t v);
void     kp_push_i64(kp_vm *vm, int64_t v);
void     kp_push_f64(kp_vm *vm, double v);
void     kp_push_handle(kp_vm *vm, uint32_t id);
```

Compiler-emitted runtime helpers (`kp_retain`, `kp_release`, `kp_str_*`, and the
coroutine helpers `kp_co_new`/`kp_co_resume`/`kp_co_yield`/`kp_co_drop` with their
per-backend context-switch routine) are internal to the backend runtime and are not
part of the host-facing API.
