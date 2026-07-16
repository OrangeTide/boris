---
title: Sandbox Credits + Multicore Scheduler
status: backlog
gitlab-sync: OrangeTide/boris#51
---

Gate item 3 for freezing the sandbox ABI. Provides the runaway backstop,
which is currently absent at every layer. See
doc/mud-cf-sandbox-design.md "Scheduler".

Multicore from the start: per-core runqueues with work stealing. Task
guest state is per-instance and unshared, so a task runs on any core
with no guest-visible effect; only host-side shared structures need
synchronization, off the per-instruction hot path.

## Tasks

- [ ] Credit counter: +1 per plain CF instruction in cf_run, plus
      credit_cost[hc_id] per hypercall in the dispatch handler.
      cf_cpu.cycles is incremented but read nowhere today (coldfire.c:2462).
- [ ] credit_cost[] table loaded from config (boris.cfg), host-side, not
      part of the ABI.
- [ ] Three thresholds: CREDIT_BUDGET (per-quantum preemption),
      credits_used (lifetime counter in task_t), CREDIT_LIMIT_TOTAL
      (lifetime kill).
- [ ] Per-core runqueues + work stealing across MUD worker cores. Home
      core affinity hint; stealable.
- [ ] Preempt returns the task to a runqueue (not a kill). Fault or
      lifetime-cap crossing kills.
- [ ] Replace the flat MAX_INSNS_PER_TICK tick loop (obj_program.c) with
      the credit-based scheduler.
- [ ] Tune start values (CREDIT_BUDGET=10000, per-tick cap=256,
      CREDIT_LIMIT_TOTAL=1<<30) against a real workload.
