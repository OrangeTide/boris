/* rv32.h : embeddable RV32IMAFC_Zicsr_Zifencei_Zba_Zbb_Zbs_Zcb CPU emulator
 * Copyright 2026 Jon Mayo
 * SPDX-License-Identifier: 0BSD OR CC0-1.0
 */

#ifndef RV32_H
#define RV32_H

#include <stdint.h>
#include <string.h>

/****************************************************************
 * Trace event types
 ****************************************************************/

enum rv_trace_type {
    RV_TR_NONE = 0,
    RV_TR_ILLEGAL,
    RV_TR_FETCH_FAULT,
    RV_TR_LOAD_FAULT,
    RV_TR_STORE_FAULT,
    RV_TR_LOAD_MISALIGN,
    RV_TR_STORE_MISALIGN,
    RV_TR_ECALL,
    RV_TR_EBREAK,
    RV_TR_CSR,
    RV_TR_TRAP,
    RV_TR_DOUBLE_FAULT,
    RV_TR_INTERRUPT,
};

/****************************************************************
 * Trace event record
 ****************************************************************/

#define RV_TRACE_NOTE_SIZE 48

typedef struct rv_trace_event {
    uint32_t pc;
    uint32_t addr;
    uint32_t insn;
    uint8_t  type;
    uint8_t  _pad[3];
    char     note[RV_TRACE_NOTE_SIZE];
} rv_trace_event_t;

/****************************************************************
 * Trace ring buffer
 ****************************************************************/

#define RV_TRACE_CAPACITY 64

typedef struct rv_trace {
    rv_trace_event_t events[RV_TRACE_CAPACITY];
    uint32_t head;
    uint32_t total;
} rv_trace_t;

/****************************************************************
 * Trace inline operations
 ****************************************************************/

static inline void
rv_trace_init(rv_trace_t *t)
{
    memset(t, 0, sizeof(*t));
}

static inline void
rv_trace_push(rv_trace_t *t, uint8_t type, uint32_t pc,
              uint32_t insn, uint32_t addr, const char *note)
{
    rv_trace_event_t *ev = &t->events[t->head & (RV_TRACE_CAPACITY - 1)];
    ev->type = type;
    ev->pc = pc;
    ev->insn = insn;
    ev->addr = addr;
    if (note) {
        size_t n = strlen(note);
        if (n >= RV_TRACE_NOTE_SIZE)
            n = RV_TRACE_NOTE_SIZE - 1;
        memcpy(ev->note, note, n);
        ev->note[n] = '\0';
    } else {
        ev->note[0] = '\0';
    }
    t->head++;
    t->total++;
}

static inline uint32_t
rv_trace_count(const rv_trace_t *t)
{
    uint32_t n = t->head;
    return n < RV_TRACE_CAPACITY ? n : RV_TRACE_CAPACITY;
}

static inline int
rv_trace_overflowed(const rv_trace_t *t)
{
    return t->total > RV_TRACE_CAPACITY;
}

static inline const rv_trace_event_t *
rv_trace_peek(const rv_trace_t *t, uint32_t i)
{
    uint32_t n = rv_trace_count(t);
    uint32_t start;

    if (i >= n)
        return NULL;
    if (t->head <= RV_TRACE_CAPACITY)
        start = 0;
    else
        start = t->head;
    return &t->events[(start + i) & (RV_TRACE_CAPACITY - 1)];
}

static inline void
rv_trace_clear(rv_trace_t *t)
{
    t->head = 0;
    t->total = 0;
}

/****************************************************************
 * Types
 ****************************************************************/

typedef uint32_t (*rv_read_fn)(void *ctx, uint32_t addr);
typedef void (*rv_write_fn)(void *ctx, uint32_t addr, uint32_t val);

/* Optional access check for sandboxing. Return 0 to allow the access,
 * nonzero to raise an access fault. size is 1, 2 or 4; is_write is 0 for
 * loads and instruction fetches, 1 for stores. */
typedef int (*rv_probe_fn)(void *ctx, uint32_t addr, int size, int is_write);

/* Environment call callback: invoked on ECALL before the trap is taken.
 * The callback reads arguments from cpu->x[]/cpu->f[] and writes results
 * back. Return 0 if handled, nonzero to fall through to the ECALL trap. */
