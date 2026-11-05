---
title: Snapshot Retention and GC Config
status: backlog
gitlab-sync:
---

Follow-up from the world-history work (see [[world-backup-commands]],
`doc/snapshot-restore-spec.md` section 14, open question "Retention defaults").

Automatic per-save snapshots grow the `world` log by one entry per edit, so the
log is pruned and swept on commit (`obj_cache_cas_retention` +
`obj_cache_cas_gc_policy`, wired in `builder_snapshot_init`). The bounds are
compile-time stand-ins today: keep the last 1000 edits or anything within 30
days, prune-and-sweep every 16 commits, 1 hour GC grace
(`SNAPSHOT_KEEP_COUNT` / `SNAPSHOT_KEEP_AGE` / `SNAPSHOT_GC_EVERY` /
`SNAPSHOT_GC_GRACE` in `builder_snapshot.c`). Named `@checkpoint` refs are
exempt from truncation by design.

Make these server-configurable rather than compile-time. This needs the dotted
config keys that `doc/zone-spec.md` and `doc/olc-spec.md` also wait on (the
same gap that keeps `ZONE_BASE` and the reserved `scratch`/`zoneinfo` segments
as constants), so coordinate with that work.

The grace period has a correctness constraint: it must exceed the longest a
save may sit uncommitted on any cache sharing the depot, or a sweep could drop
a blob still referenced by pending work.

- [ ] add config keys for keep-count, age window, GC cadence, and grace
- [ ] `builder_snapshot_init` reads them (falling back to the current
      defaults), via `builder_snapshot_set_retention`
- [ ] validate the grace against the uncommitted-save window
- [ ] tests: config-driven bounds prune as specified; checkpoints still exempt
