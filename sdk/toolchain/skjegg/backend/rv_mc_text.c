/* rv_mc_text.c : the GAS text sink (see rv_mc_text.h) plus the RISC-V AOT driver
   (target_emit).

   One implementation of backend/rv_mc.h that writes RV32 (RV32IMFD + Zfh) GAS
   assembly.  Each rv_mc_* call prints one instruction (or the assembler-assisted
   form of a large frame offset routed through t6); the selector drives it exactly
   as it drives the JIT's byte sink, so the two paths emit the same code from one
   selection logic.  Registers arrive as hardware numbers and are indexed into the
   ABI-name tables.  The RISC-V parallel of backend/arm64_mc_text.c. */

#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ir.h"
#include "rv_mc.h"
#include "rv_mc_text.h"
#include "rv_select.h"

struct rv_mc {
    FILE *out;
    int serial;             /* per-function label namespace */
    int nlab;               /* next label id */
    const char *errsym;     /* parity with the byte sink; never set here */
};

/* ABI register names by hardware number. */
static const char *
xn(int r)
{
    static const char *t[32] = {
        "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
        "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
        "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
        "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6",
    };
    return t[r & 31];
}

static const char *
fnn(int r)
{
    static const char *t[32] = {
        "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
        "fs0", "fs1", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5",
        "fa6", "fa7", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7",
        "fs8", "fs9", "fs10", "fs11", "ft8", "ft9", "ft10", "ft11",
    };
    return t[r & 31];
}

struct rv_mc *
rvt_new(FILE *out)
{
    struct rv_mc *m = calloc(1, sizeof *m);
    if (m)
        m->out = out;
    return m;
}

void rvt_free(struct rv_mc *m) { free(m); }

void
rvt_begin_func(struct rv_mc *m, int serial)
{
    m->serial = serial;
    m->nlab = 0;
}

const char *rvt_errsym(struct rv_mc *m) { return m->errsym; }

/****************************************************************
 * Base-relative load/store with large-offset lowering (mirrors rv_emit.c's
 * emit_mem: a 12-bit signed immediate reaches only -2048..+2047 from the base,
 * so an out-of-range offset is materialised in t6).
 ****************************************************************/

#define IMM12_MIN (-2048)
#define IMM12_MAX 2047

static void
memop(struct rv_mc *m, const char *mnem, const char *reg, int base, int off)
{
    if (off >= IMM12_MIN && off <= IMM12_MAX) {
        fprintf(m->out, "\t%s %s, %d(%s)\n", mnem, reg, off, xn(base));
        return;
    }
    fprintf(m->out, "\tli t6, %d\n", off);
    fprintf(m->out, "\tadd t6, %s, t6\n", xn(base));
    fprintf(m->out, "\t%s %s, 0(t6)\n", mnem, reg);
}

/****************************************************************
 * Control flow
 ****************************************************************/

int rv_mc_new_label(struct rv_mc *m) { return m->nlab++; }
void rv_mc_label(struct rv_mc *m, int id) { fprintf(m->out, ".L%d_%d:\n", m->serial, id); }
void rv_mc_j(struct rv_mc *m, int id) { fprintf(m->out, "\tj .L%d_%d\n", m->serial, id); }
void rv_mc_beqz(struct rv_mc *m, int rs, int id)
{ fprintf(m->out, "\tbeqz %s, .L%d_%d\n", xn(rs), m->serial, id); }
void rv_mc_bnez(struct rv_mc *m, int rs, int id)
{ fprintf(m->out, "\tbnez %s, .L%d_%d\n", xn(rs), m->serial, id); }
void rv_mc_bne(struct rv_mc *m, int rs1, int rs2, int id)
{ fprintf(m->out, "\tbne %s, %s, .L%d_%d\n", xn(rs1), xn(rs2), m->serial, id); }
void rv_mc_ret(struct rv_mc *m) { fprintf(m->out, "\tret\n"); }
void rv_mc_jr(struct rv_mc *m, int rs) { fprintf(m->out, "\tjr %s\n", xn(rs)); }
void rv_mc_j_sym(struct rv_mc *m, const char *sym) { fprintf(m->out, "\tj %s\n", sym); }
void rv_mc_call(struct rv_mc *m, const char *sym) { fprintf(m->out, "\tjal ra, %s\n", sym); }
void rv_mc_jalr(struct rv_mc *m, int rs) { fprintf(m->out, "\tjalr ra, %s, 0\n", xn(rs)); }
void rv_mc_lea_label(struct rv_mc *m, int rd, int id)
{ fprintf(m->out, "\tla %s, .L%d_%d\n", xn(rd), m->serial, id); }

