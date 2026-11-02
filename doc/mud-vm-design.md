# MUD VM -- RV32 Sandbox Design

::: aside
**Status: EXPERIMENTAL. PRE-FREEZE.** Nothing here is released. There is
no installed base, no distributed binaries, and no ABI stability of any
kind. Every host-call name, register convention, record layout, and
memory-map address in this document is subject to change without notice.
Do not build anything that depends on the current shapes surviving.

This document replaces the earlier ColdFire sandbox design. Boris pivoted
off the Motorola ColdFire V4e emulator and its complicated hypercall,
capability, and multicore-scheduler model. The new sandbox is an RV32
emulator plus a small, flat host-call environment adapted from the smolmoo
MOO server. See `doc/vm-migration-plan.md` for the removal and import work.

**Superseded in part.** Boris has since been re-based onto the skjegg
compiler suite: the runtime now drives skjegg's embedded emulator, the
host-call table is a fixed selector band, guest files reach an in-world 9P
server, and the compile toolchain runs in world as RV32 guests. Read
`doc/vm-skjegg-rebase.md` for the current shape; the runtime and
compilation sections below describe the earlier bespoke interpreter.
:::

## Introduction

This document describes the in-world program sandbox for the boris MUD
server. Objects can have programs attached. A program runs as guest code
inside an RV32 (RISC-V 32-bit) emulator with a private, bounded memory
image. Guest code reaches the host through a single `ecall` trap into a
flat table of host calls. Isolation comes from the emulator boundary
(bounded memory, trap-on-fault), the host process sandbox (seccomp and
Landlock in `src/security/`), and an instruction budget per run, not from
language-level guarantees.

The design has two goals that the earlier ColdFire plan did not meet.

1. **Simplicity.** The previous VM planned a dirfd capability model,
   synchronous send/receive/reply messaging with a system-wide
   reply-handle table, per-domain single-writer tasks, and a multicore
   credit scheduler. That was hard to build and hard to test. This design
   keeps one flat host-call table, cooperative single-threaded scheduling,
   and a mailbox for events. The complexity that the old model spent on
   concurrency is not needed on a single-threaded host.

2. **A proven MUD execution model.** The split between ordinary programs
   and event-driven programs, the object-manipulation calls, and the
   verb dispatch order are adapted from smolmoo, a working RV32-based MOO
   server. Boris designs around the same requirements rather than
   reinventing them.

## Why RV32

- **Tooling.** A mature RISC-V ecosystem, plus first-party toolchains that
  already emit RV32 ELFs. The C toolchain (skjegg) is vendored; the kobold
  (Pascal-family) frontend is planned, not yet vendored. See **Guest
  Language Support**.
- **A shared, self-contained emulator.** The RV32 core (`rv32.c`,
  `rv32.h`) is around 2860 lines, depends only on `<stdint.h>` and
  `<string.h>`, and is identical across the kobold, smolmoo, and skjegg
  projects apart from the license header. Boris vendors one copy and owns
  it.
- **A clean host seam.** The core is bus-agnostic. It calls host function
  pointers for memory reads and writes, an optional access-probe hook, and
  an `ecall` handler. Boris supplies its own memory backend and host-call
  dispatch without touching the core.
- **Preemption without timers.** `rv_run(cpu, count)` runs up to `count`
  instructions and returns a stop reason: the budget was exhausted, the
  machine halted, a trap was taken, or the guest yielded (parked itself;
  see **Execution Model** for how a task yields).
  The host caps each run, so a runaway loop cannot stall the event loop, and
  a faulting or stuck task is reported rather than left to spin. This
  return-a-reason contract is what a future JIT backend returns through as
  well, so the runtime does not change when the interpreter is replaced.
- **Cooperative yield.** A task runs until it parks, halts, faults, or
  exhausts its budget, which makes each task a coroutine and the scheduler a
  switch over the stop reason. The yield boundary is the parked condition,
  not any one instruction: the run primitive returns a yield whenever the
  hart is parked. The canonical guest yield is the `sys_suspend` host-call,
  because yielding is a host interaction (RISC-V has no userspace yield
  instruction), because it carries the wake policy (yield now, sleep for a
  time, or block on an event), and because it works regardless of privilege
  mode. `wfi` also parks the hart, so a bare idle loop yields too, but it is
  the low-level form; the scheduler contract is the parked condition, which
  `sys_suspend` sets after recording its wake policy.
