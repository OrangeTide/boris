/* zone.h : the light zone grouping model, core (doc/zone-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef ZONE_H_
#define ZONE_H_

#include <stddef.h>

#include "obj.h"

/*
 * A zone groups instances under a path. Its metadata is a "zoneinfo" OBJ
 * (%kind=zone) at "<zone_path>/zoneinfo"; the zone path is a prefix under
 * the instance base, e.g. "zone/darkwood" or a nested "zone/darkwood/mansion".
 * The base and the reserved leaf name are config-driven in the spec, but
 * dotted config keys do not exist yet, so they are constants here.
 *
 * This is the core, read/query side of the model, used by the game at large
 * (movement, room display, ambient inheritance). Zone creation lives on top
 * in zone_builder.h so the game does not depend on the builder layer.
 */
#define ZONE_BASE      "zone"
#define ZONE_INFO_LEAF "zoneinfo"

/*
 * Write the zoneinfo key for a zone path ("zone/darkwood" ->
 * "zone/darkwood/zoneinfo") into buf. Returns 0, or -1 if zone_path is not
 * under ZONE_BASE or the key would overflow.
 */
int zone_info_key(const char *zone_path, char *buf, size_t len);

/*
 * Owning zone of an object key: the nearest ancestor path (at least
 * "zone/<slug>") that has a zoneinfo. Plain builder sub-directories with no
 * zoneinfo are transparent; a deeper zoneinfo re-roots its subtree. Writes
 * the zone path to buf. Returns 0, or -1 if object_key is not under
 * ZONE_BASE or no enclosing zone exists.
 */
int zone_resolve(const char *object_key, char *buf, size_t len);

/* Nonzero if a zone exists at zone_path (its zoneinfo is present). */
int zone_exists(const char *zone_path);

/* Pinned zoneinfo OBJ for zone_path (caller obj_release), or NULL. */
OBJ *zone_get(const char *zone_path);

/*
 * Resolve a property on a zone, walking the zone %parent chain (ambient
 * inheritance: time, weather, default template). strdup'd, caller frees;
 * NULL if unset.
 */
char *zone_resolve_prop(const char *zone_path, const char *propname);

/* The zone's default @dig room template, resolved up the chain. strdup'd or
 * NULL. */
char *zone_template(const char *zone_path);

/*
 * Edit access: nonzero if username may build in zone_path. Open by default
 * (no builders list on the zone's own zoneinfo). The list is local, not
 * inherited from parent zones. Wizard bypass is the caller's concern.
 */
int zone_may_edit(const char *zone_path, const char *username);

#endif
