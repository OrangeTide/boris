---
title: In-Server Compile and Link (stages 1-2)
status: backlog
gitlab-sync:
---

Later work, after the first cut runs pre-built ELFs. Bring stages 1 and 2 of
the compilation pipeline inside the server so a builder can author a program
and attach it without a server rebuild, following smolmoo's `@program`
model. See doc/mud-vm-design.md "Compilation Pipeline".

Do not start until the runtime (vm-task-runtime, vm-hostcall-abi,
verb-agent-model) is stable. This adds a toolchain dependency and build
wiring, so it is deliberately deferred.

## Tasks

- [ ] Stage 1: compile a guest source (kobold or C) to a KPM1 module inside
      the server.
- [ ] Stage 2: link and resolve a KPM1 module into a self-contained RV32
      ELF, binding host-call imports by name.
- [ ] An in-game command to compile, link, store, and attach a program to an
      object.
- [ ] Decide what of the kobold and skjegg toolchains is built by the boris
      GNUmakefile versus invoked as an external tool.
