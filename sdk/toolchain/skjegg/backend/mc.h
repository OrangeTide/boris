/* mc.h : the machine-code sink, the output abstraction shared by the x86-64
   instruction selector (backend/x86_select.c).

   One selector drives two sinks.  The text sink (backend/mc_text.c) writes GAS
   assembly, the form the AOT compiler emits.  The byte sink (jit/mc_bytes.c)
   writes machine code into a growable buffer, the form the in-process JIT runs.
   Both implement the operations declared here, so the selector is written once
   against register numbers and calls mc_* without knowing which sink it drives.

   Registers are numbers, not names or encodings: the allocatable integer file
   is rbx/r12/r13/r14/r15, the scratch file rax/rcx/rdx, and the SSE file
   xmm0..15, named by the enums below (the same numbering both sinks use).  The
   width of an integer operation rides the opcode (a 32-bit op zeroes the upper
   half, so an i32 result stays address-clean), not the operand.

   Control flow is by label id, not by encoded displacement: the selector asks
   for a branch to a label and the sink resolves it (the text sink prints a
   label reference, the byte sink records a fixup).  A call is by symbol: a
   local call names a function defined in the same program, an extern call names
   a runtime symbol or host binding, and the sink turns each into the form it
   needs. */

#ifndef MC_H
#define MC_H

#include <stddef.h>
#include <stdint.h>

/* Hardware integer register numbers (ModRM/REX encoding order). */
enum mc_reg {
    MC_RAX = 0, MC_RCX = 1, MC_RDX = 2, MC_RBX = 3,
    MC_RSP = 4, MC_RBP = 5, MC_RSI = 6, MC_RDI = 7,
    MC_R8 = 8, MC_R9 = 9, MC_R10 = 10, MC_R11 = 11,
    MC_R12 = 12, MC_R13 = 13, MC_R14 = 14, MC_R15 = 15,
};

/* SSE register numbers. */
enum mc_xmm {
    MC_XMM0 = 0, MC_XMM1, MC_XMM2, MC_XMM3, MC_XMM4, MC_XMM5, MC_XMM6, MC_XMM7,
    MC_XMM8, MC_XMM9, MC_XMM10, MC_XMM11, MC_XMM12, MC_XMM13, MC_XMM14, MC_XMM15,
};

/* Condition codes (the low nibble of the Jcc/SETcc opcodes). */
enum mc_cc {
    MC_O = 0x0, MC_NO = 0x1, MC_B = 0x2, MC_AE = 0x3,
    MC_E = 0x4, MC_NE = 0x5, MC_BE = 0x6, MC_A = 0x7,
    MC_S = 0x8, MC_NS = 0x9, MC_P = 0xA, MC_NP = 0xB,
    MC_L = 0xC, MC_GE = 0xD, MC_LE = 0xE, MC_G = 0xF,
};

/* The sink is opaque here; each implementation defines its own struct mc. */
struct mc;

/* ---- Data movement.  _ri32 zero-extends a 32-bit immediate to 64 bits (an
   i32 constant); _ri64 loads a full 64-bit immediate (an address or an i64). */
void mc_mov_ri32(struct mc *m, int reg, uint32_t imm);
void mc_mov_ri64(struct mc *m, int reg, uint64_t imm);
void mc_mov_rr(struct mc *m, int dst, int src);       /* 64-bit reg move */
void mc_mov32_rr(struct mc *m, int dst, int src);     /* 32-bit reg move */

/* ---- Integer arithmetic and logic, dst = dst OP src.  The 32-bit forms run on
   the low half and zero-extend the result (keeping i32 values address-clean);
   the 64-bit forms are for i64 values and address arithmetic. */
void mc_add32_rr(struct mc *m, int dst, int src);
void mc_sub32_rr(struct mc *m, int dst, int src);
void mc_and32_rr(struct mc *m, int dst, int src);
void mc_or32_rr(struct mc *m, int dst, int src);
void mc_xor32_rr(struct mc *m, int dst, int src);
void mc_imul32_rr(struct mc *m, int dst, int src);
void mc_neg32_r(struct mc *m, int reg);
void mc_not32_r(struct mc *m, int reg);

