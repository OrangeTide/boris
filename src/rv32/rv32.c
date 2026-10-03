/* rv32.c : RV32IMAFC_Zicsr_Zifencei_Zba_Zbb_Zbs_Zcb CPU emulator
 * Copyright 2026 Jon Mayo
 * SPDX-License-Identifier: 0BSD OR CC0-1.0
 */

#include "rv32.h"
#include <stdlib.h>
#include <string.h>

/* Branch hints for the interpreter loop. These do not change how the hardware
 * predictor behaves; they steer code layout so the exceptional exits (traps,
 * bus faults, illegal encodings) are kept out of the straight-line dispatch
 * path. Profiling shows the loop's conditional branches are already predicted
 * near-perfectly, so these are documentation of intent and I-cache layout, not
 * a throughput fix. Only the true rare paths are marked. */
#if defined(__GNUC__) || defined(__clang__)
#define RV_LIKELY(x)   __builtin_expect(!!(x), 1)
#define RV_UNLIKELY(x) __builtin_expect(!!(x), 0)
#else
#define RV_LIKELY(x)   (x)
#define RV_UNLIKELY(x) (x)
#endif

/* Guest-instruction coverage. Which lines of this file a test executed is
 * not the same question as which instructions it ran, and for an emulator
 * the second one is the useful one. icov.c answers it; this build option
 * is the only thing in here that knows about it, and an ordinary build
 * contains nothing of either. */
#ifdef RV_ICOV
#include "icov.h"
#define ICOV_NOTE(insn, len)    rv_icov_note((insn), (len))
#else
#define ICOV_NOTE(insn, len)    ((void)0)
#endif

/****************************************************************
 * Register names
 ****************************************************************/

const char *const rv_x_names[32] = {
    "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
    "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
    "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
    "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6",
};

const char *const rv_f_names[32] = {
    "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
    "fs0", "fs1", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5",
    "fa6", "fa7", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7",
    "fs8", "fs9", "fs10", "fs11", "ft8", "ft9", "ft10", "ft11",
};

/****************************************************************
 * Instruction field extraction
 ****************************************************************/

#define OPCODE(i)   ((i) & 0x7f)
#define RD(i)       (((i) >> 7) & 0x1f)
#define FUNCT3(i)   (((i) >> 12) & 0x07)
#define RS1(i)      (((i) >> 15) & 0x1f)
#define RS2(i)      (((i) >> 20) & 0x1f)
#define RS3(i)      (((i) >> 27) & 0x1f)
#define FUNCT7(i)   (((i) >> 25) & 0x7f)

/* Major opcodes */
#define OP_LOAD     0x03
#define OP_LOAD_FP  0x07
#define OP_AMO      0x2f
#define OP_MISC_MEM 0x0f
#define OP_IMM      0x13
#define OP_AUIPC    0x17
#define OP_STORE    0x23
#define OP_STORE_FP 0x27
#define OP_REG      0x33
#define OP_LUI      0x37
#define OP_MADD     0x43
#define OP_MSUB     0x47
#define OP_NMSUB    0x4b
#define OP_NMADD    0x4f
#define OP_FP       0x53
#define OP_BRANCH   0x63
#define OP_JALR     0x67
#define OP_JAL      0x6f
#define OP_SYSTEM   0x73

/****************************************************************
 * Immediate decoders
 ****************************************************************/

static inline int32_t
imm_i(uint32_t i)
{
    return (int32_t)i >> 20;
}

/* The S/B/J immediates are assembled in unsigned space and sign-extended by a
 * final left-then-arithmetic-right shift.  Extending the sign bit directly with
 * (int32_t)i >> k would shift a negative value left, which is undefined even
 * though it yields the intended bits on two's-complement hardware. */
static inline int32_t
imm_s(uint32_t i)
{
    uint32_t u = (((i >> 25) & 0x7f) << 5) | ((i >> 7) & 0x1f);
    return (int32_t)(u << 20) >> 20;    /* 12-bit signed */
}

static inline int32_t
imm_b(uint32_t i)
{
    uint32_t u = (((i >> 31) & 0x01) << 12) |
                 (((i >> 25) & 0x3f) << 5) |
                 (((i >> 8) & 0x0f) << 1) |
                 (((i >> 7) & 0x01) << 11);
    return (int32_t)(u << 19) >> 19;    /* 13-bit signed */
}

static inline int32_t
imm_u(uint32_t i)
{
    return (int32_t)(i & 0xfffff000);
}

static inline int32_t
imm_j(uint32_t i)
{
    uint32_t u = (((i >> 31) & 0x01) << 20) |
                 (((i >> 21) & 0x3ff) << 1) |
                 (((i >> 20) & 0x01) << 11) |
                 (((i >> 12) & 0xff) << 12);
    return (int32_t)(u << 11) >> 11;    /* 21-bit signed */
}

/****************************************************************
 * Trap handling
 ****************************************************************/

void
rv_trap(rv_cpu *cpu, uint32_t cause, uint32_t tval)
{
    int is_irq = (cause & RV_CAUSE_INTERRUPT) != 0;
    uint32_t base;

    if (cpu->in_trap) {
        /* A trap taken while already redirecting the current instruction
         * means the handler itself is unreachable. Stop rather than spin. */
        rv_trace_push(&cpu->trace, RV_TR_DOUBLE_FAULT, cpu->pc, 0, tval,
                      "double fault");
        cpu->halted = 1;
        return;
    }

    cpu->mepc = cpu->pc;
    cpu->mcause = cause;
    cpu->mtval = tval;

    /* A reservation cannot survive a change of control flow. Leaving it
     * standing would let a store conditional in a handler succeed against
     * a load reserved from the interrupted code. */
    cpu->res_valid = 0;

    /* Save and clear the interrupt-enable bit, record the previous mode */
    cpu->mstatus &= ~RV_MSTATUS_MPIE;
    if (cpu->mstatus & RV_MSTATUS_MIE)
        cpu->mstatus |= RV_MSTATUS_MPIE;
    cpu->mstatus &= ~RV_MSTATUS_MIE;
    cpu->mstatus |= RV_MSTATUS_MPP;     /* previous mode = M */

    /* An interrupt is what wfi was waiting for. */
    cpu->waiting = 0;

    /* Vectored mode spreads the *interrupts* over base + 4*cause and
     * still sends every exception to base itself. This used to vector
     * both, which sent an exception to whatever entry its cause number
     * happened to land on. Nothing caught it: no compliance test, no
     * fuzzed instruction and no lockstep run this project has ever done
     * sets mtvec to vectored mode. */
    base = cpu->mtvec & ~3u;
    if ((cpu->mtvec & 3) == 1 && is_irq)
        base += (cause & ~RV_CAUSE_INTERRUPT) * 4;
    cpu->pc = base;
    cpu->in_trap = 1;

    rv_trace_push(&cpu->trace, is_irq ? RV_TR_INTERRUPT : RV_TR_TRAP,
                  cpu->mepc, 0, tval, NULL);
}

/****************************************************************
 * Interrupts
 *
 * The host owns the lines. A timer, an interrupt controller or a frame
 * clock lives outside the interpreter, decides when a line is high, and
 * calls rv_set_irq(); the core does the rest between instructions.
 ****************************************************************/

void
rv_set_irq(rv_cpu *cpu, int cause, int level)
{
    uint32_t bit = 1u << (cause & 31);

    if (level)
        cpu->mip |= bit;
    else
        cpu->mip &= ~bit;
}

uint32_t
rv_irq_pending(const rv_cpu *cpu)
{
    uint32_t ready = cpu->mip & cpu->mie;

    /* Globally disabled: mstatus.MIE gates every machine interrupt.
     * There is no lower privilege mode here, so nothing is left that an
     * interrupt could preempt regardless of MIE. */
    if (!(cpu->mstatus & RV_MSTATUS_MIE))
        return 0;

    /* The specification's priority: external, then software, then timer */
    if (ready & RV_MIP_MEIP)
        return RV_CAUSE_INTERRUPT | RV_IRQ_EXT;
    if (ready & RV_MIP_MSIP)
        return RV_CAUSE_INTERRUPT | RV_IRQ_SOFT;
    if (ready & RV_MIP_MTIP)
        return RV_CAUSE_INTERRUPT | RV_IRQ_TIMER;
    return 0;
}

/****************************************************************
 * Memory bus
 ****************************************************************/

/** Read size bytes from addr. Returns 0 on success, -1 if a trap was taken. */
static int
mem_read(rv_cpu *cpu, uint32_t addr, int size, uint32_t *out)
{
    uint32_t v;
    int i;

    if (cpu->trap_misaligned && (addr & (uint32_t)(size - 1))) {
        rv_trace_push(&cpu->trace, RV_TR_LOAD_MISALIGN, cpu->pc, 0, addr, NULL);
        rv_trap(cpu, RV_CAUSE_LOAD_MISALIGNED, addr);
        return -1;
    }
    if (cpu->probe && cpu->probe(cpu->bus_ctx, addr, size, 0)) {
        rv_trace_push(&cpu->trace, RV_TR_LOAD_FAULT, cpu->pc, 0, addr, NULL);
        rv_trap(cpu, RV_CAUSE_LOAD_ACCESS_FAULT, addr);
        return -1;
    }

    if ((addr & (uint32_t)(size - 1)) == 0) {
        switch (size) {
        case 1:  v = cpu->read8(cpu->bus_ctx, addr) & 0xff; break;
        case 2:  v = cpu->read16(cpu->bus_ctx, addr) & 0xffff; break;
        default: v = cpu->read32(cpu->bus_ctx, addr); break;
        }
    } else {
        /* Misaligned: assemble little-endian from byte accesses */
        v = 0;
        for (i = 0; i < size; i++)
            v |= (cpu->read8(cpu->bus_ctx, addr + i) & 0xff) << (8 * i);
    }
    *out = v;
    return 0;
}

/** Write size bytes to addr. Returns 0 on success, -1 if a trap was taken. */
static int
mem_write(rv_cpu *cpu, uint32_t addr, int size, uint32_t val)
{
    int i;

    if (cpu->trap_misaligned && (addr & (uint32_t)(size - 1))) {
        rv_trace_push(&cpu->trace, RV_TR_STORE_MISALIGN, cpu->pc, 0, addr, NULL);
        rv_trap(cpu, RV_CAUSE_STORE_MISALIGNED, addr);
        return -1;
    }
    if (cpu->probe && cpu->probe(cpu->bus_ctx, addr, size, 1)) {
        rv_trace_push(&cpu->trace, RV_TR_STORE_FAULT, cpu->pc, 0, addr, NULL);
        rv_trap(cpu, RV_CAUSE_STORE_ACCESS_FAULT, addr);
        return -1;
    }

    if ((addr & (uint32_t)(size - 1)) == 0) {
        switch (size) {
        case 1:  cpu->write8(cpu->bus_ctx, addr, val & 0xff); break;
        case 2:  cpu->write16(cpu->bus_ctx, addr, val & 0xffff); break;
        default: cpu->write32(cpu->bus_ctx, addr, val); break;
        }
    } else {
        for (i = 0; i < size; i++)
            cpu->write8(cpu->bus_ctx, addr + i, (val >> (8 * i)) & 0xff);
    }
    return 0;
}

/****************************************************************
 * Floating point support
 *
 * Every single-precision result is produced by computing an exact (or
 * correctly-signed) intermediate in double precision and then rounding it
 * to single precision with f32_round(). Nothing depends on the host FPU's
 * rounding mode, so <fenv.h> is never needed. That matters for two reasons:
 * WebAssembly has no rounding-mode control at all, and relying on the host
 * mode makes results depend on whatever the embedding process left behind.
 ****************************************************************/

