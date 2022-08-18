/**
 * @file command.c
 *
 * Commands and actions
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2020 Jan 05
 *
 * Copyright (c) 2008-2020, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */

#include "command.h"
#include "boris.h"
#include "channel.h"
#include "character.h"
#include "room.h"
#include "comutil.h"
#include "debug.h"
#include "util.h"
#include "eventlog.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/******************************************************************************
 * command - handles the command processing
 ******************************************************************************/

/** action callback to do the "pose" command. */
int
command_do_pose(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "yell" command. */
int
command_do_yell(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in yelling distance");
	telnetclient_printf(cl, "%s yells \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "say" command. */
int
command_do_say(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct channel *ch;
	struct channel_member *exclude_list[1];
	TODO("Get user name");
	telnetclient_printf(cl, "You say \"%s\"\n", arg);
	ch = channel_public(0);
	exclude_list[0] = telnetclient_channel_member(cl); /* don't send message to self. */
	channel_broadcast(ch, exclude_list, 1, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "emote" command. */
int
command_do_emote(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "chsay" command. */
int
command_do_chsay(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("pass the channel name in a way that makes sense");
	TODO("Get user name");
	TODO("Broadcast to everyone in a channel");
	telnetclient_printf(cl, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "quit" command. */
int
command_do_quit(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	/** @todo
	 * the close code needs to change the state so telnetclient_isstate
	 * does not end up being true for a future read?
	 */
	telnetclient_close(cl);

	return 1; /* success */
}

/** action callback to do the "roomget" command. */
int
command_do_roomget(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct room *r;
	char roomnum_str[64];
	unsigned roomnum;
	char attrname[64];
	const char *attrvalue;

	arg = util_getword(arg, roomnum_str, sizeof roomnum_str);
	roomnum = strtoul(roomnum_str, 0, 10); /* TODO: handle errors. */

	arg = util_getword(arg, attrname, sizeof attrname);

	r = room_get(roomnum);

	if (!r) {
		telnetclient_printf(cl, "room \"%s\" not found.\n", roomnum_str);
		return 0;
	}

	attrvalue = room_attr_get(r, attrname);

	if (attrvalue) {
		telnetclient_printf(cl, "room \"%s\" \"%s\" = \"%s\"\n", roomnum_str, attrname, attrvalue);
	} else {
		telnetclient_printf(cl, "room \"%s\" attribute \"%s\" not found.\n", roomnum_str, attrname);
	}

	room_put(r);

	return 1; /* success */
}

/** action callback to do the "char" command. */
int
command_do_character(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct character *ch;
	char act[64];
	char tmp[64];
	unsigned ch_id;

	assert(arg != NULL);

	arg = util_getword(arg, act, sizeof act);

	if (!strcasecmp(act, "new")) {
		ch = character_new();
		telnetclient_printf(cl, "Created character %s.\n", character_attr_get(ch, "id"));
		character_put(ch);
	} else if (!strcasecmp(act, "get")) {
		arg = util_getword(arg, tmp, sizeof tmp);
		ch_id = strtoul(tmp, 0, 10); /* TODO: handle errors. */
		ch = character_get(ch_id);

		if (ch) {
			/* get attribute name. */
			arg = util_getword(arg, tmp, sizeof tmp);
			telnetclient_printf(cl, "Character %u \"%s\" = \"%s\"\n", ch_id, tmp, character_attr_get(ch, tmp));
			character_put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", tmp);
		}
	} else if (!strcasecmp(act, "set")) {
		arg = util_getword(arg, tmp, sizeof tmp);
		ch_id = strtoul(tmp, 0, 10); /* TODO: handle errors. */
		ch = character_get(ch_id);

		if (ch) {
			/* get attribute name. */
			arg = util_getword(arg, tmp, sizeof tmp);

			/* find start of value. */
			while (*arg && isspace(*arg)) arg++;

			if (!character_attr_set(ch, tmp, arg)) {
				telnetclient_printf(cl, "Could not set \"%s\" on character %u.\n", tmp, ch_id);
			}

			character_put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", tmp);
		}
	} else {
		telnetclient_printf(cl, "unknown action \"%s\"\n", act);
	}

	return 1; /* success */
}

/** action callback to do the "quit" command. */
int
command_do_time(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	show_gametime(cl);

	return 1; /* success */
}

/** action callback to remote that a command is not implemented. */
static int
command_not_implemented(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	telnetclient_puts(cl, "Not implemented\n");

	return 1; /* success */
}

/** table of every command string and its callback function. */
static const struct command_table {
	char *name; /**< full command name. */
	int (*cb)(struct telnetclient *cl, struct user *u, const char *cmd, const char *arg);
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
	{ "help", command_not_implemented },
	{ "spoof", command_not_implemented },
	{ "roomget", command_do_roomget },
	{ "char", command_do_character },
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
command_run(struct telnetclient *cl, struct user *u, const char *cmd, const char *arg)
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
command_execute(struct telnetclient *cl, struct user *u, const char *line)
{
	char cmd[64];
	const char *e, *arg;
	unsigned i;

	assert(cl != NULL); /** @todo support cl as NULL for silent/offline commands */
	assert(line != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	TODO("Can we eliminate trailing spaces?");

	TODO("can we define these 1 character commands as aliases?");

	if (ispunct(line[0])) {
		for (i = 0; i < NR(command_short_table); i++) {
			const char *shname = command_short_table[i].shname;
			int shname_len = strlen(shname);

			if (!strncmp(line, shname, shname_len)) {
				/* find start of arguments, after the short command. */
				arg = line + shname_len;

				/* ignore leading spaces */
				while (*arg && isspace(*arg)) arg++;

				/* use the name as the cmd. */
				return command_run(cl, u, command_short_table[i].name, arg);
			}
		}
	}

	/* copy the first word into cmd[] */
	e = line + strcspn(line, " \t");
	arg = *e ? e + 1 + strspn(e + 1, " \t") : e; /* point to where the args start */

	while (*arg && isspace(*arg)) arg++; /* ignore leading spaces */

	assert(e >= line);

	if ((unsigned)(e - line) > sizeof cmd - 1) { /* first word is too long */
		DEBUG("Command length %td is too long, truncating\n", e - line);
		e = line + sizeof cmd - 1;
	}

	memcpy(cmd, line, (unsigned)(e - line));
	cmd[e - line] = 0;

	TODO("check for \"playername,\" syntax for directed speech");

	TODO("check user aliases");

	DEBUG("cmd=\"%s\"\n", cmd);

	return command_run(cl, u, cmd, arg);
}

/** callback to process line input. */
static void
command_lineinput(struct telnetclient *cl, const char *line)
{
	assert(cl != NULL);
	DEBUG("%s:entered command '%s'\n", telnetclient_username(cl), line);

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
command_start_lineinput(struct telnetclient *cl)
{
	const struct terminal *term = telnetclient_get_terminal(cl);

	telnetclient_printf(cl, "Terminal type: %s\n", term->name);
	telnetclient_printf(cl, "display size is: %ux%u\n", term->width, term->height);

	show_gametime(cl);

	telnetclient_start_lineinput(cl, command_lineinput, mud_config.command_prompt);
}

/** wrapper callback for a menuitem to start command mode. */
void
command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	command_start_lineinput(p);
}
