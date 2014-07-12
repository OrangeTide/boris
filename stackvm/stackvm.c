/* stackvm.c - small demonstration language */
/* PUBLIC DOMAIN - Jon Mayo
 * original: June 23, 2011
 * updated: July 11, 2014 */
#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <inttypes.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stackdump.h"

/* logging macros */
#define info(format, ...) fprintf(stderr, "INFO:" format, ## __VA_ARGS__)
#define warn(format, ...) fprintf(stderr, "WARN:" format, ## __VA_ARGS__)
#define error(format, ...) fprintf(stderr, "ERROR:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define debug(format, ...) fprintf(stderr, "DEBUG:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)
#define trace(format, ...) fprintf(stderr, "TRACE:%s():%d:" format, __func__, __LINE__, ## __VA_ARGS__)

/* #define strcasecmp stricmp */

#define ARRAY_SIZE(a) (sizeof(a) / sizeof *(a))

/* flags for vm.status
 * bit set means an error, except STATUS_FINISHED
 */
#define STATUS_FINISHED		(1 << 0) /* 0x1 */
#define ERROR_INVALID_OPCODE	(1 << 1) /* 0x2 */
#define ERROR_STACK_UNDERFLOW	(1 << 2) /* 0x4 */
#define ERROR_STACK_OVERFLOW	(1 << 3) /* 0x8 */
#define ERROR_SYSCALL		(1 << 4) /* 0x10 */
#define ERROR_END_OF_FILE	(1 << 5) /* 0x20 */
#define ERROR_OUT_OF_BOUNDS	(1 << 6) /* 0x40 */
#define ERROR_MATH_ERROR	(1 << 7) /* 0x80 */
#define ERROR_UNFINISHED	(1 << 8) /* 0x100 */
#define ERROR_UNALIGNED		(1 << 9) /* 0x200 */

#define VM_STACK_SIZE 1024
#define PROGRAM_STACK_SIZE 0x10000
#define MAX_VMMAIN_ARGS 13

typedef unsigned vmword_t;
typedef float vmsingle_t;

/* expanded instruction */
struct vm_op {
	int op;
	int param;
};

struct vm;

/* environment holds infomation common to multiple VMs */
struct vm_env {
	unsigned nr_syscalls;
	void (**syscalls)(struct vm *vm);
};

struct vm {
	const struct vm_env *env;
	/* code is a read-only area for instructions */
	struct vm_op *code;
	size_t code_len;
	size_t code_mask;
	/* heap is the RAM area for data */
	union {
		vmword_t *words;
		uint16_t *halfs;
		uint8_t *bytes;
	} heap;
	size_t heap_len;
	size_t heap_mask;
	int status; /* stop loop when non-zero */
	vmword_t pc; /* program counter */
	vmword_t psp; /* program stack pointer */
	vmword_t stack_bottom; /* end of the program stack */
	vmword_t stack[VM_STACK_SIZE] __attribute__ ((aligned (__BIGGEST_ALIGNMENT__))); /* op stack */
	unsigned op_stack;
	/* bootstrap and input parameters */
	char *vm_filename;
};

static char *opcode_to_name[] = {
	"UNDEF", "IGNORE", "BREAK", "ENTER",
	"LEAVE", "CALL", "PUSH", "POP",
	"CONST", "LOCAL", "JUMP", "EQ",
	"NE", "LTI", "LEI", "GTI",
	"GEI", "LTU", "LEU", "GTU",
	"GEU", "EQF", "NEF", "LTF",
	"LEF", "GTF", "GEF", "LOAD1",
	"LOAD2", "LOAD4", "STORE1", "STORE2",
	"STORE4", "ARG", "BLOCK_COPY", "SEX8",
	"SEX16", "NEGI", "ADD", "SUB",
	"DIVI", "DIVU", "MODI", "MODU",
	"MULI", "MULU", "BAND", "BOR",
	"BXOR", "BCOM", "LSH", "RSHI",
	"RSHU", "NEGF", "ADDF", "SUBF",
	"DIVF", "MULF", "CVIF", "CVFI",
};

static struct vm_env *vm_env_new(unsigned nr_syscalls)
{

	struct vm_env *env = calloc(1, sizeof(*env));
	assert(env != NULL);
	env->nr_syscalls = nr_syscalls;
	env->syscalls = calloc(sizeof(*env->syscalls), nr_syscalls);
	assert(env->syscalls != NULL);
	return env;
}

