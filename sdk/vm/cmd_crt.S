/* cmd_crt.S : command-verb runtime entry.
 *
 * A command verb is entered with the typed argument vector, not a C argv:
 * the host leaves a0 = the slot count and a1 = the slot array, and sets the
 * stack pointer. Those are already the first two C argument registers, so we
 * call cmd_args_init(a0, a1) to stash them for the cmd_arg_* accessors, then
 * call the verb's main and exit with its return value. Links in place of
 * crt0.S. See include/cmd.h. */

	.text
	.globl _start
_start:
	jal	ra, cmd_args_init       /* a0 = slot count, a1 = slot array */
	jal	ra, main
	/* main's return value is in a0; exit with it (sys_exit never returns). */
	jal	ra, sys_exit
1:	j	1b
