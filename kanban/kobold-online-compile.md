---
title: Kobold-Pascal in-world @compile
status: backlog
---

`@compile` supports C and assembly, running the toolchain as RV32 guests over
a hostcap build directory (see vm-online-toolchain, doc/vm-skjegg-rebase.md).
Extend it to Kobold-Pascal (`.pas`, `.kp`).

The v0.39 Kobold pipeline differs from the retired `skj-kp-jit` path the old
branch used, so it needs its own validation like the C toolchain got: confirm
the Kobold front end and the KPM1-to-RV32 stage build as RV32 ELFs against the
confined libc and run as guests under the embedded runtime.

## Tasks

- [ ] Build the Kobold toolchain stages as RV32 ELFs in `make -C sdk/vm
      toolchain` (skj-pc-rv / skj-kp-rv, or the in-guest skj-kpc-rv.elf).
- [ ] Validate the stages run as guests and produce a valid RV32 ELF.
- [ ] Add the `.pas`/`.kp` language path to `src/vfs/vfs_compile.c`.
- [ ] Extend `data/help/@compile` and the test to cover Kobold.
