# MUD ColdFire Sandbox — Design Doc

## Goal

Embed the ColdFire V4e CPU emulator (`coldfire.{c,h}`, ~2200 LOC) as
the script sandbox for a multi-user MUD server. Each connected
script/area/NPC runs in its own CF VM instance, scheduled cooperatively
by the host with reduction-budget preemption (Erlang-style).

Replaces an earlier Q3VM-based design. Rejected alternatives: Wasm
(heavyweight, validation guarantees a MUD doesn't need), LuaJIT
(sandboxing weaknesses), pure Lua (no preemption).

## Why ColdFire

- **Tooling.** `m68k-linux-gnu-gcc` 14, binutils, gdb, newlib, libstdc++,
  Ada (gnat), Fortran (gfortran). Builders write in any language with an
  m68k backend.
- **FFI ergonomics.** LINE_A opcodes (0xAxxx, ~4096 slots) trap to a host
  hypercall handler with full register access. No i32-only marshaling.
- **Isolation.** Per-instance `cf_cpu` + bus callbacks bound to a private
  RAM block. Equivalent to wasm3's per-instance pattern.
- **Preemption.** `cf_run(cpu, count)` returns after `count` instructions.
  No timer interrupts needed.
- **Debuggability.** GDB remote serial protocol is ~300–500 LOC bolted
  onto coldfire.c. Live-debug a running script from a developer laptop.
- **Retro flavor.** Builders can write 68k assembly if they want to.

Host: Raspberry Pi 5, quad-core, 3 cores idle. Interpretation overhead
(50–200M emulated insns/sec/core) is irrelevant.

## Trust Model

Builders are semi-trusted (you grant a wiz bit). Threats are runaway
loops, memory exhaustion, accidental sandbox escape via emulator bugs.
Defense in depth:

1. CF user-mode (CF_SR_S clear) traps privileged instructions.
2. Bus callbacks reject out-of-range addresses.
3. Reduction budget caps per-tick CPU.
4. Per-task RAM cap (start at 64KB, tune).
5. Run MUD as dedicated unprivileged user.
6. seccomp profile on the MUD process — even an emulator escape can't
   make syscalls outside an allowlist.
7. AFL-fuzz coldfire.c against random instruction streams before
   exposing to builders.

## Terminology

- **program** (`program_t`) — an ELF blob plus metadata. Owned by muddb,
  thawed from storage on demand. A program is inert code; you need one
  to create a VM state. Multiple tasks can share a program; if the
  loader marks text RO, that RAM region can be COW-shared across tasks
  running the same program.
- **vm state** (`vm_state_t`) — CPU + registers + RAM + bus callback
  table. One per task. May reference a program's text region via COW.
- **task** (`task_t`) — a running instance. Owns a `vm_state_t`, an fd
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
    TASK_BLOCKED,    /* waiting on channel */
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
    uint64_t      reductions_used;   /* lifetime */
    uint64_t      wake_tick;
    uint32_t      blocked_on;        /* channel id */
    uint32_t      msg_inbox_head;
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
enum of hypercall IDs — no reserved ranges, no domain grouping in the
opword. New hypercalls get appended to the enum. Never reassign an ID;
never change the register convention of a shipped ID. See **ABI
Versioning** below for how clients declare which IDs they use.

For domain-typed hypercalls the dirfd carries the domain type, so the
host can reject `HC_OBJ_GET` on a `user:` dirfd without encoding the
type in the opword.

Initial set (indicative — numbering is flat and assigned at
implementation time):

| Name              | Args (registers)                         | Returns                |
|-------------------|------------------------------------------|------------------------|
| HC_YIELD          | —                                        | —                      |
| HC_SLEEP          | d0 = ticks                               | —                      |
| HC_WAIT_CHAN      | d0 = channel                             | d0 = msg ptr           |
| HC_SEND_CHAN      | d0 = channel, a0 = msg, d1 = len         | d0 = ok                |
| HC_PRINT          | a0 = string ptr, d0 = len                | —                      |
| HC_OPENAT         | d0 = dirfd, a0 = path, d1 = flags        | d0 = fd or -errno      |
| HC_CLOSE          | d0 = fd                                  | d0 = 0 or -errno       |
| HC_READ           | d0 = fd, a0 = buf, d1 = len              | d0 = bytes or -errno   |
| HC_WRITE          | d0 = fd, a0 = buf, d1 = len              | d0 = bytes or -errno   |
| HC_READDIR        | d0 = fd, a0 = entry buf                  | d0 = 0 / EOF / -errno  |
| HC_STAT           | d0 = fd, a0 = stat buf                   | d0 = 0 or -errno       |
| HC_OBJ_GET        | d0 = fd, a0 = key, d1 = keylen, a1 = buf | d0 = len or -errno     |
| HC_OBJ_PUT        | d0 = fd, a0 = key, d1 = keylen, a1 = obj | d0 = 0 or -errno       |
| HC_USER_GET       | d0 = fd, a0 = key, a1 = rec              | d0 = 0 or -errno       |
| HC_SPAWN          | d0 = prog fd, a0 = cap list, d1 = n_caps | d0 = task id or -errno |
| HC_EXIT           | d0 = exit code                           | (no return)            |

`HC_READ`/`HC_WRITE`/`HC_READDIR`/`HC_STAT` apply to blob domains
(`tmp:`, `bin:`); typed domains expose their own hypercalls
(`HC_OBJ_*`, `HC_USER_*`, and so on — one family per domain type,
following the interface in `src/<domain>/<domain>.h`). The list above
is indicative and grows as we surface more of muddb.

Tick-counter and other introspective state live in the **syspage**
(see below) and are read as plain memory, not hypercalls.

Guest-side shim:

```c
#define MUD_HC(id)  __asm__ volatile (".short 0xA000 | " #id ::: "memory")
static inline void mud_yield(void) { MUD_HC(HC_YIELD); }
```

## Scheduler

Single-threaded scheduler on one MUD core. Other 2–3 RPi5 cores remain
free for MUD I/O, persistence, etc. (Multi-core scheduler is a v2
feature — keep v1 simple.)

```
sched_tick():
    while runqueue not empty and tick_budget > 0:
        t = dequeue runqueue
        rc = cf_run(&t->vm.cpu, REDUCTION_BUDGET)
        t->reductions_used += rc.executed
        if t->vm.cpu.fault: kill(t); continue
        switch t->state:
            RUNNABLE:   enqueue runqueue (round-robin)
            SLEEPING:   insert sleep_heap by wake_tick
            BLOCKED:    leave on channel waitlist
            DEAD:       task_free(t)
    drain sleep_heap entries with wake_tick <= now into runqueue
```

Constants (start values, measure and tune):

- `REDUCTION_BUDGET` = 10000 instructions/quantum
- `MAX_TASKS_PER_TICK` = 256
- `REDUCTION_LIMIT_TOTAL` = 1<<30 (kill runaways)

Hypercalls return a status code from the dispatch handler indicating
what state to put the task into (yield → runnable, sleep → sleeping,
wait_chan → blocked, exit → dead).

## Channels

Hash table of `channel_id → channel`. Each channel has a message queue
and a waitlist of blocked tasks. Send copies bytes from sender RAM
into the host-side message struct, then into receiver RAM on wakeup.
No shared memory between tasks — keeps the isolation story clean.

## Capabilities and Filesystem

The VM has no ambient `open()`. There is no root filesystem, no `cwd`,
no resolver that walks from `/`. All access goes through typed
hypercalls that take a dirfd, and a task can only name a dirfd that
appears in its fd table.

At task creation the host populates the fd table with a set of
**initial capabilities** — one dirfd per domain the task is permitted
to touch. That fd table is the entire security boundary. If a dirfd
wasn't granted, the domain is unreachable; there is no side channel
through which a task can manufacture one.

### Typed domains vs blob domains

muddb domains are typed interfaces, not generic filesystems. Each
domain speaks a specific record type via the interface in
`src/<domain>/<domain>.h`: `user:` returns user records, `obj:` returns
JSON objects, and so on. Only two domains are byte-level blob stores:

- `tmp:` — RAM, per-task.
- `bin:` — muddb-backed persistent blob store for programs, source,
  and build artifacts. The compromise that lets `fread`/`fwrite` exist:
  not every domain can back it, but `bin:` can.

A dirfd carries a *domain type tag* along with the domain handle and
key prefix. Hypercalls enforce the type match: `HC_READ` only accepts
blob-domain fds, `HC_OBJ_GET` only accepts `obj:`-typed fds, and so on.
The guest libc picks the right wrapper based on the `type` field in
the task's cap table; builders rarely see the distinction.

### Drive prefixes are UI, dirfds are the capability

Guest code refers to domains by colon-prefixed name: `local:quests/dragon`,
`tmp:scratch.log`, `bin:npc/guard.prg`. The guest libc (`mud.h`) parses
the prefix, looks it up in the cap table, and issues the typed
hypercall appropriate to that domain. The colon syntax is ergonomic
for builders; it carries no authority. Any attempt to "make the parser
smart" — walking paths, inferring a default drive, normalizing `..` —
is reintroducing ambient authority and should be stopped at review.

Cap table entry (readonly to guest, lives in the syspage — see below):

```c
struct cap_entry {
    char     name[16];   /* "local:", "tmp:", ... */
    int32_t  fd;
    uint16_t type;       /* DOMAIN_BLOB, DOMAIN_OBJ, DOMAIN_USER, ... */
    uint16_t flags;      /* RO, RW, ... */
};
```

### Standard domains

| Prefix     | Type     | Lifetime           | Backing          | Notes                                       |
|------------|----------|--------------------|------------------|---------------------------------------------|
| `tmp:`     | blob     | task               | RAM              | Private per-task. Reaped on task exit.      |
| `bin:`     | blob     | persistent         | muddb            | Programs, source, build artifacts.          |
| `session:` | (typed)  | user session       | muddb (volatile) | Shared across tasks in the same session.    |
| `local:`   | (typed)  | owner (persistent) | muddb            | Per-player persistent storage.              |
| `area:`    | (typed)  | persistent         | muddb            | The task's home zone. Usually RO.           |
| `world:`   | (typed)  | persistent         | muddb            | Shared world state. Privileged tasks only.  |

Two tasks spawned from the same program by the same user in the same
session each get a private `tmp:` and a shared `session:`. `tmp:`
isolation is absolute — there is no hypercall by which one task can
name another task's `tmp:`.

### muddb domain resolution

A dirfd binds a domain handle plus a key prefix.
`HC_OBJ_GET(dirfd, "quests/dragon")` resolves to the key
`<prefix>quests/dragon` within the domain. `HC_READDIR` (blob) and
its typed analogues are cursor scans over the prefix. `..` is rejected
at the host — dirfds are prefix-scoped, and path traversal is the
usual way these APIs leak authority. A task wanting a parent view
must be given a dirfd to the parent explicitly.

### `tmp:` implementation

A small heap attached to `task_t`, mapped into a fixed region of guest
RAM. The guest linker script exposes `_tmp_begin` and `_tmp_end`
symbols over that region so both the guest libc's `tmp:` driver and
external tooling (ptrace, the gdb stub) can locate it without host
cooperation. Classic, easy, inspectable.

Freed in `task_free()`. No persistence plumbing until the task-snapshot
design lands, at which point `tmp:` follows whatever policy tasks follow.

### Capability delegation

`HC_SPAWN` takes a program fd (opened from `bin:` or any other blob
dirfd that holds a valid `.prg`) plus a list of `(dirfd, flags)` pairs
the parent grants to the child. The host validates every dirfd against
the parent's fd table, clamps flags (a child never gets more
permission than the parent), and installs them as the child's initial
caps. A parent holding `local:` RW can give its child `local:` RO, or
can open a subdirectory dirfd and hand that over instead — narrowing
by attenuation.

