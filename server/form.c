/**
 * @file form.c
 *
 * Handles processing input forms
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

#include "form.h"
#include <stdlib.h>
#include <ctype.h>
#include <boris.h>
#include <mud.h>
#define LOG_SUBSYSTEM "form"
#include <log.h>
#include <debug.h>
#include <game.h>

/******************************************************************************
 * Types and data structures
 ******************************************************************************/

#define FORM_FLAG_HIDDEN 1
#define FORM_FLAG_INVISIBLE 2

/** defines a form entry. */
struct formitem {
	LIST_ENTRY(struct formitem) item;
	unsigned value_index; /* used to index the form_state->value[] array */
	char *name;
	unsigned flags;
	int (*form_check)(DESCRIPTOR_DATA *cl, const char *str);
	char *description;
	char *prompt;
};

/** current status of a form, list of filled out data. */
struct form_state {
	const struct form *form;
	const struct formitem *curritem;
	unsigned curr_i;
	unsigned nr_value;
	char **value;
	int done;
};

/** defines a form. */
struct form {
	LIST_HEAD(struct, struct formitem) items;
	struct formitem *tail;
	char *form_title;
	void (*form_close)(DESCRIPTOR_DATA *cl, struct form_state *fs);
	unsigned item_count; /* number of items */
	const char *message; /* display this message on start - points to one allocated elsewhere */
};

/******************************************************************************
 * Globals
 ******************************************************************************/

/** undocumented - please add documentation. */
static struct form *form_newuser_app;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

static void form_lineinput(DESCRIPTOR_DATA *cl, const char *line);
static void form_menu_lineinput(DESCRIPTOR_DATA *cl, const char *line);

/******************************************************************************
 * Functions
 ******************************************************************************/

/** undocumented - please add documentation. */
void
form_init(struct form *f, const char *title, void (*form_close)(DESCRIPTOR_DATA *cl, struct form_state *fs))
{
	LIST_INIT(&f->items);
	f->form_title = strdup(title);
	f->tail = NULL;
	f->form_close = form_close;
	f->item_count = 0;
	f->message = 0;
}

/**
 * define a message to be displayed on start.
 */
void
form_setmessage(struct form *f, const char *message)
{
	f->message = message;
}

/** undocumented - please add documentation. */
void
form_free(struct form *f)
{
	struct formitem *curr;

	TRACE_ENTER();

	free(f->form_title);
	f->form_title = NULL;

	while ((curr = LIST_TOP(f->items))) {
		LIST_REMOVE(curr, item);
		free(curr->name);
		free(curr->prompt);
		free(curr->description);
#ifndef NDEBUG
		memset(curr, 0x55, sizeof * curr); /* fill with fake data before freeing */
#endif
		free(curr);
	}

	memset(f, 0x55, sizeof * f); /* fill with fake data before freeing */
}

/** undocumented - please add documentation. */
void
form_additem(struct form *f, unsigned flags, const char *name, const char *prompt, const char *description, int (*form_check)(DESCRIPTOR_DATA *cl, const char *str))
{
	struct formitem *newitem;

	newitem = malloc(sizeof * newitem);
	newitem->name = strdup(name);
	newitem->description = strdup(description);
	newitem->prompt = strdup(prompt);
	newitem->flags = flags;
	newitem->form_check = form_check;
	newitem->value_index = f->item_count++;

	if (f->tail) {
		LIST_INSERT_AFTER(f->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&f->items, newitem, item);
	}

	f->tail = newitem;
}

/** undocumented - please add documentation. */
static struct formitem *
form_getitem(struct form *f, const char *name)
{
	struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for (curr = LIST_TOP(f->items); curr; curr = LIST_NEXT(curr, item)) {
		if (!strcasecmp(curr->name, name)) {
			/* found first matching entry */
			return curr;
		}
	}

	LOG_ERROR("Unknown form variable '%s'\n", name);

	return NULL; /* not found */
}

/**
 * look up the user value from a form.
 */
static const char *
form_getvalue(const struct form *f, unsigned nr_value, char **value, const char *name)
{
	const struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for (curr = LIST_TOP(f->items); curr; curr = LIST_NEXT(curr, item)) {
		if (!strcasecmp(curr->name, name) && curr->value_index < nr_value) {
			/* found matching entry that was in range */
			return value[curr->value_index];
		}
	}

	LOG_ERROR("Unknown form variable '%s'\n", name);

	return NULL; /* not found */
}

