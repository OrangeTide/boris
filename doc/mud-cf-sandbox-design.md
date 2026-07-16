# MUD ColdFire Sandbox -- Design Doc

::: aside
**Status: EXPERIMENTAL. PRE-FREEZE.** Nothing here is released. There is
no installed base, no distributed binaries, and no ABI stability of any
kind. Every hypercall ID, register convention, record layout, and
memory-map address in this document is subject to change without notice.
Do not build anything that depends on the current shapes surviving.

An earlier draft of this document declared a frozen v1 ABI. That was
premature. We adopted freeze discipline before the load-bearing
architecture (unprivileged execution, the multicore write model,
credit accounting, and the capability model) was built and proven. This
revision removes the freeze and the versioning machinery that served it.
The freeze line gets drawn later, once the gate list in **Roadmap** is
met and the design has survived a real workload.
:::

## Introduction

This document describes a script sandbox for the boris MUD server built
on a ColdFire V4e CPU emulator (~2200 LOC). Each script, NPC, or area
runs in its own emulator instance with private RAM. Guest code
communicates with the host through LINE_A opcodes (0xAxxx), which trap
into a small set of hypercalls. Isolation comes from unprivileged guest
execution, bus-callback bounds checking that faults on violation,
seccomp on the host process, and credit-budget preemption, not from
language-level guarantees.

There is no ambient filesystem. A task starts with a set of directory
file descriptors in its fd table, and that fd table is the entire
security boundary. HC_OPENAT takes a dirfd, a path, and intent flags
(O_BLOB, O_OBJECT, O_MSGCHAN, etc.) and returns a capability-scoped fd.
Parents delegate narrowed capabilities to children at spawn time. There
is no mechanism by which a task can manufacture a dirfd it was not
granted.

Tasks communicate through synchronous message passing (send, receive,
reply). HC_MSG_SEND blocks the caller until the receiver replies or a
timeout expires. This is not just an IPC convenience. It is the concurrency
model: the target platform is multicore, tasks run in parallel on
separate cores, and message passing is how a task reaches shared state
without touching another task's memory. Persistent domains that a task
cannot write directly (see **Object Writes**) are reached by sending to
the trusted service task that owns the domain.

The scheduler charges credits per unit of work and preempts on budget.
It is designed for a multicore host from the start: per-core runqueues
with work stealing, not a single scheduler thread. Because each task's
guest state lives in a private RAM block with its own bus callbacks,
tasks running on different cores share no mutable guest state and need
no cross-core synchronization on the execution hot path. This is the
central reason the per-instance emulator approach was chosen.

Task state snapshots let a script hibernate across server reboots. The
snapshot is not simply the CPU plus RAM. Substantial task state lives
host-side (the fd table, the capability table, the tmp ramdisk). The
snapshot format must capture all of it. See **Snapshot / Restore** for
the real state inventory and why this is deferred until the architecture
settles.

## Roadmap

We track two phases, not a version ladder. Everything is **pre-freeze**
until the gate list below is met, at which point the guest-visible ABI
becomes **frozen** and forward-compatibility discipline begins. Drawing
the freeze line earlier is what this revision undoes.

### Pre-freeze (now)

The ABI is mutable. IDs get reassigned, register conventions change,
records get reshaped, whenever the design improves. Programs are rebuilt
from the same tree as the host, so there is no compatibility boundary to
protect and no versioning machinery to carry. The work is to build and
prove the load-bearing subsystems, in breakable code, in the order that
retires the most risk.

### Frozen (later, gated)

The freeze line is drawn only when all of the following are true, and
have survived a real workload rather than existing on paper:

1. **Unprivileged execution works.** The guest runs in user mode, the
   supervisor vector table and syspage live in host-controlled memory,
   and the S-bit transition is clean. Privileged instructions trap.
2. **The multicore write model is proven under load.** Parallel readers
   and single-writer-per-domain (see **Object Writes**) stay coherent
   and perform on the target hardware.
3. **Credit accounting is real.** Per-instruction and per-hypercall
   charging, per-quantum preemption, and the lifetime runaway kill all
   exist and are exercised.
4. **The capability model is real.** dirfd-scoped access with intent
   flags and delegation, not the two hardcoded prefixes the current
   prototype recognizes.

At the freeze, and not before, we introduce the program-versioning
story (a single monotonic version compared at load, nothing more
elaborate until independently-distributed binaries actually exist) and
the append-only record discipline. Until then, none of that machinery
is worth carrying.

