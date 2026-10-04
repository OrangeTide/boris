---
title: Scratch / Temporary OBJ
status: active
gitlab-sync: OrangeTide/boris#113
---

A detached OBJ with no live database key, used as the working copy for
editing and as the collector for new-object parameters. Edits land on the
scratch, not the live object, so Cancel and Undo are cheap and the live
world is untouched until commit. Prerequisite for the interactive UI layer's
OBJ binding and the OLC. Design: `doc/scratch-obj-spec.md` (and
`doc/ui-layer-spec.md` section 5.4.1).

The editing-working-copy goal is met in `@redit` with existing primitives
(`obj_new` for a detached scratch, `copy_props` to seed from the live room,
`builder_save` to commit). The named module API below (`obj_dup`,
account-scratch persistence, dedicated tests) was not built as a separate
unit; what remains is real but not blocking the OLC.

- [x] constructor for a detached OBJ not registered in the object cache
      (`obj_new(key)` yields a scratch not registered until committed)
- [ ] `obj_dup(OBJ*)`: deep-copy clone with NO key, so it cannot be saved
      until a fresh unique key is assigned. NOT built; `@redit` edit uses
      `obj_new` + `copy_props` instead, which covers the same need there.
- [x] seed from a live object (edit) or start empty / from a template (create)
      (`copy_props` on edit; `%kind`/`%parent` template seed on create)
- [~] ephemeral lifetime: freed on Submit, Discard, or disconnect is done
      (frame `free` hook / `ui_free_cb`). "Survives leaving the editor" is
      DEFERRED -> account-scratch below; today a scratch is per-editor.
- [x] commit path: `builder_save(commit_key, scratch)` turns it live
      (`redit_submit`)
- [~] commit collision: v1 last-write-wins is the current behavior; a
      field-granularity 3-way merge (baseline vs live vs scratch) is LATER
- [ ] LATER (after ephemeral path): account-scratch persistence so an
      interrupted edit resumes after reconnect (storage key deferred)
- [ ] tests: COW isolation is exercised by `test_obj`; a dedicated
      scratch-lifecycle test (ephemeral cleanup, resume) is not yet written
