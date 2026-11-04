/* vm.c : boris guest runtime over skjegg's embeddable process scheduler.
 *
 * Each vm_task owns one skjegg scheduler (emu/sched.c) holding a root process
 * (and any children it spawns). The adapter drives the scheduler a round at a
 * time from boris's event loop through sched_step, rather than skjegg's own
 * blocking sched_run, so the single-threaded server never blocks on a guest.
 * skjegg owns the proc model, the ELF load, the initial stack, the mounts and
 * the Linux syscall service (emu/guest.c); boris owns the cooperative wake
 * decisions, the line-buffered console, the event mailbox, and its host-call
 * selector band. A boris-authored skj_cpu_ops installs an ecall handler that
 * serves the band and intercepts the console descriptors before falling through
 * to skjegg's private selectors and guest_syscall. */

#include "vm.h"

#include <guest.h>
#include <rv32.h>
#include <sched.h>
#include <elf32.h>

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* Linux rv32 syscall numbers boris intercepts for the console descriptors
 * (0/1/2) before they reach guest_syscall: fd 1 and 2 are the line-buffered
 * output sink, fd 0 is the cooperative blocking stdin. Every other syscall,
 * and every descriptor >= 3, goes to skjegg's guest_syscall (files via fs/,
 * the program break, exit, the clock, the RNG, nanosleep, yield). */
#define VM_NR_READ        63u
#define VM_NR_WRITE       64u
#define VM_NR_WRITEV      66u

/* Largest iovec a single writev may gather, a sandbox-sane cap. */
#define VM_IOV_MAX     16

#define VM_OUT_BUF     512
#define VM_MAX_ARGS    16       /* argv entries a one-shot program may get */
#define VM_MAILBOX_MAX 16       /* events a task may queue before back-pressure */
#define VM_MSG_MAX     256      /* payload bytes kept per event */
#define VM_STDIN_BUF   512      /* bytes of unread stdin a task may hold */
#define VM_MAX_MOUNTS  8        /* host-directory grants a task may be given */
#define VM_MOUNT_SPEC_MAX 384   /* backing size of one "name:hostdir" spec */

/* The per-task guest sizes handed to the scheduler. A guest commits pages
 * lazily; mem_limit caps the committed total (image, heap, stack, page tables,
 * mmap growth), so it must hold more than heap+stack. The image margin covers
 * the loaded segments including bss: a Kobold guest's shared crt reserves a
 * 2 MiB execution stack in bss (for kpcom's deep self-compile), so its image
 * memsz nears 2.5 MiB. The margin holds that with headroom; because pages
 * commit lazily, a small guest that never touches the reserve costs nothing. */
#define VM_HEAP_SIZE   (256u * 1024u)
#define VM_STACK_SIZE  (64u * 1024u)
#define VM_IMAGE_MARGIN (8u * 1024u * 1024u)
#define VM_MEM_LIMIT   (VM_IMAGE_MARGIN + VM_HEAP_SIZE + VM_STACK_SIZE)

/* Instructions per scheduler round; one slice per runnable process. */
#define VM_ROUND_INSNS SKJ_QUANTUM

/* sys_suspend modes, selected by a0. */
#define VM_SUSPEND_YIELD 0      /* run again next tick */
#define VM_SUSPEND_EVENT 1      /* park until a mailbox event arrives */
#define VM_SUSPEND_SLEEP 2      /* park until a1 ms pass, then get a timer event */

struct vm_task {
	/* The task's own scheduler and its root process. One sched per task keeps
	 * each guest tree independent (its own stdio and argv), the shape skjegg's
	 * sched_add_root is built for. The sched is embedded, so its address
	 * recovers the owning task inside the shared ecall handler. */
	sched         S;
	run_opts      opts;             /* S->o points here; must outlive the sched */
	proc         *root;             /* S.procs[root slot], the console guest */
	proc         *cur;              /* the process a host call is serving now */
	char          path[256];        /* image path, or a label for an in-memory root */

	uint32_t      id;
	enum vm_state state;
	int           exit_status;
	int           loaded;

	/* Cooperative output, buffered host-side and flushed a line at a time. */
	char          out[VM_OUT_BUF];
	size_t        out_len;
	vm_output_fn  out_fn;
	void         *out_ctx;

	/* Host-side context. */
	uint32_t      session;
	uint32_t      authority;
	void         *userdata;

	/* Bounded mailbox, a ring of pending events. blocked is set when the guest
	 * parked in sys_suspend (or a stdin read) on empty input; the adapter
	 * leaves the task idle until a delivery wakes it. */
	struct vm_msg {
		uint32_t kind;
		uint32_t sender;
		uint32_t len;
		char     data[VM_MSG_MAX];
	}             mbox[VM_MAILBOX_MAX];
	int           mbox_head;
	int           mbox_count;
	int           blocked;
	int           sleeping;
	uint64_t      wake_at_ms;

	/* Blocking stdin: bytes fed by the host wait in stdin_buf until a read on
	 * fd 0 consumes them; an empty read parks the task and records the pending
	 * read so vm_task_feed_stdin can complete it. */
	char          stdin_buf[VM_STDIN_BUF];
	uint32_t      stdin_head;
	uint32_t      stdin_len;
	int           stdin_eof;
	int           rd_waiting;
	uint32_t      rd_buf;
	uint32_t      rd_len;

	struct vm_env *env;
	uint32_t      rng;

	/* Host-directory grants installed before load. The run_opts mount arrays
	 * hold pointers, so the "name:hostdir" specs live here to outlive the
	 * sched; vm_task_add_mount fills a slot and points an opts entry at it. */
	char          mount_spec[VM_MAX_MOUNTS][VM_MOUNT_SPEC_MAX];
	int           n_mount_spec;

	struct vm_task *next;           /* run-queue link */
};

struct vm_env {
	struct {
		vm_hostcall_fn fn;
		void          *ctx;
	} sel[VM_CALL_COUNT];
	vm_stream_fn stream_fn;
	void        *stream_ctx;
};

