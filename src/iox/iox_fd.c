/* iox_fd.c : I/O multiplexer -- file descriptor watchers */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */

/* iox_fd_add(), iox_fd_mod(), and iox_fd_remove() are implemented in
 * iox_loop.c because they operate directly on the loop's pollfd array. */