/** undocumented - please add documentation. */
static void
form_menu_show(DESCRIPTOR_DATA *cl, const struct form *f, struct form_state *fs)
{
	const struct formitem *curr;
	unsigned i;

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	for (i = 0, curr = LIST_TOP(f->items); curr && (!fs || i < fs->nr_value); curr = LIST_NEXT(curr, item), i++) {
		const char *user_value;

		/* skip over invisible items without altering the count/index */
		while (curr && (curr->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE)
			curr = LIST_NEXT(curr, item);

		if (!curr)
			break;

		user_value = fs ? fs->value[curr->value_index] ? fs->value[curr->value_index] : "" : 0;

		if ((curr->flags & FORM_FLAG_HIDDEN) == FORM_FLAG_HIDDEN) {
			user_value = "<hidden>";
		}

		telnetclient_printf(cl, "%d. %s %s\n", i + 1, curr->prompt, user_value ? user_value : "");
	}

	telnetclient_printf(cl, "A. accept\n");
}

/** undocumented - please add documentation. */
static void
form_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	struct form_state *fs = cl->state.form;
	const struct form *f = fs->form;
	char **value = &fs->value[fs->curritem->value_index];

	assert(f != NULL);
	assert(fs->curritem != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (*line) {
		/* check the input */
		if (fs->curritem->form_check && !fs->curritem->form_check(cl, line)) {
			LOG_DEBUG("%s:Invalid form input\n", telnetclient_socket_name(cl));
			telnetclient_puts(cl, mud_config.msg_tryagain);
			telnetclient_setprompt(cl, fs->curritem->prompt);
			return;
		}

		if (*value) {
			free(*value);
			*value = NULL;
		}

		*value = strdup(line);
		fs->curritem = LIST_NEXT(fs->curritem, item);

		if (fs->curritem && (!fs->done || ((fs->curritem->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE))) {
			/* go to next item if not done or if next item is invisible */
			telnetclient_puts(cl, fs->curritem->description);
			telnetclient_setprompt(cl, fs->curritem->prompt);
		} else {
			fs->done = 1; /* causes form entry to bounce back to form menu */
			/* a menu for verifying the form */
			form_menu_show(cl, f, fs);
			telnetclient_start_lineinput(cl, form_menu_lineinput, mud_config.form_prompt);
		}
	}
}

/** undocumented - please add documentation. */
static void
form_menu_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	struct form_state *fs = &cl->state.form;
	const struct form *f = fs->form;
	char *endptr;

	assert(cl != NULL);
	assert(line != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (tolower(*line) == 'a') { /* accept */
		LOG_TODO("callback to close out the form");

		if (f->form_close) {
			/* this call will switch states on success */
			f->form_close(cl, fs);
		} else {
			/* fallback */
			LOG_DEBUG("%s:ERROR:going to main menu\n", telnetclient_socket_name(cl));
			telnetclient_puts(cl, mud_config.msg_errormain);
			menu_start_input(cl, &gamemenu_login);
		}

		return; /* success */
	} else {
		long i;
		i = strtol(line, &endptr, 10);

		if (endptr != line && i > 0) {
			for (fs->curritem = LIST_TOP(f->items); fs->curritem; fs->curritem = LIST_NEXT(fs->curritem, item)) {
				/* skip invisible entries in selection */
				if ((fs->curritem->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE) continue;

				if (--i == 0) {
					telnetclient_start_lineinput(cl, form_lineinput, fs->curritem->prompt);
					return; /* success */
				}
			}
		}
	}

	/* invalid_selection */
	telnetclient_puts(cl, mud_config.msg_invalidselection);
	form_menu_show(cl, f, fs);
	telnetclient_setprompt(cl, mud_config.form_prompt);
}

/** undocumented - please add documentation. */
static void
form_state_free(DESCRIPTOR_DATA *cl)
{
	struct form_state *fs = &cl->state.form;
	unsigned i;
	LOG_DEBUG("%s:freeing state\n", telnetclient_socket_name(cl));

	if (fs->value) {
		for (i = 0; i < fs->nr_value; i++) {
			if (fs->value[i]) {
				size_t len; /* carefully erase the data from the heap, it may be private */
				len = strlen(fs->value[i]);
				memset(fs->value[i], 0, len);
				free(fs->value[i]);
				fs->value[i] = NULL;
			}
		}

		free(fs->value);
	}

	fs->value = 0;
	fs->nr_value = 0;
}

/** undocumented - please add documentation. */
void
form_state_init(struct form_state *fs, const struct form *f)
{
	fs->form = f;
	fs->nr_value = 0;
	fs->value = NULL;
	fs->done = 0;
}

/** undocumented - please add documentation. */
static int
form_createaccount_username_check(DESCRIPTOR_DATA *cl, const char *str)
{
	int res;
	size_t len;
	const char *s;

	TRACE_ENTER();

	assert(cl != NULL);

	len = strlen(str);

	if (len < 3) {
		telnetclient_puts(cl, mud_config.msg_usermin3);
		LOG_DEBUG_MSG("failure: username too short.");
		goto failure;
	}

	for (s = str, res = isalpha(*s); *s; s++) {
		res = res && isalnum(*s);

		if (!res) {
			telnetclient_puts(cl, mud_config.msg_useralphanumeric);
			LOG_DEBUG_MSG("failure: bad characters");
			goto failure;
		}
	}

	if (user_exists(str)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		LOG_DEBUG_MSG("failure: user exists.");
		goto failure;
	}

	LOG_DEBUG_MSG("success.");

	return 1;
failure:
	telnetclient_puts(cl, mud_config.msg_tryagain);
	if (cl->state.form) {
		telnetclient_setprompt(cl, cl->state.form->curritem->prompt);
	}

	return 0;
}

static int
form_createaccount_password_check(DESCRIPTOR_DATA *cl, const char *str)
{
	TRACE_ENTER();

	assert(cl != NULL);
	assert(cl->state.form->form != NULL);

	if (str && strlen(str) > 3) {
		LOG_DEBUG_MSG("success.");
		return 1;
	}

	/* failure */
	telnetclient_puts(cl, mud_config.msg_tryagain);
	telnetclient_setprompt(cl, cl->state.form->curritem->prompt);

	return 0;
}

/** verify that the second password entry matches the first */
static int
form_createaccount_password2_check(DESCRIPTOR_DATA *cl, const char *str)
{
	const char *password1;
	struct form_state *fs = &cl->state.form;

	TRACE_ENTER();

	assert(cl != NULL);
	assert(fs->form != NULL);

	password1 = form_getvalue(fs->form, fs->nr_value, fs->value, "PASSWORD");

	if (password1 && !strcmp(password1, str)) {
		LOG_DEBUG_MSG("success.");
		return 1;
	}

	telnetclient_puts(cl, mud_config.msg_tryagain);
	fs->curritem = form_getitem((struct form*)fs->form, "PASSWORD"); /* rewind to password entry */
	telnetclient_setprompt(cl, fs->curritem->prompt);

	return 0;
}

/** undocumented - please add documentation. */
static void
form_createaccount_close(DESCRIPTOR_DATA *cl, struct form_state *fs)
{
	const char *username, *password, *email;
	struct user *u;
	const struct form *f = fs->form;

	username = form_getvalue(f, fs->nr_value, fs->value, "USERNAME");
	password = form_getvalue(f, fs->nr_value, fs->value, "PASSWORD");
	email = form_getvalue(f, fs->nr_value, fs->value, "EMAIL");

	LOG_DEBUG("%s:create account: '%s'\n", telnetclient_socket_name(cl), username);

	if (user_exists(username)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		return;
	}

	LOG_TODO("u = user_create(\"%s\", \"%s\", \"%s\");", username, password, email);
	// u = user_create(username, password, email);

	if (!u) {
		telnetclient_printf(cl, "Could not create user named '%s'\n", username);
		return;
	}

	user_free(u);

	telnetclient_puts(cl, mud_config.msg_usercreatesuccess);

	LOG_TODO("for approvable based systems, disconnect the user with a friendly message");
	menu_start_input(cl, &gamemenu_login);
}

/** undocumented - please add documentation. */
static void
form_start(void *p, long unused2, void *form)
{
	(void)unused2;

	DESCRIPTOR_DATA *cl = p;
	struct form *f = form;
	struct form_state *fs = cl->state.form;

	telnetclient_clear_statedata(cl); /* this is a fresh state */

	if (!mud_config.newuser_allowed) {
		/* currently not accepting applications */
		telnetclient_puts(cl, mud_config.msgfile_newuser_deny);
		menu_start_input(cl, &gamemenu_login);
		return;
	}

	if (f->message)
		telnetclient_puts(cl, f->message);

	cl->state_free = form_state_free;
	fs->form = f;
	fs->curritem = LIST_TOP(f->items);
	fs->nr_value = f->item_count;
	fs->value = calloc(fs->nr_value, sizeof * fs->value);

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	telnetclient_puts(cl, fs->curritem->description);
	telnetclient_start_lineinput(cl, form_lineinput, fs->curritem->prompt);
}

/** undocumented - please add documentation. */
void
form_createaccount_start(void *p, long unused2, void *unused3)
{
	(void)unused2;
	(void)unused3;

	form_start(p, 0, form_newuser_app);
}

/** undocumented - please add documentation. */
struct form *form_load(const char *buf, void (*form_close)(DESCRIPTOR_DATA *cl, struct form_state *fs))
{
	const char *p, *tmp;
	char *name, *prompt, *description, *title;
	struct form *f;
	struct util_strfile h;
	size_t e, len;

	name = 0;
	prompt = 0;
	description = 0;
	f = 0;

	util_strfile_open(&h, buf);

	p = util_strfile_readline(&h, &len);

	if (!p) {
		LOG_ERROR("Could not parse form.");
		goto failure;
	}

	title = malloc(len + 1);
	memcpy(title, p, len);
	title[len] = 0;

	f = calloc(1, sizeof * f);
	form_init(f, title, form_close);

	free(title);
	title = NULL;

	/* count number of entries */
	while (1) {

		/* look for the name */
		do {
			p = util_strfile_readline(&h, &len);

			if (!p)
				goto done;

			while (isspace(*p)) p++ ; /* skip leading blanks and blank lines */

			for (e = 0; e < len && !isspace(p[e]); e++) ;
		} while (!e);

		/* found a word */
		name = malloc(e + 1);
		memcpy(name, p, e);
		name[e] = 0;

		/* look for the prompt */
		p = util_strfile_readline(&h, &len);

		if (!p) break;

		prompt = malloc(len + 1);
		memcpy(prompt, p, len);
		prompt[len] = 0;

		/* find end of description */
		tmp = strstr(h.buf, "\n~");

		if (!tmp)
			tmp = strlen(h.buf) + h.buf;
		else
			tmp++;

		len = tmp - h.buf;
		description = malloc(len + 1);
		memcpy(description, h.buf, len);
		description[len] = 0;
		h.buf = *tmp ? tmp + 1 : tmp;

		LOG_DEBUG("name='%s'\n", name);
		LOG_DEBUG("prompt='%s'\n", prompt);
		LOG_DEBUG("description='%s'\n", description);
		form_additem(f, 0, name, prompt, description, NULL);
		free(name);
		name = 0;
		free(prompt);
		prompt = 0;
		free(description);
		description = 0;
	}

done:
	util_strfile_close(&h);
	free(name); /* with current loop will always be NULL */
	free(prompt); /* with current loop will always be NULL */
	free(description); /* with current loop will always be NULL */
	return f;
failure:
	LOG_ERROR("Error loading form");
	util_strfile_close(&h);
	free(name);
	free(prompt);
	free(description);

	if (f) {
		form_free(f);
	}

	return NULL;
}

/** undocumented - please add documentation. */
struct form *form_load_from_file(const char *filename, void (*form_close)(DESCRIPTOR_DATA *cl, struct form_state *fs))
{
	struct form *ret;
	char *buf;

	buf = util_textfile_load(filename);

	if (!buf) return 0;

	ret = form_load(buf, form_close);
	free(buf);

	return ret;
}

/** undocumented - please add documentation. */
int
form_module_init(void)
{
	struct formitem *fi;

	form_newuser_app = form_load_from_file(mud_config.form_newuser_filename, form_createaccount_close);

	if (!form_newuser_app) {
		LOG_ERROR("could not load %s\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi = form_getitem(form_newuser_app, "USERNAME");

	if (!fi) {
		LOG_ERROR("%s does not have a USERNAME field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi->form_check = form_createaccount_username_check;

	fi = form_getitem(form_newuser_app, "PASSWORD");

	if (!fi) {
		LOG_ERROR("%s does not have a PASSWORD field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi->flags |= FORM_FLAG_HIDDEN; /* hidden */
	fi->form_check = form_createaccount_password_check;

	fi = form_getitem(form_newuser_app, "PASSWORD2");

	if (!fi) {
		LOG_INFO("warning: %s does not have a PASSWORD2 field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	} else {
		fi->flags |= FORM_FLAG_INVISIBLE; /* invisible */
		fi->form_check = form_createaccount_password2_check;
	}

	return 1;
}

/** undocumented - please add documentation. */
void
form_module_shutdown(void)
{
	form_free(form_newuser_app);
	free(form_newuser_app);
	form_newuser_app = NULL;
}
