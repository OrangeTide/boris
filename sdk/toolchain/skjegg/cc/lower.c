/* lower.c : C AST to IR lowering */

#include "cc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

static struct arena *lower_arena;
static struct ir_func *cur_fn;
static struct ir_program *cur_prog;
static const char *cur_fn_name;
static int cur_fn_returns_float;
static int cur_fn_returns_i64;
static int cur_fn_ret_neb;              /* psABI: struct-return eightbytes (>0) */
static int cur_fn_ret_mem;             /* psABI: MEMORY struct return (hidden ptr) */
static int cur_fn_sret_slot;           /* slot holding the hidden result pointer */
static struct cc_type *cur_fn_ret_type;

/* Debug info (-g), see cc.h. */
int cc_debug = 0;
const char *cc_src_file = NULL;
static int last_loc_line;               /* last line marked in this function */

static struct ir_insn *
emit(int op)
{
    return ir_emit(cur_fn, op);
}

static int
new_temp(void)
{
    return ir_new_temp(cur_fn);
}

static int
new_label(void)
{
    return ir_new_label(cur_fn);
}

static int
lower_const(long v)
{
    struct ir_insn *ins = emit(IR_LIC);
    ins->dst = new_temp();
    ins->imm = v;
    return ins->dst;
}

static int
lower_const64(long long v)
{
    struct ir_insn *ins = emit(IR_LIC64);
    ins->dst = new_temp();
    ins->imm = v;
    return ins->dst;
}

static void
emit_label(int lab)
{
    struct ir_insn *ins = emit(IR_LABEL);
    ins->label = lab;
}

static void
emit_jmp(int lab)
{
    struct ir_insn *ins = emit(IR_JMP);
    ins->label = lab;
}

static void
emit_bnz(int t, int lab)
{
    struct ir_insn *ins = emit(IR_BNZ);
    ins->a = t;
    ins->label = lab;
}


/****************************************************************
 * Local slots
 ****************************************************************/

static int *slot_sizes;
static int *slot_aligns;
static int nslots;
static int slot_cap;

/* Allocate a local slot of `bytes` bytes.  `align` is the slot's natural
   alignment, recorded for backends that lay out the argument structure by
   alignment (MIPS o32); pass 0 to leave it unset, which lets a backend infer
   it from the size (exact for a scalar slot). */
static int
alloc_slot(int bytes, int align)
{
    if (nslots == slot_cap) {
        slot_cap = slot_cap ? slot_cap * 2 : 32;
        slot_sizes = realloc(slot_sizes, slot_cap * sizeof *slot_sizes);
        slot_aligns = realloc(slot_aligns, slot_cap * sizeof *slot_aligns);
    }
    slot_sizes[nslots] = bytes;
    slot_aligns[nslots] = align;
    return nslots++;
}

struct local {
    char *name;
    int slot;
    struct cc_type *type;
    char *static_name;
    char *asm_reg;      /* GNU local register variable binding, or NULL */
};

static struct local *locals;
static int nlocals;
static int local_cap;

static void
add_local(const char *name, int slot, struct cc_type *type)
{
    if (nlocals == local_cap) {
        local_cap = local_cap ? local_cap * 2 : 32;
        locals = realloc(locals, local_cap * sizeof *locals);
    }
    locals[nlocals].name = arena_strdup(lower_arena,name);
    locals[nlocals].slot = slot;
    locals[nlocals].type = type;
    locals[nlocals].static_name = NULL;
    locals[nlocals].asm_reg = NULL;
    nlocals++;
}

static struct local *
find_local(const char *name)
{
    for (int i = nlocals - 1; i >= 0; i--)
        if (strcmp(locals[i].name, name) == 0)
            return &locals[i];
    return NULL;
}

/* The physical register an extended-asm operand is pinned to, or NULL for a
   generic register operand.  A "{$reg}" constraint names it explicitly; a
   bare "r"/"=r"/"+r" operand whose expression is a GNU local register
   variable (register T x __asm__("$reg")) carries it on the variable. */
static char *
asm_operand_pin(struct cc_node *op)
{
    int i;

    for (i = 0; i < op->slen; i++)
        if (op->sval[i] == '{') {
            int j = i + 1, n = 0;
            while (j + n < op->slen && op->sval[j + n] != '}')
                n++;
            return arena_strndup(lower_arena, op->sval + j, n);
        }
    if (op->a && op->a->kind == ND_VAR) {
        struct local *lc = find_local(op->a->name);
        if (lc && lc->asm_reg)
            return lc->asm_reg;
    }
    return NULL;
}

/****************************************************************
 * Global tracking
 ****************************************************************/

struct global {
    char *name;
    struct cc_type *type;
    int is_func;
};

static struct global *globals;
static int nglobals;
static int global_cap;

/* A read-only object belongs in .rodata.  A const scalar or aggregate is
   read-only; an array is read-only when its element type is const (const char
   s[]); a pointer is read-only only when the pointer itself is const
   (int * const), which is_const marks, as opposed to a pointer to const
   (const int *).  An uninitialized read-only global still answers true here;
   the backend keeps it in .bss (no file image), so only initialized read-only
   globals reach .rodata. */
static int
type_is_readonly(struct cc_type *t)
{
    while (t && t->kind == TY_ARRAY)
        t = t->base;
    return t && t->is_const;
}

static void
add_global(const char *name, struct cc_type *type, int is_func)
{
    if (nglobals == global_cap) {
        global_cap = global_cap ? global_cap * 2 : 32;
        globals = realloc(globals, global_cap * sizeof *globals);
    }
    globals[nglobals].name = arena_strdup(lower_arena,name);
    globals[nglobals].type = type;
    globals[nglobals].is_func = is_func;
    nglobals++;
}

static struct global *
find_global(const char *name)
{
    for (int i = 0; i < nglobals; i++)
        if (strcmp(globals[i].name, name) == 0)
            return &globals[i];
    return NULL;
}

/****************************************************************
 * Break/continue/switch context
 ****************************************************************/

struct loop_ctx {
    int brk;
    int cont;
};

static struct loop_ctx loop_stack[64];
static int nloops;

struct switch_ctx {
    int end_label;
    int default_label;
    int ncases;
    long case_vals[256];
    int case_labels[256];
};

static struct switch_ctx *cur_switch;

/****************************************************************
 * Goto/label table
 ****************************************************************/

struct named_label {
    char *name;
    int label;
};

static struct named_label named_labels[256];
static int nnamed_labels;

static int
get_named_label(const char *name)
{
    for (int i = 0; i < nnamed_labels; i++)
        if (strcmp(named_labels[i].name, name) == 0)
            return named_labels[i].label;
    int lab = new_label();
    named_labels[nnamed_labels].name = arena_strdup(lower_arena,name);
    named_labels[nnamed_labels].label = lab;
    nnamed_labels++;
    return lab;
}

/****************************************************************
 * Type helpers for lowering
 ****************************************************************/

static void hit_ldouble(int line);

static int
type_to_ir(struct cc_type *t)
{
    if (!t)
        return IR_I32;
    switch (t->kind) {
    case TY_CHAR:      return IR_I8;
    case TY_SHORT:     return IR_I16;
    case TY_LONG_LONG: return IR_I64;
    case TY_LONG:      return CC_LONG_SIZE == 8 ? IR_I64 : IR_I32;
    case TY_PTR:
    case TY_FUNC:      return CC_PTR_SIZE == 8 ? IR_I64 : IR_I32;
    case TY_FLOAT16:   return IR_F64;   /* _Float16 computes as double */
    case TY_FLOAT:     return IR_F32;   /* native single precision */
    case TY_DOUBLE:    return IR_F64;
    case TY_LDOUBLE:
        hit_ldouble(0);
        return IR_I64;              /* unreachable: hit_ldouble does not return */
    default:           return IR_I32;
    }
}

/* long double has the correct ABI size for sizeof and struct layout, but no
   codegen representation (its value is 80-bit x87 on x86-64, 128-bit quad on
   arm64, neither of which the backends implement).  Every point where a long
   double value would be materialized or cross the ABI calls reject_ldouble;
   those points (emit_load / emit_store / a cast / a parameter, return,
   argument, local, or call) are the single source of truth for "uses long
   double".

   The reject is resolved by whether an `inline` function is being lowered.
   An inline definition may be omitted, which is exactly how musl's header
   helpers like __islessf (they reach long double only through a sizeof-guarded
   dead branch) are meant to work, so an inline that hits a reject is dropped:
   we longjmp back to a recovery point armed in lower_function and return no
   function.  Any other use is a hard error via die() -- the same longjmp-to-
   main machinery every other compile error already uses.  Because the recovery
   piggybacks on the actual reject points, the drop is complete by construction
   (no separate pre-scan to keep in sync).  A bare declaration (a header
   prototype) reaches no reject and is unaffected. */
static jmp_buf ldouble_recover;         /* function-scope drop for an inline */
static int ldouble_recover_active;

static void
hit_ldouble(int line)
{
    if (ldouble_recover_active)
        longjmp(ldouble_recover, 1);    /* drop the inline being lowered */
    if (line)
        die("lower:%d: long double is not supported (no 80-bit/128-bit float "
            "in this backend); use double", line);
    die("long double is not supported (no 80-bit/128-bit float in this "
        "backend); use double");
}

static void
reject_ldouble(struct cc_type *t, int line)
{
    if (t && t->kind == TY_LDOUBLE)
        hit_ldouble(line);
}

static int
pointee_size(struct cc_type *t)
{
    if (!t)
        return 4;
    struct cc_type *base = NULL;
    if (t->kind == TY_PTR)
        base = t->base;
    else if (t->kind == TY_ARRAY)
        base = t->base;
    if (!base)
        return 4;
    return cc_type_size(base);
}

static int
is_float_type(struct cc_type *t)
{
    return t && (t->kind == TY_FLOAT16 ||
                 t->kind == TY_FLOAT || t->kind == TY_DOUBLE);
}

/*
 * Float opcode width tag for a C type: `float` is native single precision
 * (FWIDTH_F32); `double` and `_Float16` compute as double (0).  A cc temp
 * holding a `float` value lives in an F32 register; float<->double
 * conversions go through IR_F32TOF64 / IR_F64TOF32.
 */
static int
fwidth(struct cc_type *t)
{
    return t && t->kind == TY_FLOAT ? FWIDTH_F32 : 0;
}

static int
is_double_type(struct cc_type *t)
{
    return t && (t->kind == TY_DOUBLE || t->kind == TY_FLOAT16);
}

/* Convert a double to an IEEE-754 binary16 (half) bit pattern, rounding to
 * nearest with ties to even. Used to fold a _Float16 literal into a 2-byte
 * global; the runtime uses the same mapping for load/store conversion. */
static uint16_t
double_to_half(double d)
{
    union { double d; uint64_t u; } v;
    v.d = d;
    uint64_t bits = v.u;
    uint16_t sign = (uint16_t)((bits >> 48) & 0x8000u);
    int exp = (int)((bits >> 52) & 0x7ff);
    uint64_t mant = bits & 0xfffffffffffffULL;

    if (exp == 0x7ff)                       /* inf / NaN */
        return sign | (mant ? 0x7e00u : 0x7c00u);
    if (exp == 0)                           /* double subnormal/zero underflows */
        return sign;

    int e = exp - 1023 + 15;                /* rebias to half's exponent */
    if (e >= 0x1f)                          /* overflow to inf */
        return sign | 0x7c00u;

    if (e <= 0) {                           /* subnormal half */
        mant |= 0x10000000000000ULL;        /* restore the implicit leading 1 */
        int shift = 43 - e;
        if (shift >= 64)
            return sign;                    /* too small, flush to zero */
        uint64_t q = mant >> shift;
        uint64_t rem = mant & (((uint64_t)1 << shift) - 1);
        uint64_t half = (uint64_t)1 << (shift - 1);
        if (rem > half || (rem == half && (q & 1)))
            q++;                            /* a carry into the exp field is intended */
        return sign | (uint16_t)q;
    }

    uint64_t frac = mant >> 42;             /* top 10 bits become the half fraction */
    uint64_t rem = mant & (((uint64_t)1 << 42) - 1);
    uint64_t half = (uint64_t)1 << 41;
    uint16_t out = sign | (uint16_t)(e << 10) | (uint16_t)frac;
    if (rem > half || (rem == half && (frac & 1)))
        out++;                              /* carry ripples correctly into exp */
    return out;
}

static int
is_i64_type(struct cc_type *t)
{
    if (!t)
        return 0;
    if (t->kind == TY_LONG_LONG)
        return 1;
    /* under LP64, `long` is a 64-bit type too (same IR_I64 machinery) */
    if (CC_LONG_SIZE == 8 && t->kind == TY_LONG)
        return 1;
    /* under LP64 a pointer / function designator is an 8-byte value, so it
       rides the i64 storage, comparison, and int<->pointer cast paths;
       pointer arithmetic is handled separately with the address helpers */
    if (CC_PTR_SIZE == 8 && (t->kind == TY_PTR || t->kind == TY_FUNC))
        return 1;
    return 0;
}

static int
is_bool_type(struct cc_type *t)
{
    return t && t->is_bool;
}

static int
widen_to_i64(int val, struct cc_type *src_type)
{
    if (src_type && is_i64_type(src_type))
        return val;
    /* An array or function value decays to its address in a value context, so
       under LP64 it is already i64-wide (the address came from an IR_LEA64);
       re-extending it through SEXT64 keeps only the low 32 bits and corrupts a
       high address.  Only a genuinely narrow integer is widened. */
    if (src_type && (src_type->kind == TY_ARRAY || src_type->kind == TY_FUNC) &&
        CC_PTR_SIZE == 8)
        return val;
    int op = (src_type && src_type->is_unsigned) ? IR_ZEXT64 : IR_SEXT64;
    struct ir_insn *ins = emit(op);
    ins->dst = new_temp();
    ins->a = val;
    return ins->dst;
}

/* Widen a value that is one branch of a wider expression (e.g. a ternary whose
   result type is i64/pointer).  The array/function decay guard now lives in
   widen_to_i64, so this is a thin alias kept for call-site clarity. */
static int
widen_branch_to_i64(int val, struct cc_type *bt)
{
    return widen_to_i64(val, bt);
}

/****************************************************************
 * Forward declarations
 ****************************************************************/

static int lower_expr(struct cc_node *n);
static int lower_addr(struct cc_node *n);
static int val_is_wide(struct cc_type *t);
static void lower_stmt(struct cc_node *n);
static void lower_cond(struct cc_node *n, int ltrue, int lfalse);
static struct cc_type *lvalue_type(struct cc_node *n);
static void index_operands(struct cc_node *n, struct cc_node **basep,
                           struct cc_node **idxp);
static void lower_local_decl(struct cc_node *n);
static void lower_global_decl(struct cc_node *gn);
static const char *compound_lit_global(struct cc_node *n);
static const char *compound_lit_local(struct cc_node *n);

/****************************************************************
 * Emit a typed load from an address
 ****************************************************************/

static int
emit_load(int addr_temp, struct cc_type *t)
{
    struct ir_insn *ins;
    /* the universal value-load path: catch a long double loaded from a struct
       field, global, or array element, which bypasses the ABI-boundary checks */
    reject_ldouble(t, 0);
    if (is_float_type(t)) {
        if (t->kind == TY_FLOAT16) {
            ins = emit(IR_FLH);
        } else {
            ins = emit(IR_FLD);
            ins->imm = fwidth(t);       /* native single for float */
        }
        ins->dst = new_temp();
        ins->a = addr_temp;
        return ins->dst;
    }
    if (val_is_wide(t)) {
        ins = emit(IR_LD64);
        ins->dst = new_temp();
        ins->a = addr_temp;
        return ins->dst;
    }
    int sz = cc_type_size(t);
    if (sz == 1) {
        ins = emit(t->is_unsigned ? IR_LB : IR_LBS);
    } else if (sz == 2) {
        ins = emit(t->is_unsigned ? IR_LH : IR_LHS);
    } else {
        ins = emit(IR_LW);
    }
    ins->dst = new_temp();
    ins->a = addr_temp;
    return ins->dst;
}

static int is_aggregate(struct cc_type *t);
static void emit_aggregate_copy(int dst, int src, int size);
static int emit_addr_sym(const char *sym);

static void
emit_store(int addr_temp, int val_temp, struct cc_type *t)
{
    struct ir_insn *ins;
    reject_ldouble(t, 0);           /* a long double stored to a field/global */
    if (is_aggregate(t)) {
        /* value-semantic copy: val_temp is the source aggregate's address */
        emit_aggregate_copy(addr_temp, val_temp, cc_type_size(t));
        return;
    }
    if (is_float_type(t)) {
        if (t->kind == TY_FLOAT16) {
            ins = emit(IR_FSH);
        } else {
            ins = emit(IR_FSD);
            ins->imm = fwidth(t);       /* native single for float */
        }
        ins->a = addr_temp;
        ins->b = val_temp;
        return;
    }
    if (val_is_wide(t)) {
        ins = emit(IR_ST64);
        ins->a = addr_temp;
        ins->b = val_temp;
        return;
    }
    int sz = cc_type_size(t);
    if (sz == 1)
        ins = emit(IR_SB);
    else if (sz == 2)
        ins = emit(IR_SH);
    else
        ins = emit(IR_SW);
    ins->a = addr_temp;
    ins->b = val_temp;
}

/*
 * Convert a value of type `from` to a float type `to`, inserting the needed
 * conversion op (int -> float via IR_ITOF, or float <-> double via
 * IR_F32TOF64 / IR_F64TOF32).  Used where a value is stored or passed into a
 * float slot whose width may differ (e.g. `float x = 10;`).
 */
static int
to_float(int val, struct cc_type *from, struct cc_type *to)
{
    struct ir_insn *ins;

    if (!is_float_type(to))
        return val;
    if (!is_float_type(from)) {                 /* int -> float */
        if (is_i64_type(from)) {
            ins = emit(IR_TRUNC64);
            ins->dst = new_temp();
            ins->a = val;
            val = ins->dst;
        }
        ins = emit(IR_ITOF);
        ins->dst = new_temp();
        ins->a = val;
        ins->imm = fwidth(to);
        return ins->dst;
    }
    if (fwidth(from) != fwidth(to)) {            /* float <-> double */
        ins = emit(fwidth(to) == FWIDTH_F32 ? IR_F64TOF32 : IR_F32TOF64);
        ins->dst = new_temp();
        ins->a = val;
        return ins->dst;
    }
    return val;
}

/****************************************************************
 * String literal pool
 ****************************************************************/

static int str_counter;

static int
emit_string_literal(const char *s, int len)
{
    char namebuf[32];
    snprintf(namebuf, sizeof namebuf, "__str_%d", str_counter++);

    struct ir_global *g = arena_zalloc(lower_arena, sizeof *g);
    g->name = arena_strdup(lower_arena, namebuf);
    g->base_type = IR_I8;
    g->arr_size = len + 1;
    g->is_local = 1;
    g->init_string = arena_alloc(lower_arena, len + 1);
    memcpy(g->init_string, s, len);
    g->init_string[len] = '\0';
    g->init_strlen = len + 1;
    g->next = cur_prog->globals;
    cur_prog->globals = g;

    /* a string literal's address is address-width (LEA64 under LP64) */
    return emit_addr_sym(namebuf);
}

/****************************************************************
 * Static initializer flattening
 ****************************************************************/

static int
count_init_flat(struct cc_node *n)
{
    int count = 0;
    for (struct cc_node *e = n->body; e; e = e->next) {
        if (e->kind == ND_INIT_LIST)
            count += count_init_flat(e);
        else
            count++;
    }
    return count;
}

static char *
emit_string_global(const char *s, int len)
{
    char namebuf[32];
    snprintf(namebuf, sizeof namebuf, "__str_%d", str_counter++);

    struct ir_global *g = arena_zalloc(lower_arena, sizeof *g);
    g->name = arena_strdup(lower_arena, namebuf);
    g->base_type = IR_I8;
    g->arr_size = len + 1;
    g->is_local = 1;
    g->init_string = arena_alloc(lower_arena, len + 1);
    memcpy(g->init_string, s, len);
    g->init_string[len] = '\0';
    g->init_strlen = len + 1;
    g->next = cur_prog->globals;
    cur_prog->globals = g;

    return arena_strdup(lower_arena, namebuf);
}

static void encode_scalar(struct cc_type *t, struct cc_node *e,
                          int64_t *val, char **sym);

/* Resolve an address-constant initializer (&a[2], a + 2, "s" + 1, &s.f, a
   function/array name) to a symbol plus a byte addend.  Returns 1 and sets
   (*sym, *addend); returns 0 for anything that is not symbol-relative (an
   integer-constant pointer such as (int *)0x1000 is the caller's fallback).
   Defined after lvalue_type, which supplies the declared types the stride and
   member-offset arithmetic needs (initializer nodes carry no computed type). */
static int fold_addr(struct cc_node *e, char **sym, int64_t *addend);

/* Fold an integer constant expression, including an address constant that
   reduces to a pure number (the offsetof idiom).  Defined after fold_addr. */
static int64_t fold_int_const(struct cc_node *e);

/* The scalar leaf type of an aggregate laid out through the flat init_ivals
   path: strip array dimensions (a flat array, or a nested flat array, fills
   its innermost scalar), or the type itself for a braced scalar (int x = {5}). */
static struct cc_type *
flat_elem_type(struct cc_type *t)
{
    while (t && t->kind == TY_ARRAY)
        t = t->base;
    return t;
}

/* flatten an initializer list into the flat (ivals, syms) slots, encoding each
   scalar leaf against the element type et so a float literal, a negated
   literal, or a constant expression all land correctly (not just int literals) */
static void
flatten_init(struct cc_type *et, struct cc_node *n,
             int64_t *ivals, char **syms, int *pos)
{
    for (struct cc_node *e = n->body; e; e = e->next) {
        if (e->kind == ND_INIT_LIST) {
            flatten_init(et, e, ivals, syms, pos);
        } else {
            encode_scalar(et, e, &ivals[*pos], &syms[*pos]);
            (*pos)++;
        }
    }
}

/****************************************************************
 * Aggregate global initializer -> byte image
 *
 * An initialized struct/union global (or an array whose element is one) is
 * lowered to a list of ir_init chunks: the type tree is walked in declaration
 * order, and each scalar leaf of a flattened initializer is placed at its
 * field/element byte offset (so padding is left as zero and doubles/i64/ptr
 * fields land aligned).  Brace elision falls out naturally: the initializer is
 * flattened to a leaf list and consumed by a cursor as the type is walked, so
 * both {1,{2,3}} and {1,2,3} fill the same slots.
 ****************************************************************/

/* a cursor over the elements of one initializer-list level */
struct init_cursor {
    struct cc_node *cur;
};

