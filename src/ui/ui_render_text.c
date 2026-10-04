/* ui_render_text.c : plain TELNET text renderer (doc/ui-layer-spec.md 8.2) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "ui.h"
#include <boris.h>
#include "telnetclient.h"
#include "stred.h"

#include <ctype.h>
#include <stdio.h>

/* Draw the whole frame: title, one numbered line per field with its staged
 * value, and an action line listing the enabled universal actions. */
static void
text_render(struct ui_session *s, const struct ui_frame *f)
{
	DESCRIPTOR_DATA *cl = s->cl;
	char buf[UI_VALUE_MAX];
	char line[256];
	size_t off = 0;
	unsigned i, a;

	telnetclient_printf(cl, "\n== %s ==\n", f->title ? f->title : "");

	for (i = 0; i < f->nr_fields; i++) {
		const struct ui_field *fld = &f->fields[i];
		const char *val;
		char mark = (i == s->cursor) ? '>' : ' ';

		if (fld->flags & UI_F_HIDDEN) {
			val = "<hidden>";
		} else {
			int n = fld->get ? fld->get(f->binding, fld->key, buf,
				sizeof buf) : -1;
			val = (n > 0) ? buf : "";
		}
		telnetclient_printf(cl, " %c%2u) %-16s %s%s\n", mark, i + 1,
			fld->label ? fld->label : fld->key, val,
			(fld->flags & UI_F_READONLY) ? "  (read-only)" : "");
	}

	for (a = 0; a < UI_ACT_COUNT; a++) {
		if (f->action_mask & UI_A(a)) {
			int w = snprintf(line + off, sizeof line - off, "[%c]%s ",
				(char)toupper((unsigned char)ui_action_key(a)),
				ui_action_name(a));
			if (w > 0 && (size_t)w < sizeof line - off)
				off += (size_t)w;
		}
	}
	if (off)
		telnetclient_printf(cl, "%s\n", line);
}

/* Terminal prompt for one field. Enums list their numbered choices. */
static void
text_enter_field(struct ui_session *s, const struct ui_field *fld)
{
	DESCRIPTOR_DATA *cl = s->cl;
	unsigned i;

	if (fld->type == UI_ENUM) {
		telnetclient_printf(cl, "%s -- choose:\n",
			fld->label ? fld->label : fld->key);
		for (i = 0; i < fld->nr_choices; i++)
			telnetclient_printf(cl, "  %u) %s\n", i + 1, fld->choices[i]);
		telnetclient_puts(cl, "> ");
	} else if (fld->type == UI_BOOL) {
		char cur[UI_VALUE_MAX];
		int n = fld->get ? fld->get(ui_top(s)->binding, fld->key,
			cur, sizeof cur) : -1;
		int on = (n > 0 && (cur[0] == 'y' || cur[0] == 'Y' || cur[0] == '1'));

		telnetclient_printf(cl, "%s (yes/no) [%s]: ",
			fld->label ? fld->label : fld->key, on ? "yes" : "no");
	} else {
		telnetclient_printf(cl, "%s: ", fld->label ? fld->label : fld->key);
	}
}

static void
text_notify(struct ui_session *s, const char *text)
{
	telnetclient_printf(s->cl, "%s\n", text);
}

/* string editor finished: apply the value, then resume the UI controller's
 * line input unless it handed off to another out-of-band editor. */
static void
text_edit_text_done(DESCRIPTOR_DATA *cl, const char *result, int changed,
	void *ctx)
{
	struct ui_session *s = ctx;

	ui_text_result(s, result, changed);
	if (s->mode != UI_MODE_SUSPENDED)
		ui_resume_input(cl);
}

/* edit a UI_TEXT field in the online string editor (multi-line). */
static void
text_edit_text(struct ui_session *s, const struct ui_field *f)
{
	char cur[8192];
	int n = f->get ? f->get(ui_top(s)->binding, f->key, cur, sizeof cur) : -1;

	stred_start(s->cl, n > 0 ? cur : "", STRED_MULTI, text_edit_text_done, s);
}

const struct ui_renderer ui_render_text = {
	.name = "text",
	.open = NULL,		/* writes through s->cl; no per-session ctx */
	.close = NULL,
	.render = text_render,
	.enter_field = text_enter_field,
	.edit_text = text_edit_text,
	.notify = text_notify,
};
