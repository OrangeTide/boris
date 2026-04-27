/**
 * @file show_room.c
 *
 * Communication utilities - show_room
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2019-2026, Jon Mayo <jon@rm-f.net>
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
#include "cmdutil.h"
#include <boris.h>
#include "worldclock.h"
#include <character.h>
#include <variables.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* variable lookup for show_room: supports "room.<attr>" and "char.<attr>". */
struct room_lookup_ctx {
	OBJ		*r;
	struct character *ch;
};

struct exit_room_lookup_ctx {
	OBJ		*room;
	OBJ		*exit_room;
	const char	*dir;
};

static const char * const dirs[] = {
	"n", "north", "s", "south", "e", "east",
	"w", "west", "u", "up", "d", "down",
	"ne", "northeast", "nw", "northwest",
	"se", "southeast", "sw", "southwest",
	"enter", NULL
};

static const char *
dir_info(OBJ *r, const char *d, const char *arg)
{
	(void)r; // TODO: we can reach into the current room's "exit.*.name", if it exists.
	if (!strcmp(arg, "desc")) {
		if (!strcmp(d, "n"))
			return "the north";
		if (!strcmp(d, "s"))
			return "the south";
		if (!strcmp(d, "w"))
			return "the west";
		if (!strcmp(d, "e"))
			return "the east";
		if (!strcmp(d, "nw"))
			return "the northwest";
		if (!strcmp(d, "ne"))
			return "the northeast";
		if (!strcmp(d, "sw"))
			return "the southwest";
		if (!strcmp(d, "se"))
			return "the southeast";
		if (!strcmp(d, "u"))
			return "above";
		if (!strcmp(d, "d"))
			return "below";
		return "an unknown direction";
	}
	return NULL;
}

/* room_lookup resolves "room.<attr>" and "char.<attr>" variable references. */
static const char *
room_lookup(void *user, const char *name)
{
	struct room_lookup_ctx *rl = user;

	if (!strncmp(name, "room.", 5))
		return rl->r ? obj_prop_get(rl->r, name + 5) : NULL;
	if (!strncmp(name, "char.", 5))
		return rl->ch ? character_attr_get(rl->ch, name + 5) : NULL;
	return NULL;
}

/* exit_room_lookup resolves room exits to other rooms. */
static const char *
exit_room_lookup(void *user, const char *name)
{
	struct exit_room_lookup_ctx *orl = user;

	if (!strncmp(name, "room.", 5))
		return orl->room ? obj_prop_get(orl->room, name + 5) : NULL;
	if (!strncmp(name, "to.", 5))
		return orl->exit_room ? obj_prop_get(orl->exit_room, name + 5) : NULL;
	if (!strncmp(name, "dir.", 4))
		return orl->dir ? dir_info(orl->exit_room, orl->dir, name + 4) : NULL;;
	return NULL;
}

/* expand_to_telnet expands variable references in s and streams the result to the client. */
static void
expand_to_telnet(DESCRIPTOR_DATA *cl, const char *s,
		 const struct var_ctx *ctx)
{
	struct _tc_sink snk = { cl, {0}, 0 };

	expand_string_stream(s, ctx, _tc_sink, &snk);
	_tc_sink(&snk, "\n", 1);
	_tc_flush(&snk);
}

/* show_glance displays the room's desc.glance field, if it exists */
static int
show_glance(DESCRIPTOR_DATA *cl, OBJ *r, struct var_ctx *vctx)
{
	char *glance = obj_prop_get(r, "desc.glance");
	if (!glance)
		return 0;
	expand_to_telnet(cl, glance, vctx);
	return 1;
}

/* show_room displays the current room to the player. Output order: room title,
 * time of day, glance text, blank line, description paragraphs, blank line,
 * entity list, blank line, exit list.
 *
 * Format for room output:
 * 1. Room Title (name)
 * 2. Time of Day. Ambient Weather Condition.
 * 3. Extra at a glance information, if available.
 * 4. New Line (space)
 * 5. Body of Main Room Description including objects in the room.
 * 6. New Line (space)
 * 7. List of entities - TODO: not yet supported!
 * 8. New Line (space)
 * 9. Static exit Desc or dynamic exit description list (paragraphs with indent)
 * 10. New Line (space)
 * 11. Print available Exits - TODO: not yet supported!
 *
 */
