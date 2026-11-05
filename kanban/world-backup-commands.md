---
title: In-Game World Backup Commands
status: done
gitlab-sync: OrangeTide/boris#76
---

Protect builder data with in-game snapshot and export commands so a bad
edit, wipe, or crash does not cost a builder their work, without shell
access. First cut only; full snapshot / rollback / gc / diff follow
`doc/snapshot-proposal.md` in a later phase. Distinct from VM task-state
snapshotting in the sandbox track, which is emulator state, not the world
DB. See `doc/plan.md` Phase 0.

## Owns the CAS snapshot/export path

The live object store is muddb only; CAS (smolvfs) was demoted to an
offline snapshot/export format (see [[obj-cache-cas]]). This card owns
that path. The mechanism already exists as `muddb-tool to-cas`, which
exports the whole muddb world into a content-addressed depot: each export
is an immutable, deduplicated snapshot, so repeated exports to one depot
keep a compact history and support diffing world versions. In-game
`@checkpoint` drives this; shell access is not required.

Two backup formats, both through `muddb-tool`:

- JSON export (`export`): portable, human-readable, one file per record.
- CAS depot (`to-cas`): deduplicated immutable snapshots with history.

Other features delegate snapshot/restore here rather than owning it: the
mail dedup/undo work points per-message restore from a snapshot at this
card (see [[mail-dedup-undo]]).

The scoped cas-to-muddb import now exists, so a CAS depot is a restore
path, not only a backup and diff target (`doc/snapshot-restore-spec.md`,
`world_restore`). A restore or copy replaces the whole target path
wholesale, deletions included: `builder_snapshot_subtree` recomputes the
wipe and `@destroy` drops its key via `builder_snapshot_forget`, both over
the `obj_cache_cas_del` tombstone, so the round-trip never resurrects a
removed object. The deletion gap flagged against this round-trip is
resolved (spec section 14).

`doc/snapshot-restore-spec.md` implemented this with a revised mechanism:
continuous in-process snapshots on every builder save plus a scoped
cas-to-muddb restore and an undo/redo/checkout/publish surface, rather than
`@checkpoint` driving the offline `to-cas`. Reconciled against that:

- [x] `@checkpoint <label>` -- pins the current world root under a named
      `cp-<label>` ref (the labelled snapshot the to-cas drive was for),
      `builder_history_checkpoint`
- [x] world export/dump command over the `muddb-tool` JSON-record format
      -- in-game `@export [<domain> ...]` (wizard-only) dumps the live store
      to `data/export/<timestamp>/`, over a shared `muddb_export` library the
      `muddb-tool export` subcommand now also uses, so both emit identical
      output
- [x] cas-to-muddb import so a CAS snapshot can be restored, not just
      diffed; closes the round-trip -- `world_restore`, driving `@restore`,
      `@undo`, `@redo`, `@checkout`, `@publish` (spec steps 2-4, 6)
- [x] depot retention (bounded history) via smolvfs log pruning -- the
      `world` log is pruned and GC'd per commit (spec step 5); named
      `@checkpoint` refs are intentionally exempt, since pinning is how deep
      history is kept
- [x] wizard-only, wired through the ACS gate -- `@checkpoint` is wizard
      (`fW`); the builder commands are `fB|fW` plus the zone allow-list
      (`zone_may_edit`)
- [x] document the in-game command surface and the CAS export/restore
      mechanism -- landed as `doc/snapshot-restore-spec.md` (section 10
      surface, section 15 implementation), not an edit to
      `snapshot-proposal.md`
- [x] tests: the cas-to-muddb import/restore and `@checkpoint` round-trips
      (`test_world_restore`, `test_builder_history`, `test_builder_snapshot`),
      and the JSON-record export (`test_muddb_export`)

Follow-ups deferred from `doc/snapshot-restore-spec.md` section 14:
[[builder-scratch-area-lifetime]] (reclaim and quota for scratch areas) and
[[snapshot-retention-config]] (make the retention/GC bounds configurable).