/* Recover the owning task from an embedded scheduler. The ecall handler is
 * given the calling proc; its scheduler is this task's. */
#define TASK_OF(p) ((struct vm_task *)((char *)(p)->sched - offsetof(struct vm_task, S)))

/****************************************************************
 * Guest memory access
 ****************************************************************/

/* Copy between host and the current process's guest memory a page at a time,
 * stopping at the first unmapped address so a bad guest pointer yields a short
 * count rather than a host fault. gm_page records a fault for an unmapped
 * probe, so clear it: a host-call bounds check must not leave a pending fault
 * that would halt the guest on its next real access. */
static uint32_t
gcopy(struct vm_task *t, uint32_t gaddr, void *host, uint32_t len, int to_guest)
{
	guest_mem *m = &t->cur->g.mem;
	uint8_t   *hb = host;
	uint32_t   done = 0;

	while (done < len) {
		uint8_t *pg = gm_page(m, gaddr + done, to_guest);
		uint32_t off, chunk;

		if (!pg) {
			m->fault = 0;
			break;
		}
		off = (gaddr + done) & (GM_PAGE_SIZE - 1);
		chunk = GM_PAGE_SIZE - off;
		if (chunk > len - done)
			chunk = len - done;
		if (to_guest)
			memcpy(pg + off, hb + done, chunk);
		else
			memcpy(hb + done, pg + off, chunk);
		done += chunk;
	}
	return done;
}

/****************************************************************
 * Output buffering
 ****************************************************************/

static void
flush_lines(struct vm_task *t)
{
	size_t start = 0;
	size_t i;

	for (i = 0; i < t->out_len; i++) {
		if (t->out[i] == '\n') {
			if (t->out_fn)
				t->out_fn(t->out_ctx, t->out + start, i - start + 1);
			start = i + 1;
		}
	}
	if (start > 0) {
		memmove(t->out, t->out + start, t->out_len - start);
		t->out_len -= start;
	}
}

static void
flush_all(struct vm_task *t)
{
	flush_lines(t);
	if (t->out_len > 0) {
		if (t->out_fn)
			t->out_fn(t->out_ctx, t->out, t->out_len);
		t->out_len = 0;
	}
}

static void
out_append(struct vm_task *t, uint32_t gaddr, uint32_t len)
{
	uint32_t done = 0;

	while (done < len) {
		uint8_t  tmp[256];
		uint32_t want = len - done;
		uint32_t got, i;

		if (want > sizeof tmp)
			want = sizeof tmp;
		got = gcopy(t, gaddr + done, tmp, want, 0);
		for (i = 0; i < got; i++) {
			if (t->out_len == VM_OUT_BUF)
				flush_all(t);
			t->out[t->out_len++] = (char)tmp[i];
		}
		flush_lines(t);
		if (got < want)
			break;
		done += got;
	}
}

/****************************************************************
 * Host-call argument access
 ****************************************************************/

uint32_t
vm_arg(struct vm_task *t, int i)
{
	if (i < 0 || i > 5)
		return 0;
	return ((rv_cpu *)t->cur->cpu)->x[10 + i];      /* a0-a5 are x10-x15 */
}

void
vm_set_ret(struct vm_task *t, uint32_t v)
{
	((rv_cpu *)t->cur->cpu)->x[10] = v;             /* result in a0 */
}

uint32_t
vm_read(struct vm_task *t, uint32_t gaddr, void *dst, uint32_t len)
{
	return gcopy(t, gaddr, dst, len, 0);
}

uint32_t
vm_write(struct vm_task *t, uint32_t gaddr, const void *src, uint32_t len)
{
	return gcopy(t, gaddr, (void *)(uintptr_t)src, len, 1);
}

uint32_t
vm_arg_cstr(struct vm_task *t, uint32_t gaddr, char *buf, uint32_t bufsz)
{
	uint32_t n = 0;

	if (bufsz == 0)
		return 0;
	while (n + 1 < bufsz) {
		uint8_t c;
		if (gcopy(t, gaddr + n, &c, 1, 0) != 1 || c == 0)
			break;
		buf[n++] = (char)c;
	}
	buf[n] = 0;
	return n;
}

/****************************************************************
 * Cooperative park helpers
 ****************************************************************/

/* Park the task on empty input: the adapter will not step it until a delivery
 * (vm_task_post / vm_task_feed_stdin) clears the block. */
static void
task_park(struct vm_task *t)
{
	t->blocked = 1;
	((rv_cpu *)t->cur->cpu)->waiting = 1;
}

/****************************************************************
 * Builtin host calls
 ****************************************************************/

static void stdin_read(struct vm_task *t, uint32_t buf, uint32_t len);

static void
bi_exit(struct vm_task *t, void *ctx)
{
	(void)ctx;
	t->exit_status = (int)vm_arg(t, 0);
	t->state = VM_EXITED;
	rv_halt(t->cur->cpu);
}

/* Move bytes between the guest and a descriptor the VM core does not own (fd
 * >= 3) through the env's stream backend. With no backend a read on fd 0 is
 * end-of-file and anything else is -EBADF. */
static long
stream_rw(struct vm_task *t, uint32_t fd, uint32_t buf, uint32_t len, int is_write)
{
	if (t->env && t->env->stream_fn)
		return t->env->stream_fn(t, t->env->stream_ctx, (int)fd, buf, len, is_write);
	if (!is_write && fd == 0)
		return 0;                       /* stdin reports EOF when unbacked */
	return -9;                              /* -EBADF */
}

/* Write one guest buffer to a descriptor. fd 1 and 2 share the output sink; any
 * other descriptor is the host's, routed to the stream backend. */
static long
write_fd(struct vm_task *t, uint32_t fd, uint32_t buf, uint32_t len)
{
	if (fd == 1 || fd == 2) {
		out_append(t, buf, len);
		return (long)len;
	}
	return stream_rw(t, fd, buf, len, 1);
}

static void
bi_write(struct vm_task *t, void *ctx)
{
	/* a0 = fd, a1 = buffer, a2 = length. */
	uint32_t fd = vm_arg(t, 0), buf = vm_arg(t, 1), len = vm_arg(t, 2);
	(void)ctx;
	vm_set_ret(t, (uint32_t)write_fd(t, fd, buf, len));
}

