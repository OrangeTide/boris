/* ui.c : interactive UI layer controller (doc/ui-layer-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "ui.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void wizard_start(struct ui_session *s);
static void finish_edit(struct ui_session *s, int retry);

/* --- action <-> key table (spec 6) ----------------------------------- */

static const struct {
	char key;
	const char *name;
} ui_actions[UI_ACT_COUNT] = {
	[UI_ACT_NEXT]    = { 'n', "Next" },
	[UI_ACT_PREV]    = { 'p', "Prev" },
	[UI_ACT_SUBMIT]  = { 's', "Submit" },
	[UI_ACT_UNDO]    = { 'u', "Undo" },
	[UI_ACT_REFRESH] = { 'r', "Refresh" },
	[UI_ACT_LIST]    = { 'l', "List" },
	[UI_ACT_QUIT]    = { 'q', "Quit" },
	[UI_ACT_DISCARD] = { 'x', "Discard" },
	[UI_ACT_HELP]    = { '?', "Help" },
};

char
ui_action_key(enum ui_action a)
{
	return a < UI_ACT_COUNT ? ui_actions[a].key : '\0';
}

const char *
ui_action_name(enum ui_action a)
{
	return a < UI_ACT_COUNT ? ui_actions[a].name : "";
}

/* Reserved action for a typed key, or -1 if none. */
static int
action_for_key(char c)
{
	unsigned i;

	c = (char)tolower((unsigned char)c);
	for (i = 0; i < UI_ACT_COUNT; i++)
		if (ui_actions[i].key == c)
			return (int)i;
	return -1;
}

/* --- small helpers --------------------------------------------------- */

struct ui_frame *
ui_top(struct ui_session *s)
{
	return (s && s->depth) ? s->stack[s->depth - 1] : NULL;
}

static void
draw(struct ui_session *s)
{
	struct ui_frame *f = ui_top(s);

	if (f && s->renderer && s->renderer->render)
		s->renderer->render(s, f);
}

static void
notify(struct ui_session *s, const char *text)
{
	if (s->renderer && s->renderer->notify)
		s->renderer->notify(s, text);
}

int
ui_field_get(struct ui_session *s, unsigned idx, char *buf, size_t buflen)
{
	struct ui_frame *f = ui_top(s);

	if (!f || idx >= f->nr_fields || !f->fields[idx].get)
		return -1;
	return f->fields[idx].get(f->binding, f->fields[idx].key, buf, buflen);
}

/* Nonzero if the field is empty (get returns nothing). */
static int
field_empty(struct ui_frame *f, unsigned idx)
{
	char buf[UI_VALUE_MAX];
	int n;

	if (!f->fields[idx].get)
		return 1;
	n = f->fields[idx].get(f->binding, f->fields[idx].key, buf, sizeof buf);
	return n <= 0 || buf[0] == '\0';
}

/* Validate then set a field's value. Returns 0 on success. */
static int
set_value(struct ui_session *s, struct ui_field *fld, const char *value)
{
	if ((fld->flags & UI_F_READONLY) || !fld->set) {
		notify(s, "That field cannot be edited.");
		return -1;
	}
	if (fld->validate) {
		const char *err = NULL;
		if (fld->validate(ui_top(s)->binding, value, &err) != 0) {
			notify(s, err ? err : "Invalid value.");
			return -1;
		}
	}
	if (fld->set(ui_top(s)->binding, fld->key, value) != 0) {
		notify(s, "Could not set that value.");
		return -1;
	}
	s->dirty = 1;
	/* let the change refresh the frame (e.g. reveal type-dependent fields).
	 * Callers use s->cursor, not fld, after set_value, and a rebuild is
	 * in place, so fld stays valid. */
	if (fld->on_change)
		fld->on_change(s, ui_top(s)->binding);
	return 0;
}

/* --- lifecycle ------------------------------------------------------- */

int
ui_push(struct ui_session *s, struct ui_frame *child)
{
	if (!s || !child)
		return -1;
	if (s->depth >= UI_MAX_DEPTH)
		return -1;
	s->stack[s->depth++] = child;
	s->cursor = 0;
	s->mode = UI_MODE_BROWSING;
	draw(s);
	wizard_start(s);
	return 0;
}

