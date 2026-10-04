---
title: OLC Item and NPC Editors (@oedit/@medit)
status: done
gitlab-sync: OrangeTide/boris#73
---

Item (`@oedit`) and NPC (`@medit`) editors on the same pattern as `@redit`,
built once the room editor shape is proven. Reuse the UI layer, the
two-namespace key model, and `builder_save()`. See `doc/plan.md` Phase 3.
Depends on `olc-redit` and `template-hierarchy`. Item field set is in
`doc/olc-spec.md` section 6 / `doc/item-schema.md`. NPC editing uses the
entity system (`src/entity/`, PC/NPC/creature, `%parent` prototype chain).

- [x] `@oedit` over the item schema (`doc/item-schema.md`); type-dependent
      fields (container capacity, wear slot) built from `type` at open
      (`src/cmd/oedit.c`)
- [x] `@medit` over the drafted field set (`doc/olc-spec.md` section 7):
      name/keywords/desc, `%kind`, `%parent` class, difficulty, faction,
      loot, Skills sub-frame (16 actions), Tags sub-frame; class vs instance
      commit target; `%`-keys via internal accessor (`src/cmd/medit.c`)
- [x] shared wizard components factored out of `@redit` into `src/cmd/olc.c`
      (`olc_copy_props`, `olc_make_scratch`, `olc_submit`), used by both
- [x] save through `builder_save()` (via `olc_submit` + `builder_zone_ops`)
- [x] end-to-end tests: `medit_class` (author a class, save, reopen, add a
      tag) and `oedit_item` (create a container, save, reopen, confirm the
      type-dependent Capacity field appears) smoke cases, both backends
