---
title: Sandbox Scheduler-Integrated Dispatch + ABI Cleanup
status: backlog
gitlab-sync:
---

Follow-on cleanups once the gate items land. See
doc/mud-cf-sandbox-design.md "Pre-Freeze Work List".

## Tasks

- [ ] Move verb dispatch off the inline command path.
      obj_program_dispatch_verb runs machine_run synchronously inside
      do_move (obj_program.c); a spinning handler stalls the player's
      command processing. Route dispatch through the scheduler.
- [ ] Pick one multiplexing primitive: HC_WAIT (WaitForMultipleObjects,
      in the prototype) or HC_SELECT (fd-bitmask, in the design). Ship
      one, remove the other.
- [ ] Reserve the verb context-block region in the linker script and
      validate the loaded program does not occupy it, so dispatch does
      not clobber guest code/data (machine.c write_context, fixed addr).
- [ ] Keep only C prototypes as the normative ABI description; do not
      maintain a hand-written register table alongside them.
