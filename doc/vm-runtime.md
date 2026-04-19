# VM Runtime

This document describes the scripting runtime that hosts sandboxed VM
programs inside boris. It defines the contract between the VM and the
host: how scripts are scheduled, how they observe and mutate game
state, how their effects become visible to the rest of the world, and
how conflicts between concurrent scripts are resolved.

The current target is the StackVM (a Quake III-style 32-bit stack
machine, see `/home/jon/DEVEL/Source/stackvm/`). A future scripting
language (e.g. a LuaJIT-like system) is anticipated; the runtime
contract is designed to survive that swap. The VM itself is an
implementation detail. The lifecycle, syscall surfaces, and
concurrency model are the durable design.

## Goals

 1. **Sandboxed execution.** Scripts run in a fixed-heap VM with no
    ability to allocate host memory, escape their address space, or
    issue arbitrary system calls. The Q3-style VM provides this by
    construction.
 2. **Bounded resource use.** Every activation has an instruction
    budget. Memory is bounded by the VM heap allocated at init.
    Output is bounded by the VM heap (see deferred outputs, below).
 3. **Atomic effects.** A script either succeeds entirely or has no
    observable effect on world state or other players. No partial
    updates, no half-sent messages.
 4. **Natural access to game state.** Scripts read and write `obj`
    attributes and muddb records through syscalls that feel
    appropriate to those data shapes -- typed accessors for objects,
    file-like accessors for raw scratch storage.
 5. **Multi-script safety.** Multiple scripts may target the same
    object. Conflicts must not corrupt state. Conflict resolution
    must be implementable today, not require a research project.
 6. **Forward-compatible with multithreading.** boris is intended to
    become multithreaded. The runtime contract should not assume a
    single global lock.

## Non-goals

 - **Hard real-time guarantees.** Scripts are cooperative and
   interruptible at instruction-budget boundaries. Worst-case latency
   is bounded but not tight.
 - **Pure-function scripts / general replay.** Scripts are written
   against side effects. Replay is supported only at the explicit
   activation boundary (yield-and-requeue), not at arbitrary points.
 - **A scripting language.** This document covers the runtime, not
   the language. Initial scripts will be written in C or Pascal
   targeting the VM bytecode. A DSL is a later question, gated on
   real ergonomic pain that better syscalls cannot solve.
 - **Multiple unrelated VM ISAs.** A future swap to a different VM
   (e.g. LuaJIT) is in scope, but the runtime assumes one VM family
   at a time, not a polyglot host.

## Background

Three subsystems define what scripts need to manipulate:

 - **`obj`** (`src/obj/`) -- copy-on-write JSON objects on a single
   buffer. Each game object is one JSON blob. The single-buffer
   design is deliberate, for performance and simplicity. See
   memory `project_json_compact.md`.
 - **`muddb`** -- the persistence layer above LMDB, organizing
   records into typed domains (entities, rooms, accounts, etc.).
 - **LMDB** -- the storage backend. Provides MVCC read snapshots
   and a single-writer process-wide transaction model. See memory
   `project_lmdb_migration.md`.

A separate prototype, `!NOTES/vfs.[ch]`, explores an in-memory
filesystem with Unix-style permissions and quotas. It is referenced
below as one of the candidate syscall surfaces.

The VM itself exposes the hooks the runtime depends on:
`vm_run_slice`, `vm_yield`, `vm_set_extra` / `vm_get_extra`,
syscall registration via `vm_env_register`, and a negative-CALL
syscall dispatch convention. See
`/home/jon/DEVEL/Source/stackvm/stackvm.h`.

## Design overview

A script execution is an **activation**: one VM instance, loaded
with a program, called at an entry point, run to completion (or
abort) under bounded instruction count. Activations are the unit of
scheduling and the unit of atomicity.

An activation proceeds in three phases:

 1. **Pre-acquire** -- the VM may compute, but cannot read or write
    game state and cannot emit observable output. Used to compute
    which objects the activation needs.
 2. **Acquired** -- the VM has declared a working set of objects
    and the scheduler has locked all of them. Reads see a consistent
    snapshot; writes go to a staged buffer; outputs go to a deferred
    outbox.
 3. **Commit / abort** -- the staged writes are flushed to muddb in
    a short LMDB write transaction; the outbox is drained in
    emission order; locks are released. On abort, both buffers are
    discarded.

Three syscall surfaces serve different access patterns:

 - **`obj` syscalls** -- typed `get(id, attr)` / `set(id, attr, val)`
   against the object's JSON cells. The natural shape for the
   primary game data model.
 - **VFS syscalls** -- file-like CRUD against an LMDB-backed
   namespace, for script scratch space, configuration, shared blobs.
   Built on the prototype in `!NOTES/vfs.[ch]`. Inherits LMDB's
   transaction semantics natively.
 - **World syscalls** -- verbs like `tell`, `say`, `move`, `spawn`.
   Not CRUD; these are actions, not data access. Output-side world
   syscalls go through the deferred outbox.