#define F32_CANON_NAN   0x7fc00000u

/****************************************************************
 * Portable double-precision helpers
 *
 * The emulator uses no math library. Everything below is either a
 * compiler builtin that maps to a single machine instruction on both x86
 * and WebAssembly, or a few lines of bit manipulation. That keeps the
 * WebAssembly build free of imports and removes any dependence on the
 * host's floating-point environment.
 ****************************************************************/

static inline double
d_abs(double x)
{
    return __builtin_fabs(x);
}

/* Build with -fno-math-errno so this stays a single instruction. Without
 * it the compiler adds a call to the library sqrt for the negative case,
 * which fp_sqrt has already excluded. */
static inline double
d_sqrt(double x)
{
    return __builtin_sqrt(x);
}

static inline uint64_t
d_bits(double x)
{
    uint64_t b;

    memcpy(&b, &x, sizeof(b));
    return b;
}

static inline double
d_from_bits(uint64_t b)
{
    double x;

    memcpy(&x, &b, sizeof(x));
    return x;
}

static inline int
d_is_inf(double x)
{
    return (d_bits(x) & 0x7fffffffffffffffull) == 0x7ff0000000000000ull;
}

/** Largest integral value not greater than x. */
static double
d_floor(double x)
{
    double t;

    /* Beyond 2^52 every double is already an integer */
    if (d_abs(x) >= 4503599627370496.0)
        return x;
    t = (double)(int64_t)x;         /* truncates toward zero */
    return t > x ? t - 1.0 : t;
}

/** Smallest integral value not less than x. */
static double
d_ceil(double x)
{
    double t;

    if (d_abs(x) >= 4503599627370496.0)
        return x;
    t = (double)(int64_t)x;
    return t < x ? t + 1.0 : t;
}

/** True when an integral double is odd. Values at or above 2^53 are
 * multiples of a large power of two and therefore even. */
static int
d_is_odd(double x)
{
    if (d_abs(x) >= 9007199254740992.0)
        return 0;
    return (int)((int64_t)x & 1);
}

/** Split x into a fraction in [0.5, 1) and a power of two exponent. */
static double
d_frexp(double x, int *e)
{
    uint64_t b = d_bits(x);
    int ex = (int)((b >> 52) & 0x7ff);

    *e = 0;
    if (x == 0.0 || ex == 0x7ff)
        return x;
    if (ex == 0) {
        /* Subnormal: normalize first, then correct the exponent */
        x *= 18014398509481984.0;    /* 2^54 */
        b = d_bits(x);
        ex = (int)((b >> 52) & 0x7ff);
        *e = -54;
    }
    *e += ex - 1022;
    return d_from_bits((b & 0x800fffffffffffffull) |
                       ((uint64_t)1022 << 52));
}

/** Multiply x by two raised to n. */
static double
d_ldexp(double x, int n)
{
    /* Step in bounded chunks so the scale factor is always representable */
    while (n > 1000) {
        x *= d_from_bits((uint64_t)(1023 + 1000) << 52);
        n -= 1000;
    }
    while (n < -1000) {
        x *= d_from_bits((uint64_t)(1023 - 1000) << 52);
        n += 1000;
    }
    return x * d_from_bits((uint64_t)(1023 + n) << 52);
}

/** Exact product of two doubles, using Dekker's splitting.
 *
 * Returns the rounded product and sets *err so that the sum of the two is
 * the exact product. Every value this emulator multiplies came from a
 * single-precision operand, so the partial products stay far inside the
 * double exponent range and the transform is always exact. */
static double
two_product(double x, double y, double *err)
{
    const double splitter = 134217729.0;    /* 2^27 + 1 */
    double p = x * y;
    double cx = splitter * x;
    double cy = splitter * y;
    double xh = cx - (cx - x), xl = x - xh;
    double yh = cy - (cy - y), yl = y - yh;

    *err = ((xh * yh - p) + xh * yl + xl * yh) + xl * yl;
    return p;
}

/** The remainder a - x*y, for the case where x*y is very close to a.
 *
 * This replaces a fused multiply-add. The subtraction a - p is exact
 * because the two are within a factor of two of each other, so the sign of
 * the result is the sign of the exact remainder, which is all the rounding
 * code needs from it. */
static double
remainder_exact(double a, double x, double y)
{
    double err;
    double p = two_product(x, y, &err);

    return (a - p) - err;
}

/* Fraction position of the exact value relative to the truncated mantissa */
enum frac_pos {
    FRAC_ZERO = 0,
    FRAC_BELOW_HALF,
    FRAC_HALF,
    FRAC_ABOVE_HALF,
};

static inline uint32_t
f32_bits(float f)
{
    uint32_t b;
    memcpy(&b, &f, sizeof(b));
    return b;
}

static inline float
f32_val(uint32_t bits)
{
    float f;
    memcpy(&f, &bits, sizeof(f));
    return f;
}

static inline int
f32_is_nan(uint32_t b)
{
    return (b & 0x7f800000u) == 0x7f800000u && (b & 0x007fffffu) != 0;
}

static inline int
f32_is_snan(uint32_t b)
{
    return f32_is_nan(b) && (b & 0x00400000u) == 0;
}

static inline int
f32_is_inf(uint32_t b)
{
    return (b & 0x7fffffffu) == 0x7f800000u;
}

static inline int
f32_is_zero(uint32_t b)
{
    return (b & 0x7fffffffu) == 0;
}

static inline int
f32_sign(uint32_t b)
{
    return (int)(b >> 31);
}

static inline void
fflags_set(rv_cpu *cpu, uint32_t flags)
{
    cpu->fcsr |= flags & 0x1f;
}

/** Resolve a static rounding-mode field against frm. Returns -1 if invalid. */
static int
resolve_rm(rv_cpu *cpu, uint32_t rm)
{
    if (rm == RV_RM_DYN)
        rm = (cpu->fcsr >> 5) & 7;
    if (rm > RV_RM_RMM)
        return -1;
    return (int)rm;
}

/** Round the exact value (hi + lo) to single precision.
 *
 * hi carries the value and lo is a residual used only to decide which side
 * of a representable value or a midpoint the exact result falls on. For
 * addition and fused multiply-add, lo is the exact error term of a
 * two-sum, so hi + lo is the exact result. For division and square root,
 * lo is a small correctly-signed remainder. For multiplication lo is zero
 * because the product of two floats is exact in double precision.
 */
/* Round the exact magnitude a + lo_mag, whose exponent is e, to p
 * significand bits, and report whether anything was discarded. Splitting
 * this out lets the same exact value be rounded twice: once at the
 * precision the format actually has at that exponent, which is the
 * result delivered, and once at full precision, which is what the
 * underflow rule has to be judged against. */
static double
f32_round_at(double a, double lo_mag, int e, int p, int rm, int sign,
             int *inexact_out)
{
    double scaled, ip, fr;
    int frac, up;

    scaled = d_ldexp(a, p - e);
    ip = d_floor(scaled);
    fr = scaled - ip;           /* exact: both terms are doubles */

    if (fr == 0.0) {
        if (lo_mag == 0.0) {
            frac = FRAC_ZERO;
        } else if (lo_mag > 0.0) {
            frac = FRAC_BELOW_HALF;
        } else {
            ip -= 1.0;          /* exact value sits just below ip */
            frac = FRAC_ABOVE_HALF;
        }
    } else if (fr < 0.5) {
        frac = FRAC_BELOW_HALF;
    } else if (fr > 0.5) {
        frac = FRAC_ABOVE_HALF;
    } else if (lo_mag > 0.0) {
        frac = FRAC_ABOVE_HALF;
    } else if (lo_mag < 0.0) {
        frac = FRAC_BELOW_HALF;
    } else {
        frac = FRAC_HALF;
    }

    *inexact_out = frac != FRAC_ZERO;

    switch (rm) {
    case RV_RM_RNE:
        up = frac == FRAC_ABOVE_HALF ||
             (frac == FRAC_HALF && d_is_odd(ip));
        break;
    case RV_RM_RTZ:
        up = 0;
        break;
    case RV_RM_RDN:
        up = sign && *inexact_out;
        break;
    case RV_RM_RUP:
        up = !sign && *inexact_out;
        break;
    default:    /* RV_RM_RMM */
        up = frac == FRAC_ABOVE_HALF || frac == FRAC_HALF;
        break;
    }
    if (up)
        ip += 1.0;

    return d_ldexp(ip, e - p);
}

static uint32_t
f32_round(rv_cpu *cpu, double hi, double lo, int rm, int sign_of_zero)
{
    int e, e0, p, sign, inexact, unb_inexact;
    double a, m, lo_mag, mag, unbounded;
    float result;

    if (hi != hi)
        return F32_CANON_NAN;
    if (hi == 0.0 && lo == 0.0)
        return sign_of_zero ? 0x80000000u : 0u;
    if (hi == 0.0) {
        hi = lo;
        lo = 0.0;
    }

    sign = hi < 0.0;
    a = sign ? -hi : hi;
    lo_mag = sign ? -lo : lo;

    if (d_is_inf(a))
        return sign ? 0xff800000u : 0x7f800000u;

    /* Split a into mantissa and exponent, then find how many mantissa bits
     * single precision has available at that exponent. Below 2^-126 the
     * result is subnormal and precision shrinks one bit at a time. */
    m = d_frexp(a, &e);

    /* When a is an exact power of two and the residual is negative, the
     * exact value lies in the binade below, where the spacing is half as
     * wide. Decomposing at the higher exponent would round it to two
     * steps below instead of one. */
    if (m == 0.5 && lo_mag < 0.0)
        e--;

    e0 = e;
    p = 24;
    if (e < -125)
        p = 24 + (e + 125);
    if (p <= 0) {
        p = 0;
        e = -149;
    }

    /* The result as the format delivers it: below 2^-126 the significand
     * loses a bit per exponent step, so this rounding is coarser than
     * single precision proper. */
    mag = f32_round_at(a, lo_mag, e, p, rm, sign, &inexact);

    /* The same value rounded as though the exponent range were
     * unbounded, which keeps all 24 bits.  The two differ exactly in the
     * subnormal range, and both the overflow and the underflow rules are
     * written against this one rather than against what is delivered. */
    unbounded = p == 24 ? mag
                        : f32_round_at(a, lo_mag, e0, 24, rm, sign,
                                       &unb_inexact);

    if (unbounded >= d_ldexp(1.0, 128)) {
        fflags_set(cpu, RV_FFLAG_OF | RV_FFLAG_NX);
        switch (rm) {
        case RV_RM_RTZ:
            return sign ? 0xff7fffffu : 0x7f7fffffu;
        case RV_RM_RDN:
            return sign ? 0xff800000u : 0x7f7fffffu;
        case RV_RM_RUP:
            return sign ? 0xff7fffffu : 0x7f800000u;
        default:
            return sign ? 0xff800000u : 0x7f800000u;
        }
    }

    if (inexact) {
        fflags_set(cpu, RV_FFLAG_NX);
        /* "Tininess is detected after rounding", per the RISC-V spec,
         * which is the IEEE phrase for rounding as though the exponent
         * range were unbounded and asking whether the result still lies
         * below the smallest normal.  It is not a question about the
         * delivered result: in the subnormal range the delivered value
         * is rounded at reduced precision, so it can step up to exactly
         * 2^-126 while the full-precision value stays under it, and that
         * case is tiny.  Testing the delivered result instead lost the
         * underflow flag there, which is what a differential run against
         * qemu turned up on fnmadd.s. */
        if (unbounded < d_ldexp(1.0, -126))
            fflags_set(cpu, RV_FFLAG_UF);
    }

    if (mag == 0.0)
        return sign ? 0x80000000u : 0u;

    result = (float)(sign ? -mag : mag);    /* exact by construction */
    return f32_bits(result);
}

