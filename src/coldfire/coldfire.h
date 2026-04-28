/* coldfire.h : embeddable ColdFire V4e CPU emulator */
/* Copyright (c) 2026 Jon Mayo — MIT-0 OR Public Domain */
/* Written with AI assistance (Claude, Anthropic) */

#ifndef COLDFIRE_H
#define COLDFIRE_H

#include <stdint.h>

/****************************************************************
 * Types
 ****************************************************************/

typedef uint32_t (*cf_read_fn)(void *ctx, uint32_t addr);
typedef void (*cf_write_fn)(void *ctx, uint32_t addr, uint32_t val);

/* Hypercall callback: invoked on LINE_A opcodes that are not MOV3Q.
 * The full opword is passed — bits 11-0 encode the function ID.
 * Return 0 if handled, nonzero to fall through to LINE_A exception. */
struct cf_cpu;
typedef int (*cf_hypercall_fn)(struct cf_cpu *cpu, uint16_t opword, void *ctx);

typedef struct cf_cpu {
    /* Integer core */
    uint32_t d[8];          /* D0-D7 data registers */
    uint32_t a[8];          /* A0-A7 address registers (A7 = active SP) */
    uint32_t pc;            /* program counter */
    uint32_t sr;            /* status register (includes CCR) */
    uint32_t vbr;           /* vector base register */
    uint32_t cacr;          /* cache control (stub) */
    uint32_t other_a7;      /* shadow stack pointer (USP or SSP) */

    /* FPU */
    double   fp[8];         /* FP0-FP7, 64-bit double precision */
    uint32_t fpcr;          /* FP control register */
    uint32_t fpsr;          /* FP status register */
    uint32_t fpiar;         /* FP instruction address register */

    /* EMAC */
    int64_t  acc[4];        /* ACC0-ACC3, 48-bit accumulators */
    uint32_t macsr;         /* MAC status register */
    uint32_t mask;          /* MAC mask register */
    uint8_t  accext[8];     /* accumulator extensions */

    /* Emulator state */
    int      halted;        /* HALT/STOP flag */
    uint64_t cycles;        /* instruction counter */
    int      fault;         /* set on bus/address error */

    /* Memory bus callbacks */
    cf_read_fn  read8, read16, read32;
    cf_write_fn write8, write16, write32;
    void *bus_ctx;          /* opaque pointer passed to callbacks */

    /* Hypercall interface (LINE_A intercept) */
    cf_hypercall_fn hypercall;
    void *hypercall_ctx;    /* opaque pointer passed to hypercall */
} cf_cpu;

/****************************************************************
 * Status register bits
 ****************************************************************/

#define CF_SR_C     (1 << 0)    /* carry */
#define CF_SR_V     (1 << 1)    /* overflow */
#define CF_SR_Z     (1 << 2)    /* zero */
#define CF_SR_N     (1 << 3)    /* negative */
#define CF_SR_X     (1 << 4)    /* extend */
#define CF_SR_IPL   (7 << 8)    /* interrupt priority level mask */
#define CF_SR_S     (1 << 13)   /* supervisor mode */
#define CF_SR_T     (1 << 15)   /* trace mode */

/****************************************************************
 * Exception vectors
 ****************************************************************/

#define CF_VEC_RESET_SSP        0
#define CF_VEC_RESET_PC         1
#define CF_VEC_ACCESS_ERROR     2
#define CF_VEC_ADDRESS_ERROR    3
#define CF_VEC_ILLEGAL          4
#define CF_VEC_ZERO_DIVIDE      5
#define CF_VEC_PRIVILEGE        8
#define CF_VEC_TRACE            9
#define CF_VEC_LINE_A           10
#define CF_VEC_LINE_F           11
#define CF_VEC_FORMAT_ERROR     14
#define CF_VEC_UNINITIALIZED    15
#define CF_VEC_SPURIOUS         24
#define CF_VEC_AUTOVECTOR(n)    (25 + (n))  /* n = 0..6 */
#define CF_VEC_TRAP(n)          (32 + (n))  /* n = 0..15 */

/****************************************************************
 * Public API
 ****************************************************************/

void cf_init(cf_cpu *cpu,
             cf_read_fn r8, cf_read_fn r16, cf_read_fn r32,
             cf_write_fn w8, cf_write_fn w16, cf_write_fn w32,
             void *bus_ctx);

void cf_reset(cf_cpu *cpu);

/* Install a hypercall handler (LINE_A intercept for host-native calls).
 * Non-MOV3Q LINE_A opcodes are passed to the callback before raising
 * a LINE_A exception. The callback reads args from cpu->d[]/a[]/fp[]
 * and writes return values back. Returns with no guest-side overhead
 * beyond the opword fetch+decode. */
void cf_set_hypercall(cf_cpu *cpu, cf_hypercall_fn fn, void *ctx);

/* Execute one instruction. Returns 0 on success, -1 on halt/stop. */
int cf_step(cf_cpu *cpu);

/* Execute up to count instructions. Returns number executed. */
int cf_run(cf_cpu *cpu, int count);

/* Register access */
uint32_t cf_get_d(cf_cpu *cpu, int n);
uint32_t cf_get_a(cf_cpu *cpu, int n);
uint32_t cf_get_pc(cf_cpu *cpu);
uint32_t cf_get_sr(cf_cpu *cpu);
void cf_set_d(cf_cpu *cpu, int n, uint32_t val);
void cf_set_a(cf_cpu *cpu, int n, uint32_t val);
void cf_set_pc(cf_cpu *cpu, uint32_t val);
void cf_set_sr(cf_cpu *cpu, uint32_t val);

/* FPU register access */
double cf_get_fp(cf_cpu *cpu, int n);
void cf_set_fp(cf_cpu *cpu, int n, double val);

/* Raise an exception (software or external) */
void cf_exception(cf_cpu *cpu, int vector);

#endif /* COLDFIRE_H */
