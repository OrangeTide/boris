/* rv_mc.h : the RISC-V RV32 machine-code sink, the output abstraction shared by
   the RISC-V instruction selector (backend/rv_select.c).

   One selector drives two sinks.  The text sink (backend/rv_mc_text.c) writes
   GAS assembly, the form the AOT compiler emits.  The byte sink (jit/jit_rv.c)
   writes machine code into a growable buffer, the form the in-process JIT runs.
   Both implement the operations declared here, so the selection logic is written
   once against hardware register numbers and calls rv_mc_* without knowing which
   sink it drives.  This is the RISC-V parallel of backend/mc.h (x86-64) and
   backend/arm64_mc.h (AArch64).

   Registers are hardware numbers 0..31 (x0..x31 for integer, f0..f31 for float).
   RV32 has no separate 32-bit register view, so no width flag rides an integer
   op; a float op carries an f32 flag selecting the .s / .d instruction suffix.
   Control flow is by label id; a call is by symbol (a module function or a
   runtime/host binding) or through a register.  The "smart" operations rv_mc_li,
   rv_mc_la, and the load/store family hide the forms that differ per sink: the
   text sink leans on the assembler (the li / la pseudo-instructions, in-range
   offsets); the byte sink materialises them (lui/addi, auipc/addi with a
   relocation, an out-of-range offset routed through a scratch base). */

#ifndef RV_MC_H
#define RV_MC_H

#include <stddef.h>

/* The sink is opaque here; each implementation defines its own struct rv_mc. */
struct rv_mc;

/* ---- Control flow by label id (forward references allowed). */
int rv_mc_new_label(struct rv_mc *m);
void rv_mc_label(struct rv_mc *m, int id);
void rv_mc_j(struct rv_mc *m, int id);
void rv_mc_beqz(struct rv_mc *m, int rs, int id);
void rv_mc_bnez(struct rv_mc *m, int rs, int id);
void rv_mc_bne(struct rv_mc *m, int rs1, int rs2, int id);
void rv_mc_ret(struct rv_mc *m);
void rv_mc_jr(struct rv_mc *m, int rs);              /* jr rs (tail, indirect) */
void rv_mc_j_sym(struct rv_mc *m, const char *sym);  /* j sym (tail, direct) */
void rv_mc_call(struct rv_mc *m, const char *sym);   /* jal ra, sym */
void rv_mc_jalr(struct rv_mc *m, int rs);            /* jalr ra, rs, 0 (call) */
void rv_mc_lea_label(struct rv_mc *m, int rd, int id); /* la rd, .Lid (a code addr) */

/* ---- Moves, immediates, addresses. */
void rv_mc_li(struct rv_mc *m, int rd, long imm);    /* li rd, imm (any 32-bit) */
void rv_mc_la(struct rv_mc *m, int rd, const char *sym); /* la rd, sym (a data/func addr) */
void rv_mc_mv(struct rv_mc *m, int rd, int rs);
void rv_mc_addbig(struct rv_mc *m, int rd, int base, int imm); /* addi + big fallback */
void rv_mc_addi(struct rv_mc *m, int rd, int rs, int imm);     /* plain addi (in range) */
void rv_mc_andi(struct rv_mc *m, int rd, int rs, int imm);
void rv_mc_xori(struct rv_mc *m, int rd, int rs, int imm);
void rv_mc_srai(struct rv_mc *m, int rd, int rs, int shamt);