static void
bi_read(struct vm_task *t, void *ctx)
{
	/* a0 = fd, a1 = buffer, a2 = length. fd 0 is stdin (may park); fd 1 and 2
	 * are write-only; any other descriptor is the host's. */
	uint32_t fd = vm_arg(t, 0), buf = vm_arg(t, 1), len = vm_arg(t, 2);
	(void)ctx;
	if (fd == 1 || fd == 2)
		vm_set_ret(t, (uint32_t)-9);    /* -EBADF */
	else if (fd == 0)
		stdin_read(t, buf, len);        /* may park; sets the result itself */
	else
		vm_set_ret(t, (uint32_t)stream_rw(t, fd, buf, len, 0));
}

static void
bi_random(struct vm_task *t, void *ctx)
{
	uint32_t bound = vm_arg(t, 0);
	uint32_t x = t->rng;
	(void)ctx;
	x ^= x << 13;
	x ^= x >> 17;
	x ^= x << 5;
	t->rng = x;
	vm_set_ret(t, bound ? x % bound : x);
}

static void
bi_now(struct vm_task *t, void *ctx)
{
	(void)ctx;
	vm_set_ret(t, (uint32_t)time(NULL));
}

/* Monotonic milliseconds for timed sleeps. */
static uint64_t
now_ms(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint64_t)ts.tv_sec * 1000u + (uint64_t)ts.tv_nsec / 1000000u;
}

static void
bi_suspend(struct vm_task *t, void *ctx)
{
	/* Wake policy in a0; for a sleep the span in a1 (ms). EVENT parks until an
	 * event arrives; SLEEP parks until a1 ms pass, when vm_task_run delivers a
	 * timer event (a real event arriving first wakes it early); YIELD runs
	 * again next tick. Either blocking mode returns at once if the mailbox
	 * already holds an event, so a pending event is never missed. */
	uint32_t mode = vm_arg(t, 0);
	(void)ctx;

	t->sleeping = 0;
	if (mode == VM_SUSPEND_EVENT) {
		if (t->mbox_count == 0)
			task_park(t);
	} else if (mode == VM_SUSPEND_SLEEP) {
		if (t->mbox_count == 0) {
			task_park(t);
			t->sleeping = 1;
			t->wake_at_ms = now_ms() + vm_arg(t, 1);
		}
	} else {
		((rv_cpu *)t->cur->cpu)->waiting = 1;   /* plain yield */
	}
	vm_set_ret(t, 0);
}

/* Pop one mailbox event into a guest record: u32 kind, u32 sender, u32 len,
 * then len payload bytes and a NUL, little-endian. An empty mailbox writes a
 * VM_EV_NONE header and returns 0. Non-blocking; pair with sys_suspend to wait. */
static void
bi_getmsg(struct vm_task *t, void *ctx)
{
	uint32_t buf = vm_arg(t, 0);
	uint32_t cap = vm_arg(t, 1);
	struct vm_msg *m;
	uint32_t hdr[3];
	uint32_t room;
	(void)ctx;

	if (t->mbox_count == 0) {
		hdr[0] = VM_EV_NONE;
		hdr[1] = 0;
		hdr[2] = 0;
		if (cap >= sizeof hdr)
			vm_write(t, buf, hdr, sizeof hdr);
		vm_set_ret(t, VM_EV_NONE);
		return;
	}

	m = &t->mbox[t->mbox_head];
	room = cap > sizeof hdr ? cap - (uint32_t)sizeof hdr : 0;
	if (room > 0)
		room -= 1;
	if (room > m->len)
		room = m->len;

	hdr[0] = m->kind;
	hdr[1] = m->sender;
	hdr[2] = room;
	if (cap >= sizeof hdr) {
		vm_write(t, buf, hdr, sizeof hdr);
		if (room > 0)
			vm_write(t, buf + (uint32_t)sizeof hdr, m->data, room);
		vm_write(t, buf + (uint32_t)sizeof hdr + room, "", 1);
	}

	t->mbox_head = (t->mbox_head + 1) % VM_MAILBOX_MAX;
	t->mbox_count--;
	vm_set_ret(t, m->kind);
}

/* Whether a selector names a runtime builtin (served directly, never through an
 * env). sys_exit/write/read/random/now are the raw Linux seam now, served by
 * guest_syscall and the console interception, not the band; the band builtins
 * are the boris-only calls with no Linux equivalent. */
static int
is_builtin_call(int call)
{
	switch (call) {
	case VM_CALL_EXIT:
	case VM_CALL_WRITE:
	case VM_CALL_READ:
	case VM_CALL_RANDOM:
	case VM_CALL_NOW:
	case VM_CALL_SUSPEND:
	case VM_CALL_GETMSG:
		return 1;
	default:
		return 0;
	}
}

static int
call_builtin(struct vm_task *t, int call)
{
	switch (call) {
	case VM_CALL_EXIT:    bi_exit(t, NULL);    return 1;
	case VM_CALL_WRITE:   bi_write(t, NULL);   return 1;
	case VM_CALL_READ:    bi_read(t, NULL);    return 1;
	case VM_CALL_RANDOM:  bi_random(t, NULL);  return 1;
	case VM_CALL_NOW:     bi_now(t, NULL);     return 1;
	case VM_CALL_SUSPEND: bi_suspend(t, NULL); return 1;
	case VM_CALL_GETMSG:  bi_getmsg(t, NULL);  return 1;
	default:              return 0;
	}
}

/****************************************************************
 * Console descriptors (fd 0/1/2), intercepted for the root
 ****************************************************************/

static long
stdin_consume(struct vm_task *t, uint32_t buf, uint32_t len)
{
	uint32_t n;

	if (t->stdin_len == 0)
		return -1;
	n = len < t->stdin_len ? len : t->stdin_len;
	n = vm_write(t, buf, t->stdin_buf + t->stdin_head, n);
	t->stdin_head += n;
	t->stdin_len -= n;
	if (t->stdin_len == 0)
		t->stdin_head = 0;
	return (long)n;
}