/* true when the type must be laid out through the byte-image builder rather
   than the flat init_ivals path (an aggregate, or an array of one) */
static int
needs_image(struct cc_type *t)
{
    if (!t)
        return 0;
    if (t->kind == TY_STRUCT || t->kind == TY_UNION)
        return 1;
    if (t->kind == TY_ARRAY)
        return needs_image(t->base);
    return 0;
}

/* use the byte-image path for an aggregate, or for any array with a designated
   initializer (indexed placement and zeroed gaps need the image, not the flat
   sequential init_ivals) */
static int
wants_image(struct cc_type *t, struct cc_node *init)
{
    if (needs_image(t))
        return 1;
    if (t && t->kind == TY_ARRAY && init && init->kind == ND_INIT_LIST) {
        for (struct cc_node *e = init->body; e; e = e->next)
            if (e->kind == ND_DESIG)
                return 1;
    }
    return 0;
}

/* True when a constant expression is integer-valued, so it must fold with
   integer semantics (`1 / 2` is 0).  Prefer the node's static type, but a
   file-scope initializer's operator nodes carry no type (only the leaves do),
   so fall back to the operand types: an arithmetic node is integer when all
   its operands are. */
static int
const_expr_is_integer(struct cc_node *e)
{
    if (!e)
        return 0;
    if (e->type)
        return cc_type_is_integer(e->type);
    switch (e->kind) {
    case ND_INTLIT:   return 1;
    case ND_FLOATLIT: return 0;
    case ND_CAST:     return const_expr_is_integer(e->a);
    case ND_UNOP:     return const_expr_is_integer(e->a);
    case ND_BINOP:    return const_expr_is_integer(e->a) &&
                             const_expr_is_integer(e->b);
    case ND_TERNARY:  return const_expr_is_integer(e->b) &&
                             const_expr_is_integer(e->c);
    default:          return 0;
    }
}

/* Evaluate a float or double constant expression to a double.  The floating
   counterpart of the parser's integer const_eval (cc_const_eval), so a static
   initializer such as `1.5 + 2.0` folds to a value instead of silently
   becoming zero.  It is type-aware: an integer-valued subexpression keeps
   integer semantics (`1 / 2` is 0, not 0.5) by folding through cc_const_eval.
   Dies on a non-constant operand, the correct diagnostic for a static
   initializer. */
static double
fold_float_const(struct cc_node *e)
{
    if (!e)
        die("expected constant expression");
    if (const_expr_is_integer(e))
        return (double)cc_const_eval(e);
    switch (e->kind) {
    case ND_FLOATLIT:
        return e->fval;
    case ND_CAST:
        /* a float-to-float cast is value-preserving for this fold */
        return fold_float_const(e->a);
    case ND_UNOP:
        if (e->op == TOK_MINUS)
            return -fold_float_const(e->a);
        if (e->op == TOK_PLUS)
            return fold_float_const(e->a);
        break;
    case ND_BINOP: {
        double a = fold_float_const(e->a);
        double b = fold_float_const(e->b);
        switch (e->op) {
        case TOK_PLUS:  return a + b;
        case TOK_MINUS: return a - b;
        case TOK_STAR:  return a * b;
        case TOK_SLASH: return a / b;
        default:        break;
        }
        break;
    }
    case ND_TERNARY:
        return cc_const_eval(e->a) ? fold_float_const(e->b)
                                   : fold_float_const(e->c);
    default:
        break;
    }
    die("lower:%d: non-constant initializer", e->line);
    return 0;
}

/* encode one scalar leaf against its slot type into (val, sym) */
static void
encode_scalar(struct cc_type *t, struct cc_node *e, int64_t *val, char **sym)
{
    *val = 0;
    *sym = NULL;
    if (e->kind == ND_INTLIT) {
        if (t->kind == TY_DOUBLE) {
            union { double d; int64_t i; } u;
            u.d = (double)e->ival;
            *val = u.i;
        } else if (t->kind == TY_FLOAT) {
            union { float f; int32_t i; } u;
            u.f = (float)e->ival;
            *val = (uint32_t)u.i;
        } else if (t->kind == TY_FLOAT16) {
            *val = (uint16_t)double_to_half((double)e->ival);
        } else {
            *val = e->ival;
        }
    } else if (e->kind == ND_UNOP && e->op == TOK_MINUS && e->a &&
               (e->a->kind == ND_INTLIT || e->a->kind == ND_FLOATLIT)) {
        /* negate the operand in the slot's representation: for a float type
           flip the sign bit of the encoded pattern, for an integer negate. */
        encode_scalar(t, e->a, val, sym);
        if (t->kind == TY_DOUBLE)
            *val ^= (int64_t)((uint64_t)1 << 63);   /* shift unsigned: 1<<63
                                                       overflows a signed 64 */
        else if (t->kind == TY_FLOAT)
            *val ^= (int64_t)1 << 31;
        else if (t->kind == TY_FLOAT16)
            *val ^= (int64_t)1 << 15;
        else
            *val = -*val;
    } else if (e->kind == ND_FLOATLIT) {
        if (t->kind == TY_FLOAT) {
            union { float f; int32_t i; } u;
            u.f = (float)e->fval;
            *val = (uint32_t)u.i;
        } else if (t->kind == TY_FLOAT16) {
            *val = (uint16_t)double_to_half(e->fval);
        } else {
            union { double d; int64_t i; } u;
            u.d = e->fval;
            *val = u.i;
        }
    } else if (t->kind == TY_PTR) {
        /* a pointer slot: an address constant (&a[2], a + 2, "s" + 1, &var, a
           string or an array/function name) resolves to a symbol plus a byte
           addend carried in *val; otherwise an integer-constant pointer */
        if (!fold_addr(e, sym, val))
            *val = cc_const_eval(e);
    } else if (cc_type_is_integer(t)) {
        /* an integer slot initialized by a constant expression (A * B, 1 << N,
           or the offsetof idiom (size_t)&((T *)0)->m); a bare or negated
           literal matched above */
        *val = fold_int_const(e);
    } else if (t->kind == TY_FLOAT || t->kind == TY_DOUBLE ||
               t->kind == TY_FLOAT16) {
        /* a float or double constant expression (1.5 + 2.0, PI / 2): fold it
           and encode the result in the slot's representation */
        double d = fold_float_const(e);
        if (t->kind == TY_FLOAT) {
            union { float f; int32_t i; } u;
            u.f = (float)d;
            *val = (uint32_t)u.i;
        } else if (t->kind == TY_FLOAT16) {
            *val = (uint16_t)double_to_half(d);
        } else {
            union { double d; int64_t i; } u;
            u.d = d;
            *val = u.i;
        }
    } else {
        die("lower:%d: non-constant initializer", e->line);
    }
    /* a _Bool slot holds only 0 or 1: a nonzero constant (an integer, or a
       float whose encoded bits are nonzero) normalizes to 1 */
    if (is_bool_type(t) && !*sym)
        *val = (*val != 0);
}

/* number of initializable slots at aggregate level t */
static int
agg_nslots(struct cc_type *t)
{
    if (t->kind == TY_ARRAY)
        return t->array_len > 0 ? t->array_len : 0;
    if (t->kind == TY_UNION)
        return t->fields ? 1 : 0;
    int n = 0;
    for (struct cc_field *f = t->fields; f; f = f->next)
        n++;
    return n;
}

/* type and byte offset (within t) of slot `pos` */
static struct cc_type *
agg_slot(struct cc_type *t, int pos, int *off)
{
    if (t->kind == TY_ARRAY) {
        *off = pos * cc_type_size(t->base);
        return t->base;
    }
    struct cc_field *f = t->fields;
    for (int i = 0; i < pos && f; i++)
        f = f->next;
    if (!f) {
        *off = 0;
        return NULL;
    }
    *off = f->offset;
    return f->type;
}

static int
field_index(struct cc_type *t, const char *name)
{
    int i = 0;
    for (struct cc_field *f = t->fields; f; f = f->next, i++)
        if (f->name && strcmp(f->name, name) == 0)
            return i;
    return -1;
}

/* Resolve member `name` in struct/union `t`, descending through anonymous
   (unnamed) struct/union members per C11 6.7.2.1p13.  A direct named field
   wins; otherwise each anonymous member is searched in turn.  Returns the leaf
   cc_field, and adds the byte offset of the enclosing anonymous members (not
   the leaf's own f->offset) to *base_off, so the caller's byte offset of the
   access is *base_off + f->offset.  Returns NULL when `name` is not a member. */
static struct cc_field *
resolve_member(struct cc_type *t, const char *name, int *base_off)
{
    if (!t || (t->kind != TY_STRUCT && t->kind != TY_UNION))
        return NULL;
    for (struct cc_field *f = t->fields; f; f = f->next)
        if (f->name && strcmp(f->name, name) == 0)
            return f;
    for (struct cc_field *f = t->fields; f; f = f->next) {
        if (f->name || !f->type)
            continue;
        if (f->type->kind != TY_STRUCT && f->type->kind != TY_UNION)
            continue;
        int inner = 0;
        struct cc_field *g = resolve_member(f->type, name, &inner);
        if (g) {
            *base_off += f->offset + inner;
            return g;
        }
    }
    return NULL;
}

static int
is_aggregate(struct cc_type *t)
{
    return t && (t->kind == TY_STRUCT || t->kind == TY_UNION ||
                 t->kind == TY_ARRAY);
}

#ifdef CC_STRUCT_ABI
/* merge two SysV eightbyte classes (0 INTEGER, 1 SSE, -1 NO_CLASS); INTEGER
   dominates SSE, and either dominates NO_CLASS */
static int
eb_merge(int a, int b)
{
    if (a == -1)
        return b;
    if (b == -1)
        return a;
    if (a == 0 || b == 0)       /* INTEGER wins */
        return 0;
    return 1;                   /* both SSE */
}

/* accumulate the class of each eightbyte of `t` (placed at byte `base` inside
   the top-level aggregate) into cls[0..1] */
static void
eb_classify(struct cc_type *t, int base, int *cls)
{
    if (!t)
        return;
    if (t->kind == TY_STRUCT || t->kind == TY_UNION) {
        for (struct cc_field *f = t->fields; f; f = f->next)
            eb_classify(f->type, base + f->offset, cls);
        return;
    }
    if (t->kind == TY_ARRAY) {
        int es = cc_type_size(t->base), n = es ? cc_type_size(t) / es : 0;
        for (int k = 0; k < n; k++)
            eb_classify(t->base, base + k * es, cls);
        return;
    }
    /* a scalar leaf: class its eightbyte(s).  Well-aligned scalars do not
       cross an eightbyte boundary; class both ends to be safe. */
    int lo = base / 8, hi = (base + cc_type_size(t) - 1) / 8;
    int c = is_float_type(t) ? 1 : 0;
    if (lo <= 1)
        cls[lo] = eb_merge(cls[lo], c);
    if (hi <= 1 && hi != lo)
        cls[hi] = eb_merge(cls[hi], c);
}
#endif /* CC_STRUCT_ABI */

#if !defined(CC_ARM64) && !defined(CC_RISCV)
/* SysV eightbyte classification of a struct/union type.  Returns the number
   of eightbytes passed in registers (1 or 2) and fills cls[] with each one's
   class (0 INTEGER, 1 SSE); returns -1 for the MEMORY class (larger than 16
   bytes), or 0 if `t` is not a struct/union.  Gated to the psABI cc targets. */
static int
sysv_eightbytes(struct cc_type *t, int *cls)
{
#ifdef CC_STRUCT_ABI
    int sz, neb;
    cls[0] = cls[1] = -1;
    if (!t || (t->kind != TY_STRUCT && t->kind != TY_UNION))
        return 0;
    sz = cc_type_size(t);
    if (sz < 1)
        return 0;
    if (sz > 16)
        return -1;              /* MEMORY */
    neb = (sz + 7) / 8;
    eb_classify(t, 0, cls);
    if (cls[0] == -1)
        cls[0] = 0;
    if (neb == 2 && cls[1] == -1)
        cls[1] = 0;
    return neb;
#else
    (void)t;
    cls[0] = cls[1] = -1;
    return 0;
#endif
}
#endif /* !CC_ARM64 && !CC_RISCV */

#ifdef CC_ARM64
/* walk the leaves of a candidate HFA: every leaf must be the same floating
   type (float or double).  *elem records that type's kind, *n counts leaves. */
static int
hfa_walk(struct cc_type *t, int *elem, int *n)
{
    if (!t)
        return 0;
    if (t->kind == TY_UNION)
        return 0;                       /* unions are not HFAs here */
    if (t->kind == TY_STRUCT) {
        for (struct cc_field *f = t->fields; f; f = f->next)
            if (!hfa_walk(f->type, elem, n))
                return 0;
        return 1;
    }
    if (t->kind == TY_ARRAY) {
        int es = cc_type_size(t->base), cnt = es ? cc_type_size(t) / es : 0;
        for (int k = 0; k < cnt; k++)
            if (!hfa_walk(t->base, elem, n))
                return 0;
        return 1;
    }
    if (t->kind == TY_FLOAT || t->kind == TY_DOUBLE) {
        if (*elem == -1)
            *elem = t->kind;
        else if (*elem != t->kind)
            return 0;
        (*n)++;
        return 1;
    }
    return 0;                           /* a non-float leaf: not an HFA */
}

/* AAPCS64 aggregate classification.  Returns the number of register slots
   (1-4) and fills cls[] with each slot's class (0 = INTEGER/x-reg, 1 =
   double/d-reg, 2 = float/s-reg); returns -1 for the indirect (>16 byte)
   class, or 0 if `t` is not a struct/union.  A Homogeneous Floating-point
   Aggregate (1-4 members of one float type) rides the FP registers; any other
   aggregate of 16 bytes or less rides 1-2 x-registers; a larger one is passed
   by a pointer to a copy and returned through x8. */
static int
aapcs_agg(struct cc_type *t, int *cls)
{
    int sz, elem = -1, n = 0, j;
    cls[0] = cls[1] = cls[2] = cls[3] = -1;
    if (!t || (t->kind != TY_STRUCT && t->kind != TY_UNION))
        return 0;
    sz = cc_type_size(t);
    if (sz < 1)
        return 0;
    if (t->kind == TY_STRUCT && hfa_walk(t, &elem, &n) && n >= 1 && n <= 4) {
        /* a Homogeneous Floating-point Aggregate rides consecutive fp regs:
           a double HFA in d0..d3, a float HFA in s0..s3 */
        for (j = 0; j < n; j++)
            cls[j] = (elem == TY_FLOAT) ? 2 : 1;
        return n;
    }
    if (sz > 16)
        return -1;                      /* indirect */
    for (j = 0; j < (sz + 7) / 8; j++)
        cls[j] = 0;
    return (sz + 7) / 8;
}
#endif

#ifdef CC_RISCV
/* RISC-V ilp32 aggregate classification (the soft-float ABI skjegg's RV
   backend targets).  A struct/union whose size is at most 8 bytes (2 XLEN) is
   passed in 1-2 integer registers, one 4-byte word each; a larger one is
   passed by reference (a pointer to a caller copy).  Returns the word count
   (1-2), -1 for the by-reference class, or 0 if `t` is not a struct/union.
   Every slot is integer: float content does not change placement under ilp32
   (there is no HFA / FP-register rule), so cls[] is all zero. */
static int
rv_agg(struct cc_type *t, int *cls)
{
    int sz, j;
    cls[0] = cls[1] = cls[2] = cls[3] = -1;
    if (!t || (t->kind != TY_STRUCT && t->kind != TY_UNION))
        return 0;
    sz = cc_type_size(t);
    if (sz < 1)
        return 0;
    if (sz > 8)
        return -1;                      /* by reference */
    for (j = 0; j < (sz + 3) / 4; j++)
        cls[j] = 0;
    return (sz + 3) / 4;
}
#endif

/* target-neutral aggregate classifier: AAPCS64 on arm64, RISC-V ilp32 words on
   RISC-V, SysV eightbytes elsewhere.  Fills cls[0..3]; returns slot count
   (1-4), -1 for the memory/indirect class, or 0 if not a struct/union. */
static int
abi_agg(struct cc_type *t, int *cls)
{
#ifdef CC_ARM64
    return aapcs_agg(t, cls);
#elif defined(CC_RISCV)
    return rv_agg(t, cls);
#else
    cls[2] = cls[3] = -1;
    return sysv_eightbytes(t, cls);
#endif
}

/* A register-struct slot is a 4-byte word on RISC-V ilp32, an 8-byte eightbyte
   on the LP64 targets. */
#ifdef CC_RISCV
#define ABI_SLOT_BYTES 4
#else
#define ABI_SLOT_BYTES 8
#endif

/* true if `t` is passed in memory (SysV: a >16-byte stack copy; AAPCS64: a
   pointer to a copy, returned through x8) */
static int
abi_struct_mem(struct cc_type *t)
{
    int cls[4];
    return abi_agg(t, cls) < 0;
}

/* true if a by-value struct/union return is handed back through a hidden
   caller-allocated result pointer (a leading argument), rather than in
   registers.  The register-ABI targets use this only for their MEMORY class
   (abi_struct_mem).  ColdFire and MIPS do not classify a struct into return
   registers at all, so every struct return goes through the hidden pointer;
   this is what keeps the result in the caller's frame instead of a pointer
   into the callee's dead frame.  The pointer is CC_PTR_SIZE bytes, so the
   MEMORY paths that carry it key on the pointer size, not on one target. */
static int
ret_uses_hidden_ptr(struct cc_type *t)
{
#if defined(CC_M68K) || defined(CC_MIPS)
    if (t && (t->kind == TY_STRUCT || t->kind == TY_UNION))
        return 1;
#endif
    return abi_struct_mem(t);
}

/* emit one scalar (or char[]-from-string) leaf at byte offset off */
static struct ir_init *
emit_leaf(struct cc_type *t, struct cc_node *e, int off, struct ir_init *tail)
{
    if (t && t->kind == TY_ARRAY && cc_type_size(t->base) == 1 &&
        e->kind == ND_STRLIT) {
        for (int i = 0; i < e->slen; i++) {
            struct ir_init *it = arena_zalloc(lower_arena, sizeof *it);
            it->offset = off + i;
            it->size = 1;
            it->ival = (unsigned char)e->sval[i];
            tail->next = it;
            tail = it;
        }
        return tail;
    }
    struct ir_init *it = arena_zalloc(lower_arena, sizeof *it);
    it->offset = off;
    it->size = cc_type_size(t);
    encode_scalar(t, e, &it->ival, &it->sym);
    tail->next = it;
    return it;
}

/* the first scalar leaf inside a braced value (for a braced scalar {x}) */
static struct cc_node *
first_leaf(struct cc_node *e)
{
    while (e && e->kind == ND_INIT_LIST)
        e = e->body;
    if (e && e->kind == ND_DESIG)
        e = e->a;
    return e;
}

/*
 * Fill aggregate t (at byte offset `base`) from the element cursor.  Elements
 * are consumed in order; a `.field` / `[index]` designator repositions the
 * slot; a braced element initializes a sub-aggregate (recurse on its own
 * elements); an unbraced aggregate slot draws from the same cursor (brace
 * elision).  A missing initializer leaves the slot zero.
 */
static struct ir_init *
build_image(struct cc_type *t, struct init_cursor *cur, int base,
            struct ir_init *tail)
{
    if (!t)
        return tail;

    /* a whole char array initialized directly by a string literal */
    if (t->kind == TY_ARRAY && cc_type_size(t->base) == 1 &&
        cur->cur && cur->cur->kind == ND_STRLIT) {
        struct cc_node *s = cur->cur;
        cur->cur = s->next;
        return emit_leaf(t, s, base, tail);
    }

    int nslots = agg_nslots(t);
    int pos = 0;
    while (cur->cur) {
        struct cc_node *e = cur->cur;
        struct cc_type *ft;
        int off;

        if (e->kind == ND_DESIG) {
            if (t->kind == TY_ARRAY) {
                pos = (int)e->ival;
                if (pos < 0 || pos >= nslots)
                    die("lower:%d: designator out of range", e->line);
                ft = agg_slot(t, pos, &off);
            } else {
                int fi = field_index(t, e->name);
                if (fi >= 0) {
                    pos = fi;
                    if (pos < 0 || pos >= nslots)
                        die("lower:%d: designator out of range", e->line);
                    ft = agg_slot(t, pos, &off);
                } else {
                    /* a field reached through an anonymous struct/union member
                       (C11 6.7.2.1p13).  Build straight into the leaf at its
                       total offset and continue positionally after the whole
                       anonymous member. */
                    ft = NULL;
                    int idx = 0;
                    for (struct cc_field *af = t->fields; af;
                         af = af->next, idx++) {
                        if (af->name || !af->type)
                            continue;
                        if (af->type->kind != TY_STRUCT &&
                            af->type->kind != TY_UNION)
                            continue;
                        int extra = 0;
                        struct cc_field *lf =
                            resolve_member(af->type, e->name, &extra);
                        if (lf) {
                            ft = lf->type;
                            off = af->offset + extra + lf->offset;
                            pos = idx;
                            break;
                        }
                    }
                    if (!ft)
                        die("lower:%d: no field named '%s'", e->line, e->name);
                }
            }
            cur->cur = e->next;                /* consume the designator */
            if (e->a->kind == ND_INIT_LIST) {
                struct init_cursor sub = { e->a->body };
                tail = build_image(ft, &sub, base + off, tail);
            } else {
                tail = emit_leaf(ft, e->a, base + off, tail);
            }
            pos++;
            continue;
        }

        /* positional element: stop once the slots are full */
        if (pos >= nslots)
            break;
        ft = agg_slot(t, pos, &off);
        if (!ft)
            break;
        if (e->kind == ND_INIT_LIST) {
            cur->cur = e->next;
            if (is_aggregate(ft)) {
                struct init_cursor sub = { e->body };
                tail = build_image(ft, &sub, base + off, tail);
            } else {
                struct cc_node *lf = first_leaf(e);
                if (lf)
                    tail = emit_leaf(ft, lf, base + off, tail);
            }
        } else if (is_aggregate(ft) &&
                   !(ft->kind == TY_ARRAY &&
                     cc_type_size(ft->base) == 1 && e->kind == ND_STRLIT)) {
            /* brace elision: consume from the same cursor into ft */
            tail = build_image(ft, cur, base + off, tail);
        } else {
            cur->cur = e->next;
            tail = emit_leaf(ft, e, base + off, tail);
        }
        pos++;
    }
    return tail;
}

/* build the ir_init list for an aggregate global from its initializer node.
   Items are then sorted by offset (a designator can write out of order, and
   emit_globals pads forward), and an earlier write to a slot a later one
   overrode is dropped (same offset, last wins). */
