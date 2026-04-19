/**
 * @file time.c
 *
 * "Time" command
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
#include "cmdutil.h"

/** action callback to do the "time" command. */
int
command_do_time(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	show_gametime(cl);

	return 1; /* success */
}
