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
#include <boris.h>
#include <obj.h>
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
#include <charset.h>
#include <webclient.h>
#include <weblogin.h>
#include <wordwrap.h>

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

/* telnetclient_start_lineinput sets the line input handler and prompt for a client. */
void
telnetclient_start_lineinput(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt)
{
	assert(cl != NULL);
	telnetclient_setprompt(cl, prompt);
	cl->line_input = line_input;
}

/* telnetclient_on_data processes incoming data from a client socket. */
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

	if (cl->mth) {
		if (cl->mth->cols > 0)
			cl->terminal.width = cl->mth->cols;
		if (cl->mth->rows > 0)
			cl->terminal.height = cl->mth->rows;
	}

	if (cl->encoding && size > 0) {
		char conv[2048];
		int conv_len = charset_to_utf8(cl->encoding,
					       (const char *)output, size,
					       conv, sizeof(conv));
		if (conv_len > 0 && (size_t)conv_len <= outlen) {
			memcpy(output, conv, conv_len);
			size = conv_len;
		}
	}

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
				telnetclient_set_buffered(cl);
				cl->line_input(cl, start);
				telnetclient_clear_buffered(cl);
			} else {
				LOG_WARNING("Missing or invalid line input handler [fd=%ld %s]", (long)net_get_socket(e->stream), telnetclient_socket_name(cl));
				telnetclient_printf(cl, "ERROR, missing or invalid line input handler: \"%.*s\"\n", linelen, start);
			}
		}
		consumed += linelen + 1;
	}
	buf_consume(cl->linebuf, consumed);
}

/* telnetserver_on_accept handles a new incoming connection. */
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

/* telnetserver_on_error logs a server-level error. */
static void
telnetserver_on_error(net_event *e)
{
	LOG_CRITICAL("telnet server error: %s", e->msg);
}

/* telnetclient_on_error logs a client-level error and closes the stream. */
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

/* telnetclient_on_destroy frees a client and all its associated resources. */
static void
telnetclient_on_destroy(net_event *e)
{
	DESCRIPTOR_DATA *client = e->udata;

	assert(client != NULL);

	if (!client)
		return;

	LIST_REMOVE(client, list);

	/* Clear the stream pointer without calling net_close -- we are
	 * already inside stream_free, so re-entering net_close would
	 * double-free the stream and this client struct. */
	client->stream = NULL;

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

	user_put(&client->user);

#ifndef NDEBUG
	memset(client, 0xBB, sizeof * client); /* fill with fake data before freeing */
#endif

	free(client);
}

/* telnetclient_on_close handles a client disconnect by notifying channels and cleaning up. */
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

/* telnetclient_username returns the username associated with the client. */
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

/* write_to_descriptor writes raw bytes to a client's stream, called by MTH. */
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

/* write_escaped writes text to a descriptor, escaping newlines as CR/LF and IAC bytes. */
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

/* telnetclient_puts writes a null-terminated string to a client. */
int
telnetclient_puts(DESCRIPTOR_DATA *cl, const char *s)
{
	assert(cl != NULL);

	size_t n = strlen(s);

	if (cl->ops && cl->ops->puts) {
		cl->ops->puts(cl, s, n);
	} else {
		assert(cl->stream != NULL);
		if (cl->encoding) {
			char buf[2048];
			int len = charset_from_utf8(cl->encoding, s, n, buf, sizeof(buf));
			write_escaped(cl, buf, len);
		} else {
			write_escaped(cl, s, n);
		}
	}

	cl->prompt_flag = 0;

	return OK;
}

/* telnetclient_vprintf formats and writes a string to a client using a va_list. */
int
telnetclient_vprintf(DESCRIPTOR_DATA *cl, const char *fmt, va_list ap)
{
	assert(cl != NULL);
	assert(fmt != NULL);

	char buf[1024];
	vsnprintf(buf, sizeof(buf), fmt, ap);

	size_t n = strlen(buf);

	if (cl->ops && cl->ops->puts) {
		cl->ops->puts(cl, buf, n);
	} else {
		assert(cl->stream != NULL);
		if (cl->encoding) {
			char conv[2048];
			int len = charset_from_utf8(cl->encoding, buf, n, conv, sizeof(conv));
			write_escaped(cl, conv, len);
		} else {
			write_escaped(cl, buf, n);
		}
	}

	cl->prompt_flag = 0;

	return OK;
}