/* ---- Integer three-register ops, rd = rs1 OP rs2. */
void rv_mc_add(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_sub(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_mul(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_and(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_or(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_xor(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_sll(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_sra(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_srl(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_div(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_divu(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_rem(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_remu(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_slt(struct rv_mc *m, int rd, int rs1, int rs2);
void rv_mc_sltu(struct rv_mc *m, int rd, int rs1, int rs2);

/* ---- Integer two-register pseudos. */
void rv_mc_neg(struct rv_mc *m, int rd, int rs);
void rv_mc_not(struct rv_mc *m, int rd, int rs);
void rv_mc_seqz(struct rv_mc *m, int rd, int rs);
void rv_mc_snez(struct rv_mc *m, int rd, int rs);

/* ---- Integer loads and stores, reg and base+off.  The sink selects a valid
   offset encoding, materialising a large offset through a scratch base. */
void rv_mc_lb(struct rv_mc *m, int rd, int base, int off);
void rv_mc_lh(struct rv_mc *m, int rd, int base, int off);
void rv_mc_lw(struct rv_mc *m, int rd, int base, int off);
void rv_mc_lbu(struct rv_mc *m, int rd, int base, int off);
void rv_mc_lhu(struct rv_mc *m, int rd, int base, int off);
void rv_mc_sb(struct rv_mc *m, int rs, int base, int off);
void rv_mc_sh(struct rv_mc *m, int rs, int base, int off);
void rv_mc_sw(struct rv_mc *m, int rs, int base, int off);

/* ---- Float loads and stores (float reg, base+off).  f32 picks flw/fsw vs
   fld/fsd; rv_mc_flh/fsh are the half-word forms (Zfh). */
void rv_mc_flw(struct rv_mc *m, int frd, int base, int off);
void rv_mc_fld(struct rv_mc *m, int frd, int base, int off);
void rv_mc_flh(struct rv_mc *m, int frd, int base, int off);
void rv_mc_fsw(struct rv_mc *m, int frs, int base, int off);
void rv_mc_fsd(struct rv_mc *m, int frs, int base, int off);
void rv_mc_fsh(struct rv_mc *m, int frs, int base, int off);

/* ---- Float data processing.  f32 selects .s (1) vs .d (0). */
void rv_mc_fadd(struct rv_mc *m, int f32, int fd, int fs1, int fs2);
void rv_mc_fsub(struct rv_mc *m, int f32, int fd, int fs1, int fs2);
void rv_mc_fmul(struct rv_mc *m, int f32, int fd, int fs1, int fs2);
void rv_mc_fdiv(struct rv_mc *m, int f32, int fd, int fs1, int fs2);
void rv_mc_fneg(struct rv_mc *m, int f32, int fd, int fs);
void rv_mc_fabs(struct rv_mc *m, int f32, int fd, int fs);
void rv_mc_feq(struct rv_mc *m, int f32, int rd, int fs1, int fs2);
void rv_mc_flt(struct rv_mc *m, int f32, int rd, int fs1, int fs2);
void rv_mc_fle(struct rv_mc *m, int f32, int rd, int fs1, int fs2);

/* ---- Float conversions and integer<->float bit moves. */
void rv_mc_fcvt_f_w(struct rv_mc *m, int f32, int fd, int rs);  /* fcvt.{s,d}.w (int->float) */
void rv_mc_fcvt_w_f(struct rv_mc *m, int f32, int rd, int fs);  /* fcvt.w.{s,d} rtz (float->int) */
void rv_mc_fcvt_d_s(struct rv_mc *m, int fd, int fs);           /* single -> double */
void rv_mc_fcvt_s_d(struct rv_mc *m, int fd, int fs);           /* double -> single */
void rv_mc_fcvt_d_h(struct rv_mc *m, int fd, int fs);           /* half -> double */
void rv_mc_fcvt_h_d(struct rv_mc *m, int fd, int fs);           /* double -> half */
void rv_mc_fmv_x_w(struct rv_mc *m, int rd, int fs);            /* int <- float bits */
void rv_mc_fmv_w_x(struct rv_mc *m, int fd, int rs);            /* float <- int bits */

/* ---- Inline assembly: emit a verbatim assembly string (text sink only; the
   byte sink reports it unsupported through its error channel). */
void rv_mc_asm(struct rv_mc *m, const char *text);

#endif /* RV_MC_H */
