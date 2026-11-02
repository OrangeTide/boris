/* vm.h : RV32 task runtime and cooperative scheduler */

#ifndef VM_H
#define VM_H

#include <stddef.h>
#include <stdint.h>

#include "vm_sys.h"

/* Default per-task memory image size. */
#define VM_MEM_DEFAULT (128u * 1024u)

/* Host-call ABI. A guest reaches a host call with an ecall whose a7 holds
 * VM_HOSTCALL_BASE plus a fixed selector (see vm_sys.h), integer and pointer
 * arguments in a0-a5, and the result written back to a0. The selectors are
 * fixed, not bound per image: the runtime always serves the builtins
 * (VM_CALL_EXIT/WRITE/RANDOM/NOW/SUSPEND/GETMSG/READ), and the host registers
 * the game-specific calls into a vm_env at their selectors. A call to a
 * selector no one serves faults. */

/* A task's execution state. */
enum vm_state {
	VM_READY,       /* runnable; more instructions to execute */
	VM_EXITED,      /* called the exit host-call; exit status is set */
	VM_FAULTED,     /* took a fatal trap (bad access, illegal insn) */
};

/* Event kinds delivered to a task's mailbox. The host chooses the kind when it
 * posts; the guest reads it back from the marshalled record. VM_EV_NONE is not
 * posted: sys_getmsg reports it when the mailbox is empty. */
enum vm_event_kind {
	VM_EV_NONE  = 0,        /* mailbox empty (sys_getmsg result only) */
	VM_EV_ENTER = 1,        /* something entered the task's object */
	VM_EV_TIMER = 2,        /* the dwell timer fired */
	VM_EV_USER  = 3,        /* a user event carrying a string payload */
	VM_EV_WAKE  = 4,        /* a bare wake, no payload */
};

/* Sink for a task's output. Called with one line at a time while output is
 * flowing, and with any unterminated remainder when the task ends. The
 * runtime owns no player or socket; the host binds this to wherever guest
 * output should go. */
typedef void (*vm_output_fn)(void *ctx, const char *buf, size_t len);

struct vm_task;
struct vm_sched;
struct vm_env;

/* A host call. It reads its arguments and writes its result through the
 * accessors below, using the task handle it is given. ctx is the pointer
 * registered alongside the function. */
typedef void (*vm_hostcall_fn)(struct vm_task *t, void *ctx);

/****************************************************************
 * Tasks
 ****************************************************************/

/* Create a task with a zeroed memory image of mem_size bytes (0 selects
 * VM_MEM_DEFAULT). Returns NULL on allocation failure. */
struct vm_task *vm_task_new(uint32_t mem_size);

/* Free a task, flushing any buffered output first. */
void vm_task_free(struct vm_task *t);

/* Bind the output sink. */
void vm_task_set_output(struct vm_task *t, vm_output_fn fn, void *ctx);

/* Load a program image and ready the task to run from its entry point.
 * The _mem variant loads an in-memory ELF the caller owns (`what` names it
 * in diagnostics); the _file variant reads a pre-built ELF from disk.
 * Returns 0 on success, -1 on failure. */
int vm_task_load_mem(struct vm_task *t, const uint8_t *buf, long size,
                     const char *what);
int vm_task_load_file(struct vm_task *t, const char *path);

/* Grant the task a confined host directory, reached by the guest through the
 * fs/ mount `name:` (its fs-interpose libc resolves a `name:path` argument to
 * that directory). A read-only grant fails mutating ops with EROFS. Must be
 * called before vm_task_load_*; up to a small per-task limit. Returns 0, or -1
 * if the task is already loaded, the table is full, or the spec does not fit.
 * This is the seam @compile uses to give a toolchain stage its build dir. */
int vm_task_add_mount(struct vm_task *t, const char *name, const char *hostdir,
                      int readonly);

/* Raise the task's memory caps before load. A batch guest such as a compile
 * stage needs far more heap, stack, and committed memory than an interactive
 * verb. A zero argument keeps the default. Must be called before
 * vm_task_load_*. */
void vm_task_set_limits(struct vm_task *t, uint32_t mem_limit,
                        uint32_t heap_size, uint32_t stack_size);

