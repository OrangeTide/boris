/* test_vm.c : unit tests for the RV32 task runtime and scheduler */

#include "vm.h"

#include <elf32.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "ctest.h"

/****************************************************************
 * ELF builder
 *
 * Wrap a segment of guest bytes in a minimal ELF32 little-endian RISC-V
 * executable: one PT_LOAD at 0x1000 holding the code. A host call is reached
 * from guest code with a7 = VM_HOSTCALL_BASE + a fixed VM_CALL_* selector.
 * Building images inline keeps the tests self-contained, with no toolchain.
 ****************************************************************/

#define LOAD_VADDR 0x1000u

static void
le16(uint8_t *p, uint16_t v)
{
	p[0] = (uint8_t)v;
	p[1] = (uint8_t)(v >> 8);
}

static void
le32(uint8_t *p, uint32_t v)
{
	p[0] = (uint8_t)v;
	p[1] = (uint8_t)(v >> 8);
	p[2] = (uint8_t)(v >> 16);
	p[3] = (uint8_t)(v >> 24);
}

/* Emit "set a7 = VM_HOSTCALL_BASE + sel, then ecall" at seg+o; return the new
 * offset. sel is a fixed VM_CALL_* selector. VM_HOSTCALL_BASE is 0x00100000,
 * which is lui a7, 0x100. */
static uint32_t
emit_call(uint8_t *seg, uint32_t o, uint32_t sel)
{
	le32(seg + o, 0x001008B7u);             /* lui  a7, 0x100 */
	o += 4;
	if (sel) {
		le32(seg + o, 0x00088893u | (sel << 20));  /* addi a7, a7, sel */
		o += 4;
	}
	le32(seg + o, 0x00000073u);             /* ecall */
	return o + 4;
}

/* Emit "set a7 = nr, then ecall" at seg+o for a raw Linux-number syscall (the
 * Tier-0 seam, not the host-call table). nr must fit a 12-bit immediate.
 * addi a7, x0, nr is 0x00000893 | (nr << 20). Returns the new offset. */
static uint32_t
emit_syscall(uint8_t *seg, uint32_t o, uint32_t nr)
{
	le32(seg + o, 0x00000893u | (nr << 20));        /* addi a7, x0, nr */
	o += 4;
	le32(seg + o, 0x00000073u);                     /* ecall */
	return o + 4;
}

/* Assemble the full image. Returns its total length. Host calls reach the
 * runtime by fixed selector (emit_call), so the image carries code only: no
 * import table. */
static long
build_prog(uint8_t *buf, const uint8_t *seg, uint32_t seglen)
{
	uint8_t *eh = buf;
	uint8_t *ph = buf + 52;
	uint32_t code_off = 84;
	uint8_t *body = buf + code_off;
	uint32_t total;

	memcpy(body, seg, seglen);
	total = seglen;

	/* ELF header and the one program header. No section headers: the loader
	 * reads only program headers, and the guest assembler cannot emit the
	 * sections anyway. */
	memset(eh, 0, 84);
	eh[0] = 0x7f; eh[1] = 'E'; eh[2] = 'L'; eh[3] = 'F';
	eh[4] = 1;                      /* ELFCLASS32 */
	eh[5] = 1;                      /* ELFDATA2LSB */
	eh[6] = 1;                      /* EI_VERSION */
	le16(eh + 16, 2);               /* e_type = ET_EXEC */
	le16(eh + 18, EM_RISCV);        /* e_machine */
	le32(eh + 20, 1);               /* e_version */
	le32(eh + 24, LOAD_VADDR);      /* e_entry */
	le32(eh + 28, 52);              /* e_phoff */
	le16(eh + 40, 52);              /* e_ehsize */
	le16(eh + 42, 32);              /* e_phentsize */
	le16(eh + 44, 1);               /* e_phnum */

	le32(ph + 0, 1);                /* p_type = PT_LOAD */
	le32(ph + 4, code_off);         /* p_offset */
	le32(ph + 8, LOAD_VADDR);       /* p_vaddr */
	le32(ph + 12, LOAD_VADDR);      /* p_paddr */
	le32(ph + 16, total);           /* p_filesz */
	le32(ph + 20, total);           /* p_memsz */
	le32(ph + 24, 4 | 1);           /* p_flags = PF_R | PF_X */
	le32(ph + 28, LOAD_VADDR);      /* p_align */

	return (long)(code_off + total);
}

/* A program that imports sys_exit and exits with a status (status must fit a
 * 12-bit immediate). */
