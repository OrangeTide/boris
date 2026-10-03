---
title: VM Host-Call ABI and Table
status: done
gitlab-sync: OrangeTide/boris#105
---

Phase 2 of the VM pivot. Implement the flat, name-bound host-call table the
guest reaches through `ecall`. One flat namespace: the game services plus a
renamed set of the traditional Linux calls. Calls resolve by name through
the program's ELF import table, using kobold's linker machinery. This
replaces the ColdFire hand-maintained hypercall-ID enum. See
doc/mud-vm-design.md "Host-Call ABI" and "Host-Call Set".

Scope decision: this card ships the name-bound dispatch, the argument
marshalling, the always-present runtime builtins, and the `vm_env`
registration seam. The game-coupled calls (object access, broadcast,
privilege) need the boris object store, ACS, and session model, so the host
registers them into a `vm_env` during the integration (verb/agent) card,
which keeps `src/vm/` free of the game. See doc/mud-vm-design.md "Host-Call
ABI" (builtins vs registered calls) and "Host-Call Set" (status).

## Tasks

- [x] `ecall` dispatcher: selector in `a7` (`VM_HOSTCALL_BASE` + import
      index), integer and pointer args in `a0`-`a5`, result written back to
      `a0`. `vm_arg`/`vm_set_ret`/`vm_read`/`vm_write`/`vm_arg_cstr` marshal
      arguments and buffers, bounds-checked against the task's flat image.
      Float args in `fa0`-`fa5` wait for a call that needs them.
- [x] Name binding: at load, read the `KPIMPT1` table from the `.kp.imports`
      ELF section (host-read, never in guest memory since our image is flat)
      and bind each import index to a builtin, then to a `vm_env` entry, by
      name. An unbound name faults the task if it is ever called.
- [x] Runtime builtins: `sys_exit`, `sys_write` (to the task output sink),
      `sys_random`, `sys_now`, `sys_suspend` (parks the task through
      `RV_RUN_YIELD`). `sys_broadcast` is game-coupled; the host registers it.
- [x] `vm_env` registration seam: `vm_env_new`/`vm_env_register`/`vm_env_free`
      and `vm_task_set_env`. A registered name cannot shadow a builtin.
- [x] Tests: builtins (exit, write, random, now, suspend), a registered env
      call, an unbound-name fault, and builtin-shadow rejection.
- [ ] Deferred to the verb/agent (integration) card: object-access calls
      (`sys_getprop`/`setprop`/`getobj`/`objfind`/`next`/`rollup`/`create`/
      `recycle`/`move`), `sys_broadcast`, and `sys_setpriv`, registered into a
      `vm_env` against the object store and ACS. Includes the fixed-layout
      argument block and string area written into guest memory before a
      program runs (argv and event records), which rides on that dispatch.
