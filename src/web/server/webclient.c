/* webclient.c : web client connection management for SSE-based web server */
/* PUBLIC DOMAIN (CC0-1.0) */

#include "webclient.h"
#include <net.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

static struct web_client *web_clients_head;

static int
generate_session(char *out, int len)
{
	unsigned char buf[16];
	int fd = open("/dev/urandom", O_RDONLY);
	if (fd < 0)
		return -1;
	ssize_t n = read(fd, buf, sizeof(buf));
	close(fd);
	if (n != (ssize_t)sizeof(buf))
		return -1;
	for (int i = 0; i < (int)sizeof(buf) && i * 2 + 1 < len; i++)
		snprintf(out + i * 2, 3, "%02x", buf[i]);
	out[len - 1] = '\0';
	return 0;
}

struct web_client *
webclient_new(struct net_stream *stream)
{
	struct web_client *wc = calloc(1, sizeof(*wc));
	if (!wc)
		return NULL;
	wc->stream = stream;
	wc->state = WC_HTTP;
	if (generate_session(wc->session, sizeof(wc->session)) < 0) {
		free(wc);
		return NULL;
	}
	wc->next = web_clients_head;
	web_clients_head = wc;
	return wc;
}

void
webclient_destroy(struct web_client *wc)
{
	struct web_client **pp = &web_clients_head;
	while (*pp) {
		if (*pp == wc) {
			*pp = wc->next;
			break;
		}
		pp = &(*pp)->next;
	}
	free(wc);
}

struct web_client *
webclient_first(void)
{
	return web_clients_head;
}

struct web_client *
webclient_find_session(const char *token)
{
	for (struct web_client *wc = web_clients_head; wc; wc = wc->next) {
		if (strcmp(wc->session, token) == 0)
			return wc;
	}
	return NULL;
}