static int vm_env_register(struct vm_env *env, int syscall_num, void (*sc)(struct vm *vm))
{
	assert(syscall_num < 0);
	unsigned ofs = -1 - syscall_num;
	if (ofs >= env->nr_syscalls)
		return -1;
	env->syscalls[ofs] = sc;
	return 0;
}

static int vm_env_call(const struct vm_env *env, int syscall_num, struct vm *vm)
{
	assert(syscall_num < 0);
	unsigned ofs = -1 - syscall_num;
	if (ofs >= env->nr_syscalls)
		return -1;
	void (*sc)(struct vm *vm) = env->syscalls[ofs];
	if (!sc) // TODO: catch this as an error
		return -1;
	sc(vm); // TODO: check for errors
	return 0;
}

/* returns number of bytes an opcode will consume.
 * 0 if an unknown or illegal opcode. */
static unsigned opcode_length(unsigned char op)
{
	unsigned len = 1;

	switch (op) {
	case 0x00: /* UNDEF*/
	case 0x01: /* IGNORE */
	case 0x02: /* BREAK */
		break;
	case 0x03: /* ENTER */
	case 0x04: /* LEAVE */
		len = 5;
		break;
	case 0x05: /* CALL */
	case 0x06: /* PUSH */
	case 0x07: /* POP */
		break;
	case 0x08: /* CONST x */
	case 0x09: /* LOCAL x */
		len = 5;
		break;
	case 0x0a: /* JUMP */
		break;
	case 0x0b: /* EQ x */
	case 0x0c: /* NE x */
	case 0x0d: /* LTI x */
	case 0x0e: /* LEI x */
	case 0x0f: /* GTI x */
	case 0x10: /* GEI x */
	case 0x11: /* LTU x */
	case 0x12: /* LEU x */
	case 0x13: /* GTU x */
	case 0x14: /* GEU x */
	case 0x15: /* EQF x */
	case 0x16: /* NEF x */
	case 0x17: /* LTF x */
	case 0x18: /* LEF x */
	case 0x19: /* GTF x */
	case 0x1a: /* GEF x */
		len = 5;
		break;
	case 0x1b: /* LOAD1 */
	case 0x1c: /* LOAD2 */
	case 0x1d: /* LOAD4 */
	case 0x1e: /* STORE1 */
	case 0x1f: /* STORE2 */
	case 0x20: /* STORE4 */
		break;
	case 0x21: /* ARG x */
		len = 2;
		break;
	case 0x22: /* BLOCK_COPY x */
	case 0x23: /* SEX8 */
	case 0x24: /* SEX16 */
	case 0x25: /* NEGI */
	case 0x26: /* ADD */
	case 0x27: /* SUB */
	case 0x28: /* DIVI */
	case 0x29: /* DIVU */
	case 0x2a: /* MODI */
	case 0x2b: /* MODU */
	case 0x2c: /* MULI */
	case 0x2d: /* MULU */
	case 0x2e: /* BAND */
	case 0x2f: /* BOR */
	case 0x30: /* BXOR */
	case 0x31: /* BCOM */
	case 0x32: /* LSH */
	case 0x33: /* RSHI */
	case 0x34: /* RSHU */
	case 0x35: /* NEGF */
	case 0x36: /* ADDF */
	case 0x37: /* SUBF */
	case 0x38: /* DIVF */
	case 0x39: /* MULF */
	case 0x3a: /* CVIF */
	case 0x3b: /* CVFI */
		break;
	default:
		return 0; /* failure */
	}

	return len;
}

/* returns the count of instructions.
 * returns 0 on error or if there are no complete instructions. */
static unsigned count_instructions(const unsigned char *opbytes, size_t oplen)
{
	unsigned total = 0;

	while (oplen > 0) {
		// trace("opbytes=%p oplen=%zd total=%d\n", opbytes, oplen, total);
		unsigned result = opcode_length(*opbytes);

		if (result > oplen)
			return 0; /* truncated instruction */

		if (!result)
			return 0; /* illegal instruction */

		assert(result <= 5);
		opbytes += result;
		oplen -= result;
		total++;
	}

	trace("total=%d\n", total);
	return total;
}

static const char *disassemble_opcode(const struct vm_op *op)
{
	static char buf[256];
	unsigned b = op->op;

	if (b < ARRAY_SIZE(opcode_to_name)) {
		if (opcode_length(b) > 1) {
			unsigned p = op->param;
			snprintf(buf, sizeof(buf), "%s %d [0x%02x %#x]",
			         opcode_to_name[b], p, b, p);
		} else {
			snprintf(buf, sizeof(buf), "%s [0x%02x]",
			         opcode_to_name[b], b);
		}
	} else {
		snprintf(buf, sizeof(buf), "0x%02hhx", b & 255);
	}

	return buf;
}

