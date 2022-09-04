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
#include <dyad.h>
#include <list.h>
#include <mud.h>
#define LOG_SUBSYSTEM "telnetserver"
#include <log.h>
#include <debug.h>
#include <eventlog.h>
#include <game.h>
#include <mudconfig.h>

#define OK (0)
#define ERR (-1)

/******************************************************************************
 * Telnet protocol constants
 ******************************************************************************/
/** @todo prefix these to clean up the namespace */

/** telnet protocol escape */
#define IAC '\377'

/** telnet protocol directive. */
#define DONT '\376'

/** telnet protocol directive. */
#define DO '\375'

/** telnet protocol directive. */
#define WONT '\374'

/** telnet protocol directive. */
#define WILL '\373'

/** telnet protocol to start multiple bytes of data. */
#define SB '\372'

/** telnet directive - go ahead. */
#define GA '\371'

/** undocumented - please add documentation. */
#define EL '\370'

/** undocumented - please add documentation. */
#define EC '\367'

/** undocumented - please add documentation. */
#define AYT '\366'

/** undocumented - please add documentation. */
#define AO '\365'

/** undocumented - please add documentation. */
#define IP '\364'

/** undocumented - please add documentation. */
#define BREAK '\363'

/** undocumented - please add documentation. */
#define DM '\362'

/** undocumented - please add documentation. */
#define NOP '\361'

/** undocumented - please add documentation. */
#define SE '\360'

/** undocumented - please add documentation. */
#define EOR '\357'

/** undocumented - please add documentation. */
#define ABORT '\356'

/** undocumented - please add documentation. */
#define SUSP '\355'

/** undocumented - please add documentation. */
#define xEOF '\354' /* this is what BSD arpa/telnet.h calls the EOF */

/** undocumented - please add documentation. */
#define SYNCH '\362'

/*=* telnet options *=*/

/** undocumented - please add documentation. */
#define TELOPT_ECHO 1

/** undocumented - please add documentation. */
#define TELOPT_SGA 3

/** undocumented - please add documentation. */
#define TELOPT_TTYPE 24		/* terminal type - rfc1091 */

/** undocumented - please add documentation. */
#define TELOPT_NAWS 31		/* negotiate about window size - rfc1073 */

/** undocumented - please add documentation. */
#define TELOPT_LINEMODE 34	/* line mode option - rfc1116 */

/*=* generic sub-options *=*/

/** undocumented - please add documentation. */
#define TELQUAL_IS 0

/** undocumented - please add documentation. */
#define TELQUAL_SEND 1

/** undocumented - please add documentation. */
#define TELQUAL_INFO 2

/*=* Linemode sub-options *=*/

/** undocumented - please add documentation. */
#define	LM_MODE 1

/** undocumented - please add documentation. */
#define	LM_FORWARDMASK 2

/** undocumented - please add documentation. */
#define	LM_SLC 3

/*=* linemode modes *=*/

/** undocumented - please add documentation. */
#define	MODE_EDIT 1

/** undocumented - please add documentation. */
#define	MODE_TRAPSIG 2

/** undocumented - please add documentation. */
#define	MODE_ACK 4

/** undocumented - please add documentation. */
#define MODE_SOFT_TAB 8

/** undocumented - please add documentation. */
#define MODE_LIT_ECHO 16

/** undocumented - please add documentation. */
#define	MODE_MASK 31

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
static void telnetclient_free(dyad_Event *e);
static void telnetclient_channel_send(struct channel_member *cm, struct channel *ch, const char *msg);
static DESCRIPTOR_DATA *telnetclient_newclient(dyad_Stream *stream);
static int telnetclient_telnet_init(DESCRIPTOR_DATA *cl);
static int telnetclient_echomode(DESCRIPTOR_DATA *cl, int mode);
static int telnetclient_linemode(DESCRIPTOR_DATA *cl, int mode);

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

	if (!cl) {
		LOG_ERROR("Illegal client state! [fd=%ld, %s:%u]\n", (long)dyad_getSocket(e->remote), dyad_getAddress(e->remote), dyad_getPort(e->remote));
		dyad_close(e->remote);
		return;
	}

	// TODO: replace this simple echo code
	dyad_write(e->stream, e->data, e->size);
}

