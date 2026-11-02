/* kpm.c : reader for the KPM1 text module format */

#include "kpm.h"
#include "target.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* The pointer-width class this backend reads modules for.  A KPM1 module is NOT
   architecture-agnostic: its opcodes bake in the guest pointer width (ADD vs
   ADD64, LDL vs LDL64, ARG vs ARG64, the `ptr` global flag), so a module and the
   backend that loads it must agree.  The front end stamps the class in the
   `.target` header (ilp32 for rv32/cf/mips, lp64 for x86-64/arm64); the reader
   rejects a module of the other class rather than silently truncating a 64-bit
   handle to 32 bits (or sign-confusing a 32-bit one).  This tool's own class is
   the shared width axis (target.h): SKJ_LP64 is set for the JIT and the x86-64 /
   arm64 AOT, unset for the 32-bit backends (rv32, ColdFire, MIPS). */
#define KPM_NATIVE_TARGET SKJ_KPM_TARGET

/* The architecture this backend reads modules for.  A unit (KPM module) is bound
   to one Target, not just one width class: it carries native-code assumptions
   beyond pointer width (ISA, ABI), so a module built for one architecture is not
   valid for another even at the same width (an rv32 unit must not load into the
   ColdFire backend).  The front end stamps the architecture in the `.target`
   header; the reader rejects a cross-architecture module.  The build passes
   SKJ_KPM_ARCH per binary (Plan 9 style); target.h derives a fallback. */
#define KPM_NATIVE_ARCH SKJ_KPM_ARCH

/* Is `t` an architecture tag (binds a unit to one ISA) rather than a legacy
   width-only tag (ilp32/lp64) or hint (agnostic)?  An arch tag is matched
   exactly against this backend's own; a width tag keeps the looser width check. */
static int
kpm_is_arch_tag(const char *t)
{
    return strcmp(t, "rv32") == 0 || strcmp(t, "cf") == 0
        || strcmp(t, "x86-64") == 0 || strcmp(t, "arm64") == 0
        || strcmp(t, "mips") == 0 || strcmp(t, "x86-32") == 0;
}

/****************************************************************
 * Opcode names
 *
 * A KPM1 instruction mnemonic is the ir_op enum name without the IR_
 * prefix. One table serves both directions: name -> op for the reader and
 * op -> name for a dump.
 ****************************************************************/

struct op_entry {
    const char *name;
    int op;
};

static const struct op_entry op_table[] = {
    { "NOP", IR_NOP }, { "LIC", IR_LIC }, { "LEA", IR_LEA },
    { "ADL", IR_ADL }, { "MOV", IR_MOV },
    { "LEA64", IR_LEA64 }, { "ADL64", IR_ADL64 },
    { "ADD", IR_ADD }, { "SUB", IR_SUB }, { "MUL", IR_MUL },
    { "ADDO", IR_ADDO }, { "SUBO", IR_SUBO }, { "MULO", IR_MULO },
    { "LOC", IR_LOC },
    { "DIVS", IR_DIVS }, { "DIVU", IR_DIVU }, { "MODS", IR_MODS },
    { "MODU", IR_MODU }, { "AND", IR_AND }, { "OR", IR_OR },
    { "XOR", IR_XOR }, { "SHL", IR_SHL }, { "SHRS", IR_SHRS },
    { "SHRU", IR_SHRU }, { "NEG", IR_NEG }, { "NOT", IR_NOT },
    { "LB", IR_LB }, { "LBS", IR_LBS }, { "LH", IR_LH },
    { "LHS", IR_LHS }, { "LW", IR_LW },
    { "SB", IR_SB }, { "SH", IR_SH }, { "SW", IR_SW },
    { "LDL", IR_LDL }, { "STL", IR_STL }, { "ALLOCA", IR_ALLOCA },
    { "CMPEQ", IR_CMPEQ }, { "CMPNE", IR_CMPNE },
    { "CMPLTS", IR_CMPLTS }, { "CMPLES", IR_CMPLES },
    { "CMPGTS", IR_CMPGTS }, { "CMPGES", IR_CMPGES },
    { "CMPLTU", IR_CMPLTU }, { "CMPLEU", IR_CMPLEU },
    { "CMPGTU", IR_CMPGTU }, { "CMPGEU", IR_CMPGEU },
    { "JMP", IR_JMP }, { "BZ", IR_BZ }, { "BNZ", IR_BNZ },
    { "ARG", IR_ARG }, { "FARG", IR_FARG }, { "CALL", IR_CALL },
    { "CALLI", IR_CALLI }, { "TAILCALL", IR_TAILCALL },
    { "TAILCALLI", IR_TAILCALLI }, { "RET", IR_RET }, { "RETV", IR_RETV },
    { "FUNC", IR_FUNC }, { "ENDF", IR_ENDF }, { "LABEL", IR_LABEL },
    { "MARK", IR_MARK }, { "CAPTURE", IR_CAPTURE }, { "RESUME", IR_RESUME },
    { "CONT_UNWIND", IR_CONT_UNWIND },
    { "FADD", IR_FADD }, { "FSUB", IR_FSUB }, { "FMUL", IR_FMUL },
    { "FDIV", IR_FDIV }, { "FNEG", IR_FNEG }, { "FABS", IR_FABS },
    { "FSQRT", IR_FSQRT },
    { "FCMPEQ", IR_FCMPEQ }, { "FCMPLT", IR_FCMPLT }, { "FCMPLE", IR_FCMPLE },
    { "ITOF", IR_ITOF }, { "FTOI", IR_FTOI }, { "FROUND", IR_FROUND },
    { "F32TOF64", IR_F32TOF64 }, { "F64TOF32", IR_F64TOF32 },
    { "FLS", IR_FLS }, { "FLD", IR_FLD }, { "FSS", IR_FSS },
    { "FSD", IR_FSD }, { "FLH", IR_FLH }, { "FSH", IR_FSH },
    { "FLDL", IR_FLDL }, { "FSTL", IR_FSTL },
    { "FRETV", IR_FRETV }, { "FCALL", IR_FCALL }, { "FCALLI", IR_FCALLI },
    { "LIC64", IR_LIC64 },
    { "ADD64", IR_ADD64 }, { "SUB64", IR_SUB64 }, { "MUL64", IR_MUL64 },
    { "DIVS64", IR_DIVS64 }, { "DIVU64", IR_DIVU64 },
    { "MODS64", IR_MODS64 }, { "MODU64", IR_MODU64 },
    { "AND64", IR_AND64 }, { "OR64", IR_OR64 }, { "XOR64", IR_XOR64 },
    { "SHL64", IR_SHL64 }, { "SHRS64", IR_SHRS64 }, { "SHRU64", IR_SHRU64 },
    { "NEG64", IR_NEG64 },
    { "CMP64EQ", IR_CMP64EQ }, { "CMP64NE", IR_CMP64NE },
    { "CMP64LTS", IR_CMP64LTS }, { "CMP64LES", IR_CMP64LES },
    { "CMP64GTS", IR_CMP64GTS }, { "CMP64GES", IR_CMP64GES },
    { "CMP64LTU", IR_CMP64LTU }, { "CMP64LEU", IR_CMP64LEU },
    { "CMP64GTU", IR_CMP64GTU }, { "CMP64GEU", IR_CMP64GEU },
    { "LD64", IR_LD64 }, { "ST64", IR_ST64 },
    { "LDL64", IR_LDL64 }, { "STL64", IR_STL64 },
    { "VA_START", IR_VA_START },
    { "SEXT64", IR_SEXT64 }, { "ZEXT64", IR_ZEXT64 }, { "TRUNC64", IR_TRUNC64 },
    { "ARG64", IR_ARG64 }, { "RETV64", IR_RETV64 },
    { "CALL64", IR_CALL64 }, { "CALLI64", IR_CALLI64 },
    { "RETV_AGG", IR_RETV_AGG }, { "CALL_AGG", IR_CALL_AGG },
    { "CALLI_AGG", IR_CALLI_AGG },
    { "RETV2", IR_RETV2 }, { "CALL2", IR_CALL2 }, { "CALLI2", IR_CALLI2 },
    { "ARG_MEM", IR_ARG_MEM }, { "ARG_X8", IR_ARG_X8 }, { "ASM", IR_ASM },
    { "LABADDR", IR_LABADDR }, { "IJMP", IR_IJMP },
    { "LABADDR64", IR_LABADDR64 }, { "IJMP64", IR_IJMP64 },
};

