#include <errno.h>

/* The one global errno.  Zeroed at load; the library sets it where the standard
   or POSIX requires (strtol/strtoul on overflow, malloc on exhaustion), and a
   program reads it after a call that can fail. */
int errno = 0;
