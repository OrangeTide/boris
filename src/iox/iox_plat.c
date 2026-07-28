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

int
iox_plat_poll(struct pollfd *fds, unsigned long nfds, int timeout_ms)
{
    return poll(fds, (nfds_t)nfds, timeout_ms);
}

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
