# Snapshot Restore and Builder History Spec

Design spec for builder-facing world history: automatic snapshots, undo and
redo, and Subversion-style path-copy restore (scratch areas and publish).
Builds on the CAS substrate in `doc/snapshot-proposal.md`, reuses the zone
permission model in `doc/zone-spec.md`, and composes with the per-object
editing isolation in `doc/scratch-obj-spec.md`. In-game surface extends the
`world-backup-commands` kanban card; the CAS store comes from the
`obj-cache-cas` and `smolvfs-revendor` cards.

Status: agreed, signed off 2026-11-04. Implementation may begin.

## 1. Purpose and scope

Builders need to work on their areas on the live MUD without fear. The goals:

- Every accepted builder edit is recorded, so a bad change can be undone and
  redone.
- A builder can restore a past version of their own area, in whole or in
  part, without touching anyone else's work.
- A builder can copy their live area into a private scratch area, edit and
  test it there, then publish it back over the original when satisfied.
- A wizard can do all of this anywhere in the tree.

The model is a single versioned object tree. There are no branch references
(no git-style heads). A "branch" is a subtree copied to another path, the way
Subversion treats `branches/` and `tags/` as directory copies under one tree.
This is the realization of the `database-forks` line of work, narrowed to a
single live world plus history, with branching dropped.

Out of scope: a conflict-resolving merge engine, multiple simultaneous live
worlds, cross-server replication (`doc/snapshot-proposal.md` future work), and
field-granularity object merge (`doc/scratch-obj-spec.md` section 7).

## 2. Relationship to existing specs

| Spec | What it provides | What this spec adds |
|------|------------------|---------------------|
| `snapshot-proposal.md` | CAS export (`muddb-tool to-cas`), refs, append-only log, dedup, GC, diff. Rollback (cas-to-muddb import) named as the unbuilt gap. | The in-process, dirty-only snapshot path; the scoped cas-to-muddb import (restore); the builder workflow on top. |
| `scratch-obj-spec.md` | A detached OBJ for editing one object in an OLC frame; commit on Submit. | A scratch **area** (a live subtree under a path), not one object. The two compose: editing an object inside a scratch area still uses the scratch OBJ. |
| `zone-spec.md` | Zones as `zone/<slug>/` key prefixes; `zoneinfo` with `creator` and `builders` allow-list. | Reuses that allow-list verbatim for snapshot and restore permission; no new access control. |

The word "scratch" is overloaded by history: `scratch-obj` is a per-object,
connection-lifetime working copy for one editor frame. A scratch **area**
here is a persistent, live subtree the builder owns. They are different
mechanisms with the same intent, isolation before commit.

## 3. Model

### 3.1 One tree, path-copy branching

The live world is one object tree in LMDB. Object keys are hierarchical and
domain-qualified in the CAS (`objs/zone/darkwood/closet`, `chars/1`,
`templates/room/...`), per `doc/object-identity.md`. A zone is everything
under `objs/zone/<slug>/`, which is exactly one CAS subtree.

Every history operation is one primitive:

```
copy(src, dst, rewrite)
```

- `src`  a subtree, taken either from the live tree or from a historical
         snapshot root.
- `dst`  a destination path prefix in the live tree.
- `rewrite`  when the destination prefix differs from the source prefix,
             rewrite intra-subtree references (section 5). When the prefixes
             are equal, no rewrite is needed.

Three workflows are this one operation with different arguments:

| Workflow | src | dst | rewrite |
|----------|-----|-----|---------|
| undo / restore | a historical root's subtree | the same path | off |
| checkout to scratch | the live subtree | `zone/scratch/<user>/<name>/` | on |
| publish back | the scratch subtree | the original zone path | on (and guarded, section 6.3) |

A consequence worth stating: the cheap same-path restore never needs
deserialization, because the keys and therefore the references do not change.
Only the cross-path copies pay the rewrite pass, and that cost is bounded by
the subtree size.

### 3.2 Authority and direction

LMDB is the live store and the single source of truth (the working tree). The
CAS depot is derived history (the object store plus the log). State flows
LMDB -> CAS on snapshot, and CAS -> LMDB on restore. No live read or write is
ever served from CAS.

