/* rv_select.c : the shared RISC-V RV32 (ILP32 psABI) instruction selector (see
   rv_select.h).

   Lifted from backend/rv_emit.c: the register model, frame geometry, ILP32 psABI
   parameter classification and call marshalling, prologue/epilogue, and the
   per-opcode switch, all re-expressed against the backend/rv_mc.h sink.  The AOT
   (text) and JIT (byte) paths supply the sink; this selection logic is shared.
   The RISC-V parallel of backend/x86_select.c and backend/arm64_select.c.

   The convention is the platform ILP32 psABI (a0-a7 in order, a two-word
   argument in the next two registers low word first with no even alignment,
   splitting low-word-in-register when only one is left, a double crossing
   through memory since RV32 cannot move an f-register's halves to integer
   registers, results in a0/a1).  It is the only convention the backend emits;
   the toolkit's old stack convention was retired. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ir.h"
#include "rv_mc.h"
#include "rv_select.h"

#define NSAVED 11

/*
 * Allocator index -> hardware register number.  Indices 0-1 are the scratch
 * slots (t0, t1); indices 2-12 are the allocatable callee-saved integer
 * registers s1..s11, matching FIRST_REG=2, NUM_REGS=11 in regalloc_rv.c.
 */
static const int reg[] = {
    5, 6,                       /* t0, t1 (scratch) */
    9, 18, 19, 20, 21, 22,      /* s1, s2, s3, s4, s5, s6 */
    23, 24, 25, 26, 27,         /* s7, s8, s9, s10, s11 */
};

/*
 * Float allocator index -> hardware register number.  Indices 0-1 are scratch
 * (ft0, ft1); indices 2-13 are the allocatable callee-saved fs0..fs11, matching
 * FP_FIRST_REG=2, FP_NUM_REGS=12 in regalloc_rv.c.  A RISC-V float register has
 * one name for both widths; single vs double is the instruction suffix (.s / .d).
 */
static const int freg[] = {
    0, 1,                       /* ft0, ft1 (scratch) */
    8, 9,                       /* fs0, fs1 */
    18, 19, 20, 21, 22, 23,     /* fs2..fs7 */
    24, 25, 26, 27,             /* fs8..fs11 */
};

/* allocatable float index range in freg[] (fs0..fs11) */
#define FP_ALLOC_FIRST 2
#define FP_ALLOC_LAST  13

/* Named hardware registers the selector and glue use directly. */
#define RA   1
#define SP   2
#define FP   8      /* s0, the frame pointer */
#define T0   5
#define T1   6
#define T2   7
#define T6   31     /* the large-offset / big-immediate scratch base */
#define A0   10
#define A1   11

static const int argreg[] = { 10, 11, 12, 13, 14, 15, 16, 17 };
#define NARGREG 8

/* Per-temp width classification for the function being emitted: g_is_i64[t] is 1
   when temp t is an i64 (register pair), else it is an i32 (single register) or a
   float.  The temp readers consult this so a width-crossing access, where the IR
   reads a temp at a different width than it was defined (the coroutine seed path
   does: it stores an i32 into an 8-byte slot with ST64 and loads it back with
   LD64 then passes it with a plain i32 ARG), picks the right register.  On x86 and
   AArch64 this never arises because i32 and i64 share a register.  Set over each
   function in rv_select_func and cleared after. */
static const int *g_is_i64;
static int t_is_i64(int t) { return g_is_i64 && t >= 0 && g_is_i64[t]; }

/* Per-temp float storage format (1 = f32/single, 0 = f64).  The C front end keeps
   `float` as f32 in registers while Kobold keeps every float as f64, so a single
   value crossing a call is converted only when the temp's format differs from the
   f32 wire width.  Set per function in rv_select_func (see ir_classify_f32). */
static const unsigned char *g_f32;
static int src_is_f32(int t) { return g_f32 && t >= 0 && g_f32[t]; }

/* Divide-by-zero trap policy for this function (RV_TRAP_*).  Set per function in
   rv_select_func.  RV_TRAP_GUARDED makes a 32-bit div/mod guard its divisor and
   call kp_trap_div_zero, since RV32 divide does not fault by hardware. */
static int g_trap_policy;

/****************************************************************
 * The RISC-V ILP32 calling convention (pure computation, ported verbatim)
 ****************************************************************/

/* Where one argument or parameter lives. */
struct rv_ploc {
    int words;      /* 1 or 2 (a larger aggregate rides the stack whole) */
    int ireg;       /* first a-register index, -1 if none */
    int nreg;       /* registers used: 0, 1 (split low word), or words */
    int soff;       /* byte offset of the stack part within the block */
};

/*
 * Assign homes to a sequence of arguments given their widths in words.
 * Returns the size of the outgoing stack block.  Both the caller and the
 * callee run this over the same sequence, which is what makes the two
 * sides agree.
 *
 * first_vararg, when >= 0, is the index of the first unnamed argument of a
 * variadic call.  From there on every argument is placed on the stack
 * (registers are treated as exhausted), which is skjegg's self-consistent
 * variadic convention: unnamed arguments ride the stack so the callee's
 * va_list can walk them contiguously with no register save area.  A fixed
 * (named) argument assignment passes -1, the plain psABI placement.
 */
static int
rv_abi_assign(const int *words, int n, struct rv_ploc *loc, int first_vararg)
{
    int ix = 0, soff = 0, k;

    for (k = 0; k < n; k++) {
        int w = words[k];

        if (first_vararg >= 0 && k >= first_vararg)
            ix = NARGREG;       /* unnamed args: stack only */

        loc[k].words = w;
        loc[k].ireg = -1;
        loc[k].nreg = 0;
        loc[k].soff = 0;

        if (w == 1) {
            if (ix < NARGREG) {
                loc[k].ireg = ix++;
                loc[k].nreg = 1;
            } else {
                loc[k].soff = soff;
                soff += 4;
            }
        } else if (w == 2) {
            if (ix + 1 < NARGREG) {
                loc[k].ireg = ix;
                loc[k].nreg = 2;
                ix += 2;
            } else if (ix < NARGREG) {
                /* split: the low word takes the last register, the high
                   word opens the stack block */
                loc[k].ireg = ix;
                loc[k].nreg = 1;
                ix = NARGREG;
                loc[k].soff = soff;
                soff += 4;
            } else {
                soff = (soff + 7) & ~7;
                loc[k].soff = soff;
                soff += 8;
            }
        } else {
            /* an aggregate wider than two words: stack, 8-aligned */
            ix = NARGREG;
            soff = (soff + 7) & ~7;
            loc[k].soff = soff;
            soff += w * 4;
        }
    }
    return soff;
}

/* Width in words of parameter `slot`, from its slot size. */
static int
rv_param_words(struct ir_func *fn, int slot)
{
    int sz = (fn->slot_size[slot] + 3) & ~3;

    /* A single-precision float is one ABI word even though its local slot is
       widened to 8 bytes; the caller passes it in one integer register, so
       the callee must count it the same way (see param_fw). */
    if (fn->param_fw && fn->param_fw[slot])
        return 1;
    return sz / 4 < 1 ? 1 : sz / 4;
}

/*
 * Home of parameter `slot` on the callee side, plus the byte offset of its
 * home slot in the frame when it arrives in registers.
 */
static void
rv_param(struct ir_func *fn, int slot, struct rv_ploc *out, int *home)
{
    struct rv_ploc loc[64];
    int words[64] = { 0 };
    int n = fn->nparams;
    int i, h = 0;

    if (n > 64)
        n = 64;
    for (i = 0; i < n; i++)
        words[i] = rv_param_words(fn, i);
    rv_abi_assign(words, n, loc, -1);

    for (i = 0; i < n; i++) {
        int sz = words[i] * 4;
        if (loc[i].nreg == 0)
            continue;
        if (sz % 8 == 0)
            h = (h + 7) & ~7;
        h += sz;
        if (i == slot) {
            *out = loc[i];
            *home = -h;
            return;
        }
    }
    *out = loc[slot < n ? slot : 0];
    *home = 0;
}

/* Bytes reserved below s0 for register-parameter homes. */
static int
param_home(struct ir_func *fn)
{
    struct rv_ploc p;
    int i, h = 0, home;

    for (i = 0; i < fn->nparams; i++) {
        rv_param(fn, i, &p, &home);
        if (p.nreg == 0)
            continue;
        if (-home > h)
            h = -home;
    }
    return (h + 7) & ~7;
}

static int
frame_reserve(struct ir_func *fn)
{
    return param_home(fn);
}

/****************************************************************
 * Frame layout helpers (pure computation, ported verbatim)
 ****************************************************************/

static int
slot_bytes(struct ir_func *fn, int i)
{
    return (fn->slot_size[i] + 3) & ~3;
}

static int
locals_size(struct ir_func *fn)
{
    int i, x;

    x = 0;
    for (i = fn->nparams; i < fn->nslots; i++) {
        int sz = slot_bytes(fn, i);
        if (sz % 8 == 0)
            x = (x + 7) & ~7;
        x += sz;
    }
    return (x + 7) & ~7;
}

static int
slot_offset(struct ir_func *fn, int slot)
{
    int i, off;

    if (slot < fn->nparams) {
        struct rv_ploc p;
        int home;

        rv_param(fn, slot, &p, &home);
        if (p.nreg > 0)
            return home;
        return 8 + p.soff;
    }
    off = 0;
    for (i = fn->nparams; i <= slot; i++) {
        int sz = slot_bytes(fn, i);
        if (sz % 8 == 0)
            off = (off + 7) & ~7;
        off += sz;
    }
    return -frame_reserve(fn) - off;
}

