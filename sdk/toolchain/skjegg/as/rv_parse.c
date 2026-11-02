/* rv_parse.c : two-pass driver, operand and directive parsing for RV32
 *
 * The scanner and object bookkeeping are the shared skeleton (asm_lex.c,
 * asm_obj.c); this file supplies the RISC-V operand grammar, directive set
 * and the label handling.  Sections carry the little-endian flag so the
 * shared byte emitter produces RISC-V byte order. */

#include "rv.h"
#include "dwarf.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Numeric local labels (GAS 1: / 1f / 1b)
 *
 * A digit label may be redefined; a forward reference (1f) binds to the next
 * definition, a backward reference (1b) to the most recent one.  Each
 * definition is given a unique internal name .Lnum_<d>_<k>, so references
 * resolve through the ordinary symbol table.
 ****************************************************************/

/* If str is a numeric reference like "1f", "2b" or "42f", return its label
 * number and direction; else return 0. */
static int
numeric_ref(const char *str, int *num, char *dir)
{
    size_t n = strlen(str);
    if (n < 2)
        return 0;
    if (str[n - 1] != 'f' && str[n - 1] != 'b')
        return 0;
    for (size_t i = 0; i < n - 1; i++)
        if (str[i] < '0' || str[i] > '9')
            return 0;
    *num = atoi(str);                   /* the leading digits */
    *dir = str[n - 1];
    return 1;
}

/* The redefinition counter for a label number, created at 0 the first time a
 * number is seen (as a definition or a reference). */
static int *
numlabel_count(struct rv_asm *a, int num)
{
    for (int i = 0; i < a->n_numlabels; i++)
        if (a->numlabels[i].num == num)
            return &a->numlabels[i].count;

    if (a->n_numlabels >= a->numlabel_cap) {
        a->numlabel_cap = a->numlabel_cap ? a->numlabel_cap * 2 : 16;
        a->numlabels = realloc(a->numlabels,
            (size_t)a->numlabel_cap * sizeof(*a->numlabels));
        if (!a->numlabels)
            die("out of memory");
    }
    a->numlabels[a->n_numlabels].num = num;
    a->numlabels[a->n_numlabels].count = 0;
    return &a->numlabels[a->n_numlabels++].count;
}

/* Resolve "1f"/"1b" (or "42f"/"42b") to the internal name of the matching
 * definition. */
static const char *
numeric_ref_name(struct rv_asm *a, int num, char dir)
{
    char buf[32];
    int k = *numlabel_count(a, num);
    if (dir == 'b')
        k -= 1;                         /* most recent definition */
    /* dir == 'f' -> next definition (index k, not yet defined) */
    snprintf(buf, sizeof(buf), ".Lnum_%d_%d", num, k < 0 ? 0 : k);
    return arena_strdup(&a->arena, buf);
}

/****************************************************************
 * Operand parsing
 ****************************************************************/

static int
reloc_op_of(const char *name)
{
    if (strcmp(name, "hi") == 0)        return RELOC_OP_HI;
    if (strcmp(name, "lo") == 0)        return RELOC_OP_LO;
    if (strcmp(name, "pcrel_hi") == 0)  return RELOC_OP_PCREL_HI;
    if (strcmp(name, "pcrel_lo") == 0)  return RELOC_OP_PCREL_LO;
    return -1;
}

/* Parse an optional trailing "+ N" or "- N" addend, returning its value. */
static long
parse_addend(struct lexer *l)
{
    long add = 0;
    if (l->tok.type == T_PLUS) {
        lex_next(l);
        if (l->tok.type == T_INT) { add = l->tok.ival; lex_next(l); }
    } else if (l->tok.type == T_MINUS) {
        lex_next(l);
        if (l->tok.type == T_INT) { add = -l->tok.ival; lex_next(l); }
    }
    return add;
}