static void disassemble(FILE *out, const struct vm_op *ops, size_t ops_len, vmword_t baseaddr)
{
	unsigned i;
	fprintf(out, "---8<--- start of disassembly (len=%zd) ---8<---\n", ops_len);

	for (i = 0; i < ops_len; i++)
		fprintf(out, "%06x: %s\n",
		        baseaddr + i, disassemble_opcode(ops + i));

	fprintf(out, "---8<--- end of disassembly ---8<---\n");
}

/* round up len to next power of two minus one */
static size_t make_mask(size_t len)
{
	size_t ret = 0;

	while (ret + 1 < len)
		ret = (ret << 1) | 1;

	return ret;
}

static inline int check_code_bounds(struct vm *vm, vmword_t ofs)
{
	if (ofs & ~vm->code_mask) {
		vm->status |= ERROR_OUT_OF_BOUNDS;
		return -1;
	}

	return 0;
}

static inline int check_data_bounds(struct vm *vm, vmword_t ofs)
{
	if (ofs & ~vm->heap_mask) {
		vm->status |= ERROR_OUT_OF_BOUNDS;
		return -1;
	}

	return 0;
}

static inline int check_stack_bounds(struct vm *vm)
{
	if (vm->psp < vm->stack_bottom)
		return -1;

	return check_data_bounds(vm, vm->psp);
}

/* push a value onto the op stack */
static void opush(struct vm *vm, vmword_t val)
{
	trace("%s:PUSH %d\n", vm->vm_filename, val);

	if (vm->op_stack < ARRAY_SIZE(vm->stack))
		vm->stack[vm->op_stack++] = val;
	else
		vm->status |= ERROR_STACK_OVERFLOW;
}

/* peek a value from the op stack
 * negative numbers start from most recent entry. (-1 = newest)
 * positive numbers start from oldest entry on stack. (0 = oldest) */
