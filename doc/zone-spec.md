# Zone Spec

Design spec for the zone model: the light grouping unit that anchors `@dig`
templates and per-Builder quotas. From the `zone-model` kanban card and
`doc/plan.md` section 4 and Phase 1. Kept deliberately minimal; this is not
the ColdFire sandbox area model (`doc/mud-cf-sandbox-design.md`).

Status: agreed, signed off 2026-07-16. Implementation may begin
(`doc/plan.md` section 5).

## 1. Purpose and scope

A zone groups rooms (and later items and NPCs) under a shared id namespace,
a default template for new rooms, and a creator of record. It exists so that:

- `@dig` and `@redit new` know what template to seed a new room from.
- room ids are namespaced, so two builders can both make a "square" without
  colliding.
- per-Builder quotas have a unit to count against.

Out of scope: access control (edit scope is open, `doc/plan.md` section 4),
the ColdFire area/capability model, and any cross-zone linking rules beyond
plain exits.

## 2. Data model

A zone's metadata lives in a **`zoneinfo` object** at key
`zone/<slug>/zoneinfo` in the `objs` domain, with `%kind = zone`. The zone is
not a bare directory: `zoneinfo` is the OBJ that carries the zone's title,
creator, template, and access list. The zone's namespace is everything under
`zone/<slug>/`. (`zone`, and the reserved leaf name `zoneinfo`, are
config-driven, `doc/olc-spec.md` 3.2.)

| Property        | Required | Description |
|-----------------|----------|-------------|
| `%kind`         | yes      | `zone`; marks this OBJ as zone metadata. |
| `title`         | yes      | Human-readable zone name. |
| `creator`       | yes      | Username of the zone's creator, stamped once. |
| `%parent`       | no       | Enclosing zone's `zoneinfo`; unset on the world root (see 2.1). |
| `template`      | no       | Default room template for `@dig`, a class in the room hierarchy (`templates/room/...`, `doc/template-hierarchy.md`). |
| `builders`      | no       | Edit-access allow-list; unset means open to any Builder (2.2). |
| `desc`          | no       | Builder-facing note about the zone. |
| ambient props   | no       | e.g. time and weather settings, inherited by children (2.1). |

`<slug>` is the zone's path segment under `zone/`, so `zone/darkwood/...` is
the Darkwood zone. `creator` is stamped by `builder_save()` and never
rewritten, consistent with open edit scope.

Two distinct prototype relationships use `%parent`, and they must not be
confused:

- A **zone's** `%parent` points at its **parent zone** (2.1). This is the
  world/area hierarchy and carries ambient inheritance.
- A **room's** `%parent` points at its zone's **room template** (section 4).
  This seeds a new room's defaults. It is not the zone hierarchy.

### 2.1 Zone hierarchy and ambient inheritance

Zones nest by path and link by `%parent`. A sub-zone is simply a deeper path
that has its own `zoneinfo`; its `%parent` points at the enclosing zone's
`zoneinfo`. A typical world is a shallow tree:

```
zone/world/zoneinfo               (root, %parent unset)
zone/darkwood/zoneinfo            (%parent = zone/world/zoneinfo)
zone/darkwood/mansion/zoneinfo    (%parent = zone/darkwood/zoneinfo)
```

A location large enough to be its own zone (its own namespace, its own room
template) can still sit under a parent zone and inherit **ambient
properties** from it. Time of day and weather are the motivating examples:
the mansion is its own zone but reads its time and weather from `darkwood`
unless it overrides them. Resolution walks the zone `%parent` chain with
`obj_cache_prop_resolve` (up to 10 levels), the same mechanism rooms use for
their template.

A plain builder sub-directory is *not* a zone: `zone/darkwood/dungeon/room1`
with no `zone/darkwood/dungeon/zoneinfo` still belongs to `darkwood`. A
directory becomes a sub-zone precisely when a `zoneinfo` is placed in it
(3), so builders organize freely without accidentally minting zones.

