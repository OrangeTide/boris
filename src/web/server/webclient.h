/* webclient.h : web client connection state for SSE-based web server */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#ifndef WEBCLIENT_H_
#define WEBCLIENT_H_

#include "mud.h"

struct net_stream;

enum web_client_state {
	WC_HTTP,
	WC_SSE,
	WC_CLOSING,
};

#define WC_SESSION_LEN 32
#define WC_REQBUF_SIZE 4096

struct web_client {
	struct web_client *next;
	struct net_stream *stream;
	DESCRIPTOR_DATA *cl;
	enum web_client_state state;
	char session[WC_SESSION_LEN + 1];
	char reqbuf[WC_REQBUF_SIZE];
	int reqlen;
};

struct web_client *webclient_new(struct net_stream *stream);
void webclient_destroy(struct web_client *wc);
struct web_client *webclient_first(void);
struct web_client *webclient_find_session(const char *token);

int sse_write(struct web_client *wc, int cmd, const char *msg);

extern const struct client_ops web_client_ops;

#endif /* WEBCLIENT_H_ */
