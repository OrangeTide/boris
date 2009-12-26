/**
 * @file logging.c
 *
 * basic logging to stderr.
 *
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

static int log_level=B_LOG_INFO;

static char *prio_names[] = {
	"ASSERT", "CRITIAL", "ERROR", "WARNING",
	"INFO", "TODO", "DEBUG", "TRACE"
};

static void do_log(int priority, const char *domain, const char *fmt, ...) {
	char buf[LOGBASIC_LENGTH_MAX];
	int i;
	va_list ap;

	assert(priority >= 0 && priority <= 7);
	assert(fmt != NULL);

	/* write priority */
	i=snprintf(buf, sizeof buf-1, "%s:",
		priority>=0 && priority<=7 ? prio_names[priority] : "UNKNOWN"
	);

	/* write domain - if it is set. */
	if(domain)
		i+=snprintf(buf+i, sizeof buf-i-1, "%s:", domain);

	/* apply format string. */
	va_start(ap, fmt);
	i+=vsnprintf(buf+i, sizeof buf-i-1, fmt, ap);
	va_end(ap);

	/* add newline if one not found. */
	if(i && buf[i-1]!='\n') strcpy(buf+i, "\n");

	fputs(buf, stderr);
}

static int initialize(void) {
	fprintf(stderr, "loaded %s\n", plugin_class.base_class.class_name);
	service_attach_log(do_log);
	b_log(B_LOG_INFO, "logging", "Logging system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	return 1;
}

static int shutdown(void) {
	service_detach_log(do_log);
	return 1;
}

/**
 * set the currnet logging level.
 */
static void set_level(int level) {
	if(level>7) level=7;
	if(level<0) level=0;
	log_level=level;
}

/**
 * the only external symbol.
 */
const struct plugin_basiclog_class plugin_class = {
	.base_class = { PLUGIN_API, "logging", initialize, shutdown },
	.log_interface = { do_log, set_level }
};