void
ui_pop(struct ui_session *s)
{
	struct ui_frame *f;

	if (!s || s->depth == 0)
		return;
	f = s->stack[--s->depth];
	if (f->free)
		f->free(f);
	s->cursor = 0;
	s->mode = UI_MODE_BROWSING;
	if (s->depth == 0) {
		if (s->on_close && s->cl)
			s->on_close(s->cl);
		return;
	}
	draw(s);
}

void
ui_swap_top(struct ui_session *s, struct ui_frame *fresh)
{
	struct ui_frame *old;

	if (!s || !s->depth || !fresh)
		return;
	old = s->stack[s->depth - 1];
	if (old->free)
		old->free(old);
	s->stack[s->depth - 1] = fresh;
	s->cursor = 0;
	s->mode = UI_MODE_BROWSING;
	draw(s);
	wizard_start(s);
}

void
ui_fields_rebuilt(struct ui_session *s, unsigned nr_fields)
{
	struct ui_frame *f = ui_top(s);

	if (!f)
		return;
	f->nr_fields = nr_fields;
	/* keep the cursor addressable if the set shrank; the normal edit flow
	 * (finish_edit / draw) renders the refreshed frame afterward. */
	if (nr_fields == 0)
		s->cursor = 0;
	else if (s->cursor >= nr_fields)
		s->cursor = nr_fields - 1;
}

struct ui_session *
ui_session_new(const struct ui_renderer *renderer, struct descriptor_data *cl,
	void (*on_close)(struct descriptor_data *cl), struct ui_frame *frame)
{
	struct ui_session *s;

	if (!renderer || !frame)
		return NULL;
	s = calloc(1, sizeof *s);
	if (!s)
		return NULL;
	s->renderer = renderer;
	s->cl = cl;
	s->on_close = on_close;
	s->mode = UI_MODE_BROWSING;
	if (renderer->open)
		s->render_ctx = renderer->open(cl);
	s->stack[s->depth++] = frame;
	draw(s);
	wizard_start(s);
	return s;
}

void
ui_session_free(struct ui_session *s)
{
	if (!s)
		return;
	/* pop every frame through its free hook; run no user callbacks */
	while (s->depth)
		if (s->stack[--s->depth]->free)
			s->stack[s->depth]->free(s->stack[s->depth]);
	if (s->renderer && s->renderer->close)
		s->renderer->close(s->render_ctx);
	free(s);
}

/* --- actions --------------------------------------------------------- */

static void
do_submit(struct ui_session *s)
{
	struct ui_frame *f = ui_top(s);
	unsigned i;

	for (i = 0; i < f->nr_fields; i++) {
		if ((f->fields[i].flags & UI_F_REQUIRED) && field_empty(f, i)) {
			char msg[128];
			snprintf(msg, sizeof msg, "\"%s\" is required.",
				f->fields[i].label ? f->fields[i].label : "field");
			notify(s, msg);
			return;
		}
	}
	if (f->on_submit) {
		if (f->on_submit(s, f->binding) == 0)
			ui_pop(s);	/* accepted */
		/* -1: stay open, error already shown by on_submit */
	} else {
		ui_pop(s);
	}
}

static void
run_action(struct ui_session *s, enum ui_action a)
{
	struct ui_frame *f = ui_top(s);

	switch (a) {
	case UI_ACT_NEXT:
		if (f->nr_fields)
			s->cursor = (s->cursor + 1) % f->nr_fields;
		draw(s);
		break;
	case UI_ACT_PREV:
		if (f->nr_fields)
			s->cursor = (s->cursor + f->nr_fields - 1) % f->nr_fields;
		draw(s);
		break;
	case UI_ACT_REFRESH:
	case UI_ACT_LIST:	/* generated-list paging is a later step */
		draw(s);
		break;
	case UI_ACT_HELP:
		notify(s, "Numbers pick a field; letters run actions.");
		break;
	case UI_ACT_UNDO:	/* baseline-backed undo lands with the OBJ binding */
		notify(s, "Nothing to undo.");
		break;
	case UI_ACT_SUBMIT:
		do_submit(s);
		break;
	case UI_ACT_QUIT:
		ui_pop(s);
		break;
	case UI_ACT_DISCARD:
		if (f->on_cancel)
			f->on_cancel(s, f->binding);
		ui_pop(s);
		break;
	default:
		break;
	}
}

