/* history_cmd.c : builder world-history commands (snapshot-restore-spec 10) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "character.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder_history.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* --- gates and shared helpers ---------------------------------------- */

static int
is_wizard(const struct acs_info *a)
{
	return a && acs_check((struct acs_info *)a, "fW");
}

static int
is_builder(const struct acs_info *a)
{
	return a && acs_check((struct acs_info *)a, "fB|fW");
}

/* May the actor change the given zone? Wizards anywhere; builders only in a
 * zone they created or are listed on (spec section 9). */
static int
may_build(const struct acs_info *a, const char *name, const char *zone_path)
{
	if (is_wizard(a))
		return 1;
	return zone_may_edit(zone_path, name);
}

/* The zone path the player is standing in, or -1 if not in a zone. */
static int
current_zone(DESCRIPTOR_DATA *cl, char *buf, size_t len)
{
	struct character *ch = telnetclient_character(cl);
	const char *cur;

	if (!ch || !(cur = character_attr_get(ch, "room.current")))
		return -1;
	return zone_resolve(cur, buf, len);
}

/* Turn a slug or an explicit "zone/..." path into a zone path in buf. */
static void
zone_arg_to_path(const char *slug, char *buf, size_t len)
{
	if (strchr(slug, '/'))
		snprintf(buf, len, "%s", slug);
	else
		snprintf(buf, len, "%s/%s", ZONE_BASE, slug);
}

/* A trailing "force" word is the wizard override past an integrity failure
 * (spec section 9). Returns 1 and consumes it only for a wizard; a builder's
 * "force" is ignored (the operation runs unforced and is refused if unsafe). */
static int
take_force(const char **arg, const struct acs_info *a)
{
	char word[16] = "";
	const char *rest = util_getword(*arg, word, sizeof word);

	if (!strcasecmp(word, "force")) {
		*arg = rest;
		return is_wizard(a);
	}
	return 0;
}

/* --- @history -------------------------------------------------------- */