### Deferred past the freeze

Root-bounded `..` in paths, selective-peek message channel semantics if
we find we need them, typed hypercalls for non-obj domains (`user:`,
`area:`), a GDB stub, multi-thread-per-task, and the
program-distribution / symbol-versioning story. None of these block the
freeze; all are cheaper to add after the core is stable.

## Current Prototype

A working prototype exists and is unit- and smoke-tested. It implements
the execution wiring end to end but almost none of the security model.
Treat every ID and convention here as scratch: the frozen ABI will not
match it.

### Hypercalls implemented

HC_ABORT (0), HC_TRAP (1), HC_YIELD (2), HC_SLEEP (3), HC_EXIT (4),
HC_PRINT (5), HC_OPEN (6), HC_CLOSE (7), HC_WAIT (8), HC_MSG_POST (19).

These IDs are prototype-only and collide with the intended ABI shape.
HC_OPEN here recognizes only the literal prefixes `verb:` and `event:`.
There is no dirfd, no capability, no blob or object domain, no filesystem.

### Execution model

The guest currently runs in **supervisor mode**. This is a known defect,
not a design choice: `cf_reset()` sets the S bit and `machine_start()`
never clears it, so the guest can execute privileged instructions
(MOVEC, move-to-SR, STOP, RTE). Nothing escapes the RAM sandbox because
the bus callbacks bound every access, but the unprivileged-execution
isolation layer is absent. Fixing this is gate item 1.

Bus callbacks currently **succeed silently on out-of-range access**:
reads return zero, writes are dropped. The intended behavior is to raise
an access-error exception so a stray access kills the task instead of
running on garbage. Fixing this is part of gate item 1's work.

### Task state machine

```
INIT --> READY <--> BUSY --> DEAD
  |        |                   ^
  |        +--> SLEEPING ------+
  +--------------------------------+
```

- **INIT**: CRT runs, zeroes .bss, opens verb/event handles, calls
  `main()` if present. First HC_WAIT transitions to READY.
- **READY**: parked, host may dispatch verbs/events.
- **BUSY**: handler executing. May call HC_WAIT internally.
- **SLEEPING**: waiting for a timeout before returning to READY.
- **DEAD**: exited or force-killed.

Events are delivered as normal function calls when the sandbox is in a
known quiescent state (parked in HC_WAIT). No async interruption, no
reentrancy. Inspired by Palm OS PilotMain.

### Unified handle system

File descriptors, verbs, and events share a single `uint16_t` handle
space. Every open handle is a `struct machine_file` in the task's fd
table. Handle types: MF_IO, MF_VERB, MF_EVENT. HC_CLOSE returns a kind
enum so the CRT can perform type-specific cleanup. Fds 0/1/2 are opened
as MF_IO at task creation.

### Verb dispatch

The host finds verbs by searching the fd table for MF_VERB entries with
matching names. A context block is written at a fixed guest address
before dispatch, the host sets PC to the handler, and execution resumes
under an instruction cap. Verb dispatch currently runs **inline on the
command path** (`obj_program_dispatch_verb` from `do_move`). That does
not compose with the scheduler and is temporary.

### Room lifecycle integration

Machine instances are tied to the obj cache. On obj load, a
`program.continuous` property triggers ELF load and instance creation;
on obj evict, the termination sequence runs and the instance is freed.
A tick timer drives sleeping and continuous scripts.

### Files

Host-side: `src/machine/{machine,obj_program,program,objref}.c`,
`src/coldfire/{coldfire,elf_loader}.c`. Guest SDK: `sdk/machine/`.

## Goal

Embed the ColdFire V4e emulator as the script sandbox. Each connected
script/area/NPC runs in its own CF VM instance, scheduled by the host
across multiple cores with credit-budget preemption.

Rejected alternatives: Q3VM (limited tools, cumbersome instruction
indices), Wasm (heavyweight, validation guarantees not needed), LuaJIT
(sandboxing weaknesses), pure Lua (no preemption).

## Why ColdFire

- **Tooling.** `m68k-linux-gnu-gcc`, binutils, gdb, newlib. The m68k
  backend is mature. C is the baseline target; other GCC frontends are
  feasible (see **Guest Language Support**) but not required to ship.
