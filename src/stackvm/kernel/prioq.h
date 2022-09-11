#ifndef PRIOQ_H_
#define PRIOQ_H_

struct prioq_elm
{
    unsigned long long d; /* key - usually time */
    void *p;
};

struct prioq {
	unsigned heap_len, heap_max;
	struct prioq_elm *heap;
};

struct prioq *prioq_new(unsigned max_size);
void prioq_free(struct prioq *h);
int prioq_enqueue(struct prioq *h, const struct prioq_elm *elm);
int prioq_dequeue(struct prioq *h, struct prioq_elm *out);
int prioq_cancel(struct prioq *h, unsigned i, struct prioq_elm *out);
int prioq_find(struct prioq *h, const void *p);
int prioq_test_if_valid(struct prioq *h);
// TODO: an API to return the min value would be good for setting up minimum time outs

#endif