void mc_add_rr(struct mc *m, int dst, int src);
void mc_sub_rr(struct mc *m, int dst, int src);
void mc_and_rr(struct mc *m, int dst, int src);
void mc_or_rr(struct mc *m, int dst, int src);
void mc_xor_rr(struct mc *m, int dst, int src);
void mc_imul_rr(struct mc *m, int dst, int src);
void mc_neg_r(struct mc *m, int reg);
void mc_not_r(struct mc *m, int reg);

/* dst OP= imm32 (sign-extended into 64 bits). */
void mc_add_ri32(struct mc *m, int reg, int32_t imm);
void mc_sub_ri32(struct mc *m, int reg, int32_t imm);

/* ---- Division.  cqo/cdq sign-extend rax into rdx:rax / edx:eax before idiv;
   an unsigned divide zeroes rdx/edx first (the selector emits that as a plain
   xor).  Quotient in rax/eax, remainder in rdx/edx. */
void mc_cqo(struct mc *m);
void mc_cdq(struct mc *m);
void mc_idiv_r(struct mc *m, int reg);
void mc_idiv32_r(struct mc *m, int reg);
void mc_div_r(struct mc *m, int reg);
void mc_div32_r(struct mc *m, int reg);

/* ---- Shifts by the count in cl. */
void mc_shl_cl(struct mc *m, int reg);
void mc_sar_cl(struct mc *m, int reg);
void mc_shr_cl(struct mc *m, int reg);
void mc_shl32_cl(struct mc *m, int reg);
void mc_sar32_cl(struct mc *m, int reg);
void mc_shr32_cl(struct mc *m, int reg);

/* ---- Compare and condition materialization. */
void mc_cmp_rr(struct mc *m, int a, int b);
void mc_test_rr(struct mc *m, int a, int b);
void mc_cmp32_rr(struct mc *m, int a, int b);
void mc_test32_rr(struct mc *m, int a, int b);
void mc_setcc_r(struct mc *m, int cc, int reg);       /* 0/1 byte into reg's low byte */
void mc_movzx_rb(struct mc *m, int dst, int src);     /* zero-extend low byte to 32 */
void mc_movsxd_rr(struct mc *m, int dst, int src);    /* sign-extend 32 to 64 */

/* ---- Memory.  Sub-word loads extend into a 32-bit result; sub-word stores
   write the register's low byte / low 16 bits.  The 32-bit access is for i32
   slots, the 64-bit for a pointer or i64 slot.  A load/store address is
   base+disp. */
void mc_load8(struct mc *m, int dst, int base, int32_t disp);
void mc_load8s(struct mc *m, int dst, int base, int32_t disp);
void mc_load16(struct mc *m, int dst, int base, int32_t disp);
void mc_load16s(struct mc *m, int dst, int base, int32_t disp);
void mc_store8(struct mc *m, int base, int32_t disp, int src);
void mc_store16(struct mc *m, int base, int32_t disp, int src);
void mc_load32(struct mc *m, int dst, int base, int32_t disp);
void mc_store32(struct mc *m, int base, int32_t disp, int src);
void mc_load64(struct mc *m, int dst, int base, int32_t disp);
void mc_store64(struct mc *m, int base, int32_t disp, int src);
void mc_lea(struct mc *m, int dst, int base, int32_t disp);   /* dst = base+disp */

/* ---- Stack. */
void mc_push_r(struct mc *m, int reg);
void mc_pop_r(struct mc *m, int reg);

/* ---- Control flow by label id.  mc_new_label allocates a fresh label (for
   both the IR's labels and the selector's own internal branches); mc_label
   marks it at the current position; the branch ops target a label the sink
   resolves (forward references allowed).  mc_ret / mc_leave / mc_nop are the
   plain instructions; mc_call_reg / mc_jmp_reg are indirect. */
int mc_new_label(struct mc *m);
void mc_label(struct mc *m, int id);
void mc_jmp(struct mc *m, int id);
void mc_jcc(struct mc *m, int cc, int id);
void mc_ret(struct mc *m);
void mc_leave(struct mc *m);
void mc_nop(struct mc *m);
void mc_call_reg(struct mc *m, int reg);
void mc_jmp_reg(struct mc *m, int reg);