static uint32_t
stdin_buf_append(struct vm_task *t, const char *data, uint32_t len)
{
	uint32_t room;

	if (t->stdin_head > 0) {
		if (t->stdin_len > 0)
			memmove(t->stdin_buf, t->stdin_buf + t->stdin_head, t->stdin_len);
		t->stdin_head = 0;
	}
	room = VM_STDIN_BUF - t->stdin_len;
	if (len > room)
		len = room;
	memcpy(t->stdin_buf + t->stdin_len, data, len);
	t->stdin_len += len;
	return len;
}

/* A read on fd 0: serve buffered bytes at once; on an empty buffer report EOF
 * when stdin is closed, else park the task and record the pending read so
 * vm_task_feed_stdin can complete it. The read ecall advances past; a woken
 * guest resumes after it with its result in a0, set by feed_stdin. */
static void
stdin_read(struct vm_task *t, uint32_t buf, uint32_t len)
{
	long n;

	if (len == 0) {
		vm_set_ret(t, 0);
		return;
	}
	n = stdin_consume(t, buf, len);
	if (n >= 0) {
		vm_set_ret(t, (uint32_t)n);
		return;
	}
	if (t->stdin_eof) {
		vm_set_ret(t, 0);
		return;
	}
	t->rd_waiting = 1;
	t->rd_buf = buf;
	t->rd_len = len;
	task_park(t);
}

static long
writev_console(struct vm_task *t, uint32_t iov, uint32_t iovcnt)
{
	long total = 0;
	uint32_t i;

	if (iovcnt > VM_IOV_MAX)
		return -22;                     /* -EINVAL */
	for (i = 0; i < iovcnt; i++) {
		uint32_t ent = iov + i * 8;     /* struct iovec { u32 base; u32 len } */
		uint8_t  raw[8];
		uint32_t base, len;

		if (vm_read(t, ent, raw, 8) != 8)
			return total ? total : -14; /* -EFAULT */
		base = (uint32_t)raw[0] | ((uint32_t)raw[1] << 8) |
		       ((uint32_t)raw[2] << 16) | ((uint32_t)raw[3] << 24);
		len = (uint32_t)raw[4] | ((uint32_t)raw[5] << 8) |
		      ((uint32_t)raw[6] << 16) | ((uint32_t)raw[7] << 24);
		if (len == 0)
			continue;
		out_append(t, base, len);
		total += len;
	}
	return total;
}

/* Intercept a console read/write/writev on fd 0/1/2 for the root process.
 * Returns 1 if the syscall was a console descriptor (and served it), 0 to let
 * it fall through to guest_syscall (a file fd, or a redirected child fd). */
static int
console_syscall(struct vm_task *t, uint32_t nr, rv_cpu *cpu)
{
	uint32_t fd = cpu->x[10];

	switch (nr) {
	case VM_NR_WRITE:
		if (fd == 1 || fd == 2) {
			out_append(t, cpu->x[11], cpu->x[12]);
			cpu->x[10] = cpu->x[12];
			return 1;
		}
		return 0;
	case VM_NR_WRITEV:
		if (fd == 1 || fd == 2) {
			cpu->x[10] = (uint32_t)writev_console(t, cpu->x[11], cpu->x[12]);
			return 1;
		}
		return 0;
	case VM_NR_READ:
		if (fd == 0) {
			stdin_read(t, cpu->x[11], cpu->x[12]);
			return 1;
		}
		return 0;
	default:
		return 0;
	}
}

/****************************************************************
 * The RV32 syscall-number map (the generic Linux table), mirroring the
 * vendored emu/rv_user.c so boris's ecall reaches the same guest_syscall.
 ****************************************************************/

#define RV_NR_OPENAT        56
#define RV_NR_CLOSE         57
#define RV_NR_LSEEK         62
#define RV_NR_READ          63
#define RV_NR_WRITE         64
#define RV_NR_WRITEV        66
#define RV_NR_EXIT          93
#define RV_NR_EXIT_GROUP    94
#define RV_NR_BRK           214
#define RV_NR_STATX         291
#define RV_NR_MKDIRAT       34
#define RV_NR_UNLINKAT      35
#define RV_NR_FCHMODAT      53
#define RV_NR_RENAMEAT2     276
#define RV_NR_GETDENTS64    61
#define RV_NR_CLOCK_GETTIME 113
#define RV_NR_GETRANDOM     278
#define RV_NR_NANOSLEEP     101
#define RV_NR_SCHED_YIELD   124

static int
sys_of_rv(uint32_t nr)
{
	switch (nr) {
	case RV_NR_OPENAT:        return GSYS_OPENAT;
	case RV_NR_CLOSE:         return GSYS_CLOSE;
	case RV_NR_LSEEK:         return GSYS_LLSEEK;
	case RV_NR_READ:          return GSYS_READ;
	case RV_NR_WRITE:         return GSYS_WRITE;
	case RV_NR_WRITEV:        return GSYS_WRITEV;
	case RV_NR_EXIT:          return GSYS_EXIT;
	case RV_NR_EXIT_GROUP:    return GSYS_EXIT_GROUP;
	case RV_NR_BRK:           return GSYS_BRK;
	case RV_NR_STATX:         return GSYS_STATX;
	case RV_NR_MKDIRAT:       return GSYS_MKDIRAT;
	case RV_NR_UNLINKAT:      return GSYS_UNLINKAT;
	case RV_NR_FCHMODAT:      return GSYS_FCHMODAT;
	case RV_NR_RENAMEAT2:     return GSYS_RENAMEAT2;
	case RV_NR_GETDENTS64:    return GSYS_GETDENTS64;
	case RV_NR_CLOCK_GETTIME: return GSYS_CLOCK_GETTIME;
	case RV_NR_GETRANDOM:     return GSYS_GETRANDOM;
	case RV_NR_NANOSLEEP:     return GSYS_NANOSLEEP;
	case RV_NR_SCHED_YIELD:   return GSYS_SCHED_YIELD;
	default:                  return GSYS_UNKNOWN;
	}
}