- **FFI ergonomics.** LINE_A opcodes (0xAxxx, ~4096 slots) trap to a
  host hypercall handler with full register access. No i32-only
  marshaling.
- **Isolation.** Per-instance `cf_cpu` plus bus callbacks bound to a
  private RAM block. No shared mutable guest state between instances,
  which is what makes the multicore scheduler cheap.
- **Preemption.** `cf_run(cpu, count)` returns after `count`
  instructions. No timer interrupts needed.
- **Debuggability.** A GDB remote-serial stub is a few hundred LOC
  bolted onto coldfire.c (deferred).
- **Retro flavor.** Builders can write 68k assembly if they want to.

Host: Raspberry Pi 5, quad-core. Interpretation overhead
(50-200M emulated insns/sec/core) is comfortable, and the spare cores
are the point: the scheduler is meant to use them.

## Trust Model

Builders are semi-trusted (granted a builder-access bit). Threats are
runaway loops, memory exhaustion, and accidental sandbox escape via
emulator bugs. Defense in depth:

1. **Unprivileged guest execution.** The guest runs with CF_SR_S clear.
   Privileged instructions trap to the host. (Not yet implemented; gate
   item 1.)
2. **Bus callbacks fault on out-of-range access.** An access outside
   the task's RAM raises an access error and kills the task, rather than
   silently reading zero. (Currently silent; part of gate item 1.)
3. **Credit budget** caps CPU per task per quantum; a per-tick cap
   bounds the tick as a whole; a lifetime cap kills runaways.
4. **Per-task RAM cap** (start at 64KB, tune).
5. **Dedicated unprivileged host user.**
6. **seccomp profile** on the MUD process, so even an emulator escape
   cannot make syscalls outside an allowlist.
7. **AFL-fuzz** coldfire.c against random instruction streams before
   exposing to builders.

Layers 1 and 2 are the ones the earlier draft named first but did not
build. They are the top of the pre-freeze work list.

## Terminology

- **program** (`program_t`) -- an ELF blob plus metadata. Inert code.
  Owned by muddb, thawed on demand. Multiple tasks can share a program;
  read-only text can be COW-shared across tasks.
- **vm state** (`vm_state_t`) -- CPU + registers + RAM + bus callback
  table. One per task.
- **task** (`task_t`) -- a running instance. Owns a vm state, an fd
  table, a private `tmp:` ramdisk, and capabilities for the persistent
  domains it may touch. The scheduler operates on tasks.

"Script" survives only as informal shorthand for "a program someone
wrote for the MUD."

## Per-Task State

```c
typedef enum {
    TASK_RUNNABLE,
    TASK_BLOCKED,    /* waiting on message send/recv/reply */
    TASK_SLEEPING,   /* wake at wake_tick */
    TASK_DEBUGGING,  /* gdb breakpoint (deferred) */
    TASK_DEAD,
} task_state_t;

typedef struct task {
    uint32_t      id;
    vm_state_t    vm;                /* cpu + ram + bus callbacks */
    program_t    *program;           /* code this task is running */
    task_state_t  state;
    uint32_t      priority;          /* MLFQ level */
    uint64_t      credits_used;      /* lifetime */
    uint64_t      wake_tick;
    uint32_t      blocked_on;        /* reply handle or channel fd */
    fd_table_t    fds;               /* caps; see Capabilities */
    uint8_t      *tmp_ram;           /* tmp: ramdisk, reaped in task_free */
    uint32_t      tmp_size;
    uint32_t      home_core;         /* scheduler affinity hint */
    struct task  *next;              /* runqueue link */
} task_t;
```

Per-task overhead ~65 KB (RAM dominates). 1000 tasks ~ 64 MB.

## Hypercall ABI

::: aside
**Unstable.** The IDs, register assignments, and record layouts in this
section will change before the freeze. They are documented to pin down
the intended *shape*, not to be built against.
:::

Hypercalls are LINE_A opcodes (`0xAxxx`). The low 12 bits carry a flat
enum of hypercall IDs. The opword for HC ID `n` is `0xA000 | n`.

Return values and fd/errno results are `int16_t`. File descriptors are
non-negative; errors are negated errno values. The per-task fd table and
its cap are a single number to be fixed with the capability work; the
prototype's 256-entry table and the earlier draft's stated cap of 127
must be reconciled to one value.

### Intended set

