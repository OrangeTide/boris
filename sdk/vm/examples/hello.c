/* hello.c : a one-shot VM guest program.
 *
 * Writes a line through the host and exits with argc, to show output and the
 * argument block both reach the program. Built with the vendored skjegg RV32
 * toolchain; run with the vm-run harness. */

#include "vmsys.h"

static int
slen(const char *s)
{
	int n = 0;
	while (s[n])
		n++;
	return n;
}

int
main(int argc, char **argv)
{
	const char *msg = "hello from the rv32 guest\n";

	(void)argv;
	sys_write(1, msg, slen(msg));
	return argc;
}
