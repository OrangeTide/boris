/* asm_lex.h : arch-neutral GAS-syntax tokenizer shared by the assemblers.
 *
 * The scanner is parameterized by two knobs set at init time:
 *   comment_ch : the line-comment character ('|' for m68k GAS, '#' for RISC-V)
 *   reloc_pct  : how a leading '%' is treated.  0 strips it and re-lexes the
 *                identifier (m68k register names arrive as %d0/%a1); 1 emits a
 *                T_RELOC token carrying the operator name (RISC-V relocation
 *                operators %hi/%lo/%pcrel_hi/%pcrel_lo).
 *
 * One field is set directly after lex_init rather than through it, to keep the
 * init signature stable for the existing callers:
 *   dollar_reg : when nonzero, a '$' begins a register token (MIPS $t0, $f12,
 *                $0) lexed as a T_IDENT whose text keeps the leading '$'.  When
 *                zero (the default) a '$' is skipped as before. */

#ifndef ASM_LEX_H
#define ASM_LEX_H

#include "arena.h"

enum token_type {
    T_IDENT,
    T_DOT_IDENT,
    T_INT,
    T_STRING,
    T_HASH,
    T_COMMA,
    T_COLON,
    T_LPAREN,
    T_RPAREN,
    T_MINUS,
    T_PLUS,
    T_RELOC,                /* %hi / %lo / %pcrel_hi / %pcrel_lo (name in str) */
    T_NEWLINE,
    T_EOF,
};

struct token {
    int type;
    int line;
    const char *str;
    int str_len;
    long ival;
};

struct lexer {
    const char *src;
    const char *pos;
    int line;
    struct token tok;
    char *str_buf;
    int str_cap;
    struct arena *arena;
    char comment_ch;
    int reloc_pct;
    int dollar_reg;             /* nonzero: '$' begins a register token */
};

void lex_init(struct lexer *l, const char *src, char comment_ch, int reloc_pct);
void lex_next(struct lexer *l);

#endif