/****************************************************************
 * Moves / immediates / addresses
 ****************************************************************/

void rv_mc_li(struct rv_mc *m, int rd, long imm) { fprintf(m->out, "\tli %s, %ld\n", xn(rd), imm); }
void rv_mc_la(struct rv_mc *m, int rd, const char *sym) { fprintf(m->out, "\tla %s, %s\n", xn(rd), sym); }
void rv_mc_mv(struct rv_mc *m, int rd, int rs) { fprintf(m->out, "\tmv %s, %s\n", xn(rd), xn(rs)); }

void
rv_mc_addbig(struct rv_mc *m, int rd, int base, int imm)
{
    if (imm >= IMM12_MIN && imm <= IMM12_MAX) {
        fprintf(m->out, "\taddi %s, %s, %d\n", xn(rd), xn(base), imm);
        return;
    }
    fprintf(m->out, "\tli t6, %d\n", imm);
    fprintf(m->out, "\tadd %s, %s, t6\n", xn(rd), xn(base));
}

void rv_mc_addi(struct rv_mc *m, int rd, int rs, int imm) { fprintf(m->out, "\taddi %s, %s, %d\n", xn(rd), xn(rs), imm); }
void rv_mc_andi(struct rv_mc *m, int rd, int rs, int imm) { fprintf(m->out, "\tandi %s, %s, %d\n", xn(rd), xn(rs), imm); }
void rv_mc_xori(struct rv_mc *m, int rd, int rs, int imm) { fprintf(m->out, "\txori %s, %s, %d\n", xn(rd), xn(rs), imm); }
void rv_mc_srai(struct rv_mc *m, int rd, int rs, int shamt) { fprintf(m->out, "\tsrai %s, %s, %d\n", xn(rd), xn(rs), shamt); }

/****************************************************************
 * Integer arithmetic and logic
 ****************************************************************/

static void
r3(struct rv_mc *m, const char *mnem, int rd, int rs1, int rs2)
{ fprintf(m->out, "\t%s %s, %s, %s\n", mnem, xn(rd), xn(rs1), xn(rs2)); }

void rv_mc_add(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "add", rd, rs1, rs2); }
void rv_mc_sub(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "sub", rd, rs1, rs2); }
void rv_mc_mul(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "mul", rd, rs1, rs2); }
void rv_mc_and(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "and", rd, rs1, rs2); }
void rv_mc_or(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "or", rd, rs1, rs2); }
void rv_mc_xor(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "xor", rd, rs1, rs2); }
void rv_mc_sll(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "sll", rd, rs1, rs2); }
void rv_mc_sra(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "sra", rd, rs1, rs2); }
void rv_mc_srl(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "srl", rd, rs1, rs2); }
void rv_mc_div(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "div", rd, rs1, rs2); }
void rv_mc_divu(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "divu", rd, rs1, rs2); }
void rv_mc_rem(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "rem", rd, rs1, rs2); }
void rv_mc_remu(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "remu", rd, rs1, rs2); }
void rv_mc_slt(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "slt", rd, rs1, rs2); }
void rv_mc_sltu(struct rv_mc *m, int rd, int rs1, int rs2) { r3(m, "sltu", rd, rs1, rs2); }

