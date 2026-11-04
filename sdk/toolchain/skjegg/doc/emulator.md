# skj-run: the in-tree guest runner

`skj-run` runs a compiled 32-bit guest program on an emulator built into
this tree, the way `qemu-user` or `wasmtime` runs one. It replaces
`qemu-m68k`, `qemu-riscv32` and `qemu-mipsel` for the targets it covers,
and it is the only runner for strict ColdFire code, which qemu does not
model.

```sh
skj-run hello.elf                  # architecture from the ELF header
skj-run --arch rv32 prog.elf a b   # override, and pass guest arguments
skj-run --arch mips32 prog.elf     # little-endian MIPS I (o32)
skj-run --arch x86-64 prog.elf     # x86-64 guest run natively under KVM
skj-run --trace --stats prog.elf   # CPU event ring on a fault, counters
```

The emulated cores run 32-bit ELF32 guests. The x86-64 core runs a 64-bit
ELF64 guest, and runs it natively under KVM rather than interpreting it.

The exit status is the guest's own. A guest killed by a fault reports
128 plus the signal a host kernel would have raised (139 for a bad
memory access, 132 for an illegal instruction), which is what a shell
reports for a real process, so a test harness needs no special case.

## Where it came from

The two CPU cores were written for the research articles and adopted
into skjegg, which owns them now. The RV32 series ran to five articles
and is finished, so upstream is a record of how the core was built
rather than a place it is maintained; the final version, its whole test
rig and the tooling that audited that rig were imported here (2026-08-05,
research commit 99a25a2). The articles keep a frozen copy of the code
they describe:

- <https://orangetide.github.io/the-mechanical-researcher/coldfire-emulator/>
- <https://orangetide.github.io/the-mechanical-researcher/coldfire-emulator-part-2/>
- <https://orangetide.github.io/the-mechanical-researcher/rv32-emulator/>
- <https://orangetide.github.io/the-mechanical-researcher/rv32-bitmanip/>
- <https://orangetide.github.io/the-mechanical-researcher/rv32-zcb/>
- <https://orangetide.github.io/the-mechanical-researcher/rv32-interrupts/>
- <https://orangetide.github.io/the-mechanical-researcher/rv32-coverage/>

Fixes land here, not there. Two have landed already: `REMS.L`/`REMU.L`
wrote the quotient into `Dq` as well as the remainder into `Dr`, which
is the 68020 pair form rather than the ColdFire split, and it masked a
matching `skj-as` bug (a two-operand `divs.l` was encoded with `Dr = 0`,
which real hardware reads as a remainder instruction). The debug-support
instructions `PULSE` (an unprivileged processor-status pulse, which decodes in
the same group-4 slot as `TAS` and was mis-taken for it), `WDDATA` (write to the
debug data port), and `WDEBUG` (the supervisor-only debug-register write) are
decoded rather than rejected as illegal.

## Layout

```
emu/coldfire.c   ColdFire V4e core (integer, FPU, EMAC)   \  one component
emu/cf_user.c    Linux/m68k user mode: vectors, syscalls  /

emu/rv32.c       RV32IMAFC + Zicsr, Zifencei, Zba/Zbb/Zbs, Zcb  \  another
emu/rv_user.c    Linux/RISC-V user mode: ecall             |
emu/rv_gdb.c     the --gdb remote stub (RV32)             /

emu/mips32.c     MIPS I (R3000-class) integer core, little-endian  \  a third
emu/mips_user.c  Linux/MIPS o32 user mode: syscall         |
emu/mips_gdb.c   the --gdb remote stub (MIPS)             /

emu/hvcore.c     x86-64 and aarch64 under a VMM: a guest run natively \  a fourth
emu/vmm_kvm.c    the Linux KVM backend (long mode, syscall doorbell) |
emu/vmm_hvf.c    the macOS Hypervisor.framework backend (arm64)     |
emu/hv_gdb.c     the --gdb remote stub (x86-64 and aarch64)        /
emu/vmm.h        the backend-neutral VMM seam (KVM and HVF)
emu/skj_hv_abi.h the guest/host contract (doorbell, page tables)

emu/sched.c      the arch-neutral process sandbox + scheduler (all cores)
emu/guest.c      sparse memory, the syscall layer, the initial stack
emu/elf32.c      ELF32 loader, either endianness
emu/elf64.c      ELF64 loader (the hardware-virtualization guests)
emu/main.c       the driver
```

The three cores are independent components. A project vendoring skjegg
takes `emu-cf`, `emu-rv`, `emu-mips`, or any mix; `EMU_COLDFIRE=0` /
`EMU_RV32=0` / `EMU_MIPS32=0` drop a core out of the build entirely. This
matters because the target hosts differ: smolmoo is ColdFire, and a host
that moved to RV32 would carry only the RISC-V core.

The MIPS core is the user-visible architecture only: the general
registers, HI/LO, the branch and load delay slots, and the `SYSCALL` and
`BREAK` traps. It has no CP0, cache or MMIO, and no COP1; floating point
is the backend's softfloat path, so a hardware-COP1 binary faults with an
illegal instruction here.

## The machine

Guest memory is a sparse two-level page table over the 32-bit address
space, committed 4 KB at a time on first touch inside a mapped region.
The loader maps one region per `PT_LOAD` segment with that segment's
protection, then the heap (for `brk`) and the stack are mapped above
the image. An access outside every region is a fault reported with the
address and the reason, rather than a silent read of zero.

Syscalls reach one arch-neutral layer, described in "How guest syscalls
work" below.

The ELF loader has an in-memory form beside the path form. `elf32_load`
now slurps the file and delegates to `elf32_load_mem`, which walks the
program headers over a caller-owned buffer and does no file I/O;
`elf32_symbol` and `elf32_load_raw` are the same split. This is what lets
a host load a guest from an image it already holds in memory (a vendored
verb, a downloaded module) rather than only from a path. Every emulator
suite exercises the `_mem` body through the path wrappers.

## How guest syscalls work

A guest issues a syscall through its architecture's normal trap, and skj-run
turns that into a call on one arch-neutral layer. The flow is the same on every
core:

1. The guest raises its trap with the Linux number and arguments in that ISA's
   registers: `ecall` with the number in `a7` and arguments in `a0`-`a5` on
   RV32, `TRAP #0` with the number in `d0` and arguments in `d1`-`d5`/`a0` on
   ColdFire, `SYSCALL` with the number in `$v0` and arguments in `$a0`-`$a3`
   (the fifth and sixth on the stack) on MIPS. The hardware-virtualization cores
   use a load from a doorbell address instead of a trap (see that section).
2. Each core's `*_user.c` shim reads those registers and maps the
   per-architecture Linux number onto one arch-neutral selector (`enum
   guest_sys` in `emu/guest.h`). The Linux/m68k table, the RISC-V generic table
   and the MIPS o32 table all collapse onto the same set, so a call added once
   reaches every target.
3. `guest_syscall` in `emu/guest.c` services the call against the guest's memory
   and host bindings and returns the Linux convention: a non-negative result, or
   a negative errno. The shim writes that back into the ISA's result register
   (`a0`, `d0`, or the o32 `$v0`/`$a3` pair, which carries the result or a
   positive errno plus an error flag).

The set is the handful a freestanding guest reaches: `read`, `write`, `writev`,
`openat`, `close`, `lseek`, `brk`, `exit`/`exit_group`, the stat, dirent and
namespace calls the `fs/` layer needs, the clock and random seams, `nanosleep`
and `sched_yield`. Anything outside it answers `-ENOSYS`, the way Linux would,
so an unexpected call surfaces as a guest-visible error rather than a silent
wrong result. Host-varying work (confined opens, directory reads, the clock,
random bytes) goes through `emu/hostplat.h`, whose one implementation per host
OS keeps `guest.c` free of host `#ifdef`s.

ColdFire needs no syscall hook in the core: user mode is built out of the
hardware behavior. The vector table sits in a page of guest memory with every
entry pointing at a distinct address in an unmapped magic window, so when the PC
lands there the driver knows which vector fired. `TRAP #0` is serviced and
returns through the exception frame; any other vector is reported as the signal
a kernel would raise. RV32 and MIPS instead use the core's `ecall` / `SYSCALL`
callback.