static const int op_count = sizeof(op_table) / sizeof(op_table[0]);

const char *
kpm_op_name(int op)
{
    for (int i = 0; i < op_count; i++)
        if (op_table[i].op == op)
            return op_table[i].name;
    return NULL;
}

/* Which opcodes use a slot or a label as an array index in the backends, so
   the reader must insist the field is present (not just range-check it when it
   happens to appear). ir_emit defaults slot and label to -1, and the selectors
   index the frame's slot table and the label table by these fields without a
   >= 0 guard (the toolkit's own front ends always supply them). A corrupt or
   hostile module that names such an opcode but omits the field would otherwise
   reach the backend with the -1 default and drive an out-of-bounds access, so
   a missing field is rejected here beside the range check. */
static int
op_needs_slot(int op)
{
    switch (op) {
    case IR_ADL: case IR_ADL64:
    case IR_LDL: case IR_STL:
    case IR_LDL64: case IR_STL64:
    case IR_FLDL: case IR_FSTL:
    case IR_CALL2: case IR_CALLI2:
    case IR_CALL_AGG: case IR_CALLI_AGG:
    case IR_MARK: case IR_CONT_UNWIND:
        return 1;
    default:
        return 0;
    }
}

static int
op_needs_label(int op)
{
    switch (op) {
    case IR_JMP: case IR_BZ: case IR_BNZ: case IR_LABEL:
    case IR_LABADDR: case IR_LABADDR64:
        return 1;
    default:
        return 0;
    }
}

static int
op_by_name(const char *name)
{
    for (int i = 0; i < op_count; i++)
        if (strcmp(op_table[i].name, name) == 0)
            return op_table[i].op;
    return -1;
}

static int
base_type_by_name(const char *name)
{
    if (strcmp(name, "i8") == 0) return IR_I8;
    if (strcmp(name, "i16") == 0) return IR_I16;
    if (strcmp(name, "i32") == 0) return IR_I32;
    if (strcmp(name, "i64") == 0) return IR_I64;
    if (strcmp(name, "f32") == 0) return IR_F32;
    if (strcmp(name, "f64") == 0) return IR_F64;
    return -1;
}

/****************************************************************
 * Line and token helpers
 ****************************************************************/

#define MAX_TOKENS 64

/* An upper bound on any count a module declares (function slots, params, temps,
   labels). It is far above any real program yet small enough that the count
   times an element size cannot overflow or demand an absurd allocation. A
   module claiming more is rejected rather than trusted, so an untrusted or
   corrupt image cannot drive a negative or wild-sized arena allocation. */
#define KPM_MAX_COUNT (1 << 20)

/* Split a NUL-terminated line into whitespace-separated tokens in place,
   writing pointers into tok[] (up to MAX_TOKENS) and returning the count. */
