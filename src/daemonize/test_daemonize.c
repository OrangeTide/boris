/* test_daemonize.c : test for daemonize.c */
/* Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN */
#include <stdio.h>
#include <unistd.h>
#include <daemonize.h>

int
main(int argc, char *argv[])
{
	(void)argc;
	fprintf(stderr, "%s:Backgrounding... (process will exit with success or failure)\n", argv[0]);
	if (daemonize() != 0) {
		printf("%s: Failed\n", argv[0]);
		return 1;
	}
	sleep(2);
	return 0;
}