static struct ir_init *
lower_aggregate_init(struct cc_type *t, struct cc_node *init)
{
    struct ir_init head = {0};
    struct init_cursor cur = { init->body };
    int n = 0, i;

    build_image(t, &cur, 0, &head);

    for (struct ir_init *it = head.next; it; it = it->next)
        n++;
    if (n <= 1)
        return head.next;

    struct ir_init **arr = arena_alloc(lower_arena, n * sizeof *arr);
    i = 0;
    for (struct ir_init *it = head.next; it; it = it->next)
        arr[i++] = it;

    /* stable insertion sort by offset (n is small); keeps append order among
       equal offsets so the last write to a slot stays last in its run */
    for (i = 1; i < n; i++) {
        struct ir_init *key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j]->offset > key->offset) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }

    struct ir_init *out = NULL, *tail = NULL;
    for (i = 0; i < n; i++) {
        if (i + 1 < n && arr[i + 1]->offset == arr[i]->offset)
            continue;   /* overridden by a later write to the same slot */
        arr[i]->next = NULL;
        if (!tail)
            out = arr[i];
        else
            tail->next = arr[i];
        tail = arr[i];
    }
    return out;
}

/* array length from an initializer, honoring [index] designators (C rule:
   the length is one past the highest index written) */
static int
infer_array_len(struct cc_node *initlist)
{
    int idx = 0, max = 0;
    for (struct cc_node *e = initlist->body; e; e = e->next) {
        if (e->kind == ND_DESIG && e->name == NULL)
            idx = (int)e->ival;
        if (idx + 1 > max)
            max = idx + 1;
        idx++;
    }
    return max;
}

/****************************************************************
 * Address of lvalue (returns temp holding the address)
 ****************************************************************/

/****************************************************************
 * Address model
 *
 * Under LP64 an address (and a pointer value) is 64-bit: the roots are
 * IR_LEA64 / IR_ADL64, arithmetic uses the *64 ops, and a pointer value is
 * loaded/stored 8 bytes wide.  Under ILP32 (CC_PTR_SIZE == 4) every helper
 * reduces to the original 32-bit ops, so the lowering is byte-identical.
 ****************************************************************/

#define ADDR64 (CC_PTR_SIZE == 8)

/* a value that occupies pointer width (8 bytes under LP64): a pointer or a
   function designator, on top of the genuine 64-bit integer types */
static int
val_is_wide(struct cc_type *t)
{
    if (is_i64_type(t))
        return 1;
    return ADDR64 && t && (t->kind == TY_PTR || t->kind == TY_FUNC);
}

static int
emit_addr_sym(const char *sym)
{
    struct ir_insn *ins = emit(ADDR64 ? IR_LEA64 : IR_LEA);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena, sym);
    return ins->dst;
}

static int
emit_addr_slot(int slot)
{
    struct ir_insn *ins = emit(ADDR64 ? IR_ADL64 : IR_ADL);
    ins->dst = new_temp();
    ins->slot = slot;
    return ins->dst;
}

/* an address-width integer constant (for a field offset / element size) */
static int
emit_addr_const(long v)
{
    struct ir_insn *ins = emit(ADDR64 ? IR_LIC64 : IR_LIC);
    ins->dst = new_temp();
    ins->imm = v;
    return ins->dst;
}

/* base + off, both already address-width */
static int
emit_addr_add(int base, int off)
{
    struct ir_insn *ins = emit(ADDR64 ? IR_ADD64 : IR_ADD);
    ins->dst = new_temp();
    ins->a = base;
    ins->b = off;
    return ins->dst;
}

/* copy `size` bytes from address src to address dst.  This is the aggregate
   (struct/union/array) value-semantic copy: an assignment, a local init from
   another aggregate, and, for the psABI, packing/unpacking a small struct
   argument all route through it.  Unrolled into 4/2/1-byte chunks. */
static void
emit_aggregate_copy(int dst, int src, int size)
{
    struct ir_insn *ins;
    int off = 0;
    while (size - off >= 4) {
        int sa = off ? emit_addr_add(src, emit_addr_const(off)) : src;
        ins = emit(IR_LW); ins->dst = new_temp(); ins->a = sa;
        int v = ins->dst;
        int da = off ? emit_addr_add(dst, emit_addr_const(off)) : dst;
        ins = emit(IR_SW); ins->a = da; ins->b = v;
        off += 4;
    }
    if (size - off >= 2) {
        int sa = off ? emit_addr_add(src, emit_addr_const(off)) : src;
        ins = emit(IR_LH); ins->dst = new_temp(); ins->a = sa;
        int v = ins->dst;
        int da = off ? emit_addr_add(dst, emit_addr_const(off)) : dst;
        ins = emit(IR_SH); ins->a = da; ins->b = v;
        off += 2;
    }
    if (size - off >= 1) {
        int sa = off ? emit_addr_add(src, emit_addr_const(off)) : src;
        ins = emit(IR_LB); ins->dst = new_temp(); ins->a = sa;
        int v = ins->dst;
        int da = off ? emit_addr_add(dst, emit_addr_const(off)) : dst;
        ins = emit(IR_SB); ins->a = da; ins->b = v;
    }
}

/* a - b, both already address-width */
static int
emit_addr_sub(int a, int b)
{
    struct ir_insn *ins = emit(ADDR64 ? IR_SUB64 : IR_SUB);
    ins->dst = new_temp();
    ins->a = a;
    ins->b = b;
    return ins->dst;
}

/* widen (or narrow) an integer index to address width (sign per its type) */
static int
widen_to_addr(int val, struct cc_type *src)
{
    struct ir_insn *ins;
    if (!ADDR64) {
        /* 32-bit addresses: a wide (i64) index must be truncated to its
           low 32 bits before it enters address arithmetic, so a 32-bit
           IR_ADD/IR_MUL never receives an i64 temp as an operand. */
        if (!val_is_wide(src))
            return val;
        ins = emit(IR_TRUNC64);
        ins->dst = new_temp();
        ins->a = val;
        return ins->dst;
    }
    if (val_is_wide(src))
        return val;
    ins = emit(src && src->is_unsigned ? IR_ZEXT64 : IR_SEXT64);
    ins->dst = new_temp();
    ins->a = val;
    return ins->dst;
}

/* index * elem_sz, address-width */
static int
emit_addr_scale(int idx, struct cc_type *idx_type, int elem_sz)
{
    int w = widen_to_addr(idx, idx_type);
    if (elem_sz == 1)
        return w;
    int sc = emit_addr_const(elem_sz);
    struct ir_insn *ins = emit(ADDR64 ? IR_MUL64 : IR_MUL);
    ins->dst = new_temp();
    ins->a = w;
    ins->b = sc;
    return ins->dst;
}

static int
lower_addr(struct cc_node *n)
{
    struct ir_insn *ins;
    (void)ins;

    switch (n->kind) {
    case ND_VAR: {
        struct local *lc = find_local(n->name);
        if (lc) {
            if (lc->static_name)
                return emit_addr_sym(lc->static_name);
            int a = emit_addr_slot(lc->slot);
#ifdef CC_M68K
            /* Big-endian: a sub-word scalar local lives in a word-rounded slot
               accessed with a full-word load/store, so its value byte(s) sit
               at the low-order end of the word, i.e. the high addresses.  Its
               address is therefore offset from the slot base by (word - size);
               a byte/half access through that pointer then reaches the same
               byte the word access uses.  Arrays and aggregates keep the slot
               base (their bytes run from it), and a static local is an exactly
               sized global, so neither is offset.  Little-endian targets keep
               the value at the slot base and need no adjustment. */
            {
                struct cc_type *t = lc->type;
                if (t && t->kind != TY_ARRAY && t->kind != TY_STRUCT &&
                    t->kind != TY_UNION && !is_float_type(t)) {
                    int sz = cc_type_size(t);
                    if (sz > 0 && sz < 4)
                        a = emit_addr_add(a, emit_addr_const(4 - sz));
                }
            }
#endif
            return a;
        }
        struct global *gl = find_global(n->name);
        if (!gl)
            die("lower:%d: undefined '%s'", n->line, n->name);
        return emit_addr_sym(n->name);
    }
    case ND_DEREF:
        return lower_expr(n->a);

    case ND_INDEX: {
        struct cc_node *bn, *xn;
        index_operands(n, &bn, &xn);
        int base = lower_expr(bn);
        int idx = lower_expr(xn);
        struct cc_type *arr_type = lvalue_type(bn);
        int elem_sz = pointee_size(arr_type);
        /* On a 32-bit-address target a wide (i64) index must be narrowed to
           address width, so its real type matters: a computed index (e.g. a
           64-bit `v % 10`) carries no parser-stamped n->b->type, so recover it
           with lvalue_type.  On a 64-bit-address target the index already is
           address width and the stamped type is kept, so that codegen is
           undisturbed. */
        struct cc_type *idx_type = ADDR64 ? xn->type : lvalue_type(xn);
        int scaled = emit_addr_scale(idx, idx_type, elem_sz);
        return emit_addr_add(base, scaled);
    }
    case ND_MEMBER: {
        struct cc_type *obj_type = lvalue_type(n->a);
        int obj_addr;
        if (obj_type && (obj_type->kind == TY_STRUCT || obj_type->kind == TY_UNION)) {
            obj_addr = lower_addr(n->a);
        } else {
            obj_addr = lower_expr(n->a);
            if (obj_type && obj_type->kind == TY_PTR)
                obj_type = obj_type->base;
        }
        if (!obj_type || (obj_type->kind != TY_STRUCT && obj_type->kind != TY_UNION))
            die("lower:%d: member access on non-struct", n->line);
        int extra = 0;
        struct cc_field *f = resolve_member(obj_type, n->name, &extra);
        if (!f)
            die("lower:%d: no field '%s'", n->line, n->name);
        int off = extra + f->offset;
        if (off == 0)
            return obj_addr;
        return emit_addr_add(obj_addr, emit_addr_const(off));
    }
    case ND_COMPOUND_LIT: {
        /* the anonymous object's address: an automatic local synthesized here */
        struct cc_node v = { 0 };
        v.kind = ND_VAR;
        v.line = n->line;
        v.name = (char *)compound_lit_local(n);
        return lower_addr(&v);
    }
    case ND_CALL: {
        /* A call returning a struct/union by value materializes its result in
           a hidden slot (register-return via IR_CALL_AGG, or the memory-return
           slot), and lower_expr yields that slot's address.  So a postfix
           `.member` / `[index]` directly on the call result (`mk().a`) has an
           address: the temporary's.  Only an aggregate return is addressable;
           taking the address of a scalar rvalue stays an error. */
        struct cc_type *rt = lvalue_type(n);
        if (rt && (rt->kind == TY_STRUCT || rt->kind == TY_UNION))
            return lower_expr(n);
        die("lower:%d: not an lvalue", n->line);
        return -1;
    }
    default:
        die("lower:%d: not an lvalue", n->line);
        return -1;
    }
}

/****************************************************************
 * _Generic selection (C11)
 ****************************************************************/

/* Structural type compatibility for choosing a _Generic association. The
   controlling type (already lvalue-converted and decayed) is matched against
   each association's type-name. This covers the scalar, pointer, and tagged
   types _Generic is used with; it distinguishes _Bool from char and matches
   pointers by their pointee. skj-cc does not model const/volatile/restrict
   (the parser discards them), so a qualified type and its unqualified form are
   the same type here, which also satisfies C11's rule that the controlling
   type is matched with its top-level qualifiers removed. */
static int
generic_type_match(struct cc_type *a, struct cc_type *b)
{
    if (!a || !b)
        return 0;
    if (a->kind != b->kind)
        return 0;
    switch (a->kind) {
    case TY_CHAR: case TY_SHORT: case TY_INT:
    case TY_LONG: case TY_LONG_LONG:
        return a->is_unsigned == b->is_unsigned && a->is_bool == b->is_bool;
    case TY_VOID:
    case TY_FLOAT16: case TY_FLOAT: case TY_DOUBLE: case TY_LDOUBLE:
    case TY_ENUM:
        return 1;
    case TY_PTR:
        return generic_type_match(a->base, b->base);
    case TY_ARRAY:
        return (a->array_len == b->array_len || a->array_len < 0
                || b->array_len < 0)
            && generic_type_match(a->base, b->base);
    case TY_STRUCT: case TY_UNION:
        if (a->tag && b->tag)
            return strcmp(a->tag, b->tag) == 0;
        return a == b;
    default:
        return a == b;
    }
}

/* Choose the association expression for a _Generic node. The controlling
   expression is not evaluated; only its type selects the branch, after lvalue
   conversion (array -> pointer, function -> pointer). The first type-name that
   matches wins; a `default` is the fallback. */
static struct cc_node *
generic_select(struct cc_node *n)
{
    struct cc_type *ct = lvalue_type(n->a);
    if (ct && ct->kind == TY_ARRAY)
        ct = cc_type_ptr(lower_arena, ct->base);
    else if (ct && ct->kind == TY_FUNC)
        ct = cc_type_ptr(lower_arena, ct);
    struct cc_node *dflt = NULL, *hit = NULL;
    for (struct cc_node *a = n->b; a; a = a->next) {
        if (!a->decl_type) {
            dflt = a;
            continue;
        }
        if (generic_type_match(ct, a->decl_type)) {
            if (hit)
                die("_Generic: the controlling type matches more than one "
                    "association at line %d", n->line);
            hit = a;
        }
    }
    if (hit)
        return hit->a;
    if (dflt)
        return dflt->a;
    die("_Generic: no association matches the controlling type at line %d",
        n->line);
    return NULL;
}

/* a[b] indexes whichever operand is the pointer or array; C permits either
   order (arr[i] and i[arr] denote the same element), so the pointer operand is
   the base and the other is the index. */
static void
index_operands(struct cc_node *n, struct cc_node **basep, struct cc_node **idxp)
{
    struct cc_type *at = lvalue_type(n->a);
    if (at && (at->kind == TY_PTR || at->kind == TY_ARRAY)) {
        *basep = n->a;
        *idxp = n->b;
    } else {
        *basep = n->b;
        *idxp = n->a;
    }
}

/****************************************************************
 * Type of an lvalue (for load/store sizing)
 ****************************************************************/

static struct cc_type *
lvalue_type(struct cc_node *n)
{
    switch (n->kind) {
    case ND_GENERIC:
        return lvalue_type(generic_select(n));
    case ND_VAR: {
        struct local *lc = find_local(n->name);
        if (lc) return lc->type;
        struct global *gl = find_global(n->name);
        if (gl) return gl->type;
        return cc_type_int();
    }
    case ND_DEREF: {
        struct cc_type *pt = lvalue_type(n->a);
        if (pt && pt->kind == TY_PTR)
            return pt->base;
        return cc_type_int();
    }
    case ND_INDEX: {
        struct cc_node *bn, *xn;
        index_operands(n, &bn, &xn);
        struct cc_type *at = lvalue_type(bn);
        if (at && (at->kind == TY_PTR || at->kind == TY_ARRAY))
            return at->base;
        return cc_type_int();
    }
    case ND_MEMBER: {
        struct cc_type *obj = lvalue_type(n->a);
        if (obj && obj->kind == TY_PTR)
            obj = obj->base;
        if (obj && (obj->kind == TY_STRUCT || obj->kind == TY_UNION)) {
            int extra = 0;
            struct cc_field *f = resolve_member(obj, n->name, &extra);
            if (f)
                return f->type;
        }
        return cc_type_int();
    }
    case ND_CAST:
        if (n->decl_type)
            return n->decl_type;
        return cc_type_int();
    case ND_COMPOUND_LIT:
        return n->decl_type ? n->decl_type : cc_type_int();
    case ND_ADDR: {
        struct cc_type *base = lvalue_type(n->a);
        return cc_type_ptr(lower_arena,base);
    }
    case ND_LABELADDR:
        /* &&label is a void* (GNU labels as values) */
        return cc_type_ptr(lower_arena, cc_type_void());
    /* ++x, x++, --x, x-- have the type of their operand.  Without this a
       dereference or index of the result (e.g. *p++ on a char*) loses the
       pointee size and defaults to an int-width access. */
    case ND_PRE_INC:
    case ND_PRE_DEC:
    case ND_POST_INC:
    case ND_POST_DEC:
        return lvalue_type(n->a);
    case ND_FLOATLIT:
        return n->type ? n->type : cc_type_int();
    case ND_INTLIT:
        return n->type ? n->type : cc_type_int();
    case ND_STRLIT:
        /* char[len+1] (the parser's type); sizeof measures the array and an
           index scales by the char element.  It decays to char* in value
           contexts through the ordinary TY_ARRAY handling. */
        return n->type ? n->type
                       : cc_type_array(lower_arena, cc_type_char(), n->slen + 1);
    case ND_UNOP:
        return lvalue_type(n->a);
    case ND_BINOP: {
        struct cc_type *lt = lvalue_type(n->a);
        struct cc_type *rt = lvalue_type(n->b);
        if (is_float_type(lt) || is_float_type(rt)) {
            static struct cc_type ty_double = { .kind = TY_DOUBLE };
            static struct cc_type ty_float  = { .kind = TY_FLOAT };
            return is_double_type(lt) || is_double_type(rt)
                   ? &ty_double : &ty_float;
        }
        /* a comparison yields int whatever the operand types */
        switch (n->op) {
        case TOK_EQ: case TOK_NE:
        case TOK_LT: case TOK_LE: case TOK_GT: case TOK_GE:
            return cc_type_int();
        default:
            break;
        }
        /* pointer arithmetic keeps the pointer type (ptr +/- int, and the
           prior result for ptr - ptr) */
        if (cc_type_is_ptr(lt))
            return lt;
        if (cc_type_is_ptr(rt))
            return rt;
        /* a shift's result is the promoted left operand; every other integer
           operator takes the usual arithmetic conversions (this subsumes the
           old "either operand i64 -> long long", and now carries the right
           signedness, e.g. long long + unsigned int stays signed) */
        if (n->op == TOK_SHL || n->op == TOK_SHR)
            return cc_type_promote(lt);
        return cc_type_usual_arith(lt, rt);
    }
    case ND_TERNARY: {
        /* a ? b : c has the common type of its branches.  Without this the
           surrounding context (an assignment, a call argument) mistypes an
           i64 or float result as int and loses the upper half. */
        struct cc_type *tb = lvalue_type(n->b);
        struct cc_type *tc = lvalue_type(n->c);
        if (is_float_type(tb) || is_float_type(tc)) {
            static struct cc_type ty_double = { .kind = TY_DOUBLE };
            static struct cc_type ty_float  = { .kind = TY_FLOAT };
            return is_double_type(tb) || is_double_type(tc)
                   ? &ty_double : &ty_float;
        }
        /* an array/function branch decays to a pointer in value context, so
           the ternary's type is that pointer, not the array: returning the
           array type here sizes the result slot wrong and loses the pointer's
           width (a string-literal branch is the common case). */
        if (tb && tb->kind == TY_ARRAY)
            return cc_type_ptr(lower_arena, tb->base);
        if (tb && tb->kind == TY_FUNC)
            return cc_type_ptr(lower_arena, tb);
        if (tc && tc->kind == TY_ARRAY)
            return cc_type_ptr(lower_arena, tc->base);
        if (tc && tc->kind == TY_FUNC)
            return cc_type_ptr(lower_arena, tc);
        if (cc_type_is_ptr(tb))
            return tb;
        if (cc_type_is_ptr(tc))
            return tc;
        if (tb && tc && cc_type_is_arith(tb) && cc_type_is_arith(tc))
            return cc_type_usual_arith(tb, tc);
        return tb ? tb : (tc ? tc : cc_type_int());
    }
    case ND_CALL: {
        if (n->a->kind == ND_VAR) {
            if (strcmp(n->a->name, "__builtin_va_arg") == 0 && n->decl_type)
                return n->decl_type;        /* generic va_arg types as its type */
            struct global *gl = find_global(n->a->name);
            if (gl && gl->type && gl->type->kind == TY_FUNC && gl->type->base)
                return gl->type->base;
        }
        /* an indirect call: the callee is a function pointer (or function), so
           the result type is the base of the pointed-to function type */
        struct cc_type *ct = lvalue_type(n->a);
        if (ct && ct->kind == TY_PTR)
            ct = ct->base;
        if (ct && ct->kind == TY_FUNC && ct->base)
            return ct->base;
        return cc_type_int();
    }
    default:
        return cc_type_int();
    }
}

/* Resolve a constant lvalue (one whose address is fixed at link time: a named
   object, an array element, a struct/union member) to a symbol plus a byte
   offset.  Returns 1 on success.  Strides and member offsets come from
   lvalue_type, since an initializer's nodes carry no computed type. */
static int
fold_lval_addr(struct cc_node *e, char **sym, int64_t *addend)
{
    switch (e->kind) {
    case ND_VAR:
        *sym = arena_strdup(lower_arena, e->name);
        return 1;
    case ND_COMPOUND_LIT:
        /* &(T){...}: the address of the anonymous static object */
        *sym = arena_strdup(lower_arena, compound_lit_global(e));
        return 1;
    case ND_INDEX: {
        /* base[idx]: the base must be an addressable array, not a pointer (a
           pointer base is a runtime load, not a link-time constant). Either
           operand may be the array (C allows i[arr]). */
        struct cc_node *bn, *xn;
        index_operands(e, &bn, &xn);
        struct cc_type *bt = lvalue_type(bn);
        if (!bt || bt->kind != TY_ARRAY)
            return 0;
        if (!fold_lval_addr(bn, sym, addend))
            return 0;
        *addend += cc_const_eval(xn) * cc_type_size(bt->base);
        return 1;
    }
    case ND_MEMBER: {
        /* s.field (direct); p->field has a pointer base, a runtime value */
        struct cc_type *ot = lvalue_type(e->a);
        if (!ot || (ot->kind != TY_STRUCT && ot->kind != TY_UNION))
            return 0;
        if (!fold_lval_addr(e->a, sym, addend))
            return 0;
        int extra = 0;
        struct cc_field *f = resolve_member(ot, e->name, &extra);
        if (f) {
            *addend += extra + f->offset;
            return 1;
        }
        return 0;
    }
    case ND_DEREF:
        /* &*p == p: the pointer is an address constant, or a constant-integer
           pointer (the offsetof idiom &((T *)0)->field derefs a cast integer) */
        if (fold_addr(e->a, sym, addend))
            return 1;
        *addend += cc_const_eval(e->a);
        return 1;
    default:
        return 0;
    }
}

/* Evaluate an integer constant expression that may be an address constant
   reducing to a pure number, e.g. offsetof: (size_t)&((T *)0)->member.  An
   address constant with a symbol is not an integer constant (it is a link-time
   relocation), so it falls through to cc_const_eval, which reports the error. */
