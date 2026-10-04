/* zone_builder.h : zone creation on top of the core zone model */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef ZONE_BUILDER_H_
#define ZONE_BUILDER_H_

#include "acs.h"
#include "obj.h"
#include "builder.h"
#include "zone.h"

/*
 * Create a zoneinfo at zone_path through builder_save (creator stamped,
 * Builder-flag checked, duplicate-guarded). parent_path may be NULL (a root
 * zone) or an enclosing zone whose zoneinfo becomes %parent. template_ref
 * (default @dig room template) may be NULL. ops carries the save hooks
 * (builder_default_ops in production). Returns the builder_status.
 *
 * This sits on top of zone.c: the game reads zones through zone.h without
 * depending on the builder layer; only creation pulls builder_save.
 */
enum builder_status zone_create(const struct builder_ops *ops,
	const struct acs_info *actor, const char *actor_name,
	const char *zone_path, const char *title, const char *template_ref,
	const char *parent_path, struct builder_result *res);

/*
 * Production builder_ops that enforce a zone's builders allow-list on top
 * of the default obj-store hooks (builder_default_ops). Edits under the
 * zone namespace resolve to their owning zone and check zone_may_edit;
 * wizards bypass, and keys outside a zone are unrestricted. Command
 * handlers that write instances should use these instead of
 * builder_default_ops.
 */
const struct builder_ops *builder_zone_ops(void);

/*
 * Nonzero if actor may edit the object at key: wizards bypass, keys with no
 * owning zone are unrestricted, otherwise the zone's builders allow-list
 * decides. This is the check builder_zone_ops enforces on writes; commands
 * that delete (which do not go through builder_save) call it directly.
 */
int zone_edit_allowed(const struct acs_info *actor, const char *actor_name,
	const char *key);

#endif
