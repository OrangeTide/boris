---
title: VM Task Runtime and Cooperative Scheduler
status: done
gitlab-sync:
---

Phase 2 of the VM pivot. Stand up `src/vm/`: the task lifecycle and the
cooperative, single-threaded scheduler on the boris event loop. This is not
the ColdFire design's multicore credit scheduler; multicore stays in the
`multithreading` card. See doc/mud-vm-design.md "Execution Model".

## Tasks

- [x] Task struct: one `rv_cpu` plus its private memory image, host-side
      bookkeeping (session and authority context), and a run-queue link.
- [x] Allocate, set up (load ELF, seed the stack), step, and reap tasks.
- [x] Scheduler: step each ready task by a quantum, capping instructions per
      tick so no task stalls the event loop. Reap tasks that finish; keep
      runnable tasks on the queue.
- [x] Cooperative I/O: buffer guest writes host-side and flush them a line
      at a time through a bound output sink.
- [x] Run a pre-built one-shot ELF end to end (from memory and from a file).
- [x] Tests: exit-and-reap, output capture, instruction-cap preemption of a
      spinning task, fault on a stray access, scheduler reap, file load. 21
      checks, `make check` green (27 suites), valgrind-clean.

## Notes

- `src/vm/` is a standalone library (`vm.c`, `vm.h`) linking `rv32`. It has
  no game dependencies: output goes through a `vm_output_fn` callback the
  host binds, so telnet/SSE wiring lands with the verb/agent card.
- The per-task memory image, bounds-checked bus callbacks, and access probe
  now live here (`src/vm/vm.c`), moved out of the rv32 test harness.
- `rv_run` returns a stop reason (`RV_RUN_BUDGET`, `RV_RUN_HALT`,
  `RV_RUN_TRAP`, `RV_RUN_YIELD`) and stops the batch the moment the machine
  halts, takes a trap, or parks. The runtime does one batched `rv_run` per
  quantum and switches on the reason; it never steps instruction by
  instruction. A trap is reported and reaped as a fault (no guest handler in
  this cut) rather than left to spin unseen, which matters for detecting a
  stuck task in production. This reason API was prototyped here and now lives
  upstream in the skjegg core, so `rv32.c` carries no local diff (see
  `rv32-emulator`).
- The cooperative-yield boundary is the parked bit (`cpu->waiting`), not any
  one instruction: `rv_run` returns `RV_RUN_YIELD` whenever it is set, and the
  runtime clears it on resume (the core keeps real interrupt semantics). This
  makes each task a coroutine. The canonical guest yield is the `sys_suspend`
  host-call, which sets the bit after recording its wake policy (yield now,
  sleep, or block) and belongs to `vm-hostcall-abi`; `wfi` also parks the
  hart, so it yields too, but it is the low-level form, not the contract. The
  yield tests use `wfi` to exercise the park and resume path before
  `sys_suspend` exists.
- Returning a reason from the batch primitive is the contract a JIT backend
  honors, so the runtime path does not change when the interpreter is later
  replaced.
- The `ecall` handler is provisional: it recognizes only the Linux
  `write` (64) and `exit` (93) selectors, enough to run a one-shot program
  and capture its output. `vm-hostcall-abi` replaces it with the flat,
  name-bound host-call table. Sleeping/blocked task states and the event
  mailbox belong to `vm-hostcall-abi` and `verb-agent-model`.
- The full argument block (argc/argv) is not written yet; a one-shot program
  with no arguments needs only a seeded stack pointer. The dispatch path in
  `verb-agent-model` writes the argument block.