/* telnetclient_printf formats and writes a string to a client. */
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

/* telnetclient_clear_statedata frees the current state data and zeroes the state union. */
void
telnetclient_clear_statedata(DESCRIPTOR_DATA *cl)
{
	if (cl->state_free) {
		cl->state_free(cl);
		cl->state_free = NULL;
	}

	memset(&cl->state, 0, sizeof cl->state);
}

/* telnetclient_channel_add joins the client to a channel and appends it to the client's channel list. */
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

/* telnetclient_channel_remove parts the client from a channel and removes it from the client's channel list. */
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

/* telnetclient_channel_send delivers a channel message to the client. */
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

/* telnetclient_newclient allocates and initializes a new client on the given stream. */
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

/* telnetclient_setuser replaces the current user, updating reference counts on both old and new. */
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

/* telnetclient_setcharacter replaces the current character, releasing the old one. */
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

/* telnetclient_character returns the character associated with the client. */
struct character *
telnetclient_character(DESCRIPTOR_DATA *cl)
{
	assert(cl != NULL);
	return cl->character;
}

#if 0 // TODO: use MTH to change ECHO mode
/* telnetclient_echomode sends TELNET protocol messages to enable or disable echo. */
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
/* telnetclient_linemode sends TELNET protocol messages to enable or disable line mode. */
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

/* telnetclient_output_prompt writes the prompt string to the client and sets the prompt flag. */
static void
telnetclient_output_prompt(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->prompt_string) {
		// LOG_TRACE("Outputing prompt [user=%s]", user_username(cl->user));
		telnetclient_puts(cl, cl->prompt_string);
		cl->prompt_flag = 1;
	}
}

/* telnetclient_setprompt sets the prompt string and immediately displays it. */
void
telnetclient_setprompt(DESCRIPTOR_DATA *cl, const char *prompt)
{
	char *oldprompt = cl->prompt_string;
	cl->prompt_string = strdup(prompt ? prompt : "? ");
	telnetclient_output_prompt(cl);
	free(oldprompt);
}

/* telnetclient_isstate returns true if the client's line input handler and prompt match the given values. */
int
telnetclient_isstate(DESCRIPTOR_DATA *cl, void (*line_input)(DESCRIPTOR_DATA *cl, const char *line), const char *prompt)
{

	if (!cl) return 0;

	return cl->line_input == line_input &&
		(cl->prompt_string == prompt || strcmp(cl->prompt_string, prompt));
}

/* telnetclient_close marks a client for closure, dispatching to the appropriate close handler. */
void
telnetclient_close(DESCRIPTOR_DATA *cl)
{
	if (!cl)
		return;
	if (cl->ops && cl->ops->close) {
		cl->ops->close(cl);
	} else if (cl->stream) {
		struct net_stream *stream = cl->stream;
		cl->stream = NULL;
		net_close(stream);
	}
}

/* telnetclient_prompt_refresh redisplays the prompt if one is set and not already shown. */
void
telnetclient_prompt_refresh(DESCRIPTOR_DATA *cl)
{
	if (cl && (cl->type == CLIENT_TYPE_USER || cl->type == CLIENT_TYPE_WEB)
	    && cl->prompt_string && !cl->prompt_flag) {
		telnetclient_output_prompt(cl);
	}
}

/* telnetclient_prompt_refresh_all redisplays the prompt on every connected client. */
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

/* telnetclient_channel_member returns the client's channel membership handle. */
struct channel_member *
telnetclient_channel_member(DESCRIPTOR_DATA *cl)
{
	return &cl->channel_member;
}


/* telnetclient_socket_handle returns the underlying network stream for the client. */
struct net_stream *
telnetclient_socket_handle(DESCRIPTOR_DATA *cl)
{
	return cl->stream;
}

/* telnetclient_socket_name returns a human-readable address string for the client's connection. */
const char *
telnetclient_socket_name(DESCRIPTOR_DATA *cl)
{
	static char tmp[64];

	if (cl && cl->stream) {
		snprintf(tmp, sizeof(tmp), "%s:%u", net_get_address(cl->stream), net_get_port(cl->stream));
	} else if (cl && cl->type == CLIENT_TYPE_WEB) {
		snprintf(tmp, sizeof(tmp), "web");
	} else {
		snprintf(tmp, sizeof(tmp), "INVALID");
	}

	return tmp;
}

