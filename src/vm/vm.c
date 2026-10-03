/* vm.c : RV32 task runtime and cooperative scheduler */

#include "vm.h"

#include <rv32.h>
#include <elf32.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* Reserved ecall selectors below VM_HOSTCALL_BASE. A guest runtime signals an
 * unrecoverable fault (divide by zero, overflow, bad index) with this
 * selector and the kind in a0; the runtime turns it into a task fault. */
#define VM_SYS_TRAP    0x000f0000u

#define VM_OUT_BUF     512
#define VM_MAX_ARGS    16       /* argv entries a one-shot program may get */
#define VM_MAX_IMPORTS 64       /* host calls one image may import */
#define VM_ENV_MAX     64       /* host calls one env may provide */
#define VM_ENV_NAMELEN 48
#define VM_MAILBOX_MAX 16       /* events a task may queue before back-pressure */
#define VM_MSG_MAX     256      /* payload bytes kept per event */

/* sys_suspend modes, selected by a0. */
#define VM_SUSPEND_YIELD 0      /* run again next tick */
#define VM_SUSPEND_EVENT 1      /* park until a mailbox event arrives */
#define VM_SUSPEND_SLEEP 2      /* park until a1 ms pass, then get a timer event */

struct vm_task {
	uint32_t      id;
	rv_cpu        cpu;
	uint8_t      *ram;
	uint32_t      ram_size;

	enum vm_state state;
	int           exit_status;

	/* Cooperative output, buffered host-side and flushed a line at a
	 * time. The runtime never blocks the guest on a reader. */
	char          out[VM_OUT_BUF];
	size_t        out_len;
	vm_output_fn  out_fn;
	void         *out_ctx;

	/* Host-side context. */
	uint32_t      session;
	uint32_t      authority;
	void         *userdata;         /* opaque per-task context for the host */

	/* Bounded mailbox, a ring of pending events. The host fills it with
	 * vm_task_post; the guest drains it with sys_getmsg. blocked is set when
	 * the guest parked in sys_suspend on an empty mailbox, so the scheduler
	 * leaves it idle until an event arrives. */
	struct vm_msg {
		uint32_t kind;
		uint32_t sender;
		uint32_t len;
		char     data[VM_MSG_MAX];
	}             mbox[VM_MAILBOX_MAX];
	int           mbox_head;
	int           mbox_count;
	int           blocked;
	int           sleeping;         /* blocked on a timed sleep, not an event */
	uint64_t      wake_at_ms;       /* monotonic deadline for a timed sleep */

	/* Host-call bindings for the loaded image: import index -> resolved
	 * call, from the builtins and the task's env. */
	struct vm_env *env;
	struct {
		vm_hostcall_fn fn;
		void          *ctx;
	} bound[VM_MAX_IMPORTS];
	int           nbound;
	uint32_t      rng;      /* per-task PRNG state for sys_random */

	struct vm_task *next;   /* run-queue link */
};

struct vm_env {
	struct {
		char           name[VM_ENV_NAMELEN];
		vm_hostcall_fn fn;
		void          *ctx;
	} ent[VM_ENV_MAX];
	int n;
};

/****************************************************************
 * Memory image and bus seam
 *
 * A bounded little-endian RAM block per task. The probe is the enforcement:
 * any access that would leave the image faults, so the callbacks never
 * touch host memory out of range.
 ****************************************************************/

/* Monotonic milliseconds, for timed sleeps. Monotonic so a wall-clock change
 * cannot make a sleeping task hang or fire early. */
static uint64_t
now_ms(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (uint64_t)ts.tv_sec * 1000u + (uint64_t)ts.tv_nsec / 1000000u;
}

static int
in_range(const struct vm_task *t, uint32_t addr, uint32_t size)
{
	return addr < t->ram_size && size <= t->ram_size - addr;
}

static uint32_t
bus_r8(void *ctx, uint32_t addr)
{
	struct vm_task *t = ctx;
	return in_range(t, addr, 1) ? t->ram[addr] : 0;
}

static uint32_t
bus_r16(void *ctx, uint32_t addr)
{
	struct vm_task *t = ctx;
	if (!in_range(t, addr, 2))
		return 0;
	return (uint32_t)t->ram[addr] | ((uint32_t)t->ram[addr + 1] << 8);
}

