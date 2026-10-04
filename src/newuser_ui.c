/* newuser_ui.c : the new-user application form on the interactive UI layer */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "ui.h"
#include <boris.h>
#include "telnetclient.h"
#include "user.h"
#include "login.h"
#include "game.h"
#include "mudconfig.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct newuser_data {
	char username[32];
	char password[64];
	char password2[64];
	char email[128];
};

/* the frame, its fields, and the binding, allocated together per connection.
 * frame is first so the free hook can cast back to the whole block. */
struct newuser_ui {
	struct ui_frame frame;
	struct ui_field fields[4];
	struct newuser_data data;
};

static char *
nd_slot(struct newuser_data *d, const char *key, size_t *sz)
{
	if (!strcmp(key, "username"))  { *sz = sizeof d->username;  return d->username; }
	if (!strcmp(key, "password"))  { *sz = sizeof d->password;  return d->password; }
	if (!strcmp(key, "password2")) { *sz = sizeof d->password2; return d->password2; }
	if (!strcmp(key, "email"))     { *sz = sizeof d->email;     return d->email; }
	return NULL;
}

static int
nd_get(void *ctx, const char *key, char *buf, size_t len)
{
	size_t sz;
	char *v = nd_slot(ctx, key, &sz);

	if (!v)
		return -1;
	return (int)snprintf(buf, len, "%s", v);
}

static int
nd_set(void *ctx, const char *key, const char *value)
{
	size_t sz;
	char *v = nd_slot(ctx, key, &sz);

	if (!v)
		return -1;
	snprintf(v, sz, "%s", value);
	return 0;
}

/* --- validators (same rules as the old form.c checks) ---------------- */

static int
v_username(void *ctx, const char *value, const char **err)
{
	const char *s;

	(void)ctx;
	if (strlen(value) < 3) {
		*err = mud_config.msg_usermin3;
		return -1;
	}
	if (!isalpha((unsigned char)value[0])) {
		*err = mud_config.msg_useralphanumeric;
		return -1;
	}
	for (s = value; *s; s++)
		if (!isalnum((unsigned char)*s)) {
			*err = mud_config.msg_useralphanumeric;
			return -1;
		}
	if (user_exists(value)) {
		*err = mud_config.msg_userexists;
		return -1;
	}
	return 0;
}

static int
v_password(void *ctx, const char *value, const char **err)
{
	(void)ctx;
	if (strlen(value) <= 3) {
		*err = "Password must be more than 3 characters.";
		return -1;
	}
	return 0;
}

static int
v_password2(void *ctx, const char *value, const char **err)
{
	struct newuser_data *d = ctx;

	if (strcmp(value, d->password) != 0) {
		*err = "Passwords do not match.";
		return -1;
	}
	return 0;
}

/* --- submit ---------------------------------------------------------- */

static int
nu_submit(struct ui_session *s, void *binding)
{
	struct newuser_data *d = binding;
	DESCRIPTOR_DATA *cl = s->cl;
	struct user *u;

	/* re-check the match in case password changed after confirm was set */
	if (strcmp(d->password, d->password2) != 0) {
		telnetclient_puts(cl, "Passwords do not match.\n");
		return -1;
	}
	if (user_exists(d->username)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		return -1;
	}
	u = user_create(d->username, d->password, d->email);
	if (!u) {
		telnetclient_printf(cl, "Could not create user named '%s'.\n",
			d->username);
		return -1;
	}
	telnetclient_puts(cl, mud_config.msg_usercreatesuccess);
	return 0;	/* accept -> pop -> on_close opens the login menu */
}

/* frame is the first member, so freeing it frees the whole block */
static void
nu_free(struct ui_frame *f)
{
	free(f);
}

static void
nu_on_close(DESCRIPTOR_DATA *cl)
{
	login_ui_open(cl);
}

void
newuser_ui_open(DESCRIPTOR_DATA *cl)
{
	struct newuser_ui *nu = calloc(1, sizeof *nu);

	if (!nu) {
		signoff(cl, 0, NULL);
		return;
	}
	nu->fields[0] = (struct ui_field){ .label = "Username", .key = "username",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = nd_get, .set = nd_set, .validate = v_username };
	nu->fields[1] = (struct ui_field){ .label = "Password", .key = "password",
		.type = UI_STRING, .flags = UI_F_REQUIRED | UI_F_HIDDEN,
		.get = nd_get, .set = nd_set, .validate = v_password };
	nu->fields[2] = (struct ui_field){ .label = "Confirm password",
		.key = "password2", .type = UI_STRING,
		.flags = UI_F_REQUIRED | UI_F_HIDDEN,
		.get = nd_get, .set = nd_set, .validate = v_password2 };
	nu->fields[3] = (struct ui_field){ .label = "Email", .key = "email",
		.type = UI_STRING, .flags = UI_F_REQUIRED,
		.get = nd_get, .set = nd_set };

	nu->frame = (struct ui_frame){
		.title = "New User Application",
		.fields = nu->fields,
		.nr_fields = 4,
		.action_mask = UI_A(UI_ACT_SUBMIT) | UI_A(UI_ACT_QUIT),
		.wizard = 1,
		.binding = &nu->data,
		.on_submit = nu_submit,
		.free = nu_free,
	};

	ui_open(cl, &nu->frame, nu_on_close);
}