### Emulator-private host calls

A second, non-Linux set of selectors sits far above the Linux syscall space
(`0x000f0000` and up, in `emu/sched.h`), so a real kernel or qemu-user answers
each with `-ENOSYS` and a guest built for skj-run still runs there, just without
the service. The shared handler `sched_private` serves them before the Linux
path: `MAP`/`MUNMAP` (guarded guest mmap), `SPAWN` (load a child process),
`FATAL` (abort with a backtrace), `YIELD` (give up the rest of the slice), and
`P9` (ring the 9P doorbell, see the filesystem section). Each core puts the
selector in its own syscall-number register, so the values and meanings are
identical across targets.

### Blocking calls yield instead of stalling the sandbox

skj-run runs every guest process on one host thread under a cooperative
scheduler, so a syscall that blocks on the host would freeze the whole sandbox,
not just its caller. `read`, `nanosleep` and `sched_yield` therefore yield the
scheduler slice rather than block the host:

- `read` probes the fd with a non-blocking `poll` first. If data (or EOF) is
  ready it reads normally; if the read would block it parks the process and
  re-runs the same syscall on a later slice, so no host fd flags are touched and
  a regular file always reads at once.
- `nanosleep` parks the process to an absolute deadline rather than sleeping on
  the host clock.
- `sched_yield` completes but ends the slice so siblings run this round.

The scheduler skips a parked process until its fd is ready or its sleep deadline
passes, and blocks the host in a single `poll` only when every live process is
parked, so there is no busy-spin and no idle host stall. This is opt-in per core
(the three emulated cores enable it; the hardware-virtualization cores keep the
plain blocking path). The scheduler these yields drive is described under "The
process sandbox".

## The RV32 interpreter loop

`rv_run(cpu, budget, retired)` runs up to `budget` instructions and
returns **why** it stopped, an `enum rv_run_reason`:

| Reason | Meaning |
|---|---|
| `RV_RUN_BUDGET` | ran the full count; still runnable |
| `RV_RUN_HALT`   | halted: a clean exit or a double fault |
| `RV_RUN_TRAP`   | a trap was taken; `cpu->mcause` names the cause |
| `RV_RUN_YIELD`  | the hart is parked (`cpu->waiting`): `wfi`, still runnable |

`*retired`, when non-NULL, receives the count. The loop stops the moment
the machine halts, a trap is taken, or the hart parks on `wfi`, rather
than spinning the rest of the batch through a vector with no handler
installed. Halt outranks a trap (a double fault sets both, and the host
wants the halt); a parked hart reports as a yield, not a stop, because it
is still runnable once the host clears `cpu->waiting` or an interrupt
does. This is the cooperative-yield boundary a scheduler builds
coroutine-style tasks on, and it is the contract a JIT backend would
return through as well. `rv_step` is one instruction over the same loop,
for a host that drives the machine itself; it discards the reason and
reports only halt.

The dispatch is a single threaded loop over the major opcode, not a
call per instruction. The exceptional exits (misaligned PC, fetch and
bus faults, illegal encodings, the interrupt path, the per-instruction
stop test) are marked `RV_UNLIKELY` so the compiler keeps the cold trap
trampolines out of the straight-line fetch and dispatch path. That is a
code-layout aid, not a prediction fix: profiling shows every one of
those branches is already predicted near-perfectly, and the measurable
win (about 7% on a mixed-workload guest, best-of-runs) comes entirely
from tightening the hot path's instruction footprint. The two branches
that actually mispredict, the compressed-versus-32-bit discriminator
(near 50/50) and the dispatch switch itself (an indirect branch), are
inherent and cannot be hinted.

A **decoded-instruction cache** (`rv_dec_enable`) speeds re-execution: a
direct-mapped table keyed by guest PC holding the expanded 32-bit form
and length, so a re-executed PC skips the fetch-and-expand. It is a
hint, so a miss only costs the work it was meant to save. `skj-run`
enables it on every process; a host that does not want it simply leaves
`cpu->dec` NULL and the slow decode runs every instruction, which is
what the coverage build does (see `RV_ICOV`). `fence.i` invalidates the
whole cache: without that a guest that rewrites an instruction and then
runs `fence.i` (self-modifying code, a guest-side JIT) would keep
running the stale decode. Because it is a hint it must change no result,
and `make test-rv-decode-cache` pins exactly that: it runs a program
with the cache on and off in lockstep and compares the architectural
state after every instruction. One of its programs rewrites an
instruction it already ran, runs `fence.i`, and runs it again, so a
missed invalidation shows as a divergence between the two cores.

## The two test tiers

`make check` cross-compiles the C runtime for generic m68k, which is
what `qemu-m68k` models. gcc then emits 68020 instructions (the 64-bit
divide, byte and word arithmetic on memory, `bfextu`) that neither a
real ColdFire nor this emulator has.

`make check-emu` rebuilds that runtime with `-mcpu=5475` and relinks
into `build/cf`. The compiled test objects are unchanged, since every
front end already emits ColdFire. That build is what a boris or smolmoo
host would load, so the emulator tier is the closer model of the real
target; qemu stays as an independent oracle for the generic-m68k build.
Note that qemu cannot run the ColdFire tier at all, `-cpu cfv4e`
included: it rejects `mov3q` and the remainder instructions.

| Target               | Runner       | Runtime built for      |
|----------------------|--------------|------------------------|
| `make check`         | qemu-m68k    | generic m68k           |
| `make check-emu`     | skj-run      | ColdFire (5475)        |
| `make check-rv`      | qemu-riscv32 | RV32IM                 |
| `make check-rv-emu`  | skj-run      | RV32IM (same binaries) |
| `make check-mips`    | qemu-mipsel  | MIPS I                 |
| `make check-mips-emu`| skj-run      | MIPS I (same binaries) |

Like RISC-V, the MIPS tests link no cross-compiled C, so `check-mips-emu`
runs the same binaries `check-mips` builds straight on the in-tree core.

`make check-emu-all` runs every suite the emulator covers, with no qemu
involved.

## Architecture parity

The long-term goal is for the three targets to behave the same under skj-run
wherever that is possible, and to document the cases where it is not. There are
two separable sandbox layers, and the targets sit at different points on each.

| Capability                                   | rv32 | ColdFire | MIPS |
|----------------------------------------------|------|----------|------|
| User-mode CPU core + Linux syscalls          | yes  | yes      | yes  |
| Hardware FPU (double, single, condition flag) | yes  | yes      | yes (COP1) |
| Guest fault report + DWARF/trap backtrace    | yes  | yes      | yes  |
| Hosted driver libc (the C toolchain target)  | yes  | yes      | yes  |
| In-guest self-hosting of the toolchain       | yes  | yes      | yes  |
| Capability filesystem: confined `fs/` libc, `--mount`, hostcap, RESOLVE_BENEATH | yes | yes | yes |
| Process sandbox: guarded `mmap`, `spawn`, the round-robin scheduler, the aggregate memory pool | yes | yes | yes |
| GDB remote stub (`--gdb`)                     | yes  | no       | yes  |

The **basic machine** (the CPU core, the Linux syscall surface, fault reporting
and the symbolized backtrace) is at full parity: every target runs the same
freestanding guests under skj-run the same way.

The **capability filesystem** is the confined `fs/` layer, described in full
under "The filesystem layer" below: a guest links the freestanding `fs/` libc,
and the launcher grants host directories with `--mount`, confined by the
`hostcap` backend. All three targets have it, exercised by `test-rv-fs-cap`,
`test-cf-fs-cap` and `test-mips-fs-cap` (and by `check-emu-posix`, which reruns
them through the portable `cap_walk` confinement floor). Since the `fs/` sources
are portable C compiled into the guest and the launcher
(`guest_install_mounts`) is arch-neutral, the per-target work is only in the
runtime seam. Bringing MIPS up to this level needed two runtime fixes worth
noting as the kind of ABI divergence a new target surfaces: the MIPS crt gained
the `__sys_*` syscall-seam aliases and `openat` the `fs/` layer calls (with the
public fd wrappers made weak so the confined libc's `fdio.c` can take them
over), and skj-run's MIPS front end now translates the o32 `open()` flag bits
(`O_CREAT` is `0x100` on MIPS, `0x40` on the asm-generic ABI the host uses) to
the host ABI, the way qemu-mipsel does.