static uint32_t
bus_r32(void *ctx, uint32_t addr)
{
	struct vm_task *t = ctx;
	if (!in_range(t, addr, 4))
		return 0;
	return (uint32_t)t->ram[addr] |
	       ((uint32_t)t->ram[addr + 1] << 8) |
	       ((uint32_t)t->ram[addr + 2] << 16) |
	       ((uint32_t)t->ram[addr + 3] << 24);
}

static void
bus_w8(void *ctx, uint32_t addr, uint32_t val)
{
	struct vm_task *t = ctx;
	if (in_range(t, addr, 1))
		t->ram[addr] = (uint8_t)val;
}

static void
bus_w16(void *ctx, uint32_t addr, uint32_t val)
{
	struct vm_task *t = ctx;
	if (!in_range(t, addr, 2))
		return;
	t->ram[addr] = (uint8_t)val;
	t->ram[addr + 1] = (uint8_t)(val >> 8);
}

static void
bus_w32(void *ctx, uint32_t addr, uint32_t val)
{
	struct vm_task *t = ctx;
	if (!in_range(t, addr, 4))
		return;
	t->ram[addr] = (uint8_t)val;
	t->ram[addr + 1] = (uint8_t)(val >> 8);
	t->ram[addr + 2] = (uint8_t)(val >> 16);
	t->ram[addr + 3] = (uint8_t)(val >> 24);
}

static int
bus_probe(void *ctx, uint32_t addr, int size, int is_write)
{
	struct vm_task *t = ctx;
	(void)is_write;
	return in_range(t, addr, (uint32_t)size) ? 0 : 1;
}

static void
bus_poke(void *ctx, uint32_t addr, uint8_t byte)
{
	struct vm_task *t = ctx;
	if (in_range(t, addr, 1))
		t->ram[addr] = byte;
}

/****************************************************************
 * Output buffering
 ****************************************************************/

/* Emit complete lines and keep any unterminated remainder. */
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

/* Emit everything, including an unterminated final line. */
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
	uint32_t i;

	for (i = 0; i < len; i++) {
		if (!in_range(t, gaddr + i, 1))
			break;
		if (t->out_len == VM_OUT_BUF)
			flush_all(t);
		t->out[t->out_len++] = (char)t->ram[gaddr + i];
	}
	flush_lines(t);
}

/****************************************************************
 * Host-call argument access
 ****************************************************************/

uint32_t
vm_arg(struct vm_task *t, int i)
{
	if (i < 0 || i > 5)
		return 0;
	return rv_get_x(&t->cpu, 10 + i);       /* a0-a5 are x10-x15 */
}

void
vm_set_ret(struct vm_task *t, uint32_t v)
{
	rv_set_x(&t->cpu, 10, v);               /* result in a0 */
}

uint32_t
vm_read(struct vm_task *t, uint32_t gaddr, void *dst, uint32_t len)
{
	uint32_t n = 0;

	while (n < len && in_range(t, gaddr + n, 1)) {
		((uint8_t *)dst)[n] = t->ram[gaddr + n];
		n++;
	}
	return n;
}

uint32_t
vm_write(struct vm_task *t, uint32_t gaddr, const void *src, uint32_t len)
{
	uint32_t n = 0;

	while (n < len && in_range(t, gaddr + n, 1)) {
		t->ram[gaddr + n] = ((const uint8_t *)src)[n];
		n++;
	}
	return n;
}

uint32_t
vm_arg_cstr(struct vm_task *t, uint32_t gaddr, char *buf, uint32_t bufsz)
{
	uint32_t n = 0;

	if (bufsz == 0)
		return 0;
	while (n + 1 < bufsz && in_range(t, gaddr + n, 1)) {
		char c = (char)t->ram[gaddr + n];
		if (c == 0)
			break;
		buf[n++] = c;
	}
	buf[n] = 0;
	return n;
}

/****************************************************************
 * Builtin host calls
 *
 * The runtime always provides these. They touch only the task itself, so the
 * library stays independent of the game. Each reads its arguments and writes
 * its result through the accessors above.
 ****************************************************************/

