/* run.c : @run -- launch a program as an interactive foreground session.
 *
 * `@run <prog> [args]` starts the program object programs/<prog> as a
 * foreground VM task bound to the player's descriptor. The player's typed lines
 * are fed to the program's stdin and its stdout is written back to the player,
 * so an interactive utility or REPL can read and write a line at a time. The
 * task is stepped on the server heartbeat (verb_fg_tick), not run to completion
 * inside this call, which is what lets it span the player's later input.
 *
 * A lone "~." detaches: it closes the program's stdin (so a blocking read sees
 * end of file) and, if the program does not exit on its own next tick, kills
 * it. Wizard only for now; interactive programs are powerful and this is the
 * first surface for them.
 *
 * This follows the stred/@fedit pattern: capture cl->line_input, hang a session
 * off the descriptor, swap state_free so a disconnect tears the task down, and
 * command_resume() when the program ends. */

#include "command.h"
#include <boris.h>
#include <user.h>
#include <telnetclient.h>
#include <util.h>
#include <character.h>

#include <verb_dispatch.h>

#include <stdlib.h>
#include <string.h>

#define FG_RUN_MAX_ARGS 8               /* argv[0] plus up to this many words */
#define FG_RUN_SENTINEL "~."            /* a lone line that detaches the session */
#define FG_LINE_MAX     512             /* a line of guest I/O */

/* Carried on the descriptor for the life of the session. The session id routes
 * feed/quit/close to the VM task; outer_free is the descriptor's prior cleanup
 * hook, restored on exit and chained on disconnect (the stred pattern). */
struct fg_session {
	uint32_t id;
	void (*outer_free)(DESCRIPTOR_DATA *cl);
};

/* verb_fg output hook: a line of the program's stdout, written as-is (the VM
 * delivers whole lines, newline included; a final partial line has none). */
static void
fg_output(void *ctx, const char *buf, size_t len)
{
	DESCRIPTOR_DATA *cl = ctx;
	char line[FG_LINE_MAX];

	if (len >= sizeof line)
		len = sizeof line - 1;
	memcpy(line, buf, len);
	line[len] = '\0';
	telnetclient_puts(cl, line);
}

/* verb_fg exit hook: the program ended (on its own, a fault, or a kill). Tear
 * the session down, restore the outer state_free, and hand input back to the
 * command parser. Fired from the heartbeat, so cl is still a live descriptor. */
static void
fg_exit(void *ctx, int status, int faulted)
{
	DESCRIPTOR_DATA *cl = ctx;
	struct fg_session *fs = telnetclient_get_fg(cl);
	void (*outer)(DESCRIPTOR_DATA *);

	if (!fs)
		return;
	outer = fs->outer_free;
	telnetclient_set_fg(cl, NULL);
	telnetclient_set_state_free(cl, outer);
	free(fs);

	if (faulted)
		telnetclient_puts(cl, "[program ended abnormally]\n");
	else
		telnetclient_printf(cl, "[program exited (%d)]\n", status);
	command_resume(cl);
}

/* Free-on-disconnect: kill the task silently (no exit hook, the descriptor is
 * going away) and chain the outer state's cleanup. */
static void
fg_free_cb(DESCRIPTOR_DATA *cl)
{
	struct fg_session *fs = telnetclient_get_fg(cl);

	if (fs) {
		void (*outer)(DESCRIPTOR_DATA *) = fs->outer_free;

		telnetclient_set_fg(cl, NULL);
		verb_fg_close(fs->id);
		free(fs);
		if (outer)
			outer(cl);
	}
}

/* Every typed line while a session is foreground. The sentinel detaches; any
 * other line is fed to the program's stdin with a terminating newline so a
 * line-reading guest sees a complete line. */
static void
fg_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	struct fg_session *fs = telnetclient_get_fg(cl);
	char buf[FG_LINE_MAX];
	size_t n;

	if (!fs)
		return;
	if (strcmp(line, FG_RUN_SENTINEL) == 0) {
		verb_fg_request_quit(fs->id);
		return;
	}
	n = strlen(line);
	if (n > sizeof buf - 2)
		n = sizeof buf - 2;
	memcpy(buf, line, n);
	buf[n++] = '\n';
	verb_fg_feed(fs->id, buf, (uint32_t)n);
}

int
command_do_run(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char prog[128];
	char words[FG_RUN_MAX_ARGS][128];
	const char *av[FG_RUN_MAX_ARGS + 1];
	const char *actor_id;
	struct fg_session *fs;
	uint32_t id;
	int argc = 0;

	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return 0;
	}

	arg = util_getword(arg, prog, sizeof prog);
	if (!prog[0]) {
		telnetclient_printf(cl, "usage: %s <program> [args]\n", cmd);
		telnetclient_puts(cl,
			"Run a program interactively; a lone ~. line quits it.\n");
		return 0;
	}

	actor_id = character_obj_id(telnetclient_character(cl));
	if (!actor_id) {
		telnetclient_puts(cl, "You have no character to run as.\n");
		return 0;
	}

	av[argc++] = prog;                      /* argv[0] is the program name */
	while (argc <= FG_RUN_MAX_ARGS) {
		char *slot = words[argc - 1];

		arg = util_getword(arg, slot, sizeof words[0]);
		if (!slot[0])
			break;
		av[argc++] = slot;
	}
	av[argc] = NULL;

	fs = calloc(1, sizeof *fs);
	if (!fs) {
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}

	id = verb_fg_launch(prog, actor_id, av, argc, fg_output, fg_exit, cl);
	if (!id) {
		free(fs);
		telnetclient_printf(cl, "Could not run program '%s'.\n", prog);
		return 0;
	}

	fs->id = id;
	fs->outer_free = telnetclient_get_state_free(cl);
	telnetclient_set_fg(cl, fs);
	telnetclient_set_state_free(cl, fg_free_cb);
	telnetclient_printf(cl, "[running %s; ~. to quit]\n", prog);
	telnetclient_start_lineinput(cl, fg_lineinput, "");
	return 1;
}