static long
build_exit_elf(uint8_t *buf, uint32_t status)
{
	uint8_t seg[16];
	uint32_t o = 0;

	le32(seg + o, 0x00000513u | (status << 20));    /* addi a0, x0, status */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);                        /* sys_exit */
	return build_prog(buf, seg, o);
}

/****************************************************************
 * Output capture
 ****************************************************************/

struct outbuf {
	char   data[256];
	size_t len;
};

static void
capture(void *ctx, const char *buf, size_t len)
{
	struct outbuf *o = ctx;
	if (o->len + len > sizeof o->data)
		len = sizeof o->data - o->len;
	memcpy(o->data + o->len, buf, len);
	o->len += len;
}

/****************************************************************
 * A registered (non-builtin) host call, for the env tests.
 ****************************************************************/

static void
echo_plus1(struct vm_task *t, void *ctx)
{
	(void)ctx;
	vm_set_ret(t, vm_arg(t, 0) + 1);
}

/****************************************************************
 * Tests
 ****************************************************************/

/* A one-shot program runs to completion and reports its exit status. */
static void
test_oneshot_exit(void)
{
	uint8_t elf[512];
	long len = build_exit_elf(elf, 42);
	struct vm_task *t = vm_task_new(0);

	EXPECT(t != NULL, "task allocated");
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<exit>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 42, "exit status is 42");
	vm_task_free(t);
}

/* A program's sys_write reaches the bound output sink, buffered by line. */
static void
test_write_output(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o, dataoff;
	long len;
	struct outbuf out = { .len = 0 };
	struct vm_task *t;

	le32(seg + 0, 0x000015B7u);     /* lui  a1, 1     -> a1 = 0x1000 */
	le32(seg + 4, 0x00058593u);     /* addi a1, a1, 0 (offset patched below) */
	le32(seg + 8, 0x00100513u);     /* addi a0, x0, 1 (fd) */
	le32(seg + 12, 0x00300613u);    /* addi a2, x0, 3 (len) */
	o = 16;
	o = emit_call(seg, o, VM_CALL_WRITE);       /* sys_write */
	le32(seg + o, 0x00000513u);     /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	dataoff = o;
	seg[o++] = 'h';
	seg[o++] = 'i';
	seg[o++] = '\n';
	le32(seg + 4, 0x00058593u | (dataoff << 20));   /* a1 = 0x1000 + dataoff */

	len = build_prog(elf, seg, o);
	t = vm_task_new(0);
	vm_task_set_output(t, capture, &out);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<write>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(out.len, 3, "three bytes of output captured");
	EXPECT(out.len == 3 && memcmp(out.data, "hi\n", 3) == 0,
	       "output is the written line");
	vm_task_free(t);
}

/* A spinning program is preempted by the instruction cap, not run forever. */
static void
test_instruction_cap(void)
{
	uint8_t seg[4];
	uint8_t elf[512];
	long len;
	struct vm_task *t;

	le32(seg + 0, 0x0000006Fu);     /* jal x0, 0  -> jump to self */
	len = build_prog(elf, seg, sizeof seg);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<spin>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 500), VM_READY, "cap returns control, task alive");
	EXPECT_EQ(vm_task_run(t, 500), VM_READY, "still runnable after another cap");
	vm_task_free(t);
}

/* An out-of-range access faults the task rather than corrupting the host. */
static void
test_fault(void)
{
	uint8_t seg[8];
	uint8_t elf[512];
	long len;
	struct vm_task *t;

	le32(seg + 0, 0x400002B7u);     /* lui x5, 0x40000 -> x5 = 0x40000000 */
	le32(seg + 4, 0x0002A023u);     /* sw  x0, 0(x5)   -> out of range    */
	len = build_prog(elf, seg, sizeof seg);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<fault>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_FAULTED, "stray store faults the task");
	vm_task_free(t);
}

/* A selector no one serves faults the task when called, rather than passing
 * silently. A game selector with no env bound is the natural unserved call. */
static void
test_unbound_call(void)
{
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o;
	long len;
	struct vm_task *t;

	o = emit_call(seg, 0, VM_CALL_GETPROP);
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<unbound>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_FAULTED, "unserved call faults the task");
	vm_task_free(t);
}

