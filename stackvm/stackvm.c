/* stackvm.c - small demonstration language */
/* PUBLIC DOMAIN - Jon Mayo
 * original: June 23, 2011
 * updated: June 11, 2014 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

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

#define OP_RET 9
#define OP_LIT 12
#define OP_SYS 29
static char *opcode_to_name[] = {
	"NOP", "JUMP", "JEQ", "JNE",
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
		if (op == OP_LIT) {
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
	vm->heap[offset & vm->heap_mask] = value;
}

static vmword_t read_data_vmword(struct vm *vm, vmword_t offset)
{
	return vm->heap[offset & vm->heap_mask];
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
	switch (num) {
	case 0: /* EXIT ( -- ) : cause interpreter to exit cleanly */
		vm->status |= STATUS_FINISHED;
		break;
	case 1: /* PUTC ( c -- ) : output a character */
		printf("%c", dpop(vm));
		fflush(stdout);
		break;
	case 2: /* CR ( -- ) : carriage return */
		printf("\n");
		break;
	case 3: /* PRINT_NUM ( n -- ) : output a number */
		printf(" %d", dpop(vm));
		fflush(stdout);
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

	vm->pc = 0;
	vm->status = 0;

	while (!vm->status) {
		vm->pc &= vm->code_mask; /* keep PC in bounds */
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
			break;
		case 0x03: /* JNE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a != b)
				vm->pc = next_pc;
			break;
		case 0x04: /* JLE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a <= b)
				vm->pc = next_pc;
			break;
		case 0x05: /* JLT */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a < b)
				vm->pc = next_pc;
			break;
		case 0x06: /* JGE */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a >= b)
				vm->pc = next_pc;
			break;
		case 0x07: /* JGT */
			a = dpop(vm);
			b = dpop(vm);
			next_pc = vm->pc + read_code_short(vm, vm->pc);
			if (a > b)
				vm->pc = next_pc;
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
			dpush(vm, read_data_vmword(vm, dpop(vm)));
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
			dpush(vm, dpeek(vm, 1));
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
			vm_sys(vm, read_code_byte(vm, vm->pc++));
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
		fprintf(stderr, "%s:error 0x%x (pc=0x%x)\n", vm->vm_filename,
			vm->status, vm->pc);
	}
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
		fprintf(stderr, "new_code=%p new_code_len=%zd old_code_len=%zd\n", code, code_len, vm->code_len);
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
	if (d) {
		if (d->code_field == DICT_CFA_INSERT_OPCODE) {
			append_code_seq(vm, d->parameter_field.opcode_len, d->parameter_field.opcode);
			return 1;
		} else {
			fprintf(stderr, "%s:unknown action %p\n", token, d->code_field);
			return 0;
		}
	}
	fprintf(stderr, "%s:unknown token '%s'\n", vm->vm_filename, token);
	return 0;
}

static int vm_load(struct vm *vm, const char *filename)
{
	FILE *f;
	char token[64];
	long value;

	memset(vm, 0, sizeof(*vm));
	vm->vm_filename = filename;

	f = fopen(filename, "r");
	if (!f) {
		perror(filename);
		return 0;
	}

	while (1) {
		fscanf(f, " ;%*[^\n]"); /* ignore comments */
		if (fscanf(f, " %ld", &value) == 1) {
			append_code_short(vm, value);
		} else if (fscanf(f, " #%ld", &value) == 1) {
			append_code_vmword(vm, value);
		} else if (fscanf(f, " %63[^ \t\n]", token) == 1) {
			if (!vm_token(vm, token))
				break;
		} else if (feof(f)) {
			fclose(f);
			return 1; /* success */
		} else if (ferror(f)) {
			perror(filename);
			break;
		} else {
			fprintf(stderr, "%s:parse error\n", filename);
			break;
		}
	}

	fclose(f);
	return 0; /* failure */

}

/*** Main ***/

static const char *progname; /* basename of argv[0] */
static size_t opt_heap_len;
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
					fprintf(stderr, "%s:bad flag '%c'\n",
						progname, *s);
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
	vm.heap_len = opt_heap_len;

	dict_generate_from_opcode_to_name();
	if (!vm_load(&vm, opt_vm_filename)) {
		fprintf(stderr, "%s:could not load file\n", opt_vm_filename);
		return EXIT_FAILURE;
	}
	disassemble(stdout, vm.code, vm.code_len);

	vm_run(&vm);

	return EXIT_SUCCESS;
}