static vmword_t opeek(struct vm *vm, int index)
{
	unsigned ofs = index < 0 ? vm->op_stack + index : (unsigned)index;

	if (ofs < vm->op_stack)
		return vm->stack[ofs];

	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

/* pop a value from the op stack */
static vmword_t opop(struct vm *vm)
{
	if (vm->op_stack) {
		vmword_t val = vm->stack[--vm->op_stack];
		trace("%s:POP %d\n", vm->vm_filename, val);
		return val;
	}

	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

/* push a value onto the op stack */
static void opushf(struct vm *vm, vmsingle_t val)
{
	if (vm->op_stack < ARRAY_SIZE(vm->stack))
		vm->stack[vm->op_stack++] = *(vmword_t*) & val;
	else
		vm->status |= ERROR_STACK_OVERFLOW;
}

/* pop a value from the op stack */
static vmsingle_t opopf(struct vm *vm)
{
	if (vm->op_stack)
		return *(vmsingle_t*)(vm->stack + --vm->op_stack);

	vm->status |= ERROR_STACK_UNDERFLOW;
	return NAN;
}

static inline void dwrite4(struct vm *vm, vmword_t ofs, vmword_t val)
{
	trace("%s:write %d (%#x) : %d\n", vm->vm_filename, ofs, ofs, val);

	if (check_data_bounds(vm, ofs) || check_data_bounds(vm, ofs + 3))
		return;

	if (ofs & 3) {
		vm->status |= ERROR_UNALIGNED;
		return;
	}

	vm->heap.words[ofs >> 2] = val;
}

static inline void dwrite2(struct vm *vm, vmword_t ofs, uint16_t val)
{
	trace("%s:write %d (%#x) : %d\n", vm->vm_filename, ofs, ofs, val);

	if (check_data_bounds(vm, ofs) || check_data_bounds(vm, ofs + 1))
		return;

	if (ofs & 1) {
		vm->status |= ERROR_UNALIGNED;
		return;
	}

	vm->heap.halfs[ofs >> 1] = val;
}

static inline void dwrite1(struct vm *vm, vmword_t ofs, uint8_t val)
{
	check_data_bounds(vm, ofs);
	vm->heap.bytes[ofs] = val;
}

static inline vmword_t dread4(struct vm *vm, vmword_t ofs)
{
	// TODO: use one function to check range
	if (check_data_bounds(vm, ofs) || check_data_bounds(vm, ofs + 3)) {
		vm->status |= ERROR_OUT_OF_BOUNDS;
		return 0xdeadbeef;
	}

	if (ofs & 3) {
		vm->status |= ERROR_UNALIGNED;
		return 0xdeadbeef;
	}

	vmword_t val = vm->heap.words[ofs >> 2];
	trace("%s:read %d (%#x) : %d\n", vm->vm_filename, ofs, ofs, val);
	return val;
}

static inline uint16_t dread2(struct vm *vm, vmword_t ofs)
{
	// TODO: use one function to check range
	if (check_data_bounds(vm, ofs) || check_data_bounds(vm, ofs + 1)) {
		vm->status |= ERROR_OUT_OF_BOUNDS;
		return 0xdead;
	}

	if (ofs & 1) {
		vm->status |= ERROR_UNALIGNED;
		return 0xbeef;
	}

	return vm->heap.halfs[ofs >> 1];
}

static inline uint8_t dread1(struct vm *vm, vmword_t ofs)
{
	if (check_data_bounds(vm, ofs)) {
		vm->status |= ERROR_OUT_OF_BOUNDS;
		return 0xde;
	}

	return vm->heap.bytes[ofs];
}

/* write value to program stack */
static void ppoke(struct vm *vm, int index, vmword_t val)
{
	// unsigned ofs = vm->psp - index - 4; // TODO: is this correct?
	unsigned ofs = vm->psp - index; // TODO: is this correct?

	if (check_data_bounds(vm, ofs))
		return;

	trace("%s:write %d (%#x) : %d\n", vm->vm_filename, ofs, ofs, val);
	dwrite4(vm, ofs, val);
}

static void vm_disassemble(const struct vm *vm)
{
	disassemble(stdout, vm->code, vm->code_len, 0);
}

static void vm_stacktrace(const struct vm *vm)
{
	abort(); // TODO: implement this
}

// TODO: limit number of cycles or amount of time for this slice
static void vm_run_slice(struct vm *vm)
{
	vmword_t a; /* scratch area */
	vmword_t b; /* scratch area */
	vmsingle_t af; /* scratch area */
	vmsingle_t bf; /* scratch area */

	debug("code_mask=0x%08zx code_len=0x%08zx\n",
	      vm->code_mask, vm->code_len);
	debug("heap_mask=0x%08zx heap_len=0x%08zx\n",
	      vm->heap_mask, vm->heap_len);
	/* the interpreter should only use _mask, not _len for checks */
	assert(vm->code_mask == make_mask(vm->code_len));
	assert(vm->heap_mask == make_mask(vm->heap_len));

	while (!vm->status && !check_code_bounds(vm, vm->pc)) {
		struct vm_op *op = &vm->code[vm->pc++];
		{ /* debug only */
			vmword_t top = ~0;

			if (vm->op_stack)
				top = vm->stack[vm->op_stack - 1];

			debug("PC:pc=%d (%#x) op=%s top=%d (%#x) psp=%d (%#x)\n",
			      vm->pc - 1, vm->pc - 1, disassemble_opcode(op),
			      top, top, vm->psp, vm->psp);
		}

		switch (op->op) {
			;
		case 0x00: /* UNDEF*/
			break;
		case 0x01: /* IGNORE */
			break;
		case 0x02: /* BREAK */
			abort(); // TODO: implement a debugging callback
			break;
		case 0x03: /* ENTER - increase program stack by amount */
			vm->psp -= op->param;
			// TODO: this is interesting, it skips 2 stack frames: vm->psp -= op->param - 4;
			break;
		case 0x04: /* LEAVE - shrink program stack by amount */
			vm->psp += op->param; /* remove the frame added by ENTER */
			/*
			trace("LEAVE:psp=%d %d %d %d %d %d %d %d %d %d\n",
				dread4(vm, vm->psp + 0),
				dread4(vm, vm->psp + 4),
				dread4(vm, vm->psp + 8),
				dread4(vm, vm->psp + 12),
				dread4(vm, vm->psp + 16),
				dread4(vm, vm->psp + 20),
				dread4(vm, vm->psp + 24),
				dread4(vm, vm->psp + 28),
				dread4(vm, vm->psp + 32),
				dread4(vm, vm->psp + 36)
				);
			*/
			b = vm->psp ;
			a = dread4(vm, b);

			if ((int)a == -1)
				vm->status = STATUS_FINISHED;

			// TODO: handle other negative values for reentrant vm_call
			trace("LEAVE to %d (%#x) from %d (%#x)\n", a, a, vm->pc, vm->pc);
			vm->pc = a;
			break;
		case 0x05: /* CALL */
			dwrite4(vm, vm->psp + 4, vm->psp); /* save the old SP */
			dwrite4(vm, vm->psp, vm->pc); /* save the old PC */
			a = opop(vm);

			if ((int32_t)a < 0) {
				// TODO: the original would store as byte offset, not instruction index
				dwrite4(vm, vm->psp + 4, -1 - vm->pc); /* save the old PC */
				// TODO: do system call if program counter is negative
				vm->pc = 0xdeadbeef; /* system call better clean this up */
				if (vm->env) {
					vm_env_call(vm->env, a, vm);
					// TODO: check results
				} else {
					// TODO: catch this as an error
					abort(); // TODO: implement this
				}
			} else {
				vm->pc = a;
				check_code_bounds(vm, vm->pc);
			}

			break;
		case 0x06: /* PUSH - push a 0 onto data stack */
			opush(vm, 0);
			break;
		case 0x07: /* POP - remove an item from data stack */
			opop(vm);
			break;
		case 0x08: /* CONST x */
			opush(vm, op->param);
			break;
		case 0x09: /* LOCAL x - get address of local */
			a = vm->psp + op->param;
			opush(vm, a);
			break;
		case 0x0a: /* JUMP */
			vm->pc = opop(vm);
			check_code_bounds(vm, vm->pc);
			break;
		case 0x0b: /* EQ x */
			a = opop(vm);
			b = opop(vm);

			if (b == a)
				vm->pc = op->param;

			break;
		case 0x0c: /* NE x */
			a = opop(vm);
			b = opop(vm);

			if (b != a)
				vm->pc = op->param;

			break;
		case 0x0d: /* LTI x */
			a = opop(vm);
			b = opop(vm);

			if ((int)b < (int)a)
				vm->pc = op->param;

			break;
		case 0x0e: /* LEI x */
			a = opop(vm);
			b = opop(vm);

			if ((int)b <= (int)a)
				vm->pc = op->param;

			break;
		case 0x0f: /* GTI x */
			a = opop(vm);
			b = opop(vm);

			if ((int)b > (int)a)
				vm->pc = op->param;

			break;
		case 0x10: /* GEI x */
			a = opop(vm);
			b = opop(vm);

			if ((int)b >= (int)a)
				vm->pc = op->param;

			break;
		case 0x11: /* LTU x */
			a = opop(vm);
			b = opop(vm);

			if (b < a)
				vm->pc = op->param;

			break;
		case 0x12: /* LEU x */
			a = opop(vm);
			b = opop(vm);

			if (b <= a)
				vm->pc = op->param;

			break;
		case 0x13: /* GTU x */
			a = opop(vm);
			b = opop(vm);

			if (b > a)
				vm->pc = op->param;

			break;
		case 0x14: /* GEU x */
			a = opop(vm);
			b = opop(vm);

			if (b >= a)
				vm->pc = op->param;

			break;
		case 0x15: /* EQF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf == af)
				vm->pc = op->param;

			break;
		case 0x16: /* NEF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf != af)
				vm->pc = op->param;

			break;
		case 0x17: /* LTF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf < af)
				vm->pc = op->param;

			break;
		case 0x18: /* LEF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf <= af)
				vm->pc = op->param;

			break;
		case 0x19: /* GTF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf > af)
				vm->pc = op->param;

			break;
		case 0x1a: /* GEF x */
			af = opopf(vm);
			bf = opopf(vm);

			if (bf >= af)
				vm->pc = op->param;

			break;
		case 0x1b: /* LOAD1 */
			a = opop(vm);
			b = dread1(vm, a);
			opush(vm, b);
			break;
		case 0x1c: /* LOAD2 */
			a = opop(vm);
			b = dread2(vm, a);
			opush(vm, b);
			break;
		case 0x1d: /* LOAD4 */
			a = opop(vm);
			b = dread4(vm, a);
			trace("%s:LOAD4 (@%d) : %d\n", vm->vm_filename, a, b);
			opush(vm, b);
			break;
		case 0x1e: /* STORE1 */
			a = opop(vm);
			b = opop(vm);
			dwrite1(vm, b, a);
			break;
		case 0x1f: /* STORE2 */
			a = opop(vm);
			b = opop(vm);
			dwrite2(vm, b, a);
			break;
		case 0x20: /* STORE4 */
			a = opop(vm);
			b = opop(vm);
			trace("%s:STORE4 %d (@%d) : %d\n", vm->vm_filename, a, a, b);
			dwrite4(vm, b, a);
			break;
		case 0x21: /* ARG x - write value to program stack */
			a = opop(vm);
			b = vm->psp + op->param;
			trace("%s:ARG %d (@%d) : %d\n", vm->vm_filename, op->param, b, a);
			dwrite4(vm, b, a);
			break;
		case 0x22: /* BLOCK_COPY x - copy x bytes */
			a = opop(vm); /* src */
			b = opop(vm); /* dest */
#if 0 // TODO: implement this
			block_copy(vm, b, a, op->param);
#endif
			abort(); // TODO: implement this
			break;
		case 0x23: /* SEX8 */
			a = (int32_t)(int8_t)opop(vm);
			opush(vm, a);
			break;
		case 0x24: /* SEX16 */
			a = (int32_t)(int16_t)opop(vm);
			opush(vm, a);
			break;
		case 0x25: /* NEGI */
			a = opop(vm);
			opush(vm, -a);
			break;
		case 0x26: /* ADD */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b + a);
			break;
		case 0x27: /* SUB */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b - a);
			break;
		case 0x28: /* DIVI */
			a = opop(vm);
			b = opop(vm);

			if (a) // TODO: check for INT_MIN / -1
				opush(vm, (int)b / (int)a);
			else
				vm->status |= ERROR_MATH_ERROR;

			break;
		case 0x29: /* DIVU */
			a = opop(vm);
			b = opop(vm);

			if (a)
				opush(vm, b / a);
			else
				vm->status |= ERROR_MATH_ERROR;

			break;
		case 0x2a: /* MODI */
			a = opop(vm);
			b = opop(vm);

			if (a) // TODO: check for INT_MIN / -1
				opush(vm, (int)b % (int)a);
			else
				vm->status |= ERROR_MATH_ERROR;

			break;
		case 0x2b: /* MODU */
			a = opop(vm);
			b = opop(vm);

			if (a)
				opush(vm, b % a);
			else
				vm->status |= ERROR_MATH_ERROR;

			break;
		case 0x2c: /* MULI */
			a = opop(vm);
			b = opop(vm);
			// TODO: check for INT_MIN * -1 errors
			opush(vm, b * a);
			break;
		case 0x2d: /* MULU */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b * a);
			break;
		case 0x2e: /* BAND */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b & a);
			break;
		case 0x2f: /* BOR */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b | a);
			break;
		case 0x30: /* BXOR */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b ^ a);
			break;
		case 0x31: /* BCOM */
			a = opop(vm);
			opush(vm, ~a);
			break;
		case 0x32: /* LSH */
			a = opop(vm);
			b = opop(vm);
			opush(vm, b << a);
			break;
		case 0x33: /* RSHI */
			a = opop(vm);
			b = opop(vm);
			opush(vm, (int)b >> a);
			break;
		case 0x34: /* RSHU */
			a = opop(vm);
			b = opop(vm);
			opush(vm, (unsigned)b >> a);
			break;
		case 0x35: /* NEGF */
			af = opopf(vm);
			opushf(vm, -af);
			break;
		case 0x36: /* ADDF */
			af = opopf(vm);
			bf = opopf(vm);
			opushf(vm, bf + af);
			break;
		case 0x37: /* SUBF */
			af = opopf(vm);
			bf = opopf(vm);
			opushf(vm, bf - af);
			break;
		case 0x38: /* DIVF */
			af = opopf(vm);
			bf = opopf(vm);
			opushf(vm, bf / af);
			break;
		case 0x39: /* MULF */
			af = opopf(vm);
			bf = opopf(vm);
			opushf(vm, bf * af);
			break;
		case 0x3a: /* CVIF */
			af = (vmsingle_t)opop(vm);
			opushf(vm, af);
			break;
		case 0x3b: /* CVFI */
			a = (vmword_t)opopf(vm);
			opush(vm, a);
			break;
		default:
			vm->status |= ERROR_INVALID_OPCODE;
		}
	}