/* A host call registered in a vm_env at a game selector runs. */
static void
test_env_call(void)
{
	uint8_t seg[32];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_env *env;
	struct vm_task *t;

	le32(seg + o, 0x02900513u);     /* addi a0, x0, 41 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_GETPROP);  /* echo -> a0 = 42 */
	o = emit_call(seg, o, VM_CALL_EXIT);     /* sys_exit with a0 = 42 */
	len = build_prog(elf, seg, o);

	env = vm_env_new();
	EXPECT_EQ(vm_env_register(env, VM_CALL_GETPROP, echo_plus1, NULL), 0,
	          "registered a host call");
	EXPECT_EQ(vm_env_register(env, VM_CALL_EXIT, echo_plus1, NULL), -1,
	          "cannot register a builtin selector");

	t = vm_task_new(0);
	vm_task_set_env(t, env);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<env>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 42, "env call returned arg + 1");
	vm_task_free(t);
	vm_env_free(env);
}

/* sys_random returns a value within the requested bound. */
static void
test_random(void)
{
	uint8_t seg[32];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x06400513u);     /* addi a0, x0, 100 (bound) */
	o += 4;
	o = emit_call(seg, o, VM_CALL_RANDOM);       /* sys_random -> a0 in [0,100) */
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit with that value */
	len = build_prog(elf, seg, o);

	t = vm_task_new(0);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<random>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT(vm_task_exit_status(t) >= 0 && vm_task_exit_status(t) < 100,
	       "random value is within the bound");
	vm_task_free(t);
}

/* sys_now returns a nonzero timestamp. */
static void
test_now(void)
{
	uint8_t seg[24];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	o = emit_call(seg, o, VM_CALL_NOW);       /* sys_now -> a0 = seconds */
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit with that value */
	len = build_prog(elf, seg, o);

	t = vm_task_new(0);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<now>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT(vm_task_exit_status(t) != 0, "timestamp is nonzero");
	vm_task_free(t);
}

/* argc reaches main in a0: a program that exits with a0 reports it. */
static void
test_argc(void)
{
	static const char *const argv[] = { "a", "bb", "ccc" };
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o;
	long len;
	struct vm_task *t;

	o = emit_call(seg, 0, VM_CALL_EXIT);       /* sys_exit with a0 = argc */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<argc>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_args(t, argv, 3), 0, "argument block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 3, "exit status is argc");
	vm_task_free(t);
}

/* argv strings reach the guest: the program writes argv[0] to its output. */
static void
test_argv_strings(void)
{
	static const char *const argv[] = { "hi\n" };
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct outbuf out = { .len = 0 };
	struct vm_task *t;

	le32(seg + o, 0x0005A583u);     /* lw   a1, 0(a1) -> a1 = argv[0] */
	o += 4;
	le32(seg + o, 0x00100513u);     /* addi a0, x0, 1 (fd) */
	o += 4;
	le32(seg + o, 0x00300613u);     /* addi a2, x0, 3 (len) */
	o += 4;
	o = emit_call(seg, o, VM_CALL_WRITE);       /* sys_write */
	le32(seg + o, 0x00000513u);     /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);

	t = vm_task_new(0);
	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<argv>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_args(t, argv, 1), 0, "argument block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT(out.len == 3 && memcmp(out.data, "hi\n", 3) == 0,
	       "guest read and wrote argv[0]");
	vm_task_free(t);
}

/* The Linux initial stack: argc sits at [sp] and the argv pointers at [sp+4].
 * A program that reads argc off the stack reports it, independent of a0. */
static void
test_initial_stack_argc(void)
{
	static const char *const argv[] = { "p", "q", "r", "s" };
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00012503u); o += 4;     /* lw a0, 0(sp)  -> a0 = argc */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit(argc) */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stack-argc>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_args(t, argv, 4), 0, "argument block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 4, "argc read off the stack at sp");
	vm_task_free(t);
}

/* The argv pointers at [sp+4] point at the argv strings: exit with argv[0][0]. */
static void
test_initial_stack_argv(void)
{
	static const char *const argv[] = { "Zed", "x" };
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00412583u); o += 4;     /* lw  a1, 4(sp)  -> a1 = argv[0] ptr */
	le32(seg + o, 0x0005C503u); o += 4;     /* lbu a0, 0(a1)  -> a0 = argv[0][0] */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit(argv[0][0]) */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stack-argv>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_args(t, argv, 2), 0, "argument block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 'Z',
	          "argv[0] pointer off the stack reaches the string");
	vm_task_free(t);
}

/* The verb entry ABI: vm_task_set_typed_args writes a0 = slot count and a1 =
 * the slot array. These tags are opaque to the VM; the verb layer and the SDK
 * runtime agree on their meaning (1 = object handle, 2 = string pointer). */
#define TA_OBJ 1u
#define TA_STR 2u

