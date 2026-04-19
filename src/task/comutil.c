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
#include <character.h>
#include <variables.h>
#include <stdio.h>
#include <string.h>
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

/* sink state for streaming expand_string output to a telnetclient.
 * buffers small chunks on the stack and flushes via telnetclient_puts
 * so the expander never has to allocate. */
struct tc_sink {
	DESCRIPTOR_DATA	*cl;
	char		buf[256];
	unsigned	len;
};

static void
tc_flush(struct tc_sink *s)
{
	if (s->len == 0) return;
	s->buf[s->len] = '\0';
	telnetclient_puts(s->cl, s->buf);
	s->len = 0;
}

static int
tc_sink(void *user, const char *data, unsigned n)
{
	struct tc_sink *s = user;

	while (n > 0) {
		unsigned room = sizeof(s->buf) - 1 - s->len;
		unsigned w = n < room ? n : room;

		memcpy(s->buf + s->len, data, w);
		s->len += w;
		data += w;
		n -= w;
		if (s->len + 1 >= sizeof(s->buf))
			tc_flush(s);
	}
	return 0;
}

/* variable lookup for show_room: supports "room.<attr>" and "char.<attr>". */
struct room_lookup_ctx {
	struct room	*r;
	struct character *ch;
};

static const char *
room_lookup(void *user, const char *name)
{
	struct room_lookup_ctx *rl = user;

	if (!strncmp(name, "room.", 5))
		return rl->r ? room_attr_get(rl->r, name + 5) : NULL;
	if (!strncmp(name, "char.", 5))
		return rl->ch ? character_attr_get(rl->ch, name + 5) : NULL;
	return NULL;
}

/** expand s through the ctx, streaming straight into cl. */
static void
expand_to_telnet(DESCRIPTOR_DATA *cl, const char *s,
		 const struct var_ctx *ctx)
{
	struct tc_sink snk = { cl, {0}, 0 };

	expand_string_stream(s, ctx, tc_sink, &snk);
	tc_sink(&snk, "\n", 1);
	tc_flush(&snk);
}

/** display the current room to the player. */
void
show_room(DESCRIPTOR_DATA *cl, struct room *r)
{
	struct room_lookup_ctx rl = { r, telnetclient_character(cl) };
	struct var_ctx vctx = { room_lookup, &rl, 0, NULL, NULL, 0 };
	const char *name, *desc;

	name = room_attr_get(r, "name.short");
	if (name)
		expand_to_telnet(cl, name, &vctx);

	desc = room_attr_get(r, "desc.long");
	if (!desc)
		desc = room_attr_get(r, "desc.short");
	if (desc)
		expand_to_telnet(cl, desc, &vctx);

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