static int
frame_size(struct ir_func *fn)
{
    return frame_reserve(fn) + locals_size(fn) + fn->nfspills * 8
           + fn->nspills * 4
           + fn->ni64spills * 8;
}

static int
fspill_byte_offset(struct ir_func *fn, int temp)
{
    return -frame_reserve(fn) - locals_size(fn) - (fn->temp_spill[temp] + 8);
}

static int
spill_byte_offset(struct ir_func *fn, int temp)
{
    return -frame_reserve(fn) - locals_size(fn) - fn->nfspills * 8
           - (fn->temp_spill[temp] + 4);
}

static int
i64spill_byte_offset(struct ir_func *fn, int temp)
{
    return -frame_reserve(fn) - locals_size(fn) - fn->nfspills * 8
           - fn->nspills * 4
           - (fn->temp_spill[temp] + 8);
}

/****************************************************************
 * Float temp -> register materialisation (returns hardware register numbers)
 ****************************************************************/

static int
frs_w(struct rv_mc *m, struct ir_func *fn, int t, int scratch, int f32)
{
    int r = fn->temp_reg[t];

    if (r >= 0)
        return freg[r];
    if (f32)
        rv_mc_flw(m, freg[scratch], FP, fspill_byte_offset(fn, t));
    else
        rv_mc_fld(m, freg[scratch], FP, fspill_byte_offset(fn, t));
    return freg[scratch];
}

static int
frd_w(struct ir_func *fn, int t, int scratch)
{
    int r = fn->temp_reg[t];

    return r >= 0 ? freg[r] : freg[scratch];
}

static void
fwd_f(struct rv_mc *m, struct ir_func *fn, int t, int r, int f32)
{
    if (fn->temp_reg[t] >= 0)
        return;
    if (f32)
        rv_mc_fsw(m, r, FP, fspill_byte_offset(fn, t));
    else
        rv_mc_fsd(m, r, FP, fspill_byte_offset(fn, t));
}

/****************************************************************
 * Integer temp -> register materialisation
 ****************************************************************/

static int i64_rs_lo(struct rv_mc *m, struct ir_func *fn, int t, int scratch);

/* Read temp t as an i32 (single register), the storage an i32-classed temp uses. */
static int
rs_i32(struct rv_mc *m, struct ir_func *fn, int t, int scratch)
{
    int r = fn->temp_reg[t];

    if (r >= 0)
        return reg[r];
    rv_mc_lw(m, reg[scratch], FP, spill_byte_offset(fn, t));
    return reg[scratch];
}

/* Read temp t as an i32 value.  An i64 temp is narrowed to its low word, which is
   where an i32 consumer (a plain ARG, an i32 op) expects the value. */
static int
rs(struct rv_mc *m, struct ir_func *fn, int t, int scratch)
{
    if (t_is_i64(t))
        return i64_rs_lo(m, fn, t, scratch);
    return rs_i32(m, fn, t, scratch);
}

static int
rd(struct ir_func *fn, int t, int scratch)
{
    int r = fn->temp_reg[t];

    return r >= 0 ? reg[r] : reg[scratch];
}

static void
wd(struct rv_mc *m, struct ir_func *fn, int t, int r)
{
    if (fn->temp_reg[t] >= 0)
        return;
    rv_mc_sw(m, r, FP, spill_byte_offset(fn, t));
}

/****************************************************************
 * I64 register-pair helpers
 ****************************************************************/

static int i64_lo_idx(int pair) { return 11 - 2 * pair; }
static int i64_hi_idx(int pair) { return 12 - 2 * pair; }

static int
i64_rs_lo(struct rv_mc *m, struct ir_func *fn, int t, int scratch)
{
    int pair;
    /* An i32-classed temp read as an i64 (the coroutine seed store) supplies its
       single register as the low word. */
    if (!t_is_i64(t))
        return rs_i32(m, fn, t, scratch);
    pair = fn->temp_reg[t];
    if (pair >= 0)
        return reg[i64_lo_idx(pair)];
    rv_mc_lw(m, reg[scratch], FP, i64spill_byte_offset(fn, t));
    return reg[scratch];
}

static int
i64_rs_hi(struct rv_mc *m, struct ir_func *fn, int t, int scratch)
{
    int pair;
    /* The high word of an i32-classed temp read as an i64 is its sign extension. */
    if (!t_is_i64(t)) {
        int lo = rs_i32(m, fn, t, scratch);
        rv_mc_srai(m, reg[scratch], lo, 31);
        return reg[scratch];
    }
    pair = fn->temp_reg[t];
    if (pair >= 0)
        return reg[i64_hi_idx(pair)];
    rv_mc_lw(m, reg[scratch], FP, i64spill_byte_offset(fn, t) + 4);
    return reg[scratch];
}

static int
i64_rd_lo(struct ir_func *fn, int t, int scratch)
{
    int pair = fn->temp_reg[t];
    if (pair >= 0)
        return reg[i64_lo_idx(pair)];
    return reg[scratch];
}

static int
i64_rd_hi(struct ir_func *fn, int t, int scratch)
{
    int pair = fn->temp_reg[t];
    if (pair >= 0)
        return reg[i64_hi_idx(pair)];
    return reg[scratch];
}

static void
i64_wd_lo(struct rv_mc *m, struct ir_func *fn, int t, int r)
{
    if (fn->temp_reg[t] >= 0)
        return;
    rv_mc_sw(m, r, FP, i64spill_byte_offset(fn, t));
}

static void
i64_wd_hi(struct rv_mc *m, struct ir_func *fn, int t, int r)
{
    if (fn->temp_reg[t] >= 0)
        return;
    rv_mc_sw(m, r, FP, i64spill_byte_offset(fn, t) + 4);
}

/****************************************************************
 * Binary / unary / compare / load / store helpers
 ****************************************************************/

typedef void (*rrr_fn)(struct rv_mc *, int, int, int);
typedef void (*rr_fn)(struct rv_mc *, int, int);
typedef void (*ldst_fn)(struct rv_mc *, int, int, int);
typedef void (*frrr_fn)(struct rv_mc *, int, int, int, int);
typedef void (*frr_fn)(struct rv_mc *, int, int, int);

static void
emit_binop(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, rrr_fn op)
{
    int sa = rs(m, fn, i->a, 0);
    int sb = rs(m, fn, i->b, 1);
    int sd = rd(fn, i->dst, 0);
    op(m, sd, sa, sb);
    wd(m, fn, i->dst, sd);
}

/* 32-bit integer divide/remainder.  RV32 does not fault on a zero divisor (it
   returns -1 for div, the dividend for rem), so under RV_TRAP_GUARDED (Kobold)
   a zero divisor is tested and kp_trap_div_zero is called before the divide.
   The call sits on the divisor-is-zero path, which never returns, so it does
   not matter that it may clobber sa/sb: the divide is reached only on the
   fall-through where the divisor is nonzero and the operands are still live.
   For a signed op a second guard catches INT_MIN / -1 (and its modulo), whose
   mathematical result is unrepresentable: RV32 returns INT_MIN silently, so
   Kobold traps OVERFLOW instead.  T2 is named scratch outside the allocator's
   pool (as emit_overflow uses it), so the compares never disturb sa/sb/sd. */
static void
emit_div(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, rrr_fn op,
         int is_signed)
{
    int sa = rs(m, fn, i->a, 0);
    int sb = rs(m, fn, i->b, 1);
    int sd = rd(fn, i->dst, 0);
    if (g_trap_policy == RV_TRAP_GUARDED) {
        int ok = rv_mc_new_label(m);
        rv_mc_bnez(m, sb, ok);           /* divisor nonzero: skip the trap */
        rv_mc_call(m, "kp_trap_div_zero");
        rv_mc_label(m, ok);
        if (is_signed) {
            int ok2 = rv_mc_new_label(m);
            rv_mc_li(m, T2, -1);
            rv_mc_bne(m, sb, T2, ok2);   /* divisor != -1: cannot overflow */
            rv_mc_li(m, T2, -2147483647L - 1);   /* INT_MIN */
            rv_mc_bne(m, sa, T2, ok2);   /* dividend != INT_MIN: no overflow */
            rv_mc_call(m, "kp_trap_overflow");
            rv_mc_label(m, ok2);
        }
    }
    op(m, sd, sa, sb);
    wd(m, fn, i->dst, sd);
}

/* Overflow-checked 32-bit signed arithmetic (IR_ADDO/SUBO/MULO).  RV32 has no
   hardware overflow flag, so the result's validity is tested directly and a
   failure calls kp_trap_overflow.  For add/sub the sign bits decide it; for
   multiply the signed high half (mulh) must be the sign extension of the low
   half.  T2 and T6 are named scratch outside the allocator's register pool, so
   the source registers (sa, sb) are only ever read and the result (sd) is
   written last, which stays correct even when sd aliases sa or sb. */
static int il(struct rv_mc *m, int *lbl, int n);   /* defined below */