static int
tokenize(char *line, char **tok)
{
    int n = 0;
    char *p = line;

    while (*p) {
        while (*p == ' ' || *p == '\t')
            p++;
        if (!*p)
            break;
        if (n >= MAX_TOKENS)
            break;
        tok[n++] = p;
        while (*p && *p != ' ' && *p != '\t')
            p++;
        if (*p)
            *p++ = '\0';
    }
    return n;
}

/* True when `line` begins with the directive `word`, delimited by end of
   line or whitespace. Does not mutate the line, unlike tokenize, so the
   dispatch can peek at a directive and let its reader tokenize afresh. */
static int
kw(const char *line, const char *word)
{
    size_t wl = strlen(word);

    return strncmp(line, word, wl) == 0
        && (line[wl] == '\0' || line[wl] == ' ' || line[wl] == '\t');
}

/* The class tokens between '(' and ')' among tok[0..n-1], plus the token
   after '->'. Returns the class count; *ret points at the ret class token
   (or NULL). Fills cls[] with pointers into the token array. */
static int
parse_signature(char **tok, int n, char **cls, int maxcls, char **ret)
{
    int i = 0, ncls = 0;

    *ret = NULL;
    while (i < n && strcmp(tok[i], "(") != 0)
        i++;
    i++;    /* past '(' */
    while (i < n && strcmp(tok[i], ")") != 0) {
        if (ncls < maxcls)
            cls[ncls++] = tok[i];
        i++;
    }
    i++;    /* past ')' */
    if (i < n && strcmp(tok[i], "->") == 0 && i + 1 < n)
        *ret = tok[i + 1];
    return ncls;
}

/****************************************************************
 * Reader state
 ****************************************************************/

struct reader {
    struct kpm_module *m;
    char **lines;       /* trimmed, NUL-terminated, one per source line */
    int nlines;
    int pos;            /* current line index */
    char *err;
    size_t errlen;
};

static void
fail(struct reader *r, int line1, const char *msg)
{
    if (r->err && r->errlen)
        snprintf(r->err, r->errlen, "line %d: %s", line1, msg);
}

/* Copy `n` class-token strings into a fresh arena array of arena strings. */
static char **
dup_classes(struct arena *a, char **cls, int n)
{
    char **out;

    if (n == 0)
        return NULL;
    out = arena_alloc(a, (size_t)n * sizeof(*out));
    for (int i = 0; i < n; i++)
        out[i] = arena_strdup(a, cls[i]);
    return out;
}

/****************************************************************
 * Imports and exports
 ****************************************************************/

static int
read_import(struct reader *r, struct kp_import *imp)
{
    char *tok[MAX_TOKENS];
    char *cls[MAX_TOKENS];
    char *ret;
    int n, ncls;

    n = tokenize(r->lines[r->pos], tok);
    /* tok: .import <kind> <name> ... */
    if (n < 3) {
        fail(r, r->pos + 1, "malformed .import");
        return -1;
    }
    imp->name = arena_strdup(&r->m->arena, tok[2]);
    if (strcmp(tok[1], "func") == 0)
        imp->kind = KP_IMPORT_FUNC;
    else if (strcmp(tok[1], "helper") == 0)
        imp->kind = KP_IMPORT_HELPER;
    else if (strcmp(tok[1], "type") == 0)
        imp->kind = KP_IMPORT_TYPE;
    else {
        fail(r, r->pos + 1, "unknown import kind");
        return -1;
    }

    if (imp->kind == KP_IMPORT_TYPE) {
        int nm = 0, k;
        /* .import type <name> methods <n> */
        for (k = 3; k < n - 1; k++)
            if (strcmp(tok[k], "methods") == 0)
                nm = (int)strtol(tok[k + 1], NULL, 10);
        if (nm < 0 || nm > KPM_MAX_COUNT) {
            fail(r, r->pos + 1, "method count out of range");
            return -1;
        }
        imp->nmethods = nm;
        imp->methods = nm ? arena_alloc(&r->m->arena,
                                        (size_t)nm * sizeof(*imp->methods))
                          : NULL;
        for (int mi = 0; mi < nm; mi++) {
            r->pos++;
            if (r->pos >= r->nlines) {
                fail(r, r->pos, "unexpected end inside .import type");
                return -1;
            }
            n = tokenize(r->lines[r->pos], tok);
            /* .method <index> <name> ( classes ) -> ret */
            if (n < 3 || strcmp(tok[0], ".method") != 0) {
                fail(r, r->pos + 1, "expected .method");
                return -1;
            }
            imp->methods[mi].name = arena_strdup(&r->m->arena, tok[2]);
            ncls = parse_signature(tok, n, cls, MAX_TOKENS, &ret);
            imp->methods[mi].nparams = ncls;
            imp->methods[mi].param_cls = dup_classes(&r->m->arena, cls, ncls);
            imp->methods[mi].ret_cls = ret
                ? arena_strdup(&r->m->arena, ret) : NULL;
        }
        return 0;
    }

    ncls = parse_signature(tok, n, cls, MAX_TOKENS, &ret);
    imp->nparams = ncls;
    imp->param_cls = dup_classes(&r->m->arena, cls, ncls);
    imp->ret_cls = ret ? arena_strdup(&r->m->arena, ret) : NULL;
    return 0;
}

/****************************************************************
 * Globals
 ****************************************************************/

/* Unescape a C-style quoted string body (already stripped of its quotes)
   into a fresh arena buffer; sets *outlen to the byte length. */
