# Running a Kobold-Pascal program in the RV32 sandbox

This is the end-to-end path from a Kobold-Pascal source file to a program running
inside the in-tree RV32 emulator (`skj-run`, the `emu/rv32.c` core). It is the
freestanding tier: the program links against the no-libc guest runtime, so it is
the same build a real RV32 VM host would load, not a hosted libc executable.

`skj-kp-jit` (see `kp-guide.md`) is the quickest way to run a program on the
host, and `kobold/aot-run.sh` builds a hosted native executable. Neither loads
the program into the emulator. This document covers that path, whose steps
otherwise live only in the test runner.

## The pipeline

```
prog.pas ──(1)──▶ prog.kpm ──(2)──▶ prog.s ──(3)──▶ prog.o ──(4)──▶ prog.elf ──(5)──▶ run
        frontend          skj-kp-rv       skj-as-rv       skj-ld-rv        skj-run
       (host-native)      (RV32 AOT)      (RV32 as)      (+ crt + lib)     (rv32.c)
```

Stage 1 runs the `kpcom` front end natively on the host. It is the only
host-specific stage. It needs no `fpc` or external Pascal toolchain: the native
front-end binary (`skj-kpc-rv` / `skj-kpc-cf`, which `skj-pc` builds from
`kobold/kpcom.pas`) reads the source and emits the module directly. Stages 2 to 4
are host-independent cross tools that emit and consume RV32 regardless of the
machine they run on. Stage 5 is the emulator.

## No fpc is involved

`fpc` is only used by `make bootstrap-fpc`, the compiler-independence proof (it
rebuilds the front end from source and checks it emits the same module as the
`skj-pc` build). That target is never on the normal build path. The normal build
compiles `kobold/kpcom.pas` with `skj-pc` into the front end, so no `fpc` is
involved.

There is no committed seed to regenerate. After editing `kobold/kpcom.pas`, a
plain build rebuilds the front end from source and each target re-emits its own
seed. That works on any supported host; compiling your own `.pas` with the front
end works on any supported host too.

## Build the tools once

The front-end binary differs by host. The cross toolchain and the emulator are
the same on every host.

```sh
# the native front end (one of these, matching the host):
make build/skj-kpc              # x86-64 host
make build/skj-kpc-arm64        # aarch64 host

# host-independent: the RV32 cross toolchain, freestanding runtime, emulator
make build/skj-kp-rv \
     build/skj-as-rv \
     build/skj-ld-rv \
     build/kpfree-rv/kp_crt_rv.o \
     build/libkpaot-rv-free.a \
     build/skj-run
```

`skj-kp-jit` (x86-64) or `skj-kp-jit-arm64` (aarch64) work in place of `skj-kpc`
for stage 1. They JIT the same seed and emit byte-identical KPM1.

## Compile and run

```sh
FE=build/skj-kpc        # or build/skj-kpc-arm64 on an aarch64 host

# 1. source to a KPM1 module (the front end runs natively on the host)
$FE --emit-kpm prog.pas -o prog.kpm

# 2. KPM1 module to RV32 GAS assembly
build/skj-kp-rv prog.kpm -o prog.s

# 3. assemble to an RV32 object
build/skj-as-rv -o prog.o prog.s

# 4. link the crt, the program, and the freestanding runtime into a static ELF
build/skj-ld-rv -o prog.elf \
    build/kpfree-rv/kp_crt_rv.o \
    prog.o \
    build/libkpaot-rv-free.a

# 5. load and run in the RV32 sandbox
build/skj-run prog.elf
```

`skj-run` is a drop-in for `qemu-riscv32` on this path, so
`qemu-riscv32 prog.elf` runs the same ELF as an independent cross-check.

## The link order matters

The three link inputs go in this order, and the order is load-bearing:

1. `build/kpfree-rv/kp_crt_rv.o` is the crt: `_start`, the syscall wrappers over
   `ecall`, the bump arena, and the coroutine context switch. It must come first
   so `_start` is the entry.
