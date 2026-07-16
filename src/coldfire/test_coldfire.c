/* test_coldfire.c : self-contained test suite for the ColdFire V4e emulator */
/* No cross-compiler needed -- test binaries are embedded as const arrays. */
/* PUBLIC DOMAIN (CC0-1.0) */

#include "coldfire.h"

#include <stdio.h>
#include <string.h>

static int failures;
static int passes;

#define FAIL(fmt, ...) do { \
    fprintf(stderr, "FAIL %s:%d " fmt "\n", __func__, __LINE__, ##__VA_ARGS__); \
    failures++; \
} while (0)

#define OK(label) do { printf("ok   %s\n", (label)); passes++; } while (0)

#define EXPECT_EQ(actual, expected, label) do { \
    if ((actual) != (expected)) \
        FAIL("%s: got %u expected %u", (label), \
             (unsigned)(actual), (unsigned)(expected)); \
    else OK(label); \
} while (0)

#define EXPECT_EQ_X(actual, expected, label) do { \
    if ((actual) != (expected)) \
        FAIL("%s: got 0x%08x expected 0x%08x", (label), \
             (unsigned)(actual), (unsigned)(expected)); \
    else OK(label); \
} while (0)

/****************************************************************
 * Flat 16 MB memory with big-endian bus callbacks
 ****************************************************************/

#define MEM_SIZE (16 * 1024 * 1024)
static uint8_t mem[MEM_SIZE];

static uint32_t
mem_read8(void *ctx, uint32_t addr)
{
    (void)ctx;
    if (addr < MEM_SIZE)
        return mem[addr];
    return 0;
}

static uint32_t
mem_read16(void *ctx, uint32_t addr)
{
    (void)ctx;
    if (addr + 1 < MEM_SIZE)
        return ((uint32_t)mem[addr] << 8) | mem[addr + 1];
    return 0;
}

static uint32_t
mem_read32(void *ctx, uint32_t addr)
{
    (void)ctx;
    if (addr + 3 < MEM_SIZE)
        return ((uint32_t)mem[addr] << 24) | ((uint32_t)mem[addr + 1] << 16) |
               ((uint32_t)mem[addr + 2] << 8) | mem[addr + 3];
    return 0;
}

static void
mem_write8(void *ctx, uint32_t addr, uint32_t val)
{
    (void)ctx;
    if (addr < MEM_SIZE)
        mem[addr] = val & 0xFF;
}

static void
mem_write16(void *ctx, uint32_t addr, uint32_t val)
{
    (void)ctx;
    if (addr + 1 < MEM_SIZE) {
        mem[addr]     = (val >> 8) & 0xFF;
        mem[addr + 1] = val & 0xFF;
    }
}

static void
mem_write32(void *ctx, uint32_t addr, uint32_t val)
{
    (void)ctx;
    if (addr + 3 < MEM_SIZE) {
        mem[addr]     = (val >> 24) & 0xFF;
        mem[addr + 1] = (val >> 16) & 0xFF;
        mem[addr + 2] = (val >> 8) & 0xFF;
        mem[addr + 3] = val & 0xFF;
    }
}

/****************************************************************
 * Helper: init CPU with flat memory, TRAP #0 -> HALT
 ****************************************************************/

static void
setup_cpu(cf_cpu *cpu, uint32_t entry)
{
    memset(mem, 0, MEM_SIZE);
    cf_init(cpu, mem_read8, mem_read16, mem_read32,
            mem_write8, mem_write16, mem_write32, NULL);

    mem_write32(NULL, 0x00, MEM_SIZE);
    mem_write32(NULL, 0x04, entry);
    mem_write32(NULL, 32 * 4, 0x00000200);
    mem_write16(NULL, 0x200, 0x4AC8);  /* HALT */

    cf_reset(cpu);
}

/****************************************************************
 * Embedded test binary (fibonacci, gcd, sum, bits, FPU sqrt)
 ****************************************************************
 * Source: test_program.c, compiled with:
 *   m68k-linux-gnu-gcc -mcpu=5475 -O2 -nostdlib -static -ffreestanding
 *                      -T link.ld -o test_program.elf test_program.c
 *
 * Tests: fibonacci(10)=55, gcd(252,105)=21, sum_to(100)=5050,
 *        bit_test(0xAB)=0x0A55, sqrt_approx(2.0)=1414
 ****************************************************************/

