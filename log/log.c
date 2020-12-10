/*
 * Copyright (c) 2020 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "log.h"

////////////////////////////////////////////////////////////////////////
// Logging

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>

static inline void
log_generic(const char *prefix, const char *fmt, va_list ap)
{
	/* timestamp */
	struct timeval tv;
	gettimeofday(&tv, NULL);
	struct tm tm;
	localtime_r(&tv.tv_sec, &tm);
	char stamp[32];
	strftime(stamp, sizeof(stamp), "%Y-%m-%dT%T.XXX%z  ", &tm);

	// hack into the buffer and replace the ".000"
	char msec[4];
	snprintf(msec, sizeof(msec), "%03u", (unsigned)((tv.tv_usec / 1000) % 1000));
	memcpy(stamp + (4 + 1 + 2 + 1 + 2 + 1 + 9), msec, 3);
	fputs(stamp, stderr);

	// print the log message
	fputs(prefix, stderr);
	vfprintf(stderr, fmt, ap);
	fputc('\n', stderr);
}

void
log_vinfo(const char *fmt, va_list ap)
{
	log_generic("INFO:    ", fmt, ap);
}

void
log_verror(const char *fmt, va_list ap)
{
	log_generic("ERROR:   ", fmt, ap);
}

void
log_vwarn(const char *fmt, va_list ap)
{
	log_generic("WARNING: ", fmt, ap);
}

void
log_info(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	log_vinfo(fmt, ap);
	va_end(ap);
}

void
log_error(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	log_verror(fmt, ap);
	va_end(ap);
}

void
log_warn(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	log_vwarn(fmt, ap);
	va_end(ap);
}

void
log_errno(const char *reason)
{
	if (reason && *reason)
		log_error("%s:%s", strerror(errno), reason);
	else
		log_error("%s", strerror(errno));
}
