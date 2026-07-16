---
title: OLC Room Editor (redit)
status: backlog
gitlab-sync:
---

Menu-based room editor, the first and reference OLC surface. A step wizard
walks the room's fields in sequence, rendered per client (text, MXP, or web
form). Built on the rebuilt UI layer. See `doc/plan.md` Phase 3. Depends on
`ui-layer-rebuild`, `builder-save`, `zone-model`. Relates to `room-display`
(#34) and `room-schema` doc.

- [ ] write `doc/olc-spec.md` before coding (field sets, step flow,
      validation)
- [ ] `redit` walks name, glance, short desc, long desc, exits, creator
      note
- [ ] universal actions as letters, enumerated choices as numbers
- [ ] exit add/remove sub-step (direction picks numbered)
- [ ] long text suspends to `@edit` and resumes
- [ ] save through `builder_save()`
- [ ] end-to-end test: drive a redit session, assert the saved room OBJ
