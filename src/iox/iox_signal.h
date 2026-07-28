/* iox_signal.h : I/O multiplexer -- signal handling */

#ifndef IOX_SIGNAL_H
#define IOX_SIGNAL_H

struct iox_loop;

typedef void (*iox_signal_cb)(struct iox_loop *loop, int signo, void *arg);

/** Register a handler for signo on this loop.
 *
 * Callbacks run in normal context, not in the signal handler, so they may
 * call anything. Registering a signal already registered on this loop
 * replaces its callback. Several loops may watch the same signal; each
 * gets its own callback. Returns 0 on success, -1 on error.
 */
int iox_signal_add(struct iox_loop *loop, int signo, iox_signal_cb cb,
                   void *arg);

/** Unregister signo on this loop.
 *
 * The process-wide disposition is restored only once the last loop
 * watching signo has dropped it.
 */
void iox_signal_remove(struct iox_loop *loop, int signo);

/* internal -- called by iox_loop */
int  iox_signal_init(struct iox_loop *loop);
void iox_signal_shutdown(struct iox_loop *loop);

#endif /* IOX_SIGNAL_H */