## 4. Snapshots

### 4.1 Trigger: automatic, on every builder save

A snapshot is recorded after each accepted builder edit. `builder_save()`,
having committed to LMDB, hands the set of keys it just wrote to the snapshot
bridge, which mirrors those objects into the CAS cache and appends a commit to
the `world` ref's log. Undo and redo are therefore per-edit and need no
builder action.

The commit is incremental and dirty-only. Only the objects that changed get a
new blob, and `cas-tree` copy-on-write rebuilds only the tree levels from
those leaves up to the root. The per-save cost is: serialize the changed
objects, write their blobs if absent, rebuild O(depth) tree nodes, write the
ref. The full-world `muddb-tool to-cas` export from `snapshot-proposal.md`
remains available as the offline or scheduled path and as the first-boot
seed.

### 4.2 Log entry contents

Each commit records a timestamp, the new root hash, and a comment carrying
the acting builder, the zone or zones the changed keys fall under, and a short
summary. The per-builder, per-zone history view is the `world` log filtered to
entries whose changed keys touch `zone/<slug>/`.

### 4.3 Named checkpoints (wizard pins)

`@checkpoint <label>` (wizard-only, as in `doc/plan.md`) records the current
root under a separate named ref (`refs/<label>`). A named ref is not subject
to the `world` log truncation (section 8), so a pinned checkpoint survives
retention and deep history is preserved by pinning rather than by keeping the
whole log.

### 4.4 Failure policy

The snapshot is best-effort history, not part of the write's success
condition. If the CAS commit fails, the edit has already succeeded in LMDB and
the world is correct. The bridge logs a warning and continues. It never rolls
back a builder's edit because history recording failed.

## 5. The copy primitive and reference rewrite

Rewrite acts on **marked object references only**, never on string content. A
property is rewritten if and only if its key is marked as a reference, so the
rewrite can never alter a description, a name, or any other plain string. The
type lives in the property key, the same way boris already marks structural
keys with `%` and tombstones with `!` (obj.c); the value stays a plain path
string. See section 5.1 for the marker.

When `copy` moves a subtree to a different prefix, each copied object is parsed
and every reference-marked property whose value falls **inside** the subtree is
rewritten from the source prefix to the destination prefix. References that
point **outside** the subtree (to `templates/...`, to another zone) are left
unchanged, because they are shared or external. Non-reference properties (a
`desc`, a `name`, the username in `creator` or `owner`) are never touched, by
key, not by a property-name allowlist. This is the one path that must parse the
object rather than compare hashes, and it is bounded by the subtree size.

### 5.1 The object-reference key marker

A reference is a property whose key carries the reserved reference marker `~`,
with the path-id as a plain string value. This makes a reference
distinguishable from a string by the key alone, extending the existing key
conventions (`%` structural, `!` tombstone) rather than adding a value type.
The obj model stays a flat map of string values; no object-valued or
array-valued properties are introduced.

A single reference:

```
"exit.e.to~": "zone/darkwood/square"
```

A list of references is a set of indexed reference keys, the way exits are
already a keyed collection rather than an array value:

```
"keys.0~": "zone/darkwood/brass-key"
"keys.1~": "zone/darkwood/iron-key"
```

The marker is a value-type axis, orthogonal to the `%` protection prefix, so a
key can be both: the structural references `%parent` and `%location` become
`%parent~` and `%location~`. Every reference carries the marker, structural or
user-space (`exit.*.to~`, `template~`), so "is this a reference" is one test on
the key, with no exceptions and no side table.

Rewrite and the integrity scan (section 6.4) walk an object's keys, act on
every `~`-marked key whose value is in scope, and leave every other property
alone. The check is a cheap test on the key name, with no value parsing.

Obj-model impact is small: recognize `~` as a reserved key marker alongside `%`
and `!`, add convenience accessors that read and write the path under a marked
key and test whether a key is a reference, and validate that a marked key's
value is a well-formed path-id. Existing unmarked reference keys are converted
by a one-time migration pass (section 15 step 0).