// finished: // TODO: LEAVE -1 could jump here instead of using flags
	if ((vm->status & ~STATUS_FINISHED))
		error("%s:error 0x%x (pc=0x%x)\n", vm->vm_filename, vm->status, vm->pc);
	else if (vm->status == STATUS_FINISHED)
		info("%s:finished!\n", vm->vm_filename);
	else {
		info("%s:not finished!\n", vm->vm_filename);
		vm->status |= ERROR_UNFINISHED;
	}

	free(vm->heap.bytes);
	vm->heap.bytes = NULL;
}

static void vm_call(struct vm *vm, unsigned nr_args, ...)
{
	va_list ap;
	assert(vm != NULL);
	unsigned i;

	va_start(ap, nr_args);
	// TODO: find entry point
	vm->pc = 0;
	/* make space for args and return */
	vmword_t old_psp = vm->psp;
	vm->psp -= 8 + (4 * nr_args);
	check_stack_bounds(vm);
	/* store return address and old stack */
	dwrite4(vm, vm->psp, -1);
	dwrite4(vm, vm->psp + 4, old_psp);

	/* store args */
	for (i = 0; i < nr_args; i++) {
		vmword_t val = va_arg(ap, vmword_t);
		dwrite4(vm, vm->psp + 8 + (i * 4), val);
	}

	// TODO: optionally vm_run() until complete and return result
	va_end(ap);
}

