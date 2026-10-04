/* zone_cmd.c : the @zone builder command (create/inspect/allow-list) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder.h"

#include <stdio.h>
#include <string.h>

/* Wizard-only actions gate on the 'W' flag; zone creation is structural
 * (doc/zone-spec.md 6). Builder ('B') alone is not enough. */
static int
is_wizard(const struct acs_info *acs)
{
	return acs && acs_check((struct acs_info *)acs, "fW");
}

/* Build "zone/<slug>" from a slug argument. Returns 0, or -1 on overflow. */
static int
slug_to_path(const char *slug, char *buf, size_t len)
{
	if ((size_t)snprintf(buf, len, "%s/%s", ZONE_BASE, slug) >= len)
		return -1;
	return 0;
}

/* Rebuild a whitespace-separated builders list, adding or removing name.
 * add != 0 inserts (idempotent); add == 0 removes. Writes to out. */
static void
list_edit(const char *cur, const char *name, int add, char *out, size_t len)
{
	const char *p = cur ? cur : "";
	size_t used = 0;
	size_t namelen = strlen(name);

	out[0] = '\0';
	while (*p) {
		size_t tok;

		while (*p == ' ' || *p == '\t' || *p == ',')
			p++;
		tok = strcspn(p, " \t,");
		if (tok == 0)
			break;
		if (!(tok == namelen && strncmp(p, name, namelen) == 0)) {
			int n = snprintf(out + used, len - used, "%s%.*s",
				used ? " " : "", (int)tok, p);
			if (n > 0 && (size_t)n < len - used)
				used += n;
		}
		p += tok;
	}
	if (add) {
		int n = snprintf(out + used, len - used, "%s%s",
			used ? " " : "", name);
		if (n > 0 && (size_t)n < len - used)
			used += n;
	}
}

static int
zone_new(DESCRIPTOR_DATA *cl, const struct acs_info *acs, const char *name,
	const char *arg)
{
	char slug[64] = "";
	char zone_path[OBJ_PATH_MAX];
	const char *title;
	struct builder_result res;
	enum builder_status st;

	if (!is_wizard(acs)) {
		telnetclient_puts(cl, "Only wizards may create zones.\n");
		return 0;
	}
	arg = util_getword(arg, slug, sizeof slug);
	if (!slug[0]) {
		telnetclient_puts(cl, "usage: @zone new <slug> [title]\n");
		return 0;
	}
	title = (arg && *arg) ? arg : slug;
	if (slug_to_path(slug, zone_path, sizeof zone_path) != 0) {
		telnetclient_puts(cl, "zone slug too long.\n");
		return 0;
	}

	st = zone_create(builder_zone_ops(), acs, name, zone_path, title,
		NULL, NULL, &res);
	if (st == BUILDER_OK)
		telnetclient_printf(cl, "Created zone %s (%s).\n", zone_path, title);
	else
		telnetclient_printf(cl, "Could not create zone: %s\n", res.message);
	return st == BUILDER_OK;
}

static int
zone_info(DESCRIPTOR_DATA *cl, const char *arg)
{
	char slug[64] = "";
	char zone_path[OBJ_PATH_MAX];
	OBJ *z;
	const char *v;

	arg = util_getword(arg, slug, sizeof slug);
	if (!slug[0]) {
		telnetclient_puts(cl, "usage: @zone info <slug>\n");
		return 0;
	}
	if (slug_to_path(slug, zone_path, sizeof zone_path) != 0
		|| !(z = zone_get(zone_path))) {
		telnetclient_printf(cl, "No such zone \"%s\".\n", slug);
		return 0;
	}

	telnetclient_printf(cl, "Zone %s\n", zone_path);
	v = obj_prop_get(z, "title");
	telnetclient_printf(cl, "  title    : %s\n", v ? v : "(unset)");
	v = obj_prop_get(z, "creator");
	telnetclient_printf(cl, "  creator  : %s\n", v ? v : "(unset)");
	v = obj_prop_get(z, "template");
	telnetclient_printf(cl, "  template : %s\n", v ? v : "(unset)");
	v = obj_prop_get(z, "%parent");
	telnetclient_printf(cl, "  parent   : %s\n", v ? v : "(none)");
	v = obj_prop_get(z, "builders");
	telnetclient_printf(cl, "  builders : %s\n", v && v[0] ? v : "(open)");
	obj_release(z);
	return 1;
}

