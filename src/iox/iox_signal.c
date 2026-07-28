/* iox_signal.c : I/O multiplexer -- signal handling */

#include "iox_signal.h"
#include "iox_fd.h"
#include "iox_internal.h"

#include <stdlib.h>

#define IOX_MAX_SIGNALS 8

/* Signal callbacks and the wakeup channel are per-loop, but the signal
 * disposition is a property of the process. Two layers, then: each loop
 * owns a struct iox_signals, and a process-wide table refcounts the
 * dispositions so the last loop to drop a signal is the one that restores
 * the previous handler. The handler itself wakes every loop; each loop
 * dispatches only the signals in its own table. */

struct iox_signal_entry {
    iox_signal_cb cb;
    void *arg;
    int signo;
    int active;
};

#ifndef _WIN32
/****************************************************************
 * POSIX: signal delivery via a self-pipe
 ****************************************************************/

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>

struct iox_signals {
    int pipe[2];
    struct iox_signal_entry table[IOX_MAX_SIGNALS];
    int count;
    struct iox_loop *loop;
    struct iox_signals *next;
};

static struct iox_signals *sig_list;

struct sig_disposition {
    struct sigaction old_sa;
    int signo;
    int refs;
};

static struct sig_disposition sig_disposition[IOX_MAX_SIGNALS];
static int sig_disposition_count;

static void
sig_handler(int signo)
{
    unsigned char s = (unsigned char)signo;
    int saved_errno = errno;
    struct iox_signals *signals;

    /* best-effort write; if a pipe is full, that loop already has the
     * signal pending */
    for (signals = sig_list; signals; signals = signals->next) {
        ssize_t r = write(signals->pipe[1], &s, 1);

        (void)r;
    }

    errno = saved_errno;
}

/* The handler walks sig_list, so block delivery while the list is being
 * relinked. */
static void
sig_block_all(sigset_t *old)
{
    sigset_t all;

    sigfillset(&all);
    sigprocmask(SIG_SETMASK, &all, old);
}

static void
sig_unblock(const sigset_t *old)
{
    sigprocmask(SIG_SETMASK, old, NULL);
}

static struct sig_disposition *
disposition_find(int signo)
{
    int i;

    for (i = 0; i < sig_disposition_count; i++) {
        if (sig_disposition[i].signo == signo)
            return &sig_disposition[i];
    }
    return NULL;
}

/* Install the shared handler for signo, or bump its refcount. */
static int
disposition_ref(int signo)
{
    struct sig_disposition *d = disposition_find(signo);
    struct sigaction sa;

    if (d) {
        d->refs++;
        return IOX_OK;
    }

    if (sig_disposition_count >= IOX_MAX_SIGNALS)
        return IOX_ERR;

    d = &sig_disposition[sig_disposition_count];

    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = sig_handler;
    sa.sa_flags = SA_RESTART;
    sigemptyset(&sa.sa_mask);

    if (sigaction(signo, &sa, &d->old_sa) < 0)
        return IOX_ERR;

    d->signo = signo;
    d->refs = 1;
    sig_disposition_count++;
    return IOX_OK;
}

/* Drop a reference; the last one out restores the previous handler. */
static void
disposition_unref(int signo)
{
    struct sig_disposition *d = disposition_find(signo);

    if (!d)
        return;
    if (--d->refs > 0)
        return;

    sigaction(signo, &d->old_sa, NULL);
    *d = sig_disposition[--sig_disposition_count];
}

