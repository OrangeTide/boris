---
title: In-Game World Backup Commands
status: backlog
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

Open gap: there is no cas-to-muddb import yet, so a CAS depot is a backup
and diff target but not yet a restore path. Restore today is from a JSON
export or an `mdb_copy`. Building the import is part of making `to-cas`
a full round-trip (see tasks).

- [ ] `@checkpoint <label>` -- named snapshot; drives `to-cas` into the
      backup depot (and/or a JSON export), labelled for later reference
- [ ] world export/dump command over the `muddb-tool` JSON-record format
- [ ] cas-to-muddb import so a CAS snapshot can be restored, not just
      diffed; closes the round-trip (coordinate with [[smolvfs-revendor]]
      for the depot format)
- [ ] depot retention for `@checkpoint` output (bounded history), using
      smolvfs log pruning (see [[smolvfs-revendor]])
- [ ] wizard-only, wired through the ACS gate
- [ ] extend `doc/snapshot-proposal.md` with the in-game command surface
      and the CAS export/restore mechanism
- [ ] tests: checkpoint then export round-trips the world store; to-cas
      then import restores it
