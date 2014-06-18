/* stackvm.c - small demonstration language */
/* PUBLIC DOMAIN - Jon Mayo
 * original: June 23, 2011
 * updated: June 11, 2014 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <errno.h>

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
#define STATUS_FINISHED		(1 << 0)
#define ERROR_INVALID_OPCODE	(1 << 1)
#define ERROR_STACK_UNDERFLOW	(1 << 2)
#define ERROR_STACK_OVERFLOW	(1 << 3)
#define ERROR_SYSCALL		(1 << 4)
#define ERROR_END_OF_FILE	(1 << 5)

/* TODO: use real routines instead of magic values */
#define DICT_CFA_INSERT_OPCODE ((struct dictdef *)0x01)

/* dictionary definition */
struct dictdef {
	char name[16];
	struct dictdef *next;
	int action;
	struct dictdef *code_field;
	union {
		struct {
			size_t opcode_len;
			unsigned char opcode[16]; /* TODO: dynamically allocate an array */
		};
	} parameter_field ;
};

typedef unsigned vmword_t;

struct vm {
	/* code is a read-only area for instructions */
	unsigned char *code;
	size_t code_len;
	size_t code_mask;
	/* heap is the RAM area for data */
	vmword_t *heap;
	size_t heap_len;
	size_t heap_mask;
	int status; /* stop loop when non-zero */
	/* registers and stacks */
	vmword_t pc;
	vmword_t d;
	vmword_t dstack[64];
	vmword_t r;
	vmword_t rstack[64];
	/* bootstrap and input parameters */
	const char *vm_filename;
};

static struct dictdef *dict_head; /* TODO: keep inside the vm structure */

#define OP_JMP 1
#define OP_JEQ 2
#define OP_JNE 3
#define OP_RET 9
#define OP_LIT 12
#define OP_SYS 29
static char *opcode_to_name[] = {
	"NOP", "JMP", "JEQ", "JNE",
	"JLE", "JLT", "JGE", "JGT",
	"CALL", "RET", "LOAD", "STORE",
	"LIT", "COM", "XOR", "AND",
	"ADD", "SHL", "SHR", "DUP",
	"DROP", "TOR", "FROMR", "COPYR",
	"OVER", "SWAP", "DUPR", "NIP",
	"TUCK", "SYS", "OR", "SUB",
};

/* location of useful heap globals */
#define TOK_BUF_OFFSET 0
#define TOK_BUF_LENGTH 64

struct dictdef *dict_new(const char *name)
{
	struct dictdef *d = calloc(1, sizeof(*d));
	if (!d)
		return NULL;
	strncpy(d->name, name, sizeof(d->name) - 1);
	d->name[sizeof(d->name) - 1] = 0;
	d->action = 0; /* nothing/error */
	d->next = dict_head;
	dict_head = d;
	return d;
}

/* wraps up steps to create a definition for assembly opcodes */
struct dictdef *dict_new_opcode(const char *name, size_t oplen, unsigned char *op)
{
	struct dictdef *d = dict_new(name);
	if (!d)
		return NULL;
	d->code_field = DICT_CFA_INSERT_OPCODE;
	d->parameter_field.opcode_len = oplen;
	unsigned i;
	for (i = 0; i < oplen && i < sizeof(d->parameter_field.opcode); i++)
		d->parameter_field.opcode[i] = op[i];
	return d;
}

struct dictdef *dict_lookup(const char *name)
{
	struct dictdef *cur = dict_head;
	while (cur) {
		if (!strcmp(cur->name, name))
			return cur;
		cur = cur->next;
	}
	return NULL;
}

static void dict_generate_from_opcode_to_name(void)
{
	unsigned i;
	for (i = 0; i < ARRAY_SIZE(opcode_to_name); i++) {
		unsigned char op[1] = { i };
		struct dictdef *d = dict_new_opcode(opcode_to_name[i], sizeof(op), op);
		assert(d != NULL);
	}
}