The **process sandbox** (guarded `mmap` through the `MAP`/`MUNMAP` host calls,
`spawn`, the round-robin scheduler, and the shared memory-commit pool) runs on
all three cores through one arch-neutral scheduler. `emu/sched.c` owns the
process table, the slices, spawn, the shared `gm_pool` budget, the handle
generations, the fault backtrace cache, and the `MAP`/`MUNMAP`/`SPAWN`/`FATAL`/
`YIELD` selectors.  It never names a concrete CPU type: it holds a `void *cpu`
handle and reaches the core only through a `struct skj_cpu_ops` vtable (alloc,
ready, run, halt, the fault/trap diagnostics, the backtrace frame pointer).
Each `*_user.c` is now a thin binding that fills in that vtable and a per-core
syscall shim; `run_rv32` / `run_mips32` / `run_coldfire` each just call
`run_sandbox(o, &<core>_ops, status)`.

Every core exposes the same batched run,
`enum skj_run_reason <arch>_run(cpu, count, *retired)` (see `run_reason.h`), the
boundary the scheduler drives tasks on.  rv and MIPS service their syscalls in a
step callback, so their `run` returns to the scheduler only on a terminal event;
ColdFire takes its syscalls as a `TRAP #0` that vectors into a reserved window,
so its binding wraps `cf_run` in a loop that services the `TRAP #0` in place and
presents the scheduler the same callback contract.  The cooperative yield is
part of that contract: rv parks on `wfi` (`cpu->waiting`), while MIPS and
ColdFire use a reserved host-call selector `0x000f0004` (in `$v0` on MIPS, in
`%d0` at `TRAP #0` on ColdFire) that the emulator picks up and never forwards to
the host, so it is a yield under skj-run and a harmless unknown syscall
(`-ENOSYS`) on a real host.  The blocking syscalls `read`, `nanosleep` and
`sched_yield` hand back through this same yield reason rather than stalling the
host, so a parked reader does not freeze its siblings (see "Blocking calls yield
instead of stalling the sandbox" under "How guest syscalls work").  The
scheduler clears the park flag (`ops->clear_yield`)
at the start of each slice.  The GDB stub stays a per-core piece plugged into the
same scheduler through an optional `ops->gdb` hook; `rv_gdb.c` and `mips_gdb.c`
provide it for rv32 and MIPS, ColdFire not yet.  The MIPS stub derives its o32
register layout from the ELF (it advertises no target description, since gdb's
MIPS tdesc validator rejects a supplied one, matching qemu-mipsel's stub), and
gdb's prologue-only MIPS unwind of CFI-less skj-cc code stops short of the full
call chain that skj-run's own DWARF backtrace walks.

## The instruction-count benchmark

The interpreter counts retired instructions with no timing input, so the
count for a given guest is identical on every host. That is what makes it
a benchmark metric where wall-clock time is not: two machines, or the same
machine before and after an unrelated change, report the same number, so a
difference means the work changed, not that the host was busier.

`make bench` runs the corpus in `tests/bench.list` under `skj-run --stats`
and compares each retired-instruction count against the committed baseline
`tests/bench.expected`. The corpus reuses guests that `check-emu` and
`check-rv-emu` already build and validate, chosen to span both cores and a
range from a few thousand to a few million instructions. A count that moves
in either direction fails the gate: on a deterministic interpreter nothing
else moves it but a change in the generated code, so each change is meant to
be read. Once it is understood and intended, `make bench-accept` records the
new numbers.

```
make bench            # gate both cores against the baseline
make bench-cf         # gate the ColdFire corpus only (one toolchain)
make bench-rv         # gate the RV32 corpus only
make bench-accept     # rebaseline after an intended change
```

`make check-emu-all` runs `bench` with the rest of the emulator suites,
since that umbrella already requires both cross toolchains. The lighter
`make check` leaves it out: it is a signal to read rather than a pass/fail
property of a release. A guest whose binary is absent is skipped, not failed, so
`bench-cf` or `bench-rv` gates its own half on a machine that has only one
toolchain. The counts are guest-instruction counts; for tuning the
interpreter itself, callgrind host-instruction counts are the companion
metric, with the guest count held fixed as a behavior-preservation check.

## The RISC-V platform ABI

The RISC-V backend has a platform-ABI path so compiled output and a
gcc-built C runtime can call each other under RV32 ILP32. The C compiler
uses it in its psABI mode (`check-cc-rv-psabi` under `qemu-riscv32`),
where `skj-cc-rv` output links against a gcc-built runtime.

Getting there was a calling-convention problem. The RV backend passes
every call argument on the stack, which is the toolkit's own
convention; the RISC-V ILP32 ABI passes the first eight in `a0`-`a7`.
On m68k the two coincide, which is why a gcc-built C runtime and
compiled output call each other for free there. On RV32 they could not,
in either direction, so a shim layer would have needed trampolines both
ways.

So the RV backend gained a platform-ABI path under `CC_PSABI`, the flag
x86-64 and AArch64 already use, which `skj-cc-rv` emits in its psABI
mode. The rules it implements, all confirmed against what gcc emits:

- one-word arguments take `a0` through `a7` in order;
- a two-word argument takes the next two registers, low word first, and
  the pair is **not** aligned to an even register the way ARM's EABI
  aligns it;
- with one register left, a two-word argument splits: low word in the
  register, high word first in the outgoing block;
- the rest go in the block, two-word arguments 8-aligned;
- a double crosses through memory (RV32 cannot move the halves of an
  f-register to integer registers), a single through `fmv.x.w`;
- results come back in `a0`, or `a0` and `a1`.

A register parameter is spilled to a home slot in the prologue, so the
rest of the lowering keeps reading parameters from slots and does not
know the difference. A tail call whose arguments all fit in registers
stays a real tail call; one with a stack argument becomes a call and a
return, since the outgoing block would sit under the frame being torn
down. Only the Scheme front end depends on the tail property, and it
does not target this ABI.

`runtime/start_rv_psabi_cc.S` is the matching C runtime: entry and
syscalls under that convention. `runtime/soft64.c` supplies the 64-bit
helpers, since the cross toolchain ships no rv32 libgcc. Both retire a
trap that was already in the tree: `start_rv.S` defines `__muldi3` and
the shift helpers with the stack convention under the standard names, so
gcc-built C calling one would read its arguments from the wrong place.

## The RV32 test rig, and what it is worth

The RV32 core came out of a five-article series that is now finished,
so skjegg is where it is maintained. What came with it matters as much
as the core: six verification methods, each runnable alone, in
`tests/rv32`.

| Method | What it is | Target |
|---|---|---|
| `unit` | seven suites, 443 checks, no reference model | `make test-rv32-unit` |
| `program` | one compiled guest that validates its own results | `make test-rv32-program` |
| `apps` | CoreMark and Lua, which validate their own results | `make test-rv32-apps` |
| `archtest` | 268 compliance tests against qemu-system-riscv32 | `make check-archtest` |
| `fuzz` | randomized encodings against qemu-riscv32, per instruction | `make test-rv32-fuzz` |
| `lockstep` | compiled guests against qemu-riscv32, per instruction | `make test-rv32-lockstep` |

`make check-rv32` runs the two that need no reference model and no
download. Measured on import: 443 unit checks pass, the self-checking
guest passes, arch-test is 268 passed / 0 failed / 4 skipped, lockstep
runs 21,708 instructions across four guests with no divergence, and the
fuzzer compares 25,600 instructions with none.

The `apps` method is neither vendored nor built by default, since each
needs a checkout and Lua needs a second toolchain:

```sh
make test-rv32-apps CM=<path>/coremark LUA=<path>/lua
#   git clone --depth 1 https://github.com/eembc/coremark.git
#   git clone --depth 1 -b v5.4.7 https://github.com/lua/lua.git
#   apt-get install gcc-riscv64-unknown-elf picolibc-riscv64-unknown-elf
```

What those buy over the hand-written guests is that nobody wrote them
with this emulator in mind. CoreMark validates its own workload CRCs
(30.4M instructions retired here). Lua is the harder of the two: it
allocates constantly, uses `setjmp`/`longjmp` for errors, formats
floating point, and runs a script that checks its own answers, so if it
passes then most of a C library and most of the instruction set are
working together (15.0M instructions, all checks pass). Lua needs a C
library the stock riscv cross toolchain does not have, which is what
picolibc is for.

Being able to run each method alone is what let the series measure what
each is worth, which is the part worth keeping:

```
make audit-rv32-coverage   # which lines each method reaches
make audit-rv32-icov       # which guest instructions each method runs
make audit-rv32-mutants    # whether a wrong answer would be noticed
```

Instruction coverage exists because line coverage is the wrong unit for
an emulator: one switch arm serves eight instructions, so a method can
run every line of the decoder while touching a fraction of the
architecture. Reproduced in this tree:

```
method         seen    of 171    unique cumulative
unit             98     57.3%         8         98
program          39     22.8%         0        129
apps             98     57.3%         0        156
archtest        155     90.6%         7        166
fuzz            101     59.1%         0        166
lockstep         89     52.0%         0        166

union           166     97.1%

never executed by any method:
c_ebreak csrrc csrrci csrrsi ebreak
```

The **unique** column is the one to read: instructions a method reaches
that no other method does, which is the closest thing coverage offers
to "what would be lost if this were deleted". Only two methods score
there at all.

That last list is the point. It is the same information as "185
uncovered lines" in a form a person can act on.

**The two measures disagree, and the disagreement is the lesson.**
Lockstep contributes no unique line and no unique instruction, so on
coverage it is redundant; mutation testing says it kills four mutants
nothing else kills. Coverage measures *reach*: did control flow arrive
here. Mutation measures *sensitivity*: if the answer here were wrong,
would anything notice. The fuzzer adds almost no coverage and was for a
long time the only method to find a real bug in this core, because its
value is in the values flowing through a line rather than in reaching
it. Lockstep adds no coverage and supplies the only oracle written by
strangers; everything else compares against expectations written by the
same person who wrote the interpreter. Acting on either measure alone
would delete a method the project cannot do without.

The series also found a defect this way that had been present since the
first commit, and it is the one fixed in this tree: vectored `mtvec`
applied to exceptions as well as interrupts. It survived 268 compliance
tests, a hundred thousand fuzzed instructions and every lockstep run,
because no user-mode reference model has machine mode in it at all.
`gcov` had been reporting that line as uncovered the whole time, inside
a list nobody read, and the first article had excused it by name as
"defensive". It was not defensive; it had simply never been run.

A sanitizer pass (`make check-emu-san`, ASan and UBSan over the
host-only tests) later found a defect none of the value methods could
see: the S/B/J immediate decoders sign-extended by shifting a negative
value left, which is undefined behavior. It produced the right bits on
two's-complement hardware, so every value method, the fuzzer and
lockstep included, ran straight over it, and the coverage audit reported
those lines as reached the whole time. Reach and sensitivity both ask
whether the answer is right; the sanitizer asks whether the code that
produced it is defined, an axis the value methods have no view of.

## Verification gaps and future work

The peripheral layers added since the core, the guest allocator
(`emu/guest.c`) and the process scheduler (`emu/sched.c`, split out of
`rv_user.c` when it became arch-neutral), do not have
the core's verification depth, and a run of reviews found several bugs in
them: `fence.i` not flushing the decode cache, a 32-bit wrap in
`gm_mmap`/`gm_munmap`, `do_spawn` leaving the parent's `mem.fault` set,
and `proc_slice` never clearing `cpu->waiting`. Each of those now has a
regression test, and `make check-emu-san` rebuilds the host-only tests
with ASan and UBSan (it found an undefined left-shift in the S/B/J
immediate decoders on its first run). Three follow-on items would close
the rest of the gap. They follow the same lesson the audit above teaches:
sensitivity, not reach.

1. **A differential for every internal optimization, seeded with its
   adversarial case.** The decode cache is transparent to a guest, so
   qemu is not its oracle; cache-on versus cache-off in one process is
   (`make test-rv-decode-cache`). The `fence.i` bug was the invalidation
   trigger, not the steady state, so the rule is that a cache or hint's
   differential must exercise every invalidation trigger, not just
   re-execution of the same code. A targeted fuzz mode that emits
   store-to-text plus `fence.i` sequences and compares cache-on against
   cache-off would be cheaper and more sensitive for that class than a
   qemu lockstep, which cannot see the cache at all.

2. **A boundary-value table for guest address and size arithmetic.**
   `gm_mmap` and `gm_munmap` compute near the 32-bit boundary, which is
   where the wrap bug hid. Every size or address entry point should be
   driven with a standing table of values around the edges (0, 1, one
   below a page, a page, one page below 4GB, 4GB, and 4GB plus a guard),
   rather than the specific overflow cases now sitting in
   `tests/test_guest_mmap.c` that were added once the bug was known.

3. **Scheduler state invariants and a stress guest.** Both scheduler
   bugs were shared state left set across a lifecycle boundary. A
   debug-build invariant checked between quanta (a runnable process has
   `mem.fault == 0`, and its park flag matches the reason its last
   slice returned) would turn that class into an immediate abort
   instead of a misbehavior found by reading. The one sandbox demo is a
   happy path; a stress guest that spawns many children, exhausts the
   per-child and aggregate memory budgets, and mixes `wfi` park and wake
   would drive the transitions those two bugs lived in.

## Conformance: riscv-arch-test

`make check-archtest ARCHTEST=<path>/riscv-test-suite` runs the RISC-V
compliance suite against the RV32 core. Current result:

```
riscv-arch-test: 268 passed, 0 failed, 4 skipped, 0 did not build
```

covering I, M, A, C, F, F_Zcf, B and Zifencei, in about three minutes.

The suite ships no reference signatures, so the harness produces them:
each test writes its signature over a serial port, and the same binary
is run on `qemu-system-riscv32` to get the same text, which is then
compared byte for byte. The dump is done by the guest rather than by
reading memory through a debugger, because attaching one changes what
is measured, qemu's gdb stub claims the guest's own `ebreak` instead of
letting it trap, and that trap is exactly what the `cebreak` test
exists to check.

`tests/archtest.c` is therefore a second, **bare-metal** machine beside
`skj-run`'s user mode: RAM at 0x80000000, a 16550 transmitter, a CLINT
and a test finisher, since compliance binaries are machine-mode images.
It shares the CPU core and the ELF loader (`elf32_load_raw`, the same
segment walk against a plain byte-write callback).

Two dependencies keep it opt-in rather than part of `check-emu-all`:
`qemu-system-riscv32` for the reference, and a checkout of
riscv-arch-test on branch **old-framework-3.x**. The suite is large and
external, so it is not vendored; `ARCHTEST` points at it, and the
target says what it needs rather than reporting a pass it did not run.
The main branch needs an assembler that pads `.p2align` with nops while
relaxation is disabled, and binutils 2.42 fills it with zeros, which
hangs those binaries on any model.

The 4 skips are honest gaps, not noise: three are Zbc carry-less
multiply, a separate extension from the B suite that this core does not
implement, and one is `C/cebreak-01`, whose signature holds `mstatus`, a
WARL register whose readable bits depend on which privilege modes exist:
qemu's virt CPU has machine, supervisor and user where this core has
machine only, so the two read back different legal values and the test
is not comparable between them.

## Interrupts (RV32)

The RV32 core takes machine-mode interrupts. A host raises and lowers
the three lines a single hart has:

```c
rv_set_irq(cpu, RV_IRQ_TIMER, 1);   /* raise */
rv_set_irq(cpu, RV_IRQ_TIMER, 0);   /* lower */
uint32_t cause = rv_irq_pending(cpu);   /* 0 when none would be taken */
```

`RV_IRQ_SOFT`, `RV_IRQ_TIMER` and `RV_IRQ_EXT` are the three, and they
are the bit positions in `mip` and `mie` as well as the low bits of the
`mcause` an interrupt produces. That is the whole seam: a timer or an
interrupt controller lives in the host, decides when a line is high,
and the core does the rest.

What the core does with it:

- An interrupt is taken **between instructions**, so `mepc` names the
  instruction that has not run yet and `mret` resumes at it. Nothing
  retires on that step.
- Both gates apply: `mstatus.MIE` globally, and the matching bit in
  `mie`. Enabling a bit later takes an interrupt that was already
  raised, because a line is a level and not an edge.
- Priority is the spec's: external, then software, then timer.
- The lines are **level-sensitive**, like the hardware they model. A
  handler that returns without lowering the line, or without clearing
  the bit in `mip` itself, is re-entered. That is a faithful model
  rather than a convenience, and a guest that forgets will livelock in
  its handler exactly as it would on real silicon.
- `wfi` is a nop, which the spec allows, and sets `cpu->waiting`. A
  host driving the machine step by step can read that and jump its own
  clock to whatever raises the next interrupt instead of stepping the
  wait out.
- Vectored `mtvec` (mode 1) sends interrupts to `base + 4*cause` and
  every exception to `base`. **This used to vector both**, so an
  exception landed on whatever entry its cause number happened to hit;
  the fix came with this work and `make test-rv-irq` pins it.

`make test-rv-irq` is a host-side test that drives the core directly
with hand-encoded guest programs, so it needs neither a cross toolchain
nor qemu. It covers delivery, both mask gates, priority, vectored mode
for interrupts and exceptions alike, `wfi`, and level re-entry.

## Guest mmap and guarded stacks (RV32)

A guest can ask the emulator for a fresh, guarded region at run time.
`gm_mmap(m, size, flags)` maps `size` bytes (page-rounded) at an
emulator-chosen address in a dynamic area above the image, heap and
stack, returns the base, and with `GM_MAP_GUARD_LO` places an unmapped
guard page just below it. A guard page is simply a region with
protection 0, so any access to it faults with the reason "stack
overflow" and sets `fault_guard`. `gm_munmap(m, base, size)` releases
the region and its guard. An aggregate commit budget (`struct gm_pool`,
shared across every process in a run) is wired up by the scheduler from
`--total-mem`.

`gm_mmap` computes the whole extent (an optional guard page, the
mapping, and a trailing gap) in 64-bit and refuses anything that would
leave the 32-bit space, so a near-4GB request cannot wrap the cursor and
hand back a low address that overlaps the image, heap, or an earlier
mapping. It reserves the region-table slots up front, so a full table
never leaves a guard page mapped with no mapping behind it. `gm_munmap`
likewise ignores a range whose base plus size wraps past 4GB rather than
walking a bad page count. These bounds are guest self-corruption
concerns, not host escapes: a guest address is never a host address, it
is translated through the per-process page tables to a host page.

The guest reaches this through an **emulator-private host call**, not a
Linux syscall: on RV32, `a7 = 0x000f0001` (`SKJ_SYS_MAP`, `a0` size, `a1`
flags, returns base in `a0`), `a7 = 0x000f0002` (`SKJ_SYS_MUNMAP`), and
`a7 = 0x000f0003` (`SKJ_SYS_SPAWN`, below). The same selector values are
shared by every core (`emu/sched.h`); each puts the number in its own
syscall register (`$v0` on MIPS, `%d0` at `TRAP #0` on ColdFire). Those
numbers sit far above the Linux syscall space, so a real kernel or
`qemu-user` answers `-ENOSYS` and a guest that wanted a guarded region
falls back to whatever it does without one.

A guest that wants a guarded region can install a stack provider that
issues the `MAP` host call with the guard flag. On `skj-run` that
returns a guarded region, so a stack overrun faults on the guard page
instead of silently corrupting the arena; on `qemu-user` the ecall
returns `-ENOSYS` and the guest falls back to an arena block.

Two host-side tests pin these primitives directly, needing no cross
toolchain and no qemu. `make test-guest-mmap` drives `emu/guest.c` with
no CPU: it checks the guard page faults on an overrun, `gm_munmap`
releases the region and its guard, the `gm_pool` aggregate budget caps a
commit, `gm_read_out` copies a range out, and the overflow bounds hold
(a near-4GB mmap is refused with no dangling guard, a wrapping munmap is
a no-op). `make test-rv-run` pins the
`rv_run` batch contract (the reason it returns and the early stop on a
trap, a park, or a halt).

## The process sandbox (one scheduler, every core)

`skj-run` runs one root process, and a guest may spawn children. Each
process has its own CPU, guest memory, and heap and stack, so a child
shares no memory with its parent. A round-robin scheduler (`emu/sched.c`)
runs the live processes a `SKJ_QUANTUM` of instructions at a time; the
batched `ops->run` returns after each slice with the reason it stopped, so
the scheduler reaps a process that exited, halted, or faulted, and
reschedules one that merely spent its slice. This is the consumer the
batched-run reason contract was built for, and one copy serves all three
cores through the `skj_cpu_ops` vtable over a `void *cpu` handle.

The full model this is growing into, a small unix-like system with one sandbox
per process and a `jsh` userland, and the spawn/wait/kill ABI with argument,
environment, descriptor, and capability passing, is written up in
[`process-model.md`](process-model.md). This section covers what ships today.

`SPAWN` (`0x000f0003`, arg0 an image pointer, arg1 its length, returns a
handle) loads a child from an image the guest holds in its own memory: the
host reads the bytes out with `gm_read_out` and loads them with the
in-memory ELF loader into a fresh process. `SPAWNV` (`0x000f0006`) is the same
but takes a size-prefixed request in guest memory so it can also pass an argv
vector (and, later, environment, descriptors, and a mount table); see
[`process-model.md`](process-model.md). A returned handle is a slot plus
a generation, so a handle held past a child's death does not match a later
child that reuses the slot. `SPAWN` is one of the emulator-private host-call
selectors (`MAP`/`MUNMAP`/`SPAWN`/`FATAL`/`YIELD`/`P9`, listed under "How guest
syscalls work"): each sits in the register the core's ABI uses for a syscall
number (a7 on rv, `$v0` on MIPS, `%d0` at `TRAP #0` on ColdFire) with the two
arguments in that ABI's first two argument registers, and the shared handler
(`sched_private`) is the same for all three.

The `--total-mem` cap is an aggregate `gm_pool` budget shared across every
process, so many children cannot together exhaust host memory even though
each keeps its own per-process `--mem` limit. `--child-max-insns` budgets
a spawned child so a runaway child is killed alone rather than stalling
the run.

`make test-rv-sandbox` is the end-to-end demo, with `test-mips-sandbox` and
`test-cf-sandbox` the MIPS and ColdFire twins. One arch-neutral parent/child
C (`tests/sandbox/{parent,child}.c`) is built by each target's in-tree
toolchain over a small per-core `sys.S` of selector stubs; the parent spawns
a child embedded in its own data and does a guarded map and release, and the
child maps a large region and touches every page. Under a generous
`--total-mem` both finish; under a tight one the child exhausts the shared
pool and faults while the parent, isolated from it, still finishes and the
run exits on the root's status. Each demo exercises spawn, the guarded map
and release, the shared budget, and the scheduler resuming a child across
many slices, on its own CPU core.

### The vDSO and the system page

`--vdso IMG` injects a slice of runtime into every process, the way Linux hands
a process its vDSO. The image is a small read-only block of pure leaf functions
(`runtime/vdso.c`), built once and shared across every sandbox: an emulated
guest aliases the one host buffer read-only through `gm_page`, an HV guest backs
a read-only hypervisor memory slot with it. The host advertises the image's
export table through a private auxv tag, and the guest walks its auxv to find it
and calls functions through an ordinal table.

The image also carries a **system page** the scheduler keeps updated, a small
block of host state the guest reads with no doorbell (monotonic and realtime
clocks today, with room for more, QNX-style). `sched_update_sysinfo` refreshes
the clock just before each slice, so it advances at slice granularity, the price
of a trap-free read. The ABI (the tag, the table, the page layout, the ordinals)
lives in `include/skj_vdso.h`; the full account is in
[`process-model.md`](process-model.md), "Injecting runtime". Tests: `test-rv-vdso`,
`test-cf-vdso` and `test-mips-vdso` on the emulated cores (ColdFire big-endian,
MIPS little-endian, so they also prove the loader and the system-page writer
honour the guest byte order), and `test-hv-x86-64-vdso` (plus `test-hv-arm64-vdso`)
on the HV tier, all in `check-emu-all`.

## The filesystem layer (`fs/`)

A guest that does file I/O does not reach the host directly. It goes through
`fs/`, a small filesystem switch shared by every front end: the C libc and the
Kobold runtime both call it. The design, and the guest-versus-host split, are
the subject of this section.

### What it is, and what it is not

`fs/` is a flat table of named, independent namespaces (mounts) with one
selected as current. It is **not** a VFS: there are no subdirectory mounts, no
mount-point crossing, and no unions, so a path never spans two backends. The
model is the old "filesystem switch", with DOS-style drive-letter naming:

```
name:/sub   mount `name`, from its root
name:sub    mount `name`, from that mount's current directory
/sub        current mount, from its root
sub         current mount, from its current directory
```

The layer is language-agnostic and plain C. `fs.c` owns the one shared fd space
and the resolver. It strips the `name:` selector, picks root versus current
directory per the grammar, and dispatches the backend-relative path to the
chosen backend through a `struct fs_backend` operation table
(`open`/`read`/`write`/`lseek`/`readdir`/`stat` and the namespace ops).
Directories are opened with `FS_O_DIRECTORY` and read as fixed `struct
fs_dirent` records, so there is no separate `opendir`. A guest never mounts: the
launcher fills the mount table before the program runs, and the guest only reads
it.

**The default root, `ROOT:`.** Mount index 0 is the default root. `ROOT:` (any
case: `root:`, `Root:`) is a built-in selector alias for it, so a program can
name the default drive without knowing its real mount name. The alias is
resolved only after an exact `name:` match fails, so it never shadows a mount
actually called `ROOT`, and it works whatever backend sits at index 0: the
scratch mount in the default landing (a host directory under `skj-run`, or the
in-guest ramfs in a `FS_WITH_RAM` build), or the first `--mount` grant otherwise.
This is the DOS single-drive case. Almost every workload uses one drive and
treats it as the root, the way `C:` is the only drive on most Windows and DOS
programs, so `ROOT:` names it directly. It is a resolver convenience in `fs.c`,
not a stored name: the table never holds a mount literally called `ROOT`.

### Guest side versus host side

The split is the key thing to keep straight. Almost the whole layer compiles
**into the guest** and never reaches the host.

| Piece | Where it runs | Files |
|---|---|---|
| The switch, resolver, fd space | guest | `fs/fs.c` |
| ramfs (in-memory scratch, optional, `FS_WITH_RAM`) | guest | `fs/ramfs.c` |
| romfs reader (read-only image, optional, `FS_WITH_ROM`) | guest | `fs/romfs.c` |
| devfs (null/zero/full) | guest | `fs/devfs.c` |
| hostcap (confined host tree) | guest client, host kernel enforces | `fs/hostcap.c` |
| 9P client (ninefs) and transport | guest | `fs/ninefs.c`, `fs/p9_guest.c` |
| 9P server | host, inside skj-run | `fs/p9_server.c` |
| hostfs / ambientfs | host-side backends, for the hosted tools and tests | `fs/hostfs.c`, `fs/ambientfs.c` |
| the launcher that fills the table | host, inside skj-run | `guest_install_mounts` (`emu/guest.c`) |
| romfs builder | host tool | `fs/romfs_build.c`, `fs/mkromfs.c` |

The only ways a mount can touch real host files are the two deliberately narrow
host seams below: the confined hostcap backend, and the 9P server.

### The launcher and the mount table

When skj-run loads the root program it runs `guest_install_mounts`
(`emu/guest.c`), which turns the launcher's grants into entries in the guest's
`fs_mounts` table (resolved as guest-ELF symbols) before the first instruction
runs. The guest's own `fs_init` then adopts that table. The command-line grants:

```
--mount    NAME:DIR   a confined host directory (hostcap)
--mount-ro NAME:DIR   the same, read-only (mutating ops return EROFS)
--rom      NAME:IMG   a read-only romfs image parsed in the guest
--dev      NAME       a devfs mount (null/zero/full)
--9p       NAME:DIR   a host directory served over 9P
```

Whenever the launcher grants a guest any mount, it also gives it its own
`scratch`, an ephemeral host directory (one per sandbox, created with `mkdtemp`
and removed at teardown) that is the spot a bare path resolves against. So a
granted guest lands on a private host-owned scratch, and the host is otherwise
reachable only through a mount that was explicitly granted. A guest launched with
no grants keeps its own default landing: the in-guest ramfs when built with
`FS_WITH_RAM`, or the `FS_AMBIENT_DEFAULT` ambient host for the bare-qemu test
harnesses. `fs_mount_aux` carries the extra per-mount parameters that do not fit
the 16-byte table entry: a romfs image's guest address and length, and a 9P
channel's guest address.

### Reaching real host files, confined

Two backends cross to the host, each through a capability rather than an ambient
path:

- **hostcap** (`--mount`, `--mount-ro`). The launcher opens the granted
  directory on the host and hands the guest only a capability fd for it; the host
  fd is never visible to the guest. Every open under the mount is a host `openat`
  relative to that fd with `RESOLVE_BENEATH` (a portable `cap_walk` floor stands
  in where the kernel lacks it), so a `..`, an absolute path, or a climbing
  symlink cannot escape the granted tree. `--mount-ro` adds `FS_RO`, so a
  mutating op returns `EROFS`; the per-sandbox `scratch` directory and the
  `skj-run` userland's read-only `bin:` are both served this way.
- **9P** (`--9p`), described next, where the host side is a real file server the
  guest talks to over a protocol rather than a shared backend.

`hostfs` and `ambientfs` are the unconfined or host-resident variants used by
the hosted tools and the test harness, not by a sandboxed guest. The private
scratch default and the capability-only host access are what keep a bare
`skj-run prog.elf` from seeing the host filesystem: it reaches only its own
scratch directory and whatever was explicitly granted.

### How 9P works, and where each half lives

9P gives a guest a real host directory tree without compiling any
host-filesystem code into the guest: the guest runs a **client**, skj-run runs a
**server**, and they exchange messages. This is the one backend whose host half
is an active server rather than a passive capability.

```
guest                                   host (inside skj-run)
-----                                   ---------------------
fs_open / fs_read / ...                 p9_server.c
   |                                    (a 9P2000 server over a
   v                                     real host directory)
ninefs.c  (9P2000 client)                        ^
   |  builds a T-message                          |  dispatches, builds
   v                                              |  the R-message
p9_guest.c  (transport)                           |
   |  writes the T-message into the shared        |
   |  channel, then rings the doorbell  ----------+
   v
SKJ_SYS_P9 host call (0x000f0005)
```

- The **client** (`fs/ninefs.c`) turns each `fs/` operation into one or more
  9P2000 request/reply exchanges (`Tversion`, `Twalk`, `Topen`, `Tread`, and so
  on). It is freestanding and byte-order-safe: every wire field is
  little-endian, assembled through explicit byte helpers, so one client is
  correct on the big-endian ColdFire guest and the little-endian rv/MIPS guests
  alike.
- The **transport** (`fs/p9_guest.c`) is how the client reaches the server. The
  launcher binds a shared-memory channel in guest memory (`--9p`) and records
  its address in `fs_mount_aux`. To make one call the transport writes the
  framed T-message into the channel, rings the `SKJ_SYS_P9` emulator-private
  host call with the channel's address, and reads the R-message back out. The
  channel is laid out as a request-length word, a reply-length word, and two
  `P9_MSIZE` buffers.
- The **doorbell** is synchronous. `SKJ_SYS_P9` lands in `guest_p9_doorbell`
  (`emu/guest.c`), which finds the server bound to that channel, copies the
  T-message out of guest memory, calls `p9_server_handle`, and writes the
  R-message back into the channel before returning. The guest's call returns
  with the reply already in place, so the client never waits on a separate
  event.
- The **server** (`fs/p9_server.c`) is host-only: it uses the host libc
  directory and file API to serve one session rooted at the `--9p` directory.
  The same `p9_server_handle` entry point also backs an in-process transport for
  the host-only unit test, so the client is exercised with no emulator at all.

Because the guest side is only a client and a byte channel, a 9P guest needs no
host file code and no confinement logic of its own: the server, running on the
host, decides what the session can see.

### Tests

`make test-fs` drives the switch and backends host-only (ramfs, romfs, devfs,
hostcap over a temporary directory, and the 9P client against the in-process
server). Under skj-run the `test-rv-fs-cap`, `test-cf-fs-cap` and
`test-mips-fs-cap` targets exercise the confined `--mount` path end to end on
each core, and `check-emu-posix` reruns them through the portable `cap_walk`
confinement floor.

## Double precision (host double, on by default; revised 2026-10-07)

The RV32 core implements D, in host `double`. The `cpu->dp` flag gates it
(`skj-run` sets it, so double is on by default); with `dp` clear every
D-format instruction is illegal, which is the older F-only core. The
decoding is about 90 lines mirroring the single-precision block for the
D mnemonics the RV corpus uses, and FLD/FSD are the uncompressed forms
only (the compressed `c.fld`/`c.fsd` encodings collide with Zcmp, so
they stay unimplemented). A single value living in a D register is
NaN-boxed, so the F and D ops share one `uint64_t f[32]` register file.

**Double is host-dependent, and that is the point.** Unlike single
precision, double is *not* on the deterministic surface the F core keeps
(see "Single-precision determinism" below). The core computes double
arithmetic in host `double`, so an inexact result, a subnormal, or a NaN
sign can differ between a host that rounds one way and a host that rounds
another, and across WebAssembly embeddings. There is no wider host type
to round from (`long double` is x87-specific and absent on WebAssembly),
so honoring determinism for double would mean a Berkeley-style softfloat
binary64 (directed rounding, the inexact flag, a 106-bit product for the
fused ops), a larger and more delicate body of code than the rest of the
FPU put together. That machinery is not built. Results are canonicalized
only where it is free (a NaN result is forced to a single quiet-NaN bit
pattern), not to force cross-host agreement.

On by default is the right default for the three hosts. boris and
smolmoo run double enabled: neither synchronizes floating-point state
between systems, so host-dependent rounding never shows. Only aldeby
synchronizes state, and only one program on it (the client/server
prediction VM) is sensitive to it; that one must clear `dp` (or use the
deterministic single-precision path) rather than impose a softfloat cost
on everything else. `fadd.d`/`fsd` now run on `skj-run`, so a
double-precision guest no longer needs qemu; qemu stays the cross-check
for double, since it is the independent model.

`_Float16` (Zfh) is still absent on this core (`fmt` must be S or D), so
a `_Float16` guest belongs to qemu.

A committed regression test pins the D decoding: `tests/rv32/test_fp_d.c`
(in `make test-rv32-unit`) checks each D op's dispatch, the full 64-bit
register read/write, the double/single/integer conversions, FLD/FSD
moving eight bytes, and that every D instruction is illegal when `dp` is
clear.

## Single-precision determinism across backends

The single-precision core is not just a convenience, it is the
deterministic floating-point surface the VM hosts build on. A game that
runs its simulation on a smolmoo server and predicts it on a client
needs both sides to compute the same `float` bits, or the prediction
drifts from the authority. The core is built for exactly this: it
depends on no host rounding mode (see above), so its `fadd.s` and the
rest are a fixed function of their inputs on any host, and that function
is verified bit-for-bit against qemu by the fuzz, lockstep and
riscv-arch-test rigs.

That guarantee holds for two peers **running the same core**. It does
not automatically extend to two peers on different code generators. The
plain `test-f32-*` suites do not catch the difference: they use only
exact integer-valued operands, which every IEEE-ish FPU agrees on. The
interesting cases are the inexact, subnormal, NaN and conversion results
where hardware FPUs are free to differ.

`make test-f32-diff` measures that. The oracle is the RV32 core itself:
`tests/f32_oracle.c` drives `emu/rv32.c` over a vector table
(`tests/f32_vectors.h`) and freezes the results as a committed golden
master (`tests/f32_golden.inc`). Each backend's `skj-cc` then compiles
`tests/f32_diff.c`, runs it under that backend's qemu, and checks every
vector against the golden, naming the first divergence.

The finding is that **only peers all running the RV32 emulator are a
verified f32 sync set.** The native-FPU backends diverge from the core
on IEEE-underspecified behavior, and they do not even agree with each
other:

- x86-64 and MIPS produce the opposite NaN sign for `0 / 0`
  (`0xffc00000` where the core canonicalizes to `0x7fc00000`).
- AArch64 agrees there but differs on signaling-NaN quieting.
- ColdFire cannot hold a bit-exact binary32 at all: its FPU computes in
  a wider internal format, so injecting an exact single already loses
  the pattern.

These are reported as XFAIL, not build failures, because they are facts
about the hardware rather than regressions. The one hard gate is
`test-f32-diff-rv`, which catches a real codegen regression in the
shared f32 core (that would break many vectors, not one NaN sign), and
`f32-golden-check` enforces that the committed golden tracks the vector
table. Making a native backend a valid sync peer would mean
canonicalizing NaNs in its codegen, which is not done and is not needed
as long as the peers share the emulator.

This is also what makes an f32 source language practical. The IR, every
backend, and this test already carry a proven single-precision path, so
a language whose `float` is `IR_F32` would land inside the determinism
the games need, with no new emulator work.

## Hardware virtualization (x86-64 and aarch64)

The HV core does not interpret the guest. It runs it natively in 64-bit
supervisor mode under the host's hypervisor, through the same `skj_cpu_ops`
vtable and the same scheduler as the emulated cores (`emu/hvcore.c` is the
binding, the sibling of `rv_user.c`, serving both x86-64 and aarch64). The
hypervisor is Linux KVM (`emu/vmm_kvm.c`) or macOS Hypervisor.framework
(`emu/vmm_hvf.c`), chosen by the build host. The guest architecture must equal
the host's, since cross-architecture virtualization is not possible: an x86-64
host runs an x86-64 guest, an aarch64 host an aarch64 guest. See the
prerequisites table below for what each platform needs.

The guest reaches the sandbox syscall layer through one trap: an eight-byte
load from `SKJ_HV_DOORBELL` (`0x30000000`), an address that is mapped but
unbacked, so it faults out as an MMIO read. The syscall number is in the number
register and the arguments in the argument registers, in the platform's Linux
syscall ABI (on x86-64, `rax` and `rdi,rsi,rdx,r10,r8,r9`). The host reads the
registers, services the call through the same arch-neutral `guest.c` layer the
emulated cores use, and returns the result as the load's data, which the kernel
places in the return register. The emulator-private `MAP`/`MUNMAP`/`SPAWN`/
`FATAL`/`YIELD` selectors work the same way. `emu/skj_hv_abi.h` is the contract.

Guest RAM is one contiguous host buffer (256 MiB) mapped as the vcpu's physical
memory at guest-physical 0, with an identity map so a guest virtual address
equals its physical address. On x86-64 the host writes long-mode page tables
into guest RAM and points CR3 at them. On aarch64 the host lays a flat level-1
block table into guest RAM and programs `TTBR0_EL1`/`TCR_EL1`/`MAIR_EL1`/
`SCTLR_EL1` to turn the MMU on before the first run; this is required, not an
optimization, because with the MMU off every access is Device memory, where the
compiler's unaligned loads fault. The page-table layout and the aarch64 register
values are shared by both backends in `emu/skj_hv_abi.h`. The ELF64 loader
writes the image into the buffer, and `guest.c`'s syscall layer reaches it
through an extern-backed `guest_mem` region (`gm_set_extern`), so the whole
arch-neutral memory and stack machinery works unchanged. The guest image, heap
and stack live under 4 GiB, so the 32-bit guest-memory index addresses them.
Linking stays external (GNU `ld` for the ELF64 guests), since the in-tree linker
is ELF32.

The guest runtime is a crt (`runtime/start_<arch>_hv.S`, the ELF entry) and the
Linux syscall seam issuing the doorbell load (`runtime/syscall_<arch>_hv.S`).
The seam exports the same symbols as `syscall_rv.S`, so the freestanding C libc
and the Kobold runtime link against it unchanged. The whole freestanding C libc
(string, printf and scanf, malloc over `brk`, stdio, the math helpers, delimited
continuations and the cooperative threads) runs under the VMM this way:
`make check-libc-hv-x86-64` builds the libc with `skj-cc-x86-64`, links it with
the HV crt and seam, and runs the self-checking phase programs under `skj-run`
on real KVM. `make test-hv-x86-64` runs a bare-asm guest and a C guest. Both
skip cleanly when `/dev/kvm` is absent or inaccessible.

aarch64 is at parity in the tree: the same `hvcore.c` binding, the arm64 crt and
seam (`runtime/start_arm64_hv.S`, `runtime/syscall_arm64_hv.S`), and the same
libc tier (`make check-libc-hv-arm64`, `make test-hv-arm64`). Since a guest runs
only on a host of its own architecture, these build on any host and run only on
an aarch64 hypervisor host (a Linux aarch64 KVM box, or Apple Silicon under HVF);
off one they report a build pass.

The VMM seam (`emu/vmm.h`) is backend-neutral: it names its own `vmm_*` types
and keeps clear of the host APIs (`kvm_*` on Linux, `hv_*` on macOS) that each
backend uses internally. The two backends are peers under the same seam: the
Linux KVM backend (`emu/vmm_kvm.c`) and the macOS Hypervisor.framework backend
(`emu/vmm_hvf.c`, Apple Silicon). Each carries a stub fallback for a host without
its hypervisor, so `skj-run` builds everywhere and reports the VMM unavailable at
run time where it cannot virtualize. The build picks the backend by host OS; a
vendored sandbox resolves it the same way, with an `ifeq ($(shell uname -s),
Darwin)` in the generated `skjegg.mk`.

### Prerequisites and setup per platform

| Host | Backend | Guest arch | Prerequisites | Setup to run a guest |
|------|---------|-----------|---------------|----------------------|
| Linux x86-64 | KVM | x86-64 | `/dev/kvm` present and read/write accessible | add the user to the `kvm` group (`sudo usermod -aG kvm $USER`, then re-login), or run as root |
| Linux aarch64 | KVM | aarch64 | `/dev/kvm` present and read/write accessible | same as above |
| macOS Apple Silicon | HVF | aarch64 | macOS on Apple Silicon (`sysctl kern.hv_support` reports 1); the Hypervisor framework is linked by the build (`-framework Hypervisor`) | code-sign `skj-run` with the `com.apple.security.hypervisor` entitlement, for example `codesign -s - --entitlements hv.entitlements --force build/skj-run` where the plist sets that key true. Ad-hoc signing is enough for local development |
| macOS Intel | none (stub) | n/a | not supported in this tree (the HVF backend is Apple Silicon only) | the VMM reports unavailable |
| any other host | none (stub) | n/a | no supported hypervisor | the VMM reports unavailable |

A few platform notes:

- **Access, not just presence.** `skj-run` opens `/dev/kvm` read/write, so a host
  where the node exists but the user lacks `kvm`-group access cannot virtualize.
  The `make test-hv-*` targets probe that access and skip cleanly (the arm64 one
  reports a build pass) rather than failing.
- **Building the guest ELF on macOS.** The mac has no ELF linker, so the arm64
  HV guest (an ELF64) is cross-linked elsewhere (an aarch64 Linux `ld`, or a
  cross `aarch64-linux-gnu-ld`) and copied over. The host tools and `skj-run`
  itself build natively with the stock Apple clang.
- **The entitlement gates running, not building.** `skj-run` links the framework
  and builds without special privilege; only launching a guest needs the signed
  entitlement. Without it `hv_vm_create` fails and the VMM reports unavailable.
- **One backend per build.** Because the guest arch equals the host arch, a given
  build has exactly one usable backend. The other architectures still compile in
  (the ELF header picks the core at run time), but only a guest of the host's own
  architecture can run under the VMM.

`--gdb` serves this tier too. `emu/hv_gdb.c` is the HV sibling of the rv32 and
MIPS stubs, plugged into the scheduler through the same `ops->gdb` hook. It
keeps a host-side breakpoint table and single-steps the vcpu through the VMM, so
guest memory is never patched and the doorbell MMIO is serviced transparently
while the guest's syscalls still run. gdb learns the architecture from the ELF,
so the stub sends no target description, and the host's native gdb debugs an
x86-64 guest. A null-deref guest triple-faults into a KVM shutdown (the
long-mode guest installs no interrupt table), so there is no debuggable fault
frame as on the emulated cores. `make test-hv-gdb` drives it end to end (break,
registers, memory, exit) and skips when `/dev/kvm` is absent or inaccessible, or
gdb is not installed; `make test-hv-gdb-fpwatch` additionally covers the
floating-point registers in the g-packet and a `Z2` write watchpoint.

The tier is at parity with the emulated sandboxes. File I/O works the same way:
the libc fd model routes through the shared `fs/` layer, and the ambient backend
reaches the host by bare path (or a `--mount` grant confines it), exactly as on
the rv and cf freestanding tiers. `make check-libc-hv-x86-64` runs the full phase
set under KVM, the file phases (statx, pathops, readdir) included. Preemption
works the same way too: a compute-bound guest that never traps to a doorbell is
still interruptible. A hypervisor cannot count retired instructions, so the slice
currency is wall-clock time. A periodic 10 ms timer breaks the guest run out
(on KVM the timer signal is blocked everywhere but inside `KVM_RUN`, so host work
and a future guest-side fault handler are never charged; on HVF the timer handler
calls `hv_vcpus_exit` to force the vcpu out), and the core treats that interrupt
as a full slice spent, which keeps the round-robin scheduler fair and makes
`--max-insns` bound a runaway guest. `make test-hv-preempt` proves it: a spin
guest is stopped at the instruction cap rather than holding the vcpu forever.

Current limits of this tier:

- A supported hypervisor is required: Linux KVM, or Hypervisor.framework on
  Apple Silicon. Without one (no accessible `/dev/kvm`, or an unsigned or Intel
  macOS binary) the core reports the VMM unavailable and the run fails cleanly.
- The slice currency is time, not retired instructions, so `--max-insns` counts
  10 ms slices rather than exact instructions. It bounds a runaway guest, but it
  is a coarser unit than on the emulated cores.
- The HVF backend is Apple Silicon only; there is no x86-64 macOS VMM.

## Limits

- The RV32 core has F and D (D in host double, on by default; see
  above), but not Zfh. A `_Float16` guest on that target belongs to
  qemu. A double guest runs on `skj-run`, but its results are
  host-dependent, so a guest that must agree bit-for-bit across hosts
  uses the deterministic single-precision path or clears `dp`.
  ColdFire's FPU is full 64-bit.
- `skj-run` is user mode only. A bare-metal mode (memory-mapped
  devices, the shape the VM hosts use) is not exposed as a flag,
  though `tests/archtest.c` now shows the shape of one for RV32 and
  both cores support it.
- The `--gdb` remote stub covers rv32, MIPS and the HV cores (x86-64
  and aarch64), not ColdFire yet. Each carries the integer and
  floating-point registers and `Z2` write watchpoints (not read/access
  watchpoints or hardware breakpoints).
  gdb's prologue-only MIPS unwind of CFI-less skj-cc code stops short
  of the full call chain (skj-run's own DWARF backtrace walks it).
- `skj-as` has no `rems`/`remu` mnemonic, so a front end cannot ask for
  the remainder instruction directly. The emulator implements it.
