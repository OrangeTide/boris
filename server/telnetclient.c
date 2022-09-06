/**
 * @file telnetclient.c
 *
 * Processes data from a socket for Telnet protocol
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

#include "telnetclient.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <dyad.h>
#include <list.h>
#include <mud.h>
#define LOG_SUBSYSTEM "telnetserver"
#include <log.h>
#include <debug.h>
#include <eventlog.h>
#include <game.h>
#include <mudconfig.h>
#include <user.h>
#include <menu.h>
#include <mth.h>
#include <buf.h>

#define OK (0)
#define ERR (-1)

/******************************************************************************
 * Data structures
 ******************************************************************************/

struct telnetserver {
	LIST_HEAD(struct client_list_head, DESCRIPTOR_DATA) client_list;
	LIST_ENTRY(struct telnetserver) list;
	dyad_Stream *stream;
};

/******************************************************************************
 * Globals
 ******************************************************************************/

static LIST_HEAD(struct server_list_head, struct telnetserver) server_list;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

static void telnetclient_on_accept(dyad_Event *e);
static void telnetclient_on_error(dyad_Event *e);
static int telnetclient_channel_add(DESCRIPTOR_DATA *cl, struct channel *ch);
static int telnetclient_channel_remove(DESCRIPTOR_DATA *cl, struct channel *ch);
static void telnetclient_on_destroy(dyad_Event *e);
static void telnetclient_channel_send(struct channel_member *cm, struct channel *ch, const char *msg);
static DESCRIPTOR_DATA *telnetclient_newclient(dyad_Stream *stream);

/******************************************************************************
 * Functions
 ******************************************************************************/

/** start line input mode on a telnetclient. */
void
telnetclient_start_lineinput(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt)
{
	assert(cl != NULL);
	telnetclient_setprompt(cl, prompt);
	cl->line_input = line_input;
}

static void
telnetclient_on_data(dyad_Event *e)
{
	DESCRIPTOR_DATA *cl = e->udata;

	LOG_INFO("Data received! (%d bytes)", (int)e->size);

	if (!cl) {
		LOG_ERROR("Illegal client state! [fd=%ld, %s:%u]\n",
			  (long)dyad_getSocket(e->remote),
			  dyad_getAddress(e->remote), dyad_getPort(e->remote));
		dyad_close(e->remote);
		return;
	}

	size_t outlen;
	unsigned char *output = buf_reserve(cl->linebuf, &outlen, e->size + 1);
	if (!output || (long)outlen < e->size) {
		LOG_CRITICAL("Unable to reserse buffer memory. [fd=%ld, %s]",
			     (long)dyad_getSocket(e->remote),
			     telnetclient_socket_name(cl));
		dyad_close(e->remote);
		return;
	}

	LOG_DEBUG("[%s] e->size=%zd outlen=%zd\n",
		  telnetclient_socket_name(cl),
		  e->size,
		  outlen);

	int size = translate_telopts(cl, (unsigned char*)e->data, e->size, output, 0);
	buf_commit(cl->linebuf, size);

	// TODO: replace this simple echo code
	size_t cmdlen;
	const char *cmd = buf_data(cl->linebuf, &cmdlen);
	size_t consumed = 0;
	while (consumed < cmdlen) {
		const char *start = cmd + consumed;
		const char *end = strchr(start, '\n');
		if (!end) {
			break; /* no more complete lines */
		}
		if (end == start) {
			end++;
			continue; /* ignore blank lines */
		}

		size_t linelen = end - start;
		if (linelen > 0) {
			telnetclient_printf(cl, "Line: \"%.*s\"\n", linelen, start);
		}
		consumed += linelen + 1;
	}
	buf_consume(cl->linebuf, consumed);
}

static void
telnetclient_on_accept(dyad_Event *e)
{
	DESCRIPTOR_DATA *cl = telnetclient_newclient(e->remote);

	if (!cl) {
		LOG_ERROR("Could not create new client");
		return;
	}

	LOG_INFO("*** Connection %ld: %s", (long)dyad_getSocket(e->remote), telnetclient_socket_name(cl));
	// TODO: telnetclient_puts(cl, mud_config.msgfile_welcome);

	telnetclient_puts(cl, "## Welcome ##\r\n");
}

