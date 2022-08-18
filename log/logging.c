/**
 * @file logging.c
 *
 * Logging module.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2009-2022, Jon Mayo <jon@rm-f.net>
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

#include "logging.h"
#include "boris.h"
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#define LOGBASIC_LENGTH_MAX 1024

static int log_level = B_LOG_INFO;

static char *prio_names[] = {
	"ASSERT", "CRITIAL", "ERROR", "WARNING",
	"INFO", "TODO", "DEBUG", "TRACE"
};

void
logging_do_log(int priority, const char *domain, const char *fmt, ...)
{
	char buf[LOGBASIC_LENGTH_MAX];
	int i;
	va_list ap;

	assert(priority >= 0 && priority <= 7);
	assert(fmt != NULL);

	/* write priority */
	i = snprintf(buf, sizeof buf - 1, "%s:",
	             priority >= 0 && priority <= 7 ? prio_names[priority] : "UNKNOWN");

	/* write domain - if it is set. */
	if (domain)
		i += snprintf(buf + i, sizeof buf - i - 1, "%s:", domain);

	/* apply format string. */
	va_start(ap, fmt);
	i += vsnprintf(buf + i, sizeof buf - i - 1, fmt, ap);
	va_end(ap);

	/* add newline if one not found. */
	if (i && buf[i - 1] != '\n') strcpy(buf + i, "\n");

	fputs(buf, stderr);
}

int
logging_initialize(void)
{
	fprintf(stderr, "loaded %s\n", "logging");
	b_log(B_LOG_INFO, "logging", "Logging system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");

	return 0;
}

void
logging_shutdown(void)
{
}

/**
 * set the currnet logging level.
 */
void
logging_set_level(int level)
{
	if (level > 7)
		level = 7;

	if (level < 0)
		level = 0;

	log_level = level;
}