/* Parse "(reg)" trailing a memory operand's offset; fills base register. */
static int
parse_mem_base(struct lexer *l, int *base)
{
    int reg;
    if (l->tok.type != T_LPAREN)
        return 0;
    lex_next(l);
    if (l->tok.type != T_IDENT)
        return -1;
    reg = rv_ireg(l->tok.str);
    if (reg < 0)
        return -1;
    lex_next(l);
    if (l->tok.type != T_RPAREN)
        return -1;
    lex_next(l);
    *base = reg;
    return 1;
}

/* Parse one operand.  Returns 1 on success, 0 on syntax error. */
static int
parse_operand(struct rv_asm *a, struct rv_operand *op)
{
    struct lexer *l = &a->lex;
    int reg, base;

    memset(op, 0, sizeof(*op));
    op->reloc_op = RELOC_OP_NONE;

    /* relocation operator: %op(sym [+/- add]) optionally as memory %op(sym)(reg) */
    if (l->tok.type == T_RELOC) {
        int rop = reloc_op_of(l->tok.str);
        if (rop < 0) return 0;
        lex_next(l);
        if (l->tok.type != T_LPAREN) return 0;
        lex_next(l);
        if (l->tok.type != T_IDENT && l->tok.type != T_DOT_IDENT) return 0;
        op->sym = arena_strdup(&a->arena, l->tok.str);
        lex_next(l);
        op->imm = parse_addend(l);
        if (l->tok.type != T_RPAREN) return 0;
        lex_next(l);
        op->reloc_op = rop;
        base = -1;
        {
            int r = parse_mem_base(l, &base);
            if (r < 0) return 0;
            if (r == 1) { op->kind = RVO_MEM; op->reg = base; return 1; }
        }
        op->kind = RVO_IMM;
        return 1;
    }

    /* (reg) : memory with zero offset */
    if (l->tok.type == T_LPAREN) {
        base = -1;
        if (parse_mem_base(l, &base) != 1) return 0;
        op->kind = RVO_MEM;
        op->reg = base;
        op->imm = 0;
        return 1;
    }

    /* signed integer, possibly a memory offset  imm(reg) */
    if (l->tok.type == T_INT || l->tok.type == T_MINUS) {
        long val;
        if (l->tok.type == T_MINUS) {
            lex_next(l);
            if (l->tok.type != T_INT) return 0;
            val = -l->tok.ival;
        } else {
            val = l->tok.ival;
        }
        lex_next(l);
        base = -1;
        {
            int r = parse_mem_base(l, &base);
            if (r < 0) return 0;
            if (r == 1) {
                op->kind = RVO_MEM;
                op->reg = base;
                op->imm = val;
                return 1;
            }
        }
        op->kind = RVO_IMM;
        op->imm = val;
        return 1;
    }

    /* identifier: a numeric local-label reference, a register, or a symbol */
    if (l->tok.type == T_IDENT) {
        int num;
        char dir;
        if (numeric_ref(l->tok.str, &num, &dir)) {
            op->kind = RVO_SYM;
            op->sym = numeric_ref_name(a, num, dir);
            lex_next(l);
            return 1;
        }
        reg = rv_ireg(l->tok.str);
        if (reg >= 0) {
            op->kind = RVO_REG;
            op->reg = reg;
            /* keep the spelling: in a symbol position (a branch/jump/la
             * target) a name that happens to match a register is a symbol,
             * which is how a C global named e.g. "s1" reaches the backend. */
            op->sym = arena_strdup(&a->arena, l->tok.str);
            lex_next(l);
            return 1;
        }
        reg = rv_freg(l->tok.str);
        if (reg >= 0) {
            op->kind = RVO_FREG;
            op->reg = reg;
            op->sym = arena_strdup(&a->arena, l->tok.str);
            lex_next(l);
            return 1;
        }
        op->kind = RVO_SYM;
        op->sym = arena_strdup(&a->arena, l->tok.str);
        lex_next(l);
        return 1;
    }

    /* .L-style local label used as a branch/jump target */
    if (l->tok.type == T_DOT_IDENT) {
        op->kind = RVO_SYM;
        op->sym = arena_strdup(&a->arena, l->tok.str);
        lex_next(l);
        return 1;
    }

    return 0;
}