/* telnetclient_get_terminal returns the client's terminal information. */
const struct terminal *
telnetclient_get_terminal(DESCRIPTOR_DATA *cl)
{
	return cl ? &cl->terminal : NULL;
}

/* telnetclient_get_width returns the client's terminal width, defaulting to 80. */
unsigned
telnetclient_get_width(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->terminal.width > 0)
		return (unsigned)cl->terminal.width;
	return 80;
}

/* telnetclient_puts_wrapped word-wraps a single line of text to the client's terminal width. */
int
telnetclient_puts_wrapped(DESCRIPTOR_DATA *cl, const char *s)
{
	unsigned width = telnetclient_get_width(cl);
	unsigned slen = (unsigned)strlen(s);

	struct ww_word *words = NULL;
	int nw = ww_wordify(s, slen, &words);
	if (nw <= 0) {
		telnetclient_puts(cl, "\n");
		return OK;
	}

	unsigned *breaks = NULL;
	int nl = ww_wrap(words, (unsigned)nw, width, WW_OPTIMAL, &breaks);
	if (nl <= 0) {
		free(words);
		telnetclient_puts(cl, "\n");
		return OK;
	}

	char *out = malloc(slen + (unsigned)nl + 1);
	if (!out) {
		free(breaks);
		free(words);
		return ERR;
	}

	unsigned pos = 0;
	for (int i = 0; i < nl; i++) {
		unsigned start = breaks[i];
		unsigned end = (i + 1 < nl) ? breaks[i + 1] : (unsigned)nw;

		for (unsigned j = start; j < end; j++) {
			if (j > start)
				out[pos++] = ' ';
			memcpy(out + pos, s + words[j].off, words[j].len);
			pos += words[j].len;
		}
		out[pos++] = '\n';
	}
	out[pos] = '\0';

	telnetclient_puts(cl, out);

	free(out);
	free(breaks);
	free(words);
	return OK;
}

/* wrap_paragraph normalizes and word-wraps a single paragraph, writing it to the client. */
static int
wrap_paragraph(DESCRIPTOR_DATA *cl, const char *text, unsigned len,
	       unsigned wrap_width, const char *indent)
{
	char *norm = malloc(len + 1);
	if (!norm)
		return ERR;
	for (unsigned i = 0; i < len; i++)
		norm[i] = (text[i] == '\n' || text[i] == '\r') ? ' ' : text[i];
	norm[len] = '\0';

	struct ww_word *words = NULL;
	int nw = ww_wordify(norm, len, &words);
	if (nw <= 0) {
		free(norm);
		return OK;
	}

	unsigned *breaks = NULL;
	int nl = ww_wrap(words, (unsigned)nw, wrap_width, WW_OPTIMAL, &breaks);
	if (nl <= 0) {
		free(words);
		free(norm);
		return OK;
	}

	unsigned indent_len = indent ? (unsigned)strlen(indent) : 0;
	char *out = malloc(len + indent_len + (unsigned)nl + 1);
	if (!out) {
		free(breaks);
		free(words);
		free(norm);
		return ERR;
	}

	unsigned pos = 0;
	for (int i = 0; i < nl; i++) {
		if (i == 0 && indent_len > 0) {
			memcpy(out + pos, indent, indent_len);
			pos += indent_len;
		}

		unsigned start = breaks[i];
		unsigned end = (i + 1 < nl) ? breaks[i + 1] : (unsigned)nw;

		for (unsigned j = start; j < end; j++) {
			if (j > start)
				out[pos++] = ' ';
			memcpy(out + pos, norm + words[j].off, words[j].len);
			pos += words[j].len;
		}
		out[pos++] = '\n';
	}
	out[pos] = '\0';

	telnetclient_puts(cl, out);

	free(out);
	free(breaks);
	free(words);
	free(norm);
	return OK;
}

/* telnetclient_puts_paragraphs splits text on blank lines, word-wraps each paragraph, and
 * emits them with blank line spacing and optional indentation.
 */