/* --- entering a field ------------------------------------------------ */

static void
toggle_bool(struct ui_session *s, struct ui_field *fld)
{
	char buf[UI_VALUE_MAX];
	int n = fld->get ? fld->get(ui_top(s)->binding, fld->key, buf, sizeof buf) : -1;
	int on = (n > 0 && (buf[0] == 'y' || buf[0] == 'Y' || buf[0] == '1'));

	set_value(s, fld, on ? "no" : "yes");
	draw(s);
}

/* Edit a field as one prompted line (the renderer prints the prompt; the
 * value arrives on the next input line via handle_edit_input). */
static void
enter_field_line(struct ui_session *s, const struct ui_field *fld)
{
	s->mode = UI_MODE_EDITING;
	if (s->renderer && s->renderer->enter_field)
		s->renderer->enter_field(s, fld);
}

static void
enter_field(struct ui_session *s, unsigned idx, int in_wizard)
{
	struct ui_frame *f = ui_top(s);
	struct ui_field *fld = &f->fields[idx];

	if (fld->flags & UI_F_READONLY) {
		notify(s, "That field cannot be edited.");
		return;
	}
	/* record the selected row so on_select / open_child can find their own
	 * field via ui_top(s)->fields[s->cursor]. */
	s->cursor = idx;
	switch (fld->type) {
	case UI_ACTION:
		/* on_select may end the session; touch nothing afterwards. */
		if (fld->on_select)
			fld->on_select(s, f->binding);
		return;
	case UI_SUBFRAME:
		if (fld->open_child) {
			struct ui_frame *child = fld->open_child(s, f->binding);
			if (child)
				ui_push(s, child);
		}
		return;
	case UI_BOOL:
		if (!fld->set) {
			notify(s, "That field cannot be edited.");
			return;
		}
		/* Browse: toggle on select (quick). Wizard: prompt yes/no like any
		 * other field, so the walk waits for input and advances. */
		if (in_wizard)
			enter_field_line(s, fld);
		else
			toggle_bool(s, fld);
		return;
	case UI_TEXT:
		if (!fld->set) {
			notify(s, "That field cannot be edited.");
			return;
		}
		/* hand long text to the renderer's rich editor if it has one;
		 * it resumes through ui_text_result. Otherwise edit one line. */
		if (s->renderer && s->renderer->edit_text) {
			s->mode = UI_MODE_SUSPENDED;
			s->renderer->edit_text(s, fld);
		} else {
			enter_field_line(s, fld);
		}
		return;
	case UI_STRING:
	case UI_OBJREF:
	case UI_INT:
	case UI_ENUM:
		if (!fld->set) {
			notify(s, "That field cannot be edited.");
			return;
		}
		enter_field_line(s, fld);
		return;
	}
}

/* Apply the result of an out-of-band UI_TEXT edit and resume (spec 7). */
void
ui_text_result(struct ui_session *s, const char *result, int changed)
{
	struct ui_frame *f = ui_top(s);
	int retry = 0;

	if (!f || s->cursor >= f->nr_fields)
		return;
	if (changed)
		retry = set_value(s, &f->fields[s->cursor], result) != 0;
	finish_edit(s, retry);
}

/* A field the wizard stops on: editable, and not an action or subframe. */
static int
field_editable(const struct ui_field *f)
{
	if (f->flags & UI_F_READONLY)
		return 0;
	if (f->type == UI_ACTION || f->type == UI_SUBFRAME)
		return 0;
	return f->set != NULL;
}

/* Index of the next editable field at or after `from`, else nr_fields. */
static unsigned
next_editable(struct ui_frame *f, unsigned from)
{
	while (from < f->nr_fields && !field_editable(&f->fields[from]))
		from++;
	return from;
}

