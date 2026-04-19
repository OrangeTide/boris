/* phaseq.h - per-instance deadline-ordered event queue
 * Originally from gredin (2007 J.Mayo). Imported into boris 2026.
 *
 * Each phaseq instance is a sorted singly-linked list of
 * {deadline_ms, callback, arg, str} entries. Owners poll the head to
 * learn when to wake, then call phaseq_process() to fire all entries
 * whose deadline has passed.
 *
 * See doc/phaseq.md for design notes and doc/combat-queue.md for the
 * intended use pattern (one instance per combat session, fronted by an
 * iox timer slot).
 */
#ifndef PHASEQ_H_
#define PHASEQ_H_

#include <stdint.h>

#include "pool.h"

struct phaseq_entry;

struct phaseq {
	struct phaseq_entry *head;
	struct id_pool_head  ids;
};

typedef void (*phaseq_func_t)(void *arg, const char *str);

/** monotonic millisecond clock used by phaseq_process(). */
uint64_t phaseq_now_ms(void);

/** initialize an instance. returns 0 on success. */
int  phaseq_init(struct phaseq *q);

/** release all entries and the id pool. */
void phaseq_done(struct phaseq *q);

/** schedule a callback for absolute deadline_ms. returns event_id (nonzero)
 * on success, 0 on failure. 'str' is copied; may be NULL. */
poolid_t phaseq_add(struct phaseq *q, uint64_t deadline_ms,
                    phaseq_func_t func, void *arg, const char *str);

/** cancel a single event by event_id. returns 1 if removed, 0 otherwise. */
int phaseq_cancel(struct phaseq *q, poolid_t event_id);

/** cancel all entries whose 'arg' pointer equals arg. returns count. */
int phaseq_scrub_arg(struct phaseq *q, const void *arg);

/** absolute deadline of the head entry, or 0 if the queue is empty. */
uint64_t phaseq_head_deadline(const struct phaseq *q);

/** fire all entries whose deadline <= phaseq_now_ms().
 * returns ms-until-next-head, or -1 if the queue is empty. */
int64_t phaseq_process(struct phaseq *q);

/** same, with a caller-supplied 'now' (avoids a clock read; lets tests
 * advance time deterministically). */
int64_t phaseq_process_at(struct phaseq *q, uint64_t now_ms);

#endif
