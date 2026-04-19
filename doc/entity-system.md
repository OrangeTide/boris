# Entity System

This document describes the entity layer that makes the RPG system
meaningfully usable: player characters attached to sessions, and
creatures/NPCs for players to interact with and fight. It also
specifies the prototype-inheritance layer that entities (and
eventually rooms and items) are built on.

See [rpg-system.md](rpg-system.md) for the RPG rules that layer on top.

## Goals

  1. One **combat codepath** serves players, NPCs, pets, creatures,
     hired guards -- any RPG-capable thing. Shared struct, shared APIs.
  2. All entities are **persistent**: every creature in the world has
     a muddb record. No transient creatures.
  3. **Lightweight creatures**: a mob instance should be cheap to
     create and store. Achieved via prototype inheritance from a
     template that holds all the shared/static data.
  4. **Atomic combat updates**: a single muddb transaction must be
     able to update all participants. Requires a single domain for
     instances.

## Layers

```
    +-------------------------------------------+
    | struct entity (RPG-capable)               |
    | PC / NPC / creature wrapper structs       |
    +-------------------------------------------+
    | obj_cache: LRU + prototype walk           |
    |   - %parent chain, max depth 5            |
    |   - tombstones hide inherited values      |
    |   - %-prefix protects structural fields   |
    +-------------------------------------------+
    | muddb: LMDB-backed KV per domain          |
    |   - domain "entities" (PC/NPC/creature)   |
    |   - domain "templates" (class prototypes) |
    +-------------------------------------------+
```

## Prototype layer (obj / obj_cache)

Lives in `src/obj/`. Entirely generic: rooms and items can adopt it
later.

### Special-prefix convention on property keys

  - `%key`   -- structural/reserved. `obj_prop_set` and
                `obj_prop_delete` reject these with `OBJ_ERR_PROTECTED`.
                Only `obj_prop_set_internal` / `obj_prop_delete_internal`
                may write them. Examples: `%parent`, `%kind`.
  - `!key`   -- tombstone. `obj_prop_delete` on an object that has a
                `%parent` inserts `!key` (value `1`) as a marker that
                says "this property is deleted here, even though the
                parent may define it." `obj_prop_set` on a previously
                tombstoned key clears the tombstone atomically.
                `!`-prefixed keys are also rejected by the public
                setters/deleter.

### Prototype walk

`obj_cache_prop_resolve(cache, obj, propname)` walks at most
`OBJ_CACHE_MAX_PROTO_DEPTH` (= 5) levels:

    for level in 0..5:
        if obj has "!propname":         return NULL    # tombstoned
        if obj has "propname":          return value   # local hit
        if obj has no "%parent":        return NULL    # chain ends
        obj = cache.resolve_parent(%parent)            # may cross caches
    return NULL                                        # depth exceeded

Parents can live in a different cache (e.g. instances in the
`entities` cache look up parents in the `templates` cache). The
resolver callback in `struct obj_cache_ops` maps a `%parent` value
to the cache that owns it.

### obj_cache

Generic refcounted cache layered on a vtable of
`load(ctx, id) -> OBJ*` and `save(ctx, id, OBJ*)`. LRU holds
objects whose refcount has dropped to zero; evicted-on-overflow,
with dirty objects saved first. Mutations flag an entry dirty via
`obj_cache_mark_dirty`.

Existing per-domain LRUs in `src/room/room.c` and
`src/character/character.c` can migrate to this as follow-up work;
nothing forces the migration.

## struct entity

Defined in (proposed) `src/entity/entity.h`. Holds the typed RPG
fields that the RPG APIs operate on directly, rather than looking
them up via `obj_prop_get` on every read.

    struct entity {
        char *id;               /* primary key, also the muddb id */
        OBJ *obj;               /* backing object, pinned in obj_cache */
        OBJ_CACHE *cache;       /* the "entities" cache */

        /* RPG state -- pre-loaded so rpg/* doesn't touch obj every call */
        int skill_rank[RPG_ACTION_COUNT];
        int stress;
        struct harm_track harm;
        enum position pos;
        /* ... other typed fields as RPG phases land ... */
    };