#define LOAD_ADDR  0x00010024
#define ENTRY_ADDR 0x00010024

static const uint8_t test_image[] = {
    /* _start */
    0x51,0x8f,
    0xf2,0x17,0xf0,0x20,
    0x2f,0x03,
    0x2f,0x02,
    0x48,0x78,0x00,0x0a,
    0x4e,0xb9,0x00,0x01,0x01,0x04,
    0x75,0xfc,0x00,0xfc,
    0x58,0x8f,
    0x72,0x69,
    0x23,0xc0,0x00,0x01,0x03,0xc2,
    0x4c,0x41,0x20,0x03,
    0x20,0x01,
    0x24,0x00,
    0x22,0x03,
    0x4a,0x83,
    0x66,0xf2,
    0x42,0xa7,
    0x2f,0x3c,0x3f,0xf0,0x00,0x00,
    0xf2,0x1f,0x54,0x44,
    0x73,0xfc,0x13,0xba,
    0x77,0xfc,0x0a,0x55,
    0x23,0xc0,0x00,0x01,0x03,0xbe,
    0x70,0x14,
    0x23,0xc1,0x00,0x01,0x03,0xba,
    0x23,0xc3,0x00,0x01,0x03,0xb6,
    0x53,0x80,
    0x42,0xa7,
    0x2f,0x3c,0x40,0x00,0x00,0x00,
    0xf2,0x1f,0x54,0xc4,
    0xf2,0x00,0x00,0xe4,
    0xf2,0x00,0x04,0x66,
    0x42,0xa7,
    0x2f,0x3c,0x3f,0xe0,0x00,0x00,
    0xf2,0x1f,0x54,0xc4,
    0xf2,0x00,0x04,0x67,
    0x4a,0x80,
    0x66,0xd6,
    0x42,0xa7,
    0x2f,0x3c,0x40,0x8f,0x40,0x00,
    0xf2,0x1f,0x54,0xc4,
    0x42,0xa7,
    0x2f,0x3c,0x41,0xe0,0x00,0x00,
    0xf2,0x1f,0x55,0x44,
    0xf2,0x00,0x04,0x67,
    0xf2,0x00,0x08,0x38,
    0xf2,0x93,0x00,0x14,
    0xf2,0x00,0x00,0x03,
    0xf2,0x00,0x60,0x00,
    0x23,0xc0,0x00,0x01,0x03,0xb2,
    0x4e,0x40,
    0x60,0xfe,
    0x42,0xa7,
    0x2f,0x3c,0x41,0xe0,0x00,0x00,
    0xf2,0x1f,0x54,0xc4,
    0xf2,0x00,0x04,0x6c,
    0xf2,0x00,0x00,0x03,
    0xf2,0x00,0x60,0x00,
    0x06,0x80,0x80,0x00,0x00,0x00,
    0x23,0xc0,0x00,0x01,0x03,0xb2,
    0x4e,0x40,
    0x60,0xd6,

    /* fibonacci */
    0x4f,0xef,0xff,0x8c,
    0xa3,0x40,
    0x20,0x6f,0x00,0x78,
    0x48,0xd7,0x7c,0xfc,
    0xb0,0x88,
    0x67,0x00,0x01,0xe6,
    0x20,0x08,
    0x72,0xfe,
    0x53,0x80,
    0xc2,0x80,
    0x24,0x08,
    0x2f,0x48,0x00,0x3c,
    0x42,0xaf,0x00,0x40,
    0x20,0x40,
    0x94,0x81,
    0x2f,0x42,0x00,0x64,
    0x22,0x2f,0x00,0x64,
    0xb2,0xaf,0x00,0x3c,
    0x67,0x00,0x01,0xba,
    0x55,0xaf,0x00,0x3c,
    0x70,0xfe,
    0xc0,0xaf,0x00,0x3c,
    0x22,0x08,
    0x42,0xaf,0x00,0x44,
    0x92,0x80,
    0x2f,0x41,0x00,0x68,
    0x22,0x08,
    0x20,0x41,
    0x53,0x88,
    0xb2,0xaf,0x00,0x68,
    0x67,0x00,0x02,0x2a,
    0x55,0x81,
    0x70,0xfe,
    0xc0,0x81,
    0x24,0x08,
    0x2f,0x41,0x00,0x58,
    0x42,0xaf,0x00,0x48,
    0x22,0x08,
    0x94,0x80,
    0x2f,0x42,0x00,0x6c,
    0x22,0x41,
    0x53,0x89,
    0xb2,0xaf,0x00,0x6c,
    0x67,0x00,0x01,0xec,
    0x55,0x81,
    0x70,0xfe,
    0xc0,0x81,
    0x24,0x09,
    0x42,0xaf,0x00,0x4c,
    0x2f,0x41,0x00,0x5c,
    0x94,0x80,
    0x2f,0x42,0x00,0x70,
    0x28,0x09,
    0x53,0x84,
    0xb3,0xef,0x00,0x70,
    0x67,0x00,0x01,0xb0,
    0x55,0x89,
    0x72,0xfe,
    0x20,0x09,
    0x24,0x04,
    0xc0,0x81,
    0x42,0x81,
    0x2a,0x41,
    0x2f,0x49,0x00,0x60,
    0x94,0x80,
    0x2f,0x42,0x00,0x50,
    0x26,0x04,
    0x53,0x83,
    0xb8,0xaf,0x00,0x50,
    0x67,0x00,0x01,0x74,
    0x55,0x84,
    0x70,0xfe,
    0x42,0x86,
    0xc0,0x84,
    0x22,0x43,
    0x93,0xc0,
    0x2a,0x03,
    0x53,0x85,
    0xb3,0xc3,
    0x67,0x00,0x01,0x28,
    0x2e,0x03,
    0x70,0xfe,
    0x55,0x83,
    0xc0,0x83,
    0x57,0x87,
    0x24,0x07,
    0x99,0xcc,
    0x94,0x80,
    0x2f,0x42,0x00,0x54,
    0x24,0x05,
    0x53,0x82,
    0xbe,0xaf,0x00,0x54,
    0x67,0x00,0x01,0x18,
    0x70,0xfe,
    0x95,0xca,
    0x2c,0x42,
    0xc0,0x87,
    0x9d,0xc0,
    0x20,0x42,
    0x53,0x88,
    0xbd,0xc2,
    0x67,0x00,0x01,0x14,
    0x22,0x08,
    0x97,0xcb,
    0x2f,0x48,0x00,0x2c,
    0x20,0x41,
    0x48,0x68,0xff,0xff,
    0x2f,0x41,0x00,0x3c,
    0x2f,0x49,0x00,0x38,
    0x4e,0xba,0xfe,0xd6,
    0x58,0x8f,
    0xd7,0xc0,
    0x22,0x2f,0x00,0x38,
    0xa3,0x40,
    0x55,0x81,
    0x22,0x6f,0x00,0x34,
    0xb0,0x81,
    0x65,0xda,
    0x20,0x6f,0x00,0x2c,
    0x20,0x02,
    0x72,0xfe,
    0x57,0x80,
    0xc0,0x81,
    0x45,0xf0,0xa8,0xfe,
    0x55,0x82,
    0x95,0xc0,
    0xd5,0xcb,
    0xa3,0x40,
    0xb0,0x82,
    0x66,0xac,
    0x47,0xea,0x00,0x01,
    0x55,0x85,
    0xd9,0xcb,
    0x55,0x87,
    0xa3,0x40,
    0xb0,0x85,
    0x66,0x86,
    0x24,0x0c,
    0x52,0x82,
    0xdc,0x82,
    0xa3,0x41,
    0xb2,0x83,
    0x65,0x00,0xff,0x5c,
    0x2a,0x06,
    0xda,0x83,
    0xdb,0xc5,
    0xa3,0x40,
    0xb0,0x84,
    0x65,0x00,0xff,0x36,
    0x20,0x0d,
    0xd0,0x84,
    0x22,0x6f,0x00,0x60,
    0xd1,0xaf,0x00,0x4c,
    0xa3,0x40,
    0xb0,0x89,
    0x65,0x00,0xfe,0xfe,
    0x20,0x2f,0x00,0x4c,
    0xd0,0x89,
    0x22,0x2f,0x00,0x5c,
    0xd1,0xaf,0x00,0x48,
    0xa3,0x40,
    0xb0,0x81,
    0x65,0x00,0xfe,0xc6,
    0x20,0x41,
    0xa3,0x42,
    0x22,0x2f,0x00,0x58,
    0x20,0x2f,0x00,0x48,
    0xd0,0x88,
    0xd1,0xaf,0x00,0x44,
    0xb4,0x81,
    0x65,0x00,0xfe,0x8a,
    0x20,0x2f,0x00,0x44,
    0xd0,0x81,
    0xd1,0xaf,0x00,0x40,
    0xa3,0x42,
    0xb4,0xaf,0x00,0x3c,
    0x64,0x00,0x00,0xbe,
    0x22,0x2f,0x00,0x64,
    0x20,0x2f,0x00,0x3c,
    0x53,0x80,
    0x20,0x40,
    0xb2,0xaf,0x00,0x3c,
    0x66,0x00,0xfe,0x4a,
    0x20,0x6f,0x00,0x40,
    0xd1,0xc0,
    0x4c,0xd7,0x7c,0xfc,
    0x20,0x08,
    0x4f,0xef,0x00,0x74,
    0x4e,0x75,
    0xda,0x86,
    0xdb,0xc5,
    0xa3,0x40,
    0xb0,0x84,
    0x65,0x00,0xfe,0xae,
    0x60,0x00,0xff,0x76,
    0xd4,0x8c,
    0xdc,0x82,
    0xa3,0x41,
    0xb2,0x83,
    0x65,0x00,0xfe,0xb6,
    0x60,0x00,0xff,0x58,
    0x26,0x48,
    0xd7,0xca,
    0x55,0x85,
    0xd9,0xcb,
    0x55,0x87,
    0xa3,0x40,
    0xb0,0x85,
    0x66,0x00,0xfe,0xbe,
    0x60,0x00,0xff,0x34,
    0x20,0x03,
    0xd0,0x8d,
    0x22,0x6f,0x00,0x60,
    0xd1,0xaf,0x00,0x4c,
    0xa3,0x40,
    0xb0,0x89,
    0x65,0x00,0xfe,0x4c,
    0x60,0x00,0xff,0x4c,
    0x20,0x2f,0x00,0x4c,
    0xd0,0x84,
    0x22,0x2f,0x00,0x5c,
    0xd1,0xaf,0x00,0x48,
    0xa3,0x40,
    0xb0,0x81,
    0x65,0x00,0xfe,0x10,
    0x60,0x00,0xff,0x48,
    0x22,0x2f,0x00,0x58,
    0xa3,0x42,
    0x20,0x2f,0x00,0x48,
    0xd0,0x89,
    0xd1,0xaf,0x00,0x44,
    0xb4,0x81,
    0x65,0x00,0xfd,0xd2,
    0x60,0x00,0xff,0x46,
    0x20,0x2f,0x00,0x44,
    0xd0,0x88,
    0xd1,0xaf,0x00,0x40,
    0xa3,0x42,
    0xb4,0xaf,0x00,0x3c,
    0x65,0x00,0xff,0x46,
    0x4c,0xd7,0x7c,0xfc,
    0x20,0x6f,0x00,0x3c,
    0xd1,0xef,0x00,0x40,
    0x20,0x08,
    0x4f,0xef,0x00,0x74,
    0x4e,0x75,

    /* .results -- 20 bytes, zero-initialized */
    0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00,
};

