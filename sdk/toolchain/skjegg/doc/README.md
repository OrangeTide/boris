# Skjegg

Skjegg is a retargetable compiler toolkit: a shared 3AC intermediate
representation, multiple backends, and multiple language front ends.
It favors implementation simplicity over sophisticated optimization,
trading a small effort for a big payoff.

## Tools

| Tool         | Description                                  | Status      |
|--------------|----------------------------------------------|-------------|
| `skj-tinc`   | TinC compiler (minimal C)                    | Working     |
| `skj-sc`     | TinScheme compiler                           | Working     |
| `skj-mooc`   | MooScript compiler                           | Working     |
| `skj-pc`     | Compact Pascal compiler                      | Working     |
| `skj-cc`     | C compiler (C89 + C99 subset)                | Working     |
| `skj-cpp`    | C preprocessor (library, also used by `cc`)  | Working     |
| `skj-as`     | ColdFire/m68k assembler (GAS subset -> ELF32)| Working     |
| `skj-ld`     | ColdFire/m68k static linker                  | Working     |
| `skj-as-rv`  | RISC-V RV32 assembler                         | Working     |
| `skj-ld-rv`  | RISC-V RV32 static linker                     | Working     |
| `skj-as-mips`| MIPS I assembler                              | Working     |
| `skj-ld-mips`| MIPS I linker (ELF and PlayStation PS-EXE)    | Working     |
| `skj-ar`     | `ar(1)` archive tool (any ELF32 target)       | Working     |
| `skj-run`    | Guest runner (ColdFire and RV32 cores)        | Working     |

Most compilers exist in per-backend variants (for example `skj-cc-rv`,
`skj-cc-x86-64`, `skj-cc-arm64`).  The `skj-as`/`skj-ld` family is a
binutils-free assembler and linker for the ColdFire, RISC-V, and MIPS
targets, verified against GNU as and the qemu suites.

## Architecture

```
front ends              shared IR              backends
──────────              ─────────              ────────
tinc/    ──┐                               ┌── backend/cf_emit.c     (ColdFire/m68k)
scheme/  ──┤                               │
moo/     ──┼──▶  ir/ir.h  ──▶  regalloc  ──┼── backend/rv_emit.c     (RISC-V RV32IMFD+Zfh)
pascal/  ──┤       │                       │
cc/      ──┘       │                       ├── backend/x86_emit.c    (x86-32 and x86-64)
  ▲                │                       │
  │                └── ir/ir.c, ir/util.c  ├── backend/arm64_emit.c  (AArch64)
  │                                        │
cpp/  (preprocessor library)               └── backend/mips_emit.c   (MIPS I / R2000/R3000)
```

Each front end lowers source to the same IR (defined in `ir/ir.h`).
The IR feeds a target-specific register allocator and code emitter.
Adding a new front end means writing `lex.c`, `parse.c`, `lower.c`, and
`main.c`; the IR and backends are reused unchanged.  Adding a new
backend means writing a regalloc + emitter pair and a
`runtime/start_*.S`.

Not every front end targets every backend.  TinC and TinScheme run on
every backend.  The C compiler runs on ColdFire, RISC-V, x86-64,
AArch64, and MIPS (not x86-32).  MooScript and Compact Pascal are
ColdFire only.  The x86-32 and x86-64 targets share one backend,
selected at compile time by `X86_BITS`.

## Layout

```
ir/          portable IR library (types, opcodes, builder)
backend/     code generation: ColdFire, RISC-V RV32, x86-32/64, AArch64, MIPS I
as/          ColdFire assembler, plus the RV32 and MIPS front ends over a shared skeleton
ld/          ColdFire linker, plus the RV32 and MIPS front ends over a shared layout core
ar/          target-neutral ar(1) archive tool
cpp/         C preprocessor (library and standalone tool)
emu/         ColdFire and RV32 emulator cores, and skj-run (doc/tools/emulator.md)
runtime/     target runtimes (start_*.S per target, pascal_rt.c, str.c, list.c, 64-bit helpers)
tinc/        TinC front end (C-like)
scheme/      TinScheme front end (Scheme subset with GC; doc/internals/closures.md)
moo/         MooScript front end
pascal/      Compact Pascal front end (doc/languages/pascal.md)
cc/          C front end (uses the cpp library)
tests/       test programs and harnesses
doc/         design and reference docs (tools/, languages/, internals/)
```

## Documentation

The reference manual is published at
<https://orangetide.github.io/skjegg-compiler-suite/>, organized by language,
tool, and internals. Its source of truth is the Markdown under `doc/`:

- `doc/languages/` the language front ends, including the full Kobold-Pascal
  specification under `doc/languages/kobold/` (grammar, language reference,
  units, module format, host ABI, and more).
- `doc/tools/` the emulator, the JIT, the libc, and the MIPS backend.
- `doc/internals/` the shared IR, calling conventions, closures, and the LP64
  model.

Build the manual locally with `make -C doc` (HTML) or `make -C doc all` (HTML
and PDF); it needs `pandoc`, and PDF output additionally needs `typst`. The
built site lands in `build/manual/`, and `build/manual/index.html` opens
directly in a browser.

## Prerequisites

- A host C compiler (`cc`, C99).
- `m68k-linux-gnu-gcc` (Debian/Ubuntu: `gcc-m68k-linux-gnu`).
  `m68k-linux-gnu-as` and `m68k-linux-gnu-ld` are optional, since
  `skj-as` and `skj-ld` can replace them.