/* a0 carries the slot count, the way argc does for a plain program. */
static void
test_typed_args_count(void)
{
	struct vm_typed_arg args[] = {
		{ .type = TA_OBJ, .ival = 42 },
		{ .type = TA_STR, .str = "x" },
	};
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o;
	long len;
	struct vm_task *t;

	o = emit_call(seg, 0, VM_CALL_EXIT);       /* sys_exit with a0 = slot count */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<ta_count>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_typed_args(t, args, 2), 0, "typed block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 2, "exit status is the slot count");
	vm_task_free(t);
}

/* Each slot is {u32 type, u32 value}: value sits at offset 4 in the slot. The
 * program reads the first slot's value (a handle) and exits with it. */
static void
test_typed_args_handle(void)
{
	struct vm_typed_arg args[] = {
		{ .type = TA_OBJ, .ival = 42 },
		{ .type = TA_STR, .str = "x" },
	};
	uint8_t seg[32];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x0045A503u);     /* lw   a0, 4(a1) -> slot[0].value */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit with that handle */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<ta_handle>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_typed_args(t, args, 2), 0, "typed block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 42, "exit status is the slot handle");
	vm_task_free(t);
}

/* A string slot's value is a guest pointer to the copied bytes. The program
 * loads the first slot's value and writes the string it points at. */
static void
test_typed_args_string(void)
{
	struct vm_typed_arg args[] = {
		{ .type = TA_STR, .str = "hi\n" },
	};
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct outbuf out = { .len = 0 };
	struct vm_task *t;

	le32(seg + o, 0x0045A583u);     /* lw   a1, 4(a1) -> slot[0].value (ptr) */
	o += 4;
	le32(seg + o, 0x00100513u);     /* addi a0, x0, 1 (fd) */
	o += 4;
	le32(seg + o, 0x00300613u);     /* addi a2, x0, 3 (len) */
	o += 4;
	o = emit_call(seg, o, VM_CALL_WRITE);       /* sys_write */
	le32(seg + o, 0x00000513u);     /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);

	t = vm_task_new(0);
	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<ta_string>"), 0, "loaded image");
	EXPECT_EQ(vm_task_set_typed_args(t, args, 1), 0, "typed block written");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT(out.len == 3 && memcmp(out.data, "hi\n", 3) == 0,
	       "guest read and wrote the string slot");
	vm_task_free(t);
}

/* The scheduler steps ready tasks and reaps the ones that finish. */
static void
test_scheduler_reap(void)
{
	uint8_t a[512], b[512];
	long la = build_exit_elf(a, 1);
	long lb = build_exit_elf(b, 2);
	struct vm_sched *s = vm_sched_new();
	struct vm_task *ta = vm_task_new(0);
	struct vm_task *tb = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(ta, a, la, "<a>"), 0, "loaded task a");
	EXPECT_EQ(vm_task_load_mem(tb, b, lb, "<b>"), 0, "loaded task b");
	vm_sched_add(s, ta);
	vm_sched_add(s, tb);
	EXPECT_EQ(vm_sched_count(s), 2, "two tasks queued");

	EXPECT_EQ(vm_sched_tick(s, 1000), 0, "both tasks reaped in one tick");
	EXPECT_EQ(vm_sched_count(s), 0, "queue is empty");
	vm_sched_free(s);
}

/* A pre-built ELF loaded from a file runs end to end. */
static void
test_load_file(void)
{
	uint8_t elf[512];
	long len = build_exit_elf(elf, 7);
	char path[] = "/tmp/boris-vm-XXXXXX";
	int fd = mkstemp(path);
	struct vm_task *t;

	if (fd < 0) {
		FAIL("could not create a temp file for the ELF");
		return;
	}
	if (write(fd, elf, (size_t)len) != len) {
		close(fd);
		unlink(path);
		FAIL("short write building the temp ELF");
		return;
	}
	close(fd);

	t = vm_task_new(0);
	EXPECT_EQ(vm_task_load_file(t, path), 0, "loaded a pre-built ELF file");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 7, "exit status is 7");
	vm_task_free(t);
	unlink(path);
}

/* A task that parks on wfi yields, stays runnable, and resumes next run. */
static void
test_yield_resume(void)
{
	uint8_t seg[24];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x10500073u);     /* wfi */
	o += 4;
	le32(seg + o, 0x00500513u);     /* addi a0, x0, 5 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<yield>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY,
	          "task yields on wfi and stays runnable");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "resumes and runs to exit");
	EXPECT_EQ(vm_task_exit_status(t), 5, "exit status after resume is 5");
	vm_task_free(t);
}

/* sys_suspend(VM_SUSPEND_YIELD) is the canonical cooperative yield: it parks
 * the task through the host-call ABI, and the task resumes on the next run.
 * (a0 is 0 at the call, so this is the yield case.) */
