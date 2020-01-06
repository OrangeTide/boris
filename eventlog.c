/**
 * @file eventlog.c
 *
 * System event logging
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2020 Jan 05
 *
 * Copyright (c) 2008-2020, Jon Mayo
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

#include "eventlog.h"
#include "boris.h"
#include "debug.h"

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
int eventlog_init(void)
{
	eventlog_file = fopen(mud_config.eventlog_filename, "a");

	if (!eventlog_file) {
		PERROR(mud_config.eventlog_filename);
		return 0; /* failure */
	}

	setvbuf(eventlog_file, NULL, _IOLBF, 0);

	return 1; /* success */
}

/** clean up eventlog module and close the logging file. */
void eventlog_shutdown(void)
{
	if (eventlog_file) {
		fclose(eventlog_file);
		eventlog_file = 0;
	}
}

/** log a message to the eventlog. */
void eventlog(const char *type, const char *fmt, ...)
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
		ERROR_MSG("vsnprintf() failure");
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
		DEBUG_MSG("Adding newline to message");
	}

	time(&t);
	strftime(timestamp, sizeof timestamp, mud_config.eventlog_timeformat, gmtime(&t));

	if (fprintf(eventlog_file ? eventlog_file : stderr, "%s:%s:%s", timestamp, type, buf) < 0) {
		/* there was a write error */
		PERROR(eventlog_file ? mud_config.eventlog_filename : "stderr");
	}
}

/**
 * report that a connection has occured.
 */
void eventlog_connect(const char *peer_str)
{
	eventlog("CONNECT", "remote=%s\n", peer_str);
}

/** report the startup of the server. */
void eventlog_server_startup(void)
{
	eventlog("STARTUP", "\n");
}

/** report the shutdown of the server. */
void eventlog_server_shutdown(void)
{
	eventlog("SHUTDOWN", "\n");
}

/** report a failed login attempt. */
void eventlog_login_failattempt(const char *username, const char *peer_str)
{
	eventlog("LOGINFAIL", "remote=%s name='%s'\n", peer_str, username);
}

/** report a successful login(sign-on) to eventlog. */
void eventlog_signon(const char *username, const char *peer_str)
{
	eventlog("SIGNON", "remote=%s name='%s'\n", peer_str, username);
}

/** report a signoff to the eventlog. */
void eventlog_signoff(const char *username, const char *peer_str)
{
	eventlog("SIGNOFF", "remote=%s name='%s'\n", peer_str, username);
}

/** report that a connection was rejected because there are already too many
 * connections. */
void eventlog_toomany(void)
{
	/** @todo we could get the peername from the fd and log that? */
	eventlog("TOOMANY", "\n");
}

/**
 * log commands that a user enters.
 */
void eventlog_commandinput(const char *remote, const char *username, const char *line)
{
	eventlog("COMMAND", "remote=\"%s\" user=\"%s\" command=\"%s\"\n", remote, username, line);
}

/** report that a new public channel was created. */
void eventlog_channel_new(const char *channel_name)
{
	eventlog("CHANNEL-NEW", "channel=\"%s\"\n", channel_name);
}

/** report that a public channel was removed. */
void eventlog_channel_remove(const char *channel_name)
{
	eventlog("CHANNEL-REMOVE", "channel=\"%s\"\n", channel_name);
}

/** report a user joining a public channel. */
void eventlog_channel_join(const char *remote, const char *channel_name, const char *username)
{
	if (!remote) {
		eventlog("CHANNEL-JOIN", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-JOIN", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/** report a user leaving a public channel. */
void eventlog_channel_part(const char *remote, const char *channel_name, const char *username)
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
void eventlog_webserver_get(const char *remote, const char *uri)
{
	eventlog("WEBSITE-GET", "remote=\"%s\" uri=\"%s\"\n", remote ? remote : "", uri ? uri : "");
}