/****************************************************************
 * Directives
 ****************************************************************/

static void
skip_to_eol(struct lexer *l)
{
    while (l->tok.type != T_NEWLINE && l->tok.type != T_EOF)
        lex_next(l);
}

/* Emit an integer-list directive (.byte/.half/.word), each element `width`
 * bytes; an identifier element in a .word list becomes an R_RISCV_32 reloc. */
static void
emit_int_list(struct rv_asm *a, int width)
{
    struct section *s = &a->sections[a->cur_section];
    struct lexer *l = &a->lex;

    for (;;) {
        lex_next(l);
        if (l->tok.type == T_INT) {
            if (a->pass == 2) {
                if (width == 1) sec_emit8(s, (uint8_t)l->tok.ival);
                else if (width == 2) sec_emit16(s, (uint16_t)l->tok.ival);
                else sec_emit32(s, (uint32_t)l->tok.ival);
            } else {
                s->len += width;
            }
            lex_next(l);
        } else if (l->tok.type == T_MINUS) {
            lex_next(l);
            if (l->tok.type == T_INT) {
                long v = -l->tok.ival;
                if (a->pass == 2) {
                    if (width == 1) sec_emit8(s, (uint8_t)v);
                    else if (width == 2) sec_emit16(s, (uint16_t)v);
                    else sec_emit32(s, (uint32_t)v);
                } else {
                    s->len += width;
                }
                lex_next(l);
            }
        } else if ((l->tok.type == T_IDENT || l->tok.type == T_DOT_IDENT)
                   && width == 4) {
            /* resolve the symbol while tok.str is valid, then parse an optional
               "+ N" / "- N" addend (a symbol-relative `.word sym + 8`) */
            int idx = -1;
            if (a->pass == 2) {
                idx = sym_lookup(&a->st, l->tok.str);
                if (idx < 0) idx = sym_add(&a->st, l->tok.str);
            }
            lex_next(l);
            int32_t addend = 0;
            if (l->tok.type == T_PLUS || l->tok.type == T_MINUS) {
                int neg = l->tok.type == T_MINUS;
                lex_next(l);
                if (l->tok.type == T_INT) {
                    addend = neg ? -(int32_t)l->tok.ival : (int32_t)l->tok.ival;
                    lex_next(l);
                }
            }
            if (a->pass == 2) {
                sec_add_reloc_t(s, s->len, idx, addend, R_RISCV_32);
                sec_emit32(s, 0);
            } else {
                s->len += 4;
            }
        } else {
            break;
        }
        if (l->tok.type != T_COMMA) break;
    }
}

static void
emit_string(struct rv_asm *a, int nul)
{
    struct section *s = &a->sections[a->cur_section];
    struct lexer *l = &a->lex;

    lex_next(l);
    if (l->tok.type == T_STRING) {
        if (a->pass == 2) {
            int k;
            for (k = 0; k < l->tok.str_len; k++)
                sec_emit8(s, (uint8_t)l->tok.str[k]);
            if (nul) sec_emit8(s, 0);
        } else {
            s->len += l->tok.str_len + (nul ? 1 : 0);
        }
        lex_next(l);
    }
}

static void
do_align(struct rv_asm *a, int bytes)
{
    struct section *s = &a->sections[a->cur_section];
    if (bytes > s->align)
        s->align = bytes;
    if (a->pass == 2)
        sec_align(s, bytes);
    else
        while (s->len % bytes) s->len++;
}

/* Append one line-table row (emit pass only; see .loc below). */
static void
rv_add_locrow(struct rv_asm *a, uint32_t offset, int line)
{
    if (a->n_locrows >= a->locrow_cap) {
        a->locrow_cap = a->locrow_cap ? a->locrow_cap * 2 : 64;
        a->locrows = realloc(a->locrows,
                             (size_t)a->locrow_cap * sizeof *a->locrows);
    }
    a->locrows[a->n_locrows].offset = offset;
    a->locrows[a->n_locrows].line = line;
    a->n_locrows++;
}

