/* iox_fd.c : I/O multiplexer -- file descriptor watchers */

#include "iox_fd.h"
#include "iox_internal.h"

static unsigned
poll_events_from_iox(unsigned iox_events)
{
    unsigned pe = 0;

    if (iox_events & IOX_READ)
        pe |= POLLIN;
    if (iox_events & IOX_WRITE)
        pe |= POLLOUT;
    return pe;
}

int
iox_fd_add(struct iox_loop *loop, int fd, unsigned events,
           iox_fd_cb cb, void *arg)
{
    int idx;

    if (loop->nfds >= IOX_MAX_FDS)
        return IOX_ERR;

    idx = loop->nfds++;
    loop->pfds[idx].fd = (iox_pollfd_t)fd;
    loop->pfds[idx].events = (short)poll_events_from_iox(events);
    loop->pfds[idx].revents = 0;
    loop->fds[idx].cb = cb;
    loop->fds[idx].arg = arg;
    loop->fds[idx].events = events;
    loop->fds[idx].active = 1;
    return IOX_OK;
}

int
iox_fd_mod(struct iox_loop *loop, int fd, unsigned events)
{
    int i;

    for (i = 0; i < loop->nfds; i++) {
        if (loop->pfds[i].fd != (iox_pollfd_t)fd ||
            !loop->fds[i].active)
            continue;

        loop->fds[i].events = events;
        loop->pfds[i].events = (short)poll_events_from_iox(events);
        return IOX_OK;
    }

    return IOX_ERR; /* not found */
}

void
iox_fd_remove(struct iox_loop *loop, int fd)
{
    int i;

    for (i = 0; i < loop->nfds; i++) {
        if (loop->pfds[i].fd != (iox_pollfd_t)fd ||
            !loop->fds[i].active)
            continue;

        if (loop->dispatching) {
            /* defer removal until dispatch completes */
            loop->fds[i].active = 0;
            loop->compact_needed = 1;
        } else {
            /* immediate removal -- swap with last */
            loop->nfds--;
            if (i < loop->nfds) {
                loop->pfds[i] = loop->pfds[loop->nfds];
                loop->fds[i] = loop->fds[loop->nfds];
            }
        }
        return;
    }
}