/** Exact sum of two doubles: returns hi and sets *err so hi + *err == x + y. */
static double
two_sum(double x, double y, double *err)
{
    double s = x + y;
    double bv = s - x;
    *err = (x - (s - bv)) + (y - bv);
    return s;
}

/** Common NaN handling for two-operand arithmetic. Returns 1 if handled. */
static int
fp_nan2(rv_cpu *cpu, uint32_t a, uint32_t b, uint32_t *out)
{
    if (f32_is_snan(a) || f32_is_snan(b))
        fflags_set(cpu, RV_FFLAG_NV);
    if (f32_is_nan(a) || f32_is_nan(b)) {
        *out = F32_CANON_NAN;
        return 1;
    }
    return 0;
}

static uint32_t
fp_add(rv_cpu *cpu, uint32_t a, uint32_t b, int rm)
{
    uint32_t out;
    double hi, lo;

    if (fp_nan2(cpu, a, b, &out))
        return out;
    if (f32_is_inf(a) || f32_is_inf(b)) {
        if (f32_is_inf(a) && f32_is_inf(b) && f32_sign(a) != f32_sign(b)) {
            fflags_set(cpu, RV_FFLAG_NV);
            return F32_CANON_NAN;
        }
        return f32_is_inf(a) ? a : b;
    }
    if (f32_is_zero(a) && f32_is_zero(b)) {
        /* -0 + -0 is -0; mixed signs give -0 only when rounding down */
        if (f32_sign(a) == f32_sign(b))
            return a;
        return rm == RV_RM_RDN ? 0x80000000u : 0u;
    }

    hi = two_sum((double)f32_val(a), (double)f32_val(b), &lo);
    return f32_round(cpu, hi, lo, rm, rm == RV_RM_RDN);
}

static uint32_t
fp_mul(rv_cpu *cpu, uint32_t a, uint32_t b, int rm)
{
    uint32_t out;
    int sign;

    if (fp_nan2(cpu, a, b, &out))
        return out;
    sign = f32_sign(a) ^ f32_sign(b);
    if (f32_is_inf(a) || f32_is_inf(b)) {
        if (f32_is_zero(a) || f32_is_zero(b)) {
            fflags_set(cpu, RV_FFLAG_NV);
            return F32_CANON_NAN;
        }
        return sign ? 0xff800000u : 0x7f800000u;
    }
    if (f32_is_zero(a) || f32_is_zero(b))
        return sign ? 0x80000000u : 0u;

    /* The product of two floats needs at most 48 bits, so it is exact */
    return f32_round(cpu, (double)f32_val(a) * (double)f32_val(b), 0.0,
                     rm, sign);
}

static uint32_t
fp_div(rv_cpu *cpu, uint32_t a, uint32_t b, int rm)
{
    uint32_t out;
    int sign;
    double q, r, da, db;

    if (fp_nan2(cpu, a, b, &out))
        return out;
    sign = f32_sign(a) ^ f32_sign(b);
    if (f32_is_inf(a) && f32_is_inf(b)) {
        fflags_set(cpu, RV_FFLAG_NV);
        return F32_CANON_NAN;
    }
    if (f32_is_zero(a) && f32_is_zero(b)) {
        fflags_set(cpu, RV_FFLAG_NV);
        return F32_CANON_NAN;
    }
    if (f32_is_inf(a))
        return sign ? 0xff800000u : 0x7f800000u;
    if (f32_is_inf(b) || f32_is_zero(a))
        return sign ? 0x80000000u : 0u;
    if (f32_is_zero(b)) {
        fflags_set(cpu, RV_FFLAG_DZ);
        return sign ? 0xff800000u : 0x7f800000u;
    }

    da = (double)f32_val(a);
    db = (double)f32_val(b);
    q = da / db;
    /* The remainder gives the sign of the exact error, which tells
     * which side of q the exact quotient lies on */
    r = remainder_exact(da, q, db);
    return f32_round(cpu, q, r == 0.0 ? 0.0 : (db < 0.0 ? -r : r), rm, sign);
}

static uint32_t
fp_sqrt(rv_cpu *cpu, uint32_t a, int rm)
{
    double da, q, r;

    if (f32_is_snan(a))
        fflags_set(cpu, RV_FFLAG_NV);
    if (f32_is_nan(a))
        return F32_CANON_NAN;
    if (f32_is_zero(a))
        return a;                       /* sqrt(-0) is -0 */
    if (f32_sign(a)) {
        fflags_set(cpu, RV_FFLAG_NV);
        return F32_CANON_NAN;
    }
    if (f32_is_inf(a))
        return a;

    da = (double)f32_val(a);
    q = d_sqrt(da);
    r = remainder_exact(da, q, q);
    return f32_round(cpu, q, r, rm, 0);
}

/** Fused multiply-add: a * b + c with a single rounding. */
static uint32_t
fp_fma(rv_cpu *cpu, uint32_t a, uint32_t b, uint32_t c, int rm)
{
    int psign, invalid;
    double p, hi, lo, err;

    if (f32_is_snan(a) || f32_is_snan(b) || f32_is_snan(c))
        fflags_set(cpu, RV_FFLAG_NV);

    psign = f32_sign(a) ^ f32_sign(b);
    invalid = (f32_is_inf(a) && f32_is_zero(b)) ||
              (f32_is_zero(a) && f32_is_inf(b));
    if (invalid) {
        fflags_set(cpu, RV_FFLAG_NV);
        return F32_CANON_NAN;
    }
    if (f32_is_nan(a) || f32_is_nan(b) || f32_is_nan(c))
        return F32_CANON_NAN;

    if (f32_is_inf(a) || f32_is_inf(b)) {
        if (f32_is_inf(c) && f32_sign(c) != psign) {
            fflags_set(cpu, RV_FFLAG_NV);
            return F32_CANON_NAN;
        }
        return psign ? 0xff800000u : 0x7f800000u;
    }
    if (f32_is_inf(c))
        return c;

    /* Exact product, then an exact two-sum with the addend */
    p = (double)f32_val(a) * (double)f32_val(b);
    if (p == 0.0 && f32_is_zero(c)) {
        if (psign == f32_sign(c))
            return psign ? 0x80000000u : 0u;
        return rm == RV_RM_RDN ? 0x80000000u : 0u;
    }
    hi = two_sum(p, (double)f32_val(c), &err);
    lo = err;
    return f32_round(cpu, hi, lo, rm, rm == RV_RM_RDN);
}

/** fmin.s / fmax.s. is_max selects the maximum. */
static uint32_t
fp_minmax(rv_cpu *cpu, uint32_t a, uint32_t b, int is_max)
{
    float fa, fb;

    if (f32_is_snan(a) || f32_is_snan(b))
        fflags_set(cpu, RV_FFLAG_NV);
    if (f32_is_nan(a) && f32_is_nan(b))
        return F32_CANON_NAN;
    if (f32_is_nan(a))
        return b;
    if (f32_is_nan(b))
        return a;
    if (f32_is_zero(a) && f32_is_zero(b)) {
        /* -0 compares less than +0 for these instructions */
        int sa = f32_sign(a);
        if (is_max)
            return sa ? b : a;
        return sa ? a : b;
    }
    fa = f32_val(a);
    fb = f32_val(b);
    if (is_max)
        return fa > fb ? a : b;
    return fa < fb ? a : b;
}

/** Round a double holding an exact float value to an integral double. */
static double
round_integral(double d, int rm)
{
    double f = d_floor(d);
    double diff = d - f;

    switch (rm) {
    case RV_RM_RTZ:
        return d < 0.0 ? d_ceil(d) : f;
    case RV_RM_RDN:
        return f;
    case RV_RM_RUP:
        return d_ceil(d);
    case RV_RM_RMM:
        if (diff > 0.5)
            return f + 1.0;
        if (diff < 0.5)
            return f;
        return d < 0.0 ? f : f + 1.0;
    default:    /* RV_RM_RNE */
        if (diff > 0.5)
            return f + 1.0;
        if (diff < 0.5)
            return f;
        return d_is_odd(f) ? f + 1.0 : f;
    }
}

/** fcvt.w.s / fcvt.wu.s with RISC-V saturation semantics. */
static uint32_t
fp_to_int(rv_cpu *cpu, uint32_t a, int is_unsigned, int rm)
{
    double d, r, lim_lo, lim_hi;

    if (f32_is_nan(a)) {
        fflags_set(cpu, RV_FFLAG_NV);
        return is_unsigned ? 0xffffffffu : 0x7fffffffu;
    }
    lim_lo = is_unsigned ? 0.0 : -2147483648.0;
    lim_hi = is_unsigned ? 4294967295.0 : 2147483647.0;

    if (f32_is_inf(a)) {
        fflags_set(cpu, RV_FFLAG_NV);
        if (f32_sign(a))
            return is_unsigned ? 0u : 0x80000000u;
        return is_unsigned ? 0xffffffffu : 0x7fffffffu;
    }

    d = (double)f32_val(a);
    r = round_integral(d, rm);

    /* An out-of-range conversion raises only the invalid flag. The flags
     * are accrued, so this must not disturb whatever is already set. */
    if (r < lim_lo) {
        fflags_set(cpu, RV_FFLAG_NV);
        return is_unsigned ? 0u : 0x80000000u;
    }
    if (r > lim_hi) {
        fflags_set(cpu, RV_FFLAG_NV);
        return is_unsigned ? 0xffffffffu : 0x7fffffffu;
    }
    if (r != d)
        fflags_set(cpu, RV_FFLAG_NX);

    if (is_unsigned)
        return (uint32_t)r;
    return (uint32_t)(int32_t)r;
}

/** fclass.s: a ten-bit classification of the operand. */
static uint32_t
fp_class(uint32_t a)
{
    int sign = f32_sign(a);
    uint32_t exp = (a >> 23) & 0xff;
    uint32_t man = a & 0x7fffffu;

    if (exp == 0xff) {
        if (man == 0)
            return sign ? (1u << 0) : (1u << 7);
        return (man & 0x400000u) ? (1u << 9) : (1u << 8);
    }
    if (exp == 0) {
        if (man == 0)
            return sign ? (1u << 3) : (1u << 4);
        return sign ? (1u << 2) : (1u << 5);
    }
    return sign ? (1u << 1) : (1u << 6);
}

/****************************************************************
 * CSR access
 ****************************************************************/