| ID | Name              | Summary                       |
|----|-------------------|-------------------------------|
| 0  | HC_ABORT          | immediate task death          |
| 1  | HC_TRAP           | debug trap                    |
| 2  | HC_YIELD          | voluntary preemption          |
| 3  | HC_SLEEP          | sleep for N ticks             |
| 4  | HC_EXIT           | clean exit                    |
| 5  | HC_PRINT          | debug output                  |
| 6  | HC_SPAWN          | create child task             |
| 7  | HC_OPENAT         | open fd from dirfd + path     |
| 8  | HC_CLOSE          | close fd                      |
| 9  | HC_READ           | read bytes (blob only)        |
| 10 | HC_WRITE          | write bytes (blob only)       |
| 11 | HC_READDIR        | directory listing             |
| 12 | HC_STAT           | stat fd                       |
| 13 | HC_UNLINK         | remove entry (ACL-gated)      |
| 14 | HC_OBJ_PROP_GET   | get object property           |
| 15 | HC_OBJ_PROP_PUT   | request object property write |
| 16 | HC_OBJ_PROP_LIST  | list object properties        |
| 17 | HC_SELECT         | wait on multiple fds          |
| 18 | HC_MSG_SEND       | synchronous RPC send          |
| 19 | HC_MSG_POST       | fire-and-forget message       |
| 20 | HC_MSG_RECV       | receive on message channel    |
| 21 | HC_MSG_REPLY      | reply to received message     |

**One multiplexing primitive, not two.** The prototype has HC_WAIT
(WaitForMultipleObjects shape); this table lists HC_SELECT (fd-bitmask
shape). We ship exactly one. The choice is open, but carrying both is
churn and only one survives to the freeze.

