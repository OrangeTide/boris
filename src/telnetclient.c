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
#include <net.h>
#include <list.h>
#include <mud.h>
#define LOG_SUBSYSTEM "telnetserver"
#include <log.h>
#include <debug.h>
#include <eventlog.h>
#include <game.h>
#include <mudconfig.h>
#include <user.h>
#include <character.h>
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
	struct net_stream *stream;
};

/******************************************************************************
 * Globals
 ******************************************************************************/

static LIST_HEAD(struct server_list_head, struct telnetserver) server_list;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

static void telnetserver_on_accept(net_event *e);
static void telnetserver_on_error(net_event *e);
static int telnetclient_channel_add(DESCRIPTOR_DATA *cl, struct channel *ch);
static int telnetclient_channel_remove(DESCRIPTOR_DATA *cl, struct channel *ch);
static void telnetclient_on_destroy(net_event *e);
static void telnetclient_channel_send(struct channel_member *cm, struct channel *ch, const char *msg);
static DESCRIPTOR_DATA *telnetclient_newclient(struct telnetserver *server, struct net_stream *stream);

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
telnetclient_on_data(net_event *e)
{
	DESCRIPTOR_DATA *cl = e->udata;

	LOG_INFO("Data received! (%d bytes)", (int)e->size);

	if (!cl) {
		LOG_ERROR("Illegal client state! [fd=%ld, %s:%u]",
			  (long)net_get_socket(e->stream),
			  net_get_address(e->stream), net_get_port(e->stream));
		net_close(e->stream);
		return;
	}

	size_t outlen;
	unsigned char *output = buf_reserve(cl->linebuf, &outlen, e->size + 1);
	if (!output || (long)outlen < e->size) {
		LOG_CRITICAL("Unable to reserse buffer memory. [fd=%ld, %s]",
			     (long)net_get_socket(e->stream),
			     telnetclient_socket_name(cl));
		net_close(e->stream);
		return;
	}

	LOG_DEBUG("[%s] e->size=%zd outlen=%zd",
		  telnetclient_socket_name(cl),
		  e->size,
		  outlen);

	int size = translate_telopts(cl, (unsigned char*)e->data, e->size, output, 0);
	buf_commit(cl->linebuf, size);

	size_t cmdlen;
	char *cmd = buf_data(cl->linebuf, &cmdlen);
	size_t consumed = 0;
	while (consumed < cmdlen) {
		char *start = cmd + consumed;
		char *end = strchr(start, '\n');
		if (!end) {
			break; /* no more complete lines */
		}

		/* force redraw of prompt for blank lines */
		if (end == start) {
			end++;
			consumed++;
			cl->prompt_flag = 0;
			telnetclient_prompt_refresh(cl);
			continue; /* ignore blank lines */
		}

		size_t linelen = end - start;
		*end = 0; /* null terminate the string */
		if (linelen > 0) {
			if (cl->line_input) {
				cl->line_input(cl, start);
			} else {
				LOG_WARNING("Missing or invalid line input handler [fd=%ld %s]", (long)net_get_socket(e->stream), telnetclient_socket_name(cl));
				telnetclient_printf(cl, "ERROR, missing or invalid line input handler: \"%.*s\"\n", linelen, start);
			}
		}
		consumed += linelen + 1;
	}
	buf_consume(cl->linebuf, consumed);
}

static void
telnetserver_on_accept(net_event *e)
{
	DESCRIPTOR_DATA *cl = telnetclient_newclient(e->udata, e->remote);

	if (!cl) {
		LOG_ERROR("Could not create new client");
		return;
	}

	LOG_INFO("*** Connection %ld: %s", (long)net_get_socket(e->remote), telnetclient_socket_name(cl));
}

static void
telnetserver_on_error(net_event *e)
{
	LOG_CRITICAL("telnet server error: %s", e->msg);
}

static void
telnetclient_on_error(net_event *e)
{
	LOG_CRITICAL("telnet client error: %s", e->msg);
	if (e->udata) {
		DESCRIPTOR_DATA *cl = e->udata;
		cl->stream = NULL;
	}
	net_close(e->stream);
}

