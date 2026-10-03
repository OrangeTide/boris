/* rv_encode.c : RV32 instruction encoder
 *
 * Covers the RISC-V backend's full output plus the RV32 baseline: the RV32I
 * base, M, A, single/double/half float (F/D/Zfh), Zicsr, and the
 * Zba/Zbb/Zbs bit-manipulation extensions, together with the pseudo-
 * instructions the backend uses (li, la, call, mv, neg, not, seqz, snez, j,
 * jr, ret, nop, beqz, bnez, fmv/fneg/fabs).
 *
 * Base instructions are one 32-bit little-endian word; la/call and a wide li
 * expand to two words.  Intra-section branch and jump targets are resolved to
 * a PC-relative immediate in pass 2; cross-section and external references
 * emit a relocation instead. */

#include "rv.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Register names
 ****************************************************************/

int
rv_ireg(const char *name)
{
    static const char *abi[32] = {
        "zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
        "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
        "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
        "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6",
    };
    int k;

    if (strcmp(name, "fp") == 0)
        return 8;                       /* fp is an alias for s0 */
    for (k = 0; k < 32; k++) {
        if (strcmp(name, abi[k]) == 0)
            return k;
    }
    if (name[0] == 'x' && name[1]) {
        char *end;
        long n = strtol(name + 1, &end, 10);
        if (*end == '\0' && n >= 0 && n < 32)
            return (int)n;
    }
    return -1;
}

int
rv_freg(const char *name)
{
    static const char *abi[32] = {
        "ft0", "ft1", "ft2", "ft3", "ft4", "ft5", "ft6", "ft7",
        "fs0", "fs1", "fa0", "fa1", "fa2", "fa3", "fa4", "fa5",
        "fa6", "fa7", "fs2", "fs3", "fs4", "fs5", "fs6", "fs7",
        "fs8", "fs9", "fs10", "fs11", "ft8", "ft9", "ft10", "ft11",
    };
    int k;

    for (k = 0; k < 32; k++) {
        if (strcmp(name, abi[k]) == 0)
            return k;
    }
    if (name[0] == 'f' && name[1] >= '0' && name[1] <= '9') {
        char *end;
        long n = strtol(name + 1, &end, 10);
        if (*end == '\0' && n >= 0 && n < 32)
            return (int)n;
    }
    return -1;
}

int
rv_csr(const char *name)
{
    static const struct { const char *n; int v; } csrs[] = {
        { "fflags", 0x001 }, { "frm", 0x002 }, { "fcsr", 0x003 },
        { "cycle", 0xc00 }, { "time", 0xc01 }, { "instret", 0xc02 },
        { "cycleh", 0xc80 }, { "timeh", 0xc81 }, { "instreth", 0xc82 },
        { "mstatus", 0x300 }, { "misa", 0x301 }, { "mie", 0x304 },
        { "mtvec", 0x305 }, { "mscratch", 0x340 }, { "mepc", 0x341 },
        { "mcause", 0x342 }, { "mtval", 0x343 }, { "mip", 0x344 },
        { "mvendorid", 0xf11 }, { "marchid", 0xf12 }, { "mimpid", 0xf13 },
        { "mhartid", 0xf14 },
    };
    size_t k;

    for (k = 0; k < sizeof(csrs) / sizeof(csrs[0]); k++) {
        if (strcmp(name, csrs[k].n) == 0)
            return csrs[k].v;
    }
    return -1;
}

/* Rounding-mode operand name to its 3-bit funct3 encoding. */
static int
rv_roundmode(const char *name)
{
    if (strcmp(name, "rne") == 0) return 0;
    if (strcmp(name, "rtz") == 0) return 1;
    if (strcmp(name, "rdn") == 0) return 2;
    if (strcmp(name, "rup") == 0) return 3;
    if (strcmp(name, "rmm") == 0) return 4;
    if (strcmp(name, "dyn") == 0) return 7;
    return -1;
}

/****************************************************************
 * Instruction-format field packers
 ****************************************************************/

static uint32_t
enc_r(int op, int f3, int f7, int rd, int rs1, int rs2)
{
    return (uint32_t)op | ((uint32_t)rd << 7) | ((uint32_t)f3 << 12) |
           ((uint32_t)rs1 << 15) | ((uint32_t)rs2 << 20) | ((uint32_t)f7 << 25);
}

static uint32_t
enc_i(int op, int f3, int rd, int rs1, int imm)
{
    return (uint32_t)op | ((uint32_t)rd << 7) | ((uint32_t)f3 << 12) |
           ((uint32_t)rs1 << 15) | (((uint32_t)imm & 0xfff) << 20);
}

static uint32_t
enc_s(int op, int f3, int rs1, int rs2, int imm)
{
    return (uint32_t)op | (((uint32_t)imm & 0x1f) << 7) | ((uint32_t)f3 << 12) |
           ((uint32_t)rs1 << 15) | ((uint32_t)rs2 << 20) |
           ((((uint32_t)imm >> 5) & 0x7f) << 25);
}

static uint32_t
enc_b(int op, int f3, int rs1, int rs2, int imm)
{
    return (uint32_t)op |
           ((((uint32_t)imm >> 11) & 1) << 7) |
           ((((uint32_t)imm >> 1) & 0xf) << 8) |
           ((uint32_t)f3 << 12) | ((uint32_t)rs1 << 15) | ((uint32_t)rs2 << 20) |
           ((((uint32_t)imm >> 5) & 0x3f) << 25) |
           ((((uint32_t)imm >> 12) & 1) << 31);
}

static uint32_t
enc_u(int op, int rd, int imm20)
{
    return (uint32_t)op | ((uint32_t)rd << 7) |
           (((uint32_t)imm20 & 0xfffff) << 12);
}

static uint32_t
enc_j(int op, int rd, int imm)
{
    return (uint32_t)op | ((uint32_t)rd << 7) |
           ((((uint32_t)imm >> 12) & 0xff) << 12) |
           ((((uint32_t)imm >> 11) & 1) << 20) |
           ((((uint32_t)imm >> 1) & 0x3ff) << 21) |
           ((((uint32_t)imm >> 20) & 1) << 31);
}

