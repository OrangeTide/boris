/* asm_obj.h : arch-neutral object bookkeeping shared by the assemblers.
 *
 * Sections, symbols and relocations, plus the byte-emission and symbol-table
 * helpers.  The section emitter is endianness-aware (a per-section flag) so
 * the same helpers serve the big-endian m68k output and the little-endian
 * RISC-V output.  A relocation carries a target-specific type code; the m68k
 * ELF writer ignores it (it emits a single R_68K_32), the RISC-V writer keys
 * on it. */

#ifndef ASM_OBJ_H
#define ASM_OBJ_H

#include <stdint.h>

#include "arena.h"

/****************************************************************
 * Sections
 ****************************************************************/

struct reloc {
    uint32_t offset;
    int sym_idx;
    int32_t addend;
    int type;               /* target relocation type (0 = default) */
};

struct section {
    uint8_t *data;
    int len;
    int cap;
    int align;              /* max byte alignment requested (0 = default) */
    int little_endian;      /* byte order for sec_emit16/32 (0 = big) */
    struct reloc *relocs;
    int nrelocs;
    int reloc_cap;
};

void sec_emit8(struct section *s, uint8_t val);
void sec_emit16(struct section *s, uint16_t val);
void sec_emit32(struct section *s, uint32_t val);
void sec_align(struct section *s, int alignment);
void sec_space(struct section *s, int nbytes);
void sec_add_reloc(struct section *s, uint32_t offset, int sym_idx,
                   int32_t addend);
void sec_add_reloc_t(struct section *s, uint32_t offset, int sym_idx,
                     int32_t addend, int type);

/****************************************************************
 * Symbols
 ****************************************************************/

struct symbol {
    const char *name;
    int section;
    uint32_t value;
    int global;
    int defined;
};

struct symtab {
    struct symbol *syms;
    int nsyms;
    int cap;
    struct arena *arena;
};

int sym_lookup(struct symtab *st, const char *name);
int sym_add(struct symtab *st, const char *name);
void sym_define(struct symtab *st, int idx, int section, uint32_t value);
void sym_set_global(struct symtab *st, int idx);

#endif