## 6. Operations

### 6.1 Undo and redo

Undo and redo move a per-(builder, zone) cursor along the subsequence of
`world` log entries that touched that zone. The operation restores the
`zone/<slug>/` subtree from the cursor's target root into live, same path, no
rewrite. The restore writes the changed LMDB keys, deletes keys absent from
the target subtree, rebuilds the affected indexes (section 7), and runs the
integrity check (section 6.4). The restore is itself a snapshot, so the log
only moves forward and every undo is auditable, matching the rewind policy in
`snapshot-proposal.md`. Redo walks the cursor forward over the same filtered
subsequence; because roots are immutable and the log is append-only, a redo
target is never lost by another builder's intervening edit in a different
zone.

### 6.2 Checkout to scratch

`@checkout <zone> [as <name>]` copies the live `zone/<slug>/` subtree to the
builder's scratch area `zone/scratch/<user>/<name>/` with rewrite on, so
exits and parents inside the copy resolve within the scratch area rather than
back into the live zone. The scratch area is live objects under a path the
builder owns, so a wizard or the builder can walk into it and test it, and
edits there auto-snapshot like any other builder save. The fork-point hash of
the source subtree is recorded at checkout (section 6.3).

### 6.3 Publish back

`@publish <name> [to <zone>]` copies the scratch subtree back over the target
zone path with rewrite on (remapping scratch keys to the zone keys).

Publish overwrites the whole target subtree, so it would silently clobber any
edit made to that zone since the checkout. The guard detects, it does not
resolve: compare the target subtree's current hash to the fork-point hash
recorded at checkout. If equal, the publish is a fast-forward overwrite. If
changed, the publish is refused with a report of what moved, and the builder
re-checks-out and reapplies. This keeps the no-merge promise; the only
reintroduced check is a hash compare, never a conflict resolver.

### 6.4 Referential integrity on restore and publish

Any `copy` into live runs an integrity pass before committing:

- **Outbound.** Every reference leaving the restored or published subtree must
  resolve in the resulting live tree (an exit to another zone, a `%parent`
  template). A dangling outbound reference is reported.
- **Inbound.** Every reference from outside the target subtree that points
  into it must still resolve after the operation. This matters on publish: if
  the builder renamed or deleted a room in scratch, a live exit elsewhere that
  named the old key would dangle once scratch overwrites the zone.

The default is to refuse an operation that would create a dangling reference
and report the offending keys. A wizard may force it (section 9).

## 7. Index rebuild

The LMDB contents and owner indexes (`idx.contents`, `idx.owner` in
`obj_store.c`) are not stored in the CAS snapshot, which holds the object
graph only. Any `copy` into live must rebuild the index entries for the keys
it wrote and clear entries for keys it deleted, in the same transaction as the
object writes where the backend allows it (`muddb_txn_*`). The rebuild is
bounded by the subtree size, which is another reason the operations are
path-scoped rather than world-wide. The obj_cache must be flushed and the
affected keys forgotten first, since LMDB changes underneath it
(`obj_forget`), consistent with the rollback note in `snapshot-proposal.md`.

## 8. Retention and GC

Automatic per-save snapshots grow the `world` log by one entry per edit, so
retention is mandatory, not optional. The `world` ref's log is pruned with
`cas_tree_log_truncate` (keep the last N entries and an age window, both
config-driven), then `cas_tree_gc` sweeps objects no surviving commit or
named ref reaches, sparing objects younger than a grace period. Named
checkpoint refs (section 4.3) are never truncated, so pinning is how deep
history is retained. Defaults and the grace period follow
`obj_cache_cas_retention` and `obj_cache_cas_gc_policy`; the grace must exceed
the longest time a save may sit uncommitted on any cache sharing the store.

## 9. Permission and path scoping

Permission reuses the zone model with no new mechanism:

- A builder may snapshot-view, undo, redo, restore, checkout, and publish
  within a zone they created or are listed in on `zoneinfo.builders`
  (`zone_own_prop(zone_path, "builders")`, `doc/zone-spec.md` 2.2).