WASI itself is not all `fd_*`; it has clocks, random, and sockets as
distinct surfaces. We follow the same pragmatism: don't force one
shape onto problems that don't fit.

## Activation lifecycle

```
   create VM
       |
       v
   vm_call(entry)        <-- pre-acquire phase
       |
       v
   sys_acquire(ids[])    <-- atomic all-or-yield
       |
       +--- conflict --> vm_yield -> requeue on contended id
       |
       v
   run instructions      <-- acquired phase
   sys_get/set_attr
   sys_tell, sys_say     (queued in outbox)
       |
       v
   sys_commit            <-- flush staged writes + drain outbox
       |                     OR
   sys_abort             <-- discard both
       |
       v
   release locks, end
```

### Working-set acquisition

A script declares the objects it needs via `sys_acquire(ids[])`.
The scheduler attempts to lock all declared objects atomically:

 - All available -> acquire all, return success, enter acquired phase.
 - Any unavailable -> release any partial holds, call `vm_yield`,
   requeue the activation on a wait queue keyed on the contended id.

Acquiring all-or-nothing (with a globally consistent lock order)
makes deadlock structurally impossible. Incremental acquisition is
explicitly disallowed.

### Touching an undeclared object

A script that calls `sys_get_attr(id, ...)` for an `id` not in its
working set faults the activation (`VM_ERROR_BAD_ENVIRONMENT` or a
new `VM_ERROR_UNDECLARED_ACCESS` flag). Silent escalation would
reintroduce the deadlock potential that all-or-nothing acquisition
was meant to remove.

### Reentrancy

If script A holds object X and triggers script B that also needs X,
two policies are coherent. We pick **synchronous recursive
ownership**: B runs under A's lock, sharing A's working set. The
alternative (B queues until A finishes) is simpler in isolation but
deadlocks the moment A's continuation depends on B's output.

This is analogous to RTOS priority inheritance: the temporary holder
of a resource gains the urgency of any waiter.

### Yield and requeue

A script that yields voluntarily (or that is yielded by
`sys_acquire` on conflict) drops its locks and is requeued. The
staged write buffer and outbox are discarded. The activation
restarts from its entry point on its next slice.

Because scripts are not generally replayable, a yield is observable
to the script author: any work done before the yield is repeated.
The discipline this imposes is the same as the discipline imposed by
"no irreversible syscalls before commit": keep the pre-acquire phase
small, pure, and idempotent.

This is **good enough**, not perfect. Real replay would require
either a checkpoint opcode (explicit, but a foreign concept to most
language frontends) or full execution-state snapshotting (expensive
and surprising). Yield-and-requeue is a pattern programmers
encounter elsewhere (HTTP retries, DB serializable retries) and is
acceptable as a v1 contract.

## Concurrency model

LMDB's single-writer constraint applies to the *write transaction*,
not the script's lifetime. The runtime uses LMDB transactions only
during the commit phase, which is short and bounded by the size of
the staged write buffer.

For the script's working duration, the runtime relies on its own
**object-level locks**, not LMDB transactions. Reads during the
acquired phase use a cheap LMDB read snapshot opened at acquisition
time; this gives the script a stable view of the world without
holding any LMDB writer locks.

Optimistic concurrency control (per-record version checks at commit)
was considered and rejected. With non-replayable scripts and
object-granularity conflicts, OCC's value is small: every conflict
becomes an unrecoverable abort that the script author must handle
manually anyway. Pessimistic acquisition is simpler and surfaces
contention earlier (at acquire time, not at commit time).

### Staged writes

`sys_set_attr` and similar mutations do not touch muddb directly.
They append to a per-activation staged write buffer (held in the
VM's `vm_extra` context). `sys_get_attr` checks the staged buffer
before falling through to the LMDB snapshot, so the script observes
its own pending changes (read-your-writes).

On commit, the runtime opens a short LMDB write transaction, applies
the buffer, and commits. On abort, the buffer is dropped.

Granularity is per-object, matching the existing single-blob JSON
storage. Two scripts that touch the same object conflict; two
scripts that touch different objects do not. This is consistent with
the entity system's atomic-combat-update goal (see
`doc/entity-system.md`).

### Scheduling

Activations queued on a working set acquire in arrival order. To
mitigate priority inversion (a low-priority script holds an object
that many higher-priority activations are waiting for):

 - **Priority inheritance** -- the holder's instruction budget is
   raised to the maximum of any waiter's budget. The holder
   finishes faster, releasing the resource faster.
 - **Priority ceilings** (later, if needed) -- frequently-contended
   objects (combat rooms, central NPCs) declare a ceiling priority;
   any holder runs at >= that ceiling.

Instruction budgets are the universal backstop. Any activation that
exceeds its budget is forcibly aborted. This bounds the worst-case
hold time of any lock at the slowest script's budget, which is a
configuration knob.

## Deferred outputs (outbox)

Observable side effects -- `tell`, `say`, room broadcasts, log
writes -- are not delivered immediately. They are appended to a
per-activation outbox and emitted in order during commit. On abort,
the outbox is discarded.

