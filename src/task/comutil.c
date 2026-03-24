/**
 * @file comutil.c
 *
 * Communication utilities - show_gametime, show_room, ...
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
#include "comutil.h"
#include <boris.h>
#include "worldclock.h"
#include <stdio.h>
#include <time.h>

void
show_gametime(DESCRIPTOR_DATA *cl)
{
	char systime[64];
	char gametime[64];
	time_t t;
	struct tm *tm;

	t = time(0);
	tm = localtime(&t);

	if (strftime(systime, sizeof(systime), "%Y-%m-%d %H:%M:%S", tm) != 0)
		telnetclient_printf(cl, "System local time: %s\n", systime);

	if (worldclock_datetimestr(gametime, sizeof(gametime), worldclock_now()) != -1)
		telnetclient_printf(cl, "Current time in game: %s\n", gametime);
}

static const char * const dirs[] = {
	"n", "north", "s", "south", "e", "east",
	"w", "west", "u", "up", "d", "down",
	"ne", "northeast", "nw", "northwest",
	"se", "southeast", "sw", "southwest",
	"enter", NULL
};

/** display the current room to the player. */
void
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
