# Template Hierarchy

How class templates for every game object kind are organized. Templates hold
the shared, static defaults that instances inherit through the OBJ `%parent`
prototype chain (`obj_cache_prop_resolve`). This is the home for the class
hierarchy of rooms, items, containers, mobs, players, and future kinds.

Status: draft for review.

## 1. Purpose

Give every object kind a place to define shared defaults once and specialize
them by inheritance, instead of repeating fields on every instance. A `@dig`
or `@create` seeds a new object from a template; the instance overrides only
what differs. Zones point their default `@dig` template into this tree
(`doc/zone-spec.md`).

## 2. Layout

Templates live in the `templates` domain. A template's key is a path, and its
descendants live under a sibling `-d/` directory:

- A template at `templates/<kind>/<name>` is a class.
- Its direct descendants live at `templates/<kind>/<name>-d/<child>`, and each
  child sets `%parent` to the parent template.
- The scheme recurses: a child's own descendants live under
  `<child>-d/`.

Example, indoor rooms:

```
templates/room/indoor                     generic indoor room
templates/room/indoor-d/house-interior    %parent = templates/room/indoor
templates/room/indoor-d/dungeon           %parent = templates/room/indoor
templates/room/indoor-d/shop              %parent = templates/room/indoor
templates/room/indoor-d/dungeon-d/crypt   %parent = .../indoor-d/dungeon
```

The `-d/` directory is the discoverable organization: descendants of a class
are found by its key prefix. `%parent` is the actual inheritance link. The two
must agree: a template placed in `X-d/` sets `%parent = X`. Tooling can check
this invariant.

## 3. Kinds

Top-level kinds under `templates/`:

- `room` -- rooms (`@redit`, `@dig`).
- `item` -- takeable/usable objects (`@oedit`).
- `container` -- items that hold items; a subtype of `item`, so a container
  class typically sets `%parent` to an `item` template.
- `mob` -- NPCs and creatures (`@medit`), on the entity layer
  (`doc/entity-system.md`).
- `player` -- player-character defaults, also entities.

`mob` and `player` are entities and share the entity/RPG structure
(`doc/rpg-system.md`); `container` is-an `item`. The hierarchy expresses these
is-a relationships through `%parent`, so the kind list is a convention, not a
hard partition.

## 4. Resolution depth and cycles

`obj_cache_prop_resolve` walks `%parent`. **Set the depth limit to 10** (up
from 5), which comfortably fits a class chain plus the instance. The limit is
mostly a backstop once **cycle detection** is in place: a `%parent` chain that
loops (A -> B -> A) must be detected and refused rather than relied on the
depth cap to terminate. With cycle detection, depth is a scale concern, not a
correctness one.

This is a stopgap. Note for later: a more robust and scalable resolver
(memoized resolution, an explicit visited-set walk, or a flattened class cache)
will be wanted as the class trees and instance counts grow.

## 5. Seeding an instance

`@dig` / `@create` / the OLC set a new object's `%parent` to the chosen
template (`doc/scratch-obj-spec.md` `scratch_from_template`). The instance
resolves every unset property up its `%parent` chain and overrides only the
fields the builder edits. Changing a template propagates to all instances that
did not override the changed field.

This class-template inheritance is distinct from the OLC's **starter
templates** (`doc/olc-spec.md` 3.2), which are *copied* into a scratch with no
`%parent` link as blank-slate scaffolding. Class templates are shared
ancestry; starters are one-time seed data.

## 6. Testing plan

- **Inheritance.** An instance under a two-level class chain resolves a
  default from the top class and an override from the middle class.
- **Invariant.** A template in `X-d/` whose `%parent` is not `X` is flagged by
  the consistency check.
- **Depth.** A chain at the resolution limit resolves; one past it is
  reported, not silently truncated.

## 7. Resolved

- **Resolution depth is 10, with cycle detection** (section 4); a more robust,
  scalable resolver is a later concern.

## 8. Open questions

- Whether the `-d/` organization is enforced by tooling or is a convention
  builders are trusted to follow.
- Seeding an instance's `%parent` to a class in a `-d/` directory vs. to a
  bare class name: confirm the key form the OLC stores.
