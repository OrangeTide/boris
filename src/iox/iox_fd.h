/* iox_fd.h : I/O multiplexer -- file descriptor watchers */

#ifndef IOX_FD_H
#define IOX_FD_H

#define IOX_READ   (1u << 0)
#define IOX_WRITE  (1u << 1)

/* An exceptional condition on the descriptor: poll's POLLERR. On a socket
 * that means a pending error, or something waiting on the error queue,
 * which is how Linux reports MSG_ZEROCOPY send completions.
 *
 * Delivery only. poll cannot be asked for POLLERR and reports it whether
 * or not it was requested. Passing IOX_EXCEPT to iox_fd_add or iox_fd_mod
 * is accepted and documents the intent, but changes nothing. Register
 * IOX_READ anyway: macOS implements poll on top of kqueue and registers
 * no filter for a watcher with events 0, so such a watcher never fires
 * there at all.
 *
 * IOX_READ is set alongside it, so a caller written before this flag
 * existed still sees POLLERR as readable and still fails visibly on the
 * next read. Test for IOX_EXCEPT only if the difference matters to you.
 *
 * Linux and Windows deliver it. WSAPoll reports POLLERR, though with no
 * error queue there it only ever means a pending socket error. macOS
 * does not: its poll maps kqueue's EV_EOF to POLLHUP and sets POLLERR
 * only when registering the event failed, so a pending error arrives as
 * POLLHUP and reaches the callback as plain IOX_READ. */
#define IOX_EXCEPT (1u << 2)

struct iox_loop;

/** Callback receives the event flags that fired (IOX_READ, IOX_WRITE,
 *  IOX_EXCEPT). */
typedef void (*iox_fd_cb)(struct iox_loop *loop, int fd,
                          unsigned events, void *arg);

int iox_fd_add(struct iox_loop *loop, int fd, unsigned events,
               iox_fd_cb cb, void *arg);

/** Change watched events for an existing fd. */
int iox_fd_mod(struct iox_loop *loop, int fd, unsigned events);

/** Safe to call from within a dispatch callback. */
void iox_fd_remove(struct iox_loop *loop, int fd);

#endif /* IOX_FD_H */