static int
csr_read(rv_cpu *cpu, uint32_t csr, uint32_t *out)
{
    switch (csr) {
    case RV_CSR_FFLAGS:   *out = cpu->fcsr & 0x1f; return 0;
    case RV_CSR_FRM:      *out = (cpu->fcsr >> 5) & 7; return 0;
    case RV_CSR_FCSR:     *out = cpu->fcsr & 0xff; return 0;
    case RV_CSR_CYCLE:
    case RV_CSR_MCYCLE:   *out = (uint32_t)cpu->mcycle; return 0;
    case RV_CSR_CYCLEH:
    case RV_CSR_MCYCLEH:  *out = (uint32_t)(cpu->mcycle >> 32); return 0;
    case RV_CSR_TIME:     *out = (uint32_t)cpu->mcycle; return 0;
    case RV_CSR_TIMEH:    *out = (uint32_t)(cpu->mcycle >> 32); return 0;
    case RV_CSR_INSTRET:
    case RV_CSR_MINSTRET: *out = (uint32_t)cpu->minstret; return 0;
    case RV_CSR_INSTRETH:
    case RV_CSR_MINSTRETH:*out = (uint32_t)(cpu->minstret >> 32); return 0;
    case RV_CSR_MSTATUS:  *out = cpu->mstatus; return 0;
    /* RV32 with I, M, A, F, C and B. Machine mode is the only privilege
     * mode implemented, so neither S nor U is advertised. The B bit means
     * Zba, Zbb and Zbs all present, which is the only combination this
     * emulator offers. */
    case RV_CSR_MISA:     *out = (1u << 30) | (1u << 8) | (1u << 12) |
                                 (1u << 5) | (1u << 2) |
                                 (cpu->atomics ? (1u << 0) : 0) |
                                 (cpu->bitmanip ? (1u << 1) : 0);
                          return 0;
    case RV_CSR_MIE:      *out = cpu->mie; return 0;
    case RV_CSR_MTVEC:    *out = cpu->mtvec; return 0;
    case RV_CSR_MSCRATCH: *out = cpu->mscratch; return 0;
    case RV_CSR_MEPC:     *out = cpu->mepc; return 0;
    case RV_CSR_MCAUSE:   *out = cpu->mcause; return 0;
    case RV_CSR_MTVAL:    *out = cpu->mtval; return 0;
    case RV_CSR_MIP:      *out = cpu->mip; return 0;
    case RV_CSR_MVENDORID:
    case RV_CSR_MARCHID:
    case RV_CSR_MIMPID:
    case RV_CSR_MHARTID:  *out = 0; return 0;
    default:              return -1;
    }
}

static int
csr_write(rv_cpu *cpu, uint32_t csr, uint32_t val)
{
    switch (csr) {
    case RV_CSR_FFLAGS:   cpu->fcsr = (cpu->fcsr & ~0x1fu) | (val & 0x1f);
                          return 0;
    case RV_CSR_FRM:      cpu->fcsr = (cpu->fcsr & ~0xe0u) |
                                      ((val & 7) << 5); return 0;
    case RV_CSR_FCSR:     cpu->fcsr = val & 0xff; return 0;
    case RV_CSR_MSTATUS:  cpu->mstatus = val; return 0;
    case RV_CSR_MIE:      cpu->mie = val; return 0;
    case RV_CSR_MTVEC:    cpu->mtvec = val; return 0;
    case RV_CSR_MSCRATCH: cpu->mscratch = val; return 0;
    case RV_CSR_MEPC:     cpu->mepc = val & ~1u; return 0;
    case RV_CSR_MCAUSE:   cpu->mcause = val; return 0;
    case RV_CSR_MTVAL:    cpu->mtval = val; return 0;
    case RV_CSR_MIP:      cpu->mip = val; return 0;
    case RV_CSR_MCYCLE:   cpu->mcycle = (cpu->mcycle & 0xffffffff00000000ull) |
                                        val; return 0;
    case RV_CSR_MCYCLEH:  cpu->mcycle = (cpu->mcycle & 0xffffffffull) |
                                        ((uint64_t)val << 32); return 0;
    case RV_CSR_MINSTRET: cpu->minstret = (cpu->minstret &
                                           0xffffffff00000000ull) | val;
                          return 0;
    case RV_CSR_MINSTRETH:cpu->minstret = (cpu->minstret & 0xffffffffull) |
                                          ((uint64_t)val << 32); return 0;
    case RV_CSR_MISA:     return 0;     /* writes ignored */
    default:              return -1;    /* read-only or unimplemented */
    }
}

/****************************************************************
 * Compressed instruction expansion
 ****************************************************************/

static inline uint32_t
enc_i(uint32_t imm, uint32_t rs1, uint32_t f3, uint32_t rd, uint32_t op)
{
    return ((imm & 0xfff) << 20) | (rs1 << 15) | (f3 << 12) |
           (rd << 7) | op;
}

static inline uint32_t
enc_s(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t f3, uint32_t op)
{
    return (((imm >> 5) & 0x7f) << 25) | (rs2 << 20) | (rs1 << 15) |
           (f3 << 12) | ((imm & 0x1f) << 7) | op;
}

static inline uint32_t
enc_b(uint32_t imm, uint32_t rs2, uint32_t rs1, uint32_t f3, uint32_t op)
{
    return (((imm >> 12) & 1) << 31) | (((imm >> 5) & 0x3f) << 25) |
           (rs2 << 20) | (rs1 << 15) | (f3 << 12) |
           (((imm >> 1) & 0xf) << 8) | (((imm >> 11) & 1) << 7) | op;
}

static inline uint32_t
enc_j(uint32_t imm, uint32_t rd, uint32_t op)
{
    return (((imm >> 20) & 1) << 31) | (((imm >> 1) & 0x3ff) << 21) |
           (((imm >> 11) & 1) << 20) | (((imm >> 12) & 0xff) << 12) |
           (rd << 7) | op;
}

static inline uint32_t
enc_r(uint32_t f7, uint32_t rs2, uint32_t rs1, uint32_t f3, uint32_t rd,
      uint32_t op)
{
    return (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) |
           (rd << 7) | op;
}

/* Field helpers for the three-bit register fields, which select x8-x15 */
#define CRS1P(c)    (((c) >> 7 & 7) + 8)
#define CRS2P(c)    (((c) >> 2 & 7) + 8)
#define CRD(c)      ((c) >> 7 & 0x1f)
#define CRS2(c)     ((c) >> 2 & 0x1f)

/** Expand a Zcb encoding, or return 0 if it is not one.
 *
 * Zcb fills two holes the base compressed set left empty: the byte and
 * halfword loads and stores, which C never had, and six one-operand
 * arithmetic forms. Every one of them stands for exactly one 32-bit
 * instruction, so unlike Zcmp they need nothing but the expander that is
 * already here.
 *
 * Three of them expand into Zbb, which is the specification's own
 * dependency rather than a shortcut taken here: c.sext.b, c.zext.h and
 * c.sext.h require Zbb, and c.mul requires M. If those extensions are off,
 * the expanded instruction raises the illegal-instruction trap on its own
 * and no separate check is needed.
 */
uint32_t
rv_expand_zcb(uint16_t c)
{
    uint32_t imm;

    if (((c >> 13) & 7) != 4)           /* every Zcb encoding is funct3 100 */
        return 0;

    if ((c & 3) == 0) {
        /* Quadrant 0: the loads and stores. The byte offset is two bits in
         * the opposite order to every other compressed immediate, and the
         * halfword offset is the upper of those two alone. */
        if (c & 0x1000)
            return 0;                   /* reserved */
        switch ((c >> 10) & 3) {
        case 0:                         /* c.lbu */
            imm = ((c >> 6) & 1) | (((c >> 5) & 1) << 1);
            return enc_i(imm, CRS1P(c), 4, CRS2P(c), OP_LOAD);
        case 1:                         /* c.lhu and c.lh */
            imm = ((c >> 5) & 1) << 1;
            return enc_i(imm, CRS1P(c), (c >> 6) & 1 ? 1 : 5, CRS2P(c),
                         OP_LOAD);
        case 2:                         /* c.sb */
            imm = ((c >> 6) & 1) | (((c >> 5) & 1) << 1);
            return enc_s(imm, CRS2P(c), CRS1P(c), 0, OP_STORE);
        default:                        /* c.sh */
            if (c & 0x40)
                return 0;               /* reserved */
            imm = ((c >> 5) & 1) << 1;
            return enc_s(imm, CRS2P(c), CRS1P(c), 1, OP_STORE);
        }
    }

    if ((c & 3) != 1 || ((c >> 10) & 7) != 7)
        return 0;

    /* Quadrant 1, in the space the base set reserves for the RV64-only
     * c.subw and c.addw. Both operands are the same register except for
     * c.mul, which takes a second. */
    if (((c >> 5) & 3) == 2)            /* c.mul */
        return enc_r(0x01, CRS2P(c), CRS1P(c), 0, CRS1P(c), OP_REG);
    if (((c >> 5) & 3) != 3)
        return 0;                       /* reserved */

    switch ((c >> 2) & 7) {
    case 0:                             /* c.zext.b */
        return enc_i(0xff, CRS1P(c), 7, CRS1P(c), OP_IMM);
    case 1:                             /* c.sext.b, a Zbb instruction */
        return enc_i((0x30 << 5) | 4, CRS1P(c), 1, CRS1P(c), OP_IMM);
    case 2:                             /* c.zext.h, a Zbb instruction */
        return enc_r(0x04, 0, CRS1P(c), 4, CRS1P(c), OP_REG);
    case 3:                             /* c.sext.h, a Zbb instruction */
        return enc_i((0x30 << 5) | 5, CRS1P(c), 1, CRS1P(c), OP_IMM);
    case 5:                             /* c.not */
        return enc_i(0xfff, CRS1P(c), 4, CRS1P(c), OP_IMM);
    default:
        /* 4 is c.zext.w, which is RV64 only; 6 and 7 are reserved */
        return 0;
    }
}