static void
telnetclient_on_error(dyad_Event *e)
{
	LOG_CRITICAL("telnet server error: %s", e->msg);
}

/** free a telnetclient structure. */
static void
telnetclient_on_destroy(dyad_Event *e)
{
	DESCRIPTOR_DATA *client = e->udata;

	assert(client != NULL);

	if (!client)
		return;

	telnetclient_clear_statedata(client); /* free data associated with current state */

	free(client->prompt_string);
	client->prompt_string = NULL;

	uninit_mth_socket(client);

	buf_free(client->linebuf);
	client->linebuf = NULL;

	LOG_TODO("free any other data structures associated with client"); /* TODO: be vigilant about memory leaks! */

#ifndef NDEBUG
	memset(client, 0xBB, sizeof * client); /* fill with fake data before freeing */
#endif

	free(client);
}

/** notifies a client's disconnect. */
static void
telnetclient_on_close(dyad_Event *e)
{
	DESCRIPTOR_DATA *client = e->udata;

	assert(client != NULL);

	if (!client)
		return;

	LOG_TODO("Determine if connection was logged in first");
	eventlog_signoff(telnetclient_username(client), telnetclient_socket_name(client));
	/* forcefully leave all channels */
	/* TODO: nobody is notified that we left, this is not ideal. */
	client->channel_member.send = NULL;
	client->channel_member.p = NULL;
	LOG_DEBUG("client->nr_channel=%d\n", client->nr_channel);

	while (client->nr_channel) {
		telnetclient_channel_remove(client, client->channel[0]);
	}
}

/**
 * @return the username
 */
const char *
telnetclient_username(DESCRIPTOR_DATA *cl)
{
	if (cl) {
		if (cl->user) {
			return user_username(cl->user);
		}

		if (cl->name) {
			return cl->name;
		}
	}

	return "<UNKNOWN>";
}

/* called by MTH */
int
write_to_descriptor(DESCRIPTOR_DATA *d, const char *txt, int length)
{
	assert(d != NULL);
	assert(d->stream != NULL);

	int state = dyad_getState(d->stream);

	if (state == DYAD_STATE_CONNECTED) {
		if (d->mth->mccp2) {
			write_mccp2(d, txt, length);
		} else {
			dyad_write(d->stream, txt, length);
		}
	} else if (state == DYAD_STATE_CLOSED) {
		/* silently ignore - clean up will occur on next dyad_update() */
	} else {
		/* not a valid socket type or not ready for writing */
		LOG_INFO("%s():failed to write to fd (%ld) state=%d len=%d", __func__, (long)dyad_getSocket(d->stream), dyad_getState(d->stream), length);
	}

	return 0;
}

/** write a null terminated string to a telnetclient buffer. */
int
telnetclient_puts(DESCRIPTOR_DATA *cl, const char *s)
{
	assert(cl != NULL);
	assert(cl->stream != NULL);

	size_t n = strlen(s);
	write_to_descriptor(cl, s, n);
	// TODO: check for error
	cl->prompt_flag = 0;

	return OK;
}

/** vprintf for a telnetclient output buffer. */
int
telnetclient_vprintf(DESCRIPTOR_DATA *cl, const char *fmt, va_list ap)
{
	assert(cl != NULL);
	assert(cl->stream != NULL);
	assert(fmt != NULL);

	char buf[1024];
	vsnprintf(buf, sizeof(buf), fmt, ap);

	write_to_descriptor(cl, buf, strlen(buf));
	// TODO: check for error
	cl->prompt_flag = 0;

	return OK;
}

/** printf for a telnetclient output buffer. */
int
telnetclient_printf(DESCRIPTOR_DATA *cl, const char *fmt, ...)
{
	va_list ap;
	int res;

	va_start(ap, fmt);
	res = telnetclient_vprintf(cl, fmt, ap);
	va_end(ap);

	return res;
}

/** releases current state (frees it). */
void
telnetclient_clear_statedata(DESCRIPTOR_DATA *cl)
{
	if (cl->state_free) {
		cl->state_free(cl);
		cl->state_free = NULL;
	}

	memset(&cl->state, 0, sizeof cl->state);
}

