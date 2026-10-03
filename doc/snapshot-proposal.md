# Snapshot Proposal

## Summary

Add snapshot, diff, and rollback support to boris by exporting the muddb
world into a content-addressed depot and advancing a named reference per
snapshot. LMDB remains the live store for atomic transactional access; the
depot provides version history, dedup, and rollback without being a live
backend.

The depot is not a new hand-rolled store. It is the smolvfs CAS depot built
by `muddb-tool to-cas`, the same content-addressed format from the
`obj-cache-cas` experiment, now used export-only (see the `obj-cache-cas`
and `world-backup-commands` cards). An earlier draft of this proposal
specified a bespoke `data/snapshots/` layout of blobs, text manifests, and
refs; that is superseded by the CAS depot, which supplies all of it
(hash-addressed blobs, tree manifests, refs, an append-only log, and GC).

## Design

### Storage layout

```
data/
  muddb/                     live LMDB store (unchanged)
  casdb/                     CAS snapshot depot (smolvfs)
    objects/aa/aabb...       content-addressed blobs and tree objects
    refs/world               the snapshot reference + append-only log
```

The depot is produced and grown by `muddb-tool to-cas data/muddb data/casdb
<ref>`. `<ref>` (default `world`) names the snapshot line; each export
appends an immutable commit to that ref's log.

### Blobs

Each object's serialized JSON is stored under its content hash. Identical
objects across snapshots share one blob (dedup). This is the CAS store's
native behaviour, not something this feature implements.

### Manifests

The name -> hash mapping for a snapshot is the cas-tree (htree) tree object
at the commit root, keyed by domain-qualified path
(`objs/rooms/church`, `chars/1`, ...). Looking a name up is an O(depth)
tree walk; listing a level is one tree load. There is no separate text
manifest file; the tree object is the manifest.

### Refs and the log

- A ref (`refs/world`) points at the current snapshot root and carries an
  append-only log of every commit, each with a timestamp and comment
  (`cas_tree_ref_commit` / `cas_tree_log_read`).
- Named checkpoints are additional refs (for example `refs/before-wipe`),
  created by exporting to that ref name.

## Operations

All operations are `muddb-tool` subcommands or thin wrappers over the
cas-tree API; `world-backup-commands` owns the in-game surface.

### snap / checkpoint (create snapshot)

`muddb-tool to-cas data/muddb data/casdb <ref>`. Iterates the muddb
domains, writes each object's blob if absent, builds the tree levels, and
commits the root to `<ref>`, appending to its log. A checkpoint is the same
with a chosen `<ref>` name. In-game `@checkpoint <label>` drives this
(wizard-only, ACS-gated).

Cost: O(n) objects per export; dedup keeps unchanged blobs from being
rewritten, and a later incremental export (dirty-only) is a possible
optimization.

### rollback (restore from snapshot)

Not yet available: there is no cas-to-muddb import. Building it is the
round-trip gap tracked in `world-backup-commands`. The shape: read the
target commit's tree, and for each entry `muddb_put` the blob back into
LMDB, deleting LMDB keys absent from the tree. The obj_cache must be
flushed and invalidated first, since LMDB changes underneath it. Until the
import exists, restore is from a JSON export (`muddb-tool export`/`import`)
or an `mdb_copy` of `data/muddb`.

### gc (reclaim depot space)

`cas_tree_gc` marks from the refs and sweeps unreferenced objects older
than a grace period. Because every commit in a ref's log stays reachable,
GC alone cannot reclaim superseded history; bounding the depot needs
`cas_tree_log_truncate` (keep the last N commits) before GC. Retention is
tracked with the smolvfs re-vendor (see `smolvfs-revendor`).

### diff (compare snapshots)

Compare two commit tree roots and report objects added, removed, or changed
(entry hash differs). Hash comparison is enough; blobs need not be
deserialized.

## Integration points

- `muddb-tool` -- `to-cas` exists (snap/checkpoint); add a cas-to-muddb
  import (rollback) and, as thin wrappers, `diff` and log-pruning `gc`.
- Builder commands -- `@checkpoint <label>` exports to a named ref from
  in-game. Owned by `world-backup-commands`.
- Scheduled -- cron or an in-process timer can run periodic exports.

## What this does not change

- LMDB remains the live backend. All runtime reads and writes go through
  obj_cache -> muddb as today; nothing routes live traffic to CAS.
- Object names, prototype chains, and in-game containment are unaffected.
- The obj_cache LRU, dirty tracking, and flush logic stay the same.
- No new runtime dependency: the CAS modules are already vendored
  (src/thirdparty/smolvfs) and linked by `muddb-tool`.

## Tradeoffs

**Gains**: version history, per-object dedup across snapshots, named
checkpoints, diff between world states, and (once the import lands)
rollback without external tools. The depot is plain files, inspectable
with the CAS tooling.

**Costs**: disk for the depot (mitigated by dedup, bounded by log
truncation + GC), O(n) export on a full snap, the unbuilt cas-to-muddb
import for rollback, and two on-disk copies of snapshotted state (LMDB
live + depot history).

## Future possibilities

- Incremental export (only objects dirty since the last snapshot) to cut
  snap cost.
- Blob compression (the smolvfs codec table) if depot size becomes a
  concern.
- Ship the depot to a remote for off-site backup; this is also the
  substrate a future replication feature would build on, though that is
  pure greenfield today.
- Use tree diffs as a builder audit log ("who changed what, when").
