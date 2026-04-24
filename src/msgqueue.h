#ifndef MSGQUEUE_H_
#define MSGQUEUE_H_
#include <pthread.h>

struct client_msg {
	struct client_msg *next;
	int len;
	char data[];
};

struct msg_queue {
	pthread_mutex_t lock;
	struct client_msg *head;
	struct client_msg *tail;
};

void msgqueue_init(struct msg_queue *q);
void msgqueue_destroy(struct msg_queue *q);
int msgqueue_put(struct msg_queue *q, const char *data, int len);
struct client_msg *msgqueue_get(struct msg_queue *q);

#endif
