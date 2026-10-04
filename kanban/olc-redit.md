---
title: OLC Room Editor (@redit)
status: done
gitlab-sync: OrangeTide/boris#74
---

Menu-based room editor, the first and reference OLC surface. A step wizard
walks the room's fields in sequence, rendered per client (text, MXP, or web
form). Built on the rebuilt UI layer. See `doc/plan.md` Phase 3. Depends on
`ui-layer-rebuild`, `builder-save`, `zone-model`, `string-editor`, and
`scratch-obj`. Relates to `room-display` (#34) and `room-schema` doc.

Implemented in `src/cmd/redit.c`; create + edit + save + exit sub-editor +
multi-line long-desc editing + `@check` all verified in-game. The scratch,
copy-from-live, and Submit boilerplate was later factored into the shared
`src/cmd/olc.c` helpers (`olc_copy_props` / `olc_make_scratch` / `olc_submit`),
now shared with `@medit`; `@redit` behaviour is unchanged.

- [x] write `doc/olc-spec.md` before coding (field sets, step flow,
      validation) -- signed off 2026-07-16
- [x] `@redit` walks name, glance, short desc, long desc, builder note,
      owner; read-only creator (exits are the next cut)
- [x] universal actions as letters, field rows as numbers (wizard on
      create, browse on edit)
- [x] exit add/remove sub-step (direction picks numbered); single-exit
      edit of destination/description
- [x] auto-offer reverse exit link on add (opposite-direction map;
      commits on the target room)
- [x] cross-zone exits flagged: `[zone: <slug>]` annotation in the exit list
      and an info prompt on add noting the destination is in another zone;
      a refused reverse link (target zone the builder cannot edit) reports why
- [x] `owner` editable (implicit transfer); illegal owner hard-blocks
      Submit (enforced by `builder_save`)
- [x] warn-and-allow: soft warnings (dangling exits) shown on Submit,
      never trap the builder
- [x] `@check` command (`src/cmd/check.c`): re-runs the read-only soft-warning
      validation (`builder_check`) on one object (`@check [<id>]`, defaulting
      to the current room) or sweeps a whole zone (`@check zone [<slug>]`) via
      `obj_foreach_key`; unit-tested (`test_check`) and covered by the
      `redit_check` smoke case
- [x] long text (UI_TEXT) suspends to the `stred` string editor and
      resumes via `ui_text_result`/`ui_resume_input`; multi-line value
      round-trips on save and reopen
- [x] create seeds a scratch from the zone template (`%parent`); edit
      copies the live room into the scratch
- [x] save through `builder_save()` (via `builder_zone_ops`)
- [x] end-to-end verified by a committed test target: the `redit_longdesc`
      smoke case (`src/tests/smoke.exp`) creates a room, edits the long desc
      in `stred`, saves, and reopens to confirm the multi-line text persists;
      passes under both the muddb and cas backends