/****************************************************************
 * Hypercall test image
 ****************************************************************/

#define HC_LOAD_ADDR   0x00020000
#define HC_RESULT_ADDR 0x00020100

static const uint8_t hc_test_image[] = {
    0x70,0x07,              /* moveq  #7,%d0      */
    0x72,0x08,              /* moveq  #8,%d1      */
    0xa0,0x01,              /* .short 0xa001      */
    0x23,0xc0,              /* movel  %d0,<abs.l> */
    0x00,0x02,0x01,0x00,    /*         0x00020100 */
    0x4e,0x40,              /* trap   #0          */
};

static int
test_hypercall_handler(struct cf_cpu *cpu, uint16_t opword, void *ctx)
{
    int func = opword & 0xFFF;
    (void)ctx;

    if (func == 1) {
        cpu->d[0] = cpu->d[0] * cpu->d[1];
        return 0;
    }
    return -1;
}

/****************************************************************
 * Tests: original embedded-binary computations
 ****************************************************************/

static void
test_compute(void)
{
    cf_cpu cpu;
    struct {
        const char *name;
        uint32_t    addr;
        uint32_t    expected;
    } checks[] = {
        { "fibonacci(10)", 0x000103c2, 55   },
        { "gcd(252, 105)", 0x000103be, 21   },
        { "sum_to(100)",   0x000103ba, 5050 },
        { "bit_test(0xAB)",0x000103b6, 0x0A55 },
        { "sqrt(2)*1000",  0x000103b2, 1414 },
    };
    int nchecks = sizeof(checks) / sizeof(checks[0]);

    setup_cpu(&cpu, ENTRY_ADDR);
    memcpy(mem + LOAD_ADDR, test_image, sizeof(test_image));
    cf_reset(&cpu);
    cf_run(&cpu, 100000);

    for (int i = 0; i < nchecks; i++)
        EXPECT_EQ(mem_read32(NULL, checks[i].addr),
                  checks[i].expected, checks[i].name);
}

