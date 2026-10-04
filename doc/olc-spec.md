# OLC Editor Spec

Design spec for the menu-based On-Line Creation editors: `@redit` (rooms),
`@oedit` (items), and `@medit` (NPCs). These are the Builder-facing surface of
`doc/plan.md` Phase 3 and the `olc-redit` / `olc-object-editors` kanban
cards. Rooms come first and are the reference; items and NPCs follow the
same pattern. A **`@zedit` for zones** is a wanted future sibling on the same
UI layer (metadata, template, `builders` allow-list); see `doc/zone-spec.md`
section 6.

Status: agreed, signed off 2026-07-16. Implementation may begin
(`doc/plan.md` section 5).

## 1. Purpose and scope

Each editor is a set of `ui_frame` definitions on the interactive UI layer
(`doc/ui-layer-spec.md`). The editor supplies the field list, the bindings,
and the Submit behavior; the UI layer supplies the rendering, input
dispatch, navigation, and lifecycle. The OLC adds no new input model, no new
renderer, and no new persistence path. It is a consumer.

In scope: the field sets, the create-versus-edit flow, exit editing, and the
Submit/validation rules for each object type. Out of scope: the UI layer
mechanics (that spec), the zone model (`doc/zone-spec.md`), and
`builder_save()` internals (Phase 0 card).

## 2. Dependencies

- **`ui-layer-rebuild`** (the whole editor runs on it), and transitively its
  prerequisites: `scratch-obj`, `string-editor`, `mxp-protocol`.
- **`builder-save`** is the Submit target and owns id uniqueness, exit-target
  checks, and `creator` stamping. Implemented in `src/builder/`
  (`builder_save.c`, plus `room_create`).
- **`zone-model`** supplies the `zone/<slug>/...` id namespacing and the
  template `@dig` seeds a new room from. Implemented in `src/zone/`
  (`zone.c` core, `zone_builder.c` creation).

## 3. Common editor model

Every editor is built the same way:

- A **frame builder** constructs a `ui_frame` whose `fields` map object
  properties to `ui_field` entries (section 5.2 of the UI spec).
- The frame's `binding` is a `ui_obj_binding` over a **scratch OBJ**:
  - *Edit* an existing object: scratch is seeded from the live object;
    `baseline` is the live object; `commit_key` is its key.
  - *Create* a new object: scratch starts from a class template (via
    `%parent`) or a copied OLC starter or empty (3.2); `baseline` is NULL;
    `commit_key` is the new key.
- `on_submit` calls `builder_save(commit_key, scratch)` and returns its
  status, so a rejected save keeps the frame open with the edits intact
  (UI spec section 5.3).
- `on_cancel` drops the scratch. `dirty` drives the Quit-confirm.
- The editor is entered from the game command loop; `ui_open` records an
  `on_close` that re-installs `command_lineinput` so the builder returns to
  the game when the editor closes.

Because the flow, keys, lifecycle, and rendering are shared, `@oedit` and
`@medit` are mostly a different field table and a different `commit_key`.

### 3.1 One object type, editors are a convenience

Every game object is the **same OBJ data structure**; there is no separate
room, item, or mob type at the storage layer. `@redit` / `@oedit` / `@medit` are
a **convenience for builders**, curated field sets over the one uniform
object, not a reflection of the internal architecture. "Kind" is a property
and a template class (`doc/template-hierarchy.md`), not a C type. It follows
that a generic property editor could edit any object, and the named editors
are just the friendly, kind-appropriate presentation. This is why one
`ui_obj_binding` and one save path serve all three.

Orthogonal to `%kind` is the object's **role**, recorded by which category
base path it is stored under (3.2): an **instance** in the live world
(`zone/...`), a **class** in the inheritance hierarchy (`templates/...`), or
an **OLC starter** scaffold (`olc/...`). One object may be edited in any
role; the base path, not a separate type, is what the OLC keys off.

### 3.2 Configuration and starter templates