static int
zone_builders(DESCRIPTOR_DATA *cl, const struct acs_info *acs,
	const char *name, const char *arg)
{
	char slug[64] = "", op[64] = "";
	char zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	char newlist[512];
	OBJ *z;
	const char *cur;
	struct builder_req req;
	struct builder_result res;
	int add;

	arg = util_getword(arg, slug, sizeof slug);
	arg = util_getword(arg, op, sizeof op);
	if (!slug[0]) {
		telnetclient_puts(cl,
			"usage: @zone builders <slug> [list | +user | -user]\n");
		return 0;
	}
	if (slug_to_path(slug, zone_path, sizeof zone_path) != 0
		|| !(z = zone_get(zone_path))) {
		telnetclient_printf(cl, "No such zone \"%s\".\n", slug);
		return 0;
	}

	/* list (also the default with no op) */
	if (!op[0] || !strcasecmp(op, "list")) {
		cur = obj_prop_get(z, "builders");
		telnetclient_printf(cl, "%s builders: %s\n", zone_path,
			cur && cur[0] ? cur : "(open to any builder)");
		obj_release(z);
		return 1;
	}

	if (op[0] != '+' && op[0] != '-') {
		telnetclient_puts(cl, "usage: @zone builders <slug> [+user | -user]\n");
		obj_release(z);
		return 0;
	}
	if (!is_wizard(acs)) {
		telnetclient_puts(cl, "Only wizards may change a zone's builders.\n");
		obj_release(z);
		return 0;
	}

	add = op[0] == '+';
	cur = obj_prop_get(z, "builders");
	list_edit(cur, op + 1, add, newlist, sizeof newlist);
	obj_prop_set(z, "builders", newlist);

	zone_info_key(zone_path, key, sizeof key);
	req = (struct builder_req){
		.actor = acs,
		.actor_name = name,
		.commit_key = key,
		.obj = z,
		.is_create = 0,
	};
	if (builder_save(builder_zone_ops(), &req, &res) == BUILDER_OK)
		telnetclient_printf(cl, "%s builders: %s\n", zone_path,
			newlist[0] ? newlist : "(open to any builder)");
	else
		telnetclient_printf(cl, "Could not update builders: %s\n", res.message);
	obj_release(z);
	return 1;
}

static int
zone_set(DESCRIPTOR_DATA *cl, const struct acs_info *acs, const char *name,
	const char *arg)
{
	char slug[64] = "", field[32] = "";
	char zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const char *value;
	struct builder_req req;
	struct builder_result res;
	OBJ *z;

	if (!is_wizard(acs)) {
		telnetclient_puts(cl, "Only wizards may change zone metadata.\n");
		return 0;
	}
	arg = util_getword(arg, slug, sizeof slug);
	arg = util_getword(arg, field, sizeof field);
	if (!slug[0] || !field[0] || !arg || !*arg) {
		telnetclient_puts(cl,
			"usage: @zone set <slug> <title|template|desc> <value>\n");
		return 0;
	}
	value = arg;
	if (strcasecmp(field, "title") && strcasecmp(field, "template")
		&& strcasecmp(field, "desc")) {
		telnetclient_printf(cl, "Unknown zone field \"%s\" "
			"(title, template, desc).\n", field);
		return 0;
	}
	if (slug_to_path(slug, zone_path, sizeof zone_path) != 0
		|| !(z = zone_get(zone_path))) {
		telnetclient_printf(cl, "No such zone \"%s\".\n", slug);
		return 0;
	}

	obj_prop_set(z, field, value);
	zone_info_key(zone_path, key, sizeof key);
	req = (struct builder_req){
		.actor = acs,
		.actor_name = name,
		.commit_key = key,
		.obj = z,
		.is_create = 0,
	};
	if (builder_save(builder_zone_ops(), &req, &res) == BUILDER_OK)
		telnetclient_printf(cl, "%s %s = %s\n", zone_path, field, value);
	else
		telnetclient_printf(cl, "Could not set: %s\n", res.message);
	obj_release(z);
	return 1;
}

int
command_do_zone(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	char sub[16] = "";
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	const char *name = user_username(user);

	arg = util_getword(arg, sub, sizeof sub);
	if (!sub[0]) {
		telnetclient_puts(cl,
			"usage: @zone <new|info|set|builders> ...\n");
		return 0;
	}
	if (!strcasecmp(sub, "new"))
		return zone_new(cl, acs, name, arg);
	if (!strcasecmp(sub, "info"))
		return zone_info(cl, arg);
	if (!strcasecmp(sub, "set"))
		return zone_set(cl, acs, name, arg);
	if (!strcasecmp(sub, "builders"))
		return zone_builders(cl, acs, name, arg);

	telnetclient_printf(cl, "unknown @zone subcommand \"%s\".\n", sub);
	return 0;
}