static void
handle_directive(struct rv_asm *a, const char *dir)
{
    struct lexer *l = &a->lex;
    struct section *s = &a->sections[a->cur_section];

    if (strcmp(dir, ".text") == 0)   { a->cur_section = RSEC_TEXT; return; }
    if (strcmp(dir, ".data") == 0)   { a->cur_section = RSEC_DATA; return; }
    if (strcmp(dir, ".rodata") == 0) { a->cur_section = RSEC_RODATA; return; }
    if (strcmp(dir, ".bss") == 0 || strcmp(dir, ".sbss") == 0) {
        a->cur_section = RSEC_BSS; return;
    }
    if (strcmp(dir, ".include") == 0) {
        lex_next(l);
        if (l->tok.type != T_STRING)
            die("line %d: .include needs a \"file\" operand", l->tok.line);
        if (lex_include(l, l->tok.str) != 0)
            die("line %d: cannot .include \"%s\"", l->tok.line, l->tok.str);
        return;         /* the included tokens come next; the parent resumes on pop */
    }

    if (strcmp(dir, ".section") == 0) {
        lex_next(l);
        if (l->tok.type == T_DOT_IDENT || l->tok.type == T_IDENT) {
            const char *n = l->tok.str;
            if (strncmp(n, ".text", 5) == 0)   a->cur_section = RSEC_TEXT;
            else if (strncmp(n, ".rodata", 7) == 0) a->cur_section = RSEC_RODATA;
            else if (strncmp(n, ".data", 5) == 0)   a->cur_section = RSEC_DATA;
            else if (strncmp(n, ".bss", 4) == 0)    a->cur_section = RSEC_BSS;
            else a->cur_section = RSEC_DATA;
        }
        skip_to_eol(l);
        return;
    }

    if (strcmp(dir, ".globl") == 0 || strcmp(dir, ".global") == 0 ||
        strcmp(dir, ".weak") == 0) {
        int is_weak = (dir[1] == 'w');
        lex_next(l);
        if (l->tok.type == T_IDENT || l->tok.type == T_DOT_IDENT) {
            int idx = sym_lookup(&a->st, l->tok.str);
            if (idx < 0) idx = sym_add(&a->st, l->tok.str);
            if (is_weak) sym_set_weak(&a->st, idx);
            else sym_set_global(&a->st, idx);
            lex_next(l);
        }
        return;
    }

    /* .align / .p2align take a power-of-two exponent on RISC-V */
    if (strcmp(dir, ".align") == 0 || strcmp(dir, ".p2align") == 0) {
        lex_next(l);
        if (l->tok.type == T_INT) {
            int n = (int)l->tok.ival;
            int bytes = 1 << (n < 0 ? 0 : n > 12 ? 12 : n);
            lex_next(l);
            do_align(a, bytes);
        }
        skip_to_eol(l);
        return;
    }
    if (strcmp(dir, ".balign") == 0) {
        lex_next(l);
        if (l->tok.type == T_INT) {
            int bytes = (int)l->tok.ival;
            lex_next(l);
            if (bytes > 0) do_align(a, bytes);
        }
        skip_to_eol(l);
        return;
    }

    if (strcmp(dir, ".word") == 0 || strcmp(dir, ".long") == 0) {
        emit_int_list(a, 4); return;
    }
    if (strcmp(dir, ".half") == 0 || strcmp(dir, ".short") == 0
        || strcmp(dir, ".2byte") == 0) {
        emit_int_list(a, 2); return;
    }
    if (strcmp(dir, ".byte") == 0) { emit_int_list(a, 1); return; }

    if (strcmp(dir, ".ascii") == 0)  { emit_string(a, 0); return; }
    if (strcmp(dir, ".asciz") == 0 || strcmp(dir, ".string") == 0) {
        emit_string(a, 1); return;
    }

    if (strcmp(dir, ".space") == 0 || strcmp(dir, ".zero") == 0
        || strcmp(dir, ".skip") == 0) {
        lex_next(l);
        if (l->tok.type == T_INT) {
            if (a->pass == 2) sec_space(s, (int)l->tok.ival);
            else s->len += (int)l->tok.ival;
            lex_next(l);
        }
        skip_to_eol(l);
        return;
    }

    /* .type sym,@function : mark the symbol STT_FUNC so the ELF writer types
       it, which is what a debugger's address-to-function map and a backtrace
       read in .symtab.  The '@' is skipped by the lexer, so scan the operands
       for the "function" word; any other type is left as the default. */
    if (strcmp(dir, ".type") == 0) {
        lex_next(l);
        if (l->tok.type == T_IDENT || l->tok.type == T_DOT_IDENT) {
            int idx = sym_lookup(&a->st, l->tok.str);
            if (idx < 0) idx = sym_add(&a->st, l->tok.str);
            for (lex_next(l); l->tok.type != T_NEWLINE
                              && l->tok.type != T_EOF; lex_next(l)) {
                if ((l->tok.type == T_IDENT || l->tok.type == T_DOT_IDENT)
                    && strcmp(l->tok.str, "function") == 0)
                    sym_set_func(&a->st, idx);
            }
        } else {
            skip_to_eol(l);
        }
        return;
    }

    /* .size sym,expr : the symbol's byte extent, written as st_size.  expr is a
       sum of label and integer terms (the backend emits `.Lfunc_endN - func`);
       resolved symbol values are final by the emit pass, so evaluating the
       terms each pass leaves the authoritative size after it. */
    if (strcmp(dir, ".size") == 0) {
        int target = -1;
        lex_next(l);
        if (l->tok.type == T_IDENT || l->tok.type == T_DOT_IDENT) {
            target = sym_lookup(&a->st, l->tok.str);
            if (target < 0) target = sym_add(&a->st, l->tok.str);
            lex_next(l);
        }
        if (target >= 0 && l->tok.type == T_COMMA) {
            int32_t acc = 0;
            int neg = 0;
            for (lex_next(l); l->tok.type != T_NEWLINE
                              && l->tok.type != T_EOF; lex_next(l)) {
                int32_t v;
                if (l->tok.type == T_MINUS) { neg = 1; continue; }
                if (l->tok.type == T_PLUS)  { neg = 0; continue; }
                if (l->tok.type == T_INT) {
                    v = (int32_t)l->tok.ival;
                } else if (l->tok.type == T_IDENT
                           || l->tok.type == T_DOT_IDENT) {
                    if (strcmp(l->tok.str, ".") == 0) {
                        v = (int32_t)a->sections[a->cur_section].len;
                    } else {
                        int si = sym_lookup(&a->st, l->tok.str);
                        v = si >= 0 ? (int32_t)a->st.syms[si].value : 0;
                    }
                } else {
                    break;
                }
                acc += neg ? -v : v;
                neg = 0;
            }
            if (acc < 0) acc = 0;
            sym_set_size(&a->st, target, (uint32_t)acc);
        }
        skip_to_eol(l);
        return;
    }

    /* .file ["]name["] or .file N "name" : the DWARF source name.  The last
       one wins; a column/path form past the name is ignored. */
    if (strcmp(dir, ".file") == 0) {
        lex_next(l);
        if (l->tok.type == T_INT)       /* the file number, if present */
            lex_next(l);
        if (l->tok.type == T_STRING)
            a->debug_file = arena_strndup(&a->arena, l->tok.str, l->tok.str_len);
        skip_to_eol(l);
        return;
    }

    /* .loc N line [column] [opts] : one row of the line table.  The address is
       the current .text offset, known only in the emit pass, so rows are
       collected then; operands past the line are ignored. */
    if (strcmp(dir, ".loc") == 0) {
        int line = 0, seen_line = 0;
        lex_next(l);
        if (l->tok.type == T_INT) {     /* file number */
            lex_next(l);
            if (l->tok.type == T_INT) { line = (int)l->tok.ival; seen_line = 1; }
        }
        if (a->pass == 2 && seen_line && a->cur_section == RSEC_TEXT)
            rv_add_locrow(a, (uint32_t)a->sections[RSEC_TEXT].len, line);
        skip_to_eol(l);
        return;
    }

    /* metadata directives we accept and ignore */
    if (strcmp(dir, ".option") == 0
        || strcmp(dir, ".ident") == 0 || strcmp(dir, ".attribute") == 0
        || strcmp(dir, ".local") == 0 || strncmp(dir, ".cfi_", 5) == 0) {
        skip_to_eol(l);
        return;
    }

    warn("line %d: unknown directive '%s'", l->tok.line, dir);
    skip_to_eol(l);
}

