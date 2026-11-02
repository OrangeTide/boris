#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

/* The crt supplies write (fd, buffer, length); assert reaches it directly,
   since the stream layer does not exist yet.  This is the only Phase A file
   that produces output, and it needs no host surface beyond the crt. */

void
__assert_fail(const char *expr, const char *file, int line, const char *func)
{
    char buf[256];
    int n = snprintf(buf, sizeof buf,
                     "%s:%d: %s: assertion failed: %s\n",
                     file, line, func, expr);
    if (n > (int)sizeof buf)
        n = (int)sizeof buf - 1;
    write(2, buf, n);
    abort();
}
