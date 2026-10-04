/* zone_ops.c : builder_ops that enforce a zone's builders allow-list */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "zone"

#include "zone_builder.h"
#include "zone.h"
#include "acs.h"
#include "obj.h"

/*
 * Zone edit-access policy. Kept in its own translation unit so zone_create
 * (zone_builder.c) does not pull in builder_default_ops (and thus
 * user_exists) for callers that only create.
 */
int
zone_edit_allowed(const struct acs_info *actor, const char *actor_name,
	const char *key)
{
	char zone_path[OBJ_PATH_MAX];

	/* Wizards bypass the allow-list (doc/zone-spec.md 2.2). */
	if (actor && acs_check((struct acs_info *)actor, "fW"))
		return 1;
	/* A key with no owning zone (templates, olc starters, root-zone
	 * creation) carries no allow-list. */
	if (zone_resolve(key, zone_path, sizeof zone_path) != 0)
		return 1;
	return zone_may_edit(zone_path, actor_name);
}

/* builder_ops may_edit hook: the same policy for the write choke point. */
static int
zone_may_edit_hook(void *ctx, const struct acs_info *actor,
	const char *actor_name, const char *key)
{
	(void)ctx;
	return zone_edit_allowed(actor, actor_name, key);
}

const struct builder_ops *
builder_zone_ops(void)
{
	static struct builder_ops ops;
	static int ready;

	if (!ready) {
		ops = *builder_default_ops();	/* inherit obj-store hooks */
		ops.may_edit = zone_may_edit_hook;
		ready = 1;
	}
	return &ops;
}