static void
test_suspend_resume(void)
{
	uint8_t seg[24];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	o = emit_call(seg, o, VM_CALL_SUSPEND);       /* sys_suspend -> yield */
	le32(seg + o, 0x00500513u);     /* addi a0, x0, 5 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<suspend>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY,
	          "task suspends and stays runnable");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "resumes and runs to exit");
	EXPECT_EQ(vm_task_exit_status(t), 5, "exit status after resume is 5");
	vm_task_free(t);
}

/* sys_suspend(VM_SUSPEND_SLEEP, 0): with a zero span the deadline is already
 * past, so the next run delivers a timer event and the task drains it. A zero
 * span keeps the fire deterministic without leaning on the wall clock. */
static void
test_suspend_sleep_fires(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00200513u); o += 4;     /* addi a0, x0, 2 (SLEEP) */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (0 ms) */
	o = emit_call(seg, o, VM_CALL_SUSPEND);               /* sys_suspend -> sleeps */
	le32(seg + o, 0x00002537u); o += 4;     /* lui  a0, 2 */
	le32(seg + o, 0x04000593u); o += 4;     /* addi a1, x0, 64 */
	o = emit_call(seg, o, VM_CALL_GETMSG);               /* sys_getmsg -> a0 = kind */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<sleep0>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "task sleeps and parks");
	EXPECT(vm_task_blocked(t), "parked while sleeping");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "deadline fires, task resumes");
	EXPECT_EQ(vm_task_exit_status(t), VM_EV_TIMER, "woke on a timer event");
	vm_task_free(t);
}

/* A sleep with a long span stays parked: its deadline does not fire soon. */
static void
test_suspend_sleep_pending(void)
{
	uint8_t seg[32];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00200513u); o += 4;     /* addi a0, x0, 2 (SLEEP) */
	le32(seg + o, 0x001005B7u); o += 4;     /* lui  a1, 0x100 (~1048 s) */
	o = emit_call(seg, o, VM_CALL_SUSPEND);               /* sys_suspend -> long sleep */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit (not reached) */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<sleepN>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "task sleeps and parks");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "still parked before the deadline");
	EXPECT(vm_task_blocked(t), "a long sleep stays blocked");
	vm_task_free(t);
}

/* A real event preempts a sleep: the task wakes early with that event, not a
 * timer. */
static void
test_suspend_sleep_event_wake(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00200513u); o += 4;     /* addi a0, x0, 2 (SLEEP) */
	le32(seg + o, 0x001005B7u); o += 4;     /* lui  a1, 0x100 (~1048 s) */
	o = emit_call(seg, o, VM_CALL_SUSPEND);               /* sys_suspend -> long sleep */
	le32(seg + o, 0x00002537u); o += 4;     /* lui  a0, 2 */
	le32(seg + o, 0x04000593u); o += 4;     /* addi a1, x0, 64 */
	o = emit_call(seg, o, VM_CALL_GETMSG);               /* sys_getmsg -> a0 = kind */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<sleepev>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "task sleeps and parks");
	EXPECT_EQ(vm_task_post(t, VM_EV_USER, 0, "x", 1), 0, "a real event arrives");
	EXPECT(!vm_task_blocked(t), "the event woke it early");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "resumes and drains the event");
	EXPECT_EQ(vm_task_exit_status(t), VM_EV_USER, "woke on the event, not a timer");
	vm_task_free(t);
}

/* Emit the getmsg preamble "a0 = 0x2000 record buffer, a1 = 64 capacity" at
 * seg+o and return the new offset. The record lands at guest 0x2000, its
 * payload at 0x200c. */
static uint32_t
emit_getmsg_setup(uint8_t *seg, uint32_t o)
{
	le32(seg + o, 0x00002537u);     /* lui  a0, 2      -> a0 = 0x2000 */
	o += 4;
	le32(seg + o, 0x04000593u);     /* addi a1, x0, 64 -> a1 = 64 */
	return o + 4;
}

