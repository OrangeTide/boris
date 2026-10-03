---
title: Remove the ColdFire Emulator
status: done
gitlab-sync: OrangeTide/boris#94
---

Phase 0 of the VM pivot. Delete the ColdFire V4e emulator, the machine
runtime, the m68k guest SDK, and their integration, so the build is clean
before the RV32 sandbox is wired in. See doc/vm-migration-plan.md Part 1 for
the full touch-point inventory.

## Tasks

- [x] Delete `src/coldfire/`, `src/machine/`, `sdk/machine/`,
      `data/machine/`, and `sample/objs/programs/`.
- [x] `src/module.mk`: drop `coldfire` and `machine` from `SUBDIRS`, the
      three `machine/*.c` entries from `boris_SRCS`, and `machine` and
      `coldfire` from `boris_LIBS`.
- [x] `module.mk` (top level): drop `-Isrc/coldfire` and `-Isrc/machine`
      from `PROJECT_CPPFLAGS`.
- [x] `src/boris.c`: remove the `obj_program.h` and `program.h` includes and
      the `program_init` / `program_shutdown` / `obj_program_init` /
      `obj_program_shutdown` wiring.
- [x] `src/cmd/move.c`: remove the `objref.h` and `obj_program.h` includes
      and the `script:`-domain exit dispatch block.
- [x] `src/mudconfig.h`: remove `image_path`. `src/common.c`: remove its
      default, config registration, and `config_watch`. `src/boris.h`:
      remove `PROGRAM_ROOTDIR`.
- [x] `sample/objs/rooms/tower-entrance.json`: remove the
      `program.continuous` property.
- [x] Confirm `make` and `make check` are green with no VM attached. Also
      removed the `fountain_script` smoke case (src/tests/smoke.exp,
      test_smoke.sh) and the stale `data/machine` Landlock read rule
      (src/security/landlock.c). `make smoke` passes 5/5.
