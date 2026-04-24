/**
 * @file login.c
 *
 * Handles the login process.
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

#include "login.h"
#include <ctype.h>
#include <boris.h>
#define LOG_SUBSYSTEM "login"
#include <log.h>
#include <debug.h>
#include <eventlog.h>
#include <game.h>
#include <user.h>
#include <charset.h>

/** undocumented - please add documentation. */
void
login_password_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	struct user *u;

	assert(cl != NULL);
	assert(line != NULL);
	assert(telnetclient_get_login_username(cl)[0] != '\0'); /* must have a valid username */

	LOG_TODO("complete login process");
	LOG_DEBUG("Login attempt: Username='%s'", telnetclient_get_login_username(cl));

	u = user_lookup(telnetclient_get_login_username(cl));

	if (u) {
		LOG_INFO("User '%s' found!", telnetclient_get_login_username(cl));
		/* verify the password */
		if (user_password_check(u, line)) {
			telnetclient_setuser(cl, u);

			/* apply saved charset preference */
			const char *charset_pref = user_extra_get(u, "charset");
			if (charset_pref) {
				struct charset *cs = charset_load(charset_pref);
				if (cs)
					telnetclient_set_encoding(cl, cs);
			}

			eventlog_signon(telnetclient_get_login_username(cl), telnetclient_socket_name(cl));
			telnetclient_printf(cl, "Hello, %s.\n\n", user_username(u));
			menu_start_input(cl, &gamemenu_main);
			return; /* success */
		}

		telnetclient_puts(cl, mud_config.msgfile_badpassword);
	} else {
		telnetclient_puts(cl, mud_config.msgfile_noaccount);
	}

	/* report the attempt */
	eventlog_login_failattempt(telnetclient_get_login_username(cl), telnetclient_socket_name(cl));

	/* failed logins go back to the login menu or disconnect */
	menu_start_input(cl, &gamemenu_login);
}

/** undocumented - please add documentation. */
void
login_password_start(void *p, long unused2, void *unused3)
{
	(void)unused2;
	(void)unused3;

	DESCRIPTOR_DATA *cl = p;
	telnetclient_start_lineinput(cl, login_password_lineinput, "Password: ");
}

/** undocumented - please add documentation. */
void
login_username_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	assert(line != NULL);

	telnetclient_clear_statedata(cl); /* this is a fresh state */
	telnetclient_set_state_free(cl, NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (!*line) {
		telnetclient_puts(cl, mud_config.msg_invalidusername);
		menu_start_input(cl, &gamemenu_login);
		return;
	}

	/* store the username for the password state to use */
	telnetclient_set_login_username(cl, line);

	login_password_start(cl, 0, 0);
}

/** undocumented - please add documentation. */
void
login_username_start(void *p, long unused2, void *unused3)
{
	(void)unused2;
	(void)unused3;

	DESCRIPTOR_DATA *cl = p;
	telnetclient_start_lineinput(cl, login_username_lineinput, "Username: ");
}

/** undocumented - please add documentation. */
void
signoff(void *p, long unused2, void *unused3)
{
	(void)unused2;
	(void)unused3;

	DESCRIPTOR_DATA *cl = p;
	telnetclient_close(cl);
}
