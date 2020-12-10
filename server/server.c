/*
 * Copyright (c) 2020 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "server.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

#include <uv.h>

#include "log.h"

/**********************************************************************/

#define ERR (-1)
#define OK (0)

/**********************************************************************/

/* individual server socket */
struct server_instance {
	struct server_instance *next, **prev;
	uv_tcp_t handle;
};

/* holds state for a server thread.
 * each thread must have its own server_info structure.
 * we are NOT thread-safe! */
struct server_info {
	uv_loop_t *loop;
	struct server_instance *head;
};

struct telnet_peer {
	uv_tcp_t handle;
	uv_write_t write_req;
	// telnet_parser parser;
};

/**********************************************************************/

static void
print_gai_error(int gai_code, const char *reason)
{
	const char *errormsg = gai_strerror(gai_code);
	if (!errormsg)
		errormsg = "Unknown hostname error";
	log_error("%s:%s", errormsg, reason);
}

static void
print_uv_error(int errcode, const char *reason)
{
	const char *errormsg = uv_strerror(errcode);
	if (!errormsg)
		errormsg = "Socket error";
	log_error("%s:%s", errormsg, reason);
}

static void
print_handle_info(uv_stream_t *handle, const char *reason)
{
	uv_os_fd_t fd;
	uv_fileno((uv_handle_t*)handle, &fd);
	log_info("[%d] %s", (int)fd, reason);
}

/**********************************************************************/

static struct telnet_peer *
telnet_peer_new(void)
{
	struct telnet_peer *p = calloc(1, sizeof(*p));

	return p;
}

static void
telnet_peer_free(struct telnet_peer *p)
{
	// TODO: free p->req.base
	// TODO: free p->handle
	free(p);
}

static void
on_close(uv_handle_t *handle)
{
	log_info("closed");
	struct telnet_peer *peer = uv_handle_get_data((uv_handle_t*)handle);
	telnet_peer_free(peer);
}

static void
telnet_close(struct telnet_peer *p)
{
	uv_close((uv_handle_t*)&p->handle, on_close);
}

/**********************************************************************/

static void
alloc_buffer(uv_handle_t *handle, size_t suggested_size, uv_buf_t *buf)
{
	(void)handle; // UNUSED
	*buf = uv_buf_init(malloc(suggested_size), suggested_size);
}

static void
on_write_hello(uv_write_t *req, int status)
{
	// struct telnet_peer *peer = uv_req_get_data((uv_req_t*)req);
	// TODO: if we allocated write_req, we can free it now
}

static void
on_write_goodbye(uv_write_t *req, int status)
{
	struct telnet_peer *peer = uv_req_get_data((uv_req_t*)req);
	// TODO: if we allocated write_req, we can free it now

	telnet_close(peer);
}

static void
on_read(uv_stream_t *handle, ssize_t nread, const uv_buf_t *buf)
{
	struct telnet_peer *peer = uv_handle_get_data((uv_handle_t*)handle);

	if (nread < 0) {
		if (nread == UV_EOF)
			print_handle_info(handle, "closed");
		else
			print_uv_error(nread, "client read");
	} else {
		uv_buf_t send_bufs[] = {
			{ .base = "Good-\r\n", .len = 7 },
			{ .base = " Bye!\r\n", .len = 7 },
		};
		unsigned count = sizeof(send_bufs) / sizeof(*send_bufs);
#warning BUG: There is probably a race with write_req being over-written before it has completed ...
		uv_req_set_data((uv_req_t*)&peer->write_req, peer);
		uv_write(&peer->write_req, handle, send_bufs, count, on_write_goodbye);
	}

	free(buf->base);

	/* on close or error, initiate the clean-up */
	if (buf->len == 0 || nread <= 0)
		telnet_close(peer);
}

/* add to list */
static void
add_server(struct server_info *serv, struct server_instance *server)
{
	server->prev = &serv->head;
	server->next = serv->head;
	if (serv->head)
		serv->head->prev = &server->next;
	serv->head = server;
}

/* remove from list */
static void
del_server(struct server_instance *server)
{
	if (!server)
		return;

	if (server->next && server->next->prev)
		server->next->prev = server->prev;

	if (server->prev)
		*server->prev = server->next;

	server->prev = NULL;
	server->next = NULL;
}