/* read two bytes in little endian order,
 * use a little bitmath to sign extend the value */
static short read_short(const void *buf)
{
	unsigned m = ((const unsigned char*)buf)[0];
	m |= (unsigned)((const unsigned char*)buf)[1] << 8;
	return (m ^ 0x8000) - 0x8000;
}

/* TODO: include a length so we don't read beyond the instructions array */
static const char *disassemble_opcode(const unsigned char *instructions, unsigned *consumed)
{
	static char buf[256];

	unsigned op = *instructions++;
	if (op < ARRAY_SIZE(opcode_to_name)) {
		const char *name = opcode_to_name[op];
		if (op == OP_LIT || op == OP_JMP || op == OP_JNE || op == OP_JEQ) {
			short v = read_short(instructions);
			snprintf(buf, sizeof(buf), "%s %hd", name, v);
			*consumed = 3;
			return buf;
		} else if (op == OP_SYS) {
			unsigned short v = read_short(instructions);
			snprintf(buf, sizeof(buf), "%s %hu", name, v);
			*consumed = 3;
			return buf;
		} else {
			*consumed = 1;
			return name;
		}
	}
	return "UNKNOWN"; // TODO: return a number value
}

static void disassemble(FILE *out, const unsigned char *opcode, size_t bytes)
{
	fprintf(out, "---8<--- start of disassembly (len=%zd) ---8<---\n", bytes);
	while (bytes > 0) {
		unsigned oplen;
		fprintf(out, "%s\n", disassemble_opcode(opcode, &oplen));
		opcode += oplen;
		bytes -= oplen;
	}
	fprintf(out, "---8<--- end of disassembly ---8<---\n");
}

static void rpush(struct vm *vm, vmword_t val)
{
	if (vm->r < ARRAY_SIZE(vm->rstack))
		vm->rstack[vm->r++] = val;
	else
		vm->status |= ERROR_STACK_OVERFLOW;
}

