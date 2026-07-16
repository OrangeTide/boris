---
title: builder_save / room_create Primitive
status: backlog
gitlab-sync: OrangeTide/boris#70
---

Single save choke point for all builder writes, plus a `room_create()`
helper. Today there is no `room_create()` and no validation path; unchecked
creation caused the `char set` corruption (#3). Every OLC and `@`-command
write goes through `builder_save()`. See `doc/plan.md` Phase 0.

- [ ] `builder_save()`: `B`-flag check, field validation, exit-target
      existence check, `creator` stamping on new objects, then commit
- [ ] `room_create()`: unique id, required fields, place in zone
- [ ] no per-object ownership enforcement (open edit scope)
- [ ] hook point left for later versioning (#14) and audit logging
- [ ] unit tests for validation and creator-stamping paths