void rv_mc_neg(struct rv_mc *m, int rd, int rs) { fprintf(m->out, "\tneg %s, %s\n", xn(rd), xn(rs)); }
void rv_mc_not(struct rv_mc *m, int rd, int rs) { fprintf(m->out, "\tnot %s, %s\n", xn(rd), xn(rs)); }
void rv_mc_seqz(struct rv_mc *m, int rd, int rs) { fprintf(m->out, "\tseqz %s, %s\n", xn(rd), xn(rs)); }
void rv_mc_snez(struct rv_mc *m, int rd, int rs) { fprintf(m->out, "\tsnez %s, %s\n", xn(rd), xn(rs)); }

/****************************************************************
 * Loads and stores
 ****************************************************************/

void rv_mc_lb(struct rv_mc *m, int rd, int base, int off) { memop(m, "lb", xn(rd), base, off); }
void rv_mc_lh(struct rv_mc *m, int rd, int base, int off) { memop(m, "lh", xn(rd), base, off); }
void rv_mc_lw(struct rv_mc *m, int rd, int base, int off) { memop(m, "lw", xn(rd), base, off); }
void rv_mc_lbu(struct rv_mc *m, int rd, int base, int off) { memop(m, "lbu", xn(rd), base, off); }
void rv_mc_lhu(struct rv_mc *m, int rd, int base, int off) { memop(m, "lhu", xn(rd), base, off); }
void rv_mc_sb(struct rv_mc *m, int rs, int base, int off) { memop(m, "sb", xn(rs), base, off); }
void rv_mc_sh(struct rv_mc *m, int rs, int base, int off) { memop(m, "sh", xn(rs), base, off); }
void rv_mc_sw(struct rv_mc *m, int rs, int base, int off) { memop(m, "sw", xn(rs), base, off); }

void rv_mc_flw(struct rv_mc *m, int frd, int base, int off) { memop(m, "flw", fnn(frd), base, off); }
void rv_mc_fld(struct rv_mc *m, int frd, int base, int off) { memop(m, "fld", fnn(frd), base, off); }
void rv_mc_flh(struct rv_mc *m, int frd, int base, int off) { memop(m, "flh", fnn(frd), base, off); }
void rv_mc_fsw(struct rv_mc *m, int frs, int base, int off) { memop(m, "fsw", fnn(frs), base, off); }
void rv_mc_fsd(struct rv_mc *m, int frs, int base, int off) { memop(m, "fsd", fnn(frs), base, off); }
void rv_mc_fsh(struct rv_mc *m, int frs, int base, int off) { memop(m, "fsh", fnn(frs), base, off); }

/****************************************************************
 * Float data processing
 ****************************************************************/

static void
f3(struct rv_mc *m, const char *base, int f32, int fd, int fs1, int fs2)
{ fprintf(m->out, "\t%s.%s %s, %s, %s\n", base, f32 ? "s" : "d", fnn(fd), fnn(fs1), fnn(fs2)); }

void rv_mc_fadd(struct rv_mc *m, int f32, int fd, int fs1, int fs2) { f3(m, "fadd", f32, fd, fs1, fs2); }
void rv_mc_fsub(struct rv_mc *m, int f32, int fd, int fs1, int fs2) { f3(m, "fsub", f32, fd, fs1, fs2); }
void rv_mc_fmul(struct rv_mc *m, int f32, int fd, int fs1, int fs2) { f3(m, "fmul", f32, fd, fs1, fs2); }
void rv_mc_fdiv(struct rv_mc *m, int f32, int fd, int fs1, int fs2) { f3(m, "fdiv", f32, fd, fs1, fs2); }

void rv_mc_fneg(struct rv_mc *m, int f32, int fd, int fs)
{ fprintf(m->out, "\tfneg.%s %s, %s\n", f32 ? "s" : "d", fnn(fd), fnn(fs)); }
void rv_mc_fabs(struct rv_mc *m, int f32, int fd, int fs)
{ fprintf(m->out, "\tfabs.%s %s, %s\n", f32 ? "s" : "d", fnn(fd), fnn(fs)); }