- **ISA.** RV32IMAFC with the Zicsr, Zifencei, Zba, Zbb, Zbs, Zcb, and
  Zcmp extensions. Single-precision float. Machine-mode CSRs. Extensions
  are toggle flags on the CPU struct.

## Terminology

- **program** -- an RV32 ELF plus its object metadata. Inert code. Owned by
  the object store, loaded on demand. Read-only text can be shared across
  tasks.
- **vm state** -- one `rv_cpu` plus its private memory image and bus
  callbacks. One per task.
- **task** -- a running instance of a program. Owns a vm state and its
  host-side bookkeeping (mailbox, session and authority context). The
  scheduler operates on tasks.
- **one-shot program** -- a program that supplies its own `main()`, runs to
  completion, and exits. Fire-and-forget. The traditional program shape.
- **verb program** (agent) -- a program that does not supply `main()`. It
  links the shared event-loop runtime, which owns `main()`, and supplies
  an event handler plus a tick period. Long-lived and resident.

"Script" survives only as informal shorthand for "a program someone wrote
for the MUD."

## Emulator

The core exposes a small, stable seam. Boris drives it and supplies the
memory and host-call implementations.

```
rv_init(cpu, r8, r16, r32, w8, w16, w32, bus_ctx)  /* wire the memory bus */
rv_set_ecall(cpu, fn, ctx)                          /* the host-call seam  */
rv_set_probe(cpu, fn)                               /* access check        */
rv_reset(cpu, entry)                                /* set entry point     */
rv_run(cpu, count, &retired)                        /* batch run -> reason */
rv_step(cpu) / rv_halt(cpu)                         /* single step / stop  */
rv_get_x / rv_set_x / rv_get_pc / rv_set_pc         /* register access     */
rv_get_f / rv_set_f                                 /* float registers     */
rv_trap / rv_set_irq / rv_irq_pending               /* traps / interrupts  */
```

Each task gets its own `rv_cpu` and a private, little-endian memory image.
The image holds the loaded program, a heap above it, a guard region, and a
stack at the top. Register `x2` (sp) starts at the top of the stack.
Out-of-range access raises a trap, which kills the task rather than reading
or writing garbage.

The image does not yet distinguish read, write, and execute per region. A
per-segment protection map, so guest code cannot be modified, is planned
hardening that also unlocks the core's decoded-instruction cache (a pure
speedup that assumes immutable code). See the `vm-code-protection` card.

## Execution Model

Boris is single-threaded today. The sandbox matches that. There is one
cooperative scheduler on the main event loop. It is not the multicore,
work-stealing, credit-charged scheduler of the ColdFire design. That model
was built for a quad-core target and is not needed here. Multicore is a
separate, later concern tracked in the `multithreading` card.

- Each invocation is a task on a run queue.
- The scheduler runs each ready task with one `rv_run(cpu, quantum)` batch
  per tick, capping instructions so no task hogs the loop. It never steps
  instruction by instruction; it acts on the reason the batch returns.
- On that reason: a halted task is reaped (a clean exit or a fatal double
  fault); a task that took a trap is reaped as faulted, since a stray access
  or illegal instruction kills it rather than spinning in a vector it does
  not have; a task that parked yielded and stays runnable, resumed
  once its wake condition is met (immediately for a plain yield, on a timer
  or event for `sys_suspend`); a task that only exhausted its budget stays
  runnable and is run again next tick. Reporting the trap is what lets a
  stuck task be swept up instead of burning cycles unseen; reporting the
  yield is what lets tasks behave as cooperative coroutines.
- A task yields through the `sys_suspend` host-call. This is the canonical
  form: it records whether the task wants to yield now, sleep for a time, or
  block on an event, and it works in any privilege mode. RISC-V has no
  userspace yield instruction, so yielding is a host-call, not an
  instruction. `wfi` parks the hart as well, so a bare idle loop yields too,
  but it is the low-level form and carries no wake policy. The scheduler acts
  on the parked condition itself, not on which of the two produced it.
