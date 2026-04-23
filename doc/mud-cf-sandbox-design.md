# MUD ColdFire Sandbox -- Design Doc

::: aside
**Status: DRAFT.** This document describes v1 -- the first forward-compatible
ABI freeze -- but several v1 items are still being finalized (see **Open
Items**). v0 (the throwaway proof-of-concept) has a much smaller scope;
v1 is what gets the freeze discipline.
:::

## Introduction

This document describes a script sandbox for the boris MUD server
built on a ColdFire V4e CPU emulator (~2200 LOC). Each
script, NPC, or area runs in its own emulator instance with private
RAM. Guest code communicates with the host through LINE_A opcodes
(0xAxxx), which trap into a fixed set of 22 hypercalls -- the v1
frozen ABI. Isolation comes from user-mode trapping, bus callback
bounds checking, seccomp on the host process, and credit-budget
preemption, not from language-level guarantees.

There is no ambient filesystem. A task starts with a set of directory
file descriptors in its fd table, and that fd table is the entire
security boundary. HC_OPENAT takes a dirfd, a path, and intent flags
(O_BLOB, O_OBJECT, O_MSGCHAN, etc.) and returns a capability-scoped
fd. Parents delegate narrowed capabilities to children at spawn time.
There is no mechanism by which a task can manufacture a dirfd it was
not granted.

Tasks communicate through QNX-style synchronous message passing.
HC_MSG_SEND blocks the caller until the receiver replies or a timeout
expires. Reply handles are 64-bit random tokens in a global hash
table -- delegatable to helper tasks, with a single reaper for
timeout expiry. Message passing is also how tasks reach typed domains
(user:, area:) that have no direct hypercalls in v1: a trusted
service task owns the domain and accepts requests on a message
channel.

The scheduler charges one credit per CF instruction and a weighted
cost per hypercall from a tunable host-side table. Three thresholds
govern execution: a per-quantum budget (preemption), a lifetime
counter (accounting), and a lifetime cap (kill runaways). The
scheduler runs single-threaded on one RPi5 core with cooperative
yielding and forced preemption -- the same mechanism Erlang/BEAM uses
under the name "reductions."

Task state snapshots are a memcpy of the CPU registers plus the RAM
block. Write that to disk and the script hibernates across server
reboots. The syspage address is frozen so guest pointers stay valid
on restore; in-flight message sends are unblocked with -EINTR. This
is the key practical advantage over Wasm, where runtime-internal
state (stack, locals) is not part of the spec and cannot be
portably serialized.

## Release Plan

- **v0 -- proof-of-concept.** Throwaway ABI. Goal is end-to-end wire-up:
  boot the emulator under the host, dispatch a handful of hypercalls
  (`HC_ABORT`, `HC_EXIT`, `HC_PRINT`, `HC_YIELD`, `HC_SLEEP`), load a
  `PT_LOAD`-only ELF, run "hello world" to completion. No capability
  model, no syspage, no ABI versioning, no credits. Programs built for
  v0 get discarded when v1 lands. The point is to de-risk the big v1
  commitments by proving the basic shape works first.
- **v1 -- first frozen ABI.** Everything described in this document.
  Freeze discipline applies: IDs never reassigned, register conventions
  never change, structured records append-only. Forward-compatible from
  here on.
- **v2 -- deferred from v1.** Root-bounded `..` in paths, selective-peek
  message channel semantics if we find we need them, typed hypercalls for
  non-obj domains (`user:`, `area:`, ...), multi-core scheduler, GDB
  stub, multi-thread-per-task.
- **v3 -- unplanned re-architecture.** Optimistically never.

## Goal

Embed the ColdFire V4e CPU emulator (`coldfire.{c,h}`, ~2200 LOC) as
the script sandbox for a MUD server. Each connected
script/area/NPC runs in its own CF VM instance, scheduled cooperatively
by the host with credit-budget preemption.

Rejected alternatives: Q3VM (limited tools; cumbersome instruction indices),
Wasm (heavyweight; validation guarantees not needed), LuaJIT (sandboxing
weaknesses), pure Lua (no preemption).

## Why ColdFire

- **Tooling.** `m68k-linux-gnu-gcc` 14, binutils, gdb, newlib, libstdc++,
  Ada (gnat), Fortran (gfortran), [FreePascal][1]. Builders write in any
  language with an m68k backend.
- **FFI ergonomics.** LINE_A opcodes (0xAxxx, ~4096 slots) trap to a host
  hypercall handler with full register access. No i32-only marshaling.
- **Isolation.** Per-instance `cf_cpu` + bus callbacks bound to a private
  RAM block. Equivalent to wasm3's per-instance pattern.
- **Preemption.** `cf_run(cpu, count)` returns after `count` instructions.
  No timer interrupts needed.
- **Debuggability.** GDB remote serial protocol is ~300-500 LOC bolted
  onto coldfire.c. Live-debug a running script from a developer laptop.
- **Retro flavor.** Builders can write 68k assembly if they want to.

Host: Raspberry Pi 5, quad-core, 3 cores idle. Interpretation overhead
(50-200M emulated insns/sec/core) is irrelevant.

## Trust Model

Builders are semi-trusted (granted a builder-access bit). Threats are runaway
loops, memory exhaustion, accidental sandbox escape via emulator bugs.
Defense in depth:

1. CF user-mode (CF_SR_S clear) traps privileged instructions.
2. Bus callbacks reject out-of-range addresses.
3. Credit budget caps CPU per task per quantum; `MAX_TASKS_PER_TICK`
   bounds the tick as a whole.
4. Per-task RAM cap (start at 64KB, tune).
5. Run MUD as dedicated unprivileged user.
6. seccomp profile on the MUD process -- even an emulator escape can't
   make syscalls outside an allowlist.
