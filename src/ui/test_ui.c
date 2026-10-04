/* test_ui.c : unit tests for the UI model, dispatch, and lifecycle */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "test_ui"

#include "ui.h"

#include <stdio.h>
#include <string.h>
#include "ctest.h"

/* --- a struct test binding ------------------------------------------- */

struct tb {
	char name[64];
	char pass[64];
	char mood[64];
	char flag[64];
	int submit_calls;
	int submit_rc;		/* what on_submit returns */
	int cancel_calls;
	int freed;
};

static char *
tb_slot(struct tb *t, const char *key)
{
	if (!strcmp(key, "name")) return t->name;
	if (!strcmp(key, "pass")) return t->pass;
	if (!strcmp(key, "mood")) return t->mood;
	if (!strcmp(key, "flag")) return t->flag;
	return NULL;
}

static int
tb_get(void *ctx, const char *key, char *buf, size_t len)
{
	char *v = tb_slot(ctx, key);
	if (!v) return -1;
	return (int)snprintf(buf, len, "%s", v);
}

static int
tb_set(void *ctx, const char *key, const char *value)
{
	char *v = tb_slot(ctx, key);
	if (!v) return -1;
	snprintf(v, 64, "%s", value);
	return 0;
}

static int
tb_submit(struct ui_session *s, void *binding)
{
	struct tb *t = binding;
	(void)s;
	t->submit_calls++;
	return t->submit_rc;
}

static void
tb_cancel(struct ui_session *s, void *binding)
{
	struct tb *t = binding;
	(void)s;
	t->cancel_calls++;
}

static int
reject_bad(void *ctx, const char *value, const char **err)
{
	(void)ctx;
	if (!strcmp(value, "bad")) {
		*err = "not allowed";
		return -1;
	}
	return 0;
}

static const char *const moods[] = { "calm", "angry", "happy" };

/* --- mock renderer (records calls; single-threaded global) ----------- */

static struct {
	int render, notify, enter;
	char last_notify[128];
	enum ui_type last_enter_type;
} R;

static void reset_r(void) { memset(&R, 0, sizeof R); }

static void m_render(struct ui_session *s, const struct ui_frame *f)
{ (void)s; (void)f; R.render++; }
static void m_notify(struct ui_session *s, const char *t)
{ (void)s; R.notify++; snprintf(R.last_notify, sizeof R.last_notify, "%s", t); }
static void m_enter(struct ui_session *s, const struct ui_field *f)
{ (void)s; R.enter++; R.last_enter_type = f->type; }

static const struct ui_renderer MR = {
	.name = "mock", .render = m_render, .enter_field = m_enter,
	.notify = m_notify,
};

#define MASK (UI_A(UI_ACT_NEXT) | UI_A(UI_ACT_PREV) | UI_A(UI_ACT_SUBMIT) \
	| UI_A(UI_ACT_QUIT))

/* --- tests ----------------------------------------------------------- */

static void
test_inline_and_enter(void)
{
	struct tb t = { .submit_rc = 0 };
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK, .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	check("session created", s != NULL);
	check("initial draw happened", R.render == 1);

	ui_input_line(s, "1 Hello there");	/* inline value */
	check("inline value set the field", strcmp(t.name, "Hello there") == 0);

	ui_input_line(s, "1");			/* enter the field */
	check("entering a string prompts", R.enter == 1);
	check("enter recorded the field type", R.last_enter_type == UI_STRING);
	ui_input_line(s, "Rewritten");		/* value while editing */
	check("edit-mode value applied", strcmp(t.name, "Rewritten") == 0);

	ui_input_line(s, "1");			/* enter again... */
	ui_input_line(s, "");			/* ...empty leaves unchanged */
	check("empty edit leaves value", strcmp(t.name, "Rewritten") == 0);

	ui_session_free(s);
}

