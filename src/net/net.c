/* net.c : TCP networking layer on top of libiox. */

#include "net.h"
#include "iox_fd.h"
#include "iox_loop.h"

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define NET_READ_BUF    4096
#define NET_MAX_LISTENERS 6   /* one slot per NET_EVENT_* (incl. NULL) */

struct listener_slot {
	net_cb cb;
	void *udata;
};

struct net_stream {
	int fd;
	int state;
	struct listener_slot listeners[NET_MAX_LISTENERS];

	/* Write buffer: append on net_write, drain when IOX_WRITE fires. */
	char *wbuf;
	size_t wbuf_len;
	size_t wbuf_cap;
	unsigned watched_events;

	/* Cached peer info (filled at accept / listen time). */
	char addr[INET6_ADDRSTRLEN];
	int port;

	struct net_stream *next;
};

static struct iox_loop *g_loop;
static struct net_stream *g_streams;
static int g_stream_count;
static int g_dispatch_depth;
static struct net_stream *g_pending_free;

/* ---------- helpers ---------- */

static int
set_nonblock(int fd)
{
	int fl = fcntl(fd, F_GETFL, 0);
	if (fl < 0) return -1;
	return fcntl(fd, F_SETFL, fl | O_NONBLOCK);
}

static void
fill_addr_from_sockaddr(struct net_stream *s, const struct sockaddr *sa)
{
	if (sa->sa_family == AF_INET) {
		const struct sockaddr_in *in = (const struct sockaddr_in *)sa;
		inet_ntop(AF_INET, &in->sin_addr, s->addr, sizeof s->addr);
		s->port = ntohs(in->sin_port);
	} else if (sa->sa_family == AF_INET6) {
		const struct sockaddr_in6 *in = (const struct sockaddr_in6 *)sa;
		inet_ntop(AF_INET6, &in->sin6_addr, s->addr, sizeof s->addr);
		s->port = ntohs(in->sin6_port);
	} else {
		snprintf(s->addr, sizeof s->addr, "?");
		s->port = 0;
	}
}

static void stream_free(struct net_stream *s);

static void
flush_pending_frees(void)
{
	while (g_pending_free) {
		struct net_stream *s = g_pending_free;
		g_pending_free = s->next;
		s->next = NULL;
		stream_free(s);
	}
}

static void
dispatch(struct net_stream *s, int event, char *data, int size, const char *msg,
    struct net_stream *remote)
{
	if (event < 0 || event >= NET_MAX_LISTENERS) return;
	struct listener_slot *slot = &s->listeners[event];
	if (!slot->cb) return;
	net_event e = {
		.type = event,
		.udata = slot->udata,
		.stream = s,
		.remote = remote,
		.msg = msg,
		.data = data,
		.size = size,
	};
	g_dispatch_depth++;
	slot->cb(&e);
	if (--g_dispatch_depth == 0)
		flush_pending_frees();
}

static void net_fd_cb(struct iox_loop *loop, int fd, unsigned events, void *arg);

static void
update_watch(struct net_stream *s)
{
	if (s->fd < 0) return;
	unsigned want = IOX_READ;
	if (s->state == NET_STATE_CLOSING)
		want = 0;
	if (s->wbuf_len > 0) want |= IOX_WRITE;
	if (want == s->watched_events) return;
	if (s->watched_events == 0) {
		iox_fd_add(g_loop, s->fd, want, net_fd_cb, s);
	} else {
		iox_fd_mod(g_loop, s->fd, want);
	}
	s->watched_events = want;
}

static void
stream_link(struct net_stream *s)
{
	s->next = g_streams;
	g_streams = s;
	g_stream_count++;
}

static void
stream_unlink(struct net_stream *s)
{
	struct net_stream **pp = &g_streams;
	while (*pp && *pp != s) pp = &(*pp)->next;
	if (*pp == s) {
		*pp = s->next;
		g_stream_count--;
	}
}

static struct net_stream *
stream_alloc(void)
{
	struct net_stream *s = calloc(1, sizeof *s);
	if (!s) return NULL;
	s->fd = -1;
	s->state = NET_STATE_CLOSED;
	return s;
}