static char *
unescape(struct arena *a, const char *s, int *outlen)
{
    size_t cap = strlen(s) + 1;
    char *out = arena_alloc(a, cap);
    int n = 0;

    while (*s) {
        if (*s == '\\' && s[1]) {
            s++;
            switch (*s) {
            case 'n': out[n++] = '\n'; s++; break;
            case 't': out[n++] = '\t'; s++; break;
            case 'r': out[n++] = '\r'; s++; break;
            case '"': out[n++] = '"'; s++; break;
            case '\\': out[n++] = '\\'; s++; break;
            case 'x': {
                int hi, lo;
                s++;
                hi = *s ? (int)strtol((char[]){*s, 0}, NULL, 16) : 0;
                if (*s) s++;
                lo = *s ? (int)strtol((char[]){*s, 0}, NULL, 16) : 0;
                if (*s) s++;
                out[n++] = (char)(hi * 16 + lo);
                break;
            }
            default: out[n++] = *s++; break;
            }
        } else {
            out[n++] = *s++;
        }
    }
    out[n] = '\0';
    *outlen = n;
    return out;
}

/* The quoted-string body of a .string line: the text between the first and
   last double quote. Returns NULL if not well-formed. */
static char *
quoted_body(char *line)
{
    char *a = strchr(line, '"');
    char *b = a ? strrchr(line, '"') : NULL;

    if (!a || b == a)
        return NULL;
    *b = '\0';
    return a + 1;
}

static int
read_global(struct reader *r, struct ir_global *g)
{
    char *tok[MAX_TOKENS];
    int n, k, ninit = 0, ii = 0;
    struct arena *a = &r->m->arena;

    n = tokenize(r->lines[r->pos], tok);
    /* .global <name> <base> [array <n>] [align <a>] [local] [ptr] [export] [rodata] [from <unit>] */
    if (n < 3) {
        fail(r, r->pos + 1, "malformed .global");
        return -1;
    }
    g->name = arena_strdup(a, tok[1]);
    g->base_type = base_type_by_name(tok[2]);
    if (g->base_type < 0) {
        fail(r, r->pos + 1, "unknown base type");
        return -1;
    }
    for (k = 3; k < n; k++) {
        if (strcmp(tok[k], "array") == 0 && k + 1 < n)
            g->arr_size = (int)strtol(tok[++k], NULL, 10);
        else if (strcmp(tok[k], "align") == 0 && k + 1 < n)
            g->align = (int)strtol(tok[++k], NULL, 10);
        else if (strcmp(tok[k], "local") == 0)
            g->is_local = 1;
        else if (strcmp(tok[k], "ptr") == 0)
            g->is_ptr = 1;
        else if (strcmp(tok[k], "export") == 0)
            g->is_export = 1;
        else if (strcmp(tok[k], "rodata") == 0)
            g->is_rodata = 1;
        else if (strcmp(tok[k], "strobj") == 0)
            g->is_strobj = 1;
        else if (strcmp(tok[k], "from") == 0 && k + 1 < n)
            g->from_unit = arena_strdup(a, tok[++k]);
    }
    /* The array size and alignment come from the text and size the global's
       storage when the module is loaded, so a corrupt image must not leave them
       negative or wild. */
    if (g->arr_size < 0 || g->arr_size > KPM_MAX_COUNT || g->align < 0) {
        fail(r, r->pos + 1, "global size or alignment out of range");
        return -1;
    }

    /* count .init lines in this block to size the initializer arrays */
    for (k = r->pos + 1; k < r->nlines; k++) {
        if (strncmp(r->lines[k], ".init", 5) == 0)
            ninit++;
        else if (strcmp(r->lines[k], ".endglobal") == 0)
            break;
    }
    if (ninit) {
        g->init_ivals = arena_zalloc(a, (size_t)ninit * sizeof(int64_t));
        g->init_syms = arena_zalloc(a, (size_t)ninit * sizeof(char *));
    }

    for (;;) {
        r->pos++;
        if (r->pos >= r->nlines) {
            fail(r, r->pos, "unterminated .global");
            return -1;
        }
        char *line = r->lines[r->pos];
        if (strcmp(line, ".endglobal") == 0)
            break;
        if (strncmp(line, ".init", 5) == 0) {
            n = tokenize(line, tok);
            if (n >= 3 && strcmp(tok[1], "sym") == 0)
                g->init_syms[ii++] = arena_strdup(a, tok[2]);
            else if (n >= 2)
                g->init_ivals[ii++] = (int64_t)strtoll(tok[1], NULL, 10);
            g->init_count = ii;
        } else if (strncmp(line, ".string", 7) == 0) {
            char *body = quoted_body(line);
            if (!body) {
                fail(r, r->pos + 1, "malformed .string");
                return -1;
            }
            g->init_string = unescape(a, body, &g->init_strlen);
        } else {
            fail(r, r->pos + 1, "unexpected line in .global");
            return -1;
        }
    }
    return 0;
}

/****************************************************************
 * Functions and instructions
 ****************************************************************/

/* Fill one instruction's operand fields from key=value tokens.

   A temp index (dst, a, b), a slot index, or a label index named in the text is
   validated against the counts the enclosing .func declared and already
   range-checked. The counts bound the arrays a backend indexes by these fields
   (temp_reg/temp_spill by ntemps, the slot table by nslots, the label table by
   nlabels), so an out-of-range index from a corrupt or hostile module would
   drive an out-of-bounds access downstream. Only a field the text actually
   provides is checked, so a field left at its default is never rejected.
   Returns 0 on success, or -1 with r's error set on a bad index. */
static int
set_operands(struct ir_insn *in, char **tok, int n, struct ir_func *fn,
             struct reader *r)
{
    struct arena *a = &r->m->arena;
    int seen_slot = 0, seen_label = 0;