/****************************************************************
 * The ecall handler
 *
 * Installed by boris_ready on every process. It serves the boris selector band
 * (the builtins and the game-specific env calls), then skjegg's private
 * selectors (MAP/SPAWN/P9/...) through sched_private, then intercepts the root
 * console descriptors, and finally falls through to guest_syscall for files,
 * the program break, exit, the clock, the RNG and the cooperative yields.
 ****************************************************************/

static int
vm_ecall(rv_cpu *cpu, void *ctx)
{
	proc *p = ctx;
	struct vm_task *t = TASK_OF(p);
	guest *g = &p->g;
	uint32_t nr = cpu->x[17];               /* a7 */
	uint32_t result;
	int32_t r;

	t->cur = p;

	if (nr >= VM_HOSTCALL_BASE) {
		uint32_t idx = nr - VM_HOSTCALL_BASE;

		if (idx < VM_CALL_COUNT) {
			if (call_builtin(t, (int)idx))
				return RV_ECALL_OK;
			if (t->env && t->env->sel[idx].fn) {
				t->env->sel[idx].fn(t, t->env->sel[idx].ctx);
				return RV_ECALL_OK;
			}
		}
		/* An unserved or out-of-range selector is an observable failure. */
		t->exit_status = 127;
		t->state = VM_FAULTED;
		rv_halt(cpu);
		return RV_ECALL_OK;
	}

	/* skjegg's emulator-private selectors (FATAL/MAP/MUNMAP/SPAWN/P9/...). */
	switch (sched_private(p, nr, cpu->x[10], cpu->x[11], cpu->pc, &result)) {
	case SKJ_PRIV_OK:    cpu->x[10] = result; return RV_ECALL_OK;
	case SKJ_PRIV_FATAL: t->state = VM_FAULTED; rv_halt(cpu); return RV_ECALL_OK;
	case SKJ_PRIV_YIELD: cpu->waiting = 1; return RV_ECALL_OK;
	case SKJ_PRIV_RETRY: cpu->waiting = 1; return RV_ECALL_RETRY;
	case SKJ_PRIV_NO:    break;
	}

	/* The console descriptors belong to boris for the root process; a child's
	 * (spawned, redirected) descriptors fall through to guest_syscall. */
	if (p == t->root && console_syscall(t, nr, cpu))
		return RV_ECALL_OK;

	/* Every other syscall is skjegg's: files through fs/, the program break,
	 * exit, the clock, the RNG, nanosleep and the cooperative yields. */
	r = guest_syscall(g, sys_of_rv(nr), cpu->x[10], cpu->x[11], cpu->x[12],
	                  cpu->x[13], cpu->x[14], cpu->x[15]);
	if (g->park == GPARK_RETRY) {
		cpu->waiting = 1;
		return RV_ECALL_RETRY;          /* re-run the ecall, commit no result */
	}
	cpu->x[10] = (uint32_t)r;
	if (g->park == GPARK_YIELD)
		cpu->waiting = 1;
	if (g->exited) {
		t->state = VM_EXITED;
		t->exit_status = g->exit_code;
		rv_halt(cpu);
	}
	return RV_ECALL_OK;
}

/****************************************************************
 * The boris CPU binding
 *
 * A boris-authored skj_cpu_ops, parallel to the vendored emu/rv_user.c rv_ops
 * but installing vm_ecall so the boris band and console are served. Only the
 * fields sched_step and sched_destroy touch are filled; the diagnostics the
 * scheduler prints on a fault are left minimal.
 ****************************************************************/

static void *
boris_rv_alloc(void)
{
	return calloc(1, sizeof(rv_cpu));
}

static void
boris_rv_free(void *cpu)
{
	if (cpu) {
		rv_dec_free(cpu);
		free(cpu);
	}
}

static void
boris_rv_ready(proc *p, uint32_t entry, uint32_t sp)
{
	rv_cpu *cpu = p->cpu;

	rv_init(cpu, skj_bus_r8, skj_bus_r16, skj_bus_r32,
	        skj_bus_w8, skj_bus_w16, skj_bus_w32, p);
	rv_reset(cpu, entry);
	rv_set_ecall(cpu, vm_ecall, p);
	/* The RV32 ISA the vendored toolchain targets, matching emu/rv_user.c so
	 * boris guests and the toolchain agree on the ISA. */
	cpu->zcmp = 1;
	cpu->atomics = 1;
	cpu->bitmanip = 1;
	cpu->zcb = 1;
	cpu->dp = 1;
	rv_dec_enable(cpu);
	cpu->x[2] = sp;                 /* sp */
	p->g.can_park = 1;              /* cooperative blocking-syscall yields */
}

static enum skj_run_reason
boris_rv_run(proc *p, int budget, int *ran)
{
	return (enum skj_run_reason)rv_run(p->cpu, budget, ran);
}

static void     boris_rv_halt(void *cpu)        { rv_halt(cpu); }
static void     boris_rv_clear_yield(void *cpu) { ((rv_cpu *)cpu)->waiting = 0; }
static uint32_t boris_rv_fault_pc(void *cpu)    { return ((rv_cpu *)cpu)->pc; }
static uint32_t boris_rv_trap_pc(void *cpu)     { return ((rv_cpu *)cpu)->mepc; }
static uint32_t boris_rv_bt_fp(void *cpu)       { return ((rv_cpu *)cpu)->x[8]; }

static void
boris_rv_report_trap(FILE *out, int slot, void *cpu)
{
	const rv_cpu *c = cpu;
	fprintf(out, "vm: [proc %d] trap (mcause=0x%08x) at 0x%08x\n",
	        slot + 1, c->mcause, c->mepc);
}

static int
boris_rv_trap_signal(void *cpu)
{
	(void)cpu;
	return 11;                      /* SIGSEGV */
}

/* The scheduler calls dump_regs on any fault or trap (and dump_trace only under
 * --trace), so both must be non-NULL. A faulted guest is already turned into a
 * VM_FAULTED task by the adapter; keep the diagnostic to one line. */
