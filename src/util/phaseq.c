/* phaseq.c - deadline-ordered event queue
 * Originally from gredin (Copyright 2007 J.Mayo). Imported into boris 2026.
 */
#define LOG_SUBSYSTEM "phaseq"
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "log/log.h"
#include "pool.h"
#include "phaseq.h"

struct phaseq_entry {
	struct phaseq_entry *next;
	time_t deadline;
	poolid_t event_id;
	poolid_t group_id;
	phaseq_func_t func;
	void *arg;
	char *str;
};

static struct phaseq_entry *phaseq_head;
static struct id_pool_head phaseq_event_pool;
static struct id_pool_head phaseq_group_pool;
static int phaseq_ready;

int
phaseq_init(void)
{
	if (phaseq_ready) return 0;
	pool_init(&phaseq_event_pool, 1, POOL_MAX);
	pool_init(&phaseq_group_pool, 1, POOL_MAX);
	phaseq_head = NULL;
	phaseq_ready = 1;
	LOG_INFO("phase queue initialized");
	return 0;
}

static void
entry_free(struct phaseq_entry *ent)
{
	if (!ent) return;
	pool_return(&phaseq_event_pool, ent->event_id);
	free(ent->str);
	free(ent);
}

void
phaseq_done(void)
{
	if (!phaseq_ready) return;
	while (phaseq_head) {
		struct phaseq_entry *tmp = phaseq_head->next;
		free(phaseq_head->str);
		free(phaseq_head);
		phaseq_head = tmp;
	}
	pool_free(&phaseq_event_pool);
	pool_free(&phaseq_group_pool);
	phaseq_ready = 0;
}

time_t
phaseq_expire_in(unsigned minutes, unsigned seconds)
{
	time_t now;
	time(&now);
	return now + (time_t)(minutes * 60u + seconds);
}

poolid_t
phaseq_add(time_t deadline, poolid_t group_id,
           phaseq_func_t func, void *arg, const char *str)
{
	struct phaseq_entry *ent, *curr, **prev;
	poolid_t new_id;

	assert(func != NULL);
	if (!pool_take_next(&phaseq_event_pool, &new_id)) {
		LOG_ERROR("out of phaseq event ids");
		return 0;
	}

	ent = malloc(sizeof *ent);
	ent->event_id = new_id;
	ent->group_id = group_id;
	ent->deadline = deadline;
	ent->func = func;
	ent->arg = arg;
	ent->str = str ? strdup(str) : NULL;

	for (prev = &phaseq_head, curr = phaseq_head; curr; prev = &curr->next, curr = curr->next) {
		if (difftime(deadline, curr->deadline) < 0) break;
	}
	ent->next = curr;
	*prev = ent;

	LOG_TRACE("added event %" POOLID_FMT " group %" POOLID_FMT, new_id, group_id);
	return new_id;
}

int
phaseq_cancel(poolid_t event_id)
{
	struct phaseq_entry *curr, **prev = &phaseq_head;
	if (!event_id) return 0;
	for (curr = *prev; curr; prev = &curr->next, curr = curr->next) {
		if (curr->event_id == event_id) {
			*prev = curr->next;
			entry_free(curr);
			return 1;
		}
	}
	return 0;
}

int
phaseq_scrub_group(poolid_t group_id)
{
	struct phaseq_entry *curr, **prev = &phaseq_head;
	int count = 0;
	if (group_id == PHASEQ_SINGLE) return 0;
	curr = *prev;
	while (curr) {
		if (curr->group_id == group_id) {
			*prev = curr->next;
			entry_free(curr);
			curr = *prev;
			count++;
		} else {
			prev = &curr->next;
			curr = curr->next;
		}
	}
	return count;
}

int
phaseq_scrub_arg(const void *arg)
{
	struct phaseq_entry *curr, **prev = &phaseq_head;
	int count = 0;
	curr = *prev;
	while (curr) {
		if (curr->arg == arg) {
			*prev = curr->next;
			entry_free(curr);
			curr = *prev;
			count++;
		} else {
			prev = &curr->next;
			curr = curr->next;
		}
	}
	return count;
}

poolid_t
phaseq_group_new(void)
{
	poolid_t id;
	if (!pool_take_next(&phaseq_group_pool, &id)) {
		LOG_ERROR("out of phaseq group ids");
		return 0;
	}
	return id;
}

void
phaseq_group_release(poolid_t group_id)
{
	if (group_id == PHASEQ_SINGLE) return;
	pool_return(&phaseq_group_pool, group_id);
}

long
phaseq_process(void)
{
	time_t now;
	struct phaseq_entry *ent;

	time(&now);
	while (phaseq_head && difftime(now, phaseq_head->deadline) >= 0) {
		ent = phaseq_head;
		phaseq_head = ent->next;
		ent->func(ent->arg, ent->str);
		entry_free(ent);
		time(&now);
	}
	if (!phaseq_head) return -1;
	return (long)difftime(phaseq_head->deadline, now);
}
