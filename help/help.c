/**
 * @file help.c
 *
 * Help file
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Sep 6
 *
 * Copyright (c) 2022, Jon Mayo <jon@rm-f.net>
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

#include "help.h"
#include <boris.h>
#include <fdb.h>
#define LOG_SUBSYSTEM "help"
#include <log.h>

int
help_init(void)
{
	// TODO: load all help files into a cache
	return HELP_OK;
}

void
help_shutdown(void)
{
}

/* read help directly from disk */
int
help_show(DESCRIPTOR_DATA *d, const char *topic)
{
	struct fdb_read_handle *h;
	h = fdb_read_begin(DOMAIN_HELP, topic);
	if (!h) {
		return HELP_ERR;
	}

	const char *name, *value;
	while (fdb_read_next(h, &name, &value)) {
		if (!strcasecmp(name, "full")) {
			telnetclient_printf(d, "%s\n", value);
		} else if (!strcasecmp(name, "topic")) {
			/* ignored */
		} else if (!strcasecmp(name, "usage")) {
			/* ignored */
		} else {
			LOG_WARNING("Unrecognized tag '%s'", name);
		}
	}

	fdb_read_end(h);

	return HELP_OK;
}