/*
 * Finish editing the current field. retry (a validation failure) re-prompts
 * the same field in a wizard. Otherwise a wizard advances to the next
 * editable field (skipping read-only/action/subframe rows), the last one
 * falling through to browsing so the user can Submit. Outside a wizard,
 * editing returns to browsing. An empty line is not a retry -- it leaves an
 * optional field unchanged and advances.
 */
static void
finish_edit(struct ui_session *s, int retry)
{
	struct ui_frame *f = ui_top(s);

	if (f->wizard) {
		unsigned next;

		if (retry) {			/* validation failed: re-prompt */
			enter_field(s, s->cursor, 1);
			return;
		}
		next = next_editable(f, s->cursor + 1);
		if (next < f->nr_fields) {
			enter_field(s, next, 1);
			return;
		}
		/* no more editable fields: fall through to browsing */
	}
	s->mode = UI_MODE_BROWSING;
	draw(s);
}

/* If the top frame is a wizard, start prompting at its first editable field. */
static void
wizard_start(struct ui_session *s)
{
	struct ui_frame *f = ui_top(s);
	unsigned i;

	if (f && f->wizard) {
		i = next_editable(f, 0);
		if (i < f->nr_fields)
			enter_field(s, i, 1);
	}
}

/* Handle an input line while a field is being edited (spec 7). */
static void
handle_edit_input(struct ui_session *s, const char *line)
{
	struct ui_frame *f = ui_top(s);
	struct ui_field *fld = &f->fields[s->cursor];

	if (fld->type == UI_BOOL) {
		char c = line[0];

		if (!c) {			/* empty: leave unchanged, advance */
			finish_edit(s, 0);
			return;
		}
		if (c == 'y' || c == 'Y' || c == '1' || c == 't' || c == 'T')
			finish_edit(s, set_value(s, fld, "yes") != 0);
		else if (c == 'n' || c == 'N' || c == '0' || c == 'f' || c == 'F')
			finish_edit(s, set_value(s, fld, "no") != 0);
		else
			notify(s, "Answer yes or no.");
		return;
	}

	if (fld->type == UI_ENUM) {
		if (line[0] && isdigit((unsigned char)line[0])) {
			unsigned c = (unsigned)strtoul(line, NULL, 10);
			if (c >= 1 && c <= fld->nr_choices) {
				set_value(s, fld, fld->choices[c - 1]);
				finish_edit(s, 0);
			} else {
				notify(s, "That choice is out of range.");
			}
			return;
		}
		if (line[0]) {
			notify(s, "Pick a choice by number.");
			return;
		}
		finish_edit(s, 0);		/* empty: no change */
		return;
	}

	/* string / text / objref / int: the line is the new value */
	if (line[0])
		finish_edit(s, set_value(s, fld, line) != 0);	/* retry on failure */
	else
		finish_edit(s, 0);		/* empty leaves the field unchanged */
}

/* --- top-level dispatch (spec 6) ------------------------------------- */

void
ui_input_line(struct ui_session *s, const char *line)
{
	struct ui_frame *f;
	const char *p;

	if (!s || !line)
		return;
	f = ui_top(s);
	if (!f)
		return;

	while (*line == ' ' || *line == '\t')
		line++;

	if (s->mode == UI_MODE_EDITING) {
		handle_edit_input(s, line);
		return;
	}
	if (!line[0]) {			/* bare enter: redraw */
		draw(s);
		return;
	}

	if (isdigit((unsigned char)line[0])) {
		unsigned k = (unsigned)strtoul(line, (char **)&p, 10);

		while (*p == ' ' || *p == '\t')
			p++;
		if (k < 1 || k > f->nr_fields) {
			notify(s, "Invalid selection.");
			draw(s);
			return;
		}
		{
			enum ui_type ty = f->fields[k - 1].type;
			if (*p && ty != UI_ACTION && ty != UI_SUBFRAME) {
				set_value(s, &f->fields[k - 1], p);
				draw(s);
			} else {	/* enter row k per its type (browse) */
				enter_field(s, k - 1, 0);
			}
		}
		return;
	}

	{
		int a = action_for_key(line[0]);
		if (a >= 0 && (f->action_mask & UI_A(a)))
			run_action(s, (enum ui_action)a);
		else {
			notify(s, "Invalid selection.");
			draw(s);
		}
	}
}