/****************************************************************
 * Instruction lines
 ****************************************************************/

#define MAX_OPS 4

static void
parse_instruction(struct rv_asm *a, const char *mnemonic)
{
    struct lexer *l = &a->lex;
    struct rv_operand ops[MAX_OPS];
    int nops = 0;
    int result;

    memset(ops, 0, sizeof(ops));

    if (l->tok.type != T_NEWLINE && l->tok.type != T_EOF) {
        for (;;) {
            if (nops >= MAX_OPS)
                die("line %d: too many operands for '%s'",
                    l->tok.line, mnemonic);
            if (!parse_operand(a, &ops[nops]))
                die("line %d: bad operand for '%s'", l->tok.line, mnemonic);
            nops++;
            if (l->tok.type != T_COMMA) break;
            lex_next(l);
        }
    }

    if (a->pass == 1) {
        result = rv_encode(a, mnemonic, ops, nops, 0);
        if (result < 0)
            die("line %d: cannot encode '%s'", l->tok.line, mnemonic);
        a->sections[a->cur_section].len += result;
    } else {
        result = rv_encode(a, mnemonic, ops, nops, 1);
        if (result < 0)
            die("line %d: cannot encode '%s'", l->tok.line, mnemonic);
    }
    skip_to_eol(l);
}

