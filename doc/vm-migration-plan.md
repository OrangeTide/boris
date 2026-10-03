# VM Migration Plan -- ColdFire to RV32/kobold

> **Retired.** The pivot's first cut is complete: ColdFire is gone and the
> RV32 + kobold sandbox is in place (phases 0-4, `coldfire-removal` through
> `vm-guest-sdk` / `vm-toolchain-vendor`, all done). This document is kept
> as the historical record of that work and is no longer maintained. The
> only deferred follow-ups are the explicitly-later `vm-online-toolchain`
> (in-server compile/link) and `vm-code-protection` cards. For the current
> design see `doc/mud-vm-design.md`.

The plan for retiring the ColdFire emulator and standing up the RV32 plus
kobold sandbox described in `doc/mud-vm-design.md`. This document drove the
`kanban/` cards for the work.

## Decisions

Settled with the project owner before this plan was written.

- **Emulator.** Vendor one copy of the shared RV32 core (`rv32.c`,
  `rv32.h`). It is identical across the kobold, smolmoo, and skjegg
  projects apart from the license header. Boris owns its copy.
- **Runtime and syscall model.** Design around smolmoo's MUD requirements:
  the one-shot-program versus verb-program split, the object-access and
  movement calls, the mailbox event model, and cooperative single-threaded
  scheduling.
- **Host-call ABI.** One flat namespace of host calls, resolved by name
  through kobold's linker machinery. The traditional Linux syscalls are
  renamed into that same flat namespace. See `doc/mud-vm-design.md`.
- **Pipeline.** A three-stage, JIT-like pipeline: compile source to KPM1,
  link and resolve KPM1 into an RV32 ELF, load the ELF into the emulator.
- **First implementation cut.** Stage 3 only. Run pre-built RV32 ELFs.
  Compile and link happen offline for now.
- **Guest languages.** kobold (Pascal-family) and C via skjegg.
- **Sequencing.** Docs and kanban first, then code. This document and the
  design doc land before any emulator code is added or removed.

## Licensing

The imported sources (kobold-pascal, smolmoo, skjegg) are the project
owner's own code under `0BSD OR CC0-1.0`. The owner is authorized to
relicense them into boris's license. Relicensing and any edit to a source
file's license or copyright header is a human step performed by the owner,
not an automated one. Documentation files carry no license or copyright
notice, matching the rest of `doc/`.

## Part 1 -- Remove the ColdFire Emulator

A complete touch-point inventory. Everything below is ColdFire-specific and
comes out.

### Directories to delete

- `src/coldfire/` -- the ColdFire V4e CPU emulator (`coldfire.c`,
  `coldfire.h`, `elf_loader.c`, `elf_loader.h`, `test_coldfire.c`,
  `module.mk`).
- `src/machine/` -- the VM runtime and game glue (`machine.c`, `machine.h`,
  `test_machine.c`, `obj_program.c`, `obj_program.h`, `program.c`,
  `program.h`, `objref.c`, `objref.h`, `module.mk`).
- `sdk/machine/` -- the m68k guest SDK (`Makefile`, `include/`, `lib/`, the
  example guest sources).
- `data/machine/` -- pre-built guest ELF binaries
  (`anim/fountain.elf`, `exits/random-portal.elf`).
- `sample/objs/programs/` -- sample program objects
  (`anim/fountain.json`, `exits/random-portal.json`).

### Build system edits

- `src/module.mk` -- drop `coldfire` and `machine` from `SUBDIRS`; drop the
  three `machine/*.c` entries from `boris_SRCS`; drop `machine` and
  `coldfire` from `boris_LIBS`.
- `module.mk` (top level) -- drop `-Isrc/coldfire` and `-Isrc/machine` from
  `PROJECT_CPPFLAGS`.
- The two unit-test targets (`test_coldfire`, `test_machine`) leave
  `TEST_TARGETS` automatically when their `module.mk` files are deleted.

### Code edits

- `src/boris.c` -- remove the `obj_program.h` and `program.h` includes and
  the `program_init`, `program_shutdown`, `obj_program_init`, and
  `obj_program_shutdown` startup and shutdown wiring.
- `src/cmd/move.c` -- remove the `objref.h` and `obj_program.h` includes and
  the `script:`-domain exit block that calls `obj_program_dispatch_verb`.
  This is where the new verb dispatch will later attach.
- `src/mudconfig.h` -- remove the `image_path` field.
- `src/common.c` -- remove the `image_path` default, its config
  registration, and its `config_watch`.
- `src/boris.h` -- remove the `PROGRAM_ROOTDIR` define.

### Data edits

- `sample/objs/rooms/tower-entrance.json` -- remove the
  `program.continuous` property.

### Note

`src/security/` (seccomp and Landlock) is the host process sandbox, not the
guest emulator. It stays. `src/verb/` is command-parsing verb-spec code,
unrelated to VM verbs. It stays. `src/scrypt/` is password crypto, not
scripting. It stays.

## Part 2 -- Import the RV32 Sandbox

