/* phaseq.h - deadline-ordered event queue
 * Originally from gredin (2007 J.Mayo). Imported into boris 2026.
 * Generic callback scheduler for async/delayed actions (combat ticks,
 * spell timers, periodic system events).
 */
#ifndef PHASEQ_H_
#define PHASEQ_H_

#include <time.h>
#include "pool.h"

#define PHASEQ_SINGLE ((poolid_t)0)

typedef void (*phaseq_func_t)(void *arg, const char *str);

int phaseq_init(void);
void phaseq_done(void);

/** compute absolute deadline 'minutes:seconds' from now */
time_t phaseq_expire_in(unsigned minutes, unsigned seconds);

/** schedule a callback for 'deadline'. returns event_id (nonzero) on success, 0 on failure.
 * group_id: PHASEQ_SINGLE for ungrouped, or a previously allocated group id
 * (via phaseq_group_new) so related events can be scrubbed together.
 * 'str' is copied. */
poolid_t phaseq_add(time_t deadline, poolid_t group_id,
                    phaseq_func_t func, void *arg, const char *str);

/** cancel a single event by its event_id. returns 1 if removed. */
int phaseq_cancel(poolid_t event_id);

/** cancel all events matching group_id. returns count removed. */
int phaseq_scrub_group(poolid_t group_id);

/** cancel all events whose 'arg' pointer matches 'arg'. returns count removed.
 * Useful when tearing down a character/client: pass its pointer. */
int phaseq_scrub_arg(const void *arg);

/** allocate a new group id for grouping related events. returns 0 on failure. */
poolid_t phaseq_group_new(void);

/** release a group id after its events are gone. */
void phaseq_group_release(poolid_t group_id);

/** run all events whose deadline has passed.
 * returns seconds until the next event, or -1 if the queue is empty. */
long phaseq_process(void);

#endif