static void
test_hypercall(void)
{
    cf_cpu cpu;

    setup_cpu(&cpu, HC_LOAD_ADDR);
    memcpy(mem + HC_LOAD_ADDR, hc_test_image, sizeof(hc_test_image));
    cf_set_hypercall(&cpu, test_hypercall_handler, NULL);
    cf_reset(&cpu);
    cf_run(&cpu, 100);

    uint32_t result = mem_read32(NULL, HC_RESULT_ADDR);
    EXPECT_EQ(result, 56u, "hypercall(7*8)");
}

/****************************************************************
 * Tests: ISA_C -- FF1
 ****************************************************************/

static void
test_ff1(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* FF1 D0 : 0x04C0 */
    /* HALT   : 0x4AC8 */

    /* FF1 of 0x00008000 -- leading zeros = 16 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x04C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0x00008000;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[0], 16u, "ff1(0x00008000)");

    /* FF1 of 0x80000000 -- leading zeros = 0 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x04C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0x80000000;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[0], 0u, "ff1(0x80000000)");

    /* FF1 of 0 -- result = 32 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x04C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[0], 32u, "ff1(0)");

    /* FF1 of 1 -- leading zeros = 31 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x04C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 1;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[0], 31u, "ff1(1)");

    /* FF1 D3 : 0x04C3 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x04C3);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[3] = 0x00100000;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[3], 11u, "ff1_d3(0x00100000)");
}

/****************************************************************
 * Tests: ISA_C -- BYTEREV
 ****************************************************************/

static void
test_byterev(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* BYTEREV D0 : 0x02C0 */
    /* HALT       : 0x4AC8 */

    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x02C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0x12345678;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ_X(cpu.d[0], 0x78563412u, "byterev(0x12345678)");

    /* BYTEREV D5 : 0x02C5 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x02C5);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[5] = 0x00FF00FF;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ_X(cpu.d[5], 0xFF00FF00u, "byterev(0x00FF00FF)");

    /* BYTEREV of 0 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x02C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ_X(cpu.d[0], 0u, "byterev(0)");
}

/****************************************************************
 * Tests: EMAC -- MAC.L, MSAC.L, register access
 ****************************************************************/

static void
test_emac_mac(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MAC.L D0,D1,ACC0 (signed mode)
     * opword: 1010 001 0 0 0 000 000 = 0xA400 (Rx=D0, Ry=D0... wait)
     *
     * Actually, MAC.L Ry,Rx,ACCn encoding:
     *   opword: 1010 Rx[2:0] rx_is_addr ACC[0] 0 Ry_is_addr Ry[2:0]
     *   ext:    0000 1 SF[1:0] sub ACC[1] 0000 0000
     *
     * MAC.L D1,D0,ACC0 (no scale, MAC not MSAC):
     *   Rx=D0 (bits 11-9 = 000), rx_is_addr=0 (bit 6), ACC[0]=0 (bit 7)
     *   Ry=D1 (bits 2-0 = 001), ry_is_addr=0 (bit 3)
     *   opword = 1010 000 0 0 0 000 001 = 0xA001... but that hits hypercall
     *
     * Let's use no hypercall and different registers:
     * MAC.L D2,D3,ACC0:
     *   Rx=D3 (bits 11-9 = 011), rx_is_addr=0 (bit 6=0), ACC[0]=0 (bit 7=0)
     *   Ry=D2 (bits 2-0 = 010), ry_is_addr=0 (bit 3=0)
     *   opword = 1010 011 0 0 0 000 010 = 0xA602
     *   ext = 0000 1 00 0 0000 0000 = 0x0800 (SF=00, sub=0, ACC[1]=0)
     */

    /* MAC.L D2,D3,ACC0: 3 * 5 = 15 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA602);
    mem_write16(NULL, pc + 2, 0x0800);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[2] = 5;
    cpu.d[3] = 3;
    cpu.macsr |= (1 << 6); /* SU = signed */
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF), 15u, "mac.l 3*5 ACC0");

    /* Accumulate again: ACC0 should now be 15 + 3*5 = 30 */
    cpu.d[2] = 5;
    cpu.d[3] = 3;
    cpu.pc = pc;
    cpu.halted = 0;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF), 30u, "mac.l accumulate ACC0");

    /* MSAC.L D2,D3,ACC0: ACC0 = 30 - 3*5 = 15
     * Same opword, ext sub bit set:
     * ext = 0000 1 00 1 0000 0000 = 0x0900 */
    cpu.d[2] = 5;
    cpu.d[3] = 3;
    mem_write16(NULL, pc + 2, 0x0900);
    cpu.pc = pc;
    cpu.halted = 0;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF), 15u, "msac.l ACC0");
}

