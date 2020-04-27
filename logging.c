/**
 * @file logging.c
 *
 * Plugin that provides basic logging to stderr.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Dec 25
 *
 * Copyright (c) 2009-2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "boris.h"
#include "plugin.h"

#define LOGBASIC_LENGTH_MAX 1024

struct plugin_basiclog_class {
	struct plugin_basic_class base_class;
	struct plugin_logging_interface log_interface;
};

extern const struct plugin_basiclog_class plugin_class;

static int log_level = B_LOG_INFO;

static char *prio_names[] = {
	"ASSERT", "CRITIAL", "ERROR", "WARNING",
	"INFO", "TODO", "DEBUG", "TRACE"
};

static void do_log(int priority, const char *domain, const char *fmt, ...)
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

static int initialize(void)
{
	fprintf(stderr, "loaded %s\n", plugin_class.base_class.class_name);
	service_attach_log(do_log);
	b_log(B_LOG_INFO, "logging", "Logging system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");

	return 1;
}

static int l_shutdown(void)
{
	service_detach_log(do_log);

	return 1;
}

/**
 * set the currnet logging level.
 */
static void set_level(int level)
{
	if (level > 7)
		level = 7;

	if (level < 0)
		level = 0;

	log_level = level;
}

/**
 * the only external symbol.
 */
const struct plugin_basiclog_class plugin_class = {
	.base_class = { PLUGIN_API, "logging", initialize, l_shutdown },
	.log_interface = { do_log, set_level }
};
