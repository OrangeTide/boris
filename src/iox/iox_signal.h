/* iox_signal.h : I/O multiplexer -- signal handling via self-pipe */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#ifndef IOX_SIGNAL_H
#define IOX_SIGNAL_H

struct iox_loop;

typedef void (*iox_signal_cb)(struct iox_loop *loop, int signo, void *arg);

int iox_signal_add(struct iox_loop *loop, int signo, iox_signal_cb cb,
                   void *arg);
void iox_signal_remove(struct iox_loop *loop, int signo);

/* internal -- called by iox_loop */
void iox_signal_init(struct iox_loop *loop);
void iox_signal_shutdown(struct iox_loop *loop);

#endif /* IOX_SIGNAL_H */
