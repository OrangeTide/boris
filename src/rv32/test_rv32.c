/* test_rv32.c : unit tests for the vendored RV32 core and ELF32 loader */

#include "rv32.h"
#include "elf32.h"

#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "ctest.h"

/****************************************************************
 * Bounded flat memory image and bus seam
 *
 * A single little-endian RAM block with bounds-checked callbacks. The
 * probe is the out-of-range enforcement: it faults any access that would
 * leave the image, so the core takes an access-fault trap rather than the
 * callbacks ever touching host memory out of range. This is the minimal
 * host seam a task memory image will provide in the VM runtime.
 ****************************************************************/

#define MEM_SIZE 0x10000u       /* 64 KiB */

struct flatmem {
	uint8_t ram[MEM_SIZE];
};

static int
in_range(uint32_t addr, uint32_t size)
{
	return addr < MEM_SIZE && size <= MEM_SIZE - addr;
}

static uint32_t
mem_r8(void *ctx, uint32_t addr)
{
	struct flatmem *m = ctx;
	return in_range(addr, 1) ? m->ram[addr] : 0;
}

static uint32_t
mem_r16(void *ctx, uint32_t addr)
{
	struct flatmem *m = ctx;
	if (!in_range(addr, 2))
		return 0;
	return (uint32_t)m->ram[addr] | ((uint32_t)m->ram[addr + 1] << 8);
}

static uint32_t
mem_r32(void *ctx, uint32_t addr)
{
	struct flatmem *m = ctx;
	if (!in_range(addr, 4))
		return 0;
	return (uint32_t)m->ram[addr] |
	       ((uint32_t)m->ram[addr + 1] << 8) |
	       ((uint32_t)m->ram[addr + 2] << 16) |
	       ((uint32_t)m->ram[addr + 3] << 24);
}

static void
mem_w8(void *ctx, uint32_t addr, uint32_t val)
{
	struct flatmem *m = ctx;
	if (in_range(addr, 1))
		m->ram[addr] = (uint8_t)val;
}

static void
mem_w16(void *ctx, uint32_t addr, uint32_t val)
{
	struct flatmem *m = ctx;
	if (!in_range(addr, 2))
		return;
	m->ram[addr] = (uint8_t)val;
	m->ram[addr + 1] = (uint8_t)(val >> 8);
}

static void
mem_w32(void *ctx, uint32_t addr, uint32_t val)
{
	struct flatmem *m = ctx;
	if (!in_range(addr, 4))
		return;
	m->ram[addr] = (uint8_t)val;
	m->ram[addr + 1] = (uint8_t)(val >> 8);
	m->ram[addr + 2] = (uint8_t)(val >> 16);
	m->ram[addr + 3] = (uint8_t)(val >> 24);
}

/** Access check: nonzero raises a fault. Anything leaving the image faults. */
static int
mem_probe(void *ctx, uint32_t addr, int size, int is_write)
{
	(void)ctx;
	(void)is_write;
	return in_range(addr, (uint32_t)size) ? 0 : 1;
}

/** Poke callback for the ELF loader: write one byte if it lands in range. */
static void
mem_poke(void *ctx, uint32_t addr, uint8_t byte)
{
	struct flatmem *m = ctx;
	if (in_range(addr, 1))
		m->ram[addr] = byte;
}

/****************************************************************
 * Stub environment-call handler
 *
 * The real host-call dispatch is a later card. Here the handler records the
 * call and halts the machine so a test regains control after an ecall.
 ****************************************************************/

struct ecall_state {
	int      called;
	uint32_t a7;            /* selector register */
	uint32_t a0;            /* first argument register */
};

static int
stub_ecall(rv_cpu *cpu, void *ctx)
{
	struct ecall_state *e = ctx;
	e->called++;
	e->a7 = rv_get_x(cpu, 17);
	e->a0 = rv_get_x(cpu, 10);
	rv_halt(cpu);
	return 0;               /* handled: do not take the ecall trap */
}

/****************************************************************
 * Helpers
 ****************************************************************/

static struct flatmem g_mem;

static void
put32(uint32_t addr, uint32_t word)
{
	g_mem.ram[addr + 0] = (uint8_t)word;
	g_mem.ram[addr + 1] = (uint8_t)(word >> 8);
	g_mem.ram[addr + 2] = (uint8_t)(word >> 16);
	g_mem.ram[addr + 3] = (uint8_t)(word >> 24);
}