- A builder's scratch areas live under the reserved prefix
  `zone/scratch/<user>/`, which they own by construction.
- A wizard (ACS-gated) may operate on any path, may force an operation past a
  failed integrity check with an explicit confirm, and owns `@checkpoint`.

The reserved `scratch` segment under `zone/` is config-driven alongside the
reserved `zoneinfo` leaf (`doc/olc-spec.md` 3.2).

## 10. Commands

In-game surface, owned by the `world-backup-commands` card:

```
@history [<zone>]          list recent snapshots touching a zone (or the
                           caller's current zone), newest first
@undo                      restore the caller's current zone to the previous
                           snapshot that touched it
@redo                      step the caller's zone cursor forward again
@restore <entry> [<path>]  restore a subtree from a past entry to a path
                           (builder: own zone only; wizard: any path)
@checkout <zone> [as <n>]  copy a live zone into the caller's scratch area
@publish <n> [to <zone>]   copy a scratch area back over a zone, guarded
@checkpoint <label>        pin the current root under a named ref (wizard)
```

`@restore`, `@checkout`, and `@publish` are the `copy` primitive with the
argument shapes in the table in section 3.1.

## 11. Validation

- A restore or publish that would dangle a reference is refused and reports
  the keys, unless a wizard forces it.
- A publish whose fork point no longer matches live is refused and reports
  what moved.
- A builder command outside the caller's permitted zone or scratch prefix is
  refused before any write.
- After any `copy` into live, `idx.contents` and `idx.owner` agree with the
  written objects' `%location` and `%owner`.

## 12. Testing plan

- **Round trip.** Snapshot a zone, change it, undo; assert the objects and
  indexes match the pre-change state. Redo; assert they match the post-change
  state.
- **Scoping.** Undo in zone A does not alter zone B, even when B changed after
  A's target snapshot.
- **Rewrite.** Checkout a zone to scratch; assert exits and parents inside the
  scratch resolve within the scratch, and external refs are unchanged.
- **Publish fast-forward.** Checkout, edit scratch, publish with the zone
  untouched; assert the zone equals the scratch and references resolve.
- **Publish race.** Checkout, then change the live zone, then publish; assert
  the publish is refused with a report and the live zone is unchanged.
- **Integrity, inbound.** Rename a room in scratch that a live exit elsewhere
  targets; assert publish is refused for the dangling inbound reference.
- **Integrity, outbound.** Restore a subtree whose exit targets a since-deleted
  room; assert the restore is refused.
- **Retention.** Exceed the log keep count; assert old `world` entries are
  pruned, named checkpoints survive, and GC reclaims only unreferenced blobs.
- **Failure policy.** Force a CAS commit failure on save; assert the LMDB edit
  stands and a warning is logged.
- Wired into `module.mk` for CI (`ci-test-coverage` card).

## 13. Resolved

- **Snapshot trigger.** Automatic on every builder save, incremental and
  dirty-only. Explicit full export and named checkpoints remain available.
- **Branching.** Dropped. One live world, path-copy restore in place of
  branch references.
- **Merge.** No conflict-resolving merge. Publish is fast-forward or refuse,
  guarded by a fork-point hash compare.
- **Permission.** Reuse the `zoneinfo.builders` allow-list; scratch under a
  reserved owned prefix.
- **Migration.** Existing unmarked reference keys are converted by a one-time
  migration pass; the code then reads only `~`-marked keys, with no tolerant
  fallback (section 15 step 0).
- **Rewrite scope.** Rewrite acts on marked object references only, never on
  substrings of arbitrary string values, using the `~` reference key marker
  (section 5.1).
- **Reference encoding.** A reference is a property whose key carries the
  reserved `~` marker, with a plain path string value; a list of references is
  a set of indexed `~`-marked keys (section 5.1). The obj model stays flat (no
  object or array values), extending the existing `%` and `!` key
  conventions. The obj-model marker, the call-site conversion, the seed data,
  and the one-time store migration (`muddb-tool migrate-refs`) are complete
  (section 15 step 0).

## 14. Open questions