/****************************************************************
 * Emission and relocation helpers
 ****************************************************************/

static struct section *
cur(struct rv_asm *a)
{
    return &a->sections[a->cur_section];
}

static void
emit_word(struct rv_asm *a, uint32_t w)
{
    sec_emit32(cur(a), w);
}

static void
reloc_sym(struct rv_asm *a, uint32_t off, const char *name,
          int32_t addend, int type)
{
    int idx = sym_lookup(&a->st, name);
    if (idx < 0)
        idx = sym_add(&a->st, name);
    sec_add_reloc_t(cur(a), off, idx, addend, type);
}

/* Synthesize a local label at the given section offset and return its name,
 * for pairing a %pcrel_lo relocation with its %pcrel_hi partner. */
static const char *
new_pcrel_label(struct rv_asm *a, uint32_t off)
{
    char buf[32];
    const char *name;
    int idx;

    snprintf(buf, sizeof(buf), ".Lpcrel_hi%d", a->pcrel_serial++);
    name = arena_strdup(&a->arena, buf);
    idx = sym_lookup(&a->st, name);
    if (idx < 0)
        idx = sym_add(&a->st, name);
    sym_define(&a->st, idx, a->cur_section, off);
    return name;
}

/* Displacement for a branch/jump target, emitting a relocation unless the
 * target is defined in the current section (then the displacement is final).
 * The returned displacement uses the symbol's in-object value (0 if
 * undefined), which is what GAS writes into the instruction before the linker
 * patches it, so a relocated instruction's bytes still match GAS. */
static int32_t
branch_disp(struct rv_asm *a, const char *target, uint32_t here, int reloc_type)
{
    int idx = sym_lookup(&a->st, target);
    int defined = idx >= 0 && a->st.syms[idx].defined;
    int same = defined && a->st.syms[idx].section == a->cur_section;
    int32_t symval = defined ? (int32_t)a->st.syms[idx].value : 0;
    int32_t disp = symval - (int32_t)here;

    if (!same) {
        reloc_sym(a, here, target, 0, reloc_type);
        return disp;    /* placeholder; the linker checks the final range */
    }

    /* An in-section target is final now, so a jump that cannot reach is a
     * hard error rather than a truncated displacement.  A conditional branch
     * out of range should already have been relaxed. */
    if (reloc_type == R_RISCV_JAL) {
        if (disp < -1048576 || disp > 1048574)
            die("jump to '%s' out of range (displacement %d)", target, disp);
    } else if (disp < -4096 || disp > 4094) {
        die("branch to '%s' out of range (displacement %d)", target, disp);
    }
    return disp;
}

/****************************************************************
 * Operand accessors with validation
 ****************************************************************/

#define NEED(cond) do { if (!(cond)) return -1; } while (0)

static int
is_reg(struct rv_operand *o) { return o && o->kind == RVO_REG; }
static int
is_freg(struct rv_operand *o) { return o && o->kind == RVO_FREG; }
static int
is_imm(struct rv_operand *o) { return o && o->kind == RVO_IMM; }
static int
is_mem(struct rv_operand *o) { return o && o->kind == RVO_MEM; }
static int
is_sym(struct rv_operand *o) { return o && o->kind == RVO_SYM; }

/* The symbol name for an operand in a symbol position (a branch/jump/la/call
 * target).  A bare symbol is obvious; a register-spelled name is a symbol here
 * too (a C global named like a register), so its kept spelling is used. */
static const char *
sym_target(struct rv_operand *o)
{
    if (!o)
        return NULL;
    if (o->kind == RVO_SYM || o->kind == RVO_REG || o->kind == RVO_FREG)
        return o->sym;
    return NULL;
}

/****************************************************************
 * Encoders by instruction group
 ****************************************************************/

/* Return 1 if the mnemonic is one of the listed strings. */
static int
in3(const char *m, const char *a1, const char *a2, const char *a3)
{
    return strcmp(m, a1) == 0 || (a2 && strcmp(m, a2) == 0) ||
           (a3 && strcmp(m, a3) == 0);
}

/* R-type OP (integer register-register), M, Zba/Zbb/Zbs register forms. */
static int
enc_op_rrr(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
           int emit)
{
    int op = 0x33, f3 = -1, f7 = 0;

    NEED(nops == 3 && is_reg(&ops[0]) && is_reg(&ops[1]) && is_reg(&ops[2]));

    /* base RV32I */
    if (strcmp(m, "add") == 0)  { f3 = 0; f7 = 0x00; }
    else if (strcmp(m, "sub") == 0)  { f3 = 0; f7 = 0x20; }
    else if (strcmp(m, "sll") == 0)  { f3 = 1; f7 = 0x00; }
    else if (strcmp(m, "slt") == 0)  { f3 = 2; f7 = 0x00; }
    else if (strcmp(m, "sltu") == 0) { f3 = 3; f7 = 0x00; }
    else if (strcmp(m, "xor") == 0)  { f3 = 4; f7 = 0x00; }
    else if (strcmp(m, "srl") == 0)  { f3 = 5; f7 = 0x00; }
    else if (strcmp(m, "sra") == 0)  { f3 = 5; f7 = 0x20; }
    else if (strcmp(m, "or") == 0)   { f3 = 6; f7 = 0x00; }
    else if (strcmp(m, "and") == 0)  { f3 = 7; f7 = 0x00; }
    /* M */
    else if (strcmp(m, "mul") == 0)    { f3 = 0; f7 = 0x01; }
    else if (strcmp(m, "mulh") == 0)   { f3 = 1; f7 = 0x01; }
    else if (strcmp(m, "mulhsu") == 0) { f3 = 2; f7 = 0x01; }
    else if (strcmp(m, "mulhu") == 0)  { f3 = 3; f7 = 0x01; }
    else if (strcmp(m, "div") == 0)    { f3 = 4; f7 = 0x01; }
    else if (strcmp(m, "divu") == 0)   { f3 = 5; f7 = 0x01; }
    else if (strcmp(m, "rem") == 0)    { f3 = 6; f7 = 0x01; }
    else if (strcmp(m, "remu") == 0)   { f3 = 7; f7 = 0x01; }
    /* Zba */
    else if (strcmp(m, "sh1add") == 0) { f3 = 2; f7 = 0x10; }
    else if (strcmp(m, "sh2add") == 0) { f3 = 4; f7 = 0x10; }
    else if (strcmp(m, "sh3add") == 0) { f3 = 6; f7 = 0x10; }
    /* Zbb */
    else if (strcmp(m, "andn") == 0)   { f3 = 7; f7 = 0x20; }
    else if (strcmp(m, "orn") == 0)    { f3 = 6; f7 = 0x20; }
    else if (strcmp(m, "xnor") == 0)   { f3 = 4; f7 = 0x20; }
    else if (strcmp(m, "min") == 0)    { f3 = 4; f7 = 0x05; }
    else if (strcmp(m, "minu") == 0)   { f3 = 5; f7 = 0x05; }
    else if (strcmp(m, "max") == 0)    { f3 = 6; f7 = 0x05; }
    else if (strcmp(m, "maxu") == 0)   { f3 = 7; f7 = 0x05; }
    else if (strcmp(m, "rol") == 0)    { f3 = 1; f7 = 0x30; }
    else if (strcmp(m, "ror") == 0)    { f3 = 5; f7 = 0x30; }
    /* Zbs */
    else if (strcmp(m, "bclr") == 0)   { f3 = 1; f7 = 0x24; }
    else if (strcmp(m, "bext") == 0)   { f3 = 5; f7 = 0x24; }
    else if (strcmp(m, "binv") == 0)   { f3 = 1; f7 = 0x34; }
    else if (strcmp(m, "bset") == 0)   { f3 = 1; f7 = 0x14; }
    else return -1;

    if (emit)
        emit_word(a, enc_r(op, f3, f7, ops[0].reg, ops[1].reg, ops[2].reg));
    return 4;
}

