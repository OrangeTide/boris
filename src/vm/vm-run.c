/* vm-run.c : load and run an RV32 guest ELF in the VM.
 *
 * A small harness for developing guest programs: it loads a pre-built ELF,
 * routes its output to stdout, hands it the remaining command-line arguments,
 * and runs it to completion with only the runtime builtins bound (no game host
 * calls). The process exit status is the guest's, or non-zero on a fault or a
 * load error. */

#include "vm.h"

#include <stdio.h>
#include <stdlib.h>

#define VM_RUN_QUANTUM 8192
#define VM_RUN_SLICES  200000   /* generous cap so a real program can finish */

static void
to_stdout(void *ctx, const char *buf, size_t len)
{
	(void)ctx;
	fwrite(buf, 1, len, stdout);
}

int
main(int argc, char **argv)
{
	struct vm_task *t;
	enum vm_state st;
	int slices = 0, status;

	if (argc < 2) {
		fprintf(stderr, "usage: %s program.elf [args...]\n", argv[0]);
		return 2;
	}

	t = vm_task_new(0);
	if (!t) {
		fprintf(stderr, "vm-run: out of memory\n");
		return 1;
	}
	vm_task_set_output(t, to_stdout, NULL);

	if (vm_task_load_file(t, argv[1]) != 0) {
		vm_task_free(t);
		return 1;
	}
	/* The program's own argv starts at the ELF path. */
	vm_task_set_args(t, (const char *const *)(argv + 1), argc - 1);

	do {
		st = vm_task_run(t, VM_RUN_QUANTUM);
	} while (st == VM_READY && ++slices < VM_RUN_SLICES);

	status = vm_task_exit_status(t);
	if (st == VM_FAULTED) {
		fprintf(stderr, "vm-run: %s faulted\n", argv[1]);
		vm_task_free(t);
		return 1;
	}
	if (st == VM_READY) {
		fprintf(stderr, "vm-run: %s did not finish within the run cap\n",
		        argv[1]);
		vm_task_free(t);
		return 1;
	}
	fprintf(stderr, "vm-run: exit %d\n", status);
	vm_task_free(t);
	return status;
}