The key namespace is partitioned by **category base paths**, and the base an
object lives under is what identifies its category (3.1): a key under `zone/`
is a game **instance**, a key under `templates/` is a **class**, a key under
`olc/` is an **OLC starter**, and a key under `scratch/` is a per-user
**edit draft** (proposed, deferred; `doc/ui-layer-spec.md` 5.4.2). `@medit`
and the other editors can open an object under any base; the base tells the
OLC what it is editing. Only `zone/` marks a live game instance, so the other
categories are never resolved as world content. The OLC reads these paths
from config rather than hardcoding them, so a deployment can relocate them.
Proposed keys (exact names TBD):

| Config key             | Meaning                                  |
|------------------------|------------------------------------------|
| `olc.zone.base`        | instance root (`zone`); a key under it is a placed game object |
| `olc.zone.info_name`   | reserved zone-metadata leaf name (`zoneinfo`, `doc/zone-spec.md` 2) |
| `olc.root_zone`        | slug of the shipped default root zone (`doc/zone-spec.md` 3) |
| `olc.class.base`       | class-hierarchy root (`templates`)       |
| `olc.class.room`       | class root for rooms (`templates/room`)  |
| `olc.class.item`       | class root for items, etc.               |
| `olc.starter.base`     | OLC starter-template root (`olc`)        |
| `olc.starter.<kind>`   | an OLC starter template for a blank <kind> |
| `olc.scratch.base`     | per-user edit-draft root (`scratch`); account-scratch, deferred (`doc/ui-layer-spec.md` 5.4.2) |

Two kinds of template, and they are not the same mechanism:

- **Class templates** (`olc.class.*`, `doc/template-hierarchy.md`) are used by
  **inheritance**: a new object sets `%parent` to the class and resolves
  defaults up the chain. `@dig` from a zone's class template works this way.
- **OLC starter templates** (`olc.starter.*`) are used by **copy**: their
  properties are copied into the scratch as a starting point for editing, with
  **no `%parent` link**. They are a scaffolding convenience owned by the OLC,
  not part of the class hierarchy, so editing or deleting a starter never
  affects existing objects.

Creating a brand-new object with no chosen class copies the starter; `@dig` and
"create from class" use inheritance.

## 4. Step wizard flow

The default interaction is a step wizard (the decision in `doc/plan.md`
section 4), realized with the UI layer's universal actions:

- `Next` / `Previous` walk the field list in order. This is the guided path
  for creating a new object: fill each field, advance.
- `List` shows the whole field list for out-of-order editing (jump to field
  `k` by number).
- Selecting a field edits it per its type (string editor, enum choice list,
  bool toggle, or subframe), all defined by the UI layer.
- `Submit` validates all required fields, then commits via `builder_save()`.
- `Quit` cancels (confirmed when `dirty`).

New-object creation walks the wizard start to finish; editing an existing
object usually starts in `List` view.

**Prompt with changes present.** Every field row shows its current staged
value from the scratch, so the builder always sees the edit in progress, not
the original. The edit context is held on the connection and survives leaving
the editor: staged edits stick for as long as the connection is live (they
are ephemeral, so a disconnect loses them until account-scratch resume
lands). Re-entering `@redit` on the same object resumes the same staged edit
rather than starting over. One edit context per connection for now; see the
UI layer spec for the single-context-now, multiple-later model.

## 5. @redit (room editor)

### 5.1 Command surface

- `@redit <id>` edits an existing room; error if it does not exist.
- `@redit new <id>` creates a room, seeding the scratch from the target
  zone's default template. `@dig` (the `builder-commands` card) is the other
  creation entry and reuses the same create path, then drops the builder
  into `@redit` on the new room.
- Both require the `B` flag (enforced by the command dispatcher and again by
  `builder_save()`).

**Target zone on create.** The `<id>` a builder types decides the zone:

- A **bare name** (`@redit new closet`) lands in the **current zone**,
  resolved from where the builder is standing (`doc/zone-spec.md` 3).
- A **full path** (`@redit new zone/harbor/dock`) targets that zone
  explicitly, wherever the builder is. This is the no-teleport path.

Either way the create session opens on a **target screen** (5.7) that shows
the resolved zone and id and offers a **Change zone** action, so the target is
always visible and retargetable before any field is edited. Changing the zone
here sets the commit target for this one creation only; it is not persistent
"selected zone" state and does not move the builder. A builder never has to
walk or teleport to build in another zone.

