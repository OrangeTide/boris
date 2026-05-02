/* weblogin.c : web client pre-login handler (connect/create commands) */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#include "weblogin.h"
#include <boris.h>
#include <webclient.h>
#include <user.h>
#include <invite.h>
#include <command.h>
#include <eventlog.h>
#include <charset.h>
#define LOG_SUBSYSTEM "weblogin"
#include <log.h>

#include <ctype.h>
#include <string.h>

static int
name_valid(const char *name)
{
    int len = (int)strlen(name);

    if (len < 2 || len > 20)
        return 0;
    if (!isalpha(name[0]))
        return 0;
    for (int i = 1; i < len; i++) {
        if (!isalnum(name[i]) && name[i] != '_')
            return 0;
    }
    return 1;
}

static void
web_send_error(DESCRIPTOR_DATA *cl, const char *msg)
{
    telnetclient_send_sse(cl, '!', msg);
}

static void
web_send_login_ok(DESCRIPTOR_DATA *cl)
{
    telnetclient_send_sse(cl, '+', "");
}

static void
do_connect(DESCRIPTOR_DATA *cl, const char *args)
{
    char name[32], pw[64];
    const char *p = args;

    while (*p && isspace(*p)) p++;
    int i = 0;
    while (*p && !isspace(*p) && i < (int)sizeof(name) - 1)
        name[i++] = *p++;
    name[i] = '\0';

    while (*p && isspace(*p)) p++;
    i = 0;
    while (*p && !isspace(*p) && i < (int)sizeof(pw) - 1)
        pw[i++] = *p++;
    pw[i] = '\0';

    if (!name[0] || !pw[0]) {
        web_send_error(cl, "Usage: connect <name> <password>");
        return;
    }

    struct user *u = user_lookup(name);
    if (!u || !user_password_check(u, pw)) {
        eventlog_login_failattempt(name, "web");
        web_send_error(cl, "Invalid username or password.");
        return;
    }

    telnetclient_setuser(cl, u);

    const char *charset_pref = user_extra_get(u, "charset");
    if (charset_pref) {
        struct charset *cs = charset_load(charset_pref);
        if (cs)
            telnetclient_set_encoding(cl, cs);
    }

    eventlog_signon(user_username(u), "web");
    LOG_INFO("web login: %s", user_username(u));

    web_send_login_ok(cl);
    command_start(cl, 0, NULL);
}

static void
do_create(DESCRIPTOR_DATA *cl, const char *args)
{
    char name[32], pw[64], code[INVITE_CODE_LEN + 1];
    const char *p = args;

    while (*p && isspace(*p)) p++;
    int i = 0;
    while (*p && !isspace(*p) && i < (int)sizeof(name) - 1)
        name[i++] = *p++;
    name[i] = '\0';

    while (*p && isspace(*p)) p++;
    i = 0;
    while (*p && !isspace(*p) && i < (int)sizeof(pw) - 1)
        pw[i++] = *p++;
    pw[i] = '\0';

    while (*p && isspace(*p)) p++;
    i = 0;
    while (*p && !isspace(*p) && i < (int)sizeof(code) - 1)
        code[i++] = *p++;
    code[i] = '\0';

    if (!name[0] || !pw[0]) {
        web_send_error(cl, "Usage: create <name> <password> <invite-code>");
        return;
    }

    if (!mud_config.newuser_allowed) {
        web_send_error(cl, "New account creation is currently disabled.");
        return;
    }

    if (!name_valid(name)) {
        web_send_error(cl, "Name must be 2-20 characters, start with a letter, and contain only letters, numbers, or underscores.");
        return;
    }

    if (strlen(pw) < 4) {
        web_send_error(cl, "Password must be at least 4 characters.");
        return;
    }

    if (user_exists(name)) {
        web_send_error(cl, "That name is already taken.");
        return;
    }

    if (mud_config.invite_required) {
        if (!code[0]) {
            web_send_error(cl, "An invite code is required to create an account.");
            return;
        }
        if (!invite_validate(code)) {
            web_send_error(cl, "Invalid or expired invite code.");
            return;
        }
    }

    struct user *u = user_create(name, pw, "");
    if (!u) {
        web_send_error(cl, "Could not create account.");
        return;
    }

    if (mud_config.invite_required && code[0])
        invite_use(code);

    invite_create_for_user(name, 3);

    telnetclient_setuser(cl, u);
    eventlog_signon(user_username(u), "web");
    LOG_INFO("web account created: %s", user_username(u));

    web_send_login_ok(cl);
    command_start(cl, 0, NULL);
}

static void
weblogin_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
    while (*line && isspace(*line)) line++;

    if (!*line)
        return;

    if (strncasecmp(line, "connect ", 8) == 0) {
        do_connect(cl, line + 8);
    } else if (strncasecmp(line, "create ", 7) == 0) {
        do_create(cl, line + 7);
    } else {
        web_send_error(cl, "Use 'connect <name> <password>' or 'create <name> <password> <code>'.");
    }
}

void
weblogin_start(DESCRIPTOR_DATA *cl)
{
    telnetclient_start_lineinput(cl, weblogin_lineinput, NULL);
}
