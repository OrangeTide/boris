/* iox_plat.c : internal platform shim (see iox_plat.h) */

#include "iox_plat.h"
#include "iox_loop.h"

#ifdef _WIN32

#include <windows.h>

int
iox_plat_net_init(void)
{
    static int done;
    WSADATA wsa;

    if (done)
        return IOX_OK;
    if (WSAStartup(MAKEWORD(2, 2), &wsa) != 0)
        return IOX_ERR;
    done = 1;
    return IOX_OK;
}

void
iox_plat_socket_close(int fd)
{
    if (fd >= 0)
        closesocket((SOCKET)fd);
}

int
iox_plat_socket_nonblock(int fd)
{
    u_long on = 1;

    return ioctlsocket((SOCKET)fd, FIONBIO, &on) == 0 ? IOX_OK : IOX_ERR;
}

int
iox_plat_poll(struct pollfd *fds, unsigned long nfds, int timeout_ms)
{
    return WSAPoll(fds, (ULONG)nfds, timeout_ms);
}

int
iox_plat_poll_interrupted(void)
{
    return 0;    /* WSAPoll has no EINTR equivalent */
}

uint64_t
iox_plat_mono_ns(void)
{
    static LARGE_INTEGER freq;
    LARGE_INTEGER now;

    if (freq.QuadPart == 0)
        QueryPerformanceFrequency(&freq);
    QueryPerformanceCounter(&now);
    /* Scale to nanoseconds without overflowing: split whole seconds
     * from the sub-second remainder. */
    return (uint64_t)(now.QuadPart / freq.QuadPart) * 1000000000ull +
        (uint64_t)(now.QuadPart % freq.QuadPart) * 1000000000ull /
        (uint64_t)freq.QuadPart;
}

#else /* POSIX */

#include <errno.h>
#include <fcntl.h>
#include <time.h>

#ifdef __APPLE__
#include <sys/select.h>
#endif

int
iox_plat_net_init(void)
{
    return IOX_OK;
}

void
iox_plat_socket_close(int fd)
{
    if (fd >= 0)
        close(fd);
}

int
iox_plat_socket_nonblock(int fd)
{
    int fl = fcntl(fd, F_GETFL, 0);

    if (fl < 0)
        return IOX_ERR;
    return fcntl(fd, F_SETFL, fl | O_NONBLOCK) < 0 ? IOX_ERR : IOX_OK;
}

#ifdef __APPLE__

/* macOS poll() does not report readiness on a pseudo-terminal master. A
 * process whose only ready descriptor is a pty master blocks forever: it
 * wakes only once unrelated traffic on another descriptor returns from
 * poll(), at which point the level-triggered pty read finally runs.
 * select() reports ptys correctly here, so translate the pollfd set into a
 * select() call on this platform.
 *
 * Only POLLIN and POLLOUT are honored. A hangup or error surfaces through
 * select()'s read/write sets: an ended or errored descriptor reads ready and
 * its read()/write() then fails visibly, matching how the caller already
 * treats POLLHUP/POLLERR. A descriptor closed behind the loop's back makes
 * select() fail with EBADF; that case is mapped to POLLNVAL per descriptor so
 * the loop drops it, as it would with poll(). */
int
iox_plat_poll(struct pollfd *fds, unsigned long nfds, int timeout_ms)
{
    fd_set rfds, wfds;
    struct timeval tv, *ptv;
    int maxfd = -1, ready, n;
    unsigned long i;

    FD_ZERO(&rfds);
    FD_ZERO(&wfds);

    for (i = 0; i < nfds; i++) {
        int fd = fds[i].fd;

        fds[i].revents = 0;
        if (fd < 0)
            continue;
        if (fd >= FD_SETSIZE) {
            errno = EINVAL;
            return -1;
        }
        if (fds[i].events & POLLIN)
            FD_SET(fd, &rfds);
        if (fds[i].events & POLLOUT)
            FD_SET(fd, &wfds);
        if (fd > maxfd)
            maxfd = fd;
    }

    if (timeout_ms < 0) {
        ptv = NULL;
    } else {
        tv.tv_sec = timeout_ms / 1000;
        tv.tv_usec = (timeout_ms % 1000) * 1000;
        ptv = &tv;
    }

    ready = select(maxfd + 1, &rfds, &wfds, NULL, ptv);
    if (ready < 0) {
        /* one or more descriptors were closed behind the loop's back;
         * flag each dead one like poll()'s POLLNVAL. */
        if (errno == EBADF) {
            n = 0;
            for (i = 0; i < nfds; i++) {
                int fd = fds[i].fd;

                if (fd < 0)
                    continue;
                if (fcntl(fd, F_GETFD) < 0 && errno == EBADF) {
                    fds[i].revents = POLLNVAL;
                    n++;
                }
            }
            if (n > 0)
                return n;
        }
        return -1;    /* EINTR or a real error; caller checks errno */
    }

    n = 0;
    for (i = 0; i < nfds; i++) {
        int fd = fds[i].fd;
        short re = 0;

        if (fd < 0 || fd >= FD_SETSIZE)
            continue;
        if (FD_ISSET(fd, &rfds))
            re |= POLLIN;
        if (FD_ISSET(fd, &wfds))
            re |= POLLOUT;
        fds[i].revents = re;
        if (re)
            n++;
    }
    return n;
}

#else

int
iox_plat_poll(struct pollfd *fds, unsigned long nfds, int timeout_ms)
{
    return poll(fds, (nfds_t)nfds, timeout_ms);
}

#endif

int
iox_plat_poll_interrupted(void)
{
    return errno == EINTR;
}

uint64_t
iox_plat_mono_ns(void)
{
    struct timespec ts;

    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000ull + (uint64_t)ts.tv_nsec;
}

#endif