static void
sig_pipe_cb(struct iox_loop *loop, int fd, unsigned events, void *arg)
{
    struct iox_signals *signals = arg;
    unsigned char buf[32];
    ssize_t n;
    int i;

    (void)events;

    n = read(fd, buf, sizeof(buf));
    if (n <= 0)
        return;

    while (n-- > 0) {
        int signo = buf[n];

        for (i = 0; i < signals->count; i++) {
            if (signals->table[i].active &&
                signals->table[i].signo == signo &&
                signals->table[i].cb) {
                signals->table[i].cb(loop, signo,
                    signals->table[i].arg);
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

int
iox_signal_init(struct iox_loop *loop)
{
    struct iox_signals *signals;
    sigset_t old;

    if (loop->signals)
        return IOX_OK;

    signals = calloc(1, sizeof(*signals));
    if (!signals)
        return IOX_ERR;

    if (pipe(signals->pipe) < 0) {
        free(signals);
        return IOX_ERR;
    }

    set_nonblock(signals->pipe[0]);
    set_nonblock(signals->pipe[1]);
    set_cloexec(signals->pipe[0]);
    set_cloexec(signals->pipe[1]);

    signals->loop = loop;

    if (iox_fd_add(loop, signals->pipe[0], IOX_READ, sig_pipe_cb, signals) != 0) {
        close(signals->pipe[0]);
        close(signals->pipe[1]);
        free(signals);
        return IOX_ERR;
    }

    sig_block_all(&old);
    signals->next = sig_list;
    sig_list = signals;
    sig_unblock(&old);

    loop->signals = signals;
    return IOX_OK;
}

void
iox_signal_shutdown(struct iox_loop *loop)
{
    struct iox_signals *signals = loop->signals;
    struct iox_signals **pp;
    sigset_t old;
    int i;

    if (!signals)
        return;

    /* Drop this loop's dispositions before unlinking, so a signal only
     * this loop wanted cannot fire into a half-removed list. */
    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active) {
            disposition_unref(signals->table[i].signo);
            signals->table[i].active = 0;
        }
    }
    signals->count = 0;

    sig_block_all(&old);
    for (pp = &sig_list; *pp; pp = &(*pp)->next) {
        if (*pp == signals) {
            *pp = signals->next;
            break;
        }
    }
    sig_unblock(&old);

    iox_fd_remove(loop, signals->pipe[0]);
    close(signals->pipe[0]);
    close(signals->pipe[1]);
    free(signals);
    loop->signals = NULL;
}

int
iox_signal_add(struct iox_loop *loop, int signo, iox_signal_cb cb,
               void *arg)
{
    struct iox_signals *signals = loop->signals;
    struct iox_signal_entry *e;
    int i;

    if (!signals)
        return IOX_ERR;

    /* re-registering the same signal on the same loop replaces it */
    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active && signals->table[i].signo == signo) {
            signals->table[i].cb = cb;
            signals->table[i].arg = arg;
            return IOX_OK;
        }
    }

    if (signals->count >= IOX_MAX_SIGNALS)
        return IOX_ERR;
    if (disposition_ref(signo) != 0)
        return IOX_ERR;

    e = &signals->table[signals->count++];
    e->signo = signo;
    e->cb = cb;
    e->arg = arg;
    e->active = 1;
    return IOX_OK;
}

void
iox_signal_remove(struct iox_loop *loop, int signo)
{
    struct iox_signals *signals = loop->signals;
    int i;

    if (!signals)
        return;

    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active && signals->table[i].signo == signo) {
            disposition_unref(signo);
            signals->table[i] = signals->table[--signals->count];
            return;
        }
    }
}

#else /* _WIN32 */
/****************************************************************
 * Windows: signal delivery via a loopback self-socket
 *
 * There is no self-pipe (anonymous pipes are not pollable by WSAPoll), and
 * the CRT signal handler for SIGINT runs on a separate thread. So the loop
 * watches a bound UDP loopback socket, and the handler pokes it with a
 * one-byte datagram to wake WSAPoll and carry the signal number.
 ****************************************************************/

#include "iox_plat.h"
#include <signal.h>
#include <string.h>

struct iox_signals {
    SOCKET sock;
    struct sockaddr_in addr;    /* sock's own bound address */
    struct iox_signal_entry table[IOX_MAX_SIGNALS];
    int count;
    struct iox_loop *loop;
    struct iox_signals *next;
};

static struct iox_signals *sig_list;

struct sig_disposition {
    void (*old_handler)(int);
    int signo;
    int refs;
};

static struct sig_disposition sig_disposition[IOX_MAX_SIGNALS];
static int sig_disposition_count;

static void
sig_handler(int signo)
{
    unsigned char s = (unsigned char)signo;
    struct iox_signals *signals;

    for (signals = sig_list; signals; signals = signals->next) {
        if (signals->sock != INVALID_SOCKET) {
            sendto(signals->sock, (const char *)&s, 1, 0,
                (struct sockaddr *)&signals->addr, sizeof(signals->addr));
        }
    }

    /* CRT resets the disposition to SIG_DFL on delivery; re-arm. */
    signal(signo, sig_handler);
}

static struct sig_disposition *
disposition_find(int signo)
{
    int i;

    for (i = 0; i < sig_disposition_count; i++) {
        if (sig_disposition[i].signo == signo)
            return &sig_disposition[i];
    }
    return NULL;
}