uint32_t
rv_expand_c(uint16_t c)
{
    uint32_t op = c & 3;
    uint32_t f3 = (c >> 13) & 7;
    uint32_t imm, rd;

    if (c == 0)
        return 0;               /* defined illegal instruction */

    switch (op) {
    case 0:
        switch (f3) {
        case 0:     /* c.addi4spn */
            imm = ((c >> 7 & 0x0f) << 6) | ((c >> 11 & 3) << 4) |
                  ((c >> 5 & 1) << 3) | ((c >> 6 & 1) << 2);
            if (imm == 0)
                return 0;       /* reserved */
            return enc_i(imm, 2, 0, CRS2P(c), OP_IMM);
        case 2:     /* c.lw */
        case 3:     /* c.flw */
            imm = ((c >> 10 & 7) << 3) | ((c >> 6 & 1) << 2) |
                  ((c >> 5 & 1) << 6);
            return enc_i(imm, CRS1P(c), 2, CRS2P(c),
                         f3 == 2 ? OP_LOAD : OP_LOAD_FP);
        case 6:     /* c.sw */
        case 7:     /* c.fsw */
            imm = ((c >> 10 & 7) << 3) | ((c >> 6 & 1) << 2) |
                  ((c >> 5 & 1) << 6);
            return enc_s(imm, CRS2P(c), CRS1P(c), 2,
                         f3 == 6 ? OP_STORE : OP_STORE_FP);
        default:
            return 0;           /* c.fld / c.fsd need the D extension */
        }
    case 1:
        switch (f3) {
        case 0:     /* c.addi */
            imm = (c >> 2 & 0x1f) | ((c >> 12 & 1) ? 0xffffffe0u : 0);
            return enc_i(imm, CRD(c), 0, CRD(c), OP_IMM);
        case 1:     /* c.jal */
            imm = ((c >> 12 & 1) << 11) | ((c >> 11 & 1) << 4) |
                  ((c >> 9 & 3) << 8) | ((c >> 8 & 1) << 10) |
                  ((c >> 7 & 1) << 6) | ((c >> 6 & 1) << 7) |
                  ((c >> 3 & 7) << 1) | ((c >> 2 & 1) << 5);
            if (imm & 0x800)
                imm |= 0xfffff000u;
            return enc_j(imm, 1, OP_JAL);
        case 2:     /* c.li */
            imm = (c >> 2 & 0x1f) | ((c >> 12 & 1) ? 0xffffffe0u : 0);
            return enc_i(imm, 0, 0, CRD(c), OP_IMM);
        case 3:
            rd = CRD(c);
            if (rd == 2) {      /* c.addi16sp */
                imm = ((c >> 12 & 1) << 9) | ((c >> 6 & 1) << 4) |
                      ((c >> 5 & 1) << 6) | ((c >> 3 & 3) << 7) |
                      ((c >> 2 & 1) << 5);
                if (imm == 0)
                    return 0;
                if (imm & 0x200)
                    imm |= 0xfffffc00u;
                return enc_i(imm, 2, 0, 2, OP_IMM);
            }
            /* c.lui. A zero immediate is reserved, but rd = x0 is a hint,
             * which executes as a write to x0 and so does nothing. */
            imm = ((c >> 12 & 1) << 17) | ((c >> 2 & 0x1f) << 12);
            if (imm == 0)
                return 0;
            if (imm & 0x20000)
                imm |= 0xfffc0000u;
            return (imm & 0xfffff000u) | (rd << 7) | OP_LUI;
        case 4:
            switch (c >> 10 & 3) {
            case 0:     /* c.srli */
            case 1:     /* c.srai */
                if (c & 0x1000)
                    return 0;   /* shamt[5] must be zero on RV32 */
                imm = c >> 2 & 0x1f;
                return enc_i(imm | ((c >> 10 & 1) ? 0x400 : 0), CRS1P(c), 5,
                             CRS1P(c), OP_IMM);
            case 2:     /* c.andi */
                imm = (c >> 2 & 0x1f) | ((c >> 12 & 1) ? 0xffffffe0u : 0);
                return enc_i(imm, CRS1P(c), 7, CRS1P(c), OP_IMM);
            default:
                if (c & 0x1000)
                    return 0;   /* c.subw / c.addw are RV64 only */
                switch (c >> 5 & 3) {
                case 0: return enc_r(0x20, CRS2P(c), CRS1P(c), 0, CRS1P(c),
                                     OP_REG);   /* c.sub */
                case 1: return enc_r(0x00, CRS2P(c), CRS1P(c), 4, CRS1P(c),
                                     OP_REG);   /* c.xor */
                case 2: return enc_r(0x00, CRS2P(c), CRS1P(c), 6, CRS1P(c),
                                     OP_REG);   /* c.or */
                default: return enc_r(0x00, CRS2P(c), CRS1P(c), 7, CRS1P(c),
                                      OP_REG);  /* c.and */
                }
            }
        case 5:     /* c.j */
            imm = ((c >> 12 & 1) << 11) | ((c >> 11 & 1) << 4) |
                  ((c >> 9 & 3) << 8) | ((c >> 8 & 1) << 10) |
                  ((c >> 7 & 1) << 6) | ((c >> 6 & 1) << 7) |
                  ((c >> 3 & 7) << 1) | ((c >> 2 & 1) << 5);
            if (imm & 0x800)
                imm |= 0xfffff000u;
            return enc_j(imm, 0, OP_JAL);
        default:    /* c.beqz (6) and c.bnez (7) */
            imm = ((c >> 12 & 1) << 8) | ((c >> 10 & 3) << 3) |
                  ((c >> 5 & 3) << 6) | ((c >> 3 & 3) << 1) |
                  ((c >> 2 & 1) << 5);
            if (imm & 0x100)
                imm |= 0xfffffe00u;
            return enc_b(imm, 0, CRS1P(c), f3 == 6 ? 0 : 1, OP_BRANCH);
        }
    case 2:
        switch (f3) {
        case 0:     /* c.slli */
            if (c & 0x1000)
                return 0;
            return enc_i(c >> 2 & 0x1f, CRD(c), 1, CRD(c), OP_IMM);
        case 2:     /* c.lwsp */
        case 3:     /* c.flwsp */
            if (f3 == 2 && CRD(c) == 0)
                return 0;
            imm = ((c >> 12 & 1) << 5) | ((c >> 4 & 7) << 2) |
                  ((c >> 2 & 3) << 6);
            return enc_i(imm, 2, 2, CRD(c),
                         f3 == 2 ? OP_LOAD : OP_LOAD_FP);
        case 4:
            if ((c & 0x1000) == 0) {
                if (CRS2(c) == 0) {         /* c.jr */
                    if (CRD(c) == 0)
                        return 0;
                    return enc_i(0, CRD(c), 0, 0, OP_JALR);
                }
                /* c.mv */
                return enc_r(0, CRS2(c), 0, 0, CRD(c), OP_REG);
            }
            if (CRS2(c) == 0) {
                if (CRD(c) == 0)            /* c.ebreak */
                    return enc_i(1, 0, 0, 0, OP_SYSTEM);
                /* c.jalr */
                return enc_i(0, CRD(c), 0, 1, OP_JALR);
            }
            /* c.add */
            return enc_r(0, CRS2(c), CRD(c), 0, CRD(c), OP_REG);
        case 6:     /* c.swsp */
        case 7:     /* c.fswsp */
            imm = ((c >> 9 & 0xf) << 2) | ((c >> 7 & 3) << 6);
            return enc_s(imm, CRS2(c), 2, 2,
                         f3 == 6 ? OP_STORE : OP_STORE_FP);
        default:
            return 0;           /* c.fldsp / c.fsdsp need the D extension */
        }
    default:
        return 0;               /* not a compressed encoding */
    }
}

/****************************************************************
 * Zcmp: whole-frame push and pop
 *
 * These four instructions build or tear down a stack frame in a single
 * two-byte encoding, the way the 68000 family's movem does. They cannot
 * be expanded into one 32-bit instruction the way the rest of the
 * compressed set can, because each one performs several memory accesses
 * and a stack adjustment, so they are executed directly.
 *
 * The frame layout below was determined by running the instructions on a
 * reference implementation rather than read off a specification: the
 * registers sit at the top of the allocated frame with any padding
 * beneath them, ra occupies the lowest of the register slots, and the
 * saved registers ascend from there.
 ****************************************************************/

/* s0 and s1 are x8 and x9; s2 upwards continue at x18 */
static const uint8_t zcmp_sreg[12] = {
    8, 9, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
};

/** Expand an rlist field into the registers it names.
 * Returns the count, or 0 for the reserved encodings. */
static int
zcmp_regs(uint32_t rlist, uint8_t *out)
{
    int n = 0, i, count;

    if (rlist < 4)
        return 0;
    out[n++] = 1;                               /* ra */
    count = rlist == 15 ? 12 : (int)rlist - 4;  /* rlist 15 names s0-s11 */
    for (i = 0; i < count; i++)
        out[n++] = zcmp_sreg[i];
    return n;
}

/** Total stack adjustment: a base set by the list size, plus the
 * two-bit immediate scaled by sixteen. */
static uint32_t
zcmp_stack_adj(uint32_t rlist, uint32_t spimm)
{
    uint32_t base;

    if (rlist <= 7)
        base = 16;
    else if (rlist <= 11)
        base = 32;
    else if (rlist <= 14)
        base = 48;
    else
        base = 64;
    return base + spimm * 16;
}

/** Execute one Zcmp encoding.
 *
 * Returns 0 when the instruction was executed, -1 when the encoding is
 * not a valid Zcmp instruction. *next receives the following program
 * counter, which the returning forms take from the restored ra.
 */
static int
exec_zcmp(rv_cpu *cpu, uint16_t insn, uint32_t *next)
{
    uint8_t regs[13];
    uint32_t funct5, rlist, spimm, adj, addr;
    int n, i;

    /* cm.mvsa01 and cm.mva01s share the space and move register pairs */
    if (((insn >> 10) & 7) == 3) {
        uint32_t r1 = (insn >> 7) & 7, r2 = (insn >> 2) & 7;

        if (r1 == r2)
            return -1;                  /* the two must differ */
        switch ((insn >> 5) & 3) {
        case 1:                         /* cm.mvsa01 */
            cpu->x[zcmp_sreg[r1]] = cpu->x[10];
            cpu->x[zcmp_sreg[r2]] = cpu->x[11];
            return 0;
        case 3:                         /* cm.mva01s */
            cpu->x[10] = cpu->x[zcmp_sreg[r1]];
            cpu->x[11] = cpu->x[zcmp_sreg[r2]];
            return 0;
        default:
            return -1;
        }
    }

    funct5 = (insn >> 8) & 0x1f;
    rlist = (insn >> 4) & 0x0f;
    spimm = (insn >> 2) & 0x03;

    n = zcmp_regs(rlist, regs);
    if (n == 0)
        return -1;
    adj = zcmp_stack_adj(rlist, spimm);

    switch (funct5) {
    case 0x18:                          /* cm.push */
        /* The registers land at the top of the new frame */
        addr = cpu->x[2] - (uint32_t)n * 4;
        for (i = 0; i < n; i++) {
            if (mem_write(cpu, addr + (uint32_t)i * 4, 4, cpu->x[regs[i]]))
                return 0;               /* a fault already redirected us */
        }
        cpu->x[2] -= adj;
        return 0;

    case 0x1a:                          /* cm.pop */
    case 0x1c:                          /* cm.popretz */
    case 0x1e:                          /* cm.popret */
        addr = cpu->x[2] + adj - (uint32_t)n * 4;
        for (i = 0; i < n; i++) {
            uint32_t v;

            if (mem_read(cpu, addr + (uint32_t)i * 4, 4, &v))
                return 0;
            cpu->x[regs[i]] = v;
        }
        cpu->x[2] += adj;
        if (funct5 == 0x1c)
            cpu->x[10] = 0;             /* cm.popretz clears the result */
        if (funct5 != 0x1a)
            *next = cpu->x[1];          /* return to the restored ra */
        return 0;

    default:
        return -1;
    }
}

/** True when a compressed encoding falls in the Zcmp part of the
 * double-precision load and store space. */
static inline int
is_zcmp(uint16_t insn)
{
    if ((insn & 0xe003) != 0xa002)      /* funct3 101, quadrant 2 */
        return 0;
    if (((insn >> 10) & 7) == 3)        /* the register-move pair */
        return 1;
    return ((insn >> 11) & 3) == 3;     /* the push and pop family */
}

/****************************************************************
 * Zba, Zbb and Zbs
 ****************************************************************/

/* The three ratified bit-manipulation extensions, which together are the B
 * extension. Every one of these is a pure function of one or two registers.
 * There is no new architectural state, no memory access and no trap that
 * they can raise, which is what makes them cheap to add to an interpreter
 * that already decodes the base integer set.
 */

static uint32_t
rotr32(uint32_t v, uint32_t n)
{
    n &= 31;
    return n ? (v >> n) | (v << (32 - n)) : v;
}

static uint32_t
rotl32(uint32_t v, uint32_t n)
{
    n &= 31;
    return n ? (v << n) | (v >> (32 - n)) : v;
}

/* GCC and clang turn these three builtins into one host instruction, and in
 * WebAssembly they are the single opcodes i32.clz, i32.ctz and i32.popcnt.
 * The portable versions are kept so the emulator still builds on a compiler
 * that offers neither. */

static uint32_t
clz32(uint32_t v)
{
#if defined(__GNUC__) || defined(__clang__)
    return v ? (uint32_t)__builtin_clz(v) : 32;
#else
    uint32_t n = 0;

    if (v == 0)
        return 32;
    while (!(v & 0x80000000u)) {
        v <<= 1;
        n++;
    }
    return n;
#endif
}

static uint32_t
ctz32(uint32_t v)
{
#if defined(__GNUC__) || defined(__clang__)
    return v ? (uint32_t)__builtin_ctz(v) : 32;
#else
    uint32_t n = 0;

    if (v == 0)
        return 32;
    while (!(v & 1)) {
        v >>= 1;
        n++;
    }
    return n;
#endif
}

static uint32_t
cpop32(uint32_t v)
{
#if defined(__GNUC__) || defined(__clang__)
    return (uint32_t)__builtin_popcount(v);
#else
    uint32_t n = 0;

    while (v) {
        v &= v - 1;
        n++;
    }
    return n;
#endif
}

/* orc.b sets every bit of a byte if any bit of that byte was set. It is
 * what makes a word-at-a-time strlen or memchr cheap. */
