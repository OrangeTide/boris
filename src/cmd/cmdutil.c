/**
 * @file cmdutil.c
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
#include "cmdutil.h"
#include <boris.h>
#include "worldclock.h"
#include <character.h>
#include <variables.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* show_gametime displays the system local time and in-game time to the client. */
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

/* show_ambient displays the current time of day and returns 1 if anything was printed. */
int
show_ambient(DESCRIPTOR_DATA *cl)
{
	char ambient[256];
	if (worldclock_timeofdaystr(ambient, sizeof(ambient), worldclock_now()) != -1) {
		telnetclient_printf(cl, "It is %s.\n", ambient);
		return 1;
	}

	return 0;
}

/* show_pose displays the player's own pose/apperance to themselves.
 * Returns 1 if anything was printed. */
int
show_pose(DESCRIPTOR_DATA *cl)
{
	// TODO: improve this when we have 'pose' and other character status.
	telnetclient_puts(cl, "You are standing here.\n");
	return 1;
}

/* _tc_flush writes any buffered data in the sink to the client. */
void
_tc_flush(struct _tc_sink *s)
{
	if (s->len == 0) return;
	s->buf[s->len] = '\0';
	telnetclient_puts(s->cl, s->buf);
	s->len = 0;
}

/* _tc_sink buffers data and flushes it to the client when the buffer is full. */
int
_tc_sink(void *user, const char *data, unsigned n)
{
	struct _tc_sink *s = user;

	while (n > 0) {
		unsigned room = sizeof(s->buf) - 1 - s->len;
		unsigned w = n < room ? n : room;

		memcpy(s->buf + s->len, data, w);
		s->len += w;
		data += w;
		n -= w;
		if (s->len + 1 >= sizeof(s->buf))
			_tc_flush(s);
	}
	return 0;
}