7. [AFL][2]-fuzz coldfire.c against random instruction streams before
   exposing to builders.

## Terminology

- **program** (`program_t`) -- an ELF blob plus metadata. Owned by muddb or
  content-addressable storage, thawed from storage on demand. A program is
  inert code; you need one to create a VM state. Multiple tasks can share a
  program; if the loader marks text RO, that RAM region can be COW-shared
  across tasks running the same program.
- **vm state** (`vm_state_t`) -- CPU + registers + RAM + bus callback
  table. One per task. May reference a program's text region via COW.
- **task** (`task_t`) -- a running instance. Owns a `vm_state_t`, an fd
  table, a private `tmp:` ramdisk, and references to persistent domains
  it holds caps for. A program can be instantiated into N independent
  tasks; they share no state beyond (optional) COW text.

The scheduler operates on tasks, not programs. The word "script"
survives only as informal shorthand for "a program someone wrote for
the MUD."

## Per-Task State

```c
typedef enum {
    TASK_RUNNABLE,
    TASK_BLOCKED,    /* waiting on message send/recv/reply */
    TASK_SLEEPING,   /* wake at wake_tick */
    TASK_DEBUGGING,  /* gdb breakpoint */
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
    uint32_t      blocked_on;        /* reply handle or message channel fd */
    fd_table_t    fds;               /* caps; see Capabilities section */
    uint8_t      *tmp_ram;           /* tmp: ramdisk, reaped in task_free */
    uint32_t      tmp_size;
    struct task  *next;              /* runqueue link */
} task_t;
```

Per-task overhead ~65 KB (RAM dominates). 1000 tasks ~ 64 MB.
Comfortable on RPi5.

## Hypercall ABI

Hypercalls are LINE_A opcodes (`0xAxxx`). The low 12 bits carry a flat
enum of hypercall IDs -- no reserved ranges, no domain grouping in the
opword. The opword for HC ID `n` is `0xA000 | n`. See **ABI Versioning**
for how clients declare which IDs they use.

Return values and fd/errno results are `int16_t` throughout. File
descriptors are non-negative; errors are negated errno values. Per-task
fd cap is 127.

### v1 frozen set

The table below is the v1 ABI freeze. Per the freeze policy in **ABI
Versioning**, these IDs never get reassigned and their register
conventions never change. New hypercalls are appended at higher IDs.
Removing or changing a frozen ID requires an `abi_major` bump.

| ID | Opword | Name              | Summary                       |
|----|--------|-------------------|-------------------------------|
| 0  | 0xA000 | HC_ABORT          | immediate task death          |
| 1  | 0xA001 | HC_TRAP           | debug trap                    |
| 2  | 0xA002 | HC_YIELD          | voluntary preemption          |
| 3  | 0xA003 | HC_SLEEP          | sleep for N ticks             |
| 4  | 0xA004 | HC_EXIT           | clean exit                    |
| 5  | 0xA005 | HC_PRINT          | debug output                  |
| 6  | 0xA006 | HC_SPAWN          | create child task             |
| 7  | 0xA007 | HC_OPENAT         | open fd from dirfd + path     |
| 8  | 0xA008 | HC_CLOSE          | close fd                      |
| 9  | 0xA009 | HC_READ           | read bytes (blob only)        |
| 10 | 0xA00A | HC_WRITE          | write bytes (blob only)       |
| 11 | 0xA00B | HC_READDIR        | directory listing             |
| 12 | 0xA00C | HC_STAT           | stat fd                       |
| 13 | 0xA00D | HC_UNLINK         | remove entry (ACL-gated)      |
| 14 | 0xA00E | HC_OBJ_PROP_GET   | get object property           |
| 15 | 0xA00F | HC_OBJ_PROP_PUT   | set object property           |
| 16 | 0xA010 | HC_OBJ_PROP_LIST  | list object properties        |
| 17 | 0xA011 | HC_SELECT         | wait on multiple fds          |
| 18 | 0xA012 | HC_MSG_SEND       | synchronous RPC send          |
| 19 | 0xA013 | HC_MSG_POST       | fire-and-forget message       |
| 20 | 0xA014 | HC_MSG_RECV       | receive on message channel    |
| 21 | 0xA015 | HC_MSG_REPLY      | reply to received message     |

Groups: sentinel/debug (0--1), task lifecycle (2--4), debug output (5),
spawn (6), FS universal (7--8), blob I/O (9--10), FS metadata (11--13),
object properties (14--16), multiplexing (17), messaging (18--21).

**HC_ABORT at ID 0** is deliberate: a LINE_A opcode whose low 12 bits
are zero means "something went catastrophically wrong." Default-zeroed
registers dispatched as a hypercall trigger abort rather than an
arbitrary operation. Immediate task death, no cleanup, host logs a
fatal. Guest code uses it for `panic()` / unrecoverable asserts.