static int64_t
fold_int_const(struct cc_node *e)
{
    char *sym = NULL;
    int64_t addend = 0;
    if (fold_addr(e, &sym, &addend) && sym == NULL)
        return addend;
    return cc_const_eval(e);
}

/* a compound literal (type){init} used as the whole initializer of a same-type
   object is just the braced initializer: T x = (T){...} is T x = {...}.  A
   differently-typed literal (int *p = (int[]){...}) is not, and is kept as an
   address-constant object. */
static int
compound_matches(struct cc_type *obj, struct cc_type *lit)
{
    if (!obj || !lit || obj->kind != lit->kind)
        return 0;
    if (obj->kind == TY_STRUCT || obj->kind == TY_UNION)
        return obj == lit || cc_type_size(obj) == cc_type_size(lit);
    return 1;   /* same-kind array, pointer, or scalar */
}

static int compound_counter;

/* The anonymous object a compound literal names, as an automatic local inside
   a function body: synthesize a hidden declaration, lower it (which allocates
   the slot and emits the initializer), and return the local's name.  Created
   once per literal node and memoized on n->name. */
static const char *
compound_lit_local(struct cc_node *n)
{
    if (!n->name) {
        char buf[32];
        snprintf(buf, sizeof buf, "__cl.%d", compound_counter++);
        struct cc_node *decl = arena_zalloc(lower_arena, sizeof *decl);
        decl->kind = ND_LOCAL_DECL;
        decl->line = n->line;
        decl->name = arena_strdup(lower_arena, buf);
        decl->decl_type = n->decl_type;
        decl->a = n->a;
        lower_local_decl(decl);
        n->name = decl->name;
    }
    return n->name;
}

/* The same object in a static-initializer context: an anonymous static global
   with the literal's initializer.  Returns its symbol name. */
static const char *
compound_lit_global(struct cc_node *n)
{
    if (!n->name) {
        char buf[32];
        snprintf(buf, sizeof buf, "__cl.%d", compound_counter++);
        struct cc_node *decl = arena_zalloc(lower_arena, sizeof *decl);
        decl->kind = ND_GLOBAL_DECL;
        decl->line = n->line;
        decl->name = arena_strdup(lower_arena, buf);
        decl->decl_type = n->decl_type;
        decl->a = n->a;
        lower_global_decl(decl);
        cur_prog->globals->is_local = 1;   /* lower_global_decl prepends it */
        n->name = decl->name;
    }
    return n->name;
}

static int
fold_addr(struct cc_node *e, char **sym, int64_t *addend)
{
    switch (e->kind) {
    case ND_STRLIT:
        *sym = emit_string_global(e->sval, e->slen);
        return 1;
    case ND_VAR: {
        /* an array or function name decays to its own address */
        struct cc_type *vt = lvalue_type(e);
        if (vt && (vt->kind == TY_ARRAY || vt->kind == TY_FUNC)) {
            *sym = arena_strdup(lower_arena, e->name);
            return 1;
        }
        return 0;
    }
    case ND_ADDR:
        return fold_lval_addr(e->a, sym, addend);
    case ND_COMPOUND_LIT:
        /* a static compound literal is an anonymous static object; its value
           as a pointer (an array decays, or it is passed as an address) is that
           object's address */
        *sym = arena_strdup(lower_arena, compound_lit_global(e));
        return 1;
    case ND_CAST:
        /* a pointer cast leaves the address value unchanged */
        return fold_addr(e->a, sym, addend);
    case ND_BINOP:
        if (e->op == TOK_PLUS || e->op == TOK_MINUS) {
            /* pointer +/- integer: identify the pointer operand (commutative
               for +, left-only for -) and add the scaled integer */
            struct cc_node *pe = e->a, *ie = e->b;
            struct cc_type *pt = lvalue_type(pe);
            if (!pt || (pt->kind != TY_PTR && pt->kind != TY_ARRAY)) {
                if (e->op == TOK_MINUS)
                    return 0;          /* int - ptr is not a pointer */
                pe = e->b; ie = e->a;  /* int + ptr */
                pt = lvalue_type(pe);
                if (!pt || (pt->kind != TY_PTR && pt->kind != TY_ARRAY))
                    return 0;
            }
            if (!fold_addr(pe, sym, addend))
                return 0;
            int64_t k = cc_const_eval(ie);
            *addend += (e->op == TOK_PLUS ? k : -k) * cc_type_size(pt->base);
            return 1;
        }
        return 0;
    default:
        return 0;
    }
}

/****************************************************************
 * Bit-fields
 *
 * A bit-field packs LSB-first into a storage unit of its declared type.
 * lower_addr(ND_MEMBER) already yields the unit's address (f->offset is the
 * unit's byte offset), so a read is load-shift-mask and a write is a
 * read-modify-write on that unit.
 ****************************************************************/

/* the cc_field for `n->a . n->name` (n->a may be a pointer), or NULL */
static struct cc_field *
member_field(struct cc_node *n)
{
    struct cc_type *ot = lvalue_type(n->a);
    if (ot && ot->kind == TY_PTR)
        ot = ot->base;
    if (!ot || (ot->kind != TY_STRUCT && ot->kind != TY_UNION))
        return NULL;
    int extra = 0;
    return resolve_member(ot, n->name, &extra);
}

static int
emit_shift(int op, int a, int amt)
{
    if (amt == 0)
        return a;
    int c = lower_const(amt);   /* materialize the operand before the op */
    struct ir_insn *ins = emit(op);
    ins->dst = new_temp();
    ins->a = a;
    ins->b = c;
    return ins->dst;
}

static int
emit_and_const(int a, int mask)
{
    int m = lower_const(mask);   /* materialize the operand before the op */
    struct ir_insn *ins = emit(IR_AND);
    ins->dst = new_temp();
    ins->a = a;
    ins->b = m;
    return ins->dst;
}

/* Narrow a 32-bit integer value to the representation of a sub-int target type
   (char, short), as an rvalue cast requires.  The IR carries integers in 32-bit
   temps, so a cast to a narrower type must reduce the value to that type's
   range here; a store to a narrow lvalue truncates on its own, but an rvalue
   cast feeding an expression does not.  Unsigned narrows by masking, signed by
   a left-then-arithmetic-right shift that sign-extends the low bits.  Int-width
   and wider targets, floats, and i64 are returned unchanged. */
static int
narrow_to(int val, struct cc_type *to)
{
    int w;

    if (!to || is_float_type(to) || is_i64_type(to))
        return val;
    w = cc_type_size(to) * 8;
    if (w <= 0 || w >= 32)
        return val;
    if (to->is_unsigned)
        return emit_and_const(val, (int)(((unsigned)1 << w) - 1u));
    val = emit_shift(IR_SHL, val, 32 - w);
    return emit_shift(IR_SHRS, val, 32 - w);
}

/* Convert a scalar `val` of type `from` to _Bool: 1 if it compares unequal to
   zero, else 0 (C11 6.3.1.2).  Used at every conversion to a _Bool object, so a
   _Bool always holds a normalized 0 or 1 and a plain load reads it back. */
static int
to_bool(int val, struct cc_type *from)
{
    struct ir_insn *ins;

    if (is_float_type(from)) {
        /* f != 0.0: compare equal to a zero of the same width, then invert.
           Each operand is materialized before the op that consumes it. */
        struct cc_node zero = { 0 };
        zero.kind = ND_FLOATLIT;
        zero.fval = 0.0;
        zero.type = from;
        int z = lower_expr(&zero);
        ins = emit(IR_FCMPEQ);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = z;
        ins->imm = fwidth(from);
        int eq = ins->dst;
        int czero = lower_const(0);
        ins = emit(IR_CMPEQ);           /* (f == 0) == 0  ->  f != 0 */
        ins->dst = new_temp();
        ins->a = eq;
        ins->b = czero;
        return ins->dst;
    }
    if (is_i64_type(from)) {
        int z = lower_const64(0);
        ins = emit(IR_CMP64NE);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = z;
        return ins->dst;
    }
    int z = lower_const(0);
    ins = emit(IR_CMPNE);
    ins->dst = new_temp();
    ins->a = val;
    ins->b = z;
    return ins->dst;
}

/* read a bit-field from the storage unit at `addr` */
static int
lower_bitfield_read(int addr, struct cc_field *f)
{
    int w = cc_type_size(f->type) * 8;
    int unit = emit_load(addr, f->type);
    if (f->type->is_unsigned) {
        int v = emit_shift(IR_SHRU, unit, f->bit_off);
        if (f->bits < w)
            v = emit_and_const(v, (int)(((unsigned)1 << f->bits) - 1));
        return v;
    }
    /* signed: land the field in the top bits, then arithmetic-shift down */
    int v = emit_shift(IR_SHL, unit, w - f->bit_off - f->bits);
    return emit_shift(IR_SHRS, v, w - f->bits);
}

/* write `val` into the bit-field at `addr` (read-modify-write); returns val */
static int
lower_bitfield_write(int addr, struct cc_field *f, int val)
{
    int w = cc_type_size(f->type) * 8;
    unsigned mask = (f->bits >= w) ? ~0u : (((unsigned)1 << f->bits) - 1);
    int field = val;
    if (f->bits < w)
        field = emit_and_const(field, (int)mask);
    field = emit_shift(IR_SHL, field, f->bit_off);
    int unit = emit_load(addr, f->type);
    int cleared = emit_and_const(unit, (int)~(mask << f->bit_off));
    struct ir_insn *ins = emit(IR_OR);
    ins->dst = new_temp();
    ins->a = cleared;
    ins->b = field;
    emit_store(addr, ins->dst, f->type);
    return val;
}

/* apply a compound-assignment operator to two int temps (bit-fields are
   always integer), honoring signedness for divide/modulo/right-shift */
static int
emit_compound_int(int optok, int a, int b, struct cc_type *t)
{
    int uns = t && t->is_unsigned;
    int op;
    switch (optok) {
    case TOK_PLUS_EQ:    op = IR_ADD; break;
    case TOK_MINUS_EQ:   op = IR_SUB; break;
    case TOK_STAR_EQ:    op = IR_MUL; break;
    case TOK_SLASH_EQ:   op = uns ? IR_DIVU : IR_DIVS; break;
    case TOK_PERCENT_EQ: op = uns ? IR_MODU : IR_MODS; break;
    case TOK_AMP_EQ:     op = IR_AND; break;
    case TOK_PIPE_EQ:    op = IR_OR; break;
    case TOK_CARET_EQ:   op = IR_XOR; break;
    case TOK_SHL_EQ:     op = IR_SHL; break;
    case TOK_SHR_EQ:     op = uns ? IR_SHRU : IR_SHRS; break;
    default: die("lower: bad compound operator %d", optok); return -1;
    }
    struct ir_insn *ins = emit(op);
    ins->dst = new_temp();
    ins->a = a;
    ins->b = b;
    return ins->dst;
}

/****************************************************************
 * Expression lowering (returns temp holding rvalue)
 ****************************************************************/

