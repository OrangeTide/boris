/**
 * @file eventlog.c
 *
 * System event logging
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
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

#include "eventlog.h"
#include "boris.h"
#include "log.h"

#include <stdio.h>
#include <time.h>

/******************************************************************************
 * eventlog - writes logging information based on events
 ******************************************************************************/
/*-* eventlog:globals *-*/

/** output file used for eventlogging. */
static FILE *eventlog_file;

/*-* eventlog:internal functions *-*/

/*-* eventlog:external functions *-*/

/**
 * initialize the eventlog component.
 */
int
eventlog_init(void)
{
	eventlog_file = fopen(mud_config.eventlog_filename, "a");

	if (!eventlog_file) {
		LOG_PERROR(mud_config.eventlog_filename);
		return 0; /* failure */
	}

	setvbuf(eventlog_file, NULL, _IOLBF, 0);

	return 1; /* success */
}

/** clean up eventlog module and close the logging file. */
void
eventlog_shutdown(void)
{
	if (eventlog_file) {
		fclose(eventlog_file);
		eventlog_file = 0;
	}
}

/** log a message to the eventlog. */
void
eventlog(const char *type, const char *fmt, ...)
{
	va_list ap;
	char buf[512];
	int n;
	time_t t;
	char timestamp[64];

	va_start(ap, fmt);
	n = vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);

	if (n < 0) {
		LOG_ERROR("vsnprintf() failure");
		return; /* failure */
	}

	if (n >= (int)sizeof buf) { /* output was truncated */
		n = strlen(buf);
	}

	/* make certain the last character is a newline */
	if (n > 0 && buf[n - 1] != '\n') {
		if (n == sizeof buf) n--;

		buf[n] = '\n';
		buf[n + 1] = 0;
		LOG_DEBUG("Adding newline to message");
	}

	time(&t);
	strftime(timestamp, sizeof timestamp, mud_config.eventlog_timeformat, gmtime(&t));

	if (fprintf(eventlog_file ? eventlog_file : stderr, "%s:%s:%s", timestamp, type, buf) < 0) {
		/* there was a write error */
		LOG_PERROR(eventlog_file ? mud_config.eventlog_filename : "stderr");
	}
}

/**
 * report that a connection has occured.
 */
void
eventlog_connect(const char *peer_str)
{
	eventlog("CONNECT", "remote=%s\n", peer_str);
}

/** report the startup of the server. */
void
eventlog_server_startup(void)
{
	eventlog("STARTUP", "\n");
}

/** report the shutdown of the server. */
void
eventlog_server_shutdown(void)
{
	eventlog("SHUTDOWN", "\n");
}

/** report a failed login attempt. */
void
eventlog_login_failattempt(const char *username, const char *peer_str)
{
	eventlog("LOGINFAIL", "remote=%s name='%s'\n", peer_str, username);
}

/** report a successful login(sign-on) to eventlog. */
void
eventlog_signon(const char *username, const char *peer_str)
{
	eventlog("SIGNON", "remote=%s name='%s'\n", peer_str, username);
}

/** report a signoff to the eventlog. */
void
eventlog_signoff(const char *username, const char *peer_str)
{
	eventlog("SIGNOFF", "remote=%s name='%s'\n", peer_str, username);
}

/** report that a connection was rejected because there are already too many
 * connections. */
void
eventlog_toomany(void)
{
	/** @todo we could get the peername from the fd and log that? */
	eventlog("TOOMANY", "\n");
}

/**
 * log commands that a user enters.
 */
void
eventlog_commandinput(const char *remote, const char *username, const char *line)
{
	eventlog("COMMAND", "remote=\"%s\" user=\"%s\" command=\"%s\"\n", remote, username, line);
}

/** report that a new public channel was created. */
void
eventlog_channel_new(const char *channel_name)
{
	eventlog("CHANNEL-NEW", "channel=\"%s\"\n", channel_name);
}

/** report that a public channel was removed. */
void
eventlog_channel_remove(const char *channel_name)
{
	eventlog("CHANNEL-REMOVE", "channel=\"%s\"\n", channel_name);
}

/** report a user joining a public channel. */
void
eventlog_channel_join(const char *remote, const char *channel_name, const char *username)
{
	if (!remote) {
		eventlog("CHANNEL-JOIN", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-JOIN", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/** report a user leaving a public channel. */
void
eventlog_channel_part(const char *remote, const char *channel_name, const char *username)
{
	if (!remote) {
		eventlog("CHANNEL-PART", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-PART", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/**
 * logs an HTTP GET action.
 */
void
eventlog_webserver_get(const char *remote, const char *uri)
{
	eventlog("WEBSITE-GET", "remote=\"%s\" uri=\"%s\"\n", remote ? remote : "", uri ? uri : "");
}