### 5.2 Field set

Keys are the real room OBJ properties (verified in `src/cmd/show_room.c`).
Note: `room-schema.md` lists the glance field as `name.glance`, but the code
reads `desc.glance`; this spec uses the code key and the schema doc should be
corrected.

| Label            | key             | type        | flags      | notes |
|------------------|-----------------|-------------|------------|-------|
| Title            | `name`          | UI_STRING   | required   | first line on look |
| Glance           | `desc.glance`   | UI_STRING   |            | at-a-glance line |
| Short desc       | `desc.short`    | UI_STRING   | required   | fallback body |
| Long desc        | `desc.long`     | UI_TEXT     |            | multi-paragraph; string editor |
| Builder note     | `builder.info`  | UI_STRING   |            | not shown to players |
| Exits            | (subframe)      | UI_SUBFRAME |            | see 5.3 |
| Creator          | `creator`       | UI_STRING   | readonly   | stamped by builder_save |
| Owner            | `owner`         | UI_STRING   |            | editable; transfer, hard-validated (5.4) |

`creator` is read-only in the editor; `builder_save()` stamps it on create
and never rewrites it. `owner` is editable, so setting it is an implicit
ownership transfer; unlike the soft warnings, an illegal `owner` blocks
Submit (5.4). `id` is not a field; it is fixed at create time and is the
`commit_key`.

### 5.3 Exit sub-editor

The Exits field is a `UI_SUBFRAME`. Its `open_child` builds an **exit-list
frame** from the room's current `exit.<dir>.to` properties:

- Each existing exit is a numbered row: `<dir> -> <target-id>`. When the
  target is in another zone, the row is annotated `[zone: <name>]` so the
  builder can see they are linking out (section 5.6):

  ```
  Room: The Fantastic Closet
  ==========================

  Exit "out"      : Mud Room
  Exit "trapdoor" : Cave of Regret [zone: Dark Dimension]
  ```

- Actions: an `Add` action (a reserved letter, e.g. reuse `Next`/`List` plus
  an add) and, on a selected exit, edit or remove.

Selecting an exit row opens a **single-exit frame** with two fields:

| Label       | key                | type      | flags    | validate |
|-------------|--------------------|-----------|----------|----------|
| Destination | `exit.<dir>.to`    | UI_OBJREF | required | target room exists |
| Description | `exit.<dir>.desc`  | UI_STRING |          |          |

Adding an exit first picks a **direction** from the enumerated set
(`n s e w ne nw se sw u d enter`, numbered per the two-namespace input
model), then fills destination and description. Removing an exit deletes both
`exit.<dir>.to` and `exit.<dir>.desc` from the scratch.

All exit edits land on the scratch and commit with the room on Submit.

**Reverse linking.** Adding an exit **automatically offers the reverse
link**: after setting `exit.<dir>.to = <target>`, the editor proposes
creating the opposite exit (`exit.<opposite>.to = <this room>`) on the
target, defaulting to yes. The builder can decline for one-way passages. The
opposite of each direction is fixed (`n<->s`, `e<->w`, `ne<->sw`, `nw<->se`,
`u<->d`; `enter` has no automatic reverse). `@dig` does the same at creation.
Because the reverse edit lands on the *target* room, it commits directly (a
small `builder_save` on the target), not on this room's scratch; declining
leaves the target untouched.

### 5.4 Validation: hard blocks vs soft warnings

Two classes of check, deliberately different:

- **Hard blocks** stop Submit until fixed. Required fields (`name`,
  `desc.short`, `UI_F_REQUIRED`), a well-formed `id`, and a **legal `owner`**
  (an existing user the transfer is allowed to). `builder_save()` rejects and
  the frame stays open (UI spec `on_submit` returns -1).
- **Soft warnings** are shown but do **not** stop Submit. A dangling
  `exit.<dir>.to` (target does not exist yet) is the main one; a builder can
  commit and create the target later. This is deliberate: the workflow must
  let a builder lay rooms out in any order and step away, not trap them in the
  editor.

**Re-checking warnings.** Because warnings do not block, a builder needs a way
to find them again later. Two mechanisms:

