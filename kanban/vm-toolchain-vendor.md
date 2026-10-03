---
title: Vendor the skjegg RV32 C Toolchain
status: done
gitlab-sync: OrangeTide/boris#110
---

Prerequisite for [[vm-guest-sdk]]: bring skjegg's C compiler, assembler, and
linker for RV32 into boris so the guest SDK builds from source rather than
depending on an external toolchain checkout. Answers the "built by the boris
GNUmakefile versus invoked as an external tool" question from
[[vm-online-toolchain]] in favour of building them here. See
doc/mud-vm-design.md "Compilation Pipeline" and "Guest Language Support".

## Scope

The three tools of the C path only: `skj-cc-rv` (C -> RV32 asm text),
`skj-as-rv` (asm -> ELF32 object), `skj-ld-rv` (link -> RV32 ELF). Not the
Pascal, Scheme, MOO, x86/arm64/MIPS, or JIT paths. skjegg's ELF output
already matches src/rv32/elf32.c (ELFCLASS32, EM_RISCV, ET_EXEC, PT_LOAD,
section headers with .shstrtab), and its ILP32 psABI matches the host-call
register convention.

## Tasks

- [x] Vendor the RV32 C-path sources under `sdk/toolchain/skjegg/` (cc, cpp,
      ir, the RV backend, as, ld), keeping skjegg's subdir layout. Provide a
      static `version.h` in place of skjegg's generated one.
- [x] Build the three tools with the modular-make system as host executables
      (native CC). The shared IR core is a `skjir` static lib linked into each
      tool. Includes use `-iquote` so skjegg's own headers win over boris's
      same-named ones (e.g. `util.h`) that the global `-I` path carries.
- [x] Smoke: `cc-rv | as-rv | ld-rv` on a trivial C program yields a valid
      RV32 ELF32 LE ET_EXEC with section headers, matching src/rv32/elf32.c's
      checks. Running it under the name-bound host-call ABI needs the SDK crt
      and linker script, so end-to-end execution is [[vm-guest-sdk]].
- [x] Host-tool caveat: these run on the build host to produce guest ELFs, so
      a cross-compiled boris build still needs a native CC for them. The guest
      runtime and the SDK ELF build rules are [[vm-guest-sdk]].

## Notes

- Vendored 50 source files across cc/cpp/ir/backend/as/ld; only the RV32 C
  path is compiled (no Pascal/Scheme/MOO/x86/arm64/MIPS/JIT).
- One build gotcha resolved: stale objects from earlier iterations produced a
  crashing `skj-cc-rv`; a clean rebuild with the `skjir` lib and `-iquote`
  fixed it. License stays CC0-1.0 as upstream; no headers added or altered.