/* Zbb single-operand register ops (rd, rs). */
static int
enc_op_rr(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
          int emit)
{
    int f7 = -1, rs2 = 0, f3 = 1, op = 0x13;

    NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));

    if (strcmp(m, "clz") == 0)        { f7 = 0x30; rs2 = 0x00; }
    else if (strcmp(m, "ctz") == 0)   { f7 = 0x30; rs2 = 0x01; }
    else if (strcmp(m, "cpop") == 0)  { f7 = 0x30; rs2 = 0x02; }
    else if (strcmp(m, "sext.b") == 0){ f7 = 0x30; rs2 = 0x04; }
    else if (strcmp(m, "sext.h") == 0){ f7 = 0x30; rs2 = 0x05; }
    else if (strcmp(m, "orc.b") == 0) { f7 = 0x14; rs2 = 0x07; f3 = 5; }
    else if (strcmp(m, "rev8") == 0)  { f7 = 0x34; rs2 = 0x18; f3 = 5; }
    else if (strcmp(m, "zext.h") == 0){ f7 = 0x04; rs2 = 0x00; f3 = 4; op = 0x33; }
    else return -1;

    if (emit) {
        if (op == 0x33)
            emit_word(a, enc_r(op, f3, f7, ops[0].reg, ops[1].reg, rs2));
        else
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg,
                               (f7 << 5) | rs2));
    }
    return 4;
}

/* OP-IMM: addi/slti/... and the shift-immediate and Zbs-immediate forms. */
static int
enc_op_imm(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
           int emit)
{
    int f3 = -1, shift = 0, sh_f7 = 0, op = 0x13;

    NEED(nops == 3 && is_reg(&ops[0]) && is_reg(&ops[1]) && is_imm(&ops[2]));

    if (strcmp(m, "addi") == 0)       f3 = 0;
    else if (strcmp(m, "slti") == 0)  f3 = 2;
    else if (strcmp(m, "sltiu") == 0) f3 = 3;
    else if (strcmp(m, "xori") == 0)  f3 = 4;
    else if (strcmp(m, "ori") == 0)   f3 = 6;
    else if (strcmp(m, "andi") == 0)  f3 = 7;
    else if (strcmp(m, "slli") == 0)  { f3 = 1; shift = 1; sh_f7 = 0x00; }
    else if (strcmp(m, "srli") == 0)  { f3 = 5; shift = 1; sh_f7 = 0x00; }
    else if (strcmp(m, "srai") == 0)  { f3 = 5; shift = 1; sh_f7 = 0x20; }
    else if (strcmp(m, "rori") == 0)  { f3 = 5; shift = 1; sh_f7 = 0x30; }
    else if (strcmp(m, "bclri") == 0) { f3 = 1; shift = 1; sh_f7 = 0x24; }
    else if (strcmp(m, "bexti") == 0) { f3 = 5; shift = 1; sh_f7 = 0x24; }
    else if (strcmp(m, "binvi") == 0) { f3 = 1; shift = 1; sh_f7 = 0x34; }
    else if (strcmp(m, "bseti") == 0) { f3 = 1; shift = 1; sh_f7 = 0x14; }
    else return -1;

    /* an immediate with a relocation operator (addi rd, rs, %lo(sym)) */
    if (ops[2].reloc_op != RELOC_OP_NONE) {
        NEED(!shift);
        if (emit) {
            uint32_t off = (uint32_t)cur(a)->len;
            int type = ops[2].reloc_op == RELOC_OP_LO ? R_RISCV_LO12_I
                     : ops[2].reloc_op == RELOC_OP_PCREL_LO ? R_RISCV_PCREL_LO12_I
                     : -1;
            NEED(type >= 0);
            reloc_sym(a, off, ops[2].sym, (int32_t)ops[2].imm, type);
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg, 0));
        }
        return 4;
    }

    if (shift) {
        int shamt = (int)ops[2].imm;
        NEED(shamt >= 0 && shamt < 32);
        if (emit)
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg,
                               (sh_f7 << 5) | shamt));
        return 4;
    }

    {
        int imm = (int)ops[2].imm;
        if (imm < -2048 || imm > 2047)
            die("'%s' immediate %d out of range [-2048, 2047]", m, imm);
        if (emit)
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg, imm));
    }
    return 4;
}