static void
emit_overflow(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, int *lbl)
{
    int sa = rs(m, fn, i->a, 0);
    int sb = rs(m, fn, i->b, 1);
    int sd = rd(fn, i->dst, 0);
    int flag;

    if (i->op == IR_MULO) {
        rv_mc_mulh(m, T2, sa, sb);       /* signed high 32 of the product */
        rv_mc_mul(m, sd, sa, sb);        /* low 32 = the result (sa, sb last read) */
        rv_mc_srai(m, T6, sd, 31);       /* the sign extension the high must equal */
        rv_mc_xor(m, T2, T2, T6);        /* 0 when they agree (no overflow) */
        flag = T2;
    } else if (i->op == IR_ADDO) {
        rv_mc_add(m, T2, sa, sb);        /* sum (scratch) */
        rv_mc_xor(m, T6, sa, T2);        /* a ^ sum */
        rv_mc_xor(m, T2, sb, T2);        /* b ^ sum */
        rv_mc_and(m, T6, T6, T2);        /* sign set iff the sum overflowed */
        rv_mc_srai(m, T6, T6, 31);       /* -1 on overflow, 0 otherwise */
        rv_mc_add(m, sd, sa, sb);        /* the result (sa, sb last read) */
        flag = T6;
    } else { /* IR_SUBO */
        rv_mc_sub(m, T2, sa, sb);        /* difference (scratch) */
        rv_mc_xor(m, T6, sa, sb);        /* a ^ b */
        rv_mc_xor(m, T2, sa, T2);        /* a ^ diff */
        rv_mc_and(m, T6, T6, T2);        /* sign set iff the subtraction overflowed */
        rv_mc_srai(m, T6, T6, 31);
        rv_mc_sub(m, sd, sa, sb);        /* the result (sa, sb last read) */
        flag = T6;
    }

    if (i->label >= 0) {
        /* explicit per-site trap target (a front end's cold trap
           trampoline): branch there on overflow. */
        rv_mc_bnez(m, flag, il(m, lbl, i->label));
    } else {
        /* label-less (Kobold): call the runtime overflow handler. */
        int ok = rv_mc_new_label(m);
        rv_mc_beqz(m, flag, ok);         /* no overflow: skip the trap */
        rv_mc_call(m, "kp_trap_overflow");
        rv_mc_label(m, ok);
    }
    wd(m, fn, i->dst, sd);
}

static void
emit_unop(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, rr_fn op)
{
    int sa = rs(m, fn, i->a, 0);
    int sd = rd(fn, i->dst, 0);
    op(m, sd, sa);
    wd(m, fn, i->dst, sd);
}

static void
emit_cmp(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, int op)
{
    int sa = rs(m, fn, i->a, 0);
    int sb = rs(m, fn, i->b, 1);
    int sd = rd(fn, i->dst, 0);

    switch (op) {
    case IR_CMPEQ:
        rv_mc_xor(m, sd, sa, sb);
        rv_mc_seqz(m, sd, sd);
        break;
    case IR_CMPNE:
        rv_mc_xor(m, sd, sa, sb);
        rv_mc_snez(m, sd, sd);
        break;
    case IR_CMPLTS:
        rv_mc_slt(m, sd, sa, sb);
        break;
    case IR_CMPLES:
        rv_mc_slt(m, sd, sb, sa);
        rv_mc_xori(m, sd, sd, 1);
        break;
    case IR_CMPGTS:
        rv_mc_slt(m, sd, sb, sa);
        break;
    case IR_CMPGES:
        rv_mc_slt(m, sd, sa, sb);
        rv_mc_xori(m, sd, sd, 1);
        break;
    case IR_CMPLTU:
        rv_mc_sltu(m, sd, sa, sb);
        break;
    case IR_CMPLEU:
        rv_mc_sltu(m, sd, sb, sa);
        rv_mc_xori(m, sd, sd, 1);
        break;
    case IR_CMPGTU:
        rv_mc_sltu(m, sd, sb, sa);
        break;
    case IR_CMPGEU:
        rv_mc_sltu(m, sd, sa, sb);
        rv_mc_xori(m, sd, sd, 1);
        break;
    }

    wd(m, fn, i->dst, sd);
}

static void
emit_fbinop(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, frrr_fn op)
{
    int f32 = i->imm == FWIDTH_F32;
    int sa = frs_w(m, fn, i->a, 0, f32);
    int sb = frs_w(m, fn, i->b, 1, f32);
    int sd = frd_w(fn, i->dst, 0);
    op(m, f32, sd, sa, sb);
    fwd_f(m, fn, i->dst, sd, f32);
}

static void
emit_funop(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, frr_fn op)
{
    int f32 = i->imm == FWIDTH_F32;
    int sa = frs_w(m, fn, i->a, 0, f32);
    int sd = frd_w(fn, i->dst, 0);
    op(m, f32, sd, sa);
    fwd_f(m, fn, i->dst, sd, f32);
}

static void
emit_load(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, ldst_fn op)
{
    int sa = rs(m, fn, i->a, 0);
    int sd = rd(fn, i->dst, 0);
    op(m, sd, sa, 0);
    wd(m, fn, i->dst, sd);
}

static void
emit_store(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, ldst_fn op)
{
    int sa = rs(m, fn, i->a, 0);
    int sb = rs(m, fn, i->b, 1);
    op(m, sb, sa, 0);
}

/****************************************************************
 * Call/argument bookkeeping and used-float discovery
 ****************************************************************/

#define RET_INT   0
#define RET_I64   1
#define RET_FLOAT 2
#define RET_FAIL  3     /* failable call: value in a0, error in a1 -> error slot */

#define RV_MAX_ARGS 32

static int arg_temps[RV_MAX_ARGS];
static int arg_is_i64[RV_MAX_ARGS];
static int arg_is_float[RV_MAX_ARGS];
static int arg_fw[RV_MAX_ARGS];   /* per-arg float width: 1 = F32, 0 = F64 */
static int arg_vararg[RV_MAX_ARGS]; /* 1 = unnamed arg of a variadic call */
static int narg;

static int used_fregs[12];
static int n_used_fregs;

static void
compute_used_fregs(struct ir_func *fn)
{
    struct ir_insn *i;
    int seen[14] = {0};
    int r;

    n_used_fregs = 0;
    for (i = fn->head; i; i = i->next) {
        if (ir_op_is_float_def(i->op) && i->dst >= 0 &&
            i->dst < fn->ntemps) {
            r = fn->temp_reg[i->dst];
            if (r >= FP_ALLOC_FIRST && r <= FP_ALLOC_LAST)
                seen[r] = 1;
        }
    }
    for (r = FP_ALLOC_FIRST; r <= FP_ALLOC_LAST; r++)
        if (seen[r])
            used_fregs[n_used_fregs++] = r;
}

/****************************************************************
 * Prologue / epilogue
 ****************************************************************/

static void
emit_prologue(struct rv_mc *m, struct ir_func *fn)
{
    int frame = frame_size(fn);
    int fsaved = n_used_fregs * 8;
    int base = NSAVED * 4 + fsaved + frame;
    int total = (8 + base + 15) & ~15;
    int pad = total - (8 + base);
    int k;

    rv_mc_addbig(m, SP, SP, -total);
    rv_mc_sw(m, RA, SP, total - 4);
    rv_mc_sw(m, FP, SP, total - 8);
    rv_mc_addbig(m, FP, SP, total - 8);
    for (k = 0; k < NSAVED; k++)
        rv_mc_sw(m, reg[k + 2], SP, pad + k * 4);
    for (k = 0; k < n_used_fregs; k++)
        rv_mc_fsd(m, freg[used_fregs[k]], SP, pad + NSAVED * 4 + k * 8);

    /* Spill the register parameters into their homes. */
    for (k = 0; k < fn->nparams; k++) {
        struct rv_ploc p;
        int home;

        rv_param(fn, k, &p, &home);
        if (p.nreg == 0)
            continue;
        rv_mc_sw(m, argreg[p.ireg], FP, home);
        if (p.nreg == 2)
            rv_mc_sw(m, argreg[p.ireg + 1], FP, home + 4);
        else if (p.words == 2) {
            rv_mc_lw(m, T0, FP, 8 + p.soff);
            rv_mc_sw(m, T0, FP, home + 4);
        }
    }
}

static void
emit_epilogue_no_ret(struct rv_mc *m, struct ir_func *fn)
{
    int frame = frame_size(fn);
    int fsaved = n_used_fregs * 8;
    int int_base = -(NSAVED * 4 + fsaved + frame);
    int fp_base = -(fsaved + frame);
    int k;

    for (k = 0; k < NSAVED; k++)
        rv_mc_lw(m, reg[k + 2], FP, int_base + k * 4);
    for (k = 0; k < n_used_fregs; k++)
        rv_mc_fld(m, freg[used_fregs[k]], FP, fp_base + k * 8);
    rv_mc_lw(m, RA, FP, 4);
    rv_mc_lw(m, T0, FP, 0);
    rv_mc_addi(m, SP, FP, 8);
    rv_mc_mv(m, FP, T0);
}

static void
emit_epilogue(struct rv_mc *m, struct ir_func *fn)
{
    emit_epilogue_no_ret(m, fn);
    rv_mc_ret(m);
}

/****************************************************************
 * Call marshalling
 ****************************************************************/

