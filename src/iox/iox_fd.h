/* iox_fd.h : I/O multiplexer -- file descriptor watchers */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#ifndef IOX_FD_H
#define IOX_FD_H

#define IOX_READ  (1u << 0)
#define IOX_WRITE (1u << 1)

struct iox_loop;

/** Callback receives the event flags that fired (IOX_READ, IOX_WRITE). */
typedef void (*iox_fd_cb)(struct iox_loop *loop, int fd,
                          unsigned events, void *arg);

int iox_fd_add(struct iox_loop *loop, int fd, unsigned events,
               iox_fd_cb cb, void *arg);

/** Change watched events for an existing fd. */
int iox_fd_mod(struct iox_loop *loop, int fd, unsigned events);

/** Safe to call from within a dispatch callback. */
void iox_fd_remove(struct iox_loop *loop, int fd);

#endif /* IOX_FD_H */