- **Cursor persistence.** Resolved for now to a process-lifetime map keyed by
  (builder, zone) (step 6): the cursor survives a reconnect within one server
  run and resets on restart, with no new struct field or on-disk storage key. A
  per-account persisted cursor (surviving restart) remains the open upgrade,
  the same storage-key question `doc/scratch-obj-spec.md` section 8 defers.
- **Deletions in snapshots.** A restore now records the subtree it wrote
  (`builder_snapshot_subtree`), so the tip tracks live and undo is auditable per
  section 6.1. What remains is that the dirty-only bridge (section 4.1) is
  additive: it mirrors the objects that exist but never removes one a restore
  deleted, so the tip's copy of a shrunken subtree still carries the dropped
  keys. A deletion-aware snapshot (recording removals, not only writes) is the
  remaining fix; the live store is always correct regardless, since LMDB is the
  source of truth.
- **Scratch lifetime.** When is a published or abandoned scratch area
  reclaimed, and is there a quota on scratch areas per builder
  (`doc/zone-spec.md` section 5 quotas)?
- **Retention defaults.** The keep count, age window, and GC grace for the
  `world` log on a live server.

## 15. Implementation

0. Prerequisite: the `~` reference key marker in the obj model (section 5.1).
   Recognize it alongside `%` and `!` in `obj.c`; add the reference accessors
   (`obj_prop_get_ref` / `set_ref` / `set_ref_internal` / `delete_ref` /
   `delete_ref_internal` / `obj_resolve_prop_ref`) and the `obj_prop_is_ref`
   test; hold the which-names-are-references policy in one place
   (`src/obj/objref.c`, `objref_is_ref_name`) so the editors and the migration
   cannot disagree. Convert every call site that reads, writes, or deletes
   `%parent`, `%location`, `template`, or an `exit.<dir>.to` to the `_ref`
   accessors (OLC editors through the `olc_field_get` / `olc_field_set` choke
   point, plus `builder_edit.c`, `dig.c`, `builder_save.c`, `zone*.c`,
   `show_room.c`, `move.c`, `verb_dispatch.c`, `character.c`, `entity.c`).
   Normalize exits to flat dotted keys: the seed JSON and the migration flatten
   a nested `exit` object to `exit.<dir>.to~` / `exit.<dir>.desc`. The one-time
   migration is `muddb-tool migrate-refs <dbpath> [domain ...]`: it flattens
   nested exits and marks the four reference kinds, copying all other content
   verbatim, is idempotent (already-marked objects are skipped), and rewrites
   only objects that actually change. The code then reads only `~`-marked keys,
   with no tolerant fallback. Done.
1. The in-process snapshot bridge: a hook in `builder_save()` that mirrors the
   just-written keys into an `obj_cache_cas` cache and appends a commit to the
   `world` ref, with the attribution comment. Dirty-only. Done:
   `src/builder/builder_snapshot.c` holds the bridge (one cache on the `objs`
   domain and `world` ref, `data/world-depot`); `builder_save` calls it through
   a new optional `ops->snapshot` hook after a successful commit, best-effort
   (section 4.4); `builder_ops.c` wires the default hook and `boris.c` opens and
   closes the depot at startup/exit. Tested in `test_builder_snapshot.c`.
2. The scoped cas-to-muddb import (the rollback gap in
   `snapshot-proposal.md`), taking a root, a source prefix, a destination
   prefix, and the rewrite flag; it writes and deletes LMDB keys, rebuilds the
   affected indexes, and invalidates the obj_cache. Done for the in-place case
   (undo, redo, same-path restore): `src/builder/world_restore.c` reads the
   source subtree from a snapshot root through the shared `cas_tree`
   (`builder_snapshot_tree()`), and `obj_apply_restore` in `obj_store.c` writes
   the objects, deletes live keys absent from the source, rebuilds the contents
   and owner indexes, and invalidates the cache, all in one `muddb_txn`. Tested
   in `test_world_restore.c`. Cross-path copy (checkout and publish) returns an
   error until the rewrite pass (step 3).
