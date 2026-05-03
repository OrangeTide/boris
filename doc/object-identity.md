# Object Identity: Hierarchical Path Identifiers

## Decision

Boris uses hierarchical filesystem-style paths (e.g.
`/world/dungeon/items/weapons/ice_sword`) as stable object identifiers.
Location and class relationships are tracked separately via JSON properties
on the object, not derived from the path.

## Rationale

### Problems with LambdaMOO's numbered identifiers

LambdaMOO identifies objects by sequential numbers (`#1234`). This approach
has well-known problems in practice:

- **Opaque references.** `#4532` tells a builder nothing. Large MOOs
  developed "yellow pages" objects, search tools, and naming conventions
  just to locate things. Builders constantly needed to ask or look up
  what number corresponded to what object.

- **Object recycling bugs.** When objects were destroyed and numbers
  reused, stale references silently pointed to the wrong object. A verb
  holding `#1234` (a sword) could end up operating on a recycled chair.
  LambdaMOO added `$recycler` infrastructure specifically to mitigate
  this.

- **Sparse sprawl.** Long-running MOOs reached `#100000+` with large
  gaps from deleted objects. The numbers lost any rough organizational
  signal they might have had early on.

- **No discoverability.** You cannot browse the object space. You need
  to already know the number or have a separate index that maps names
  to numbers.

### Why hierarchical paths work for Boris

Hierarchical paths solve these problems:

- **Self-documenting.** `/world/dungeon/items/weapons/ice_sword` is
  meaningful to builders without consulting any external index.

- **Browsable.** Builders can explore the object tree by navigating
  directories, the same way they navigate a filesystem.

- **Stable identity.** The path is an identity, not a location. An
  object's path does not change when it moves in the game world,
  changes owner, or is placed in a container. Game-world relationships
  (location, class, inventory) are tracked in JSON properties on the
  object.

- **No recycling hazard.** Paths are unique strings, not reused
  indices. Deleting `/world/old_thing` does not cause a different
  object to silently assume that identity.

### Path vs. location separation

The critical design choice is that the path represents *organizational
identity*, not *game-world location*. An ice sword's path stays
`/world/dungeon/items/weapons/ice_sword` whether it is on the ground
in the tavern, in a player's inventory, or inside a chest. Its
physical location is a property value, not its name.

This avoids the brittleness of systems where the naming hierarchy
mirrors the game world -- objects in those systems change identity
whenever they move, breaking all references to them.

### Tradeoffs

- **Builder renames require care.** Renaming
  `/world/dungeon/items/weapons/ice_sword` to `.../frost_blade` is an
  administrative action that may require updating references. This is
  an infrequent, explicit operation, not a routine game event.

- **Longer than a number.** Paths take more space than an integer in
  storage and in builder commands. This is an acceptable cost for the
  usability gains.