struct rv_cpu;
typedef int (*rv_ecall_fn)(struct rv_cpu *cpu, void *ctx);

typedef struct rv_cpu {
    /* Integer core */
    uint32_t x[32];         /* x0-x31; x0 is hardwired to zero */
    uint32_t pc;            /* program counter */

    /* F extension: 32 single-precision registers held as raw bit patterns */
    uint32_t f[32];
    uint32_t fcsr;          /* frm in bits 7:5, fflags in bits 4:0 */

    /* Machine-mode CSRs */
    uint32_t mstatus;
    uint32_t mtvec;
    uint32_t mepc;
    uint32_t mcause;
    uint32_t mtval;
    uint32_t mscratch;
    uint32_t mie;
    uint32_t mip;
    uint64_t mcycle;
    uint64_t minstret;

    /* Emulator state */
    int      halted;        /* set by rv_halt() or an unrecoverable trap */
    int      in_trap;       /* a trap was taken by the current instruction */
    int      trap_misaligned;   /* 1: misaligned accesses trap, 0: emulate */

    /* Set by wfi, cleared when an interrupt is taken. Nothing in the
     * interpreter waits: a host that steps the machine itself can read
     * this to skip ahead to whatever raises the next interrupt instead
     * of spinning through the loop the guest is parked in. */
    int      waiting;

    /* Zcmp adds the push and pop instructions that build and tear down a
     * stack frame in one encoding. It occupies the encoding space of the
     * compressed double-precision loads and stores, so an implementation
     * may have one or the other but never both. This emulator has no
     * double precision, which leaves that space free. Clear this to get a
     * plain RV32IMFC machine. */
    int      zcmp;

    /* The A extension. It is provided for convenience rather than for
     * concurrency: this is a single hart with no interrupts, so no other
     * agent can observe or disturb a read-modify-write, and the acquire
     * and release ordering bits describe an ordering that cannot be
     * violated here. What it buys is the ability to link code that uses
     * C11 or C++ atomics at all, which otherwise needs a runtime library
     * that is not built for this target. */
    int      atomics;
    uint32_t res_addr;      /* address reserved by the last lr.w */
    int      res_valid;     /* a reservation is outstanding */

    /* Zba, Zbb and Zbs: the address-generation, basic bit-manipulation and
     * single-bit extensions, which together are the ratified B extension.
     * They are treated as one switch because a compiler given any of them
     * is normally given all three, and because riscv-arch-test tests them
     * as a single suite. Clear this for a machine without them. */
    int      bitmanip;

    /* Zcb adds the compressed byte and halfword loads and stores that the
     * base compressed set never had, plus six one-operand forms. It sits
     * in encodings C leaves illegal, so it conflicts with nothing. Three
     * of its forms expand into Zbb instructions and one into M, which is
     * the specification's dependency: with those extensions off, those
     * forms raise the illegal-instruction trap after expansion. */
    int      zcb;

    uint64_t cycles;        /* retired instruction counter */
    rv_trace_t trace;       /* diagnostic event ring buffer */

    /* Memory bus callbacks */
    rv_read_fn  read8, read16, read32;
    rv_write_fn write8, write16, write32;
    rv_probe_fn probe;      /* optional; NULL disables access checking */
    void *bus_ctx;          /* opaque pointer passed to callbacks */

    /* Environment call interface */
    rv_ecall_fn ecall;
    void *ecall_ctx;        /* opaque pointer passed to ecall */

    /* Decoded-instruction cache. Each guest PC is predecoded once (the
     * compressed forms expanded, the length resolved) so the hot loop skips
     * the fetch and the expander on every re-execution. Guest code carries no
     * write permission, so an entry can never go stale. NULL until
     * rv_dec_enable installs it; dec_mask is the entry count minus one. */
    struct rv_dec *dec;
    uint32_t dec_mask;
} rv_cpu;

/****************************************************************
 * mstatus bits (machine mode subset)
 ****************************************************************/

#define RV_MSTATUS_MIE      (1u << 3)
#define RV_MSTATUS_MPIE     (1u << 7)
#define RV_MSTATUS_MPP      (3u << 11)
#define RV_MSTATUS_FS       (3u << 13)

