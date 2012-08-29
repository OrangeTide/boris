/* stackvm.c - small demonstration language */
/* PUBLIC DOMAIN - Jon Mayo - June 23, 2011 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

typedef unsigned vmword_t;

static const char *progname; /* basename of argv[0] */
static const char *vm_filename;
static struct {
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
} vm;
static char *name_to_opcode[] = {
	"NOP", "JUMP", "JEQ", "JNE",
	"JLE", "JLT", "JGE", "JGT",
	"CALL", "RET", "LOAD", "STORE",
	"LIT", "COM", "XOR", "AND",
	"ADD", "SHL", "SHR", "DUP",
	"DROP", "TOR", "FROMR", "COPYR",
	"OVER", "SWAP", "DUPR", "NIP",
	"TUCK", "SYS", "OR", "SUB",
};

static void rpush(vmword_t val)
{
	if (vm.r < ARRAY_SIZE(vm.rstack))
		vm.rstack[vm.r++] = val;
	else
		vm.status |= ERROR_STACK_OVERFLOW;
}

static vmword_t rpeek(void)
{
	assert(vm.r < ARRAY_SIZE(vm.rstack));
	if (vm.r)
		return vm.rstack[vm.r - 1];
	vm.status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static vmword_t rpop(void)
{
	if (vm.r)
		return vm.rstack[--vm.r];
	vm.status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static void dpush(vmword_t val)
{
	if (vm.d < ARRAY_SIZE(vm.dstack))
		vm.dstack[vm.d++] = val;
	else
		vm.status |= ERROR_STACK_OVERFLOW;
}

static vmword_t dpeek(unsigned ofs)
{
	assert(vm.d < ARRAY_SIZE(vm.dstack));
	assert(ofs > 0); /* must be 1 or greater */
	if (vm.d >= ofs)
		return vm.dstack[vm.d - ofs];
	vm.status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

static vmword_t dpop(void)
{
	if (vm.d)
		return vm.dstack[--vm.d];
	vm.status |= ERROR_STACK_UNDERFLOW;
	return 0xdeadbeef;
}

/* round up len to next power of two minus one */
static size_t make_mask(size_t len)
{
	size_t ret;
	for (ret = 0; ret < len; ret = (ret << 1) | 1) ;
	return ret;
}

static void write_data_vmword(vmword_t offset, vmword_t value)
{
	vm.heap[offset & vm.heap_mask] = value;
}

static vmword_t read_data_vmword(vmword_t offset)
{
	return vm.heap[offset & vm.heap_mask];
}

static unsigned char read_code_byte(vmword_t offset)
{
	offset &= vm.code_mask; /* make offset in bounds for array */
	return vm.code[offset];
}

/* read two bytes from code in little endian order,
 * use a little bitmath to sign extend the value */
static short read_code_short(vmword_t offset)
{
	unsigned m;

	offset &= vm.code_mask; /* make offset in bounds for array */
	m = vm.code[offset];
	offset = (offset + 1 ) & vm.code_mask;
	m |= (unsigned)vm.code[offset] << 8;

	return (m ^ 0x8000) - 0x8000;
}

static void vm_sys(unsigned num)
{
	switch (num) {
	case 0: /* EXIT - cause interpreter to exit cleanly */
		vm.status |= STATUS_FINISHED;
		break;
	case 1: /* PUTC - output a character */
		printf("%c", dpop());
		fflush(stdout);
		break;
	case 2: /* CR - carriage return */
		printf("\n");
		break;
	case 3: /* PRINT_NUM - output a number */
		printf(" %d", dpop());
		fflush(stdout);
		break;
	default:
		vm.status |= ERROR_SYSCALL;
	}
}

static void vm_run(void)
{
	vmword_t next_pc; /* scratch area */
	vmword_t a; /* scratch area */
	vmword_t b; /* scratch area */

	/* append_code_xxx() leaves vm.pc to point at the end of code */
	vm.code_len = vm.pc;

	/* the interpreter will only use _mask, not _len for checks */
	vm.code_mask = make_mask(vm.code_len);
	vm.heap_mask = make_mask(vm.heap_len);

	vm.pc = 0;
	vm.status = 0;

	while (!vm.status) {
		vm.pc &= vm.code_mask; /* keep PC in bounds */
		switch (vm.code[vm.pc++]) {
		case 0x00: /* NOP */
			break;
		case 0x01: /* JMP */
			vm.pc += read_code_short(vm.pc);
			break;
		case 0x02: /* JEQ - jump if equal */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a == b)
				vm.pc = next_pc;
			break;
		case 0x03: /* JNE */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a != b)
				vm.pc = next_pc;
			break;
		case 0x04: /* JLE */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a <= b)
				vm.pc = next_pc;
			break;
		case 0x05: /* JLT */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a < b)
				vm.pc = next_pc;
			break;
		case 0x06: /* JGE */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a >= b)
				vm.pc = next_pc;
			break;
		case 0x07: /* JGT */
			a = dpop();
			b = dpop();
			next_pc = vm.pc + read_code_short(vm.pc);
			if (a > b)
				vm.pc = next_pc;
			break;
		case 0x08: /* CALL */
			rpush(vm.pc);
			vm.pc = dpop();
			break;
		case 0x09: /* RET */
			vm.pc = rpop();
			break;
		case 0x0a: /* LOAD */
			dpush(read_data_vmword(dpop()));
			break;
		case 0x0b: /* STORE */
			a = dpop(); /* addr */
			b = dpop(); /* value */
			write_data_vmword(a, b);
			break;
		case 0x0c: /* LIT */
			dpush(read_code_short(vm.pc));
			vm.pc += 2;
			break;
		case 0x0d: /* COM */
			dpush(~dpop());
			break;
		case 0x0e: /* XOR */
			a = dpop();
			b = dpop();
			dpush(a ^ b);
			break;
		case 0x0f: /* AND */
			a = dpop();
			b = dpop();
			dpush(a & b);
			break;
		case 0x10: /* ADD */
			a = dpop();
			b = dpop();
			dpush(a + b);
			break;
		case 0x11: /* SHL */
			dpush(dpop() << 1);
			break;
		case 0x12: /* SHR */
			dpush(dpop() >> 1);
			break;
		case 0x13: /* DUP */
			dpush(dpeek(1));
			break;
		case 0x14: /* DROP */
			dpop();
			break;
		case 0x15: /* TOR */
			rpush(dpop());
			break;
		case 0x16: /* FROMR */
			dpush(rpop());
			break;
		case 0x17: /* COPYR */
			dpush(rpeek());
			break;
		case 0x18: /* OVER */
			dpush(dpeek(2));
			break;
		case 0x19: /* SWAP */
			a = dpop();
			b = dpop();
			dpush(a);
			dpush(b);
			break;
		case 0x1a: /* DUPR */
			rpush(rpeek());
			break;
		case 0x1b: /* NIP */
			a = dpop();
			b = dpop();
			dpush(a);
			break;
		case 0x1c: /* TUCK */
			a = dpop();
			b = dpop();
			dpush(a);
			dpush(b);
			dpush(a);
			break;
		case 0x1d: /* SYS */
			vm_sys(read_code_byte(vm.pc++));
			break;
		case 0x1e: /* OR */
			a = dpop();
			b = dpop();
			dpush(a | b);
			break;
		case 0x1f: /* SUB */
			a = dpop();
			b = dpop();
			dpush(b - a);
			break;
		default:
			vm.status |= ERROR_INVALID_OPCODE;
		}
	}

	if ((vm.status & ~STATUS_FINISHED)) {
		fprintf(stderr, "%s:error 0x%x (pc=0x%x)\n", vm_filename,
			vm.status, vm.pc);
	}
}