3. The reference-rewrite pass over the fixed property set (section 5). Done:
   `objref_rewrite_prefix` (`src/obj/objref.c`) rewrites every `~`-marked
   reference whose value is inside the source subtree (equal to the prefix or
   under `prefix/`) to the destination prefix, leaving external references and
   all non-reference string values untouched. `world_restore` now remaps each
   object's key and, on a cross-path copy, rewrites its references, so
   checkout-to-scratch and publish-back work (same engine, different prefixes).
   The object's own identity is its storage key, which the restore remaps; the
   non-reference `id` property, where present, is left as-is per the
   references-only rule. Tested in `test_world_restore.c` (a rewrite unit test
   plus an end-to-end checkout).
4. The integrity pass, outbound and inbound (section 6.4). Done in
   `world_restore.c`: before the apply transaction, `check_outbound` verifies
   every reference of every written object resolves in the resulting tree
   (targets inside the subtree are the written keys, targets outside must exist
   in live), and `check_inbound` scans the live objects outside the subtree for
   any reference pointing into it that the copy would orphan. A violation
   refuses the copy and logs the offending `key[ref] -> value`, unless the new
   `force` argument (the wizard override) is set, which still logs. Inbound
   needs a full scan of objects outside the subtree, since there is no
   reverse-reference index. Tested in `test_world_restore.c` (outbound and
   inbound, each refused then forced).
5. Retention and GC wiring (section 8). Done: `builder_snapshot_init`
   configures the `world` cache with `obj_cache_cas_retention` and
   `obj_cache_cas_gc_policy`, so each commit's auto-GC prunes the log with
   `cas_tree_log_truncate` then sweeps. Defaults are compile-time stand-ins for
   the per-server config left open in section 14 (keep the last 1000 edits or
   30 days, prune-and-sweep every 16 commits, 1 hour grace);
   `builder_snapshot_set_retention` overrides them. Named checkpoint refs are
   untouched: truncation acts only on the `world` ref and GC marks every ref's
   log. Tested in `test_builder_snapshot.c` (aggressive keep bound prunes the
   log while the current world survives).
6. The `world-backup-commands` in-game surface (section 10), ACS-gated and
   zone-scoped. Done: `src/builder/builder_history.c` holds the workflow engine
   over the bridge and `world_restore`, and `src/cmd/history_cmd.c` is the thin
   telnet layer (`@history`, `@undo`, `@redo`, `@restore`, `@checkout`,
   `@publish` gate on `fB|fW` plus `zone_may_edit`; `@checkpoint` gates on
   `fW`). A trailing `force` word is the wizard override past an integrity
   failure. The undo/redo cursor is a process-lifetime map keyed by (builder,
   zone) (the section 14 question, resolved to process-lifetime: survives
   reconnect within a run, resets on restart, no new struct field or storage
   key). `@checkpoint` pins under a namespaced ref (`cp-<label>`) since a ref
   name cannot hold `/`; that ref is spared world-log truncation. Every restore
   into live (undo, redo, `@restore`, `@checkout`, `@publish`) records the
   subtree it wrote as one commit through `builder_snapshot_subtree`, so the
   world tip keeps tracking live and the operation itself lands in history
   (section 6.1): the cursor navigates the log as frozen at the first step and
   re-anchors on the tip each step produces, and `@checkout`/`@publish` read a
   faithful tip. The one remaining gap is deletions: the additive bridge
   (section 4.1) never removes a key a restore deleted, so a subtree that lost
   objects still carries them in history until a deletion-aware snapshot lands
   (section 14).
7. Tests per section 12, wired into `module.mk`. Done:
   `src/builder/test_builder_history.c` drives the workflow engine over a real
   muddb and CAS depot: per-edit undo/redo with index rebuild (round trip),
   zone-scoped undo that leaves another zone alone (scoping), the zone-filtered
   history listing, checkout reference rewrite, publish fast-forward, publish
   refusal on a moved fork point (publish race), a numbered `@restore`, and
   `@checkpoint`. The reference-rewrite and inbound/outbound integrity cases
   remain covered at the primitive level in `test_world_restore.c`, and
   retention in `test_builder_snapshot.c`. All wired into `module.mk`
   (test_builder_history, 41 checks).