static void
boris_rv_dump_regs(FILE *out, int slot, void *cpu)
{
	const rv_cpu *c = cpu;
	fprintf(out, "vm: [proc %d] pc=0x%08x ra=0x%08x sp=0x%08x a0=0x%08x\n",
	        slot + 1, c->pc, c->x[1], c->x[2], c->x[10]);
}

static void
boris_rv_dump_trace(FILE *out, void *cpu)
{
	(void)out;
	(void)cpu;
}

static const skj_cpu_ops boris_rv_ops = {
	.name = "RISC-V",
	.machine = EM_RISCV,
	.arch = GUEST_ARCH_RV32,
	.big_endian = 0,
	.word64 = 0,
	.alloc = boris_rv_alloc,
	.free = boris_rv_free,
	.ready = boris_rv_ready,
	.run = boris_rv_run,
	.halt = boris_rv_halt,
	.clear_yield = boris_rv_clear_yield,
	.fault_pc = boris_rv_fault_pc,
	.trap_pc = boris_rv_trap_pc,
	.bt_fp = boris_rv_bt_fp,
	.bt_bigendian = 0,
	.report_trap = boris_rv_report_trap,
	.trap_signal = boris_rv_trap_signal,
	.dump_regs = boris_rv_dump_regs,
	.dump_trace = boris_rv_dump_trace,
	.gdb = NULL,
};

/****************************************************************
 * Host-call environment
 ****************************************************************/

struct vm_env *
vm_env_new(void)
{
	return calloc(1, sizeof(struct vm_env));
}

void
vm_env_free(struct vm_env *e)
{
	free(e);
}

int
vm_env_register(struct vm_env *e, int call, vm_hostcall_fn fn, void *ctx)
{
	if (call < 0 || call >= VM_CALL_COUNT)
		return -1;
	/* A builtin selector is served by the runtime, not the env. */
	if (is_builtin_call(call))
		return -1;
	e->sel[call].fn = fn;
	e->sel[call].ctx = ctx;
	return 0;
}

void
vm_env_set_stream(struct vm_env *e, vm_stream_fn fn, void *ctx)
{
	e->stream_fn = fn;
	e->stream_ctx = ctx;
}

/****************************************************************
 * Task lifecycle
 ****************************************************************/

static uint32_t g_next_id = 1;

struct vm_task *
vm_task_new(uint32_t mem_size)
{
	struct vm_task *t;

	(void)mem_size;         /* memory commits lazily; the hint no longer caps */

	t = calloc(1, sizeof(*t));
	if (!t)
		return NULL;
	t->id = g_next_id++;
	t->state = VM_READY;
	t->rng = t->id * 2654435761u + 1;       /* nonzero xorshift seed */

	/* The scheduler's run options: the per-guest and aggregate memory caps and
	 * the heap and stack sizes. The path and argv are filled at load. */
	t->opts.mem_limit = VM_MEM_LIMIT;
	t->opts.total_mem = 0;                  /* no aggregate cap per task tree */
	t->opts.heap_size = VM_HEAP_SIZE;
	t->opts.stack_size = VM_STACK_SIZE;
	t->opts.max_insns = 0;
	t->opts.child_max_insns = 0;
	return t;
}

void
vm_task_free(struct vm_task *t)
{
	if (!t)
		return;
	flush_all(t);
	if (t->loaded)
		sched_destroy(&t->S);
	free(t);
}

void
vm_task_set_output(struct vm_task *t, vm_output_fn fn, void *ctx)
{
	t->out_fn = fn;
	t->out_ctx = ctx;
}

void
vm_task_set_env(struct vm_task *t, struct vm_env *e)
{
	t->env = e;
}

/* Find the process a sched_add_root handle resolves to: proc_from_handle is
 * private, but the process table is public and small. */
static proc *
proc_by_handle(sched *S, int handle)
{
	int i;

	for (i = 0; i < S->nprocs; i++)
		if (S->procs[i] && (int)S->procs[i]->handle == handle)
			return S->procs[i];
	return NULL;
}

int
vm_task_add_mount(struct vm_task *t, const char *name, const char *hostdir,
                  int readonly)
{
	int slot;

	/* Mounts are read during load (sched_add_root installs them), so they must
	 * be set first. */
	if (t->loaded || !name || !hostdir)
		return -1;
	slot = t->n_mount_spec;
	if (slot >= VM_MAX_MOUNTS)
		return -1;
	if (readonly) {
		if (t->opts.nmounts_ro >= RUN_MAX_MOUNTS)
			return -1;
	} else {
		if (t->opts.nmounts >= RUN_MAX_MOUNTS)
			return -1;
	}
	if ((int)snprintf(t->mount_spec[slot], sizeof t->mount_spec[slot], "%s:%s",
	                  name, hostdir) >= (int)sizeof t->mount_spec[slot])
		return -1;              /* the spec did not fit */
	if (readonly)
		t->opts.mounts_ro[t->opts.nmounts_ro++] = t->mount_spec[slot];
	else
		t->opts.mounts[t->opts.nmounts++] = t->mount_spec[slot];
	t->n_mount_spec++;
	return 0;
}

int
vm_task_add_p9_mount(struct vm_task *t, const char *name, const char *hostdir)
{
	int slot;

	/* The guest reaches the in-world VFS through a 9P mount served by boris's
	 * CAS-backed p9 server. sched_add_root installs it from run_opts.p9s; the
	 * server ignores hostdir (it serves the bound VFS), but the launcher opens
	 * hostdir to validate the grant, so it must name a real, readable directory.
	 * Must be set before load. */
	if (t->loaded || !name || !hostdir)
		return -1;
	slot = t->n_mount_spec;
	if (slot >= VM_MAX_MOUNTS || t->opts.np9s >= RUN_MAX_MOUNTS)
		return -1;
	if ((int)snprintf(t->mount_spec[slot], sizeof t->mount_spec[slot], "%s:%s",
	                  name, hostdir) >= (int)sizeof t->mount_spec[slot])
		return -1;
	t->opts.p9s[t->opts.np9s++] = t->mount_spec[slot];
	t->n_mount_spec++;
	return 0;
}