int
telnetclient_puts_paragraphs(DESCRIPTOR_DATA *cl, const char *s,
			     unsigned indent)
{
	const unsigned spacing = 1; /* number of blank lines between paragraphs */
	unsigned width = telnetclient_get_width(cl);
	if (indent >= width)
		indent = 0;
	unsigned wrap_width = width - indent;

	char indent_buf[16];
	if (indent > sizeof(indent_buf) - 1)
		indent = sizeof(indent_buf) - 1;
	memset(indent_buf, ' ', indent);
	indent_buf[indent] = '\0';

	/* fill a buffer with blank lines to use for spacing */
	char blank_lines[spacing + 1];
	for (unsigned i = 0; i < spacing; i++)
		blank_lines[i] = '\n';
	blank_lines[spacing] = '\0';


	unsigned paragraph_num = 0; /* track the paragraph number we are on */
	const char *p = s;
	while (*p) {
		while (*p == '\n' || *p == '\r')
			p++;
		if (!*p)
			break;

		const char *end = strstr(p, "\n\n");
		unsigned plen;
		if (end) {
			plen = (unsigned)(end - p);
		} else {
			plen = (unsigned)strlen(p);
			end = p + plen;
		}

		if (blank_lines[0] && paragraph_num)
			telnetclient_puts(cl, blank_lines);

		if (wrap_paragraph(cl, p, plen, wrap_width, indent_buf) != OK)
			return ERR;

		paragraph_num++;

		p = end;
	}

	return OK;
}

/* telnetserver_listen creates a server and begins accepting connections on the given port. */
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

/* telnetserver_shutdown frees all telnet servers and their resources. */
void
telnetserver_shutdown(void)
{
	struct telnetserver *server;

	while ((server = LIST_TOP(server_list))) {
		LIST_REMOVE(server, list);
		free(server);
	}
}

/* telnetserver_first returns the first server in the global server list. */
struct telnetserver *
telnetserver_first(void)
{
	return LIST_TOP(server_list);
}

/* telnetserver_next returns the next server in the global server list. */
struct telnetserver *
telnetserver_next(struct telnetserver *server)
{
	return LIST_NEXT(server, list);
}

void
telnetclient_room_broadcast(const char *room_id, const char *msg)
{
	struct telnetserver *sv;
	DESCRIPTOR_DATA *cl;

	for (sv = telnetserver_first(); sv; sv = telnetserver_next(sv)) {
		for (cl = LIST_TOP(sv->client_list); cl; cl = LIST_NEXT(cl, list)) {
			struct character *ch = cl->character;
			const char *cur;
			char key[OBJ_PATH_MAX];
			if (!ch)
				continue;
			cur = character_attr_get(ch, "room.current");
			if (!cur)
				continue;
			snprintf(key, sizeof(key),
			         ROOM_ROOTDIR "/%s", cur);
			if (strcmp(key, room_id) == 0)
				telnetclient_puts(cl, msg);
		}
	}

	for (struct web_client *wc = webclient_first(); wc; wc = wc->next) {
		if (wc->state != WC_SSE || !wc->cl)
			continue;
		struct character *ch = wc->cl->character;
		const char *cur;
		char key[OBJ_PATH_MAX];
		if (!ch)
			continue;
		cur = character_attr_get(ch, "room.current");
		if (!cur)
			continue;
		snprintf(key, sizeof(key), ROOM_ROOTDIR "/%s", cur);
		if (strcmp(key, room_id) == 0)
			telnetclient_puts(wc->cl, msg);
	}
}

/* telnetclient_webclient_new allocates and initializes a client backed by a web connection. */
DESCRIPTOR_DATA *
telnetclient_webclient_new(struct web_client *wc, const struct client_ops *ops)
{
	DESCRIPTOR_DATA *cl = calloc(1, sizeof(*cl));
	if (!cl)
		return NULL;

	*cl = (DESCRIPTOR_DATA){
		.type = CLIENT_TYPE_WEB,
		.ops = ops,
		.client_ctx = wc,
	};

	cl->linebuf = buf_new();
	cl->state_free = NULL;
	telnetclient_clear_statedata(cl);
	cl->prompt_string = NULL;
	cl->prompt_flag = 0;

	cl->nr_channel = 0;
	cl->channel = NULL;
	cl->channel_member.send = telnetclient_channel_send;
	cl->channel_member.p = cl;

	telnetclient_channel_add(cl, channel_public(CHANNEL_SYS));

	telnetclient_puts(cl, mud_config.msgfile_welcome);
	weblogin_start(cl);

	return cl;
}

