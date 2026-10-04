/* check.c : @check -- re-run builder soft-warning validation (olc-spec 5.4) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "character.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder.h"
#include "cmdutil.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Run the read-only checks on one object and print the result. Returns the
 * warning count, -1 if the object is missing. */
static int
check_one(DESCRIPTOR_DATA *cl, const char *key, int quiet_if_clean)
{
	OBJ *o = obj_get(key);
	struct builder_result res;
	int i, n;

	if (!o) {
		telnetclient_printf(cl, "No object \"%s\".\n", key);
		return -1;
	}
	n = builder_check(builder_zone_ops(), o, &res);
	obj_release(o);

	if (n <= 0) {
		if (!quiet_if_clean)
			telnetclient_printf(cl, "%s: ok\n", key);
		return 0;
	}
	telnetclient_printf(cl, "%s: %d warning%s\n", key, n,
		n == 1 ? "" : "s");
	for (i = 0; i < res.warn_count; i++)
		telnetclient_printf(cl, "  warning: %s\n", res.warns[i]);
	return n;
}

/* --- zone sweep: collect keys, then check each -------------------------- */

struct keyvec {
	char **keys;
	int n, cap;
};

/* obj_foreach_key callback: copy the (transient) key into the vector. */
static void
collect_key(const char *key, void *ctx)
{
	struct keyvec *kv = ctx;
	char *dup;

	if (kv->n == kv->cap) {
		int cap = kv->cap ? kv->cap * 2 : 64;
		char **nk = realloc(kv->keys, (size_t)cap * sizeof *nk);

		if (!nk)
			return;			/* drop this key on OOM */
		kv->keys = nk;
		kv->cap = cap;
	}
	dup = strdup(key);
	if (dup)
		kv->keys[kv->n++] = dup;
}

static void
check_zone(DESCRIPTOR_DATA *cl, const char *zone_path)
{
	char prefix[OBJ_PATH_MAX + 2];	/* zone_path + '/' + nul */
	struct keyvec kv = { NULL, 0, 0 };
	int i, rc, checked = 0, flagged = 0;

	if (!zone_exists(zone_path)) {
		telnetclient_printf(cl, "No zone \"%s\".\n", zone_path);
		return;
	}
	snprintf(prefix, sizeof prefix, "%s/", zone_path);
	rc = obj_foreach_key(prefix, collect_key, &kv);
	if (rc < 0) {
		telnetclient_puts(cl, "Zone sweep is not available on the "
			"current object store backend.\n");
		return;
	}
	for (i = 0; i < kv.n; i++) {
		if (check_one(cl, kv.keys[i], 1) > 0)
			flagged++;
		checked++;
		free(kv.keys[i]);
	}
	free(kv.keys);
	telnetclient_printf(cl,
		"Checked %d object%s in %s; %d with warnings.\n",
		checked, checked == 1 ? "" : "s", zone_path, flagged);
}

/* --- current-location helpers ------------------------------------------ */

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

int
command_do_check(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char word[64] = "", zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const struct acs_info *acs;
	struct character *ch;
	const char *cur;

	acs = user_acs(telnetclient_user(cl));
	if (!acs || !acs_check((struct acs_info *)acs, "fB|fW")) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, word, sizeof word);

	/* @check zone [<slug>] -- sweep a whole zone */
	if (!strcasecmp(word, "zone")) {
		char slug[96] = "";

		util_getword(arg, slug, sizeof slug);
		if (!slug[0]) {
			if (current_zone(cl, zone_path, sizeof zone_path) != 0) {
				telnetclient_puts(cl, "You are not standing in a "
					"zone; give: @check zone <slug>\n");
				return 0;
			}
		} else if (strchr(slug, '/')) {
			snprintf(zone_path, sizeof zone_path, "%s", slug);
		} else {
			snprintf(zone_path, sizeof zone_path, "%s/%s",
				ZONE_BASE, slug);
		}
		check_zone(cl, zone_path);
		return 0;
	}

	/* @check          -- check the room you are standing in
	 * @check <id>     -- bare id resolves against the current zone
	 * @check <path>   -- a full zone/<slug>/<id> path is used as-is */
	if (!word[0]) {
		ch = telnetclient_character(cl);
		if (!ch || !(cur = character_attr_get(ch, "room.current"))) {
			telnetclient_puts(cl, "usage: @check [<id>] | "
				"@check zone [<slug>]\n");
			return 0;
		}
		snprintf(key, sizeof key, "%s", cur);
	} else if (strchr(word, '/')) {
		snprintf(key, sizeof key, "%s", word);
	} else {
		if (current_zone(cl, zone_path, sizeof zone_path) != 0) {
			telnetclient_puts(cl, "You are not standing in a zone; "
				"give a full zone/<slug>/<id> path.\n");
			return 0;
		}
		if ((size_t)snprintf(key, sizeof key, "%s/%s", zone_path, word)
			>= sizeof key) {
			telnetclient_puts(cl, "That id is too long.\n");
			return 0;
		}
	}
	check_one(cl, key, 0);
	return 0;
}