void
vm_task_set_limits(struct vm_task *t, uint32_t mem_limit, uint32_t heap_size,
                   uint32_t stack_size)
{
	/* A batch guest (the compile toolchain) needs far more room than an
	 * interactive verb. Raise the caps before load; a zero field keeps the
	 * default from vm_task_new. */
	if (t->loaded)
		return;
	if (mem_limit)
		t->opts.mem_limit = mem_limit;
	if (heap_size)
		t->opts.heap_size = heap_size;
	if (stack_size)
		t->opts.stack_size = stack_size;
}

/* Bring up the task's scheduler around a root. When `image` is set the
 * scheduler loads that in-memory ELF (sched_root.image) and `path` is only a
 * diagnostic label; otherwise it opens `path`. Either way the scheduler lays
 * out the heap and stack, builds a minimal (argc 0) initial stack and readies
 * the CPU through boris_rv_ops. A later vm_task_set_args or
 * vm_task_set_typed_args rewrites the stack top with the real arguments. */
static int
load_root(struct vm_task *t, const char *path, const uint8_t *image, long len)
{
	sched_root root;
	int h;

	t->opts.path = t->path;
	sched_init(&t->S, &t->opts, &boris_rv_ops);
	memset(&root, 0, sizeof root);
	root.path = path;
	root.image = image;
	root.image_len = len;
	h = sched_add_root(&t->S, &root);
	if (h <= 0) {
		sched_destroy(&t->S);
		return -1;
	}
	t->root = proc_by_handle(&t->S, h);
	if (!t->root) {
		sched_destroy(&t->S);
		return -1;
	}
	t->cur = t->root;
	t->loaded = 1;
	t->state = VM_READY;
	t->exit_status = 0;
	return 0;
}

int
vm_task_load_mem(struct vm_task *t, const uint8_t *buf, long size,
                 const char *what)
{
	if (t->loaded)
		return -1;
	/* Boris's verb and agent images live in memory (the object store, a freshly
	 * compiled image); the scheduler loads such a root from the byte buffer
	 * through sched_root.image, with `what` kept only as a diagnostic label. */
	snprintf(t->path, sizeof t->path, "%s", what ? what : "<image>");
	return load_root(t, t->path, buf, size);
}

int
vm_task_load_file(struct vm_task *t, const char *path)
{
	if (t->loaded)
		return -1;
	snprintf(t->path, sizeof t->path, "%s", path);
	return load_root(t, t->path, NULL, 0);
}

int
vm_task_set_args(struct vm_task *t, const char *const *argv, int argc)
{
	rv_cpu  *cpu = t->root->cpu;
	guest_mem *m = &t->root->g.mem;
	uint32_t sp = t->root->g.stack_top & ~15u;
	uint32_t ptrs[VM_MAX_ARGS];
	uint32_t need, p;
	int i;

	if (argc < 0)
		argc = 0;
	if (argc > VM_MAX_ARGS)
		return -1;
	t->cur = t->root;

	for (i = argc - 1; i >= 0; i--) {
		uint32_t len = (uint32_t)strlen(argv[i]) + 1;
		if (len > sp)
			return -1;
		sp -= len;
		if (vm_write(t, sp, argv[i], len) != len)
			return -1;
		ptrs[i] = sp;
	}

	need = 4                                /* argc */
	     + 4 * ((uint32_t)argc + 1)         /* argv[0..argc-1] and the NULL */
	     + 4                                /* envp NULL */
	     + 8;                               /* auxv: one AT_NULL {0, 0} */
	need = (need + 15u) & ~15u;
	if (sp < need)
		return -1;
	sp = (sp - need) & ~15u;

	p = sp;
	gm_store(m, p, 4, 0, (uint32_t)argc);   p += 4;
	for (i = 0; i < argc; i++) {
		gm_store(m, p, 4, 0, ptrs[i]);  p += 4;
	}
	gm_store(m, p, 4, 0, 0);                p += 4;      /* argv NULL */
	gm_store(m, p, 4, 0, 0);                p += 4;      /* envp NULL */
	gm_store(m, p, 4, 0, 0);                p += 4;      /* auxv[0].type */
	gm_store(m, p, 4, 0, 0);                p += 4;      /* auxv[0].val */

	cpu->x[2] = sp;                         /* sp -> argc */
	cpu->x[10] = (uint32_t)argc;            /* a0 = argc, for the C crt */
	cpu->x[11] = sp + 4;                    /* a1 = argv, for the C crt */
	return 0;
}

int
vm_task_set_typed_args(struct vm_task *t, const struct vm_typed_arg *args,
                       int n)
{
	rv_cpu  *cpu = t->root->cpu;
	guest_mem *m = &t->root->g.mem;
	uint32_t sp = t->root->g.stack_top & ~15u;
	uint32_t values[VM_MAX_ARGS];
	uint32_t array_addr;
	int i;

	if (n < 0)
		n = 0;
	if (n > VM_MAX_ARGS)
		return -1;
	t->cur = t->root;

	for (i = n - 1; i >= 0; i--) {
		if (args[i].str) {
			uint32_t len = (uint32_t)strlen(args[i].str) + 1;
			if (len > sp)
				return -1;
			sp -= len;
			if (vm_write(t, sp, args[i].str, len) != len)
				return -1;
			values[i] = sp;
		} else {
			values[i] = args[i].ival;
		}
	}

	sp &= ~3u;
	if (sp < (uint32_t)n * 8)
		return -1;
	for (i = n - 1; i >= 0; i--) {
		sp -= 4;
		gm_store(m, sp, 4, 0, values[i]);
		sp -= 4;
		gm_store(m, sp, 4, 0, args[i].type);
	}
	array_addr = sp;

	sp &= ~15u;
	cpu->x[2] = sp;                         /* sp */
	cpu->x[10] = (uint32_t)n;               /* a0 = slot count */
	cpu->x[11] = array_addr;                /* a1 = slot array */
	return 0;
}