**HC_TRAP at ID 1** is a debug trap. The task enters `TASK_DEBUGGING`
and waits for an attached debugger. If none is attached (or wiz
permission isn't granted), the host treats it as HC_ABORT. `d0`
carries an application-supplied trap code for the debugger to read.
Reserved for asserts, breakpoints synthesized by the guest (distinct
from the GDB stub's `illegal`-instruction breakpoint patching), and
similar diagnostic stops.

### Register convention

Hypercall register assignments follow the 68k architecture's natural
data/address split: integer and size arguments fill d0, d1, d2, d3
in declaration order; pointer arguments fill a0, a1, a2 in
declaration order. Every hypercall returns its result in d0. The two
sequences are independent -- a call taking two pointers and one
integer uses a0, a1, d0 regardless of how the arguments are ordered
in the C prototype.

This matches the register-parameter convention that
`m68k-linux-gnu-gcc` generates with `__attribute__((regparm))`.
Aligning with the compiler's output has three consequences:

1. **Each hypercall IS a C prototype.** `HC_OPENAT` is
   `int mud_openat(int dirfd, const char *path, int flags)`. The
   register assignments add nothing the prototype doesn't already
   say -- `dirfd` is `int` so it goes in d0, `path` is a pointer so
   it goes in a0, `flags` is `int` so it goes in d1. Return in d0.
2. **Debug wrappers are trivial.** A host-side shim for any hypercall
   is a C function with the same prototype and a register-parameter
   annotation. The compiler places arguments in exactly the registers
   the guest expects.
3. **ABI documentation is the header file.** The `mud.h` guest header
   carries C prototypes; the register table below is a redundant
   quick-reference. If a prototype and the table ever disagree, the
   prototype wins.

Caller-saved registers are d0, d1, a0, a1. Hypercalls may clobber
these. All other registers (d2--d7, a2--a6) are callee-saved per the
standard m68k convention. In practice, arguments passed via d2/d3/a2
are consumed by the hypercall and should be treated as clobbered by
the caller.

64-bit values (e.g., reply handles) are passed by pointer, not by
register pair. This avoids d0:d1 pairing awkwardness and keeps the
upgrade path clean -- widening a pointed-to type from `uint64_t` to
a 128-bit struct changes no register conventions (see **Reply handle
sizing** in the Messaging section).

#### Full register map

```
HC_ABORT(0):          (no args)                                              -> (no return)
HC_TRAP(1):           d0=trap_code                                           -> (no return)
HC_YIELD(2):          (no args)                                              -> (no return)
HC_SLEEP(3):          d0=ticks                                               -> (no return)
HC_EXIT(4):           d0=status                                              -> (no return)
HC_PRINT(5):          d0=len, a0=str                                         -> d0=0/-errno
HC_SPAWN(6):          d0=prog_fd, d1=cap_count, a0=cap_array                 -> d0=task_id/-errno
HC_OPENAT(7):         d0=dirfd, d1=flags, a0=path                            -> d0=fd/-errno
HC_CLOSE(8):          d0=fd                                                  -> d0=0/-errno
HC_READ(9):           d0=fd, d1=count, a0=buf                                -> d0=n/-errno
HC_WRITE(10):         d0=fd, d1=count, a0=buf                                -> d0=n/-errno
HC_READDIR(11):       d0=fd, d1=buf_cap, a0=buf, a1=&count                   -> d0=0/-errno
HC_STAT(12):          d0=fd, a0=stat_buf                                     -> d0=0/-errno
HC_UNLINK(13):        d0=dirfd, a0=path                                      -> d0=0/-errno
HC_OBJ_PROP_GET(14):  d0=fd, d1=flags, d2=buf_cap, a0=key, a1=buf, a2=&len  -> d0=0/-errno
HC_OBJ_PROP_PUT(15):  d0=fd, d1=flags, d2=data_len, a0=key, a1=data         -> d0=0/-errno
HC_OBJ_PROP_LIST(16): d0=fd, d1=buf_cap, a0=path, a1=buf, a2=&count         -> d0=0/-errno
HC_SELECT(17):        d0=fd_bitmask, d1=timeout, a0=fd_array                 -> d0=index/-errno
HC_MSG_SEND(18):      d0=target_fd, d1=msg_len, d2=reply_cap, d3=timeout,
                      a0=msg, a1=reply_buf, a2=&reply_len                    -> d0=status/-errno
HC_MSG_POST(19):      d0=target_fd, d1=msg_len, a0=msg                      -> d0=0/-errno
HC_MSG_RECV(20):      d0=ch_fd, d1=buf_cap, d2=timeout,
                      a0=buf, a1=&reply_handle, a2=&recv_len                 -> d0=0/-errno
HC_MSG_REPLY(21):     d0=status, d1=reply_len,
                      a0=reply_buf, a1=&reply_handle                         -> d0=0/-errno
```

HC_MSG_RECV and HC_MSG_REPLY share a1=&reply_handle by design. After
receiving a message, the guest transitions to reply without moving
the handle pointer between registers.

### Capability-flag model

HC_OPENAT flags in `d1` express the caller's intent and become the
capability on the returned fd. The flags are orthogonal: a 2-bit
access-mode enum plus independent family bits.

```c
/* access mode: 2-bit enum in bits [1:0] */
#define O_ACCMODE    0x3
#define O_ACC_NONE   0x0   /* no data access; valid only with O_PROGRAM */
#define O_RDONLY     0x1
#define O_WRONLY     0x2
#define O_RDWR       0x3

/* family bits: exactly one must be set */
#define O_BLOB       (1UL << 2)   /* 0x04 */
#define O_OBJECT     (1UL << 3)   /* 0x08 */
#define O_DIRECTORY  (1UL << 4)   /* 0x10 */
#define O_PROGRAM    (1UL << 5)   /* 0x20 */
#define O_MSGCHAN    (1UL << 6)   /* 0x40 */

/* blob-only modifiers (rejected unless O_BLOB is set) */
#define O_BLOB_CREAT  (1UL << 8)
#define O_BLOB_EXCL   (1UL << 9)
#define O_BLOB_TRUNC  (1UL << 10)
#define O_BLOB_APPEND (1UL << 11)
```

`O_ACC_NONE` is only valid with `O_PROGRAM` -- it produces a
spawn-only capability (the task can launch the program but cannot read
its bytes). Any other family with `O_ACC_NONE` returns `-EINVAL`.

`O_DIRECTORY` -- required to obtain a dirfd for use with HC_OPENAT,
HC_READDIR, HC_UNLINK. Without it, resolving to a prefix returns
`-ENOTDIR`; with it, resolving to a leaf returns `-EISDIR`.

`O_PROGRAM` -- required to obtain an fd that HC_SPAWN will accept.
Capability equivalent of the Unix x-bit, expressed at open-intent
time. Host validates the `NT_MUD_ABI` note at open time, so
unloadable programs fail fast.

`O_OBJECT` -- enables the HC_OBJ_PROP_* hypercalls on the returned
fd. Only valid for fds opened from typed obj-domain dirfds.

`O_MSGCHAN` -- opens a message channel for HC_MSG_RECV. See
**Messaging** below.

(Open: whether blob domains carry an on-disk x-bit that `O_PROGRAM`
checks against, or whether `O_PROGRAM` only validates the ELF header
and ABI note at open time. Either works; decision deferred.)

### HC_OPENAT path resolution

```
HC_OPENAT: d0=dirfd, a0=path, d1=flags -> d0=fd or -errno
```

Path is relative to the dirfd's bound prefix. Resolution rules:

- NULL, empty string, `"."`, and a leading `"/"` all mean root of
  the dirfd's prefix scope.
- `".."` is rejected (`-EINVAL`). Dirfds are prefix-scoped; path
  traversal is the usual way these APIs leak authority. A task wanting
  a parent view must be given a dirfd to the parent explicitly.
- `"//"` collapses to `"/"`.

### Property path syntax

Object properties use dot-separated paths. HC_OBJ_PROP_GET,
HC_OBJ_PROP_PUT, and HC_OBJ_PROP_LIST accept a property path in the
key argument. Sub-objects can also be opened as handles via HC_OPENAT
with O_OBJECT on an existing object fd.

```
path       = component ("." component)*
component  = unquoted | quoted
unquoted   = [^."\\[:cntrl:]]+
quoted     = '"' (escape | normal)* '"'
escape     = '\"' | '\\'
normal     = [^"\\]
```

Examples: `name`, `stats.hp`, `"key with spaces"."nested.key"`.

### Blob vs. typed

HC_READ / HC_WRITE apply only to blob-domain fds (`tmp:`, `bin:`).
HC_OBJ_PROP_GET / HC_OBJ_PROP_PUT / HC_OBJ_PROP_LIST apply only to
object-domain fds (fds opened with O_OBJECT from an obj: dirfd).
HC_READDIR works on both blob directories and object fds. On blob
directories it lists files; on object fds it lists **contents**
(sub-objects within the object). HC_OBJ_PROP_LIST, by contrast,
enumerates the properties of an object at the current level. The
distinction -- children vs properties -- is part of the v0
proof-of-concept; the final semantics may shift in v2. HC_STAT and
HC_UNLINK work on both blob and object fds but HC_UNLINK is ACL-gated
on typed domains.

### Object property hypercalls

```
HC_OBJ_PROP_GET:  d0=fd, a0=key, d1=flags, a1=buf, d2=buf_cap,
                  a2=out_len_ptr -> d0=0 or -errno
HC_OBJ_PROP_PUT:  d0=fd, a0=key, d1=flags, a1=data, d2=data_len
                  -> d0=0 or -errno
HC_OBJ_PROP_LIST: d0=fd, a0=path_or_null, a1=buf, d1=buf_cap,
                  a2=out_count_ptr -> d0=0 or -errno
```

HC_OBJ_PROP_GET reads a single property value into `buf`. If the
buffer is too small, returns `-ERANGE` and writes the required length
to `*out_len_ptr` so the caller can retry with a larger buffer.
`MUD_OPROP_LEN_ONLY` flag in `d1` skips the copy and only writes the
length -- useful for probing size before allocating.

HC_OBJ_PROP_PUT writes a property value. Data format is the
property's native serialization (JSON string for strings, binary for
binary properties).

HC_OBJ_PROP_LIST enumerates child keys under `path_or_null` (NULL
means root). Returns NUL-separated key names in `buf` and writes the
count to `*out_count_ptr`. Same `-ERANGE` semantics as
HC_OBJ_PROP_GET.

Object access uses implicit transactions: the first write in a
quantum opens a write transaction, which commits when the task
yields, sleeps, or is preempted. No explicit begin/commit hypercalls.

### Messaging (QNX-style synchronous)

Message passing follows the QNX MsgSend/MsgReceive/MsgReply pattern:
synchronous RPC with reply handles.

```
HC_MSG_SEND:  d0=target_fd, a0=msg, d1=msg_len, a1=reply_buf,
              d2=reply_cap, a2=&reply_len, d3=timeout_ticks
              -> d0=status or -errno
HC_MSG_POST:  d0=target_fd, a0=msg, d1=msg_len
              -> d0=0 or -errno
HC_MSG_RECV:  d0=ch_fd, a0=buf, d1=buf_cap, a1=&reply_handle,
              a2=&recv_len, d2=timeout_ticks
              -> d0=0 or -errno
HC_MSG_REPLY: d0=status, a0=reply_buf, d1=reply_len,
              a1=&reply_handle -> d0=0 or -errno
```

**HC_MSG_SEND** is a blocking RPC. The caller blocks until the
receiver calls HC_MSG_REPLY or the timeout expires. The reply lands
in `reply_buf`. The returned `status` is the value the receiver
passed to HC_MSG_REPLY's `d0`.

**HC_MSG_POST** is fire-and-forget. The message is queued on the
target's message channel; the sender does not block. No reply
expected.

**HC_MSG_RECV** blocks on a message channel fd (opened with
O_MSGCHAN) until a message arrives or the timeout expires. On return,
`*reply_handle` is a 64-bit opaque token the receiver must pass to
HC_MSG_REPLY. For HC_MSG_POST messages, `*reply_handle` is zero (no
reply expected). HC_MSG_RECV and HC_MSG_REPLY share a1=&reply_handle
-- after receiving, the guest transitions to reply without moving the
handle pointer between registers.

**HC_MSG_REPLY** sends a reply to a pending HC_MSG_SEND caller,
unblocking it. The reply handle is consumed on use.

#### Reply handle table

Reply handles are 64-bit random tokens stored in a global
(system-wide) hash table, not in per-task state. Three reasons for a
global table:

1. **Delegatable.** A receiver can pass the reply handle to a helper
   task via messaging; the helper replies on behalf of the original
   receiver. Per-task tables can't express this without a forwarding
   layer.
2. **Arbitrary routing.** The reply travels back through whichever
   task holds the handle, not necessarily the one that received the
   message. This lets service tasks fan out work.
3. **Simpler timeout.** A single reaper scans one table (30--300s
   configurable timeout) and unblocks senders with `-ETIMEDOUT`.
   Per-task tables need per-task reapers or a cross-task sweep.

#### Reply handle sizing

v0 and v1 use 64-bit handles. For sandboxed builders with
credit-limited guesses, 64 bits of randomness is sufficient -- an
attacker running at full credit budget cannot brute-force a handle
before the reaper expires it.

The ABI is designed so upgrading to 128-bit handles requires only a
header change, recompile, and `abi_minor` bump. Handles are always
passed by pointer (a1=&reply_handle), never in a register pair, so
widening the pointed-to type from `uint64_t` to a 128-bit struct
changes no register conventions. Programs built against the 64-bit
header continue to work until they encounter a handle that doesn't
fit, at which point the version check catches the mismatch.

**Example: globalchat SAY.** A player's task sends
`HC_MSG_SEND(globalchat_fd, "SAY Hello", 9, reply_buf, ...)`. The
globalchat service receives via HC_MSG_RECV, broadcasts the text to
all subscribers, and replies with a status code via HC_MSG_REPLY.

**Example: objmover transfer.** An NPC task sends
`HC_MSG_SEND(objmover_fd, transfer_request, len, ...)`. The objmover
service validates, moves the object between rooms, and replies with
success/failure.

### HC_SELECT

```
HC_SELECT: d0=fd_bitmask (32 bits), a0=32-entry int16_t array,
           d1=timeout_ticks -> d0=index of ready fd or -errno
```

Waits for any of the specified fds to become ready. The 32-bit
bitmask in `d0` selects which entries in the `int16_t` array are
active. Entry `i` is checked if bit `i` of `d0` is set. Returns the
index of the first ready fd, or `-ETIMEDOUT`.

This covers the "wait on message channel OR timer OR multiple services"
pattern without polling. There is no edge-triggered mode -- a ready
fd stays ready until consumed.

### Syspage, not hypercalls

Tick counter, task id, argv, and other introspective state live in
the **syspage** and are read as plain memory. There is no
`HC_GET_TICK`.

### Guest-side shim

```c
#define MUD_HC(id)  __asm__ volatile (".short 0xA000 | " #id ::: "memory")
static inline void mud_yield(void) { MUD_HC(HC_YIELD); }
static inline void mud_abort(void) { MUD_HC(HC_ABORT); __builtin_unreachable(); }
```

## Scheduler

Single-threaded scheduler on one MUD core. Other 2-3 RPi5 cores remain
free for MUD I/O, persistence, etc. (Multi-core scheduler is a v2
feature -- keep v1 simple.)

### Credits: the unit of CPU accounting

A **credit** is an abstract unit of work charged to a task. One cheap
CF instruction costs 1 credit; a hypercall carries a larger weight
from a `credit_cost[hc_id]` table. The weight approximates "how much
does this actually cost the server to service," not just instruction
count.

The `credit_cost[]` table lives host-side, loaded from configuration
(e.g., `boris.cfg`), and is explicitly *not* part of the ABI -- weights
can change across host versions without affecting program
compatibility. Programs can't inspect or depend on specific weights;
they only know that expensive calls cost more than cheap ones.

Charging happens in two places. `cf_run` increments a credit counter
by 1 per plain CF instruction executed. The hypercall dispatch handler
adds `credit_cost[hc_id]` to the same counter before returning to
`cf_run`. The scheduler reads the accumulated total on each quantum
return (`rc.spent` in the pseudocode below -- raw cycles plus hypercall
weights).

Three thresholds use the same unit:

- **`CREDIT_BUDGET`** -- credits per quantum before the scheduler
  preempts the task. Preemption is not a kill; the task goes back on
  the runqueue.
- **`credits_used`** -- lifetime counter in `task_t`. Advances every
  quantum by the credits spent that quantum.
- **`CREDIT_LIMIT_TOTAL`** -- lifetime cap. Crossing it kills the task.
  The runaway-loop backstop.

Using a weighted unit rather than raw instruction count means a task
that spams expensive hypercalls pays in proportion to the work it
creates for the host, not just the bytes of guest code it executes.

::: aside
Erlang/BEAM uses the same mechanism under the name "reductions" and
has run production telecom switches on it for decades. We borrow the
pattern and define credits as our own unit, free of the BEAM-specific
connotations.
:::

```
sched_tick():
    while runqueue not empty and tick_budget > 0:
        t = dequeue runqueue
        rc = cf_run(&t->vm.cpu, CREDIT_BUDGET)
        t->credits_used += rc.spent
        if t->vm.cpu.fault: kill(t); continue
        if t->credits_used >= CREDIT_LIMIT_TOTAL: kill(t); continue
        switch t->state:
            RUNNABLE:   enqueue runqueue (round-robin)
            SLEEPING:   insert sleep_heap by wake_tick
            BLOCKED:    leave on message/reply waitlist
            DEAD:       task_free(t)
    drain sleep_heap entries with wake_tick <= now into runqueue
```

Constants (start values, measure and tune):

- `CREDIT_BUDGET` = 10000 credits/quantum
- `MAX_TASKS_PER_TICK` = 256
- `CREDIT_LIMIT_TOTAL` = 1<<30 credits (kill runaways)

Hypercalls return a status code from the dispatch handler indicating
what state to put the task into (yield -> runnable, sleep -> sleeping,
msg_recv/msg_send -> blocked, exit -> dead).

## Capabilities and Filesystem

The VM has no ambient `open()`. There is no root filesystem, no `cwd`,
no resolver that walks from `/`. All access goes through typed
hypercalls that take a dirfd, and a task can only name a dirfd that
appears in its fd table.

At task creation the host populates the fd table with a set of
**initial capabilities** -- one dirfd per domain the task is permitted
to touch. That fd table is the entire security boundary. If a dirfd
wasn't granted, the domain is unreachable; there is no side channel
through which a task can manufacture one.

### Typed domains vs blob domains

muddb domains are typed interfaces, not generic filesystems. Each
domain speaks a specific record type via the interface in
`src/<domain>/<domain>.h`: `user:` returns user records, `obj:` returns
JSON objects, and so on. Only two domains are byte-level blob stores:

- `tmp:` -- RAM, per-task.
- `bin:` -- muddb-backed persistent blob store for programs, source,
  and build artifacts. The compromise that lets `fread`/`fwrite` exist:
  not every domain can back it, but `bin:` can.

A dirfd carries a *domain type tag* along with the domain handle and
key prefix. The blob hypercalls (HC_READ, HC_WRITE) only accept
blob-domain fds; the host returns `-EINVAL` otherwise. Object domains
(`obj:`) use the HC_OBJ_PROP_* hypercalls on fds opened with
O_OBJECT. Other typed domains (`user:`, `area:`, etc.) have no
guest-reachable hypercalls in v1 -- scripts reach those interfaces
via messaging to trusted service tasks (see **Messaging** in the
Hypercall ABI section).

### Drive prefixes are a UI convenience; dirfds are the capability

Guest code refers to domains by colon-prefixed name: `local:quests/dragon`,
`tmp:scratch.log`, `bin:npc/guard.prg`. The guest libc (`mud.h`) parses
the prefix, looks it up in the env block, and issues the appropriate
hypercall for that domain. The colon syntax is ergonomic for builders;
it carries no authority. Any attempt to "make the parser smart" --
walking paths, inferring a default drive, normalizing `..` -- is
reintroducing ambient authority and should be stopped at review.

### Capability discovery via env block

The syspage contains an env block (NUL-separated `KEY=value` pairs,
double-NUL terminated) that maps well-known names to fd numbers.
Discovery follows a getenv-style API:

```
DIR_tmp=0
DIR_bin=3
OBJ_player=5
MSGCHAN_self=7
PROG_guard=9
```

Prefixes encode the family: `DIR_` for directories, `OBJ_` for
object handles, `MSGCHAN_` for message channels, `PROG_` for
program fds.
The guest libc provides `mud_getenv(key)` to parse the env block.
This replaces the earlier `cap_entry[]` struct -- the env block is
just bytes in the syspage, no structured record to version.

### Standard domains

| Prefix     | Type    | Lifetime           | Backing          | Notes                                       |
|------------|---------|--------------------| -----------------|---------------------------------------------|
| `tmp:`     | blob    | task               | RAM              | Private per-task. Reaped on task exit.       |
| `bin:`     | blob    | persistent         | muddb            | Programs, source, build artifacts.           |
| `obj:`     | object  | persistent         | muddb            | Object properties via HC_OBJ_PROP_*.         |
| `session:` | (typed) | user session       | muddb (volatile) | Shared across tasks in the same session.     |
| `local:`   | (typed) | owner (persistent) | muddb            | Per-player persistent storage.               |
| `area:`    | (typed) | persistent         | muddb            | The task's home zone. Usually RO.            |
| `world:`   | (typed) | persistent         | muddb            | Shared world state. Privileged tasks only.   |
| `service:` | msgchan | persistent         | host             | Well-known message channels (globalchat, etc.). |

Two tasks spawned from the same program by the same user in the same
session each get a private `tmp:` and a shared `session:`. `tmp:`
isolation is absolute -- there is no hypercall by which one task can
name another task's `tmp:`.

### muddb domain resolution

A dirfd binds a domain handle plus a key prefix.
`HC_OPENAT(dirfd, "quests/dragon", flags)` on a blob dirfd resolves
to the key `<prefix>quests/dragon` within the domain. `HC_READDIR`
is a cursor scan over the prefix. `..` is rejected at the host --
dirfds are prefix-scoped, and path traversal is the usual way these
APIs leak authority. A task wanting a parent view must be given a
dirfd to the parent explicitly.

### `tmp:` implementation

A small heap attached to `task_t`, mapped into a fixed region of guest
RAM. The guest linker script exposes `_tmp_begin` and `_tmp_end`
symbols over that region so both the guest libc's `tmp:` driver and
external tooling (ptrace, the gdb stub) can locate it without host
cooperation. Classic, easy, inspectable.

Freed in `task_free()`. No persistence plumbing until the task-snapshot
design lands, at which point `tmp:` follows whatever policy tasks follow.

### Capability delegation

HC_SPAWN takes a program fd (opened from `bin:` or any other blob
dirfd that holds a valid `.prg`) plus a list of `(dirfd, flags)` pairs
the parent grants to the child. The host validates every dirfd against
the parent's fd table, clamps flags (a child never gets more
permission than the parent), and installs them as the child's initial
caps. A parent holding `local:` RW can give its child `local:` RO, or
can open a subdirectory dirfd and hand that over instead -- narrowing
by attenuation.