static uint32_t
orcb32(uint32_t v)
{
    uint32_t i, out = 0;

    for (i = 0; i < 32; i += 8)
        if ((v >> i) & 0xffu)
            out |= 0xffu << i;
    return out;
}

static uint32_t
rev8_32(uint32_t v)
{
    return (v >> 24) | ((v >> 8) & 0xff00u) |
           ((v << 8) & 0xff0000u) | (v << 24);
}

/** Evaluate a register-register Zba, Zbb or Zbs encoding.
 *
 * Returns 1 with the result in *out when the encoding is one of them, and 0
 * when it is not, leaving the caller to reject it. Every funct7 value tested
 * here is one the base integer set leaves illegal, so the order in which the
 * caller tries the two decoders does not matter.
 */
static int
bitmanip_reg(uint32_t insn, uint32_t f3, uint32_t f7,
             uint32_t a, uint32_t b, uint32_t *out)
{
    uint32_t shamt = b & 31;
    int32_t sa = (int32_t)a, sb = (int32_t)b;

    switch (f7) {
    case 0x04:                                      /* Zbb */
        if (f3 == 4 && RS2(insn) == 0) {
            *out = a & 0xffffu;                     /* zext.h */
            return 1;
        }
        break;
    case 0x05:                                      /* Zbb */
        switch (f3) {
        case 4: *out = sa < sb ? a : b; return 1;   /* min */
        case 5: *out = a < b ? a : b; return 1;     /* minu */
        case 6: *out = sa > sb ? a : b; return 1;   /* max */
        case 7: *out = a > b ? a : b; return 1;     /* maxu */
        }
        break;
    case 0x10:                                      /* Zba */
        switch (f3) {
        case 2: *out = (a << 1) + b; return 1;      /* sh1add */
        case 4: *out = (a << 2) + b; return 1;      /* sh2add */
        case 6: *out = (a << 3) + b; return 1;      /* sh3add */
        }
        break;
    case 0x14:                                      /* Zbs */
        if (f3 == 1) {
            *out = a | (1u << shamt);               /* bset */
            return 1;
        }
        break;
    case 0x20:                                      /* Zbb */
        switch (f3) {
        case 4: *out = ~(a ^ b); return 1;          /* xnor */
        case 6: *out = a | ~b; return 1;            /* orn */
        case 7: *out = a & ~b; return 1;            /* andn */
        }
        break;
    case 0x24:                                      /* Zbs */
        if (f3 == 1) {
            *out = a & ~(1u << shamt);              /* bclr */
            return 1;
        }
        if (f3 == 5) {
            *out = (a >> shamt) & 1;                /* bext */
            return 1;
        }
        break;
    case 0x30:                                      /* Zbb */
        if (f3 == 1) {
            *out = rotl32(a, shamt);                /* rol */
            return 1;
        }
        if (f3 == 5) {
            *out = rotr32(a, shamt);                /* ror */
            return 1;
        }
        break;
    case 0x34:                                      /* Zbs */
        if (f3 == 1) {
            *out = a ^ (1u << shamt);               /* binv */
            return 1;
        }
        break;
    }
    return 0;
}

/** Evaluate a register-immediate Zbb or Zbs encoding.
 *
 * The shift amount is five bits on RV32, so the immediate splits into a
 * seven-bit selector in funct7 and the amount in the rs2 field. The unary
 * Zbb instructions reuse that amount field as a second selector.
 */
static int
bitmanip_imm(uint32_t insn, uint32_t f3, uint32_t f7,
             uint32_t a, uint32_t *out)
{
    uint32_t shamt = RS2(insn);

    switch (f7) {
    case 0x14:
        if (f3 == 1) {
            *out = a | (1u << shamt);               /* bseti */
            return 1;
        }
        if (f3 == 5 && shamt == 0x07) {
            *out = orcb32(a);                       /* orc.b */
            return 1;
        }
        break;
    case 0x24:
        if (f3 == 1) {
            *out = a & ~(1u << shamt);              /* bclri */
            return 1;
        }
        if (f3 == 5) {
            *out = (a >> shamt) & 1;                /* bexti */
            return 1;
        }
        break;
    case 0x30:
        if (f3 == 5) {
            *out = rotr32(a, shamt);                /* rori */
            return 1;
        }
        if (f3 == 1) {
            switch (shamt) {
            case 0x00: *out = clz32(a); return 1;
            case 0x01: *out = ctz32(a); return 1;
            case 0x02: *out = cpop32(a); return 1;
            case 0x04: *out = (uint32_t)(int32_t)(int8_t)a; return 1;
            case 0x05: *out = (uint32_t)(int32_t)(int16_t)a; return 1;
            }
        }
        break;
    case 0x34:
        if (f3 == 1) {
            *out = a ^ (1u << shamt);               /* binvi */
            return 1;
        }
        if (f3 == 5 && shamt == 0x18) {
            *out = rev8_32(a);                      /* rev8 */
            return 1;
        }
        break;
    }
    return 0;
}

/****************************************************************
 * Instruction execution
 ****************************************************************/

static void
illegal(rv_cpu *cpu, uint32_t insn)
{
    rv_trace_push(&cpu->trace, RV_TR_ILLEGAL, cpu->pc, insn, 0, NULL);
    rv_trap(cpu, RV_CAUSE_ILLEGAL_INSN, insn);
}

/****************************************************************
 * Decoded-instruction cache
 *
 * A direct-mapped table keyed by guest PC. Each slot holds the expanded
 * 32-bit encoding, the instruction length and a flag for the Zcmp forms that
 * are run without going through the main dispatch. The index folds a high
 * slice of the PC into the low one so that code lying in two far-apart
 * regions (the image text and the embedded runtime) does not collide. A slot
 * whose tag does not match is simply refilled: the cache is a hint, so a miss
 * or an eviction only costs the fetch-and-expand it was meant to save.
 ****************************************************************/

typedef struct rv_dec {
    uint32_t pc;            /* tag; RV_DEC_NONE marks an empty slot */
    uint32_t insn;          /* expanded form (raw 16-bit for a Zcmp entry) */
    uint16_t len;           /* 2 or 4: how far the PC advances */
    uint16_t zcmp;          /* 1 for a Zcmp form dispatched to exec_zcmp */
} rv_dec;

#define RV_DEC_BITS 16
#define RV_DEC_SIZE (1u << RV_DEC_BITS)
#define RV_DEC_NONE 0xffffffffu     /* odd, so never a valid 2-aligned PC */

static inline uint32_t
rv_dec_index(const rv_cpu *cpu, uint32_t pc)
{
    return ((pc >> 1) ^ (pc >> 17)) & cpu->dec_mask;
}

/** Run up to `budget` instructions.
 *
 * The loop stays here across instructions rather than returning after each,
 * dispatching on the major opcode with a switch the compiler lowers to a jump
 * table. cpu->pc names the instruction in flight and `next` the one after.
 *
 * It stops the moment the machine halts (an exit, or a bus fault the host
 * turned into a halt), a trap is taken, the hart parks on wfi, or the budget
 * is spent, and returns the reason so the host can act on a faulting or
 * yielding task instead of spinning out the batch. *retired, when non-NULL,
 * receives the number of instructions it accounted for. */
