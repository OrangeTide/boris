/* combat.h - combat session scheduling skeleton
 *
 * One phaseq per combat session, fronted by a single iox one-shot timer
 * slot. See doc/combat-queue.md for the layering rationale. This header
 * intentionally exposes only scheduling -- combatants, attack resolution,
 * and damage are out of scope and belong to a higher layer (rpg/).
 *
 * Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN
 */
#ifndef COMBAT_H
#define COMBAT_H

#include <stdint.h>

#include "util/phaseq.h"

struct iox_loop;

struct combat {
	struct phaseq    pq;
	struct iox_loop *loop;        /* may be NULL in tests */
	int              iox_timer_id; /* -1 if none scheduled */
};

/** initialize a combat session.
 *  @param loop  iox loop to register timers with, or NULL for tests
 *  returns 0 on success. */
int combat_open(struct combat *c, struct iox_loop *loop);

/** cancel any pending iox timer and release the phaseq. */
void combat_close(struct combat *c);

/** schedule a callback for delay_ms from phaseq_now_ms().
 *  re-arms the iox timer if the head changed.
 *  returns event_id (nonzero) on success, 0 on failure. */
poolid_t combat_schedule(struct combat *c, uint64_t delay_ms,
                         phaseq_func_t fn, void *arg, const char *str);

/** schedule a callback for an absolute monotonic-ms deadline. */
poolid_t combat_schedule_at(struct combat *c, uint64_t deadline_ms,
                            phaseq_func_t fn, void *arg, const char *str);

/** cancel a single event by id. returns 1 if removed, else 0. */
int combat_cancel(struct combat *c, poolid_t event_id);

/** cancel all events matching arg. returns count removed. */
int combat_scrub(struct combat *c, const void *arg);

/** test hook: fire all entries due at now_ms, without touching iox.
 *  returns ms-until-next-head, or -1 if drained.
 *  not for production use; the iox callback drives this in real runs. */
int64_t combat_tick_at(struct combat *c, uint64_t now_ms);

#endif /* COMBAT_H */
