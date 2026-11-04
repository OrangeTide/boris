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
    /* x86 intel-syntax memory operands: `[base + index*scale + disp]`.  These
       characters were silently skipped before, so adding them is a pure superset
       that leaves the other assemblers' token streams unchanged. */
    T_LBRACKET,
    T_RBRACKET,
    T_STAR,
    /* AArch64 `ldr Rt, =literal`: the '=' sigil introducing a literal-pool
       operand.  Previously skipped by the default arm, so this is a pure
       superset that leaves the other assemblers' token streams unchanged. */
    T_EQUAL,
    /* AArch64 Mach-O relocation suffix sigil, `_sym@PAGE` / `_sym@PAGEOFF`.
       Previously skipped by the default arm, so this too is a pure superset. */
    T_AT,
};

struct token {
    int type;
    int line;
    const char *str;
    int str_len;
    long ival;
};

/* The .include stack: `.include "file"` splices another file's tokens into the
   stream, so the lexer keeps a stack of saved positions and pops back at the
   included file's EOF.  The depth is capped (a self-including file is otherwise
   unbounded) and each included file is read up to LEX_INCLUDE_MAX bytes (so an
   endless file such as /dev/zero cannot hang a fuzz run). */
#define LEX_INCLUDE_DEPTH 16
#define LEX_INCLUDE_MAX   (1 << 22)     /* 4 MiB per included file */

struct lex_frame {
    const char *src;
    const char *pos;
    int line;
    const char *dir;
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
    const char *base_src;       /* the top-level source, for lex_rewind */
    const char *dir;            /* directory of the current file (relative .include) */
    const char *base_dir;       /* directory of the top-level file */
    struct lex_frame inc[LEX_INCLUDE_DEPTH];
    int inc_depth;
};

void lex_init(struct lexer *l, const char *src, char comment_ch, int reloc_pct);
void lex_next(struct lexer *l);

/* Reset to the start of the top-level file (between the assembler's passes),
   dropping any open .include frames. */
void lex_rewind(struct lexer *l);

/* Restore the lexer to a snapshot (struct lexer saved = *l) after a bounded
   lookahead, keeping the live scratch buffer rather than the snapshot's, so a
   grow (realloc) between the save and the restore does not resurrect a freed
   str_buf.  Use this in place of a raw `*l = saved`. */
void lex_restore(struct lexer *l, const struct lexer *saved);

/* Record the top-level source file's path, so a relative .include resolves
   against its directory.  Call after lex_init (the arena must be set). */
void lex_set_source_path(struct lexer *l, const char *path);

/* Open an included file (resolved relative to the current file's directory) and
   splice its tokens in.  Returns 0, or -1 if the file cannot be opened, the
   depth cap is reached, or it exceeds LEX_INCLUDE_MAX. */
int lex_include(struct lexer *l, const char *name);

#endif
