/**
 * @file move.c
 *
 * "Enter", "go", and "direction" commands
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2026, Jon Mayo <jon@rm-f.net>
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
#include "character.h"
#include "cmdutil.h"
#include "room.h"
#include "util.h"
#include <objref.h>
#include <obj_program.h>

#define DIRECTION_STRING_MAX 64

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
	OBJ *r;
	const char *room_id, *dest;
	char dest_buf[OBJ_PATH_MAX];
	char exitkey[DIRECTION_STRING_MAX];
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

	snprintf(exitkey, sizeof exitkey, "exit.%s.to", exit_name);
	dest = obj_prop_get(r, exitkey);
	if (!dest) {
		room_put(r);
		telnetclient_puts(cl, "You can't go that way.\n");
		return 0;
	}
	snprintf(dest_buf, sizeof dest_buf, "%s", dest);
	room_put(r);

	/* check if exit is handled by a script */
	{
		struct objref ref;
		if (objref_parse(dest, ROOM_ROOTDIR, &ref) == 0 &&
		    strcmp(ref.domain, "script") == 0) {
			const char *player_name =
				character_attr_get(ch, "name.short");
			if (obj_program_dispatch_verb(room_id, "go",
			    player_name, exit_name) < 0)
				telnetclient_puts(cl,
				    "The exit doesn't respond.\n");
			return 1;
		}
	}

	/* verify destination exists */
	r = room_get(dest_buf);
	if (!r) {
		telnetclient_printf(cl, "That exit leads nowhere (\"%s\").\n", dest_buf);
		return 0;
	}

	/* move the character */
	character_attr_set(ch, "room.current", dest_buf);
	show_room(cl, r);
	room_put(r);
	return 1;
}

/** action callback to do the "go" command. */
int
command_do_go(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	char dir[DIRECTION_STRING_MAX];

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
	char dir[DIRECTION_STRING_MAX];

	arg = util_getword(arg, dir, sizeof dir);
	if (!arg) {
		/* no argument -- check if an "enter" exit exists */
		struct character *ch = telnetclient_character(cl);
		const char *room_id;
		OBJ *r;

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
			int has_enter = obj_prop_get(r, "exit.enter.to") != NULL;
			room_put(r);
			if (has_enter)
				return do_move(cl, "enter");
		}

		telnetclient_puts(cl, "Enter where?\n");
		return 0;
	}

	return do_move(cl, dir);
}
