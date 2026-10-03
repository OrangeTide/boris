/* crt0.S : VM guest runtime entry.
 *
 * The host loads the image, sets a0 = argc, a1 = argv, and the stack pointer,
 * then enters at _start. bss is already zero because the host zeroes the image
 * before loading, so there is nothing to clear. We call main with the argc and
 * argv the host left in a0/a1, then exit with its return value. */

	.text
	.globl _start
_start:
	jal	ra, main
	/* main's return value is in a0; exit with it (sys_exit never returns). */
	jal	ra, sys_exit
1:	j	1b