static int
lower_expr(struct cc_node *n)
{
    struct ir_insn *ins;

    if (!n)
        die("lower: null expression");

    switch (n->kind) {
    case ND_GENERIC:
        return lower_expr(generic_select(n));
    case ND_INTLIT:
        if (n->type && is_i64_type(n->type))
            return lower_const64(n->ival);
        return lower_const(n->ival);

    case ND_FLOATLIT: {
        char namebuf[32];
        snprintf(namebuf, sizeof namebuf, "__flt_%d", str_counter++);
        struct ir_global *fg = arena_zalloc(lower_arena, sizeof *fg);
        fg->name = arena_strdup(lower_arena, namebuf);
        fg->is_local = 1;
        fg->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
        int is_half = n->type && n->type->kind == TY_FLOAT16;
        int use_single = n->type && n->type->kind == TY_FLOAT;
        if (is_half) {
            fg->base_type = IR_I16;
            fg->init_ivals[0] = (int16_t)double_to_half(n->fval);
        } else if (use_single) {
            union { float f; int32_t i; } u;
            u.f = (float)n->fval;
            fg->base_type = IR_F32;
            fg->init_ivals[0] = u.i;        /* 32-bit single bit pattern */
        } else {
            union { double d; int64_t i; } u;
            u.d = n->fval;
            fg->base_type = IR_F64;
            fg->init_ivals[0] = u.i;
        }
        fg->init_count = 1;
        fg->next = cur_prog->globals;
        cur_prog->globals = fg;
        int addr = emit_addr_sym(namebuf);   /* LEA64 under LP64 */
        if (is_half) {
            ins = emit(IR_FLH);
        } else {
            ins = emit(IR_FLD);
            ins->imm = use_single ? FWIDTH_F32 : 0;
        }
        ins->dst = new_temp();
        ins->a = addr;
        return ins->dst;
    }

    case ND_STRLIT:
        return emit_string_literal(n->sval, n->slen);

    case ND_VAR: {
        /* __func__ is a predefined static array holding the enclosing
           function's name (C99 6.4.2.2).  It is only synthesized when no real
           local or global shadows the name; emitted as an ordinary string
           literal so it decays to char* like any other. */
        if (strcmp(n->name, "__func__") == 0 &&
            !find_local(n->name) && !find_global(n->name)) {
            const char *fn = cur_fn_name ? cur_fn_name : "";
            return emit_string_literal(fn, (int)strlen(fn));
        }
        struct local *lc = find_local(n->name);
        if (lc) {
            if (lc->static_name) {
                struct cc_type *t = lc->type;
                int addr = emit_addr_sym(lc->static_name);
                if (t && (t->kind == TY_ARRAY || t->kind == TY_STRUCT ||
                          t->kind == TY_UNION))
                    return addr;
                return emit_load(addr, t ? t : cc_type_int());
            }
            struct cc_type *t = lc->type;
            if (t && (t->kind == TY_ARRAY || t->kind == TY_STRUCT ||
                      t->kind == TY_UNION))
                return emit_addr_slot(lc->slot);
            if (is_float_type(t)) {
                ins = emit(IR_FLDL);
                ins->dst = new_temp();
                ins->slot = lc->slot;
                ins->imm = fwidth(t);
                return ins->dst;
            }
            if (val_is_wide(t)) {
                ins = emit(IR_LDL64);
                ins->dst = new_temp();
                ins->slot = lc->slot;
                return ins->dst;
            }
            if (t) {
                /* A narrow scalar local (char/short) holds its value in one or
                   two bytes of a word-sized slot.  A full-word IR_LDL would also
                   return the slot's other bytes, which are stack garbage when the
                   value was written through the local's address by code that
                   writes only the object's own width (e.g. read(2) into &c).
                   Load it at its declared width through the same address &c uses
                   (the big-endian sub-word offset included), matching the global
                   and dereferenced-pointer load paths and the compound-assign and
                   increment reads, which already load through lower_addr. */
                int sz = cc_type_size(t);
                if (sz == 1 || sz == 2)
                    return emit_load(lower_addr(n), t);
            }
            ins = emit(IR_LDL);
            ins->dst = new_temp();
            ins->slot = lc->slot;
            return ins->dst;
        }
        struct global *gl = find_global(n->name);
        if (!gl) {
            add_global(n->name, cc_type_int(), 1);
            gl = find_global(n->name);
        }
        if (gl->is_func || (gl->type &&
            (gl->type->kind == TY_ARRAY || gl->type->kind == TY_FUNC ||
             gl->type->kind == TY_STRUCT || gl->type->kind == TY_UNION)))
            return emit_addr_sym(n->name);      /* an aggregate rvalue is its address */
        int addr = emit_addr_sym(n->name);
        return emit_load(addr, gl->type ? gl->type : cc_type_int());
    }

    case ND_DEREF: {
        int ptr = lower_expr(n->a);
        struct cc_type *pt = lvalue_type(n->a);
        struct cc_type *target = (pt && pt->kind == TY_PTR) ? pt->base : cc_type_int();
        if (target && (target->kind == TY_STRUCT || target->kind == TY_UNION ||
                       target->kind == TY_ARRAY))
            return ptr;
        return emit_load(ptr, target);
    }

    case ND_ADDR:
        return lower_addr(n->a);

    case ND_LABELADDR: {
        /* &&label: the address of a code label as a void* (GNU labels as
           values), for a computed goto / dispatch table.  A void* is 64-bit on
           an LP64 target, so pick the 64-bit opcode there (it governs the spill
           width), the 32-bit one on an ILP32 target. */
        struct ir_insn *ins = emit(CC_PTR_SIZE == 8 ? IR_LABADDR64
                                                     : IR_LABADDR);
        ins->dst = new_temp();
        ins->label = get_named_label(n->name);
        return ins->dst;
    }

    case ND_COMPOUND_LIT: {
        /* an aggregate literal is its address (a struct rvalue / array decay),
           a scalar literal is the loaded value */
        int addr = lower_addr(n);
        struct cc_type *t = n->decl_type;
        if (t && (t->kind == TY_STRUCT || t->kind == TY_UNION ||
                  t->kind == TY_ARRAY))
            return addr;
        return emit_load(addr, t);
    }

    case ND_INDEX: {
        int addr = lower_addr(n);
        struct cc_type *elem = lvalue_type(n);
        if (elem && (elem->kind == TY_STRUCT || elem->kind == TY_UNION ||
                     elem->kind == TY_ARRAY))
            return addr;
        return emit_load(addr, elem);
    }

    case ND_MEMBER: {
        struct cc_field *bf = member_field(n);
        if (bf && bf->bits > 0)
            return lower_bitfield_read(lower_addr(n), bf);
        int addr = lower_addr(n);
        struct cc_type *ft = lvalue_type(n);
        if (ft && (ft->kind == TY_STRUCT || ft->kind == TY_UNION ||
                   ft->kind == TY_ARRAY))
            return addr;
        return emit_load(addr, ft);
    }

    case ND_UNOP: {
        int val = lower_expr(n->a);
        struct cc_type *ot = lvalue_type(n->a);
        switch (n->op) {
        case TOK_MINUS:
            if (is_float_type(ot)) {
                ins = emit(IR_FNEG);
                ins->dst = new_temp();
                ins->a = val;
                ins->imm = fwidth(ot);
                return ins->dst;
            }
            if (is_i64_type(ot)) {
                ins = emit(IR_NEG64);
                ins->dst = new_temp();
                ins->a = val;
                return ins->dst;
            }
            ins = emit(IR_NEG);
            ins->dst = new_temp();
            ins->a = val;
            return ins->dst;
        case TOK_TILDE:
            if (is_i64_type(ot)) {
                int mask = lower_const64(-1);
                ins = emit(IR_XOR64);
                ins->dst = new_temp();
                ins->a = val;
                ins->b = mask;
                return ins->dst;
            }
            ins = emit(IR_NOT);
            ins->dst = new_temp();
            ins->a = val;
            return ins->dst;
        case TOK_BANG:
            if (is_i64_type(ot)) {
                int zero = lower_const64(0);
                ins = emit(IR_CMP64EQ);
                ins->dst = new_temp();
                ins->a = val;
                ins->b = zero;
                return ins->dst;
            } else {
                int zero = lower_const(0);
                ins = emit(IR_CMPEQ);
                ins->dst = new_temp();
                ins->a = val;
                ins->b = zero;
                return ins->dst;
            }
        default:
            die("lower:%d: unknown unop %d", n->line, n->op);
            return -1;
        }
    }

    case ND_BINOP: {
        if (n->op == TOK_ANDAND || n->op == TOK_OROR) {
            int ltrue = new_label();
            int lfalse = new_label();
            int lend = new_label();
            int result = new_temp();

            lower_cond(n, ltrue, lfalse);

            emit_label(ltrue);
            ins = emit(IR_LIC);
            ins->dst = result;
            ins->imm = 1;
            emit_jmp(lend);

            emit_label(lfalse);
            ins = emit(IR_LIC);
            ins->dst = result;
            ins->imm = 0;

            emit_label(lend);
            return result;
        }

        int lhs = lower_expr(n->a);
        int rhs = lower_expr(n->b);

        /* pointer arithmetic: scale by the element size, address-width.  These
           cases are self-contained so a pointer never reaches the integer
           binop below (where it would be treated as a plain i64). */
        if (n->op == TOK_PLUS || n->op == TOK_MINUS) {
            struct cc_type *lt = lvalue_type(n->a);
            struct cc_type *rt = lvalue_type(n->b);
            int l_ptr = lt && cc_type_is_ptr(lt);
            int r_ptr = rt && cc_type_is_ptr(rt);

            if (l_ptr && r_ptr && n->op == TOK_MINUS) {
                /* ptr - ptr -> byte difference / element size */
                int diff = emit_addr_sub(lhs, rhs);
                int sz = pointee_size(lt);
                if (sz <= 1)
                    return diff;
                /* the divide runs at 32 bits (no i64 divide op); an object's
                   element count fits there.  Narrow, divide, widen back. */
                int d = diff, sc = lower_const(sz);
                if (ADDR64) {
                    ins = emit(IR_TRUNC64);
                    ins->dst = new_temp();
                    ins->a = diff;
                    d = ins->dst;
                }
                ins = emit(IR_DIVS);
                ins->dst = new_temp();
                ins->a = d;
                ins->b = sc;
                int q = ins->dst;
                if (ADDR64) {
                    ins = emit(IR_SEXT64);
                    ins->dst = new_temp();
                    ins->a = q;
                    q = ins->dst;
                }
                return q;
            }
            if (l_ptr && !r_ptr) {
                int scaled = emit_addr_scale(rhs, rt, pointee_size(lt));
                return n->op == TOK_PLUS ? emit_addr_add(lhs, scaled)
                                         : emit_addr_sub(lhs, scaled);
            }
            if (r_ptr && !l_ptr && n->op == TOK_PLUS) {
                /* int + ptr */
                int scaled = emit_addr_scale(lhs, lt, pointee_size(rt));
                return emit_addr_add(rhs, scaled);
            }
        }

        struct cc_type *lt = lvalue_type(n->a);
        struct cc_type *rt = lvalue_type(n->b);
        int use_float = is_float_type(lt) || is_float_type(rt);

        if (use_float) {
            /* usual arithmetic conversion: single unless a double/_Float16
             * operand forces double; convert each operand to the target. */
            int target_dbl = is_double_type(lt) || is_double_type(rt);
            int w = target_dbl ? 0 : FWIDTH_F32;

            if (!is_float_type(lt)) {
                ins = emit(IR_ITOF);
                ins->dst = new_temp();
                ins->a = lhs;
                ins->imm = w;
                lhs = ins->dst;
            } else if (lt->kind == TY_FLOAT && target_dbl) {
                ins = emit(IR_F32TOF64);
                ins->dst = new_temp();
                ins->a = lhs;
                lhs = ins->dst;
            }
            if (!is_float_type(rt)) {
                ins = emit(IR_ITOF);
                ins->dst = new_temp();
                ins->a = rhs;
                ins->imm = w;
                rhs = ins->dst;
            } else if (rt->kind == TY_FLOAT && target_dbl) {
                ins = emit(IR_F32TOF64);
                ins->dst = new_temp();
                ins->a = rhs;
                rhs = ins->dst;
            }
            int ir_op;
            switch (n->op) {
            case TOK_PLUS:  ir_op = IR_FADD; break;
            case TOK_MINUS: ir_op = IR_FSUB; break;
            case TOK_STAR:  ir_op = IR_FMUL; break;
            case TOK_SLASH: ir_op = IR_FDIV; break;
            case TOK_EQ:    ir_op = IR_FCMPEQ; break;
            case TOK_LT:    ir_op = IR_FCMPLT; break;
            case TOK_LE:    ir_op = IR_FCMPLE; break;
            case TOK_GT: {
                int tmp = lhs; lhs = rhs; rhs = tmp;
                ir_op = IR_FCMPLT;
                break;
            }
            case TOK_GE: {
                int tmp = lhs; lhs = rhs; rhs = tmp;
                ir_op = IR_FCMPLE;
                break;
            }
            case TOK_NE: {
                ins = emit(IR_FCMPEQ);
                ins->dst = new_temp();
                ins->a = lhs;
                ins->b = rhs;
                ins->imm = w;
                int eq = ins->dst;
                int zero = lower_const(0);
                ins = emit(IR_CMPEQ);
                ins->dst = new_temp();
                ins->a = eq;
                ins->b = zero;
                return ins->dst;
            }
            default:
                die("lower:%d: float binop %d not supported", n->line, n->op);
                return -1;
            }
            ins = emit(ir_op);
            ins->dst = new_temp();
            ins->a = lhs;
            ins->b = rhs;
            ins->imm = w;
            return ins->dst;
        }

        int use_i64 = is_i64_type(lt) || is_i64_type(rt);
        int is_shift = (n->op == TOK_SHL || n->op == TOK_SHR);
        if (use_i64) {
            if (!is_i64_type(lt)) {
                ins = emit(lt && lt->is_unsigned ? IR_ZEXT64 : IR_SEXT64);
                ins->dst = new_temp();
                ins->a = lhs;
                lhs = ins->dst;
            }
            if (!is_shift && !is_i64_type(rt)) {
                ins = emit(rt && rt->is_unsigned ? IR_ZEXT64 : IR_SEXT64);
                ins->dst = new_temp();
                ins->a = rhs;
                rhs = ins->dst;
            }
            /* signedness of the operation: a shift follows the promoted left
               operand only (the right is just the count); every other operator
               follows the common type of the usual arithmetic conversions, so
               "either operand unsigned" is not enough once the ranks differ. */
            int is_uns = is_shift
                         ? cc_type_promote(lt)->is_unsigned
                         : cc_type_usual_arith(lt, rt)->is_unsigned;
            int ir_op;
            switch (n->op) {
            case TOK_PLUS:    ir_op = IR_ADD64; break;
            case TOK_MINUS:   ir_op = IR_SUB64; break;
            case TOK_STAR:    ir_op = IR_MUL64; break;
            case TOK_SLASH: {
                const char *helper = is_uns ? "__udivdi3" : "__divdi3";
                ins = emit(IR_ARG64); ins->a = lhs; ins->imm = 0;
                ins = emit(IR_ARG64); ins->a = rhs; ins->imm = 1;
                ins = emit(IR_CALL64);
                ins->dst = new_temp();
                ins->sym = arena_strdup(lower_arena, helper);
                ins->nargs = 2;
                return ins->dst;
            }
            case TOK_PERCENT: {
                const char *helper = is_uns ? "__umoddi3" : "__moddi3";
                ins = emit(IR_ARG64); ins->a = lhs; ins->imm = 0;
                ins = emit(IR_ARG64); ins->a = rhs; ins->imm = 1;
                ins = emit(IR_CALL64);
                ins->dst = new_temp();
                ins->sym = arena_strdup(lower_arena, helper);
                ins->nargs = 2;
                return ins->dst;
            }
            case TOK_AMP:     ir_op = IR_AND64; break;
            case TOK_PIPE:    ir_op = IR_OR64; break;
            case TOK_CARET:   ir_op = IR_XOR64; break;
            case TOK_SHL:     ir_op = IR_SHL64; break;
            case TOK_SHR:     ir_op = is_uns ? IR_SHRU64 : IR_SHRS64; break;
            case TOK_EQ:      ir_op = IR_CMP64EQ; break;
            case TOK_NE:      ir_op = IR_CMP64NE; break;
            case TOK_LT:      ir_op = is_uns ? IR_CMP64LTU : IR_CMP64LTS; break;
            case TOK_LE:      ir_op = is_uns ? IR_CMP64LEU : IR_CMP64LES; break;
            case TOK_GT:      ir_op = is_uns ? IR_CMP64GTU : IR_CMP64GTS; break;
            case TOK_GE:      ir_op = is_uns ? IR_CMP64GEU : IR_CMP64GES; break;
            default:
                die("lower:%d: unknown i64 binop %d", n->line, n->op);
                return -1;
            }
            ins = emit(ir_op);
            ins->dst = new_temp();
            ins->a = lhs;
            ins->b = rhs;
            return ins->dst;
        }

        /* signedness of the operation: a shift follows the promoted left
           operand only (the right is just the count); every other operator
           follows the common type of the usual arithmetic conversions, so
           "either operand unsigned" is not enough once the ranks differ. */
        int is_uns = is_shift
                     ? cc_type_promote(lt)->is_unsigned
                     : cc_type_usual_arith(lt, rt)->is_unsigned;
        int ir_op;
        switch (n->op) {
        case TOK_PLUS:    ir_op = IR_ADD; break;
        case TOK_MINUS:   ir_op = IR_SUB; break;
        case TOK_STAR:    ir_op = IR_MUL; break;
        case TOK_SLASH:   ir_op = is_uns ? IR_DIVU : IR_DIVS; break;
        case TOK_PERCENT: ir_op = is_uns ? IR_MODU : IR_MODS; break;
        case TOK_AMP:     ir_op = IR_AND; break;
        case TOK_PIPE:    ir_op = IR_OR; break;
        case TOK_CARET:   ir_op = IR_XOR; break;
        case TOK_SHL:     ir_op = IR_SHL; break;
        case TOK_SHR:     ir_op = is_uns ? IR_SHRU : IR_SHRS; break;
        case TOK_EQ:      ir_op = IR_CMPEQ; break;
        case TOK_NE:      ir_op = IR_CMPNE; break;
        case TOK_LT:      ir_op = is_uns ? IR_CMPLTU : IR_CMPLTS; break;
        case TOK_LE:      ir_op = is_uns ? IR_CMPLEU : IR_CMPLES; break;
        case TOK_GT:      ir_op = is_uns ? IR_CMPGTU : IR_CMPGTS; break;
        case TOK_GE:      ir_op = is_uns ? IR_CMPGEU : IR_CMPGES; break;
        default:
            die("lower:%d: unknown binop %d", n->line, n->op);
            return -1;
        }
        ins = emit(ir_op);
        ins->dst = new_temp();
        ins->a = lhs;
        ins->b = rhs;
        return ins->dst;
    }

    case ND_ASSIGN: {
        int val = lower_expr(n->b);
        if (n->a->kind == ND_MEMBER) {
            struct cc_field *bf = member_field(n->a);
            if (bf && bf->bits > 0)
                return lower_bitfield_write(lower_addr(n->a), bf, val);
        }
        if (n->a->kind == ND_VAR) {
            struct local *lc = find_local(n->a->name);
            if (lc && !lc->static_name && lc->type &&
                lc->type->kind != TY_ARRAY &&
                lc->type->kind != TY_STRUCT && lc->type->kind != TY_UNION) {
                int op;
                if (is_float_type(lc->type)) {
                    op = IR_FSTL;
                    val = to_float(val, lvalue_type(n->b), lc->type);
                } else if (is_i64_type(lc->type)) {
                    op = IR_STL64;
                    val = widen_to_i64(val, lvalue_type(n->b));
                } else {
                    op = IR_STL;
                    if (is_bool_type(lc->type))
                        val = to_bool(val, lvalue_type(n->b));
                }
                ins = emit(op);
                ins->a = val;
                ins->slot = lc->slot;
                if (op == IR_FSTL)
                    ins->imm = fwidth(lc->type);
                return val;
            }
        }
        int addr = lower_addr(n->a);
        struct cc_type *t = lvalue_type(n->a);
        if (is_i64_type(t))
            val = widen_to_i64(val, lvalue_type(n->b));
        else if (is_bool_type(t))
            val = to_bool(val, lvalue_type(n->b));
        emit_store(addr, val, t);
        return val;
    }

    case ND_COMPOUND_ASSIGN: {
        if (n->a->kind == ND_MEMBER) {
            struct cc_field *bf = member_field(n->a);
            if (bf && bf->bits > 0) {
                int a = lower_addr(n->a);
                int old = lower_bitfield_read(a, bf);
                int rhs = lower_expr(n->b);
                int nv = emit_compound_int(n->op, old, rhs, bf->type);
                return lower_bitfield_write(a, bf, nv);
            }
        }
        int addr = lower_addr(n->a);
        struct cc_type *t = lvalue_type(n->a);
        int old_val = emit_load(addr, t);
        int rhs = lower_expr(n->b);

        /* scale for pointer += / -= */
        if ((n->op == TOK_PLUS_EQ || n->op == TOK_MINUS_EQ) &&
            t && cc_type_is_ptr(t)) {
            int sz = pointee_size(t);
            if (sz > 1) {
                int sc = lower_const(sz);
                ins = emit(IR_MUL);
                ins->dst = new_temp();
                ins->a = rhs;
                ins->b = sc;
                rhs = ins->dst;
            }
        }

        int ir_op;
        if (is_float_type(t)) {
            if (!is_float_type(lvalue_type(n->b))) {
                ins = emit(IR_ITOF);
                ins->dst = new_temp();
                ins->a = rhs;
                rhs = ins->dst;
            }
            switch (n->op) {
            case TOK_PLUS_EQ:  ir_op = IR_FADD; break;
            case TOK_MINUS_EQ: ir_op = IR_FSUB; break;
            case TOK_STAR_EQ:  ir_op = IR_FMUL; break;
            case TOK_SLASH_EQ: ir_op = IR_FDIV; break;
            default:
                die("lower:%d: float compound assign %d not supported",
                    n->line, n->op);
                return -1;
            }
        } else if (is_i64_type(t)) {
            /* a shift count stays a 32-bit value (the i64 shift ops take an
               i32 count); every other i64 operator widens its RHS to i64 */
            int is_shift = (n->op == TOK_SHL_EQ || n->op == TOK_SHR_EQ);
            if (!is_shift && !is_i64_type(lvalue_type(n->b))) {
                struct cc_type *rt = lvalue_type(n->b);
                ins = emit(rt && rt->is_unsigned ? IR_ZEXT64 : IR_SEXT64);
                ins->dst = new_temp();
                ins->a = rhs;
                rhs = ins->dst;
            }
            switch (n->op) {
            case TOK_PLUS_EQ:    ir_op = IR_ADD64; break;
            case TOK_MINUS_EQ:   ir_op = IR_SUB64; break;
            case TOK_STAR_EQ:    ir_op = IR_MUL64; break;
            case TOK_SLASH_EQ: {
                const char *h = t->is_unsigned ? "__udivdi3" : "__divdi3";
                ins = emit(IR_ARG64); ins->a = old_val; ins->imm = 0;
                ins = emit(IR_ARG64); ins->a = rhs; ins->imm = 1;
                ins = emit(IR_CALL64);
                ins->dst = new_temp();
                ins->sym = arena_strdup(lower_arena, h);
                ins->nargs = 2;
                int new_val = ins->dst;
                if (n->a->kind == ND_VAR) {
                    struct local *lc = find_local(n->a->name);
                    if (lc && !lc->static_name && lc->type &&
                        lc->type->kind != TY_ARRAY) {
                        ins = emit(IR_STL64);
                        ins->a = new_val;
                        ins->slot = lc->slot;
                        return new_val;
                    }
                }
                emit_store(addr, new_val, t);
                return new_val;
            }
            case TOK_PERCENT_EQ: {
                const char *h = t->is_unsigned ? "__umoddi3" : "__moddi3";
                ins = emit(IR_ARG64); ins->a = old_val; ins->imm = 0;
                ins = emit(IR_ARG64); ins->a = rhs; ins->imm = 1;
                ins = emit(IR_CALL64);
                ins->dst = new_temp();
                ins->sym = arena_strdup(lower_arena, h);
                ins->nargs = 2;
                int new_val = ins->dst;
                if (n->a->kind == ND_VAR) {
                    struct local *lc = find_local(n->a->name);
                    if (lc && !lc->static_name && lc->type &&
                        lc->type->kind != TY_ARRAY) {
                        ins = emit(IR_STL64);
                        ins->a = new_val;
                        ins->slot = lc->slot;
                        return new_val;
                    }
                }
                emit_store(addr, new_val, t);
                return new_val;
            }
            case TOK_AMP_EQ:     ir_op = IR_AND64; break;
            case TOK_PIPE_EQ:    ir_op = IR_OR64; break;
            case TOK_CARET_EQ:   ir_op = IR_XOR64; break;
            case TOK_SHL_EQ:     ir_op = IR_SHL64; break;
            case TOK_SHR_EQ:     ir_op = t->is_unsigned ? IR_SHRU64 : IR_SHRS64; break;
            default:
                die("lower:%d: unknown i64 compound assign", n->line);
                return -1;
            }
        } else {
            switch (n->op) {
            case TOK_PLUS_EQ:    ir_op = IR_ADD; break;
            case TOK_MINUS_EQ:   ir_op = IR_SUB; break;
            case TOK_STAR_EQ:    ir_op = IR_MUL; break;
            case TOK_SLASH_EQ:   ir_op = t->is_unsigned ? IR_DIVU : IR_DIVS; break;
            case TOK_PERCENT_EQ: ir_op = t->is_unsigned ? IR_MODU : IR_MODS; break;
            case TOK_AMP_EQ:     ir_op = IR_AND; break;
            case TOK_PIPE_EQ:    ir_op = IR_OR; break;
            case TOK_CARET_EQ:   ir_op = IR_XOR; break;
            case TOK_SHL_EQ:     ir_op = IR_SHL; break;
            case TOK_SHR_EQ:     ir_op = t->is_unsigned ? IR_SHRU : IR_SHRS; break;
            default:
                die("lower:%d: unknown compound assign", n->line);
                return -1;
            }
        }
        ins = emit(ir_op);
        ins->dst = new_temp();
        ins->a = old_val;
        ins->b = rhs;
        int new_val = ins->dst;
        if (is_bool_type(t))            /* the result is a _Bool: normalize */
            new_val = to_bool(new_val, t);

        /* store back */
        if (n->a->kind == ND_VAR) {
            struct local *lc = find_local(n->a->name);
            if (lc && !lc->static_name && lc->type && lc->type->kind != TY_ARRAY) {
                int op;
                if (is_float_type(lc->type))
                    op = IR_FSTL;
                else if (is_i64_type(lc->type))
                    op = IR_STL64;
                else
                    op = IR_STL;
                ins = emit(op);
                ins->a = new_val;
                ins->slot = lc->slot;
                if (op == IR_FSTL)
                    ins->imm = fwidth(lc->type);
                return new_val;
            }
        }
        emit_store(addr, new_val, t);
        return new_val;
    }

    case ND_PRE_INC:
    case ND_PRE_DEC: {
        if (n->a->kind == ND_MEMBER) {
            struct cc_field *bf = member_field(n->a);
            if (bf && bf->bits > 0) {
                int a = lower_addr(n->a);
                int old = lower_bitfield_read(a, bf);
                int one = lower_const(n->kind == ND_PRE_INC ? 1 : -1);
                struct ir_insn *ai = emit(IR_ADD);
                ai->dst = new_temp();
                ai->a = old;
                ai->b = one;
                return lower_bitfield_write(a, bf, ai->dst);  /* pre: new */
            }
        }
        int addr = lower_addr(n->a);
        struct cc_type *t = lvalue_type(n->a);
        int old_val = emit_load(addr, t);
        int delta = 1;
        if (t && cc_type_is_ptr(t))
            delta = pointee_size(t);
        int dc;
        int add_op;
        int stl_op;
        if (is_i64_type(t)) {
            dc = lower_const64(n->kind == ND_PRE_INC ? delta : -delta);
            add_op = IR_ADD64;
            stl_op = IR_STL64;
        } else {
            dc = lower_const(n->kind == ND_PRE_INC ? delta : -delta);
            add_op = IR_ADD;
            stl_op = IR_STL;
        }
        ins = emit(add_op);
        ins->dst = new_temp();
        ins->a = old_val;
        ins->b = dc;
        int new_val = ins->dst;
        if (n->a->kind == ND_VAR) {
            struct local *lc = find_local(n->a->name);
            if (lc && !lc->static_name && lc->type && lc->type->kind != TY_ARRAY) {
                ins = emit(stl_op);
                ins->a = new_val;
                ins->slot = lc->slot;
                return new_val;
            }
        }
        emit_store(addr, new_val, t);
        return new_val;
    }

    case ND_POST_INC:
    case ND_POST_DEC: {
        if (n->a->kind == ND_MEMBER) {
            struct cc_field *bf = member_field(n->a);
            if (bf && bf->bits > 0) {
                int a = lower_addr(n->a);
                int old = lower_bitfield_read(a, bf);
                int one = lower_const(n->kind == ND_POST_INC ? 1 : -1);
                struct ir_insn *ai = emit(IR_ADD);
                ai->dst = new_temp();
                ai->a = old;
                ai->b = one;
                lower_bitfield_write(a, bf, ai->dst);
                return old;                                   /* post: old */
            }
        }
        int addr = lower_addr(n->a);
        struct cc_type *t = lvalue_type(n->a);
        int old_val = emit_load(addr, t);
        int delta = 1;
        if (t && cc_type_is_ptr(t))
            delta = pointee_size(t);
        int dc;
        int add_op;
        int stl_op;
        if (is_i64_type(t)) {
            dc = lower_const64(n->kind == ND_POST_INC ? delta : -delta);
            add_op = IR_ADD64;
            stl_op = IR_STL64;
        } else {
            dc = lower_const(n->kind == ND_POST_INC ? delta : -delta);
            add_op = IR_ADD;
            stl_op = IR_STL;
        }
        ins = emit(add_op);
        ins->dst = new_temp();
        ins->a = old_val;
        ins->b = dc;
        int new_val = ins->dst;
        if (n->a->kind == ND_VAR) {
            struct local *lc = find_local(n->a->name);
            if (lc && !lc->static_name && lc->type && lc->type->kind != TY_ARRAY) {
                ins = emit(stl_op);
                ins->a = new_val;
                ins->slot = lc->slot;
                return old_val;
            }
        }
        emit_store(addr, new_val, t);
        return old_val;
    }

    case ND_TERNARY: {
        /* The two branches are separate basic blocks, so the merged value must
           round-trip through a local slot (the IR's "SSA within, memory
           between" rule), not a temp written in both blocks.  The slot is sized
           by the result type so a 64-bit or float branch keeps its full width;
           an earlier IR_MOV here copied only 32 bits and lost an i64's high
           half. */
        struct cc_type *t = lvalue_type(n);
        int ltrue = new_label();
        int lfalse = new_label();
        int lend = new_label();

        if (is_aggregate(t)) {
            /* a struct/union result flows by address: a plain copy is fine */
            int result = new_temp();
            lower_cond(n->a, ltrue, lfalse);
            emit_label(ltrue);
            ins = emit(IR_MOV);
            ins->dst = result;
            ins->a = lower_expr(n->b);
            emit_jmp(lend);
            emit_label(lfalse);
            ins = emit(IR_MOV);
            ins->dst = result;
            ins->a = lower_expr(n->c);
            emit_label(lend);
            return result;
        }

        int slot = alloc_slot(cc_type_size(t), cc_type_align(t));
        int flt = is_float_type(t);
        int wide = val_is_wide(t);
        int stl = flt ? IR_FSTL : wide ? IR_STL64 : IR_STL;

        lower_cond(n->a, ltrue, lfalse);

        emit_label(ltrue);
        int tv = lower_expr(n->b);
        if (flt) tv = to_float(tv, lvalue_type(n->b), t);
        else if (is_i64_type(t)) tv = widen_branch_to_i64(tv, lvalue_type(n->b));
        ins = emit(stl);
        ins->a = tv;
        ins->slot = slot;
        if (flt) ins->imm = fwidth(t);
        emit_jmp(lend);

        emit_label(lfalse);
        int fv = lower_expr(n->c);
        if (flt) fv = to_float(fv, lvalue_type(n->c), t);
        else if (is_i64_type(t)) fv = widen_branch_to_i64(fv, lvalue_type(n->c));
        ins = emit(stl);
        ins->a = fv;
        ins->slot = slot;
        if (flt) ins->imm = fwidth(t);

        emit_label(lend);
        ins = emit(flt ? IR_FLDL : wide ? IR_LDL64 : IR_LDL);
        ins->dst = new_temp();
        ins->slot = slot;
        if (flt) ins->imm = fwidth(t);
        return ins->dst;
    }

    case ND_COMMA:
        lower_expr(n->a);
        return lower_expr(n->b);

    case ND_CAST: {
        struct cc_type *from = lvalue_type(n->a);
        struct cc_type *to = n->decl_type;
        reject_ldouble(to, n->line);        /* a cast producing a long double */
        reject_ldouble(from, n->line);      /* or consuming one */
        int val = lower_expr(n->a);
        if (is_bool_type(to))               /* (_Bool)x normalizes to 0/1 */
            return to_bool(val, from);
        if (to && is_float_type(to) && !is_float_type(from)) {
            if (is_i64_type(from)) {
                ins = emit(IR_TRUNC64);
                ins->dst = new_temp();
                ins->a = val;
                val = ins->dst;
            }
            ins = emit(IR_ITOF);
            ins->dst = new_temp();
            ins->a = val;
            ins->imm = fwidth(to);
            return ins->dst;
        }
        if (to && !is_float_type(to) && is_float_type(from)) {
            ins = emit(IR_FTOI);
            ins->dst = new_temp();
            ins->a = val;
            ins->imm = fwidth(from);
            val = ins->dst;
            if (is_i64_type(to)) {
                ins = emit(IR_SEXT64);
                ins->dst = new_temp();
                ins->a = val;
                return ins->dst;
            }
            return narrow_to(val, to);
        }
        /* float <-> double (both float types, differing width) */
        if (to && from && is_float_type(to) && is_float_type(from)) {
            if (fwidth(from) != fwidth(to)) {
                ins = emit(fwidth(to) == FWIDTH_F32
                           ? IR_F64TOF32 : IR_F32TOF64);
                ins->dst = new_temp();
                ins->a = val;
                return ins->dst;
            }
            return val;
        }
        if (to && is_i64_type(to) && !is_i64_type(from)) {
            ins = emit(from && from->is_unsigned ? IR_ZEXT64 : IR_SEXT64);
            ins->dst = new_temp();
            ins->a = val;
            return ins->dst;
        }
        if (to && !is_i64_type(to) && is_i64_type(from)) {
            ins = emit(IR_TRUNC64);
            ins->dst = new_temp();
            ins->a = val;
            return narrow_to(ins->dst, to);
        }
        return narrow_to(val, to);
    }

    case ND_SIZEOF: {
        struct cc_type *t = n->decl_type ? n->decl_type
                          : n->a ? lvalue_type(n->a) : NULL;
        int v = n->op == TOK_ALIGNOF ? cc_type_align(t ? t : cc_type_int())
              : t ? cc_type_size(t) : 4;
        return lower_const(v);
    }

    case ND_CALL: {
        int is_indirect = 0;
        int fptr = -1;
        struct cc_type *callee_type = NULL;

        /* varargs builtins (a va_list decays to the address of its struct) */
        if (n->a->kind == ND_VAR && n->b) {
            const char *bn = n->a->name;
            if (strcmp(bn, "__builtin_va_start") == 0) {
                int ap = lower_expr(n->b);   /* the va_list address */
                ins = emit(IR_VA_START);
                ins->a = ap;
                return lower_const(0);
            }
            if (strcmp(bn, "__builtin_va_end") == 0)
                return lower_const(0);        /* no-op on SysV */
            /* va_arg: the three typed spellings and the generic
               __builtin_va_arg(ap, type) the real <stdarg.h> uses.  Each
               lowers to __va_arg(ap, kind), which returns a pointer to the
               next argument slot and advances the va_list, then a typed load.
               kind classifies the slot for the per-ABI __va_arg (notably the
               ILP32 stack ABIs, where int advances 4 bytes and a 64-bit value
               8): 0 = 32-bit int/pointer (LW), 1 = double (FLD), 2 = 64-bit
               integer (LD64). */
            int va_generic = strcmp(bn, "__builtin_va_arg") == 0 && n->decl_type;
            int va_kind = -1;
            if (strcmp(bn, "__builtin_va_arg_int") == 0)
                va_kind = 0;
            else if (strcmp(bn, "__builtin_va_arg_dbl") == 0)
                va_kind = 1;
            else if (strcmp(bn, "__builtin_va_arg_long") == 0)
                va_kind = 2;
            else if (va_generic) {
                struct cc_type *vt = n->decl_type;
                va_kind = is_float_type(vt) ? 1 : is_i64_type(vt) ? 2 : 0;
            }
            if (va_kind >= 0) {
                int ap = lower_expr(n->b);
                int kc = lower_const(va_kind);
                /* ap and the returned slot pointer are address-width: 8 bytes
                   under LP64 (ARG64/CALL64), 4 under ILP32 (ARG/CALL). */
                ins = emit(ADDR64 ? IR_ARG64 : IR_ARG); ins->a = ap; ins->imm = 0;
                ins = emit(IR_ARG); ins->a = kc; ins->imm = 1;
                ins = emit(ADDR64 ? IR_CALL64 : IR_CALL);
                ins->dst = new_temp();
                ins->sym = arena_strdup(lower_arena, "__va_arg");
                ins->nargs = 2;
                int ptr = ins->dst;
                if (va_kind == 1) {
                    ins = emit(IR_FLD);
                    ins->dst = new_temp();
                    ins->a = ptr;
                    ins->imm = 0;            /* double */
                    return ins->dst;
                }
                if (va_kind == 2) {
                    ins = emit(IR_LD64);
                    ins->dst = new_temp();
                    ins->a = ptr;
                    return ins->dst;
                }
                ins = emit(IR_LW);
                ins->dst = new_temp();
                ins->a = ptr;
                return ins->dst;
            }
        }
        if (n->a->kind == ND_VAR) {
            struct local *lc = find_local(n->a->name);
            if (lc && lc->type && (lc->type->kind == TY_PTR ||
                                    lc->type->kind == TY_FUNC)) {
                is_indirect = 1;
                fptr = lower_expr(n->a);
                callee_type = lc->type;
                if (callee_type->kind == TY_PTR)
                    callee_type = callee_type->base;
            } else {
                struct global *gl = find_global(n->a->name);
                if (gl)
                    callee_type = gl->type;
            }
        } else {
            is_indirect = 1;
            fptr = lower_expr(n->a);
            /* The callee is any other expression (a struct/union member
               function pointer b->f, an array element fps[i], *pp, a cast).
               Recover its type so the call's return width is known; without
               this callee_type stays NULL and the result defaults to 32-bit
               int, silently narrowing an i64/float/struct return (a member
               function pointer returning long long came back as its high
               word alone).  lvalue_type types the member/index/deref/cast
               callees and falls back to int for anything it cannot, matching
               the prior behavior. */
            callee_type = lvalue_type(n->a);
            if (callee_type && callee_type->kind == TY_PTR)
                callee_type = callee_type->base;
        }
        int args[32];
        int arg_kind[32];       /* 0 int, 1 float, 2 i64, 3 MEMORY struct,
                                   4 x8 result pointer (AAPCS64) */
        int arg_fw[32];
        int arg_msize[32] = {0}; /* byte size for a kind-3 MEMORY struct arg */
        int arg_vararg[32] = {0}; /* 1 if this is an unnamed (variadic) arg */
        int arg_align8[32] = {0}; /* 1 if this arg starts an 8-aligned struct
                                     (MIPS o32: it begins on an even word) */
        int nargs = 0;
        /* a memory-class struct return: hand the callee a pointer to a result
           slot.  SysV passes it as the first integer argument; AAPCS64 passes
           it in the x8 indirect-result register (arg_kind 4). */
        /* mirror the ABI's register accounting so the caller applies the
           same all-or-nothing rule the callee does: a register struct whose
           slots do not all fit in the remaining registers is passed wholly in
           memory rather than split across a register and the stack.  ABI_NINT
           integer arg registers (SysV rdi..r9 = 6; AAPCS64 x0..x7 = 8), 8 fp. */
#if defined(CC_ARM64) || defined(CC_RISCV)
        int abi_nint = 8;
#else
        int abi_nint = 6;
#endif
        int iu = 0, fu = 0;             /* integer / fp arg registers used */
        int mem_ret_slot = -1;
        if (callee_type && callee_type->kind == TY_FUNC &&
            ret_uses_hidden_ptr(callee_type->base)) {
            mem_ret_slot = alloc_slot(cc_type_size(callee_type->base),
                                      cc_type_align(callee_type->base));
            args[0] = emit_addr_slot(mem_ret_slot);
#if defined(CC_ARM64)
            arg_kind[0] = 4;           /* AAPCS64: the x8 indirect-result reg */
#elif CC_PTR_SIZE == 4
            arg_kind[0] = 0;           /* ILP32 (RV / ColdFire / MIPS): a plain
                                          1-word pointer in the first arg slot */
            iu = 1;                    /* it consumes the first int register */
#else
            arg_kind[0] = 2;           /* SysV: the hidden first int argument */
            iu = 1;                    /* it consumes rdi */
#endif
            arg_fw[0] = 0;
            nargs = 1;
        }
        struct cc_param *pp = (callee_type && callee_type->kind == TY_FUNC)
                              ? callee_type->params : NULL;
        for (struct cc_node *a = n->b; a; a = a->next) {
            if (nargs >= 32)
                die("lower:%d: too many arguments", n->line);
            /* an unnamed argument: a variadic callee with no more fixed
               params.  The RISC-V backend reads this to route unnamed args to
               the stack; other backends ignore it. */
            int this_vararg = callee_type && callee_type->kind == TY_FUNC &&
                              callee_type->is_variadic && pp == NULL;
            int cls[4], neb;
            struct cc_type *at = pp ? pp->type : lvalue_type(a);
            reject_ldouble(at, n->line);
            if ((neb = abi_agg(at, cls)) > 0) {
#ifdef CC_RISCV
                /* RISC-V ilp32: a <=8-byte struct decomposes into 1-2 plain
                   word args (4-byte IR_LW), placed in a0.. by the backend.  A
                   2-word struct splits naturally (last register, then stack);
                   there is no x86/arm64 all-or-nothing on RISC-V. */
                int rbase = lower_expr(a);
                for (int j = 0; j < neb; j++) {
                    int raddr = j ? emit_addr_add(rbase, emit_addr_const(4 * j))
                                  : rbase;
                    struct ir_insn *rld = emit(IR_LW);
                    rld->dst = new_temp();
                    rld->a = raddr;
                    args[nargs] = rld->dst;
                    arg_kind[nargs] = 0;
                    arg_fw[nargs] = 0;
                    arg_vararg[nargs] = this_vararg;
                    nargs++;
                }
                if (pp)
                    pp = pp->next;
                continue;
#else
                int need_i = 0, need_f = 0;
                for (int j = 0; j < neb; j++)
                    if (cls[j] == 0) need_i++; else need_f++;
                if (iu + need_i > abi_nint || fu + need_f > 8) {
                    /* the slots do not all fit: pass the whole struct in memory
                       (a by-value stack copy), matching the callee's all-or-
                       nothing rule.  The remaining registers stay available for
                       later arguments (iu/fu unchanged). */
                    args[nargs] = lower_expr(a);
                    arg_kind[nargs] = 3;
                    arg_fw[nargs] = 0;
                    arg_msize[nargs] = cc_type_size(at);
                    arg_vararg[nargs] = this_vararg;
                    if (pp)
                        pp = pp->next;
                    nargs++;
                    continue;
                }
                iu += need_i;
                fu += need_f;
                /* register struct: decompose into its slots, one arg each,
                   loaded from the struct's address.  An integer/double slot is
                   8 bytes; a float-HFA slot is a 4-byte single, so the stride
                   and width follow the slot class. */
                int base = lower_expr(a);
                int stride = (cls[0] == 2) ? 4 : 8;
                for (int j = 0; j < neb; j++) {
                    int addr = j ? emit_addr_add(base,
                                       emit_addr_const(stride * j))
                                 : base;
                    struct ir_insn *ld;
                    if (cls[j] != 0) {          /* FP slot -> fp reg */
                        int w = (cls[j] == 2) ? FWIDTH_F32 : 8;
                        ld = emit(IR_FLD);
                        ld->imm = w;
                        ld->dst = new_temp();
                        ld->a = addr;
                        args[nargs] = ld->dst;
                        arg_kind[nargs] = 1;
                        arg_fw[nargs] = w;
                    } else {                    /* INTEGER slot -> gp */
                        ld = emit(IR_LD64);
                        ld->dst = new_temp();
                        ld->a = addr;
                        args[nargs] = ld->dst;
                        arg_kind[nargs] = 2;
                        arg_fw[nargs] = 0;
                    }
                    arg_vararg[nargs] = this_vararg;
                    nargs++;
                }
                if (pp)
                    pp = pp->next;
                continue;
#endif /* !CC_RISCV */
            }
            if (abi_struct_mem(at)) {
#if defined(CC_ARM64) || defined(CC_RISCV)
                /* AAPCS64 and RISC-V ilp32 (>8 bytes): pass a pointer to a
                   caller-made copy (value semantics: the callee must not see
                   later mutations) */
                int src = lower_expr(a);
                int cslot = alloc_slot(cc_type_size(at), cc_type_align(at));
                emit_aggregate_copy(emit_addr_slot(cslot), src,
                                    cc_type_size(at));
                args[nargs] = emit_addr_slot(cslot);
#ifdef CC_RISCV
                arg_kind[nargs] = 0;    /* a 4-byte pointer in one a-register */
#else
                arg_kind[nargs] = 2;    /* the pointer rides a gp reg */
#endif
                arg_fw[nargs] = 0;
                arg_vararg[nargs] = this_vararg;
                if (iu < abi_nint)
                    iu++;               /* the pointer consumes an x-register */
                if (pp)
                    pp = pp->next;
                nargs++;
                continue;
#else
                /* SysV: pass a by-value stack copy (the backend copies its
                   bytes onto the outgoing stack) */
                args[nargs] = lower_expr(a);
                arg_kind[nargs] = 3;
                arg_fw[nargs] = 0;
                arg_msize[nargs] = cc_type_size(at);
                arg_vararg[nargs] = this_vararg;
                if (pp)
                    pp = pp->next;
                nargs++;
                continue;
#endif
            }
#if defined(CC_M68K) || defined(CC_MIPS)
            if (at && (at->kind == TY_STRUCT || at->kind == TY_UNION)) {
                /* ColdFire and MIPS o32 pass a by-value struct as its words in
                   the argument structure (on the stack for m68k; the first four
                   words in $a0-$a3 then the stack for o32).  abi_agg does not
                   classify a struct on these targets (so struct return is
                   unaffected); decompose it into ceil(size/4) word arguments,
                   each a copy, so value semantics hold.  The callee reads the
                   words back from its parameter slot.  The slot carries the
                   struct's true alignment (size-driven on m68k, the IR
                   slot_align on MIPS), so a struct with 8-byte-aligned members
                   (an embedded double or long long) reconstructs 8-aligned.
                   On MIPS o32 such a struct starts on an even argument word, so
                   its first word carries argalign 8 to make the caller's outgoing
                   placement match the callee's 8-aligned home slot. */
                int sbase = lower_expr(a);
                int swords = (cc_type_size(at) + 3) / 4;
                int align8 = cc_type_align(at) > 4;
                for (int j = 0; j < swords; j++) {
                    int saddr = j ? emit_addr_add(sbase, emit_addr_const(4 * j))
                                  : sbase;
                    ins = emit(IR_LW);
                    ins->dst = new_temp();
                    ins->a = saddr;
                    args[nargs] = ins->dst;
                    arg_kind[nargs] = 0;
                    arg_fw[nargs] = 0;
                    arg_vararg[nargs] = this_vararg;
                    arg_align8[nargs] = (j == 0) ? align8 : 0;
                    if (iu < abi_nint)
                        iu++;
                    nargs++;
                }
                if (pp)
                    pp = pp->next;
                continue;
            }
#endif
            args[nargs] = lower_expr(a);
            arg_fw[nargs] = 0;
            if (is_float_type(at)) {
                arg_kind[nargs] = 1;
                arg_fw[nargs] = fwidth(at);
                if (fu < 8)
                    fu++;
                /* convert the argument to the parameter's float type */
                if (pp)
                    args[nargs] = to_float(args[nargs], lvalue_type(a), at);
            } else if (is_i64_type(at)) {
                arg_kind[nargs] = 2;
                if (iu < abi_nint)
                    iu++;
                args[nargs] = widen_to_i64(args[nargs], lvalue_type(a));
            } else if (pp && is_bool_type(at)) {
                /* a _Bool parameter: normalize the argument to 0/1 (handles an
                   i64 or float source too, so no separate TRUNC64 is needed) */
                arg_kind[nargs] = 0;
                if (iu < abi_nint)
                    iu++;
                args[nargs] = to_bool(args[nargs], lvalue_type(a));
            } else {
                arg_kind[nargs] = 0;
                if (iu < abi_nint)
                    iu++;
                /* narrow a 64-bit argument to a 32-bit integer or pointer
                   parameter.  The cast path does this explicitly (ND_CAST
                   i64 -> non-i64); an implicit conversion at a prototyped
                   call argument needs the same IR_TRUNC64, or the i64 value
                   rides a register pair the plain-int ARG then misreads. */
                if (pp && is_i64_type(lvalue_type(a)) && !is_i64_type(at)) {
                    ins = emit(IR_TRUNC64);
                    ins->dst = new_temp();
                    ins->a = args[nargs];
                    args[nargs] = ins->dst;
                }
            }
            arg_vararg[nargs] = this_vararg;
            if (pp)
                pp = pp->next;
            nargs++;
        }
        for (int i = 0; i < nargs; i++) {
            int op = arg_kind[i] == 1 ? IR_FARG
                   : arg_kind[i] == 2 ? IR_ARG64
                   : arg_kind[i] == 3 ? IR_ARG_MEM
                   : arg_kind[i] == 4 ? IR_ARG_X8
                   : IR_ARG;
            ins = emit(op);
            ins->a = args[i];
            ins->vararg = arg_vararg[i];
            if (op == IR_ARG && arg_align8[i])
                ins->argalign = 8;
            /* FARG carries the float width in imm; ARG_MEM carries the struct
             * byte size; other ARGs carry the arg index */
            ins->imm = op == IR_FARG ? arg_fw[i]
                     : op == IR_ARG_MEM ? arg_msize[i]
                     : i;
        }
        if (callee_type && callee_type->kind == TY_FUNC)
            reject_ldouble(callee_type->base, n->line);
        int fret = callee_type && callee_type->kind == TY_FUNC &&
                   is_float_type(callee_type->base);
        int rcls[4], rneb = 0;
        if (callee_type && callee_type->kind == TY_FUNC)
            rneb = abi_agg(callee_type->base, rcls);
        int sret = rneb > 0;    /* struct returned in registers */
        int i64ret = callee_type && callee_type->kind == TY_FUNC &&
                     is_i64_type(callee_type->base);
        if (sret) {
            /* a struct-returning call: the backend makes the call and stores
               the returned register slots into a hidden slot; imm encodes the
               slot count (bits 0-2) and each slot's class in a 2-bit field
               (0 = integer, 1 = double, 2 = float single) at bits 3+2*j.  The
               call expression yields the slot address, uniform with every
               other struct value. */
            int slot = alloc_slot(rneb * ABI_SLOT_BYTES < 8
                                  ? 8 : rneb * ABI_SLOT_BYTES, 8);
            long enc = rneb;
            for (int j = 0; j < rneb; j++)
                enc |= (long)rcls[j] << (3 + 2 * j);
            ins = emit(is_indirect ? IR_CALLI_AGG : IR_CALL_AGG);
            ins->dst = -1;
            ins->slot = slot;
            ins->imm = enc;
            ins->nargs = nargs;
            if (is_indirect)
                ins->a = fptr;
            else
                ins->sym = arena_strdup(lower_arena, n->a->name);
            return emit_addr_slot(slot);
        }
        if (mem_ret_slot >= 0)
            /* MEMORY return: the result register holds the hidden pointer, so
               the call yields a pointer-sized value (the dst is discarded, the
               result is read from mem_ret_slot).  Only an LP64 pointer needs
               the 64-bit call form; an ILP32 pointer (rv / ColdFire / MIPS) is
               a plain call. */
            i64ret = (CC_PTR_SIZE == 8);
        if (is_indirect) {
            int op = fret ? IR_FCALLI : i64ret ? IR_CALLI64 : IR_CALLI;
            ins = emit(op);
            ins->dst = new_temp();
            ins->a = fptr;
            ins->nargs = nargs;
            if (fret)
                ins->imm = fwidth(callee_type->base);   /* single vs double */
        } else {
            int op = fret ? IR_FCALL : i64ret ? IR_CALL64 : IR_CALL;
            ins = emit(op);
            ins->dst = new_temp();
            ins->sym = arena_strdup(lower_arena, n->a->name);
            ins->nargs = nargs;
            if (fret)
                ins->imm = fwidth(callee_type->base);   /* single vs double */
        }
        if (mem_ret_slot >= 0)
            /* the call wrote the struct into our result slot; yield its
               address, uniform with every other struct value */
            return emit_addr_slot(mem_ret_slot);
        return ins->dst;
    }

    case ND_INIT_LIST:
        die("lower:%d: init list in expression context", n->line);
        return -1;

    default:
        die("lower:%d: unhandled expression kind %d", n->line, n->kind);
        return -1;
    }
}

