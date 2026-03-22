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
#include "hashtable.h"
#define LOG_SUBSYSTEM "help"
#include <log.h>

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define HELP_DIR "data/help/"
#define HELP_LINE_MAX 1024

/** cached help topics, keyed by topic name, value is strdup'd file content. */
static struct ht_str help_cache;
static int help_cache_ready;

int
help_init(void)
{
	ht_str_init(&help_cache, 32);
	help_cache_ready = 1;
	return HELP_OK;
}

void
help_shutdown(void)
{
	if (help_cache_ready) {
		ht_str_free(&help_cache, free);
		help_cache_ready = 0;
	}
}

void
help_cache_invalidate(void)
{
	if (help_cache_ready) {
		ht_str_free(&help_cache, free);
		ht_str_init(&help_cache, 32);
		LOG_INFO("help cache invalidated");
	}
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

/** load a help file into a single allocated buffer. returns NULL on failure. */
static char *
help_file_load(const char *path)
{
	FILE *fp;
	char *buf;
	long len;

	fp = fopen(path, "r");
	if (!fp)
		return NULL;

	if (fseek(fp, 0, SEEK_END) < 0) {
		fclose(fp);
		return NULL;
	}

	len = ftell(fp);
	if (len < 0) {
		fclose(fp);
		return NULL;
	}

	rewind(fp);

	buf = malloc(len + 1);
	if (!buf) {
		fclose(fp);
		return NULL;
	}

	len = fread(buf, 1, len, fp);
	buf[len] = '\0';
	fclose(fp);

	return buf;
}

int
help_show(DESCRIPTOR_DATA *d, const char *topic)
{
	char path[256];
	char *content;
	int n;

	if (!help_topic_valid(topic)) {
		LOG_WARNING("invalid help topic \"%s\"", topic);
		return HELP_ERR;
	}

	/* check cache first */
	content = ht_str_get(&help_cache, topic);
	if (content) {
		telnetclient_puts(d, content);
		return HELP_OK;
	}

	n = snprintf(path, sizeof path, "%s%s", HELP_DIR, topic);
	if (n < 0 || (unsigned)n >= sizeof path) {
		LOG_WARNING("help topic too long \"%s\"", topic);
		return HELP_ERR;
	}

	content = help_file_load(path);
	if (!content)
		return HELP_ERR;

	/* cache the content for future lookups */
	ht_str_set(&help_cache, topic, content);

	telnetclient_puts(d, content);

	return HELP_OK;
}
