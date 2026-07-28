/* iox_internal.h : shared loop internals, not part of the public API */

#ifndef IOX_INTERNAL_H
#define IOX_INTERNAL_H

#include "iox_loop.h"
#include "iox_fd.h"
#include "iox_plat.h"

#define IOX_MAX_FDS 64

/* Timer and signal state are per-loop, but their layouts pull in headers
 * (pq.h, signal.h, winsock2.h) that the rest of the library has no reason
 * to see. Each is an opaque pointer owned by its own translation unit. */
struct iox_timers;
struct iox_signals;

struct iox_fd_entry {
    iox_fd_cb cb;
    void *arg;
    unsigned events;
    int active;
};

struct iox_loop {
    struct pollfd pfds[IOX_MAX_FDS];
    struct iox_fd_entry fds[IOX_MAX_FDS];
    int nfds;
    int running;
    int dispatching;
    int compact_needed;
    iox_idle_cb idle_cb;
    void *idle_arg;
    struct iox_timers *timers;      /* owned by iox_timer.c */
    struct iox_signals *signals;    /* owned by iox_signal.c */
};

#endif /* IOX_INTERNAL_H */