/** Wire a CPU to the flat memory image, with the probe and ecall stub. */
static void
setup(rv_cpu *cpu, struct ecall_state *e, uint32_t entry)
{
	memset(e, 0, sizeof(*e));
	rv_init(cpu, mem_r8, mem_r16, mem_r32, mem_w8, mem_w16, mem_w32, &g_mem);
	rv_set_probe(cpu, mem_probe);
	rv_set_ecall(cpu, stub_ecall, e);
	rv_reset(cpu, entry);
}

/****************************************************************
 * Tests
 ****************************************************************/

/* Execute a short program and confirm the arithmetic and the ecall seam. */
static void
test_execute(void)
{
	rv_cpu cpu;
	struct ecall_state e;

	memset(&g_mem, 0, sizeof(g_mem));
	put32(0x00, 0x01400293);        /* addi x5, x0, 20   */
	put32(0x04, 0x01628313);        /* addi x6, x5, 22   -> x6 = 42 */
	put32(0x08, 0x00000073);        /* ecall             -> halts   */

	setup(&cpu, &e, 0x00);
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_HALT,
	          "run stops with a halt reason at the ecall");

	EXPECT_EQ(rv_get_x(&cpu, 5), 20, "addi loads an immediate");
	EXPECT_EQ(rv_get_x(&cpu, 6), 42, "addi adds register and immediate");
	EXPECT_EQ(e.called, 1, "ecall handler ran exactly once");
	EXPECT(cpu.halted, "machine halted after ecall");
}

/* An out-of-range store faults instead of writing anywhere. */
static void
test_store_fault(void)
{
	rv_cpu cpu;
	struct ecall_state e;

	memset(&g_mem, 0, sizeof(g_mem));
	put32(0x00, 0x400002B7);        /* lui  x5, 0x40000  -> x5 = 0x40000000 */
	put32(0x04, 0x0002A023);        /* sw   x0, 0(x5)    -> out of range    */

	setup(&cpu, &e, 0x00);
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_TRAP,
	          "run returns a trap reason on the stray store");
	EXPECT_EQ(cpu.mcause, RV_CAUSE_STORE_ACCESS_FAULT,
	          "out-of-range store raises a store access fault");
	EXPECT_EQ_X(cpu.mtval, 0x40000000u, "mtval reports the faulting address");
}

/* An out-of-range load faults instead of reading host memory. */
static void
test_load_fault(void)
{
	rv_cpu cpu;
	struct ecall_state e;

	memset(&g_mem, 0, sizeof(g_mem));
	put32(0x00, 0x400002B7);        /* lui  x5, 0x40000  -> x5 = 0x40000000 */
	put32(0x04, 0x0002A303);        /* lw   x6, 0(x5)    -> out of range    */

	setup(&cpu, &e, 0x00);
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_TRAP,
	          "run returns a trap reason on the stray load");
	EXPECT_EQ(cpu.mcause, RV_CAUSE_LOAD_ACCESS_FAULT,
	          "out-of-range load raises a load access fault");
	EXPECT_EQ_X(cpu.mtval, 0x40000000u, "mtval reports the faulting address");
}

/****************************************************************
 * ELF32 loader test
 *
 * A hand-built minimal ELF32 little-endian RISC-V executable: one PT_LOAD
 * segment carrying two instructions at 0x1000. Building it inline keeps the
 * test self-contained, with no toolchain and no binary fixture.
 ****************************************************************/

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