static int
telnetclient_channel_add(DESCRIPTOR_DATA *cl, struct channel *ch)
{
	struct channel **newlist;

	assert(cl != NULL);

	if (!ch) return 1; /* adding NULL is ignored. */

	if (!channel_join(ch, &cl->channel_member)) return 0; /* could not join channel. */

	newlist = realloc(cl->channel, sizeof * cl->channel * (cl->nr_channel + 1));

	if (!newlist) {
		PERROR("realloc()");

		return 0; /* could not allocate. */
	}

	cl->channel = newlist;
	cl->channel[cl->nr_channel++] = ch;

	return 1; /* success */
}

static int
telnetclient_channel_remove(DESCRIPTOR_DATA *cl, struct channel *ch)
{
	unsigned i;

	assert(cl != NULL);

	if (!ch) return 1; /* removng NULL is ignored. */

	for (i = 0; i < cl->nr_channel; i++) {
		if (cl->channel[i] == ch) {
			LOG_DEBUG("channel_part(%p, %p)\n", (void*)cl->channel[i], (void*)&cl->channel_member);

			channel_part(cl->channel[i], &cl->channel_member);

			cl->channel[i] = NULL;
			assert(cl->nr_channel > 0); /* can't enter this condition when no channels. */
			cl->channel[i] = cl->channel[--cl->nr_channel];

			if (!cl->nr_channel) {
				/* if not in any channels then free the array. */
				free(cl->channel);
				cl->channel = NULL;
			}

			return 1; /* success */
		}
	}

	return 0; /* not found. */
}

static void
telnetclient_channel_send(struct channel_member *cm, struct channel *ch, const char *msg)
{
	assert(cm != NULL);
	assert(msg != NULL);

	if (!cm) return;

	DESCRIPTOR_DATA *cl = cm->p;

	/* TODO: fill in a channel name? */
	telnetclient_printf(cl, "[%p] %s\n", (void*)ch, msg);
}

/** allocate a new telnetclient based on an existing valid dyad handle. */
static DESCRIPTOR_DATA *
telnetclient_newclient(dyad_Stream *stream)
{
	DESCRIPTOR_DATA *cl = malloc(sizeof * cl);
	FAILON(!cl, "malloc()", failed);

	JUNKINIT(cl, sizeof * cl);

	*cl = (DESCRIPTOR_DATA){
			.stream = stream,
		};

	cl->linebuf = buf_new();

	cl->terminal.width = cl->terminal.height = 0;
	strcpy(cl->terminal.name, "");

	cl->state_free = NULL;
	telnetclient_clear_statedata(cl);

	cl->prompt_flag = 0;
	cl->prompt_string = NULL;

	cl->nr_channel = 0;
	cl->channel = NULL;
	cl->channel_member.send = telnetclient_channel_send;
	cl->channel_member.p = cl;

	telnetclient_channel_add(cl, channel_public(CHANNEL_SYS));

	dyad_addListener(stream, DYAD_EVENT_DESTROY, telnetclient_on_destroy, cl);
	dyad_addListener(stream, DYAD_EVENT_DATA, telnetclient_on_data, cl);
	dyad_addListener(stream, DYAD_EVENT_CLOSE, telnetclient_on_close, cl);

	init_mth_socket(cl);

	menu_start_input(cl, &gamemenu_login);

	return cl;
failed:
	return NULL;
}

/**
 * replaces the current user with a different one and updates the reference counts.
 */
void
telnetclient_setuser(DESCRIPTOR_DATA *cl, struct user *u)
{
	struct user *old_user;
	assert(cl != NULL);
	old_user = cl->user;
	cl->user = u;
	user_get(u);
	user_put(&old_user);
}

#if 0 // TODO: use MTH to change ECHO mode
/** send TELNET protocol messages to control echo mode. */
static int
telnetclient_echomode(DESCRIPTOR_DATA *cl, int mode)
{
	static const char echo_off[] = { IAC, WILL, TELOPT_ECHO }; /* OFF */
	static const char echo_on[] = { IAC, WONT, TELOPT_ECHO }; /* ON */
	const char *s;
	size_t len;

	if (mode) {
		s = echo_on;
		len = sizeof echo_on;
	} else {
		s = echo_off;
		len = sizeof echo_off;
	}

	dyad_write(cl->stream, s, len);
	// TODO: check for errors

	return OK;
}
#endif