static void
test_validation(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set, .validate = reject_bad },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK, .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "1 bad");
	check("rejected value not set", t.name[0] == '\0');
	check("validation error notified", R.notify == 1
		&& strcmp(R.last_notify, "not allowed") == 0);
	ui_input_line(s, "1 good");
	check("accepted value set", strcmp(t.name, "good") == 0);
	ui_session_free(s);
}

static void
test_required_and_submit(void)
{
	struct tb t = { .submit_rc = 0 };
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .flags = UI_F_REQUIRED, .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK, .binding = &t, .on_submit = tb_submit };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "s");			/* submit with required empty */
	check("required blocks submit", t.submit_calls == 0);
	check("required notified", R.notify == 1);

	ui_input_line(s, "1 Zog");
	ui_input_line(s, "s");			/* now it can submit */
	check("submit runs when satisfied", t.submit_calls == 1);
	check("accepted submit popped the frame (session ended)", s->depth == 0);
	ui_session_free(s);
}

static void
test_submit_reject_keeps_frame(void)
{
	struct tb t = { .submit_rc = -1 };	/* on_submit refuses */
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK, .binding = &t, .on_submit = tb_submit };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "1 Zog");
	ui_input_line(s, "s");
	check("on_submit was called", t.submit_calls == 1);
	check("rejected submit keeps the frame", s->depth == 1);
	check("staged edit preserved", strcmp(t.name, "Zog") == 0);
	ui_session_free(s);
}

static void
test_enum_and_bool(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "Mood", .key = "mood", .type = UI_ENUM,
		  .get = tb_get, .set = tb_set, .choices = moods, .nr_choices = 3 },
		{ .label = "Flag", .key = "flag", .type = UI_BOOL,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 2,
		.action_mask = MASK, .binding = &t };
	struct ui_session *s;

	reset_r();
	strcpy(t.flag, "no");
	s = ui_session_new(&MR, NULL, NULL, &frame);

	ui_input_line(s, "1");			/* enter the enum */
	ui_input_line(s, "9");			/* out of range */
	check("enum out-of-range notified", R.notify >= 1
		&& strcmp(R.last_notify, "That choice is out of range.") == 0);
	check("enum unchanged on bad pick", t.mood[0] == '\0');
	ui_input_line(s, "2");			/* pick 'angry' */
	check("enum choice applied", strcmp(t.mood, "angry") == 0);

	ui_input_line(s, "2");			/* enter the bool -> toggles */
	check("bool toggled to yes", strcmp(t.flag, "yes") == 0);
	ui_input_line(s, "2");
	check("bool toggled back to no", strcmp(t.flag, "no") == 0);

	ui_session_free(s);
}

static void
test_dispatch_edges(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	/* Quit enabled, but Submit NOT in the mask */
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = UI_A(UI_ACT_QUIT), .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "9");			/* out-of-range row */
	check("out-of-range row notified", strcmp(R.last_notify,
		"Invalid selection.") == 0);
	ui_input_line(s, "s");			/* action not in mask */
	check("disabled action rejected", strcmp(R.last_notify,
		"Invalid selection.") == 0);
	ui_input_line(s, "q");			/* Quit is enabled -> pops */
	check("quit popped the last frame", s->depth == 0);
	ui_session_free(s);
}

static void
test_readonly(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "Id", .key = "name", .type = UI_STRING,
		  .flags = UI_F_READONLY, .get = tb_get },	/* no set */
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK, .binding = &t };
	struct ui_session *s;

	reset_r();
	strcpy(t.name, "fixed");
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "1 nope");		/* attempt to set */
	check("readonly not changed", strcmp(t.name, "fixed") == 0);
	check("readonly notified", R.notify == 1);
	ui_session_free(s);
}

/* subframe: selecting field 1 pushes a child */
static struct ui_frame child_frame;
static struct ui_frame *
open_child(struct ui_session *s, void *ctx)
{
	(void)s; (void)ctx;
	return &child_frame;
}