/****************************************************************
 * Pass driver
 ****************************************************************/

static void
define_label(struct rv_asm *a, const char *name)
{
    if (a->pass == 1) {
        int idx = sym_lookup(&a->st, name);
        if (idx < 0) idx = sym_add(&a->st, name);
        sym_define(&a->st, idx, a->cur_section,
                   (uint32_t)a->sections[a->cur_section].len);
    }
}

static void
run_pass(struct rv_asm *a)
{
    struct lexer *l = &a->lex;

    int k;

    a->cur_section = RSEC_TEXT;
    for (k = 0; k < a->n_numlabels; k++)
        a->numlabels[k].count = 0;      /* same numbers each pass, recount */
    lex_next(l);

    while (l->tok.type != T_EOF) {
        if (l->tok.type == T_NEWLINE) {
            lex_next(l);
            continue;
        }

        /* numeric local label: N:  (the rest of the line still parses) */
        if (l->tok.type == T_INT) {
            int num = (int)l->tok.ival;
            struct lexer saved = *l;
            lex_next(l);
            if (l->tok.type == T_COLON && num >= 0) {
                char buf[32];
                int *cnt = numlabel_count(a, num);
                lex_next(l);
                if (a->pass == 1) {
                    int idx;
                    snprintf(buf, sizeof(buf), ".Lnum_%d_%d", num, *cnt);
                    idx = sym_lookup(&a->st, buf);
                    if (idx < 0) idx = sym_add(&a->st, buf);
                    sym_define(&a->st, idx, a->cur_section,
                               (uint32_t)a->sections[a->cur_section].len);
                }
                (*cnt)++;
                continue;
            }
            lex_restore(l, &saved);
            skip_to_eol(l);
            if (l->tok.type == T_NEWLINE) lex_next(l);
            continue;
        }

        /* dotted token: a directive, or a dotted label (.L1:, .fail:).
         * Peek one token for a ':' to tell them apart, restoring the lexer to
         * the name if it is a directive (handle_directive expects the name to
         * be the current token). */
        if (l->tok.type == T_DOT_IDENT) {
            const char *name = l->tok.str;
            struct lexer saved = *l;
            lex_next(l);
            if (l->tok.type == T_COLON) {
                lex_next(l);
                define_label(a, name);
                continue;
            }
            lex_restore(l, &saved);
            handle_directive(a, name);
            skip_to_eol(l);
            if (l->tok.type == T_NEWLINE) lex_next(l);
            continue;
        }

        if (l->tok.type == T_IDENT) {
            const char *name = l->tok.str;
            lex_next(l);
            if (l->tok.type == T_COLON) {
                lex_next(l);
                define_label(a, name);
                continue;
            }
            parse_instruction(a, name);
            if (l->tok.type == T_NEWLINE) lex_next(l);
            continue;
        }

        skip_to_eol(l);
        if (l->tok.type == T_NEWLINE) lex_next(l);
    }
}