/** free a telnetclient structure. */
static void
telnetclient_on_destroy(net_event *e)
{
	DESCRIPTOR_DATA *client = e->udata;

	assert(client != NULL);

	if (!client)
		return;

	LIST_REMOVE(client, list);

	telnetclient_close(client);

	telnetclient_clear_statedata(client); /* free data associated with current state */

	free(client->prompt_string);
	client->prompt_string = NULL;

	uninit_mth_socket(client);

	buf_free(client->linebuf);
	client->linebuf = NULL;

	if (client->character) {
		character_put(client->character);
		client->character = NULL;
	}

#ifndef NDEBUG
	memset(client, 0xBB, sizeof * client); /* fill with fake data before freeing */
#endif
	user_put(&client->user);

	free(client);
}

/** notifies a client's disconnect. */
static void
telnetclient_on_close(net_event *e)
{
	DESCRIPTOR_DATA *client = e->udata;

	assert(client != NULL);

	if (!client)
		return;

	LOG_TODO("Determine if connection was logged in first");
	eventlog_signoff(telnetclient_username(client), telnetclient_socket_name(client));

	/* notify all joined channels before departing */
	{
		unsigned i;
		struct channel_member *exclude_list[] = { &client->channel_member };
		const char *name = telnetclient_username(client);

		for (i = 0; i < client->nr_channel; i++) {
			channel_broadcast(client->channel[i], exclude_list, 1,
				"%s has left the channel.\n", name);
		}
	}

	/* forcefully leave all channels */
	client->channel_member.send = NULL;
	client->channel_member.p = NULL;
	LOG_DEBUG("client->nr_channel=%d", client->nr_channel);

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

	/* treat as already closedif stream is NULL */
	int state = d && d->stream ? net_get_state(d->stream) : NET_STATE_CLOSED;

	if (state == NET_STATE_CONNECTED) {
		if (d->mth->mccp2) {
			write_mccp2(d, txt, length);
		} else {
			net_write(d->stream, txt, length);
		}
	} else if (state == NET_STATE_CLOSED) {
		/* silently ignore - clean up will occur on next loop iteration */
	} else {
		/* not a valid socket type or not ready for writing */
		LOG_INFO("%s():failed to write to fd (%ld) state=%d len=%d", __func__, (long)net_get_socket(d->stream), net_get_state(d->stream), length);
	}

	return 0;
}

/* process regular input data, escape newline as CR/LF and IAC as IAC IAC */
static void
write_escaped(DESCRIPTOR_DATA *d, const char *txt, int length)
{
	const char *base = txt;
	int len = length;

	while (len > 0) {
		const char *nl = memchr(base, '\n', len);
		const char *iac = memchr(base, '\xff', len);

		/* find whichever special byte comes first */
		const char *next = NULL;
		if (nl && (!iac || nl <= iac))
			next = nl;
		else if (iac)
			next = iac;

		if (!next) {
			write_to_descriptor(d, base, len);
			break;
		}

		/* write data before the special byte */
		if (next > base)
			write_to_descriptor(d, base, next - base);

		if (*next == '\n') {
			write_to_descriptor(d, "\r\n", 2);
		} else {
			/* escape IAC (0xFF) by doubling it */
			write_to_descriptor(d, "\xff\xff", 2);
		}

		next++;
		len -= next - base;
		assert(len >= 0);
		base = next;
	}
}

