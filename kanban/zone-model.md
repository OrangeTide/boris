---
title: Zone Model
status: done
gitlab-sync: OrangeTide/boris#77
---

Light grouping unit for content. A zone's metadata is a `zoneinfo` OBJ in
`objs` (`zone/<slug>/zoneinfo`, `%kind=zone`) and is the anchor for `@dig`
templates and per-Builder quotas. Instances live under `zone/<slug>/...`;
the `zone/` segment marks a game instance (`doc/zone-spec.md`). Kept
deliberately minimal; not the ColdFire sandbox area model. See `doc/plan.md`
Phase 1. Depends on nothing; `builder-commands` (#6) and `builder-role`
build on it.

- [x] write `doc/zone-spec.md` before coding (data model, commands) -- signed off 2026-07-16
- [x] `src/zone/` model: zoneinfo record (title, creator, `%parent`,
      default `@dig` template), key helpers (`zone_info_key`)
- [x] zone resolution: nearest-ancestor `zoneinfo` (`zone_resolve`);
      plain sub-directories transparent, deeper zoneinfo re-roots a subtree
- [x] zone hierarchy via `%parent` (world root -> zones -> sub-zones);
      props resolve up the chain (`zone_resolve_prop`, `zone_template`)
- [x] edit-access allow-list, open by default (`zone_may_edit`)
- [x] `zone_create` through `builder_save` (creator stamp, dup guard)
- [x] load/save round-trip + resolution tests (`test_zone`, 20 cases)
- [x] `@zone` commands: `@zone new` (wizard-only), `@zone info`,
      `@zone set <field>` (title/template/desc), `@zone builders`
      (list/+user/-user); verified in-game (`src/cmd/zone_cmd.c`).
- [x] wire `builder_save` edit-access to `zone_may_edit` via an injected
      `may_edit` hook and `builder_zone_ops` (`src/zone/zone_ops.c`);
      wizards bypass, open zones unrestricted. `@dig`/`@zone` use it.
- [x] target-zone-exists soft check on create: `builder_save` warns (never
      blocks) when a new object's enclosing zone has no `zoneinfo` yet, via
      an optional `req->zone_key`; `room_create` and `@redit` create set it
      (`test_missing_zone`, verified in-game)
- [x] ship a default root zone record in `sample/`
      (`sample/objs/zone/zoneinfo.json`); `zone/world` `%parent`s to it so
      top-level zones inherit shared defaults up the chain
- [x] `@zedit` menu editor for zone metadata (title, description, dig
      template, parent zone, builder note, and a `builders` allow-list
      sub-frame), a sibling of `@redit` on the UI layer (`src/cmd/zedit.c`),
      wizard-only and edit-only; covered by the `zedit_meta` smoke case
