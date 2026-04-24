#include "msgqueue.h"
#include <stdlib.h>
#include <string.h>

void
msgqueue_init(struct msg_queue *q)
{
	pthread_mutex_init(&q->lock, NULL);
	q->head = NULL;
	q->tail = NULL;
}

void
msgqueue_destroy(struct msg_queue *q)
{
	struct client_msg *msg;
	while ((msg = msgqueue_get(q)) != NULL)
		free(msg);
	pthread_mutex_destroy(&q->lock);
}

int
msgqueue_put(struct msg_queue *q, const char *data, int len)
{
	struct client_msg *msg = malloc(sizeof(*msg) + len + 1);
	if (!msg)
		return -1;
	msg->next = NULL;
	msg->len = len;
	memcpy(msg->data, data, len);
	msg->data[len] = '\0';

	pthread_mutex_lock(&q->lock);
	if (q->tail)
		q->tail->next = msg;
	else
		q->head = msg;
	q->tail = msg;
	pthread_mutex_unlock(&q->lock);

	return 0;
}

struct client_msg *
msgqueue_get(struct msg_queue *q)
{
	pthread_mutex_lock(&q->lock);
	struct client_msg *msg = q->head;
	if (msg) {
		q->head = msg->next;
		if (!q->head)
			q->tail = NULL;
		msg->next = NULL;
	}
	pthread_mutex_unlock(&q->lock);

	return msg;
}
