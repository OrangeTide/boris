/* iox_loop.c : I/O multiplexer -- poll()-based event loop */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#include "iox_loop.h"
#include "iox_fd.h"
#include "iox_signal.h"
#include "iox_timer.h"

#include <poll.h>
#include <stdlib.h>

#define IOX_MAX_FDS 64

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
};

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
poll_events_from_iox(unsigned iox_events)
{
	unsigned pe = 0;

	if (iox_events & IOX_READ)
		pe |= POLLIN;
	if (iox_events & IOX_WRITE)
		pe |= POLLOUT;
	return pe;
}

static unsigned
iox_events_from_poll(unsigned short revents)
{
	unsigned ev = 0;

	if (revents & (POLLIN | POLLHUP | POLLERR))
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

	iox_signal_init(loop);
	iox_timer_init(loop);
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
	n = poll(loop->pfds, (nfds_t)loop->nfds, timeout_ms);
	if (n < 0)
		return -1; /* caller checks errno for EINTR */

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
			loop->fds[i].cb(loop, loop->pfds[i].fd, ev,
			    loop->fds[i].arg);
			dispatched++;
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
			/* EINTR is normal (signal delivery) */
			continue;
		}

		if (loop->idle_cb)
			loop->idle_cb(loop, loop->idle_arg);
	}

	return 0;
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

int
iox_loop_stopped(const struct iox_loop *loop)
{
	return !loop->running;
}

void
iox_loop_set_idle(struct iox_loop *loop, iox_idle_cb cb, void *arg)
{
	loop->idle_cb = cb;
	loop->idle_arg = arg;
}

int
iox_fd_add(struct iox_loop *loop, int fd, unsigned events,
           iox_fd_cb cb, void *arg)
{
	int idx;

	if (loop->nfds >= IOX_MAX_FDS)
		return -1;

	idx = loop->nfds++;
	loop->pfds[idx].fd = fd;
	loop->pfds[idx].events = (short)poll_events_from_iox(events);
	loop->pfds[idx].revents = 0;
	loop->fds[idx].cb = cb;
	loop->fds[idx].arg = arg;
	loop->fds[idx].events = events;
	loop->fds[idx].active = 1;
	return 0;
}

int
iox_fd_mod(struct iox_loop *loop, int fd, unsigned events)
{
	int i;

	for (i = 0; i < loop->nfds; i++) {
		if (loop->pfds[i].fd != fd || !loop->fds[i].active)
			continue;

		loop->fds[i].events = events;
		loop->pfds[i].events = (short)poll_events_from_iox(events);
		return 0;
	}

	return -1; /* not found */
}

void
iox_fd_remove(struct iox_loop *loop, int fd)
{
	int i;

	for (i = 0; i < loop->nfds; i++) {
		if (loop->pfds[i].fd != fd || !loop->fds[i].active)
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