Message sends (HC_MSG_SEND, HC_MSG_REPLY) may optionally carry an fd
in the message payload in the same shape as `SCM_RIGHTS`: the
sender's fd is resolved at send time, the receiver gets a new fd in
its own table on receive. Revocation = close. This is where the
capability model earns its keep: a builder can write a service task
that accepts a cap to a caller's `local:`, works on it, and the
caller revokes by closing -- without any ambient trust between them.

### Snapshot interaction

A guest-visible fd is an integer; the host-side cap table maps it to
`(domain handle, prefix, type, flags)`. On restore, the host
re-resolves each cap by name. Domains that still exist return with
the same fd; domains that were deleted mid-hibernation (e.g., the
owner of a `local:` was removed) come back as a closed fd that returns
`-EBADF` on use. Guests handle this the same way they handle any
other revocation.

## ABI Versioning

Every `.prg` carries a PT_NOTE of type `NT_MUD_ABI` with the following
shape:

```c
struct mud_abi_note {
    uint16_t abi_major;      /* breaking changes */
    uint16_t abi_minor;      /* additive changes */
    uint16_t abi_patch;      /* doc/clarification only */
    uint16_t base_byte;      /* bitmap offset in bytes into the global HC space */
    uint16_t n_bytes;        /* bitmap length in bytes */
    uint8_t  bitmap[];       /* zero-padded up to a 4-byte boundary */
};
```

