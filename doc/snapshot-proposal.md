<!-- Made by a machine. PUBLIC DOMAIN (CC0-1.0) -->
# Snapshot Proposal

## Summary

Add snapshot and rollback support to boris by periodically hashing dirty
objects into a content-addressed depot and recording manifests. LMDB remains
the live cold store for atomic transactional access. The CAS depot provides
version history, dedup, and rollback without replacing the existing backend.

## Design

### Storage Layout

```
data/
  muddb/                    existing LMDB (live cold store)
  snapshots/
    blobs/aa/aabb...        content-addressed object blobs (SHA-256)
    manifests/
      00000001.manifest     name -> hash mapping at sequence 1
      00000002.manifest     name -> hash mapping at sequence 2
    refs/
      latest                sequence number of most recent snapshot
      named/before-wipe     sequence number of a named checkpoint
```

### Blob Format

Each blob is the serialized JSON of one object, stored under its SHA-256
hash. Identical objects across snapshots share one blob (dedup).

### Manifest Format

A manifest is a text file listing every object in the world at that point
in time:

```
# snapshot 00000042
# timestamp 2026-05-02T14:30:00Z
rooms/town_square  a1b2c3d4e5f6...
rooms/tavern       f7e8d9c0b1a2...
chars/templates/human  deadbeef0123...
```

One line per object: canonical name, whitespace, content hash.
Manifests are append-only -- old manifests are never modified.

### Refs

- `latest` -- points to the current sequence number.
- `named/<label>` -- user-created named checkpoints (bookmarks).

## Operations

### snap (create snapshot)

1. Iterate all objects in LMDB (or just dirty objects if tracking since
   last snap).
2. For each object: serialize to JSON, compute SHA-256.
3. If blob does not exist in `blobs/`, write it.
4. Write manifest file with all name -> hash pairs.
5. Update `refs/latest`.

Cost: O(n) for full snap, O(dirty) for incremental if dirty tracking is
maintained between snaps.

### rollback (restore from snapshot)

1. Read target manifest (by sequence number or named ref).
2. For each entry: read blob from `blobs/`, put into LMDB via muddb_put.
3. Delete any LMDB keys not present in the manifest (objects created after
   the snapshot).
4. Update `refs/latest` to the restored sequence.

The obj_cache must be invalidated/flushed before rollback since LMDB
contents change underneath it.

### gc (garbage collection)

1. Determine retention window (e.g., keep last N snapshots or last M days).
2. Walk all manifests within retention window, collect referenced hashes.
3. Delete blobs not referenced by any retained manifest.
4. Delete manifests outside retention window.

### checkpoint (named snapshot)

Same as snap, but also writes `refs/named/<label>` pointing to the
new sequence number. Useful before destructive builder operations.

### diff (compare snapshots)

1. Load two manifests.
2. Report objects added, removed, or changed (hash differs).

Does not require deserializing blobs -- hash comparison is sufficient
to detect changes.

## Integration Points

- `world_save()` -- optionally trigger snap after LMDB flush.
- `muddb-tool` -- add `snap`, `rollback`, `gc`, `checkpoint`, `diff`
  subcommands.
- Builder commands -- `@checkpoint <label>` creates a named snapshot
  from in-game.
- Scheduled -- cron or in-process timer for periodic automatic snapshots.

## What This Does Not Change

- LMDB remains the live backend. All runtime reads/writes go through
  obj_cache -> muddb as today.
- Object names, prototype chains, and in-game containment are unaffected.
- The obj_cache LRU, dirty tracking, and flush logic stay the same.
- No new dependencies beyond SHA-256 (already available via system crypto
  or a small implementation).

## Tradeoffs

**Gains**: full version history, per-object dedup across snapshots, named
checkpoints, rollback without external backup tools, diff between world
states, shell-debuggable (plain files, cat-able blobs).

**Costs**: disk space for blob depot (mitigated by dedup), O(n) manifest
writes on full snap, additional code for gc/rollback, two copies of world
state on disk (LMDB + blobs for snapshotted versions).

## Future Possibilities

- Incremental snapshots (only write dirty objects since last snap) to
  reduce snap cost.
- Compress blobs (zlib/zstd) if depot size becomes a concern.
- Ship snapshot depot to a remote for off-site backup.
- Use manifest diffs as a change log for builder auditing ("who changed
  what, when").
