/* iox_loop.h : I/O multiplexer -- event loop */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#ifndef IOX_LOOP_H
#define IOX_LOOP_H

struct iox_loop;

typedef void (*iox_idle_cb)(struct iox_loop *loop, void *arg);

struct iox_loop *iox_loop_new(void);
void iox_loop_free(struct iox_loop *loop);

/** Poll once, dispatching ready fd events and expired timers.
 *  Blocks until an fd is ready or the next timer expires.
 *  Returns number of events dispatched, or -1 on error. */
int iox_loop_poll(struct iox_loop *loop);

/** Run the loop until iox_loop_stop() is called.
 *  Calls idle callback (if set) between iterations. */
int iox_loop_run(struct iox_loop *loop);

void iox_loop_stop(struct iox_loop *loop);

/** Mark the loop as running (for use with manual iox_loop_poll loops).
 *  Called automatically by iox_loop_run(). */
void iox_loop_start(struct iox_loop *loop);

/** Returns non-zero if the loop has been stopped via iox_loop_stop(). */
int iox_loop_stopped(const struct iox_loop *loop);

void iox_loop_set_idle(struct iox_loop *loop, iox_idle_cb cb, void *arg);

#endif /* IOX_LOOP_H */
