---
title: obj_cache_cas retention policy (bounded depot)
status: active
gitlab-sync:
---

Wire smolvfs v0.2.0 history pruning into the CAS backend so depot
growth is bounded. Satisfies promotion conditions 2 and 3 from the
obj-cache-cas card: a retention policy in obj_cache_cas, and a
benchmark re-run confirming the depot converges instead of growing
linearly.

## Background

The obj-cache-cas experiment measured unbounded depot growth (~1.5 KB
per edit at best batching) because every ref log entry keeps its
snapshot reachable and GC reclaims only never-committed orphans.
smolvfs v0.2.0 (vendored) adds cas_tree_log_truncate (prune a ref's
log by count and/or age, newest entry always kept) and sparse-tolerant
GC marking (missing object = boundary; corruption still errors). With
"keep last N snapshots" retention, depot size should converge to
roughly live world + N x churn.

Retention discards history, so it must be opt-in: the shim's default
stays "keep everything".

## Tasks

- [ ] obj_cache_cas_retention(c, keep_count, keep_age): configure
      pruning; applied in the auto-GC path (truncate, then sweep).
      keep_age is a duration, converted to an absolute cutoff at
      each sweep. Disabled by default.
- [ ] unit tests: old snapshots collected past the retention window,
      current world and retained snapshots intact, log entry count
      matches keep_count
- [ ] bench_obj_cache_cas retention mode: re-run the churn workload
      with retention active and record depot convergence vs the
      unbounded baseline
- [ ] record results here and update the obj-cache-cas conditions