**HC_ABORT at ID 0.** ID 0 = abort is a useful convention: guest
`panic()` and unrecoverable asserts map to it, and it reads clearly in
logs. Note the earlier rationale ("default-zeroed state dispatched as a
hypercall triggers abort") does not hold: hypercall dispatch is only
reached through a 0xAxxx opword, and zeroed guest memory decodes as
0x0000 (ORI.B), not LINE_A. A wild jump into zeroed RAM faults through
the normal exception path, not through HC_ABORT. Keep ID 0 = abort for
the convention, not for that reason.

**HC_TRAP at ID 1.** Debug trap. The task enters TASK_DEBUGGING and
waits for a debugger. If none is attached, treated as HC_ABORT.

### Register convention

Integer and size arguments fill d0, d1, d2, d3 in declaration order;
pointer arguments fill a0, a1, a2 in declaration order. Every hypercall
returns its result in d0. The two sequences are independent.

This matches what `m68k-linux-gnu-gcc` generates for register-parameter
calls, so each hypercall is expressible as a plain C prototype and the
`mud.h` header is the authoritative ABI description. **The prototype is
normative; any register table in this doc is a derived quick-reference.**

The earlier draft carried two register tables that disagreed (a
type-grouped "full map" and an interleaved per-call listing). To avoid
that, this revision keeps only the rule above and the C prototypes. When
we need a table, it is generated from the prototypes, not hand-written
alongside them.

64-bit values (reply handles) are passed by pointer, never by register
pair. Widening a pointed-to type later changes no register conventions.

### Guest-side shim

```c
#define MUD_HC(id)  __asm__ volatile (".short 0xA000 | " #id ::: "memory")
static inline void mud_yield(void) { MUD_HC(HC_YIELD); }
static inline void mud_abort(void) { MUD_HC(HC_ABORT); __builtin_unreachable(); }
```

### Capability-flag model

HC_OPENAT flags in `d1` express the caller's intent and become the
capability on the returned fd.

```c
/* access mode: 2-bit enum in bits [1:0] */
#define O_ACCMODE    0x3
#define O_ACC_NONE   0x0   /* no data access; valid only with O_PROGRAM */
#define O_RDONLY     0x1
#define O_WRONLY     0x2
#define O_RDWR       0x3

/* family bits: exactly one must be set */
#define O_BLOB       (1UL << 2)
#define O_OBJECT     (1UL << 3)
#define O_DIRECTORY  (1UL << 4)
#define O_PROGRAM    (1UL << 5)
#define O_MSGCHAN    (1UL << 6)

/* blob-only modifiers (rejected unless O_BLOB is set) */
#define O_BLOB_CREAT  (1UL << 8)
#define O_BLOB_EXCL   (1UL << 9)
#define O_BLOB_TRUNC  (1UL << 10)
#define O_BLOB_APPEND (1UL << 11)
```

`O_ACC_NONE` is only valid with `O_PROGRAM` (spawn-only capability).
`O_DIRECTORY` is required to obtain a dirfd. `O_PROGRAM` is required to
obtain an fd HC_SPAWN will accept. `O_OBJECT` enables the
HC_OBJ_PROP_* hypercalls. `O_MSGCHAN` opens a message channel.

### HC_OPENAT path resolution

Path is relative to the dirfd's bound prefix.

- NULL, empty, `"."`, and a leading `"/"` mean root of the dirfd's scope.
- `".."` is rejected (`-EINVAL`). Dirfds are prefix-scoped. A task
  wanting a parent view must be granted a dirfd to the parent.
- `"//"` collapses to `"/"`.

Any attempt to make the colon-prefix parser "smart" (walking paths,
inferring a default drive, normalizing `..`) reintroduces ambient
authority and should be stopped at review. The colon syntax is UI
convenience; the dirfd is the authority.

### Object property hypercalls

```
HC_OBJ_PROP_GET:  read a single property value into a buffer.
                  -ERANGE + required length if buffer too small.
HC_OBJ_PROP_PUT:  request a property write (see Object Writes).
HC_OBJ_PROP_LIST: enumerate child keys under a path.
```

Property paths are dot-separated with optional quoting:
`name`, `stats.hp`, `"key with spaces"."nested.key"`.

## Object Writes

This is the section the multicore target most changes, and it replaces
the earlier "implicit transactions, commit on yield" model.

The persistent store is LMDB. LMDB permits **exactly one write
transaction at a time per environment**, with any number of concurrent
MVCC readers. On a multicore scheduler, an implicit "first write opens a
transaction that commits on preemption" model does not work: two tasks
on two cores cannot both hold an open write transaction, and holding one
across a scheduling quantum serializes every writing task behind one
lock for the length of its quantum. The scheduler's parallelism would
evaporate for exactly the workloads that write.

The model instead is **single writer per domain**:

- **Reads are direct and parallel.** Guest tasks read object properties
  through short-lived MVCC read transactions. LMDB parallelizes these
  across cores with no contention. HC_OBJ_PROP_GET and HC_OBJ_PROP_LIST
  resolve this way.
- **Writes go through the domain's owner task.** Each writable domain
  (`area:`, `world:`, and so on) has one trusted service task that holds
  the write transaction for that domain. A guest that wants to mutate a
  property sends a message to that owner. HC_OBJ_PROP_PUT is, for
  non-private domains, sugar over a message send to the owner: the guest
  expresses a write, the libc turns it into an RPC, the owner validates,
  applies, and replies.
- **Private domains are exempt.** `tmp:` is per-task RAM with no sharing
  and no transaction. A task's own scratch storage needs none of this.

This makes messaging load-bearing rather than optional, and it is why
routing typed-domain access through service tasks (which the earlier
draft treated as a stopgap for "domains without direct hypercalls") is
actually the concurrency architecture. One owner per domain is a clean
serialization point that matches LMDB's single-writer constraint instead
of fighting it.

Write visibility and atomicity are defined by the owner: a write is
visible to other tasks once the owner commits, and the owner batches or
serializes as it sees fit. Guests do not observe partial writes and do
not depend on commit-on-yield timing.

## Scheduler

Multicore from the start. Per-core runqueues with work stealing across
the MUD's worker cores. A task has a home-core affinity hint but may be
stolen. Because task guest state is per-instance and unshared, a task
can run on any core without guest-visible effect; only host-side shared
structures (the reply-handle table, the sleep structure, per-domain
owners) need synchronization, and those are off the per-instruction hot
path.

### Credits: the unit of CPU accounting

A **credit** is an abstract unit of work charged to a task. One cheap CF
instruction costs 1 credit; a hypercall carries a larger weight from a
host-side `credit_cost[hc_id]` table. The weight approximates "how much
does this cost the server to service."

The `credit_cost[]` table lives host-side, loaded from configuration,
and is explicitly not part of the ABI. Programs cannot inspect or depend
on specific weights.

Charging happens in two places. `cf_run` increments the credit counter
by 1 per plain CF instruction. The hypercall dispatch handler adds
`credit_cost[hc_id]` before returning. Three thresholds use the same
unit:

- **`CREDIT_BUDGET`** -- credits per quantum before preemption.
  Preemption returns the task to a runqueue; it is not a kill.
- **`credits_used`** -- lifetime counter in `task_t`.
- **`CREDIT_LIMIT_TOTAL`** -- lifetime cap. Crossing it kills the task.
  The runaway backstop.

Note the current prototype implements none of this: `cf_cpu.cycles` is
incremented and read nowhere, and the tick loop runs a flat instruction
count per task with no budget carried across ticks. Credits are gate
item 3.

```
sched_tick(core):
    while local_runqueue not empty and tick_budget > 0:
        t = dequeue local_runqueue (or steal from a busy core)
        rc = cf_run(&t->vm.cpu, CREDIT_BUDGET)
        t->credits_used += rc.spent
        if t->vm.cpu.fault: kill(t); continue
        if t->credits_used >= CREDIT_LIMIT_TOTAL: kill(t); continue
        switch t->state:
            RUNNABLE:   enqueue (round-robin)
            SLEEPING:   insert into sleep structure by wake_tick
            BLOCKED:    leave on message/reply waitlist
            DEAD:       task_free(t)
    drain sleep entries with wake_tick <= now into runqueues
```

Start values (measure and tune): `CREDIT_BUDGET` = 10000,
per-tick task cap = 256, `CREDIT_LIMIT_TOTAL` = 1<<30.

## Messaging (synchronous send/receive/reply)

The send/receive/reply shape is inspired by microkernel message passing,
but the implementation is our own. Do not read the names below as any
particular kernel's semantics.

```
HC_MSG_SEND:  blocking RPC. Caller blocks until the receiver replies or
              the timeout expires. Reply lands in the caller's buffer.
HC_MSG_POST:  fire-and-forget. Queued on the target channel; no reply.
HC_MSG_RECV:  block on a message channel until a message arrives.
HC_MSG_REPLY: reply to a pending sender, unblocking it.
```

Message sends may optionally carry an fd in the payload, SCM_RIGHTS
style: the sender's fd is resolved at send time and the receiver gets a
new fd in its own table. Revocation is close. A builder can write a
service task that accepts a cap to a caller's `local:`, works on it, and
the caller revokes by closing, with no ambient trust between them.

### Reply handles

A reply handle is a token the receiver passes to HC_MSG_REPLY to unblock
the original sender. Handles are 64-bit random tokens in a system-wide
hash table, not per-task state. Two properties drive this:

1. **Concurrency-safe.** On a multicore host, sender and receiver may
   run on different cores. A shared table with proper synchronization is
   the handoff point; a bare task pointer is not safe to pass around.
2. **Delegatable and unforgeable.** A receiver can hand the reply handle
   to a helper task, which replies on the original receiver's behalf.
   Because the handle travels through message payloads as a plain value,
   it is a bearer token: it must be unguessable, or a task could forge a
   reply to a transaction it never received and unblock an arbitrary
   sender with a chosen status. 64 bits of randomness, against a
   credit-limited guesser and a reaper that expires handles, is
   sufficient. The randomization is justified by delegation, not by core
   count.

A single reaper scans the table (30-300s configurable) and unblocks
timed-out senders with `-ETIMEDOUT`.

Open question: whether reply delegation is needed at freeze time at all.
If it is not, the bearer-token requirement goes away and handles can be
validated table slots instead of random tokens. Decide this with the
messaging work rather than assuming the more general design.

## Capabilities and Filesystem

The VM has no ambient `open()`. No root filesystem, no `cwd`, no resolver
that walks from `/`. All access goes through typed hypercalls that take a
dirfd, and a task can only name a dirfd in its fd table.

At task creation the host populates the fd table with a set of initial
capabilities, one dirfd per domain the task may touch. That fd table is
the entire security boundary.

### Typed domains vs blob domains

muddb domains are typed interfaces, not generic filesystems. Two domains
are byte-level blob stores:

- `tmp:` -- RAM, per-task, private.
- `bin:` -- muddb-backed persistent blob store for programs, source, and
  build artifacts. The one place `fread`/`fwrite` semantics exist.

A dirfd carries a domain type tag. Blob hypercalls (HC_READ, HC_WRITE)
accept only blob-domain fds. Object domains use HC_OBJ_PROP_* on
O_OBJECT fds. Other typed domains are reached through messaging to their
owner tasks.

### Standard domains

| Prefix     | Type    | Lifetime           | Backing          | Notes                                    |
|------------|---------|--------------------|------------------|------------------------------------------|
| `tmp:`     | blob    | task               | RAM              | Private per-task. Reaped on exit.        |
| `bin:`     | blob    | persistent         | muddb            | Programs, source, build artifacts.       |
| `obj:`     | object  | persistent         | muddb            | Read direct; write via owner.            |
| `session:` | typed   | user session       | muddb (volatile) | Shared across tasks in the session.      |
| `local:`   | typed   | owner (persistent) | muddb            | Per-player persistent storage.           |
| `area:`    | typed   | persistent         | muddb            | The task's home zone. Usually RO.        |
| `world:`   | typed   | persistent         | muddb            | Shared world state. Privileged tasks.    |
| `service:` | msgchan | persistent         | host             | Well-known channels (globalchat, etc.).  |

### Capability discovery via env block

The syspage contains an env block (NUL-separated `KEY=value` pairs,
double-NUL terminated) that maps well-known names to fd numbers:

```
DIR_tmp=0
DIR_bin=3
OBJ_player=5
MSGCHAN_self=7
PROG_guard=9
```

`DIR_` for directories, `OBJ_` for object handles, `MSGCHAN_` for
channels, `PROG_` for program fds. The guest libc provides
`mud_getenv(key)`. The env block is just bytes in the syspage, no
structured record to version.

### Capability delegation

HC_SPAWN takes a program fd plus a list of `(dirfd, flags)` pairs the
parent grants the child. The host validates every dirfd against the
parent's fd table, clamps flags (a child never gets more than the
parent), and installs them as the child's initial caps. Narrowing by
attenuation: a parent holding `local:` RW can hand the child `local:` RO
or a subdirectory dirfd.

