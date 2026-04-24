/* daemonize.h : fork into background as a daemon */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

#ifndef DAEMONIZE_H
#define DAEMONIZE_H

/* fork, setsid, redirect stdio to /dev/null.
 * returns 0 in the child (daemon), -1 on error.
 * the parent process exits(0) on success. */
int daemonize(void);

#endif /* DAEMONIZE_H */
