/* net.h : TCP networking layer on top of libiox.
 *
 * API mirrors dyad's semantics (buffered writes, event callbacks) but
 * slimmer: one listener per event per stream, no connect/line/timer
 * events, no blocking mode. Backed by libiox's poll loop.
 */

#ifndef BORIS_NET_H
#define BORIS_NET_H

#include <stdarg.h>

struct iox_loop;
struct net_stream;

typedef struct net_event {
	int type;
	void *udata;
	struct net_stream *stream;
	struct net_stream *remote;
	const char *msg;
	char *data;
	int size;
} net_event;

typedef void (*net_cb)(net_event *);

enum {
	NET_EVENT_NULL,
	NET_EVENT_DESTROY,
	NET_EVENT_ACCEPT,
	NET_EVENT_CLOSE,
	NET_EVENT_DATA,
	NET_EVENT_ERROR
};

enum {
	NET_STATE_CLOSED,
	NET_STATE_CLOSING,
	NET_STATE_CONNECTED,
	NET_STATE_LISTENING
};

/** Initialize with a loop. Call once before any other net_* function. */
int net_init(struct iox_loop *loop);
void net_shutdown(void);
int net_stream_count(void);

struct net_stream *net_new_stream(void);
int net_listen(struct net_stream *s, int port);
void net_close(struct net_stream *s);
void net_close_when_done(struct net_stream *s);
int net_write(struct net_stream *s, const void *data, int size);
int net_writef(struct net_stream *s, const char *fmt, ...);

/** Register (or replace) a callback for @event on @s. Pass cb=NULL to clear. */
void net_add_listener(struct net_stream *s, int event, net_cb cb, void *udata);

int net_get_state(const struct net_stream *s);
const char *net_get_address(const struct net_stream *s);
int net_get_port(const struct net_stream *s);
int net_get_socket(const struct net_stream *s);

#endif /* BORIS_NET_H */