/* Loads: lb/lh/lw/lbu/lhu and the float loads flw/fld/flh. */
static int
enc_load(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
         int emit)
{
    int f3 = -1, op = 0x03, fp = 0;

    if (strcmp(m, "lb") == 0)       f3 = 0;
    else if (strcmp(m, "lh") == 0)  f3 = 1;
    else if (strcmp(m, "lw") == 0)  f3 = 2;
    else if (strcmp(m, "lbu") == 0) f3 = 4;
    else if (strcmp(m, "lhu") == 0) f3 = 5;
    else if (strcmp(m, "flh") == 0) { f3 = 1; op = 0x07; fp = 1; }
    else if (strcmp(m, "flw") == 0) { f3 = 2; op = 0x07; fp = 1; }
    else if (strcmp(m, "fld") == 0) { f3 = 3; op = 0x07; fp = 1; }
    else return -1;

    NEED(nops == 2 && is_mem(&ops[1]));
    NEED(fp ? is_freg(&ops[0]) : is_reg(&ops[0]));

    if (ops[1].reloc_op != RELOC_OP_NONE) {
        if (emit) {
            uint32_t off = (uint32_t)cur(a)->len;
            int type = ops[1].reloc_op == RELOC_OP_LO ? R_RISCV_LO12_I
                     : ops[1].reloc_op == RELOC_OP_PCREL_LO ? R_RISCV_PCREL_LO12_I
                     : -1;
            NEED(type >= 0);
            reloc_sym(a, off, ops[1].sym, (int32_t)ops[1].imm, type);
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg, 0));
        }
        return 4;
    }

    {
        int imm = (int)ops[1].imm;
        if (imm < -2048 || imm > 2047)
            die("'%s' offset %d out of range [-2048, 2047]", m, imm);
        if (emit)
            emit_word(a, enc_i(op, f3, ops[0].reg, ops[1].reg, imm));
    }
    return 4;
}

/* Stores: sb/sh/sw and the float stores fsw/fsd/fsh. */
static int
enc_store(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
          int emit)
{
    int f3 = -1, op = 0x23, fp = 0;

    if (strcmp(m, "sb") == 0)       f3 = 0;
    else if (strcmp(m, "sh") == 0)  f3 = 1;
    else if (strcmp(m, "sw") == 0)  f3 = 2;
    else if (strcmp(m, "fsh") == 0) { f3 = 1; op = 0x27; fp = 1; }
    else if (strcmp(m, "fsw") == 0) { f3 = 2; op = 0x27; fp = 1; }
    else if (strcmp(m, "fsd") == 0) { f3 = 3; op = 0x27; fp = 1; }
    else return -1;

    NEED(nops == 2 && is_mem(&ops[1]));
    NEED(fp ? is_freg(&ops[0]) : is_reg(&ops[0]));

    if (ops[1].reloc_op != RELOC_OP_NONE) {
        if (emit) {
            uint32_t off = (uint32_t)cur(a)->len;
            int type = ops[1].reloc_op == RELOC_OP_LO ? R_RISCV_LO12_S
                     : ops[1].reloc_op == RELOC_OP_PCREL_LO ? R_RISCV_PCREL_LO12_S
                     : -1;
            NEED(type >= 0);
            reloc_sym(a, off, ops[1].sym, (int32_t)ops[1].imm, type);
            emit_word(a, enc_s(op, f3, ops[1].reg, ops[0].reg, 0));
        }
        return 4;
    }

    {
        int imm = (int)ops[1].imm;
        if (imm < -2048 || imm > 2047)
            die("'%s' offset %d out of range [-2048, 2047]", m, imm);
        if (emit)
            emit_word(a, enc_s(op, f3, ops[1].reg, ops[0].reg, imm));
    }
    return 4;
}

/* Branches: beq/bne/blt/bge/bltu/bgeu and the pseudo beqz/bnez. */
static int
enc_branch(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
           int emit)
{
    int f3 = -1, rs1, rs2;
    const char *target;
    /* form: 0 = two-reg, 1 = swapped two-reg, 2 = (rs, target) with x0 as
     * the second operand, 3 = (rs, target) with x0 as the first operand */
    int form = 0, swap = 0;

    if (strcmp(m, "beq") == 0)       f3 = 0;
    else if (strcmp(m, "bne") == 0)  f3 = 1;
    else if (strcmp(m, "blt") == 0)  f3 = 4;
    else if (strcmp(m, "bge") == 0)  f3 = 5;
    else if (strcmp(m, "bltu") == 0) f3 = 6;
    else if (strcmp(m, "bgeu") == 0) f3 = 7;
    /* swapped-operand pseudos */
    else if (strcmp(m, "bgt") == 0)  { f3 = 4; swap = 1; }
    else if (strcmp(m, "ble") == 0)  { f3 = 5; swap = 1; }
    else if (strcmp(m, "bgtu") == 0) { f3 = 6; swap = 1; }
    else if (strcmp(m, "bleu") == 0) { f3 = 7; swap = 1; }
    /* compare-with-zero pseudos */
    else if (strcmp(m, "beqz") == 0) { f3 = 0; form = 2; }
    else if (strcmp(m, "bnez") == 0) { f3 = 1; form = 2; }
    else if (strcmp(m, "blez") == 0) { f3 = 5; form = 3; } /* bge x0, rs */
    else if (strcmp(m, "bgez") == 0) { f3 = 5; form = 2; } /* bge rs, x0 */
    else if (strcmp(m, "bltz") == 0) { f3 = 4; form = 2; } /* blt rs, x0 */
    else if (strcmp(m, "bgtz") == 0) { f3 = 4; form = 3; } /* blt x0, rs */
    else return -1;

    if (form == 2) {
        NEED(nops == 2 && is_reg(&ops[0]) && sym_target(&ops[1]));
        rs1 = ops[0].reg; rs2 = 0; target = sym_target(&ops[1]);
    } else if (form == 3) {
        NEED(nops == 2 && is_reg(&ops[0]) && sym_target(&ops[1]));
        rs1 = 0; rs2 = ops[0].reg; target = sym_target(&ops[1]);
    } else {
        NEED(nops == 3 && is_reg(&ops[0]) && is_reg(&ops[1])
             && sym_target(&ops[2]));
        rs1 = ops[0].reg;
        rs2 = ops[1].reg;
        target = sym_target(&ops[2]);
        if (swap) { int t = rs1; rs1 = rs2; rs2 = t; }
    }

    {
        int site = a->bsite++;
        int relaxed = (site < a->brelax_len) ? a->brelax[site] : 0;
        uint32_t off = (uint32_t)cur(a)->len;

        if (a->recording)
            rv_note_branch(a, a->cur_section, off, target);

        if (!emit)
            return relaxed ? 8 : 4;

        if (relaxed) {
            /* invert the condition and branch over a jal that reaches far */
            int32_t jdisp;
            emit_word(a, enc_b(0x63, f3 ^ 1, rs1, rs2, 8));
            jdisp = branch_disp(a, target, off + 4, R_RISCV_JAL);
            emit_word(a, enc_j(0x6f, 0, jdisp));
            return 8;
        }
        emit_word(a, enc_b(0x63, f3, rs1, rs2,
                           branch_disp(a, target, off, R_RISCV_BRANCH)));
    }
    return 4;
}