static void
on_connect(uv_stream_t *server_handle, int status)
{
	struct telnet_peer *peer = telnet_peer_new();
	uv_loop_t *loop = uv_handle_get_loop((uv_handle_t*)server_handle);

	uv_tcp_init(loop, &peer->handle);

	int result;
	result = uv_accept(server_handle, (uv_stream_t *)&peer->handle);
	if (result) {
		print_uv_error(result, "server TCP accept");
		telnet_peer_free(peer);
		return;
	}

	uv_handle_set_data((uv_handle_t*)&peer->handle, peer);

	// Print a welcome message ...
	uv_buf_t send_bufs[] = {
		{ .base = "Hello\r\n", .len = 7 },
		{ .base = " World!\r\n", .len = 9 },
	};
	unsigned count = sizeof(send_bufs) / sizeof(*send_bufs);

	uv_req_set_data((uv_req_t*)&peer->write_req, peer);
	uv_write(&peer->write_req, (uv_stream_t*)&peer->handle, send_bufs, count, on_write_hello);

	// Wait for input ...
	uv_read_start((uv_stream_t*)&peer->handle, alloc_buffer, on_read);
}

static int
telnet_server_instance_start(struct server_info *serv, const struct sockaddr *addr)
{
	struct server_instance *server = calloc(1, sizeof(*server));
	if (!server) {
		log_errno("server");
		return ERR;
	}

	int result;
	result = uv_tcp_init(serv->loop, &server->handle);
	if (result) {
		print_uv_error(result, "server TCP init");
		return ERR;
	}

	result = uv_tcp_bind(&server->handle, (const struct sockaddr *)addr, 0);
	if (result) {
		print_uv_error(result, "server TCP bind");
		return ERR;
	}

	result = uv_listen((uv_stream_t *) &server->handle, 128, on_connect);
	if (result) {
		print_uv_error(result, "server TCP listen");
		return ERR;
	}

	add_server(serv, server);

	return OK;
}

/* start a server for every matching interface */
static int
telnet_server_start(struct server_info *serv, const char *portservice)
{
	/* parse hostname & port */
	char hostname[128];
	char service[64];
	if (sscanf(portservice, "%127[^/ ]/%63s", hostname, service) == 2) {
		// success
	} else if (sscanf(portservice, "%63s", service) == 1) {
		hostname[0] = 0;
		if (strchr(service, '/')) {
			log_error("%s():%d:parse error", __func__, __LINE__);
			return ERR; /* unable to determine valid host/port string */
		}
	} else {
		log_error("%s():%d:parse error", __func__, __LINE__);
		return ERR; /* unable to determine valid host/port string */
	}

	/* get all matching interfaces */
	const int socktype = SOCK_STREAM; // TODO: also support SOCK_DGRAM
	const int family = AF_INET; // TODO: also support AF_INET6
	struct addrinfo ai_hints[] = {
		{
			.ai_flags = AI_PASSIVE,
			.ai_family = family,
			.ai_socktype = socktype,
			.ai_next = NULL
		},
	};

	int result;
	struct addrinfo *ai_res; /* result */
	result = getaddrinfo(*hostname ? hostname : NULL, service, ai_hints, &ai_res);
	if (result != 0) {
		print_gai_error(result, "hostname parsing error");
		log_error("%s():%d:parse error", __func__, __LINE__);
		return ERR;
	}

	/* Walk list, process any AF_INET or AF_INET6 entry.
	 * NOTE: failures in this loop won't back out earlier successes.
	 */
	result = OK;
	struct addrinfo *curr;
	for (curr = ai_res; curr; curr = curr->ai_next) {
		result = telnet_server_instance_start(serv, curr->ai_addr);
		if (result != OK)
			break;
	}

	freeaddrinfo(ai_res);

	log_info("%s():result=%d", __func__, __LINE__, result);
	return result;
}

/**********************************************************************/

/* allocate and initialize a server_info structure */
struct server_info *
server_new(void)
{
	struct server_info *serv = calloc(1, sizeof(*serv));
	if (!serv)
		return NULL;

	uv_loop_t *loop = malloc(uv_loop_size());
	if (!loop) {
		free(serv);
		return NULL;
	}

	uv_loop_init(loop);
	serv->loop = loop;

	return serv;
}

int
server_add(struct server_info *serv, const char *portservice)
{
	int result = telnet_server_start(serv, portservice);

	log_info("%s():result=%d", __func__, __LINE__, result);

	return result;
}

/* blocks until terminated */
int
server_start(struct server_info *serv)
{
	return uv_run(serv->loop, UV_RUN_DEFAULT);
}

/* This may only be called in the same thread as server_start */
int
server_stop(struct server_info *serv)
{
	uv_stop(serv->loop);

	return OK;
}

void
server_free(struct server_info *serv)
{
	// TODO: determine that the server is in a stopped/quiescent state
	if (serv) {
		// TODO: make use of uv_unref() and uv_has_ref()
		uv_loop_close(serv->loop);
		free(serv->loop);
		serv->loop = NULL;
		free(serv);
	}
}