static void
test_subframe_push_pop(void)
{
	struct tb t = {0};
	struct ui_field parent_fields[] = {
		{ .label = "Exits", .key = "exits", .type = UI_SUBFRAME,
		  .open_child = open_child },
	};
	struct ui_frame frame = { .title = "Parent", .fields = parent_fields,
		.nr_fields = 1, .action_mask = MASK, .binding = &t };
	struct ui_session *s;

	child_frame = (struct ui_frame){ .title = "Child", .nr_fields = 0,
		.action_mask = UI_A(UI_ACT_QUIT) };

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	check("start at depth 1", s->depth == 1);
	ui_input_line(s, "1");			/* enter subframe -> push */
	check("subframe pushed to depth 2", s->depth == 2);
	check("top is the child", ui_top(s) == &child_frame);
	ui_input_line(s, "q");			/* quit child -> pop */
	check("popped back to depth 1", s->depth == 1);
	check("top is the parent again", ui_top(s) == &frame);
	ui_session_free(s);
}

static void
test_discard(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "Name", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "T", .fields = fields, .nr_fields = 1,
		.action_mask = MASK | UI_A(UI_ACT_DISCARD), .binding = &t,
		.on_cancel = tb_cancel };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	ui_input_line(s, "1 draft");
	ui_input_line(s, "x");			/* Discard */
	check("discard ran on_cancel", t.cancel_calls == 1);
	check("discard popped the frame", s->depth == 0);
	ui_session_free(s);
}

static void
test_wizard(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "A", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set, .validate = reject_bad },
		{ .label = "B", .key = "mood", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "W", .fields = fields, .nr_fields = 2,
		.action_mask = MASK, .wizard = 1, .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	check("wizard auto-enters the first field", R.enter == 1);

	ui_input_line(s, "bad");		/* rejected -> re-prompt same */
	check("wizard re-prompts on validation failure",
		R.enter == 2 && s->cursor == 0 && t.name[0] == '\0');

	ui_input_line(s, "alpha");		/* ok -> advance to field 1 */
	check("first field set after retry", strcmp(t.name, "alpha") == 0);
	check("wizard advanced to the second field", R.enter == 3);

	ui_input_line(s, "beta");		/* last field -> browsing */
	check("second field set", strcmp(t.mood, "beta") == 0);
	check("wizard ends in browsing mode", s->mode == UI_MODE_BROWSING);

	ui_session_free(s);
}

