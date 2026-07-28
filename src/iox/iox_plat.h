/* iox_plat.h : internal platform shim -- sockets, poll, monotonic clock */

#ifndef IOX_PLAT_H
#define IOX_PLAT_H

#include <stdint.h>
#include <sys/types.h>      /* ssize_t (both platforms via mingw) */

#ifdef _WIN32
#  include <winsock2.h>     /* sockaddr_in, struct pollfd, WSAPoll, ... */
#  include <ws2tcpip.h>     /* socklen_t, sockaddr_in6, inet_pton, ... */
#else
#  include <sys/socket.h>
#  include <netinet/in.h>
#  include <arpa/inet.h>
#  include <poll.h>
#  include <unistd.h>
#endif

/* The descriptor type inside struct pollfd. Windows stores a SOCKET there,
 * an unsigned pointer-sized handle, while the libiox API speaks int. The
 * two round-trip safely because every fd libiox holds came in through the
 * API as an int, but the comparisons need the cast to stay warning-free. */
#ifdef _WIN32
typedef SOCKET iox_pollfd_t;
#else
typedef int iox_pollfd_t;
#endif

/** One-time transport init (WSAStartup on Windows, no-op elsewhere).
 *
 * Safe to call repeatedly. Returns 0 on success, -1 on failure.
 */
int iox_plat_net_init(void);

/** Close a socket (closesocket on Windows, close elsewhere). */
void iox_plat_socket_close(int fd);

/** Put a socket into non-blocking mode. Returns 0 on success, -1 on error. */
int iox_plat_socket_nonblock(int fd);

/** poll() wrapper: WSAPoll on Windows, poll elsewhere.
 *
 * struct pollfd and the POLL* flags come from the headers above; winsock2
 * defines both.
 */
int iox_plat_poll(struct pollfd *fds, unsigned long nfds, int timeout_ms);

/** Was the last iox_plat_poll() failure a benign interruption?
 *
 * Non-zero for EINTR on POSIX. Always zero on Windows, where WSAPoll has
 * no equivalent. Only meaningful straight after a failed poll.
 */
int iox_plat_poll_interrupted(void);

/** Monotonic clock in nanoseconds since an unspecified epoch.
 *
 * Backed by clock_gettime(CLOCK_MONOTONIC) on POSIX and
 * QueryPerformanceCounter on Windows.
 */
uint64_t iox_plat_mono_ns(void);

#endif /* IOX_PLAT_H */