/* A delivered event reaches the guest: sys_getmsg returns its kind. */
static void
test_mailbox_deliver(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o;
	long len;
	struct vm_task *t;

	o = emit_getmsg_setup(seg, 0);
	o = emit_call(seg, o, VM_CALL_GETMSG);       /* sys_getmsg -> a0 = kind */
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit with that kind */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<mail>"), 0, "loaded image");
	EXPECT_EQ(vm_task_post(t, VM_EV_USER, 7, "hi", 2), 0, "event posted");
	EXPECT_EQ(vm_task_msgs(t), 1, "one event queued");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), VM_EV_USER, "getmsg reports the kind");
	EXPECT_EQ(vm_task_msgs(t), 0, "mailbox drained");
	vm_task_free(t);
}

/* sys_getmsg on an empty mailbox reports VM_EV_NONE rather than blocking. */
static void
test_mailbox_empty(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o;
	long len;
	struct vm_task *t;

	o = emit_getmsg_setup(seg, 0);
	o = emit_call(seg, o, VM_CALL_GETMSG);       /* sys_getmsg on empty -> a0 = 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<empty>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), VM_EV_NONE, "empty mailbox reads NONE");
	vm_task_free(t);
}

/* sys_suspend(VM_SUSPEND_EVENT) blocks on an empty mailbox; the scheduler
 * leaves the task idle until vm_task_post wakes it, and it then drains. */
static void
test_mailbox_block_wake(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00100513u);     /* addi a0, x0, 1 (VM_SUSPEND_EVENT) */
	o += 4;
	o = emit_call(seg, o, VM_CALL_SUSPEND);       /* sys_suspend -> blocks, mailbox empty */
	o = emit_getmsg_setup(seg, o);
	o = emit_call(seg, o, VM_CALL_GETMSG);       /* sys_getmsg -> a0 = kind */
	o = emit_call(seg, o, VM_CALL_EXIT);       /* sys_exit */
	len = build_prog(elf, seg, o);
	t = vm_task_new(0);

	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<block>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "task blocks on empty mailbox");
	EXPECT(vm_task_blocked(t), "task is parked waiting for an event");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "stays parked with no event");
	EXPECT(vm_task_blocked(t), "still parked after an idle tick");

	EXPECT_EQ(vm_task_post(t, VM_EV_ENTER, 0, NULL, 0), 0, "event posted");
	EXPECT(!vm_task_blocked(t), "post cleared the block");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "resumes and runs to exit");
	EXPECT_EQ(vm_task_exit_status(t), VM_EV_ENTER, "drained the posted event");
	vm_task_free(t);
}

/* Events drain in FIFO order and their payloads marshal into guest memory:
 * two one-byte payloads come back concatenated in order. */
static void
test_mailbox_fifo(void)
{
	uint8_t seg[128];
	uint8_t elf[512];
	uint32_t o = 0;
	int i;
	long len;
	struct outbuf out = { .len = 0 };
	struct vm_task *t;

	for (i = 0; i < 2; i++) {
		o = emit_getmsg_setup(seg, o);
		o = emit_call(seg, o, VM_CALL_GETMSG);               /* sys_getmsg */
		le32(seg + o, 0x000025B7u);             /* lui  a1, 2 */
		o += 4;
		le32(seg + o, 0x00C58593u);             /* addi a1, a1, 12 -> payload */
		o += 4;
		le32(seg + o, 0x00100513u);             /* addi a0, x0, 1 (fd) */
		o += 4;
		le32(seg + o, 0x00100613u);             /* addi a2, x0, 1 (len) */
		o += 4;
		o = emit_call(seg, o, VM_CALL_WRITE);               /* sys_write one payload byte */
	}
	le32(seg + o, 0x00000513u);             /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit */
	len = build_prog(elf, seg, o);

	t = vm_task_new(0);
	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<fifo>"), 0, "loaded image");
	EXPECT_EQ(vm_task_post(t, VM_EV_USER, 0, "A", 1), 0, "first event posted");
	EXPECT_EQ(vm_task_post(t, VM_EV_USER, 0, "B", 1), 0, "second event posted");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT(out.len == 2 && memcmp(out.data, "AB", 2) == 0,
	       "payloads drain in FIFO order");
	vm_task_free(t);
}

/* The mailbox is bounded: once full, further posts are rejected. */
static void
test_mailbox_full(void)
{
	struct vm_task *t = vm_task_new(0);
	int i, rc = 0;

	for (i = 0; i < 16; i++)
		rc |= vm_task_post(t, VM_EV_WAKE, 0, NULL, 0);
	EXPECT_EQ(rc, 0, "sixteen events accepted");
	EXPECT_EQ(vm_task_post(t, VM_EV_WAKE, 0, NULL, 0), -1,
	          "a full mailbox rejects the next event");
	EXPECT_EQ(vm_task_msgs(t), 16, "count is capped at the bound");
	vm_task_free(t);
}