static void
test_wizard_skip(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "A", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
		{ .label = "RO", .key = "pass", .type = UI_STRING,
		  .flags = UI_F_READONLY, .get = tb_get },	/* skipped */
		{ .label = "B", .key = "mood", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "W", .fields = fields, .nr_fields = 3,
		.action_mask = MASK, .wizard = 1, .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	check("wizard starts at first editable field",
		R.enter == 1 && s->cursor == 0);
	ui_input_line(s, "one");		/* advance skips the read-only field */
	check("wizard skips read-only to the next editable",
		s->cursor == 2 && R.enter == 2);
	ui_input_line(s, "");			/* empty advances (optional), to end */
	check("empty on last field ends the wizard",
		s->mode == UI_MODE_BROWSING && strcmp(t.name, "one") == 0);
	ui_session_free(s);
}

/* A UI_BOOL field inside the step wizard prompts yes/no and advances, rather
 * than auto-toggling and desyncing the walk. Browse-mode toggle-on-select is
 * covered by test_enum_and_bool. */
static void
test_wizard_bool(void)
{
	struct tb t = {0};
	struct ui_field fields[] = {
		{ .label = "A", .key = "name", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
		{ .label = "Fixed", .key = "flag", .type = UI_BOOL,
		  .get = tb_get, .set = tb_set },
		{ .label = "C", .key = "mood", .type = UI_STRING,
		  .get = tb_get, .set = tb_set },
	};
	struct ui_frame frame = { .title = "W", .fields = fields, .nr_fields = 3,
		.action_mask = MASK, .wizard = 1, .binding = &t };
	struct ui_session *s;

	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);

	ui_input_line(s, "alpha");		/* set A -> advance to the bool */
	check("wizard prompts the bool, no auto-toggle",
		s->cursor == 1 && R.enter == 2 && t.flag[0] == '\0');

	ui_input_line(s, "garbage");		/* not yes/no -> stays put */
	check("bad bool answer rejected",
		s->cursor == 1 && t.flag[0] == '\0');

	ui_input_line(s, "yes");		/* answer -> set and advance */
	check("bool set from the prompt", strcmp(t.flag, "yes") == 0);
	check("wizard advanced past the bool",
		s->cursor == 2 && R.enter == 3);

	ui_input_line(s, "beta");		/* last field -> browsing */
	check("wizard with a bool completed",
		s->mode == UI_MODE_BROWSING && strcmp(t.mood, "beta") == 0);

	ui_session_free(s);
}

/* --- on_change / ui_fields_rebuilt: type-dependent fields ------------ */

/* A static fields buffer so the on_change handler can rebuild it in place
 * (no realloc, no move), the way @oedit rebuilds from `type`. */
static struct ui_field oc_fields[3];
static void oc_changed(struct ui_session *s, void *binding);

/* Mood at index 0 (with on_change); a "Rage" field appears only when the mood
 * is "angry"; Name last. The edited field (Mood) keeps its index. */
static unsigned
oc_build(struct tb *t)
{
	unsigned n = 0;

	oc_fields[n++] = (struct ui_field){ .label = "Mood", .key = "mood",
		.type = UI_ENUM, .choices = moods, .nr_choices = 3,
		.get = tb_get, .set = tb_set, .on_change = oc_changed };
	if (!strcmp(t->mood, "angry"))
		oc_fields[n++] = (struct ui_field){ .label = "Rage",
			.key = "flag", .type = UI_STRING,
			.get = tb_get, .set = tb_set };
	oc_fields[n++] = (struct ui_field){ .label = "Name", .key = "name",
		.type = UI_STRING, .get = tb_get, .set = tb_set };
	return n;
}

static void
oc_changed(struct ui_session *s, void *binding)
{
	ui_fields_rebuilt(s, oc_build(binding));
}

static void
test_on_change(void)
{
	struct tb t = {0};
	struct ui_frame frame = { .title = "OC", .fields = oc_fields,
		.nr_fields = 0, .action_mask = MASK, .binding = &t };
	struct ui_session *s;

	frame.nr_fields = oc_build(&t);		/* mood empty: Mood + Name */
	reset_r();
	s = ui_session_new(&MR, NULL, NULL, &frame);
	check("on_change: two fields initially", ui_top(s)->nr_fields == 2);

	ui_input_line(s, "1");			/* enter Mood */
	ui_input_line(s, "2");			/* choice 2 = angry */
	check("on_change: value applied", strcmp(t.mood, "angry") == 0);
	check("on_change: field revealed live", ui_top(s)->nr_fields == 3);
	check("on_change: revealed field is Rage",
		strcmp(oc_fields[1].label, "Rage") == 0);
	check("on_change: edited field kept its index",
		strcmp(oc_fields[0].label, "Mood") == 0);

	ui_input_line(s, "1");			/* enter Mood again */
	ui_input_line(s, "1");			/* choice 1 = calm */
	check("on_change: value changed", strcmp(t.mood, "calm") == 0);
	check("on_change: field hidden again", ui_top(s)->nr_fields == 2);
	check("on_change: cursor still in range", 1);

	ui_session_free(s);
}

int
main(void)
{
	test_inline_and_enter();
	test_wizard();
	test_wizard_skip();
	test_discard();
	test_validation();
	test_required_and_submit();
	test_submit_reject_keeps_frame();
	test_enum_and_bool();
	test_dispatch_edges();
	test_readonly();
	test_subframe_push_pop();
	test_wizard_bool();
	test_on_change();
	return ctest_report("test_ui");
}
