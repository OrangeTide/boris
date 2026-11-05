/* dig.c : @dig builder command -- create a room and link it to the current one */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "room.h"
#include "character.h"
#include "cmdutil.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Add exit.<dir>.to = target on room and save it through builder_save. */
static enum builder_status
link_exit(const struct acs_info *acs, const char *actor, const char *room_key,
	OBJ *room, const char *dir, const char *target, struct builder_result *res)
{
	char prop[64];
	struct builder_req req;

	snprintf(prop, sizeof prop, "exit.%s.to", dir);
	obj_prop_set_ref(room, prop, target);
	req = (struct builder_req){
		.actor = acs,
		.actor_name = actor,
		.commit_key = room_key,
		.obj = room,
		.is_create = 0,
	};
	return builder_save(builder_zone_ops(), &req, res);
}

int
command_do_dig(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	char dirword[32] = "", id[64] = "";
	const char *dirkey, *opp, *title, *cur;
	struct character *ch = telnetclient_character(cl);
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *uname = user_username(user);
	char zone_path[OBJ_PATH_MAX], newkey[OBJ_PATH_MAX];
	char *template;
	static const char *const room_required[] = { "name", "desc.short", NULL };
	struct builder_req req;
	struct builder_result res;
	enum builder_status st;
	OBJ *room, *cr;

	arg = util_getword(arg, dirword, sizeof dirword);
	arg = util_getword(arg, id, sizeof id);
	if (!dirword[0] || !id[0]) {
		telnetclient_puts(cl, "usage: @dig <direction> <id> [title]\n");
		return 0;
	}
	title = (arg && *arg) ? arg : id;

	if (!acs || !acs_check((struct acs_info *)acs, "fB|fW")) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	if (cmd_dir_resolve(dirword, &dirkey, &opp) != 0) {
		telnetclient_printf(cl, "\"%s\" is not a direction you can dig.\n",
			dirword);
		return 0;
	}
	if (strchr(id, '/')) {
		telnetclient_puts(cl, "A room id must be a single path component.\n");
		return 0;
	}
	if (!ch || !(cur = character_attr_get(ch, "room.current"))) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}
	if (zone_resolve(cur, zone_path, sizeof zone_path) != 0) {
		telnetclient_puts(cl, "You are not standing in a zone.\n");
		return 0;
	}
	if ((size_t)snprintf(newkey, sizeof newkey, "%s/%s", zone_path, id)
		>= sizeof newkey) {
		telnetclient_puts(cl, "That room id is too long.\n");
		return 0;
	}

	/* Build the new room seeded from the zone template, with the reverse
	 * exit already pointing back, then commit it once. */
	room = obj_new(newkey);
	if (!room) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	obj_prop_set_internal(room, "%kind", "room");
	template = zone_template(zone_path);
	if (template)
		obj_prop_set_ref_internal(room, "%parent", template);
	free(template);
	obj_prop_set(room, "name", title);
	obj_prop_set(room, "desc.short", "An unfinished room.");
	if (opp) {
		char prop[64];
		snprintf(prop, sizeof prop, "exit.%s.to", opp);
		obj_prop_set_ref(room, prop, cur);
	}

	req = (struct builder_req){
		.actor = acs,
		.actor_name = uname,
		.commit_key = newkey,
		.obj = room,
		.required = room_required,
		.is_create = 1,
	};
	st = builder_save(builder_zone_ops(), &req, &res);
	obj_free(room);
	if (st != BUILDER_OK) {
		telnetclient_printf(cl, "Could not dig: %s\n", res.message);
		return 0;
	}

	/* Link the forward exit on the current room. */
	cr = room_get(cur);
	if (cr) {
		if (link_exit(acs, uname, cur, cr, dirkey, newkey, &res) != BUILDER_OK)
			telnetclient_printf(cl,
				"Room created, but linking the exit failed: %s\n",
				res.message);
		room_put(cr);
	}

	telnetclient_printf(cl, "You dig %s to %s (\"%s\").\n", dirkey, newkey, title);
	if (opp)
		telnetclient_printf(cl, "A return exit (%s) links back.\n", opp);
	return 1;
}