/****************************************************************
 * Conditional lowering (short-circuit)
 ****************************************************************/

static void
lower_cond(struct cc_node *n, int ltrue, int lfalse)
{
    if (n->kind == ND_BINOP && n->op == TOK_ANDAND) {
        int lmid = new_label();
        lower_cond(n->a, lmid, lfalse);
        emit_label(lmid);
        lower_cond(n->b, ltrue, lfalse);
        return;
    }
    if (n->kind == ND_BINOP && n->op == TOK_OROR) {
        int lmid = new_label();
        lower_cond(n->a, ltrue, lmid);
        emit_label(lmid);
        lower_cond(n->b, ltrue, lfalse);
        return;
    }
    if (n->kind == ND_UNOP && n->op == TOK_BANG) {
        lower_cond(n->a, lfalse, ltrue);
        return;
    }
    int v = lower_expr(n);
    emit_bnz(v, ltrue);
    emit_jmp(lfalse);
}

/* Zero the `size` bytes at base_addr.  A local aggregate is zeroed before its
   initializer runs, so a slot no element reaches is zero as C 6.7.8 requires
   (the provided leaves then overwrite their slots). */
static void
emit_zero_fill(int base_addr, int size)
{
    struct ir_insn *ins;
    int z = lower_const(0);
    int off = 0;
    while (size - off >= 4) {
        int da = off ? emit_addr_add(base_addr, emit_addr_const(off)) : base_addr;
        ins = emit(IR_SW); ins->a = da; ins->b = z;
        off += 4;
    }
    if (size - off >= 2) {
        int da = off ? emit_addr_add(base_addr, emit_addr_const(off)) : base_addr;
        ins = emit(IR_SH); ins->a = da; ins->b = z;
        off += 2;
    }
    if (size - off >= 1) {
        int da = off ? emit_addr_add(base_addr, emit_addr_const(off)) : base_addr;
        ins = emit(IR_SB); ins->a = da; ins->b = z;
    }
}

/* Store one scalar (or char-array-from-string) leaf of a local aggregate
   initializer at base_addr + off.  The value is lowered first, then converted
   to the slot type the way the scalar init path does, then stored. */
static void
store_leaf(int base_addr, int off, struct cc_type *ft, struct cc_node *e)
{
    if (ft && ft->kind == TY_ARRAY && cc_type_size(ft->base) == 1 &&
        e->kind == ND_STRLIT) {
        int src = lower_expr(e);                    /* pointer to the string */
        int n = e->slen + 1;
        int cap = cc_type_size(ft);
        int addr = off ? emit_addr_add(base_addr, emit_addr_const(off))
                       : base_addr;
        emit_aggregate_copy(addr, src, n < cap ? n : cap);
        return;
    }
    int val = lower_expr(e);
    struct cc_type *st = lvalue_type(e);
    if (is_float_type(ft))
        val = to_float(val, st, ft);
    else if (is_i64_type(ft))
        val = widen_to_i64(val, st);
    else if (is_bool_type(ft))
        val = to_bool(val, st);
    int addr = off ? emit_addr_add(base_addr, emit_addr_const(off))
                   : base_addr;
    emit_store(addr, val, ft);
}

