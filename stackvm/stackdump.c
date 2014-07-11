/* stackdump.c - library for printing stack traces on crash */
/* PUBLIC DOMAIN - Jon Mayo
 * original: June 11, 2014 */
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <execinfo.h>
#include <signal.h>
#include <unistd.h>
#include "stackdump.h"

static void do_dump(int sig)
{
	dprintf(STDERR_FILENO, "=== Signal %s : start of backtrace ===\n",
		strsignal(sig));
	void *buf[64];
	int count = backtrace(buf, 64);
	backtrace_symbols_fd(buf, count, STDERR_FILENO);
	dprintf(STDERR_FILENO, "=== end of backtrace ===\n");
	_exit(128 + sig);
}

void enable_stack_dump(void)
{
	signal(SIGSEGV, do_dump);
	signal(SIGABRT, do_dump);
	signal(SIGILL, do_dump);
	signal(SIGFPE, do_dump);
	signal(SIGBUS, do_dump);
}