## Snapshot / Restore

The earlier draft claimed the snapshot is `memcpy(cf_cpu) + memcpy(RAM)`.
That is wrong, and correcting it is why snapshotting is deferred until
the architecture settles rather than specified now.

Task state is spread across several places, only two of which are the
CPU and guest RAM:

- **CPU registers** -- in `cf_cpu`, but that struct also holds host
  function pointers (`read8`, `hypercall`, `bus_ctx`, `hypercall_ctx`)
  that are meaningless after a reload and must be rebuilt, not restored.
- **Guest RAM** -- the RAM block, straightforward to serialize.
- **fd table** -- `struct machine_file` entries, host-side, holding
  types, strdup'd verb names, and host callback pointers. Not in guest
  RAM.
- **Capability table** -- the `(domain handle, prefix, type, flags)`
  backing each guest fd integer. Host-side. On restore, re-resolved by
  name: domains that still exist return the same fd, deleted domains
  return a closed fd that yields `-EBADF` on use.
- **tmp ramdisk** -- per-task heap, host-side, freed in `task_free`.
- **In-flight messaging** -- a task blocked in HC_MSG_SEND is waiting on
  a reply handle in the system-wide table, not on its own state. On
  restore, stale handles are expired and the sender is unblocked with
  `-EINTR`; the sender must retry.

