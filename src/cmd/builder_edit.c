/* builder_edit.c : @create / @link / @unlink / @set / @destroy edit commands */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "character.h"
#include "cmdutil.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder.h"
#include "olc.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* actor context gathered from the descriptor */
struct actor {
	const struct acs_info *acs;
	const char *name;
	struct character *ch;
};

static int
get_actor(DESCRIPTOR_DATA *cl, struct actor *a)
{
	struct user *u = telnetclient_user(cl);

	a->acs = user_acs(u);
	a->name = user_username(u);
	a->ch = telnetclient_character(cl);
	return a->acs != NULL;
}

static int
is_builder(const struct acs_info *acs)
{
	return acs && acs_check((struct acs_info *)acs, "fB|fW");
}

/* Full key of the room the actor is standing in, or NULL. */
static const char *
current_room(struct actor *a)
{
	return a->ch ? character_attr_get(a->ch, "room.current") : NULL;
}

/*
 * Resolve a builder-typed object reference to a full store key. A ref with a
 * '/' is already a full key; a bare id is placed in the actor's current zone.
 * Returns 0 on success.
 */
static int
resolve_ref(struct actor *a, const char *ref, char *buf, size_t len)
{
	char zone_path[OBJ_PATH_MAX];
	const char *cur;

	if (strchr(ref, '/'))
		return (size_t)snprintf(buf, len, "%s", ref) >= len ? -1 : 0;
	cur = current_room(a);
	if (!cur || zone_resolve(cur, zone_path, sizeof zone_path) != 0)
		return -1;
	return (size_t)snprintf(buf, len, "%s/%s", zone_path, ref) >= len ? -1 : 0;
}

/*
 * A detached, editable copy of the live object at key, or NULL if there is no
 * such object. The builder commit path (default_commit) writes its object
 * through obj_put and then obj_forget()s the key. It must never be handed the
 * live cached object: the forget would free an object the caller still holds,
 * dropping the edit and leaving a dangling pin. Edit this copy and release it
 * with room_edit_free() when done.
 */
static OBJ *
room_edit(const char *key)
{
	OBJ *scratch = obj_new(key);
	OBJ *live;

	if (!scratch)
		return NULL;
	live = obj_get(key);
	if (!live) {
		obj_free(scratch);
		return NULL;
	}
	olc_copy_props(scratch, live);
	obj_release(live);
	return scratch;
}

static void
room_edit_free(OBJ *scratch)
{
	obj_free(scratch);
}

/* Save obj under key through the zone-aware ops; report failure to the client. */
static int
save_obj(DESCRIPTOR_DATA *cl, struct actor *a, const char *key, OBJ *obj,
	const char *what)
{
	struct builder_req req = {
		.actor = a->acs,
		.actor_name = a->name,
		.commit_key = key,
		.obj = obj,
		.is_create = 0,
	};
	struct builder_result res;

	if (builder_save(builder_zone_ops(), &req, &res) == BUILDER_OK)
		return 1;
	telnetclient_printf(cl, "Could not %s: %s\n", what, res.message);
	return 0;
}

/* ------------------------------------------------------------------ @create */