static void
bi_exit(struct vm_task *t, void *ctx)
{
	(void)ctx;
	t->exit_status = (int)vm_arg(t, 0);
	t->state = VM_EXITED;
	rv_halt(&t->cpu);
}

static void
bi_write(struct vm_task *t, void *ctx)
{
	/* a0 = fd (ignored), a1 = buffer, a2 = length. */
	uint32_t len = vm_arg(t, 2);
	(void)ctx;
	out_append(t, vm_arg(t, 1), len);
	vm_set_ret(t, len);
}

static void
bi_random(struct vm_task *t, void *ctx)
{
	/* xorshift32; a0 = bound (0 asks for the full 32-bit range). */
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

static void
bi_suspend(struct vm_task *t, void *ctx)
{
	/* Cooperative yield with a wake policy in a0, and for a sleep the span in
	 * a1 (milliseconds). VM_SUSPEND_YIELD parks for one tick and runs again
	 * next tick. VM_SUSPEND_EVENT parks until an event arrives. VM_SUSPEND_SLEEP
	 * parks until a1 ms pass, when vm_task_run delivers a VM_EV_TIMER event;
	 * a real event arriving first wakes it early, so it also serves as the
	 * dwell timer for an idle event loop. Either blocking mode returns at once
	 * if the mailbox already holds an event, so a pending event is never missed. */
	uint32_t mode = vm_arg(t, 0);
	(void)ctx;

	t->sleeping = 0;
	if (mode == VM_SUSPEND_EVENT) {
		if (t->mbox_count == 0) {
			t->blocked = 1;
			t->cpu.waiting = 1;
		}
	} else if (mode == VM_SUSPEND_SLEEP) {
		if (t->mbox_count == 0) {
			t->blocked = 1;
			t->cpu.waiting = 1;
			t->sleeping = 1;
			t->wake_at_ms = now_ms() + vm_arg(t, 1);
		}
	} else {
		t->cpu.waiting = 1;             /* plain yield */
	}
	vm_set_ret(t, 0);
}

/* Pop one event from the mailbox into a guest record. a0 = guest address of the
 * record buffer, a1 = its capacity. The record is little-endian: u32 kind, u32
 * sender, u32 len, then len payload bytes and a NUL. The payload is truncated to
 * fit the buffer. With an empty mailbox it writes a VM_EV_NONE header and
 * returns 0; otherwise it returns the event kind. Non-blocking; a guest that
 * wants to wait pairs this with sys_suspend(VM_SUSPEND_EVENT). */
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

	/* Fit the payload plus its terminator into whatever follows the header. */
	m = &t->mbox[t->mbox_head];
	room = cap > sizeof hdr ? cap - (uint32_t)sizeof hdr : 0;
	if (room > 0)
		room -= 1;               /* leave a byte for the terminator */
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

static const struct {
	const char    *name;
	vm_hostcall_fn fn;
} vm_builtins[] = {
	{ "sys_exit",    bi_exit },
	{ "sys_write",   bi_write },
	{ "sys_random",  bi_random },
	{ "sys_now",     bi_now },
	{ "sys_suspend", bi_suspend },
	{ "sys_getmsg",  bi_getmsg },
};
#define VM_NBUILTIN ((int)(sizeof vm_builtins / sizeof vm_builtins[0]))

/****************************************************************
 * Host-call environment and name binding
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
vm_env_register(struct vm_env *e, const char *name, vm_hostcall_fn fn,
                void *ctx)
{
	int i;

	if (e->n >= VM_ENV_MAX || strlen(name) >= VM_ENV_NAMELEN)
		return -1;
	for (i = 0; i < VM_NBUILTIN; i++)
		if (strcmp(vm_builtins[i].name, name) == 0)
			return -1;             /* a name never shadows a builtin */
	for (i = 0; i < e->n; i++)
		if (strcmp(e->ent[i].name, name) == 0)
			return -1;
	strcpy(e->ent[e->n].name, name);
	e->ent[e->n].fn = fn;
	e->ent[e->n].ctx = ctx;
	e->n++;
	return 0;
}

