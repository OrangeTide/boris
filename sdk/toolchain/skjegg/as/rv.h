/* rv.h : RISC-V RV32 assembler — shared types
 *
 * A second front end for the assembler skeleton (asm_lex.c + asm_obj.c),
 * beside the ColdFire one.  It reads the GAS-syntax subset the RISC-V backend
 * emits (RV32IMAFD + Zfh + Zicsr + Zba/Zbb/Zbs) and writes little-endian
 * ELF32 EM_RISCV relocatable objects. */

#ifndef RV_H
#define RV_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "arena.h"
#include "util.h"
#include "asm_lex.h"
#include "asm_obj.h"

/****************************************************************
 * RISC-V ELF relocation types
 ****************************************************************/

enum {
    R_RISCV_NONE = 0,
    R_RISCV_32 = 1,
    R_RISCV_BRANCH = 16,
    R_RISCV_JAL = 17,
    R_RISCV_CALL = 18,
    R_RISCV_CALL_PLT = 19,
    R_RISCV_PCREL_HI20 = 23,
    R_RISCV_PCREL_LO12_I = 24,
    R_RISCV_PCREL_LO12_S = 25,
    R_RISCV_HI20 = 26,
    R_RISCV_LO12_I = 27,
    R_RISCV_LO12_S = 28,
    R_RISCV_ADD32 = 35,
    R_RISCV_SUB32 = 39,
    R_RISCV_RELAX = 51,
};

/****************************************************************
 * Operands
 ****************************************************************/

enum rv_reloc_op {
    RELOC_OP_NONE,
    RELOC_OP_HI,            /* %hi(sym)        -> R_RISCV_HI20 */
    RELOC_OP_LO,            /* %lo(sym)        -> R_RISCV_LO12_I/S */
    RELOC_OP_PCREL_HI,      /* %pcrel_hi(sym)  -> R_RISCV_PCREL_HI20 */
    RELOC_OP_PCREL_LO,      /* %pcrel_lo(lbl)  -> R_RISCV_PCREL_LO12_I/S */
};

enum rv_op_kind {
    RVO_NONE,
    RVO_REG,                /* integer register x0..x31 */
    RVO_FREG,               /* float register f0..f31 */
    RVO_IMM,                /* immediate: literal, or reloc_op(sym) */
    RVO_SYM,                /* bare symbol (branch/jal/la/call target) */
    RVO_MEM,                /* offset(base): imm or reloc_op(sym), base reg */
    RVO_CSR,                /* control/status register (number in imm) */
};

struct rv_operand {
    int kind;
    int reg;                /* REG/FREG number, or MEM base register */
    long imm;               /* IMM/MEM literal offset */
    const char *sym;        /* SYM, or reloc_op symbol for IMM/MEM */
    int reloc_op;           /* enum rv_reloc_op */
};

/****************************************************************
 * Sections
 ****************************************************************/

enum rv_section_id {
    RSEC_TEXT,
    RSEC_DATA,
    RSEC_RODATA,
    RSEC_BSS,
    RSEC_COUNT,
};

/****************************************************************
 * Conditional-branch relaxation
 *
 * A B-type branch reaches only +/-4 KB.  When a target is farther the branch
 * is relaxed to an inverted branch over a jal (the range the backend relies on
 * the assembler to provide, as GNU as does).  The relaxation decision per
 * branch site is discovered by iterating a sizing pass to a fixpoint before
 * the emit pass.
 ****************************************************************/

struct rv_bsite {
    int section;
    uint32_t offset;        /* section-relative offset of the branch */
    const char *target;
};

/* A numeric local label (1:, 42:, referenced 1f/1b/42f/42b): one
 * redefinition counter per label number, grown as new numbers appear so any
 * non-negative label works, not just a single digit. */
struct rv_numlabel {
    int num;
    int count;
};

/****************************************************************
 * Assembler state
 ****************************************************************/

struct rv_asm {
    struct lexer lex;
    struct section sections[RSEC_COUNT];
    int cur_section;
    struct symtab st;
    int pass;
    int pcrel_serial;       /* counter for synthesized .Lpcrel_hi labels */

    struct rv_bsite *bsites; /* branch sites recorded during sizing passes */
    int nbsites;
    int bsite_cap;
    uint8_t *brelax;        /* per branch site: 1 = relaxed to branch+jal */
    int brelax_len;
    int bsite;              /* running branch-site index within a pass */
    int recording;          /* sizing pass records sites; emit pass does not */

    struct rv_numlabel *numlabels;  /* numeric local labels, keyed by number */
    int n_numlabels;
    int numlabel_cap;

    struct arena arena;
};

void rv_init(struct rv_asm *a, const char *src);
void rv_free(struct rv_asm *a);
char *rv_expand_macros(struct arena *a, const char *src);
void rv_assemble(struct rv_asm *a);     /* sizing + relaxation + emit passes */
void rv_note_branch(struct rv_asm *a, int section, uint32_t offset,
                    const char *target);

/****************************************************************
 * Encoder
 *
 * Returns the encoded byte length (always 4 for a base instruction, 8 for a
 * two-instruction pseudo like la/call/li-wide), or -1 if the mnemonic or its
 * operands cannot be encoded.  In pass 2 it emits into the current section and
 * records relocations; in pass 1 (emit == 0) it only reports the size.
 ****************************************************************/

int rv_encode(struct rv_asm *a, const char *mnemonic,
              struct rv_operand *ops, int nops, int emit);

/****************************************************************
 * ELF writer
 ****************************************************************/

void rv_elf_write(struct rv_asm *a, FILE *out);

/****************************************************************
 * Register name lookup (shared by parser and encoder helpers)
 ****************************************************************/

int rv_ireg(const char *name);          /* -1 if not an integer register */
int rv_freg(const char *name);          /* -1 if not a float register */
int rv_csr(const char *name);           /* -1 if not a known CSR name */

#endif
