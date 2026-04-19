/**
 * @file cmd.c
 *
 * Commands and actions
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "command.h"
#include <boris.h>
#include <channel.h>
#include <character.h>
#include <room.h>
#include <cmdutil.h>
#define LOG_SUBSYSTEM "command"
#include <log.h>
#include <util.h>
#include <eventlog.h>
#include <help.h>

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/******************************************************************************
 * command - handles the command processing
 ******************************************************************************/

/** action callback to remote that a command is not implemented. */
static int
command_not_implemented(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	telnetclient_puts(cl, "Not implemented\n");

	return 1; /* success */
}

/** table of every command string and its callback function. */
static const struct command_table {
	char *name; /**< full command name. */
	int (*cb)(DESCRIPTOR_DATA *cl, struct user *u, const char *cmd, const char *arg);
} command_table[] = {
	{ "who", command_not_implemented },
	{ "quit", command_do_quit },
	{ "page", command_not_implemented },
	{ "say", command_do_say },
	{ "yell", command_do_yell },
	{ "emote", command_do_emote },
	{ "pose", command_do_pose },
	{ "chsay", command_do_chsay },
	{ "sayto", command_not_implemented },
	{ "tell", command_not_implemented },
	{ "time", command_do_time },
	{ "whisper", command_not_implemented },
	{ "to", command_not_implemented },
	{ "help", command_do_help },
	{ "spoof", command_not_implemented },
	{ "look", command_do_look },
	{ "l", command_do_look },
	{ "go", command_do_go },
	{ "enter", command_do_enter },
	{ "north", command_do_direction },
	{ "n", command_do_direction },
	{ "south", command_do_direction },
	{ "s", command_do_direction },
	{ "east", command_do_direction },
	{ "e", command_do_direction },
	{ "west", command_do_direction },
	{ "w", command_do_direction },
	{ "up", command_do_direction },
	{ "down", command_do_direction },
	{ "roomget", command_do_roomget },
	{ "char", command_do_character },
	{ "stat", command_do_stat },
	{ "roll", command_do_roll },
	{ "resist", command_do_resist },
};

/**
 * table of short commands, they must start with a punctuation. ispunct()
 * but they can be more than one character long, the table is first match.
 */
static const struct command_short_table {
	char *shname; /**< short commands. */
	char *name; /**< full command name. */
} command_short_table[] = {
	{ ":", "pose" },
	{ "'", "say" },
	{ "\"\"", "yell" },
	{ "\"", "say" },
	{ ",", "emote" },
	{ ".", "chsay" },
	{ ";", "spoof" },
};

/**
 * use cmd to run a command from the command_table array.
 */
static int
command_run(DESCRIPTOR_DATA *cl, struct user *u, const char *cmd, const char *arg)
{
	unsigned i;

	/* search for a long command. */
	for (i = 0; i < NR(command_table); i++) {
		if (!strcasecmp(cmd, command_table[i].name)) {
			return command_table[i].cb(cl, u, cmd, arg);
		}
	}

	telnetclient_puts(cl, mud_config.msg_invalidcommand);

	return 0; /* failure */
}

/**
 * executes a command for user u.
 */
static int
command_execute(DESCRIPTOR_DATA *cl, struct user *u, const char *line)
{
	char cmd[64];
	const char *e, *arg;
	unsigned i;

	assert(cl != NULL); /** @todo support cl as NULL for silent/offline commands */
	assert(line != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	LOG_TODO("Can we eliminate trailing spaces?");

	LOG_TODO("can we define these 1 character commands as aliases?");

	if (ispunct(line[0])) {
		for (i = 0; i < NR(command_short_table); i++) {
			const char *shname = command_short_table[i].shname;
			int shname_len = strlen(shname);

			if (!strncmp(line, shname, shname_len)) {
				/* find start of arguments, after the short command. */
				arg = line + shname_len;

				/* ignore leading spaces */
				while (isspace(*arg))
					arg++;
				if (!*arg)
					arg = NULL;

				/* use the name as the cmd. */
				return command_run(cl, u, command_short_table[i].name, arg);
			}
		}
	}

	/* copy the first word into cmd[] */
	e = line + strcspn(line, " \t");
	arg = *e ? e + 1 + strspn(e + 1, " \t") : e; /* point to where the args start */

	/* ignore leading spaces */
	while (isspace(*arg))
		arg++;
	if (!*arg)
		arg = NULL;

	assert(e >= line);

	if ((unsigned)(e - line) > sizeof cmd - 1) { /* first word is too long */
		LOG_DEBUG("Command length %td is too long, truncating", e - line);
		e = line + sizeof cmd - 1;
	}

	memcpy(cmd, line, (unsigned)(e - line));
	cmd[e - line] = 0;

	LOG_TODO("check for \"playername,\" syntax for directed speech");

	LOG_TODO("check user aliases");

	LOG_DEBUG("cmd=\"%s\"", cmd);

	return command_run(cl, u, cmd, arg);
}

/** callback to process line input. */
static void
command_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	assert(cl != NULL);
	LOG_DEBUG("%s:entered command '%s'", telnetclient_username(cl), line);

	/* log command input */
	eventlog_commandinput(telnetclient_socket_name(cl), telnetclient_username(cl), line);

	/* do something with the command */
	command_execute(cl, NULL, line); /** @todo pass current user and character */

	/* check if we should update the prompt */
	if (telnetclient_isstate(cl, command_lineinput, mud_config.command_prompt)) {
		telnetclient_setprompt(cl, mud_config.command_prompt);
	}
}

/** start line input mode and send it to command_lineinput. */
static void
command_start_lineinput(DESCRIPTOR_DATA *cl)
{
	struct character *ch;
	const struct terminal *term = telnetclient_get_terminal(cl);

	telnetclient_printf(cl, "Terminal type: %s\n", term->name);
	telnetclient_printf(cl, "display size is: %ux%u\n", term->width, term->height);

	show_gametime(cl);

	/* create a character for this session if we don't have one */
	ch = telnetclient_character(cl);
	if (!ch) {
		ch = character_new();
		if (ch) {
			character_attr_set(ch, "name.short", telnetclient_username(cl));
			character_attr_set(ch, "room.current", mud_config.newuser_room);
			telnetclient_setcharacter(cl, ch);
		}
	}

	/* show the starting room */
	if (ch) {
		const char *room_id = character_attr_get(ch, "room.current");
		if (room_id) {
			struct room *r = room_get(room_id);
			if (r) {
				show_room(cl, r);
				room_put(r);
			}
		}
	}

	telnetclient_start_lineinput(cl, command_lineinput, mud_config.command_prompt);
}

/** wrapper callback for a menuitem to start command mode. */
void
command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	command_start_lineinput(p);
}