/****************************************************************
 * fcsr fields
 ****************************************************************/

#define RV_FFLAG_NX     (1u << 0)   /* inexact */
#define RV_FFLAG_UF     (1u << 1)   /* underflow */
#define RV_FFLAG_OF     (1u << 2)   /* overflow */
#define RV_FFLAG_DZ     (1u << 3)   /* divide by zero */
#define RV_FFLAG_NV     (1u << 4)   /* invalid operation */

#define RV_RM_RNE   0   /* round to nearest, ties to even */
#define RV_RM_RTZ   1   /* round toward zero */
#define RV_RM_RDN   2   /* round down (toward -inf) */
#define RV_RM_RUP   3   /* round up (toward +inf) */
#define RV_RM_RMM   4   /* round to nearest, ties to max magnitude */
#define RV_RM_DYN   7   /* use frm from fcsr */

/****************************************************************
 * Trap causes (mcause values, interrupt bit clear)
 ****************************************************************/

#define RV_CAUSE_INSN_MISALIGNED    0
#define RV_CAUSE_INSN_ACCESS_FAULT  1
#define RV_CAUSE_ILLEGAL_INSN       2
#define RV_CAUSE_BREAKPOINT         3
#define RV_CAUSE_LOAD_MISALIGNED    4
#define RV_CAUSE_LOAD_ACCESS_FAULT  5
#define RV_CAUSE_STORE_MISALIGNED   6
#define RV_CAUSE_STORE_ACCESS_FAULT 7
#define RV_CAUSE_ECALL_U            8
#define RV_CAUSE_ECALL_M            11

/****************************************************************
 * Interrupts
 *
 * An mcause with the top bit set names an interrupt rather than an
 * exception, and the rest of it is the bit position in mip and mie. A
 * single hart in machine mode has three: software, timer and external,
 * taken in the priority the specification fixes, external first.
 *
 * The lines are level-sensitive, which is what the hardware they model
 * is: rv_set_irq raises or lowers one, and it stays raised until the
 * host lowers it or the guest clears the bit in mip. A handler that
 * returns without doing either is re-entered, exactly as it would be on
 * a real machine.
 ****************************************************************/

#define RV_CAUSE_INTERRUPT  0x80000000u     /* the mcause interrupt bit */

#define RV_IRQ_SOFT     3
#define RV_IRQ_TIMER    7
#define RV_IRQ_EXT      11

#define RV_MIP_MSIP     (1u << RV_IRQ_SOFT)
#define RV_MIP_MTIP     (1u << RV_IRQ_TIMER)
#define RV_MIP_MEIP     (1u << RV_IRQ_EXT)

/****************************************************************
 * CSR numbers
 ****************************************************************/

#define RV_CSR_FFLAGS       0x001
#define RV_CSR_FRM          0x002
#define RV_CSR_FCSR         0x003
#define RV_CSR_CYCLE        0xC00
#define RV_CSR_TIME         0xC01
#define RV_CSR_INSTRET      0xC02
#define RV_CSR_CYCLEH       0xC80
#define RV_CSR_TIMEH        0xC81
#define RV_CSR_INSTRETH     0xC82
#define RV_CSR_MSTATUS      0x300
#define RV_CSR_MISA         0x301
#define RV_CSR_MIE          0x304
#define RV_CSR_MTVEC        0x305
#define RV_CSR_MSCRATCH     0x340
#define RV_CSR_MEPC         0x341
#define RV_CSR_MCAUSE       0x342
#define RV_CSR_MTVAL        0x343
#define RV_CSR_MIP          0x344
#define RV_CSR_MCYCLE       0xB00
#define RV_CSR_MINSTRET     0xB02
#define RV_CSR_MCYCLEH      0xB80
#define RV_CSR_MINSTRETH    0xB82
#define RV_CSR_MVENDORID    0xF11
#define RV_CSR_MARCHID      0xF12
#define RV_CSR_MIMPID       0xF13
#define RV_CSR_MHARTID      0xF14

/****************************************************************
 * Public API
 ****************************************************************/