static void
emit_call_flush(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i,
                int indirect, int retkind)
{
    struct rv_ploc loc[RV_MAX_ARGS];
    int words[RV_MAX_ARGS] = { 0 };
    int k, push_bytes, stack_bytes, stage, need_stage, first_vararg = -1;

    for (k = 0; k < narg; k++) {
        if (arg_is_i64[k])
            words[k] = 2;
        else if (arg_is_float[k])
            words[k] = arg_fw[k] ? 1 : 2;
        else
            words[k] = 1;
        if (first_vararg < 0 && arg_vararg[k])
            first_vararg = k;
    }
    stack_bytes = rv_abi_assign(words, narg, loc, first_vararg);

    need_stage = (retkind == RET_FLOAT && i->imm != FWIDTH_F32);
    for (k = 0; k < narg; k++)
        if (arg_is_float[k] && !arg_fw[k])
            need_stage = 1;

    stage = (stack_bytes + 7) & ~7;
    push_bytes = stage + (need_stage ? 8 : 0);
    push_bytes = (push_bytes + 15) & ~15;
    if (need_stage && push_bytes < stage + 8)
        push_bytes = stage + 16;

    if (push_bytes > 0)
        rv_mc_addbig(m, SP, SP, -push_bytes);

    for (k = 0; k < narg; k++) {
        struct rv_ploc *p = &loc[k];

        if (arg_is_float[k] && !arg_fw[k]) {
            /* double: park it, then move the halves as words */
            int sa = frs_w(m, fn, arg_temps[k], 0, 0);
            rv_mc_fsd(m, sa, SP, stage);
            if (p->nreg >= 1)
                rv_mc_lw(m, argreg[p->ireg], SP, stage);
            else {
                rv_mc_lw(m, T0, SP, stage);
                rv_mc_sw(m, T0, SP, p->soff);
            }
            if (p->nreg == 2)
                rv_mc_lw(m, argreg[p->ireg + 1], SP, stage + 4);
            else {
                rv_mc_lw(m, T0, SP, stage + 4);
                rv_mc_sw(m, T0, SP, p->soff + (p->nreg == 1 ? 0 : 4));
            }
        } else if (arg_is_float[k]) {
            /* single: move the f32 bits into an integer register.  An f64-format
               temp (Kobold) narrows to f32 (ft1) first; an already-f32 temp (C)
               supplies its bits directly. */
            int sbits;
            if (src_is_f32(arg_temps[k])) {
                sbits = frs_w(m, fn, arg_temps[k], 0, 1);
            } else {
                int sa = frs_w(m, fn, arg_temps[k], 0, 0);
                rv_mc_fcvt_s_d(m, 1, sa);
                sbits = 1;
            }
            if (p->nreg == 1) {
                rv_mc_fmv_x_w(m, argreg[p->ireg], sbits);
            } else {
                rv_mc_fmv_x_w(m, T0, sbits);
                rv_mc_sw(m, T0, SP, p->soff);
            }
        } else if (arg_is_i64[k]) {
            int lo = i64_rs_lo(m, fn, arg_temps[k], 0);
            if (p->nreg >= 1)
                rv_mc_mv(m, argreg[p->ireg], lo);
            else
                rv_mc_sw(m, lo, SP, p->soff);
            {
                int hi = i64_rs_hi(m, fn, arg_temps[k], 0);
                if (p->nreg == 2)
                    rv_mc_mv(m, argreg[p->ireg + 1], hi);
                else
                    rv_mc_sw(m, hi, SP, p->soff + (p->nreg == 1 ? 0 : 4));
            }
        } else {
            int sa = rs(m, fn, arg_temps[k], 0);
            if (p->nreg == 1)
                rv_mc_mv(m, argreg[p->ireg], sa);
            else
                rv_mc_sw(m, sa, SP, p->soff);
        }
    }

    if (indirect) {
        /* the target is read before the call, and a0-a7 are already loaded, so
           it goes through a scratch register */
        int sa = rs(m, fn, i->a, 0);
        if (sa != T0)
            rv_mc_mv(m, T0, sa);
        rv_mc_jalr(m, T0);
    } else {
        rv_mc_call(m, i->sym);
    }
    narg = 0;

    /* A failable call returns its error in the second integer register (a1),
       which the front end expects spilled to the call's error slot.  The value
       in a0 is then handled as a plain integer result below. */
    if (retkind == RET_FAIL)
        rv_mc_sw(m, A1, FP, slot_offset(fn, i->slot));

    if (i->dst >= 0) {
        if (retkind == RET_I64) {
            int dlo = i64_rd_lo(fn, i->dst, 0);
            int dhi = i64_rd_hi(fn, i->dst, 1);
            if (dlo != A0)
                rv_mc_mv(m, dlo, A0);
            if (dhi != A1)
                rv_mc_mv(m, dhi, A1);
            i64_wd_lo(m, fn, i->dst, dlo);
            i64_wd_hi(m, fn, i->dst, dhi);
        } else if (retkind == RET_FLOAT) {
            int sd = frd_w(fn, i->dst, 0);
            /* a single result arrives as f32 bits in a0.  Widen it to f64 when the
               destination temp holds f64 format (Kobold); keep it f32 when the temp
               stays single (C).  A double arrives as its two words in a0:a1. */
            if (i->imm == FWIDTH_F32) {
                rv_mc_fmv_w_x(m, sd, A0);
                if (!src_is_f32(i->dst)) {
                    rv_mc_fcvt_d_s(m, sd, sd);
                    fwd_f(m, fn, i->dst, sd, 0);
                } else {
                    fwd_f(m, fn, i->dst, sd, 1);
                }
            } else {
                rv_mc_sw(m, A0, SP, stage);
                rv_mc_sw(m, A1, SP, stage + 4);
                rv_mc_fld(m, sd, SP, stage);
                fwd_f(m, fn, i->dst, sd, 0);
            }
        } else {
            int sd = rd(fn, i->dst, 0);
            if (sd != A0)
                rv_mc_mv(m, sd, A0);
            wd(m, fn, i->dst, sd);
        }
    }

    if (push_bytes > 0)
        rv_mc_addbig(m, SP, SP, push_bytes);
}

static void
emit_tailcall_flush(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i,
                    int indirect)
{
    struct rv_ploc loc[RV_MAX_ARGS];
    int words[RV_MAX_ARGS] = { 0 };
    int k, stack_bytes, first_vararg = -1;

    for (k = 0; k < narg; k++) {
        if (arg_is_i64[k])
            words[k] = 2;
        else if (arg_is_float[k])
            words[k] = arg_fw[k] ? 1 : 2;
        else
            words[k] = 1;
        if (first_vararg < 0 && arg_vararg[k])
            first_vararg = k;
    }
    stack_bytes = rv_abi_assign(words, narg, loc, first_vararg);

    if (stack_bytes > 0) {
        struct ir_insn call = *i;
        call.dst = -1;
        emit_call_flush(m, fn, &call, indirect, RET_INT);
        emit_epilogue(m, fn);
        return;
    }

    for (k = 0; k < narg; k++) {
        struct rv_ploc *p = &loc[k];

        if (arg_is_float[k] && !arg_fw[k]) {
            int sa = frs_w(m, fn, arg_temps[k], 0, 0);
            rv_mc_addi(m, SP, SP, -8);
            rv_mc_fsd(m, sa, SP, 0);
            rv_mc_lw(m, argreg[p->ireg], SP, 0);
            rv_mc_lw(m, argreg[p->ireg + 1], SP, 4);
            rv_mc_addi(m, SP, SP, 8);
        } else if (arg_is_float[k]) {
            int sa = frs_w(m, fn, arg_temps[k], 0, 1);
            rv_mc_fmv_x_w(m, argreg[p->ireg], sa);
        } else if (arg_is_i64[k]) {
            int lo = i64_rs_lo(m, fn, arg_temps[k], 0);
            rv_mc_mv(m, argreg[p->ireg], lo);
            rv_mc_mv(m, argreg[p->ireg + 1], i64_rs_hi(m, fn, arg_temps[k], 0));
        } else {
            int sa = rs(m, fn, arg_temps[k], 0);
            rv_mc_mv(m, argreg[p->ireg], sa);
        }
    }
    if (indirect) {
        int sa = rs(m, fn, i->a, 0);
        rv_mc_mv(m, T2, sa);
    }
    narg = 0;
    emit_epilogue_no_ret(m, fn);
    if (indirect)
        rv_mc_jr(m, T2);
    else
        rv_mc_j_sym(m, i->sym);
}

/****************************************************************
 * Per-instruction selection
 ****************************************************************/

static int
il(struct rv_mc *m, int *lbl, int n)
{
    if (lbl[n] < 0)
        lbl[n] = rv_mc_new_label(m);
    return lbl[n];
}

/* RISC-V ABI register names, indexed by hardware number (x0..x31). */
static const char *rv_abi_name[32] = {
    "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
    "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
    "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
    "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6",
};

/* name -> hardware number, or -1 (accepts "fp" as an alias for s0). */
static int
rv_reg_num(const char *name)
{
    int h;
    if (strcmp(name, "fp") == 0)
        return 8;
    for (h = 0; h < 32; h++)
        if (strcmp(rv_abi_name[h], name) == 0)
            return h;
    return -1;
}


static int
asm_reg_clobbered(struct ir_asm_info *ai, const char *name)
{
    int k;
    for (k = 0; k < ai->nclobbers; k++)
        if (strcmp(ai->clobbers[k], name) == 0)
            return 1;
    return 0;
}

/* The allocator index (temp_reg value) of hardware register `h`, or -1 if `h`
   is not an allocatable register. */
static int
rv_hw_to_index(int h)
{
    int k;
    for (k = 2; k < (int)(sizeof reg / sizeof reg[0]); k++)
        if (reg[k] == h)
            return k;
    return -1;
}

/* Fill out[] (capacity max) with the allocator indices of the allocatable
   registers any extended asm in fn pins or clobbers, deduplicated. */
int
rv_asm_reserved_regs(struct ir_func *fn, int *out, int max)
{
    struct ir_insn *i;
    int n = 0, k, j;

    for (i = fn->head; i; i = i->next) {
        struct ir_asm_info *ai = i->asm_info;
        if (i->op != IR_ASM || !ai)
            continue;
        for (k = 0; k < ai->noutputs + ai->ninputs; k++) {
            int h, idx;
            if (!ai->ops[k].pin_reg)
                continue;
            h = rv_reg_num(ai->ops[k].pin_reg);
            idx = h < 0 ? -1 : rv_hw_to_index(h);
            if (idx < 0)
                continue;
            for (j = 0; j < n && out[j] != idx; j++)
                ;
            if (j == n && n < max)
                out[n++] = idx;
        }
        for (k = 0; k < ai->nclobbers; k++) {
            int h = rv_reg_num(ai->clobbers[k]);
            int idx = h < 0 ? -1 : rv_hw_to_index(h);
            if (idx < 0)
                continue;
            for (j = 0; j < n && out[j] != idx; j++)
                ;
            if (j == n && n < max)
                out[n++] = idx;
        }
    }
    return n;
}

