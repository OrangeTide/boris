---
title: obj_cache CAS backend experiment (smolvfs)
status: active
gitlab-sync:
---

Experiment: implement a second obj_cache backend over smolvfs
(cas + cas-omap) alongside the default muddb/LMDB backend. Evaluate
content-addressable storage for MUD objects without replacing LMDB.

## Background

obj_cache already provides the write-behind layer: pinned live objects
in RAM, dirty tracking, save-on-evict, flush_all. The backend is
pluggable via struct obj_cache_ops (load/save), so "live objects stay
in RAM until flush or idle eviction" holds for any backend. A CAS
backend is a shim like obj_cache_muddb.c, not an architecture change.

The CAS churn concern is half-solved in smolvfs already. cas_omap_put
only dirties in-RAM pages; nothing hits the CAS until cas_omap_store
writes dirty pages (COW at page granularity) plus one directory object.
A flush cycle costs one blob per dirty object, a few omap pages, one
directory object, one ref update. The directory hash is a whole-world
snapshot.

What CAS buys over LMDB: free snapshots (one hash), rollback, diff
between snapshots, dedup across object versions, and a replication
substrate (DOWNLOAD.md incremental fetch; SHOAL is a design doc only,
not implemented). Durability is unchanged: obj_cache is already
write-behind, so the crash window is the last flush either way.

The real cost is garbage collection, not write amplification. LMDB
reclaims superseded pages automatically via its freelist. In CAS every
superseded object version stays in the depot as an unreferenced blob
until a mark-and-sweep GC runs. For a mutation-heavy workload GC is
mandatory ongoing machinery. Depot growth rate under real load decides
whether GC is a periodic chore or a serious problem.

Key shape mismatch (minor): muddb keys are (domain, string key);
cas-omap keys are uint64. Numeric-in-zones keys fit one omap per
domain; otherwise cas-tree paths (domain/key) fit strings at the cost
of O(depth) tree objects per flush instead of pages.

## Decision: cas-tree with htree, not cas-omap

Surveyed the real database (muddb-tool export of data/muddb):
users has account-name keys ("boris"), chars has small decimal keys
(1-13), objs has hierarchical slash paths ("rooms/church",
"programs/anim/fountain"). Keys are strings and already path-shaped,
so cas-omap (uint64 keys) fits only chars. cas-tree with the
CAS_TREE_USE_HTREE flag fits all three domains uniformly as paths
like "objs/rooms/church", with O(1) lookup per level.

cas-tree also already provides refs (cas_tree_ref_commit/read), an
append-only snapshot log, fsck, and mark-from-refs GC with a grace
period (cas_tree_gc). So ref storage and the GC pass are wiring, not
new machinery.

What cas-tree does not provide: path walking. cas_tree_lookup is
single-name within one tree object and cas_tree_store writes one
directory level. The shim must walk paths down and COW-rebuild
modified levels up. Also, obj_cache calls ops->save per object, so a
naive shim would rewrite O(depth) tree nodes plus a ref commit per
save. The shim should write the object blob immediately on save but
buffer path->hash updates, committing the tree and ref once per
flush cycle. A blob written but not yet committed to a tree is
unreachable after a crash, which is the same loss window as
write-behind generally, and GC collects the orphan.

## Measurements (2026-07-14)

bench_obj_cache_cas, real data/muddb contents (21 objects, 4076
bytes JSON), 500 puts total in each config, same edit sequence for
both backends. LMDB is one fsynced transaction per put; CAS is one
blob write per put plus a fsynced ref commit per touched domain per
round.

| config           | CAS time | LMDB time | CAS depot growth | LMDB growth |
|------------------|----------|-----------|------------------|-------------|
| commit per edit  |  9851 ms |   2204 ms | 3.32 MB          | 0           |
| 5 edits/commit   |  3182 ms |   1542 ms | 1.25 MB          | 0           |
| 20 edits/commit  |  1437 ms |   1398 ms | 0.74 MB          | 0           |

Import of the full database: 62 ms, 35 CAS files, 30 KB apparent.
GC after churn: 27-141 ms, removed 0 objects in every config
(expected: history stays reachable via the ref log).

Findings:

- Batching works as designed. At 20 edits per commit, CAS reaches
  time parity with LMDB (1437 vs 1398 ms) and depot growth per put
  drops 4.4x vs commit-per-edit. Commit frequency, not edit count,
  is the dominant cost (ref commit fsync + tree level rewrites).
- Depot growth is unbounded and linear in commits, ~1.5 KB per edit
  at best batching for ~200 byte objects (tree/htree objects
  dominate; blobs are small). LMDB storage stayed flat at 53 KB
  through every run via page reuse. GC cannot help because it
  reclaims only never-committed orphans.
- Path forward (upstream smolvfs): sparse/incomplete references.
  Today mark_tree treats a missing tree as a hard error and
  cas_tree_gc aborts, so partial state is illegal. The extension is
  (1) sparse-tolerant marking (missing object = boundary, skip),
  (2) a ref log truncation op (keep last N entries), and (3) a
  fsck mode aware of pruned history. With "keep last N snapshots"
  retention, depot size converges to live world + N x churn instead
  of growing forever. This aligns with SHOAL's partial-state GC
  design element. Go/no-go for promoting the backend hinges on this
  upstream work.
- On-disk usage runs ~4x apparent size from 4 KB block rounding on
  small loose objects; cas-pack rollup would mitigate.

## Tasks

- [x] decide id mapping: cas-tree htree paths (see Decision above);
      real keys are strings and path-shaped, cas-omap fits only chars
- [x] decide how boris consumes smolvfs: vendored release v0.1.0
      CAS modules into src/thirdparty/smolvfs (see UPSTREAM there)
- [x] obj_cache_cas.c implementing obj_cache_ops over smolvfs:
      path walk for load, blob write plus buffered path->hash
      updates for save, tree COW rebuild and ref commit per flush
      cycle (blobs first, then tree levels, then ref; crash leaves
      only orphaned blobs, recoverable by GC). Includes
      obj_cache_cas_put for object creation and unit tests
      (valgrind clean). cas_tree_ref_commit wired for the root.
- [x] wire up cas_tree_gc: threshold-based auto GC in commit (default
      every 16 commits, 3600s grace) plus obj_cache_cas_gc for manual
      runs. Note: cas_tree_gc marks from every ref's full snapshot
      log, so committed history is never collected; GC reclaims only
      never-committed orphans. Reclaiming superseded history would
      need log pruning, an upstream smolvfs feature.
- [x] measure against real muddb data: bench_obj_cache_cas imports
      the live database (21 objects, 4KB JSON) into both backends and
      drives an identical 500-put edit workload (see Measurements)
- [ ] go/no-go writeup: keep as optional backend, promote, or drop

Related: object-versioning card (CAS snapshots would give diff/history
for free if this backend is adopted).