static void
telnetclient_on_accept(dyad_Event *e)
{
	DESCRIPTOR_DATA *cl = telnetclient_newclient(e->remote);

	if (!cl) {
		LOG_ERROR("Could not create new client");
		return;
	}

	if (telnetclient_telnet_init(cl) || telnetclient_linemode(cl, 1) || telnetclient_echomode(cl, 1)) {
		return; /* failure, the client would have been deleted */
	}

	fprintf(stderr, "*** Connection %ld: %s\n", (long)dyad_getSocket(e->remote), telnetclient_socket_name(cl));
	// TODO: telnetclient_puts(cl, mud_config.msgfile_welcome);

	dyad_writef(e->remote, "## Welcome ##\r\n");
}

static void
telnetclient_on_error(dyad_Event *e)
{
	LOG_CRITICAL("telnet server error: %s", e->msg);
}

/**
 * @return the username
 */
const char *
telnetclient_username(DESCRIPTOR_DATA *cl)
{
	return cl && cl->name ? cl->name : "<UNKNOWN>";
}

/** write a null terminated string to a telnetclient buffer. */
int
telnetclient_puts(DESCRIPTOR_DATA *cl, const char *s)
{
	assert(cl != NULL);
	assert(cl->stream != NULL);
	// TODO: dyad_getState()

	size_t n = strlen(s);
	dyad_write(cl->stream, s, n);
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

	// TODO: dyad_getState()

	dyad_vwritef(cl->stream, fmt, ap);
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

/** free a telnetclient structure. */
static void
telnetclient_free(dyad_Event *e)
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

	telnetclient_clear_statedata(client); /* free data associated with current state */

	free(client->prompt_string);
	client->prompt_string = NULL;

	LOG_TODO("free any other data structures associated with client"); /* be vigilant about memory leaks */

#ifndef NDEBUG
	memset(client, 0xBB, sizeof * client); /* fill with fake data before freeing */
#endif

	free(client);
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

	dyad_addListener(stream, DYAD_EVENT_DESTROY, telnetclient_free, cl);
	dyad_addListener(stream, DYAD_EVENT_DATA, telnetclient_on_data, cl);

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

/**
 * posts telnet protocol necessary to begin negotiation of options.
 */
static int
telnetclient_telnet_init(DESCRIPTOR_DATA *cl)
{
	const char support[] = {
		IAC, DO, TELOPT_LINEMODE,
		IAC, DO, TELOPT_NAWS,		/* window size events */
		IAC, DO, TELOPT_TTYPE,		/* accept terminal-type infomation */
		IAC, SB, TELOPT_TTYPE, TELQUAL_SEND, IAC, SE, /* ask the terminal type */
	};

	dyad_write(cl->stream, support, sizeof support);
	// TODO: check for errors

	return OK;
}

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

#if 0 // TODO: replace this with dyad Event handler
/** callback used when a socketio_handle for a telnetclient is write-ready. */
void
telnetclient_write_event(struct socketio_handle *sh, SOCKET fd, void *p)
{
	const char *data;
	size_t len;
	int res;
	DESCRIPTOR_DATA *cl = p;

	assert(cl->sh->delete_flag == 0); /* we should never be called if already deleted */

	/* only call this if the client wasn't closed and we have data in our buffer */
	assert(cl != NULL);
	assert(sh == cl->sh);

	data = buffer_data(&cl->output, &len);
	res = socketio_send(fd, data, len);

	if (res < 0) {
		sh->delete_flag = 1;
		return; /* client write failure */
	}

	TRACE("len=%zu res=%d\n", len, res);
	len = buffer_consume(&cl->output, (unsigned)res);

	if (len > 0) {
		/* there is still data in our buffer */
		socketio_writeready(fd);
	}
}
#endif

#if 0 // TODO: replace this with MTH code
/**
 * for processing IAC SB.
 */
static void
telnetclient_iac_process_sb(const char *iac, size_t len, DESCRIPTOR_DATA *cl)
{
	assert(cl != NULL);
	assert(iac[0] == IAC);
	assert(iac[1] == SB);

	if (!iac) return;

	if (!cl) return;

	switch(iac[2]) {
	case TELOPT_TTYPE:
		if (iac[3] == TELQUAL_IS) {
			if (len < 9) {
				LOG_ERROR("WARNING: short IAC SB TTYPE IS .. IAC SE");
				return;
			}

			snprintf(cl->terminal.name, sizeof cl->terminal.name, "%.*s", (int)len - 4 - 2, iac + 4);
			LOG_DEBUG("%s:Client terminal type is now \"%s\"\n", cl->sh->name, cl->terminal.name);
			/*
			telnetclient_printf(cl, "Terminal type: %s\n", cl->terminal.name);
			*/
		}

		break;

	case TELOPT_NAWS: {
		if (len < 9) {
			LOG_ERROR("WARNING: short IAC SB NAWS .. IAC SE");
			return;
		}

		assert(len == 9);
		cl->terminal.width = RD_BE16(iac, 3);
		cl->terminal.height = RD_BE16(iac, 5);
		LOG_DEBUG("%s:Client display size is now %ux%u\n", cl->sh->name, cl->terminal.width, cl->terminal.height);
		/*
		telnetclient_printf(cl, "display size is: %ux%u\n", cl->terminal.width, cl->terminal.height);
		*/
		break;
	}
	}
}

/**
 * @return 0 means "incomplete" data for this function
 */
static size_t
telnetclient_iac_process(const char *iac, size_t len, void *p)
{
	DESCRIPTOR_DATA *cl = p;
	const char *endptr;

	assert(iac != NULL);
	assert(iac[0] == IAC);

	if (iac[0] != IAC) {
		LOG_ERROR("called on non-telnet data\n");
		return 0;
	}

	switch(iac[1]) {
	case IAC:
		return 1; /* consume the first IAC and leave the second behind */

	case WILL:
		if (len >= 3) {
			LOG_DEBUG("IAC WILL %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case WONT:
		if (len >= 3) {
			LOG_DEBUG("IAC WONT %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case DO:
		if (len >= 3) {
			LOG_DEBUG("IAC DO %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case DONT:
		if (len >= 3) {
			LOG_DEBUG("IAC DONT %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case SB:
		/* look for IAC SE */
		TRACE("IAC SB %hhu found\n", iac[2]);
		endptr = iac + 2;

		while ((endptr = memchr(endptr, IAC, len - (endptr - iac)))) {
			assert(endptr[0] == IAC);
			TRACE("found IAC %hhu\n", endptr[1]);
			endptr++;

			if ((endptr - iac) >= (ptrdiff_t)len) {
				LOG_DEBUG_MSG("Unterminated IAC SB sequence");
				return 0; /* unterminated */
			}

			if (endptr[0] == SE) {
				endptr++;
				// LOG_DEBUG("IAC SB %hhu ... IAC SE\n", iac[2]);
				HEXDUMP(iac, endptr - iac, "%s():IAC SB %hhu: ", __func__, iac[2]);
				telnetclient_iac_process_sb(iac, (size_t)(endptr - iac), cl);
				return endptr - iac;
			} else if (endptr[0] == IAC) {
				TRACE_MSG("Found IAC IAC in IAC SB block");
				endptr++;
			}
		}

		return 0; /* unterminated IAC SB sequence */

	case SE:
		LOG_ERROR("found IAC SE without IAC SB, ignoring it.");

	/* fall through */
	default:
		if (len >= 3)
			return 2; /* treat anything we don't know about as a 2-byte operation */
		else
			return 0; /* not enough data */
	}

	/* we should never get to this point */

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

#if 0 // TODO: replace with dyad Event
/**
 * callback given to socketio_listen to create telnetclients on accept.
 */
void
telnetclient_new_event(struct socketio_handle *sh)
{
	DESCRIPTOR_DATA *cl;

	cl = telnetclient_newclient(sh);

	if (!cl) {
		return; /* failure */
	}

	sh->write_event = telnetclient_write_event;
	sh->read_event = NULL;

	menu_start_input(cl, &gamemenu_login);
}
#endif

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