static int
disposition_ref(int signo)
{
    struct sig_disposition *d = disposition_find(signo);
    void (*prev)(int);

    if (d) {
        d->refs++;
        return IOX_OK;
    }

    if (sig_disposition_count >= IOX_MAX_SIGNALS)
        return IOX_ERR;

    d = &sig_disposition[sig_disposition_count];

    prev = signal(signo, sig_handler);
    if (prev == SIG_ERR)
        return IOX_ERR;

    d->old_handler = prev;
    d->signo = signo;
    d->refs = 1;
    sig_disposition_count++;
    return IOX_OK;
}

static void
disposition_unref(int signo)
{
    struct sig_disposition *d = disposition_find(signo);

    if (!d)
        return;
    if (--d->refs > 0)
        return;

    signal(signo, d->old_handler);
    *d = sig_disposition[--sig_disposition_count];
}

static void
sig_sock_cb(struct iox_loop *loop, int fd, unsigned events, void *arg)
{
    struct iox_signals *signals = arg;
    unsigned char buf[32];
    int n, k, i;

    (void)events;

    n = recvfrom((SOCKET)fd, (char *)buf, sizeof(buf), 0, NULL, NULL);
    if (n <= 0)
        return;

    for (k = 0; k < n; k++) {
        int signo = buf[k];

        for (i = 0; i < signals->count; i++) {
            if (signals->table[i].active &&
                signals->table[i].signo == signo &&
                signals->table[i].cb) {
                signals->table[i].cb(loop, signo,
                    signals->table[i].arg);
            }
        }
    }
}

int
iox_signal_init(struct iox_loop *loop)
{
    struct iox_signals *signals;
    socklen_t sl;

    if (loop->signals)
        return IOX_OK;
    if (iox_plat_net_init() != 0)
        return IOX_ERR;

    signals = calloc(1, sizeof(*signals));
    if (!signals)
        return IOX_ERR;

    signals->sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (signals->sock == INVALID_SOCKET) {
        free(signals);
        return IOX_ERR;
    }

    memset(&signals->addr, 0, sizeof(signals->addr));
    signals->addr.sin_family = AF_INET;
    signals->addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    signals->addr.sin_port = 0;

    sl = sizeof(signals->addr);
    if (bind(signals->sock, (struct sockaddr *)&signals->addr,
        sizeof(signals->addr)) != 0 ||
        getsockname(signals->sock, (struct sockaddr *)&signals->addr, &sl) != 0) {
        closesocket(signals->sock);
        free(signals);
        return IOX_ERR;
    }

    iox_plat_socket_nonblock((int)signals->sock);
    signals->loop = loop;

    if (iox_fd_add(loop, (int)signals->sock, IOX_READ, sig_sock_cb, signals) != 0) {
        closesocket(signals->sock);
        free(signals);
        return IOX_ERR;
    }

    signals->next = sig_list;
    sig_list = signals;

    loop->signals = signals;
    return IOX_OK;
}

void
iox_signal_shutdown(struct iox_loop *loop)
{
    struct iox_signals *signals = loop->signals;
    struct iox_signals **pp;
    int i;

    if (!signals)
        return;

    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active) {
            disposition_unref(signals->table[i].signo);
            signals->table[i].active = 0;
        }
    }
    signals->count = 0;

    for (pp = &sig_list; *pp; pp = &(*pp)->next) {
        if (*pp == signals) {
            *pp = signals->next;
            break;
        }
    }

    iox_fd_remove(loop, (int)signals->sock);
    closesocket(signals->sock);
    free(signals);
    loop->signals = NULL;
}

int
iox_signal_add(struct iox_loop *loop, int signo, iox_signal_cb cb,
               void *arg)
{
    struct iox_signals *signals = loop->signals;
    struct iox_signal_entry *e;
    int i;

    if (!signals)
        return IOX_ERR;

    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active && signals->table[i].signo == signo) {
            signals->table[i].cb = cb;
            signals->table[i].arg = arg;
            return IOX_OK;
        }
    }

    if (signals->count >= IOX_MAX_SIGNALS)
        return IOX_ERR;
    if (disposition_ref(signo) != 0)
        return IOX_ERR;

    e = &signals->table[signals->count++];
    e->signo = signo;
    e->cb = cb;
    e->arg = arg;
    e->active = 1;
    return IOX_OK;
}

void
iox_signal_remove(struct iox_loop *loop, int signo)
{
    struct iox_signals *signals = loop->signals;
    int i;

    if (!signals)
        return;

    for (i = 0; i < signals->count; i++) {
        if (signals->table[i].active && signals->table[i].signo == signo) {
            disposition_unref(signo);
            signals->table[i] = signals->table[--signals->count];
            return;
        }
    }
}

#endif /* _WIN32 */
