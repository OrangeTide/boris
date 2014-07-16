/* demovm.c - small demonstration virtual machine */
/* PUBLIC DOMAIN - July 16, 2014 - Jon Mayo */
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "stackdump.h"
#include "stackvm.h"

/* logging macros */
#define info(format, ...) fprintf(stderr, "INFO:" format, ## __VA_ARGS__)
#define warn(format, ...) fprintf(stderr, "WARN:" format, ## __VA_ARGS__)
#define error(format, ...) fprintf(stderr, "ERROR:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define debug(format, ...) fprintf(stderr, "DEBUG:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define trace(format, ...) fprintf(stderr, "TRACE:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)


/*** Main ***/

static const char *progname; /* basename of argv[0] */
static const char *opt_vm_filename;

static void usage(void)
{
	fprintf(stderr, "%s [-m maxheap] <file.vm>\n", progname);
	exit(EXIT_FAILURE);
}

static void process_args(int argc, char **argv)
{
	int i;

	if (!(progname = strrchr(argv[0], '/')))
		progname = argv[0];

	for (i = 1; i < argc; i++) {
		if (argv[i][0] == '-') { /* parse flags */
			const char *s;

			for (s = &argv[i][1]; *s; s++) {
				if (*s == 'h') {
					usage();
				} else {
					error("%s:bad flag '%c'\n", progname, *s);
					usage();
				}
			}
		} else if (!opt_vm_filename) { /* require exactly 1 filename */
			opt_vm_filename = argv[i];
		} else {
			usage();
		}
	}

	if (!opt_vm_filename)
		usage();
}

static void sys_trap_print(struct vm *vm)
{
	vmword_t s_addr = vm_arg(vm, 0);
	size_t slen;
	const char *s = vm_string(vm, s_addr, &slen);
	assert(s != NULL);
	printf("SysPrint:%.*s\n", (int)slen, s);
}

static void sys_trap_error(struct vm *vm)
{
	vmword_t s_addr = vm_arg(vm, 0);
	size_t slen;
	const char *s = vm_string(vm, s_addr, &slen);
	assert(s != NULL);
	printf("SysError:%.*s\n", (int)slen, s);
	vm_abort(vm);
}

int main(int argc, char **argv)
{
	enable_stack_dump();
	process_args(argc, argv);

	struct vm_env *env = vm_env_new(100);
	assert(env != NULL);
	vm_env_register(env, -1, sys_trap_print);
	vm_env_register(env, -2, sys_trap_error);

	struct vm *vm = vm_new(env);
	if (!vm_load(vm, opt_vm_filename)) {
		error("%s:could not load file\n", opt_vm_filename);
		return EXIT_FAILURE;
	}

	if (1)
		vm_disassemble(vm);

	vm_call(vm, 2, 500, 800); /* result should be 1800 (500+500+800) */
	// TODO: call in a loop
	vm_run_slice(vm);
	vmword_t result = 0xdeadbeef;

	if (vm_status(vm) == VM_STATUS_FINISHED)
		result = vm_opop(vm);

	if (vm_status(vm) != VM_STATUS_FINISHED) {
		info("%s:VM failure\n", vm_filename(vm));
		vm_free(vm);
		vm = NULL;
		return EXIT_FAILURE;
	}

	info("%s:VM success:result=%d\n", vm_filename(vm), result);
	vm_free(vm);
	vm = NULL;
	return EXIT_SUCCESS;
}
