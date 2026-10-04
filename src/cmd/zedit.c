/* zedit.c : @zedit -- the OLC zone-metadata editor on the UI layer.
 * Sibling of @redit for a zone's zoneinfo (doc/zone-spec.md). Wizard-only,
 * like the other @zone metadata verbs. */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "zone.h"
#include "builder.h"
#include "zone_builder.h"
#include "ui.h"
#include "olc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUILDER_ROWS 24
#define BUILDERS_MAX 512

struct zedit {
	struct ui_frame frame;
	struct ui_field fields[7];
	OBJ *scratch;
	char commit_key[OBJ_PATH_MAX];	/* zone/<slug>/zoneinfo */
};

/* --- OBJ binding accessors (edit the scratch by prop key) ------------ */

static int
zedit_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct zedit *z = ctx;
	char *v = obj_prop_get(z->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

/* %-prefixed keys (%parent) are protected; route them through the internal
 * setter so the parent-zone link is editable. */
static int
zedit_set(void *ctx, const char *key, const char *value)
{
	struct zedit *z = ctx;
	int rc = (key[0] == '%')
		? obj_prop_set_internal(z->scratch, key, value)
		: obj_prop_set(z->scratch, key, value);

	return rc == OBJ_OK ? 0 : -1;
}

/* Rebuild a whitespace/comma-separated list, adding or removing name.
 * add != 0 inserts (idempotent); add == 0 removes. */
static void
list_edit(const char *cur, const char *name, int add, char *out, size_t len)
{
	const char *p = cur ? cur : "";
	size_t used = 0, namelen = strlen(name);

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

/* --- builders sub-frame (the zone allow-list) ------------------------ */

static struct ui_frame *build_builders_list(struct zedit *z);

/* select a builder row to drop it from the allow-list */
static void
builder_remove(struct ui_session *s, void *binding)
{
	struct zedit *z = binding;
	const char *name = ui_top(s)->fields[s->cursor].key;
	char *cur = obj_prop_get(z->scratch, "builders");
	char next[BUILDERS_MAX];

	list_edit(cur, name, 0, next, sizeof next);
	obj_prop_set(z->scratch, "builders", next);
	ui_swap_top(s, build_builders_list(z));	/* refresh the stale list */
}

/* -- add builder: a one-field name prompt -- */
struct add_builder {
	struct ui_frame frame;
	struct ui_field fields[1];
	struct zedit *z;
	char name[32];
};

static int
ab_get(void *ctx, const char *key UNUSED, char *buf, size_t len)
{
	struct add_builder *ab = ctx;

	return (int)snprintf(buf, len, "%s", ab->name);
}

static int
ab_set(void *ctx, const char *key UNUSED, const char *value)
{
	struct add_builder *ab = ctx;

	snprintf(ab->name, sizeof ab->name, "%s", value);
	return 0;
}

static void
ab_free(struct ui_frame *f)
{
	free(f);
}

static int
ab_submit(struct ui_session *s, void *binding)
{
	struct add_builder *ab = binding;
	struct zedit *z = ab->z;
	char *cur;
	char next[BUILDERS_MAX];

	if (!ab->name[0]) {
		telnetclient_puts(s->cl, "A builder name is required.\n");
		return -1;
	}
	cur = obj_prop_get(z->scratch, "builders");
	list_edit(cur, ab->name, 1, next, sizeof next);
	obj_prop_set(z->scratch, "builders", next);
	telnetclient_printf(s->cl, "Added builder %s.\n", ab->name);

	ui_pop(s);				/* pop the add frame (frees ab) */
	ui_swap_top(s, build_builders_list(z));	/* refresh the list */
	return -1;				/* pop/refresh already done */
}

static void
builder_add_start(struct ui_session *s, void *binding)
{
	struct zedit *z = binding;
	struct add_builder *ab = calloc(1, sizeof *ab);

	if (!ab)
		return;
	ab->z = z;
	ab->fields[0] = (struct ui_field){ .label = "Builder name",
		.key = "name", .type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = ab_get, .set = ab_set };
	ab->frame = (struct ui_frame){ .title = "Add builder",
		.fields = ab->fields, .nr_fields = 1,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT),
		.wizard = 1, .binding = ab, .on_submit = ab_submit,
		.free = ab_free };
	ui_push(s, &ab->frame);
}

/* -- the builders list -- */
struct builders_list {
	struct ui_frame frame;
	struct ui_field fields[MAX_BUILDER_ROWS];
	char names[MAX_BUILDER_ROWS][32];
	struct zedit *z;
};

static void
builders_list_free(struct ui_frame *f)
{
	free(f);
}

static struct ui_frame *
build_builders_list(struct zedit *z)
{
	struct builders_list *bl = calloc(1, sizeof *bl);
	const char *p = obj_prop_get(z->scratch, "builders");
	unsigned n = 0;

	if (!bl)
		return NULL;
	bl->z = z;
	p = p ? p : "";
	while (*p && n < MAX_BUILDER_ROWS - 1) {
		size_t tok, cp;

		while (*p == ' ' || *p == '\t' || *p == ',')
			p++;
		tok = strcspn(p, " \t,");
		if (tok == 0)
			break;
		cp = tok >= sizeof bl->names[0] ? sizeof bl->names[0] - 1 : tok;
		memcpy(bl->names[n], p, cp);
		bl->names[n][cp] = '\0';
		bl->fields[n] = (struct ui_field){ .label = bl->names[n],
			.key = bl->names[n], .type = UI_ACTION,
			.on_select = builder_remove };
		n++;
		p += tok;
	}

	bl->fields[n] = (struct ui_field){ .label = "(add a builder)",
		.type = UI_ACTION, .on_select = builder_add_start };
	n++;
	bl->frame = (struct ui_frame){
		.title = "Builders (open to any builder if empty; select to remove)",
		.fields = bl->fields, .nr_fields = n,
		.action_mask = UI_A(UI_ACT_QUIT), .binding = z,
		.free = builders_list_free };
	return &bl->frame;
}

static struct ui_frame *
builders_list_open(struct ui_session *s, void *binding)
{
	(void)s;
	return build_builders_list(binding);
}

/* --- submit / lifecycle ---------------------------------------------- */

static int
zedit_submit(struct ui_session *s, void *binding)
{
	struct zedit *z = binding;
	struct user *u = telnetclient_user(s->cl);
	struct builder_req req = {
		.actor = user_acs(u),
		.actor_name = user_username(u),
		.commit_key = z->commit_key,
		.obj = z->scratch,
		.is_create = 0,		/* zones are created by @zone new */
	};

	return olc_submit(s->cl, builder_zone_ops(), &req);
}

static void
zedit_free(struct ui_frame *f)
{
	struct zedit *z = (struct zedit *)f;

	obj_free(z->scratch);
	free(z);
}

/* --- field set ------------------------------------------------------- */

static void
init_fields(struct zedit *z)
{
	struct ui_field *f = z->fields;

	f[0] = (struct ui_field){ .label = "Title", .key = "title",
		.type = UI_STRING, .get = zedit_get, .set = zedit_set };
	f[1] = (struct ui_field){ .label = "Description", .key = "desc",
		.type = UI_STRING, .get = zedit_get, .set = zedit_set };
	f[2] = (struct ui_field){ .label = "Dig template", .key = "template",
		.type = UI_OBJREF, .get = zedit_get, .set = zedit_set };
	f[3] = (struct ui_field){ .label = "Parent zone", .key = "%parent",
		.type = UI_OBJREF, .get = zedit_get, .set = zedit_set };
	f[4] = (struct ui_field){ .label = "Builder note",
		.key = "builder.info", .type = UI_STRING,
		.get = zedit_get, .set = zedit_set };
	f[5] = (struct ui_field){ .label = "Creator", .key = "creator",
		.type = UI_STRING, .flags = UI_F_READONLY, .get = zedit_get };
	f[6] = (struct ui_field){ .label = "Builders", .type = UI_SUBFRAME,
		.open_child = builders_list_open };
}

/* --- command --------------------------------------------------------- */

int
command_do_zedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char slug[80] = "", zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const struct acs_info *acs;
	struct zedit *z;

	acs = user_acs(telnetclient_user(cl));
	if (!acs || !acs_check((struct acs_info *)acs, "fW")) {
		telnetclient_puts(cl, "Only wizards may edit zone metadata.\n");
		return 0;
	}
	util_getword(arg, slug, sizeof slug);
	if (!slug[0]) {
		telnetclient_puts(cl, "usage: @zedit <slug>\n");
		return 0;
	}

	/* accept a bare slug or a full "zone/<slug>" path */
	if (!strncmp(slug, ZONE_BASE "/", strlen(ZONE_BASE) + 1))
		snprintf(zone_path, sizeof zone_path, "%s", slug);
	else if ((size_t)snprintf(zone_path, sizeof zone_path, "%s/%s",
		ZONE_BASE, slug) >= sizeof zone_path) {
		telnetclient_puts(cl, "That zone slug is too long.\n");
		return 0;
	}
	if (!zone_exists(zone_path)) {
		telnetclient_printf(cl, "No such zone \"%s\".\n", zone_path);
		return 0;
	}
	if (zone_info_key(zone_path, key, sizeof key) != 0) {
		telnetclient_puts(cl, "Bad zone path.\n");
		return 0;
	}

	z = calloc(1, sizeof *z);
	if (!z) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	snprintf(z->commit_key, sizeof z->commit_key, "%s", key);
	z->scratch = olc_make_scratch(cl, key, 0);	/* edit-only */
	if (!z->scratch) {		/* olc_make_scratch already messaged */
		free(z);
		return 0;
	}

	init_fields(z);
	z->frame = (struct ui_frame){
		.title = z->commit_key,
		.fields = z->fields,
		.nr_fields = 7,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT)
			| UI_A(UI_ACT_NEXT) | UI_A(UI_ACT_PREV) | UI_A(UI_ACT_LIST),
		.wizard = 0,			/* edit-only: browse */
		.binding = z,
		.on_submit = zedit_submit,
		.free = zedit_free,
	};

	ui_open(cl, &z->frame, command_resume);
	return 1;
}
