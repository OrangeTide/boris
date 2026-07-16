---
title: OLC Item and NPC Editors (oedit/medit)
status: backlog
gitlab-sync:
---

Item (`oedit`) and NPC (`medit`) editors on the same pattern as `redit`,
built once the room editor shape is proven. Reuse the UI layer, the
two-namespace key model, and `builder_save()`. See `doc/plan.md` Phase 3.
Depends on `olc-redit`. NPC editing uses the entity system (`src/entity/`,
PC/NPC/creature, `%parent` prototype chain).

- [ ] `oedit` item field set and step flow
- [ ] `medit` NPC field set, including template/prototype selection
- [ ] shared wizard components factored out of `redit`
- [ ] save through `builder_save()`
- [ ] end-to-end tests for each editor, asserting the saved OBJ
