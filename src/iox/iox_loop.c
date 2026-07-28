/* iox_loop.c : I/O multiplexer -- poll()-based event loop */

#include "iox_loop.h"
#include "iox_signal.h"
#include "iox_timer.h"
#include "iox_internal.h"

#include <stdlib.h>

/* remove inactive entries after dispatch completes */
static void
compact(struct iox_loop *loop)
{
    int i;

    loop->compact_needed = 0;

    for (i = 0; i < loop->nfds; ) {
        if (loop->fds[i].active) {
            i++;
            continue;
        }

        /* swap with last entry */
        loop->nfds--;
        if (i < loop->nfds) {
            loop->pfds[i] = loop->pfds[loop->nfds];
            loop->fds[i] = loop->fds[loop->nfds];
        }
        /* don't advance i -- re-check the swapped entry */
    }
}

static unsigned
iox_events_from_poll(unsigned short revents)
{
    unsigned ev = 0;

    /* POLLNVAL means the fd was closed behind the loop's back. Report it
     * as readable so the callback's next read() fails visibly; the
     * dispatch loop then drops the entry so poll cannot spin on it. */
    if (revents & (POLLIN | POLLHUP | POLLERR | POLLNVAL))
        ev |= IOX_READ;
    if (revents & POLLOUT)
        ev |= IOX_WRITE;
    return ev;
}

struct iox_loop *
iox_loop_new(void)
{
    struct iox_loop *loop;

    loop = calloc(1, sizeof(*loop));
    if (!loop)
        return NULL;

    if (iox_timer_init(loop) != 0 || iox_signal_init(loop) != 0) {
        iox_loop_free(loop);
        return NULL;
    }

    return loop;
}

void
iox_loop_free(struct iox_loop *loop)
{
    if (!loop)
        return;
    iox_timer_shutdown(loop);
    iox_signal_shutdown(loop);
    free(loop);
}

int
iox_loop_poll(struct iox_loop *loop)
{
    int i, n, dispatched, timeout_ms;

    timeout_ms = iox_timer_next_ms(loop);
    n = iox_plat_poll(loop->pfds, (unsigned long)loop->nfds, timeout_ms);
    if (n < 0)
        return IOX_ERR; /* caller checks errno for EINTR */

    dispatched = 0;
    loop->dispatching = 1;

    for (i = 0; i < loop->nfds && n > 0; i++) {
        unsigned ev;

        if (loop->pfds[i].revents == 0)
            continue;
        n--;

        if (!loop->fds[i].active)
            continue;

        ev = iox_events_from_poll(loop->pfds[i].revents);
        if (ev && loop->fds[i].cb) {
            loop->fds[i].cb(loop, (int)loop->pfds[i].fd, ev,
                loop->fds[i].arg);
            dispatched++;
        }

        /* An invalid fd never becomes valid again. Drop it rather
         * than let poll return it immediately, forever. */
        if (loop->pfds[i].revents & POLLNVAL) {
            loop->fds[i].active = 0;
            loop->compact_needed = 1;
        }
    }

    loop->dispatching = 0;

    if (loop->compact_needed)
        compact(loop);

    iox_timer_dispatch(loop);

    return dispatched;
}

int
iox_loop_run(struct iox_loop *loop)
{
    loop->running = 1;

    while (loop->running) {
        int rc = iox_loop_poll(loop);

        if (rc < 0) {
            /* EINTR is normal (signal delivery); anything else
             * would spin here forever, so surface it */
            if (iox_plat_poll_interrupted())
                continue;
            return IOX_ERR;
        }

        if (loop->idle_cb)
            loop->idle_cb(loop, loop->idle_arg);
    }

    return IOX_OK;
}

void
iox_loop_start(struct iox_loop *loop)
{
    loop->running = 1;
}

void
iox_loop_stop(struct iox_loop *loop)
{
    loop->running = 0;
}

bool
iox_loop_is_stopped(const struct iox_loop *loop)
{
    return !loop->running;
}

void
iox_loop_set_idle(struct iox_loop *loop, iox_idle_cb cb, void *arg)
{
    loop->idle_cb = cb;
    loop->idle_arg = arg;
}