void
show_room(DESCRIPTOR_DATA *cl, OBJ *r)
{
	struct room_lookup_ctx rl = { r, telnetclient_character(cl) };
	struct var_ctx vctx = { room_lookup, &rl, 0, NULL, NULL, 0 };
	const char *name, *desc;
	char exitname[64];
	unsigned i;

	// 1. Room Title (name)
	name = obj_prop_get(r, "name");
	if (name)
		expand_to_telnet(cl, name, &vctx);
	else
		telnetclient_puts(cl, "ERROR:nameless room\n");

	// 2. Time of Day. Ambient Weather Condition.
	show_ambient(cl);

	// 3. Extra at a glance information, if available.
	show_glance(cl, r, &vctx);

	// 4. New Line (space)
	telnetclient_puts(cl, "\n");

	// 5. Body of Main Room Description including objects in the room.
	// 6. New Line (space)
	desc = obj_prop_get(r, "desc.long");

	/* fallback to "desc.short" if no "desc.long" */
	if (!desc)
		desc = obj_prop_get(r, "desc.short");
	if (desc) {
		char *expanded = expand_string(desc, &vctx);
		if (expanded) {
			telnetclient_puts_paragraphs(cl, expanded, 2);
			free(expanded);
		}
		telnetclient_puts(cl, "\n");
	}
	// TODO: append each object's desc.pose or desc.short to the Body of Main Room Description
	//
	// players will use a pose-like command to place an object in a room
	// with a custom description. desc.pose overrides desc.short, it is a
	// temporary values that players can set on item or object when placing
	// items in the room.  taking most posed objects would remove the pose.
	//
	// example:
	// "desc.short":"A half-eaten sandwich has been left here."
	// "desc.pose":"A half-eaten sandwich is laying open-faced on the table."
	//
	// a place/pose command will use the "name" field of the object, and
	// then players can appends what they want to it.

	// 7. List of entities
	// 8. New Line (space)
	// TODO: list other the entities in the room.
	// show yourself as another entity.
	if (show_pose(cl) > 0)
		telnetclient_puts(cl, "\n");

	// 9. Static exit Desc or dynamic exit description list (paragraphs with indent)
	{
		static const char *fallback = "${to.name} lies to ${dir.desc}.";
		char para[4096];
		unsigned plen = 0;

		for (i = 0; dirs[i]; i++) {
			const char *exit_room_id, *exit_desc, *tmpl;
			struct exit_room_lookup_ctx orl;
			struct var_ctx evctx;
			char descname[64];
			char *expanded;
			unsigned elen;
			OBJ *exit_room;

			snprintf(exitname, sizeof exitname, "exit.%s.to", dirs[i]);
			exit_room_id = obj_prop_get(r, exitname);
			if (!exit_room_id)
				continue;

			snprintf(descname, sizeof descname, "exit.%s.desc", dirs[i]);
			exit_desc = obj_prop_get(r, descname);
			exit_room = room_get(exit_room_id);

			if (!exit_desc && !exit_room)
				continue;

			tmpl = exit_desc ? exit_desc : fallback;
			orl = (struct exit_room_lookup_ctx){ r, exit_room, dirs[i] };
			evctx = (struct var_ctx){ exit_room_lookup, &orl, 0, NULL, NULL, 0 };
			expanded = expand_string(tmpl, &evctx);

			if (exit_room)
				room_put(exit_room);
			if (!expanded)
				continue;

			elen = strlen(expanded);
			if (plen + 1 + elen >= sizeof para) {
				free(expanded);
				break;
			}
			if (plen > 0)
				para[plen++] = ' ';
			memcpy(para + plen, expanded, elen);
			plen += elen;
			free(expanded);
		}

		if (plen > 0) {
			para[plen] = '\0';
			telnetclient_puts_paragraphs(cl, para, 0);
			telnetclient_puts(cl, "\n");
		}
	}
	// 10. New Line (space)

	// 11. Print available Exits
	/* list exits */
	telnetclient_puts(cl, "Exits:");
	{
		int found = 0;

		for (i = 0; dirs[i]; i++) {
			snprintf(exitname, sizeof exitname, "exit.%s.to", dirs[i]);
			if (obj_prop_get(r, exitname)) {
				telnetclient_printf(cl, " %s", dirs[i]);
				found = 1;
			}
		}

		if (!found)
			telnetclient_puts(cl, " none");
		telnetclient_puts(cl, "\n");
	}
}