static int
asm_reg_pinned(struct ir_asm_info *ai, const char *name)
{
    int k, n = ai->noutputs + ai->ninputs;
    for (k = 0; k < n; k++)
        if (ai->ops[k].pin_reg && strcmp(ai->ops[k].pin_reg, name) == 0)
            return 1;
    return 0;
}

/* Extended inline asm.  A generic "r" operand goes in its allocated s-register
 * or a t-register materialised from the spill slot; a pinned operand goes in
 * the named physical register (its value moved in from the operand temp's home
 * and, for an output, back out).  The template's %N are substituted with the
 * register's ABI name and emitted as one text blob through rv_mc_asm; the
 * surrounding loads and stores go through the ordinary sink.  This is the
 * syscall case: a7/a0..a5 are not allocatable, so a pin to them is free. */
static void
emit_asm_ext(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i)
{
    struct ir_asm_info *ai = i->asm_info;
    int n = ai->noutputs + ai->ninputs;
    static const int pool[] = { 5, 6, 7, 28, 29, 30 };  /* t0,t1,t2,t3,t4,t5 */
    int npool = (int)(sizeof pool / sizeof pool[0]);
    int ophw[32];               /* each operand's hardware register number */
    int next = 0, k;
    const char *s;
    char buf[1024];
    size_t bp = 0;

    if (n > 32)
        die("rv: too many asm operands");

    /* 1. name each operand's register */
    for (k = 0; k < n; k++) {
        struct ir_asm_op *op = &ai->ops[k];

        if (t_is_i64(op->temp))
            die("rv: 64-bit asm operand not supported yet");
        if (op->pin_reg) {
            int j, h = rv_reg_num(op->pin_reg);
            if (h < 0)
                die("rv: unknown asm register %s", op->pin_reg);
            /* an allocatable pin is fine: the allocator reserved it (see
               rv_asm_reserved_regs), so no temp lives there across the asm */
            for (j = 0; j < k; j++)
                if (ai->ops[j].pin_reg &&
                    strcmp(ai->ops[j].pin_reg, op->pin_reg) == 0)
                    die("rv: two asm operands pinned to %s", op->pin_reg);
            ophw[k] = h;
        } else if (fn->temp_reg[op->temp] >= 0) {
            ophw[k] = reg[fn->temp_reg[op->temp]];
        } else {
            ophw[k] = -1;       /* a pool reg, assigned next */
        }
    }
    /* 2. hand spilled generic operands a pool register each */
    for (k = 0; k < n; k++) {
        if (ophw[k] >= 0)
            continue;
        while (next < npool && (asm_reg_clobbered(ai, rv_abi_name[pool[next]]) ||
                                asm_reg_pinned(ai, rv_abi_name[pool[next]])))
            next++;
        if (next >= npool)
            die("rv: too many spilled asm operands");
        ophw[k] = pool[next++];
    }

    /* 3. materialise input values into their operand registers */
    for (k = 0; k < n; k++) {
        struct ir_asm_op *op = &ai->ops[k];
        int home = fn->temp_reg[op->temp];

        if (op->is_output && !op->is_inout)
            continue;
        if (op->pin_reg) {
            if (home >= 0)
                rv_mc_mv(m, ophw[k], reg[home]);
            else
                rv_mc_lw(m, ophw[k], FP, spill_byte_offset(fn, op->temp));
        } else if (home < 0) {
            rv_mc_lw(m, ophw[k], FP, spill_byte_offset(fn, op->temp));
        }
    }

    /* 4. build the template with %N substituted, then emit it as one blob */
    for (s = i->sym; *s && bp + 1 < sizeof buf; s++) {
        if (*s != '%') {
            buf[bp++] = *s;
            continue;
        }
        s++;
        if (*s == '%') {
            buf[bp++] = '%';
        } else if (*s >= '0' && *s <= '9') {
            int idx = 0;
            const char *nm;
            while (*s >= '0' && *s <= '9')
                idx = idx * 10 + (*s++ - '0');
            s--;
            if (idx >= n)
                die("rv: asm operand %%%d out of range", idx);
            nm = rv_abi_name[ophw[idx]];
            while (*nm && bp + 1 < sizeof buf)
                buf[bp++] = *nm++;
        } else {
            buf[bp++] = '%';
            if (bp + 1 < sizeof buf)
                buf[bp++] = *s;
        }
    }
    buf[bp] = '\0';
    rv_mc_asm(m, buf);

    /* 5. store outputs back from their operand registers */
    for (k = 0; k < ai->noutputs; k++) {
        struct ir_asm_op *op = &ai->ops[k];
        int home = fn->temp_reg[op->temp];

        if (op->pin_reg) {
            if (home >= 0)
                rv_mc_mv(m, reg[home], ophw[k]);
            else
                rv_mc_sw(m, ophw[k], FP, spill_byte_offset(fn, op->temp));
        } else {
            wd(m, fn, op->temp, ophw[k]);
        }
    }
}