    for (int k = 1; k < n; k++) {
        char *eq = strchr(tok[k], '=');
        char *key = tok[k];
        char *val;
        long v;

        if (!eq)
            continue;
        *eq = '\0';
        val = eq + 1;
        /* A temp index of -1 is the "none" sentinel ir_emit initializes dst/a/b
           to, and the backends guard on (a result is written only when dst >= 0).
           CALL2 with a discarded primary value emits dst=-1, so the reader must
           accept it; any other negative value is still out of range. */
        if (strcmp(key, "dst") == 0) {
            v = strtol(val, NULL, 10);
            if (v < -1 || v >= fn->ntemps)
                goto bad_temp;
            in->dst = (int)v;
        } else if (strcmp(key, "a") == 0) {
            v = strtol(val, NULL, 10);
            if (v < -1 || v >= fn->ntemps)
                goto bad_temp;
            in->a = (int)v;
        } else if (strcmp(key, "b") == 0) {
            v = strtol(val, NULL, 10);
            if (v < -1 || v >= fn->ntemps)
                goto bad_temp;
            in->b = (int)v;
        } else if (strcmp(key, "imm") == 0) {
            in->imm = strtoll(val, NULL, 10);
        } else if (strcmp(key, "slot") == 0) {
            v = strtol(val, NULL, 10);
            if (v < 0 || v >= fn->nslots) {
                fail(r, r->pos + 1, "slot index out of range");
                return -1;
            }
            in->slot = (int)v;
            seen_slot = 1;
        } else if (strcmp(key, "label") == 0) {
            v = strtol(val, NULL, 10);
            if (v < 0 || v >= fn->nlabels) {
                fail(r, r->pos + 1, "label index out of range");
                return -1;
            }
            in->label = (int)v;
            seen_label = 1;
        } else if (strcmp(key, "nargs") == 0) {
            in->nargs = (int)strtol(val, NULL, 10);
        } else if (strcmp(key, "sym") == 0) {
            in->sym = arena_strdup(a, val);
        }
    }

    /* An opcode the backend indexes by slot or label must carry that field; the
       -1 ir_emit leaves otherwise would index a frame or label array out of
       bounds downstream (the field is range-checked above when present). */
    if (op_needs_slot(in->op) && !seen_slot) {
        fail(r, r->pos + 1, "missing slot operand");
        return -1;
    }
    if (op_needs_label(in->op) && !seen_label) {
        fail(r, r->pos + 1, "missing label operand");
        return -1;
    }
    return 0;

bad_temp:
    fail(r, r->pos + 1, "temp index out of range");
    return -1;
}

static void
read_int_list(char **tok, int n, int *out, int max)
{
    for (int k = 1; k < n && k - 1 < max; k++)
        out[k - 1] = (int)strtol(tok[k], NULL, 10);
}

/* A digit, without pulling in ctype. */
static int
kpm_isdigit(char c)
{
    return c >= '0' && c <= '9';
}

/* Parse one extended-asm operand descriptor "role,constraint,temp,size" (role is
   'o' output, 'i' input, 'b' inout) into op, with temp range-checked against
   ntemps. Mutates desc in place. Returns 0, or -1 if malformed or out of range. */
static int
parse_asm_op(struct arena *a, char *desc, struct ir_asm_op *op, int ntemps)
{
    char *role = desc, *constraint, *temp_s, *size_s, *c;
    long t, sz;

    c = strchr(desc, ',');       if (!c) return -1; *c = '\0'; constraint = c + 1;
    c = strchr(constraint, ',');  if (!c) return -1; *c = '\0'; temp_s = c + 1;
    c = strchr(temp_s, ',');      if (!c) return -1; *c = '\0'; size_s = c + 1;
    if (role[0] != 'o' && role[0] != 'i' && role[0] != 'b')
        return -1;
    t = strtol(temp_s, NULL, 10);
    sz = strtol(size_s, NULL, 10);
    if (t < 0 || t >= ntemps || sz <= 0 || sz > 8)
        return -1;
    op->constraint = arena_strdup(a, constraint);
    op->pin_reg = NULL;
    op->temp = (int)t;
    op->size = (int)sz;
    op->is_output = (role[0] == 'o' || role[0] == 'b');
    op->is_inout = (role[0] == 'b');
    return 0;
}