/* use vm.pc to append a byte, grow vm.code_len to fit */
static void append_code_byte(unsigned b)
{
	if (vm.pc >= vm.code_len) {
		vm.code_len = vm.pc * 2;
		vm.code = realloc(vm.code, vm.code_len);
		if (!vm.code) {
			perror("realloc()");
			exit(EXIT_FAILURE);
		}
	}
	vm.code[vm.pc++] = b;
}

static void append_code_short(short s)
{
	vmword_t w = s;
	append_code_byte(w & 255);
	w >>= 8;
	append_code_byte(w & 255);
	w >>= 8;
}

/* store a word in little endian order */
static void append_code_vmword(vmword_t w)
{
	append_code_byte(w & 255);
	w >>= 8;
	append_code_byte(w & 255);
	w >>= 8;
	append_code_byte(w & 255);
	w >>= 8;
	append_code_byte(w & 255);
}


/* process an incoming token */
static int vm_token(const char *token)
{
	unsigned i;
	for (i = 0; i < ARRAY_SIZE(name_to_opcode); i++) {
		if (!strcasecmp(name_to_opcode[i], token)) {
			append_code_byte(i);
			return 1;
		}
	}
	fprintf(stderr, "%s:unknown token '%s'\n", vm_filename, token);
	return 0;
}

static int vm_load(const char *filename)
{
	FILE *f;
	char token[64];
	long value;

	f = fopen(filename, "r");
	if (!f) {
		perror(filename);
		return 0;
	}

	while (1) {
		fscanf(f, " ;%*[^\n]"); /* ignore comments */
		if (fscanf(f, " %ld", &value) == 1) {
			append_code_short(value);
		} else if (fscanf(f, " #%ld", &value) == 1) {
			append_code_vmword(value);
		} else if (fscanf(f, " %63[^ \t\n]", token) == 1) {
			if (!vm_token(token))
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
					vm.heap_len = strtol(argv[++i], 0, 0);
				} else {
					fprintf(stderr, "%s:bad flag '%c'\n",
						progname, *s);
					usage();
				}
			}
		} else if (!vm_filename) { /* require exactly 1 filename */
			vm_filename = argv[i];
		} else {
			usage();
		}
	}

	if (!vm_filename)
		usage();
}

int main(int argc, char **argv)
{
	process_args(argc, argv);

	if (!vm_load(vm_filename)) {
		fprintf(stderr, "%s:could not load file\n", vm_filename);
		return EXIT_FAILURE;
	}

	vm_run();

	return EXIT_SUCCESS;
}
