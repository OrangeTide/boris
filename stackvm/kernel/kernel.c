/* kernel.c - virtual machine kernel */
/* PUBLIC DOMAIN - July 16, 2014 - Jon Mayo */
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>
#include <unistd.h>

#include "stackvm.h"
#include "task.h"
#include "prioq.h"

//////////////////////////////////////////////////////////////////////////////

/* logging macros */
#define info(format, ...) fprintf(stderr, "INFO:" format, ## __VA_ARGS__)
#define warn(format, ...) fprintf(stderr, "WARN:" format, ## __VA_ARGS__)
#define error(format, ...) fprintf(stderr, "ERROR:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define debug(format, ...) fprintf(stderr, "DEBUG:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define trace(format, ...) fprintf(stderr, "TRACE:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)

//////////////////////////////////////////////////////////////////////////////
extern int stackvm_verbose; // HACK

static int opt_vm_disasm;

static struct task_channel *ready, *sleeping;
static int kernel_task_count;
static struct prioq *timerq;

//////////////////////////////////////////////////////////////////////////////

#include <math.h>

static double
timer_now(void)
{
	struct timespec ts;
	if (clock_gettime(CLOCK_MONOTONIC, &ts))
		return FP_NAN;
	return (double)ts.tv_sec + ((double)ts.tv_nsec / 1e9);
}

//////////////////////////////////////////////////////////////////////////////

static void
sys_puts(struct vm *vm)
{
	vmword_t s_addr = vm_arg(vm, 0);
	size_t slen;
	const char *s = vm_string(vm, s_addr, &slen);
	assert(s != NULL);
	printf("%.*s\n", (int)slen, s);
	vm_push(vm, 0); // TODO: is this correct for the ABI?
}

static void
sys_error(struct vm *vm)
{
	vmword_t code = vm_arg(vm, 0);
	vmword_t s_addr = vm_arg(vm, 1);
	size_t slen;
	const char *reason = vm_string(vm, s_addr, &slen);
	printf("***** Error #%u:%.*s\n", code, (int)slen,
		reason ? reason : "<no reason provided>");
	vm_abort(vm);
	vm_push(vm, 0); // TODO: is this correct for the ABI?
}

/* void syslog(int priority, const char *format, ...); */
static void
sys_syslog(struct vm *vm)
{
	printf("***** Not implemented\n");
	vm_abort(vm);
	vm_push(vm, 0); // TODO: is this correct for the ABI?
}

/* void openlog(const char *ident, int option, int facility); */
static void
sys_openlog(struct vm *vm)
{
	printf("***** Not implemented\n");
	vm_abort(vm);
	vm_push(vm, 0); // TODO: is this correct for the ABI?
}

/* void mdelay(int msec); */
static void
sys_mdelay(struct vm *vm)
{
	vmword_t msec = vm_arg(vm, 0);
	vm_push(vm, 0); // TODO: is this correct for the ABI?

	struct task *task = vm_get_extra(vm);
	unsigned long deadline = (timer_now() + msec / 1e6) * 1e6;
	struct prioq_elm elm = { deadline, task };
	prioq_enqueue(timerq, &elm);

	task_schedule(task, sleeping);
	info("%s:VM sleeping (%lu microseconds)\n", vm_filename(vm), (unsigned long)msec);

	// BUG: if next line below is done, VM's don't run to completion in run_all() loop
	// vm_yield(vm);
}

struct vm_env *
create_environment(void)
{
	struct vm_env *env = vm_env_new(100);
	if (!env)
		return NULL;
	vm_env_register(env, -1, sys_puts);
	vm_env_register(env, -2, sys_error);
	vm_env_register(env, -3, sys_syslog);
	vm_env_register(env, -4, sys_openlog);
	vm_env_register(env, -5, sys_mdelay);

	return env;
}

//////////////////////////////////////////////////////////////////////////////

static void
start_vm(struct vm *vm)
{
	int arg_count = 1;
	int arg_ptr = 0; // TODO: allocate and copy arguments
	vm_call(vm, 0, 2, arg_count, arg_ptr);
	// TODO: vm_status(vm);
}