static int
read_func(struct reader *r, struct ir_func *fn)
{
    char *tok[MAX_TOKENS];
    int n, k;
    struct arena *a = &r->m->arena;

    n = tokenize(r->lines[r->pos], tok);
    /* .func <name> [local] [from <unit>] [variadic] params N slots N temps N labels N */
    if (n < 2) {
        fail(r, r->pos + 1, "malformed .func");
        return -1;
    }
    fn->name = arena_strdup(a, tok[1]);
    for (k = 2; k < n; k++) {
        if (strcmp(tok[k], "local") == 0) fn->is_local = 1;
        else if (strcmp(tok[k], "variadic") == 0) fn->is_variadic = 1;
        else if (strcmp(tok[k], "from") == 0 && k + 1 < n)
            fn->from_unit = arena_strdup(a, tok[++k]);
        else if (strcmp(tok[k], "params") == 0 && k + 1 < n)
            fn->nparams = (int)strtol(tok[++k], NULL, 10);
        else if (strcmp(tok[k], "slots") == 0 && k + 1 < n)
            fn->nslots = (int)strtol(tok[++k], NULL, 10);
        else if (strcmp(tok[k], "temps") == 0 && k + 1 < n)
            fn->ntemps = (int)strtol(tok[++k], NULL, 10);
        else if (strcmp(tok[k], "labels") == 0 && k + 1 < n)
            fn->nlabels = (int)strtol(tok[++k], NULL, 10);
    }
    /* Counts come straight from the text, so a corrupt or hostile image can make
       them negative or wild. Reject those before any is used as an allocation
       size or an IR array bound. */
    if (fn->nparams < 0 || fn->nparams > KPM_MAX_COUNT ||
        fn->nslots < 0 || fn->nslots > KPM_MAX_COUNT ||
        fn->ntemps < 0 || fn->ntemps > KPM_MAX_COUNT ||
        fn->nlabels < 0 || fn->nlabels > KPM_MAX_COUNT) {
        fail(r, r->pos + 1, "function count out of range");
        return -1;
    }
    /* Every parameter is spilled to a home slot in the prologue, so the first
       nparams slots are the parameter homes: the backend reads the frame's slot
       table at each parameter index. A module declaring more parameters than
       slots would drive that read past the table, so require the invariant the
       toolkit's own output always holds. */
    if (fn->nparams > fn->nslots) {
        fail(r, r->pos + 1, "more parameters than slots");
        return -1;
    }
    if (fn->nslots)
        fn->slot_size = arena_zalloc(a, (size_t)fn->nslots * sizeof(int));
    if (fn->nparams) {
        fn->param_class = arena_zalloc(a, (size_t)fn->nparams * sizeof(int));
        fn->param_fw = arena_zalloc(a, (size_t)fn->nparams * sizeof(signed char));
    }

    for (;;) {
        r->pos++;
        if (r->pos >= r->nlines) {
            fail(r, r->pos, "unterminated .func");
            return -1;
        }
        char *line = r->lines[r->pos];
        if (strcmp(line, ".endfunc") == 0)
            break;
        if (line[0] == '.') {
            n = tokenize(line, tok);
            if (strcmp(tok[0], ".slotsize") == 0)
                read_int_list(tok, n, fn->slot_size, fn->nslots);
            else if (strcmp(tok[0], ".paramclass") == 0)
                read_int_list(tok, n, fn->param_class, fn->nparams);
            else if (strcmp(tok[0], ".paramfw") == 0) {
                for (int k = 1; k < n && k - 1 < fn->nparams; k++)
                    fn->param_fw[k - 1] = (signed char)strtol(tok[k], NULL, 10);
            }
            /* psABI hint lines are accepted and ignored for the v1 subset */
            else if (strcmp(tok[0], ".paramneb") != 0 &&
                     strcmp(tok[0], ".paramcls") != 0 &&
                     strcmp(tok[0], ".retneb") != 0 &&
                     strcmp(tok[0], ".retcls") != 0) {
                fail(r, r->pos + 1, "unexpected directive in .func");
                return -1;
            }
        } else {
            struct ir_insn *in;
            int op;
            /* ASM carries verbatim assembly text as a C-escaped quoted string
               that may contain spaces, so it is read from the raw line like a
               .string rather than split into key=value tokens (which tokenize,
               below, would do destructively). */
            if (strncmp(line, "ASM", 3) == 0 &&
                (line[3] == ' ' || line[3] == '\t')) {
                char *p = line + 3;
                int slen;
                while (*p == ' ' || *p == '\t')
                    p++;
                if (*p == '"') {
                    /* basic asm: the template is the whole quoted body */
                    char *body = quoted_body(line);
                    if (!body) {
                        fail(r, r->pos + 1, "malformed ASM");
                        return -1;
                    }
                    in = ir_emit(fn, IR_ASM);
                    in->sym = unescape(a, body, &slen);
                    continue;
                }
                /* extended asm: operand and clobber metadata, then the quoted
                   template last.  Decode the template first (quoted_body takes the
                   first and last quote of the q.. tail), then terminate the
                   metadata region at the opening quote and tokenize it. */
                {
                    char *q = strchr(p, '"');
                    char *body, *mtok[MAX_TOKENS];
                    struct ir_asm_info *info;
                    int mn, mi, no = -1, ni = -1, vol = 1, nc = 0, nops, ci, k;

                    if (!q || !(body = quoted_body(q))) {
                        fail(r, r->pos + 1, "malformed ASM");
                        return -1;
                    }
                    *q = '\0';
                    mn = tokenize(p, mtok);
                    for (mi = 0; mi < mn; mi++) {
                        if (strncmp(mtok[mi], "nout=", 5) == 0)
                            no = (int)strtol(mtok[mi] + 5, NULL, 10);
                        else if (strncmp(mtok[mi], "nin=", 4) == 0)
                            ni = (int)strtol(mtok[mi] + 4, NULL, 10);
                        else if (strncmp(mtok[mi], "vol=", 4) == 0)
                            vol = (int)strtol(mtok[mi] + 4, NULL, 10);
                        else if (mtok[mi][0] == 'c' && kpm_isdigit(mtok[mi][1]))
                            nc++;
                    }
                    if (no < 0 || ni < 0 || no > KPM_MAX_COUNT ||
                        ni > KPM_MAX_COUNT) {
                        fail(r, r->pos + 1, "malformed ASM operand counts");
                        return -1;
                    }
                    nops = no + ni;
                    info = arena_zalloc(a, sizeof *info);
                    info->noutputs = no;
                    info->ninputs = ni;
                    info->is_volatile = vol;
                    info->nclobbers = nc;
                    info->ops = nops ? arena_zalloc(a,
                        (size_t)nops * sizeof *info->ops) : NULL;
                    info->clobbers = nc ? arena_zalloc(a,
                        (size_t)nc * sizeof *info->clobbers) : NULL;
                    ci = 0;
                    for (mi = 0; mi < mn; mi++) {
                        char *eq = strchr(mtok[mi], '=');
                        if (!eq)
                            continue;
                        if (mtok[mi][0] == 'o' && kpm_isdigit(mtok[mi][1])) {
                            int oi = (int)strtol(mtok[mi] + 1, NULL, 10);
                            if (oi < 0 || oi >= nops ||
                                parse_asm_op(a, eq + 1, &info->ops[oi],
                                             fn->ntemps) != 0) {
                                fail(r, r->pos + 1, "malformed ASM operand");
                                return -1;
                            }
                        } else if (mtok[mi][0] == 'c' &&
                                   kpm_isdigit(mtok[mi][1])) {
                            if (ci < nc)
                                info->clobbers[ci++] = arena_strdup(a, eq + 1);
                        }
                    }
                    /* every operand slot must have been filled (a truncated or
                       missing descriptor would leave a NULL constraint) */
                    for (k = 0; k < nops; k++) {
                        if (!info->ops[k].constraint) {
                            fail(r, r->pos + 1, "missing ASM operand");
                            return -1;
                        }
                    }
                    in = ir_emit(fn, IR_ASM);
                    in->sym = unescape(a, body, &slen);
                    in->asm_info = info;
                    continue;
                }
            }
            n = tokenize(line, tok);
            if (n == 0)
                continue;
            op = op_by_name(tok[0]);
            if (op < 0) {
                fail(r, r->pos + 1, "unknown opcode");
                return -1;
            }
            in = ir_emit(fn, op);
            if (set_operands(in, tok, n, fn, r) != 0)
                return -1;
        }
    }

    /* Kobold's modules describe a parameter with the scalar `.paramclass`
       (0 = integer/pointer, 1 = float), but the shared instruction selectors read
       the psABI fields (param_cls, param_neb) that Skjegg's own front end fills.
       Every Kobold parameter is a single eightbyte, so derive those fields here:
       one register slot each, SSE (class 1) for a float and INTEGER otherwise.
       Without this a float parameter is classed INTEGER and read from the wrong
       register, so the callee sees zero. */
    if (fn->nparams && fn->param_class) {
        int pi;
        fn->param_neb = arena_zalloc(a, (size_t)fn->nparams * sizeof(signed char));
        fn->param_cls = arena_zalloc(a, (size_t)fn->nparams * 4 * sizeof(signed char));
        for (pi = 0; pi < fn->nparams; pi++) {
            fn->param_neb[pi] = 1;
            fn->param_cls[4 * pi] = (signed char)(fn->param_class[pi] == 1 ? 1 : 0);
        }
    }
    return 0;
}