/****************************************************************
 * Branch relaxation bookkeeping
 ****************************************************************/

void
rv_note_branch(struct rv_asm *a, int section, uint32_t offset,
               const char *target)
{
    if (a->nbsites >= a->bsite_cap) {
        a->bsite_cap = a->bsite_cap ? a->bsite_cap * 2 : 64;
        a->bsites = realloc(a->bsites,
                            (size_t)a->bsite_cap * sizeof(struct rv_bsite));
    }
    a->bsites[a->nbsites].section = section;
    a->bsites[a->nbsites].offset = offset;
    a->bsites[a->nbsites].target = target;
    a->nbsites++;
}

/* A sizing pass: reassign label addresses and re-record branch sites for the
 * current relaxation decisions.  Sections are emptied first; encode runs with
 * emit == 0 so only sizes accumulate. */
static void
sizing_pass(struct rv_asm *a)
{
    int k;
    for (k = 0; k < RSEC_COUNT; k++)
        a->sections[k].len = 0;
    a->pass = 1;
    a->recording = 1;
    a->bsite = 0;
    a->nbsites = 0;
    lex_rewind(&a->lex);
    run_pass(a);
}

/* After a sizing pass, grow the relaxation set: any same-section branch whose
 * target is now out of B-type range becomes a branch+jal.  Relaxation is
 * monotone (a site never un-relaxes), so the fixpoint is reached in at most
 * one iteration per site. */
static int
relax_measure(struct rv_asm *a)
{
    int changed = 0;
    int i;
    for (i = 0; i < a->nbsites; i++) {
        struct rv_bsite *b = &a->bsites[i];
        int idx = sym_lookup(&a->st, b->target);
        int32_t disp;
        if (a->brelax[i])
            continue;
        if (idx < 0 || !a->st.syms[idx].defined
            || a->st.syms[idx].section != b->section)
            continue;                   /* a relocation will cover it */
        disp = (int32_t)a->st.syms[idx].value - (int32_t)b->offset;
        if (disp < -4096 || disp > 4094) {
            a->brelax[i] = 1;
            changed = 1;
        }
    }
    return changed;
}

/****************************************************************
 * Public interface
 ****************************************************************/

void
rv_init(struct rv_asm *a, const char *src)
{
    int k;

    memset(a, 0, sizeof(*a));
    arena_init(&a->arena);
    a->lex.arena = &a->arena;
    a->st.arena = &a->arena;
    for (k = 0; k < RSEC_COUNT; k++)
        a->sections[k].little_endian = 1;
    /* expand .macro/.endm before the lexer sees the source */
    src = rv_expand_macros(&a->arena, src);
    lex_init(&a->lex, src, '#', 1);
}

