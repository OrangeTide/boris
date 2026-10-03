/* grant.c : @grant and @revoke -- set or clear an account's acs flags */

#include "command.h"
#include <boris.h>
#include <user.h>
#include <telnetclient.h>

#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* Shared body of @grant and @revoke. `enable` selects set vs clear; `cmdname`
 * names the command for the usage line; `verb` and `prep` word the success
 * feedback ("Granted flag 'w' to bob." / "Revoked ... from bob."). Wizard-only:
 * the caller's account must carry the 'w' flag. */
static int
command_acs_flag(DESCRIPTOR_DATA *cl, const char *arg, int enable,
	const char *cmdname, const char *verb, const char *prep)
{
	struct user *caller = telnetclient_user(cl);
	struct user *target;
	char username[32];
	char token[8];
	char flag;

	if (!user_is_wizard(caller)) {
		telnetclient_puts(cl, "Permission denied.\n");
		return 0;
	}

	/* Expect exactly "<account> <flag>", the flag a single letter or digit. */
	if (!arg || sscanf(arg, "%31s %7s", username, token) != 2
		|| token[1] != '\0' || !isalnum((unsigned char)token[0])) {
		telnetclient_printf(cl, "Usage: %s <account> <flag>\n", cmdname);
		return 0;
	}
	flag = token[0];

	target = user_lookup(username);
	if (!target) {
		telnetclient_printf(cl, "No such account: %s\n", username);
		return 0;
	}

	/* Report a no-op rather than churn the store and claim a change. */
	if (user_acs_testflag(target, flag) == enable) {
		telnetclient_printf(cl, "%s already %s flag '%c'.\n",
			username, enable ? "has" : "lacks", flag);
		return 1;
	}

	if (!user_acs_setflag(target, flag, enable)) {
		telnetclient_printf(cl, "'%c' is not a valid flag.\n", flag);
		return 0;
	}

	if (!user_save(target)) {
		telnetclient_puts(cl, "Could not save the account.\n");
		return 0;
	}

	telnetclient_printf(cl, "%s flag '%c' %s %s.\n", verb, flag, prep,
		username);
	return 1;
}

int
command_do_grant(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd, const char *arg)
{
	return command_acs_flag(cl, arg, 1, cmd, "Granted", "to");
}

int
command_do_revoke(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd, const char *arg)
{
	return command_acs_flag(cl, arg, 0, cmd, "Revoked", "from");
}