/****************************************************************
 * Top-level parse
 ****************************************************************/

/* Split the text into trimmed line pointers within a mutable arena copy.
   Blank lines and ';' comment lines become empty strings. */
static void
split_lines(struct reader *r, const char *text, size_t len)
{
    struct arena *a = &r->m->arena;
    char *buf = arena_alloc(a, len + 1);
    int nlines = 1;

    memcpy(buf, text, len);
    buf[len] = '\0';
    for (size_t i = 0; i < len; i++)
        if (buf[i] == '\n')
            nlines++;

    r->lines = arena_alloc(a, (size_t)nlines * sizeof(char *));
    r->nlines = 0;

    char *p = buf;
    while (p) {
        char *nl = strchr(p, '\n');
        if (nl)
            *nl = '\0';
        char *line = p;
        /* strip a trailing CR and leading/trailing spaces */
        size_t l = strlen(line);
        if (l && line[l - 1] == '\r')
            line[--l] = '\0';
        while (*line == ' ' || *line == '\t')
            line++;
        l = strlen(line);
        while (l && (line[l - 1] == ' ' || line[l - 1] == '\t'))
            line[--l] = '\0';
        if (line[0] == ';')
            line = (char *)"";
        r->lines[r->nlines++] = line;
        p = nl ? nl + 1 : NULL;
    }
}

