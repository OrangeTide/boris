<!-- Made by a machine. PUBLIC DOMAIN (CC0-1.0) -->
# MOO-VFS Storage Proposal

## Summary

Replace the flat `world.data` text file persistence with CAS-backed VFS
storage. Objects keep integer IDs (`#N`). The VFS provides persistence,
snapshots, rollback, dedup, GC, and fsck using infrastructure already built
in smolvfs.

## Object Identity

Objects use integer IDs internally, like inodes. The `#N` syntax in verbs,
properties, and references does not change. Paths are a storage/organizational
detail, not a replacement for object identity.

Path aliases (human-readable names for objects) are a possible future layer
on top — not a prerequisite. If added, they behave like hard links: one or
more path names resolve to an integer object ID. Builders would use paths
for organization; the engine uses integers at runtime.

## Storage Layout

```
depot/                              CAS on disk (already exists)
  objects/aa/aabb...                content-addressed blobs
  refs/world                        points to latest tree hash
  log/world                         commit history for rollback

VFS tree (in-memory, snapped to CAS):
  /objs/0000/0042                   serialized object #42
  /objs/0000/0043                   serialized object #43
  /objs/0001/1000                   object #1000
```

Objects are grouped into directories by ranges of 1000 (e.g. `/objs/0000/`
holds IDs 0–999, `/objs/0001/` holds 1000–1999) to avoid oversized
directories.

ELF binaries remain in CAS directly, referenced by hash from object
properties as they are today.

## Persistence Model

### Save

Serialize each dirty object into its VFS slot, then `vfs_snap_commit()`.
CAS content-addressing deduplicates unchanged objects — only modified blobs
cost new storage across snapshots.

### Load

`vfs_snap_checkout()` restores the VFS tree from the latest (or chosen)
ref. Walk `/objs/*/` and deserialize into runtime structures.

### Rollback

`cas_tree_log_read()` lists commit history. `vfs_snap_checkout()` restores
any previous snapshot. This replaces the current atomic-rename-only scheme
with full version history.

## Runtime Architecture

### Phase 1: VFS as persistence layer

Keep the in-memory `objs[]` array as the authoritative runtime store.
VFS is written to only on save. Two representations exist at runtime:
`objs[]` for fast access, VFS tree as the last checkpoint.

- `world_save()` → serialize objects into VFS, `vfs_snap_commit()`
- `world_load()` → `vfs_snap_checkout()`, deserialize into `objs[]`
- Property reads/writes hit `objs[]` directly, no VFS overhead

### Phase 2: VFS as live store (future)

Eliminate `objs[]`. Properties are VFS files. All reads and writes go
through the VFS API.

Requirements for phase 2:

- **LRU cache**: Hot objects stay deserialized in a cache to avoid
  VFS tree traversal on every property access. Cache is write-back:
  dirty entries are flushed to VFS on eviction or save, not on every
  write.
- **Deferred tree updates**: Batch VFS writes so that directory tree
  updates (which are costly) happen at save time, not per-property-write.
- **Dirty tracking**: Mark cached objects as dirty on write. Only
  dirty objects are serialized and written to VFS on save/flush.

The LRU cache effectively makes VFS-as-live-store behave like phase 1
at runtime (hot objects in memory, cold objects on VFS), but with a
unified data path and no separate `objs[]` array.

## Serialization Format

Each object is stored as a single VFS file (blob in CAS). The existing
text format can serve as the blob content:

```
#42 #1
owner=#0
group=#10
name=Town Square
description=A cobblestone plaza with a fountain in the center.
```

This keeps the format human-readable and debuggable. The difference
from today is that each object is its own blob rather than all objects
in one monolithic file.

## What This Replaces

- `world.data` flat file (monolithic save/load)
- `world.sample` hash bootstrap
- Manual atomic-rename durability

## What This Preserves

- `#N` object syntax everywhere
- Integer IDs as the engine-internal identity
- The `objs[]` flat array (in phase 1)
- Existing CAS depot for ELF storage

## Tradeoffs

**Gains**: snapshot/rollback history, per-object dedup across saves,
integrity checking (fsck), garbage collection of orphaned blobs,
copy-on-write semantics, path toward eliminating the separate `objs[]`
array.

**Costs**: more code than the ~200-line `world_load`/`world_save`,
two representations of world state at runtime (phase 1), VFS + CAS
library becomes load-bearing rather than optional.