Channel sends may optionally carry a dirfd in the same shape as
`SCM_RIGHTS`: the sender's fd is resolved at send time, the receiver
gets a new fd in its own table on receive. Revocation = close. This is
where the capability model earns its keep: a builder can write a
service task that accepts a cap to a caller's `local:`, works on it,
and the caller revokes by closing — without any ambient trust between
them.

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
check shift-free; the 0–7 bit waste is negligible.

**Freeze policy.** Once shipped:

- An HC ID never gets reassigned.
- An HC's register convention never changes.
- Structured records (stat, dirent, cap_entry) are append-only in
  existing layouts; new fields go on the end, old offsets never move.
- Breaking any of the above requires an `abi_major` bump.

`abi_major` mismatch = hard refusal at load. Bitmap-superset pass +
`abi_major` match = accepted even across `abi_minor`/`abi_patch`
differences.

## Syspage

Read-only page at fixed guest address `0x00001000`, mapped by the host
bus callbacks as readable but not writable by the VM. Distinct region
from task RAM and from `tmp:`. The name follows QNX's System Page
conventions — a kernel-maintained shared page with live data and
fast-path helpers.

### Layout

```
0x00001000  syspage_header  { layout_major, layout_minor, size }
0x00001010  live data       task_id, owner_id, session_id,
                            current_tick, argc, argv_ptr, ulimits,
                            cap_entry[] (terminated)
0x00001???  text area       versioned helper code
```

