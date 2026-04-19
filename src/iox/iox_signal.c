/* iox_signal.c : I/O multiplexer -- signal handling via self-pipe */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#include "iox_signal.h"
#include "iox_fd.h"

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <unistd.h>

#define IOX_MAX_SIGNALS 8

struct iox_signal_entry {
	iox_signal_cb cb;
	void *arg;
	int signo;
	struct sigaction old_sa;
	int active;
};

static int sig_pipe[2] = { -1, -1 };
static struct iox_signal_entry sig_table[IOX_MAX_SIGNALS];
static int sig_count;

static void
sig_handler(int signo)
{
	unsigned char s = (unsigned char)signo;
	int saved_errno = errno;

	/* best-effort write; if pipe is full, signal is already pending */
	(void)write(sig_pipe[1], &s, 1);
	errno = saved_errno;
}

static void
sig_pipe_cb(struct iox_loop *loop, int fd, unsigned events, void *arg)
{
	unsigned char buf[32];
	ssize_t n;
	int i;

	(void)events;
	(void)arg;

	n = read(fd, buf, sizeof(buf));
	if (n <= 0)
		return;

	while (n-- > 0) {
		int signo = buf[n];

		for (i = 0; i < sig_count; i++) {
			if (sig_table[i].active &&
			    sig_table[i].signo == signo &&
			    sig_table[i].cb) {
				sig_table[i].cb(loop, signo,
				    sig_table[i].arg);
			}
		}
	}
}

static int
set_nonblock(int fd)
{
	int flags = fcntl(fd, F_GETFL);

	if (flags < 0)
		return -1;
	return fcntl(fd, F_SETFL, flags | O_NONBLOCK);
}

static int
set_cloexec(int fd)
{
	int flags = fcntl(fd, F_GETFD);

	if (flags < 0)
		return -1;
	return fcntl(fd, F_SETFD, flags | FD_CLOEXEC);
}

void
iox_signal_init(struct iox_loop *loop)
{
	if (sig_pipe[0] >= 0)
		return;

	if (pipe(sig_pipe) < 0)
		return;

	set_nonblock(sig_pipe[0]);
	set_nonblock(sig_pipe[1]);
	set_cloexec(sig_pipe[0]);
	set_cloexec(sig_pipe[1]);

	iox_fd_add(loop, sig_pipe[0], IOX_READ, sig_pipe_cb, NULL);
}

void
iox_signal_shutdown(struct iox_loop *loop)
{
	int i;

	for (i = 0; i < sig_count; i++) {
		if (sig_table[i].active)
			iox_signal_remove(loop, sig_table[i].signo);
	}
	sig_count = 0;

	if (sig_pipe[0] >= 0) {
		iox_fd_remove(loop, sig_pipe[0]);
		close(sig_pipe[0]);
		close(sig_pipe[1]);
		sig_pipe[0] = -1;
		sig_pipe[1] = -1;
	}
}

int
iox_signal_add(struct iox_loop *loop, int signo, iox_signal_cb cb,
               void *arg)
{
	struct iox_signal_entry *e;
	struct sigaction sa;

	(void)loop;

	if (sig_count >= IOX_MAX_SIGNALS)
		return -1;

	e = &sig_table[sig_count++];
	e->signo = signo;
	e->cb = cb;
	e->arg = arg;
	e->active = 1;

	sa.sa_handler = sig_handler;
	sa.sa_flags = SA_RESTART;
	sigemptyset(&sa.sa_mask);

	if (sigaction(signo, &sa, &e->old_sa) < 0) {
		sig_count--;
		return -1;
	}

	return 0;
}

void
iox_signal_remove(struct iox_loop *loop, int signo)
{
	int i;

	(void)loop;

	for (i = 0; i < sig_count; i++) {
		if (sig_table[i].active && sig_table[i].signo == signo) {
			sigaction(signo, &sig_table[i].old_sa, NULL);
			sig_table[i].active = 0;
			return;
		}
	}
}