static inline unsigned roundup_pow2(unsigned n)
{
	n--;
	n |= n >> 1;
	n |= n >> 2;
	n |= n >> 4;
	n |= n >> 8;
	n |= n >> 16;
	n++;
	return n;
}

struct vm_header {
#define VM_MAGIC 0x12721444
#define VM_MAGIC_VER2   0x12721445
	uint32_t magic;
	int32_t instruction_count;
	uint32_t code_offset;
	int32_t code_length;
	uint32_t data_offset;
	int32_t data_length;
	int32_t lit_length;
	int32_t bss_length;
	int32_t jtrg_length; /* jump table target */
};

static int load_data_segment(struct vm *vm, FILE *f, const char *filename, const struct vm_header *header)
{
	uint32_t heap_len = header->data_length + header->lit_length + header->bss_length;
	const unsigned data_length = header->data_length;
	const unsigned data_offset = header->data_offset;
	heap_len = roundup_pow2(heap_len);
	vm->heap_len = heap_len;
	vm->heap_mask = heap_len ? heap_len - 1 : 0;
	vm->heap.bytes = malloc(vm->heap_len);

	if (fseek(f, data_offset, SEEK_SET))
		goto failure_perror;

	if (fread(vm->heap.bytes, 1, data_length, f) != (size_t)data_length)
		goto failure_perror; // TODO: check errno and print short read msg

	memset(vm->heap.bytes + data_length, 0x00,
	       vm->heap_mask - data_length);
	return 0;
failure_perror:
	perror(filename);
	return -1;
}