static void
test_emac_signed_negative(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MAC.L D2,D3,ACC0 signed: (-3) * 5 = -15 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA602);
    mem_write16(NULL, pc + 2, 0x0800);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[2] = 5;
    cpu.d[3] = (uint32_t)-3;
    cpu.macsr |= (1 << 6); /* SU = signed */
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF), (uint32_t)-15, "mac.l signed neg");
    EXPECT_EQ((cpu.macsr >> 3) & 1, 1u, "mac.l MACSR.N set");
}

static void
test_emac_scale(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MAC.L D2,D3,ACC0 with <<1 scale
     * ext = 0000 1 01 0 0000 0000 = 0x0A00 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA602);
    mem_write16(NULL, pc + 2, 0x0A00);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[2] = 10;
    cpu.d[3] = 4;
    cpu.macsr |= (1 << 6); /* SU = signed */
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF), 80u, "mac.l scale<<1");

    /* MAC.L D2,D3,ACC1 with >>1 scale
     * ACC[0] in opword bit 7 = 1, ACC[1] in ext bit 4 = 0 -> ACC index = 1
     * opword = 1010 011 0 1 0 000 010 = 0xA682
     * ext = 0000 1 11 0 0000 0000 = 0x0E00 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA682);
    mem_write16(NULL, pc + 2, 0x0E00);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[2] = 10;
    cpu.d[3] = 4;
    cpu.macsr |= (1 << 6);
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ((uint32_t)(cpu.acc[1] & 0xFFFFFFFF), 20u, "mac.l scale>>1 ACC1");
}

static void
test_emac_saturation(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MAC.L D2,D3,ACC0 with OMC (saturation) enabled */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA602);
    mem_write16(NULL, pc + 2, 0x0800);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.macsr = (1 << 6) | (1 << 7); /* SU + OMC */
    /* Set ACC0 near 48-bit max, then multiply to overflow */
    cpu.acc[0] = ((int64_t)1 << 47) - 10;
    cpu.d[2] = 100;
    cpu.d[3] = 1;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    /* Should saturate to (2^47 - 1) */
    int64_t max48 = ((int64_t)1 << 47) - 1;
    EXPECT_EQ((uint32_t)(cpu.acc[0] & 0xFFFFFFFF),
              (uint32_t)(max48 & 0xFFFFFFFF), "mac.l saturate pos");
    EXPECT_EQ((cpu.macsr >> 1) & 1, 1u, "mac.l MACSR.V on overflow");
}