enum rv_run_reason
rv_run(rv_cpu *cpu, int budget, int *retired)
{
    uint32_t rd, rs1, rs2, f3, f7, a, b, addr, val, csr, old;
    uint32_t insn, next, lo, pc;
    int32_t sa, sb;
    int rm;
    int count = 0;
    rv_dec *d;

step:
    if (count >= budget || cpu->halted)
        goto out;

    cpu->in_trap = 0;

    /* An interrupt is taken between instructions; nothing retires on it. */
    if (RV_UNLIKELY((cpu->mip & cpu->mie) != 0)) {
        uint32_t irq = rv_irq_pending(cpu);

        if (irq) {
            rv_trap(cpu, irq, 0);
            count++;
            goto out;
        }
    }

    pc = cpu->pc;
    if (RV_UNLIKELY(pc & 1)) {
        rv_trap(cpu, RV_CAUSE_INSN_MISALIGNED, pc);
        count++;
        goto out;
    }

    /* Fast path: a predecoded entry for this PC (guest code never changes). */
    d = cpu->dec ? &cpu->dec[rv_dec_index(cpu, pc)] : NULL;
    if (d && d->pc == pc) {
        next = pc + d->len;
        insn = d->insn;
        if (d->zcmp)
            goto do_zcmp;
    } else {
        if (RV_UNLIKELY(cpu->probe && cpu->probe(cpu->bus_ctx, pc, 2, 0))) {
            rv_trace_push(&cpu->trace, RV_TR_FETCH_FAULT, pc, 0, pc, NULL);
            rv_trap(cpu, RV_CAUSE_INSN_ACCESS_FAULT, pc);
            count++;
            goto out;
        }
        lo = cpu->read16(cpu->bus_ctx, pc) & 0xffff;
        if ((lo & 3) != 3) {
            next = pc + 2;
            ICOV_NOTE(lo, 2);
            if (cpu->zcmp && is_zcmp((uint16_t)lo)) {
                insn = lo;
                if (d) { d->insn = lo; d->len = 2; d->zcmp = 1; d->pc = pc; }
                goto do_zcmp;
            }
            insn = rv_expand_c((uint16_t)lo);
            if (insn == 0 && cpu->zcb)
                insn = rv_expand_zcb((uint16_t)lo);
            if (RV_UNLIKELY(insn == 0)) {
                illegal(cpu, lo);
                count++;
                goto out;
            }
            if (d) { d->insn = insn; d->len = 2; d->zcmp = 0; d->pc = pc; }
        } else {
            if (RV_UNLIKELY(cpu->probe && cpu->probe(cpu->bus_ctx, pc + 2, 2, 0))) {
                rv_trace_push(&cpu->trace, RV_TR_FETCH_FAULT, pc, 0, pc + 2,
                              NULL);
                rv_trap(cpu, RV_CAUSE_INSN_ACCESS_FAULT, pc + 2);
                count++;
                goto out;
            }
            insn = lo | ((cpu->read16(cpu->bus_ctx, pc + 2) & 0xffff) << 16);
            next = pc + 4;
            ICOV_NOTE(insn, 4);
            if (d) { d->insn = insn; d->len = 4; d->zcmp = 0; d->pc = pc; }
        }
    }

    rd = RD(insn); rs1 = RS1(insn); rs2 = RS2(insn);
    f3 = FUNCT3(insn); f7 = FUNCT7(insn);
    a = cpu->x[rs1]; b = cpu->x[rs2];
    sa = (int32_t)a; sb = (int32_t)b;

    switch (OPCODE(insn)) {
    case OP_LUI:
        cpu->x[rd] = (uint32_t)imm_u(insn);
        break;

    case OP_AUIPC:
        cpu->x[rd] = cpu->pc + (uint32_t)imm_u(insn);
        break;

    case OP_JAL:
        val = cpu->pc + (uint32_t)imm_j(insn);
        cpu->x[rd] = next;
        next = val;
        break;

    case OP_JALR:
        if (f3 != 0) {
            illegal(cpu, insn);
            goto retire;
        }
        val = (a + (uint32_t)imm_i(insn)) & ~1u;
        cpu->x[rd] = next;
        next = val;
        break;

    case OP_BRANCH:
        switch (f3) {
        case 0: val = a == b; break;                        /* beq */
        case 1: val = a != b; break;                        /* bne */
        case 4: val = sa < sb; break;                       /* blt */
        case 5: val = sa >= sb; break;                      /* bge */
        case 6: val = a < b; break;                         /* bltu */
        case 7: val = a >= b; break;                        /* bgeu */
        default: illegal(cpu, insn); goto retire;
        }
        if (val)
            next = cpu->pc + (uint32_t)imm_b(insn);
        break;

    case OP_LOAD:
        addr = a + (uint32_t)imm_i(insn);
        switch (f3) {
        case 0: /* lb */
            if (mem_read(cpu, addr, 1, &val)) goto retire;
            cpu->x[rd] = (uint32_t)(int32_t)(int8_t)val;
            break;
        case 1: /* lh */
            if (mem_read(cpu, addr, 2, &val)) goto retire;
            cpu->x[rd] = (uint32_t)(int32_t)(int16_t)val;
            break;
        case 2: /* lw */
            if (mem_read(cpu, addr, 4, &val)) goto retire;
            cpu->x[rd] = val;
            break;
        case 4: /* lbu */
            if (mem_read(cpu, addr, 1, &val)) goto retire;
            cpu->x[rd] = val & 0xff;
            break;
        case 5: /* lhu */
            if (mem_read(cpu, addr, 2, &val)) goto retire;
            cpu->x[rd] = val & 0xffff;
            break;
        default:
            illegal(cpu, insn);
            goto retire;
        }
        break;

    case OP_STORE:
        addr = a + (uint32_t)imm_s(insn);
        switch (f3) {
        case 0: mem_write(cpu, addr, 1, b); break;
        case 1: mem_write(cpu, addr, 2, b); break;
        case 2: mem_write(cpu, addr, 4, b); break;
        default: illegal(cpu, insn); goto retire;
        }
        break;

    case OP_IMM: {
        int32_t imm = imm_i(insn);
        uint32_t shamt = (uint32_t)imm & 0x1f;

        switch (f3) {
        case 0: cpu->x[rd] = a + (uint32_t)imm; break;      /* addi */
        case 2: cpu->x[rd] = sa < imm; break;               /* slti */
        case 3: cpu->x[rd] = a < (uint32_t)imm; break;      /* sltiu */
        case 4: cpu->x[rd] = a ^ (uint32_t)imm; break;      /* xori */
        case 6: cpu->x[rd] = a | (uint32_t)imm; break;      /* ori */
        case 7: cpu->x[rd] = a & (uint32_t)imm; break;      /* andi */
        case 1:
            if (f7 != 0) goto zb_imm;
            cpu->x[rd] = a << shamt;                        /* slli */
            break;
        case 5:
            if (f7 == 0)
                cpu->x[rd] = a >> shamt;                    /* srli */
            else if (f7 == 0x20)
                cpu->x[rd] = (uint32_t)(sa >> shamt);       /* srai */
            else goto zb_imm;
            break;
        }
        break;
    }

    case OP_REG:
        if (f7 == 0x01) {
            /* M extension */
            switch (f3) {
            case 0: cpu->x[rd] = a * b; break;              /* mul */
            case 1: cpu->x[rd] = (uint32_t)(((int64_t)sa * (int64_t)sb) >> 32);
                    break;                                  /* mulh */
            case 2: cpu->x[rd] = (uint32_t)(((int64_t)sa * (int64_t)(uint64_t)b)
                                            >> 32);
                    break;                                  /* mulhsu */
            case 3: cpu->x[rd] = (uint32_t)(((uint64_t)a * (uint64_t)b) >> 32);
                    break;                                  /* mulhu */
            case 4:                                         /* div */
                if (b == 0)
                    cpu->x[rd] = 0xffffffffu;
                else if (a == 0x80000000u && b == 0xffffffffu)
                    cpu->x[rd] = 0x80000000u;
                else
                    cpu->x[rd] = (uint32_t)(sa / sb);
                break;
            case 5:                                         /* divu */
                cpu->x[rd] = b == 0 ? 0xffffffffu : a / b;
                break;
            case 6:                                         /* rem */
                if (b == 0)
                    cpu->x[rd] = a;
                else if (a == 0x80000000u && b == 0xffffffffu)
                    cpu->x[rd] = 0;
                else
                    cpu->x[rd] = (uint32_t)(sa % sb);
                break;
            default:                                        /* remu */
                cpu->x[rd] = b == 0 ? a : a % b;
                break;
            }
            break;
        }
        if (f7 != 0 && f7 != 0x20)
            goto zb_reg;
        switch (f3) {
        case 0:
            cpu->x[rd] = f7 == 0x20 ? a - b : a + b;        /* add / sub */
            break;
        case 1:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = a << (b & 0x1f);                   /* sll */
            break;
        case 2:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = sa < sb;                           /* slt */
            break;
        case 3:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = a < b;                             /* sltu */
            break;
        case 4:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = a ^ b;                             /* xor */
            break;
        case 5:
            if (f7 == 0)
                cpu->x[rd] = a >> (b & 0x1f);               /* srl */
            else
                cpu->x[rd] = (uint32_t)(sa >> (b & 0x1f));  /* sra */
            break;
        case 6:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = a | b;                             /* or */
            break;
        default:
            if (f7 != 0) goto zb_reg;
            cpu->x[rd] = a & b;                             /* and */
            break;
        }
        break;

    case OP_AMO: {
        /* Atomics on a single hart with no interrupts. Nothing can
         * interleave with a read-modify-write here, so each of these is
         * just a load, an operation and a store. The reservation that
         * lr.w and sc.w carry is still tracked, because a store
         * conditional is architecturally allowed to fail and software is
         * written to retry. */
        uint32_t funct5 = (insn >> 27) & 0x1f;
        uint32_t addr = a, val, old;

        if (!cpu->atomics || f3 != 2) {     /* RV32 has only the word forms */
            illegal(cpu, insn);
            goto retire;
        }

        /* An atomic must be naturally aligned whatever the setting for
         * ordinary misaligned access: the guarantee cannot be offered on
         * an operand split across two words. */
        if (addr & 3) {
            uint32_t cause = funct5 == 0x02 ? RV_CAUSE_LOAD_MISALIGNED
                                            : RV_CAUSE_STORE_MISALIGNED;

            rv_trace_push(&cpu->trace,
                          funct5 == 0x02 ? RV_TR_LOAD_MISALIGN
                                         : RV_TR_STORE_MISALIGN,
                          cpu->pc, insn, addr, "unaligned atomic");
            rv_trap(cpu, cause, addr);
            goto retire;
        }

        if (funct5 == 0x02) {               /* lr.w */
            if (rs2 != 0) {
                illegal(cpu, insn);
                goto retire;
            }
            if (mem_read(cpu, addr, 4, &old))
                goto retire;
            cpu->res_addr = addr;
            cpu->res_valid = 1;
            cpu->x[rd] = old;
            break;
        }

        if (funct5 == 0x03) {               /* sc.w */
            if (cpu->res_valid && cpu->res_addr == addr) {
                if (mem_write(cpu, addr, 4, b))
                    goto retire;
                cpu->x[rd] = 0;             /* zero means the store won */
            } else {
                cpu->x[rd] = 1;
            }
            cpu->res_valid = 0;
            break;
        }

        if (mem_read(cpu, addr, 4, &old))
            goto retire;
        switch (funct5) {
        case 0x00: val = old + b; break;                        /* amoadd */
        case 0x01: val = b; break;                              /* amoswap */
        case 0x04: val = old ^ b; break;                        /* amoxor */
        case 0x08: val = old | b; break;                        /* amoor */
        case 0x0c: val = old & b; break;                        /* amoand */
        case 0x10: val = (int32_t)old < (int32_t)b ? old : b; break;
        case 0x14: val = (int32_t)old > (int32_t)b ? old : b; break;
        case 0x18: val = old < b ? old : b; break;              /* amominu */
        case 0x1c: val = old > b ? old : b; break;              /* amomaxu */
        default:
            illegal(cpu, insn);
            goto retire;
        }
        if (mem_write(cpu, addr, 4, val))
            goto retire;
        cpu->x[rd] = old;                   /* the value before the update */
        break;
    }

    case OP_MISC_MEM:
        /* fence (f3=0) is a data barrier: nothing to do on a single-hart
         * interpreter. fence.i (f3=1) makes prior stores visible to
         * instruction fetch, so it must drop the decoded-instruction cache,
         * which would otherwise serve a stale decode for a page the guest
         * just rewrote (self-modifying code, a guest-side JIT). */
        if (f3 == 1) {
            if (cpu->dec) {
                uint32_t k;
                for (k = 0; k <= cpu->dec_mask; k++)
                    cpu->dec[k].pc = RV_DEC_NONE;
            }
        } else if (f3 != 0) {
            illegal(cpu, insn);
        }
        break;

    case OP_LOAD_FP:
        if (f3 != 2) {
            illegal(cpu, insn);
            goto retire;
        }
        addr = a + (uint32_t)imm_i(insn);
        if (mem_read(cpu, addr, 4, &val))
            goto retire;
        cpu->f[rd] = val;
        break;

    case OP_STORE_FP:
        if (f3 != 2) {
            illegal(cpu, insn);
            goto retire;
        }
        addr = a + (uint32_t)imm_s(insn);
        mem_write(cpu, addr, 4, cpu->f[rs2]);
        break;

    case OP_MADD:
    case OP_MSUB:
    case OP_NMSUB:
    case OP_NMADD: {
        uint32_t fa = cpu->f[rs1], fb = cpu->f[rs2], fc = cpu->f[RS3(insn)];

        if (((insn >> 25) & 3) != 0) {  /* fmt must be S */
            illegal(cpu, insn);
            goto retire;
        }
        rm = resolve_rm(cpu, f3);
        if (rm < 0) {
            illegal(cpu, insn);
            goto retire;
        }
        switch (OPCODE(insn)) {
        case OP_MADD:
            break;                              /* a * b + c */
        case OP_MSUB:
            fc ^= 0x80000000u;                  /* a * b - c */
            break;
        case OP_NMSUB:
            fa ^= 0x80000000u;                  /* -(a * b) + c */
            break;
        default:
            fa ^= 0x80000000u;                  /* -(a * b) - c */
            fc ^= 0x80000000u;
            break;
        }
        cpu->f[rd] = fp_fma(cpu, fa, fb, fc, rm);
        break;
    }

    case OP_FP: {
        uint32_t fa = cpu->f[rs1], fb = cpu->f[rs2];

        if ((f7 & 3) != 0) {            /* fmt must be S */
            illegal(cpu, insn);
            goto retire;
        }
        switch (f7 >> 2) {
        case 0x00:  /* fadd.s */
        case 0x01:  /* fsub.s */
        case 0x02:  /* fmul.s */
        case 0x03:  /* fdiv.s */
            rm = resolve_rm(cpu, f3);
            if (rm < 0) { illegal(cpu, insn); goto retire; }
            switch (f7 >> 2) {
            case 0x00: cpu->f[rd] = fp_add(cpu, fa, fb, rm); break;
            case 0x01: cpu->f[rd] = fp_add(cpu, fa, fb ^ 0x80000000u, rm);
                       break;
            case 0x02: cpu->f[rd] = fp_mul(cpu, fa, fb, rm); break;
            default:   cpu->f[rd] = fp_div(cpu, fa, fb, rm); break;
            }
            break;
        case 0x0b:  /* fsqrt.s */
            if (rs2 != 0) { illegal(cpu, insn); goto retire; }
            rm = resolve_rm(cpu, f3);
            if (rm < 0) { illegal(cpu, insn); goto retire; }
            cpu->f[rd] = fp_sqrt(cpu, fa, rm);
            break;
        case 0x04:  /* fsgnj.s / fsgnjn.s / fsgnjx.s */
            switch (f3) {
            case 0: cpu->f[rd] = (fa & 0x7fffffffu) | (fb & 0x80000000u);
                    break;
            case 1: cpu->f[rd] = (fa & 0x7fffffffu) |
                                 (~fb & 0x80000000u); break;
            case 2: cpu->f[rd] = fa ^ (fb & 0x80000000u); break;
            default: illegal(cpu, insn); goto retire;
            }
            break;
        case 0x05:  /* fmin.s / fmax.s */
            if (f3 > 1) { illegal(cpu, insn); goto retire; }
            cpu->f[rd] = fp_minmax(cpu, fa, fb, (int)f3);
            break;
        case 0x14:  /* feq.s / flt.s / fle.s */
            if (f3 > 2) { illegal(cpu, insn); goto retire; }
            if (f3 == 2) {                              /* feq.s */
                if (f32_is_snan(fa) || f32_is_snan(fb))
                    fflags_set(cpu, RV_FFLAG_NV);
                cpu->x[rd] = (!f32_is_nan(fa) && !f32_is_nan(fb) &&
                              f32_val(fa) == f32_val(fb));
            } else {
                if (f32_is_nan(fa) || f32_is_nan(fb)) {
                    fflags_set(cpu, RV_FFLAG_NV);
                    cpu->x[rd] = 0;
                } else if (f3 == 1) {                   /* flt.s */
                    cpu->x[rd] = f32_val(fa) < f32_val(fb);
                } else {                                /* fle.s */
                    cpu->x[rd] = f32_val(fa) <= f32_val(fb);
                }
            }
            break;
        case 0x18:  /* fcvt.w.s / fcvt.wu.s */
            if (rs2 > 1) { illegal(cpu, insn); goto retire; }
            rm = resolve_rm(cpu, f3);
            if (rm < 0) { illegal(cpu, insn); goto retire; }
            cpu->x[rd] = fp_to_int(cpu, fa, (int)rs2, rm);
            break;
        case 0x1a:  /* fcvt.s.w / fcvt.s.wu */
            if (rs2 > 1) { illegal(cpu, insn); goto retire; }
            rm = resolve_rm(cpu, f3);
            if (rm < 0) { illegal(cpu, insn); goto retire; }
            if (rs2 == 0)
                cpu->f[rd] = f32_round(cpu, (double)(int32_t)a, 0.0, rm,
                                       (int32_t)a < 0);
            else
                cpu->f[rd] = f32_round(cpu, (double)a, 0.0, rm, 0);
            break;
        case 0x1c:  /* fmv.x.w / fclass.s */
            if (rs2 != 0) { illegal(cpu, insn); goto retire; }
            if (f3 == 0)
                cpu->x[rd] = fa;
            else if (f3 == 1)
                cpu->x[rd] = fp_class(fa);
            else { illegal(cpu, insn); goto retire; }
            break;
        case 0x1e:  /* fmv.w.x */
            if (rs2 != 0 || f3 != 0) { illegal(cpu, insn); goto retire; }
            cpu->f[rd] = a;
            break;
        default:
            illegal(cpu, insn);
            goto retire;
        }
        break;
    }

    case OP_SYSTEM:
        if (f3 == 0) {
            if (insn == 0x00000073) {           /* ecall */
                rv_trace_push(&cpu->trace, RV_TR_ECALL, cpu->pc, insn,
                              cpu->x[17], NULL);
                if (cpu->ecall && cpu->ecall(cpu, cpu->ecall_ctx) == 0)
                    break;
                rv_trap(cpu, RV_CAUSE_ECALL_M, 0);
                goto retire;
            }
            if (insn == 0x00100073) {           /* ebreak */
                rv_trace_push(&cpu->trace, RV_TR_EBREAK, cpu->pc, insn, 0,
                              NULL);
                /* Writing mtval on a breakpoint is optional. Leaving it
                 * zero matches what the common implementations do, and
                 * trap handlers that recover the instruction length read
                 * it from mepc rather than from mtval. */
                rv_trap(cpu, RV_CAUSE_BREAKPOINT, 0);
                goto retire;
            }
            if (insn == 0x30200073) {           /* mret */
                cpu->mstatus |= RV_MSTATUS_MIE;
                if (!(cpu->mstatus & RV_MSTATUS_MPIE))
                    cpu->mstatus &= ~RV_MSTATUS_MIE;
                cpu->mstatus |= RV_MSTATUS_MPIE;
                next = cpu->mepc;
                goto retire;
            }
            if (insn == 0x10500073) {           /* wfi */
                /* Legal as a nop, and that is what it is here: the
                 * interpreter has no idle state to enter, so the guest
                 * runs on and takes the interrupt when it arrives. The
                 * flag is for a host that would rather jump its own
                 * clock forward than step the wait out. */
                cpu->waiting = 1;
                break;
            }
            illegal(cpu, insn);
            goto retire;
        }
        /* Zicsr */
        csr = insn >> 20;
        val = (f3 & 4) ? rs1 : a;               /* immediate or register form */
        if (f3 == 4) {
            illegal(cpu, insn);
            goto retire;
        }
        /* A read is skipped only for a write-only csrrw with rd == x0 */
        if ((f3 & 3) == 1 && rd == 0) {
            old = 0;
        } else if (csr_read(cpu, csr, &old)) {
            illegal(cpu, insn);
            goto retire;
        }
        /* Set and clear forms with a zero source field perform no write,
         * so they never raise an exception on a read-only csr */
        if ((f3 & 3) != 1 && rs1 == 0) {
            cpu->x[rd] = old;
            break;
        }
        switch (f3 & 3) {
        case 1: break;                                  /* csrrw */
        case 2: val = old | val; break;                 /* csrrs */
        default: val = old & ~val; break;               /* csrrc */
        }
        if (csr_write(cpu, csr, val)) {
            illegal(cpu, insn);
            goto retire;
        }
        cpu->x[rd] = old;
        rv_trace_push(&cpu->trace, RV_TR_CSR, cpu->pc, insn, csr, NULL);
        break;

    default:
        illegal(cpu, insn);
        break;
    }

retire:
    cpu->x[0] = 0;
    if (!cpu->in_trap)
        cpu->pc = next;
    cpu->cycles++;
    cpu->mcycle++;
    cpu->minstret++;
    count++;
    if (RV_UNLIKELY(cpu->in_trap || cpu->halted || cpu->waiting))
        goto out;
    goto step;

    /* A Zcmp form does too much to be rewritten as one 32-bit instruction, so
     * it runs here and joins the others at retire. */
do_zcmp:
    if (exec_zcmp(cpu, (uint16_t)insn, &next))
        illegal(cpu, insn);
    goto retire;

    /* Zba, Zbb and Zbs are reached only once the base decoder has rejected an
     * encoding, which is why they sit at the end rather than in front of every
     * add and shift: testing for them first costs about 7% of throughput on
     * code that uses none of them. */
zb_reg:
    if (cpu->bitmanip && bitmanip_reg(insn, f3, f7, a, b, &val)) {
        cpu->x[rd] = val;
        goto retire;
    }
    illegal(cpu, insn);
    goto retire;

zb_imm:
    if (cpu->bitmanip && bitmanip_imm(insn, f3, f7, a, &val)) {
        cpu->x[rd] = val;
        goto retire;
    }
    illegal(cpu, insn);
    goto retire;

out:
    if (retired)
        *retired = count;
    /* halt outranks a trap: a double fault sets both, and the host wants to
     * see the halt. A parked hart (wfi) is still runnable, so it reports as a
     * yield, not a stop. Budget exhaustion is the fall-through. */
    if (cpu->halted)
        return RV_RUN_HALT;
    if (cpu->in_trap)
        return RV_RUN_TRAP;
    if (cpu->waiting)
        return RV_RUN_YIELD;
    return RV_RUN_BUDGET;
}