static void
stream_free(struct net_stream *s)
{
	if (!s) return;
	if (s->fd >= 0) {
		if (s->watched_events) iox_fd_remove(g_loop, s->fd);
		close(s->fd);
		s->fd = -1;
	}
	dispatch(s, NET_EVENT_DESTROY, NULL, 0, NULL, NULL);
	free(s->wbuf);
	free(s);
}

/* ---------- write buffer ---------- */

static int
wbuf_append(struct net_stream *s, const void *data, int size)
{
	if (size <= 0) return 0;
	size_t need = s->wbuf_len + (size_t)size;
	if (need > s->wbuf_cap) {
		size_t cap = s->wbuf_cap ? s->wbuf_cap : 256;
		while (cap < need) cap *= 2;
		char *nb = realloc(s->wbuf, cap);
		if (!nb) return -1;
		s->wbuf = nb;
		s->wbuf_cap = cap;
	}
	memcpy(s->wbuf + s->wbuf_len, data, (size_t)size);
	s->wbuf_len += (size_t)size;
	return 0;
}

static void
wbuf_drain(struct net_stream *s)
{
	while (s->wbuf_len > 0) {
		ssize_t n = send(s->fd, s->wbuf, s->wbuf_len, MSG_NOSIGNAL);
		if (n < 0) {
			if (errno == EAGAIN || errno == EWOULDBLOCK) return;
			dispatch(s, NET_EVENT_ERROR, NULL, 0, strerror(errno), NULL);
			net_close(s);
			return;
		}
		if ((size_t)n < s->wbuf_len)
			memmove(s->wbuf, s->wbuf + n, s->wbuf_len - (size_t)n);
		s->wbuf_len -= (size_t)n;
	}
	if (s->state == NET_STATE_CLOSING)
		net_close(s);
}

/* ---------- accept path ---------- */

static void
do_accept(struct net_stream *listener)
{
	for (;;) {
		struct sockaddr_storage ss;
		socklen_t slen = sizeof ss;
		int cfd = accept(listener->fd, (struct sockaddr *)&ss, &slen);
		if (cfd < 0) {
			if (errno == EAGAIN || errno == EWOULDBLOCK) return;
			if (errno == EINTR) continue;
			dispatch(listener, NET_EVENT_ERROR, NULL, 0, strerror(errno), NULL);
			return;
		}
		if (set_nonblock(cfd) < 0) { close(cfd); continue; }
		struct net_stream *c = stream_alloc();
		if (!c) { close(cfd); continue; }
		c->fd = cfd;
		c->state = NET_STATE_CONNECTED;
		fill_addr_from_sockaddr(c, (struct sockaddr *)&ss);
		stream_link(c);
		update_watch(c);
		dispatch(listener, NET_EVENT_ACCEPT, NULL, 0, NULL, c);
	}
}

/* ---------- read path ---------- */

static void
do_read(struct net_stream *s)
{
	char buf[NET_READ_BUF];
	for (;;) {
		ssize_t n = recv(s->fd, buf, sizeof buf, 0);
		if (n > 0) {
			dispatch(s, NET_EVENT_DATA, buf, (int)n, NULL, NULL);
			if (s->state != NET_STATE_CONNECTED) return;
			continue;
		}
		if (n == 0) {
			net_close(s);
			return;
		}
		if (errno == EAGAIN || errno == EWOULDBLOCK) return;
		if (errno == EINTR) continue;
		dispatch(s, NET_EVENT_ERROR, NULL, 0, strerror(errno), NULL);
		net_close(s);
		return;
	}
}

/* ---------- fd callback ---------- */

static void
net_fd_cb(struct iox_loop *loop, int fd, unsigned events, void *arg)
{
	struct net_stream *s = arg;
	(void)loop; (void)fd;
	if (s->state == NET_STATE_LISTENING) {
		if (events & IOX_READ) do_accept(s);
		return;
	}
	if (events & IOX_WRITE) {
		wbuf_drain(s);
		if (s->state == NET_STATE_CLOSED) return;
		update_watch(s);
	}
	if (events & IOX_READ) {
		do_read(s);
	}
}

