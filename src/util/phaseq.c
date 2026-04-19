/* phaseq.c - per-instance deadline-ordered event queue
 * Originally from gredin (Copyright 2007 J.Mayo). Imported into boris 2026.
 */
#define LOG_SUBSYSTEM "phaseq"
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "log/log.h"
#include "pool.h"
#include "phaseq.h"

struct phaseq_entry {
	struct phaseq_entry *next;
	uint64_t      deadline_ms;
	poolid_t      event_id;
	phaseq_func_t func;
	void         *arg;
	char         *str;
};

uint64_t
phaseq_now_ms(void)
{
	struct timespec ts;
	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint64_t)ts.tv_sec * 1000u + (uint64_t)(ts.tv_nsec / 1000000);
}

int
phaseq_init(struct phaseq *q)
{
	assert(q != NULL);
	q->head = NULL;
	pool_init(&q->ids, 1, POOL_MAX);
	return 0;
}

static void
entry_free(struct phaseq *q, struct phaseq_entry *ent)
{
	if (!ent) return;
	pool_return(&q->ids, ent->event_id);
	free(ent->str);
	free(ent);
}

void
phaseq_done(struct phaseq *q)
{
	if (!q) return;
	while (q->head) {
		struct phaseq_entry *tmp = q->head->next;
		free(q->head->str);
		free(q->head);
		q->head = tmp;
	}
	pool_free(&q->ids);
}

poolid_t
phaseq_add(struct phaseq *q, uint64_t deadline_ms,
           phaseq_func_t func, void *arg, const char *str)
{
	struct phaseq_entry *ent, *curr, **prev;
	poolid_t new_id;

	assert(q != NULL);
	assert(func != NULL);

	if (!pool_take_next(&q->ids, &new_id)) {
		LOG_ERROR("out of phaseq event ids");
		return 0;
	}

	ent = malloc(sizeof *ent);
	if (!ent) {
		pool_return(&q->ids, new_id);
		return 0;
	}
	ent->event_id = new_id;
	ent->deadline_ms = deadline_ms;
	ent->func = func;
	ent->arg = arg;
	ent->str = str ? strdup(str) : NULL;
	if (str && !ent->str) {
		pool_return(&q->ids, new_id);
		free(ent);
		return 0;
	}

	for (prev = &q->head, curr = q->head; curr; prev = &curr->next, curr = curr->next) {
		if (deadline_ms < curr->deadline_ms) break;
	}
	ent->next = curr;
	*prev = ent;

	return new_id;
}

int
phaseq_cancel(struct phaseq *q, poolid_t event_id)
{
	struct phaseq_entry *curr, **prev;
	if (!q || !event_id) return 0;
	prev = &q->head;
	for (curr = *prev; curr; prev = &curr->next, curr = curr->next) {
		if (curr->event_id == event_id) {
			*prev = curr->next;
			entry_free(q, curr);
			return 1;
		}
	}
	return 0;
}

int
phaseq_scrub_arg(struct phaseq *q, const void *arg)
{
	struct phaseq_entry *curr, **prev;
	int count = 0;
	if (!q) return 0;
	prev = &q->head;
	curr = *prev;
	while (curr) {
		if (curr->arg == arg) {
			*prev = curr->next;
			entry_free(q, curr);
			curr = *prev;
			count++;
		} else {
			prev = &curr->next;
			curr = curr->next;
		}
	}
	return count;
}

uint64_t
phaseq_head_deadline(const struct phaseq *q)
{
	if (!q || !q->head) return 0;
	return q->head->deadline_ms;
}

int64_t
phaseq_process_at(struct phaseq *q, uint64_t now_ms)
{
	struct phaseq_entry *ent;

	assert(q != NULL);
	while (q->head && q->head->deadline_ms <= now_ms) {
		ent = q->head;
		q->head = ent->next;
		ent->func(ent->arg, ent->str);
		entry_free(q, ent);
	}
	if (!q->head) return -1;
	return (int64_t)(q->head->deadline_ms - now_ms);
}

int64_t
phaseq_process(struct phaseq *q)
{
	return phaseq_process_at(q, phaseq_now_ms());
}
