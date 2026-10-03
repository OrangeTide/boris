---
title: One-Shot Program Dispatch Backbone
status: done
gitlab-sync:
---

First slice split out of the old verb-agent-model card. The end-to-end
backbone for running a guest program once against a game object, using only
object-store primitives that exist today. The agent/event model and the full
LambdaMOO object model are the follow-on cards [[vm-agent-events]] and
[[vm-object-model]]. See doc/mud-vm-design.md "Object Association and
Dispatch".

## What shipped

- Argument block in the VM library: `vm_task_set_args` writes a C-style
  argv/argc block into the guest stack and sets a0/a1, so a one-shot program
  sees `main(argc, argv)`. Plus `vm_task_set_userdata`/`vm_task_userdata`, an
  opaque per-task slot the host uses for its "self" object context.
- `src/verb/verb_dispatch.c`: the game glue. It builds a shared `vm_env`,
  registers the host calls that map to existing store primitives
  (`sys_getprop`/`sys_setprop` over `obj_prop_get/set`, `sys_broadcast`), runs
  a program to completion under an instruction cap, and reaps it.
  `verb_dispatch_oneshot` resolves a program object and loads its ELF;
  `verb_dispatch_run_image` runs an in-memory image (for tests).
- Program-attribute convention: an exit whose `exit.<dir>.to` is `prog:<id>`
  runs a one-shot program. `<id>` names a program object at key
  `programs/<id>` carrying `image.path` (relative ELF, path-safety checked)
  and optional `ram.size`. This restores the exit dispatch removed with the
  ColdFire seam in src/cmd/move.c.
- Decoupling: `verb_dispatch` takes a broadcast callback so it needs no telnet
  or network dependency. boris injects `telnetclient_room_broadcast`. The glue
  lives in `src/verb/`, not `src/vm/`, keeping the VM library game-agnostic
  (a deliberate deviation from the design doc's proposed layout).
- Wiring: `vm.image_path` config (default `data/vm`) plus a Landlock read
  rule; `verb_dispatch_init`/`_shutdown` in boris.c around the game init.
- Tests: `test_vm` argv block (argc and argv strings reach main);
  `test_verb_dispatch` covers getprop, setprop, and broadcast against an
  in-memory object with hand-built ELFs.

## Not in this slice

- No object-handle model, so the host calls act on the program's implicit
  self object only. `sys_getobj`/`objfind`/`next`/`rollup`/`create`/`recycle`/
  `move` and `sys_setpriv` wait for [[vm-object-model]].
- No authority or ACS check on `sys_setprop` yet (see [[vm-object-model]]).
- Live end-to-end exercise needs a built guest ELF, which waits for the guest
  SDK and toolchain cards.
