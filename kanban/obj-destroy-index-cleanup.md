---
title: Destroy must clean up containment index entries
status: backlog
gitlab-sync:
---

Found while reviewing the L2 containment work in [[vm-object-model]]. The
`idx.contents` index is maintained on the write path by `obj_move`, but the
destroy path does not touch it, so destroying a contained object leaves stale
index entries behind.

## Problem

`obj_cache_destroy` (src/obj/obj_cache.c) deletes the object record and drops
the cache entry. `obj_destroy` (src/obj/obj_store.c) wraps it. Neither removes
the object from its container's `idx.contents` set, nor clears the entries
where the destroyed object is itself a container. After a destroy:

- `obj_contents(container)` still lists the dead member id.
- any object whose `%location` pointed at the destroyed container now dangles
  (its `%location` names a container that no longer exists, and that
  container's index entries are gone).

## Why it is not yet triggered

At L2 nothing destroys contained objects. Items do not exist until L3, and the
recycle command (`sys_recycle`) does not land until L5. So the gap is latent,
but it becomes load-bearing the moment either exists.

## Fix direction

Destroy should resolve containment before deleting, in one place so every
caller is covered:

- Move the victim to limbo first (`obj_move(id, NULL)`) so its membership is
  removed from its container's index in a transaction.
- Decide and implement the policy for the victim's own contents (objects whose
  `%location` is the victim): reparent them to the victim's container, move
  them to limbo, or refuse the destroy while non-empty. The MUD convention is
  usually to spill contents into the enclosing container.
- Fold the record delete and the index deltas into one `MUDDB_TXN` so a crash
  cannot leave the record gone but the index entry present.

This belongs with the recycle path (L5/L7 `sys_recycle`) in
[[vm-object-model]]; land it there, or earlier if L3 introduces any destroy of
a contained object first.

## Tests

- Destroy a contained object: it disappears from its container's contents
  listing and count.
- Destroy a non-empty container: its contents follow the chosen policy (no
  dangling `%location`, no orphaned index entries).
- The record delete and index cleanup are atomic across a simulated failure.