/* jal rd, target  and the pseudo  j target. */
static int
enc_jal(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
        int emit)
{
    int rd;
    const char *target;

    if (strcmp(m, "j") != 0 && strcmp(m, "jal") != 0)
        return -1;

    if (strcmp(m, "j") == 0) {
        NEED(nops == 1 && sym_target(&ops[0]));
        rd = 0;
        target = sym_target(&ops[0]);
    } else {                            /* jal */
        if (nops == 1) {                /* jal target  (rd defaults to ra) */
            NEED(sym_target(&ops[0]));
            rd = 1;
            target = sym_target(&ops[0]);
        } else {
            NEED(nops == 2 && is_reg(&ops[0]) && sym_target(&ops[1]));
            rd = ops[0].reg;
            target = sym_target(&ops[1]);
        }
    }

    if (emit) {
        uint32_t off = (uint32_t)cur(a)->len;
        int32_t disp = branch_disp(a, target, off, R_RISCV_JAL);
        emit_word(a, enc_j(0x6f, rd, disp));
    }
    return 4;
}

/* jalr rd, rs1, imm  and the pseudos jr rs / ret. */
static int
enc_jalr(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
         int emit)
{
    int rd, rs1, imm = 0;

    if (strcmp(m, "ret") == 0) {
        NEED(nops == 0);
        rd = 0; rs1 = 1;                /* jalr x0, ra, 0 */
    } else if (strcmp(m, "jr") == 0) {
        NEED(nops == 1 && is_reg(&ops[0]));
        rd = 0; rs1 = ops[0].reg;
    } else {                            /* jalr */
        if (nops == 1) {                /* jalr rs1  (rd=ra, imm=0) */
            NEED(is_reg(&ops[0]));
            rd = 1; rs1 = ops[0].reg;
        } else {
            NEED(nops == 3 && is_reg(&ops[0]) && is_reg(&ops[1])
                 && is_imm(&ops[2]) && ops[2].reloc_op == RELOC_OP_NONE);
            rd = ops[0].reg; rs1 = ops[1].reg; imm = (int)ops[2].imm;
        }
    }

    if (imm < -2048 || imm > 2047)
        die("'%s' immediate %d out of range [-2048, 2047]", m, imm);
    if (emit)
        emit_word(a, enc_i(0x67, 0, rd, rs1, imm));
    return 4;
}