static int
emit_insn(struct rv_mc *m, struct ir_func *fn, struct ir_insn *i, int *lbl,
          char *err, size_t errlen)
{
    switch (i->op) {
    case IR_NOP:
        break;

    case IR_ASM:
        if (i->asm_info) {
            emit_asm_ext(m, fn, i);
            break;
        }
        rv_mc_asm(m, i->sym);
        break;

    case IR_LIC: {
        int sd = rd(fn, i->dst, 0);
        rv_mc_li(m, sd, i->imm);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_LEA: {
        int sd = rd(fn, i->dst, 0);
        rv_mc_la(m, sd, i->sym);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_LABADDR: {
        int sd = rd(fn, i->dst, 0);
        rv_mc_lea_label(m, sd, il(m, lbl, i->label));
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_ADL: {
        int sd = rd(fn, i->dst, 0);
        rv_mc_addbig(m, sd, FP, slot_offset(fn, i->slot));
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_MOV: {
        int sa = rs(m, fn, i->a, 0);
        int sd = rd(fn, i->dst, 0);
        if (sa != sd)
            rv_mc_mv(m, sd, sa);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_ADD:  emit_binop(m, fn, i, rv_mc_add);  break;
    case IR_SUB:  emit_binop(m, fn, i, rv_mc_sub);  break;
    case IR_MUL:  emit_binop(m, fn, i, rv_mc_mul);  break;
    case IR_ADDO: case IR_SUBO: case IR_MULO: emit_overflow(m, fn, i, lbl); break;
    case IR_AND:  emit_binop(m, fn, i, rv_mc_and);  break;
    case IR_OR:   emit_binop(m, fn, i, rv_mc_or);   break;
    case IR_XOR:  emit_binop(m, fn, i, rv_mc_xor);  break;
    case IR_SHL:  emit_binop(m, fn, i, rv_mc_sll);  break;
    case IR_SHRS: emit_binop(m, fn, i, rv_mc_sra);  break;
    case IR_SHRU: emit_binop(m, fn, i, rv_mc_srl);  break;
    case IR_DIVS: emit_div(m, fn, i, rv_mc_div,  1); break;
    case IR_DIVU: emit_div(m, fn, i, rv_mc_divu, 0); break;
    case IR_MODS: emit_div(m, fn, i, rv_mc_rem,  1); break;
    case IR_MODU: emit_div(m, fn, i, rv_mc_remu, 0); break;

    case IR_NEG: emit_unop(m, fn, i, rv_mc_neg); break;
    case IR_NOT: emit_unop(m, fn, i, rv_mc_not); break;

    case IR_LB:  emit_load(m, fn, i, rv_mc_lbu); break;
    case IR_LBS: emit_load(m, fn, i, rv_mc_lb);  break;
    case IR_LH:  emit_load(m, fn, i, rv_mc_lhu); break;
    case IR_LHS: emit_load(m, fn, i, rv_mc_lh);  break;
    case IR_LW:  emit_load(m, fn, i, rv_mc_lw);  break;

    case IR_SB: emit_store(m, fn, i, rv_mc_sb); break;
    case IR_SH: emit_store(m, fn, i, rv_mc_sh); break;
    case IR_SW: emit_store(m, fn, i, rv_mc_sw); break;

    case IR_LDL: {
        int sd = rd(fn, i->dst, 0);
        rv_mc_lw(m, sd, FP, slot_offset(fn, i->slot));
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_STL: {
        int sa = rs(m, fn, i->a, 0);
        rv_mc_sw(m, sa, FP, slot_offset(fn, i->slot));
        break;
    }

    case IR_ALLOCA: {
        int sa = rs(m, fn, i->a, 0);
        int sd = rd(fn, i->dst, 0);
        if (sa != T0)
            rv_mc_mv(m, T0, sa);
        rv_mc_addi(m, T0, T0, 3);
        rv_mc_andi(m, T0, T0, -4);
        rv_mc_sub(m, SP, SP, T0);
        rv_mc_mv(m, sd, SP);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_CMPEQ:
    case IR_CMPNE:
    case IR_CMPLTS: case IR_CMPLES: case IR_CMPGTS: case IR_CMPGES:
    case IR_CMPLTU: case IR_CMPLEU: case IR_CMPGTU: case IR_CMPGEU:
        emit_cmp(m, fn, i, i->op);
        break;

    case IR_JMP:
        rv_mc_j(m, il(m, lbl, i->label));
        break;
    case IR_IJMP: {
        int sa = rs(m, fn, i->a, 0);
        rv_mc_jr(m, sa);
        break;
    }
    case IR_BZ: {
        int sa = rs(m, fn, i->a, 0);
        rv_mc_beqz(m, sa, il(m, lbl, i->label));
        break;
    }
    case IR_BNZ: {
        int sa = rs(m, fn, i->a, 0);
        rv_mc_bnez(m, sa, il(m, lbl, i->label));
        break;
    }
    case IR_LABEL:
        rv_mc_label(m, il(m, lbl, i->label));
        break;

    case IR_ARG:
        if (narg >= RV_MAX_ARGS) {
            snprintf(err, errlen, "rv_select: too many args");
            return -1;
        }
        arg_is_i64[narg] = 0;
        arg_is_float[narg] = 0;
        arg_vararg[narg] = i->vararg;
        arg_temps[narg++] = i->a;
        break;
    case IR_ARG64:
        if (narg >= RV_MAX_ARGS) {
            snprintf(err, errlen, "rv_select: too many args");
            return -1;
        }
        arg_is_i64[narg] = 1;
        arg_is_float[narg] = 0;
        arg_vararg[narg] = i->vararg;
        arg_temps[narg++] = i->a;
        break;
    case IR_CALL:
        emit_call_flush(m, fn, i, 0, RET_INT);
        break;
    case IR_CALLI:
        emit_call_flush(m, fn, i, 1, RET_INT);
        break;
    case IR_CALL2:
        emit_call_flush(m, fn, i, 0, RET_FAIL);
        break;
    case IR_CALLI2:
        emit_call_flush(m, fn, i, 1, RET_FAIL);
        break;
    case IR_CALL_AGG:
    case IR_CALLI_AGG: {
        /* a call returning a <=8-byte struct in a0 (and a1): make the call
           (i->dst is -1, so emit_call_flush leaves a0/a1 untouched), then store
           the returned words into the hidden result slot.  imm bits 0-2 hold
           the word count (every slot integer under ilp32). */
        int rneb = (int)(i->imm & 7);
        int off;
        emit_call_flush(m, fn, i, i->op == IR_CALLI_AGG, RET_INT);
        off = slot_offset(fn, i->slot);
        rv_mc_sw(m, A0, FP, off);
        if (rneb == 2)
            rv_mc_sw(m, A1, FP, off + 4);
        break;
    }
    case IR_TAILCALL:
        emit_tailcall_flush(m, fn, i, 0);
        break;
    case IR_TAILCALLI:
        emit_tailcall_flush(m, fn, i, 1);
        break;

    case IR_RET:
        emit_epilogue(m, fn);
        break;
    case IR_RETV: {
        int sa = rs(m, fn, i->a, 0);
        if (sa != A0)
            rv_mc_mv(m, A0, sa);
        emit_epilogue(m, fn);
        break;
    }
    case IR_RETV2: {
        /* failable return: value in a0, error in a1.  Materialise through
           distinct scratch slots so the second load cannot clobber the first;
           neither reg[] slot is a0/a1, so the moves are independent. */
        int sa = rs(m, fn, i->a, 0);
        int sb = rs(m, fn, i->b, 1);
        if (sa != A0)
            rv_mc_mv(m, A0, sa);
        if (sb != A1)
            rv_mc_mv(m, A1, sb);
        emit_epilogue(m, fn);
        break;
    }
    case IR_RETV_AGG: {
        /* return a <=8-byte struct in a0 (and a1): load each 4-byte word from
           the struct's address (i->a) into the return registers.  Every slot
           is integer under the ilp32 soft-float ABI, so ret_cls is unused.
           The struct address is never a0/a1 (not an allocatable register), so
           loading a0 then a1 cannot clobber the base. */
        int ab = rs(m, fn, i->a, 0);
        int j;
        for (j = 0; j < fn->ret_neb; j++)
            rv_mc_lw(m, argreg[j], ab, 4 * j);
        emit_epilogue(m, fn);
        break;
    }

    case IR_MARK: {
        int sd = rd(fn, i->dst, 0);
        int off = slot_offset(fn, i->slot);
        int reentry = rv_mc_new_label(m);

        rv_mc_sw(m, FP, FP, off);
        rv_mc_sw(m, SP, FP, off + 4);
        rv_mc_lea_label(m, T0, reentry);
        rv_mc_sw(m, T0, FP, off + 8);
        rv_mc_addbig(m, T0, FP, off);
        rv_mc_la(m, T1, "__cont_mark_sp");
        rv_mc_sw(m, T0, T1, 0);
        /* stash the continuation-arena high-water mark (first entry only,
           before the re-entry label) for IR_CONT_UNWIND to restore */
        rv_mc_la(m, T0, "__cont_arena_ptr");
        rv_mc_lw(m, T1, T0, 0);
        rv_mc_sw(m, T1, FP, off + 12);
        rv_mc_li(m, A0, 0);
        rv_mc_label(m, reentry);
        if (sd != A0)
            rv_mc_mv(m, sd, A0);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_CAPTURE: {
        int sd = rd(fn, i->dst, 0);
        int k;

        for (k = 0; k < NSAVED; k++) {
            rv_mc_addi(m, SP, SP, -4);
            rv_mc_sw(m, reg[k + 2], SP, 0);
        }
        rv_mc_call(m, "__cont_capture");
        for (k = NSAVED - 1; k >= 0; k--) {
            rv_mc_lw(m, reg[k + 2], SP, 0);
            rv_mc_addi(m, SP, SP, 4);
        }
        if (sd != A0)
            rv_mc_mv(m, sd, A0);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_CONT_UNWIND: {
        int off = slot_offset(fn, i->slot);
        rv_mc_lw(m, T0, FP, off + 12);
        rv_mc_la(m, T1, "__cont_arena_ptr");
        rv_mc_sw(m, T0, T1, 0);
        break;
    }

    case IR_RESUME: {
        int sa = rs(m, fn, i->a, 0);
        int sb = rs(m, fn, i->b, 1);

        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, sa, SP, 0);
        rv_mc_sw(m, sb, SP, 4);
        rv_mc_call(m, "__cont_resume");
        break;
    }

    /* ---- Floating point (IEEE 754, hardware RV32FD + Zfh) ---- */

    case IR_FADD: emit_fbinop(m, fn, i, rv_mc_fadd); break;
    case IR_FSUB: emit_fbinop(m, fn, i, rv_mc_fsub); break;
    case IR_FMUL: emit_fbinop(m, fn, i, rv_mc_fmul); break;
    case IR_FDIV: emit_fbinop(m, fn, i, rv_mc_fdiv); break;
    case IR_FNEG: emit_funop(m, fn, i, rv_mc_fneg); break;
    case IR_FABS: emit_funop(m, fn, i, rv_mc_fabs); break;
    case IR_FSQRT: emit_funop(m, fn, i, rv_mc_fsqrt); break;

    case IR_FCMPEQ: case IR_FCMPLT: case IR_FCMPLE: {
        int f32 = i->imm == FWIDTH_F32;
        int fa = frs_w(m, fn, i->a, 0, f32);
        int fb = frs_w(m, fn, i->b, 1, f32);
        int sd = rd(fn, i->dst, 0);
        if (i->op == IR_FCMPEQ)
            rv_mc_feq(m, f32, sd, fa, fb);
        else if (i->op == IR_FCMPLT)
            rv_mc_flt(m, f32, sd, fa, fb);
        else
            rv_mc_fle(m, f32, sd, fa, fb);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_ITOF: {
        int f32 = i->imm == FWIDTH_F32;
        int sa = rs(m, fn, i->a, 0);
        int sd = frd_w(fn, i->dst, 0);
        rv_mc_fcvt_f_w(m, f32, sd, sa);
        fwd_f(m, fn, i->dst, sd, f32);
        break;
    }

    case IR_FTOI: {
        int f32 = i->imm == FWIDTH_F32;
        int sa = frs_w(m, fn, i->a, 0, f32);
        int sd = rd(fn, i->dst, 0);
        rv_mc_fcvt_w_f(m, f32, sd, sa);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_FROUND: {       /* float -> i32, round to nearest */
        int f32 = i->imm == FWIDTH_F32;
        int sa = frs_w(m, fn, i->a, 0, f32);
        int sd = rd(fn, i->dst, 0);
        rv_mc_fround(m, f32, sd, sa);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_F32TOF64: {
        int sa = frs_w(m, fn, i->a, 0, 1);
        int sd = frd_w(fn, i->dst, 0);
        rv_mc_fcvt_d_s(m, sd, sa);
        fwd_f(m, fn, i->dst, sd, 0);
        break;
    }

    case IR_F64TOF32: {
        int sa = frs_w(m, fn, i->a, 0, 0);
        int sd = frd_w(fn, i->dst, 0);
        rv_mc_fcvt_s_d(m, sd, sa);
        fwd_f(m, fn, i->dst, sd, 1);
        break;
    }

    case IR_FLDL: {
        int f32 = i->imm == FWIDTH_F32;
        int sd = frd_w(fn, i->dst, 0);
        if (f32)
            rv_mc_flw(m, sd, FP, slot_offset(fn, i->slot));
        else
            rv_mc_fld(m, sd, FP, slot_offset(fn, i->slot));
        fwd_f(m, fn, i->dst, sd, f32);
        break;
    }

    case IR_FSTL: {
        int f32 = i->imm == FWIDTH_F32;
        int sa = frs_w(m, fn, i->a, 0, f32);
        if (f32)
            rv_mc_fsw(m, sa, FP, slot_offset(fn, i->slot));
        else
            rv_mc_fsd(m, sa, FP, slot_offset(fn, i->slot));
        break;
    }

    case IR_FLD: {
        int f32 = i->imm == FWIDTH_F32;
        int sa = rs(m, fn, i->a, 0);
        int sd = frd_w(fn, i->dst, 0);
        if (f32)
            rv_mc_flw(m, sd, sa, 0);
        else
            rv_mc_fld(m, sd, sa, 0);
        fwd_f(m, fn, i->dst, sd, f32);
        break;
    }

    case IR_FSD: {
        int f32 = i->imm == FWIDTH_F32;
        int sa = rs(m, fn, i->a, 0);
        int sb = frs_w(m, fn, i->b, 0, f32);
        if (f32)
            rv_mc_fsw(m, sb, sa, 0);
        else
            rv_mc_fsd(m, sb, sa, 0);
        break;
    }

    case IR_FLS: {                                   /* load single -> double */
        int sa = rs(m, fn, i->a, 0);
        int sd = frd_w(fn, i->dst, 0);
        rv_mc_flw(m, 0, sa, 0);                       /* ft0 */
        rv_mc_fcvt_d_s(m, sd, 0);
        fwd_f(m, fn, i->dst, sd, 0);
        break;
    }

    case IR_FSS: {                                   /* double -> single, store */
        int sa = rs(m, fn, i->a, 0);
        int sb = frs_w(m, fn, i->b, 0, 0);
        rv_mc_fcvt_s_d(m, 0, sb);                     /* ft0 */
        rv_mc_fsw(m, 0, sa, 0);
        break;
    }

    case IR_FLH: {                                   /* load half -> double */
        int sa = rs(m, fn, i->a, 0);
        int sd = frd_w(fn, i->dst, 0);
        rv_mc_flh(m, 0, sa, 0);                       /* ft0, Zfh */
        rv_mc_fcvt_d_h(m, sd, 0);
        fwd_f(m, fn, i->dst, sd, 0);
        break;
    }

    case IR_FSH: {                                   /* double -> half, store */
        int sa = rs(m, fn, i->a, 0);
        int sb = frs_w(m, fn, i->b, 0, 0);
        rv_mc_fcvt_h_d(m, 0, sb);                     /* ft0 */
        rv_mc_fsh(m, 0, sa, 0);
        break;
    }

    case IR_FRETV: {
        /* a single result returns its f32 bits in a0: narrowed from an f64-format
           temp (Kobold), or taken directly from an f32 temp (C).  A double returns
           as its two words in a0:a1. */
        if (i->imm == FWIDTH_F32) {
            int sbits;
            if (src_is_f32(i->a)) {
                sbits = frs_w(m, fn, i->a, 0, 1);
            } else {
                int sa = frs_w(m, fn, i->a, 0, 0);
                rv_mc_fcvt_s_d(m, 1, sa);
                sbits = 1;
            }
            rv_mc_fmv_x_w(m, A0, sbits);
        } else {
            int sa = frs_w(m, fn, i->a, 0, 0);
            rv_mc_addi(m, SP, SP, -8);
            rv_mc_fsd(m, sa, SP, 0);
            rv_mc_lw(m, A0, SP, 0);
            rv_mc_lw(m, A1, SP, 4);
            rv_mc_addi(m, SP, SP, 8);
        }
        emit_epilogue(m, fn);
        break;
    }

    case IR_FARG:
        if (narg >= RV_MAX_ARGS) {
            snprintf(err, errlen, "rv_select: too many args");
            return -1;
        }
        arg_is_i64[narg] = 0;
        arg_is_float[narg] = 1;
        arg_fw[narg] = i->imm == FWIDTH_F32;
        arg_vararg[narg] = i->vararg;
        arg_temps[narg++] = i->a;
        break;

    case IR_FCALL:
        emit_call_flush(m, fn, i, 0, RET_FLOAT);
        break;
    case IR_FCALLI:
        emit_call_flush(m, fn, i, 1, RET_FLOAT);
        break;

    /* ---- I64 opcodes ---- */

    case IR_LIC64: {
        uint64_t val = (uint64_t)i->imm;
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_li(m, dlo, (int)(uint32_t)val);
        rv_mc_li(m, dhi, (int)(uint32_t)(val >> 32));
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_ADD64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int ahi, dhi, bhi;
        rv_mc_add(m, dlo, alo, blo);
        rv_mc_sltu(m, T0, dlo, blo);
        i64_wd_lo(m, fn, i->dst, dlo);
        ahi = i64_rs_hi(m, fn, i->a, 1);
        dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_add(m, dhi, ahi, T0);
        bhi = i64_rs_hi(m, fn, i->b, 0);
        rv_mc_add(m, dhi, dhi, bhi);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_SUB64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int ahi, dhi, bhi;
        rv_mc_sltu(m, T0, alo, blo);
        rv_mc_sub(m, dlo, alo, blo);
        i64_wd_lo(m, fn, i->dst, dlo);
        ahi = i64_rs_hi(m, fn, i->a, 1);
        dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_sub(m, dhi, ahi, T0);
        bhi = i64_rs_hi(m, fn, i->b, 0);
        rv_mc_sub(m, dhi, dhi, bhi);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_MUL64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo, dlo, dhi;
        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, alo, SP, 0);
        rv_mc_sw(m, i64_rs_hi(m, fn, i->a, 0), SP, 4);
        blo = i64_rs_lo(m, fn, i->b, 1);
        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, blo, SP, 0);
        rv_mc_sw(m, i64_rs_hi(m, fn, i->b, 1), SP, 4);
        rv_mc_call(m, "__muldi3");
        rv_mc_addi(m, SP, SP, 16);
        dlo = i64_rd_lo(fn, i->dst, 0);
        dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != A0)
            rv_mc_mv(m, dlo, A0);
        if (dhi != A1)
            rv_mc_mv(m, dhi, A1);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_DIVS64: case IR_DIVU64: case IR_MODS64: case IR_MODU64: {
        /* RV32 has no 64-bit divide; call the register-ABI helper (a and b in the
           a0:a1 and a2:a3 pairs, the result in a0:a1), the same helpers the host
           binds for the JIT.  Sources are callee-saved or scratch, never a0-a3, so
           the argument pairs load without clobbering one another. */
        const char *sym = i->op == IR_DIVS64 ? "__divdi3" :
                          i->op == IR_DIVU64 ? "__udivdi3" :
                          i->op == IR_MODS64 ? "__moddi3" : "__umoddi3";
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        int blo, bhi, dlo, dhi;
        rv_mc_mv(m, A0, alo);
        rv_mc_mv(m, A1, ahi);
        blo = i64_rs_lo(m, fn, i->b, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        rv_mc_mv(m, argreg[2], blo);     /* a2 */
        rv_mc_mv(m, argreg[3], bhi);     /* a3 */
        rv_mc_call(m, sym);
        dlo = i64_rd_lo(fn, i->dst, 0);
        dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != A0)
            rv_mc_mv(m, dlo, A0);
        if (dhi != A1)
            rv_mc_mv(m, dhi, A1);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_AND64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int ahi, bhi, dhi;
        rv_mc_and(m, dlo, alo, blo);
        i64_wd_lo(m, fn, i->dst, dlo);
        ahi = i64_rs_hi(m, fn, i->a, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        dhi = i64_rd_hi(fn, i->dst, 0);
        rv_mc_and(m, dhi, ahi, bhi);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_OR64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int ahi, bhi, dhi;
        rv_mc_or(m, dlo, alo, blo);
        i64_wd_lo(m, fn, i->dst, dlo);
        ahi = i64_rs_hi(m, fn, i->a, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        dhi = i64_rd_hi(fn, i->dst, 0);
        rv_mc_or(m, dhi, ahi, bhi);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_XOR64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int ahi, bhi, dhi;
        rv_mc_xor(m, dlo, alo, blo);
        i64_wd_lo(m, fn, i->dst, dlo);
        ahi = i64_rs_hi(m, fn, i->a, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        dhi = i64_rd_hi(fn, i->dst, 0);
        rv_mc_xor(m, dhi, ahi, bhi);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_NEG64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_neg(m, dlo, alo);
        rv_mc_snez(m, T0, alo);
        rv_mc_neg(m, dhi, ahi);
        rv_mc_sub(m, dhi, dhi, T0);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_SHL64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        int sb = rs(m, fn, i->b, 0);
        int dlo, dhi;
        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, alo, SP, 0);
        rv_mc_sw(m, ahi, SP, 4);
        rv_mc_addi(m, SP, SP, -4);
        rv_mc_sw(m, sb, SP, 0);
        rv_mc_call(m, "__ashldi3");
        rv_mc_addi(m, SP, SP, 12);
        dlo = i64_rd_lo(fn, i->dst, 0);
        dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != A0)
            rv_mc_mv(m, dlo, A0);
        if (dhi != A1)
            rv_mc_mv(m, dhi, A1);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_SHRS64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        int sb = rs(m, fn, i->b, 0);
        int dlo, dhi;
        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, alo, SP, 0);
        rv_mc_sw(m, ahi, SP, 4);
        rv_mc_addi(m, SP, SP, -4);
        rv_mc_sw(m, sb, SP, 0);
        rv_mc_call(m, "__ashrdi3");
        rv_mc_addi(m, SP, SP, 12);
        dlo = i64_rd_lo(fn, i->dst, 0);
        dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != A0)
            rv_mc_mv(m, dlo, A0);
        if (dhi != A1)
            rv_mc_mv(m, dhi, A1);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_SHRU64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        int sb = rs(m, fn, i->b, 0);
        int dlo, dhi;
        rv_mc_addi(m, SP, SP, -8);
        rv_mc_sw(m, alo, SP, 0);
        rv_mc_sw(m, ahi, SP, 4);
        rv_mc_addi(m, SP, SP, -4);
        rv_mc_sw(m, sb, SP, 0);
        rv_mc_call(m, "__lshrdi3");
        rv_mc_addi(m, SP, SP, 12);
        dlo = i64_rd_lo(fn, i->dst, 0);
        dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != A0)
            rv_mc_mv(m, dlo, A0);
        if (dhi != A1)
            rv_mc_mv(m, dhi, A1);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_CMP64EQ: case IR_CMP64NE: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int sd = rd(fn, i->dst, 0);
        int ahi, bhi;
        rv_mc_xor(m, T0, alo, blo);
        ahi = i64_rs_hi(m, fn, i->a, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        rv_mc_xor(m, T1, ahi, bhi);
        rv_mc_or(m, T0, T0, T1);
        if (i->op == IR_CMP64EQ)
            rv_mc_seqz(m, sd, T0);
        else
            rv_mc_snez(m, sd, T0);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_CMP64LTS: case IR_CMP64LES:
    case IR_CMP64GTS: case IR_CMP64GES:
    case IR_CMP64LTU: case IR_CMP64LEU:
    case IR_CMP64GTU: case IR_CMP64GEU: {
        int done = rv_mc_new_label(m);
        int ahi = i64_rs_hi(m, fn, i->a, 0);
        int bhi = i64_rs_hi(m, fn, i->b, 1);
        int sd = rd(fn, i->dst, 0);
        int hi_signed;         /* 1 = slt, 0 = sltu for the high word */
        int swap_ab = 0;
        int alo, blo;

        switch (i->op) {
        case IR_CMP64LTS: hi_signed = 1; break;
        case IR_CMP64GTS: hi_signed = 1; swap_ab = 1; break;
        case IR_CMP64LTU: hi_signed = 0; break;
        case IR_CMP64GTU: hi_signed = 0; swap_ab = 1; break;
        case IR_CMP64LES: hi_signed = 1; swap_ab = 1; break;
        case IR_CMP64GES: hi_signed = 1; break;
        case IR_CMP64LEU: hi_signed = 0; swap_ab = 1; break;
        case IR_CMP64GEU: hi_signed = 0; break;
        default: hi_signed = 0; break;
        }

        if (swap_ab) {
            int tmp = ahi; ahi = bhi; bhi = tmp;
        }

        if (hi_signed)
            rv_mc_slt(m, sd, ahi, bhi);
        else
            rv_mc_sltu(m, sd, ahi, bhi);
        rv_mc_bne(m, ahi, bhi, done);

        alo = i64_rs_lo(m, fn, swap_ab ? i->b : i->a, 0);
        blo = i64_rs_lo(m, fn, swap_ab ? i->a : i->b, 1);
        rv_mc_sltu(m, sd, alo, blo);
        rv_mc_label(m, done);

        switch (i->op) {
        case IR_CMP64LES: case IR_CMP64GES:
        case IR_CMP64LEU: case IR_CMP64GEU:
            rv_mc_xori(m, sd, sd, 1);
            break;
        default:
            break;
        }

        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_LD64: {
        int sa = rs(m, fn, i->a, 0);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_lw(m, dlo, sa, 0);
        rv_mc_lw(m, dhi, sa, 4);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_ST64: {
        int sa = rs(m, fn, i->a, 0);
        int blo = i64_rs_lo(m, fn, i->b, 1);
        int bhi;
        rv_mc_sw(m, blo, sa, 0);
        bhi = i64_rs_hi(m, fn, i->b, 1);
        rv_mc_sw(m, bhi, sa, 4);
        break;
    }

    case IR_LDL64: {
        int off = slot_offset(fn, i->slot);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        rv_mc_lw(m, dlo, FP, off);
        rv_mc_lw(m, dhi, FP, off + 4);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_STL64: {
        int off = slot_offset(fn, i->slot);
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi;
        rv_mc_sw(m, alo, FP, off);
        ahi = i64_rs_hi(m, fn, i->a, 1);
        rv_mc_sw(m, ahi, FP, off + 4);
        break;
    }

    case IR_SEXT64: {
        int sa = rs(m, fn, i->a, 0);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != sa)
            rv_mc_mv(m, dlo, sa);
        rv_mc_srai(m, dhi, dlo, 31);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_ZEXT64: {
        int sa = rs(m, fn, i->a, 0);
        int dlo = i64_rd_lo(fn, i->dst, 0);
        int dhi = i64_rd_hi(fn, i->dst, 1);
        if (dlo != sa)
            rv_mc_mv(m, dlo, sa);
        rv_mc_li(m, dhi, 0);
        i64_wd_lo(m, fn, i->dst, dlo);
        i64_wd_hi(m, fn, i->dst, dhi);
        break;
    }

    case IR_TRUNC64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int sd = rd(fn, i->dst, 0);
        if (sd != alo)
            rv_mc_mv(m, sd, alo);
        wd(m, fn, i->dst, sd);
        break;
    }

    case IR_CALL64:
        emit_call_flush(m, fn, i, 0, RET_I64);
        break;
    case IR_CALLI64:
        emit_call_flush(m, fn, i, 1, RET_I64);
        break;

    case IR_RETV64: {
        int alo = i64_rs_lo(m, fn, i->a, 0);
        int ahi = i64_rs_hi(m, fn, i->a, 1);
        if (alo != A0)
            rv_mc_mv(m, A0, alo);
        if (ahi != A1)
            rv_mc_mv(m, A1, ahi);
        emit_epilogue(m, fn);
        break;
    }

    case IR_VA_START: {
        /* Initialize the va_list at [temp a].  skjegg's variadic convention
           routes every unnamed argument onto the caller's outgoing stack
           block (see rv_abi_assign's first_vararg), so the unnamed arguments
           sit contiguously just past the named stack arguments at fp+8.  The
           named arguments consume their psABI homes first; compute the byte
           offset past them (8 for the saved fp/ra, plus the named stack
           bytes, which is 0 for the common fmt-in-a0 case), point
           overflow_arg_area (field @8 of the SysV __va_list_tag) there, and
           zero the unused register-area fields.  runtime/va_rv.c reads only
           overflow_arg_area, 8-aligning it for a 64-bit slot. */
        struct rv_ploc loc[64];
        int words[64] = { 0 };
        int n = fn->nparams, k, off, sa;

        if (n > 64)
            n = 64;
        for (k = 0; k < n; k++)
            words[k] = rv_param_words(fn, k);
        off = 8 + rv_abi_assign(words, n, loc, -1);
        sa = rs(m, fn, i->a, 1);        /* va_list struct address (t1 scratch) */
        rv_mc_addbig(m, T0, FP, off);   /* overflow_arg_area = fp + off */
        rv_mc_sw(m, T0, sa, 8);
        rv_mc_sw(m, 0, sa, 0);          /* gp_offset     = 0 */
        rv_mc_sw(m, 0, sa, 4);          /* fp_offset     = 0 */
        rv_mc_sw(m, 0, sa, 12);         /* reg_save_area = 0 */
        break;
    }

    case IR_FUNC:
    case IR_ENDF:
        break;

    case IR_LOC:
        rv_mc_loc(m, (int)i->imm);      /* debug-info line marker (-g) */
        break;

    default:
        snprintf(err, errlen, "rv_select: unhandled op %d", i->op);
        return -1;
    }
    return 0;
}

/****************************************************************
 * Per-function driver
 ****************************************************************/

int
rv_select_func(struct rv_mc *m, struct ir_func *fn, int tp,
               char *err, size_t errlen)
{
    struct ir_insn *i;
    struct ir_insn *last = NULL;
    int *lbl;
    int *is_i64;
    unsigned char *f32fmt;
    int k;

    g_trap_policy = tp;
    narg = 0;
    compute_used_fregs(fn);

    lbl = malloc((size_t)(fn->nlabels > 0 ? fn->nlabels : 1) * sizeof(int));
    if (!lbl) {
        snprintf(err, errlen, "rv_select: out of memory");
        return -1;
    }
    for (k = 0; k < fn->nlabels; k++)
        lbl[k] = -1;

    /* Classify each temp's storage width (i64 pair vs single register), matching
       regalloc_rv, so the temp readers resolve a width-crossing access correctly. */
    is_i64 = calloc((size_t)(fn->ntemps > 0 ? fn->ntemps : 1), sizeof(int));
    if (!is_i64) {
        free(lbl);
        snprintf(err, errlen, "rv_select: out of memory");
        return -1;
    }
    for (i = fn->head; i; i = i->next)
        if (i->dst >= 0 && i->dst < fn->ntemps && ir_op_is_i64_def(i->op))
            is_i64[i->dst] = 1;
    g_is_i64 = is_i64;

    /* Classify each float temp's register format (single vs double), so a single
       value crossing a call is converted only when the temp format differs. */
    f32fmt = calloc((size_t)(fn->ntemps > 0 ? fn->ntemps : 1), 1);
    if (!f32fmt) {
        g_is_i64 = NULL;
        free(is_i64);
        free(lbl);
        snprintf(err, errlen, "rv_select: out of memory");
        return -1;
    }
    ir_classify_f32(fn, f32fmt);
    g_f32 = f32fmt;

    emit_prologue(m, fn);

    for (i = fn->head; i; i = i->next) {
        if (emit_insn(m, fn, i, lbl, err, errlen) != 0) {
            g_is_i64 = NULL;
            g_f32 = NULL;
            free(f32fmt);
            free(is_i64);
            free(lbl);
            return -1;
        }
        if (i->op != IR_FUNC && i->op != IR_ENDF && i->op != IR_LABEL)
            last = i;
    }

    if (!last || (last->op != IR_RET && last->op != IR_RETV &&
        last->op != IR_RETV64 &&
        last->op != IR_TAILCALL && last->op != IR_TAILCALLI))
        emit_epilogue(m, fn);

    g_is_i64 = NULL;
    g_f32 = NULL;
    free(f32fmt);
    free(is_i64);
    free(lbl);
    return 0;
}