`base_byte` and `n_bytes` describe a byte-aligned window into the
global flat HC-ID space. A program using only high-numbered hypercalls
can start its window well into the space: `base_byte = 40, n_bytes = 6`
means "bits represent HC IDs 320..367, nothing below." Host
compatibility check:

```c
for (i = 0; i < prog->n_bytes; i++) {
    size_t host_idx = prog->base_byte + i;
    uint8_t host_byte = (host_idx < host_n_bytes) ? host_bitmap[host_idx] : 0;
    if ((host_byte & prog->bitmap[i]) != prog->bitmap[i]) return FAIL;
}
```

Bitmap storage is zero-padded up to a 4-byte boundary so the loop can
be unrolled into `uint32_t` compares later if profiling justifies it
(or a Duff's device). Byte-aligned `base_byte` and `n_bytes` keep the
check shift-free; the 0-7 bit waste is negligible.

**Freeze policy.** Once shipped:

- An HC ID never gets reassigned.
- An HC's register convention never changes.
- Structured records (stat, dirent) are append-only in existing
  layouts; new fields go on the end, old offsets never move.
- Breaking any of the above requires an `abi_major` bump.

`abi_major` mismatch = hard refusal at load. Bitmap-superset pass +
`abi_major` match = accepted even across `abi_minor`/`abi_patch`
differences.

## Syspage

Read-only page at fixed guest address `0x00001000`, mapped by the host
bus callbacks as readable but not writable by the VM. Distinct region
from task RAM and from `tmp:`. The name follows QNX's System Page
conventions -- a kernel-maintained shared page with live data and
fast-path helpers.

### Layout

```
0x00001000  syspage_header  { layout_major, layout_minor, size }
0x00001010  live data       task_id, owner_id, session_id,
                            current_tick, argc, argv_ptr, ulimits,
                            env_block_ptr, env_block_len
0x00001???  env block       NUL-separated KEY=value pairs (double-NUL terminated)
0x00001???  text area       versioned helper code
```

Header carries `{layout_major, layout_minor, size}`. Guest crt0 checks
these at task entry and refuses to run if the major is wrong.
Append-only discipline within a major -- old offsets never move.

### Live data

Host updates these in place; guest reads them as plain loads. No
hypercall is needed to ask what tick it is.

- `task_id`, `owner_id`, `session_id`
- `current_tick` -- incremented by the scheduler
- `argc`, `argv_ptr` -- pointers into syspage string table
- ulimits -- RAM cap, credit budget, etc.
- `env_block_ptr`, `env_block_len` -- pointer and length of the env
  block within the syspage. The env block is NUL-separated
  `KEY=value` pairs, double-NUL terminated (see **Capability
  discovery via env block** above).

`HC_GET_TICK` is gone. The tick is `*(uint64_t *)0x00001018` (or
wherever the layout puts it).

### Text area

Small helpers the host compiles per-build and ships as part of the
syspage. Exported as versioned symbols using an ELF-symbol-versioning
scheme (see **Loader** below).

Example helpers:

- `mud_domain_parse(path, &fd_out, &tail_out)` -- walks a
  `"local:foo/bar"` string, looks up the matching fd in the env block,
  and returns the fd plus the tail path.
- `mud_getenv(key)` -- scans the env block for `key` and returns the
  value pointer, or NULL.
- `mud_tick()` -- one-instruction load from the live-data area;
  exported as a function so its address is stable across layout shifts.
- formatters, simple helpers -- as the need arises.

The win is that upgrading the host can improve these without any
program rebuild. Builders link against versioned symbols; the loader
resolves them at program load.

### Hibernate/restore

Syspage address is frozen. On restore, the host recreates the syspage
at `0x00001000` with the same layout-major the guest was built
against. Guest-held pointers into argv/environ stay valid. If a host
upgrade has bumped the layout-major, restore fails with a clear error
and the task is either migrated through a rebuild or retired.

## Snapshot / Restore

`memcpy(&dst->cpu, &src->cpu, sizeof(cf_cpu))` plus `memcpy` of the RAM
block. That's the entire snapshot. Write it to disk -> script hibernates
across MUD restarts. A builder's quest script survives a server reboot
mid-execution. **Wasm cannot easily match this** -- runtime-internal
state (stack, locals) isn't part of the .wasm spec.

In-flight HC_MSG_SEND calls pose a snapshot complication: the task is
blocked waiting for a reply handle that exists in the system-wide hash
table, not in the task's own state. On restore, stale reply handles
are expired and the sender is unblocked with `-EINTR`. The sender
must be prepared to retry.

## Loader

ELF loader for big-endian 32-bit M68K. Responsibilities on load:

1. Parse `PT_LOAD` segments and copy them into task RAM.
2. Locate the `NT_MUD_ABI` note and run the version / bitmap check
   (see **ABI Versioning**). Hard-fail on mismatch.
3. Resolve syspage symbol imports. Walk the program's `.mud.symver_r`
   section (our rename of GNU's `.gnu.version_r` -- same data shape,
   our section name since we are not a GNU/Linux environment). For
   every required `(symbol, version)` pair, look up the matching
   syspage export and patch the GOT entry. If any required version is
   absent, fail the load with a clear error naming the missing symbol.
4. Set PC to the entry point.

PT_LOAD segments for the program itself are plain copies -- no
relocation, no dynamic loading of external objects. The symbol-version
machinery exists solely to bind syspage imports. This is the minimum
dynamic-linking surface we can get away with; everything else
statically links into the `.prg`.

Reject anything with non-LOAD segments that touch executable memory.

### Toolchain note

Binutils emits `.gnu.version_r` / `.gnu.version_d` by default. Our
`prg-finalize` post-processing tool (which also attaches the
`NT_MUD_ABI` note) renames those sections to `.mud.symver_r` /
`.mud.symver_d`. Builders compile and link normally; the finalization
step produces the `.prg` the loader expects.

## GDB Stub (v2 feature)

m68k remote serial protocol. Commands: `g`/`G` (registers), `m`/`M`
(memory), `c`/`s` (continue/step), `Z0`/`z0` (sw breakpoint).

Breakpoint = patch instruction with `illegal` (0x4AFC), trap into stub,
swap original back on continue. Park task in `TASK_DEBUGGING` so
the scheduler skips it while a developer is poking around.

Listen on a Unix socket per-task, gated by wiz permission.

## What We Give Up vs Wasm

- Load-time validation guarantees (don't need them -- semi-trusted
  builders, runtime traps are fine).
- FP determinism across hosts (don't need it; if ever needed, drop in
  SoftFloat).
- Spec stability and adversarial audit pedigree (the real cost -- we are
  the sole maintainer of the sandbox; mitigate with seccomp + fuzzing).
- Portable artifacts (don't need it -- single-host MUD).
- Industry plugin-runtime momentum (irrelevant).

## Open Items

- [ ] **v0 scope**: boot emulator, dispatch HC_ABORT/EXIT/PRINT/YIELD/SLEEP,
      load PT_LOAD-only ELF, run hello-world to completion. No caps, no
      syspage, no credits, no ABI versioning. Throwaway.
- [ ] Populate `credit_cost[hc_id]` weight table; tune `CREDIT_BUDGET`
      and per-task RAM cap against a real workload.
- [ ] Write seccomp profile.
- [ ] AFL-fuzz coldfire.c (one afternoon).
- [ ] Decide whether blob domains carry an on-disk x-bit that
      `O_PROGRAM` checks against, or whether `O_PROGRAM` only
      validates the ELF + `NT_MUD_ABI` note at open time.
- [ ] ACL / permission model for HC_UNLINK and HC_OBJ_PROP_PUT on
      shared muddb domains. Who may write to `area:`? Who may delete
      from `bin:`?
- [ ] Reply handle reaper: configurable timeout range (30--300s),
      system-wide hash table sizing, snapshot/restore expiry semantics.
- [ ] Persistence format for task snapshots (and `tmp:` policy within).
- [ ] Builder docs: writing a program in C, Pascal, Forth, or 68k asm;
      where to find newlib; what the hypercall shim looks like.
- [ ] v2: typed hypercalls for non-obj domains (`user:`, `area:`, ...).
- [ ] v2: GDB stub.
- [ ] v2: multi-core scheduler (work-stealing across MUD cores).

## Stretch: Higher-Level Languages as CF Guests

Doubly-sandboxed: the language's own VM enforces type/GC discipline,
the CF emulator catches anything that escapes.

- **Lua 5.4** -- ~24 KLOC portable C, needs only newlib + a tiny shim.
  Stub `os.*` with hypercalls.
- **MicroPython** -- similar story, larger footprint.
- **QuickJS** -- ~70 KLOC, runs on freestanding targets. Gives you
  TypeScript-via-`tsc`-strip-types-then-run-on-QuickJS-on-CF.
- **mruby**, **Wren**, **Janet**, **Forth** ([ATLAST][3]) -- all viable.

TypeScript itself has no native m68k backend; QuickJS-on-CF is the
pragmatic path.

## Estimated Effort

- Scheduler + hypercall dispatch: ~400 LOC host C.
- Messaging (send/recv/reply, reply handle table, reaper): ~400 LOC.
- Object property hypercalls (get/put/list, implicit txn): ~300 LOC.
- HC_SELECT + fd multiplexing: ~150 LOC.
- Capability model + env block + HC_OPENAT flag validation: ~200 LOC.
- Guest-side `mud.h` shim: ~300 LOC.
- ELF loader + ABI note check: ~200 LOC.
- Syspage setup + helpers: ~150 LOC.
- GDB stub (v2): ~400 LOC.
- AFL fuzzing harness: ~50 LOC + an afternoon of triage.

Total v1: ~2100 LOC, roughly two weeks of focused work on top of the
existing emulator. v0 (subset of scheduler + dispatch + loader) is
3--4 days.

[1]: https://wiki.freepascal.org/m68k
[2]: https://lcamtuf.coredump.cx/afl/
[3]: https://www.fourmilab.ch/atlast/