int
command_do_history(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char slug[96] = "", zone_path[OBJ_PATH_MAX];
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);
	struct builder_history_entry ents[20];
	int n = 0, i;

	if (!is_builder(acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	util_getword(arg, slug, sizeof slug);
	if (slug[0]) {
		zone_arg_to_path(slug, zone_path, sizeof zone_path);
	} else if (current_zone(cl, zone_path, sizeof zone_path) != 0) {
		telnetclient_puts(cl, "You are not standing in a zone; "
			"give: @history <zone>\n");
		return 0;
	}
	if (!may_build(acs, name, zone_path)) {
		telnetclient_printf(cl, "You may not view the history of %s.\n",
			zone_path);
		return 0;
	}

	if (builder_history_list(zone_path, ents, 20, &n) != BUILDER_HISTORY_OK) {
		telnetclient_printf(cl, "No history available for %s.\n",
			zone_path);
		return 0;
	}
	if (n == 0) {
		telnetclient_printf(cl, "No snapshots touch %s yet.\n", zone_path);
		return 0;
	}

	telnetclient_printf(cl, "History for %s (newest first):\n", zone_path);
	for (i = 0; i < n; i++) {
		time_t t = (time_t)ents[i].time_s;
		struct tm *tmv = localtime(&t);
		char when[32];

		if (tmv)
			strftime(when, sizeof when, "%Y-%m-%d %H:%M", tmv);
		else
			snprintf(when, sizeof when, "?");
		telnetclient_printf(cl, "%3d. %s  %s\n", i + 1, when,
			ents[i].comment);
	}
	return 1;
}

/* --- @undo / @redo --------------------------------------------------- */

static int
undo_redo(DESCRIPTOR_DATA *cl, const char *arg, int redo)
{
	char zone_path[OBJ_PATH_MAX], msg[256];
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);
	int force, rc;

	if (!is_builder(acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	if (current_zone(cl, zone_path, sizeof zone_path) != 0) {
		telnetclient_printf(cl, "You are not standing in a zone to %s.\n",
			redo ? "redo" : "undo");
		return 0;
	}
	if (!may_build(acs, name, zone_path)) {
		telnetclient_printf(cl, "You may not edit %s.\n", zone_path);
		return 0;
	}
	force = take_force(&arg, acs);

	rc = redo ? builder_history_redo(name, zone_path, force, msg, sizeof msg)
		: builder_history_undo(name, zone_path, force, msg, sizeof msg);
	telnetclient_printf(cl, "%s\n", msg);
	return rc == BUILDER_HISTORY_OK;
}

int
command_do_undo(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	return undo_redo(cl, arg, 0);
}

int
command_do_redo(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	return undo_redo(cl, arg, 1);
}

/* --- @restore <entry> [<path>] [force] ------------------------------- */

int
command_do_restore(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char entstr[16] = "", path[OBJ_PATH_MAX] = "";
	char zone_path[OBJ_PATH_MAX], msg[256];
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);
	const char *dst = NULL;
	int entry, force, rc;

	if (!is_builder(acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, entstr, sizeof entstr);
	entry = atoi(entstr);
	if (entry < 1) {
		telnetclient_puts(cl, "usage: @restore <entry#> [<path>] "
			"(see @history)\n");
		return 0;
	}
	if (current_zone(cl, zone_path, sizeof zone_path) != 0) {
		telnetclient_puts(cl, "You are not standing in a zone; "
			"restore from where you are standing.\n");
		return 0;
	}
	if (!may_build(acs, name, zone_path)) {
		telnetclient_printf(cl, "You may not restore %s.\n", zone_path);
		return 0;
	}

	/* an optional explicit destination (a word that is not "force") */
	{
		char word[OBJ_PATH_MAX] = "";
		const char *rest = util_getword(arg, word, sizeof word);

		if (word[0] && strcasecmp(word, "force")) {
			snprintf(path, sizeof path, "%s", word);
			dst = path;
			arg = rest;
		}
	}
	force = take_force(&arg, acs);

	/* writing somewhere other than the source zone needs edit rights there */
	if (dst && !zone_edit_allowed(acs, name, dst)) {
		telnetclient_printf(cl, "You may not write to %s.\n", dst);
		return 0;
	}

	rc = builder_history_restore(zone_path, entry, dst, force, msg,
		sizeof msg);
	telnetclient_printf(cl, "%s\n", msg);
	return rc == BUILDER_HISTORY_OK;
}

/* --- @checkout <zone> [as <name>] [force] ---------------------------- */

int
command_do_checkout(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char slug[96] = "", name_word[64] = "", scratch_name[64] = "";
	char src_zone[OBJ_PATH_MAX], scratch[OBJ_PATH_MAX], msg[256];
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);
	int force, rc;

	if (!is_builder(acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, slug, sizeof slug);
	if (!slug[0]) {
		telnetclient_puts(cl, "usage: @checkout <zone> [as <name>]\n");
		return 0;
	}
	zone_arg_to_path(slug, src_zone, sizeof src_zone);
	if (!may_build(acs, name, src_zone)) {
		telnetclient_printf(cl, "You may not check out %s.\n", src_zone);
		return 0;
	}

	/* optional "as <name>", then an optional trailing "force". A bare word
	 * that is neither "as" nor "force" is taken as the scratch name. */
	arg = util_getword(arg, name_word, sizeof name_word);
	if (name_word[0] && !strcasecmp(name_word, "as")) {
		arg = util_getword(arg, scratch_name, sizeof scratch_name);
		force = take_force(&arg, acs);
	} else if (name_word[0] && !strcasecmp(name_word, "force")) {
		force = is_wizard(acs);
	} else if (name_word[0]) {
		snprintf(scratch_name, sizeof scratch_name, "%s", name_word);
		force = take_force(&arg, acs);
	} else {
		force = 0;
	}

	rc = builder_history_checkout(name, src_zone,
		scratch_name[0] ? scratch_name : NULL, force, scratch,
		sizeof scratch, msg, sizeof msg);
	telnetclient_printf(cl, "%s\n", msg);
	return rc == BUILDER_HISTORY_OK;
}

/* --- @publish <name> [to <zone>] [force] ----------------------------- */

int
command_do_publish(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char scratch_name[64] = "", kw[16] = "", zslug[96] = "";
	char dst_zone[OBJ_PATH_MAX] = "", resolved[OBJ_PATH_MAX], msg[256];
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);
	const char *dst = NULL;
	int force, rc;

	if (!is_builder(acs)) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, scratch_name, sizeof scratch_name);
	if (!scratch_name[0]) {
		telnetclient_puts(cl, "usage: @publish <name> [to <zone>]\n");
		return 0;
	}

	/* optional "to <zone>" */
	arg = util_getword(arg, kw, sizeof kw);
	if (kw[0] && !strcasecmp(kw, "to")) {
		arg = util_getword(arg, zslug, sizeof zslug);
		if (zslug[0]) {
			zone_arg_to_path(zslug, dst_zone, sizeof dst_zone);
			dst = dst_zone;
		}
	} else if (kw[0] && strcasecmp(kw, "force")) {
		telnetclient_puts(cl, "usage: @publish <name> [to <zone>]\n");
		return 0;
	}
	if (!strcasecmp(kw, "force"))
		force = is_wizard(acs);
	else
		force = take_force(&arg, acs);

	/* resolve the target for the permission check: either the explicit "to"
	 * zone, or the zone recorded at checkout. */
	if (!dst) {
		if (builder_history_scratch_zone(name, scratch_name, resolved,
			sizeof resolved) != BUILDER_HISTORY_OK) {
			telnetclient_printf(cl, "No checkout named \"%s\" on "
				"record; @checkout first.\n", scratch_name);
			return 0;
		}
		dst = resolved;
	}
	if (!may_build(acs, name, dst)) {
		telnetclient_printf(cl, "You may not publish over %s.\n", dst);
		return 0;
	}

	rc = builder_history_publish(name, scratch_name, dst, force, msg,
		sizeof msg);
	telnetclient_printf(cl, "%s\n", msg);
	return rc == BUILDER_HISTORY_OK;
}

/* --- @checkpoint <label> (wizard) ------------------------------------ */

int
command_do_checkpoint(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char label[64] = "", msg[256];
	const struct acs_info *acs = user_acs(telnetclient_user(cl));
	int rc;

	if (!is_wizard(acs)) {
		telnetclient_puts(cl, "Only wizards may pin checkpoints.\n");
		return 0;
	}
	util_getword(arg, label, sizeof label);
	if (!label[0]) {
		telnetclient_puts(cl, "usage: @checkpoint <label>\n");
		return 0;
	}
	rc = builder_history_checkpoint(label, msg, sizeof msg);
	telnetclient_printf(cl, "%s\n", msg);
	return rc == BUILDER_HISTORY_OK;
}