static vmword_t rpeek(struct vm *vm)
{
	assert(vm->r < ARRAY_SIZE(vm->rstack));
	if (vm->r)
		return vm->rstack[vm->r - 1];
	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static vmword_t rpop(struct vm *vm)
{
	if (vm->r)
		return vm->rstack[--vm->r];
	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static void dpush(struct vm *vm, vmword_t val)
{
	if (vm->d < ARRAY_SIZE(vm->dstack))
		vm->dstack[vm->d++] = val;
	else
		vm->status |= ERROR_STACK_OVERFLOW;
}

static vmword_t dpeek(struct vm *vm, unsigned ofs)
{
	assert(vm->d < ARRAY_SIZE(vm->dstack));
	assert(ofs > 0); /* must be 1 or greater */
	if (vm->d >= ofs)
		return vm->dstack[vm->d - ofs];
	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static vmword_t dpop(struct vm *vm)
{
	if (vm->d)
		return vm->dstack[--vm->d];
	vm->status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

/* round up len to next power of two minus one */
static size_t make_mask(size_t len)
{
	size_t ret;
	for (ret = 0; ret < len; ret = (ret << 1) | 1) ;
	return ret;
}

static void write_data_vmword(struct vm *vm, vmword_t offset, vmword_t value)
{
	// TODO: throw error on heap overflow
	trace("offset=%d mask=%#zx value=%d\n", offset, vm->heap_mask, value);
	vm->heap[offset & vm->heap_mask] = value;
}

static vmword_t read_data_vmword(struct vm *vm, vmword_t offset)
{
	// TODO: throw error on heap overflow
	assert(vm->heap != NULL);
	vmword_t result = vm->heap[offset & vm->heap_mask];
	trace("offset=%d mask=%#zx result=%d\n", offset, vm->heap_mask, result);
	return result;
}

static unsigned char read_code_byte(struct vm *vm, vmword_t offset)
{
	offset &= vm->code_mask; /* make offset in bounds for array */
	return vm->code[offset];
}

/* offset must be word aligned */
static char *read_string(struct vm *vm, vmword_t offset, size_t len)
{
	// TODO: check for overflow and null termination
	return (char*)&vm->heap[(offset / sizeof(vmword_t)) & vm->heap_mask];
}

/* read two bytes from code in little endian order,
 * use a little bitmath to sign extend the value */
static short read_code_short(struct vm *vm, vmword_t offset)
{
	unsigned m;

	offset &= vm->code_mask; /* make offset in bounds for array */
	m = vm->code[offset];
	offset = (offset + 1 ) & vm->code_mask;
	m |= (unsigned)vm->code[offset] << 8;

	return (m ^ 0x8000) - 0x8000;
}

static void vm_sys(struct vm *vm, unsigned num)
{
	vmword_t a; /* scratch area */

	switch (num) {
	case 0: /* EXIT ( -- ) : cause interpreter to exit cleanly */
		vm->status |= STATUS_FINISHED;
		break;
	case 1: /* PUTC ( c -- ) : output a character */
		printf("%c", dpop(vm));
		// fflush(stdout);
		break;
	case 2: /* CR ( -- ) : carriage return */
		printf("\n");
		break;
	case 3: /* PRINT_NUM ( n -- ) : output a number */
		printf(" %d", dpop(vm));
		// fflush(stdout);
		break;
	case 4: /* READ_TOK ( -- s ) : read a token */
		// TODO: copy next token into this address
		dpush(vm, TOK_BUF_OFFSET);
		break;
	case 5: { /* LOOKUP_DICT ( s -- xt ) : look up a dictionary entry */
		char *tok = read_string(vm, dpop(vm), TOK_BUF_LENGTH); // TODO: verify safety of the string
		dpush(vm, (intptr_t)dict_lookup(tok)); // TODO: create a handle for execution tokens instead of a raw pointer
		break;
	}
	case 6: { /* GETC ( -- c ) : read a character */
		int c = getchar();
		debug("GETC:c='%c' (%d)\n", isprint(c) ? c : '?', c);
		if (c == EOF)
			vm->status |= ERROR_END_OF_FILE;
		else
			dpush(vm, c);
		break;
	}
	case 7: { /* PUTSTR ( s -- ) : output a string */
		a = dpop(vm);
		size_t len = read_data_vmword(vm, a);
		char buf[len + 1];
		size_t i;
		// TODO: check range
		trace("TRACE\n");
		for (i = 0; i < len; i++)
			buf[i] = read_data_vmword(vm, a + i + 1); /* truncate to ASCII/ISO-8895-1 */
		buf[i] = 0;
		debug("[len=%zd] \"%.*s\"\n", len, (int)len, buf);
		printf("%s", buf);
		// fflush(stdout);
		break;
	}
	default:
		vm->status |= ERROR_SYSCALL;
	}
}

static void vm_run(struct vm *vm)
{
	vmword_t next_pc; /* scratch area */
	vmword_t a; /* scratch area */
	vmword_t b; /* scratch area */
	vmword_t top_r = vm->r; /* exit if we RET past here */

	/* append_code_xxx() leaves vm.pc to point at the end of code */
	vm->code_len = vm->pc;

	/* the interpreter will only use _mask, not _len for checks */
	vm->code_mask = make_mask(vm->code_len);
	vm->heap_mask = make_mask(vm->heap_len);
	vm->heap = calloc(sizeof(*vm->heap), vm->heap_mask + 1);

	vm->pc = 0;
	vm->status = 0;

	unsigned unused;
	while (!vm->status) {
		vm->pc &= vm->code_mask; /* keep PC in bounds */
		debug("PC:pc=%d op=%s\n", vm->pc, disassemble_opcode(&vm->code[vm->pc], &unused));
		switch (vm->code[vm->pc++]) {
		case 0x00: /* NOP */
			break;
		case 0x01: /* JMP */
			vm->pc += read_code_short(vm, vm->pc);
			break;
		case 0x02: /* JEQ - jump if equal */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a == b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x03: /* JNE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a != b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x04: /* JLE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a <= b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x05: /* JLT */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a < b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x06: /* JGE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a >= b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x07: /* JGT */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a > b)
				vm->pc = next_pc;
			else
				vm->pc += 2;
			break;
		case 0x08: /* CALL */
			rpush(vm, vm->pc);
			vm->pc = dpop(vm);
			break;
		case 0x09: /* RET */
			if (vm->r == top_r)
				goto finished; /* return up to the caller */
			vm->pc = rpop(vm);
			break;
		case 0x0a: /* LOAD */
			a = dpop(vm);
			debug("LOAD:@%d\n", a);
			dpush(vm, read_data_vmword(vm, a));
			break;
		case 0x0b: /* STORE */
			a = dpop(vm); /* addr */
			b = dpop(vm); /* value */
			write_data_vmword(vm, a, b);
			break;
		case 0x0c: /* LIT */
			dpush(vm, read_code_short(vm, vm->pc));
			vm->pc += 2;
			break;
		case 0x0d: /* COM */
			dpush(vm, ~dpop(vm));
			break;
		case 0x0e: /* XOR */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a ^ b);
			break;
		case 0x0f: /* AND */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a & b);
			break;
		case 0x10: /* ADD */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a + b);
			break;
		case 0x11: /* SHL */
			dpush(vm, dpop(vm) << 1);
			break;
		case 0x12: /* SHR */
			dpush(vm, dpop(vm) >> 1);
			break;
		case 0x13: /* DUP */
			a = dpeek(vm, 1);
			debug("DUP:%d\n", a);
			dpush(vm, a);
			break;
		case 0x14: /* DROP */
			dpop(vm);
			break;
		case 0x15: /* TOR */
			rpush(vm, dpop(vm));
			break;
		case 0x16: /* FROMR */
			dpush(vm, rpop(vm));
			break;
		case 0x17: /* COPYR */
			dpush(vm, rpeek(vm));
			break;
		case 0x18: /* OVER */
			dpush(vm, dpeek(vm, 2));
			break;
		case 0x19: /* SWAP */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a);
			dpush(vm, b);
			break;
		case 0x1a: /* DUPR */
			rpush(vm, rpeek(vm));
			break;
		case 0x1b: /* NIP */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a);
			break;
		case 0x1c: /* TUCK */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a);
			dpush(vm, b);
			dpush(vm, a);
			break;
		case 0x1d: /* SYS */
			// TODO: make this a read_code_byte()
			vm_sys(vm, read_code_short(vm, vm->pc));
			vm->pc += 2;
			break;
		case 0x1e: /* OR */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, a | b);
			break;
		case 0x1f: /* SUB */
			a = dpop(vm);
			b = dpop(vm);
			dpush(vm, b - a);
			break;
		default:
			vm->status |= ERROR_INVALID_OPCODE;
		}
	}