/* sys_brk over the raw Linux seam: query the base with brk(0), then grow it by
 * 0x80 and report the delta as the exit status. A served brk returns the new
 * break, so the delta is exactly 0x80 (128). */
static void
test_brk(void)
{
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	struct vm_task *t;

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0  (brk query)    */
	o = emit_syscall(seg, o, 214);          /* sys_brk -> a0 = base           */
	le32(seg + o, 0x00050413u); o += 4;     /* addi s0, a0, 0  (s0 = base)    */
	le32(seg + o, 0x08040513u); o += 4;     /* addi a0, s0, 0x80 (want base+128) */
	o = emit_syscall(seg, o, 214);          /* sys_brk -> a0 = new break      */
	le32(seg + o, 0x40850533u); o += 4;     /* sub  a0, a0, s0 (a0 = delta)   */
	le32(seg + o, 0x0ff57513u); o += 4;     /* andi a0, a0, 0xff              */
	o = emit_syscall(seg, o, 93);           /* sys_exit(delta & 0xff)         */

	len = build_prog(elf, seg, o);
	t = vm_task_new(0);
	EXPECT(t != NULL, "task allocated");
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<brk>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(vm_task_exit_status(t), 0x80,
	          "brk grew by the requested 128 bytes");
	vm_task_free(t);
}

/* writev gathers two iovec entries to the output sink in order. */
static void
test_writev(void)
{
	uint8_t seg[128];
	uint8_t elf[512];
	uint32_t o, iv, d0, d1;
	long len;
	struct outbuf out = { .len = 0 };
	struct vm_task *t;

	le32(seg + 0, 0x000015B7u);     /* lui  a1, 1       -> a1 = 0x1000        */
	le32(seg + 4, 0x00058593u);     /* addi a1, a1, iv  (iovec ptr, patched)  */
	le32(seg + 8, 0x00100513u);     /* addi a0, x0, 1   (fd = 1)              */
	le32(seg + 12, 0x00200613u);    /* addi a2, x0, 2   (iovcnt = 2)          */
	o = 16;
	o = emit_syscall(seg, o, 66);   /* sys_writev                             */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0                 */
	o = emit_syscall(seg, o, 93);   /* sys_exit                               */

	/* The iovec table (two 8-byte entries), 4-aligned, then the data bytes. */
	iv = (o + 3) & ~3u;
	d0 = iv + 16;                   /* "ab"                                   */
	d1 = d0 + 2;                    /* "cd\n"                                 */
	le32(seg + iv + 0, LOAD_VADDR + d0);    /* iov[0].base                    */
	le32(seg + iv + 4, 2);                  /* iov[0].len                     */
	le32(seg + iv + 8, LOAD_VADDR + d1);    /* iov[1].base                    */
	le32(seg + iv + 12, 3);                 /* iov[1].len                     */
	seg[d0 + 0] = 'a'; seg[d0 + 1] = 'b';
	seg[d1 + 0] = 'c'; seg[d1 + 1] = 'd'; seg[d1 + 2] = '\n';
	le32(seg + 4, 0x00058593u | (iv << 20));        /* a1 = 0x1000 + iv       */

	len = build_prog(elf, seg, d1 + 3);
	t = vm_task_new(0);
	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<writev>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "ran to a clean exit");
	EXPECT_EQ(out.len, 5, "five bytes gathered");
	EXPECT(out.len == 5 && memcmp(out.data, "abcd\n", 5) == 0,
	       "writev concatenates the entries in order");
	vm_task_free(t);
}

/* A guest that reads up to 8 bytes from stdin into 0x2000, echoes what it read
 * to stdout, and exits. Imports: 0 = sys_read, 1 = sys_write, 2 = sys_exit. */
static long
build_stdin_echo(uint8_t *elf)
{
	uint8_t seg[64];
	uint32_t o = 0;

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0  (fd 0)       */
	le32(seg + o, 0x000025B7u); o += 4;     /* lui  a1, 2      (buf 0x2000) */
	le32(seg + o, 0x00800613u); o += 4;     /* addi a2, x0, 8  (len 8)      */
	o = emit_call(seg, o, VM_CALL_READ);               /* sys_read -> a0 = count       */
	le32(seg + o, 0x00050613u); o += 4;     /* addi a2, a0, 0  (len = count)*/
	le32(seg + o, 0x000025B7u); o += 4;     /* lui  a1, 2      (buf 0x2000) */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1  (fd 1)       */
	o = emit_call(seg, o, VM_CALL_WRITE);               /* sys_write(1, buf, count)     */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0               */
	o = emit_call(seg, o, VM_CALL_EXIT);               /* sys_exit(0)                  */
	return build_prog(elf, seg, o);
}