/****************************************************************
 * Public API
 ****************************************************************/

void
rv_init(rv_cpu *cpu,
        rv_read_fn r8, rv_read_fn r16, rv_read_fn r32,
        rv_write_fn w8, rv_write_fn w16, rv_write_fn w32,
        void *bus_ctx)
{
    memset(cpu, 0, sizeof(*cpu));
    cpu->read8 = r8;
    cpu->read16 = r16;
    cpu->read32 = r32;
    cpu->write8 = w8;
    cpu->write16 = w16;
    cpu->write32 = w32;
    cpu->bus_ctx = bus_ctx;
    cpu->zcmp = 1;          /* part of the machine, not of its reset state */
    cpu->atomics = 1;
    cpu->bitmanip = 1;
    cpu->zcb = 1;
    rv_trace_init(&cpu->trace);
}

void
rv_reset(rv_cpu *cpu, uint32_t entry)
{
    memset(cpu->x, 0, sizeof(cpu->x));
    memset(cpu->f, 0, sizeof(cpu->f));
    cpu->pc = entry;
    cpu->fcsr = 0;
    cpu->mstatus = RV_MSTATUS_MPP | RV_MSTATUS_FS;
    cpu->mtvec = 0;
    cpu->mepc = 0;
    cpu->mcause = 0;
    cpu->mtval = 0;
    cpu->mscratch = 0;
    cpu->mie = 0;
    cpu->mip = 0;
    cpu->mcycle = 0;
    cpu->minstret = 0;
    cpu->halted = 0;
    cpu->in_trap = 0;
    cpu->waiting = 0;
    cpu->cycles = 0;
    cpu->res_valid = 0;
    cpu->res_addr = 0;
    rv_trace_clear(&cpu->trace);
}

void
rv_set_ecall(rv_cpu *cpu, rv_ecall_fn fn, void *ctx)
{
    cpu->ecall = fn;
    cpu->ecall_ctx = ctx;
}

void
rv_set_probe(rv_cpu *cpu, rv_probe_fn fn)
{
    cpu->probe = fn;
}

void
rv_halt(rv_cpu *cpu)
{
    cpu->halted = 1;
}

/* The decoded-instruction cache (rv_dec, rv_dec_index) is defined above, next
 * to rv_run, the loop that reads it. These install and release it. */
void
rv_dec_enable(rv_cpu *cpu)
{
#ifdef RV_ICOV
    /* Coverage counts every dynamic execution, which the cache's fast path
     * would skip, so leave it off for that build. */
    (void)cpu;
#else
    uint32_t i;

    if (cpu->dec)
        return;
    cpu->dec = malloc(RV_DEC_SIZE * sizeof(rv_dec));
    if (!cpu->dec) {            /* no cache: the slow path still runs */
        cpu->dec_mask = 0;
        return;
    }
    for (i = 0; i < RV_DEC_SIZE; i++)
        cpu->dec[i].pc = RV_DEC_NONE;
    cpu->dec_mask = RV_DEC_SIZE - 1;
#endif
}

void
rv_dec_free(rv_cpu *cpu)
{
    free(cpu->dec);
    cpu->dec = NULL;
    cpu->dec_mask = 0;
}

int
rv_step(rv_cpu *cpu)
{
    /* One instruction, for a host that drives the machine itself. The
     * threaded rv_run is the loop the scheduler uses. */
    rv_run(cpu, 1, NULL);
    return cpu->halted ? -1 : 0;
}

uint32_t
rv_get_x(rv_cpu *cpu, int n)
{
    return n == 0 ? 0 : cpu->x[n & 31];
}

void
rv_set_x(rv_cpu *cpu, int n, uint32_t val)
{
    if (n != 0)
        cpu->x[n & 31] = val;
}

uint32_t
rv_get_pc(rv_cpu *cpu)
{
    return cpu->pc;
}

void
rv_set_pc(rv_cpu *cpu, uint32_t val)
{
    cpu->pc = val;
}

uint32_t
rv_get_f(rv_cpu *cpu, int n)
{
    return cpu->f[n & 31];
}

void
rv_set_f(rv_cpu *cpu, int n, uint32_t bits)
{
    cpu->f[n & 31] = bits;
}