Header carries `{layout_major, layout_minor, size}`. Guest crt0 checks
these at task entry and refuses to run if the major is wrong.
Append-only discipline within a major — old offsets never move.

### Live data

Host updates these in place; guest reads them as plain loads. No
hypercall is needed to ask what tick it is.

- `task_id`, `owner_id`, `session_id`
- `current_tick` — incremented by the scheduler
- `argc`, `argv_ptr` — pointers into syspage string table
- ulimits — RAM cap, reduction budget, etc.
- `cap_entry[]` — the task's initial cap table, terminated by a
  zero-name entry

`HC_GET_TICK` is gone. The tick is `*(uint64_t *)0x00001018` (or
wherever the layout puts it).

### Text area

Small helpers the host compiles per-build and ships as part of the
syspage. Exported as versioned symbols using an ELF-symbol-versioning
scheme (see **Loader** below).

Example helpers:

- `mud_domain_parse(path, &fd_out, &tail_out)` — walks a
  `"local:foo/bar"` string and returns the matching cap_entry fd plus
  the tail path.
- `mud_tick()` — one-instruction load from the live-data area;
  exported as a function so its address is stable across layout shifts.
- formatters, simple helpers — as the need arises.

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
block. That's the entire snapshot. Write it to disk → script hibernates
across MUD restarts. A builder's quest script survives a server reboot
mid-execution. **Wasm cannot easily match this** — runtime-internal
state (stack, locals) isn't part of the .wasm spec.