/* Write a C-style argument block into the top of the guest stack, then set
 * a0 = argc and a1 = the guest address of the argv pointer array, and lower
 * the stack pointer below the block. Call after loading and before running.
 * The strings and the NULL-terminated pointer array follow the usual layout,
 * so a _start that reads a0/a1 sees main(argc, argv). Returns 0, or -1 if the
 * block would not fit the image. */
int vm_task_set_args(struct vm_task *t, const char *const *argv, int argc);

/* One typed argument for the verb entry ABI. `type` is an opaque tag the VM
 * does not interpret; the verb host layer and the guest runtime agree on its
 * meaning. When `str` is non-NULL it is copied into guest memory and the slot
 * carries its guest address; otherwise the slot carries `ival` verbatim (used
 * for an object handle). */
struct vm_typed_arg {
	uint32_t    type;
	uint32_t    ival;
	const char *str;
};

/* Write a typed argument vector into the top of the guest stack as an array of
 * {u32 type, u32 value} slots, set a0 = n and a1 = the guest address of the
 * array, and lower the stack pointer below it. The verb entry ABI, parallel to
 * vm_task_set_args but typed: a guest runtime reads the slots rather than a
 * C argv. Call after loading and before running. Returns 0, or -1 if n is out
 * of range or the block would not fit the image. */
int vm_task_set_typed_args(struct vm_task *t, const struct vm_typed_arg *args,
                           int n);

/* Run up to quantum instructions. Returns the task's state afterward: it
 * caps the work so a runaway task cannot stall the caller. A task already
 * exited or faulted returns its final state without running. */
enum vm_state vm_task_run(struct vm_task *t, int quantum);

enum vm_state vm_task_state(const struct vm_task *t);
int vm_task_exit_status(const struct vm_task *t);
uint32_t vm_task_id(const struct vm_task *t);

/****************************************************************
 * Mailbox
 *
 * Each task owns a bounded event queue. The host delivers events into it with
 * vm_task_post; the guest drains them one at a time with the sys_getmsg
 * builtin, and blocks for one with sys_suspend. Delivery is cooperative: an
 * event never interrupts the guest, it waits in the queue until the guest asks
 * for it. This is the VM-core half of the event model; the object-to-task and
 * task-id routing that decides which task an event reaches is the host's
 * (src/verb/), built on vm_task_post.
 ****************************************************************/

/* Deliver an event into a task's mailbox. sender is a task id or object handle
 * the guest reads back; str/len is an optional payload (NULL/0 for a bare
 * event), truncated to the per-event limit. Posting wakes a task blocked in
 * sys_suspend so it runs next tick. Returns 0, or -1 if the mailbox is full. */
int vm_task_post(struct vm_task *t, uint32_t kind, uint32_t sender,
                 const char *str, uint32_t len);

/* Feed bytes to a task's stdin (fd 0). If the task is parked in a blocking
 * read, the bytes complete that read (filling its buffer and setting its
 * result) and wake it; otherwise they wait in a bounded buffer for the next
 * read. Returns the count accepted, short only when the buffer is full. */
int vm_task_feed_stdin(struct vm_task *t, const void *data, uint32_t len);

/* Close a task's stdin: a blocking read parked on empty input, and every later
 * read, then returns 0 (end of file) rather than parking. */
void vm_task_close_stdin(struct vm_task *t);

/* Whether the task is parked waiting for input: a mailbox event (sys_suspend)
 * or a blocking read on fd 0. The scheduler does not run a blocked task until a
 * delivery (vm_task_post or vm_task_feed_stdin) wakes it, so it costs no cycles
 * while idle. */
int vm_task_blocked(const struct vm_task *t);

/* Number of events waiting in the task's mailbox. */
int vm_task_msgs(const struct vm_task *t);

/* Owning session and current authority. Set by the host at spawn; the
 * verb/agent and host-call cards read and enforce them. */
void vm_task_set_context(struct vm_task *t, uint32_t session, uint32_t authority);
uint32_t vm_task_session(const struct vm_task *t);
uint32_t vm_task_authority(const struct vm_task *t);