/* Fill buf with a minimal ELF and return its length. */
static long
build_test_elf(uint8_t *buf)
{
	uint8_t *eh = buf;              /* ELF header at 0            */
	uint8_t *ph = buf + 52;         /* one program header at 52   */
	uint8_t *code = buf + 84;       /* segment contents at 84     */

	memset(buf, 0, 128);

	/* e_ident */
	eh[0] = 0x7f; eh[1] = 'E'; eh[2] = 'L'; eh[3] = 'F';
	eh[4] = 1;                      /* ELFCLASS32 */
	eh[5] = 1;                      /* ELFDATA2LSB */
	eh[6] = 1;                      /* EI_VERSION */
	le16(eh + 16, 2);               /* e_type = ET_EXEC */
	le16(eh + 18, EM_RISCV);        /* e_machine */
	le32(eh + 20, 1);               /* e_version */
	le32(eh + 24, 0x1000);          /* e_entry */
	le32(eh + 28, 52);              /* e_phoff */
	le32(eh + 32, 0);               /* e_shoff */
	le32(eh + 36, 0);               /* e_flags */
	le16(eh + 40, 52);              /* e_ehsize */
	le16(eh + 42, 32);              /* e_phentsize */
	le16(eh + 44, 1);               /* e_phnum */
	le16(eh + 46, 0);               /* e_shentsize */
	le16(eh + 48, 0);               /* e_shnum */
	le16(eh + 50, 0);               /* e_shstrndx */

	/* program header: PT_LOAD */
	le32(ph + 0, 1);                /* p_type = PT_LOAD */
	le32(ph + 4, 84);               /* p_offset */
	le32(ph + 8, 0x1000);           /* p_vaddr */
	le32(ph + 12, 0x1000);          /* p_paddr */
	le32(ph + 16, 8);               /* p_filesz */
	le32(ph + 20, 8);               /* p_memsz */
	le32(ph + 24, 4 | 1);           /* p_flags = PF_R | PF_X */
	le32(ph + 28, 0x1000);          /* p_align */

	/* segment contents: two instructions */
	le32(code + 0, 0x06300513);     /* addi x10, x0, 99 */
	le32(code + 4, 0x00000073);     /* ecall            */

	return 92;
}

static void
test_elf_loader(void)
{
	uint8_t buf[128];
	long len;
	elf32_info info;
	uint32_t entry;
	rv_cpu cpu;
	struct ecall_state e;

	len = build_test_elf(buf);

	memset(&info, 0, sizeof(info));
	EXPECT_EQ(elf32_probe_mem(buf, len, &info), 0, "probe accepts the image");
	EXPECT_EQ(info.machine, EM_RISCV, "probe reports the RISC-V machine");

	memset(&g_mem, 0, sizeof(g_mem));
	memset(&info, 0, sizeof(info));
	entry = elf32_load_raw_mem(buf, len, mem_poke, &g_mem, "<test-elf>",
	                           &info);

	EXPECT_EQ_X(entry, 0x1000u, "loader returns the entry point");
	EXPECT_EQ(info.nsegments, 1, "one loadable segment");
	EXPECT_EQ_X(mem_r32(&g_mem, 0x1000), 0x06300513u,
	            "first instruction landed at the entry");
	EXPECT_EQ_X(mem_r32(&g_mem, 0x1004), 0x00000073u,
	            "second instruction landed after it");

	/* Run the loaded image and confirm it computes what it should. */
	setup(&cpu, &e, entry);
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_HALT,
	          "loaded program halts at its ecall");
	EXPECT_EQ(rv_get_x(&cpu, 10), 99, "loaded program set a0 to 99");
	EXPECT_EQ(e.called, 1, "loaded program reached its ecall");
}

/* The loader rejects a buffer that is not an ELF image. */
static void
test_elf_reject(void)
{
	uint8_t junk[64];
	elf32_info info;

	memset(junk, 0xA5, sizeof(junk));
	EXPECT_EQ(elf32_probe_mem(junk, sizeof(junk), &info), -1,
	          "probe rejects a non-ELF buffer");
}

/* wfi parks the machine and rv_run reports it as a cooperative yield. */
static void
test_yield(void)
{
	rv_cpu cpu;
	struct ecall_state e;

	memset(&g_mem, 0, sizeof(g_mem));
	put32(0x00, 0x10500073);        /* wfi   -> park */
	put32(0x04, 0x00000073);        /* ecall -> halt (only if resumed) */

	setup(&cpu, &e, 0x00);
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_YIELD,
	          "wfi returns a yield reason");
	EXPECT(cpu.waiting, "wfi set the wait flag");
	EXPECT_EQ(e.called, 0, "parked before reaching the ecall");

	/* Resume: the host clears the wait bit and runs on. */
	cpu.waiting = 0;
	EXPECT_EQ(rv_run(&cpu, 100, NULL), RV_RUN_HALT,
	          "resumes past wfi and halts");
	EXPECT_EQ(e.called, 1, "reached the ecall after resuming");
}

int
main(void)
{
	test_execute();
	test_store_fault();
	test_load_fault();
	test_yield();
	test_elf_loader();
	test_elf_reject();
	return ctest_report("rv32");
}
