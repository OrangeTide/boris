---
title: Vendor the RV32 Emulator Core
status: done
gitlab-sync: OrangeTide/boris#91
---

Phase 1 of the VM pivot. Bring in and own the RV32 CPU emulator core and
ELF32 loader, and wire the host seam without any game integration yet. See
doc/mud-vm-design.md "Emulator" and doc/vm-migration-plan.md Part 2.

The core is self-contained (`<stdint.h>` and `<string.h>` only) and a
verbatim copy of the upstream skjegg core apart from the license header.
The owner relicenses the imported files into boris's license as a separate
human step.

## Tasks

- [x] Copy `rv32.c`, `rv32.h`, `elf32.c`, `elf32.h` into `src/rv32/` with a
      `module.mk` declaring the library and a `test_rv32` target.
- [x] Provide boris's memory bus callbacks (read8/16/32, write8/16/32) over
      a bounded, little-endian memory image, plus an access-probe hook. Out
      of-range access traps via the probe, so the callbacks never touch host
      memory out of range.
- [x] Wire a stub `ecall` handler (real dispatch lands in vm-hostcall-abi).
- [x] Unit tests: instruction execution, out-of-range load and store faults,
      and the ELF32 loader against a hand-built minimal image. 17 checks,
      `make check` green (26 suites).

## Notes

- `rv32.c` and `rv32.h` are vendored verbatim from skjegg's `emu/`, the merge
  point for this project's `rv_run` stop-reason API and kobold-pascal's
  decoded-instruction cache. Re-vendoring from skjegg keeps the core a clean upstream copy with
  no local diff. The decoded-instruction cache (`rv_dec_enable`/`rv_dec_free`)
  is opt-in and left off; the runtime does not enable it.
- `elf32.c`/`elf32.h` are ours, adapted to drop the `guest.c` sparse-memory
  dependency: the `guest *`-based `elf32_load` and `elf32_load_mem` are
  removed, and a byte-poke `elf32_load_raw_mem` was added so a flat memory
  image loads an image without `guest.c`. They are not re-vendored from
  skjegg, whose `elf32` still uses the sparse `guest` memory.
- The bus callbacks, bounded memory image, probe, and stub ecall live in
  `test_rv32.c` for now. The reusable per-task memory image and the
  cooperative scheduler are `vm-task-runtime` (Phase 2); the real host-call
  dispatch is `vm-hostcall-abi` (Phase 2). `src/rv32/` builds as a library
  but is not yet linked into `boris`.