/* ---------- public API ---------- */

int
net_init(struct iox_loop *loop)
{
	g_loop = loop;
	g_streams = NULL;
	g_stream_count = 0;
	g_dispatch_depth = 0;
	g_pending_free = NULL;
	return 0;
}

void
net_shutdown(void)
{
	while (g_streams) {
		struct net_stream *s = g_streams;
		stream_unlink(s);
		stream_free(s);
	}
	flush_pending_frees();
	g_loop = NULL;
}

int
net_stream_count(void)
{
	return g_stream_count;
}

struct net_stream *
net_new_stream(void)
{
	struct net_stream *s = stream_alloc();
	if (!s) return NULL;
	stream_link(s);
	return s;
}

int
net_listen(struct net_stream *s, int port)
{
	char portstr[16];
	snprintf(portstr, sizeof portstr, "%d", port);
	struct addrinfo hints = { 0 };
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE | AI_NUMERICSERV;
	struct addrinfo *res = NULL;
	if (getaddrinfo(NULL, portstr, &hints, &res) != 0 || !res)
		return -1;
	int fd = -1;
	for (struct addrinfo *ai = res; ai; ai = ai->ai_next) {
		fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
		if (fd < 0) continue;
		int one = 1;
		setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
		if (bind(fd, ai->ai_addr, ai->ai_addrlen) == 0) break;
		close(fd);
		fd = -1;
	}
	freeaddrinfo(res);
	if (fd < 0) return -1;
	if (set_nonblock(fd) < 0 || listen(fd, 64) < 0) {
		close(fd);
		return -1;
	}
	s->fd = fd;
	s->state = NET_STATE_LISTENING;
	s->port = port;
	snprintf(s->addr, sizeof s->addr, "0.0.0.0");
	update_watch(s);
	return 0;
}

void
net_close(struct net_stream *s)
{
	if (!s || s->state == NET_STATE_CLOSED) return;
	int was_connected = (s->state != NET_STATE_CLOSED);
	s->state = NET_STATE_CLOSED;
	if (s->fd >= 0) {
		if (s->watched_events) {
			iox_fd_remove(g_loop, s->fd);
			s->watched_events = 0;
		}
		close(s->fd);
		s->fd = -1;
	}
	if (was_connected)
		dispatch(s, NET_EVENT_CLOSE, NULL, 0, NULL, NULL);
	stream_unlink(s);
	if (g_dispatch_depth > 0) {
		s->next = g_pending_free;
		g_pending_free = s;
	} else {
		stream_free(s);
	}
}

void
net_close_when_done(struct net_stream *s)
{
	if (!s || s->state == NET_STATE_CLOSED) return;
	if (s->wbuf_len == 0) {
		net_close(s);
		return;
	}
	s->state = NET_STATE_CLOSING;
	update_watch(s);
}

int
net_write(struct net_stream *s, const void *data, int size)
{
	if (!s || s->state != NET_STATE_CONNECTED || size <= 0) return -1;
	if (wbuf_append(s, data, size) < 0) return -1;
	update_watch(s);
	return size;
}

int
net_writef(struct net_stream *s, const char *fmt, ...)
{
	char buf[1024];
	va_list ap;
	va_start(ap, fmt);
	int n = vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);
	if (n < 0) return -1;
	if (n >= (int)sizeof buf) n = (int)sizeof buf - 1;
	return net_write(s, buf, n);
}

void
net_add_listener(struct net_stream *s, int event, net_cb cb, void *udata)
{
	if (!s || event < 0 || event >= NET_MAX_LISTENERS) return;
	s->listeners[event].cb = cb;
	s->listeners[event].udata = udata;
}

int net_get_state(const struct net_stream *s) { return s ? s->state : NET_STATE_CLOSED; }
const char *net_get_address(const struct net_stream *s) { return s ? s->addr : ""; }
int net_get_port(const struct net_stream *s) { return s ? s->port : 0; }
int net_get_socket(const struct net_stream *s) { return s ? s->fd : -1; }