enum vm_state
vm_task_run(struct vm_task *t, int quantum)
{
	int rounds, i;

	if (t->state != VM_READY)
		return t->state;

	/* A parked task burns no cycles until woken. A timed sleep wakes itself:
	 * once its deadline passes it delivers a timer event, clearing the block.
	 * Any other parked task waits for an external vm_task_post / feed_stdin. */
	if (t->blocked) {
		if (t->sleeping && now_ms() >= t->wake_at_ms) {
			t->sleeping = 0;
			vm_task_post(t, VM_EV_TIMER, 0, NULL, 0);
		} else {
			return VM_READY;
		}
	}

	rounds = quantum / VM_ROUND_INSNS;
	if (rounds < 1)
		rounds = 1;

	for (i = 0; i < rounds; i++) {
		int ran = 0;

		sched_step(&t->S, &ran);

		/* The root process carries the run's result: it exits through
		 * guest_syscall (vm_ecall sets state) or faults (done without an
		 * exit). A child spawned by the root is the scheduler's to reap. */
		if (t->root->done && t->state == VM_READY) {
			if (t->root->g.exited) {
				t->state = VM_EXITED;
				t->exit_status = t->root->g.exit_code;
			} else {
				t->state = VM_FAULTED;
				t->exit_status = t->root->rc;
			}
		}
		if (t->state != VM_READY)
			break;
		if (t->blocked)         /* a host call parked the task this slice */
			break;
		if (!ran)               /* nothing runnable (all parked/done) */
			break;
	}

	if (t->state == VM_EXITED || t->state == VM_FAULTED)
		flush_all(t);
	else
		flush_lines(t);
	return t->state;
}

enum vm_state
vm_task_state(const struct vm_task *t)
{
	return t->state;
}

int
vm_task_exit_status(const struct vm_task *t)
{
	return t->exit_status;
}

uint32_t
vm_task_id(const struct vm_task *t)
{
	return t->id;
}

void
vm_task_set_context(struct vm_task *t, uint32_t session, uint32_t authority)
{
	t->session = session;
	t->authority = authority;
}

uint32_t
vm_task_session(const struct vm_task *t)
{
	return t->session;
}

uint32_t
vm_task_authority(const struct vm_task *t)
{
	return t->authority;
}

void
vm_task_set_userdata(struct vm_task *t, void *ud)
{
	t->userdata = ud;
}

void *
vm_task_userdata(const struct vm_task *t)
{
	return t->userdata;
}

/****************************************************************
 * Mailbox and stdin delivery
 ****************************************************************/

int
vm_task_post(struct vm_task *t, uint32_t kind, uint32_t sender,
             const char *str, uint32_t len)
{
	struct vm_msg *m;
	int tail;

	if (t->mbox_count >= VM_MAILBOX_MAX)
		return -1;
	if (len > VM_MSG_MAX)
		len = VM_MSG_MAX;

	tail = (t->mbox_head + t->mbox_count) % VM_MAILBOX_MAX;
	m = &t->mbox[tail];
	m->kind = kind;
	m->sender = sender;
	m->len = len;
	if (len > 0 && str)
		memcpy(m->data, str, len);
	else
		m->len = 0;
	t->mbox_count++;

	t->blocked = 0;
	t->sleeping = 0;
	return 0;
}

int
vm_task_feed_stdin(struct vm_task *t, const void *data, uint32_t len)
{
	const char *p = data;

	if (!t)
		return -1;
	t->cur = t->root;
	/* A read is parked for input: complete it now. Fill the guest buffer, set
	 * the read's result, and clear the park. Any surplus waits for the next
	 * read. */
	if (t->rd_waiting) {
		uint32_t n = len < t->rd_len ? len : t->rd_len;

		vm_write(t, t->rd_buf, p, n);
		vm_set_ret(t, n);
		t->rd_waiting = 0;
		t->blocked = 0;
		t->sleeping = 0;
		if (len > n)
			stdin_buf_append(t, p + n, len - n);
		return (int)len;
	}
	return (int)stdin_buf_append(t, p, len);
}

void
vm_task_close_stdin(struct vm_task *t)
{
	if (!t)
		return;
	t->stdin_eof = 1;
	t->cur = t->root;
	if (t->rd_waiting) {
		vm_set_ret(t, 0);
		t->rd_waiting = 0;
		t->blocked = 0;
		t->sleeping = 0;
	}
}

int
vm_task_blocked(const struct vm_task *t)
{
	return t->blocked;
}

int
vm_task_msgs(const struct vm_task *t)
{
	return t->mbox_count;
}

/****************************************************************
 * Cooperative scheduler over a set of tasks
 *
 * A thin run queue the server ticks: each tick steps every ready task by a
 * quantum and reaps the ones that finished. Each task carries its own skjegg
 * scheduler, so this layer only sequences tasks and owns their lifetimes.
 ****************************************************************/

struct vm_sched {
	struct vm_task *head;
	int             count;
};

struct vm_sched *
vm_sched_new(void)
{
	return calloc(1, sizeof(struct vm_sched));
}

void
vm_sched_free(struct vm_sched *s)
{
	struct vm_task *t;

	if (!s)
		return;
	t = s->head;
	while (t) {
		struct vm_task *next = t->next;
		vm_task_free(t);
		t = next;
	}
	free(s);
}

void
vm_sched_add(struct vm_sched *s, struct vm_task *t)
{
	t->next = s->head;
	s->head = t;
	s->count++;
}

int
vm_sched_tick(struct vm_sched *s, int quantum)
{
	struct vm_task *t = s->head;
	struct vm_task *prev = NULL;

	while (t) {
		enum vm_state st = vm_task_run(t, quantum);

		if (st == VM_READY) {
			prev = t;
			t = t->next;
			continue;
		}
		{
			struct vm_task *dead = t;
			t = t->next;
			if (prev)
				prev->next = t;
			else
				s->head = t;
			vm_task_free(dead);
			s->count--;
		}
	}
	return s->count;
}

int
vm_sched_count(const struct vm_sched *s)
{
	return s->count;
}
