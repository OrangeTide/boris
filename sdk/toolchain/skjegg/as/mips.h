/* mips.h : MIPS I (R2000/R3000, little-endian, o32) assembler — shared types
 *
 * A third front end for the assembler skeleton (asm_lex.c + asm_obj.c), beside
 * the ColdFire and RISC-V ones.  It reads the GAS-syntax subset the MIPS I
 * backend emits and writes little-endian ELF32 EM_MIPS relocatable objects.
 *
 * This header describes the full assembler; the source files are built up in
 * steps (see doc/mips.md "First sub-step").  Step 1 supplies the driver, the
 * two-pass state, the register lookups and a tokenizing assemble pass; the
 * encoder, the ELF writer, macro expansion and the .set reorder engine follow. */

#ifndef MIPS_H
#define MIPS_H

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#include "arena.h"
#include "util.h"
#include "asm_lex.h"
#include "asm_obj.h"

/****************************************************************
 * MIPS ELF relocation types
 ****************************************************************/

enum {
    R_MIPS_NONE = 0,
    R_MIPS_16 = 1,
    R_MIPS_32 = 2,
    R_MIPS_26 = 4,          /* jal/j target (26-bit word address) */
    R_MIPS_HI16 = 5,        /* high 16 bits, paired with the next LO16 */
    R_MIPS_LO16 = 6,        /* low 16 bits */
    R_MIPS_PC16 = 10,       /* signed 16-bit PC-relative branch */
};

/****************************************************************
 * Operands
 ****************************************************************/

enum mips_reloc_op {
    MRELOC_OP_NONE,
    MRELOC_OP_HI,           /* %hi(sym) -> R_MIPS_HI16 */
    MRELOC_OP_LO,           /* %lo(sym) -> R_MIPS_LO16 */
};

enum mips_op_kind {
    MO_NONE,
    MO_REG,                 /* integer register $0..$31 */
    MO_FREG,                /* float register $f0..$f31 */
    MO_IMM,                 /* immediate: literal, or reloc_op(sym) */
    MO_SYM,                 /* bare symbol (branch/jal/la target) */
    MO_MEM,                 /* offset(base): imm or reloc_op(sym), base reg */
};

struct mips_operand {
    int kind;
    int reg;                /* REG/FREG number, or MEM base register */
    long imm;               /* IMM/MEM literal offset */
    const char *sym;        /* SYM, or reloc_op symbol for IMM/MEM */
    int reloc_op;           /* enum mips_reloc_op */
};

/****************************************************************
 * Sections
 ****************************************************************/

enum mips_section_id {
    MSEC_TEXT,
    MSEC_DATA,
    MSEC_RODATA,
    MSEC_BSS,
    MSEC_COUNT,
};

/****************************************************************
 * Assembler state
 ****************************************************************/

struct mips_asm {
    struct lexer lex;
    struct section sections[MSEC_COUNT];
    int cur_section;
    struct symtab st;
    int pass;

    const char *sched_src;  /* the source after delay-slot scheduling */
    struct arena arena;
};

void mips_init(struct mips_asm *a, const char *src);
void mips_free(struct mips_asm *a);
void mips_assemble(struct mips_asm *a);

/* Fill the branch and load delay slots in the .set reorder regions of src,
 * returning the rewritten source (arena-allocated). */
char *mips_schedule(struct arena *a, const char *src);

/****************************************************************
 * Encoder (later step)
 ****************************************************************/

int mips_encode(struct mips_asm *a, const char *mnemonic,
                struct mips_operand *ops, int nops, int emit);

/****************************************************************
 * ELF writer (later step)
 ****************************************************************/

void mips_elf_write(struct mips_asm *a, FILE *out);

/****************************************************************
 * Register name lookup (shared by parser and encoder helpers)
 ****************************************************************/

int mips_ireg(const char *name);    /* -1 if not an integer register */
int mips_freg(const char *name);    /* -1 if not a float register */

#endif