/* ---- Call a named function.  The sink turns it into the right form: the text
   sink always emits `call name` (the linker resolves it); the byte sink emits a
   direct rel32 + relocation for a function defined in this program, or loads a
   host binding's address and calls through it for a runtime symbol. */
void mc_call_sym(struct mc *m, const char *name);

/* ---- Load the address of a symbol (a data global or a function's code) into
   an integer register.  The byte sink resolves a global to its mapped address
   or records a code-pointer fixup; the text sink emits `lea reg, [name]`. */
void mc_lea_sym(struct mc *m, int reg, const char *name);

/* ---- The two arithmetic traps, emitted at a guard site: each raises the fault
   and does not return.  The sink calls its runtime's helper. */
void mc_trap_div_zero(struct mc *m);
void mc_trap_overflow(struct mc *m);

/* ---- A source-line marker: records that code from here on comes from `line`
   (the byte sink builds an address-to-line table for traps; the text sink may
   ignore it). */
void mc_loc(struct mc *m, int line);

/* ---- Double-precision SSE (f64). */
void mc_movsd_rr(struct mc *m, int dst, int src);
void mc_movsd_load(struct mc *m, int dst, int base, int32_t disp);
void mc_movsd_store(struct mc *m, int base, int32_t disp, int src);
void mc_addsd_rr(struct mc *m, int dst, int src);
void mc_subsd_rr(struct mc *m, int dst, int src);
void mc_mulsd_rr(struct mc *m, int dst, int src);
void mc_divsd_rr(struct mc *m, int dst, int src);
void mc_ucomisd_rr(struct mc *m, int a, int b);
void mc_cvtsi2sd(struct mc *m, int xmm_dst, int gpr_src);
void mc_sqrtsd_rr(struct mc *m, int dst, int src);
void mc_cvttsd2si(struct mc *m, int gpr_dst, int xmm_src);   /* truncate f64->i32 */
void mc_cvtsd2si(struct mc *m, int gpr_dst, int xmm_src);    /* round f64->i32 */

/* ---- Single-precision SSE (f32) and the width converts. */
void mc_movss_load(struct mc *m, int dst, int base, int32_t disp);
void mc_movss_store(struct mc *m, int base, int32_t disp, int src);
void mc_addss_rr(struct mc *m, int dst, int src);
void mc_subss_rr(struct mc *m, int dst, int src);
void mc_mulss_rr(struct mc *m, int dst, int src);
void mc_divss_rr(struct mc *m, int dst, int src);
void mc_ucomiss_rr(struct mc *m, int a, int b);
void mc_cvtsi2ss(struct mc *m, int xmm_dst, int gpr_src);
void mc_cvttss2si(struct mc *m, int gpr_dst, int xmm_src);
void mc_cvtss2sd_rr(struct mc *m, int xmm_dst, int xmm_src);       /* widen f32->f64 */
void mc_cvtsd2ss_rr(struct mc *m, int xmm_dst, int xmm_src);       /* narrow f64->f32 */
void mc_cvtss2sd_load(struct mc *m, int xmm_dst, int base, int32_t disp);

/* movq between a 64-bit GPR and an xmm (for the sign-bit fabs/fneg through a
   GPR, and any raw f64 bit move). */
void mc_movq_from_xmm(struct mc *m, int gpr_dst, int xmm_src);
void mc_movq_to_xmm(struct mc *m, int xmm_dst, int gpr_src);

/* movd: the low 32 bits between a 32-bit GPR and an xmm (the _Float16 softfloat
   glue moves single-precision bits to and from the helper's integer ABI). */
void mc_movd_from_xmm(struct mc *m, int gpr_dst, int xmm_src);
void mc_movd_to_xmm(struct mc *m, int xmm_dst, int gpr_src);

/* ---- Inline assembly: emit a verbatim assembly string (basic asm, no
   operands).  The text sink writes the line; the byte sink has no assembler and
   reports the string unsupported through its error channel. */
void mc_asm(struct mc *m, const char *text);

#endif /* MC_H */
