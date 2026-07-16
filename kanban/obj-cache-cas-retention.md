---
title: obj_cache_cas retention policy (bounded depot)
status: done
gitlab-sync: OrangeTide/boris#59
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

## Results (2026-07-15)

bench_obj_cache_cas, real data/muddb, 100 rounds x 5 edits, keep 8
snapshots, auto GC every 16 commits, both configs same run
conditions:

| metric                | no retention | retention keep 8 |
|-----------------------|--------------|------------------|
| depot files after     | 972          | 74               |
| depot bytes apparent  | 1.28 MB      | 81 KB            |
| depot bytes on disk   | 3.99 MB      | 288 KB           |
| churn time per round  | 74.3 ms      | 81.3 ms          |

A 400-round run (2000 puts, 4x the work) lands on the same floor:
74 files, 89 KB apparent, 288 KB on disk after the final truncate
and sweep. Depot size is bounded, sawtoothing between GC sweeps and
converging to live world + retained churn, exactly as predicted.
Retention overhead is ~9% on churn time (truncate + sweep every 16
commits).

Promotion conditions 2 and 3 from the obj-cache-cas card are
satisfied. Remaining for promotion: cross-domain %parent parity
(condition 4) and config-gated live routing with an import path
(condition 5).

## Tasks

- [x] obj_cache_cas_retention(c, keep_count, keep_age): configure
      pruning; applied in the auto-GC path (truncate, then sweep).
      keep_age is a duration, converted to an absolute cutoff at
      each sweep. Disabled by default.
- [x] unit tests: old snapshots collected past the retention window,
      current world and retained snapshots intact, log entry count
      matches keep_count (50 checks, valgrind clean)
- [x] bench_obj_cache_cas retention mode: re-run the churn workload
      with retention active and record depot convergence vs the
      unbounded baseline
- [x] record results here and update the obj-cache-cas conditions
