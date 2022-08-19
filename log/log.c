/**
 * @file log.c
 *
 * Logging service.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
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

#define LOG_SUBSYSTEM "logging"
#include "log.h"
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

static char *level_names[] = {
	"ASSERT", "CRITIAL", "ERROR", "WARNING",
	"INFO", "TODO", "DEBUG", "TRACE"
};

void
log_vlogf(int level, const char *subsystem, const char *fmt, va_list ap)
{
	char buf[512];
	int i;

	assert(level >= 0 && level <= 7);
	assert(fmt != NULL);

	/* write level */
	i = snprintf(buf, sizeof buf - 1, "%s:",
	             level >= 0 && level <= 7 ? level_names[level] : "UNKNOWN");

	/* write subsystem - if it is set. */
	if (subsystem)
		i += snprintf(buf + i, sizeof buf - i - 1, "%s:", subsystem);

	/* apply format string. */
	i += vsnprintf(buf + i, sizeof buf - i - 1, fmt, ap);

	/* add newline if one not found. */
	if (i && buf[i - 1] != '\n') strcpy(buf + i, "\n");

	fputs(buf, stderr);
}

void
log_logf(int level, const char *subsystem, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	log_vlogf(level, subsystem, fmt, ap);
	va_end(ap);
}

void
log_perror(int level, const char *subsystem, const char *reason)
{
	log_logf(level, subsystem, "%s:%s", reason, strerror(errno));
}

int
log_init(void)
{
	LOG_INFO("Logging system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");

	return LOG_OK;
}

void
log_done(void)
{
}
