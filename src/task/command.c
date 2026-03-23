/**
 * @file command.c
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
#include <comutil.h>
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

/** action callback to do the "pose" command. */
int
command_do_pose(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	LOG_TODO("Get user name");
	LOG_TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "yell" command. */
int
command_do_yell(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	LOG_TODO("Get user name");
	LOG_TODO("Broadcast to everyone in yelling distance");
	telnetclient_printf(cl, "%s yells \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "say" command. */
int
command_do_say(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct channel *ch;
	struct channel_member *exclude_list[1];
	LOG_TODO("Get user name");
	telnetclient_printf(cl, "You say \"%s\"\n", arg);
	ch = channel_public(0);
	exclude_list[0] = telnetclient_channel_member(cl); /* don't send message to self. */
	channel_broadcast(ch, exclude_list, 1, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "emote" command. */
int
command_do_emote(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	LOG_TODO("Get user name");
	LOG_TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "chsay" command. */
int
command_do_chsay(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	LOG_TODO("pass the channel name in a way that makes sense");
	LOG_TODO("Get user name");
	LOG_TODO("Broadcast to everyone in a channel");
	telnetclient_printf(cl, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "quit" command. */
int
command_do_quit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
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
command_do_roomget(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct room *r;
	char roomnum_str[64];
	char attrname[64];
	const char *attrvalue;

	arg = util_getword(arg, roomnum_str, sizeof roomnum_str);
	arg = util_getword(arg, attrname, sizeof attrname);

	r = room_get(roomnum_str);

	if (!arg) {
		telnetclient_printf(cl, "usage: roomget <roomnum> <attrname>\n");
		return 0;
	}

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
command_do_character(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct character *ch;
	char act[64];

	assert(arg != NULL);

	arg = util_getword(arg, act, sizeof(act));
	if (!arg) {
		telnetclient_printf(cl, "usage: char [new | get | set]\n");
		return 0;
	}

	if (!strcasecmp(act, "new")) {
		ch = character_new();
		telnetclient_printf(cl, "Created character %s.\n", character_attr_get(ch, "id"));
		character_put(ch);
	} else if (!strcasecmp(act, "get")) {
		char ch_id_str[64];
		char attr_str[64];
		unsigned ch_id;
		char *endptr;

		arg = util_getword(arg, ch_id_str, sizeof(ch_id_str));
		arg = util_getword(arg, attr_str, sizeof(attr_str));
		if (!arg) {
			telnetclient_printf(cl, "usage: char get <character-id> <attribute>\n");
			return 0;
		}

		ch_id = strtoul(ch_id_str, &endptr, 10);
		if (*endptr != '\0') {
			telnetclient_printf(cl, "Invalid character id \"%s\"\n", ch_id_str);
			return 0;
		}
		ch = character_get(ch_id);

		if (ch) {
			telnetclient_printf(cl, "Character %u \"%s\" = \"%s\"\n", ch_id, attr_str, character_attr_get(ch, attr_str));
			character_put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", ch_id_str);
		}
	} else if (!strcasecmp(act, "set")) {
		char ch_id_str[64];
		char attr_str[64];
		unsigned ch_id;
		char *endptr;

		arg = util_getword(arg, ch_id_str, sizeof ch_id_str);
		arg = util_getword(arg, attr_str, sizeof attr_str);

		/* skip over leading space to find start of value. */
		if (arg) {
			while (isspace(*arg))
				arg++;
		}

		if (!arg || !*arg) {
			telnetclient_printf(cl, "usage: char set <character-id> <attribute> <value>\n");
			return 0;
		}

		ch_id = strtoul(ch_id_str, &endptr, 10);
		if (*endptr != '\0') {
			telnetclient_printf(cl, "Invalid character id \"%s\"\n", ch_id_str);
			return 0;
		}
		ch = character_get(ch_id);

		if (ch) {
			if (!character_attr_set(ch, attr_str, arg)) {
				telnetclient_printf(cl, "Could not set \"%s\" on character %u.\n", attr_str, ch_id);
			}

			character_put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", ch_id_str);
		}
	} else {
		telnetclient_printf(cl, "unknown action \"%s\"\n", act);
	}

	return 1; /* success */
}

/** action callback to do the "quit" command. */
int
command_do_time(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	show_gametime(cl);

	return 1; /* success */
}

/** action callback to do the "char" command. */
int
command_do_help(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	char topic[64];

	assert(arg != NULL);

	arg = util_getword(arg, topic, sizeof(topic));
	if (!arg) {
		telnetclient_puts(cl, "usage: help <topic>\n");
		telnetclient_puts(cl, "See 'help commands' for a list of commands.\n");
		telnetclient_puts(cl, "See 'help topics' for a list of help topics.\n");
		return 1;
	}

	if (help_show(cl, topic) != HELP_OK) {
		telnetclient_printf(cl, "unknown help topic \"%s\"\n", topic);
	}

	return 1; /* success */
}

/** display the current room to the player. */
static void
show_room(DESCRIPTOR_DATA *cl, struct room *r)
{
	const char *name, *desc;

	name = room_attr_get(r, "name.short");
	if (name)
		telnetclient_printf(cl, "%s\n", name);

	desc = room_attr_get(r, "desc.long");
	if (!desc)
		desc = room_attr_get(r, "desc.short");
	if (desc)
		telnetclient_printf(cl, "%s\n", desc);

	/* list exits */
	telnetclient_puts(cl, "Exits:");
	{
		const char *dirs[] = {
			"n", "north", "s", "south", "e", "east",
			"w", "west", "u", "up", "d", "down",
			"ne", "northeast", "nw", "northwest",
			"se", "southeast", "sw", "southwest",
			"enter", NULL
		};
		char exitname[64];
		int found = 0;
		unsigned i;

		for (i = 0; dirs[i]; i++) {
			snprintf(exitname, sizeof exitname, "exit.%s", dirs[i]);
			if (room_attr_get(r, exitname)) {
				telnetclient_printf(cl, " %s", dirs[i]);
				found = 1;
			}
		}

		if (!found)
			telnetclient_puts(cl, " none");
		telnetclient_puts(cl, "\n");
	}
}

/** action callback to do the "look" command. */
int
command_do_look(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	struct character *ch;
	struct room *r;
	const char *room_id;

	ch = telnetclient_character(cl);
	if (!ch) {
		telnetclient_puts(cl, "You have no character.\n");
		return 0;
	}

	room_id = character_attr_get(ch, "room.current");
	if (!room_id) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}

	r = room_get(room_id);
	if (!r) {
		telnetclient_printf(cl, "You are in an invalid room \"%s\".\n", room_id);
		return 0;
	}

	show_room(cl, r);
	room_put(r);
	return 1;
}

/** direction aliases mapping full names to short exit keys. */
static const struct {
	const char *name;
	const char *exit_key;
} direction_aliases[] = {
	{ "north", "n" },
	{ "south", "s" },
	{ "east", "e" },
	{ "west", "w" },
	{ "up", "u" },
	{ "down", "d" },
	{ "northeast", "ne" },
	{ "northwest", "nw" },
	{ "southeast", "se" },
	{ "southwest", "sw" },
	{ "n", "n" },
	{ "s", "s" },
	{ "e", "e" },
	{ "w", "w" },
	{ "u", "u" },
	{ "d", "d" },
	{ "ne", "ne" },
	{ "nw", "nw" },
	{ "se", "se" },
	{ "sw", "sw" },
};

/**
 * move the player through an exit.
 * exit_name is the exit to look for (e.g. "n", "enter").
 * returns 1 on success, 0 on failure.
 */
static int
do_move(DESCRIPTOR_DATA *cl, const char *exit_name)
{
	struct character *ch;
	struct room *r;
	const char *room_id, *dest;
	char exitkey[64];
	unsigned i;

	ch = telnetclient_character(cl);
	if (!ch) {
		telnetclient_puts(cl, "You have no character.\n");
		return 0;
	}

	room_id = character_attr_get(ch, "room.current");
	if (!room_id) {
		telnetclient_puts(cl, "You are nowhere.\n");
		return 0;
	}

	r = room_get(room_id);
	if (!r) {
		telnetclient_printf(cl, "You are in an invalid room \"%s\".\n", room_id);
		return 0;
	}

	/* resolve direction aliases to short exit keys */
	for (i = 0; i < NR(direction_aliases); i++) {
		if (!strcasecmp(exit_name, direction_aliases[i].name)) {
			exit_name = direction_aliases[i].exit_key;
			break;
		}
	}

	snprintf(exitkey, sizeof exitkey, "exit.%s", exit_name);
	dest = room_attr_get(r, exitkey);
	room_put(r);

	if (!dest) {
		telnetclient_puts(cl, "You can't go that way.\n");
		return 0;
	}

	/* verify destination exists */
	r = room_get(dest);
	if (!r) {
		telnetclient_printf(cl, "That exit leads nowhere (\"%s\").\n", dest);
		return 0;
	}

	/* move the character */
	character_attr_set(ch, "room.current", dest);
	show_room(cl, r);
	room_put(r);
	return 1;
}

/** action callback to do the "go" command. */
int
command_do_go(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	char dir[64];

	arg = util_getword(arg, dir, sizeof dir);
	if (!arg) {
		telnetclient_puts(cl, "Go where?\n");
		return 0;
	}

	return do_move(cl, dir);
}

/**
 * action callback for direction commands (north, south, etc.).
 * the command name itself is the direction.
 */
int
command_do_direction(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd, const char *arg UNUSED)
{
	return do_move(cl, cmd);
}

/** action callback to do the "enter" command. */
int
command_do_enter(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	char dir[64];

	arg = util_getword(arg, dir, sizeof dir);
	if (!arg) {
		/* no argument -- check if an "enter" exit exists */
		struct character *ch = telnetclient_character(cl);
		const char *room_id;
		struct room *r;

		if (!ch) {
			telnetclient_puts(cl, "You have no character.\n");
			return 0;
		}

		room_id = character_attr_get(ch, "room.current");
		if (!room_id) {
			telnetclient_puts(cl, "You are nowhere.\n");
			return 0;
		}

		r = room_get(room_id);
		if (r) {
			const char *dest = room_attr_get(r, "exit.enter");
			room_put(r);
			if (dest)
				return do_move(cl, "enter");
		}

		telnetclient_puts(cl, "Enter where?\n");
		return 0;
	}

	return do_move(cl, dir);
}

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