int
command_do_create(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	static const char *const req[] = { "name", NULL };
	struct actor a;
	char kind[16] = "", id[64] = "";
	char zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const char *name, *cur;
	struct builder_req breq;
	struct builder_result res;
	enum builder_status st;
	OBJ *o;
	char *p;

	if (!get_actor(cl, &a) || !is_builder(a.acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, kind, sizeof kind);
	arg = util_getword(arg, id, sizeof id);
	if (!kind[0] || !id[0]) {
		telnetclient_puts(cl,
			"usage: @create <item|npc|creature> <id> [name]\n");
		return 0;
	}
	for (p = kind; *p; p++)
		*p = tolower((unsigned char)*p);
	if (strcmp(kind, "item") && strcmp(kind, "npc") && strcmp(kind, "creature")) {
		telnetclient_printf(cl, "Unknown kind \"%s\" "
			"(use item, npc, or creature; rooms use @dig).\n", kind);
		return 0;
	}
	if (strchr(id, '/')) {
		telnetclient_puts(cl, "An id must be a single path component.\n");
		return 0;
	}
	cur = current_room(&a);
	if (!cur || zone_resolve(cur, zone_path, sizeof zone_path) != 0) {
		telnetclient_puts(cl, "You are not standing in a zone.\n");
		return 0;
	}
	if ((size_t)snprintf(key, sizeof key, "%s/%s", zone_path, id) >= sizeof key) {
		telnetclient_puts(cl, "That id is too long.\n");
		return 0;
	}
	name = (arg && *arg) ? arg : id;

	o = obj_new(key);
	if (!o) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	obj_prop_set_internal(o, "%kind", kind);
	obj_prop_set(o, "name", name);
	obj_prop_set(o, "desc.short", "Nothing special.");

	breq = (struct builder_req){
		.actor = a.acs,
		.actor_name = a.name,
		.commit_key = key,
		.obj = o,
		.required = req,
		.is_create = 1,
	};
	st = builder_save(builder_zone_ops(), &breq, &res);
	obj_free(o);
	if (st != BUILDER_OK) {
		telnetclient_printf(cl, "Could not create: %s\n", res.message);
		return 0;
	}
	telnetclient_printf(cl, "Created %s %s (\"%s\").\n", kind, key, name);
	return 1;
}

/* -------------------------------------------------------------------- @link */

int
command_do_link(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	struct actor a;
	char dirword[32] = "", target[128] = "";
	const char *dirkey, *opp, *desc, *cur;
	char targetkey[OBJ_PATH_MAX], prop[64];
	OBJ *r, *tr;

	if (!get_actor(cl, &a) || !is_builder(a.acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, dirword, sizeof dirword);
	arg = util_getword(arg, target, sizeof target);
	if (!dirword[0] || !target[0]) {
		telnetclient_puts(cl, "usage: @link <direction> <target> [description]\n");
		return 0;
	}
	desc = (arg && *arg) ? arg : NULL;
	if (cmd_dir_resolve(dirword, &dirkey, &opp) != 0) {
		telnetclient_printf(cl, "\"%s\" is not a direction.\n", dirword);
		return 0;
	}
	cur = current_room(&a);
	if (!cur) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}
	if (resolve_ref(&a, target, targetkey, sizeof targetkey) != 0) {
		telnetclient_puts(cl, "That target is not valid.\n");
		return 0;
	}

	r = room_edit(cur);
	if (!r) {
		telnetclient_puts(cl, "You are in an invalid room.\n");
		return 0;
	}
	snprintf(prop, sizeof prop, "exit.%s.to", dirkey);
	obj_prop_set_ref(r, prop, targetkey);
	if (desc) {
		snprintf(prop, sizeof prop, "exit.%s.desc", dirkey);
		obj_prop_set(r, prop, desc);
	}
	if (!save_obj(cl, &a, cur, r, "link")) {
		room_edit_free(r);
		return 0;
	}
	room_edit_free(r);
	telnetclient_printf(cl, "Linked %s -> %s.\n", dirkey, targetkey);

	/* offer the reverse link on the target, if it exists */
	if (opp) {
		tr = room_edit(targetkey);
		if (!tr) {
			telnetclient_puts(cl,
				"(target does not exist yet; no reverse link)\n");
			return 1;
		}
		snprintf(prop, sizeof prop, "exit.%s.to", opp);
		obj_prop_set_ref(tr, prop, cur);
		if (save_obj(cl, &a, targetkey, tr, "link reverse"))
			telnetclient_printf(cl, "Reverse exit (%s) linked from %s.\n",
				opp, targetkey);
		room_edit_free(tr);
	}
	return 1;
}

/* ------------------------------------------------------------------ @unlink */

int
command_do_unlink(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	struct actor a;
	char dirword[32] = "";
	const char *dirkey, *opp, *cur, *target, *back;
	char targetkey[OBJ_PATH_MAX], prop[64];
	OBJ *r, *tr;

	if (!get_actor(cl, &a) || !is_builder(a.acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, dirword, sizeof dirword);
	if (!dirword[0]) {
		telnetclient_puts(cl, "usage: @unlink <direction>\n");
		return 0;
	}
	if (cmd_dir_resolve(dirword, &dirkey, &opp) != 0) {
		telnetclient_printf(cl, "\"%s\" is not a direction.\n", dirword);
		return 0;
	}
	cur = current_room(&a);
	if (!cur) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}
	r = room_edit(cur);
	if (!r) {
		telnetclient_puts(cl, "You are in an invalid room.\n");
		return 0;
	}
	snprintf(prop, sizeof prop, "exit.%s.to", dirkey);
	target = obj_prop_get_ref(r, prop);
	if (!target) {
		telnetclient_printf(cl, "There is no %s exit here.\n", dirkey);
		room_edit_free(r);
		return 0;
	}
	snprintf(targetkey, sizeof targetkey, "%s", target);	/* copy before edits */

	obj_prop_delete_ref(r, prop);
	snprintf(prop, sizeof prop, "exit.%s.desc", dirkey);
	obj_prop_delete(r, prop);
	if (!save_obj(cl, &a, cur, r, "unlink")) {
		room_edit_free(r);
		return 0;
	}
	room_edit_free(r);
	telnetclient_printf(cl, "Removed the %s exit.\n", dirkey);

	/* remove the reverse exit only if it points back to us */
	if (opp) {
		tr = room_edit(targetkey);
		if (!tr)
			return 1;
		snprintf(prop, sizeof prop, "exit.%s.to", opp);
		back = obj_prop_get_ref(tr, prop);
		if (back && strcmp(back, cur) == 0) {
			obj_prop_delete_ref(tr, prop);
			snprintf(prop, sizeof prop, "exit.%s.desc", opp);
			obj_prop_delete(tr, prop);
			if (save_obj(cl, &a, targetkey, tr, "unlink reverse"))
				telnetclient_printf(cl,
					"Removed the reverse (%s) exit on %s.\n",
					opp, targetkey);
		}
		room_edit_free(tr);
	}
	return 1;
}

/* --------------------------------------------------------------------- @set */

int
command_do_set(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	struct actor a;
	char prop[64] = "";
	const char *value, *cur;
	OBJ *r;

	if (!get_actor(cl, &a) || !is_builder(a.acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, prop, sizeof prop);
	if (!prop[0] || !arg || !*arg) {
		telnetclient_puts(cl, "usage: @set <property> <value>\n");
		return 0;
	}
	value = arg;
	cur = current_room(&a);
	if (!cur) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}
	r = room_edit(cur);
	if (!r) {
		telnetclient_puts(cl, "You are in an invalid room.\n");
		return 0;
	}
	if (obj_prop_set(r, prop, value) == OBJ_ERR_PROTECTED) {
		telnetclient_printf(cl,
			"\"%s\" is a protected property and cannot be set here.\n",
			prop);
		room_edit_free(r);
		return 0;
	}
	if (save_obj(cl, &a, cur, r, "set"))
		telnetclient_printf(cl, "Set %s = %s\n", prop, value);
	room_edit_free(r);
	return 1;
}

/* ----------------------------------------------------------------- @destroy */

int
command_do_destroy(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	struct actor a;
	char id[128] = "", confirm[16] = "";
	char key[OBJ_PATH_MAX];
	const char *cur, *kind;
	int is_zone;
	OBJ *o;

	if (!get_actor(cl, &a) || !is_builder(a.acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, id, sizeof id);
	arg = util_getword(arg, confirm, sizeof confirm);
	if (!id[0]) {
		telnetclient_puts(cl, "usage: @destroy <id> [confirm]\n");
		return 0;
	}
	if (resolve_ref(&a, id, key, sizeof key) != 0) {
		telnetclient_puts(cl, "That id is not valid.\n");
		return 0;
	}
	cur = current_room(&a);
	if (cur && strcmp(cur, key) == 0) {
		telnetclient_puts(cl,
			"You can't destroy the room you are standing in.\n");
		return 0;
	}

	o = obj_get(key);
	if (!o) {
		telnetclient_printf(cl, "No such object \"%s\".\n", key);
		return 0;
	}
	kind = obj_prop_get(o, "%kind");
	is_zone = kind && strcmp(kind, "zone") == 0;
	obj_release(o);
	if (is_zone) {
		telnetclient_puts(cl, "Use @zone to manage zones, not @destroy.\n");
		return 0;
	}
	if (!zone_edit_allowed(a.acs, a.name, key)) {
		telnetclient_puts(cl, "You may not build in that zone.\n");
		return 0;
	}
	if (strcasecmp(confirm, "confirm") != 0) {
		telnetclient_printf(cl,
			"This permanently deletes %s. Repeat with: @destroy %s confirm\n",
			key, key);
		return 0;
	}
	if (obj_delete(key) != OBJ_OK) {
		telnetclient_printf(cl, "Could not delete %s "
			"(deletion may be unsupported on this storage backend).\n",
			key);
		return 0;
	}
	telnetclient_printf(cl, "Destroyed %s. "
		"(Exits pointing here may now dangle.)\n", key);
	return 1;
}