/* Float R-type (arith, sign-inject, min/max, compares, conversions, moves). */
static int
enc_float(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
          int emit)
{
    /* fmt bits [26:25]: 00 = s, 01 = d, 10 = h */
    int op = 0x53;

    /* three-register arithmetic */
    struct { const char *n; int f7; } arith[] = {
        { "fadd.s", 0x00 }, { "fsub.s", 0x04 }, { "fmul.s", 0x08 },
        { "fdiv.s", 0x0c },
        { "fadd.d", 0x01 }, { "fsub.d", 0x05 }, { "fmul.d", 0x09 },
        { "fdiv.d", 0x0d },
        { "fadd.h", 0x02 }, { "fsub.h", 0x06 }, { "fmul.h", 0x0a },
        { "fdiv.h", 0x0e },
    };
    struct { const char *n; int f7; int f3; } signi[] = {
        { "fsgnj.s", 0x10, 0 }, { "fsgnjn.s", 0x10, 1 }, { "fsgnjx.s", 0x10, 2 },
        { "fsgnj.d", 0x11, 0 }, { "fsgnjn.d", 0x11, 1 }, { "fsgnjx.d", 0x11, 2 },
        { "fsgnj.h", 0x12, 0 }, { "fsgnjn.h", 0x12, 1 }, { "fsgnjx.h", 0x12, 2 },
        { "fmin.s", 0x14, 0 }, { "fmax.s", 0x14, 1 },
        { "fmin.d", 0x15, 0 }, { "fmax.d", 0x15, 1 },
        { "fmin.h", 0x16, 0 }, { "fmax.h", 0x16, 1 },
    };
    struct { const char *n; int f7; int f3; } cmp[] = {
        { "fle.s", 0x50, 0 }, { "flt.s", 0x50, 1 }, { "feq.s", 0x50, 2 },
        { "fle.d", 0x51, 0 }, { "flt.d", 0x51, 1 }, { "feq.d", 0x51, 2 },
        { "fle.h", 0x52, 0 }, { "flt.h", 0x52, 1 }, { "feq.h", 0x52, 2 },
    };
    size_t k;

    for (k = 0; k < sizeof(arith) / sizeof(arith[0]); k++) {
        if (strcmp(m, arith[k].n) == 0) {
            NEED(nops == 3 && is_freg(&ops[0]) && is_freg(&ops[1])
                 && is_freg(&ops[2]));
            if (emit)                   /* rm = dyn (7), as GAS defaults */
                emit_word(a, enc_r(op, 7, arith[k].f7, ops[0].reg,
                                   ops[1].reg, ops[2].reg));
            return 4;
        }
    }
    for (k = 0; k < sizeof(signi) / sizeof(signi[0]); k++) {
        if (strcmp(m, signi[k].n) == 0) {
            NEED(nops == 3 && is_freg(&ops[0]) && is_freg(&ops[1])
                 && is_freg(&ops[2]));
            if (emit)
                emit_word(a, enc_r(op, signi[k].f3, signi[k].f7, ops[0].reg,
                                   ops[1].reg, ops[2].reg));
            return 4;
        }
    }
    for (k = 0; k < sizeof(cmp) / sizeof(cmp[0]); k++) {
        if (strcmp(m, cmp[k].n) == 0) {
            NEED(nops == 3 && is_reg(&ops[0]) && is_freg(&ops[1])
                 && is_freg(&ops[2]));
            if (emit)
                emit_word(a, enc_r(op, cmp[k].f3, cmp[k].f7, ops[0].reg,
                                   ops[1].reg, ops[2].reg));
            return 4;
        }
    }

    /* fsqrt.{s,d,h} rd, rs (rs2 field = 0) */
    if (in3(m, "fsqrt.s", "fsqrt.d", "fsqrt.h")) {
        int f7 = m[6] == 's' ? 0x2c : m[6] == 'd' ? 0x2d : 0x2e;
        NEED(nops == 2 && is_freg(&ops[0]) && is_freg(&ops[1]));
        if (emit)                       /* rm = dyn */
            emit_word(a, enc_r(op, 7, f7, ops[0].reg, ops[1].reg, 0));
        return 4;
    }

    /* fclass.{s,d,h} rd(int), rs(float): funct7 0x70/0x71/0x72, rs2=0, f3=1 */
    if (in3(m, "fclass.s", "fclass.d", "fclass.h")) {
        int f7 = m[7] == 's' ? 0x70 : m[7] == 'd' ? 0x71 : 0x72;
        NEED(nops == 2 && is_reg(&ops[0]) && is_freg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(op, 1, f7, ops[0].reg, ops[1].reg, 0));
        return 4;
    }

    /* moves between int and float registers */
    if (in3(m, "fmv.x.w", "fmv.x.h", NULL)) {   /* rd int, rs float */
        int f7 = strcmp(m, "fmv.x.w") == 0 ? 0x70 : 0x72;
        NEED(nops == 2 && is_reg(&ops[0]) && is_freg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(op, 0, f7, ops[0].reg, ops[1].reg, 0));
        return 4;
    }
    if (in3(m, "fmv.w.x", "fmv.h.x", NULL)) {   /* rd float, rs int */
        int f7 = strcmp(m, "fmv.w.x") == 0 ? 0x78 : 0x7a;
        NEED(nops == 2 && is_freg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(op, 0, f7, ops[0].reg, ops[1].reg, 0));
        return 4;
    }

    /* conversions: float<->int and float<->float */
    {
        /* rm: the funct3 rounding field GAS emits by default -- dyn (7) where
         * the conversion may round, rne (0) where it is exact (widening or
         * an integer that fits). */
        struct { const char *n; int f7; int rs2; int rd_int; int rs_int; int rm; } cv[] = {
            /* float from int */
            { "fcvt.s.w", 0x68, 0, 0, 1, 7 }, { "fcvt.s.wu", 0x68, 1, 0, 1, 7 },
            { "fcvt.d.w", 0x69, 0, 0, 1, 0 }, { "fcvt.d.wu", 0x69, 1, 0, 1, 0 },
            { "fcvt.h.w", 0x6a, 0, 0, 1, 7 }, { "fcvt.h.wu", 0x6a, 1, 0, 1, 7 },
            /* int from float */
            { "fcvt.w.s", 0x60, 0, 1, 0, 7 }, { "fcvt.wu.s", 0x60, 1, 1, 0, 7 },
            { "fcvt.w.d", 0x61, 0, 1, 0, 7 }, { "fcvt.wu.d", 0x61, 1, 1, 0, 7 },
            { "fcvt.w.h", 0x62, 0, 1, 0, 7 }, { "fcvt.wu.h", 0x62, 1, 1, 0, 7 },
            /* float width conversions (narrow rounds, widen is exact) */
            { "fcvt.s.d", 0x20, 1, 0, 0, 7 }, { "fcvt.d.s", 0x21, 0, 0, 0, 0 },
            { "fcvt.s.h", 0x20, 2, 0, 0, 0 }, { "fcvt.h.s", 0x22, 0, 0, 0, 7 },
            { "fcvt.d.h", 0x21, 2, 0, 0, 0 }, { "fcvt.h.d", 0x22, 1, 0, 0, 7 },
        };
        for (k = 0; k < sizeof(cv) / sizeof(cv[0]); k++) {
            if (strcmp(m, cv[k].n) == 0) {
                int rm = cv[k].rm;
                NEED(nops == 2 || nops == 3);
                NEED(cv[k].rd_int ? is_reg(&ops[0]) : is_freg(&ops[0]));
                NEED(cv[k].rs_int ? is_reg(&ops[1]) : is_freg(&ops[1]));
                /* an explicit rounding-mode operand overrides (rtz, rne...) */
                if (nops == 3) {
                    if (is_imm(&ops[2]))
                        rm = (int)ops[2].imm;
                    else if (is_sym(&ops[2]))
                        rm = rv_roundmode(ops[2].sym);
                    NEED(rm >= 0);
                }
                if (emit)
                    emit_word(a, enc_r(op, rm, cv[k].f7, ops[0].reg,
                                       ops[1].reg, cv[k].rs2));
                return 4;
            }
        }
    }

    return -1;
}

/* Fused multiply-add family: fmadd/fmsub/fnmsub/fnmadd .{s,d,h}. */
static int
enc_fma(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
        int emit)
{
    int op = -1, fmt;
    const char *dot;

    if (strncmp(m, "fmadd.", 6) == 0)       op = 0x43;
    else if (strncmp(m, "fmsub.", 6) == 0)  op = 0x47;
    else if (strncmp(m, "fnmsub.", 7) == 0) op = 0x4b;
    else if (strncmp(m, "fnmadd.", 7) == 0) op = 0x4f;
    else return -1;

    dot = strrchr(m, '.');
    fmt = dot[1] == 's' ? 0 : dot[1] == 'd' ? 1 : dot[1] == 'h' ? 2 : -1;
    NEED(fmt >= 0);
    NEED(nops == 4 && is_freg(&ops[0]) && is_freg(&ops[1])
         && is_freg(&ops[2]) && is_freg(&ops[3]));
    if (emit) {
        uint32_t w = (uint32_t)op | ((uint32_t)ops[0].reg << 7) |
                     (7u << 12) |               /* rm = dyn */
                     ((uint32_t)ops[1].reg << 15) |
                     ((uint32_t)ops[2].reg << 20) |
                     ((uint32_t)fmt << 25) |
                     ((uint32_t)ops[3].reg << 27);
        emit_word(a, w);
    }
    return 4;
}

