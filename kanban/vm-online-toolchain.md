---
title: In-Server Compile and Link (stages 1-2)
status: done
gitlab-sync: OrangeTide/boris#108
---

Bring the compilation pipeline inside the server so a builder can author a
program and attach it without a server rebuild.

Done, though not by the KPM1-module and name-binding route this card first
imagined. After the skjegg rebase the compiler, assembler, and linker are
themselves RV32 ELFs, run as guests under the embedded runtime over a hostcap
build directory (`src/vfs/vfs_compile.c`). `@compile <src> [<out>]` compiles a
VFS source to a VFS ELF; `@program` binds it to a program object and `@run`
launches it. Because no host process is spawned, in-world compilation works
with seccomp and Landlock active. See `doc/vm-skjegg-rebase.md`.

## Tasks

- [x] Compile a guest C or assembly source to an RV32 ELF inside the server.
- [x] Link it into a self-contained RV32 ELF against the confined libc.
- [x] In-game commands to compile (`@compile`), bind (`@program`), and launch
      (`@run`) a program.
- [x] The toolchain guests are built by `make -C sdk/vm toolchain`; nothing is
      invoked as an external host tool.
- [x] Kobold-Pascal (`.pas`/`.kp`) compilation (see kobold-online-compile).
