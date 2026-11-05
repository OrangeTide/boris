/* medit.c : @medit -- the OLC mob/NPC editor on the UI layer (olc-spec 7) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "obj.h"
#include "builder.h"
#include "zone_builder.h"
#include "ui.h"
#include "olc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Class root for mob templates; a bare id authors a class here (olc-spec 3.2,
 * 7). The name is meant to be config-driven (olc.class.*); a constant for now. */
#define MOB_CLASS_BASE "templates/mob"

/* the frame, its fields, and the editing scratch, one per session.
 * frame is first so the free hook can reclaim the whole block. */
struct medit {
	struct ui_frame frame;
	struct ui_field fields[11];
	OBJ *scratch;			/* working copy edited here */
	int is_create;
	char commit_key[OBJ_PATH_MAX];
};

static const char *const mob_required[] = {
	"name", "keywords", "desc.short", "%kind", NULL
};

/* pc / npc / creature differ behaviorally, not structurally; creature is the
 * default for a hostile mob (olc-spec 7.1). */
static const char *const kind_choices[] = { "creature", "npc", "pc" };

/* --- OBJ binding accessors (edit the scratch by prop key) ------------ */

static int
medit_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct medit *m = ctx;
	char *v = olc_field_get(m->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

/* Reference and %-prefixed keys (%kind, %parent) route through olc_field_set,
 * which uses the ref accessors and bypasses the public-setter protection, so
 * they are editable fields here (olc-spec 7). */
static int
medit_set(void *ctx, const char *key, const char *value)
{
	struct medit *m = ctx;

	return olc_field_set(m->scratch, key, value) == OBJ_OK ? 0 : -1;
}

/* --- validators ------------------------------------------------------ */

/* Accept an empty value (clears the field) or an integer in [lo, hi]. */
static int
validate_int_range(const char *v, long lo, long hi, const char **err,
	const char *msg)
{
	char *end;
	long n;

	if (!v || !v[0])
		return 0;		/* empty is allowed; leaves it unset */
	n = strtol(v, &end, 10);
	if (*end || n < lo || n > hi) {
		*err = msg;
		return -1;
	}
	return 0;
}

static int
validate_difficulty(void *ctx, const char *v, const char **err)
{
	(void)ctx;
	return validate_int_range(v, 1, 5, err, "Difficulty must be 1-5.");
}

static int
validate_rank(void *ctx, const char *v, const char **err)
{
	(void)ctx;
	return validate_int_range(v, 0, 4, err, "Rank must be 0-4.");
}

/* --- skills sub-frame (olc-spec 7.2) --------------------------------- */

/* the sixteen W&L actions, grouped by attribute for a readable list */
static const char *const skill_keys[16] = {
	"skill.fight", "skill.move",   "skill.endure", "skill.brawn",
	"skill.shoot", "skill.prowl",  "skill.nimble", "skill.tinker",
	"skill.hunt",  "skill.study",  "skill.survey", "skill.attune",
	"skill.command", "skill.consort", "skill.judge", "skill.sway"
};
static const char *const skill_labels[16] = {
	"Fight (Body)", "Move (Body)", "Endure (Body)", "Brawn (Body)",
	"Shoot (Finesse)", "Prowl (Finesse)", "Nimble (Finesse)", "Tinker (Finesse)",
	"Hunt (Mind)", "Study (Mind)", "Survey (Mind)", "Attune (Mind)",
	"Command (Presence)", "Consort (Presence)", "Judge (Presence)", "Sway (Presence)"
};

struct skills_frame {
	struct ui_frame frame;
	struct ui_field fields[16];
};

static void
skills_free(struct ui_frame *f)
{
	free(f);
}

static struct ui_frame *
skills_open(struct ui_session *s, void *binding)
{
	struct medit *m = binding;	/* the main-frame binding is the editor */
	struct skills_frame *sf = calloc(1, sizeof *sf);
	int i;

	(void)s;
	if (!sf)
		return NULL;
	for (i = 0; i < 16; i++)
		sf->fields[i] = (struct ui_field){ .label = skill_labels[i],
			.key = skill_keys[i], .type = UI_INT,
			.get = medit_get, .set = medit_set,
			.validate = validate_rank };
	sf->frame = (struct ui_frame){ .title = "Skills (0-4)",
		.fields = sf->fields, .nr_fields = 16,
		.action_mask = UI_A(UI_ACT_QUIT), .binding = m,
		.free = skills_free };
	return &sf->frame;
}

/* --- tags sub-frame (olc-spec 7.3) ----------------------------------- */

#define MAX_TAG_ROWS 16

static const char *const tag_mode_choices[] = { "position", "difficulty" };

static int
validate_tag_value(void *ctx, const char *v, const char **err)
{
	(void)ctx;
	return validate_int_range(v, -3, 3, err, "Tag value must be -3..3.");
}

static struct ui_frame *build_tag_list(struct medit *m);

/* -- single tag: value + mode + remove -- */
struct single_tag {
	struct ui_frame frame;
	struct ui_field fields[3];
	struct medit *m;
	char name[32];
	char title[48];
	char value_key[64];
	char mode_key[64];
};

static int
st_get(void *ctx, const char *key, char *buf, size_t len)
{
	struct single_tag *st = ctx;
	char *v = obj_prop_get(st->m->scratch, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

static int
st_set(void *ctx, const char *key, const char *value)
{
	struct single_tag *st = ctx;

	return obj_prop_set(st->m->scratch, key, value) == OBJ_OK ? 0 : -1;
}

static void
st_free(struct ui_frame *f)
{
	free(f);
}

/* delete this tag from the scratch and refresh the list */
static void
tag_remove(struct ui_session *s, void *binding)
{
	struct single_tag *st = binding;
	struct medit *m = st->m;

	obj_prop_delete(m->scratch, st->value_key);
	obj_prop_delete(m->scratch, st->mode_key);
	ui_pop(s);				/* pop single-tag frame (frees st) */
	ui_swap_top(s, build_tag_list(m));	/* refresh the stale list */
}

static struct ui_frame *
single_tag_open(struct ui_session *s, void *binding)
{
	struct medit *m = binding;
	const char *name = ui_top(s)->fields[s->cursor].key;
	struct single_tag *st = calloc(1, sizeof *st);

	if (!st)
		return NULL;
	st->m = m;
	snprintf(st->name, sizeof st->name, "%s", name);
	snprintf(st->title, sizeof st->title, "Tag %s", name);
	snprintf(st->value_key, sizeof st->value_key, "tag.%s.value", name);
	snprintf(st->mode_key, sizeof st->mode_key, "tag.%s.mode", name);
	st->fields[0] = (struct ui_field){ .label = "Value (-3..3)",
		.key = st->value_key, .type = UI_INT, .get = st_get, .set = st_set,
		.validate = validate_tag_value };
	st->fields[1] = (struct ui_field){ .label = "Mode", .key = st->mode_key,
		.type = UI_ENUM, .choices = tag_mode_choices, .nr_choices = 2,
		.get = st_get, .set = st_set };
	st->fields[2] = (struct ui_field){ .label = "Remove this tag",
		.type = UI_ACTION, .on_select = tag_remove };
	st->frame = (struct ui_frame){ .title = st->title, .fields = st->fields,
		.nr_fields = 3, .action_mask = UI_A(UI_ACT_QUIT),
		.binding = st, .free = st_free };
	return &st->frame;
}

/* -- add tag: name, value, mode -- */
struct add_tag {
	struct ui_frame frame;
	struct ui_field fields[3];
	struct medit *m;
	char name[32];
	char value[8];
	char mode[16];
};

static char *
at_slot(struct add_tag *at, const char *key)
{
	if (!strcmp(key, "name"))  return at->name;
	if (!strcmp(key, "value")) return at->value;
	if (!strcmp(key, "mode"))  return at->mode;
	return NULL;
}

static int
at_get(void *ctx, const char *key, char *buf, size_t len)
{
	char *v = at_slot(ctx, key);

	return (int)snprintf(buf, len, "%s", v ? v : "");
}

static int
at_set(void *ctx, const char *key, const char *value)
{
	struct add_tag *at = ctx;
	char *v = at_slot(at, key);
	size_t sz = !strcmp(key, "name") ? sizeof at->name
		: !strcmp(key, "value") ? sizeof at->value : sizeof at->mode;

	if (!v)
		return -1;
	snprintf(v, sz, "%s", value);
	return 0;
}

static void
at_free(struct ui_frame *f)
{
	free(f);
}

static int
tag_add_submit(struct ui_session *s, void *binding)
{
	struct add_tag *at = binding;
	struct medit *m = at->m;
	DESCRIPTOR_DATA *cl = s->cl;
	const char *err = NULL;
	char prop[80];

	if (!at->name[0]) {
		telnetclient_puts(cl, "A tag name is required.\n");
		return -1;
	}
	if (validate_tag_value(NULL, at->value, &err) != 0) {
		telnetclient_printf(cl, "%s\n", err);
		return -1;
	}
	snprintf(prop, sizeof prop, "tag.%s.value", at->name);
	obj_prop_set(m->scratch, prop, at->value[0] ? at->value : "0");
	if (at->mode[0]) {
		snprintf(prop, sizeof prop, "tag.%s.mode", at->name);
		obj_prop_set(m->scratch, prop, at->mode);
	}
	telnetclient_printf(cl, "Added tag %s.\n", at->name);

	ui_pop(s);				/* pop the add frame (frees at) */
	ui_swap_top(s, build_tag_list(m));	/* refresh the list */
	return -1;				/* pop/refresh already done */
}

static void
tag_add_start(struct ui_session *s, void *binding)
{
	struct medit *m = binding;
	struct add_tag *at = calloc(1, sizeof *at);

	if (!at)
		return;
	at->m = m;
	at->fields[0] = (struct ui_field){ .label = "Tag name", .key = "name",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = at_get, .set = at_set };
	at->fields[1] = (struct ui_field){ .label = "Value (-3..3)",
		.key = "value", .type = UI_INT, .get = at_get, .set = at_set,
		.validate = validate_tag_value };
	at->fields[2] = (struct ui_field){ .label = "Mode", .key = "mode",
		.type = UI_ENUM, .choices = tag_mode_choices, .nr_choices = 2,
		.get = at_get, .set = at_set };
	at->frame = (struct ui_frame){ .title = "Add tag", .fields = at->fields,
		.nr_fields = 3,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT),
		.wizard = 1, .binding = at, .on_submit = tag_add_submit,
		.free = at_free };
	ui_push(s, &at->frame);
}

/* -- the tag list -- */
struct tag_list {
	struct ui_frame frame;
	struct ui_field fields[MAX_TAG_ROWS];
	char names[MAX_TAG_ROWS][32];
	char labels[MAX_TAG_ROWS][96];
	struct medit *m;
};

static void
tag_list_free(struct ui_frame *f)
{
	free(f);
}

static struct ui_frame *
build_tag_list(struct medit *m)
{
	struct tag_list *tl = calloc(1, sizeof *tl);
	unsigned n = 0;
	OBJ_ITER *it;
	const char *k, *v;

	if (!tl)
		return NULL;
	tl->m = m;

	it = obj_iter_begin(m->scratch);
	while (obj_iter_next(it, &k, &v) && n < MAX_TAG_ROWS - 1) {
		size_t kl = strlen(k), nl;
		char mode_key[80], lbl[96];
		char *mode;

		/* a tag is "tag.<name>.value"; one row per name */
		if (strncmp(k, "tag.", 4) != 0 || kl < 11
			|| strcmp(k + kl - 6, ".value") != 0)
			continue;
		nl = kl - 4 - 6;
		if (nl == 0 || nl >= sizeof tl->names[0])
			continue;
		memcpy(tl->names[n], k + 4, nl);
		tl->names[n][nl] = '\0';
		snprintf(mode_key, sizeof mode_key, "tag.%s.mode", tl->names[n]);
		mode = obj_prop_get(m->scratch, mode_key);
		/* build in a local temp so the compiler does not see names/labels
		 * (same struct) aliasing in one snprintf (-Wrestrict). */
		if (mode && mode[0])
			snprintf(lbl, sizeof lbl, "%s = %s (%s)",
				tl->names[n], v ? v : "0", mode);
		else
			snprintf(lbl, sizeof lbl, "%s = %s", tl->names[n], v ? v : "0");
		snprintf(tl->labels[n], sizeof tl->labels[n], "%s", lbl);
		tl->fields[n] = (struct ui_field){ .label = tl->labels[n],
			.key = tl->names[n], .type = UI_SUBFRAME,
			.open_child = single_tag_open };
		n++;
	}
	obj_iter_end(it);

	tl->fields[n] = (struct ui_field){ .label = "(add a new tag)",
		.type = UI_ACTION, .on_select = tag_add_start };
	n++;
	tl->frame = (struct ui_frame){ .title = "Tags", .fields = tl->fields,
		.nr_fields = n, .action_mask = UI_A(UI_ACT_QUIT),
		.binding = m, .free = tag_list_free };
	return &tl->frame;
}

static struct ui_frame *
tag_list_open(struct ui_session *s, void *binding)
{
	(void)s;
	return build_tag_list(binding);
}

/* --- submit / lifecycle ---------------------------------------------- */

static int
medit_submit(struct ui_session *s, void *binding)
{
	struct medit *m = binding;
	struct user *u = telnetclient_user(s->cl);
	struct builder_req req = {
		.actor = user_acs(u),
		.actor_name = user_username(u),
		.commit_key = m->commit_key,
		.obj = m->scratch,
		.required = mob_required,
		.is_create = m->is_create,
	};

	return olc_submit(s->cl, builder_zone_ops(), &req);
}

static void
medit_free(struct ui_frame *f)
{
	struct medit *m = (struct medit *)f;

	obj_free(m->scratch);
	free(m);
}

/* --- field set ------------------------------------------------------- */

static void
init_fields(struct medit *m)
{
	struct ui_field *f = m->fields;

	f[0] = (struct ui_field){ .label = "Name", .key = "name",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = medit_get, .set = medit_set };
	f[1] = (struct ui_field){ .label = "Keywords", .key = "keywords",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = medit_get, .set = medit_set };
	f[2] = (struct ui_field){ .label = "Short desc", .key = "desc.short",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = medit_get, .set = medit_set };
	f[3] = (struct ui_field){ .label = "Long desc", .key = "desc.long",
		.type = UI_TEXT, .get = medit_get, .set = medit_set };
	f[4] = (struct ui_field){ .label = "Kind", .key = "%kind",
		.type = UI_ENUM, .flags = UI_F_REQUIRED,
		.choices = kind_choices,
		.nr_choices = sizeof kind_choices / sizeof kind_choices[0],
		.get = medit_get, .set = medit_set };
	f[5] = (struct ui_field){ .label = "Template", .key = "%parent",
		.type = UI_OBJREF, .get = medit_get, .set = medit_set };
	f[6] = (struct ui_field){ .label = "Difficulty", .key = "difficulty",
		.type = UI_INT, .get = medit_get, .set = medit_set,
		.validate = validate_difficulty };
	f[7] = (struct ui_field){ .label = "Faction", .key = "faction",
		.type = UI_STRING, .get = medit_get, .set = medit_set };
	f[8] = (struct ui_field){ .label = "Skills", .type = UI_SUBFRAME,
		.open_child = skills_open };
	f[9] = (struct ui_field){ .label = "Tags", .type = UI_SUBFRAME,
		.open_child = tag_list_open };
	f[10] = (struct ui_field){ .label = "Loot", .key = "loot",
		.type = UI_OBJREF, .get = medit_get, .set = medit_set };
}

/* --- command --------------------------------------------------------- */

int
command_do_medit(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	char word[64] = "", id[96] = "", key[OBJ_PATH_MAX];
	const struct acs_info *acs;
	int is_create = 0;
	struct medit *m;

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
		telnetclient_puts(cl, "usage: @medit [new] "
			"<templates/mob/<id> | zone/<slug>/<id> | <id>>\n");
		return 0;
	}

	/* the key's base path is the class-vs-instance choice (olc-spec 7); a
	 * bare id authors a mob class under the class root. */
	if (strchr(id, '/'))
		snprintf(key, sizeof key, "%s", id);
	else if ((size_t)snprintf(key, sizeof key, "%s/%s", MOB_CLASS_BASE, id)
		>= sizeof key) {
		telnetclient_puts(cl, "That id is too long.\n");
		return 0;
	}

	m = calloc(1, sizeof *m);
	if (!m) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	snprintf(m->commit_key, sizeof m->commit_key, "%s", key);
	m->is_create = is_create;
	m->scratch = olc_make_scratch(cl, key, is_create);
	if (!m->scratch) {		/* olc_make_scratch already messaged */
		free(m);
		return 0;
	}
	if (is_create) {		/* seed a sensible default kind (editable) */
		obj_prop_set_internal(m->scratch, "%kind", "creature");
	}

	init_fields(m);
	m->frame = (struct ui_frame){
		.title = m->commit_key,
		.fields = m->fields,
		.nr_fields = 11,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT)
			| UI_A(UI_ACT_NEXT) | UI_A(UI_ACT_PREV) | UI_A(UI_ACT_LIST),
		.wizard = is_create,		/* create walks; edit browses */
		.binding = m,
		.on_submit = medit_submit,
		.free = medit_free,
	};

	ui_open(cl, &m->frame, command_resume);
	return 1;
}