- Re-open the object in `@redit` and Submit again; the warnings re-run and
  redisplay.
- `@check <id>` re-runs validation on one object, and `@check zone [<slug>]`
  sweeps a whole zone, reporting every soft warning (dangling exits, orphans)
  without opening the editor. This is the "did I finish my zone" check.

Implemented in `src/cmd/check.c` on `builder_check()` (the read-only half of
`builder_save`, dangling exits so far; orphans are a later addition). Bare
`@check` with no argument checks the room the builder is standing in, and a
bare id resolves against the current zone, mirroring `@redit`. The zone sweep
enumerates keys through `obj_foreach_key()`; the CAS object-store backend has
no key listing yet, so `@check zone` there reports that the sweep is
unavailable rather than a partial result.

Id uniqueness on create is a hard block in `builder_save()`.

### 5.5 Binding and commit

`ui_obj_binding { scratch, baseline, prefix="", commit_key }` where
`commit_key` is `zone/<slug>/<room>` (domain `objs`, `doc/zone-spec.md` 3),
possibly under a builder sub-directory. Edit seeds scratch from the live room;
create seeds from the zone template. Submit runs
`builder_save(commit_key, scratch)`.

### 5.6 Cross-zone exits

An exit whose target is in a different zone (the target id's prefix differs
from this room's, `doc/zone-spec.md` section 3) is allowed but flagged, never
blocked:

- On add, an info prompt notes the destination is in another zone.
- In the exit list, the row is annotated `[zone: <name>]` (5.3), so the
  cross-zone link is visible at a glance without opening each exit.

Both live in `src/cmd/redit.c`: `add_submit` prints the note when the
destination's zone (`zone_resolve`) differs from the room's, and
`build_exit_list` appends the annotation; `<name>` is the zone's display slug
(`zone/darkwood` shown as `darkwood`). A reverse link into a zone the builder
cannot edit is refused by `builder_save`, and its reason is surfaced rather
than silently dropped.

## 5.7 Screen-by-screen walkthrough

Concrete rendering of a full `@redit new` session, the reference for the
implementation. Screens are the text-client form; MXP and web clients render
the same model differently (`doc/ui-layer-spec.md`). The convention throughout:
**universal actions are letters** (`[N]ext` `[P]rev` `[L]ist` `[S]ubmit`
`[Q]uit`, and `Enter` to accept/proceed); **everything screen-specific is a
numbered entry**, picked with `[#]`. No screen invents its own letter command.
Every screen shows the staged value, never the original (§4).

### 5.7.1 Target screen (create only)

First screen of a create session. Both the zone and the id are changeable, so
each is a numbered row; the commit key is derived and read-only.

```
Create Room
===========
 1) Zone   darkwood            [from your location]
 2) Id     closet
    key -> zone/darkwood/closet

[#] change   [Enter] begin   [Q] quit
```

`1` opens a numbered zone list (`1) darkwood  2) harbor  3) world`) and
re-forms the key; `2` edits the leaf id, or accepts a full path
(`zone/harbor/dock`), which also resets the zone. `Enter` seeds the scratch
from the zone template (`doc/zone-spec.md` 4) and advances to the first field;
`[Q]` cancels (nothing staged yet, so no confirm). An edit session
(`@redit <id>`) skips this screen and opens on the List view (5.7.3).

### 5.7.2 Field screen (the wizard step)

One field at a time, the guided create path. `Next`/`Previous` walk the field
list from 5.2 in order.

```
Room: zone/darkwood/closet                       (field 3 of 8)
-----------------------------------------------------------------
Short desc *   A cramped broom closet.

Required. The fallback body shown on look.

[Enter] edit   [N]ext   [P]rev   [L]ist   [S]ubmit   [Q]uit
```

`*` marks a required field. `Enter` edits the shown field with its type
editor: a line prompt for `UI_STRING`, the string editor (`@edit`, suspends
and resumes) for `UI_TEXT`, a numbered choice list for `UI_ENUM`, a toggle for
`UI_BOOL`. A read-only field (`Creator`) shows `(read-only)` and offers no
`Enter` edit.

### 5.7.3 List view (out-of-order editing)

`[L]` shows every field with its staged value; a builder jumps to any field by
number. Editing an existing room opens here.

```
Room: zone/darkwood/closet
-----------------------------------------------------------------
 1) Title *        The Broom Closet
 2) Glance         a narrow closet
 3) Short desc *   A cramped broom closet.
 4) Long desc      (3 lines)
 5) Builder note   --
 6) Exits          out -> mud-room
 7) Creator        rhea            (read-only)
 8) Owner          rhea

[#] edit field   [S]ubmit   [Q]uit
```

### 5.7.4 Exit sub-editor

Selecting `Exits` (field 6) opens the exit list (5.3). Full add / edit /
remove, not just `@dig`-in-situ creation. Adding is a numbered entry, not a
letter command.

```
Exits of zone/darkwood/closet
-----------------------------------------------------------------
 1) out       -> mud-room
 2) trapdoor  -> cave-of-regret   [zone: dark-dimension]
 3) (add a new exit)

[#] select   [Enter] back
```

Selecting an existing exit (1, 2) opens the single-exit frame; selecting the
add row (3) starts the add flow.

```
Exit "out" of zone/darkwood/closet
-----------------------------------------------------------------
 1) Destination   mud-room
 2) Description   a plain door
 3) remove this exit

[#] edit   [Enter] back
```

Add walks: pick a **direction** from the numbered set, then fill the
single-exit frame (destination soft-warns if the target does not exist yet,
5.4), then the **reverse-link offer** (default yes, 5.3):

```
Add exit -- pick a direction:
 1) n   2) s   3) e   4) w   5) ne  6) nw
 7) se  8) sw  9) u  10) d  11) enter
[#] choose   [Enter] cancel

Destination : zone/darkwood/pantry
Description  : a low doorway

Also link pantry "west" back to this room? [Y/n]
```

`remove this exit` (entry 3 of a single-exit frame) deletes both
`exit.<dir>.to` and `exit.<dir>.desc` after a confirm. All exit edits land on
the scratch and commit with the room; the reverse link commits directly on the
target room (5.3).

### 5.7.5 Submit

`[S]` validates. Hard blocks stop the commit and list what to fix; soft
warnings are shown but do not block (5.4). `[L]` returns to the field list to
fix a block.

```
Submit zone/darkwood/closet
-----------------------------------------------------------------
BLOCK  Owner "nobody" is not a valid user.
warn   Exit "trapdoor" -> cave-of-regret: target does not exist yet.

[L]ist (back to fix)   [Q]uit
```

With no hard blocks, Submit calls `builder_save()` and, on success, closes the
editor back to the game, echoing the saved key. A `builder_save()` rejection
keeps the frame open with edits intact (§3, UI spec 5.3).

### 5.7.6 Quit

`[Q]` closes the editor. If `dirty`, it confirms first (`Discard changes to
zone/darkwood/closet? [y/N]`); the staged edit otherwise survives on the
connection and re-opening `@redit` on the same id resumes it (§4).

## 6. @oedit (item editor)

Follows the room pattern once `@redit` is proven, over the conservative item
schema (`doc/item-schema.md`). An item instance commits to `zone/<slug>/<id>`,
the same instance namespace as a room; an item **class** lives under
`templates/item/...`. Mechanics (scratch binding, wizard, Submit) are
identical to `@redit`.

| Label       | key                  | type        | flags    | notes |
|-------------|----------------------|-------------|----------|-------|
| Name        | `name`               | UI_STRING   | required | short display name |
| Keywords    | `keywords`           | UI_STRING   | required | targeting words |
| Short desc  | `desc.short`         | UI_STRING   | required | ground/list line |
| Long desc   | `desc.long`          | UI_TEXT     |          | examine / readable text |
| Template    | `%parent`            | UI_OBJREF   |          | class (`templates/item/...`) |
| Type        | `type`               | UI_ENUM     |          | misc / container / readable / wearable |
| Weight      | `weight`             | UI_INT      |          | base weight |
| Bulk        | `bulk`               | UI_INT      |          | volume it occupies |
| Value       | `value`              | UI_INT      |          | |
| Fixed       | `flags.fixed`        | UI_BOOL     |          | cannot be taken |
| Capacity    | `container.capacity` | UI_INT      |          | max total bulk; shown when `type = container` |
| Wear slot   | `wear.slot`          | UI_STRING   |          | shown when `type = wearable` |

Type-dependent fields (Capacity, Wear slot) are shown only when `type`
selects them, so the wizard stays short for a plain object. `%parent` is
picked from the item template hierarchy (`doc/template-hierarchy.md`), the
same way `@redit` seeds a room from its zone template.

Implemented in `src/cmd/oedit.c` on the shared OLC helpers (`src/cmd/olc.c`).
The field set is built from `type` when the editor opens and rebuilt live when
the type changes, through the UI layer's `on_change` hook and
`ui_fields_rebuilt` (in-place, cursor preserved), so Capacity / Wear slot
appear the moment the type selects them, including mid-wizard. A bare id
resolves to the builder's current
zone like `@redit`; `%kind=item` is stamped internally on create since items
are typed by `type`, not `%kind`. `Fixed` is a `UI_BOOL`: the step wizard
prompts it yes/no, and in browse mode selecting it toggles.

## 7. @medit (NPC editor)

NPCs and creatures are entities (`doc/entity-system.md`): OBJ records that
inherit their bulk data from a `templates/mob` class through `%parent`, so a
mob instance is cheap (mostly `%parent` plus a few overrides). `@medit` is
therefore two things at one editor: authoring a **mob class** (a
`templates/mob/...` template) and, less often, tweaking a **placed instance**.
The field set is the same either way; only the `commit_key` differs
(`templates/mob/<id>` for a class, `zone/<slug>/<id>` for a placed instance).
Most fields on an instance are left unset and resolve from its class.

The mechanics (scratch binding, wizard, Submit) match `@redit`. `%`-prefixed
keys are protected, so `%kind` and `%parent` are written through the internal
accessor (`obj_prop_set_internal`) on the scratch.

**Choosing class vs instance.** The **key's base path picks the target**
(3.1, 3.2), one verb over any commit key: `@medit templates/mob/<id>` (a
`templates/` key) authors a mob class; `@medit zone/<slug>/<id>` (a `zone/`
key) edits a placed instance. There is no separate verb and no mode flag; the
path the builder types is the choice, mirroring `@redit`'s `commit_key`
handling (5.5). `@medit new templates/mob/<id>` creates a class; instance
creation is done by spawn placement, which is deferred to its own design note
(7.4).

Implemented in `src/cmd/medit.c` on the shared OLC helpers in `src/cmd/olc.c`
(`olc_copy_props`, `olc_make_scratch`, `olc_submit`, also used by `@redit`). A
bare id with no base path authors a mob class under `templates/mob/`. `%kind`
and `%parent` are editable fields written through the internal accessor. Skill
ranks are `skill.<action>` (16 UI_INT fields, 0-4); scene tags are stored as
`tag.<name>.value` and `tag.<name>.mode` (a -3..3 value and a
position/difficulty mode), edited through an add/edit/remove sub-frame like the
exit sub-editor. Derived attribute scores (7.2) are not yet shown.

### 7.1 Core fields

| Label       | key           | type      | flags    | notes |
|-------------|---------------|-----------|----------|-------|
| Name        | `name`        | UI_STRING | required | "a goblin sentry" |
| Keywords    | `keywords`    | UI_STRING | required | targeting words |
| Short desc  | `desc.short`  | UI_STRING | required | room line ("A goblin snarls here.") |
| Long desc   | `desc.long`   | UI_TEXT   |          | examine text |
| Kind        | `%kind`       | UI_ENUM   | required | pc / npc / creature |
| Template    | `%parent`     | UI_OBJREF |          | class in `templates/mob/...` |
| Difficulty  | `difficulty`  | UI_INT    |          | 1-5, the mob's defense (RPG doc 4.2) |
| Faction     | `faction`     | UI_STRING |          | side for morale/reaction |
| Skills      | (subframe)    | UI_SUBFRAME |        | action ranks (7.2) |
| Tags        | (subframe)    | UI_SUBFRAME |        | scene tags (7.3) |
| Loot        | `loot`        | UI_OBJREF |          | loot table/seed ref |

`pc` / `npc` / `creature` differ behaviorally, not structurally
(`doc/entity-system.md`); `creature` is the default for a hostile mob.

### 7.2 Skills sub-frame

The sixteen W&L actions (RPG doc section 2), each a rank 0-4, grouped by
attribute so the list reads sensibly:

```
Body:     Fight  Move    Endure  Brawn
Finesse:  Shoot  Prowl   Nimble  Tinker
Mind:     Hunt   Study   Survey  Attune
Presence: Command Consort Judge  Sway
```

Each is `skill.<action>` (e.g. `skill.fight`). On a class these set the base
ranks; on an instance they override the class. Unset ranks resolve up the
`%parent` chain, so a builder usually sets a template's skills once and leaves
instances alone. Attribute scores are derived (sum of the four action ranks,
RPG doc 2.2) and shown read-only, not edited.

### 7.3 Tags sub-frame

Scene tags (RPG doc section 5) are first-class mob data: `armored`,
`fanatical`, `wounded`, and so on. Each tag is a name, a ladder value
(-3..+3), and a mode (position or difficulty). The tags sub-frame lists the
mob's tags and adds/edits/removes them, the same shape as the exit sub-editor.

### 7.4 Deferred

Harm capacity and stress track default to the standard (2/2/1 harm, 9 stress,
RPG doc section 6) and are not edited here in the first cut; ancestry, harm
box adjustments, playbooks, special abilities, dialog/shop/quest hooks, and
spawn placement all layer on later with their own design notes. `@medit` v1
covers appearance, kind, class, difficulty, skills, tags, faction, and loot,
enough to author a mundane creature.

## 8. Testing plan

- **Field-model unit tests.** Build the `@redit` frame over a scratch room;
  assert each field's get/set, required-field blocking on `name` /
  `desc.short`, and the exit subframe add/edit/remove against the scratch.
- **Validation tests.** Exit destination existence check; creator is
  read-only; id fixed.
- **End to end.** Drive a full `@redit new` session (title, short desc, one
  exit) to Submit and assert the saved room OBJ has the expected properties
  and `exit.<dir>.to`. Drive an edit session that changes one field and
  Cancels, asserting the live room is unchanged (scratch isolation).
- Wired into `module.mk` so it runs in CI (`ci-test-coverage` card).

## 9. Resolved

- **Reverse exit links are offered automatically** on every exit add,
  defaulting to yes, with a fixed opposite-direction map (section 5.3).
- **Edit context is connection-scoped** and survives leaving the editor;
  ephemeral edits stick for the life of the connection. One context at a
  time for now (section 4).
- **Warn-and-allow, never trap the builder** (5.4). Soft warnings (dangling
  exits) do not block Submit; re-check by re-editing or with `@check <id>` /
  `@check zone`.
- **`owner` is editable** (implicit transfer), but an illegal owner is a
  hard block on Submit, not a warning (5.4).
- **Cross-zone exits are allowed and flagged** with an info prompt and a
  `[zone: <name>]` annotation (5.6), not blocked.
- **`@medit` picks role by the key's base path** (3.1, 7): a `templates/...`
  key authors a class, a `zone/...` key edits a placed instance, one verb over
  any commit target. Spawn placement (how an instance first gets into a room)
  is deferred to its own design note (7.4).
- **`@medit` v1 stat scope: tags in, harm/stress out** (7.3, 7.4). The Tags
  sub-frame ships in v1; harm-capacity and stress-track default to the
  standard and wait for the combat doc.
- **Target zone on create is the typed id, shown on a target screen** (5.1,
  5.7.1): bare name -> current zone, full path -> explicit zone. The screen's
  numbered rows let a builder retarget the zone or id without moving; no
  teleport, and no persistent "selected zone" state.
- **Letters are universal actions only; per-screen actions are numbered
  entries** (5.7). The exit list's Add and the target screen's zone/id changes
  are numbered rows, not letter commands.

## 10. Open questions

None outstanding. All prior open questions are resolved (section 9); the spec
is ready for review sign-off, after which implementation may begin
(`doc/plan.md` section 5).
