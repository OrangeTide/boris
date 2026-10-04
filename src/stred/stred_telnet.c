/* stred_telnet.c : telnetclient wiring for the string editor (spec 3) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "stred.h"
#include <boris.h>
#include "telnetclient.h"

#include <stdio.h>
#include <stdlib.h>

struct stred_session {
	struct stred *ed;
	void (*done)(DESCRIPTOR_DATA *cl, const char *result, int changed, void *ctx);
	void *ctx;
	/* the editor nests inside a suspended state (e.g. a UI session); we
	 * take over state_free for the edit, then chain/restore this so the
	 * outer state is still freed on disconnect and after we resume. */
	void (*outer_free)(DESCRIPTOR_DATA *cl);
};

/* editor output (list, help, messages) goes to the client */
static void
stred_out(void *ctx, const char *text)
{
	telnetclient_printf((DESCRIPTOR_DATA *)ctx, "%s\n", text);
}

/* free-on-disconnect for an in-progress edit */
static void
stred_free_cb(DESCRIPTOR_DATA *cl)
{
	struct stred_session *ss = telnetclient_get_stred(cl);

	if (ss) {
		void (*outer)(DESCRIPTOR_DATA *) = ss->outer_free;

		telnetclient_set_stred(cl, NULL);
		stred_free(ss->ed);
		free(ss);
		if (outer)		/* free the suspended outer state too */
			outer(cl);
	}
}

static void
stred_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	struct stred_session *ss = telnetclient_get_stred(cl);
	enum stred_status st = stred_feed(ss->ed, line);
	char result[STRED_BUF_MAX];
	const char *src;
	int changed;
	void (*done)(DESCRIPTOR_DATA *, const char *, int, void *);
	void (*outer)(DESCRIPTOR_DATA *);
	void *ctx;

	if (st == STRED_CONTINUE)
		return;

	src = (st == STRED_SAVED) ? stred_result(ss->ed) : stred_original(ss->ed);
	changed = (st == STRED_SAVED) ? stred_changed(ss->ed) : 0;
	snprintf(result, sizeof result, "%s", src);
	done = ss->done;
	ctx = ss->ctx;
	outer = ss->outer_free;

	/* Tear our state down first so done() can freely re-install line input
	 * (the suspend/resume bracket). result is a local copy, so ss->ed can go.
	 * Restore the outer state's free hook so it is freed on later disconnect. */
	telnetclient_set_stred(cl, NULL);
	telnetclient_set_state_free(cl, outer);
	stred_free(ss->ed);
	free(ss);

	done(cl, result, changed, ctx);
}

void
stred_start(DESCRIPTOR_DATA *cl, const char *current, enum stred_mode mode,
	void (*done)(DESCRIPTOR_DATA *cl, const char *result, int changed, void *ctx),
	void *ctx)
{
	struct stred_session *ss = calloc(1, sizeof *ss);

	if (!ss) {
		done(cl, current ? current : "", 0, ctx);
		return;
	}
	ss->ed = stred_new(current, mode, stred_out, cl);
	ss->done = done;
	ss->ctx = ctx;
	ss->outer_free = telnetclient_get_state_free(cl);
	if (!ss->ed) {
		free(ss);
		done(cl, current ? current : "", 0, ctx);
		return;
	}
	telnetclient_set_stred(cl, ss);
	telnetclient_set_state_free(cl, stred_free_cb);

	telnetclient_puts(cl,
		"Enter text. /s saves, /a aborts, /h for help.\n");
	if (current && *current)
		telnetclient_printf(cl, "%s\n", current);
	telnetclient_start_lineinput(cl, stred_lineinput, "] ");
}