void vm_free(struct vm *vm)
{
	if (!vm)
		return;

	free(vm->vm_filename);
	vm->vm_filename = NULL;
	free(vm->heap.bytes);
	vm->heap.bytes = NULL;
	vm->heap_len = vm->heap_mask = 0;
	free(vm->code);
	vm->code = NULL;
	vm->code_len = vm->code_mask = 0;
}

static int vm_load(struct vm *vm, const char *filename)
{
	struct vm_header header;
	FILE *f;
	size_t header_len;
	unsigned header_version;

	memset(vm, 0, sizeof(*vm));

	f = fopen(filename, "rb");

	if (!f) {
		perror(filename);
		return 0;
	}

	vm->vm_filename = strdup(filename);

	header_len = fread(&header, 1, sizeof(header), f);

	if (header_len >= 36 && header.magic == VM_MAGIC_VER2) {
		header_version = 2;
	} else if (header_len >= 32 && header.magic == VM_MAGIC) {
		header_version = 1;
	} else {
		error("%s:not a valid VM file (magic=0x%08" PRIx32 " len=%zd)\n",
		      filename, header.magic, header_len);
		goto failure;
	}

	info("code_length=%d data_length=%d lit_length=%d bss_length=%d\n",
	     header.code_length, header.data_length, header.lit_length,
	     header.bss_length);

	/* validate */

	/* checks that none of the sizes are negative
	 * checks that bss_length has room for PROGRAM_STACK_SIZE.
	 */
	if (header.code_length < 0 || header.data_length < 0 || header.lit_length < 0
	                || header.bss_length < PROGRAM_STACK_SIZE
	                || (header_version >= 2 && header.jtrg_length < 0)) {
		goto failure;
	}

	/* TODO: validate these:
	instruction_count;
	code_offset;
	data_offset;
	*/


	/* load data segment */
	int e;
	e = load_data_segment(vm, f, filename, &header);

	if (e)
		goto failure_freevm;

	/* load code segment */
	size_t codebuf_len = header.code_length;
	unsigned char *codebuf = malloc(codebuf_len);

	if (fseek(f, header.code_offset, SEEK_SET))
		goto failure_perror;

	if (fread(codebuf, 1, codebuf_len, f) != codebuf_len)
		goto failure_perror; // TODO: check errno and print short msg

	/* expand code segment into ops */
	trace("codebuf=%p codebuf_len=%zd\n", codebuf, codebuf_len);
	unsigned instruction_count = count_instructions(codebuf, codebuf_len);
	size_t code_size = roundup_pow2(instruction_count);
	trace("instruction_count=%d code_size=%zd\n", instruction_count, code_size);
	vm->code = malloc(code_size * sizeof(*vm->code));
	unsigned i;
	unsigned n = 0;

	for (i = 0; i < instruction_count; i++) {
		if (n >= codebuf_len) {
			error("incorrect instruction count at %d (i=%d cnt=%d)\n", n, i, instruction_count);
			goto failure_freecodebuf;
		}

		unsigned oplen = opcode_length(codebuf[n]);

		if (oplen > codebuf_len - n) {
			error("trucated opcode sequence at offset %d!\n", n);
			goto failure_freecodebuf;
		}

		if (oplen == 0) {
			error("invalid opcode at offset %d!\n", n);
			goto failure_freecodebuf;
		} else if (oplen == 1) {
			vm->code[i].param = 0;
		} else if (oplen == 2) { /* 8-bit parameter */
			vm->code[i].param = codebuf[n + 1];
		} else if (oplen == 5) { /* 32-bit parameter */
			vm->code[i].param =
			        codebuf[n + 1] |
			        ((vmword_t)codebuf[n + 2] << 8) |
			        ((vmword_t)codebuf[n + 3] << 16) |
			        ((vmword_t)codebuf[n + 4] << 24);
		} else {
			error("opcode size %d is not supported!\n", oplen);
			goto failure_freecodebuf;
		}

		// trace("i=%d n=%d oplen=%d\n", i, n, oplen);
		vm->code[i].op = codebuf[n];
		n += oplen;
	}

	for (; i < code_size; i++) {
		vm->code[i].op = 0x02; /* BREAK */
		vm->code[i].param = 0;
	}

	vm->code_len = instruction_count;
	vm->code_mask = make_mask(code_size);
	free(codebuf);
	debug("Loaded %d opcodes\n", instruction_count);

	fclose(f);

	/* initialize fields */
	vm->pc = 0;
	vm->psp = (vm->heap_mask + 1) - 4; /* points to the last word */
	vm->stack_bottom = vm->psp - PROGRAM_STACK_SIZE;
	vm->status = 0;

	return 1;
failure_perror:
	perror(filename);
failure_freecodebuf:
	free(codebuf);
failure_freevm:
	free(vm->heap.bytes);
	free(vm->code);
	// TODO: free other stuff
failure:
	fclose(f);
	error("%s:could not load file\n", filename);
	return 0;
}

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
	trace("TODO\n");
	// TODO: get arguments from the VM
	abort(); // TODO: implement this
}