2. `prog.o` is your compiled program.
3. `build/libkpaot-rv-free.a` is the freestanding guest runtime: the compute
   runtime (`str_core`, `dynarr`, `map`), the guest heap over a handed-in region,
   the console and exit seam, and the 64-bit integer and coroutine helpers. It
   comes last so the linker pulls only the archive members the program
   references.

This is the freestanding tier (`KP_FREESTANDING`, double-precision reals). It is
distinct from the hosted `libkpaot-rv.a` that `kobold/aot-run.sh` links against a
libc for a Linux or qemu run.

## Running it as a spawned child instead of the root program

The steps above run the program as the root ELF the emulator loads. The RV32
sandbox can also spawn a compiled guest as a child process (its own CPU, memory,
heap, and stack) over `RV_SYS_SPAWN`. `tests/xlang-sandbox/` is the worked
example: a C root process (built with `skj-cc-rv`) spawns a Kobold-Pascal child
built through this same `skj-kp-rv` to `skj-as-rv` to `skj-ld-rv` chain, proving
a C guest and a Kobold-Pascal guest are the same kind of thing to the sandbox,
both being RV32 ELFs from the one shared IR. See `make test-rv-xlang-sandbox` and
`doc/tools/emulator.md`.

## The compiler itself in the sandbox

Stage 1 above runs the front end natively on the host, but that is a choice, not
a requirement. `kpcom` is an ordinary Kobold-Pascal program, so it compiles
through this same RV32 and ColdFire pipeline into a guest ELF and runs inside
`skj-run`. The in-guest compiler is a verified fixed point: the KPM1 it emits is
byte-identical to the KPM1 the host compiler emits for the same source.

Two tiers of check cover it, on both the RV32 and the ColdFire guest:

- `make test-rv-selfhost-kpc` and `make test-cf-selfhost-kpc` compile a small
  program (`hello.pas`) with the in-guest `skj-kpc` and compare the emitted KPM1
  to the host compiler's. Fast, suitable for routine runs.
- `make test-rv-selfhost-kpc-full` and `make test-cf-selfhost-kpc-full` compile
  `kpcom`'s own source (`kobold/kpcom.pas`, about 480 KB) with the in-guest
  compiler and compare that KPM1 to the host's. This is the compiler reproducing
  itself in the sandbox. It is opt-in and slow, since the whole source runs
  through the RV32 or ColdFire interpreter, and it needs a larger guest heap
  (the target passes `--heap 256M`).

The guest ELF is built the same way a program is: `skj-kp-rv` (or the ColdFire
`skj-kp-cf`) compiles the build-time seed (`build/kpcom-rv.kpm`, or
`build/kpcom-cf.kpm`) to assembly,
`skj-as-rv` assembles, and `skj-ld-rv` links the freestanding crt, the compiler
object, and the freestanding runtime archive. Byte-identical output means the
in-guest compiler is a true peer of the host compiler, not an approximation:
anything the host compiler accepts and lowers, the guest compiler lowers the
same way, including the threaded-dispatch surface (`@label` computed goto and a
procedural value called through a computed designator). The host restriction in
"No fpc is involved" is about regenerating the seed, which still needs the
x86-64 or aarch64 host JIT; compiling a program, or compiling `kpcom` itself,
runs in-guest.

## How the tests exercise this

`tests/run-kp-src-tests.sh` runs exactly this pipeline in its `free` mode: the
native front end emits the module, `skj-kp-rv` compiles it, `skj-as-rv`
assembles, `skj-ld-rv` links the crt, program, and freestanding archive, and the
ELF runs under `skj-run` (passed as the `QEMU` prefix) or `qemu-riscv32`. The
`make check-kp-io-free` and `check-kp-inc-free` targets drive it, so the path is
covered in CI, not only documented here.
