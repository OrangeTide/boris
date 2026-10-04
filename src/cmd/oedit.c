/* oedit.c : @oedit -- the OLC item editor on the UI layer (olc-spec 6) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "character.h"
#include "zone.h"
#include "builder.h"
#include "zone_builder.h"
#include "ui.h"
#include "olc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* the frame, its (type-dependent) fields, and the editing scratch.
 * frame is first so the free hook can reclaim the whole block. */
struct oedit {
	struct ui_frame frame;
	struct ui_field fields[13];
	OBJ *scratch;
	int is_create;
	char commit_key[OBJ_PATH_MAX];
};

static const char *const item_required[] = {
	"name", "keywords", "desc.short", NULL
};
static const char *const type_choices[] = {
	"misc", "container", "readable", "wearable"
};

/* --- OBJ binding accessors (edit the scratch by prop key) ------------ */

static int
oedit_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct oedit *o = ctx;
	char *v = obj_prop_get(o->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

/* %-prefixed keys (%parent) are protected; route them through the internal
 * setter so Template is an editable field. */
static int
oedit_set(void *ctx, const char *key, const char *value)
{
	struct oedit *o = ctx;
	int rc = (key[0] == '%')
		? obj_prop_set_internal(o->scratch, key, value)
		: obj_prop_set(o->scratch, key, value);

	return rc == OBJ_OK ? 0 : -1;
}

/* Accept an empty value or a non-negative integer (weight/bulk/value/cap). */
static int
validate_count(void *ctx, const char *v, const char **err)
{
	char *end;
	long n;

	(void)ctx;
	if (!v || !v[0])
		return 0;
	n = strtol(v, &end, 10);
	if (*end || n < 0) {
		*err = "Must be a non-negative integer.";
		return -1;
	}
	return 0;
}

/* --- submit / lifecycle ---------------------------------------------- */

static int
oedit_submit(struct ui_session *s, void *binding)
{
	struct oedit *o = binding;
	struct user *u = telnetclient_user(s->cl);
	struct builder_req req = {
		.actor = user_acs(u),
		.actor_name = user_username(u),
		.commit_key = o->commit_key,
		.obj = o->scratch,
		.required = item_required,
		.is_create = o->is_create,
	};

	return olc_submit(s->cl, builder_zone_ops(), &req);
}

static void
oedit_free(struct ui_frame *f)
{
	struct oedit *o = (struct oedit *)f;

	obj_free(o->scratch);
	free(o);
}

/* --- field set (type-dependent, olc-spec 6) -------------------------- */

static unsigned init_fields(struct oedit *o);

/* Type changed: rebuild the field list in place so Capacity / Wear slot
 * appear or disappear live, and publish the new count. The edited Type field
 * keeps its index (only fields after it change), so this is safe mid-edit. */
static void
oedit_type_changed(struct ui_session *s, void *binding)
{
	struct oedit *o = binding;

	ui_fields_rebuilt(s, init_fields(o));
}

/* Build the field list from the item's current type and return the count.
 * Capacity shows only for a container, Wear slot only for a wearable, so the
 * wizard stays short for a plain object. Rebuilt live when the type changes
 * (oedit_type_changed) and once more on reopen. */
static unsigned
init_fields(struct oedit *o)
{
	struct ui_field *f = o->fields;
	char *type = obj_prop_get(o->scratch, "type");
	unsigned n = 0;

	f[n++] = (struct ui_field){ .label = "Name", .key = "name",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = oedit_get, .set = oedit_set };
	f[n++] = (struct ui_field){ .label = "Keywords", .key = "keywords",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = oedit_get, .set = oedit_set };
	f[n++] = (struct ui_field){ .label = "Short desc", .key = "desc.short",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = oedit_get, .set = oedit_set };
	f[n++] = (struct ui_field){ .label = "Long desc", .key = "desc.long",
		.type = UI_TEXT, .get = oedit_get, .set = oedit_set };
	f[n++] = (struct ui_field){ .label = "Template", .key = "%parent",
		.type = UI_OBJREF, .get = oedit_get, .set = oedit_set };
	f[n++] = (struct ui_field){ .label = "Type", .key = "type",
		.type = UI_ENUM, .choices = type_choices,
		.nr_choices = sizeof type_choices / sizeof type_choices[0],
		.get = oedit_get, .set = oedit_set,
		.on_change = oedit_type_changed };
	f[n++] = (struct ui_field){ .label = "Weight", .key = "weight",
		.type = UI_INT, .get = oedit_get, .set = oedit_set,
		.validate = validate_count };
	f[n++] = (struct ui_field){ .label = "Bulk", .key = "bulk",
		.type = UI_INT, .get = oedit_get, .set = oedit_set,
		.validate = validate_count };
	f[n++] = (struct ui_field){ .label = "Value", .key = "value",
		.type = UI_INT, .get = oedit_get, .set = oedit_set,
		.validate = validate_count };
	f[n++] = (struct ui_field){ .label = "Fixed", .key = "flags.fixed",
		.type = UI_BOOL, .get = oedit_get, .set = oedit_set };

	if (type && !strcmp(type, "container"))
		f[n++] = (struct ui_field){ .label = "Capacity (bulk)",
			.key = "container.capacity", .type = UI_INT,
			.get = oedit_get, .set = oedit_set,
			.validate = validate_count };
	else if (type && !strcmp(type, "wearable"))
		f[n++] = (struct ui_field){ .label = "Wear slot",
			.key = "wear.slot", .type = UI_STRING,
			.get = oedit_get, .set = oedit_set };

	f[n++] = (struct ui_field){ .label = "Creator", .key = "creator",
		.type = UI_STRING, .flags = UI_F_READONLY, .get = oedit_get };
	f[n++] = (struct ui_field){ .label = "Owner", .key = "owner",
		.type = UI_STRING, .get = oedit_get, .set = oedit_set };
	return n;
}

/* --- command --------------------------------------------------------- */

int
command_do_oedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char word[64] = "", id[96] = "";
	char zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const struct acs_info *acs;
	struct character *ch;
	const char *cur;
	int is_create = 0;
	struct oedit *o;

	acs = user_acs(telnetclient_user(cl));
	if (!acs || !acs_check((struct acs_info *)acs, "fB|fW")) {
		telnetclient_puts(cl, "You are not a builder.\n");
		return 0;
	}
	arg = util_getword(arg, word, sizeof word);
	if (!strcasecmp(word, "new")) {
		is_create = 1;
		arg = util_getword(arg, id, sizeof id);
	} else {
		snprintf(id, sizeof id, "%s", word);
	}
	if (!id[0]) {
		telnetclient_puts(cl, "usage: @oedit [new] "
			"<templates/item/<id> | zone/<slug>/<id> | <id>>\n");
		return 0;
	}

	/* a full path is used as-is; a bare id lands in the zone the builder is
	 * standing in, the same instance namespace as a room (olc-spec 6). */
	if (strchr(id, '/')) {
		snprintf(key, sizeof key, "%s", id);
	} else {
		ch = telnetclient_character(cl);
		if (!ch || !(cur = character_attr_get(ch, "room.current"))
			|| zone_resolve(cur, zone_path, sizeof zone_path) != 0) {
			telnetclient_puts(cl, "You are not standing in a zone; "
				"give a full templates/item/<id> or "
				"zone/<slug>/<id> path.\n");
			return 0;
		}
		if ((size_t)snprintf(key, sizeof key, "%s/%s", zone_path, id)
			>= sizeof key) {
			telnetclient_puts(cl, "That item id is too long.\n");
			return 0;
		}
	}

	o = calloc(1, sizeof *o);
	if (!o) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	snprintf(o->commit_key, sizeof o->commit_key, "%s", key);
	o->is_create = is_create;
	o->scratch = olc_make_scratch(cl, key, is_create);
	if (!o->scratch) {		/* olc_make_scratch already messaged */
		free(o);
		return 0;
	}
	if (is_create)			/* items are typed by "type", not %kind */
		obj_prop_set_internal(o->scratch, "%kind", "item");

	o->frame = (struct ui_frame){
		.title = o->commit_key,
		.fields = o->fields,
		.nr_fields = init_fields(o),
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT)
			| UI_A(UI_ACT_NEXT) | UI_A(UI_ACT_PREV) | UI_A(UI_ACT_LIST),
		.wizard = is_create,		/* create walks; edit browses */
		.binding = o,
		.on_submit = oedit_submit,
		.free = oedit_free,
	};

	ui_open(cl, &o->frame, command_resume);
	return 1;
}