void rv_mc_feq(struct rv_mc *m, int f32, int rd, int fs1, int fs2)
{ fprintf(m->out, "\tfeq.%s %s, %s, %s\n", f32 ? "s" : "d", xn(rd), fnn(fs1), fnn(fs2)); }
void rv_mc_flt(struct rv_mc *m, int f32, int rd, int fs1, int fs2)
{ fprintf(m->out, "\tflt.%s %s, %s, %s\n", f32 ? "s" : "d", xn(rd), fnn(fs1), fnn(fs2)); }
void rv_mc_fle(struct rv_mc *m, int f32, int rd, int fs1, int fs2)
{ fprintf(m->out, "\tfle.%s %s, %s, %s\n", f32 ? "s" : "d", xn(rd), fnn(fs1), fnn(fs2)); }

void rv_mc_fcvt_f_w(struct rv_mc *m, int f32, int fd, int rs)
{ fprintf(m->out, "\tfcvt.%s.w %s, %s\n", f32 ? "s" : "d", fnn(fd), xn(rs)); }
void rv_mc_fcvt_w_f(struct rv_mc *m, int f32, int rd, int fs)
{ fprintf(m->out, "\tfcvt.w.%s %s, %s, rtz\n", f32 ? "s" : "d", xn(rd), fnn(fs)); }
void rv_mc_fcvt_d_s(struct rv_mc *m, int fd, int fs) { fprintf(m->out, "\tfcvt.d.s %s, %s\n", fnn(fd), fnn(fs)); }
void rv_mc_fcvt_s_d(struct rv_mc *m, int fd, int fs) { fprintf(m->out, "\tfcvt.s.d %s, %s\n", fnn(fd), fnn(fs)); }
void rv_mc_fcvt_d_h(struct rv_mc *m, int fd, int fs) { fprintf(m->out, "\tfcvt.d.h %s, %s\n", fnn(fd), fnn(fs)); }
void rv_mc_fcvt_h_d(struct rv_mc *m, int fd, int fs) { fprintf(m->out, "\tfcvt.h.d %s, %s\n", fnn(fd), fnn(fs)); }
void rv_mc_fmv_x_w(struct rv_mc *m, int rd, int fs) { fprintf(m->out, "\tfmv.x.w %s, %s\n", xn(rd), fnn(fs)); }
void rv_mc_fmv_w_x(struct rv_mc *m, int fd, int rs) { fprintf(m->out, "\tfmv.w.x %s, %s\n", fnn(fd), xn(rs)); }

/****************************************************************
 * Inline asm
 ****************************************************************/

void rv_mc_asm(struct rv_mc *m, const char *text) { fprintf(m->out, "%s\n", text); }

/****************************************************************
 * Globals (ported from rv_emit.c)
 ****************************************************************/

static void
emit_string_bytes(FILE *out, const char *s, int n)
{
    int k;

    fputs("\t.ascii \"", out);
    for (k = 0; k < n; k++) {
        unsigned char c = (unsigned char)s[k];
        if (c == '\\')
            fputs("\\\\", out);
        else if (c == '"')
            fputs("\\\"", out);
        else if (c == '\n')
            fputs("\\n", out);
        else if (c == '\t')
            fputs("\\t", out);
        else if (c == '\r')
            fputs("\\r", out);
        else if (c >= 0x20 && c < 0x7f)
            fputc(c, out);
        else
            fprintf(out, "\\%03o", c);
    }
    fputs("\"\n", out);
}

