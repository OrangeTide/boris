/* pool.c - numeric id pools
 * PUBLIC DOMAIN - August 2005 - J.Mayo
 * Imported into boris from gredin, 2026.
 */
#define LOG_SUBSYSTEM "pool"
#include <stdlib.h>
#include <stdio.h>

#include "log/log.h"
#include "pool.h"

struct id_pool {
	poolid_t lower, upper;
	struct id_pool *next;
};

static struct id_pool *
pool_entry_create(poolid_t lower, poolid_t upper, struct id_pool *next)
{
	struct id_pool *ret = malloc(sizeof *ret);
	ret->lower = lower;
	ret->upper = upper;
	ret->next = next;
	return ret;
}

void
pool_init(struct id_pool_head *head, poolid_t lower, poolid_t upper)
{
	head->head = pool_entry_create(lower, upper, NULL);
}

void
pool_free(struct id_pool_head *head)
{
	while (head->head) {
		struct id_pool *tmp = head->head->next;
		free(head->head);
		head->head = tmp;
	}
}

int
pool_take_next(struct id_pool_head *head, poolid_t *id)
{
	struct id_pool *curr = head->head;
	if (!curr || !id) return 0;
	*id = curr->lower;
	curr->lower++;
	if (curr->lower > curr->upper) {
		head->head = curr->next;
		free(curr);
	}
	return 1;
}

int
pool_take(struct id_pool_head *head, poolid_t id)
{
	struct id_pool *curr, **prev = &head->head;
	for (curr = *prev; curr && curr->lower < id && curr->upper < id; prev = &curr->next, curr = curr->next)
		;
	if (!curr || id < curr->lower || id > curr->upper) return 0;
	if (id == curr->lower) {
		curr->lower++;
	} else if (id == curr->upper) {
		curr->upper--;
	} else {
		curr->next = pool_entry_create(id + 1, curr->upper, curr->next);
		curr->upper = id - 1;
	}
	if (curr->lower > curr->upper) {
		*prev = curr->next;
		free(curr);
	}
	return 1;
}

void
pool_return(struct id_pool_head *head, poolid_t id)
{
	struct id_pool *curr, **prev = &head->head, *last = NULL;
	curr = *prev;
	if (!curr || curr->lower > id) {
		if (curr && id + 1 == curr->lower) {
			curr->lower--;
			return;
		}
		*prev = pool_entry_create(id, id, curr);
		return;
	}
	for (; curr && curr->upper < id; prev = &curr->next, last = curr, curr = curr->next)
		;
	if (!curr) {
		if (last && last->upper + 1 == id) {
			last->upper++;
			return;
		}
		*prev = pool_entry_create(id, id, NULL);
		return;
	}
	if (id >= curr->lower && id <= curr->upper) {
		LOG_WARNING("id %" POOLID_FMT " already in pool", id);
		return;
	}

	if (last && last->upper + 1 == id) last->upper++;
	else if (curr->lower == id + 1) curr->lower--;
	else *prev = pool_entry_create(id, id, curr);

	if (last && curr->lower == last->upper + 1) {
		last->upper = curr->upper;
		last->next = curr->next;
		free(curr);
	}
}

#ifndef NDEBUG
void
pool_dump(const struct id_pool_head *head)
{
	const struct id_pool *curr;
	LOG_DEBUG("id pool:");
	for (curr = head->head; curr; curr = curr->next) {
		LOG_DEBUG("  [%" POOLID_FMT ", %" POOLID_FMT "]", curr->lower, curr->upper);
	}
}
#endif