finished:
	if ((vm->status & ~STATUS_FINISHED)) {
		error("%s:error 0x%x (pc=0x%x)\n", vm->vm_filename, vm->status, vm->pc);
	}
	free(vm->heap);
	vm->heap = NULL;
}

/* use vm.pc to append a byte, grow vm.code_len to fit */
static void append_code_byte(struct vm *vm, unsigned b)
{
	if (vm->pc >= vm->code_len) {
		size_t code_len = vm->code_len ? vm->code_len * 2 : 1;
		while (vm->pc >= code_len)
			code_len *= 2;
		unsigned char *code = vm->code;
		code = realloc(code, code_len);
		if (!code) {
			perror("realloc()");
			exit(EXIT_FAILURE);
			// TODO: catch error
		}
		trace("new_code=%p new_code_len=%zd old_code_len=%zd\n", code, code_len, vm->code_len);
		if (code_len > vm->code_len)
			memset(code + vm->code_len, OP_RET, code_len - vm->code_len);
		vm->code_len = code_len;
		vm->code = code;
	}
	vm->code[vm->pc++] = b;
}

static void append_code_short(struct vm *vm, short s)
{
	vmword_t w = s;
	append_code_byte(vm, w & 255);
	w >>= 8;
	append_code_byte(vm, w & 255);
}

