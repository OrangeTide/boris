/* combat.c - combat session scheduling skeleton
 * Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN
 */
#include "combat.h"

#include <assert.h>
#include <stddef.h>
#include <stdint.h>

#include "iox/iox_timer.h"

static void combat_tick_cb(struct iox_loop *loop, void *arg);

static void
combat_rearm(struct combat *c)
{
	if (c->iox_timer_id >= 0) {
		if (c->loop)
			iox_timer_remove(c->loop, c->iox_timer_id);
		c->iox_timer_id = -1;
	}
	if (!c->loop)
		return;
	uint64_t head = phaseq_head_deadline(&c->pq);
	if (head == 0)
		return;
	uint64_t now = phaseq_now_ms();
	int delay = (head <= now) ? 0 : (int)(head - now);
	c->iox_timer_id = iox_timer_add(c->loop, delay, combat_tick_cb, c);
}

static void
combat_tick_cb(struct iox_loop *loop, void *arg)
{
	struct combat *c = arg;
	(void)loop;
	c->iox_timer_id = -1;          /* iox one-shot already consumed */
	int64_t next = phaseq_process(&c->pq);
	if (next < 0)
		return;
	combat_rearm(c);
}

int
combat_open(struct combat *c, struct iox_loop *loop)
{
	assert(c != NULL);
	c->loop = loop;
	c->iox_timer_id = -1;
	return phaseq_init(&c->pq);
}

void
combat_close(struct combat *c)
{
	assert(c != NULL);
	if (c->iox_timer_id >= 0) {
		if (c->loop)
			iox_timer_remove(c->loop, c->iox_timer_id);
		c->iox_timer_id = -1;
	}
	phaseq_done(&c->pq);
	c->loop = NULL;
}

poolid_t
combat_schedule(struct combat *c, uint64_t delay_ms,
                phaseq_func_t fn, void *arg, const char *str)
{
	return combat_schedule_at(c, phaseq_now_ms() + delay_ms, fn, arg, str);
}

poolid_t
combat_schedule_at(struct combat *c, uint64_t deadline_ms,
                   phaseq_func_t fn, void *arg, const char *str)
{
	uint64_t prev_head = phaseq_head_deadline(&c->pq);
	poolid_t id = phaseq_add(&c->pq, deadline_ms, fn, arg, str);
	if (id == 0)
		return 0;
	if (phaseq_head_deadline(&c->pq) != prev_head)
		combat_rearm(c);
	return id;
}

int
combat_cancel(struct combat *c, poolid_t event_id)
{
	uint64_t prev_head = phaseq_head_deadline(&c->pq);
	int removed = phaseq_cancel(&c->pq, event_id);
	if (removed && phaseq_head_deadline(&c->pq) != prev_head)
		combat_rearm(c);
	return removed;
}

int
combat_scrub(struct combat *c, const void *arg)
{
	uint64_t prev_head = phaseq_head_deadline(&c->pq);
	int n = phaseq_scrub_arg(&c->pq, arg);
	if (n > 0 && phaseq_head_deadline(&c->pq) != prev_head)
		combat_rearm(c);
	return n;
}

int64_t
combat_tick_at(struct combat *c, uint64_t now_ms)
{
	int64_t next = phaseq_process_at(&c->pq, now_ms);
	/* don't rearm in test mode (loop is typically NULL); production
	 * uses combat_tick_cb which rearms after phaseq_process. */
	if (c->loop)
		combat_rearm(c);
	return next;
}
