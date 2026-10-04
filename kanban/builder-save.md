---
title: builder_save / room_create Primitive
status: done
gitlab-sync: OrangeTide/boris#70
---

Single save choke point for all builder writes, plus a `room_create()`
helper. Today there is no `room_create()` and no validation path; unchecked
creation caused the `char set` corruption (#3). Every OLC and `@`-command
write goes through `builder_save()`. See `doc/plan.md` Phase 0.

Implemented in `src/builder/builder_save.c` (`builder_save`, `room_create`),
with zone allow-list enforcement in `src/zone/zone_ops.c`. Covered by
`test_builder` (37 cases). Used by `@redit`, `@dig`, `@create/@set`, `@zone`.

- [x] `builder_save()`: `B`-flag check, field validation, exit-target
      existence check, `creator` stamping on new objects, then commit
- [x] `room_create()`: unique id, required fields, place in zone
- [x] edit-access: open by default; enforce a zone's `builders` allow-list
      when set; wizards bypass (`builder_zone_ops`)
- [x] duplicate-key guard: refuse a create whose key already exists.
      (A separate scan tool to find pre-existing duplicate ids was not built;
      spin it into its own card if wanted -- not needed for the primitive.)
- [x] hard-block validation: legal `owner` on transfer, required fields;
      soft warnings (dangling exits) do not block
- [x] hook point left for later versioning (#14) and audit logging
      (the commit step in `builder_save` is the marked insertion point)
- [x] unit tests for validation and creator-stamping paths (`test_builder`)
