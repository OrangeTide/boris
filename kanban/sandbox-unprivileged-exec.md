---
title: Sandbox Unprivileged Execution + Faulting Bus
status: backlog
gitlab-sync: OrangeTide/boris#48
---

Gate item 1 for freezing the sandbox ABI. Foundational: everything else
sits on this. See doc/mud-cf-sandbox-design.md.

The guest currently runs in supervisor mode and out-of-range bus access
silently returns zero. The two isolation layers the trust model names
first do not exist. Fix both.

## Tasks

- [ ] Start the guest in user mode. `cf_reset()` sets CF_SR_S and
      `machine_start()` never clears it (coldfire.c:2501, machine.c
      machine_start). Drop the guest to user mode after reset.
- [ ] Place the supervisor vector table and syspage in host-controlled
      memory the guest cannot write. Verify the S-bit transition and
      exception frame handling with the guest unprivileged.
- [ ] Confirm privileged instructions (MOVEC, move-to-SR, STOP, RTE)
      trap to CF_VEC_PRIVILEGE from user mode and kill the task.
- [ ] Make bus callbacks raise an access error on out-of-range access
      instead of returning zero / dropping the write (machine.c:50-108).
      A stray access must kill the task, not run on garbage.
- [ ] Tests: user-mode privileged-instruction trap, OOB read/write
      fault, clean exception path with unprivileged guest.