Bring in and own the pieces named in `doc/mud-vm-design.md`. Sources are the
owner's projects at `kobold-pascal`, `smolmoo`, and `skjegg`. Copy, adapt,
and own; do not vendor as an upstream dependency.

### Emulator core -> `src/rv32/`

- `rv32.c`, `rv32.h` -- the CPU core. Self-contained. Boris supplies the
  memory bus callbacks, an access probe, and the `ecall` handler.
- `elf32.c`, `elf32.h` -- the RV32 ELF loader (load from file and from
  memory).

### Runtime -> `src/vm/`

Adapt, do not copy verbatim. The reference implementations are woven into
`smolmoo.c` and `rv_user.c`.

- Task lifecycle and the cooperative scheduler: allocate, set up, step,
  and reap tasks; per-task private memory image; instruction budget per
  tick.
- The `ecall` dispatcher and the flat, name-bound host-call table. The
  reference is `do_ecall` and `bind_hostcalls` in kobold's `rv_user.c`
  (name binding through the import-table metadata segment) and the syscall
  switch in smolmoo's `vm_ecall`.
- The host-call set from `doc/mud-vm-design.md`, implemented against
  boris's object store, room and player model, and ACS layer.
- Verb and agent dispatch: resolution order, typed argument matching, the
  per-task mailbox, `sys_listen` and `sys_getmsg`, the resident-program
  boot scan.

### Guest SDK -> `sdk/vm/`

- The C runtime start (`_start`) and the `ecall` host-call stubs.
- The event-loop runtime that a verb program links (smolmoo's `verbmain`
  is the pattern: register with `sys_listen`, drain the mailbox, call the
  program's event handler, synthesize a timer on dwell).
- The guest header defining the host-call names and the argument and event
  record layouts (smolmoo's `mulibc.h` is the reference contract).
- The linker script and a few example programs (one one-shot, one agent).

### Offline toolchain (not vendored into the server for the first cut)

- kobold and skjegg stay as external toolchains used to build ELFs offline.
  They are not built by the boris `GNUmakefile` in the first cut. Online
  compilation and linking (stages 1 and 2) are a later card.

## Part 3 -- Phased Delivery

Each phase is shippable and testable on its own.

### Phase 0 -- Remove ColdFire

Execute Part 1. The build stays green with no VM attached. This is a clean
deletion with no replacement wired in yet.

### Phase 1 -- Emulator core

Vendor `src/rv32/`. Wire the memory bus, the access probe, and a stub
`ecall` handler. Unit-test instruction execution, traps on out-of-range
access, and the ELF32 loader against a small pre-built ELF. No game
integration yet.

### Phase 2 -- Task runtime and host-call dispatch

Stand up `src/vm/`: the task lifecycle, the cooperative scheduler on the
event loop, and the flat name-bound `ecall` table. Implement the runtime
and I/O host calls first (`sys_exit`, `sys_write`, `sys_broadcast`,
`sys_random`, `sys_now`), then the object-access calls. Run a pre-built
one-shot ELF end to end. Unit-test each host call.

### Phase 3 -- Verb and agent programs

Implement verb resolution and dispatch, argument matching, the mailbox, and
the `sys_listen` and `sys_getmsg` calls. Re-attach exit-verb dispatch in
`src/cmd/move.c` at the point Part 1 cleared. Add the resident-program boot
scan. Ship one one-shot example and one agent example as pre-built ELFs,
with the room and object samples to exercise them.

### Phase 4 -- Guest SDK and examples

Land `sdk/vm/`: the shared C runtime, the host-call stubs, the event-loop
runtime, the guest header, and the linker script. Rebuild the example
programs from source with the offline toolchain. Document the build in
`README.md` and `doc/DEV.md`.

### Later -- Online compilation and linking

Stages 1 and 2 of the pipeline inside the server, following smolmoo's
`@program` model: compile kobold and C to KPM1, link to an RV32 ELF, store
it, and attach it, without a server rebuild. Its own card.

## Kanban

Phase 0 through the later online-toolchain work map to these cards. The nine
ColdFire-era cards (`coldfire-isa` and the eight `sandbox-*` cards) are
removed; they described the abandoned design.

| Card                 | Phase       | Concern                                    |
|----------------------|-------------|--------------------------------------------|
| `coldfire-removal`   | 0           | delete the ColdFire emulator and runtime   |
| `rv32-emulator`      | 1           | vendor and own the RV32 core and loader    |
| `vm-task-runtime`    | 2           | task lifecycle and cooperative scheduler   |
| `vm-hostcall-abi`    | 2           | flat name-bound host-call table and set    |
| `verb-agent-model`   | 3           | one-shot vs verb split, dispatch, mailbox  |
| `vm-guest-sdk`       | 4           | guest C runtime, stubs, event-loop library |
| `vm-online-toolchain`| later       | in-server compile and link (stages 1-2)    |

The gitlab issues behind the removed cards (`#22`, `#41` through `#48`)
should be closed as will-not-do by the owner.