/* CSR access: csrrw/csrrs/csrrc (register) and *i (immediate) forms. */
static int
enc_csr(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
        int emit)
{
    int f3 = -1, imm_form = 0;

    if (strcmp(m, "csrrw") == 0)       f3 = 1;
    else if (strcmp(m, "csrrs") == 0)  f3 = 2;
    else if (strcmp(m, "csrrc") == 0)  f3 = 3;
    else if (strcmp(m, "csrrwi") == 0) { f3 = 5; imm_form = 1; }
    else if (strcmp(m, "csrrsi") == 0) { f3 = 6; imm_form = 1; }
    else if (strcmp(m, "csrrci") == 0) { f3 = 7; imm_form = 1; }
    else return -1;

    NEED(nops == 3 && is_reg(&ops[0]));
    NEED(imm_form ? is_imm(&ops[2]) : is_reg(&ops[2]));

    {
        int csrnum;
        if (ops[1].kind == RVO_CSR || is_imm(&ops[1]))
            csrnum = (int)ops[1].imm;
        else if (is_sym(&ops[1]))
            csrnum = rv_csr(ops[1].sym);
        else
            return -1;
        NEED(csrnum >= 0);
        if (emit) {
            int src = imm_form ? ((int)ops[2].imm & 0x1f) : ops[2].reg;
            emit_word(a, enc_i(0x73, f3, ops[0].reg, src, csrnum));
        }
    }
    return 4;
}

/* lui / auipc (rd, imm20 or reloc-operator). */
static int
enc_u_type(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
           int emit)
{
    int op;

    if (strcmp(m, "lui") == 0)        op = 0x37;
    else if (strcmp(m, "auipc") == 0) op = 0x17;
    else return -1;

    NEED(nops == 2 && is_reg(&ops[0]) && is_imm(&ops[1]));

    if (ops[1].reloc_op != RELOC_OP_NONE) {
        if (emit) {
            uint32_t off = (uint32_t)cur(a)->len;
            int type = ops[1].reloc_op == RELOC_OP_HI ? R_RISCV_HI20
                     : ops[1].reloc_op == RELOC_OP_PCREL_HI ? R_RISCV_PCREL_HI20
                     : -1;
            NEED(type >= 0);
            reloc_sym(a, off, ops[1].sym, (int32_t)ops[1].imm, type);
            emit_word(a, enc_u(op, ops[0].reg, 0));
        }
        return 4;
    }
    if (emit)
        emit_word(a, enc_u(op, ops[0].reg, (int)ops[1].imm));
    return 4;
}

/* Atomic memory operations (word forms). */
static int
enc_amo(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
        int emit)
{
    int f5 = -1, lr = 0;

    if (strcmp(m, "lr.w") == 0)        { f5 = 0x02; lr = 1; }
    else if (strcmp(m, "sc.w") == 0)      f5 = 0x03;
    else if (strcmp(m, "amoswap.w") == 0) f5 = 0x01;
    else if (strcmp(m, "amoadd.w") == 0)  f5 = 0x00;
    else if (strcmp(m, "amoxor.w") == 0)  f5 = 0x04;
    else if (strcmp(m, "amoand.w") == 0)  f5 = 0x0c;
    else if (strcmp(m, "amoor.w") == 0)   f5 = 0x08;
    else if (strcmp(m, "amomin.w") == 0)  f5 = 0x10;
    else if (strcmp(m, "amomax.w") == 0)  f5 = 0x14;
    else if (strcmp(m, "amominu.w") == 0) f5 = 0x18;
    else if (strcmp(m, "amomaxu.w") == 0) f5 = 0x1c;
    else return -1;

    if (lr) {
        /* lr.w rd, (rs1)  -- rs2 field is zero */
        NEED(nops == 2 && is_reg(&ops[0]) && is_mem(&ops[1])
             && ops[1].imm == 0);
        if (emit)
            emit_word(a, enc_r(0x2f, 2, f5 << 2, ops[0].reg, ops[1].reg, 0));
    } else {
        /* op rd, rs2, (rs1) */
        NEED(nops == 3 && is_reg(&ops[0]) && is_reg(&ops[1])
             && is_mem(&ops[2]) && ops[2].imm == 0);
        if (emit)
            emit_word(a, enc_r(0x2f, 2, f5 << 2, ops[0].reg, ops[2].reg,
                               ops[1].reg));
    }
    return 4;
}

/* li rd, imm : one addi, one lui, or lui+addi depending on the value. */
static int
enc_li(struct rv_asm *a, struct rv_operand *ops, int nops, int emit)
{
    int32_t imm, hi, lo;

    NEED(nops == 2 && is_reg(&ops[0]) && is_imm(&ops[1])
         && ops[1].reloc_op == RELOC_OP_NONE);
    imm = (int32_t)ops[1].imm;

    if (imm >= -2048 && imm <= 2047) {
        if (emit)
            emit_word(a, enc_i(0x13, 0, ops[0].reg, 0, imm));  /* addi rd,x0,imm */
        return 4;
    }

    hi = (imm + 0x800) >> 12;
    lo = imm - (hi << 12);              /* sign-extended low 12 bits */
    if (lo == 0) {
        if (emit)
            emit_word(a, enc_u(0x37, ops[0].reg, hi));         /* lui rd, hi */
        return 4;
    }
    if (emit) {
        emit_word(a, enc_u(0x37, ops[0].reg, hi));             /* lui rd, hi */
        emit_word(a, enc_i(0x13, 0, ops[0].reg, ops[0].reg, lo)); /* addi */
    }
    return 8;
}