/* A read on empty stdin parks the task; feeding input wakes it and the read
 * returns the bytes. */
static void
test_stdin_block_then_feed(void)
{
	uint8_t elf[512];
	long len = build_stdin_echo(elf);
	struct outbuf out = { .len = 0 };
	struct vm_task *t = vm_task_new(0);

	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stdin>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "read parks on empty stdin");
	EXPECT(vm_task_blocked(t), "the task is blocked waiting for input");
	EXPECT_EQ(out.len, (size_t)0, "nothing echoed yet");

	EXPECT_EQ(vm_task_feed_stdin(t, "hello", 5), 5, "fed five bytes");
	EXPECT(!vm_task_blocked(t), "the feed woke the task");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "it resumed and exited");
	EXPECT(out.len == 5 && memcmp(out.data, "hello", 5) == 0,
	       "the read returned the fed bytes");
	vm_task_free(t);
}

/* Input fed before the read waits in the buffer; the read returns it at once,
 * without parking. */
static void
test_stdin_buffered_then_read(void)
{
	uint8_t elf[512];
	long len = build_stdin_echo(elf);
	struct outbuf out = { .len = 0 };
	struct vm_task *t = vm_task_new(0);

	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stdin>"), 0, "loaded image");
	EXPECT_EQ(vm_task_feed_stdin(t, "hi", 2), 2, "buffered two bytes");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "read served from the buffer");
	EXPECT(out.len == 2 && memcmp(out.data, "hi", 2) == 0,
	       "the read returned the buffered bytes without parking");
	vm_task_free(t);
}

/* Closing stdin makes a parked read return 0 (end of file). */
static void
test_stdin_eof(void)
{
	uint8_t elf[512];
	long len = build_stdin_echo(elf);
	struct outbuf out = { .len = 0 };
	struct vm_task *t = vm_task_new(0);

	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stdin>"), 0, "loaded image");
	EXPECT_EQ(vm_task_run(t, 1000), VM_READY, "read parks on empty stdin");
	EXPECT(vm_task_blocked(t), "the task is blocked");

	vm_task_close_stdin(t);
	EXPECT(!vm_task_blocked(t), "closing stdin woke the task");
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "it resumed and exited");
	EXPECT_EQ(out.len, (size_t)0, "the read returned end of file, echoing nothing");
	vm_task_free(t);
}

/* Unix semantics: a read on stdin that is already closed returns 0 at once, it
 * does not park. The task runs straight through to exit on its first slice. */
static void
test_stdin_eof_before_read(void)
{
	uint8_t elf[512];
	long len = build_stdin_echo(elf);
	struct outbuf out = { .len = 0 };
	struct vm_task *t = vm_task_new(0);

	vm_task_set_output(t, capture, &out);
	EXPECT_EQ(vm_task_load_mem(t, elf, len, "<stdin>"), 0, "loaded image");

	vm_task_close_stdin(t);
	EXPECT_EQ(vm_task_run(t, 1000), VM_EXITED, "read at EOF does not park");
	EXPECT(!vm_task_blocked(t), "the task never blocked");
	EXPECT_EQ(out.len, (size_t)0, "the read returned end of file, echoing nothing");
	vm_task_free(t);
}

int
main(void)
{
	test_oneshot_exit();
	test_brk();
	test_writev();
	test_write_output();
	test_instruction_cap();
	test_fault();
	test_unbound_call();
	test_env_call();
	test_random();
	test_now();
	test_yield_resume();
	test_suspend_resume();
	test_suspend_sleep_fires();
	test_suspend_sleep_pending();
	test_suspend_sleep_event_wake();
	test_argc();
	test_argv_strings();
	test_initial_stack_argc();
	test_initial_stack_argv();
	test_stdin_block_then_feed();
	test_stdin_buffered_then_read();
	test_stdin_eof();
	test_stdin_eof_before_read();
	test_typed_args_count();
	test_typed_args_handle();
	test_typed_args_string();
	test_mailbox_deliver();
	test_mailbox_empty();
	test_mailbox_block_wake();
	test_mailbox_fifo();
	test_mailbox_full();
	test_scheduler_reap();
	test_load_file();
	return ctest_report("vm");
}
