#include "webclient.h"
#include <stdlib.h>
#include <string.h>

static pthread_mutex_t web_clients_lock = PTHREAD_MUTEX_INITIALIZER;
static struct web_client *web_clients_head;
static int wake_fd = -1;

void
webclient_set_wake_fd(int fd)
{
	wake_fd = fd;
}

int
webclient_get_wake_fd(void)
{
	return wake_fd;
}

struct web_client *
webclient_new(struct mg_connection *c)
{
	struct web_client *wc = calloc(1, sizeof(*wc));
	if (!wc)
		return NULL;
	wc->ws_conn = c;
	wc->state = WC_NEW;
	msgqueue_init(&wc->input_q);
	msgqueue_init(&wc->output_q);

	pthread_mutex_lock(&web_clients_lock);
	wc->next = web_clients_head;
	web_clients_head = wc;
	pthread_mutex_unlock(&web_clients_lock);

	return wc;
}

void
webclient_destroy(struct web_client *wc)
{
	pthread_mutex_lock(&web_clients_lock);
	struct web_client **pp = &web_clients_head;
	while (*pp) {
		if (*pp == wc) {
			*pp = wc->next;
			break;
		}
		pp = &(*pp)->next;
	}
	pthread_mutex_unlock(&web_clients_lock);

	msgqueue_destroy(&wc->input_q);
	msgqueue_destroy(&wc->output_q);
	free(wc);
}

struct web_client *
webclient_first(void)
{
	return web_clients_head;
}

void
webclient_lock(void)
{
	pthread_mutex_lock(&web_clients_lock);
}

void
webclient_unlock(void)
{
	pthread_mutex_unlock(&web_clients_lock);
}