/** write a null terminated string to a telnetclient buffer. */
int
telnetclient_puts(DESCRIPTOR_DATA *cl, const char *s)
{
	assert(cl != NULL);
	assert(cl->stream != NULL);

	size_t n = strlen(s);
	write_escaped(cl, s, n);
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

	write_escaped(cl, buf, strlen(buf));
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
			LOG_DEBUG("channel_part(%p, %p)", (void*)cl->channel[i], (void*)&cl->channel_member);

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
telnetclient_newclient(struct telnetserver *server, struct net_stream *stream)
{
	DESCRIPTOR_DATA *cl = malloc(sizeof * cl);
	FAILON(!cl, "malloc()", failed);

	JUNKINIT(cl, sizeof * cl);

	*cl = (DESCRIPTOR_DATA){
			.stream = stream,
			.type = CLIENT_TYPE_USER,
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

	net_add_listener(stream, NET_EVENT_ERROR, telnetclient_on_error, server);
	net_add_listener(stream, NET_EVENT_DESTROY, telnetclient_on_destroy, cl);
	net_add_listener(stream, NET_EVENT_DATA, telnetclient_on_data, cl);
	net_add_listener(stream, NET_EVENT_CLOSE, telnetclient_on_close, cl);

	init_mth_socket(cl);

	telnetclient_puts(cl, mud_config.msgfile_welcome);

	menu_start_input(cl, &gamemenu_login);

	LIST_INSERT_HEAD(&server->client_list, cl, list);

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
	if (u) {
		user_get(u);
	}
	user_put(&old_user);
}

/**
 * replaces the current character with a different one and updates reference counts.
 */
void
telnetclient_setcharacter(DESCRIPTOR_DATA *cl, struct character *ch)
{
	struct character *old;
	assert(cl != NULL);
	old = cl->character;
	cl->character = ch;
	if (ch) {
		/* caller already holds a reference -- we take ownership */
	}
	if (old) {
		character_put(old);
	}
}

/**
 * return the character associated with this descriptor.
 */
struct character *
telnetclient_character(DESCRIPTOR_DATA *cl)
{
	assert(cl != NULL);
	return cl->character;
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

static void
telnetclient_output_prompt(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->prompt_string) {
		// LOG_TRACE("Outputing prompt [user=%s]", user_username(cl->user));
		telnetclient_puts(cl, cl->prompt_string);
		cl->prompt_flag = 1;
	}
}

/** configures the prompt string for telnetclient_rdev_lineinput. */
void
telnetclient_setprompt(DESCRIPTOR_DATA *cl, const char *prompt)
{
	char *oldprompt = cl->prompt_string;
	cl->prompt_string = strdup(prompt ? prompt : "? ");
	telnetclient_output_prompt(cl);
	free(oldprompt);
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
		struct net_stream *stream = cl->stream;
		cl->stream = NULL;
		net_close(stream);
	}
}

/** display the currently configured prompt string again. */
void
telnetclient_prompt_refresh(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->type == CLIENT_TYPE_USER
	    && cl->prompt_string && !cl->prompt_flag) {
		telnetclient_output_prompt(cl);
	}
}

/** update the prompts on all open sockets if they are type 1(client). */
void
telnetclient_prompt_refresh_all(struct telnetserver *server)
{
	DESCRIPTOR_DATA *curr, *next;

	for (curr = LIST_TOP(server->client_list); curr; curr = next) {
		// LOG_TRACE("Refreshing prompt %p [username=%s]", curr, user_username(curr->user));
		next = LIST_NEXT(curr, list);
		telnetclient_prompt_refresh(curr);
	}
}

struct channel_member *
telnetclient_channel_member(DESCRIPTOR_DATA *cl)
{
	return &cl->channel_member;
}


struct net_stream *
telnetclient_socket_handle(DESCRIPTOR_DATA *cl)
{
	return cl->stream;
}

const char *
telnetclient_socket_name(DESCRIPTOR_DATA *cl)
{
	static char tmp[64];

	if (cl && cl->stream) {
		snprintf(tmp, sizeof(tmp), "%s:%u", net_get_address(cl->stream), net_get_port(cl->stream));
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

	struct net_stream *s = net_new_stream();
	if (!s) {
		free(server);
		return ERR;
	}

	net_add_listener(s, NET_EVENT_ERROR, telnetserver_on_error, server);
	net_add_listener(s, NET_EVENT_ACCEPT, telnetserver_on_accept, server);
	if (net_listen(s, port) != 0) {
		net_close(s);
		free(server);
		return ERR;
	}

	LIST_INIT(&server->client_list);
	server->stream = s;

	LIST_INSERT_HEAD(&server_list, server, list);

	LOG_INFO("Listening on port %u", port);

	return OK;
}

void
telnetserver_shutdown(void)
{
	struct telnetserver *server;

	while ((server = LIST_TOP(server_list))) {
		LIST_REMOVE(server, list);
		free(server);
	}
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
