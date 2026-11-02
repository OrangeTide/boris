#include <stdlib.h>
#include <stdio.h>

/* Program termination.  __libc_fini runs the atexit handlers in reverse order
   and flushes the streams; the crt calls it when main returns, and exit()
   calls it before the raw _exit.  A guard makes it idempotent, so the two
   paths (or an atexit handler that itself calls exit) never double-run it.

   This object is force-linked into a hosted program (the driver and the libc
   test runner place it beside the crt), so the crt's weak reference to
   __libc_fini resolves here.  A freestanding link omits it, and the crt's
   weak reference then stays 0 and the call is skipped. */

extern void _exit(int code);            /* the raw exit syscall, from the crt */

#define MAX_ATEXIT 32

static void (*handlers[MAX_ATEXIT])(void);
static int nhandlers;
static int finished;

int
atexit(void (*fn)(void))
{
    if (nhandlers >= MAX_ATEXIT)
        return -1;
    handlers[nhandlers++] = fn;
    return 0;
}

void
__libc_fini(void)
{
    if (finished)
        return;
    finished = 1;
    while (nhandlers > 0)
        handlers[--nhandlers]();
    fflush(NULL);
}

void
exit(int code)
{
    __libc_fini();
    _exit(code);
    for (;;)                            /* _exit does not return */
        ;
}