/* create and start a VM.
 * int main(int argc, char *argv[]);
 */
static int
add_vm(struct vm_env *env, const char *vm_filename)
{
	struct vm *vm = vm_new(env);
	if (!vm_load(vm, vm_filename)) {
		error("%s:could not load file\n", vm_filename);
		return -1;
	}

	if (opt_vm_disasm)
		vm_disassemble(vm);

	struct task *task = task_new(vm_filename, vm, NULL, NULL);

	vm_set_extra(vm, task);

	start_vm(vm);

	task_schedule(task, ready);

	kernel_task_count++;

	return 0;
}

static int
done(struct task *task)
{
	struct vm *vm = task_extra(task);

	if (vm_status(vm) == VM_STATUS_FINISHED) {
		vmword_t result = vm_pop(vm);
		info("%s:VM success (result=%u)\n",
			vm_filename(vm), (int) result);
	}

	if (vm_status(vm) != VM_STATUS_FINISHED) {
		info("%s:VM failure (err=%#x)\n",
			vm_filename(vm), vm_status(vm));
	}

	vm_free(vm);

	task_free(task);

	kernel_task_count--;

	return 0;
}

static int
wait_for_next(void)
{
	struct prioq_elm elm;
	if (!prioq_dequeue(timerq, &elm))
		return -1;
	// TODO: loop through all prioq entries that have timed out

	unsigned long now = timer_now() * 1e6;

	/* not expired yet ... sleeping */
	if (now > elm.d) {
		struct timespec waittime = {
			.tv_sec = (now - elm.d) / 1000,
			.tv_nsec = ((now - elm.d) % 1000) * 1000,
		};
		nanosleep(&waittime, NULL);
		// TODO: fix issue of waking up due to signal, etc ...
	}

	struct task *task = elm.p;
	task_schedule(task, ready);

	struct vm *vm = task_extra(task);
	info("%s:VM waking from sleep\n", vm_filename(vm));

	return 0;
}

static int
run_all(void)
{
	do {
		struct task *task = task_channel_next(ready);
		if (!task) {
			// This design is bad - running tasks will starve out ready tasks
			info("no tasks ready ... sleeping\n");
			if (wait_for_next())
				break;
			continue;
		}

		struct vm *vm = task_extra(task);
		int e = vm_run_slice(vm);
		if (e == 1) { // finished
			done(task);
		} else if (e == 0) { // not finished
			/* add it to the ready list if not on any list */
			if (task_empty(task)) {
				task_schedule(task, ready);
				info("%s:VM scheduling (READY)\n", vm_filename(vm));
			}
		} else { // error / unknown
			error("%s:VM run slice error (%d)\n", vm_filename(vm), e);
			done(task);
		}
	} while (kernel_task_count);

	return 0;
}

/*** Main ***/

static
void usage(void)
{
	fprintf(stderr, "%s [-h] [-v] [-s] <file.vm>\n", program_invocation_short_name);
	exit(EXIT_FAILURE);
}

static void
process_args(int argc, char **argv)
{
	int opt;
	while ((opt = getopt(argc, argv, "hvs")) != -1) {
		switch (opt) {
		case 'h':
			usage();
		case 'v':
			stackvm_verbose++;
			break;
		case 's':
			opt_vm_disasm = 1;
			break;
		}
	}
}

int
main(int argc, char **argv)
{
	process_args(argc, argv);

	ready = task_channel_new("READY");
	sleeping = task_channel_new("SLEEPING");
	timerq = prioq_new(250);

	struct vm_env *env = create_environment();
	if (!env) {
		error("%s:could not create environment\n", program_invocation_short_name);
		return EXIT_FAILURE;
	}

	/* load all */
	while (optind < argc) {
		const char *fn = argv[optind++];
		if (add_vm(env, fn)) {
			return EXIT_FAILURE;
		}
	}

	run_all();

	return EXIT_SUCCESS;
}
