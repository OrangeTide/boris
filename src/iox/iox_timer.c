/* iox_timer.c : I/O multiplexer -- one-shot timers via priority queue */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#include "iox_timer.h"

#include <stdint.h>
#include <time.h>

#define IOX_MAX_TIMERS 16

struct iox_timer_entry {
	int64_t deadline_ns;
	iox_timer_cb cb;
	void *arg;
	int id;
};

#define PQ_NAME		timer_pq
#define PQ_ENTRY_TYPE	struct iox_timer_entry
#define PQ_KEY(e)	((e).deadline_ns)
#define PQ_STATIC
#define PQ_IMPLEMENTATION
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#include "pq.h"
#pragma GCC diagnostic pop

static struct timer_pq timers;
static int next_id;
static int initialized;

static int64_t
now_ns(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (int64_t)ts.tv_sec * 1000000000LL + (int64_t)ts.tv_nsec;
}

void
iox_timer_init(struct iox_loop *loop)
{
	(void)loop;

	if (initialized)
		return;
	timer_pq_init(&timers, IOX_MAX_TIMERS);
	next_id = 0;
	initialized = 1;
}

void
iox_timer_shutdown(struct iox_loop *loop)
{
	(void)loop;

	if (!initialized)
		return;
	timer_pq_free(&timers);
	initialized = 0;
}

int
iox_timer_add(struct iox_loop *loop, int ms, iox_timer_cb cb, void *arg)
{
	struct iox_timer_entry e;

	(void)loop;

	if (!initialized)
		return -1;

	e.deadline_ns = now_ns() + (int64_t)ms * 1000000LL;
	e.cb = cb;
	e.arg = arg;
	e.id = next_id++;

	if (!timer_pq_enqueue(&timers, e)) {
		/* queue full -- try to grow */
		if (!timer_pq_resize(&timers, timers.max * 2))
			return -1;
		if (!timer_pq_enqueue(&timers, e))
			return -1;
	}

	return e.id;
}

void
iox_timer_remove(struct iox_loop *loop, int id)
{
	int idx;
	struct iox_timer_entry probe;

	(void)loop;

	if (!initialized)
		return;

	/* linear scan by ID -- fine for small timer counts */
	for (idx = 0; idx < (int)timer_pq_size(&timers); idx++) {
		struct iox_timer_entry *ep = timer_pq_peek(&timers, (unsigned)idx);

		if (ep && ep->id == id) {
			timer_pq_remove(&timers, (unsigned)idx, &probe);
			return;
		}
	}
}

int
iox_timer_next_ms(struct iox_loop *loop)
{
	struct iox_timer_entry *top;
	int64_t diff;

	(void)loop;

	if (!initialized)
		return -1;

	top = timer_pq_top(&timers);
	if (!top)
		return -1;

	diff = (top->deadline_ns - now_ns() + 999999LL) / 1000000LL;
	if (diff < 0)
		diff = 0;
	if (diff > (int64_t)0x7FFFFFFF)
		diff = 0x7FFFFFFF;
	return (int)diff;
}

void
iox_timer_dispatch(struct iox_loop *loop)
{
	struct iox_timer_entry e;
	int64_t t;

	if (!initialized)
		return;

	t = now_ns();

	while (timer_pq_top(&timers) &&
	    timer_pq_top(&timers)->deadline_ns <= t) {
		timer_pq_dequeue(&timers, &e);
		if (e.cb)
			e.cb(loop, e.arg);
	}
}