void
rv_free(struct rv_asm *a)
{
    int k;
    for (k = 0; k < RSEC_COUNT; k++) {
        free(a->sections[k].data);
        free(a->sections[k].relocs);
    }
    free(a->st.syms);
    free(a->bsites);
    free(a->brelax);
    free(a->numlabels);
    free(a->locrows);
    free(a->lex.str_buf);
    arena_free(&a->arena);
}

/* Build the DWARF debug sections from the .loc rows collected in the emit pass.
   The three sections are non-alloc, so they do not perturb the text/data
   layout; the only link-time unknowns are the absolute address fields, each an
   R_RISCV_32 against a synthesized .text base symbol (value 0, so the folding in
   the ELF writer turns it into the .text section symbol plus the addend). */
void
rv_emit_debug(struct rv_asm *a)
{
    struct arena *ar = &a->arena;
    struct section *sl = &a->sections[RSEC_DEBUG_LINE];
    struct section *si = &a->sections[RSEC_DEBUG_INFO];
    struct section *sa = &a->sections[RSEC_DEBUG_ABBREV];
    const char *name = a->debug_file ? a->debug_file : "?";
    struct dw_line_row *rows;
    uint8_t *bytes;
    size_t len, set_addr_off, low_off, high_off, b;
    uint32_t text_end;
    int sym, i;

    if (a->n_locrows == 0)
        return;                 /* no .loc seen (no -g): emit nothing */

    /* The text-base symbol the absolute address fields relocate against. */
    sym = sym_lookup(&a->st, ".Ldebug_text0");
    if (sym < 0)
        sym = sym_add(&a->st, ".Ldebug_text0");
    sym_define(&a->st, sym, RSEC_TEXT, 0);

    rows = arena_zalloc(ar, (size_t)a->n_locrows * sizeof *rows);
    for (i = 0; i < a->n_locrows; i++) {
        rows[i].addr = a->locrows[i].offset;
        rows[i].line = a->locrows[i].line;
    }
    text_end = (uint32_t)a->sections[RSEC_TEXT].len;

    /* .debug_line: the line program, set_address fixed to .text + first row. */
    len = dw_line_build(ar, &name, 1, rows, a->n_locrows, text_end, &bytes,
                        &set_addr_off, 0, 4);
    for (b = 0; b < len; b++)
        sec_emit8(sl, bytes[b]);
    sec_add_reloc_t(sl, (uint32_t)set_addr_off, sym,
                    (int32_t)rows[0].addr, R_RISCV_32);

    /* .debug_abbrev: fixed, no relocations. */
    len = dw_abbrev_build(ar, &bytes);
    for (b = 0; b < len; b++)
        sec_emit8(sa, bytes[b]);

    /* .debug_info: a CU spanning all of .text, stmt_list at line program 0. */
    len = dw_info_build(ar, "skjegg", name, ".", 0, text_end, 0, &bytes,
                        &low_off, &high_off, 0, 4);
    for (b = 0; b < len; b++)
        sec_emit8(si, bytes[b]);
    sec_add_reloc_t(si, (uint32_t)low_off, sym, 0, R_RISCV_32);
    sec_add_reloc_t(si, (uint32_t)high_off, sym, (int32_t)text_end, R_RISCV_32);
}

void
rv_assemble(struct rv_asm *a)
{
    int iter, k;

    /* initial layout with no relaxation, to count the branch sites */
    sizing_pass(a);

    a->brelax_len = a->nbsites;
    a->brelax = calloc((size_t)(a->brelax_len ? a->brelax_len : 1), 1);

    /* iterate sizing to a relaxation fixpoint */
    for (iter = 0; iter <= a->brelax_len; iter++) {
        if (!relax_measure(a))
            break;
        sizing_pass(a);
    }

    /* emit pass: real bytes, relocations and synthesized pcrel labels */
    for (k = 0; k < RSEC_COUNT; k++)
        a->sections[k].len = 0;
    a->pass = 2;
    a->recording = 0;
    a->bsite = 0;
    a->pcrel_serial = 0;
    lex_rewind(&a->lex);
    run_pass(a);
}
