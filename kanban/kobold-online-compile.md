---
title: Kobold-Pascal in-world @compile
status: done
gitlab-sync: OrangeTide/boris#118
---

`@compile` now supports Kobold-Pascal (`.pas`, `.kp`) alongside C and
assembly, running the toolchain as RV32 guests over a hostcap build directory
(see vm-online-toolchain, doc/vm-skjegg-rebase.md).

The v0.39 Kobold pipeline is four stages: the front end `skj-kpc-rv.elf`
lowers the source to a KPM1 module, the backend `skj-kp-rv.elf` compiles that
to RV32 asm, then the shared `skj-as-rv` / `skj-ld-rv` assemble and link it
against the Kobold freestanding runtime (`libkpaot-rv-free.a`) and its crt
(`kp_crt_rv.o`). The front end is itself a Kobold program, built by the host
backend from the vendored rv32 KPM1 seed.

Building the backend as a guest surfaced an skj-cc-rv bug: `sizeof` in a
file-scope static initializer folded to the size of `int`, so kpm.c's
`op_count` became 1 and the backend rejected every opcode. Fixed in the
vendored compiler (const_eval types the sizeof operand through a lowering
hook).

## Tasks

- [x] Build the Kobold toolchain stages as RV32 ELFs in `make -C sdk/vm
      toolchain` (skj-kp-rv.elf backend, skj-kpc-rv.elf front end).
- [x] Validate the stages run as guests and produce a valid RV32 ELF.
- [x] Add the `.pas`/`.kp` language path to `src/vfs/vfs_compile.c`.
- [x] Extend `data/help/@compile` and the test to cover Kobold.
