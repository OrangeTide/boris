/* redit.c : @redit -- the OLC room editor on the UI layer (doc/olc-spec.md 5) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "room.h"
#include "character.h"
#include "zone.h"
#include "zone_builder.h"
#include "builder.h"
#include "ui.h"
#include "cmdutil.h"
#include "olc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* the frame, its fields, and the editing scratch, one per session.
 * frame is first so the free hook can reclaim the whole block. */
struct redit {
	struct ui_frame frame;
	struct ui_field fields[8];
	OBJ *scratch;			/* working copy edited here */
	int is_create;			/* create (no baseline) vs edit */
	char commit_key[OBJ_PATH_MAX];
};

static const char *const room_required[] = { "name", "desc.short", NULL };

/* --- OBJ binding accessors (edit the scratch by prop key) ------------ */

static int
redit_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct redit *r = ctx;
	char *v = olc_field_get(r->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

static int
redit_set(void *ctx, const char *key, const char *value)
{
	struct redit *r = ctx;

	return olc_field_set(r->scratch, key, value) == OBJ_OK ? 0 : -1;
}

/* --- submit / lifecycle ---------------------------------------------- */

static void room_zoneinfo_key(const char *room_key, char *buf, size_t len);

static int
redit_submit(struct ui_session *s, void *binding)
{
	struct redit *r = binding;
	struct user *u = telnetclient_user(s->cl);
	char zone_key[OBJ_PATH_MAX];
	struct builder_req req = {
		.actor = user_acs(u),
		.actor_name = user_username(u),
		.commit_key = r->commit_key,
		.obj = r->scratch,
		.required = room_required,
		.is_create = r->is_create,
	};
	/* soft-warn on create if the enclosing zone has no zoneinfo yet */
	room_zoneinfo_key(r->commit_key, zone_key, sizeof zone_key);
	req.zone_key = zone_key[0] ? zone_key : NULL;

	return olc_submit(s->cl, builder_zone_ops(), &req);
}

static void
redit_free(struct ui_frame *f)
{
	struct redit *r = (struct redit *)f;

	obj_free(r->scratch);
	free(r);
}

/* --- scratch construction -------------------------------------------- */

/* --- exit sub-editor (olc-spec.md 5.3) ------------------------------- */

#define MAX_EXIT_ROWS 12

static const char *const dir_choices[] = {
	"n", "s", "e", "w", "ne", "nw", "se", "sw", "u", "d", "enter"
};

static struct ui_frame *build_exit_list(struct redit *r);
static struct ui_frame *single_exit_open(struct ui_session *s, void *binding);
static void exit_add_start(struct ui_session *s, void *binding);

/* Display slug of a zone path: "zone/darkwood" -> "darkwood" (olc-spec 5.3). */
static const char *
zone_slug(const char *zone_path)
{
	size_t base = strlen(ZONE_BASE);

	if (!strncmp(zone_path, ZONE_BASE, base) && zone_path[base] == '/')
		return zone_path + base + 1;
	return zone_path;
}

/* The immediate zone's zoneinfo key for a room key, derived without needing
 * the zone to exist yet: "zone/darkwood/closet" -> "zone/darkwood/zoneinfo".
 * Writes "" if room_key is not a "zone/<slug>/<id>" path. */
static void
room_zoneinfo_key(const char *room_key, char *buf, size_t len)
{
	size_t base = strlen(ZONE_BASE);
	const char *slash;

	buf[0] = '\0';
	if (strncmp(room_key, ZONE_BASE, base) || room_key[base] != '/')
		return;				/* not under the zone base */
	slash = strchr(room_key + base + 1, '/');
	if (!slash)
		return;				/* "zone/<slug>" with no room id */
	snprintf(buf, len, "%.*s/%s", (int)(slash - room_key), room_key,
		ZONE_INFO_LEAF);
}

/* Resolve a builder-typed room ref to a full key, in the room's own zone. */
static void
resolve_room_ref(struct redit *r, const char *ref, char *buf, size_t len)
{
	char zone_path[OBJ_PATH_MAX];

	if (strchr(ref, '/')
		|| zone_resolve(r->commit_key, zone_path, sizeof zone_path) != 0)
		snprintf(buf, len, "%s", ref);
	else
		snprintf(buf, len, "%s/%s", zone_path, ref);
}

/* -- single exit: destination + description + remove -- */

struct single_exit {
	struct ui_frame frame;
	struct ui_field fields[3];
	struct redit *r;
	char dir[8];
	char title[32];
	char to_key[64];
	char desc_key[64];
};

static int
se_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct single_exit *se = ctx;
	char *v = olc_field_get(se->r->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

static int
se_set(void *ctx, const char *key, const char *value)
{
	struct single_exit *se = ctx;

	return olc_field_set(se->r->scratch, key, value) == OBJ_OK ? 0 : -1;
}

static void
se_free(struct ui_frame *f)
{
	free(f);
}

/* delete this exit from the scratch and refresh the list */
static void
exit_remove(struct ui_session *s, void *binding)
{
	struct single_exit *se = binding;
	struct redit *r = se->r;

	obj_prop_delete_ref(r->scratch, se->to_key);
	obj_prop_delete(r->scratch, se->desc_key);
	ui_pop(s);				/* pop the single-exit frame (frees se) */
	ui_swap_top(s, build_exit_list(r));	/* refresh the (now stale) list */
}

static struct ui_frame *
single_exit_open(struct ui_session *s, void *binding)
{
	struct redit *r = binding;
	const char *dir = ui_top(s)->fields[s->cursor].key;
	struct single_exit *se = calloc(1, sizeof *se);

	if (!se)
		return NULL;
	se->r = r;
	snprintf(se->dir, sizeof se->dir, "%s", dir);
	snprintf(se->title, sizeof se->title, "Exit %s", dir);
	snprintf(se->to_key, sizeof se->to_key, "exit.%s.to", dir);
	snprintf(se->desc_key, sizeof se->desc_key, "exit.%s.desc", dir);
	se->fields[0] = (struct ui_field){ .label = "Destination",
		.key = se->to_key, .type = UI_OBJREF, .flags = UI_F_REQUIRED,
		.get = se_get, .set = se_set };
	se->fields[1] = (struct ui_field){ .label = "Description",
		.key = se->desc_key, .type = UI_STRING, .get = se_get, .set = se_set };
	se->fields[2] = (struct ui_field){ .label = "Remove this exit",
		.type = UI_ACTION, .on_select = exit_remove };
	se->frame = (struct ui_frame){ .title = se->title, .fields = se->fields,
		.nr_fields = 3, .action_mask = UI_A(UI_ACT_QUIT),
		.binding = se, .free = se_free };
	return &se->frame;
}

/* -- add exit: pick direction, destination, description; reverse-link -- */

struct add_exit {
	struct ui_frame frame;
	struct ui_field fields[3];
	struct redit *r;
	char dir[16];
	char dest[128];
	char desc[256];
};

static char *
ae_slot(struct add_exit *ae, const char *key)
{
	if (!strcmp(key, "dir"))  return ae->dir;
	if (!strcmp(key, "dest")) return ae->dest;
	if (!strcmp(key, "desc")) return ae->desc;
	return NULL;
}

static int
ae_get(void *ctx, const char *key, char *buf, size_t len)
{
	char *v = ae_slot(ctx, key);
	return (int)snprintf(buf, len, "%s", v ? v : "");
}

static int
ae_set(void *ctx, const char *key, const char *value)
{
	struct add_exit *ae = ctx;
	char *v = ae_slot(ae, key);
	size_t sz = !strcmp(key, "dir") ? sizeof ae->dir
		: !strcmp(key, "dest") ? sizeof ae->dest : sizeof ae->desc;

	if (!v)
		return -1;
	snprintf(v, sz, "%s", value);
	return 0;
}

static void
ae_free(struct ui_frame *f)
{
	free(f);
}

static int
add_submit(struct ui_session *s, void *binding)
{
	struct add_exit *ae = binding;
	struct redit *r = ae->r;
	DESCRIPTOR_DATA *cl = s->cl;
	struct user *u = telnetclient_user(cl);
	const char *dirkey, *opp;
	char destkey[OBJ_PATH_MAX], prop[64];
	OBJ *tr;

	if (!ae->dir[0] || !ae->dest[0]) {
		telnetclient_puts(cl, "Direction and destination are required.\n");
		return -1;
	}
	if (cmd_dir_resolve(ae->dir, &dirkey, &opp) != 0) {
		telnetclient_printf(cl, "\"%s\" is not a direction.\n", ae->dir);
		return -1;
	}
	resolve_room_ref(r, ae->dest, destkey, sizeof destkey);

	snprintf(prop, sizeof prop, "exit.%s.to", dirkey);
	obj_prop_set_ref(r->scratch, prop, destkey);
	if (ae->desc[0]) {
		snprintf(prop, sizeof prop, "exit.%s.desc", dirkey);
		obj_prop_set(r->scratch, prop, ae->desc);
	}
	telnetclient_printf(cl, "Added exit %s -> %s.\n", dirkey, destkey);

	/* flag a destination in another zone: the exit leaves this zone, and a
	 * reverse link would try to commit on a room the builder may not own
	 * (olc-spec 5.3). This is informational, never a block. */
	{
		char my_zone[OBJ_PATH_MAX], tgt_zone[OBJ_PATH_MAX];

		if (zone_resolve(r->commit_key, my_zone, sizeof my_zone) == 0
			&& zone_resolve(destkey, tgt_zone, sizeof tgt_zone) == 0
			&& strcmp(my_zone, tgt_zone) != 0)
			telnetclient_printf(cl,
				"Note: this exit leaves zone %s into zone %s.\n",
				zone_slug(my_zone), zone_slug(tgt_zone));
	}

	/* offer the reverse link on the target, committed directly (5.3) */
	if (opp && (tr = obj_get(destkey))) {
		struct builder_req req = {
			.actor = user_acs(u), .actor_name = user_username(u),
			.commit_key = destkey, .obj = tr, .is_create = 0,
		};
		struct builder_result res;

		snprintf(prop, sizeof prop, "exit.%s.to", opp);
		obj_prop_set_ref(tr, prop, r->commit_key);
		if (builder_save(builder_zone_ops(), &req, &res) == BUILDER_OK)
			telnetclient_printf(cl, "Reverse exit (%s) linked from %s.\n",
				opp, destkey);
		else	/* commonly a cross-zone target the builder cannot edit */
			telnetclient_printf(cl, "(no reverse link: %s)\n",
				res.message);
		obj_release(tr);
	} else if (opp) {
		telnetclient_puts(cl,
			"(target does not exist yet; no reverse link)\n");
	}

	ui_pop(s);				/* pop the add frame (frees ae) */
	ui_swap_top(s, build_exit_list(r));	/* refresh the list */
	return -1;				/* pop/refresh already done */
}

static void
exit_add_start(struct ui_session *s, void *binding)
{
	struct redit *r = binding;
	struct add_exit *ae = calloc(1, sizeof *ae);

	if (!ae)
		return;
	ae->r = r;
	ae->fields[0] = (struct ui_field){ .label = "Direction", .key = "dir",
		.type = UI_ENUM, .flags = UI_F_REQUIRED, .choices = dir_choices,
		.nr_choices = sizeof dir_choices / sizeof dir_choices[0],
		.get = ae_get, .set = ae_set };
	ae->fields[1] = (struct ui_field){ .label = "Destination", .key = "dest",
		.type = UI_STRING, .flags = UI_F_REQUIRED, .get = ae_get, .set = ae_set };
	ae->fields[2] = (struct ui_field){ .label = "Description", .key = "desc",
		.type = UI_STRING, .get = ae_get, .set = ae_set };
	ae->frame = (struct ui_frame){ .title = "Add exit", .fields = ae->fields,
		.nr_fields = 3,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT),
		.wizard = 1, .binding = ae, .on_submit = add_submit, .free = ae_free };
	ui_push(s, &ae->frame);
}

/* -- the exit list -- */

struct exit_list {
	struct ui_frame frame;
	struct ui_field fields[MAX_EXIT_ROWS];
	char dirs[MAX_EXIT_ROWS][8];
	char labels[MAX_EXIT_ROWS][160];
	struct redit *r;
};

static void
exit_list_free(struct ui_frame *f)
{
	free(f);
}

static struct ui_frame *
build_exit_list(struct redit *r)
{
	struct exit_list *el = calloc(1, sizeof *el);
	char my_zone[OBJ_PATH_MAX];
	unsigned n = 0;
	OBJ_ITER *it;
	const char *k, *v;

	if (!el)
		return NULL;
	el->r = r;
	(void)zone_resolve(r->commit_key, my_zone, sizeof my_zone);

	it = obj_iter_begin(r->scratch);
	while (obj_iter_next(it, &k, &v) && n < MAX_EXIT_ROWS - 1) {
		size_t kl = strlen(k), dl;
		char tgt_zone[OBJ_PATH_MAX], ann[OBJ_PATH_MAX + 16] = "";
		char lbl[160];

		if (strncmp(k, "exit.", 5) != 0 || kl < 10
			|| strcmp(k + kl - 4, ".to~") != 0)
			continue;
		dl = kl - 5 - 4;
		if (dl == 0 || dl >= sizeof el->dirs[0])
			continue;
		memcpy(el->dirs[n], k + 5, dl);
		el->dirs[n][dl] = '\0';
		if (v && zone_resolve(v, tgt_zone, sizeof tgt_zone) == 0
			&& strcmp(my_zone, tgt_zone) != 0)
			snprintf(ann, sizeof ann, " [zone: %s]", zone_slug(tgt_zone));
		snprintf(lbl, sizeof lbl, "%s -> %s%s", el->dirs[n], v ? v : "", ann);
		snprintf(el->labels[n], sizeof el->labels[n], "%s", lbl);
		el->fields[n] = (struct ui_field){ .label = el->labels[n],
			.key = el->dirs[n], .type = UI_SUBFRAME,
			.open_child = single_exit_open };
		n++;
	}
	obj_iter_end(it);

	el->fields[n] = (struct ui_field){ .label = "(add a new exit)",
		.type = UI_ACTION, .on_select = exit_add_start };
	n++;
	el->frame = (struct ui_frame){ .title = "Exits", .fields = el->fields,
		.nr_fields = n, .action_mask = UI_A(UI_ACT_QUIT),
		.binding = r, .free = exit_list_free };
	return &el->frame;
}

static struct ui_frame *
exit_list_open(struct ui_session *s, void *binding)
{
	(void)s;
	return build_exit_list(binding);
}

/* --- field set ------------------------------------------------------- */

static void
init_fields(struct redit *r)
{
	struct ui_field *f = r->fields;

	f[0] = (struct ui_field){ .label = "Title", .key = "name",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = redit_get, .set = redit_set };
	f[1] = (struct ui_field){ .label = "Glance", .key = "desc.glance",
		.type = UI_STRING, .get = redit_get, .set = redit_set };
	f[2] = (struct ui_field){ .label = "Short desc", .key = "desc.short",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = redit_get, .set = redit_set };
	f[3] = (struct ui_field){ .label = "Long desc", .key = "desc.long",
		.type = UI_TEXT, .get = redit_get, .set = redit_set };
	f[4] = (struct ui_field){ .label = "Builder note", .key = "builder.info",
		.type = UI_STRING, .get = redit_get, .set = redit_set };
	f[5] = (struct ui_field){ .label = "Exits", .type = UI_SUBFRAME,
		.open_child = exit_list_open };
	f[6] = (struct ui_field){ .label = "Creator", .key = "creator",
		.type = UI_STRING, .flags = UI_F_READONLY, .get = redit_get };
	f[7] = (struct ui_field){ .label = "Owner", .key = "owner",
		.type = UI_STRING, .get = redit_get, .set = redit_set };
}

/* --- command --------------------------------------------------------- */

int
command_do_redit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	char word[64] = "", id[96] = "";
	char zone_path[OBJ_PATH_MAX], key[OBJ_PATH_MAX];
	const struct acs_info *acs;
	struct character *ch;
	const char *cur;
	int is_create = 0;
	struct redit *r;

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
		telnetclient_puts(cl, "usage: @redit [new] <id>\n");
		return 0;
	}

	/* resolve the commit key: a full zone/ path is used as-is; a bare id
	 * lands in the zone the builder is standing in. */
	if (strchr(id, '/')) {
		snprintf(key, sizeof key, "%s", id);
	} else {
		ch = telnetclient_character(cl);
		if (!ch || !(cur = character_attr_get(ch, "room.current"))
			|| zone_resolve(cur, zone_path, sizeof zone_path) != 0) {
			telnetclient_puts(cl, "You are not standing in a zone; "
				"give a full zone/<slug>/<id> path.\n");
			return 0;
		}
		if ((size_t)snprintf(key, sizeof key, "%s/%s", zone_path, id)
			>= sizeof key) {
			telnetclient_puts(cl, "That room id is too long.\n");
			return 0;
		}
	}

	r = calloc(1, sizeof *r);
	if (!r) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	snprintf(r->commit_key, sizeof r->commit_key, "%s", key);
	r->is_create = is_create;
	r->scratch = olc_make_scratch(cl, key, is_create);
	if (!r->scratch) {		/* olc_make_scratch already messaged */
		free(r);
		return 0;
	}

	if (is_create) {		/* seed %kind and the zone's class template */
		char *template;

		obj_prop_set_internal(r->scratch, "%kind", "room");
		if (strchr(key, '/'))
			zone_resolve(key, zone_path, sizeof zone_path);
		template = zone_template(zone_path);
		if (template)
			obj_prop_set_ref_internal(r->scratch, "%parent", template);
		free(template);
	}

	init_fields(r);
	r->frame = (struct ui_frame){
		.title = r->commit_key,
		.fields = r->fields,
		.nr_fields = 8,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT)
			| UI_A(UI_ACT_NEXT) | UI_A(UI_ACT_PREV) | UI_A(UI_ACT_LIST),
		.wizard = is_create,		/* create walks; edit browses */
		.binding = r,
		.on_submit = redit_submit,
		.free = redit_free,
	};

	ui_open(cl, &r->frame, command_resume);
	return 1;
}