/* Opaque host pointer carried on the task. The runtime never dereferences it;
 * the game stores its per-task context here (the object a verb is attached to,
 * the acting player) for its registered host calls to read back. */
void vm_task_set_userdata(struct vm_task *t, void *ud);
void *vm_task_userdata(const struct vm_task *t);

/****************************************************************
 * Host-call argument access
 *
 * A host call reads its arguments and moves data through these. Arguments are
 * the integer/pointer registers a0-a5 (i in 0..5); the result is written to
 * a0. The read and write helpers copy between the guest image and host memory
 * bounds-checked against the task's RAM, returning the number of bytes moved
 * (short at the image edge). vm_arg_cstr copies a NUL-terminated guest string
 * into buf, always NUL-terminates, and returns the length copied.
 ****************************************************************/

uint32_t vm_arg(struct vm_task *t, int i);
void vm_set_ret(struct vm_task *t, uint32_t v);
uint32_t vm_read(struct vm_task *t, uint32_t gaddr, void *dst, uint32_t len);
uint32_t vm_write(struct vm_task *t, uint32_t gaddr, const void *src, uint32_t len);
uint32_t vm_arg_cstr(struct vm_task *t, uint32_t gaddr, char *buf, uint32_t bufsz);

/****************************************************************
 * Host-call environment
 *
 * The set of game-specific host calls, each bound to a fixed selector (see
 * vm_sys.h). The runtime always serves the builtins (sys_exit, sys_write,
 * sys_read, sys_random, sys_now, sys_suspend, sys_getmsg); everything
 * game-specific -- object access, broadcast, privilege -- is registered here
 * by the host, so this library stays free of the game's object store. A call
 * to a selector no one serves faults.
 ****************************************************************/

struct vm_env *vm_env_new(void);
void vm_env_free(struct vm_env *e);

/* Register a host call at selector `call` (a VM_CALL_* value). Returns 0, or
 * -1 if the selector is out of range or names a builtin the runtime serves. */
int vm_env_register(struct vm_env *e, int call,
                    vm_hostcall_fn fn, void *ctx);

/* Bind a task to an environment before loading its image. NULL leaves only
 * the builtins available. The env must outlive the task. */
void vm_task_set_env(struct vm_task *t, struct vm_env *e);

/* Stream backend for file descriptors the VM core does not own itself.
 *
 * The builtin sys_write and sys_read, and the freestanding write/read ecall
 * seam, handle the session streams directly: fd 1 and 2 write to the output
 * sink, fd 0 reads end-of-file. Any other descriptor is the host's: when an
 * env carries a stream backend, the VM routes a read or write on such an fd to
 * it, so files (the VFS fd table) share the one read/write call with the
 * streams, as the hosting design intends. Without a backend, a non-stream fd is
 * EBADF. The VM never interprets the fd or the bytes; it only forwards, so the
 * core stays independent of the game and its filesystem.
 *
 * fn moves len bytes between guest address gbuf and descriptor fd (is_write
 * selects the direction) and returns the count moved, or a negative
 * errno-style code the guest sees verbatim in a0. */
typedef long (*vm_stream_fn)(struct vm_task *t, void *ctx, int fd,
                             uint32_t gbuf, uint32_t len, int is_write);
void vm_env_set_stream(struct vm_env *e, vm_stream_fn fn, void *ctx);

/****************************************************************
 * Cooperative scheduler
 *
 * A single run queue stepped on the host event loop. Each tick steps every
 * ready task by one quantum and reaps the ones that finished. This is not
 * the multicore, credit-charged scheduler of the ColdFire design; that is
 * the multithreading track.
 ****************************************************************/

struct vm_sched *vm_sched_new(void);

/* Free the scheduler and any tasks still on its queue. */
void vm_sched_free(struct vm_sched *s);

/* Hand a task to the scheduler, which owns it from then on. */
void vm_sched_add(struct vm_sched *s, struct vm_task *t);

/* Step every ready task by quantum instructions, then reap and free the
 * tasks that exited or faulted. Returns the number of tasks still live. */
int vm_sched_tick(struct vm_sched *s, int quantum);

int vm_sched_count(const struct vm_sched *s);

#endif /* VM_H */