static void
test_emac_move_regs(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MOVE D0,ACC0 (write): 1010 000 1 0 0 000 000 = 0xA100
     *   emac_reg=000 (ACC0), dir=0 (write), rn=000 (D0) */
    /* MOVE ACC0,D1 (read):  1010 000 1 1 0 000 001 = 0xA181
     *   emac_reg=000 (ACC0), dir=1 (read), rn=001 (D1) */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA100); /* MOVE D0,ACC0 */
    mem_write16(NULL, pc + 2, 0xA181); /* MOVE ACC0,D1 */
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 42;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[1], 42u, "move d0->acc0->d1");

    /* MOVE D0,MACSR: emac_reg=100 (MACSR), dir=0
     * 1010 100 1 0 0 000 000 = 0xA900 */
    /* MOVE MACSR,D2: emac_reg=100, dir=1
     * 1010 100 1 1 0 000 010 = 0xA982 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA900);
    mem_write16(NULL, pc + 2, 0xA982);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0x44;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ(cpu.d[2], 0x44u, "move macsr roundtrip");

    /* MOVE D0,MASK: emac_reg=110 (MASK), dir=0
     * 1010 110 1 0 0 000 000 = 0xAD00 */
    /* MOVE MASK,D3: emac_reg=110, dir=1
     * 1010 110 1 1 0 000 011 = 0xAD83 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xAD00);
    mem_write16(NULL, pc + 2, 0xAD83);
    mem_write16(NULL, pc + 4, 0x4AC8);
    cf_reset(&cpu);
    cpu.d[0] = 0xFFFF0000;
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ_X(cpu.d[3], 0xFFFF0000u, "move mask roundtrip");
}

static void
test_emac_macsr_to_ccr(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* MOVE MACSR,CCR: emac_reg=100, dir=1, special=1
     * 1010 100 1 1 1 000 000 = 0xA9C0 */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0xA9C0);
    mem_write16(NULL, pc + 2, 0x4AC8);
    cf_reset(&cpu);
    cpu.macsr = (1 << 3) | (1 << 1); /* N=1, V=1 */
    cpu.sr = CF_SR_S | (7 << 8);
    cpu.pc = pc;
    cf_run(&cpu, 10);
    EXPECT_EQ((cpu.sr >> 3) & 1, 1u, "macsr->ccr N");
    EXPECT_EQ((cpu.sr >> 1) & 1, 1u, "macsr->ccr V");
    EXPECT_EQ(cpu.sr & 1, 0u, "macsr->ccr C cleared");
}