The concrete ambient property set (a weather/time system) is out of scope
here; this spec only fixes that such properties resolve up the zone chain and
that the world is the root. A zone overrides an inherited ambient property by
setting it locally.

### 2.2 Edit access

Edit scope is **open by default**, as `doc/plan.md` section 4 decided: any
Builder (`B` flag) may edit any object. A zone may narrow that with an
optional `builders` allow-list:

- `builders` unset: any Builder may edit objects in the zone (the default).
- `builders` set: only the listed usernames, plus wizards, may edit objects
  in the zone. This is how a head builder hands a zone to a specific team.

`builder_save()` is the enforcement point: on a write under `zone/<slug>/...`
it resolves the zone (3) and checks the `builders` list before committing.
Wizards bypass the list. This refines, but does not reverse, the open-scope
decision: the default is still open, and the plan's section 4 should note the
per-zone restriction when this lands.

## 3. Id namespacing

Every game **instance** lives under the `zone/` base; that first segment is
the only thing that marks a key as a placed game object, as opposed to a
class (`templates/...`) or an OLC starter (`olc/...`). See `doc/olc-spec.md`
3.1 and 3.2. An instance's key is `zone/<slug>/<id>` by default. Builders may
create arbitrary sub-directories under a zone for their own organization
(`zone/<slug>/dungeon/<id>`); the zone layer ignores that structure.

- **Resolving an object's zone.** The owning zone is the nearest ancestor
  path that has a `zoneinfo` object. In the common case that is just the
  second segment: everything under `zone/darkwood/` belongs to `darkwood`
  (key `zone/darkwood/zoneinfo`) unless a deeper `zoneinfo` re-roots part of
  it into a sub-zone (2.1). No separate "selected zone" session state is
  needed; a builder's zone is wherever they are standing.
- **The root zone** is the shipped default zone, its slug configured by
  `olc.root_zone` (`doc/olc-spec.md` 3.2); its `zoneinfo` ships in `sample/`.
  A new player or a builder without an explicit zone starts there. Code
  tolerates a missing `zoneinfo` (falls back to the configured default
  template), but the shipped record is the normal case.

## 4. @dig and @create integration

`@dig <dir> <name>` and `@redit new <name>`:

1. Resolve the current zone from the builder's room id (section 3).
2. Form the new room's `commit_key` `zone/<slug>/<name>` (or under the
   builder's current sub-directory).
3. Seed the scratch OBJ (`doc/ui-layer-spec.md` 5.4.1) from the zone's
   `template`, or the configured default when the zone has none.
4. `@dig` links the exit both ways and commits via `builder_save()`; `@redit
   new` opens the editor on the scratch and commits on Submit.

**Template seeding.** The new room sets `%parent` to the zone's `template`
so it inherits the template's defaults through the prototype chain
(`obj_cache` resolves `%parent` up to 10 levels, see `doc/template-hierarchy.md`), and
overrides only the fields the builder edits. This keeps a zone's rooms
consistent and lets a template change propagate. Prototype inheritance over a
flat copy is a settled decision (section 9).

## 5. Quotas

Per-Builder creation limits (the Phase 4 guardrail on the `builder-role`
card) count objects by `creator`. A zone is the natural scope to count
within, but enforcement and the limit value live with `builder-role`, not
here. This spec only guarantees that `creator` is recorded on every zone and
room so the count is possible. Quota is advisory, not access control; the
`builders` allow-list (2.2) is the access control.

## 6. Commands

Minimal surface for the first cut:

- `@zone new <slug>` creates a zone by writing `zone/<slug>/zoneinfo`
  (`%kind = zone`), stamping `creator`. **Wizard-only**: allocating a
  namespace is structural, unlike building rooms inside one. A sub-zone is
  created the same way at a deeper path, with `%parent` set to the enclosing
  `zoneinfo`.
- `@zone set template <ref>` sets the default `@dig` template. Wizard-only.
- `@zone set title <text>` / `@zone info` edit and show zone metadata.
- `@zone builders <slug> [+user | -user | list]` manages the edit-access
  allow-list (2.2). Wizard-only.

