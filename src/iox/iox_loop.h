/* iox_loop.h : I/O multiplexer -- event loop */

#ifndef IOX_LOOP_H
#define IOX_LOOP_H

#include <stdbool.h>

/* Every libiox function returning a plain status returns one of these.
 * The return type stays int and the values are fixed by the definition, so
 * a caller that tests < 0 directly is correct without including this. */
#define IOX_OK  (0)
#define IOX_ERR (-1)

struct iox_loop;

typedef void (*iox_idle_cb)(struct iox_loop *loop, void *arg);

struct iox_loop *iox_loop_new(void);
void iox_loop_free(struct iox_loop *loop);

/** Poll once, dispatching ready fd events and expired timers.
 *  Blocks until an fd is ready or the next timer expires.
 *  Returns the number of fd events dispatched, or IOX_ERR on error.
 *  Success is any count from zero up, so < 0 is the failure test. */
int iox_loop_poll(struct iox_loop *loop);

/** Run the loop until iox_loop_stop() is called.
 *  Calls the idle callback (if set) between iterations.
 *  Returns IOX_OK on a clean stop, or IOX_ERR if poll failed for any
 *  reason other than EINTR. */
int iox_loop_run(struct iox_loop *loop);

void iox_loop_stop(struct iox_loop *loop);

/** Mark the loop as running (for use with manual iox_loop_poll loops).
 *  Called automatically by iox_loop_run(). */
void iox_loop_start(struct iox_loop *loop);

/** True once iox_loop_stop() has been called.
 *
 * A question rather than a status, so it answers with a bool and there is
 * no IOX_OK anywhere near it.
 */
bool iox_loop_is_stopped(const struct iox_loop *loop);

void iox_loop_set_idle(struct iox_loop *loop, iox_idle_cb cb, void *arg);

/* Deprecated, to be removed in 0.2.0.
 *
 * iox_loop_stopped read as a status where it is really a predicate. Four
 * call sites across the pre-consolidation copies use the old name, so the
 * alias is what lets those re-vendor without an edit. Define
 * IOX_NO_DEPRECATED to drop it, which is how a copy proves it has finished
 * migrating. */
#ifndef IOX_NO_DEPRECATED
#  define iox_loop_stopped(loop) iox_loop_is_stopped(loop)
#endif

#endif /* IOX_LOOP_H */
