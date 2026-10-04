# Scratch OBJ Spec

Design spec for the scratch / temporary OBJ: the detached working copy used
for editing and for collecting new-object parameters. From the `scratch-obj`
kanban card and `doc/ui-layer-spec.md` section 5.4.1. Prerequisite for the
UI layer's OBJ binding and the OLC.

Status: draft for review. Per `doc/plan.md` section 5, coding does not start
until this spec is agreed.

## 1. Purpose and scope

Editing must not touch the live world until the builder commits. A scratch
OBJ is an object the builder edits freely; the live object (or the target
id, for a create) is untouched until `builder_save()` runs on Submit. This
gives Cancel and Undo for free and keeps validation off the live store.

Two uses, one mechanism:

- **Edit** an existing object: the scratch is a clone of the live object.
- **Create** a new object: the scratch starts empty or from a template and
  accumulates fields until Submit turns it into a live object.

## 2. What already exists

Most of the primitive is present in `src/obj/obj.h`:

- `OBJ *obj_new(const char *key)` builds a bare OBJ that is **not registered
  in any cache**, so it is inherently detached and invisible to `obj_get`.
  That is the ephemeral scratch.
- `OBJ *obj_new_from_json(const char *key, const char *json)` and
  `int obj_get_json(OBJ *obj, char *buf, size_t len, size_t *out_len)`
  give a clone path: serialize the live object, rebuild it as a scratch.
- `obj_free(OBJ *obj)` drops it.
- `obj_prop_set_internal` writes `%`-protected props such as `%parent`.

So this card is thin: a small set of helpers over these primitives plus the
optional account-scratch persistence. It adds no new object representation.

## 3. API

```
/* empty scratch for a create; key is the intended commit key */
OBJ *scratch_new(const char *key);

/* clone a live object into a detached scratch (edit) */
OBJ *scratch_from_obj(const char *key, OBJ *live);

/* empty scratch that inherits a template via %parent (create-from-template) */
OBJ *scratch_from_template(const char *key, const char *template_key);

/* drop an ephemeral scratch */
void scratch_free(OBJ *scratch);
```

- `scratch_from_obj` clones `live` with the new `obj_dup` helper (below),
  then assigns `key`. The clone is independent; edits do not reach `live`.
- `scratch_from_template` is `obj_new(key)` then
  `obj_prop_set_internal(scratch, "%parent", template_key)`, so the new
  object resolves template defaults through the prototype chain
  (`obj_cache_prop_resolve`, up to 10 levels) and overrides only edited
  fields.
- Commit is **not** here: `builder_save(commit_key, scratch)` (Phase 0 card)
  reads the scratch and writes the live store. Scratch-obj only produces and
  disposes the detached object.

### 3.1 obj_dup and the duplicate-key hazard

Add a clone primitive to `obj.h`:

```
OBJ *obj_dup(OBJ *src);   /* deep copy of src's properties, with NO key */
```

`obj_dup` deliberately produces a **keyless** object. The store has no
concept of two objects sharing a key; if two ever save under the same id the
result is silent data loss that is hard to detect. Returning a keyless clone
closes that hole by construction: the copy cannot be saved until something
assigns a fresh unique key (the `scratch_*` helpers set the commit key,
`builder_save` checks uniqueness). Cloning by `obj_get_json` + a caller-chosen
key is the alternative but leaves the same-key trap open, so `obj_dup` is
preferred.

Note for `builder_save` / muddb (Phase 0): add a guard that **detects and
refuses a save whose key already exists** unless the caller intends an
overwrite, and a tool/check to scan the store for duplicate ids. This is the
backstop for the hazard `obj_dup` avoids at the source.

## 4. Ephemeral lifetime

The default scratch is memory-only and its lifetime is the **connection**,
not a single editor frame:

- Created with `obj_new` / the helpers above, held by the connection's edit
  context (UI spec 5.6), reached through `ui_obj_binding.scratch` while a
  frame is open.
- Never inserted into the object cache, so no other connection and no
  `obj_get` can see it.
- Survives leaving the editor: the staged edits stick for as long as the
  connection is live and resume on re-entry.
- Freed only on **Submit** (committed), an explicit **Discard**, or
  **disconnect** (UI spec section 7). Merely closing the editor frame does
  not drop it.

## 5. Account-scratch (resumable, opt-in; ships after the ephemeral path)

For edits a builder may want to resume after a disconnect, the scratch is
also persisted:

- On stage, serialize with `obj_get_json` and store the JSON under a
  per-account scratch record.
- On reconnect, if a scratch record exists for an edit, offer to resume:
  reload it with `obj_new_from_json` and continue.
- On commit or explicit discard, delete the record.

Storage key is deferred to the muddb/zone specs; the proposal is a record
per `(user, edit-id)`, for example under the `users` domain keyed
`<user>/scratch/<edit-id>`, or a dedicated `scratch` domain. Account-scratch
is opt-in per edit; simple edits stay ephemeral.

**Decided: account-scratch ships after the ephemeral path.** The ephemeral
scratch is the whole of the first cut; resume-after-disconnect is a later
increment. Nothing in the ephemeral path depends on it, and its storage key
can be settled alongside the muddb/zone work rather than blocking the UI
layer.

## 6. Testing plan

- **Isolation.** Edit a `scratch_from_obj` clone; assert the live object is
  unchanged until an explicit commit.
- **Keyless clone.** `obj_dup` returns an object with no key; a save attempt
  without assigning a key is refused; the duplicate-key guard rejects a save
  whose key already exists.
- **Template inheritance.** `scratch_from_template` resolves an inherited
  default via `%parent` and overrides only set fields.
- **Ephemeral cleanup.** A scratch is freed on frame teardown and was never
  visible to `obj_get`.
- **Resume.** An account-scratch record round-trips through
  `obj_get_json` / `obj_new_from_json` and reloads identically; commit or
  discard deletes it.
- Wired into `module.mk` for CI (`ci-test-coverage` card).

## 7. Commit collision

If the live object changed while a scratch was open (another builder edited
the same room), Submit must decide what to do. **Decided: v1 is
last-write-wins** -- the scratch overwrites whatever is live. It is the
simplest correct behavior and concurrent edits of one object are rare on a
single-threaded server.

Long term, a **field-granularity 3-way merge** is the goal: compare the
`baseline` (the clone taken at edit-start), the current live object, and the
scratch; apply the scratch's changes to fields the other edit did not touch,
and warn only on fields both changed. The `baseline` already held for Undo is
exactly the merge base, so no new state is needed to add this later.

## 8. Open questions

- Account-scratch storage: which domain and key? (Timing is settled: it
  ships after the ephemeral path, section 5.)
