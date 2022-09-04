/**
 * @file menu.c
 *
 * Draws menus to a telnetclient
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

#include "menu.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define LOG_SUBSYSTEM "menu"
#include <log.h>
#include <debug.h>
#include <list.h>
#include <mudconfig.h>
#include <telnetclient.h>

/** callback to handle a line of input. */
static void
menu_lineinput(DESCRIPTOR_DATA *cl, const char *line)
{
	menu_input(cl, cl->state.menu, line);
}

/** start menu input mode for a telnet client. */
void
menu_start_input(DESCRIPTOR_DATA *cl, const struct menuinfo *menu)
{
	telnetclient_clear_statedata(cl); /* this is a fresh state */
	cl->state.menu = menu;
	menu_show(cl, cl->state.menu);
	telnetclient_start_lineinput(cl, menu_lineinput, mud_config.menu_prompt);
}

/** initialize a menuinfo structure. */
void
menu_create(struct menuinfo *mi, const char *title)
{
	assert(mi != NULL);
	LIST_INIT(&mi->items);
	mi->title_width = strlen(title);
	mi->title = malloc(mi->title_width + 1);
	FAILON(!mi->title, "malloc()", failed);
	strcpy(mi->title, title);
	mi->tail = NULL;
failed:
	return;
}

/** add a new menuitem to a menuinfo. */
void
menu_additem(struct menuinfo *mi, int ch, const char *name, void (*func)(void*, long, void*), long extra2, void *extra3)
{
	struct menuitem *newitem;
	newitem = malloc(sizeof * newitem);
	newitem->name = strdup(name);
	newitem->key = ch;
	LOG_TODO("check for duplicate keys");
	newitem->action_func = func;
	newitem->extra2 = extra2;
	newitem->extra3 = extra3;

	if (mi->tail) {
		LIST_INSERT_AFTER(mi->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&mi->items, newitem, item);
	}

	mi->tail = newitem;
}

/**
 * draw a little box around the string.
 */
void
menu_titledraw(DESCRIPTOR_DATA *cl, const char *title, size_t len)
{
#if __STDC_VERSION__ >= 199901L
	char buf[len + 2];
#else
	char buf[256];

	if (len > sizeof buf - 1)
		len = sizeof buf - 1;

#endif
	memset(buf, '=', len);
	buf[len] = '\n';
	buf[len + 1] = 0;

	if (cl)
		telnetclient_puts(cl, buf);

	LOG_DEBUG("%s>>%s", telnetclient_socket_name(cl), buf);

	if (cl)
		telnetclient_printf(cl, "%s\n", title);

	LOG_DEBUG("%s>>%s\n", telnetclient_socket_name(cl), title);

	if (cl)
		telnetclient_puts(cl, buf);

	LOG_DEBUG("%s>>%s", telnetclient_socket_name(cl), buf);
}

/** send the selection menu to a telnetclient. */
void
menu_show(DESCRIPTOR_DATA *cl, const struct menuinfo *mi)
{
	const struct menuitem *curr;

	assert(mi != NULL);
	menu_titledraw(cl, mi->title, mi->title_width);

	for (curr = LIST_TOP(mi->items); curr; curr = LIST_NEXT(curr, item)) {
		if (curr->key) {
			if (cl)
				telnetclient_printf(cl, "%c. %s\n", curr->key, curr->name);

			LOG_DEBUG("%s>>%c. %s\n", telnetclient_socket_name(cl), curr->key, curr->name);
		} else {
			if (cl)
				telnetclient_printf(cl, "%s\n", curr->name);

			LOG_DEBUG("%s>>%s\n", telnetclient_socket_name(cl), curr->name);
		}
	}
}

/** process input into the menu system. */
void
menu_input(DESCRIPTOR_DATA *cl, const struct menuinfo *mi, const char *line)
{
	const struct menuitem *curr;

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	for (curr = LIST_TOP(mi->items); curr; curr = LIST_NEXT(curr, item)) {
		if (tolower(*line) == tolower(curr->key)) {
			if (curr->action_func) {
				curr->action_func(cl, curr->extra2, curr->extra3);
			} else {
				telnetclient_puts(cl, mud_config.msg_unsupported);
				menu_show(cl, mi);
			}

			return;
		}
	}

	telnetclient_puts(cl, mud_config.msg_invalidselection);
	menu_show(cl, mi);
	telnetclient_setprompt(cl, mud_config.menu_prompt);
}

/**
 * used as a generic starting point for menus.
 */
void
menu_start(void *p, long unused2, void *extra3)
{
	(void)unused2;

	DESCRIPTOR_DATA *cl = p;
	struct menuinfo *mi = extra3;
	menu_start_input(cl, mi);
}