/* la rd, sym : auipc rd, %pcrel_hi(sym) ; addi rd, rd, %pcrel_lo(.Lpcrel). */
static int
enc_la(struct rv_asm *a, struct rv_operand *ops, int nops, int emit)
{
    NEED(nops == 2 && is_reg(&ops[0]) && sym_target(&ops[1]));
    if (emit) {
        uint32_t hi_off = (uint32_t)cur(a)->len;
        const char *label = new_pcrel_label(a, hi_off);
        reloc_sym(a, hi_off, sym_target(&ops[1]), 0, R_RISCV_PCREL_HI20);
        emit_word(a, enc_u(0x17, ops[0].reg, 0));              /* auipc */
        reloc_sym(a, (uint32_t)cur(a)->len, label, 0, R_RISCV_PCREL_LO12_I);
        emit_word(a, enc_i(0x13, 0, ops[0].reg, ops[0].reg, 0)); /* addi */
    }
    return 8;
}

/* call sym : auipc ra, 0 ; jalr ra, ra, 0  with one R_RISCV_CALL_PLT. */
static int
enc_call(struct rv_asm *a, struct rv_operand *ops, int nops, int emit)
{
    NEED(nops == 1 && sym_target(&ops[0]));
    if (emit) {
        uint32_t off = (uint32_t)cur(a)->len;
        reloc_sym(a, off, sym_target(&ops[0]), 0, R_RISCV_CALL_PLT);
        emit_word(a, enc_u(0x17, 1, 0));                       /* auipc ra, 0 */
        emit_word(a, enc_i(0x67, 0, 1, 1, 0));                 /* jalr ra, ra, 0 */
    }
    return 8;
}

/****************************************************************
 * Top-level dispatch
 ****************************************************************/

int
rv_encode(struct rv_asm *a, const char *m, struct rv_operand *ops, int nops,
          int emit)
{
    int r;

    /* register-move and simple pseudos rewritten to a base instruction */
    if (strcmp(m, "mv") == 0) {          /* addi rd, rs, 0 */
        NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_i(0x13, 0, ops[0].reg, ops[1].reg, 0));
        return 4;
    }
    if (strcmp(m, "neg") == 0) {         /* sub rd, x0, rs */
        NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(0x33, 0, 0x20, ops[0].reg, 0, ops[1].reg));
        return 4;
    }
    if (strcmp(m, "not") == 0) {         /* xori rd, rs, -1 */
        NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_i(0x13, 4, ops[0].reg, ops[1].reg, -1));
        return 4;
    }
    if (strcmp(m, "seqz") == 0) {        /* sltiu rd, rs, 1 */
        NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_i(0x13, 3, ops[0].reg, ops[1].reg, 1));
        return 4;
    }
    if (strcmp(m, "snez") == 0) {        /* sltu rd, x0, rs */
        NEED(nops == 2 && is_reg(&ops[0]) && is_reg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(0x33, 3, 0x00, ops[0].reg, 0, ops[1].reg));
        return 4;
    }
    if (strcmp(m, "nop") == 0) {         /* addi x0, x0, 0 */
        NEED(nops == 0);
        if (emit)
            emit_word(a, enc_i(0x13, 0, 0, 0, 0));
        return 4;
    }
    if (strcmp(m, "fmv.s") == 0 || strcmp(m, "fmv.d") == 0
        || strcmp(m, "fmv.h") == 0) {    /* fsgnj.x rd, rs, rs */
        int f7 = m[4] == 's' ? 0x10 : m[4] == 'd' ? 0x11 : 0x12;
        NEED(nops == 2 && is_freg(&ops[0]) && is_freg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(0x53, 0, f7, ops[0].reg, ops[1].reg,
                               ops[1].reg));
        return 4;
    }
    if (strcmp(m, "fneg.s") == 0 || strcmp(m, "fneg.d") == 0
        || strcmp(m, "fneg.h") == 0) {   /* fsgnjn.x rd, rs, rs */
        int f7 = m[5] == 's' ? 0x10 : m[5] == 'd' ? 0x11 : 0x12;
        NEED(nops == 2 && is_freg(&ops[0]) && is_freg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(0x53, 1, f7, ops[0].reg, ops[1].reg,
                               ops[1].reg));
        return 4;
    }
    if (strcmp(m, "fabs.s") == 0 || strcmp(m, "fabs.d") == 0
        || strcmp(m, "fabs.h") == 0) {   /* fsgnjx.x rd, rs, rs */
        int f7 = m[5] == 's' ? 0x10 : m[5] == 'd' ? 0x11 : 0x12;
        NEED(nops == 2 && is_freg(&ops[0]) && is_freg(&ops[1]));
        if (emit)
            emit_word(a, enc_r(0x53, 2, f7, ops[0].reg, ops[1].reg,
                               ops[1].reg));
        return 4;
    }

    if (strcmp(m, "li") == 0)   return enc_li(a, ops, nops, emit);
    if (strcmp(m, "la") == 0)   return enc_la(a, ops, nops, emit);
    if (strcmp(m, "call") == 0) return enc_call(a, ops, nops, emit);

    if (strcmp(m, "ecall") == 0) {
        NEED(nops == 0);
        if (emit) emit_word(a, 0x00000073);
        return 4;
    }
    if (strcmp(m, "ebreak") == 0) {
        NEED(nops == 0);
        if (emit) emit_word(a, 0x00100073);
        return 4;
    }
    if (strcmp(m, "fence") == 0) {
        NEED(nops == 0);                 /* fence iorw, iorw */
        if (emit) emit_word(a, 0x0ff0000f);
        return 4;
    }
    if (strcmp(m, "fence.i") == 0) {
        NEED(nops == 0);
        if (emit) emit_word(a, 0x0000100f);
        return 4;
    }

    if ((r = enc_op_rrr(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_op_rr(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_op_imm(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_load(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_store(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_branch(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_jal(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_jalr(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_u_type(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_amo(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_csr(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_float(a, m, ops, nops, emit)) != -1) return r;
    if ((r = enc_fma(a, m, ops, nops, emit)) != -1) return r;

    return -1;
}
