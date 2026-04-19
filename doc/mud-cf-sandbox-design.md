# MUD ColdFire Sandbox — Design Doc

## Goal

Embed the Triton ColdFire V4e CPU emulator (`coldfire.{c,h}`, ~2200 LOC) as
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
4. Per-script RAM cap (start at 64KB, tune).
5. Run MUD as dedicated unprivileged user.
6. seccomp profile on the MUD process — even an emulator escape can't
   make syscalls outside an allowlist.
7. AFL-fuzz coldfire.c against random instruction streams before
   exposing to builders.

## Per-Script State

```c
typedef enum {
    SCRIPT_RUNNABLE,
    SCRIPT_BLOCKED,    /* waiting on channel */
    SCRIPT_SLEEPING,   /* wake at wake_tick */
    SCRIPT_DEBUGGING,  /* gdb breakpoint */
    SCRIPT_DEAD,
} script_state_t;

typedef struct script {
    uint32_t        id;
    cf_cpu          cpu;
    uint8_t        *ram;
    uint32_t        ram_size;        /* default 64 KB */
    script_state_t  state;
    uint32_t        priority;        /* MLFQ level */
    uint64_t        reductions_used; /* lifetime */
    uint64_t        wake_tick;
    uint32_t        blocked_on;      /* channel id */
    uint32_t        msg_inbox_head;
    struct script  *next;            /* runqueue link */
} script_t;
```

Per-script overhead ~65 KB. 1000 scripts ~ 64 MB. Comfortable on RPi5.

## Hypercall ABI

Lock these early — they are the stable ABI between guest and host.

| Opword  | Name         | Args (registers)             | Returns |
|---------|--------------|------------------------------|---------|
| 0xA001  | HC_YIELD     | —                            | —       |
| 0xA002  | HC_SLEEP     | d0 = ticks                   | —       |
| 0xA003  | HC_WAIT_CHAN | d0 = channel                 | d0 = msg ptr |
| 0xA004  | HC_SEND_CHAN | d0 = channel, a0 = msg, d1 = len | d0 = ok |
| 0xA010  | HC_PRINT     | a0 = string ptr, d0 = len    | —       |
| 0xA011  | HC_GET_TICK  | —                            | d0 = tick |
| 0xA0FF  | HC_EXIT      | d0 = exit code               | (no return) |

MUD-specific hypercalls (look up player, move object, emit room message,
etc.) live in their own opword range, e.g. 0xA100–0xA1FF.

Guest-side shim:

```c
static inline void mud_yield(void) {
    __asm__ volatile (".short 0xA001" ::: "memory");
}
```

## Scheduler

Single-threaded scheduler on one MUD core. Other 2–3 RPi5 cores remain
free for MUD I/O, persistence, etc. (Multi-core scheduler is a v2
feature — keep v1 simple.)

```
sched_tick():
    while runqueue not empty and tick_budget > 0:
        s = dequeue runqueue
        rc = cf_run(&s->cpu, REDUCTION_BUDGET)
        s->reductions_used += rc.executed
        if s->cpu.fault: kill(s); continue
        switch s->state:
            RUNNABLE:   enqueue runqueue (round-robin)
            SLEEPING:   insert sleep_heap by wake_tick
            BLOCKED:    leave on channel waitlist
            DEAD:       free(s)
    drain sleep_heap entries with wake_tick <= now into runqueue
```

Constants (start values, measure and tune):

- `REDUCTION_BUDGET` = 10000 instructions/quantum
- `MAX_SCRIPTS_PER_TICK` = 256
- `REDUCTION_LIMIT_TOTAL` = 1<<30 (kill runaways)

Hypercalls return a status code from the dispatch handler indicating
what state to put the script into (yield → runnable, sleep → sleeping,
wait_chan → blocked, exit → dead).

## Channels

Hash table of `channel_id → channel`. Each channel has a message queue
and a waitlist of blocked scripts. Send copies bytes from sender RAM
into the host-side message struct, then into receiver RAM on wakeup.
No shared memory between scripts — keeps the isolation story clean.

## Snapshot / Restore

`memcpy(&dst->cpu, &src->cpu, sizeof(cf_cpu))` plus `memcpy` of the RAM
block. That's the entire snapshot. Write it to disk → script hibernates
across MUD restarts. A builder's quest script survives a server reboot
mid-execution. **Wasm cannot easily match this** — runtime-internal
state (stack, locals) isn't part of the .wasm spec.

## Loader

ELF loader for big-endian 32-bit M68K, same shape as the Triton monitor
ROM's loader (see `triton-system-emulator/demo/monitor.c`). Parses
`PT_LOAD` segments, copies into RAM, sets PC to entry point.

Reject anything with non-LOAD segments that touch executable memory.

## GDB Stub (v2 feature)

m68k remote serial protocol. Commands: `g`/`G` (registers), `m`/`M`
(memory), `c`/`s` (continue/step), `Z0`/`z0` (sw breakpoint).

Breakpoint = patch instruction with `illegal` (0x4AFC), trap into stub,
swap original back on continue. Park script in `SCRIPT_DEBUGGING` so
the scheduler skips it while a developer is poking around.

Listen on a Unix socket per-script, gated by wiz permission.

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

- [ ] Tune `REDUCTION_BUDGET` and per-script RAM cap on real workload.
- [ ] Write seccomp profile.
- [ ] AFL-fuzz coldfire.c (one afternoon).
- [ ] Decide MUD-specific hypercall opword range and table.
- [ ] Persistence format for script snapshots.
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