## Loader

ELF loader for big-endian 32-bit M68K. Responsibilities on load:

1. Parse `PT_LOAD` segments and copy them into task RAM.
2. Locate the `NT_MUD_ABI` note and run the version / bitmap check
   (see **ABI Versioning**). Hard-fail on mismatch.
3. Resolve syspage symbol imports. Walk the program's `.mud.symver_r`
   section (our rename of GNU's `.gnu.version_r` — same data shape,
   our section name since we are not a GNU/Linux environment). For
   every required `(symbol, version)` pair, look up the matching
   syspage export and patch the GOT entry. If any required version is
   absent, fail the load with a clear error naming the missing symbol.
4. Set PC to the entry point.

PT_LOAD segments for the program itself are plain copies — no
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

- Load-time validation guarantees (don't need them — semi-trusted
  builders, runtime traps are fine).
- FP determinism across hosts (don't need it; if ever needed, drop in
  SoftFloat).
- Spec stability and adversarial audit pedigree (the real cost — we are
  the sole maintainer of the sandbox; mitigate with seccomp + fuzzing).
- Portable artifacts (don't need it — single-host MUD).
- Industry plugin-runtime momentum (irrelevant).

## Open Items

- [ ] Tune `REDUCTION_BUDGET` and per-task RAM cap on real workload.
- [ ] Write seccomp profile.
- [ ] AFL-fuzz coldfire.c (one afternoon).
- [ ] Decide MUD-specific hypercall opword range and table.
- [ ] Persistence format for task snapshots (and `tmp:` policy within).
- [ ] Builder docs: how to write a script in C, where to find newlib,
      what the hypercall shim looks like.
- [ ] v2: GDB stub.
- [ ] v2: multi-core scheduler (work-stealing across MUD cores).

## Stretch: Higher-Level Languages as CF Guests

Doubly-sandboxed: the language's own VM enforces type/GC discipline,
the CF emulator catches anything that escapes.

- **Lua 5.4** — ~24 KLOC portable C, needs only newlib + a tiny shim.
  Stub `os.*` with hypercalls.
- **MicroPython** — similar story, larger footprint.
- **QuickJS** — ~70 KLOC, runs on freestanding targets. Gives you
  TypeScript-via-`tsc`-strip-types-then-run-on-QuickJS-on-CF.
- **mruby**, **Wren**, **Janet** — all viable.

TypeScript itself has no native m68k backend; QuickJS-on-CF is the
pragmatic path.

## Estimated Effort

- Scheduler + hypercall dispatch + channels: ~600 LOC host C.
- Guest-side `mud.h` shim: ~200 LOC.
- ELF loader: ~150 LOC (port from monitor.c).
- GDB stub (v2): ~400 LOC.
- AFL fuzzing harness: ~50 LOC + an afternoon of triage.

Total v1: roughly a week of focused work on top of the existing
emulator.
