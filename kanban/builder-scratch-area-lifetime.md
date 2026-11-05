---
title: Builder Scratch Area Lifetime and Quota
status: backlog
gitlab-sync:
---

Follow-up from the world-history work (see [[world-backup-commands]],
`doc/snapshot-restore-spec.md` section 14, open question "Scratch lifetime").

`@checkout` copies a live zone into a persistent scratch area under the
reserved, owned prefix `zone/scratch/<user>/<name>/`, which the builder edits
and then `@publish`es back. Today nothing reclaims a scratch area after it is
published or abandoned: the objects live in LMDB indefinitely and each edit
keeps snapshotting under the `scratch` pseudo-zone. There is also no limit on
how many scratch areas a builder may hold.

This is distinct from [[scratch-obj]], which is the per-object,
connection-lifetime working copy for one OLC frame. A scratch *area* is a
persistent live subtree.

Decisions to make:

- When is a scratch area reclaimed -- on a successful `@publish`, on an
  explicit `@discard <name>`, on disconnect, or by age?
- Is there a per-builder quota on scratch areas (count and/or object total),
  coordinating with the zone quotas in `doc/zone-spec.md` section 5?
- Reclaiming must delete the subtree from live and mirror the deletion into
  history (the `builder_snapshot_subtree` wipe already handles the history
  side, so a reclaim is a `world_restore`-style wipe plus a snapshot).

- [ ] decide the reclaim trigger(s) and whether `@discard <name>` is added
- [ ] decide the per-builder scratch quota, if any
- [ ] wire reclaim through the existing restore/wipe path and history mirror
- [ ] tests: publish-then-reclaim, abandon-then-reclaim, quota refusal