Properties:

 - **Buffer lives in the VM heap.** The fixed VM heap caps outbox
   size; runaway scripts hit their own ceiling, host memory is
   never threatened.
 - **FIFO across all output kinds.** A single tagged queue
   (`{kind, target, payload}`) preserves the order the script
   emitted things. Per-channel queues would mis-order interleaved
   tells and says.
 - **Aborts are silent to the world but visible to ops.** A
   host-side counter tracks aborted activations and discarded
   output volume so a buggy script doesn't quietly produce nothing
   forever.

### What does not defer

Inputs are not side effects and must return real values
synchronously: `sys_random`, clock reads, attribute reads,
"who is in this room". Without real values the script cannot
branch.

### Spawn and destroy

Object lifecycle (creating an NPC, destroying an item) sits between
data writes and outputs. Two coherent policies:

 - Resolve through the staged write buffer: a spawned object exists
   for the rest of this activation's reads, materializes on commit.
 - Forbid until commit: spawn syscalls record an intent, but the
   object is not addressable until the next activation.

The first is consistent with attribute writes and is the planned
behavior. It requires that staged spawns participate in the
working-set lock (the new id is implicitly held).

### Escape hatch: explicit flush

A `sys_flush_now()` that drains the outbox mid-activation is
deliberately **not** in v1. It forfeits atomicity for everything
emitted before it and undermines the "scripts are atomic" contract.
It will be revisited only when a real use case (e.g. a long ritual
with progress messages) cannot be reasonably expressed by splitting
the activation.

## Syscall surface conventions

 - Negative CALL addresses dispatch to host syscalls (StackVM
   convention; -1 reserved for VM exit).
 - The active activation context (working set, staged writes,
   outbox, snapshot handle) lives in `vm_extra`, not in globals.
   This is mandatory for the multithreaded future.
 - Transactions are not user-visible. The `glBegin`/`glEnd` pattern
   considered earlier is replaced by the implicit activation
   boundary: every script *is* a transaction. This avoids the
   nested-end footgun OpenGL had.
 - Irreversible syscalls (anything that goes through the outbox)
   may only be called in the acquired phase. Calling them
   pre-acquire faults the VM.

The concrete syscall numbers and signatures are not fixed in this
document; they belong in a separate API reference once the surface
has stabilized in code.

## Research summary and rejected alternatives

 - **VFS as the universal interface for game objects** -- rejected.
   The "everything is a file" model loses the JSON structure
   `obj.c` was built around, makes per-attribute access an O(n)
   path scan, and has no event/watch primitive. Retained as one of
   three syscall surfaces for the data shapes that genuinely match
   it (script scratch storage).
 - **Optimistic concurrency control with per-record versions** --
   rejected. Non-replayable scripts make abort-on-conflict
   unrecoverable from the script's perspective, so the optimism
   buys nothing. Object-granularity conflicts also defeat
   per-attribute version precision when an object is one JSON blob.
 - **Explicit `glBegin`/`glEnd` transactions in script code** --
   rejected. The activation already is the transaction boundary;
   exposing it to scripts adds a footgun (nested or forgotten
   `end`) without adding expressive power.
 - **`setjmp`/`longjmp` checkpoints for replay** -- rejected for
   v1. Violates least surprise; would require every language
   frontend to expose the concept. Yield-and-requeue is sufficient.
 - **Writing a DSL up front** -- deferred. C and Pascal targeting
   the VM are sufficient to validate the syscall surface. A DSL
   becomes worth designing only after real scripts have surfaced
   ergonomic pain that better syscalls and a small standard library
   cannot fix.

## Open questions

 - **Scope of `sys_acquire`.** Can a script acquire mid-activation
   (e.g. after computing which object it needs from a query)? The
   safe answer is "only once, at the start"; a richer answer
   ("re-acquire is allowed and behaves as commit-then-yield") may
   be needed for some queries. Decide when the first script needs it.
 - **Wait-queue starvation.** A heavily-contended object could
   starve newcomers if priority inheritance keeps boosting the
   current holder. A fairness mechanism (FIFO with bounded
   boosting, or aging) may be needed.
 - **Cross-VM communication.** If a future LuaJIT-style runtime is
   added alongside StackVM, the outbox and acquire model should
   remain compatible. Verify before committing to a second VM.
 - **Persistent state of in-flight activations.** What happens to a
   yielded activation if the server restarts? Simplest answer:
   discard. Document this so script authors do not depend on
   activation continuity across restarts.

## References

 - `/home/jon/DEVEL/Source/stackvm/stackvm.h` -- VM API
 - `/home/jon/DEVEL/Source/stackvm/stackvm.txt` -- ISA and file format
 - `!NOTES/vfs.[ch]` -- VFS prototype
 - `src/obj/` -- copy-on-write JSON objects
 - `doc/entity-system.md` -- entities and atomic combat updates
 - `doc/rpg-system.md` -- RPG rules layered on entities