void rv_init(rv_cpu *cpu,
             rv_read_fn r8, rv_read_fn r16, rv_read_fn r32,
             rv_write_fn w8, rv_write_fn w16, rv_write_fn w32,
             void *bus_ctx);

void rv_reset(rv_cpu *cpu, uint32_t entry);

/* Install (or drop) the decoded-instruction cache. Enabling it is a pure
 * speed-up with no effect on results. Safe to call once after rv_init; a
 * second enable is a no-op. rv_dec_free releases it. */
void rv_dec_enable(rv_cpu *cpu);
void rv_dec_free(rv_cpu *cpu);

/* Install an ECALL handler. Guest ECALLs are passed to the callback before
 * the environment-call trap is taken, giving the host a zero-copy seam for
 * native services. */
void rv_set_ecall(rv_cpu *cpu, rv_ecall_fn fn, void *ctx);

/* Install an access-check callback used to sandbox guest memory. */
void rv_set_probe(rv_cpu *cpu, rv_probe_fn fn);

/* Execute one instruction. Returns 0 on success, -1 when halted. */
int rv_step(rv_cpu *cpu);

/* Why rv_run() returned control to the host. */
enum rv_run_reason {
    RV_RUN_BUDGET = 0,  /* ran the full count; still runnable */
    RV_RUN_HALT,        /* cpu halted: a clean exit or a double fault */
    RV_RUN_TRAP,        /* a trap was taken; cpu->mcause names the cause */
    RV_RUN_YIELD,       /* the hart is parked (cpu->waiting): still runnable,
                         * voluntarily off the CPU. A host-call handler sets
                         * the bit to yield, and wfi sets it too. The host
                         * resumes by clearing cpu->waiting (or by taking an
                         * interrupt, which clears it) and running again. This
                         * is the cooperative-yield boundary a scheduler builds
                         * coroutine-style tasks on. */
};

/* Execute up to count instructions, stopping early the moment the machine
 * halts, takes a trap, or parks on wfi. Returns the reason so the host can
 * observe and act on a stuck, faulting, or yielding task instead of spinning
 * out the batch; *retired, when non-NULL, receives the number of
 * instructions executed. Stopping on these events is what a JIT backend
 * returns through as well: this interpreter loop is one implementation of
 * that contract. */
enum rv_run_reason rv_run(rv_cpu *cpu, int count, int *retired);

/* Stop execution; rv_step() returns -1 until the next rv_reset(). */
void rv_halt(rv_cpu *cpu);

/* Register access */
uint32_t rv_get_x(rv_cpu *cpu, int n);
void rv_set_x(rv_cpu *cpu, int n, uint32_t val);
uint32_t rv_get_pc(rv_cpu *cpu);
void rv_set_pc(rv_cpu *cpu, uint32_t val);
uint32_t rv_get_f(rv_cpu *cpu, int n);
void rv_set_f(rv_cpu *cpu, int n, uint32_t bits);

/* Raise a trap from host code (software or external) */
void rv_trap(rv_cpu *cpu, uint32_t cause, uint32_t tval);

/* Raise (level != 0) or lower an interrupt line; cause is RV_IRQ_SOFT,
 * RV_IRQ_TIMER or RV_IRQ_EXT. This is the seam a timer or an interrupt
 * controller in the host plugs into. */
void rv_set_irq(rv_cpu *cpu, int cause, int level);

/* The interrupt that would be taken before the next instruction, as an
 * mcause value, or 0 when none is. */
uint32_t rv_irq_pending(const rv_cpu *cpu);

/* Expand a 16-bit compressed encoding to its 32-bit equivalent.
 * Returns 0 for an illegal or reserved encoding. Exposed for testing. */
uint32_t rv_expand_c(uint16_t c);

/* Expand a Zcb encoding, or return 0 if it is not one. These live in
 * encodings rv_expand_c() rejects, so a decoder tries this one first and
 * falls back. Exposed for testing. */
uint32_t rv_expand_zcb(uint16_t c);

/* ABI register names, indexed by register number ("zero", "ra", "sp", ...) */
extern const char *const rv_x_names[32];
extern const char *const rv_f_names[32];

#endif /* RV32_H */
