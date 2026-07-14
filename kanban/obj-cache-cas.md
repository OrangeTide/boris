---
title: obj_cache CAS backend experiment (smolvfs)
status: backlog
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

## Tasks

- [ ] decide id mapping: per-domain cas-omap (numeric keys) vs
      cas-tree paths (string keys)
- [ ] obj_cache_cas.c implementing obj_cache_ops over smolvfs
- [ ] flush ordering for crash consistency: blobs, then omap pages,
      then directory, then ref update (crash leaves only orphaned
      blobs, recoverable by GC)
- [ ] ref storage: where the current snapshot root hash lives
- [ ] GC pass: mark from live snapshot roots, sweep loose objects,
      repack
- [ ] measure under real session load: bytes written per flush, depot
      growth rate, GC cost; compare against muddb
- [ ] go/no-go writeup: keep as optional backend, promote, or drop

Related: object-versioning card (CAS snapshots would give diff/history
for free if this backend is adopted).