- `qemu-user` for the user-mode emulators (`qemu-m68k`, `qemu-riscv32`,
  `qemu-i386`, `qemu-x86_64`, `qemu-aarch64`, `qemu-mipsel`).

Per-target toolchains, needed only to build and test that target:

- RISC-V: `binutils-riscv64-linux-gnu` (and `gcc-riscv64-linux-gnu` for
  a gcc-built guest runtime).  `skj-as-rv`/`skj-ld-rv` can replace binutils.
- AArch64: `gcc-aarch64-linux-gnu`, `binutils-aarch64-linux-gnu`.
- MIPS: `binutils-mipsel-linux-gnu` (or a bare-metal `mipsel-none-elf`
  cross).  `skj-as-mips`/`skj-ld-mips` can replace binutils.
- x86: a host `as` (GNU binutils, intel mode) and a host `ld`.

## Build and Run

```sh
make              # build all tools (every front end, backend, and toolchain)
make check        # ColdFire suite: compile, assemble, link, run under qemu-m68k
make check-rv     # RISC-V RV32 suite under qemu-riscv32
make check-x86    # x86-32 suite under qemu-i386
make check-x86-64 # x86-64 suite under qemu-x86_64
make check-arm64  # AArch64 suite under qemu-aarch64
make check-cc     # C compiler tests (skj-cc -> skj-as -> skj-ld -> qemu-m68k)
make check-cpp    # C preprocessor tests
make check-rvas   # RV32 assembler/linker golden-master vs GNU as
make check-all    # the whole qemu matrix across every backend
make check-smoke  # full in-tree toolchain smoke test (no cross toolchain needed)
make clean        # remove build/
```

`make help` prints the full target set (per-backend suites, the
emulator tiers, the MIPS and PlayStation paths, and the integer/float
integration tests).  `make check-smoke` exercises the full in-tree
pipeline (front end -> `skj-as` -> `skj-ld` -> `qemu-m68k`) without
requiring `m68k-linux-gnu-as` or `m68k-linux-gnu-ld`.

## Using the Tools Directly

```sh
# TinC for ColdFire, using the in-tree assembler and linker
./build/skj-tinc -o out.s tests/bsearch.tc
./build/skj-as -o out.o out.s
./build/skj-as -o start.o runtime/start.S
./build/skj-ld -o prog start.o out.o
qemu-m68k ./prog ; echo $?

# C for RISC-V RV32, using the in-tree RV toolchain
./build/skj-cc-rv -o out.s tests/cc_t001_return.c
./build/skj-as-rv -o out.o out.s
./build/skj-as-rv -o start.o runtime/start_rv.S
./build/skj-ld-rv -o prog start.o out.o
qemu-riscv32 ./prog ; echo $?
```

## Vendoring

`vendor.sh` copies selected Skjegg components into another project.
Pick one or more backends and front ends, plus optional tools.  The IR
core is always included.

```sh
# Vendor TinC + Pascal with the ColdFire backend and assembler
./vendor.sh coldfire tinc pascal as

# Vendor just the C compiler (pulls in the cpp library automatically)
./vendor.sh coldfire cc

# Vendor the binutils-free RISC-V toolchain on its own
./vendor.sh as-rv ld-rv

# Vendor into a custom directory
./vendor.sh -d lib/skjegg coldfire tinc
```

The script generates two files in the destination directory:

- **`skjegg.mk`**, an includable Makefile fragment that builds exactly
  the selected components.  Add `include skjegg/skjegg.mk` to your
  project's Makefile.
- **`update-skjegg.sh`**, a copy of `vendor.sh` with the selection baked
  in, so re-running `./skjegg/update-skjegg.sh` updates without
  repeating arguments.

The `ORIGIN` variable at the top of `vendor.sh` controls where sources
are fetched from (defaults to the GitHub repository).  Edit it to point
at a fork or local path.

### Components

| Name       | What it vendors                                          |
|------------|----------------------------------------------------------|
| `coldfire` | ColdFire/m68k backend + `runtime/start.S`                |
| `riscv`    | RISC-V RV32 backend + `runtime/start_rv.S`               |
| `x86`      | x86-32 / x86-64 backend + runtime                        |
| `mips`     | MIPS I backend + runtime (incl. the soft-float path)     |
| `tinc`     | TinC front end                                           |
| `scheme`   | TinScheme front end (with GC)                            |
| `moo`      | MooScript front end + `runtime/str.c`, `list.c`          |
| `pascal`   | Compact Pascal front end + `runtime/pascal_rt.c`         |
| `cc`       | C compiler front end (auto-includes the cpp library)     |
| `as`, `ld` | ColdFire assembler and linker (library + standalone)     |
| `as-rv`, `ld-rv`     | RISC-V RV32 assembler and linker               |
| `as-mips`, `ld-mips` | MIPS assembler and linker (ld-mips writes PS-EXE) |
| `ar`       | target-neutral `ar(1)` archive tool                      |
| `cpp`      | C preprocessor (library + standalone tool)               |
| `emu-cf`, `emu-rv`   | the ColdFire and RV32 emulator cores           |

A front-end selection needs at least one backend.  The `cc` component
pulls in the `cpp` library automatically.  The AArch64 backend is not
yet vendorable; it builds only in-tree.

## Name

Norwegian: *skjegg* (beard).  From the idiom *a sta med skjegget i
postkassa*, to get your beard stuck in the mailbox.
