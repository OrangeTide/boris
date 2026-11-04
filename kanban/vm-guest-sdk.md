---
title: VM Guest SDK
status: done
gitlab-sync: OrangeTide/boris#104
---

Phase 4 of the VM pivot. Land `sdk/vm/`: the guest-side runtime and headers a
program links, built with the vendored skjegg toolchain ([[vm-toolchain-vendor]]).
This card delivers the one-shot half end to end; the verb/agent event-loop
runtime is [[vm-agent-events]]. See doc/mud-vm-design.md "Guest Language
Support".

## Tasks

- [x] C runtime start (`sdk/vm/crt0.S`): the ELF entry, calls `main()` on the
      host-set `argc`/`argv`/stack, exits with its return value. bss needs no
      clearing since the host zeroes the image.
- [x] Host-call stubs (`sdk/vm/stubs.S`): one `ecall` wrapper per host call
      (`a7 = 0x00100000 + index`), matching vm-hostcall-abi.
- [x] Guest header (`sdk/vm/include/vmsys.h`) declaring the host-call names.
- [x] Import table (`sdk/vm/imports.S`) and a linker script (`sdk/vm/vm.ld`,
      128KB flat from `skjegg`'s RV32 runtime linker script). One one-shot example
      (`examples/hello.c`) plus `sdk/vm/Makefile` to build it.
- [x] `vm-run` harness (`src/vm/vm-run.c`) loads and runs a program image
      against the runtime builtins; validated hello end to end (prints its
      line, exit status is argc).
- [ ] Deferred to [[vm-agent-events]]: the event-loop runtime a verb program
      links (`sys_listen`/`sys_getmsg` + dwell timer), the event-record
      layouts in the guest header, and an agent example program.

## Notes

- The skjegg assembler emits no custom sections or symbol table, so the
  KPIMPT1 import table is placed in `.rodata` and the loader finds it by
  scanning the image for the magic (packed NUL-terminated names). This
  replaced the earlier `.kp.imports` ELF-section scheme in `bind_imports`;
  the hand-built test ELFs were updated to match.
- SDK ELFs are build artifacts under `data/vm/` (gitignored); build them with
  `make -C sdk/vm BIN=<path-to-tools>`. Not wired into `make all` because the
  host tools would be cross-built under a cross-compiled boris.
