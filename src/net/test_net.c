/* test_net.c : unit test for src/net. Spins up a listener, connects a
 * raw socket client, verifies accept/data/close callbacks fire. */

#include "net.h"
#include "iox_loop.h"
#include "iox_timer.h"

#include <arpa/inet.h>
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

static int accept_fired;
static int data_fired;
static int close_fired;
static char received[256];
static int received_len;
static struct net_stream *client_stream;
static struct iox_loop *g_loop;

static void
on_client_data(net_event *e)
{
	data_fired++;
	int copy = e->size < (int)(sizeof received - received_len)
	    ? e->size : (int)(sizeof received - received_len);
	memcpy(received + received_len, e->data, copy);
	received_len += copy;
}

static void
on_client_close(net_event *e)
{
	(void)e;
	close_fired++;
	iox_loop_stop(g_loop);
}

static void
on_accept(net_event *e)
{
	accept_fired++;
	client_stream = e->remote;
	net_add_listener(client_stream, NET_EVENT_DATA, on_client_data, NULL);
	net_add_listener(client_stream, NET_EVENT_CLOSE, on_client_close, NULL);
	net_write(client_stream, "hello\n", 6);
}

static void
bail(struct iox_loop *loop, void *arg)
{
	(void)loop; (void)arg;
	fprintf(stderr, "test_net: timeout\n");
	iox_loop_stop(g_loop);
}

static int
connect_localhost(int port)
{
	int fd = socket(AF_INET, SOCK_STREAM, 0);
	if (fd < 0) return -1;
	struct sockaddr_in sa = { 0 };
	sa.sin_family = AF_INET;
	sa.sin_port = htons(port);
	inet_pton(AF_INET, "127.0.0.1", &sa.sin_addr);
	if (connect(fd, (struct sockaddr *)&sa, sizeof sa) < 0) {
		close(fd);
		return -1;
	}
	return fd;
}

int
main(void)
{
	g_loop = iox_loop_new();
	if (!g_loop || net_init(g_loop) != 0) {
		fprintf(stderr, "init failed\n");
		return 1;
	}

	struct net_stream *listener = net_new_stream();
	if (!listener) return 1;
	net_add_listener(listener, NET_EVENT_ACCEPT, on_accept, NULL);
	/* Port 0 would need a getsockname — just use a fixed high port. */
	int port = 47321;
	if (net_listen(listener, port) != 0) {
		fprintf(stderr, "listen failed: %s\n", strerror(errno));
		return 1;
	}

	iox_timer_add(g_loop, 2000, bail, NULL);

	/* Kick off a client connection after the loop starts by doing
	 * it synchronously here (the listener socket is already in the
	 * kernel's accept queue ready for incoming SYNs). */
	int cfd = connect_localhost(port);
	if (cfd < 0) { fprintf(stderr, "connect failed\n"); return 1; }

	/* Send some bytes and half-close to trigger the close callback
	 * on the server side. */
	if (write(cfd, "ping", 4) != 4) { fprintf(stderr, "write failed\n"); return 1; }
	shutdown(cfd, SHUT_WR);

	iox_loop_run(g_loop);

	/* Read the server's reply. */
	char rb[32] = { 0 };
	ssize_t n = read(cfd, rb, sizeof rb - 1);
	(void)n;
	close(cfd);

	net_shutdown();
	iox_loop_free(g_loop);

	printf("accept=%d data=%d close=%d received=\"%.*s\" reply=\"%s\"\n",
	    accept_fired, data_fired, close_fired, received_len, received, rb);

	int ok = accept_fired == 1
	    && data_fired >= 1
	    && received_len == 4 && memcmp(received, "ping", 4) == 0
	    && close_fired == 1
	    && strcmp(rb, "hello\n") == 0;
	if (!ok) {
		fprintf(stderr, "test_net: FAIL\n");
		return 1;
	}
	printf("test_net: OK\n");
	return 0;
}
