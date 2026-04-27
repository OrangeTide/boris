# Room Schema

This document describes the room JSON schema used by boris. Rooms are
stored in `sample/rooms/` as individual JSON files. The filename
(minus `.json`) must match the `id` field inside the file.

Rooms are imported into muddb via `muddb-tool import` under the
`rooms` domain.

## Top-level Fields

| Field           | Required | Description |
|-----------------|----------|-------------|
| `id`            | yes      | Unique room identifier. Must match the filename. |
| `name`          | yes      | Room title shown on the first line when a player looks. |
| `name.glance`   | no       | Extra at-a-glance text shown below the title. |
| `builder.info`  | no       | Builder-facing note (not shown to players). |
| `desc.short`    | yes      | One-sentence fallback description. |
| `desc.long`     | no       | Full room description, may contain multiple paragraphs separated by `\n\n`. Supports variable expansion (`${room.name}`, `${char.name}`, etc.). Falls back to `desc.short` when absent. |
| `creator`       | no       | Username of the room's creator. |
| `owner`         | no       | Username of the room's current owner. |
| `exit`          | no       | Object containing exit definitions (see below). |

## Exit Definitions

Exits live under the `exit` key as a nested object. Each key is a
direction and maps to an object with `to` and `desc`:

```json
"exit": {
    "n": {
        "to": "thieves-entrance",
        "desc": "Roads lead north to narrow buildings with dark alleys."
    },
    "e": {
        "to": "east-gates",
        "desc": "To the east are the city gates."
    }
}
```

### Supported Directions

Cardinal: `n`, `s`, `e`, `w`

Diagonal: `ne`, `nw`, `se`, `sw`

Vertical: `u` (up), `d` (down)

Special: `enter`

Full names (`north`, `south`, etc.) are accepted as player input and
resolved to the short form internally.

### Exit Object Fields

| Field  | Required | Description |
|--------|----------|-------------|
| `to`   | yes      | Room id of the destination. |
| `desc` | no       | Description shown in the exit list. |

## Display Order

When a player enters or looks at a room, the output follows this
layout (see `src/cmd/show_room.c:room_show()`):

 1. Room Title (`name`)
 2. Time of Day. Ambient Weather Condition.
 3. Extra at-a-glance information (`name.glance`), if available.
 4. Blank line.
 5. Body of main room description (`desc.long` or `desc.short`),
    including posed objects.
 6. Blank line.
 7. List of entities in the room. (not yet implemented)
 8. Blank line.
 9. Exit descriptions or dynamic exit list.
10. Blank line.
11. Available exits summary. (not yet implemented)

## Object Poses (Planned)

Objects placed in a room can have pose descriptions appended to the
main room body. `desc.pose` overrides `desc.short` for an object and
is a temporary value set by players when placing items.

Example on an object:

```json
"desc.short": "A half-eaten sandwich has been left here.",
"desc.pose": "A half-eaten sandwich is laying open-faced on the table."
```

Taking a posed object removes the pose.

## Variable Expansion

Room descriptions support `${room.<attr>}` and `${char.<attr>}`
references, resolved at display time against the current room and the
viewing character.

## Internal Representation

The room struct (`src/room/room.c`) has dedicated fields for `id`,
`name.short`, `name.long`, `desc.short`, `desc.long`, `creator`, and
`owner`. All other attributes (including exits) go into an
`extra_values` attribute list accessed via `room_attr_get()` /
`room_attr_set()`.

The JSON samples use nested objects for exits. The obj iterator
currently skips non-primitive values, so the loader needs to flatten
nested keys into dotted form (e.g. `exit.n` -> destination room id)
for the attribute list, or the exit access pattern needs to change to
match the nested structure. This is part of the in-progress schema
redesign.

## Example

```json
{
    "id": "tower-entrance",
    "name": "The Tower Entrance",
    "builder.info": "In Front of the Entrance to the Tower",
    "desc.short": "A bustling square at the foot of a massive stone tower.",
    "desc.long": "You are standing in a cobblestone square. To the west, a stone tower rises well into the clouds, its two massive iron-bound doors covered in chains and sealed shut.\n\nVendor stalls and adventurers on blankets crowd the square around you, and the general mood is positive and excited.",
    "exit": {
        "n": {
            "to": "thieves-entrance",
            "desc": "Roads lead north to narrow buildings with dark alleys."
        },
        "e": {
            "to": "east-gates",
            "desc": "To the east are the city gates, through which you can see an ocean view."
        },
        "s": {
            "to": "church",
            "desc": "A small stone church with gothic architecture lies to the south."
        }
    }
}
```