Building rooms within a zone needs the `B` flag and, if the zone has a
`builders` list, membership in it (2.2). A fuller `@zedit` menu editor can come
later and would reuse the UI layer like `@redit`; it is not required for the
first cut.

## 7. Validation

- `<slug>` is unique (no existing `zone/<slug>/zoneinfo`), lowercase, no
  whitespace. A sub-zone slug is a single new path segment under its parent.
  Enforced at `@zone new`.
- `template`, if set, must resolve to an existing object.
- Room-side: `builder_save()` already checks id uniqueness and exit-target
  existence; the zone layer adds no separate room validation.

## 8. Testing plan

- **Zone round-trip.** Create a `zoneinfo` OBJ, save and reload through
  muddb, assert `%kind` / `title` / `creator` / `template` survive.
- **Namespacing.** `@dig` in `zone/darkwood/foo` creates
  `zone/darkwood/bar`; zone resolution finds `zone/darkwood/zoneinfo`. A
  deeper `zoneinfo` re-roots its subtree into a sub-zone.
- **Template seeding.** A room dug from a zone with a `template` has
  `%parent` set to it and resolves an inherited default; a zone without a
  template falls back to the configured default.
- Wired into `module.mk` for CI (`ci-test-coverage` card).

## 9. Resolved

- **`%parent` prototype, not flat copy**, for both relationships: a room
  inherits its zone template, and a zone inherits its parent zone's ambient
  properties (time, weather). Consistency and propagation win over
  independence.
- **Zones form a hierarchy** under a world root (2.1); sub-zones inherit
  ambient state from their parent zone.
- **Zone creation is wizard-only** (section 6); allocating a namespace is a
  structural privilege.
- **Edit access is open by default, zone-restrictable** via the `builders`
  allow-list (2.2).
- **Cross-zone exits are allowed and flagged**, not blocked. The editor shows
  an info prompt on add and annotates the exit with `[zone: <name>]` when the
  target is in another zone (see `doc/olc-spec.md` 5.3).
- **A default root zone record ships** in `sample/`; OLC paths and template
  roots are config-driven (`doc/olc-spec.md` 3.2), not hardcoded.
- **A zone is a `zoneinfo` object, not a bare directory** (2). Instances live
  under `zone/<slug>/...`; the `zone/` segment is the only marker of a game
  instance. Zones nest by placing a `zoneinfo` at a deeper path (2.1, 3), so
  a plain builder sub-directory never accidentally becomes a zone.

## 10. Open questions

- (none blocking; see `doc/olc-spec.md` and `doc/template-hierarchy.md` for
  the deferred template/config details.)

## 11. Implementation

Split so the game reads zones without depending on the builder layer:

- **`src/zone/zone.c` / `zone.h`** (core, depends only on obj): the
  read/query side. `zone_info_key` (2), `zone_resolve` and `zone_exists`
  (3, nearest-ancestor `zoneinfo`), `zone_get`, `zone_resolve_prop` /
  `zone_template` (2.1 ambient/template up the `%parent` chain), and
  `zone_may_edit` (2.2 allow-list, open by default, local not inherited).
- **`src/zone/zone_builder.c` / `zone_builder.h`** (on `builder_save`):
  `zone_create` writes a zoneinfo (`%kind=zone`, `%parent` to the enclosing
  zone) through the builder choke point, so section 6's `@zone new` becomes a
  thin command over it.
- **`builder_save()`** (`src/builder/`) is the write choke point (2.2);
  the `%parent` chain walk uses `obj_resolve_prop` (`src/obj/`).
- Tests: `src/zone/test_zone.c` (core round-trip and resolution),
  `src/zone/test_zone_builder.c` (creation, permission, dup guard, nesting).

Still to land (the command layer): `@zone` / `@dig` commands, wiring
`builder_save` edit-access to `zone_may_edit` and `room_create` to
`zone_resolve`/`zone_exists`, and a shipped root-zone record in `sample/`.