/* Lower a local aggregate initializer into runtime stores at base_addr + base.
   Mirrors build_image (the global byte-image walk): elements are consumed in
   order, a `.field` / `[index]` designator repositions the slot, a braced
   element initializes a sub-aggregate, and an unbraced aggregate slot draws
   from the same cursor (brace elision).  Slots no element reaches keep the
   zero from emit_zero_fill. */
static void
store_init(struct cc_type *t, struct init_cursor *cur, int base_addr, int base)
{
    if (!t)
        return;

    if (t->kind == TY_ARRAY && cc_type_size(t->base) == 1 &&
        cur->cur && cur->cur->kind == ND_STRLIT) {
        struct cc_node *s = cur->cur;
        cur->cur = s->next;
        store_leaf(base_addr, base, t, s);
        return;
    }

    int nslots = agg_nslots(t);
    int pos = 0;
    while (cur->cur) {
        struct cc_node *e = cur->cur;
        struct cc_type *ft;
        int off;

        if (e->kind == ND_DESIG) {
            if (t->kind == TY_ARRAY) {
                pos = (int)e->ival;
                if (pos < 0 || pos >= nslots)
                    die("lower:%d: designator out of range", e->line);
                ft = agg_slot(t, pos, &off);
            } else {
                int fi = field_index(t, e->name);
                if (fi >= 0) {
                    pos = fi;
                    if (pos < 0 || pos >= nslots)
                        die("lower:%d: designator out of range", e->line);
                    ft = agg_slot(t, pos, &off);
                } else {
                    /* a field of an anonymous member (C11 6.7.2.1p13) */
                    ft = NULL;
                    int idx = 0;
                    for (struct cc_field *af = t->fields; af;
                         af = af->next, idx++) {
                        if (af->name || !af->type)
                            continue;
                        if (af->type->kind != TY_STRUCT &&
                            af->type->kind != TY_UNION)
                            continue;
                        int extra = 0;
                        struct cc_field *lf =
                            resolve_member(af->type, e->name, &extra);
                        if (lf) {
                            ft = lf->type;
                            off = af->offset + extra + lf->offset;
                            pos = idx;
                            break;
                        }
                    }
                    if (!ft)
                        die("lower:%d: no field named '%s'", e->line, e->name);
                }
            }
            cur->cur = e->next;
            if (e->a->kind == ND_INIT_LIST) {
                struct init_cursor sub = { e->a->body };
                store_init(ft, &sub, base_addr, base + off);
            } else {
                store_leaf(base_addr, base + off, ft, e->a);
            }
            pos++;
            continue;
        }

        if (pos >= nslots)
            break;
        ft = agg_slot(t, pos, &off);
        if (!ft)
            break;
        if (e->kind == ND_INIT_LIST) {
            cur->cur = e->next;
            if (is_aggregate(ft)) {
                struct init_cursor sub = { e->body };
                store_init(ft, &sub, base_addr, base + off);
            } else {
                struct cc_node *lf = first_leaf(e);
                if (lf)
                    store_leaf(base_addr, base + off, ft, lf);
            }
        } else if (is_aggregate(ft) &&
                   !(ft->kind == TY_ARRAY &&
                     cc_type_size(ft->base) == 1 && e->kind == ND_STRLIT)) {
            store_init(ft, cur, base_addr, base + off);   /* brace elision */
        } else {
            cur->cur = e->next;
            store_leaf(base_addr, base + off, ft, e);
        }
        pos++;
    }
}

/****************************************************************
 * Statement lowering
 ****************************************************************/

static int static_counter;

static void
lower_local_decl(struct cc_node *n)
{
    struct cc_type *t = n->decl_type;

    /* A block-scope declaration with no declarator names no object (a malformed
       `extern int;`, or a bare type/tag declaration whose tag is registered
       during parsing), so there is nothing to lower.  Guards every n->name use
       below, including add_global and the static-name mangling. */
    if (!n->name)
        return;

    /* T x = (T){...} is just T x = {...}; a differently-typed literal
       (int *p = (int[]){...}) stays an address-constant object */
    if (n->a && n->a->kind == ND_COMPOUND_LIT &&
        compound_matches(t, n->a->decl_type))
        n->a = n->a->a;

    /* braced scalar initializer: int x = {42} is int x = 42 */
    if (n->a && n->a->kind == ND_INIT_LIST && !is_aggregate(t) &&
        n->a->body && !n->a->body->next && n->a->body->kind != ND_DESIG)
        n->a = n->a->body;

    /* a braced initializer still on a scalar is ill-formed: excess elements
       (int x = {1, 2}), empty (int x = {}), or a designator on a scalar */
    if (n->a && n->a->kind == ND_INIT_LIST && !is_aggregate(t))
        die("lower:%d: braced initializer for scalar type must hold a single value",
            n->a->line);

    if (n->is_extern || t->kind == TY_FUNC) {
        add_global(n->name, t, t->kind == TY_FUNC);
        return;
    }
    reject_ldouble(t, n->line);

    if (n->is_static) {
        char mangled[128];
        snprintf(mangled, sizeof mangled, "%s.%s.%d",
                 cur_fn_name, n->name, static_counter++);
        struct ir_global *g = arena_zalloc(lower_arena, sizeof *g);
        g->name = arena_strdup(lower_arena, mangled);
        g->is_local = 1;
        g->is_rodata = type_is_readonly(t);
        g->base_type = type_to_ir(t);
        /* char m[] = "..." : deduce the bound as the string plus its NUL into
           the TYPE, before arr_size is read, so sizeof (which reads the type)
           is right.  The auto path does this in the common tail below, but the
           static block returns before reaching it. */
        if (t->kind == TY_ARRAY && t->array_len < 0 && n->a &&
            n->a->kind == ND_STRLIT)
            t->array_len = n->a->slen + 1;
        if (wants_image(t, n->a)) {
            /* aggregate (struct/union, or an array of one): a byte blob of the
               full size, aligned to the aggregate's alignment; an initializer
               becomes an ir_init byte image */
            if (t->kind == TY_ARRAY && t->array_len < 0 && n->a &&
                n->a->kind == ND_INIT_LIST) {
                t->array_len = infer_array_len(n->a);
            }
            g->base_type = IR_I8;
            g->arr_size = cc_type_size(t);
            g->align = cc_type_align(t);
            if (n->a && n->a->kind == ND_INIT_LIST)
                g->inits = lower_aggregate_init(t, n->a);
        } else if (t->kind == TY_ARRAY) {
            g->base_type = type_to_ir(t->base);
            if (t->array_len < 0 && n->a &&
                n->a->kind == ND_INIT_LIST) {
                /* one top-level initializer per element, whatever the element
                   width (dividing a flat leaf count by the element size in
                   words mis-sized an 8-byte-element array). */
                t->array_len = infer_array_len(n->a);
            }
            g->arr_size = t->array_len > 0 ? t->array_len : 0;
        }
        if (n->a && !g->inits) {
            if (n->a->kind == ND_INIT_LIST) {
                int cnt = count_init_flat(n->a);
                g->init_ivals = arena_alloc(lower_arena, cnt * sizeof(int64_t));
                g->init_syms = arena_zalloc(lower_arena, cnt * sizeof(char *));
                int pos = 0;
                flatten_init(flat_elem_type(t), n->a,
                             g->init_ivals, g->init_syms, &pos);
                g->init_count = pos;
                if (g->arr_size == 0)
                    g->arr_size = pos;
            } else if (n->a->kind == ND_STRLIT && t->kind != TY_PTR) {
                g->init_string = arena_alloc(lower_arena, n->a->slen + 1);
                memcpy(g->init_string, n->a->sval, n->a->slen);
                g->init_string[n->a->slen] = '\0';
                g->init_strlen = n->a->slen + 1;
                if (g->arr_size == 0)
                    g->arr_size = n->a->slen + 1;
            } else if (t->kind == TY_PTR) {
                /* a pointer initialized by an address constant (&a[2], a + 2,
                   "s" + 1, &var, a string/array/function name) -> a symbol plus
                   a byte addend, emitted as a relocation; an integer-constant
                   pointer ((int *)0x1000) folds to a bare value */
                int64_t val = 0;
                char *sym = NULL;
                encode_scalar(t, n->a, &val, &sym);
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = val;
                if (sym) {
                    g->init_syms = arena_zalloc(lower_arena, sizeof(char *));
                    g->init_syms[0] = sym;
                }
                g->init_count = 1;
            } else if (t->kind == TY_FLOAT || t->kind == TY_DOUBLE ||
                       t->kind == TY_FLOAT16) {
                /* a scalar float/double/half static initialized by a literal:
                   encode its bit pattern, as the file-scope path does. */
                int64_t val = 0;
                char *sym = NULL;
                encode_scalar(t, n->a, &val, &sym);
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = val;
                g->init_count = 1;
            } else if (is_bool_type(t)) {
                /* a _Bool static holds only 0 or 1 */
                int64_t v = n->a->kind == ND_FLOATLIT
                            ? (n->a->fval != 0.0)
                            : (fold_int_const(n->a) != 0);
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = v;
                g->init_count = 1;
            } else if (n->a->kind == ND_INTLIT) {
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = n->a->ival;
                g->init_count = 1;
            } else if (n->a->kind == ND_UNOP &&
                       n->a->op == TOK_MINUS &&
                       n->a->a &&
                       n->a->a->kind == ND_INTLIT) {
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = -n->a->a->ival;
                g->init_count = 1;
            } else if (cc_type_is_integer(t)) {
                /* integer scalar initialized by a constant expression (A * B,
                   1 << N, or the offsetof idiom): fold it, as the file-scope
                   path does. */
                g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
                g->init_ivals[0] = fold_int_const(n->a);
                g->init_count = 1;
            }
        }
        g->next = cur_prog->globals;
        cur_prog->globals = g;
        add_global(mangled, t, 0);
        if (n->name) {
            if (nlocals == local_cap) {
                local_cap = local_cap ? local_cap * 2 : 32;
                locals = realloc(locals, local_cap * sizeof *locals);
            }
            locals[nlocals].name = arena_strdup(lower_arena,n->name);
            locals[nlocals].slot = -1;
            locals[nlocals].type = t;
            locals[nlocals].static_name = arena_strdup(lower_arena, mangled);
            nlocals++;
        }
        return;
    }

    if (t->kind == TY_ARRAY && t->array_len < 0 && n->a &&
        n->a->kind == ND_INIT_LIST)
        t->array_len = infer_array_len(n->a);
    /* char m[] = "..."  : the length is the string plus its terminating NUL
       (mirrors the global path).  Without this the array keeps length -1, so
       sizeof is wrong and the slot is mis-sized. */
    if (t->kind == TY_ARRAY && t->array_len < 0 && n->a &&
        n->a->kind == ND_STRLIT)
        t->array_len = n->a->slen + 1;

    int sz = cc_type_size(t);
    if (is_float_type(t) && sz < 8)
        sz = 8;
    if (is_i64_type(t) && sz < 8)
        sz = 8;
    int slot = alloc_slot(sz, cc_type_align(t));
    if (n->name) {
        add_local(n->name, slot, t);
        if (n->sval)            /* GNU local register variable binding */
            locals[nlocals - 1].asm_reg =
                arena_strndup(lower_arena, n->sval, n->slen);
    }

    if (!n->a)
        return;

    if (n->a->kind == ND_INIT_LIST && is_aggregate(t)) {
        /* array/struct/union initializer list, possibly with nested braces,
           designators, or brace elision.  Zero the slot, then emit a store for
           each provided leaf via the recursive walk that mirrors the global
           byte-image path.  Addresses are address-width (64-bit under LP64),
           so the ADDR64-aware helpers avoid truncating a high stack address. */
        int base_addr = emit_addr_slot(slot);
        emit_zero_fill(base_addr, cc_type_size(t));
        struct init_cursor cur = { n->a->body };
        store_init(t, &cur, base_addr, 0);
    } else if (n->a->kind == ND_STRLIT && is_aggregate(t)) {
        /* char array initialized from a string literal: zero the slot, then
           copy the string bytes (including the NUL, truncated if the array is
           shorter, e.g. char m[3] = "abcd").  char m[10] = "abc" leaves the
           tail zero. */
        int base_addr = emit_addr_slot(slot);
        int total = cc_type_size(t);
        int nbytes = n->a->slen + 1;
        if (nbytes > total)
            nbytes = total;
        emit_zero_fill(base_addr, total);
        emit_aggregate_copy(base_addr, lower_expr(n->a), nbytes);
    } else {
        int val = lower_expr(n->a);
        if (is_aggregate(t)) {
            /* init from another aggregate: value-semantic byte copy */
            emit_aggregate_copy(emit_addr_slot(slot), val, cc_type_size(t));
            return;
        }
        int op;
        if (is_float_type(t)) {
            op = IR_FSTL;
            val = to_float(val, lvalue_type(n->a), t);
        } else if (is_i64_type(t)) {
            op = IR_STL64;
            val = widen_to_i64(val, lvalue_type(n->a));
        } else {
            op = IR_STL;
            if (is_bool_type(t))
                val = to_bool(val, lvalue_type(n->a));
        }
        struct ir_insn *ins = emit(op);
        ins->a = val;
        ins->slot = slot;
        if (op == IR_FSTL)
            ins->imm = fwidth(t);
    }
}

static void
collect_cases(struct cc_node *n, struct switch_ctx *sw)
{
    if (!n)
        return;
    if (n->kind == ND_CASE) {
        int lab = new_label();
        sw->case_vals[sw->ncases] = cc_const_eval(n->a);
        sw->case_labels[sw->ncases] = lab;
        sw->ncases++;
        collect_cases(n->b, sw);
        return;
    }
    if (n->kind == ND_DEFAULT) {
        sw->default_label = new_label();
        collect_cases(n->a, sw);
        return;
    }
    if (n->kind == ND_BLOCK) {
        for (struct cc_node *s = n->body; s; s = s->next)
            collect_cases(s, sw);
    }
}

static void
lower_stmt(struct cc_node *n)
{
    struct ir_insn *ins;

    if (!n)
        return;

    /* Debug info (-g): mark the source line at the head of each statement, once
       per distinct line, so the backend builds an address-to-line table.  A
       block carries no line of its own; its inner statements each mark theirs. */
    if (cc_debug && n->line > 0 && n->line != last_loc_line
        && n->kind != ND_BLOCK) {
        ir_loc(cur_fn, n->line)->b = n->col;    /* b carries the source column */
        last_loc_line = n->line;
    }

    switch (n->kind) {
    case ND_BLOCK: {
        int saved_nlocals = nlocals;
        for (struct cc_node *s = n->body; s; s = s->next)
            lower_stmt(s);
        nlocals = saved_nlocals;
        return;
    }

    case ND_EXPR_STMT:
        if (n->a)
            lower_expr(n->a);
        return;

    case ND_LOCAL_DECL:
        /* One declarator.  A multi-declarator declaration (int a, b, c;) is a
           chain of these, but parse_block flattens the chain so each declarator
           is a separate statement the ND_BLOCK loop visits in turn; lowering the
           chain here too would lower every declarator but the first a second
           time (and re-run a call initializer).  The one place a chain arrives
           unflattened is a for-init, handled in ND_FOR below. */
        lower_local_decl(n);
        return;

    case ND_IF: {
        int ltrue = new_label();
        int lfalse = new_label();
        int lend = new_label();
        lower_cond(n->a, ltrue, lfalse);
        emit_label(ltrue);
        lower_stmt(n->b);
        if (n->c) {
            emit_jmp(lend);
            emit_label(lfalse);
            lower_stmt(n->c);
            emit_label(lend);
        } else {
            emit_label(lfalse);
        }
        return;
    }

    case ND_WHILE: {
        int ltop = new_label();
        int lbody = new_label();
        int lbrk = new_label();
        emit_label(ltop);
        lower_cond(n->a, lbody, lbrk);
        emit_label(lbody);
        loop_stack[nloops].brk = lbrk;
        loop_stack[nloops].cont = ltop;
        nloops++;
        lower_stmt(n->b);
        nloops--;
        emit_jmp(ltop);
        emit_label(lbrk);
        return;
    }

    case ND_DO_WHILE: {
        int ltop = new_label();
        int lcont = new_label();
        int lbrk = new_label();
        emit_label(ltop);
        loop_stack[nloops].brk = lbrk;
        loop_stack[nloops].cont = lcont;
        nloops++;
        lower_stmt(n->a);
        nloops--;
        emit_label(lcont);
        lower_cond(n->b, ltop, lbrk);
        emit_label(lbrk);
        return;
    }

    case ND_FOR: {
        int ltop = new_label();
        int lbody = new_label();
        int lcont = new_label();
        int lbrk = new_label();
        /* init */
        if (n->a) {
            if (n->a->kind == ND_LOCAL_DECL) {
                /* a for-init declaration chain (for (int i = 0, j = 0; ...))
                   is not flattened into a block, so lower each declarator */
                for (struct cc_node *d = n->a; d; d = d->next)
                    lower_local_decl(d);
            } else {
                lower_stmt(n->a);
            }
        }
        emit_label(ltop);
        /* condition */
        if (n->b)
            lower_cond(n->b, lbody, lbrk);
        else
            emit_jmp(lbody);
        emit_label(lbody);
        loop_stack[nloops].brk = lbrk;
        loop_stack[nloops].cont = lcont;
        nloops++;
        lower_stmt(n->d);
        nloops--;
        emit_label(lcont);
        /* increment */
        if (n->c)
            lower_expr(n->c);
        emit_jmp(ltop);
        emit_label(lbrk);
        return;
    }

    case ND_SWITCH: {
        struct switch_ctx sw = {0};
        sw.end_label = new_label();
        sw.default_label = -1;
        collect_cases(n->b, &sw);

        int val = lower_expr(n->a);
        /* a long long control value needs a 64-bit case value and a 64-bit
           equality compare; a 32-bit compare only sees the low word, so an i64
           switch would never match a case (and a case constant above 32 bits
           would be truncated). */
        int wide = is_i64_type(lvalue_type(n->a));

        for (int i = 0; i < sw.ncases; i++) {
            int cv = wide ? lower_const64(sw.case_vals[i])
                          : lower_const(sw.case_vals[i]);
            ins = emit(wide ? IR_CMP64EQ : IR_CMPEQ);
            ins->dst = new_temp();
            ins->a = val;
            ins->b = cv;
            emit_bnz(ins->dst, sw.case_labels[i]);
        }
        if (sw.default_label >= 0)
            emit_jmp(sw.default_label);
        else
            emit_jmp(sw.end_label);

        struct switch_ctx *prev = cur_switch;
        cur_switch = &sw;
        loop_stack[nloops].brk = sw.end_label;
        loop_stack[nloops].cont = -1;
        nloops++;
        lower_stmt(n->b);
        nloops--;
        cur_switch = prev;
        emit_label(sw.end_label);
        return;
    }

    case ND_CASE: {
        if (!cur_switch)
            die("lower:%d: case outside switch", n->line);
        long cv = cc_const_eval(n->a);
        for (int i = 0; i < cur_switch->ncases; i++) {
            if (cur_switch->case_vals[i] == cv) {
                emit_label(cur_switch->case_labels[i]);
                break;
            }
        }
        lower_stmt(n->b);
        return;
    }

    case ND_DEFAULT:
        if (!cur_switch)
            die("lower:%d: default outside switch", n->line);
        emit_label(cur_switch->default_label);
        lower_stmt(n->a);
        return;

    case ND_BREAK:
        if (nloops == 0)
            die("lower:%d: break outside loop/switch", n->line);
        emit_jmp(loop_stack[nloops - 1].brk);
        return;

    case ND_CONTINUE: {
        /* continue targets the nearest enclosing loop, not a switch: a switch
           frame carries a break target but cont == -1, so skip those frames. */
        int li = nloops - 1;
        while (li >= 0 && loop_stack[li].cont < 0)
            li--;
        if (li < 0)
            die("lower:%d: continue outside loop", n->line);
        emit_jmp(loop_stack[li].cont);
        return;
    }

    case ND_RETURN:
        if (n->a) {
            int val = lower_expr(n->a);
            if (cur_fn_ret_mem) {
                /* MEMORY return: copy the struct through the hidden result
                   pointer and return that pointer.  The pointer is CC_PTR_SIZE
                   bytes: 8 on LP64 (x86-64 / arm64), 4 on the ILP32 targets
                   (RISC-V / ColdFire / MIPS). */
                struct ir_insn *ld;
#if CC_PTR_SIZE == 4
                ld = emit(IR_LDL);
                ld->dst = new_temp();
                ld->slot = cur_fn_sret_slot;
                emit_aggregate_copy(ld->dst, val, cc_type_size(cur_fn_ret_type));
                ins = emit(IR_RETV);
                ins->a = ld->dst;
#else
                ld = emit(IR_LDL64);
                ld->dst = new_temp();
                ld->slot = cur_fn_sret_slot;
                emit_aggregate_copy(ld->dst, val, cc_type_size(cur_fn_ret_type));
                ins = emit(IR_RETV64);
                ins->a = ld->dst;
#endif
                return;
            }
            if (cur_fn_ret_neb > 0) {
                /* pack the returned struct into the return registers: the
                   backend loads each eightbyte from the struct's address
                   (val) into rax/rdx or xmm0/xmm1 per fn->ret_cls */
                ins = emit(IR_RETV_AGG);
                ins->a = val;
                return;
            }
            if (cur_fn_returns_i64)
                val = widen_to_i64(val, lvalue_type(n->a));
            else if (cur_fn_returns_float)
                val = to_float(val, lvalue_type(n->a), cur_fn_ret_type);
            else if (is_bool_type(cur_fn_ret_type))
                val = to_bool(val, lvalue_type(n->a));
            int op = cur_fn_returns_float ? IR_FRETV
                   : cur_fn_returns_i64   ? IR_RETV64
                   : IR_RETV;
            ins = emit(op);
            ins->a = val;
            if (op == IR_FRETV)
                ins->imm = fwidth(cur_fn_ret_type);   /* single vs double */
        } else {
            emit(IR_RET);
        }
        return;

    case ND_GOTO:
        if (n->a) {
            /* GNU computed goto: goto *expr, an indirect jump through a label
               address (from &&label).  The operand is a void*, 64-bit on LP64,
               so pick the matching-width jump (it governs the operand reload).
               Compute the target before emitting the jump: lower_expr emits the
               address computation, which must precede the IJMP, not follow it. */
            int target = lower_expr(n->a);
            struct ir_insn *ins = emit(CC_PTR_SIZE == 8 ? IR_IJMP64 : IR_IJMP);
            ins->a = target;
        } else {
            emit_jmp(get_named_label(n->name));
        }
        return;

    case ND_LABEL:
        emit_label(get_named_label(n->name));
        lower_stmt(n->a);
        return;

    case ND_ASM: {
        struct ir_insn *ins;
        struct cc_node *o;
        char *templ = arena_strndup(lower_arena, n->sval, n->slen);

        if (!n->a && !n->b && !n->c) {          /* basic asm: verbatim */
            ins = emit(IR_ASM);
            ins->sym = templ;
            return;
        }
#if !defined(CC_MIPS) && !defined(CC_M68K) && !defined(CC_RISCV) && \
    !defined(X86_BITS) && !defined(CC_ARM64)
        /* Extended asm (operand constraints and %N substitution) is
           implemented per backend; a target not yet covered takes only the
           basic (verbatim) form. */
        die("lower:%d: extended inline asm is not supported on this target yet",
            n->line);
#endif
        /* extended asm: count operands, lower each, then emit the asm with a
           descriptor the backend uses to substitute %0.. and place operands. */
        {
            int no = 0, ni = 0, nc = 0, k;
            int out_addr[16];
            struct cc_type *out_ty[16];
            struct ir_asm_info *info;
            for (o = n->a; o; o = o->next) no++;
            for (o = n->b; o; o = o->next) ni++;
            for (o = n->c; o; o = o->next) nc++;
            if (no > 16)
                die("lower:%d: too many asm outputs", n->line);
            info = arena_alloc(lower_arena, sizeof *info);
            info->noutputs = no;
            info->ninputs = ni;
            info->nclobbers = nc;
            info->is_volatile = (int)n->ival;
            info->ops = arena_alloc(lower_arena,
                                    (size_t)(no + ni) * sizeof *info->ops);
            info->clobbers = nc ? arena_alloc(lower_arena,
                                    (size_t)nc * sizeof *info->clobbers) : NULL;
            /* outputs: an lvalue; "+..." is read-write so the current value is
               loaded first, otherwise a fresh result temp. The store back to
               the lvalue happens after the asm. */
            k = 0;
            for (o = n->a; o; o = o->next, k++) {
                int inout = (o->slen >= 1 && o->sval[0] == '+');
                out_addr[k] = lower_addr(o->a);
                out_ty[k] = lvalue_type(o->a);
                /* a float asm operand would live in a float register, which
                   the backends' operand placement does not handle yet (they
                   index the integer register tables by temp_reg); reject it
                   rather than miscompile. */
                if (is_float_type(out_ty[k]))
                    die("lower:%d: a float extended-asm operand is not "
                        "supported yet", n->line);
                info->ops[k].constraint =
                    arena_strndup(lower_arena, o->sval, o->slen);
                info->ops[k].pin_reg = asm_operand_pin(o);
                info->ops[k].size = cc_type_size(out_ty[k]);
                info->ops[k].is_output = 1;
                info->ops[k].is_inout = inout;
                info->ops[k].temp = inout ? lower_expr(o->a) : new_temp();
            }
            /* inputs */
            for (o = n->b; o; o = o->next, k++) {
                if (is_float_type(lvalue_type(o->a)))
                    die("lower:%d: a float extended-asm operand is not "
                        "supported yet", n->line);
                info->ops[k].constraint =
                    arena_strndup(lower_arena, o->sval, o->slen);
                info->ops[k].pin_reg = asm_operand_pin(o);
                info->ops[k].size = cc_type_size(lvalue_type(o->a));
                info->ops[k].is_output = 0;
                info->ops[k].is_inout = 0;
                info->ops[k].temp = lower_expr(o->a);
            }
            k = 0;
            for (o = n->c; o; o = o->next, k++)
                info->clobbers[k] = arena_strndup(lower_arena, o->sval, o->slen);

            ins = emit(IR_ASM);
            ins->sym = templ;
            ins->asm_info = info;

            for (k = 0; k < no; k++)
                emit_store(out_addr[k], info->ops[k].temp, out_ty[k]);
        }
        return;
    }

    default:
        die("lower:%d: unhandled statement kind %d", n->line, n->kind);
    }
}