static void sys_trap_error(struct vm *vm)
{
	trace("TODO\n");
	// TODO: get arguments from the VM
	abort(); // TODO: implement this
}

int main(int argc, char **argv)
{
	struct vm_env *env;
	struct vm vm;
	enable_stack_dump();
	process_args(argc, argv);

	env = vm_env_new(100);
	assert(env != NULL);
	vm_env_register(env, -1, sys_trap_print);
	vm_env_register(env, -2, sys_trap_error);

	if (!vm_load(&vm, opt_vm_filename)) {
		error("%s:could not load file\n", opt_vm_filename);
		return EXIT_FAILURE;
	}

	/* TODO: add an API that gives a more elegant way to set the env. */
	vm.env = env;

	if (1)
		vm_disassemble(&vm);

	vm_call(&vm, 2, 500, 800); /* result should be 1800 (500+500+800) */
	// TODO: call in a loop
	vm_run_slice(&vm);
	vmword_t result = 0xdeadbeef;

	if (vm.status == STATUS_FINISHED)
		result = opop(&vm);

	if (vm.status != STATUS_FINISHED) {
		info("%s:VM failure\n", vm.vm_filename);
		vm_free(&vm);
		return EXIT_FAILURE;
	}

	info("%s:VM success:result=%d\n", vm.vm_filename, result);
	vm_free(&vm);
	return EXIT_SUCCESS;
}