/* telnetclient_webclient_destroy tears down a web client, parting all channels and freeing resources. */
void
telnetclient_webclient_destroy(DESCRIPTOR_DATA *cl)
{
	if (!cl)
		return;

	eventlog_signoff(telnetclient_username(cl), "web");

	{
		unsigned i;
		struct channel_member *exclude_list[] = { &cl->channel_member };
		const char *name = telnetclient_username(cl);
		for (i = 0; i < cl->nr_channel; i++) {
			channel_broadcast(cl->channel[i], exclude_list, 1,
				"%s has left the channel.\n", name);
		}
	}

	cl->channel_member.send = NULL;
	cl->channel_member.p = NULL;
	while (cl->nr_channel)
		telnetclient_channel_remove(cl, cl->channel[0]);

	telnetclient_clear_statedata(cl);

	free(cl->prompt_string);
	cl->prompt_string = NULL;

	buf_free(cl->linebuf);
	cl->linebuf = NULL;

	if (cl->character) {
		character_put(cl->character);
		cl->character = NULL;
	}

	user_put(&cl->user);
	free(cl);
}

/* telnetclient_set_buffered enables output buffering on the client. */
void
telnetclient_set_buffered(DESCRIPTOR_DATA *cl)
{
	if (cl)
		cl->buffered = 1;
}

/* telnetclient_clear_buffered disables output buffering and flushes pending output. */
void
telnetclient_clear_buffered(DESCRIPTOR_DATA *cl)
{
	if (!cl)
		return;
	cl->buffered = 0;
	telnetclient_flush(cl);
}

/* telnetclient_flush sends any buffered output to the client. */
void
telnetclient_flush(DESCRIPTOR_DATA *cl)
{
	if (cl && cl->ops && cl->ops->flush)
		cl->ops->flush(cl);
}

int
telnetclient_send_sse(DESCRIPTOR_DATA *cl, int cmd, const char *msg)
{
	if (!cl || cl->type != CLIENT_TYPE_WEB || !cl->client_ctx)
		return -1;
	telnetclient_flush(cl);
	struct web_client *wc = cl->client_ctx;
	return sse_write(wc, cmd, msg);
}

/* telnetclient_set_encoding sets the character encoding for the client. */
void
telnetclient_set_encoding(DESCRIPTOR_DATA *cl, struct charset *cs)
{
	if (cl)
		cl->encoding = cs;
}

/* telnetclient_get_encoding returns the client's character encoding. */
struct charset *
telnetclient_get_encoding(DESCRIPTOR_DATA *cl)
{
	return cl ? cl->encoding : NULL;
}

/* telnetclient_user returns the user associated with the client. */
struct user *
telnetclient_user(DESCRIPTOR_DATA *cl)
{
	return cl ? cl->user : NULL;
}

/* telnetclient_get_menu returns the current menu state for the client. */
const struct menuinfo *
telnetclient_get_menu(DESCRIPTOR_DATA *cl)
{
	return cl->state.menu;
}

/* telnetclient_set_menu sets the current menu state for the client. */
void
telnetclient_set_menu(DESCRIPTOR_DATA *cl, const struct menuinfo *menu)
{
	cl->state.menu = menu;
}

/* telnetclient_get_login_username returns the username entered during login. */
const char *
telnetclient_get_login_username(DESCRIPTOR_DATA *cl)
{
	return cl->state.login.username;
}

/* telnetclient_set_login_username stores the username entered during login. */
void
telnetclient_set_login_username(DESCRIPTOR_DATA *cl, const char *name)
{
	snprintf(cl->state.login.username,
		 sizeof(cl->state.login.username), "%s", name);
}

/* telnetclient_get_form returns the client's current form state. */
struct form_state *
telnetclient_get_form(DESCRIPTOR_DATA *cl)
{
	return cl->state.form;
}

/* telnetclient_set_form sets the client's current form state. */
void
telnetclient_set_form(DESCRIPTOR_DATA *cl, struct form_state *form)
{
	cl->state.form = form;
}

/* telnetclient_set_state_free registers a cleanup callback for the client's current state data. */
void
telnetclient_set_state_free(DESCRIPTOR_DATA *cl, void (*fn)(DESCRIPTOR_DATA *))
{
	cl->state_free = fn;
}