/****************************************************************
 * Tests: trace ring buffer
 ****************************************************************/

static void
test_trace_basic(void)
{
    cf_trace_t t;
    cf_trace_init(&t);

    EXPECT_EQ(cf_trace_count(&t), 0u, "trace empty");
    EXPECT_EQ(cf_trace_overflowed(&t), 0, "trace no overflow");

    cf_trace_push(&t, CF_TR_ILLEGAL, 0x1000, 0x4AFC, 0, "test note");
    EXPECT_EQ(cf_trace_count(&t), 1u, "trace count=1");

    const cf_trace_event_t *ev = cf_trace_peek(&t, 0);
    EXPECT_EQ(ev->type, CF_TR_ILLEGAL, "trace type");
    EXPECT_EQ(ev->pc, 0x1000u, "trace pc");
    EXPECT_EQ(ev->opword, 0x4AFCu, "trace opword");

    cf_trace_clear(&t);
    EXPECT_EQ(cf_trace_count(&t), 0u, "trace cleared");
}

static void
test_trace_wraparound(void)
{
    cf_trace_t t;
    cf_trace_init(&t);

    for (int i = 0; i < CF_TRACE_CAPACITY + 10; i++)
        cf_trace_push(&t, CF_TR_TRAP, (uint32_t)i, 0, 0, NULL);

    EXPECT_EQ(cf_trace_count(&t), (uint32_t)CF_TRACE_CAPACITY, "trace full count");
    EXPECT_EQ(cf_trace_overflowed(&t), 1, "trace overflowed");

    const cf_trace_event_t *oldest = cf_trace_peek(&t, 0);
    EXPECT_EQ(oldest->pc, 10u, "trace oldest after wrap");

    const cf_trace_event_t *newest = cf_trace_peek(&t, CF_TRACE_CAPACITY - 1);
    EXPECT_EQ(newest->pc, (uint32_t)(CF_TRACE_CAPACITY + 9), "trace newest after wrap");

    EXPECT_EQ(cf_trace_peek(&t, CF_TRACE_CAPACITY) == NULL, 1u, "trace oob null");
}

static void
test_trace_on_exception(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* Execute an illegal instruction, verify trace records it */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x4AFC); /* ILLEGAL */
    /* Point illegal vector to HALT */
    mem_write32(NULL, CF_VEC_ILLEGAL * 4, 0x2000);
    mem_write16(NULL, 0x2000, 0x4AC8); /* HALT */
    cf_reset(&cpu);
    cpu.pc = pc;
    cf_run(&cpu, 10);

    EXPECT_EQ(cf_trace_count(&cpu.trace) >= 1, 1u, "trace has exception");
    const cf_trace_event_t *ev = cf_trace_peek(&cpu.trace, 0);
    EXPECT_EQ(ev->type, CF_TR_ILLEGAL, "trace illegal type");
}