#if 0 // TODO: use MTH to change line mode
/** send TELNET protocol messages to control line mode. */
static int
telnetclient_linemode(DESCRIPTOR_DATA *cl, int mode)
{
	const char enable[] = {
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_EDIT | MODE_TRAPSIG, IAC, SE
	};
	const char disable[] = { /* character at a time mode */
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_TRAPSIG, IAC, SE
	};
	const char *s;
	size_t len;

	if (mode) {
		s = enable;
		len = sizeof enable;
	} else {
		s = disable;
		len = sizeof disable;
	}

	dyad_write(cl->stream, s, len);
	// TODO: check for errors

	return OK;
}
#endif

/** configures the prompt string for telnetclient_rdev_lineinput. */
void
telnetclient_setprompt(DESCRIPTOR_DATA *cl, const char *prompt)
{
	free(cl->prompt_string);
	cl->prompt_string = strdup(prompt ? prompt : "? ");
	telnetclient_puts(cl, cl->prompt_string);
	cl->prompt_flag = 1;
}

/**
 * @return true if client is still in this state
 */
int
telnetclient_isstate(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt)
{

	if (!cl) return 0;

	return cl->line_input == line_input &&
		(cl->prompt_string == prompt || strcmp(cl->prompt_string, prompt));
}

/** mark a telnetclient to be closed and freed. */
void
telnetclient_close(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->stream) {
		dyad_close(cl->stream);
		cl->stream = NULL;
	}
}

/** display the currently configured prompt string again. */
void
telnetclient_prompt_refresh(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->prompt_string && !cl->prompt_flag) {
		telnetclient_setprompt(cl, cl->prompt_string);
	}
}

/** update the prompts on all open sockets if they are type 1(client). */
void
telnetclient_prompt_refresh_all(struct telnetserver *server)
{
	DESCRIPTOR_DATA *curr, *next;

	for (curr = LIST_TOP(server->client_list); curr; curr = next) {
		next = LIST_NEXT(curr, list);

		if (curr->type == 1) {
			telnetclient_prompt_refresh(curr);
		}
	}
}

struct channel_member *
telnetclient_channel_member(DESCRIPTOR_DATA *cl)
{
	return &cl->channel_member;
}


dyad_Stream *
telnetclient_socket_handle(DESCRIPTOR_DATA *cl)
{
	return cl->stream;
}

const char *
telnetclient_socket_name(DESCRIPTOR_DATA *cl)
{
	static char tmp[64];

	if (cl) {
		snprintf(tmp, sizeof(tmp), "%s:%u", dyad_getAddress(cl->stream), dyad_getPort(cl->stream));
	} else {
		snprintf(tmp, sizeof(tmp), "INVALID");
	}

	return tmp;
}

const struct terminal *
telnetclient_get_terminal(DESCRIPTOR_DATA *cl)
{
	return cl ? &cl->terminal : NULL;
}

int
telnetserver_listen(int port)
{
	struct telnetserver *server = malloc(sizeof(*server));
	if (!server) {
		return ERR;
	}

	dyad_Stream *s = dyad_newStream();
	if (!s) {
		free(server);
		return ERR;
	}

	dyad_addListener(s, DYAD_EVENT_ERROR,  telnetclient_on_error,  NULL);
	dyad_addListener(s, DYAD_EVENT_ACCEPT, telnetclient_on_accept, NULL);
	if (dyad_listen(s, port) != 0) {
		dyad_close(s);
		free(server);
		return ERR;
	}

	LIST_INIT(&server->client_list);
	server->stream = s;

	LIST_INSERT_HEAD(&server_list, server, list);

	LOG_INFO("Listening on port %u", port);

	return OK;
}

struct telnetserver *
telnetserver_first(void)
{
	return LIST_TOP(server_list);
}

struct telnetserver *
telnetserver_next(struct telnetserver *server)
{
	return LIST_NEXT(server, list);
}
