/**
 * @file character.c
 *
 * "Character command
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
#include "util.h"
#include <ctype.h>
#include <stdlib.h>

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