/* store a word in little endian order */
static void append_code_vmword(struct vm *vm, vmword_t w)
{
	append_code_byte(vm, w & 255);
	w >>= 8;
	append_code_byte(vm, w & 255);
	w >>= 8;
	append_code_byte(vm, w & 255);
	w >>= 8;
	append_code_byte(vm, w & 255);
}

static void append_code_seq(struct vm *vm, size_t oplen, const unsigned char *op)
{
	while (oplen > 0) {
		append_code_byte(vm, *op);
		op++;
		oplen--;
	}
}

/* process an incoming token */
static int vm_token(struct vm *vm, const char *token)
{
	struct dictdef *d = dict_lookup(token);
	trace("LOOKUP:result=%s\n", d->name);
	if (!d)
		return 0;
	if (d->code_field == DICT_CFA_INSERT_OPCODE) {
		append_code_seq(vm, d->parameter_field.opcode_len, d->parameter_field.opcode);
		return 1;
	} else {
		error("%s:unknown action %p\n", token, d->code_field);
		return 0;
	}
	return 0;
}

static int vm_load(struct vm *vm, const char *filename)
{
	FILE *f;

	memset(vm, 0, sizeof(*vm));
	vm->vm_filename = filename;

	f = fopen(filename, "r");
	if (!f) {
		perror(filename);
		return 0;
	}

	char token[64] = "";
	size_t token_len = 0;
	int c;
	while ((c = fgetc(f)) != EOF) {
		if (c == '\\') {
			while ((c = fgetc(f)) != '\n')
				if (c == EOF)
					goto missing_nl;
			continue;
		}
		if (isspace(c)) {
			if (token_len) {
				char *endptr;
				errno = 0;
				long value = strtol(token, &endptr, 0);
				if (!errno && endptr != token) { /* is it a number? */
					append_code_short(vm, value);
					trace("VALUE:%ld\n", value);
				} else if (vm_token(vm, token)) { /* is it a word? */
					trace("APPEND:%s\n", token);
				} else {
					error("%s:unknown token '%s'\n", vm->vm_filename, token);
					goto failure;
				}
				// TODO: do something with append_code_vmword()
			}
			token_len = 0;
		} else if (token_len >= sizeof(token) - 1) {
			error("%s:overflow of token buffer\n", vm->vm_filename);
			goto failure;
		} else {
			/* append a character */
			token[token_len++] = c;
			token[token_len] = 0;
		}
	}
	if (token_len != 0) {
missing_nl:
		error("%s:EOF before end of last line\n", vm->vm_filename);
		goto failure;
	}
	fclose(f);
	return 1; /* success */

failure:
	fclose(f);
	return 0; /* failure */

}

/*** Main ***/

static const char *progname; /* basename of argv[0] */
static size_t opt_heap_len = 1024;
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
				} else if (*s == 'm' && i + 1 < argc) {
					opt_heap_len = strtol(argv[++i], 0, 0);
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

int main(int argc, char **argv)
{
	struct vm vm;
	process_args(argc, argv);

	dict_generate_from_opcode_to_name();
	if (!vm_load(&vm, opt_vm_filename)) {
		error("%s:could not load file\n", opt_vm_filename);
		return EXIT_FAILURE;
	}
	vm.heap_len = opt_heap_len;
	disassemble(stdout, vm.code, vm.code_len);

	vm_run(&vm);

	return EXIT_SUCCESS;
}
