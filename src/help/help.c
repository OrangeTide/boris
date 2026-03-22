/* help.c : online help system -- reads plain text files from data/help/ */
/*
 * Copyright (c) 2022-2026, Jon Mayo <jon@rm-f.net>
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
#define LOG_SUBSYSTEM "help"
#include <log.h>

#include <ctype.h>
#include <stdio.h>
#include <string.h>

#define HELP_DIR "data/help/"
#define HELP_LINE_MAX 1024

int
help_init(void)
{
	return HELP_OK;
}

void
help_shutdown(void)
{
}

/** validate topic name -- alphanumeric, dash, underscore only. */
static int
help_topic_valid(const char *topic)
{
	const char *p;

	if (!topic || !*topic)
		return 0;

	for (p = topic; *p; p++) {
		if (!isalnum((unsigned char)*p) && *p != '-' && *p != '_')
			return 0;
	}

	return 1;
}

int
help_show(DESCRIPTOR_DATA *d, const char *topic)
{
	char path[256];
	char line[HELP_LINE_MAX];
	FILE *fp;
	int n;

	if (!help_topic_valid(topic)) {
		LOG_WARNING("invalid help topic \"%s\"", topic);
		return HELP_ERR;
	}

	n = snprintf(path, sizeof path, "%s%s", HELP_DIR, topic);
	if (n < 0 || (unsigned)n >= sizeof path) {
		LOG_WARNING("help topic too long \"%s\"", topic);
		return HELP_ERR;
	}

	fp = fopen(path, "r");
	if (!fp)
		return HELP_ERR;

	while (fgets(line, sizeof line, fp))
		telnetclient_puts(d, line);

	fclose(fp);

	return HELP_OK;
}