/* Resolve one import name against the builtins first, then the task's env. */
static void
resolve_import(struct vm_task *t, const char *name,
               vm_hostcall_fn *fn_out, void **ctx_out)
{
	int i;

	*fn_out = NULL;
	*ctx_out = NULL;
	for (i = 0; i < VM_NBUILTIN; i++)
		if (strcmp(name, vm_builtins[i].name) == 0) {
			*fn_out = vm_builtins[i].fn;
			return;
		}
	if (t->env)
		for (i = 0; i < t->env->n; i++)
			if (strcmp(name, t->env->ent[i].name) == 0) {
				*fn_out = t->env->ent[i].fn;
				*ctx_out = t->env->ent[i].ctx;
				return;
			}
}

static uint32_t
le32_at(const uint8_t *p)
{
	return (uint32_t)p[0] | ((uint32_t)p[1] << 8) |
	       ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

/* Bind the guest's imported host calls by name. The image carries a KPIMPT1
 * import table, located by scanning the loaded memory image for its magic
 * rather than by a named ELF section, since the guest assembler cannot emit
 * custom sections. Layout, little-endian: the magic "KPIMPT1\0", a u32 count,
 * then count packed NUL-terminated names. Import index i is reached with
 * a7 = VM_HOSTCALL_BASE + i; the guest toolchain and this loader agree on the
 * order through the table. A name no builtin or env provides binds to NULL and
 * faults the task if it is ever called. An image with no table imports
 * nothing. */
static void
bind_imports(struct vm_task *t)
{
	static const char magic[8] = { 'K', 'P', 'I', 'M', 'P', 'T', '1', '\0' };
	uint32_t base = 0, off, count, i;
	int found = 0;

	memset(t->bound, 0, sizeof t->bound);
	t->nbound = 0;

	for (i = 0; i + 8 <= t->ram_size; i++)
		if (memcmp(t->ram + i, magic, 8) == 0) {
			base = i;
			found = 1;
			break;
		}
	if (!found || base + 12 > t->ram_size)
		return;

	count = le32_at(t->ram + base + 8);
	if (count > VM_MAX_IMPORTS)
		count = VM_MAX_IMPORTS;

	off = base + 12;
	for (i = 0; i < count; i++) {
		char name[VM_ENV_NAMELEN];
		uint32_t k = 0;

		if (off >= t->ram_size)
			break;                  /* truncated table */
		while (off < t->ram_size && t->ram[off] != 0) {
			if (k + 1 < sizeof name)
				name[k++] = (char)t->ram[off];
			off++;
		}
		if (off >= t->ram_size)
			break;                  /* unterminated name */
		off++;                          /* past the NUL */
		name[k] = 0;
		resolve_import(t, name, &t->bound[i].fn, &t->bound[i].ctx);
	}
	t->nbound = (int)i;
}

/****************************************************************
 * ECALL dispatch
 ****************************************************************/

static int
vm_ecall(rv_cpu *cpu, void *ctx)
{
	struct vm_task *t = ctx;
	uint32_t sel = rv_get_x(cpu, 17);       /* a7 */

	if (sel >= VM_HOSTCALL_BASE) {
		uint32_t idx = sel - VM_HOSTCALL_BASE;

		if (idx < (uint32_t)t->nbound && t->bound[idx].fn) {
			t->bound[idx].fn(t, t->bound[idx].ctx);
			return 0;
		}
		/* An unbound or out-of-range call is an observable failure, not a
		 * silent no-op: the task faults so the host can sweep it up. */
		t->exit_status = 127;
		t->state = VM_FAULTED;
		rv_halt(cpu);
		return 0;
	}

	if (sel == VM_SYS_TRAP) {               /* a guest runtime fault */
		t->state = VM_FAULTED;
		rv_halt(cpu);
		return 0;
	}

	/* No raw Linux-number path: every service is name-bound. An unknown
	 * low selector is an illegal call. */
	t->state = VM_FAULTED;
	rv_halt(cpu);
	return 0;
}

/****************************************************************
 * Task lifecycle
 ****************************************************************/

static uint32_t g_next_id = 1;

struct vm_task *
vm_task_new(uint32_t mem_size)
{
	struct vm_task *t;

	if (mem_size == 0)
		mem_size = VM_MEM_DEFAULT;

	t = calloc(1, sizeof(*t));
	if (!t)
		return NULL;
	t->ram = calloc(1, mem_size);
	if (!t->ram) {
		free(t);
		return NULL;
	}
	t->ram_size = mem_size;
	t->id = g_next_id++;
	t->state = VM_READY;
	t->rng = t->id * 2654435761u + 1;       /* nonzero xorshift seed */

	rv_init(&t->cpu, bus_r8, bus_r16, bus_r32, bus_w8, bus_w16, bus_w32, t);
	rv_set_probe(&t->cpu, bus_probe);
	rv_set_ecall(&t->cpu, vm_ecall, t);
	return t;
}

void
vm_task_free(struct vm_task *t)
{
	if (!t)
		return;
	flush_all(t);
	free(t->ram);
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

/* Ready the CPU at entry and seed a stack pointer at the top of the image.
 * The full argument block (argc/argv) is written by the dispatch path in a
 * later card; a one-shot program with no arguments needs only a stack. */
static void
ready_at(struct vm_task *t, uint32_t entry)
{
	rv_reset(&t->cpu, entry);
	rv_set_x(&t->cpu, 2, t->ram_size & ~15u);   /* sp, 16-byte aligned */
	t->state = VM_READY;
	t->exit_status = 0;
}

/* Load the PT_LOAD segments into the image, bind the host-call imports from
 * the same file bytes, and ready the CPU at the entry point. */
static int
load_common(struct vm_task *t, const uint8_t *buf, long size, const char *what)
{
	elf32_info info;
	uint32_t entry;

	memset(&info, 0, sizeof(info));
	entry = elf32_load_raw_mem(buf, size, bus_poke, t, what, &info);
	if (entry == 0)
		return -1;
	bind_imports(t);
	ready_at(t, entry);
	return 0;
}

int
vm_task_load_mem(struct vm_task *t, const uint8_t *buf, long size,
                 const char *what)
{
	return load_common(t, buf, size, what);
}

/* Read a whole file into a freshly allocated buffer, or NULL with a message. */
static uint8_t *
read_file(const char *path, long *size)
{
	FILE *f = fopen(path, "rb");
	uint8_t *buf;
	long n;

	if (!f) {
		fprintf(stderr, "vm: cannot open %s\n", path);
		return NULL;
	}
	if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0) {
		fclose(f);
		fprintf(stderr, "vm: cannot size %s\n", path);
		return NULL;
	}
	rewind(f);
	buf = malloc((size_t)n);
	if (!buf) {
		fclose(f);
		return NULL;
	}
	if (fread(buf, 1, (size_t)n, f) != (size_t)n) {
		fclose(f);
		free(buf);
		fprintf(stderr, "vm: short read on %s\n", path);
		return NULL;
	}
	fclose(f);
	*size = n;
	return buf;
}

int
vm_task_load_file(struct vm_task *t, const char *path)
{
	uint8_t *buf;
	long size;
	int rc;

	buf = read_file(path, &size);
	if (!buf)
		return -1;
	rc = load_common(t, buf, size, path);
	free(buf);
	return rc;
}

int
vm_task_set_args(struct vm_task *t, const char *const *argv, int argc)
{
	uint32_t sp = rv_get_x(&t->cpu, 2);     /* current top of stack */
	uint32_t ptrs[VM_MAX_ARGS];
	uint32_t argv_addr;
	int i;

	if (argc < 0)
		argc = 0;
	if (argc > VM_MAX_ARGS)
		return -1;

	/* Strings first, growing down from the top. */
	for (i = argc - 1; i >= 0; i--) {
		uint32_t len = (uint32_t)strlen(argv[i]) + 1;
		if (len > sp)
			return -1;
		sp -= len;
		if (vm_write(t, sp, argv[i], len) != len)
			return -1;
		ptrs[i] = sp;
	}

	/* Then the NULL-terminated pointer array, word-aligned. */
	sp &= ~3u;
	if (sp < (uint32_t)(argc + 1) * 4)
		return -1;
	sp -= 4;
	bus_w32(t, sp, 0);                      /* argv[argc] = NULL */
	for (i = argc - 1; i >= 0; i--) {
		sp -= 4;
		bus_w32(t, sp, ptrs[i]);
	}
	argv_addr = sp;

	sp &= ~15u;                             /* keep the stack 16-aligned */
	rv_set_x(&t->cpu, 2, sp);               /* sp */
	rv_set_x(&t->cpu, 10, (uint32_t)argc);  /* a0 = argc */
	rv_set_x(&t->cpu, 11, argv_addr);       /* a1 = argv */
	return 0;
}

int
vm_task_set_typed_args(struct vm_task *t, const struct vm_typed_arg *args,
                       int n)
{
	uint32_t sp = rv_get_x(&t->cpu, 2);     /* current top of stack */
	uint32_t values[VM_MAX_ARGS];
	uint32_t array_addr;
	int i;

	if (n < 0)
		n = 0;
	if (n > VM_MAX_ARGS)
		return -1;

	/* String payloads first, growing down from the top; a non-string slot
	 * carries its integer value (a handle) verbatim. */
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

	/* Then the slot array: n pairs of {type, value}, word-aligned. */
	sp &= ~3u;
	if (sp < (uint32_t)n * 8)
		return -1;
	for (i = n - 1; i >= 0; i--) {
		sp -= 4;
		bus_w32(t, sp, values[i]);
		sp -= 4;
		bus_w32(t, sp, args[i].type);
	}
	array_addr = sp;

	sp &= ~15u;                             /* keep the stack 16-aligned */
	rv_set_x(&t->cpu, 2, sp);               /* sp */
	rv_set_x(&t->cpu, 10, (uint32_t)n);     /* a0 = slot count */
	rv_set_x(&t->cpu, 11, array_addr);      /* a1 = slot array */
	return 0;
}

enum vm_state
vm_task_run(struct vm_task *t, int quantum)
{
	enum rv_run_reason reason;

	if (t->state != VM_READY)
		return t->state;

	/* A parked task burns no cycles until it is woken. A timed sleep wakes
	 * itself: once its deadline passes, it delivers a timer event to its own
	 * mailbox, which clears the block. Any other parked task waits for an
	 * external vm_task_post. */
	if (t->blocked) {
		if (t->sleeping && now_ms() >= t->wake_at_ms) {
			t->sleeping = 0;
			vm_task_post(t, VM_EV_TIMER, 0, NULL, 0);
		} else {
			return VM_READY;
		}
	}

	/* Resume a task that parked on wfi last tick. The core does not clear
	 * the wait bit itself; the scheduler owns the wake decision, and for a
	 * plain yield that decision is "run again now". */
	t->cpu.waiting = 0;

	/* One batched run per quantum. The core returns the reason it stopped,
	 * so the runtime never steps instruction by instruction and the same
	 * path works when a JIT backend replaces the interpreter. */
	reason = rv_run(&t->cpu, quantum, NULL);

	switch (reason) {
	case RV_RUN_HALT:
		/* The exit host-call sets VM_EXITED before halting; a halt
		 * without it is a double fault. */
		if (t->state != VM_EXITED)
			t->state = VM_FAULTED;
		break;
	case RV_RUN_TRAP:
		/* No guest trap handler in this cut: a stray access or an
		 * illegal instruction kills the task rather than spinning in a
		 * vector it does not have. */
		t->state = VM_FAULTED;
		break;
	case RV_RUN_YIELD:
		/* Cooperative yield (wfi). The task stays runnable and resumes
		 * next tick, unless sys_suspend also set the mailbox block, in
		 * which case the check at the top of the next run keeps it parked
		 * until an event arrives. sys_suspend's sleep-for-a-span policy is
		 * still a later card. */
		break;
	case RV_RUN_BUDGET:
		break;                  /* still runnable next tick */
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
 * Mailbox
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

	/* A delivery wakes a task parked on an empty mailbox, cancelling a pending
	 * sleep so its stale deadline cannot fire a spurious timer later. */
	t->blocked = 0;
	t->sleeping = 0;
	return 0;
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
 * Cooperative scheduler
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

		/* Reap: unlink and free the finished task. */
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