A real snapshot serializes all of the above and rebuilds the host-side
pointers on restore. The syspage is recreated at its fixed address with
the layout the guest was built against, so guest-held pointers into
argv/environ stay valid. This is genuinely useful (a quest script
surviving a reboot is something Wasm cannot easily match, since its
runtime-internal state is not part of the spec), but it is not a memcpy,
and it is not worth building until the fd table, cap table, and tmp
policy are stable.

## Syspage

Read-only page at a fixed guest address, mapped readable but not
writable by the VM. Distinct from task RAM and from `tmp:`.

### Layout

```
syspage_header  { layout_major, layout_minor, size }
live data       task_id, owner_id, session_id, current_tick,
                argc, argv_ptr, ulimits, env_block_ptr, env_block_len
env block       NUL-separated KEY=value pairs (double-NUL terminated)
```

Host updates live data in place; the guest reads it as plain loads. No
hypercall is needed to ask the tick. `current_tick` is a single global
monotonic counter (not per-core), so a plain guest load of it is always
meaningful under the multicore scheduler.

The earlier draft's "text area" of host-shipped helper code, exported
through an ELF-symbol-versioning scheme (a renamed `.gnu.version_r`,
GOT patching at load), is dropped for now. That machinery buys "upgrade
host helpers without rebuilding programs," which only matters once
programs ship separately from the host. Pre-freeze, helpers are plain
static library code linked into each program, or fixed syspage
addresses. The symbol-versioning story returns with the
program-distribution story, after the freeze, if it is needed at all.