static void
emit_init_image(FILE *out, struct ir_global *g)
{
    struct ir_init *it;
    int cur = 0;

    for (it = g->inits; it; it = it->next) {
        if (it->offset > cur) {
            fprintf(out, "\t.space %d\n", it->offset - cur);
            cur = it->offset;
        }
        if (it->sym)
            fprintf(out, "\t.word %s\n", it->sym);
        else if (it->size == 8) {
            uint64_t b = (uint64_t)it->ival;
            fprintf(out, "\t.word 0x%08x\n", (unsigned)(b & 0xFFFFFFFF));
            fprintf(out, "\t.word 0x%08x\n", (unsigned)(b >> 32));
        } else if (it->size == 2)
            fprintf(out, "\t.short 0x%04x\n", (unsigned)(it->ival & 0xFFFF));
        else if (it->size == 1)
            fprintf(out, "\t.byte 0x%02x\n", (unsigned)(it->ival & 0xFF));
        else
            fprintf(out, "\t.word 0x%08x\n", (unsigned)it->ival);
        cur += it->size;
    }
    if (g->arr_size > cur)
        fprintf(out, "\t.space %d\n", g->arr_size - cur);
}

static void
emit_globals(FILE *out, struct ir_program *prog)
{
    struct ir_global *g;

    fputs("\n\t.data\n", out);
    for (g = prog->globals; g; g = g->next) {
        int elsz;

        switch (g->base_type) {
        case IR_I8:  elsz = 1; break;
        case IR_I16: elsz = 2; break;
        case IR_I64: elsz = 8; break;
        case IR_F64: elsz = 8; break;
        default:     elsz = 4; break;   /* incl. IR_F32 (4-byte bit pattern) */
        }

        {
            int alb = g->base_type == IR_F64 ? 8 : 4, e = 0;
            if (g->align > alb)
                alb = g->align;
            while ((1 << e) < alb)
                e++;
            fprintf(out, "\t.align %d\n", e);
        }
        if (!g->is_local)
            fprintf(out, "\t.globl %s\n", g->name);
        fprintf(out, "%s:\n", g->name);
        if (g->inits) {
            emit_init_image(out, g);
        } else if (g->init_string) {
            emit_string_bytes(out, g->init_string, g->init_strlen);
        } else if (g->init_count > 0) {
            int k;
            for (k = 0; k < g->init_count; k++) {
                if (g->init_syms && g->init_syms[k])
                    fprintf(out, "\t.word %s\n", g->init_syms[k]);
                else if (g->base_type == IR_I64 || g->base_type == IR_F64) {
                    uint64_t bits = (uint64_t)g->init_ivals[k];
                    fprintf(out, "\t.word 0x%08x\n", (unsigned)(bits & 0xFFFFFFFF));
                    fprintf(out, "\t.word 0x%08x\n", (unsigned)(bits >> 32));
                } else if (elsz == 1)
                    fprintf(out, "\t.byte %" PRId64 "\n", g->init_ivals[k]);
                else if (elsz == 2)
                    fprintf(out, "\t.short %" PRId64 "\n", g->init_ivals[k]);
                else
                    fprintf(out, "\t.word %" PRId64 "\n", g->init_ivals[k]);
            }
            if (g->arr_size > g->init_count)
                fprintf(out, "\t.space %d\n", (g->arr_size - g->init_count) * elsz);
        } else {
            int sz = (g->arr_size > 0) ? g->arr_size * elsz : elsz;
            fprintf(out, "\t.space %d\n", sz);
        }
    }
}

/****************************************************************
 * Entry point
 ****************************************************************/

void
target_emit(FILE *out, struct ir_program *prog)
{
    struct ir_func *fn;
    struct rv_mc *m;
    int serial = 0;

    fputs("# tinc: generated RISC-V (RV32IMFD + Zfh) assembly\n", out);

    m = rvt_new(out);
    if (!m) {
        fputs("rv_mc_text: out of memory\n", stderr);
        exit(1);
    }
    for (fn = prog->funcs; fn; fn = fn->next) {
        char err[128];

        fprintf(out, "\n\t.text\n\t.align 2\n");
        if (!fn->is_local)
            fprintf(out, "\t.globl %s\n", fn->name);
        fprintf(out, "%s:\n", fn->name);

        rvt_begin_func(m, ++serial);
        if (rv_select_func(m, fn, err, sizeof err) != 0) {
            fprintf(stderr, "rv_mc_text: %s\n", err);
            exit(1);
        }
    }
    rvt_free(m);

    emit_globals(out, prog);
}