/****************************************************************
 * Tests: double fault detection
 ****************************************************************/

static void
test_double_fault(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* Simulate exception during exception processing -> double fault.
     * Set in_exception=1 then trigger ILLEGAL. */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x4AFC);     /* ILLEGAL at 0x1000 */
    mem_write32(NULL, CF_VEC_ILLEGAL * 4, 0x2000);
    mem_write16(NULL, 0x2000, 0x4AC8); /* HALT at handler */
    cf_reset(&cpu);
    cpu.pc = pc;
    cpu.in_exception = 1;
    cf_run(&cpu, 20);

    EXPECT_EQ(cpu.fault, 1, "double fault flag");
    EXPECT_EQ(cpu.halted, 1, "double fault halted");

    int found_df = 0;
    uint32_t n = cf_trace_count(&cpu.trace);
    for (uint32_t i = 0; i < n; i++) {
        const cf_trace_event_t *ev = cf_trace_peek(&cpu.trace, i);
        if (ev->type == CF_TR_DOUBLE_FAULT)
            found_df = 1;
    }
    EXPECT_EQ(found_df, 1, "double fault in trace");
}

/****************************************************************
 * Tests: privilege violation
 ****************************************************************/

static void
test_privilege_violation(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* Execute HALT in user mode -> privilege violation */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc, 0x4AC8); /* HALT */
    /* Point privilege violation vector to a NOP+HALT sequence */
    mem_write32(NULL, CF_VEC_PRIVILEGE * 4, 0x2000);
    mem_write16(NULL, 0x2000, 0x4E71); /* NOP */
    mem_write16(NULL, 0x2002, 0x4AC8); /* HALT */
    cf_reset(&cpu);
    cpu.pc = pc;
    /* Switch to user mode via cf_set_sr (handles A7/USP swap) */
    cf_set_sr(&cpu, cpu.sr & ~CF_SR_S);
    cf_run(&cpu, 20);

    /* Should have taken privilege violation, now in supervisor mode */
    EXPECT_EQ((cpu.sr & CF_SR_S) != 0, 1u, "priv viol -> supervisor");

    int found = 0;
    uint32_t n = cf_trace_count(&cpu.trace);
    for (uint32_t i = 0; i < n; i++) {
        const cf_trace_event_t *ev = cf_trace_peek(&cpu.trace, i);
        if (ev->type == CF_TR_PRIVILEGE)
            found = 1;
    }
    EXPECT_EQ(found, 1, "priv viol in trace");
}

/****************************************************************
 * Tests: zero divide
 ****************************************************************/

static void
test_zero_divide(void)
{
    cf_cpu cpu;
    uint32_t pc = 0x1000;

    /* DIVU.L D1,D0 : opword 0x4C41, ext 0x0000
     * with D1=0 -> zero divide exception */
    setup_cpu(&cpu, pc);
    mem_write16(NULL, pc,     0x4C41); /* DIVU.L D1,D0 */
    mem_write16(NULL, pc + 2, 0x0000);
    mem_write32(NULL, CF_VEC_ZERO_DIVIDE * 4, 0x2000);
    mem_write16(NULL, 0x2000, 0x4AC8); /* HALT */
    cf_reset(&cpu);
    cpu.d[0] = 100;
    cpu.d[1] = 0;
    cpu.pc = pc;
    cf_run(&cpu, 20);

    int found = 0;
    uint32_t n = cf_trace_count(&cpu.trace);
    for (uint32_t i = 0; i < n; i++) {
        const cf_trace_event_t *ev = cf_trace_peek(&cpu.trace, i);
        if (ev->type == CF_TR_ZERO_DIVIDE)
            found = 1;
    }
    EXPECT_EQ(found, 1, "zero divide in trace");
}

/****************************************************************
 * Main
 ****************************************************************/

int
main(void)
{
    test_compute();
    test_hypercall();
    test_ff1();
    test_byterev();
    test_emac_mac();
    test_emac_signed_negative();
    test_emac_scale();
    test_emac_saturation();
    test_emac_move_regs();
    test_emac_macsr_to_ccr();
    test_trace_basic();
    test_trace_wraparound();
    test_trace_on_exception();
    test_double_fault();
    test_privilege_violation();
    test_zero_divide();

    printf("\n%d passed, %d failed\n", passes, failures);
    return failures > 0 ? 1 : 0;
}