- I/O is cooperative. Guest writes buffer host-side and flush to the
  player between steps. There is no blocking read; input reaches a program
  only as pre-parsed arguments or as mailbox events.

## Program vs Verb: One Runtime, One Table

The central design point, adapted from smolmoo, is that the difference
between an ordinary program and an event-driven verb program is **not a VM
feature**. It is a link-time choice of who supplies `main()`.

- Every program shares one C runtime start (`_start`), which is always the
  ELF entry point and always calls `main()`, then exits with its return
  value.
- A **one-shot program** defines its own `main()`. It runs, returns, and
  the task is reaped. This is the traditional program with a main
  procedure.
- A **command verb** also defines its own `main()`, but links the command
  runtime (`sdk/vm/cmd_crt.S` + `cmd_rt.c`) in place of the plain start.
  That start stashes the host's typed argument slots and exposes them through
  `cmd_arg_obj`/`cmd_arg_str` accessors (a type-checked, `va_arg`-style pull
  that matches the verb's argument spec), then calls `main()` and exits. It is
  the one-shot kind specialized for the verb entry ABI.
- An **agent** does not define `main()`. It links the shared event-loop
  runtime (`sdk/vm/verb_rt.c`), whose `main()` registers the task as its
  object's handler, then loops: drain the mailbox and call the program's event
  handler on each message; when the mailbox is empty for the dwell period,
  synthesize a timer event. The program supplies only the event handler and
  the dwell period.

All three use the same flat host-call table. The event-driven half rides
on exactly two extra calls (`sys_listen` to register, `sys_getmsg` to drain
the mailbox) plus reuse of `sys_suspend` for the tick. Everything else,
object access, movement, and authority, is shared identically. (The agent
runtime is named `verb_rt`, which predates the command-verb work; the two are
distinct runtimes despite the overlapping terminology.)

This is the design worth keeping: one flat host-call table, and
"event-driven" expressed purely as a runtime library that owns the loop.

## Host-Call ABI

Guest code reaches the host with the RISC-V `ecall` instruction. The
convention is the standard ILP32 one:

- Selector: register `a7` (`x17`).
- Integer and pointer arguments: `a0`-`a5` (`x10`-`x15`).
- Single-precision float arguments: `fa0`-`fa5` (`f10`-`f15`).
- Integer result: `a0`. Float result: `fa0`. The host writes the result
  back into the CPU registers in place.

### Flat, name-bound table

There is one flat namespace of host calls. The traditional Linux syscalls a
freestanding C runtime needs (write, read, exit, brk, and a few more) are
**renamed into that same flat namespace** rather than kept as a separate
Linux syscall layer. From the guest's point of view there is one table of
named host services and nothing else.

Host calls are resolved **by name**. The selector in `a7` is
`VM_HOSTCALL_BASE (0x00100000)` plus the call's index among the program's
imports. The image carries a `KPIMPT1` import table naming those calls in
order: the magic `"KPIMPT1\0"`, a u32 count, then the packed NUL-terminated
names. At load, the runtime reads that table, binds each index to a host
function by name, and then dispatches by index. An unbound name binds to
nothing and faults the task if it is ever called. Adding or removing a host
call is a change to one host-side table plus the guest imports; there is no
fragile numeric ABI to keep in sync by hand.

The table lives in the program's read-only data and the loader finds it by
**scanning the loaded image for the magic**. It does not rely on an ELF
section or symbol table: the vendored skjegg assembler emits neither a custom
section nor a symbol table, so a section- or symbol-located table would not
survive the toolchain. Scanning for a unique 8-byte magic is toolchain
independent, and the guest SDK authors the table as a few `.asciz` lines
(`sdk/vm/imports.S`).

The host functions come from two places, resolved builtins first:

- **Builtins**, always present, provided by `src/vm/` itself because they
  touch only the task: `sys_exit`, `sys_write`, `sys_random`, `sys_now`,
  `sys_suspend`.
- **Registered calls**, added by the host through a `vm_env` registry of
  `{name, function, context}` entries. Everything game-specific (object
  access, broadcast, privilege) is registered here, so the runtime library
  stays free of the game's object store. A name may not shadow a builtin.

This name-bound scheme is what makes the online-linking stage (below)
clean, and it replaces the ColdFire design's hand-maintained hypercall-ID
enum.

## Host-Call Set

The set below is adapted from smolmoo's syscall table, which is small on
purpose. It is the design target. Names and grouping are stable in intent;
signatures will be pinned as the runtime is built. All are reached through
the flat name-bound table above.

Status: the runtime builtins `sys_exit`, `sys_write`, `sys_random`,
`sys_now`, `sys_suspend`, and `sys_getmsg` are implemented in `src/vm/`.
`sys_suspend` supports a plain yield, a block until a mailbox event, and a
timed sleep whose deadline delivers a `VM_EV_TIMER`; `sys_getmsg` drains one
event into guest memory. The event-routing calls (`sys_listen`, `sys_notify`,
`sys_post`, `sys_taskid`) are registered by the host in `src/verb/`.

The object model card ([[vm-object-model]]) landed the object-access and
authority calls, all registered in `src/verb/`: `sys_getprop`, `sys_setprop`,
`sys_broadcast`, `sys_close`, `sys_getobj`, `sys_objfind`, `sys_next`,
`sys_contents_count`, `sys_move`, `sys_setpriv`, `sys_create`, `sys_recycle`,
and `sys_errno`. Object handles are the currency: a call that yields an object
returns a per-task handle (`VM_HANDLE_SELF` is the program's own object,
`VM_HANDLE_NONE` is failure or end of iteration) which the guest releases with
`sys_close`. `sys_errno` reports the last failing call's reason from a small
fixed enum, refining the `0`/handle/`-1` return without changing it.

The earlier sketch also listed `sys_rollup`, `sys_spawn`, `sys_call`, and
`sys_hasverb`. None shipped. They are deferred, not part of the object model;
cross-object verb invocation and the numeric-rollup cache will be revisited if a
concrete need appears. `sys_write` currently goes to the task's output sink.

**Runtime and I/O**

| Name           | Summary                                               |
|----------------|-------------------------------------------------------|
| `sys_exit`     | halt the task with a status                           |
| `sys_write`    | write bytes to the caller's player session            |
| `sys_broadcast`| write a line to everyone in a room                    |
| `sys_random`   | uniform integer in `[0, max)`                         |
| `sys_now`      | wall-clock seconds (for cooldowns, decay)             |

**Object access**

| Name          | Summary                                                |
|---------------|--------------------------------------------------------|
| `sys_getprop`        | read a string property into a buffer            |
| `sys_setprop`        | write a string property (permission checked)    |
| `sys_getobj`         | open an object-reference property as a handle   |
| `sys_objfind`        | resolve a name in the caller's scope to a handle|
| `sys_next`           | open the ordinal-th member of a container       |
| `sys_contents_count` | number of direct members (bounds a `sys_next` loop) |
| `sys_create`         | allocate a new persistent object under a parent |
| `sys_recycle`        | destroy an empty object the caller owns         |
| `sys_move`           | relocate an object into a container (checked)   |
| `sys_close`          | release an object handle                        |
| `sys_errno`          | the reason the last call failed                 |

**Tasks, messaging, and events**

| Name          | Summary                                                    |
|---------------|-----------------------------------------------------------|
| `sys_spawn`   | start a new task from a program, inheriting caller context |
| `sys_suspend` | sleep for N ms, yield, or block for an event               |
| `sys_call`    | resolve and run a verb on another object (fire-and-forget) |
| `sys_hasverb` | test whether a target responds to a caller-runnable verb   |
| `sys_listen`  | route an object's events to the calling task               |
| `sys_getmsg`  | pop one mailbox event (non-blocking)                       |
| `sys_notify`  | deliver a user event with a string argument to a listener  |
| `sys_post`    | wake a task by id with a bare event                        |
| `sys_taskid`  | the current task's id                                      |

**Security**

| Name          | Summary                                                    |
|---------------|-----------------------------------------------------------|
| `sys_setpriv` | switch effective owner, or enable/drop the wizard flag     |

Argument passing for larger inputs follows smolmoo: the host writes a
fixed-layout argument block and a string area into guest memory before a
program runs, and marshals event records into the string area on
`sys_getmsg`. Input reaches a program only this way. There is no ambient
file access and no blocking read.

## Object Association and Dispatch

Programs attach to ordinary game objects, which live in the boris object
store (`objs` domain, muddb or the CAS backend). A program object names its
ELF by reference and carries its metadata as properties. Verbs are objects
whose properties give the command word, the typed argument spec, and the
ELF reference.

- **Verb resolution** scans four scope tiers in order: the actor, the
  actor's location, the actor's held (direct-contents) items, and the room's
  contents. Each tier is prototype-walked child-first along `%parent`, and the
  first `verb.<word>` found wins. (This replaces the earlier LambdaMOO
  actor/location/root sketch, which predated the held-items and room-contents
  tiers.) The command word's remaining words are matched against the verb's
  typed argument spec; object and player slots are resolved to handles before
  the program runs, and a failed slot aborts dispatch before any task starts.
- **One-shot dispatch.** On a match the host allocates a task, loads the
  ELF into a fresh vm state, and writes the matched arguments into guest memory
  as typed slots, not an argc/argv vector. Each slot is a `{type, value}` pair:
  an object slot carries a handle, a string slot a guest pointer. The task runs
  to completion and is reaped. Verbs return nothing to the caller.
- **Verb programs (agents).** A resident program registers with
  `sys_listen` and drains events from its mailbox. Events reach it when a
  player enters, when another program notifies it, on its dwell timer, or
  when a task posts to it. Delivery is cooperative: events queue in a
  bounded per-task mailbox and are drained at the program's own
  suspend/getmsg point, never as an interrupt.
- **Resident lifecycle.** A configured list names the resident programs (the
  successor to the ColdFire `program.continuous` property). A supervisor keeps
  them running, relaunching any that exit or fault, throttled so a program that
  keeps dying is respawned at a bounded rate. This is the sysvinit respawn
  model rather than smolmoo's awake-object scan; a store-driven scan can replace
  the config list once the object model lands.

Not everything long-running is a verb program. A sequential task bound to
one player session can block on `sys_suspend` and be resumed by
`sys_post`, without calling `sys_listen`, so it never intercepts that
object's other events.

Status: the one-shot dispatch backbone is built in `src/verb/verb_dispatch.c`
(the [[vm-oneshot-dispatch]] card). An exit whose `exit.<dir>.to` is
`prog:<id>` runs a one-shot program; `<id>` is a program object at key
`programs/<id>` carrying `image.path` and optional `ram.size`. The dispatcher
registers `sys_getprop`/`sys_setprop`/`sys_broadcast`, which act on the
program's implicit self object.

The verb/agent half is built in `src/verb/verb_agent.c` (the
[[vm-agent-events]] card). A resident-task manager keeps agents alive across
ticks, registers the event-routing host calls, and routes events into per-task
mailboxes. The configured `vm.resident` programs are launched and supervised by
`boris`, driven by a re-arming iox timer that steps every agent a slice. The
guest event-loop runtime lives in `sdk/vm/verb_rt.c`.

Object model ([[vm-object-model]], built). Characters unify into the OBJ cache
as objects (`chars/<id>`, `%parent` = `templates/pc`), so the char id, the VM
effective owner, and an object's `%owner` share one id space. Containment uses a
`%location` field on each object as a cheap forward pointer, with the reverse
view (`container -> members`) held in a persisted secondary index rather than a
volatile in-memory table. Such indexes will be numerous and cover much of the
world, so they live in LMDB as `DUPSORT` sub-databases, maintained
transactionally on the write path and read by a cursor over the matching key.
There is no boot scan, memory is bounded by the page-cache working set, and
listings are complete rather than loaded-only. Guest programs address objects
through a per-task, host-owned handle table that pins an object while a handle
holds it (`obj_get`) and releases it when the handle is closed or the task ends,
an ARC model over the cache. A verb is a packed `verb.<word>` property naming a
program and its typed spec, resolved by the scope-tier prototype walk above. New
objects come from `obj_create`/`obj_destroy` cache primitives, reached by guests
through `sys_create`/`sys_recycle`. The permission check is in the Capability
and Security Model below.

## Capability and Security Model

The old dirfd capability model is dropped. In its place is a seteuid-style
scheme with two orthogonal axes that travel with a running task, settled in the
[[vm-object-model]] L7 work.

- **Effective owner** is the identity that a property write, create, move, or
  recycle is checked against an object's `%owner`, and the owner stamped on
  objects the task creates. It defaults to the **initiator**, the player who ran
  the verb, not the program owner. This is the reverse of Unix, chosen so a
  program cannot launder privilege by creating objects while elevated.
- **Real owner** is the attached object's `%owner`. A program may switch its
  effective owner to this (`sys_setpriv(VM_PRIV_AS_OWNER)`) to modify the object
  it is attached to, then switch back (`VM_PRIV_AS_CALLER`). The program/ELF
  object itself plays no part in authority.
- **Wizard** is an orthogonal flag, not an identity. The task state holds
  whether wizard is *available* (the current effective identity is durably
  permitted it) and whether it is *enabled* (`VM_PRIV_WIZ_ON`/`WIZ_OFF`, default
  off). A program enables it for the smallest region, then drops it; enabling is
  denied when the effective identity is not permitted. Switching the effective
  owner recomputes availability and drops wizard, so an identity change always
  starts un-elevated.
- The permission check on object `O` is: effective owner equals `O.%owner`, or
  wizard is enabled. An object with no `%owner` is writable only by the system
  or a wizard.
- **Durable permissions live on the account**, not the object. The VM side reads
  availability through a host-registered callback
  (`verb_dispatch_set_wizard_check`) keyed by the current effective identity;
  the account's durable-permission storage and the player-facing elevate/drop
  command ride with the later command-loop wiring. A host-initiated one-shot
  with no effective owner runs as the system, unrestricted; a resident agent
  instead runs as its object's owner (see below).

A failing check sets `sys_errno` to `VM_ERR_DENIED`. This scheme replaces the
earlier plan of a setuid bit in the ELF-reference mode and a direct bridge to
the `src/acs.c` ACS layer.

**An agent runs as its object's owner.** At launch the agent's effective owner
is seated from its self object's `%owner`, so its property writes, moves,
recycles, and creates are owner-checked exactly as a verb's are, and it is bound
to that one identity. A program object with no `%owner` cannot be launched as an
agent, so every agent has an identity. Wizard rights follow the owner's account
(a `sys_setpriv` `WIZ_ON` succeeds only when the owner is wizard-capable); an
agent has no caller, so `AS_CALLER` resets it to its own owner rather than to
the unrestricted system. The launch paths are still administrator-only: the
configured `vm.resident` list and the supervisor in `boris` start agents, and no
guest or player can spawn one. Agent authors must still treat all event input as
untrusted: `sys_notify` and `sys_post` are not authority-gated, so any running
task, including a one-shot verb that a non-wizard player authored on an object
they own, can deliver a payload or a wake to a listening agent, and an event
carries no authenticated principal (its sender is only a task id). An agent must
never use event data to decide which object to modify, or it becomes a confused
deputy acting on a player's behalf. Because an agent's handle table lives for
the agent's whole life rather than one run, an agent must also `sys_close` every
handle it opens, or it exhausts the table.

The host process is still confined by seccomp and Landlock at startup
(`src/security/`), so even an emulator escape cannot make syscalls or touch
files outside the allowlist. That layer is independent of the guest
sandbox and is unaffected by this pivot.

## Compilation Pipeline

The full design is a three-stage, JIT-like pipeline. It matches how kobold
already works and keeps the online step small.

1. **Compile.** A guest-language source file (kobold or C) compiles to a
   KPM1 module (kobold's intermediate module format). This is the language
   front end.
2. **Link.** The KPM1 module is linked and its imports resolved into a
   self-contained RV32 ELF. Import names bind through the name-bound scheme
   in **Host-Call ABI**. This stage can run online, inside the server.
3. **Execute.** The ELF is loaded into the RV32 emulator and run as a task.

**First implementation cut: stage 3 only.** The initial build runs
pre-built RV32 ELFs. Compilation and linking happen offline, outside the
server, with the kobold and skjegg toolchains. Stages 1 and 2 are designed
now so the ABI and module format do not have to be reworked later, but
online compilation and linking are deferred. In-server compilation is the
larger, later scope, and it is what smolmoo's `@program` command does.

## Guest Language Support

Two guest languages are targeted.

- **kobold** -- a small, statically typed Pascal-family language. The
  primary runtime. It compiles through the pipeline above. Kobold has no
  raw pointers; host objects are reached through opaque integer handles and
  the host-call FFI, which suits the sandbox.
- **C** -- through the skjegg RV32 toolchain, for low-level programs. C
  compiles to a standard ILP32 RV32 ELF and links against the guest
  runtime.

Both share one guest runtime: the C start code (`_start`), the host-call
stubs, and the event-loop runtime that a verb program links. The runtime is
freestanding; it provides a heap over the program break, a small string and
number layer, and the host-call wrappers, and it makes no host calls other
than those in the flat table.

Status: the C toolchain is vendored in-tree at `sdk/toolchain/skjegg/`
(`skj-cc-rv`, `skj-as-rv`, `skj-ld-rv`; the [[vm-toolchain-vendor]] card), and
the guest runtime is in `sdk/vm/`: `crt0.S` (one-shot start: calls `main` on
the host-set `argc`/`argv`/stack, then exits), `cmd_crt.S` + `cmd_rt.c` (the
command-verb start and typed-argument accessors), `verb_rt.c` (the agent
event-loop runtime), `stubs.S` (`ecall`-per-call), `imports.S` (the KPIMPT1
table), `vm.ld`, and `vmsys.h`. `sdk/vm/Makefile` builds the example programs,
and `vm-run` loads and runs a program image against the runtime builtins for
testing. The kobold front end is a later card ([[vm-online-toolchain]]).

## What This Drops From the ColdFire Design

Recorded so the intent is clear and the old cards are not resurrected by
mistake.

- **Multicore credit scheduler, per-core run queues, work stealing.**
  Replaced by one cooperative single-threaded scheduler with an
  instruction budget. Multicore is deferred to the `multithreading` track.
- **dirfd capability model, intent flags, `HC_OPENAT`, delegation.**
  Replaced by the seteuid-style authority model: an effective owner checked
  against an object's `%owner`, with an orthogonal wizard flag raised and
  dropped by `sys_setpriv`.
- **Synchronous send/receive/reply messaging, the system-wide
  reply-handle table, and the bearer-token reaper.** Replaced by a
  cooperative per-task mailbox drained with `sys_getmsg`.
- **Single-writer-per-domain owner tasks.** Not needed without concurrent
  writers. Property writes go through the permission-checked host calls
  directly.
- **The hand-maintained hypercall-ID enum and register tables.** Replaced
  by name-bound host calls.
- **ABI freeze and program-versioning machinery.** Pre-release, everything
  builds from one tree, so there is no compatibility boundary to protect
  yet. The freeze story returns only if independently distributed binaries
  ever exist.
- **Snapshot and restore of task state.** Deferred until the runtime is
  stable.

## Source Layout (proposed)

The new subsystem replaces `src/coldfire/` and `src/machine/`.

| Path         | Contents                                                     |
|--------------|--------------------------------------------------------------|
| `src/rv32/`  | vendored RV32 emulator core and ELF32 loader, owned by boris |
| `src/vm/`    | task lifecycle, memory image, `ecall` host-call dispatch and ABI framework, argument block, per-task mailbox and timed sleep; game-agnostic |
| `src/verb/`  | verb argument matching and the game glue: object-store host calls, program resolution, one-shot dispatch, the resident-agent manager, event routing, and resident supervision |
| `sdk/vm/`    | guest SDK: the C runtime start, host-call stubs, the event-loop runtime, linker script, and example programs |
| `sdk/toolchain/skjegg/` | vendored skjegg RV32 C toolchain (`skj-cc-rv`, `skj-as-rv`, `skj-ld-rv`) that builds guest programs |

The object-store integration lives in `src/verb/`, not `src/vm/`, to keep the
VM runtime free of the game's object store (it reaches the host only through
registered host calls and an injected output callback).

Files to bring in are listed in `doc/vm-migration-plan.md`.