### Duck-typed RPG layer

The RPG APIs take `struct entity *`. Any wrapper that embeds
`struct entity` as its first field (or at a known offset) is
RPG-capable -- pass `&wrapper->entity` to the RPG calls. No
`container_of` needed: the RPG code only touches fields inside
the embedded struct.

## Wrappers

All wrappers embed `struct entity`:

  - **struct pc**    -- player character. Links to a user account
                        and (when online) a connection/session.
                        Inventory, form/menu state.
  - **struct npc**   -- scripted non-player character. May have
                        dialog, shop, quest hooks.
  - **struct creature** -- hostile mob. Loot seed, goal/behavior tag,
                        faction weights.

Distinctions between NPC and creature are behavioral, not structural:
both are persistent records with a template parent. A guard could be
either.

## Domains

### `entities` domain (instances)

Every PC / NPC / creature has a row here. Keyed by entity id
(`pc:alice`, `mob:forest-wolf-42`, etc). Fields:

  - `%kind`       -- `"pc"` | `"npc"` | `"creature"`. Structural.
  - `%parent`     -- template reference, e.g. `"templates/wolf"`.
                     Optional for PCs.
  - Overridden instance fields (hp, current stress, position,
                     inventory ids, location room id, etc).

Single-domain so a combat tick holding **one muddb write lock**
can update every participant atomically. Separate locks per
domain would create ordering/deadlock surface.

### `templates` domain (class prototypes)

Builder-editable classes. Holds the static/inheritable data:
name, description, keywords, base skill ranks, harm capacity,
default loot, default faction weights. Also may define seed
values copied into new instances at spawn time.

Templates themselves can have `%parent` -- a `goblin-shaman`
template parents `goblin`, which parents `humanoid`. Depth-5 cap
still applies.

## Persistence (entity_import / entity_export)

Because the prototype layer lives below the entity struct, import
and export stay dead simple:

    int entity_import(struct entity *e, OBJ_CACHE *c, const char *id)
    {
        e->obj = obj_cache_get(c, id);
        if (!e->obj) return -1;
        e->id = strdup(id);
        e->cache = c;

        /* typed fields read via resolve, so parent values flow in */
        for (int a = 0; a < RPG_ACTION_COUNT; a++) {
            char key[32];
            snprintf(key, sizeof(key), "skill.%s", rpg_action_name(a));
            char *v = obj_cache_prop_resolve(c, e->obj, key);
            e->skill_rank[a] = v ? atoi(v) : 0;
            free(v);
        }
        /* ... stress, harm, position, ... */
        return 0;
    }

    int entity_export(struct entity *e)
    {
        /* write back typed fields that have drifted from obj */
        obj_prop_set_int(e->obj, "stress", e->stress);
        /* ... */
        obj_cache_mark_dirty(e->cache, e->obj);
        return 0;
    }

Spawn of a new instance from a template writes the instance with
just `%parent` + any overrides. Everything else resolves through
the chain.

## Combat atomicity

A combat tick resolving an exchange across N participants:

  1. Pin all participants via `obj_cache_get`.
  2. Compute outcomes (dice, position shifts, harm, stress) on
     the in-memory `struct entity` fields.
  3. `entity_export` each participant (marks obj dirty).
  4. Begin muddb write txn, save each dirty obj, commit.
  5. Release pins.

Single domain -> single LMDB transaction -> atomic.

## Reparenting

Out of scope. Changing an instance's `%parent` after creation can
invalidate cached resolutions and is not supported. Template
edits that reshape the chain are an editor-time concern, not a
runtime one.

## Not in this phase

  - Combat implementation (rpg phases 4-7).
  - Editor UI for templates.
  - Versioned template history (TODO.md P2).
  - Migrating room/character caches to obj_cache.
