---
title: Verb Programs, Mailbox, and Events
status: done
gitlab-sync: OrangeTide/boris#102
---

Second slice split out of the old verb-agent-model card. The event-driven
half: verb programs (agents) that link a shared event-loop runtime, a
per-task mailbox, and the resident-program lifecycle. Builds on
[[vm-oneshot-dispatch]]. See doc/mud-vm-design.md "Program vs Verb" and
"Object Association and Dispatch".

Built in layers: the VM-core mailbox and timed sleep (`src/vm/`), the host-side
agent manager and event routing (`src/verb/verb_agent.c`), the guest event-loop
runtime (`sdk/vm/verb_rt.c`), and the live heartbeat plus resident supervision
(`src/boris.c`).

## Tasks

- [x] Per-task bounded mailbox. `sys_getmsg` (a VM builtin) drains one event
      into guest memory, `sys_suspend` blocks for one; `sys_listen` registers a
      task as its object's handler and `sys_notify`/`sys_post` deliver, routed
      host-side in `src/verb/`. Event kinds: none, enter, timer, user, wake.
- [x] Program vs verb split as a link-time choice of who supplies `main()`:
      `sdk/vm/verb_rt.c` registers with `sys_listen`, drains the mailbox, calls
      the program's `verb_event`, and sleeps for a dwell period when idle so the
      host delivers a `VM_EV_TIMER`. A guest-SDK runtime, not a VM feature.
- [x] Resident programs come from a configured `vm.resident` list rather than a
      store scan (chosen over the load/evict-callback path). A sysvinit-style
      supervisor (`verb_agent_supervise`) relaunches any that exit or fault,
      throttled by a cooldown. Driven by a re-arming iox timer in `boris` that
      steps every agent a slice (`verb_agent_tick`).
- [x] A sequential task resumes on `verb_agent_post`/`sys_post` by id without
      calling `sys_listen`, so it never intercepts the object's other events.
- [x] Tests: mailbox delivery/ordering/back-pressure and block-wake in
      `test_vm`; timed sleep fire/pending/event-preempt in `test_vm`; listen +
      deliver, sequential post-resume (no event stealing), and the supervisor in
      `test_verb_dispatch`. The compiled `agent.elf` was validated end to end.

## Notes

- Interim until [[vm-object-model]]: event routing is keyed on an object's
  string key, and an agent's self is its program-def object. The object-handle
  host calls (`sys_getobj`/`sys_objfind`/`sys_next`/...), LambdaMOO verb
  resolution, and the authority-to-ACS bridge remain on that card.
- The dwell period is a fixed 1000 ms in the runtime; a per-program dwell is a
  later refinement. A process-health monitor could grow from the supervisor.
