/**
 * @file roomget.c
 *
 * "Roomget" command
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
#include "room.h"
#include "util.h"

/** action callback to do the "roomget" command. */
int
command_do_roomget(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct room *r;
	char roomid_str[64];
	char attrname[64];
	const char *attrvalue;

	arg = util_getword(arg, roomid_str, sizeof roomid_str);
	if (!arg) roomid_str[0] = 0; /* no arg */
	arg = util_getword(arg, attrname, sizeof attrname);
	if (!arg) attrname[0] = 0; /* no arg */

	/* check that roomid and attrname are not empty, and there is no trailing arguments */
	if (!roomid_str[0] || !attrname[0] || arg) {
		telnetclient_printf(cl, "usage: roomget <roomid> <attrname>\n");
		return 0;
	}

	r = room_get(roomid_str);

	if (!r) {
		telnetclient_printf(cl, "room \"%s\" not found.\n", roomid_str);
		return 0;
	}

	attrvalue = room_attr_get(r, attrname);

	if (attrvalue) {
		telnetclient_printf(cl, "room \"%s\" \"%s\" = \"%s\"\n", roomid_str, attrname, attrvalue);
	} else {
		telnetclient_printf(cl, "room \"%s\" attribute \"%s\" not found.\n", roomid_str, attrname);
	}

	room_put(r);

	return 1; /* success */
}