## Loader

ELF loader for big-endian 32-bit M68K:

1. Parse `PT_LOAD` segments and copy them into task RAM.
2. Set PC to the entry point.
3. Reject anything with non-LOAD segments that touch executable memory.

Program versioning is deferred to the freeze. Pre-freeze there is no
version note to check: the host and every program build from one tree.
When the freeze lands, the loader gains a single monotonic version check
(refuse on mismatch) and nothing more elaborate until independently
distributed binaries exist to justify it.

The context block the host writes before verb dispatch currently lands
at a fixed guest address. The linker script must reserve that region and
the host must validate the program does not occupy it, so dispatch does
not clobber guest code or data.

## GDB Stub (deferred)

m68k remote serial protocol. Breakpoints via `illegal` (0x4AFC) patching,
park the task in TASK_DEBUGGING so the scheduler skips it. Unix socket
per task, gated by wiz permission. Not needed before the freeze.

## Guest Language Support

C is the baseline and the only language the guest SDK targets today.
Other GCC frontends have been shown to cross-compile to bare-metal
ColdFire in experiments (C++ with `-fno-exceptions -fno-rtti` is
byte-identical to C; Fortran via `ISO_C_BINDING` needs only a `_start`
shim; Ada, Modula-2 need small runtime ports). This is evidence that the
toolchain is not a dead end, not a commitment to support them. Adding a
language means providing an entry-point shim that works with the syspage
and env block, not porting a whole runtime.

Interpreted VMs can run as CF guests (doubly sandboxed: the language VM
enforces its own discipline, the emulator catches escapes). Lua 5.4
(~24 KLOC + newlib) is the most likely first, with QuickJS as the path
to TypeScript. None of this is on the critical path.

## What We Give Up vs Wasm

- Load-time validation guarantees (runtime traps suffice for
  semi-trusted builders).
- FP determinism across hosts (single host; drop in SoftFloat if ever
  needed).
- Spec stability and adversarial audit pedigree (the real cost; we are
  the sole maintainer, mitigated by seccomp and fuzzing).
- Portable artifacts (single-host MUD).

## Pre-Freeze Work List

In priority order, by risk retired. Detailed cards live in `kanban/`.

1. **Unprivileged execution + faulting bus** (gate item 1). Run the
   guest in user mode, place the supervisor vector table and syspage in
   host-controlled memory, make out-of-range bus access raise an access
   error. This is foundational; everything else sits on it.
2. **Single-writer-per-domain write model** (gate item 2). Prove
   parallel MVCC readers plus one owner task per writable domain, under
   real multicore load. This most shapes the eventual ABI.
3. **Credits and the multicore scheduler** (gate item 3). Per-core
   runqueues, work stealing, per-instruction and per-hypercall charging,
   preemption, the lifetime runaway kill.
4. **Capability / dirfd model** (gate item 4). Replace the two hardcoded
   `verb:`/`event:` prefixes with dirfd-scoped access, intent flags, and
   delegation.
5. **Scheduler-integrated verb dispatch.** Move dispatch off the inline
   command path onto the scheduler.
6. **Pick one multiplexing primitive** (HC_WAIT or HC_SELECT).
7. **Snapshot format** once the fd table, cap table, and tmp policy are
   stable.

Deferred until the freeze or later: program versioning, symbol-versioned
syspage helpers, GDB stub, typed hypercalls for non-obj domains,
multi-thread-per-task.

## Estimated Effort

Rough host-C estimates, to be revised as the spikes land:

- Unprivileged execution + faulting bus + syspage/vector layout: ~250 LOC.
- Single-writer-per-domain write model + owner tasks: ~400 LOC.
- Credits + multicore scheduler: ~500 LOC.
- Capability model + env block + HC_OPENAT flag validation: ~300 LOC.
- Messaging (send/recv/reply, reply table, reaper): ~400 LOC.
- Object property read path + PUT-as-RPC sugar: ~250 LOC.
- ELF loader (done) + monotonic version check at freeze: ~50 LOC.
- Guest `mud.h` shim: ~300 LOC.

[1]: https://wiki.freepascal.org/m68k
[2]: https://lcamtuf.coredump.cx/afl/
[3]: https://www.fourmilab.ch/atlast/