/****************************************************************
 * Function lowering
 ****************************************************************/

static struct ir_func *
lower_function(struct cc_node *fndef)
{
    struct ir_func *fn = ir_new_func(lower_arena, fndef->name);
    fn->is_local = fndef->is_static;
    fn->src_file = cc_debug ? (fndef->file ? fndef->file : cc_src_file) : NULL;
    last_loc_line = 0;
    cur_fn = fn;
    cur_fn_name = fndef->name;
    nloops = 0;
    nlocals = 0;
    nslots = 0;
    nnamed_labels = 0;
    cur_switch = NULL;

    struct cc_type *ftype = fndef->decl_type;
    int rcls[4];
    /* Arm the inline-drop recovery: an inline function that hits any long
       double reject (its signature, body, or a dead call into a long double
       helper) longjmps back here and is dropped, since an inline definition
       may be omitted -- which is how musl's header helpers such as __islessf
       are meant to work.  A non-inline function errors via die() instead. */
    if (fndef->is_inline) {
        ldouble_recover_active = 1;
        if (setjmp(ldouble_recover)) {
            ldouble_recover_active = 0;
            return NULL;
        }
    }
    reject_ldouble(ftype->base, fndef->line);       /* return type */
    for (struct cc_param *p = ftype->params; p; p = p->next)
        reject_ldouble(p->type, fndef->line);
    cur_fn_returns_float = is_float_type(ftype->base);
    cur_fn_returns_i64 = is_i64_type(ftype->base);
    cur_fn_ret_neb = abi_agg(ftype->base, rcls);
    cur_fn_ret_mem = ret_uses_hidden_ptr(ftype->base);
    if (cur_fn_ret_neb < 0)
        cur_fn_ret_neb = 0;             /* MEMORY: returned via a hidden ptr */
    fn->ret_neb = cur_fn_ret_mem ? -1 : cur_fn_ret_neb;
    for (int j = 0; j < 4; j++)
        fn->ret_cls[j] = rcls[j];
    cur_fn_ret_type = ftype->base;
    fn->is_variadic = ftype->is_variadic;
    int nparams = 0;

    /* allocate slots for params.  A MEMORY return adds a hidden leading
       integer parameter, the caller-provided result pointer (SysV): it takes
       the first gp register like any other pointer, and the return copies the
       struct through it. */
    int np = 0;
    for (struct cc_param *p = ftype->params; p; p = p->next)
        np++;
    if (cur_fn_ret_mem)
        np++;
    np = np > 0 ? np : 1;
    fn->param_class = arena_alloc(lower_arena, np * sizeof(int));
    fn->param_neb = arena_alloc(lower_arena, np * sizeof(signed char));
    fn->param_cls = arena_alloc(lower_arena, 4 * np * sizeof(signed char));
    fn->param_fw = arena_alloc(lower_arena, np * sizeof(signed char));
    memset(fn->param_fw, 0, np * sizeof(signed char));
    if (cur_fn_ret_mem) {
        cur_fn_sret_slot = alloc_slot(CC_PTR_SIZE, CC_PTR_SIZE);
        fn->param_neb[0] = 1;
        fn->param_cls[0] = 0;
        fn->param_cls[1] = fn->param_cls[2] = fn->param_cls[3] = -1;
        fn->param_class[0] = 0;
        nparams = 1;
    }
    /* AAPCS64 memory params: a >16-byte struct arrives as a pointer to a
       caller copy.  The pointer occupies the param slot; the copied struct
       needs a local slot, which must be allocated after all param slots so the
       param indices stay 0..nparams-1.  Deferred here, resolved below. */
    int mem_pslot[16], nmemparam = 0;
    struct cc_param *mem_pparam[16];
    for (struct cc_param *p = ftype->params; p; p = p->next) {
        int sz = cc_type_size(p->type);
        int pcls[4], neb = abi_agg(p->type, pcls);
        int mem_ptr = 0;
#if defined(CC_ARM64) || defined(CC_RISCV)
        mem_ptr = (neb < 0);            /* a pointer to a caller copy */
#endif
        int palign = cc_type_align(p->type);
        if (is_float_type(p->type) && sz < 8) {
            sz = 8;
            /* A single-float parameter rides an 8-byte, 8-aligned doubleword
               home in the o32 argument structure (the MIPS caller passes every
               float arg as a two-word, even-word slot), so its home slot must
               be 8-aligned to match.  cc_type_align(float) is 4, which would
               place it on an odd word after a preceding single word (e.g. a
               hidden struct-return pointer); only the MIPS backend reads this
               alignment, so it is inert elsewhere. */
            palign = 8;
        } else if (is_i64_type(p->type) && sz < 8)
            sz = 8;
        else if (neb > 0 && sz < neb * ABI_SLOT_BYTES)
            sz = neb * ABI_SLOT_BYTES;  /* room to reconstruct the slots */
        else if (sz < 4)
            sz = 4;
        for (int j = 0; j < 4; j++)
            fn->param_cls[4 * nparams + j] = -1;
        if (mem_ptr) {                  /* one gp reg holds the ptr */
            int slot = alloc_slot(ABI_SLOT_BYTES, CC_PTR_SIZE);
            if (nmemparam < 16) {
                mem_pslot[nmemparam] = slot;
                mem_pparam[nmemparam] = p;
                nmemparam++;
            }
            fn->param_neb[nparams] = 1;
            fn->param_cls[4 * nparams] = 0;
            fn->param_class[nparams] = 0;
            nparams++;
            continue;
        }
        int slot = alloc_slot(sz, palign);
        if (p->name)
            add_local(p->name, slot, p->type);
        if (neb > 0) {                  /* struct in 1-4 registers */
            fn->param_neb[nparams] = neb;
            for (int j = 0; j < neb; j++)
                fn->param_cls[4 * nparams + j] = pcls[j];
            fn->param_class[nparams] = pcls[0];
        } else if (neb < 0) {           /* SysV MEMORY struct: read from stack */
            fn->param_neb[nparams] = (sz + 7) / 8;   /* 8-byte stack slots */
            fn->param_cls[4 * nparams] = -2;         /* MEMORY marker */
            fn->param_cls[4 * nparams + 1] = -2;
            fn->param_class[nparams] = 0;
        } else {                        /* scalar */
            fn->param_neb[nparams] = 1;
            fn->param_cls[4 * nparams] = is_float_type(p->type) ? 1 : 0;
            fn->param_class[nparams] = is_float_type(p->type) ? 1 : 0;
            if (is_float_type(p->type) && cc_type_size(p->type) == 4)
                fn->param_fw[nparams] = 1;    /* single: one ABI word on RV */
        }
        nparams++;
    }
    fn->nparams = nparams;

    /* allocate the copied-struct locals for the memory params (after the param
       slots), bind each name to its copy, and record the copy-in */
    int mem_dslot[16];
    for (int m = 0; m < nmemparam; m++) {
        mem_dslot[m] = alloc_slot(cc_type_size(mem_pparam[m]->type),
                                  cc_type_align(mem_pparam[m]->type));
        if (mem_pparam[m]->name)
            add_local(mem_pparam[m]->name, mem_dslot[m], mem_pparam[m]->type);
    }

    struct ir_insn *ins = emit(IR_FUNC);
    ins->sym = arena_strdup(lower_arena, fndef->name);
    ins->nargs = nparams;

    /* copy each by-reference (memory-class) struct parameter from its pointer
       into the local copy, before the body runs.  The incoming pointer is 8
       bytes on LP64 (IR_LDL64), 4 bytes on RISC-V ilp32 (IR_LDL). */
    for (int m = 0; m < nmemparam; m++) {
#ifdef CC_RISCV
        struct ir_insn *ld = emit(IR_LDL);
#else
        struct ir_insn *ld = emit(IR_LDL64);
#endif
        ld->dst = new_temp();
        ld->slot = mem_pslot[m];
        emit_aggregate_copy(emit_addr_slot(mem_dslot[m]), ld->dst,
                            cc_type_size(mem_pparam[m]->type));
    }

    lower_stmt(fndef->body);

    /* ensure function ends with a return */
    if (!fn->tail || (fn->tail->op != IR_RET && fn->tail->op != IR_RETV &&
                      fn->tail->op != IR_RETV64 && fn->tail->op != IR_FRETV &&
                      fn->tail->op != IR_RETV_AGG)) {
        if (cur_fn_ret_mem) {
            /* no explicit return (UB): still hand back the hidden pointer
               (CC_PTR_SIZE bytes: 8 on LP64, 4 on the ILP32 targets) */
            int p;
#if CC_PTR_SIZE == 4
            ins = emit(IR_LDL);
            ins->dst = new_temp();
            ins->slot = cur_fn_sret_slot;
            p = ins->dst;
            ins = emit(IR_RETV);
            ins->a = p;
#else
            ins = emit(IR_LDL64);
            ins->dst = new_temp();
            ins->slot = cur_fn_sret_slot;
            p = ins->dst;
            ins = emit(IR_RETV64);
            ins->a = p;
#endif
        } else if (cur_fn_returns_i64) {
            int z = lower_const64(0);
            ins = emit(IR_RETV64);
            ins->a = z;
        } else {
            int z = lower_const(0);
            ins = emit(IR_RETV);
            ins->a = z;
        }
    }

    emit(IR_ENDF);

    fn->nslots = nslots;
    fn->slot_size = arena_alloc(lower_arena, nslots * sizeof(int));
    fn->slot_align = arena_alloc(lower_arena, nslots * sizeof(int));
    if (nslots) {
        memcpy(fn->slot_size, slot_sizes, nslots * sizeof(int));
        memcpy(fn->slot_align, slot_aligns, nslots * sizeof(int));
    }
    ldouble_recover_active = 0;
    return fn;
}

/****************************************************************
 * Global lowering
 ****************************************************************/

static void
lower_global_decl(struct cc_node *gn)
{
    struct cc_type *t = gn->decl_type;

    /* T x = (T){...} is just T x = {...} (see lower_local_decl) */
    if (gn->a && gn->a->kind == ND_COMPOUND_LIT &&
        compound_matches(t, gn->a->decl_type))
        gn->a = gn->a->a;

    /* braced scalar initializer: int x = {42} is int x = 42 */
    if (gn->a && gn->a->kind == ND_INIT_LIST && !is_aggregate(t) &&
        gn->a->body && !gn->a->body->next && gn->a->body->kind != ND_DESIG)
        gn->a = gn->a->body;

    /* a braced initializer still on a scalar is ill-formed: excess elements
       (int x = {1, 2}), empty (int x = {}), or a designator on a scalar */
    if (gn->a && gn->a->kind == ND_INIT_LIST && !is_aggregate(t))
        die("lower:%d: braced initializer for scalar type must hold a single value",
            gn->a->line);

    /* char x[] = "..." : deduce the bound as the string plus its NUL into the
       TYPE (sizeof reads the type), before any branch reads cc_type_size(t).
       Mirrors lower_local_decl; without it the array keeps length -1 and
       sizeof folds to garbage. */
    if (t->kind == TY_ARRAY && t->array_len < 0 && gn->a &&
        gn->a->kind == ND_STRLIT)
        t->array_len = gn->a->slen + 1;

    if (gn->is_extern) {
        add_global(gn->name, t, t->kind == TY_FUNC);
        return;
    }
    if (t->kind == TY_FUNC) {
        add_global(gn->name, t, 1);
        return;
    }

    struct ir_global *g = arena_zalloc(lower_arena, sizeof *g);
    g->name = arena_strdup(lower_arena, gn->name);
    g->is_rodata = type_is_readonly(t);

    if (wants_image(t, gn->a)) {
        /* an aggregate global (struct/union, or an array of one) is a byte
           blob of its full size, aligned to the aggregate's alignment; an
           initializer becomes an ir_init byte image (see build_image) */
        if (t->kind == TY_ARRAY && t->array_len < 0 && gn->a &&
            gn->a->kind == ND_INIT_LIST) {
            t->array_len = infer_array_len(gn->a);
        }
        g->base_type = IR_I8;
        g->arr_size = cc_type_size(t);
        g->align = cc_type_align(t);
        if (gn->a && gn->a->kind == ND_INIT_LIST)
            g->inits = lower_aggregate_init(t, gn->a);
    } else if (t->kind == TY_ARRAY) {
        g->base_type = type_to_ir(t->base);
        if (t->array_len < 0 && gn->a &&
            gn->a->kind == ND_INIT_LIST) {
            /* one top-level initializer per element, whatever the element
               width (dividing a flat leaf count by the element size in words
               mis-sized an 8-byte-element array). */
            t->array_len = infer_array_len(gn->a);
        }
        g->arr_size = t->array_len > 0 ? t->array_len : 0;
    } else if (t->kind == TY_PTR) {
        g->base_type = ADDR64 ? IR_I64 : IR_I32;
        g->is_ptr = 1;
    } else {
        g->base_type = type_to_ir(t);
    }

    if (gn->a && !g->inits) {
        if (gn->a->kind == ND_STRLIT && t->kind != TY_PTR) {
            g->init_string = arena_alloc(lower_arena, gn->a->slen + 1);
            memcpy(g->init_string, gn->a->sval, gn->a->slen);
            g->init_string[gn->a->slen] = '\0';
            g->init_strlen = gn->a->slen + 1;
            if (g->arr_size == 0)
                g->arr_size = gn->a->slen + 1;
        } else if (t->kind == TY_PTR) {
            /* a pointer global initialized by an address constant: &var, an
               array/function name (decays), a string literal, or a symbol plus
               a byte offset (&a[2], a + 2, "s" + 1, &s.f).  encode_scalar
               yields the symbol and, in val, the addend; init_syms emits it as
               a relocation.  An integer-constant pointer folds to a bare value. */
            int64_t val = 0;
            char *sym = NULL;
            encode_scalar(t, gn->a, &val, &sym);
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = val;
            if (sym) {
                g->init_syms = arena_zalloc(lower_arena, sizeof(char *));
                g->init_syms[0] = sym;
            }
            g->init_count = 1;
        } else if (gn->a->kind == ND_INIT_LIST) {
            int cnt = count_init_flat(gn->a);
            g->init_ivals = arena_alloc(lower_arena, cnt * sizeof(int64_t));
            g->init_syms = arena_zalloc(lower_arena, cnt * sizeof(char *));
            int pos = 0;
            flatten_init(flat_elem_type(t), gn->a,
                         g->init_ivals, g->init_syms, &pos);
            g->init_count = pos;
            if (g->arr_size == 0)
                g->arr_size = pos;
        } else if (t->kind == TY_FLOAT || t->kind == TY_DOUBLE ||
                   t->kind == TY_FLOAT16) {
            /* a scalar float/double/half global initialized by a literal:
               encode its bit pattern (encode_scalar converts a float or int
               literal to the slot's representation).  Without this the
               initializer was never captured and the global defaulted to
               zero, so `static double d = 1.5;` silently became 0.0. */
            int64_t val = 0;
            char *sym = NULL;
            encode_scalar(t, gn->a, &val, &sym);
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = val;
            g->init_count = 1;
        } else if (is_bool_type(t)) {
            /* a _Bool global holds only 0 or 1 */
            int64_t v = gn->a->kind == ND_FLOATLIT
                        ? (gn->a->fval != 0.0)
                        : (fold_int_const(gn->a) != 0);
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = v;
            g->init_count = 1;
        } else if (gn->a->kind == ND_INTLIT) {
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = gn->a->ival;
            g->init_count = 1;
        } else if (gn->a->kind == ND_UNOP && gn->a->op == TOK_MINUS &&
                   gn->a->a && gn->a->a->kind == ND_INTLIT) {
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = -gn->a->a->ival;
            g->init_count = 1;
        } else if (cc_type_is_integer(t)) {
            /* an integer scalar initialized by a constant expression (A * B,
               1 << N, or the offsetof idiom (size_t)&((T *)0)->m): fold it.  A
               bare literal matched above; this covers the general constant
               expression, which was previously dropped to zero (emitted as
               .space) rather than evaluated. */
            g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
            g->init_ivals[0] = fold_int_const(gn->a);
            g->init_count = 1;
        }
    }

    if (gn->align > g->align)   /* _Alignas raises the global's alignment */
        g->align = gn->align;

    g->next = cur_prog->globals;
    cur_prog->globals = g;
    add_global(gn->name, t, 0);
}

/****************************************************************
 * Entry point
 ****************************************************************/

struct ir_program *
cc_lower_program(struct arena *a, struct cc_node *ast)
{
    lower_arena = a;
    struct ir_program *prog = arena_zalloc(lower_arena, sizeof *prog);
    cur_prog = prog;
    nglobals = 0;
    str_counter = 0;

    /* let const_eval size `sizeof expr` operands by their declared type (the
       parser leaves expression nodes untyped); active only during lowering. */
    cc_const_sizeof_typer = lvalue_type;

    /* register the varargs builtins so a call to one types by its return
       type (the lowering intercepts them by name; this is just for typing) */
    {
        struct cc_type *dbl = arena_zalloc(lower_arena, sizeof *dbl);
        dbl->kind = TY_DOUBLE;
        struct cc_type *rets[3] = { cc_type_int(), cc_type_long(), dbl };
        const char *nms[3] = { "__builtin_va_arg_int",
                               "__builtin_va_arg_long", "__builtin_va_arg_dbl" };
        for (int k = 0; k < 3; k++) {
            struct cc_type *ft = arena_zalloc(lower_arena, sizeof *ft);
            ft->kind = TY_FUNC;
            ft->base = rets[k];
            add_global(nms[k], ft, 1);
        }
    }

    /* first pass: register globals and functions */
    for (struct cc_node *d = ast->body; d; d = d->next) {
        if (d->kind == ND_GLOBAL_DECL)
            lower_global_decl(d);
        else if (d->kind == ND_FUNC_DEF)
            add_global(d->name, d->decl_type, 1);
    }

    /* second pass: lower function bodies */
    struct ir_func **ftail = &prog->funcs;
    for (struct cc_node *d = ast->body; d; d = d->next) {
        if (d->kind != ND_FUNC_DEF)
            continue;
        struct ir_func *fn = lower_function(d);
        if (!fn)                        /* skipped (e.g. a long double inline) */
            continue;
        *ftail = fn;
        ftail = &fn->next;
    }

    free(slot_sizes);
    free(slot_aligns);
    slot_sizes = NULL;
    slot_aligns = NULL;
    nslots = slot_cap = 0;

    free(locals);
    locals = NULL;
    nlocals = local_cap = 0;

    free(globals);
    globals = NULL;
    nglobals = global_cap = 0;

    return prog;
}
