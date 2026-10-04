# Item Schema

A conservative schema for items: enough for a builder to control the
appearance and basic behavior of mundane objects (a lamp, a key, a sack, a
sign). It is intentionally small. Combat stats, magic, and game-specific
attributes are out of scope and layer on later via the RPG system and the
template hierarchy.

An item instance is an OBJ in the `objs` domain under the zone instance
namespace, keyed `zone/<slug>/<id>` (`doc/zone-spec.md` 3); an item **class**
lives under `templates/item/...` and instances inherit its defaults through
`%parent` (`doc/template-hierarchy.md`). They are edited with `@oedit`
(`doc/olc-spec.md`).

Status: draft for review.

## Fields

| Field           | Required | Description |
|-----------------|----------|-------------|
| `id`            | yes      | Unique item id; the storage key. |
| `name`          | yes      | Short display name ("a brass lamp"). |
| `keywords`      | yes      | Space-separated words for targeting ("brass lamp light"). |
| `desc.short`    | yes      | One line when the item is on the ground or in a list. |
| `desc.long`     | no       | Text shown on examine; also the readable text for `type: readable`. |
| `%parent`       | no       | Class template (`templates/item/...`). |
| `type`          | no       | Behavior class: `misc` (default), `container`, `readable`, `wearable`. Extensible. |
| `weight`        | no       | Integer base weight; 0 if unset. |
| `bulk`          | no       | Integer volume the item occupies; 0 if unset. |
| `value`         | no       | Integer value in the base currency; 0 if unset. |
| `flags.fixed`   | no       | If true, cannot be picked up (a sign, a fountain). Default takeable. |
| `container.capacity` | no  | For `type: container`: max total **bulk** it holds. |
| `wear.slot`     | no       | For `type: wearable`: the slot it occupies ("head", "hand"). |

`creator` and `owner` follow the shared rules (`doc/plan.md` section 4):
`creator` is stamped once; `owner` is an editable transfer.

## Behavior notes

- **type = misc**: an inert object. Appearance only.
- **type = container**: holds other items. `container.capacity` is a **bulk**
  (volume) budget: the sum of contained items' `bulk` may not exceed it.
  There is no weight limit; a container's effective weight is its own `weight`
  plus the weight of everything inside. Over-capacity is not enforced yet;
  later an effect fires when a container holds more bulk (or weight) than
  allowed.
- **type = readable**: `desc.long` is shown on `read`, not just `examine`.
- **type = wearable**: can be worn in `wear.slot`. Slot vocabulary is minimal
  for now and grows with the RPG system.

Unknown `type` values and unknown fields round-trip intact (OBJ keeps unknown
properties), so extending the schema later does not break existing items.

## Out of scope (for now)

Damage, armor, charges, spells, food/drink nutrition, light radius and
duration, lock/key pairing, and currency denominations. These arrive with the
RPG system (`doc/rpg-system.md`) and extend `type`/fields without reworking
this base.

## Open questions

- Whether `light`, `key`, and `food` become `type` values or flags when the
  RPG layer lands.
