/* iox_timer.h : I/O multiplexer -- one-shot timers */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#ifndef IOX_TIMER_H
#define IOX_TIMER_H

struct iox_loop;

/** Callback invoked when a timer expires. */
typedef void (*iox_timer_cb)(struct iox_loop *loop, void *arg);

/** Schedule a one-shot timer that fires after @ms milliseconds.
 *  Returns a timer ID (>= 0) on success, -1 on error. */
int iox_timer_add(struct iox_loop *loop, int ms, iox_timer_cb cb, void *arg);

/** Cancel a pending timer. Safe to call with an expired or invalid ID. */
void iox_timer_remove(struct iox_loop *loop, int id);

/* internal -- called by iox_loop */
void iox_timer_init(struct iox_loop *loop);
void iox_timer_shutdown(struct iox_loop *loop);
int  iox_timer_next_ms(struct iox_loop *loop);
void iox_timer_dispatch(struct iox_loop *loop);

#endif /* IOX_TIMER_H */