int
kpm_read(struct kpm_module *m, const char *text, size_t len,
         char *err, size_t errlen)
{
    struct reader r;
    struct ir_func *ftail = NULL;
    struct ir_global *gtail = NULL;
    int nimp = 0, nexp = 0, iimp = 0, iexp = 0, ndep = 0, idep = 0;

    memset(m, 0, sizeof(*m));
    arena_init(&m->arena);
    r.m = m;
    r.err = err;
    r.errlen = errlen;
    r.pos = 0;
    if (err && errlen)
        err[0] = '\0';
    split_lines(&r, text, len);

    /* header: the first non-empty line must be ".kpm 1" */
    while (r.pos < r.nlines && r.lines[r.pos][0] == '\0')
        r.pos++;
    if (r.pos >= r.nlines || strncmp(r.lines[r.pos], ".kpm", 4) != 0) {
        fail(&r, r.pos + 1, "missing .kpm header");
        goto err;
    }
    {
        char *tok[MAX_TOKENS];
        int n = tokenize(r.lines[r.pos], tok);
        if (n < 2 || strcmp(tok[1], "1") != 0) {
            fail(&r, r.pos + 1, "unsupported .kpm version");
            goto err;
        }
    }
    r.pos++;

    /* pre-count imports, exports, dependencies, and link-time constants to size their tables */
    for (int i = 0; i < r.nlines; i++) {
        if (kw(r.lines[i], ".import"))
            nimp++;
        else if (kw(r.lines[i], ".export"))
            nexp++;
        else if (kw(r.lines[i], ".uses"))
            ndep++;
    }
    if (nimp)
        m->imports = arena_zalloc(&m->arena,
                                  (size_t)nimp * sizeof(struct kp_import));
    if (nexp)
        m->exports = arena_zalloc(&m->arena, (size_t)nexp * sizeof(char *));
    if (ndep)
        m->deps = arena_zalloc(&m->arena, (size_t)ndep * sizeof(struct kp_dep));

    for (; r.pos < r.nlines; r.pos++) {
        char *line = r.lines[r.pos];
        char *tok[MAX_TOKENS];
        int n;

        if (line[0] == '\0')
            continue;
        /* Peek at the directive without mutating the line: read_import,
           read_global, and read_func each tokenize it from the top. */
        if (kw(line, ".target")) {
            n = tokenize(line, tok);
            if (n >= 2) {
                m->target = arena_strdup(&m->arena, tok[1]);
                /* An architecture tag binds the module to one Target: require an
                   exact match, since a cross-arch unit carries native-code and
                   ABI assumptions this backend cannot honor.  The legacy width
                   tags (ilp32/lp64) keep the looser width check for old modules
                   and hand-written reader fixtures; any other value (agnostic, a
                   hint) is left unchecked. */
                if (kpm_is_arch_tag(tok[1])) {
                    if (strcmp(tok[1], KPM_NATIVE_ARCH) != 0) {
                        char msg[128];
                        snprintf(msg, sizeof msg,
                                 "KPM target mismatch: module is %s, this backend is %s",
                                 tok[1], KPM_NATIVE_ARCH);
                        fail(&r, r.pos + 1, msg);
                        goto err;
                    }
                } else if ((strcmp(tok[1], "ilp32") == 0 || strcmp(tok[1], "lp64") == 0)
                    && strcmp(tok[1], KPM_NATIVE_TARGET) != 0) {
                    fail(&r, r.pos + 1,
                         strcmp(KPM_NATIVE_TARGET, "lp64") == 0
                         ? "KPM pointer-width mismatch: module is ilp32, this backend is lp64"
                         : "KPM pointer-width mismatch: module is lp64, this backend is ilp32");
                    goto err;
                }
            }
        } else if (kw(line, ".module")) {
            n = tokenize(line, tok);
            if (n >= 2) {
                if (strcmp(tok[1], "object") == 0)
                    m->kind = KP_MOD_OBJECT;
                else if (strcmp(tok[1], "library") == 0)
                    m->kind = KP_MOD_LIBRARY;
                else if (strcmp(tok[1], "executable") == 0)
                    m->kind = KP_MOD_EXECUTABLE;
                else {
                    fail(&r, r.pos + 1, "unknown module kind");
                    goto err;
                }
                /* an object module carries its own unit name, so the linker can match a
                   consumer's .uses against it for the fingerprint check */
                if (n >= 3)
                    m->name = arena_strdup(&m->arena, tok[2]);
            }
        } else if (kw(line, ".entry")) {
            n = tokenize(line, tok);
            if (n >= 2)
                m->entry = arena_strdup(&m->arena, tok[1]);
        } else if (kw(line, ".uses")) {
            /* A direct dependency and the interface fingerprint it was compiled against.
               ".uses <name> fingerprint <n>". The linker checks each against the loaded
               dependency's own interface fingerprint to reject interface skew. */
            n = tokenize(line, tok);
            if (n >= 4 && strcmp(tok[2], "fingerprint") == 0) {
                m->deps[idep].name = arena_strdup(&m->arena, tok[1]);
                m->deps[idep].fingerprint = (uint32_t)strtoul(tok[3], NULL, 10);
                idep++;
            } else if (n >= 2) {
                m->deps[idep].name = arena_strdup(&m->arena, tok[1]);
                m->deps[idep].fingerprint = 0;
                idep++;
            }
        } else if (kw(line, ".interface")) {
            /* A self-delimiting block a consumer type-checks a unit against without its
               bodies. The linker needs only the fingerprint (to match a consumer's .uses),
               so record it and skip to .endinterface (kp-module-format.md). */
            int j = r.pos + 1;
            n = tokenize(line, tok);
            if (n >= 3 && strcmp(tok[1], "fingerprint") == 0)
                m->iface_fp = (uint32_t)strtoul(tok[2], NULL, 10);
            while (j < r.nlines && !kw(r.lines[j], ".endinterface"))
                j++;
            if (j >= r.nlines) {
                fail(&r, r.pos + 1, "unterminated .interface");
                goto err;
            }
            r.pos = j;      /* the loop's r.pos++ steps past .endinterface */
        } else if (kw(line, ".file")) {
            char *body = quoted_body(line);
            if (body) {
                int flen;
                m->source_file = unescape(&m->arena, body, &flen);
            }
        } else if (kw(line, ".import")) {
            if (read_import(&r, &m->imports[iimp++]) != 0)
                goto err;
        } else if (kw(line, ".export")) {
            n = tokenize(line, tok);
            if (n >= 2)
                m->exports[iexp++] = arena_strdup(&m->arena, tok[1]);
        } else if (kw(line, ".global")) {
            struct ir_global *g = arena_zalloc(&m->arena, sizeof(*g));
            if (read_global(&r, g) != 0)
                goto err;
            if (gtail)
                gtail->next = g;
            else
                m->prog.globals = g;
            gtail = g;
        } else if (kw(line, ".func")) {
            struct ir_func *fn = ir_new_func(&m->arena, "");
            if (read_func(&r, fn) != 0)
                goto err;
            if (ftail)
                ftail->next = fn;
            else
                m->prog.funcs = fn;
            ftail = fn;
        } else {
            fail(&r, r.pos + 1, "unexpected top-level line");
            goto err;
        }
    }

    m->nimports = iimp;
    m->nexports = iexp;
    m->ndeps = idep;

    /* Debug info (-g): carry the .file hint onto each function for the line
       table.  Done after the loop since .file and .func may arrive in either
       order; it stays NULL (no .file emitted) when debug info is off. */
    for (struct ir_func *fn = m->prog.funcs; fn; fn = fn->next)
        fn->src_file = m->source_file;

    return 0;

err:
    /* On failure the module owns nothing usable: release the arena and
       zero the struct so the caller need not (and safely may) kpm_free. */
    arena_free(&m->arena);
    memset(m, 0, sizeof(*m));
    return -1;
}

void
kpm_free(struct kpm_module *m)
{
    arena_free(&m->arena);
    memset(m, 0, sizeof(*m));
}
