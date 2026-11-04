/* lower.c : Pascal AST to IR lowering */

#include "pascal.h"
#include "arena.h"
#include "target.h"

#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Convenience wrappers
 ****************************************************************/

static struct arena *lower_arena;
static struct ir_func *cur_fn;

/* Debug info (-g), see pascal.h. */
int pascal_debug = 0;
const char *pascal_src_file = NULL;
static int last_loc_line;               /* last line marked in this function */
static struct ir_program *cur_prog;
static int is_string_type(struct node *n);
static int is_set_type(struct node *n);
static int lower_set_addr(struct node *n);

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

/****************************************************************
 * Target pointer width
 *
 * The shared SKJ_LP64 width axis (target.h) is set for the x86-64 and aarch64
 * builds, where a pointer is a full 64-bit value and differs in width from an
 * int.  There the front end emits the IR's 64-bit address opcodes (IR_LEA64,
 * IR_ADL64, IR_LDL64, IR_ADD64, IR_ARG64), keeps pointer-carrying slots 8 bytes,
 * and loads a pointee scalar with the ordinary 32-bit IR_LW / IR_SW.  The ILP32
 * targets (ColdFire) leave SKJ_LP64 unset and keep the 32-bit address opcodes,
 * so a single IR_ADD / IR_LEA serves both a value and an address.
 ****************************************************************/

#define PC_LP64_ON   SKJ_LP64
#define PC_PTR_BYTES SKJ_PTR_BYTES

/* A heap string value is a pointer to a {refcount, kind, len, cap} descriptor
   (four 32-bit words, 16 bytes) with the bytes following it; NULL is the empty
   string.  The bytes of character N (1-based) are at offset PSTR_HDR + (N-1).
   The layout matches the backend's strobj global emission and the runtime's
   struct pstr. */
#define PSTR_HDR 16

/* Per-temp flag: set when a temp holds a pointer / full-width address, so a
   call passes it as IR_ARG64 under LP64.  Temp ids restart at 0 per function,
   so the table is cleared at each function's entry. */
static unsigned char *temp_is_ptr;
static int temp_is_ptr_cap;

/* Per-temp flag: set when a temp holds a 64-bit (Int64/QWord) value, so the
   binary operators, loads, stores, arguments and results pick the IR's 64-bit
   opcodes.  Like temp_is_ptr it is cleared at each function's entry. */
static unsigned char *temp_is_i64;
static int temp_is_i64_cap;

/* Per-temp float kind: 0 = integer, 1 = double (fw 0), 2 = single (FWIDTH_F32).
   Drives the float opcodes, argument width tags and conversions. */
static unsigned char *temp_fkind;
static int temp_fkind_cap;

static void
reset_ptr_flags(void)
{
    if (temp_is_ptr)
        memset(temp_is_ptr, 0, temp_is_ptr_cap);
    if (temp_is_i64)
        memset(temp_is_i64, 0, temp_is_i64_cap);
    if (temp_fkind)
        memset(temp_fkind, 0, temp_fkind_cap);
}

static void
mark_ptr(int t)
{
    if (!PC_LP64_ON || t < 0)
        return;
    if (t >= temp_is_ptr_cap) {
        int nc = temp_is_ptr_cap ? temp_is_ptr_cap * 2 : 256;
        while (t >= nc)
            nc *= 2;
        temp_is_ptr = realloc(temp_is_ptr, nc);
        if (!temp_is_ptr)
            die("oom");
        memset(temp_is_ptr + temp_is_ptr_cap, 0, nc - temp_is_ptr_cap);
        temp_is_ptr_cap = nc;
    }
    temp_is_ptr[t] = 1;
}

static int
is_ptr(int t)
{
    return PC_LP64_ON && t >= 0 && t < temp_is_ptr_cap && temp_is_ptr[t];
}

static void
mark_i64(int t)
{
    if (t < 0)
        return;
    if (t >= temp_is_i64_cap) {
        int nc = temp_is_i64_cap ? temp_is_i64_cap * 2 : 256;
        while (t >= nc)
            nc *= 2;
        temp_is_i64 = realloc(temp_is_i64, nc);
        if (!temp_is_i64)
            die("oom");
        memset(temp_is_i64 + temp_is_i64_cap, 0, nc - temp_is_i64_cap);
        temp_is_i64_cap = nc;
    }
    temp_is_i64[t] = 1;
}

static int
is_i64(int t)
{
    return t >= 0 && t < temp_is_i64_cap && temp_is_i64[t];
}

/* Mark temp t as a float value of the given IR width tag (0 = double,
   FWIDTH_F32 = single). */
static void
mark_float(int t, int fw)
{
    if (t < 0)
        return;
    if (t >= temp_fkind_cap) {
        int nc = temp_fkind_cap ? temp_fkind_cap * 2 : 256;
        while (t >= nc)
            nc *= 2;
        temp_fkind = realloc(temp_fkind, nc);
        if (!temp_fkind)
            die("oom");
        memset(temp_fkind + temp_fkind_cap, 0, nc - temp_fkind_cap);
        temp_fkind_cap = nc;
    }
    temp_fkind[t] = (unsigned char)(fw == FWIDTH_F32 ? 2 : 1);
}

static int
is_float(int t)
{
    return t >= 0 && t < temp_fkind_cap && temp_fkind[t];
}

/* The IR width tag of a float temp: 0 for double, FWIDTH_F32 for single. */
static int
float_fw(int t)
{
    return (t >= 0 && t < temp_fkind_cap && temp_fkind[t] == 2)
           ? FWIDTH_F32 : 0;
}

/* Address / pointer emit helpers, width-correct for the target.  Each returns
   a temp marked as a pointer. */

static int
emit_lea_sym(const char *name)   /* address of a global symbol */
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_LEA64 : IR_LEA);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena, name);
    mark_ptr(ins->dst);
    return ins->dst;
}

static int
emit_adl(int slot)               /* address of a local slot */
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_ADL64 : IR_ADL);
    ins->dst = new_temp();
    ins->slot = slot;
    mark_ptr(ins->dst);
    return ins->dst;
}

static int
emit_load_ptr(int slot)          /* load a pointer value out of a slot */
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_LDL64 : IR_LDL);
    ins->dst = new_temp();
    ins->slot = slot;
    mark_ptr(ins->dst);
    return ins->dst;
}

static void
emit_store_ptr(int slot, int val) /* store a pointer value into a slot */
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_STL64 : IR_STL);
    ins->slot = slot;
    ins->a = val;
}

static int
emit_addp(int base, int off)     /* pointer + integer offset -> pointer */
{
    struct ir_insn *ins;

    /* Under LP64 the offset is a signed 32-bit value (an array index times the
       element size can be negative for a lower bound above 0, or for an
       out-of-range index a non-short-circuit `and` still evaluates).  A 32-bit
       op zero-extends its result, so sign-extend the offset to 64 bits before
       adding it to the 64-bit base, or a small negative offset would become a
       huge positive address. */
    if (PC_LP64_ON) {
        ins = emit(IR_SEXT64);
        ins->dst = new_temp();
        ins->a = off;
        off = ins->dst;
    }
    ins = emit(PC_LP64_ON ? IR_ADD64 : IR_ADD);
    ins->dst = new_temp();
    ins->a = base;
    ins->b = off;
    mark_ptr(ins->dst);
    return ins->dst;
}

/* Int64 value helpers.  A 64-bit value lives in a temp flagged by mark_i64; a
   32-bit value is sign-extended to 64 bits on demand (Integer and LongInt are
   signed), and a 64-bit value is truncated back where a 32-bit context (an
   array index, a byte store) needs it. */

static int
to_i64(int t)
{
    struct ir_insn *ins;

    if (is_i64(t))
        return t;
    ins = emit(IR_SEXT64);
    ins->dst = new_temp();
    ins->a = t;
    mark_i64(ins->dst);
    return ins->dst;
}

static int
to_i32(int t)
{
    struct ir_insn *ins;

    if (!is_i64(t))
        return t;
    ins = emit(IR_TRUNC64);
    ins->dst = new_temp();
    ins->a = t;
    return ins->dst;
}

/* Coerce a value to a floating-point temp of IR width tag fw (0 = double,
   FWIDTH_F32 = single).  An integer is converted with IR_ITOF; a float of the
   other width is narrowed or widened with IR_F32TOF64 / IR_F64TOF32. */
static int
to_float(int t, int fw)
{
    struct ir_insn *ins;

    if (!is_float(t)) {
        t = to_i32(t);                  /* ITOF takes a 32-bit integer */
        ins = emit(IR_ITOF);
        ins->dst = new_temp();
        ins->a = t;
        ins->imm = fw;
        mark_float(ins->dst, fw);
        return ins->dst;
    }
    if (float_fw(t) == fw)
        return t;
    ins = emit(fw == FWIDTH_F32 ? IR_F64TOF32 : IR_F32TOF64);
    ins->dst = new_temp();
    ins->a = t;
    ins->imm = fw;
    mark_float(ins->dst, fw);
    return ins->dst;
}

/* Convert a float value to a 32-bit integer (truncation toward zero). */
static int
float_to_int(int t)
{
    struct ir_insn *ins;

    if (!is_float(t))
        return t;
    ins = emit(IR_FTOI);
    ins->dst = new_temp();
    ins->a = t;
    ins->imm = float_fw(t);
    return ins->dst;
}

/****************************************************************
 * Symbol table
 ****************************************************************/

struct sym {
    char *name;
    int is_local;
    int slot;
    int is_func;
    int is_const;
    long const_val;
    char *const_str;
    int const_slen;
    int is_var_param;
    char *type_name;
    struct node *decl;
    char *ir_name;
    int ncaptures;
    char **captures;
};

static struct sym *syms;
static int nsyms;
static int sym_cap;
static int sym_base;

static int *slot_sizes;
static int nslots;
static int slot_cap;

static int
alloc_slot(int bytes)
{
    if (nslots == slot_cap) {
        slot_cap = slot_cap ? slot_cap * 2 : 16;
        slot_sizes = realloc(slot_sizes,
                             slot_cap * sizeof(*slot_sizes));
        if (!slot_sizes)
            die("oom");
    }
    slot_sizes[nslots] = bytes;
    return nslots++;
}

static void
push_sym(struct sym s)
{
    if (nsyms == sym_cap) {
        sym_cap = sym_cap ? sym_cap * 2 : 32;
        syms = realloc(syms, sym_cap * sizeof(*syms));
        if (!syms)
            die("oom");
    }
    syms[nsyms++] = s;
}

static struct sym *
find_sym(const char *name)
{
    for (int i = nsyms - 1; i >= 0; i--)
        if (strcmp(syms[i].name, name) == 0)
            return &syms[i];
    return NULL;
}

/****************************************************************
 * Break/continue stack
 ****************************************************************/

struct loop {
    int brk;
    int cont;
};

static struct loop loops[64];
static int nloops;

/****************************************************************
 * With-statement context stack
 ****************************************************************/

struct with_ctx {
    int base_slot;
    struct type_def *td;
};

static struct with_ctx with_stack[16];
static int nwith;

/****************************************************************
 * Nested function support
 ****************************************************************/

static struct ir_func *nested_funcs;
static struct ir_func **nested_ftail;

/****************************************************************
 * Generated element finalizers for dynamic arrays of managed elements
 *
 * A dynamic array of string (or of a record with string members) must drop its
 * elements' references when the descriptor is freed or shrunk.  The element
 * count is only known at run time, so the work is a run-time loop in the
 * runtime (__pascal_arr_release / __pascal_arr_setlength_mgd) over a per-element
 * callback.  For an element that is a single managed pointer the callback is a
 * fixed runtime helper; for a record element the compiler generates a small
 * finalize ('dtor') and retain function here, once per element type.
 ****************************************************************/

struct elem_fn {
    char *type_name;        /* element type these functions finalize */
    char dtor[64];          /* release-one-element function symbol */
    char retain[64];        /* retain-one-element function symbol */
};
static struct elem_fn elem_fns[128];
static int nelem_fns;
static struct ir_func *gen_funcs;       /* generated finalizer/retainer list */
static struct ir_func **gen_ftail;

static void
collect_names(struct node *n, char **names, int *nn, int cap)
{
    if (!n)
        return;
    if (n->kind == N_NAME && n->name) {
        int dup = 0;
        for (int i = 0; i < *nn; i++)
            if (strcmp(names[i], n->name) == 0) {
                dup = 1;
                break;
            }
        if (!dup && *nn < cap)
            names[(*nn)++] = n->name;
    }
    collect_names(n->a, names, nn, cap);
    collect_names(n->b, names, nn, cap);
    collect_names(n->c, names, nn, cap);
    collect_names(n->d, names, nn, cap);
    collect_names(n->next, names, nn, cap);
}

static int
find_captures(struct node *decl, int outer_start,
              char **caps, int max_caps)
{
    char *names[256];
    int nn = 0, nc = 0;
    struct node *block = decl->b;

    if (block && block->kind == N_BLOCK) {
        collect_names(block->d, names, &nn, 256);
        for (struct node *v = block->b; v; v = v->next)
            collect_names(v->a, names, &nn, 256);
    }

    for (int i = 0; i < nn; i++) {
        int skip = 0;

        for (struct node *p = decl->a; p; p = p->next)
            if (strcmp(p->name, names[i]) == 0) {
                skip = 1;
                break;
            }
        if (skip)
            continue;

        if (block && block->kind == N_BLOCK) {
            for (struct node *v = block->b; v; v = v->next)
                if (strcmp(v->name, names[i]) == 0) {
                    skip = 1;
                    break;
                }
        }
        if (skip)
            continue;

        if (block && block->kind == N_BLOCK) {
            for (struct node *c = block->a; c; c = c->next)
                if (c->kind == N_CONSTDECL &&
                    strcmp(c->name, names[i]) == 0) {
                    skip = 1;
                    break;
                }
        }
        if (skip)
            continue;

        if (strcmp(names[i], decl->name) == 0)
            continue;

        for (int j = nsyms - 1; j >= outer_start; j--) {
            if (strcmp(syms[j].name, names[i]) == 0) {
                if (syms[j].is_local && !syms[j].is_func &&
                    !syms[j].is_const) {
                    if (nc < max_caps)
                        caps[nc++] = names[i];
                }
                break;
            }
        }
    }
    return nc;
}

/****************************************************************
 * Function return tracking
 ****************************************************************/

static const char *cur_func_name;
static int ret_slot;
static int ret_is_i64;          /* the current function returns an Int64 */
static int ret_is_float;        /* the current function returns a real */
static int ret_fw;              /* its float width tag when ret_is_float */
static int ret_is_str;          /* the current function returns a heap string */
static int ret_is_compound;     /* returns a record or fixed array (via sret) */
static int ret_ptr_slot;        /* hidden sret pointer slot when ret_is_compound */
static const char *ret_type_name;   /* its declared return type when ret_is_str */
static int exit_label;

/****************************************************************
 * Type table
 ****************************************************************/

struct type_field {
    char *name;
    char *type_name;
    int offset;
    int size;
};

struct type_def {
    char *name;
    int total_size;
    int nfields;
    struct type_field *fields;
    int is_array;
    int is_dynarray;            /* `array of T`: a refcounted heap descriptor */
    int lo_bound;
    int hi_bound;
    int elem_size;
    char *elem_type_name;
    char *index_type_name;      /* array[OrdinalType]: bounds from this type */
    struct node *lo_expr;       /* array[lo..hi]: bounds whose consts resolve */
    struct node *hi_expr;       /* only after the whole const section (fixup) */
    int is_string;
    int maxlen;
    int is_set;
    int is_scalar;              /* a built-in or aliased ordinal/scalar type */
    int is_ordinal;             /* an enum or subrange with lo_bound..hi_bound */
    int is_i64;                 /* a 64-bit scalar (Int64 / QWord) */
    char *alias_of;             /* `type X = Y;`: resolve X through Y */
};

static struct type_def *types;
static int ntypes;
static int type_cap;

static struct type_def *find_type(const char *name);
static struct type_def *resolve_type(const char *name);
static long const_eval(struct node *n);

/* Is a type name a 64-bit scalar?  Resolves built-in names and alias chains. */
static int
is_i64_type_name(const char *name)
{
    struct type_def *t;

    if (!name)
        return 0;
    if (strcmp(name, "int64") == 0 || strcmp(name, "qword") == 0 ||
        strcmp(name, "uint64") == 0)
        return 1;
    t = find_type(name);
    if (!t)
        return 0;
    if (t->is_i64)
        return 1;
    if (t->alias_of)
        return is_i64_type_name(t->alias_of);
    return 0;
}

/* Is a type name a floating-point scalar, and if so its IR width tag?
   real/double/float/extended are double (fw 0); single is f32 (FWIDTH_F32).
   Returns -1 when the name is not a float type. */
static int
float_fw_of_name(const char *name)
{
    struct type_def *t;

    if (!name)
        return -1;
    if (strcmp(name, "real") == 0 || strcmp(name, "double") == 0 ||
        strcmp(name, "float") == 0 || strcmp(name, "extended") == 0)
        return 0;
    if (strcmp(name, "single") == 0 || strcmp(name, "shortreal") == 0)
        return FWIDTH_F32;
    t = find_type(name);
    if (t && t->alias_of)
        return float_fw_of_name(t->alias_of);
    return -1;
}

static int
is_float_type_name(const char *name)
{
    return float_fw_of_name(name) >= 0;
}

/* Is a type name a (heap) string type?  Resolves alias chains. */
static int
is_string_type_name(const char *name)
{
    struct type_def *t;

    if (!name)
        return 0;
    t = find_type(name);
    if (!t)
        return 0;
    if (t->is_string)
        return 1;
    if (t->alias_of)
        return is_string_type_name(t->alias_of);
    return 0;
}

/* Is a type name a dynamic array (`array of T`)?  Resolves alias chains. */
static int
is_dynarray_type_name(const char *name)
{
    struct type_def *t;

    if (!name)
        return 0;
    t = find_type(name);
    if (!t)
        return 0;
    if (t->is_dynarray)
        return 1;
    if (t->alias_of)
        return is_dynarray_type_name(t->alias_of);
    return 0;
}

/* A string-like value: a heap string or a dynamic array.  Both are refcounted
   heap pointers with the same descriptor header, stored, assigned, retained,
   released, null-inited and returned the same way; only indexing and the
   builtins differ. */
static int
is_strlike_type_name(const char *name)
{
    return is_string_type_name(name) || is_dynarray_type_name(name);
}

/* Does a value of this type contain any managed (string) member, directly or
   nested inside a record field or array element?  Used to decide whether an
   aggregate copy or scope exit needs reference-count maintenance.  Pascal
   by-value members cannot form a cycle, so the recursion terminates. */
static int
type_has_managed(const char *name)
{
    struct type_def *t;
    int i;

    if (!name)
        return 0;
    if (is_strlike_type_name(name))
        return 1;
    t = find_type(name);
    if (!t)
        return 0;
    if (t->alias_of)
        return type_has_managed(t->alias_of);
    if (t->is_array)
        return type_has_managed(t->elem_type_name);
    for (i = 0; i < t->nfields; i++)
        if (type_has_managed(t->fields[i].type_name))
            return 1;
    return 0;
}

/* Storage size in bytes for a type name.  The scalar unit is 4 bytes; Int64,
   QWord and double-precision reals are 8; single is 4; aggregates carry their
   own total_size. */
static int
type_bytes(const char *name)
{
    struct type_def *t;
    int fw;

    if (!name)
        return 4;
    if (is_i64_type_name(name))
        return 8;
    fw = float_fw_of_name(name);
    if (fw == 0)
        return 8;               /* double / real */
    if (fw == FWIDTH_F32)
        return 4;               /* single */
    t = find_type(name);
    if (!t)
        return 4;
    if (t->is_string)
        return PC_PTR_BYTES;
    if (t->alias_of)
        return type_bytes(t->alias_of);
    if (t->total_size)
        return t->total_size;
    return 4;
}

/* Natural alignment of a record field: the largest power of two that is no
   larger than the field and no larger than the record's {$A} cap.  A 4-byte
   integer aligns to 4 even on LP64, while an 8-byte pointer, Int64 or real
   stays 8-aligned where the ABI and the Mach-O static linker need it.  Keeping
   the alignment to the field's own size (not the pointer width) is what makes
   a record of integers size the same under ILP32 and LP64. */
static int
field_align(int fsz, int cap)
{
    int a = fsz >= 8 ? 8 : fsz >= 4 ? 4 : fsz >= 2 ? 2 : 1;

    if (a > cap)
        a = cap;
    if (a < 1)
        a = 1;
    return a;
}

/* Whether a constant array bound can be evaluated now: every identifier in it
   is an already-registered constant.  A built-in call such as ord(...) checks
   only its argument (the callee name is not a constant). */
static int
bound_resolvable(struct node *n)
{
    if (!n)
        return 1;
    if (n->kind == N_NAME) {
        struct sym *s = find_sym(n->name);
        return s && s->is_const;
    }
    if (n->kind == N_CALL)
        return bound_resolvable(n->b);
    return bound_resolvable(n->a) && bound_resolvable(n->b);
}

/* Ensure a canonical heap-string type exists and return its name.  Used for
   string-valued constants, which carry no explicit type name of their own. */
static const char *
canonical_string_type_name(void)
{
    struct type_def *t;

    t = find_type("$string");
    if (t)
        return t->name;
    if (ntypes == type_cap) {
        type_cap = type_cap ? type_cap * 2 : 8;
        types = realloc(types, type_cap * sizeof(*types));
        if (!types)
            die("oom");
    }
    t = &types[ntypes++];
    memset(t, 0, sizeof(*t));
    t->name = "$string";
    t->is_string = 1;
    t->maxlen = 255;
    t->total_size = PC_PTR_BYTES;
    return t->name;
}

/* A record or fixed array returned by value: handled with a hidden sret
   pointer argument.  A string, set, or scalar return type is not. */
static int
type_is_sret(const char *name)
{
    struct type_def *t;

    if (!name)
        return 0;
    if (is_strlike_type_name(name))
        return 0;
    t = find_type(name);
    if (!t)
        return 0;
    return !t->is_scalar && !t->is_set;
}

static void
register_type(struct node *td)
{
    struct type_def *t;
    struct node *f;
    int nf, off;

    if (ntypes == type_cap) {
        type_cap = type_cap ? type_cap * 2 : 8;
        types = realloc(types, type_cap * sizeof(*types));
        if (!types)
            die("oom");
    }
    t = &types[ntypes++];
    memset(t, 0, sizeof(*t));
    t->name = td->name;

    if (td->op == 2) {
        int ml = (int)td->ival;
        t->is_string = 1;
        t->maxlen = ml;
        t->total_size = PC_PTR_BYTES;   /* a heap string slot holds a pointer */
        return;
    }

    if (td->op == 3) {
        t->is_set = 1;
        t->total_size = 32;
        return;
    }

    if (td->op == 4) {
        /* `type X = Y;` type alias (Y is a named type). */
        t->is_scalar = 1;
        t->alias_of = td->sval;
        t->is_i64 = is_i64_type_name(td->sval);
        t->total_size = type_bytes(td->sval);
        return;
    }

    if (td->op == 5) {
        /* `type X = lo..hi;` subrange: an ordinal scalar.  A bound outside the
           signed 32-bit range makes it a 64-bit scalar. */
        long long lo = const_eval(td->b);
        long long hi = const_eval(td->c);
        t->is_scalar = 1;
        t->is_ordinal = 1;
        t->lo_bound = (int)lo;
        t->hi_bound = (int)hi;
        if (lo < -2147483647LL - 1 || hi > 2147483647LL) {
            t->is_i64 = 1;
            t->total_size = 8;
        } else {
            t->total_size = 4;
        }
        return;
    }

    if (td->op == 6) {
        /* `type X = array of T;` dynamic array: a refcounted heap descriptor
           ({refcount, kind, len, cap} header, elements at +PSTR_HDR) addressed
           by a pointer, NULL when empty. */
        int esz = type_bytes(td->sval);
        struct type_def *et = td->sval ? find_type(td->sval) : NULL;
        if (et)
            esz = et->total_size;
        t->is_array = 1;
        t->is_dynarray = 1;
        t->lo_bound = 0;
        t->hi_bound = -1;
        t->elem_size = esz;
        t->elem_type_name = td->sval;
        t->total_size = PC_PTR_BYTES;
        return;
    }

    if (td->op == 7) {
        /* `type X = (a, b, c, ...);` enumeration: an ordinal scalar whose
           values are 0..count-1.  The literals themselves are registered as
           integer constants by the const section. */
        t->is_scalar = 1;
        t->is_ordinal = 1;
        t->lo_bound = 0;
        t->hi_bound = (int)td->ival - 1;
        t->total_size = 4;
        return;
    }

    if (td->op == 1) {
        int esz = type_bytes(td->sval);
        if (td->sval) {
            struct type_def *et = find_type(td->sval);
            if (et)
                esz = et->total_size;
        }
        t->is_array = 1;
        t->elem_size = esz;
        t->elem_type_name = td->sval;
        if (td->c) {
            /* [lo..hi]: evaluate now when every name in the bounds is an
               already-registered const (so a record's array field is sized
               correctly), otherwise defer to the fixup once the whole const
               section has been seen (a forward-referenced const). */
            if (bound_resolvable(td->b) && bound_resolvable(td->c)) {
                long lo = const_eval(td->b);
                long hi = const_eval(td->c);
                t->lo_bound = (int)lo;
                t->hi_bound = (int)hi;
                t->total_size = (int)(hi - lo + 1) * esz;
            } else {
                t->lo_expr = td->b;
                t->hi_expr = td->c;
            }
        } else {
            /* array[OrdinalType]: the index is a named ordinal type whose
               bounds may not be registered yet, so resolve them (and the size)
               in the fixup pass after every type is registered. */
            if (!td->b || td->b->kind != N_NAME)
                die("lower:%d: array index must be a range or ordinal type",
                    td->line);
            t->index_type_name = td->b->name;
        }
        return;
    }

    nf = 0;
    for (f = td->a; f; f = f->next) {
        if (f->kind == N_VARIANTPART) {
            if (f->name)
                nf++;
            for (struct node *arm = f->a; arm;
                arm = arm->next)
                for (struct node *vf = arm->b; vf;
                    vf = vf->next)
                    nf++;
        } else {
            nf++;
        }
    }
    t->nfields = nf;
    t->fields = arena_zalloc(lower_arena, nf * sizeof(*t->fields));
    off = 0;
    nf = 0;
    {
        int align = td->ival > 0 ? (int)td->ival : 4;
        int ra = 1;             /* the record's own alignment (max field) */

        for (f = td->a; f; f = f->next) {
            if (f->kind == N_VARIANTPART) {
                int vbase, max_vsize, varal = 1;
                if (f->name) {
                    int tsz = type_bytes(f->sval);
                    int fa = field_align(tsz, align);
                    if (off % fa != 0)
                        off += fa - (off % fa);
                    if (fa > ra)
                        ra = fa;
                    t->fields[nf].name = f->name;
                    t->fields[nf].type_name = f->sval;
                    t->fields[nf].offset = off;
                    t->fields[nf].size = tsz;
                    off += tsz;
                    nf++;
                }
                /* The variant base must be aligned for the widest arm field,
                   so every arm's fields land on their natural boundary. */
                for (struct node *arm = f->a; arm;
                    arm = arm->next)
                    for (struct node *vf = arm->b;
                        vf; vf = vf->next) {
                        int fa = field_align(
                            type_bytes(vf->sval), align);
                        if (fa > varal)
                            varal = fa;
                    }
                if (off % varal != 0)
                    off += varal - (off % varal);
                if (varal > ra)
                    ra = varal;
                vbase = off;
                max_vsize = 0;
                for (struct node *arm = f->a; arm;
                    arm = arm->next) {
                    int arm_off = vbase;
                    for (struct node *vf = arm->b;
                        vf; vf = vf->next) {
                        int fsz = type_bytes(vf->sval);
                        int fa = field_align(fsz, align);
                        if (arm_off % fa != 0)
                            arm_off += fa -
                                (arm_off % fa);
                        t->fields[nf].name =
                            vf->name;
                        t->fields[nf].type_name =
                            vf->sval;
                        t->fields[nf].offset =
                            arm_off;
                        t->fields[nf].size = fsz;
                        arm_off += fsz;
                        nf++;
                    }
                    if (arm_off - vbase > max_vsize)
                        max_vsize = arm_off - vbase;
                }
                off = vbase + max_vsize;
                continue;
            }
            {
                int fsz = type_bytes(f->sval);
                int fa = field_align(fsz, align);
                t->fields[nf].name = f->name;
                t->fields[nf].type_name = f->sval;
                if (off % fa != 0)
                    off += fa - (off % fa);
                if (fa > ra)
                    ra = fa;
                t->fields[nf].offset = off;
                t->fields[nf].size = fsz;
                off += fsz;
                nf++;
            }
        }
        /* Pad the record to its own alignment so an array of it tiles. */
        if (ra > 1 && (off % ra) != 0)
            off += ra - (off % ra);
    }
    t->total_size = off;
}

static struct type_def *
find_type(const char *name)
{
    for (int i = 0; i < ntypes; i++)
        if (strcmp(types[i].name, name) == 0)
            return &types[i];
    return NULL;
}

static int
type_field_offset(struct type_def *t, const char *field)
{
    for (int i = 0; i < t->nfields; i++)
        if (strcmp(t->fields[i].name, field) == 0)
            return t->fields[i].offset;
    return -1;
}

/****************************************************************
 * String literal pool
 ****************************************************************/

static int strctr;

static void
add_string_global(const char *label, const char *data, int len)
{
    struct ir_global *g;

    g = arena_zalloc(lower_arena, sizeof(*g));
    g->name = arena_strdup(lower_arena, label);
    g->base_type = IR_I8;
    g->arr_size = len;
    g->is_local = 1;
    g->init_string = arena_alloc(lower_arena, len);
    memcpy(g->init_string, data, len);
    g->init_strlen = len;
    g->next = cur_prog->globals;
    cur_prog->globals = g;
}

/****************************************************************
 * IR emission helpers
 ****************************************************************/

static int
lower_const(long v)
{
    struct ir_insn *ins;

    ins = emit(IR_LIC);
    ins->dst = new_temp();
    ins->imm = v;
    return ins->dst;
}

static int
lower_const64(long long v)
{
    struct ir_insn *ins;

    ins = emit(IR_LIC64);
    ins->dst = new_temp();
    ins->imm = v;
    mark_i64(ins->dst);
    return ins->dst;
}

/* Materialise a floating-point constant: emit a read-only global holding the
   bit pattern, then load it (IR_FLD, width in imm). */
static int
lower_real_const(double v, int fw)
{
    struct ir_global *g;
    struct ir_insn *ins;
    char namebuf[32];
    int addr;

    snprintf(namebuf, sizeof(namebuf), "__flt_%d", strctr++);
    g = arena_zalloc(lower_arena, sizeof(*g));
    g->name = arena_strdup(lower_arena, namebuf);
    g->is_local = 1;
    g->is_rodata = 1;
    g->init_ivals = arena_alloc(lower_arena, sizeof(int64_t));
    if (fw == FWIDTH_F32) {
        union { float f; int32_t i; } u;
        u.f = (float)v;
        g->base_type = IR_F32;
        g->init_ivals[0] = u.i;
    } else {
        union { double d; int64_t i; } u;
        u.d = v;
        g->base_type = IR_F64;
        g->init_ivals[0] = u.i;
    }
    g->init_count = 1;
    g->next = cur_prog->globals;
    cur_prog->globals = g;

    addr = emit_lea_sym(namebuf);
    ins = emit(IR_FLD);
    ins->dst = new_temp();
    ins->a = addr;
    ins->imm = fw;
    mark_float(ins->dst, fw);
    return ins->dst;
}

static void
emit_block_copy(int dst_addr, int src_addr, int nbytes)
{
    struct ir_insn *ins;
    int nwords = nbytes / 4;

    for (int i = 0; i < nwords; i++) {
        int sa = src_addr, da = dst_addr, tmp;
        if (i > 0) {
            int off = lower_const(i * 4);
            sa = emit_addp(src_addr, off);
            da = emit_addp(dst_addr, off);
        }
        tmp = new_temp();
        ins = emit(IR_LW);
        ins->dst = tmp;
        ins->a = sa;
        ins = emit(IR_SW);
        ins->a = da;
        ins->b = tmp;
    }
}

static void
emit_label(int lab)
{
    struct ir_insn *ins;

    ins = emit(IR_LABEL);
    ins->label = lab;
}

static void
emit_jmp(int lab)
{
    struct ir_insn *ins;

    ins = emit(IR_JMP);
    ins->label = lab;
}

static void
emit_bz(int t, int lab)
{
    struct ir_insn *ins;

    ins = emit(IR_BZ);
    ins->a = t;
    ins->label = lab;
}

static void
emit_bnz(int t, int lab)
{
    struct ir_insn *ins;

    ins = emit(IR_BNZ);
    ins->a = t;
    ins->label = lab;
}

/* Emit the argument instructions for a call: a float argument becomes an
   IR_FARG carrying its width, a pointer or Int64 an IR_ARG64, anything else an
   ordinary IR_ARG. */
static void
emit_args(int *args, int nargs)
{
    struct ir_insn *ins;

    for (int i = 0; i < nargs; i++) {
        if (is_float(args[i])) {
            ins = emit(IR_FARG);
            ins->a = args[i];
            ins->imm = float_fw(args[i]);
        } else if (is_ptr(args[i]) || is_i64(args[i])) {
            ins = emit(IR_ARG64);
            ins->a = args[i];
        } else {
            ins = emit(IR_ARG);
            ins->a = args[i];
        }
    }
}

static void
emit_call(const char *name, int *args, int nargs)
{
    struct ir_insn *ins;

    emit_args(args, nargs);
    ins = emit(IR_CALL);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena,name);
    ins->nargs = nargs;
}

static int
emit_call_ret(const char *name, int *args, int nargs)
{
    struct ir_insn *ins;

    emit_args(args, nargs);
    ins = emit(IR_CALL);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena,name);
    ins->nargs = nargs;
    return ins->dst;
}

/* Like emit_call_ret, but for a callee that returns a 64-bit value.  The
   backends read the result register's width from the opcode, so an Int64 result
   must come back through IR_CALL64, not IR_CALL. */
static int
emit_call_ret64(const char *name, int *args, int nargs)
{
    struct ir_insn *ins;

    emit_args(args, nargs);
    ins = emit(IR_CALL64);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena, name);
    ins->nargs = nargs;
    mark_i64(ins->dst);
    return ins->dst;
}

/* A callee that returns a floating-point value (IR_FCALL); the result is a
   float temp of width fw. */
static int
emit_call_retf(const char *name, int *args, int nargs, int fw)
{
    struct ir_insn *ins;

    emit_args(args, nargs);
    ins = emit(IR_FCALL);
    ins->dst = new_temp();
    ins->sym = arena_strdup(lower_arena, name);
    ins->nargs = nargs;
    ins->imm = fw;
    mark_float(ins->dst, fw);
    return ins->dst;
}

/* A call returning a pointer-width value (a heap string).  The backend reads
   the result register width from the opcode, so this is a 64-bit call on LP64
   and a 32-bit call on ILP32; the result is flagged as a pointer. */
static int
emit_call_retptr(const char *name, int *args, int nargs)
{
    int r = PC_LP64_ON ? emit_call_ret64(name, args, nargs)
                       : emit_call_ret(name, args, nargs);
    mark_ptr(r);
    return r;
}

/****************************************************************
 * Owned string temporaries
 *
 * A call that allocates a fresh heap string yields an owned reference.  If a
 * store moves that reference into a destination it is adopted (unregistered);
 * otherwise it is an expression temporary whose reference nobody keeps, such
 * as an intermediate concatenation or a string compared in a condition.  Each
 * expression context (an assignment, a call's arguments, a loop condition)
 * brackets its lowering with a mark and a release-to-mark, so every temporary
 * still registered at the end of the context is released there.  A loop
 * condition is lowered inside the loop body, so its release runs each
 * iteration.  Over-releasing is impossible: only temporaries this code
 * allocated are registered, and a move removes them first.
 ****************************************************************/

#define MAX_STR_TEMPS 1024
static int str_temps[MAX_STR_TEMPS];
static int nstr_temps;

static int
str_temp_mark(void)
{
    return nstr_temps;
}

static void
register_str_temp(int t)
{
    if (nstr_temps < MAX_STR_TEMPS)
        str_temps[nstr_temps++] = t;
    /* On overflow the temporary simply leaks; it is never freed wrongly. */
}

static void
unregister_str_temp(int t)
{
    int i;

    for (i = nstr_temps - 1; i >= 0; i--)
        if (str_temps[i] == t) {
            str_temps[i] = str_temps[--nstr_temps];
            return;
        }
}

/* Release and drop every temporary registered since the mark. */
static void
release_str_temps_to(int mark)
{
    while (nstr_temps > mark) {
        int t = str_temps[--nstr_temps];
        emit_call("__pascal_str_release", &t, 1);
    }
}

/* A call that returns a fresh, owned heap string, registered as a temporary. */
static int
emit_str_new_call(const char *name, int *args, int nargs)
{
    int r = emit_call_retptr(name, args, nargs);
    register_str_temp(r);
    return r;
}

/* Load a pointer-width value from a computed address. */
static int
emit_load_ptr_at(int addr)
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_LD64 : IR_LW);
    ins->dst = new_temp();
    ins->a = addr;
    mark_ptr(ins->dst);
    return ins->dst;
}

/* Store a pointer-width value to a computed address. */
static void
emit_store_ptr_at(int addr, int val)
{
    struct ir_insn *ins = emit(PC_LP64_ON ? IR_ST64 : IR_SW);
    ins->a = addr;
    ins->b = val;
}

/* A pointer-width constant NULL (the empty string). */
static int
emit_null_ptr(void)
{
    int z = PC_LP64_ON ? lower_const64(0) : lower_const(0);
    mark_ptr(z);
    return z;
}

/* Create a static strobj descriptor in rodata for a string literal and return
   its global name.  The backend emits the {refcount=static, kind, len, cap}
   header endian-correctly, then the bytes and a trailing NUL. */
static char *
intern_strobj(const char *data, int slen)
{
    char namebuf[32];
    struct ir_global *g;

    if (slen < 0)
        slen = 0;
    g = arena_zalloc(lower_arena, sizeof(*g));
    snprintf(namebuf, sizeof(namebuf), "__str_%d", strctr++);
    g->name = arena_strdup(lower_arena, namebuf);
    g->base_type = IR_I8;
    g->is_local = 1;
    g->is_rodata = 1;
    g->is_strobj = 1;
    g->init_string = arena_alloc(lower_arena, slen ? slen : 1);
    if (slen)
        memcpy(g->init_string, data, slen);
    g->init_strlen = slen;
    g->next = cur_prog->globals;
    cur_prog->globals = g;
    return g->name;
}

/* Materialize a string literal as a static strobj descriptor in rodata and
   return its base address (the string value). */
static int
emit_strobj_literal(const char *data, int slen)
{
    return emit_lea_sym(intern_strobj(data, slen));
}

/****************************************************************
 * Expression lowering
 ****************************************************************/

static int lower_expr(struct node *n);
static void lower_stmt(struct node *n);
static int lower_call(struct node *n);
static int lower_str_addr(struct node *n);
static void emit_string_store(int by_slot, int where, int srcptr, int owned,
                              const char *tname);
static void emit_managed_walk(int addr, const char *name, int op);
static void arr_elem_fns(struct type_def *arr, const char **dtor_out,
                         const char **retain_out);
static void emit_strlike_release(int ptrval, const char *tname);
static int lower_str_concat_operand(struct node *n);
static int node_is_string_valued(struct node *n);

static int
load_sym(struct sym *s)
{
    struct ir_insn *ins;
    int i64 = is_i64_type_name(s->type_name);
    int ffw = float_fw_of_name(s->type_name);

    int is_str = is_strlike_type_name(s->type_name);

    if (s->is_const) {
        if (s->const_str)
            return emit_strobj_literal(s->const_str, s->const_slen);
        return lower_const(s->const_val);
    }
    /* A string value is a pointer; load it, following the var-param and global
       indirections, and flag the result as a pointer. */
    if (is_str) {
        if (s->is_local) {
            if (s->is_var_param)
                return emit_load_ptr_at(emit_load_ptr(s->slot));
            return emit_load_ptr(s->slot);
        }
        return emit_load_ptr_at(emit_lea_sym(s->name));
    }
    if (s->is_local) {
        if (s->is_var_param) {
            int addr = emit_load_ptr(s->slot);
            if (ffw >= 0) {
                ins = emit(IR_FLD);
                ins->dst = new_temp();
                ins->a = addr;
                ins->imm = ffw;
                mark_float(ins->dst, ffw);
                return ins->dst;
            }
            ins = emit(i64 ? IR_LD64 : IR_LW);
            ins->dst = new_temp();
            ins->a = addr;
            if (i64)
                mark_i64(ins->dst);
            return ins->dst;
        }
        if (ffw >= 0) {
            ins = emit(IR_FLDL);
            ins->dst = new_temp();
            ins->slot = s->slot;
            ins->imm = ffw;
            mark_float(ins->dst, ffw);
            return ins->dst;
        }
        ins = emit(i64 ? IR_LDL64 : IR_LDL);
        ins->dst = new_temp();
        ins->slot = s->slot;
        if (i64)
            mark_i64(ins->dst);
        return ins->dst;
    }
    {
        int addr = emit_lea_sym(s->name);
        if (ffw >= 0) {
            ins = emit(IR_FLD);
            ins->dst = new_temp();
            ins->a = addr;
            ins->imm = ffw;
            mark_float(ins->dst, ffw);
            return ins->dst;
        }
        ins = emit(i64 ? IR_LD64 : IR_LW);
        ins->dst = new_temp();
        ins->a = addr;
        if (i64)
            mark_i64(ins->dst);
        return ins->dst;
    }
}

static int
addr_sym(struct sym *s)
{
    struct ir_insn *ins;

    (void)ins;
    if (s->is_local) {
        if (s->is_var_param)
            return emit_load_ptr(s->slot);
        return emit_adl(s->slot);
    }
    return emit_lea_sym(s->name);
}

static void
store_sym(struct sym *s, int val, int str_owned)
{
    struct ir_insn *ins;
    int i64 = is_i64_type_name(s->type_name);
    int ffw = float_fw_of_name(s->type_name);

    /* A string assignment shares the value by reference count: retain a
       borrowed source, move an owned one, and release the previous value.  It
       follows the var-param and global indirections like any pointer slot. */
    if (is_strlike_type_name(s->type_name)) {
        if (s->is_local) {
            if (s->is_var_param)
                emit_string_store(0, emit_load_ptr(s->slot), val, str_owned,
                                  s->type_name);
            else
                emit_string_store(1, s->slot, val, str_owned, s->type_name);
        } else {
            emit_string_store(0, emit_lea_sym(s->name), val, str_owned,
                              s->type_name);
        }
        return;
    }

    /* coerce the value to the destination width */
    if (ffw >= 0)
        val = to_float(val, ffw);
    else
        val = i64 ? to_i64(val) : to_i32(val);

    if (s->is_local) {
        if (s->is_var_param) {
            int addr = emit_load_ptr(s->slot);
            ins = emit(ffw >= 0 ? IR_FSD : i64 ? IR_ST64 : IR_SW);
            ins->a = addr;
            ins->b = val;
            if (ffw >= 0)
                ins->imm = ffw;
        } else {
            ins = emit(ffw >= 0 ? IR_FSTL : i64 ? IR_STL64 : IR_STL);
            ins->a = val;
            ins->slot = s->slot;
            if (ffw >= 0)
                ins->imm = ffw;
        }
    } else {
        int addr = emit_lea_sym(s->name);
        ins = emit(ffw >= 0 ? IR_FSD : i64 ? IR_ST64 : IR_SW);
        ins->a = addr;
        ins->b = val;
        if (ffw >= 0)
            ins->imm = ffw;
    }
}

static const char *
with_field_type_name(const char *name)
{
    for (int i = nwith - 1; i >= 0; i--) {
        struct type_def *td = with_stack[i].td;
        for (int j = 0; j < td->nfields; j++)
            if (strcmp(td->fields[j].name, name) == 0)
                return td->fields[j].type_name;
    }
    return NULL;
}

static int
with_field_addr(const char *name)
{
    for (int i = nwith - 1; i >= 0; i--) {
        struct type_def *td = with_stack[i].td;
        int off = type_field_offset(td, name);
        if (off >= 0) {
            int base = emit_load_ptr(with_stack[i].base_slot);
            if (off > 0)
                return emit_addp(base, lower_const(off));
            return base;
        }
    }
    return -1;
}

static const char *
lvalue_type_name(struct node *n)
{
    if (n->kind == N_NAME) {
        struct sym *s;
        /* the enclosing function's name denotes its result variable; this
           takes priority over the function's own symbol in the table */
        if (cur_func_name && (ret_slot >= 0 || ret_is_compound) &&
            strcmp(n->name, cur_func_name) == 0)
            return ret_type_name;
        s = find_sym(n->name);
        if (s)
            return s->type_name;
        if (nwith > 0)
            return with_field_type_name(n->name);
        return NULL;
    }
    if (n->kind == N_DOT) {
        const char *parent_type = lvalue_type_name(n->a);
        struct type_def *td;
        if (!parent_type)
            return NULL;
        td = find_type(parent_type);
        if (!td)
            return NULL;
        for (int i = 0; i < td->nfields; i++)
            if (strcmp(td->fields[i].name, n->name) == 0)
                return td->fields[i].type_name;
        return NULL;
    }
    if (n->kind == N_INDEX) {
        const char *parent_type = lvalue_type_name(n->a);
        struct type_def *td;
        if (!parent_type)
            return NULL;
        td = find_type(parent_type);
        if (td && td->is_string)
            return "char";
        if (td && td->is_array)
            return td->elem_type_name;
        return NULL;
    }
    return NULL;
}

static int
lower_lvalue_addr(struct node *n)
{
    struct ir_insn *ins;

    if (n->kind == N_NAME) {
        struct sym *s;
        /* the enclosing function's name denotes its result variable; this
           takes priority over the function's own symbol in the table.  A
           compound result lives in the caller, reached through the sret
           pointer; a scalar/string result has a local home slot. */
        if (cur_func_name && strcmp(n->name, cur_func_name) == 0) {
            if (ret_is_compound)
                return emit_load_ptr(ret_ptr_slot);
            if (ret_slot >= 0)
                return emit_adl(ret_slot);
        }
        s = find_sym(n->name);
        if (!s) {
            if (nwith > 0) {
                int addr = with_field_addr(n->name);
                if (addr >= 0)
                    return addr;
            }
            die("lower:%d: undefined '%s'", n->line, n->name);
        }
        return addr_sym(s);
    }
    if (n->kind == N_DOT) {
        int base = lower_lvalue_addr(n->a);
        const char *parent_tname = lvalue_type_name(n->a);
        struct type_def *td;
        int off;

        if (!parent_tname)
            die("lower:%d: not a record type", n->line);
        td = find_type(parent_tname);
        if (!td)
            die("lower:%d: not a record type", n->line);
        off = type_field_offset(td, n->name);
        if (off < 0)
            die("lower:%d: unknown field '%s'",
                n->line, n->name);
        if (off > 0)
            return emit_addp(base, lower_const(off));
        return base;
    }
    if (n->kind == N_INDEX) {
        const char *parent_tname = lvalue_type_name(n->a);
        struct type_def *td;
        int base, idx;

        if (!parent_tname)
            die("lower:%d: not an array type", n->line);
        td = find_type(parent_tname);
        if (!td)
            die("lower:%d: not an array type", n->line);
        if (td->is_string) {
            /* s[i]: character i (1-based) lives at the descriptor base plus
               PSTR_HDR + (i-1).  The base is the string pointer value.  Both
               operands are materialized before the add is emitted. */
            int sp = lower_str_addr(n->a);
            int off, k;
            idx = to_i32(lower_expr(n->b));
            k = lower_const(PSTR_HDR - 1);
            ins = emit(IR_ADD);
            ins->dst = new_temp();
            ins->a = idx;
            ins->b = k;
            off = ins->dst;
            return emit_addp(sp, off);
        }
        if (td->is_dynarray) {
            /* a[i]: element i (0-based) lives at the descriptor base plus
               PSTR_HDR + i*elem_size.  The base is the descriptor pointer. */
            int bptr = lower_expr(n->a);
            int off, hdr, scaled;
            idx = to_i32(lower_expr(n->b));
            if (td->elem_size != 1) {
                int esz = lower_const(td->elem_size);
                ins = emit(IR_MUL);
                ins->dst = new_temp();
                ins->a = idx;
                ins->b = esz;
                scaled = ins->dst;
            } else {
                scaled = idx;
            }
            hdr = lower_const(PSTR_HDR);
            ins = emit(IR_ADD);
            ins->dst = new_temp();
            ins->a = scaled;
            ins->b = hdr;
            off = ins->dst;
            return emit_addp(bptr, off);
        }
        base = lower_lvalue_addr(n->a);
        if (!td->is_array)
            die("lower:%d: not an array type", n->line);
        idx = to_i32(lower_expr(n->b));
        if (n->op) {
            int lo = lower_const(td->lo_bound);
            int hi = lower_const(td->hi_bound);
            int cmp, labort, lok, abort_args[1];
            labort = new_label();
            lok = new_label();
            cmp = new_temp();
            ins = emit(IR_CMPLTS);
            ins->dst = cmp;
            ins->a = idx;
            ins->b = lo;
            emit_bnz(cmp, labort);
            cmp = new_temp();
            ins = emit(IR_CMPGTS);
            ins->dst = cmp;
            ins->a = idx;
            ins->b = hi;
            emit_bnz(cmp, labort);
            emit_jmp(lok);
            emit_label(labort);
            abort_args[0] = lower_const(134);
            emit_call("exit", abort_args, 1);
            emit_label(lok);
        }
        if (td->lo_bound != 0) {
            int lo = lower_const(td->lo_bound);
            ins = emit(IR_SUB);
            ins->dst = new_temp();
            ins->a = idx;
            ins->b = lo;
            idx = ins->dst;
        }
        if (td->elem_size != 1) {
            int esz = lower_const(td->elem_size);
            ins = emit(IR_MUL);
            ins->dst = new_temp();
            ins->a = idx;
            ins->b = esz;
            idx = ins->dst;
        }
        return emit_addp(base, idx);
    }
    die("lower:%d: invalid l-value", n->line);
    return 0;
}

/****************************************************************
 * Compile-time constant evaluation
 ****************************************************************/

static long
const_eval(struct node *n)
{
    long l, r;

    if (!n)
        die("lower: null in const expression");

    switch (n->kind) {
    case N_NUM:
    case N_BOOL:
        return n->ival;
    case N_STR:
        if (n->slen == 1)
            return (unsigned char)n->sval[0];
        die("lower:%d: string in const expression", n->line);
        return 0;
    case N_NAME: {
        struct sym *s = find_sym(n->name);
        if (!s || !s->is_const)
            die("lower:%d: '%s' is not a constant",
                n->line, n->name);
        return s->const_val;
    }
    case N_UNOP:
        l = const_eval(n->a);
        if (n->op == T_MINUS)
            return -l;
        if (n->op == T_NOT) {
            if (n->a->kind == N_BOOL)
                return l ? 0 : 1;
            return ~l;
        }
        die("lower:%d: bad unary op in const expr", n->line);
        return 0;
    case N_BINOP:
        l = const_eval(n->a);
        r = const_eval(n->b);
        switch (n->op) {
        case T_PLUS:  return l + r;
        case T_MINUS: return l - r;
        case T_STAR:  return l * r;
        case T_DIV:   return r ? l / r : 0;
        case T_MOD:   return r ? l % r : 0;
        case T_AND:   return l & r;
        case T_OR:    return l | r;
        case T_SHL:   return l << r;
        case T_SHR:   return (unsigned long)l >> r;
        case T_EQ:    return l == r ? 1 : 0;
        case T_NE:    return l != r ? 1 : 0;
        case T_LT:    return l < r ? 1 : 0;
        case T_LE:    return l <= r ? 1 : 0;
        case T_GT:    return l > r ? 1 : 0;
        case T_GE:    return l >= r ? 1 : 0;
        default:
            die("lower:%d: bad binary op in const expr", n->line);
        }
        return 0;
    case N_CALL: {
        const char *fn;
        long a;
        if (n->a->kind != N_NAME)
            die("lower:%d: bad call in const expr", n->line);
        fn = n->a->name;
        if (!n->b)
            die("lower:%d: %s requires argument", n->line, fn);
        a = const_eval(n->b);
        if (strcmp(fn, "ord") == 0)
            return a;
        if (strcmp(fn, "int64") == 0 || strcmp(fn, "qword") == 0 ||
            strcmp(fn, "integer") == 0 || strcmp(fn, "longint") == 0 ||
            strcmp(fn, "uint64") == 0 || strcmp(fn, "cardinal") == 0)
            return a;
        if (strcmp(fn, "abs") == 0)
            return a < 0 ? -a : a;
        if (strcmp(fn, "sqr") == 0)
            return a * a;
        if (strcmp(fn, "odd") == 0)
            return a & 1;
        if (strcmp(fn, "succ") == 0)
            return a + 1;
        if (strcmp(fn, "pred") == 0)
            return a - 1;
        if (strcmp(fn, "lo") == 0)
            return a & 0xFF;
        if (strcmp(fn, "hi") == 0)
            return (a >> 8) & 0xFF;
        die("lower:%d: unknown function '%s' in const expr",
            n->line, fn);
        return 0;
    }
    case N_SIZEOF: {
        struct type_def *td = find_type(n->name);
        if (!td)
            die("lower:%d: unknown type '%s' in sizeof",
                n->line, n->name);
        return td->total_size;
    }
    default:
        die("lower:%d: not a constant expression", n->line);
    }
    return 0;
}

static int
count_init_list(struct node *n)
{
    int cnt = 0;

    if (n->kind != N_INITLIST)
        return 1;
    for (struct node *e = n->a; e; e = e->next)
        cnt += count_init_list(e);
    return cnt;
}

static void
flatten_init_list(struct node *n, long *iv, int *pos)
{
    if (n->kind != N_INITLIST) {
        iv[(*pos)++] = const_eval(n);
        return;
    }
    for (struct node *e = n->a; e; e = e->next)
        flatten_init_list(e, iv, pos);
}

/* Build the aggregate byte image (an ir_init list) for a typed constant whose
   type contains managed string members, where const_eval cannot fold the whole
   thing to integers.  A string leaf becomes a pointer to a static strobj (NULL
   for the empty string); an array walks elements at base + i*elem_size; a
   record walks fields (the initializer lists values in declared field order);
   any other scalar leaf is a sized constant.  base is the leaf's byte offset in
   the image. */
static void
build_const_image(struct node *init, const char *tname, int base,
                  struct ir_init ***tailp, int line)
{
    struct type_def *t = resolve_type(tname);
    struct ir_init *pc;

    if (is_string_type_name(tname)) {
        pc = arena_zalloc(lower_arena, sizeof(*pc));
        pc->offset = base;
        pc->size = PC_PTR_BYTES;
        if (init && init->kind == N_STR && init->slen > 0)
            pc->sym = intern_strobj(init->sval, init->slen);
        else
            pc->ival = 0;       /* '' is the empty (NULL) string */
        **tailp = pc;
        *tailp = &pc->next;
        return;
    }
    if (t && t->is_array && !t->is_dynarray) {
        int i = 0;
        struct node *e;
        if (!init || init->kind != N_INITLIST)
            die("lower:%d: array constant needs an initializer list", line);
        for (e = init->a; e; e = e->next, i++)
            build_const_image(e, t->elem_type_name,
                              base + i * t->elem_size, tailp, line);
        return;
    }
    if (t && t->nfields > 0) {
        int fi = 0;
        struct node *e;
        if (!init || init->kind != N_INITLIST)
            die("lower:%d: record constant needs an initializer list", line);
        for (e = init->a; e && fi < t->nfields; e = e->next, fi++)
            build_const_image(e, t->fields[fi].type_name,
                              base + t->fields[fi].offset, tailp, line);
        return;
    }
    /* a scalar leaf */
    pc = arena_zalloc(lower_arena, sizeof(*pc));
    pc->offset = base;
    pc->size = t ? t->total_size : type_bytes(tname);
    if (pc->size != 1 && pc->size != 2 && pc->size != 8)
        pc->size = 4;
    pc->ival = const_eval(init);
    **tailp = pc;
    *tailp = &pc->next;
}

/****************************************************************
 * IR emission helpers
 ****************************************************************/

static int
bin_op_for_tok(int op)
{
    switch (op) {
    case T_PLUS:  return IR_ADD;
    case T_MINUS: return IR_SUB;
    case T_STAR:  return IR_MUL;
    case T_DIV:   return IR_DIVS;
    case T_MOD:   return IR_MODS;
    case T_AND:   return IR_AND;
    case T_OR:    return IR_OR;
    case T_SHL:   return IR_SHL;
    case T_SHR:   return IR_SHRS;
    case T_EQ:    return IR_CMPEQ;
    case T_NE:    return IR_CMPNE;
    case T_LT:    return IR_CMPLTS;
    case T_LE:    return IR_CMPLES;
    case T_GT:    return IR_CMPGTS;
    case T_GE:    return IR_CMPGES;
    default:      return -1;
    }
}

/* The 64-bit opcode for a token.  Arithmetic and bitwise ops produce a 64-bit
   result; comparisons produce a 32-bit boolean. */
static int
bin_op_for_tok64(int op)
{
    switch (op) {
    case T_PLUS:  return IR_ADD64;
    case T_MINUS: return IR_SUB64;
    case T_STAR:  return IR_MUL64;
    case T_DIV:   return IR_DIVS64;
    case T_MOD:   return IR_MODS64;
    case T_AND:   return IR_AND64;
    case T_OR:    return IR_OR64;
    case T_SHL:   return IR_SHL64;
    case T_SHR:   return IR_SHRS64;
    case T_EQ:    return IR_CMP64EQ;
    case T_NE:    return IR_CMP64NE;
    case T_LT:    return IR_CMP64LTS;
    case T_LE:    return IR_CMP64LES;
    case T_GT:    return IR_CMP64GTS;
    case T_GE:    return IR_CMP64GES;
    default:      return -1;
    }
}

/* Does a 64-bit binary op produce a 64-bit result (vs a boolean)?  The six
   comparison tokens form the final contiguous block; everything else we lower
   as a 64-bit op is value-producing. */
static int
op64_is_value(int op)
{
    return !(op >= T_EQ && op <= T_GE);
}

/* The string pointer value (descriptor base) of a string-valued expression.
   A literal becomes a static strobj; every other form (a variable, field,
   element, call or concatenation) yields its pointer through lower_expr. */
static int
lower_str_addr(struct node *n)
{
    if (n->kind == N_STR)
        return emit_strobj_literal(n->sval, n->slen);
    return lower_expr(n);
}

/* Whether lowering n yields a fresh, owned heap string that a store may move
   without retaining.  Sound in the owned direction only: anything not plainly
   fresh is reported borrowed, so the store retains it.  Over-retaining leaks,
   but under-retaining would free a shared value too early, so borrowed is the
   safe default. */
static int
str_rvalue_owned(struct node *n)
{
    if (!n)
        return 0;
    switch (n->kind) {
    case N_STR:
        return 1;   /* a static literal; retain and release are no-ops */
    case N_BINOP:
        /* a string-valued '+' is concatenation, a fresh allocation */
        return n->op == T_PLUS;
    default:
        return 0;   /* variable, field, element, call result: borrowed */
    }
}

/* Install a string pointer into a slot or an address, transferring reference
   counts: retain a borrowed source before releasing the old value (so a self
   assignment x := x stays alive), move an owned source as is.  by_slot picks
   slot-relative (LDL/STL) over address (LD/ST) access. */
static void
emit_string_store(int by_slot, int where, int srcptr, int owned,
                  const char *tname)
{
    int old, newv;

    old = by_slot ? emit_load_ptr(where) : emit_load_ptr_at(where);
    if (owned) {
        /* adopt the source's reference; it is no longer a loose temporary */
        unregister_str_temp(srcptr);
        newv = srcptr;
    } else {
        newv = emit_call_retptr("__pascal_str_retain", &srcptr, 1);
    }
    emit_strlike_release(old, tname);
    if (by_slot)
        emit_store_ptr(where, newv);
    else
        emit_store_ptr_at(where, newv);
}

/* Resolve a string l-value to a destination for emit_string_store: a slot
   (by_slot = 1) for a plain local, otherwise an address temp (var parameter,
   global, record field or array element).  The address is computed once. */
static int
string_lhs_dest(struct node *lhs, int *by_slot)
{
    if (lhs->kind == N_NAME) {
        struct sym *s;
        /* the enclosing function's name denotes its (string) result slot */
        if (cur_func_name && ret_slot >= 0 && ret_is_str &&
            strcmp(lhs->name, cur_func_name) == 0) {
            *by_slot = 1;
            return ret_slot;
        }
        s = find_sym(lhs->name);
        if (!s)
            die("lower:%d: undefined '%s'", lhs->line, lhs->name);
        if (s->is_local) {
            if (s->is_var_param) {
                *by_slot = 0;
                return emit_load_ptr(s->slot);
            }
            *by_slot = 1;
            return s->slot;
        }
        *by_slot = 0;
        return emit_lea_sym(s->name);
    }
    *by_slot = 0;
    return lower_lvalue_addr(lhs);
}

/* Store a string value into a destination l-value (a variable, field or
   element).  owned says the source is a fresh value to move; otherwise it is
   retained.  The previous value of the destination is released. */
static void
store_string_lvalue(struct node *lhs, int srcptr, int owned)
{
    int by_slot, where = string_lhs_dest(lhs, &by_slot);
    emit_string_store(by_slot, where, srcptr, owned, lvalue_type_name(lhs));
}

/* Whether two l-value expressions denote the same location, cheaply and
   conservatively: the same variable, the same field of the same base, or the
   same element of the same base under a constant or plain-variable index (an
   index with no re-evaluation hazard).  Used to recognize x := x + e. */
static int
same_lvalue(struct node *a, struct node *b)
{
    if (!a || !b || a->kind != b->kind)
        return 0;
    switch (a->kind) {
    case N_NAME:
        return strcmp(a->name, b->name) == 0;
    case N_DOT:
        return strcmp(a->name, b->name) == 0 && same_lvalue(a->a, b->a);
    case N_INDEX:
        if (!same_lvalue(a->a, b->a))
            return 0;
        if (a->b && b->b && a->b->kind == b->b->kind) {
            if (a->b->kind == N_NUM)
                return a->b->ival == b->b->ival;
            if (a->b->kind == N_NAME)
                return strcmp(a->b->name, b->b->name) == 0;
        }
        return 0;
    default:
        return 0;
    }
}

/* Lower x := x + e in place.  __pascal_str_append appends e into x's buffer
   when x is uniquely owned with spare capacity, otherwise builds a fresh
   (over-allocated) string; either way it consumes x's old reference and
   returns an owned result stored straight back, so no separate retain or
   release is emitted.  e is only read, so an owned e temporary is released at
   statement end by the registry as usual. */
static void
lower_self_append(struct node *lhs, struct node *e)
{
    int by_slot, where, xval, eptr, res, args[2];

    where = string_lhs_dest(lhs, &by_slot);
    xval = by_slot ? emit_load_ptr(where) : emit_load_ptr_at(where);
    eptr = lower_str_concat_operand(e);
    args[0] = xval;
    args[1] = eptr;
    res = emit_call_retptr("__pascal_str_append", args, 2);
    if (by_slot)
        emit_store_ptr(where, res);
    else
        emit_store_ptr_at(where, res);
}

/* Copy on write for an in-place character mutation (s[i] := c): ensure the
   string l-value owns a private, writable buffer before its bytes are
   addressed.  __pascal_str_unique returns the value unchanged when it is
   already uniquely owned, or a fresh copy (dropping the shared reference)
   when it is shared or a static literal.  The result is moved back into the
   slot, so no retain or release is emitted here. */
static void
make_string_unique(struct node *lhs)
{
    int cur, uniq;

    if (lhs->kind == N_NAME) {
        struct sym *s = find_sym(lhs->name);
        if (!s)
            die("lower:%d: undefined '%s'", lhs->line, lhs->name);
        if (s->is_local && !s->is_var_param) {
            cur = emit_load_ptr(s->slot);
            uniq = emit_call_retptr("__pascal_str_unique", &cur, 1);
            emit_store_ptr(s->slot, uniq);
        } else {
            int addr = s->is_local ? emit_load_ptr(s->slot)
                                   : emit_lea_sym(s->name);
            cur = emit_load_ptr_at(addr);
            uniq = emit_call_retptr("__pascal_str_unique", &cur, 1);
            emit_store_ptr_at(addr, uniq);
        }
    } else {
        int addr = lower_lvalue_addr(lhs);
        cur = emit_load_ptr_at(addr);
        uniq = emit_call_retptr("__pascal_str_unique", &cur, 1);
        emit_store_ptr_at(addr, uniq);
    }
}

/* Operation applied to each managed string leaf by emit_managed_walk. */
#define MGD_RELEASE 0
#define MGD_RETAIN  1
#define MGD_NULL    2   /* store NULL (the empty string); for entry init */

/* Apply `op` to every managed string inside a value of type `name` at address
   `addr`, walking record fields and array elements at compile time.  A plain
   string is the leaf.  Branches with no managed member emit nothing. */
static void
emit_managed_walk(int addr, const char *name, int op)
{
    struct type_def *t;
    int i;

    if (!name)
        return;
    if (is_strlike_type_name(name)) {
        if (op == MGD_NULL) {
            emit_store_ptr_at(addr, emit_null_ptr());
        } else if (op == MGD_RETAIN) {
            /* retaining the descriptor shares the whole value (and with it its
               elements), so a plain retain is right for an array too. */
            int p = emit_load_ptr_at(addr);
            emit_call("__pascal_str_retain", &p, 1);
        } else {
            /* release drops the descriptor's reference and, for an array of
               managed elements, finalizes those elements at the last reference */
            emit_strlike_release(emit_load_ptr_at(addr), name);
        }
        return;
    }
    t = find_type(name);
    if (!t)
        return;
    if (t->alias_of) {
        emit_managed_walk(addr, t->alias_of, op);
        return;
    }
    if (t->is_array) {
        int n = t->hi_bound - t->lo_bound + 1;
        if (!type_has_managed(t->elem_type_name))
            return;
        for (i = 0; i < n; i++) {
            int off = lower_const(i * t->elem_size);
            emit_managed_walk(emit_addp(addr, off), t->elem_type_name, op);
        }
        return;
    }
    for (i = 0; i < t->nfields; i++) {
        int off;
        if (!type_has_managed(t->fields[i].type_name))
            continue;
        off = lower_const(t->fields[i].offset);
        emit_managed_walk(emit_addp(addr, off), t->fields[i].type_name, op);
    }
}

/* Copy an aggregate value with reference-count maintenance: retain the
   source's managed members, release the destination's previous ones, then
   copy the bytes.  Retaining before releasing keeps a self-assignment safe.
   An aggregate with no managed member is a plain block copy. */
static void
emit_aggregate_copy(int dst, int src, const char *name, int size)
{
    if (type_has_managed(name)) {
        emit_managed_walk(src, name, MGD_RETAIN);
        emit_managed_walk(dst, name, MGD_RELEASE);
    }
    emit_block_copy(dst, src, size);
}

/* Move an aggregate rvalue (a function's sret result) into a destination:
   release the destination's previous managed members, then copy the bytes.
   The source is a temporary that gives up ownership, so its members are not
   retained and it is not released. */
static void
emit_aggregate_move(int dst, int src, const char *name, int size)
{
    if (type_has_managed(name))
        emit_managed_walk(dst, name, MGD_RELEASE);
    emit_block_copy(dst, src, size);
}

/* Resolve a type name through its alias chain to the underlying type_def. */
static struct type_def *
resolve_type(const char *name)
{
    struct type_def *t = name ? find_type(name) : NULL;

    while (t && t->alias_of)
        t = find_type(t->alias_of);
    return t;
}

/* Build a one-argument function that applies `op` (MGD_RELEASE/MGD_RETAIN) to a
   single element of type `elem_type` at the address passed in.  Used as the
   per-element callback for a dynamic array of record elements.  The lowering
   slot and per-temp flag state is swapped out so generating a function in the
   middle of another function's body cannot disturb it. */
static struct ir_func *
gen_managed_elem_fn(const char *fnname, const char *elem_type, int op)
{
    struct ir_func *fn, *saved_fn = cur_fn;
    int *saved_slot_sizes = slot_sizes;
    int saved_nslots = nslots, saved_slot_cap = slot_cap;
    unsigned char *saved_is_ptr = temp_is_ptr, *saved_is_i64 = temp_is_i64;
    unsigned char *saved_fkind = temp_fkind;
    int saved_is_ptr_cap = temp_is_ptr_cap, saved_is_i64_cap = temp_is_i64_cap;
    int saved_fkind_cap = temp_fkind_cap;
    int saved_nloops = nloops, saved_nwith = nwith;
    int saved_ret_slot = ret_slot, saved_exit = exit_label;
    const char *saved_func_name = cur_func_name;
    struct ir_insn *ins;
    int pslot, addr;

    slot_sizes = NULL;
    nslots = slot_cap = 0;
    temp_is_ptr = temp_is_i64 = temp_fkind = NULL;
    temp_is_ptr_cap = temp_is_i64_cap = temp_fkind_cap = 0;
    nloops = nwith = 0;
    ret_slot = -1;
    cur_func_name = NULL;

    fn = ir_new_func(lower_arena, fnname);
    cur_fn = fn;
    exit_label = new_label();

    pslot = alloc_slot(PC_PTR_BYTES);   /* the one pointer parameter */
    fn->nparams = 1;

    ins = emit(IR_FUNC);
    ins->sym = arena_strdup(lower_arena, fnname);
    ins->nargs = 1;

    addr = emit_load_ptr(pslot);        /* the element's address */
    emit_managed_walk(addr, elem_type, op);

    emit(IR_RET);
    emit(IR_ENDF);

    fn->nslots = nslots;
    fn->slot_size = arena_alloc(lower_arena, nslots * sizeof(int));
    if (nslots)
        memcpy(fn->slot_size, slot_sizes, nslots * sizeof(int));

    free(slot_sizes);
    free(temp_is_ptr);
    free(temp_is_i64);
    free(temp_fkind);
    slot_sizes = saved_slot_sizes;
    nslots = saved_nslots;
    slot_cap = saved_slot_cap;
    temp_is_ptr = saved_is_ptr;
    temp_is_i64 = saved_is_i64;
    temp_fkind = saved_fkind;
    temp_is_ptr_cap = saved_is_ptr_cap;
    temp_is_i64_cap = saved_is_i64_cap;
    temp_fkind_cap = saved_fkind_cap;
    nloops = saved_nloops;
    nwith = saved_nwith;
    ret_slot = saved_ret_slot;
    exit_label = saved_exit;
    cur_func_name = saved_func_name;
    cur_fn = saved_fn;
    return fn;
}

/* The per-element finalize ('dtor') and retain function symbols for a dynamic
   array of managed elements.  An element that is a single managed pointer (a
   string, or a dynamic array whose own elements are unmanaged) uses the fixed
   runtime callbacks; any other managed element type gets a generated pair,
   memoized so each type is emitted once and self-reference terminates. */
static void
arr_elem_fns(struct type_def *arr, const char **dtor_out, const char **retain_out)
{
    const char *et = arr->elem_type_name;
    struct type_def *e = resolve_type(et);
    int k;

    if (is_string_type_name(et) ||
        (e && e->is_dynarray && !type_has_managed(e->elem_type_name))) {
        *dtor_out = "__pascal_elem_release_ptr";
        *retain_out = "__pascal_elem_retain_ptr";
        return;
    }
    for (k = 0; k < nelem_fns; k++)
        if (strcmp(elem_fns[k].type_name, et) == 0) {
            *dtor_out = elem_fns[k].dtor;
            *retain_out = elem_fns[k].retain;
            return;
        }
    if (nelem_fns >= (int)(sizeof(elem_fns) / sizeof(elem_fns[0])))
        die("lower: too many managed array element types");
    k = nelem_fns++;
    elem_fns[k].type_name = arena_strdup(lower_arena, et);
    snprintf(elem_fns[k].dtor, sizeof(elem_fns[k].dtor), "__pdtor_%s", et);
    snprintf(elem_fns[k].retain, sizeof(elem_fns[k].retain), "__pretain_%s", et);
    *dtor_out = elem_fns[k].dtor;
    *retain_out = elem_fns[k].retain;
    /* Reserve the entry before generating so a recursive element type resolves
       to these names rather than recursing forever. */
    {
        struct ir_func *df = gen_managed_elem_fn(elem_fns[k].dtor, et, MGD_RELEASE);
        struct ir_func *rf = gen_managed_elem_fn(elem_fns[k].retain, et, MGD_RETAIN);
        *gen_ftail = df;
        gen_ftail = &df->next;
        *gen_ftail = rf;
        gen_ftail = &rf->next;
    }
}

/* Release one strlike value (already loaded) by its type name: a dynamic array
   of managed elements goes through the element-aware runtime release with its
   finalizer; a string or scalar array is a plain descriptor release. */
static void
emit_strlike_release(int ptrval, const char *tname)
{
    struct type_def *t = resolve_type(tname);

    if (t && t->is_dynarray && type_has_managed(t->elem_type_name)) {
        const char *dtor, *retain;
        int args[3];
        arr_elem_fns(t, &dtor, &retain);
        args[0] = ptrval;
        args[1] = lower_const(t->elem_size);
        args[2] = emit_lea_sym(dtor);
        emit_call("__pascal_arr_release", args, 3);
    } else {
        emit_call("__pascal_str_release", &ptrval, 1);
    }
}

/* Whether an expression yields a boolean value.  FPC's default ({$B-}) makes
   boolean `and`/`or` short-circuit, so the lowering needs to recognize boolean
   operands to pick the short-circuit form over the bitwise one. */
static int
expr_is_boolean(struct node *n)
{
    const char *tn;

    if (!n)
        return 0;
    if (n->kind == N_BOOL)
        return 1;
    if (n->kind == N_UNOP && n->op == T_NOT)
        return 1;
    /* boolean-valued builtins: eof (bare or called) and odd(x) */
    if (n->kind == N_NAME && strcmp(n->name, "eof") == 0 &&
        !find_sym(n->name))
        return 1;
    if (n->kind == N_CALL && n->a && n->a->kind == N_NAME &&
        (strcmp(n->a->name, "eof") == 0 || strcmp(n->a->name, "odd") == 0))
        return 1;
    if (n->kind == N_BINOP) {
        if (n->op == T_AND || n->op == T_OR ||
            n->op == T_AND_THEN || n->op == T_OR_ELSE ||
            n->op == T_IN ||
            (n->op >= T_EQ && n->op <= T_GE))
            return 1;
        return 0;
    }
    if (n->kind == N_NAME || n->kind == N_DOT || n->kind == N_INDEX) {
        tn = lvalue_type_name(n);
        if (tn && strcmp(tn, "boolean") == 0)
            return 1;
    }
    if (n->kind == N_NAME) {
        struct sym *s = find_sym(n->name);
        if (s && s->is_func && s->decl &&
            s->decl->kind == N_FUNCDECL && s->decl->sval &&
            strcmp(s->decl->sval, "boolean") == 0)
            return 1;
    }
    if (n->kind == N_CALL && n->a && n->a->kind == N_NAME) {
        struct sym *s = find_sym(n->a->name);
        if (s && s->is_func && s->decl &&
            s->decl->kind == N_FUNCDECL && s->decl->sval &&
            strcmp(s->decl->sval, "boolean") == 0)
            return 1;
    }
    return 0;
}

/* Lower a short-circuit boolean `and`/`or`: evaluate the right operand only
   when the left does not already settle the result.  `is_and` picks `and`
   (false short-circuits) from `or` (true short-circuits). */
static int
lower_short_circuit(struct node *n, int is_and)
{
    struct ir_insn *ins;
    int result_slot, lshort, lend, res, l, r, cshort;

    result_slot = alloc_slot(4);
    l = lower_expr(n->a);
    lshort = new_label();
    lend = new_label();
    if (is_and)
        emit_bz(l, lshort);     /* left false: result is false */
    else
        emit_bnz(l, lshort);    /* left true: result is true */
    r = lower_expr(n->b);
    ins = emit(IR_STL);
    ins->a = r;
    ins->slot = result_slot;
    emit_jmp(lend);
    emit_label(lshort);
    cshort = lower_const(is_and ? 0 : 1);
    ins = emit(IR_STL);
    ins->a = cshort;
    ins->slot = result_slot;
    emit_label(lend);
    res = new_temp();
    ins = emit(IR_LDL);
    ins->dst = res;
    ins->slot = result_slot;
    return res;
}

static int
lower_expr(struct node *n)
{
    struct ir_insn *ins;
    int l, r, op;

    if (!n)
        die("lower: null expression");

    switch (n->kind) {
    case N_NUM:
        /* A literal outside the signed 32-bit range is a 64-bit constant. */
        if (n->ival < -2147483647L - 1 || n->ival > 2147483647L)
            return lower_const64(n->ival);
        return lower_const(n->ival);

    case N_REAL:
        return lower_real_const(n->fval, 0);

    case N_BOOL:
        return lower_const(n->ival);

    case N_STR:
        /* A one-character literal is a char constant in an arbitrary
           expression; a longer literal is a string value (a strobj pointer).
           String context forces even a one-char literal to a string through
           lower_str_addr. */
        if (n->slen == 1)
            return lower_const((unsigned char)n->sval[0]);
        return emit_strobj_literal(n->sval, n->slen);

    case N_NAME: {
        struct sym *s;
        if (strcmp(n->name, "eof") == 0)
            return emit_call_ret("__pascal_eof", NULL, 0);
        if (strcmp(n->name, "paramcount") == 0 && !find_sym(n->name))
            return emit_call_ret("__pascal_param_count", NULL, 0);
        /* nil is the null pointer: an empty string/dynamic array handle and the
           null value compared against pointers */
        if (strcmp(n->name, "nil") == 0 && !find_sym(n->name))
            return emit_null_ptr();
        /* The enclosing function's own name used as an r-value reads its
           result variable, it is not a recursive call.  This takes priority
           over the function's symbol in the table. */
        if (cur_func_name && strcmp(n->name, cur_func_name) == 0 &&
            (ret_slot >= 0 || ret_is_compound)) {
            if (ret_is_compound)
                return emit_load_ptr(ret_ptr_slot);
            if (ret_is_float) {
                ins = emit(IR_FLDL);
                ins->dst = new_temp();
                ins->slot = ret_slot;
                ins->imm = ret_fw;
                mark_float(ins->dst, ret_fw);
                return ins->dst;
            }
            if (ret_is_str)
                return emit_load_ptr(ret_slot);
            ins = emit(ret_is_i64 ? IR_LDL64 : IR_LDL);
            ins->dst = new_temp();
            ins->slot = ret_slot;
            if (ret_is_i64)
                mark_i64(ins->dst);
            return ins->dst;
        }
        s = find_sym(n->name);
        if (!s) {
            if (nwith > 0) {
                int addr = with_field_addr(n->name);
                if (addr >= 0) {
                    ins = emit(IR_LW);
                    ins->dst = new_temp();
                    ins->a = addr;
                    return ins->dst;
                }
            }
            die("lower:%d: undefined '%s'", n->line, n->name);
        }
        if (s->is_func) {
            if (s->decl && s->decl->kind == N_FUNCDECL) {
                int rfw = float_fw_of_name(s->decl->sval);
                if (rfw >= 0)
                    return emit_call_retf(n->name, NULL, 0, rfw);
                if (is_i64_type_name(s->decl->sval))
                    return emit_call_ret64(n->name, NULL, 0);
                if (is_strlike_type_name(s->decl->sval))
                    return emit_str_new_call(n->name, NULL, 0);
            }
            return emit_call_ret(n->name, NULL, 0);
        }
        return load_sym(s);
    }

    case N_DOT:
    case N_INDEX: {
        const char *etname = lvalue_type_name(n);
        const char *ptname;
        struct type_def *ptd;
        int addr, efw;
        /* A string-typed field or element holds a pointer; load it. */
        if (is_strlike_type_name(etname))
            return emit_load_ptr_at(lower_lvalue_addr(n));
        addr = lower_lvalue_addr(n);
        ptname = lvalue_type_name(n->a);
        ptd = ptname ? find_type(ptname) : NULL;
        efw = float_fw_of_name(etname);
        if (ptd && ptd->is_string)
            ins = emit(IR_LB);
        else if (efw >= 0)
            ins = emit(IR_FLD);
        else if (is_i64_type_name(etname))
            ins = emit(IR_LD64);
        else
            ins = emit(IR_LW);
        ins->dst = new_temp();
        ins->a = addr;
        if (ins->op == IR_LD64)
            mark_i64(ins->dst);
        else if (ins->op == IR_FLD) {
            ins->imm = efw;
            mark_float(ins->dst, efw);
        }
        return ins->dst;
    }

    case N_UNOP:
        if (n->op == T_MINUS) {
            l = lower_expr(n->a);
            if (is_float(l)) {
                int w = float_fw(l);
                ins = emit(IR_FNEG);
                ins->dst = new_temp();
                ins->a = l;
                ins->imm = w;
                mark_float(ins->dst, w);
                return ins->dst;
            }
            if (is_i64(l)) {
                ins = emit(IR_NEG64);
                ins->dst = new_temp();
                ins->a = l;
                mark_i64(ins->dst);
                return ins->dst;
            }
            ins = emit(IR_NEG);
            ins->dst = new_temp();
            ins->a = l;
            return ins->dst;
        }
        if (n->op == T_NOT) {
            int zero, is_bool;
            /* `not` is a bitwise complement on an integer and a logical
               negation only on a boolean.  Classify the operand before
               lowering it (expr_is_boolean inspects the node, not the
               lowered value). */
            is_bool = expr_is_boolean(n->a);
            l = lower_expr(n->a);
            if (is_i64(l)) {
                /* compute the mask into a local before emitting the XOR, so
                   its defining instruction precedes the use */
                int neg1 = lower_const64(-1);
                ins = emit(IR_XOR64);
                ins->dst = new_temp();
                ins->a = l;
                ins->b = neg1;
                mark_i64(ins->dst);
                return ins->dst;
            }
            if (!is_bool) {
                /* bitwise complement of a 32-bit integer */
                int neg1 = lower_const(-1);
                ins = emit(IR_XOR);
                ins->dst = new_temp();
                ins->a = l;
                ins->b = neg1;
                return ins->dst;
            }
            zero = lower_const(0);
            ins = emit(IR_CMPEQ);
            ins->dst = new_temp();
            ins->a = l;
            ins->b = zero;
            return ins->dst;
        }
        die("lower:%d: bad unary op", n->line);
        return 0;

    case N_BINOP:
        if (n->op == T_AND_THEN) {
            int result_slot, lfalse, lend, res, c0;
            result_slot = alloc_slot(4);
            l = lower_expr(n->a);
            lfalse = new_label();
            lend = new_label();
            emit_bz(l, lfalse);
            r = lower_expr(n->b);
            ins = emit(IR_STL);
            ins->a = r;
            ins->slot = result_slot;
            emit_jmp(lend);
            emit_label(lfalse);
            c0 = lower_const(0);
            ins = emit(IR_STL);
            ins->a = c0;
            ins->slot = result_slot;
            emit_label(lend);
            res = new_temp();
            ins = emit(IR_LDL);
            ins->dst = res;
            ins->slot = result_slot;
            return res;
        }
        if (n->op == T_OR_ELSE) {
            int result_slot, ltrue, lend, res, c1;
            result_slot = alloc_slot(4);
            l = lower_expr(n->a);
            ltrue = new_label();
            lend = new_label();
            emit_bnz(l, ltrue);
            r = lower_expr(n->b);
            ins = emit(IR_STL);
            ins->a = r;
            ins->slot = result_slot;
            emit_jmp(lend);
            emit_label(ltrue);
            c1 = lower_const(1);
            ins = emit(IR_STL);
            ins->a = c1;
            ins->slot = result_slot;
            emit_label(lend);
            res = new_temp();
            ins = emit(IR_LDL);
            ins->dst = res;
            ins->slot = result_slot;
            return res;
        }
        /* Boolean and/or short-circuit (FPC default {$B-}); a bitwise and/or
           on integer operands keeps the full-evaluation generic path. */
        if ((n->op == T_AND || n->op == T_OR) &&
            expr_is_boolean(n->a) && expr_is_boolean(n->b))
            return lower_short_circuit(n, n->op == T_AND);
        if (n->op == T_IN) {
            int args[2];
            args[0] = lower_expr(n->a);
            args[1] = lower_set_addr(n->b);
            return emit_call_ret("__pascal_set_in",
                                 args, 2);
        }
        if (n->op == T_PLUS) {
            if (is_set_type(n->a) || is_set_type(n->b)) {
                int slot, args[3], dst;
                slot = alloc_slot(32);
                dst = emit_adl(slot);
                args[0] = dst;
                args[1] = lower_set_addr(n->a);
                args[2] = lower_set_addr(n->b);
                emit_call("__pascal_set_union",
                          args, 3);
                return dst;
            }
        }
        if (n->op == T_STAR) {
            if (is_set_type(n->a) || is_set_type(n->b)) {
                int slot, args[3], dst;
                slot = alloc_slot(32);
                dst = emit_adl(slot);
                args[0] = dst;
                args[1] = lower_set_addr(n->a);
                args[2] = lower_set_addr(n->b);
                emit_call("__pascal_set_intersect",
                          args, 3);
                return dst;
            }
        }
        if (n->op == T_MINUS) {
            if (is_set_type(n->a) || is_set_type(n->b)) {
                int slot, args[3], dst;
                slot = alloc_slot(32);
                dst = emit_adl(slot);
                args[0] = dst;
                args[1] = lower_set_addr(n->a);
                args[2] = lower_set_addr(n->b);
                emit_call("__pascal_set_diff",
                          args, 3);
                return dst;
            }
        }
        if (n->op == T_PLUS) {
            int is_str = 0;
            /* a '+' is string concatenation when either operand is a
               string value: a string l-value or call, a multi-character
               literal, or (recursively) a nested concatenation.  A nested
               concat operand is why node_is_string_valued is used rather
               than is_string_type, which does not see through a binop. */
            if (node_is_string_valued(n->a) || node_is_string_valued(n->b))
                is_str = 1;
            else if (n->a->kind == N_STR && n->a->slen != 1)
                is_str = 1;
            else if (n->b->kind == N_STR && n->b->slen != 1)
                is_str = 1;
            if (is_str) {
                int args[2];
                args[0] = lower_str_concat_operand(n->a);
                args[1] = lower_str_concat_operand(n->b);
                return emit_str_new_call("__pascal_str_concat", args, 2);
            }
        }
        if (n->op >= T_EQ && n->op <= T_GE) {
            if (is_set_type(n->a) || is_set_type(n->b)) {
                int args[2];
                const char *fn = NULL;
                args[0] = lower_set_addr(n->a);
                args[1] = lower_set_addr(n->b);
                switch (n->op) {
                case T_EQ:
                    fn = "__pascal_set_eq";
                    break;
                case T_NE:
                    fn = "__pascal_set_ne";
                    break;
                case T_LE:
                    fn = "__pascal_set_subset";
                    break;
                case T_GE:
                    fn = "__pascal_set_subset";
                    /* swap: a >= b means b subset of a */
                    { int tmp = args[0]; args[0] = args[1]; args[1] = tmp; }
                    break;
                default:
                    die("lower:%d: unsupported set comparison", n->line);
                }
                return emit_call_ret(fn, args, 2);
            }
        }
        if (n->op >= T_EQ && n->op <= T_GE) {
            int is_str = 0;
            if (is_string_type(n->a) || is_string_type(n->b))
                is_str = 1;
            else if (n->a->kind == N_STR && n->a->slen != 1)
                is_str = 1;
            else if (n->b->kind == N_STR && n->b->slen != 1)
                is_str = 1;
            if (is_str) {
                int args[2], cmp, zero;
                args[0] = lower_str_addr(n->a);
                args[1] = lower_str_addr(n->b);
                cmp = emit_call_ret("__pascal_str_compare",
                                    args, 2);
                zero = lower_const(0);
                op = bin_op_for_tok(n->op);
                ins = emit(op);
                ins->dst = new_temp();
                ins->a = cmp;
                ins->b = zero;
                return ins->dst;
            }
        }
        l = lower_expr(n->a);
        r = lower_expr(n->b);
        /* floating-point operation if either operand is a real, or for the `/`
           operator which always yields a real in Pascal: promote both to the
           common width (double if either is double) and pick the float opcode.
           A comparison yields a 32-bit boolean. */
        if (is_float(l) || is_float(r) || n->op == T_SLASH) {
            int w = (is_float(l) ? float_fw(l) : 0) == FWIDTH_F32 &&
                    (is_float(r) ? float_fw(r) : 0) == FWIDTH_F32
                    ? FWIDTH_F32 : 0;
            int fop;
            l = to_float(l, w);
            r = to_float(r, w);
            switch (n->op) {
            case T_PLUS:  fop = IR_FADD; break;
            case T_MINUS: fop = IR_FSUB; break;
            case T_STAR:  fop = IR_FMUL; break;
            case T_SLASH: fop = IR_FDIV; break;
            case T_EQ:    fop = IR_FCMPEQ; break;
            case T_LT:    fop = IR_FCMPLT; break;
            case T_LE:    fop = IR_FCMPLE; break;
            case T_GT:    fop = IR_FCMPLT; { int t = l; l = r; r = t; } break;
            case T_GE:    fop = IR_FCMPLE; { int t = l; l = r; r = t; } break;
            case T_NE: {
                int eq, zero;
                ins = emit(IR_FCMPEQ);
                ins->dst = new_temp();
                ins->a = l;
                ins->b = r;
                ins->imm = w;
                eq = ins->dst;
                zero = lower_const(0);
                ins = emit(IR_CMPEQ);
                ins->dst = new_temp();
                ins->a = eq;
                ins->b = zero;
                return ins->dst;
            }
            default:
                die("lower:%d: bad float binary op", n->line);
                return 0;
            }
            ins = emit(fop);
            ins->dst = new_temp();
            ins->a = l;
            ins->b = r;
            ins->imm = w;
            if (fop == IR_FADD || fop == IR_FSUB ||
                fop == IR_FMUL || fop == IR_FDIV)
                mark_float(ins->dst, w);
            return ins->dst;
        }
        /* 64-bit operation if either operand is Int64: promote both and pick
           the 64-bit opcode.  A comparison still yields a 32-bit boolean. */
        if (is_i64(l) || is_i64(r)) {
            int op64 = bin_op_for_tok64(n->op);
            if (op64 < 0)
                die("lower:%d: bad binary op", n->line);
            l = to_i64(l);
            r = to_i64(r);
            ins = emit(op64);
            ins->dst = new_temp();
            ins->a = l;
            ins->b = r;
            if (op64_is_value(n->op))
                mark_i64(ins->dst);
            return ins->dst;
        }
        op = bin_op_for_tok(n->op);
        if (op < 0)
            die("lower:%d: bad binary op", n->line);
        ins = emit(op);
        ins->dst = new_temp();
        ins->a = l;
        ins->b = r;
        if (n->ival && (op == IR_ADD || op == IR_SUB ||
                        op == IR_MUL)) {
            int result, t1, t2, t3, zero, cmp;
            int labort, lok, abort_args[1];
            result = ins->dst;
            labort = new_label();
            lok = new_label();
            if (op == IR_ADD) {
                t1 = new_temp();
                ins = emit(IR_XOR);
                ins->dst = t1;
                ins->a = l;
                ins->b = result;
                t2 = new_temp();
                ins = emit(IR_XOR);
                ins->dst = t2;
                ins->a = r;
                ins->b = result;
                t3 = new_temp();
                ins = emit(IR_AND);
                ins->dst = t3;
                ins->a = t1;
                ins->b = t2;
            } else if (op == IR_SUB) {
                t1 = new_temp();
                ins = emit(IR_XOR);
                ins->dst = t1;
                ins->a = l;
                ins->b = r;
                t2 = new_temp();
                ins = emit(IR_XOR);
                ins->dst = t2;
                ins->a = l;
                ins->b = result;
                t3 = new_temp();
                ins = emit(IR_AND);
                ins->dst = t3;
                ins->a = t1;
                ins->b = t2;
            } else {
                /* MUL: overflow if a != 0 && result / a != b */
                int lnomul, div_res;
                lnomul = new_label();
                zero = lower_const(0);
                cmp = new_temp();
                ins = emit(IR_CMPEQ);
                ins->dst = cmp;
                ins->a = l;
                ins->b = zero;
                emit_bnz(cmp, lnomul);
                div_res = new_temp();
                ins = emit(IR_DIVS);
                ins->dst = div_res;
                ins->a = result;
                ins->b = l;
                cmp = new_temp();
                ins = emit(IR_CMPNE);
                ins->dst = cmp;
                ins->a = div_res;
                ins->b = r;
                emit_bnz(cmp, labort);
                emit_label(lnomul);
                emit_jmp(lok);
                emit_label(labort);
                abort_args[0] = lower_const(134);
                emit_call("exit", abort_args, 1);
                emit_label(lok);
                return result;
            }
            zero = lower_const(0);
            cmp = new_temp();
            ins = emit(IR_CMPLTS);
            ins->dst = cmp;
            ins->a = t3;
            ins->b = zero;
            emit_bnz(cmp, labort);
            emit_jmp(lok);
            emit_label(labort);
            abort_args[0] = lower_const(134);
            emit_call("exit", abort_args, 1);
            emit_label(lok);
            return result;
        }
        return ins->dst;

    case N_CALL:
        return lower_call(n);

    case N_SET: {
        int slot, dst;
        struct node *e;

        slot = alloc_slot(32);
        dst = emit_adl(slot);
        {
            int args[1];
            args[0] = dst;
            emit_call("__pascal_set_clear", args, 1);
        }
        for (e = n->a; e; e = e->next) {
            if (e->kind == N_SETRANGE) {
                int args[3];
                args[0] = dst;
                args[1] = lower_expr(e->a);
                args[2] = lower_expr(e->b);
                emit_call("__pascal_set_addrange",
                          args, 3);
            } else {
                int args[2];
                args[0] = dst;
                args[1] = lower_expr(e);
                emit_call("__pascal_set_add", args, 2);
            }
        }
        return dst;
    }

    case N_SIZEOF: {
        struct type_def *td = find_type(n->name);
        if (!td)
            die("lower:%d: unknown type '%s' in sizeof",
                n->line, n->name);
        ins = emit(IR_LIC);
        ins->dst = new_temp();
        ins->imm = td->total_size;
        return ins->dst;
    }

    default:
        die("lower:%d: unhandled expr kind %d", n->line, n->kind);
    }
    return 0;
}

/****************************************************************
 * Write / writeln builtin lowering
 ****************************************************************/

static void
write_str_literal(const char *str, int slen)
{
    char namebuf[32];
    int args[2];
    struct ir_insn *lea;

    snprintf(namebuf, sizeof(namebuf), "__str_%d", strctr++);
    add_string_global(namebuf, str, slen + 1);
    lea = emit(PC_LP64_ON ? IR_LEA64 : IR_LEA);
    lea->dst = new_temp();
    lea->sym = arena_strdup(lower_arena,namebuf);
    mark_ptr(lea->dst);
    /* route through the runtime so it honors the current output stream
       (Output or ErrOutput) rather than writing straight to fd 1 */
    args[0] = lea->dst;
    args[1] = lower_const(slen);
    emit_call("__pascal_write_raw", args, 2);
}

static int
is_char_call(struct node *n)
{
    if (n->kind != N_CALL || !n->a || n->a->kind != N_NAME)
        return 0;
    return strcmp(n->a->name, "chr") == 0 ||
           strcmp(n->a->name, "upcase") == 0 ||
           strcmp(n->a->name, "lowercase") == 0;
}

/* Whether an expression evaluates to a heap string: a literal, a string-typed
   l-value or string-returning call (is_string_type), or a concatenation. */
static int
node_is_string_valued(struct node *n)
{
    if (!n)
        return 0;
    if (n->kind == N_STR)
        return 1;
    if (n->kind == N_BINOP && n->op == T_PLUS)
        return node_is_string_valued(n->a) || node_is_string_valued(n->b);
    return is_string_type(n);
}

static int
is_char_type(struct node *n)
{
    const char *tn = lvalue_type_name(n);
    return tn && strcmp(tn, "char") == 0;
}

/* Whether an expression yields a char ordinal (a plain integer value) rather
   than a heap string: a char l-value (var, field, s[i]), a char-returning
   builtin (chr/upcase/lowercase), or a user function declared to return char.
   A one-character string literal is already materialized as a string, so it
   is not counted here. */
static int
expr_is_char_value(struct node *n)
{
    if (!n)
        return 0;
    if (is_char_type(n) || is_char_call(n))
        return 1;
    /* a call (with args) or a bare name (a parameterless function) whose
       callee is declared to return char */
    if (n->kind == N_CALL && n->a && n->a->kind == N_NAME) {
        struct sym *s = find_sym(n->a->name);
        if (s && s->is_func && s->decl &&
            s->decl->kind == N_FUNCDECL && s->decl->sval &&
            strcmp(s->decl->sval, "char") == 0)
            return 1;
    }
    if (n->kind == N_NAME) {
        struct sym *s = find_sym(n->name);
        if (s && s->is_func && s->decl &&
            s->decl->kind == N_FUNCDECL && s->decl->sval &&
            strcmp(s->decl->sval, "char") == 0)
            return 1;
    }
    return 0;
}

/* Lower an operand of string concatenation to a heap-string pointer.  A char
   value is promoted to a fresh one-character string; anything else goes
   through lower_str_addr unchanged. */
static int
lower_str_concat_operand(struct node *n)
{
    if (expr_is_char_value(n)) {
        int c = lower_expr(n);
        return emit_str_new_call("__pascal_str_ofchar", &c, 1);
    }
    return lower_str_addr(n);
}

static int
is_string_type(struct node *n)
{
    struct sym *s;

    if (!n)
        return 0;
    /* a string-typed l-value: a variable, a record field or an array element.
       lvalue_type_name resolves the field/element type and alias chains. */
    if (n->kind == N_NAME || n->kind == N_DOT || n->kind == N_INDEX) {
        const char *tn = lvalue_type_name(n);
        if (tn && is_string_type_name(tn))
            return 1;
    }
    /* a call whose result is a string (a bare function name, or a call with
       arguments whose callee name resolves to a string-returning function). */
    if (n->kind == N_NAME) {
        s = find_sym(n->name);
        if (s && s->is_func && s->decl &&
            is_string_type_name(s->decl->sval))
            return 1;
    }
    if (n->kind == N_CALL && n->a && n->a->kind == N_NAME) {
        const char *cn = n->a->name;
        /* string-returning builtins the front end lowers directly */
        if (strcmp(cn, "copy") == 0 || strcmp(cn, "paramstr") == 0 ||
            strcmp(cn, "concat") == 0)
            return 1;
        s = find_sym(cn);
        if (s && s->is_func && s->decl &&
            is_string_type_name(s->decl->sval))
            return 1;
    }
    return 0;
}

static int
is_set_type(struct node *n)
{
    if (n->kind == N_NAME) {
        struct sym *s = find_sym(n->name);
        if (s && s->type_name) {
            struct type_def *td = find_type(s->type_name);
            return td && td->is_set;
        }
    }
    if (n->kind == N_SET)
        return 1;
    return 0;
}

static int
lower_set_addr(struct node *n)
{
    if (n->kind == N_NAME) {
        struct sym *s = find_sym(n->name);
        if (!s)
            die("lower:%d: undefined '%s'", n->line, n->name);
        return addr_sym(s);
    }
    return lower_expr(n);
}

/* Write an already-lowered numeric value, choosing the real, Int64 or 32-bit
   integer formatter by the temp's kind. */
static void
emit_write_number(int v)
{
    if (is_float(v)) {
        int d = to_float(v, 0);
        emit_call("__pascal_write_real", &d, 1);
    } else if (is_i64(v)) {
        emit_call("__pascal_write_int64", &v, 1);
    } else {
        emit_call("__pascal_write_int", &v, 1);
    }
}

static void
lower_write_arg(struct node *arg)
{
    if (arg->kind == N_STR) {
        write_str_literal(arg->sval, arg->slen);
    } else if (arg->kind == N_NAME && is_string_type(arg)) {
        int args[1];
        args[0] = lower_str_addr(arg);
        emit_call("__pascal_write_str", args, 1);
    } else if (arg->kind == N_DOT || arg->kind == N_INDEX) {
        const char *tn = lvalue_type_name(arg);
        struct type_def *td = tn ? find_type(tn) : NULL;
        if (td && td->is_string) {
            int args[1];
            args[0] = lower_str_addr(arg);
            emit_call("__pascal_write_str", args, 1);
        } else {
            const char *ptname = lvalue_type_name(arg->a);
            struct type_def *ptd =
                ptname ? find_type(ptname) : NULL;
            if (ptd && ptd->is_string) {
                int args[1];
                args[0] = lower_expr(arg);
                emit_call("__pascal_write_char", args, 1);
            } else if (is_char_type(arg)) {
                int args[1];
                args[0] = lower_expr(arg);
                emit_call("__pascal_write_char", args, 1);
            } else {
                emit_write_number(lower_expr(arg));
            }
        }
    } else if (arg->kind == N_CALL && is_string_type(arg)) {
        /* writeln(f(...)) where f returns a string: write the result bytes */
        int args[1];
        args[0] = lower_expr(arg);
        emit_call("__pascal_write_str", args, 1);
    } else if (arg->kind == N_NAME) {
        struct sym *s = find_sym(arg->name);
        if (s && s->is_const && s->const_str) {
            write_str_literal(s->const_str, s->const_slen);
        } else if (is_char_type(arg)) {
            int args[1];
            args[0] = lower_expr(arg);
            emit_call("__pascal_write_char", args, 1);
        } else {
            emit_write_number(lower_expr(arg));
        }
    } else if (is_char_call(arg) || is_char_type(arg)) {
        int args[1];
        args[0] = lower_expr(arg);
        emit_call("__pascal_write_char", args, 1);
    } else if (node_is_string_valued(arg)) {
        /* a string-valued expression such as a concatenation (a + b) */
        int args[1];
        args[0] = lower_expr(arg);
        emit_call("__pascal_write_str", args, 1);
    } else {
        emit_write_number(lower_expr(arg));
    }
}

static void
lower_write(struct node *n, int newline)
{
    struct node *arg = n->b;
    int errstream = 0;

    /* an optional leading Output/ErrOutput selects the stream (fd 1/2) */
    if (arg && arg->kind == N_NAME &&
        (strcmp(arg->name, "output") == 0 ||
         strcmp(arg->name, "erroutput") == 0)) {
        if (strcmp(arg->name, "erroutput") == 0) {
            int two = lower_const(2);
            emit_call("__pascal_set_outfd", &two, 1);
            errstream = 1;
        }
        arg = arg->next;
    }

    for (; arg; arg = arg->next)
        lower_write_arg(arg);
    if (newline)
        write_str_literal("\n", 1);
    if (errstream) {
        int one = lower_const(1);
        emit_call("__pascal_set_outfd", &one, 1);
    }
}

/****************************************************************
 * Call lowering
 ****************************************************************/

/* Build a dynamic-array descriptor from an array constructor ([e1, e2, ...] or
   the empty []) passed where an open-array (dynamic-array) parameter is
   expected.  An empty constructor is the empty (NULL) array.  Otherwise a fresh
   descriptor is allocated and each element stored at its scalar width; the
   caller owns it for the duration of the statement (registered as a temp), and
   a `const`/value open-array parameter only borrows it.  Element types are
   scalar (the only open-array elements the front end builds a constructor for);
   a managed element type would need element retain/release and is rejected. */
static int
lower_open_array_ctor(struct node *setnode, struct type_def *arr)
{
    int count = 0, i, desc, elsize = arr->elem_size;
    int elem_i64 = is_i64_type_name(arr->elem_type_name);
    int elem_fw = float_fw_of_name(arr->elem_type_name);
    struct node *e;

    if (type_has_managed(arr->elem_type_name))
        die("lower:%d: array constructor of a managed element type is "
            "unsupported", setnode->line);
    for (e = setnode->a; e; e = e->next) {
        if (e->kind == N_SETRANGE)
            die("lower:%d: a range is not valid in an array constructor",
                setnode->line);
        count++;
    }
    if (count == 0)
        return emit_null_ptr();
    {
        int a3[3];
        a3[0] = emit_null_ptr();
        a3[1] = lower_const(count);
        a3[2] = lower_const(elsize);
        desc = emit_call_retptr("__pascal_arr_setlength", a3, 3);
    }
    i = 0;
    for (e = setnode->a; e; e = e->next, i++) {
        int addr = emit_addp(desc, lower_const(PSTR_HDR + i * elsize));
        int val = lower_expr(e);
        struct ir_insn *si;
        if (elem_fw >= 0) {
            val = to_float(val, elem_fw);
            si = emit(IR_FSD);
            si->imm = elem_fw;
        } else if (elem_i64) {
            val = to_i64(val);
            si = emit(IR_ST64);
        } else {
            val = to_i32(val);
            si = emit(IR_SW);
        }
        si->a = addr;
        si->b = val;
    }
    register_str_temp(desc);
    return desc;
}

/****************************************************************
 * Overloading by arity and type
 *
 * Several routines may share a name with different parameter lists (kpcom's
 * AddMember).  A forward declaration and its body share a signature and one
 * mangled name; genuinely different signatures get distinct names.  A call site
 * picks the overload whose arity matches the argument count, with a light type
 * score to break ties and prefer the body over a forward declaration.
 ****************************************************************/

/* Parameter count of a routine declaration. */
static int
decl_arity(struct node *d)
{
    int n = 0;
    struct node *p;
    for (p = d->a; p; p = p->next)
        n++;
    return n;
}

/* Whether two routine declarations have the same signature (kind, return type,
   and each parameter's mode and type name), so a forward and its body match
   while a real overload does not. */
static int
same_signature(struct node *a, struct node *b)
{
    struct node *pa, *pb;

    if (a->kind != b->kind)
        return 0;
    if (a->kind == N_FUNCDECL) {
        if ((a->sval == NULL) != (b->sval == NULL))
            return 0;
        if (a->sval && b->sval && strcmp(a->sval, b->sval) != 0)
            return 0;
    }
    for (pa = a->a, pb = b->a; pa && pb; pa = pa->next, pb = pb->next) {
        if (pa->op != pb->op)
            return 0;
        if ((pa->sval == NULL) != (pb->sval == NULL))
            return 0;
        if (pa->sval && pb->sval && strcmp(pa->sval, pb->sval) != 0)
            return 0;
    }
    return pa == NULL && pb == NULL;
}

/* Assign the IR symbol name for a routine among the whole routine list.  A name
   with a single signature keeps its plain spelling; an overloaded name gets a
   per-signature suffix (__ovl<k>) shared by that signature's forward and body
   so every reference and definition agree. */
static char *
overload_ir_name(struct node *d, struct node *all)
{
    struct node *o;
    int distinct = 0, myidx = -1;
    int overloaded = 0;
    char buf[256];

    for (o = all; o; o = o->next) {
        if (o->kind != N_FUNCDECL && o->kind != N_PROCDECL)
            continue;
        if (strcmp(o->name, d->name) != 0)
            continue;
        if (o != d && !same_signature(o, d))
            overloaded = 1;
    }
    if (!overloaded)
        return NULL;    /* plain name */
    /* index of d's signature among the distinct signatures seen in order */
    for (o = all; o; o = o->next) {
        int seen = 0;
        struct node *q;
        if (o->kind != N_FUNCDECL && o->kind != N_PROCDECL)
            continue;
        if (strcmp(o->name, d->name) != 0)
            continue;
        for (q = all; q != o; q = q->next) {
            if (q->kind != N_FUNCDECL && q->kind != N_PROCDECL)
                continue;
            if (strcmp(q->name, d->name) == 0 && same_signature(q, o)) {
                seen = 1;
                break;
            }
        }
        if (seen)
            continue;           /* a signature already counted */
        if (same_signature(o, d))
            myidx = distinct;
        distinct++;
    }
    snprintf(buf, sizeof(buf), "%s__ovl%d", d->name, myidx < 0 ? 0 : myidx);
    return arena_strdup(lower_arena, buf);
}

/* The function sym registered for a specific declaration node (overloads share
   a name, so a by-name lookup is not enough). */
static struct sym *
find_func_sym_by_decl(struct node *decl)
{
    int i;
    for (i = nsyms - 1; i >= 0; i--)
        if (syms[i].is_func && syms[i].decl == decl)
            return &syms[i];
    return NULL;
}

/* Rough type class of an argument expression, for overload tie-breaking:
   1 = string-like, 2 = real, 0 = everything else (integers, ordinals, ...). */
static int
arg_class(struct node *a)
{
    if (a->kind == N_STR || is_string_type(a))
        return 1;
    return 0;
}

/* Type class a parameter expects, by the same coarse scheme. */
static int
param_class(struct node *p)
{
    if (p->sval && is_strlike_type_name(p->sval))
        return 1;
    if (p->sval && is_float_type_name(p->sval))
        return 2;
    return 0;
}

/* Resolve a call to the best same-named routine: the arity must match the
   argument count; among those, the higher type-match score wins, then the body
   over a forward declaration.  Returns NULL when no routine has the name (the
   caller then treats it as a builtin or external). */
static struct sym *
resolve_overload(const char *name, struct node *args)
{
    int nargs = 0, i;
    struct node *a;
    struct sym *best = NULL;
    int best_score = -1, best_forward = 1, nfunc = 0;

    for (a = args; a; a = a->next)
        nargs++;
    for (i = 0; i < nsyms; i++) {
        struct node *d;
        struct node *p;
        int score, forward;
        if (!syms[i].is_func || !syms[i].decl)
            continue;
        if (strcmp(syms[i].name, name) != 0)
            continue;
        nfunc++;
        d = syms[i].decl;
        if (decl_arity(d) != nargs)
            continue;
        score = 0;
        for (p = d->a, a = args; p && a; p = p->next, a = a->next)
            if (param_class(p) == arg_class(a))
                score++;
        forward = d->is_forward ? 1 : 0;
        if (score > best_score ||
            (score == best_score && best_forward && !forward)) {
            best = &syms[i];
            best_score = score;
            best_forward = forward;
        }
    }
    if (best)
        return best;
    /* no arity match: fall back to any same-named routine (lets the existing
       diagnostics and single-overload calls work unchanged) */
    if (nfunc > 0)
        for (i = nsyms - 1; i >= 0; i--)
            if (syms[i].is_func && strcmp(syms[i].name, name) == 0)
                return &syms[i];
    return NULL;
}

static int
lower_call(struct node *n)
{
    struct ir_insn *ins;
    const char *name;
    struct node *arg;
    int args[16];
    int nargs;

    if (n->a->kind != N_NAME)
        die("lower:%d: indirect call not supported", n->line);
    name = n->a->name;

    /* user-defined procedures/functions take priority over builtins */
    {
        struct sym *check = find_sym(name);
        if (check && check->is_func)
            goto user_call;
    }

    if (strcmp(name, "halt") == 0) {
        if (n->b)
            args[0] = lower_expr(n->b);
        else
            args[0] = lower_const(0);
        emit_call("exit", args, 1);
        return 0;
    }

    if (strcmp(name, "exit") == 0) {
        /* Exit(v) sets the function result like `funcname := v`, so it must
           maintain reference counts the same way: a borrowed string source is
           retained (a plain store would hand the caller a value it then frees,
           dropping a reference it never owned), and a real, int64, or 32-bit
           result each stores through its own width. */
        if (n->b && cur_func_name && ret_slot >= 0) {
            if (ret_is_str) {
                int src = lower_str_addr(n->b);
                emit_string_store(1, ret_slot, src,
                                  str_rvalue_owned(n->b), ret_type_name);
            } else {
                int val = lower_expr(n->b);
                if (ret_is_float) {
                    val = to_float(val, ret_fw);
                    ins = emit(IR_FSTL);
                    ins->a = val;
                    ins->slot = ret_slot;
                    ins->imm = ret_fw;
                } else {
                    val = ret_is_i64 ? to_i64(val) : to_i32(val);
                    ins = emit(ret_is_i64 ? IR_STL64 : IR_STL);
                    ins->a = val;
                    ins->slot = ret_slot;
                }
            }
        }
        emit_jmp(exit_label);
        return 0;
    }

    if (strcmp(name, "write") == 0) {
        lower_write(n, 0);
        return 0;
    }
    if (strcmp(name, "writeln") == 0) {
        lower_write(n, 1);
        return 0;
    }
    if (strcmp(name, "flush") == 0) {
        /* output is unbuffered (direct write), so Flush(stream) is a no-op */
        return 0;
    }
    if (strcmp(name, "paramcount") == 0) {
        return emit_call_ret("__pascal_param_count", NULL, 0);
    }
    if (strcmp(name, "paramstr") == 0) {
        int a;
        if (!n->b)
            die("lower:%d: paramstr requires an argument", n->line);
        a = to_i32(lower_expr(n->b));
        return emit_str_new_call("__pascal_param_str", &a, 1);
    }

    if (strcmp(name, "read") == 0 ||
        strcmp(name, "readln") == 0) {
        struct node *a;
        int is_readln = (name[4] == 'l');
        int read_str = 0;
        for (a = n->b; a; a = a->next) {
            int addr = 0;
            if (a->kind == N_NAME) {
                struct sym *s = find_sym(a->name);
                if (!s)
                    die("lower:%d: undefined '%s'",
                        n->line, a->name);
                addr = addr_sym(s);
            } else if (a->kind == N_DOT ||
                       a->kind == N_INDEX) {
                addr = lower_lvalue_addr(a);
            } else {
                die("lower:%d: read requires a variable",
                    n->line);
            }
            if (is_string_type(a)) {
                int p = emit_str_new_call("__pascal_read_str",
                                         NULL, 0);
                store_string_lvalue(a, p, 1);
                read_str = 1;
            } else {
                const char *rt_fn =
                    is_char_type(a) ?
                    "__pascal_read_char" :
                    "__pascal_read_int";
                int rargs[1];
                rargs[0] = addr;
                emit_call(rt_fn, rargs, 1);
            }
        }
        if (is_readln && !read_str)
            emit_call("__pascal_readln", NULL, 0);
        return 0;
    }

    /* eof — check for end of input */
    if (strcmp(name, "eof") == 0)
        return emit_call_ret("__pascal_eof", NULL, 0);

    /* str(value, s) — integer to string */
    if (strcmp(name, "str") == 0) {
        struct node *val_node, *dst_node;
        int v, p;
        if (!n->b || !n->b->next)
            die("lower:%d: str requires two arguments",
                n->line);
        val_node = n->b;
        dst_node = n->b->next;
        v = lower_expr(val_node);
        if (is_float(v)) {
            v = to_float(v, 0);
            p = emit_str_new_call("__pascal_str_from_real", &v, 1);
        } else if (is_i64(v)) {
            p = emit_str_new_call("__pascal_str_from_int64", &v, 1);
        } else {
            p = emit_str_new_call("__pascal_str_from_int", &v, 1);
        }
        /* the destination is the enclosing function's string result (Str(v, F)
           inside function F) or an ordinary string l-value */
        if (dst_node->kind == N_NAME && cur_func_name &&
            strcmp(dst_node->name, cur_func_name) == 0 &&
            ret_slot >= 0 && ret_is_str) {
            emit_string_store(1, ret_slot, p, 1, ret_type_name);
        } else {
            const char *dtn = lvalue_type_name(dst_node);
            if (!dtn || !is_string_type_name(dtn))
                die("lower:%d: str destination must be a string", n->line);
            store_string_lvalue(dst_node, p, 1);
        }
        return 0;
    }

    /* ord — identity on integers */
    if (strcmp(name, "ord") == 0) {
        if (!n->b)
            die("lower:%d: ord requires argument", n->line);
        return lower_expr(n->b);
    }

    /* integer(x) / longint(x) — truncate to a 32-bit integer */
    if (strcmp(name, "integer") == 0 || strcmp(name, "longint") == 0 ||
        strcmp(name, "cardinal") == 0 || strcmp(name, "longword") == 0) {
        if (!n->b)
            die("lower:%d: %s() requires argument", n->line, name);
        return to_i32(lower_expr(n->b));
    }

    /* int64(x) / qword(x) — sign-extend to a 64-bit integer */
    if (strcmp(name, "int64") == 0 || strcmp(name, "qword") == 0 ||
        strcmp(name, "uint64") == 0) {
        if (!n->b)
            die("lower:%d: %s() requires argument", n->line, name);
        return to_i64(lower_expr(n->b));
    }

    /* real(x) / double(x) / single(x) — convert to a floating-point value */
    if (strcmp(name, "real") == 0 || strcmp(name, "double") == 0 ||
        strcmp(name, "single") == 0 || strcmp(name, "float") == 0) {
        if (!n->b)
            die("lower:%d: %s() requires argument", n->line, name);
        return to_float(lower_expr(n->b),
                        strcmp(name, "single") == 0 ? FWIDTH_F32 : 0);
    }

    /* trunc(x) — real to integer, toward zero */
    if (strcmp(name, "trunc") == 0) {
        if (!n->b)
            die("lower:%d: trunc requires argument", n->line);
        return float_to_int(to_float(lower_expr(n->b), 0));
    }

    /* round(x) — real to nearest integer */
    if (strcmp(name, "round") == 0) {
        int fa[1];
        if (!n->b)
            die("lower:%d: round requires argument", n->line);
        fa[0] = to_float(lower_expr(n->b), 0);
        return emit_call_ret("__pascal_round", fa, 1);
    }

    /* int(x) — integer part of a real, as a real */
    if (strcmp(name, "int") == 0) {
        if (!n->b)
            die("lower:%d: int requires argument", n->line);
        return to_float(float_to_int(to_float(lower_expr(n->b), 0)), 0);
    }

    /* sqrt(x) — real square root */
    if (strcmp(name, "sqrt") == 0) {
        int fa[1];
        if (!n->b)
            die("lower:%d: sqrt requires argument", n->line);
        fa[0] = to_float(lower_expr(n->b), 0);
        return emit_call_retf("__pascal_sqrt", fa, 1, 0);
    }

    /* chr(x), char(x), byte(x) — mask to 8 bits */
    if (strcmp(name, "chr") == 0 ||
        strcmp(name, "char") == 0 || strcmp(name, "byte") == 0) {
        int val, cmask;
        if (!n->b)
            die("lower:%d: %s() requires argument", n->line, name);
        val = to_i32(lower_expr(n->b));
        cmask = lower_const(0xFF);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cmask;
        return ins->dst;
    }

    /* word(x) — mask to 16 bits */
    if (strcmp(name, "word") == 0) {
        int val, cmask;
        if (!n->b)
            die("lower:%d: word() requires argument", n->line);
        val = to_i32(lower_expr(n->b));
        cmask = lower_const(0xFFFF);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cmask;
        return ins->dst;
    }

    /* abs(x) — branchless: mask=x>>(w-1), (x^mask)-mask */
    if (strcmp(name, "abs") == 0) {
        int val, c31, mask, xored;
        if (!n->b)
            die("lower:%d: abs requires argument", n->line);
        val = lower_expr(n->b);
        if (is_i64(val)) {
            int c63 = lower_const(63);
            ins = emit(IR_SHRS64);
            ins->dst = new_temp();
            ins->a = val;
            ins->b = c63;
            mark_i64(ins->dst);
            mask = ins->dst;
            ins = emit(IR_XOR64);
            ins->dst = new_temp();
            ins->a = val;
            ins->b = mask;
            mark_i64(ins->dst);
            xored = ins->dst;
            ins = emit(IR_SUB64);
            ins->dst = new_temp();
            ins->a = xored;
            ins->b = mask;
            mark_i64(ins->dst);
            return ins->dst;
        }
        c31 = lower_const(31);
        ins = emit(IR_SHRS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c31;
        mask = ins->dst;
        ins = emit(IR_XOR);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = mask;
        xored = ins->dst;
        ins = emit(IR_SUB);
        ins->dst = new_temp();
        ins->a = xored;
        ins->b = mask;
        return ins->dst;
    }

    /* odd(x) — x AND 1 */
    if (strcmp(name, "odd") == 0) {
        int val, c1;
        if (!n->b)
            die("lower:%d: odd requires argument", n->line);
        val = lower_expr(n->b);
        c1 = lower_const(1);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c1;
        return ins->dst;
    }

    /* succ(x) — x + 1 */
    if (strcmp(name, "succ") == 0) {
        int val, c1;
        if (!n->b)
            die("lower:%d: succ requires argument", n->line);
        val = lower_expr(n->b);
        c1 = lower_const(1);
        ins = emit(IR_ADD);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c1;
        return ins->dst;
    }

    /* pred(x) — x - 1 */
    if (strcmp(name, "pred") == 0) {
        int val, c1;
        if (!n->b)
            die("lower:%d: pred requires argument", n->line);
        val = lower_expr(n->b);
        c1 = lower_const(1);
        ins = emit(IR_SUB);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c1;
        return ins->dst;
    }

    /* length(s) — string length */
    if (strcmp(name, "length") == 0) {
        const char *tn;
        if (!n->b)
            die("lower:%d: length requires argument", n->line);
        if (n->b->kind == N_STR)
            return lower_const(n->b->slen);
        tn = lvalue_type_name(n->b);
        if (is_string_type(n->b) || (tn && is_strlike_type_name(tn))) {
            /* a string or dynamic array: both read element count from the
               descriptor's len field (NULL reads as 0). */
            int sp = lower_str_addr(n->b);
            return emit_call_ret("__pascal_str_length", &sp, 1);
        }
        die("lower:%d: length requires a string or dynamic array",
            n->line);
    }

    /* high(a) / low(a) on a dynamic array (length-1 and 0); for a fixed array
       the static bounds. */
    if (strcmp(name, "high") == 0 || strcmp(name, "low") == 0) {
        const char *tn;
        struct type_def *at;
        if (!n->b)
            die("lower:%d: %s requires argument", n->line, name);
        /* High/Low of an ordinal type (an enum or subrange) or of an
           ordinal-typed value: the type's static bounds.  Accept a bare type
           name, High(TColor), or an ordinal variable, High(c). */
        {
            struct type_def *ot = NULL;
            if (n->b->kind == N_NAME)
                ot = resolve_type(n->b->name);
            if (!ot) {
                const char *vt = lvalue_type_name(n->b);
                ot = vt ? resolve_type(vt) : NULL;
            }
            if (ot && ot->is_ordinal)
                return lower_const(name[0] == 'l' ? ot->lo_bound
                                                  : ot->hi_bound);
        }
        tn = lvalue_type_name(n->b);
        at = tn ? find_type(tn) : NULL;
        if (at && at->is_dynarray) {
            if (name[0] == 'l')
                return lower_const(0);
            {
                int sp = lower_str_addr(n->b);
                int len = emit_call_ret("__pascal_str_length", &sp, 1);
                int one = lower_const(1);
                ins = emit(IR_SUB);
                ins->dst = new_temp();
                ins->a = len;
                ins->b = one;
                return ins->dst;
            }
        }
        if (at && at->is_array)
            return lower_const(name[0] == 'l' ? at->lo_bound
                                              : at->hi_bound);
        die("lower:%d: %s requires an array", n->line, name);
    }

    /* setlength(a, n): resize a dynamic array in place, rebinding a. */
    if (strcmp(name, "setlength") == 0) {
        const char *tn;
        struct type_def *at;
        int by_slot, where, cur, newlen, res, args[5];
        if (!n->b || !n->b->next)
            die("lower:%d: setlength requires 2 arguments", n->line);
        tn = lvalue_type_name(n->b);
        at = resolve_type(tn);
        if (!at || !at->is_dynarray)
            die("lower:%d: setlength requires a dynamic array", n->line);
        where = string_lhs_dest(n->b, &by_slot);
        cur = by_slot ? emit_load_ptr(where) : emit_load_ptr_at(where);
        newlen = to_i32(lower_expr(n->b->next));
        args[0] = cur;
        args[1] = newlen;
        args[2] = lower_const(at->elem_size);
        if (type_has_managed(at->elem_type_name)) {
            /* managed elements: pass the per-element finalize and retain
               callbacks so a shrink drops dropped elements and a shared resize
               retains the copied ones */
            const char *dtor, *retain;
            arr_elem_fns(at, &dtor, &retain);
            args[3] = emit_lea_sym(dtor);
            args[4] = emit_lea_sym(retain);
            res = emit_call_retptr("__pascal_arr_setlength_mgd", args, 5);
        } else {
            res = emit_call_retptr("__pascal_arr_setlength", args, 3);
        }
        if (by_slot)
            emit_store_ptr(where, res);
        else
            emit_store_ptr_at(where, res);
        return 0;
    }

    /* copy(s, index, count) — substring */
    if (strcmp(name, "copy") == 0) {
        struct node *a1, *a2, *a3;
        int cargs[3];
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: copy requires 3 arguments", n->line);
        a1 = n->b;
        a2 = n->b->next;
        a3 = n->b->next->next;
        cargs[0] = lower_str_addr(a1);
        cargs[1] = lower_expr(a2);
        cargs[2] = lower_expr(a3);
        return emit_str_new_call("__pascal_str_copy", cargs, 3);
    }

    /* pos(substr, str) — find substring position */
    if (strcmp(name, "pos") == 0) {
        int pargs[2];
        if (!n->b || !n->b->next)
            die("lower:%d: pos requires 2 arguments", n->line);
        pargs[0] = lower_str_addr(n->b);
        pargs[1] = lower_str_addr(n->b->next);
        return emit_call_ret("__pascal_str_pos", pargs, 2);
    }

    /* delete(s, index, count) — remove characters, rebinding s */
    if (strcmp(name, "delete") == 0) {
        struct node *a1, *a2, *a3;
        int dargs[3], p;
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: delete requires 3 arguments",
                n->line);
        a1 = n->b;
        a2 = n->b->next;
        a3 = n->b->next->next;
        if (a1->kind != N_NAME && a1->kind != N_DOT &&
            a1->kind != N_INDEX)
            die("lower:%d: delete requires a variable",
                n->line);
        dargs[0] = lower_str_addr(a1);
        dargs[1] = lower_expr(a2);
        dargs[2] = lower_expr(a3);
        p = emit_str_new_call("__pascal_str_delete", dargs, 3);
        store_string_lvalue(a1, p, 1);
        return 0;
    }

    /* insert(source, dest, index) — insert string, rebinding dest */
    if (strcmp(name, "insert") == 0) {
        struct node *src_node, *dst_node, *idx_node;
        int iargs[3], p;
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: insert requires 3 arguments",
                n->line);
        src_node = n->b;
        dst_node = n->b->next;
        idx_node = n->b->next->next;
        if (dst_node->kind != N_NAME && dst_node->kind != N_DOT &&
            dst_node->kind != N_INDEX)
            die("lower:%d: insert dest must be a variable",
                n->line);
        if (!is_string_type_name(lvalue_type_name(dst_node)))
            die("lower:%d: insert dest must be a string",
                n->line);
        iargs[0] = lower_str_addr(src_node);
        iargs[1] = lower_str_addr(dst_node);
        iargs[2] = lower_expr(idx_node);
        p = emit_str_new_call("__pascal_str_insert", iargs, 3);
        store_string_lvalue(dst_node, p, 1);
        return 0;
    }

    /* concat(s1, s2, ...) — concatenate multiple strings */
    if (strcmp(name, "concat") == 0) {
        struct node *a;
        int prev;
        if (!n->b || !n->b->next)
            die("lower:%d: concat requires at least 2 arguments",
                n->line);
        a = n->b;
        prev = lower_str_addr(a);
        a = a->next;
        while (a) {
            int cargs[2];
            cargs[0] = prev;
            cargs[1] = lower_str_addr(a);
            prev = emit_str_new_call("__pascal_str_concat",
                                    cargs, 2);
            a = a->next;
        }
        return prev;
    }

    /* sqr(x) — x * x */
    if (strcmp(name, "sqr") == 0) {
        int val;
        if (!n->b)
            die("lower:%d: sqr requires argument", n->line);
        val = lower_expr(n->b);
        ins = emit(IR_MUL);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = val;
        return ins->dst;
    }

    /* lo(x) — x AND $FF */
    if (strcmp(name, "lo") == 0) {
        int val, cff;
        if (!n->b)
            die("lower:%d: lo requires argument", n->line);
        val = lower_expr(n->b);
        cff = lower_const(0xFF);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cff;
        return ins->dst;
    }

    /* hi(x) — (x SHR 8) AND $FF */
    if (strcmp(name, "hi") == 0) {
        int val, c8, shifted, cff;
        if (!n->b)
            die("lower:%d: hi requires argument", n->line);
        val = lower_expr(n->b);
        c8 = lower_const(8);
        ins = emit(IR_SHRS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c8;
        shifted = ins->dst;
        cff = lower_const(0xFF);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = shifted;
        ins->b = cff;
        return ins->dst;
    }

    /* swap(w) — exchange high and low bytes of a word */
    if (strcmp(name, "swap") == 0) {
        int val, c8, cff, lo, hi, shifted;
        if (!n->b)
            die("lower:%d: swap requires argument", n->line);
        val = lower_expr(n->b);
        c8 = lower_const(8);
        cff = lower_const(0xFF);
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cff;
        lo = ins->dst;
        ins = emit(IR_SHL);
        ins->dst = new_temp();
        ins->a = lo;
        ins->b = c8;
        shifted = ins->dst;
        ins = emit(IR_SHRS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c8;
        hi = ins->dst;
        ins = emit(IR_AND);
        ins->dst = new_temp();
        ins->a = hi;
        ins->b = cff;
        hi = ins->dst;
        ins = emit(IR_OR);
        ins->dst = new_temp();
        ins->a = shifted;
        ins->b = hi;
        return ins->dst;
    }

    /* upcase(ch) — lowercase to uppercase */
    if (strcmp(name, "upcase") == 0) {
        int val, ca, cz, c32, cmp_lo, cmp_hi, both, upper;
        int lskip, result_slot;
        if (!n->b)
            die("lower:%d: upcase requires argument", n->line);
        val = lower_expr(n->b);
        ca = lower_const('a');
        cz = lower_const('z');
        c32 = lower_const(32);
        ins = emit(IR_CMPLTS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = ca;
        cmp_lo = ins->dst;
        ins = emit(IR_CMPGTS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cz;
        cmp_hi = ins->dst;
        ins = emit(IR_OR);
        ins->dst = new_temp();
        ins->a = cmp_lo;
        ins->b = cmp_hi;
        both = ins->dst;
        result_slot = alloc_slot(4);
        ins = emit(IR_STL);
        ins->a = val;
        ins->slot = result_slot;
        lskip = new_label();
        emit_bnz(both, lskip);
        ins = emit(IR_SUB);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c32;
        upper = ins->dst;
        ins = emit(IR_STL);
        ins->a = upper;
        ins->slot = result_slot;
        emit_label(lskip);
        ins = emit(IR_LDL);
        ins->dst = new_temp();
        ins->slot = result_slot;
        return ins->dst;
    }

    /* lowercase(ch) — uppercase to lowercase */
    if (strcmp(name, "lowercase") == 0) {
        int val, ca, cz, c32, cmp_lo, cmp_hi, both, low;
        int lskip, result_slot;
        if (!n->b)
            die("lower:%d: lowercase requires argument", n->line);
        val = lower_expr(n->b);
        ca = lower_const('A');
        cz = lower_const('Z');
        c32 = lower_const(32);
        ins = emit(IR_CMPLTS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = ca;
        cmp_lo = ins->dst;
        ins = emit(IR_CMPGTS);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = cz;
        cmp_hi = ins->dst;
        ins = emit(IR_OR);
        ins->dst = new_temp();
        ins->a = cmp_lo;
        ins->b = cmp_hi;
        both = ins->dst;
        result_slot = alloc_slot(4);
        ins = emit(IR_STL);
        ins->a = val;
        ins->slot = result_slot;
        lskip = new_label();
        emit_bnz(both, lskip);
        ins = emit(IR_ADD);
        ins->dst = new_temp();
        ins->a = val;
        ins->b = c32;
        low = ins->dst;
        ins = emit(IR_STL);
        ins->a = low;
        ins->slot = result_slot;
        emit_label(lskip);
        ins = emit(IR_LDL);
        ins->dst = new_temp();
        ins->slot = result_slot;
        return ins->dst;
    }

    /* inc(x)/inc(x,n) and dec(x)/dec(x,n).  The target is an ordinal
       l-value: a plain variable, or a record field or array element. */
    if (strcmp(name, "inc") == 0 || strcmp(name, "dec") == 0) {
        int is_add = (name[0] == 'i');
        struct node *tgt = n->b;
        int cur_val, amount, nv;
        if (!tgt)
            die("lower:%d: %s requires a variable", n->line, name);
        amount = tgt->next ? lower_expr(tgt->next) : lower_const(1);
        if (tgt->kind == N_NAME && find_sym(tgt->name)) {
            struct sym *s = find_sym(tgt->name);
            cur_val = load_sym(s);
            ins = emit(is_add ? IR_ADD : IR_SUB);
            ins->dst = new_temp();
            ins->a = cur_val;
            ins->b = amount;
            store_sym(s, ins->dst, 0);
            return 0;
        }
        if (tgt->kind == N_DOT || tgt->kind == N_INDEX ||
            tgt->kind == N_NAME) {
            const char *tn = lvalue_type_name(tgt);
            int i64 = is_i64_type_name(tn);
            int addr = lower_lvalue_addr(tgt);
            cur_val = lower_expr(tgt);
            if (i64) {
                amount = to_i64(amount);
                cur_val = to_i64(cur_val);
            }
            ins = emit(is_add ? IR_ADD : IR_SUB);
            ins->dst = new_temp();
            ins->a = cur_val;
            ins->b = amount;
            nv = ins->dst;
            if (i64) {
                mark_i64(nv);
                ins = emit(IR_ST64);
            } else {
                ins = emit(IR_SW);
            }
            ins->a = addr;
            ins->b = nv;
            return 0;
        }
        die("lower:%d: %s requires a variable", n->line, name);
    }

    /* val(s: string; var v; var code: integer)
       v may be an integer, int64, or real lvalue (name, field, or
       element). Dispatch to the runtime helper matching v's type. */
    if (strcmp(name, "val") == 0) {
        struct node *a1, *a2, *a3;
        const char *vtn;
        const char *fn;
        int saddr, vaddr, caddr, fargs[3];
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: val requires 3 arguments",
                n->line);
        a1 = n->b;
        a2 = n->b->next;
        a3 = n->b->next->next;
        saddr = lower_str_addr(a1);
        if (a2->kind != N_NAME && a2->kind != N_DOT &&
            a2->kind != N_INDEX)
            die("lower:%d: val result must be a variable",
                n->line);
        vaddr = lower_lvalue_addr(a2);
        if (a3->kind != N_NAME && a3->kind != N_DOT &&
            a3->kind != N_INDEX)
            die("lower:%d: val code must be a variable",
                n->line);
        caddr = lower_lvalue_addr(a3);
        vtn = lvalue_type_name(a2);
        if (vtn && is_float_type_name(vtn))
            fn = "__pascal_val_real";
        else if (vtn && is_i64_type_name(vtn))
            fn = "__pascal_val_int64";
        else
            fn = "__pascal_val";
        fargs[0] = saddr;
        fargs[1] = vaddr;
        fargs[2] = caddr;
        emit_call(fn, fargs, 3);
        return 0;
    }

    /* fillchar(var x; count: integer; value: byte) */
    if (strcmp(name, "fillchar") == 0) {
        int addr, count, val, fargs[3];
        struct node *a1, *a2, *a3;
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: fillchar requires 3 arguments",
                n->line);
        a1 = n->b;
        a2 = n->b->next;
        a3 = n->b->next->next;
        if (a1->kind == N_NAME) {
            struct sym *s = find_sym(a1->name);
            if (!s)
                die("lower:%d: undefined '%s'",
                    n->line, a1->name);
            addr = addr_sym(s);
        } else if (a1->kind == N_DOT ||
                   a1->kind == N_INDEX) {
            addr = lower_lvalue_addr(a1);
        } else {
            die("lower:%d: fillchar requires a variable",
                n->line);
            addr = 0;
        }
        count = lower_expr(a2);
        val = lower_expr(a3);
        fargs[0] = addr;
        fargs[1] = val;
        fargs[2] = count;
        emit_call("memset", fargs, 3);
        return 0;
    }

    /* move(var source; var dest; count: integer) */
    if (strcmp(name, "move") == 0) {
        int src, dst, count, fargs[3];
        struct node *a1, *a2, *a3;
        if (!n->b || !n->b->next || !n->b->next->next)
            die("lower:%d: move requires 3 arguments",
                n->line);
        a1 = n->b;
        a2 = n->b->next;
        a3 = n->b->next->next;
        if (a1->kind == N_NAME) {
            struct sym *s = find_sym(a1->name);
            if (!s)
                die("lower:%d: undefined '%s'",
                    n->line, a1->name);
            src = addr_sym(s);
        } else if (a1->kind == N_DOT ||
                   a1->kind == N_INDEX) {
            src = lower_lvalue_addr(a1);
        } else {
            die("lower:%d: move requires a variable",
                n->line);
            src = 0;
        }
        if (a2->kind == N_NAME) {
            struct sym *s = find_sym(a2->name);
            if (!s)
                die("lower:%d: undefined '%s'",
                    n->line, a2->name);
            dst = addr_sym(s);
        } else if (a2->kind == N_DOT ||
                   a2->kind == N_INDEX) {
            dst = lower_lvalue_addr(a2);
        } else {
            die("lower:%d: move requires a variable",
                n->line);
            dst = 0;
        }
        count = lower_expr(a3);
        fargs[0] = dst;
        fargs[1] = src;
        fargs[2] = count;
        emit_call("memmove", fargs, 3);
        return 0;
    }

    /* look up callee to check for var/const/compound parameters, resolving an
       overloaded name by the argument list */
user_call:
    {
        struct sym *callee = resolve_overload(name, n->b);
        struct node *param = callee && callee->decl ?
                             callee->decl->a : NULL;
        const char *call_name = name;
        int sret_is = callee && callee->decl &&
                      callee->decl->kind == N_FUNCDECL &&
                      type_is_sret(callee->decl->sval);
        int sret_slot = -1;

        if (callee && callee->ir_name)
            call_name = callee->ir_name;

        nargs = 0;

        /* hidden sret argument: a caller-side temporary that receives the
           compound result, passed as the first argument.  Its managed members
           are null-initialized so the callee's first field stores release a
           clean (empty) value rather than following a garbage pointer. */
        if (sret_is) {
            struct type_def *rtd = find_type(callee->decl->sval);
            sret_slot = alloc_slot(rtd->total_size);
            if (type_has_managed(callee->decl->sval))
                emit_managed_walk(emit_adl(sret_slot),
                                  callee->decl->sval, MGD_NULL);
            args[nargs++] = emit_adl(sret_slot);
        }

        /* hidden capture arguments for nested functions */
        if (callee && callee->ncaptures > 0) {
            for (int i = 0; i < callee->ncaptures; i++) {
                struct sym *vs;
                if (nargs >= 16)
                    die("lower: too many args");
                vs = find_sym(callee->captures[i]);
                if (!vs)
                    die("lower:%d: capture '%s' "
                        "not found",
                        n->line,
                        callee->captures[i]);
                args[nargs++] = addr_sym(vs);
            }
        }

        /* Collect the user arguments with their matching parameter nodes
           (left to right), then evaluate them right to left.  Right-to-left
           is FPC's argument evaluation order; matching it keeps the emitted
           IR temp numbering identical to the reference front end.  Each
           argument's value still lands in its positional slot in args[]. */
        {
            struct node *uargs[16], *uparams[16];
            int ucount = 0;
            int base, ui;
            for (arg = n->b; arg; arg = arg->next) {
                if (ucount >= 16)
                    die("lower: too many args");
                uargs[ucount] = arg;
                uparams[ucount] = param;
                ucount++;
                if (param)
                    param = param->next;
            }
            base = nargs;
            if (base + ucount > 16)
                die("lower: too many args");
            nargs += ucount;
            for (ui = ucount - 1; ui >= 0; ui--) {
                struct node *p = uparams[ui];
                int slot = base + ui;
                int pass_addr = 0;
                arg = uargs[ui];
                if (p && p->op == 1)
                    pass_addr = 1;
                else if (p && p->sval &&
                         find_type(p->sval) &&
                         !is_strlike_type_name(p->sval) &&
                         !(resolve_type(p->sval) &&
                           resolve_type(p->sval)->is_scalar))
                    pass_addr = 1;
                if (pass_addr && p && p->sval &&
                    resolve_type(p->sval) &&
                    resolve_type(p->sval)->is_set) {
                    /* a set-typed value parameter: materialize the set
                       expression and pass the address of the 32-byte value. */
                    args[slot] = lower_set_addr(arg);
                } else if (pass_addr) {
                    if (arg->kind == N_NAME) {
                        struct sym *vs;
                        vs = find_sym(arg->name);
                        if (!vs)
                            die("lower:%d: undefined "
                                "variable '%s'",
                                n->line, arg->name);
                        args[slot] = addr_sym(vs);
                    } else if (arg->kind == N_DOT ||
                               arg->kind == N_INDEX) {
                        args[slot] = lower_lvalue_addr(arg);
                    } else {
                        die("lower:%d: parameter "
                            "requires a variable",
                            n->line);
                    }
                } else if (arg->kind == N_SET && p &&
                           resolve_type(p->sval) &&
                           resolve_type(p->sval)->is_dynarray) {
                    /* an array constructor ([...] or []) passed to an
                       open-array parameter builds a dynamic-array
                       descriptor, not a set */
                    args[slot] =
                        lower_open_array_ctor(arg, resolve_type(p->sval));
                } else {
                    int av = lower_expr(arg);
                    int pfw = p ? float_fw_of_name(p->sval) : -1;
                    /* coerce a scalar argument to the parameter's width.  A
                       string is a pointer value passed as-is (no integer
                       coercion, which would truncate it on LP64). */
                    if (p && is_strlike_type_name(p->sval))
                        ;
                    else if (pfw >= 0)
                        av = to_float(av, pfw);
                    else if (p && is_i64_type_name(p->sval))
                        av = to_i64(av);
                    else if (p && p->sval && is_i64(av))
                        av = to_i32(av);
                    else if (p && p->sval && is_float(av))
                        av = float_to_int(av);
                    args[slot] = av;
                }
            }
        }
        if (sret_is) {
            /* void call; the result sits in the sret temporary, whose address
               is the value of the call expression */
            emit_call(call_name, args, nargs);
            return emit_adl(sret_slot);
        }
        if (callee && callee->decl &&
            callee->decl->kind == N_FUNCDECL) {
            int rfw = float_fw_of_name(callee->decl->sval);
            if (rfw >= 0)
                return emit_call_retf(call_name, args, nargs, rfw);
            if (is_i64_type_name(callee->decl->sval))
                return emit_call_ret64(call_name, args, nargs);
            if (is_strlike_type_name(callee->decl->sval))
                return emit_str_new_call(call_name, args, nargs);
        }
        return emit_call_ret(call_name, args, nargs);
    }
}

/****************************************************************
 * Statement lowering
 ****************************************************************/

static void lower_stmt_inner(struct node *n);

static void
lower_stmts(struct node *n)
{
    for (; n; n = n->next)
        lower_stmt(n);
}

/* Lower one statement, then release the owned string temporaries it left
   behind (intermediate concatenations, a string compared in a condition, an
   argument built on the fly).  Loops that re-evaluate a condition release
   its temporaries inside the loop as well, so the per-iteration values do not
   accumulate; this wrapper then finds nothing more to drop. */
static void
lower_stmt(struct node *n)
{
    int mark = str_temp_mark();
    lower_stmt_inner(n);
    release_str_temps_to(mark);
}

static void
lower_stmt_inner(struct node *n)
{
    struct ir_insn *ins;
    int ltrue, lfalse, lend, ltop, lbrk;

    if (!n)
        return;

    /* Debug info (-g): mark the source line at the head of each statement, once
       per distinct line, so the backend builds an address-to-line table.  A
       compound carries no line of its own; its inner statements each mark
       theirs. */
    if (pascal_debug && n->line > 0 && n->line != last_loc_line
        && n->kind != N_COMPOUND) {
        ir_loc(cur_fn, n->line);
        last_loc_line = n->line;
    }

    switch (n->kind) {
    case N_COMPOUND:
        lower_stmts(n->a);
        return;

    case N_ASSIGN: {
        int val;
        struct sym *s;
        const char *lhs_name;

        /* self-append: x := x + e, where x is a string l-value.  Append e into
           x's buffer in place when possible rather than allocating a fresh
           concatenation and releasing the old value. */
        if (n->b->kind == N_BINOP && n->b->op == T_PLUS &&
            is_string_type(n->a) && same_lvalue(n->a, n->b->a)) {
            lower_self_append(n->a, n->b->b);
            return;
        }

        if (n->a->kind == N_DOT || n->a->kind == N_INDEX) {
            const char *tn = lvalue_type_name(n->a);
            if (tn && is_strlike_type_name(tn)) {
                store_string_lvalue(n->a, lower_str_addr(n->b), str_rvalue_owned(n->b));
                return;
            }
            {
                const char *ptname =
                    lvalue_type_name(n->a->a);
                struct type_def *ptd =
                    ptname ? find_type(ptname) : NULL;
                int elem_i64 = is_i64_type_name(tn);
                int elem_fw = float_fw_of_name(tn);
                int addr;
                /* s[i] := c mutates the buffer in place; make the string a
                   private writable copy first (copy on write). */
                if (n->a->kind == N_INDEX && ptd && ptd->is_string)
                    make_string_unique(n->a->a);
                /* evaluate the r-value before taking the destination address:
                   the r-value may be a call that grows (reallocates) the very
                   array this l-value indexes, which would move its base and
                   leave an address computed first pointing into freed memory. */
                val = lower_expr(n->b);
                addr = lower_lvalue_addr(n->a);
                if (ptd && ptd->is_string)
                    ins = emit(IR_SB);
                else if (elem_fw >= 0) {
                    val = to_float(val, elem_fw);
                    ins = emit(IR_FSD);
                    ins->imm = elem_fw;
                } else if (elem_i64) {
                    val = to_i64(val);
                    ins = emit(IR_ST64);
                } else {
                    val = to_i32(val);
                    ins = emit(IR_SW);
                }
                ins->a = addr;
                ins->b = val;
                return;
            }
        }
        if (n->a->kind != N_NAME)
            die("lower:%d: assignment to non-name", n->line);
        lhs_name = n->a->name;

        /* function return: assignment to function name */
        if (cur_func_name &&
            strcmp(lhs_name, cur_func_name) == 0 &&
            ret_slot >= 0) {
            if (ret_is_str) {
                int src = lower_str_addr(n->b);
                emit_string_store(1, ret_slot, src,
                                  str_rvalue_owned(n->b), ret_type_name);
                return;
            }
            val = lower_expr(n->b);
            if (ret_is_float) {
                val = to_float(val, ret_fw);
                ins = emit(IR_FSTL);
                ins->a = val;
                ins->slot = ret_slot;
                ins->imm = ret_fw;
                return;
            }
            val = ret_is_i64 ? to_i64(val) : to_i32(val);
            ins = emit(ret_is_i64 ? IR_STL64 : IR_STL);
            ins->a = val;
            ins->slot = ret_slot;
            return;
        }

        s = find_sym(lhs_name);
        if (!s) {
            if (nwith > 0) {
                int addr = with_field_addr(lhs_name);
                if (addr >= 0) {
                    val = lower_expr(n->b);
                    ins = emit(IR_SW);
                    ins->a = addr;
                    ins->b = val;
                    return;
                }
            }
            die("lower:%d: undefined '%s'",
                n->line, lhs_name);
        }

        if (s->type_name) {
            struct type_def *td = find_type(s->type_name);
            if (is_strlike_type_name(s->type_name)) {
                store_string_lvalue(n->a, lower_str_addr(n->b), str_rvalue_owned(n->b));
                return;
            }
            if (td && td->is_set) {
                int dst = addr_sym(s);
                int src = lower_expr(n->b);
                emit_block_copy(dst, src, 32);
                return;
            }
            /* a genuine compound (record or fixed array); a scalar type such as
               an enum, subrange or alias stores its value like any ordinal */
            if (td && !td->is_scalar) {
                int dst = addr_sym(s);
                int src = 0;
                if (n->b->kind == N_NAME) {
                    struct sym *rs;
                    rs = find_sym(n->b->name);
                    if (!rs)
                        die("lower:%d: undefined '%s'",
                            n->line, n->b->name);
                    src = addr_sym(rs);
                } else if (n->b->kind == N_DOT ||
                           n->b->kind == N_INDEX) {
                    src = lower_lvalue_addr(n->b);
                } else if (n->b->kind == N_CALL) {
                    /* a function returning a compound by value: the call
                       yields the address of its sret result, whose managed
                       members move into the destination */
                    src = lower_call(n->b);
                    emit_aggregate_move(dst, src, s->type_name,
                                        td->total_size);
                    return;
                } else {
                    die("lower:%d: cannot copy compound "
                        "type from expression",
                        n->line);
                }
                emit_aggregate_copy(dst, src, s->type_name,
                                    td->total_size);
                return;
            }
        }

        val = lower_expr(n->b);
        store_sym(s, val, str_rvalue_owned(n->b));
        return;
    }

    case N_CALL:
        (void)lower_call(n);
        return;

    case N_IF:
        ltrue = new_label();
        lfalse = new_label();
        lend = new_label();
        emit_bnz(lower_expr(n->a), ltrue);
        emit_jmp(lfalse);
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

    case N_WHILE:
        ltop = new_label();
        lbrk = new_label();
        emit_label(ltop);
        {
            /* evaluate the condition, release its string temporaries on both
               the continue and exit paths (before the branch), then test */
            int cm = str_temp_mark();
            int c = lower_expr(n->a);
            release_str_temps_to(cm);
            emit_bz(c, lbrk);
        }
        if (nloops >= 64)
            die("lower: nested loops too deep");
        loops[nloops].brk = lbrk;
        loops[nloops].cont = ltop;
        nloops++;
        lower_stmt(n->b);
        nloops--;
        emit_jmp(ltop);
        emit_label(lbrk);
        return;

    case N_FOR: {
        int ltop_f, lbrk_f, lbody, lcont_f;
        struct sym *s;
        int cmp_tmp, limit_slot;

        s = find_sym(n->name);
        if (!s)
            die("lower:%d: undefined for variable '%s'",
                n->line, n->name);

        /* evaluate limit once and stash in a hidden slot */
        limit_slot = alloc_slot(4);
        {
            int lv = lower_expr(n->b);
            ins = emit(IR_STL);
            ins->a = lv;
            ins->slot = limit_slot;
        }

        /* init: var := start */
        {
            int start = lower_expr(n->a);
            store_sym(s, start, 0);
        }

        ltop_f = new_label();
        lbrk_f = new_label();
        lbody = new_label();
        lcont_f = new_label();
        emit_label(ltop_f);

        /* condition: var <= limit (or >= for downto) */
        {
            int cur_val, limit;
            cur_val = load_sym(s);
            limit = new_temp();
            ins = emit(IR_LDL);
            ins->dst = limit;
            ins->slot = limit_slot;
            if (n->downto) {
                ins = emit(IR_CMPGES);
                ins->dst = new_temp();
                ins->a = cur_val;
                ins->b = limit;
            } else {
                ins = emit(IR_CMPLES);
                ins->dst = new_temp();
                ins->a = cur_val;
                ins->b = limit;
            }
            cmp_tmp = ins->dst;
        }
        emit_bz(cmp_tmp, lbrk_f);
        emit_label(lbody);

        if (nloops >= 64)
            die("lower: nested loops too deep");
        loops[nloops].brk = lbrk_f;
        loops[nloops].cont = lcont_f;
        nloops++;
        lower_stmt(n->c);
        nloops--;

        /* increment/decrement */
        emit_label(lcont_f);
        {
            int cur_val, step, result;
            cur_val = load_sym(s);
            step = lower_const(n->downto ? -1 : 1);
            ins = emit(IR_ADD);
            ins->dst = new_temp();
            ins->a = cur_val;
            ins->b = step;
            result = ins->dst;
            store_sym(s, result, 0);
        }
        emit_jmp(ltop_f);
        emit_label(lbrk_f);
        return;
    }

    case N_REPEAT: {
        int ltop_r, lbrk_r;

        ltop_r = new_label();
        lbrk_r = new_label();
        emit_label(ltop_r);
        if (nloops >= 64)
            die("lower: nested loops too deep");
        loops[nloops].brk = lbrk_r;
        loops[nloops].cont = ltop_r;
        nloops++;
        lower_stmts(n->a);
        nloops--;
        {
            /* release the until-condition's temporaries each iteration */
            int cm = str_temp_mark();
            int c = lower_expr(n->b);
            release_str_temps_to(cm);
            emit_bz(c, ltop_r);
        }
        emit_label(lbrk_r);
        return;
    }

    case N_CASE: {
        struct node *arm, *lab;
        int sel, sel_slot, lend;

        sel = lower_expr(n->a);
        sel_slot = alloc_slot(4);
        ins = emit(IR_STL);
        ins->a = sel;
        ins->slot = sel_slot;
        lend = new_label();

        for (arm = n->b; arm; arm = arm->next) {
            int lbody = new_label();
            int lnext = new_label();

            for (lab = arm->a; lab; lab = lab->next) {
                long start = const_eval(lab->b);
                int sv = new_temp();
                ins = emit(IR_LDL);
                ins->dst = sv;
                ins->slot = sel_slot;
                if (lab->a) {
                    long end = const_eval(lab->a);
                    int cstart, cend;
                    int t1, t2, t3;
                    cstart = lower_const(start);
                    ins = emit(IR_CMPGES);
                    ins->dst = new_temp();
                    ins->a = sv;
                    ins->b = cstart;
                    t1 = ins->dst;
                    sv = new_temp();
                    ins = emit(IR_LDL);
                    ins->dst = sv;
                    ins->slot = sel_slot;
                    cend = lower_const(end);
                    ins = emit(IR_CMPLES);
                    ins->dst = new_temp();
                    ins->a = sv;
                    ins->b = cend;
                    t2 = ins->dst;
                    ins = emit(IR_AND);
                    ins->dst = new_temp();
                    ins->a = t1;
                    ins->b = t2;
                    t3 = ins->dst;
                    emit_bnz(t3, lbody);
                } else {
                    int cstart = lower_const(start);
                    ins = emit(IR_CMPEQ);
                    ins->dst = new_temp();
                    ins->a = sv;
                    ins->b = cstart;
                    emit_bnz(ins->dst, lbody);
                }
            }
            emit_jmp(lnext);
            emit_label(lbody);
            lower_stmt(arm->b);
            emit_jmp(lend);
            emit_label(lnext);
        }
        if (n->c)
            lower_stmt(n->c);
        emit_label(lend);
        return;
    }

    case N_BREAK:
        if (nloops == 0)
            die("lower:%d: break outside loop", n->line);
        emit_jmp(loops[nloops - 1].brk);
        return;

    case N_CONTINUE:
        if (nloops == 0)
            die("lower:%d: continue outside loop", n->line);
        emit_jmp(loops[nloops - 1].cont);
        return;

    case N_WITH: {
        struct node *w;
        int saved_nwith = nwith;
        for (w = n->a; w; w = w->next) {
            const char *tname = lvalue_type_name(w);
            struct type_def *td;
            int base_addr, wslot;
            if (!tname)
                die("lower:%d: with requires a record",
                    n->line);
            td = find_type(tname);
            if (!td || td->is_array)
                die("lower:%d: with requires a record",
                    n->line);
            base_addr = lower_lvalue_addr(w);
            wslot = alloc_slot(PC_PTR_BYTES);
            emit_store_ptr(wslot, base_addr);
            if (nwith >= 16)
                die("lower:%d: too many nested with",
                    n->line);
            with_stack[nwith].base_slot = wslot;
            with_stack[nwith].td = td;
            nwith++;
        }
        lower_stmt(n->b);
        nwith = saved_nwith;
        return;
    }

    default:
        die("lower:%d: unhandled stmt kind %d", n->line, n->kind);
    }
}

/****************************************************************
 * Block lowering (declarations + compound)
 ****************************************************************/

static void
lower_const_section(struct node *consts)
{
    struct node *c;

    for (c = consts; c; c = c->next) {
        if (c->kind == N_TYPEDEF) {
            register_type(c);
            continue;
        }
        struct sym s = {0};
        s.name = c->name;
        s.is_const = 1;
        if (c->a && c->a->kind == N_STR && c->a->slen >= 1) {
            s.const_str = c->a->sval;
            s.const_slen = c->a->slen;
            if (c->a->slen == 1)
                s.const_val = (unsigned char)c->a->sval[0];
            else
                s.type_name = (char *)canonical_string_type_name();
        } else {
            s.const_val = const_eval(c->a);
        }
        push_sym(s);
    }
    /* fixup array bounds and element sizes that couldn't resolve at
       registration (a forward-referenced ordinal index type or element type) */
    for (int i = 0; i < ntypes; i++) {
        struct type_def *t = &types[i];
        if (t->is_array && t->index_type_name) {
            struct type_def *it = resolve_type(t->index_type_name);
            if (!it || !it->is_ordinal)
                die("lower: array index type '%s' is not an ordinal type",
                    t->index_type_name);
            t->lo_bound = it->lo_bound;
            t->hi_bound = it->hi_bound;
        }
        if (t->is_array && t->lo_expr) {
            t->lo_bound = (int)const_eval(t->lo_expr);
            t->hi_bound = (int)const_eval(t->hi_expr);
        }
        if (t->is_array && t->elem_type_name) {
            struct type_def *et = find_type(t->elem_type_name);
            if (et)
                t->elem_size = et->total_size;
        }
        if (t->is_array && !t->is_dynarray)
            t->total_size = (t->hi_bound - t->lo_bound + 1) * t->elem_size;
    }
}

static void
lower_var_section(struct node *vars)
{
    struct node *v;

    for (v = vars; v; v = v->next) {
        struct sym s = {0};
        int sz;
        s.name = v->name;
        s.is_local = 1;
        s.type_name = v->sval;
        sz = type_bytes(v->sval);
        s.slot = alloc_slot(sz);
        push_sym(s);
    }
}

static void
lower_var_inits(struct node *vars)
{
    struct node *v;

    for (v = vars; v; v = v->next) {
        if (!v->a)
            continue;
        struct sym *s = find_sym(v->name);
        if (!s)
            continue;
        if (is_strlike_type_name(s->type_name)) {
            store_sym(s, lower_str_addr(v->a), str_rvalue_owned(v->a));
            continue;
        }
        {
            int val = lower_expr(v->a);
            store_sym(s, val, 0);
        }
    }
}

/****************************************************************
 * Function/procedure lowering
 ****************************************************************/

static struct ir_func *
lower_function(struct node *decl, int is_func,
               char **caps, int ncaps)
{
    struct ir_func *fn, *saved_fn;
    struct ir_insn *ins;
    struct node *p, *d, *block;
    int nparams, saved_nsyms, saved_nslots, saved_slot_cap;
    int *saved_slot_sizes;
    const char *saved_func_name;
    int saved_ret_slot, saved_exit_label, saved_nloops, saved_nwith;
    int saved_ret_is_i64, saved_ret_is_float, saved_ret_fw, saved_ret_is_str;
    int saved_ret_is_compound, saved_ret_ptr_slot;
    const char *saved_ret_type_name;
    const char *ir_name = decl->name;
    int is_sret;

    {
        /* match the sym for THIS declaration, not just the name: overloads
           share a name but each has its own mangled ir_name */
        struct sym *fs = find_func_sym_by_decl(decl);
        if (!fs)
            fs = find_sym(decl->name);
        if (fs && fs->ir_name)
            ir_name = fs->ir_name;
    }

    fn = ir_new_func(lower_arena, ir_name);
    fn->src_file = pascal_debug ? pascal_src_file : NULL;
    last_loc_line = 0;
    saved_fn = cur_fn;
    cur_fn = fn;
    saved_nloops = nloops;
    nloops = 0;
    saved_nwith = nwith;
    nwith = 0;
    saved_func_name = cur_func_name;
    saved_ret_slot = ret_slot;
    saved_ret_is_i64 = ret_is_i64;
    saved_ret_is_float = ret_is_float;
    saved_ret_fw = ret_fw;
    saved_ret_is_str = ret_is_str;
    saved_ret_is_compound = ret_is_compound;
    saved_ret_ptr_slot = ret_ptr_slot;
    saved_ret_type_name = ret_type_name;
    saved_exit_label = exit_label;
    exit_label = new_label();

    saved_nsyms = nsyms;
    /* Isolate this function's slot allocation.  A nested procedure is lowered
       while its parent's slots are live, and it shares the slot_sizes array;
       without a fresh array it would overwrite the parent's slot sizes and
       corrupt the parent's frame layout.  Save the array, start empty, and
       restore it after copying this function's sizes out. */
    saved_slot_sizes = slot_sizes;
    saved_nslots = nslots;
    saved_slot_cap = slot_cap;
    slot_sizes = NULL;
    nslots = 0;
    slot_cap = 0;

    nparams = 0;

    /* Per-parameter float classification (0 integer/pointer, 1 float) and the
       single-precision flag, filled as params are built and threaded to the
       backend below only if any parameter is a real. */
    signed char pfcls[64] = {0};
    signed char pffw[64] = {0};
    int any_float_param = 0;

    /* hidden sret parameter (passed as a pointer, before every other
       argument): the caller's address for a record or array returned by
       value.  The callee writes its result through this pointer. */
    is_sret = is_func && type_is_sret(decl->sval);
    if (is_sret) {
        ret_ptr_slot = alloc_slot(PC_PTR_BYTES);
        nparams++;
    } else {
        ret_ptr_slot = -1;
    }

    /* hidden capture parameters (passed as pointers) */
    for (int i = 0; i < ncaps; i++) {
        struct sym s = {0};
        s.name = caps[i];
        s.is_local = 1;
        s.is_var_param = 1;
        s.slot = alloc_slot(PC_PTR_BYTES);
        push_sym(s);
        nparams++;
    }

    for (p = decl->a; p; p = p->next) {
        struct sym s = {0};
        int is_compound = 0;
        int receives_addr;
        int pfw;
        s.name = p->name;
        s.is_local = 1;
        s.type_name = p->sval;
        /* A string is a pointer scalar, and an enum/subrange/alias is an
           ordinal scalar: neither is a compound passed by address. */
        if (p->sval && find_type(p->sval) && !is_strlike_type_name(p->sval) &&
            !(resolve_type(p->sval) && resolve_type(p->sval)->is_scalar))
            is_compound = 1;
        if (p->op == 1)
            s.is_var_param = 1;
        else if (p->op == 2 && is_compound)
            s.is_var_param = 1;
        /* The caller passes an address for a `var` parameter or any
           compound-typed parameter (see the pass_addr rule in lower_call),
           so the incoming slot is pointer-sized.  A compound value parameter
           arrives as an address and is copied to a local below. */
        receives_addr = (p->op == 1) || is_compound;
        pfw = (!receives_addr) ? float_fw_of_name(p->sval) : -1;
        if (pfw >= 0) {
            /* A real passed by value rides a float register; its home slot is
               8 bytes (single or double), as in the C front end. */
            s.slot = alloc_slot(8);
            if (nparams < 64) {
                pfcls[nparams] = 1;
                pffw[nparams] = (pfw == FWIDTH_F32) ? 1 : 0;
            }
            any_float_param = 1;
        } else {
            s.slot = alloc_slot(receives_addr ? PC_PTR_BYTES
                                              : type_bytes(p->sval));
        }
        push_sym(s);
        nparams++;
    }
    fn->nparams = nparams;

    /* Thread the float parameter classes to the register ABI.  Only needed when
       a real parameter exists; integer and pointer params default to class 0. */
    if (any_float_param && nparams <= 64) {
        fn->param_class = arena_zalloc(lower_arena, nparams * sizeof(int));
        fn->param_neb = arena_zalloc(lower_arena, nparams * sizeof(signed char));
        fn->param_cls = arena_zalloc(lower_arena,
                                     4 * nparams * sizeof(signed char));
        fn->param_fw = arena_zalloc(lower_arena, nparams * sizeof(signed char));
        for (int i = 0; i < nparams; i++) {
            fn->param_neb[i] = 1;
            fn->param_class[i] = pfcls[i];
            fn->param_cls[4 * i] = pfcls[i];
            fn->param_cls[4 * i + 1] = -1;
            fn->param_cls[4 * i + 2] = -1;
            fn->param_cls[4 * i + 3] = -1;
            fn->param_fw[i] = pffw[i];
        }
    }

    /* function return value slot */
    if (is_func) {
        cur_func_name = decl->name;
        ret_is_compound = is_sret;
        ret_is_i64 = is_i64_type_name(decl->sval);
        ret_fw = float_fw_of_name(decl->sval);
        ret_is_float = ret_fw >= 0;
        ret_is_str = is_strlike_type_name(decl->sval);
        ret_type_name = decl->sval;
        /* a compound result lives in the caller via ret_ptr_slot; only a
           scalar/string result needs its own home slot */
        ret_slot = is_sret ? -1 : alloc_slot(type_bytes(decl->sval));
    } else {
        cur_func_name = NULL;
        ret_is_compound = 0;
        ret_is_i64 = 0;
        ret_is_float = 0;
        ret_is_str = 0;
        ret_type_name = NULL;
        ret_slot = -1;
    }

    block = decl->b;
    if (block && block->kind == N_BLOCK) {
        lower_const_section(block->a);
        lower_var_section(block->b);

        /* register nested procedures in symbol table */
        for (d = block->c; d; d = d->next) {
            struct sym s = {0};
            char mangled[256];
            char *ncap[32];
            int nc;

            snprintf(mangled, sizeof(mangled), "%s__%s",
                     ir_name, d->name);
            s.name = d->name;
            s.is_func = 1;
            s.decl = d;
            s.ir_name = arena_strdup(lower_arena, mangled);

            nc = find_captures(d, saved_nsyms, ncap, 32);
            if (nc > 0) {
                s.ncaptures = nc;
                s.captures = arena_alloc(lower_arena, nc * sizeof(char *));
                for (int i = 0; i < nc; i++)
                    s.captures[i] = ncap[i];
            }
            push_sym(s);
        }

        /* lower nested procedures */
        for (d = block->c; d; d = d->next) {
            struct ir_func *nfn;
            struct sym *fs;

            if (d->is_forward || d->is_external)
                continue;
            fs = find_sym(d->name);
            nfn = lower_function(d,
                                 d->kind == N_FUNCDECL,
                                 fs->captures,
                                 fs->ncaptures);
            *nested_ftail = nfn;
            nested_ftail = &nfn->next;
        }
    }

    reset_ptr_flags();
    ins = emit(IR_FUNC);
    ins->sym = arena_strdup(lower_arena,ir_name);
    ins->nargs = nparams;

    /* init return slot to 0 (a compound result is pre-initialized by the
       caller through the sret pointer, so it has no local slot to clear) */
    if (is_func && !ret_is_compound) {
        if (ret_is_float) {
            int zero = lower_real_const(0.0, ret_fw);
            ins = emit(IR_FSTL);
            ins->a = zero;
            ins->slot = ret_slot;
            ins->imm = ret_fw;
        } else if (ret_is_str) {
            emit_store_ptr(ret_slot, emit_null_ptr());
        } else {
            int zero = ret_is_i64 ? lower_const64(0) : lower_const(0);
            ins = emit(ret_is_i64 ? IR_STL64 : IR_STL);
            ins->a = zero;
            ins->slot = ret_slot;
        }
    }

    /* string value parameters: the slot holds the caller's pointer by value.
       Retain it so the callee owns its own reference, which matches value
       semantics (the callee's mutations never reach the caller) and lets an
       assignment release the previous value safely.  The reference is dropped
       again on scope exit, below. */
    for (p = decl->a; p; p = p->next) {
        if (p->op != 0 || !p->sval)
            continue;
        if (is_strlike_type_name(p->sval)) {
            struct sym *ps = find_sym(p->name);
            int cur;
            if (!ps)
                continue;
            cur = emit_load_ptr(ps->slot);
            emit_store_ptr(ps->slot,
                           emit_call_retptr("__pascal_str_retain",
                                            &cur, 1));
        }
    }

    /* compound value params: copy from caller address to local slot. */
    for (p = decl->a; p; p = p->next) {
        struct type_def *td;
        if (p->op != 0 || !p->sval)
            continue;
        td = find_type(p->sval);
        /* a string or dynamic array is a pointer scalar handled by the retain
           loop above, and an enum/subrange/alias is an ordinal scalar passed
           by value: neither is a by-address compound to copy here. */
        if (!td || is_strlike_type_name(p->sval) ||
            (resolve_type(p->sval) && resolve_type(p->sval)->is_scalar))
            continue;
        {
            struct sym *ps = find_sym(p->name);
            int param_slot = ps->slot;
            int copy_slot = alloc_slot(td->total_size);
            int src_addr, dst_addr;
            src_addr = emit_load_ptr(param_slot);
            dst_addr = emit_adl(copy_slot);
            emit_block_copy(dst_addr, src_addr, td->total_size);
            /* the callee's copy shares the caller's managed members; retain
               them so it owns a reference, released again on scope exit */
            if (type_has_managed(p->sval))
                emit_managed_walk(dst_addr, p->sval, MGD_RETAIN);
            ps->slot = copy_slot;
            ps->is_var_param = 0;
        }
    }

    /* null-init managed locals so an unassigned string reads as '' (a NULL
       pointer) and a record or array's string members start empty rather than
       as garbage pointers that scope-exit release would follow. */
    if (block && block->b)
        for (struct node *vv = block->b; vv; vv = vv->next) {
            struct sym *vs;
            if (is_strlike_type_name(vv->sval)) {
                vs = find_sym(vv->name);
                if (vs)
                    emit_store_ptr(vs->slot, emit_null_ptr());
            } else if (type_has_managed(vv->sval)) {
                vs = find_sym(vv->name);
                if (vs)
                    emit_managed_walk(emit_adl(vs->slot), vv->sval, MGD_NULL);
            }
        }

    if (block && block->b) {
        int m = str_temp_mark();
        lower_var_inits(block->b);
        release_str_temps_to(m);
    }

    /* reset again: a nested function lowered above shares last_loc_line, so
       the body must start fresh to mark its first statement's line (-g). */
    last_loc_line = 0;
    if (block && block->d)
        lower_stmt(block->d);

    emit_label(exit_label);

    /* Release managed string locals and retained string value parameters on
       the way out; every exit path (fall-through or Exit) jumps here.  The
       result slot is excluded: a string function result's reference belongs
       to the caller.  Halt leaves through libc exit instead and does not run
       these, which only matters to a leak checker, not to correctness. */
    for (p = decl->a; p; p = p->next) {
        struct sym *ps;
        if (p->op != 0 || !p->sval)
            continue;
        if (is_strlike_type_name(p->sval)) {
            int cur;
            ps = find_sym(p->name);
            if (!ps)
                continue;
            cur = emit_load_ptr(ps->slot);
            emit_strlike_release(cur, p->sval);
        } else if (type_has_managed(p->sval)) {
            /* a record or array value parameter, retained on entry */
            ps = find_sym(p->name);
            if (ps)
                emit_managed_walk(emit_adl(ps->slot), p->sval, MGD_RELEASE);
        }
    }
    if (block && block->b)
        for (struct node *vv = block->b; vv; vv = vv->next) {
            struct sym *vs;
            if (is_strlike_type_name(vv->sval)) {
                int cur;
                vs = find_sym(vv->name);
                if (!vs)
                    continue;
                cur = emit_load_ptr(vs->slot);
                emit_strlike_release(cur, vv->sval);
            } else if (type_has_managed(vv->sval)) {
                /* a record or array local with managed members */
                vs = find_sym(vv->name);
                if (vs)
                    emit_managed_walk(emit_adl(vs->slot), vv->sval, MGD_RELEASE);
            }
        }

    /* emit return */
    if (is_func && ret_is_compound) {
        /* the result was written through the sret pointer; the caller holds
           the destination address, so no value is returned in a register */
        emit(IR_RET);
    } else if (is_func) {
        int rv = new_temp();
        if (ret_is_float) {
            ins = emit(IR_FLDL);
            ins->dst = rv;
            ins->slot = ret_slot;
            ins->imm = ret_fw;
            mark_float(rv, ret_fw);
            ins = emit(IR_FRETV);
            ins->a = rv;
            ins->imm = ret_fw;
        } else if (ret_is_str) {
            /* a heap string result is a pointer: return it at pointer width */
            rv = emit_load_ptr(ret_slot);
            ins = emit(PC_LP64_ON ? IR_RETV64 : IR_RETV);
            ins->a = rv;
        } else {
            ins = emit(ret_is_i64 ? IR_LDL64 : IR_LDL);
            ins->dst = rv;
            ins->slot = ret_slot;
            if (ret_is_i64)
                mark_i64(rv);
            ins = emit(ret_is_i64 ? IR_RETV64 : IR_RETV);
            ins->a = rv;
        }
    } else {
        emit(IR_RET);
    }

    emit(IR_ENDF);

    fn->nslots = nslots;
    fn->slot_size = arena_alloc(lower_arena, nslots * sizeof(int));
    if (nslots)
        memcpy(fn->slot_size, slot_sizes, nslots * sizeof(int));

    free(slot_sizes);
    slot_sizes = saved_slot_sizes;
    slot_cap = saved_slot_cap;
    nsyms = saved_nsyms;
    nslots = saved_nslots;
    cur_fn = saved_fn;
    cur_func_name = saved_func_name;
    ret_slot = saved_ret_slot;
    ret_is_i64 = saved_ret_is_i64;
    ret_is_float = saved_ret_is_float;
    ret_fw = saved_ret_fw;
    ret_is_str = saved_ret_is_str;
    ret_is_compound = saved_ret_is_compound;
    ret_ptr_slot = saved_ret_ptr_slot;
    ret_type_name = saved_ret_type_name;
    exit_label = saved_exit_label;
    nloops = saved_nloops;
    nwith = saved_nwith;

    return fn;
}

/****************************************************************
 * Entry point
 ****************************************************************/

struct ir_program *
lower_program(struct arena *a, struct node *ast)
{
    struct ir_program *prog;
    struct ir_func *fn, **ftail;
    struct node *block, *d;
    struct ir_insn *ins;
    int nparams;

    lower_arena = a;
    prog = arena_zalloc(lower_arena, sizeof(*prog));
    cur_prog = prog;
    nsyms = 0;
    ntypes = 0;
    strctr = 0;
    /* Reset the per-compile lowering state a prior die() longjmp may have left
       non-zero: a nonzero nwith leaves with_stack holding type_def pointers
       into a previous compile's freed types array, which the next compile's
       with_field_addr would then dereference. */
    nwith = 0;
    nloops = 0;
    nelem_fns = 0;
    gen_funcs = NULL;
    gen_ftail = &gen_funcs;

    if (!ast || ast->kind != N_PROGRAM)
        die("lower: expected program node");

    block = ast->a;
    if (!block || block->kind != N_BLOCK)
        die("lower: expected block node");

    /* register global constants */
    lower_const_section(block->a);

    /* register global variables as IR globals */
    for (d = block->b; d; d = d->next) {
        struct ir_global *g;
        struct sym s = {0};
        struct type_def *vtd = NULL;

        g = arena_zalloc(lower_arena, sizeof(*g));
        g->name = arena_strdup(lower_arena, d->name);
        g->base_type = IR_I32;
        {
            int gfw = d->sval ? float_fw_of_name(d->sval) : -1;
            if (gfw == FWIDTH_F32) {
                g->base_type = IR_F32;
            } else if (gfw == 0) {
                g->base_type = IR_F64;
            } else if (d->sval) {
                vtd = find_type(d->sval);
                if (vtd)
                    g->arr_size = vtd->total_size / 4;
                else if (is_i64_type_name(d->sval))
                    g->arr_size = 2;    /* 8 bytes, two i32 words */
            }
        }
        if (vtd && vtd->is_set) {
            g->base_type = IR_I8;
            g->arr_size = 32;
            if (d->a && d->a->kind == N_SET) {
                unsigned char setbuf[32] = {0};
                for (struct node *e = d->a->a; e;
                     e = e->next) {
                    if (e->kind == N_SETRANGE) {
                        int lo = (int)const_eval(e->a);
                        int hi = (int)const_eval(e->b);
                        for (int k = lo; k <= hi; k++)
                            if (k >= 0 && k <= 255)
                                setbuf[k >> 3] |=
                                    (1 << (k & 7));
                    } else {
                        int v = (int)const_eval(e);
                        if (v >= 0 && v <= 255)
                            setbuf[v >> 3] |=
                                (1 << (v & 7));
                    }
                }
                g->init_ivals = arena_zalloc(lower_arena, 32 *
                    sizeof(*g->init_ivals));
                for (int k = 0; k < 32; k++)
                    g->init_ivals[k] = setbuf[k];
                g->init_count = 32;
            }
            g->next = prog->globals;
            prog->globals = g;
            s.name = d->name;
            s.is_local = 0;
            s.type_name = d->sval;
            push_sym(s);
            continue;
        }
        if (vtd && vtd->is_dynarray) {
            /* a dynamic array global is a single pointer word, NULL (the empty
               array) until SetLength or assignment gives it a descriptor. */
            g->base_type = PC_LP64_ON ? IR_I64 : IR_I32;
            g->is_ptr = 1;
            g->arr_size = 1;
            g->init_ivals = NULL;
            g->init_count = 0;
            g->next = prog->globals;
            prog->globals = g;
            s.name = d->name;
            s.is_local = 0;
            s.type_name = d->sval;
            push_sym(s);
            continue;
        }
        if (vtd && vtd->is_string) {
            /* a heap string global is a single pointer word, NULL (the empty
               string) unless initialized with a literal, in which case it
               points at a static strobj object. */
            g->base_type = PC_LP64_ON ? IR_I64 : IR_I32;
            g->is_ptr = 1;
            g->arr_size = 1;
            g->init_ivals = NULL;
            g->init_count = 0;
            if (d->a && d->a->kind == N_STR) {
                struct ir_global *lit = arena_zalloc(lower_arena,
                                                     sizeof(*lit));
                char litname[32];
                int slen = d->a->slen;
                snprintf(litname, sizeof(litname), "__str_%d", strctr++);
                lit->name = arena_strdup(lower_arena, litname);
                lit->base_type = IR_I8;
                lit->is_local = 1;
                lit->is_rodata = 1;
                lit->is_strobj = 1;
                lit->init_string = arena_alloc(lower_arena,
                                               slen ? slen : 1);
                if (slen)
                    memcpy(lit->init_string, d->a->sval, slen);
                lit->init_strlen = slen;
                lit->next = prog->globals;
                prog->globals = lit;
                g->init_syms = arena_zalloc(lower_arena,
                                            sizeof(char *));
                g->init_syms[0] = arena_strdup(lower_arena, litname);
                g->init_ivals = arena_zalloc(lower_arena,
                                             sizeof(*g->init_ivals));
                g->init_ivals[0] = 0;
                g->init_count = 1;
            }
        } else if (d->a && d->a->kind == N_INITLIST &&
                   vtd && type_has_managed(d->sval)) {
            /* an array or record constant with string members: a relocatable
               byte image whose string slots point at static strobj literals */
            struct ir_init **itail = &g->inits;
            build_const_image(d->a, d->sval, 0, &itail, d->line);
            g->base_type = IR_I8;
            g->arr_size = vtd->total_size;
        } else if (d->a && d->a->kind == N_INITLIST) {
            int cnt = count_init_list(d->a);
            int pos = 0;
            g->init_ivals = arena_zalloc(lower_arena, cnt * sizeof(*g->init_ivals));
            flatten_init_list(d->a, g->init_ivals, &pos);
            g->init_count = cnt;
        } else if (d->a && d->a->kind == N_STR &&
                   d->a->slen > 1) {
            int slen = d->a->slen;
            g->init_ivals = arena_zalloc(lower_arena, slen * sizeof(*g->init_ivals));
            for (int i = 0; i < slen; i++)
                g->init_ivals[i] =
                    (unsigned char)d->a->sval[i];
            g->init_count = slen;
        } else if (d->a && is_float_type_name(d->sval)) {
            double dv = d->a->kind == N_REAL ? d->a->fval
                                             : (double)const_eval(d->a);
            g->init_ivals = arena_zalloc(lower_arena, sizeof(*g->init_ivals));
            if (float_fw_of_name(d->sval) == FWIDTH_F32) {
                union { float f; int32_t i; } u;
                u.f = (float)dv;
                g->init_ivals[0] = u.i;
            } else {
                union { double d; int64_t i; } u;
                u.d = dv;
                g->init_ivals[0] = u.i;
            }
            g->init_count = 1;
        } else if (d->a && is_i64_type_name(d->sval)) {
            long long v = const_eval(d->a);
            g->init_ivals = arena_zalloc(lower_arena, 2 * sizeof(*g->init_ivals));
            g->init_ivals[0] = (int)(v & 0xFFFFFFFF);
            g->init_ivals[1] = (int)((v >> 32) & 0xFFFFFFFF);
            g->init_count = 2;
        } else if (d->a) {
            g->init_ivals = arena_zalloc(lower_arena, 1 * sizeof(*g->init_ivals));
            g->init_ivals[0] = const_eval(d->a);
            g->init_count = 1;
        }
        /* On LP64 a record or array global holding a managed string member must
           be pointer-aligned so the member sits on a natural 8-byte boundary.
           Besides correctness this lets a conservative leak checker see the
           heap pointer as a root, since such a global is never released. */
        if (PC_LP64_ON && vtd && type_has_managed(d->sval) &&
            g->align < PC_PTR_BYTES)
            g->align = PC_PTR_BYTES;
        g->next = prog->globals;
        prog->globals = g;

        s.name = d->name;
        s.is_local = 0;
        s.type_name = d->sval;
        push_sym(s);
    }

    /* register all procedures/functions in symbol table, giving an overloaded
       name a distinct mangled ir_name per signature */
    for (d = block->c; d; d = d->next) {
        struct sym s = {0};
        s.name = d->name;
        s.is_func = 1;
        s.decl = d;
        if (d->is_external)
            /* a host import links by its exact source spelling, not lowercased
               or overload-mangled (the C runtime exports e.g. ReadFileStr) */
            s.ir_name = d->raw_name ? d->raw_name : d->name;
        else
            s.ir_name = overload_ir_name(d, block->c);
        push_sym(s);
    }

    ftail = &prog->funcs;
    nested_funcs = NULL;
    nested_ftail = &nested_funcs;

    /* lower each procedure/function */
    for (d = block->c; d; d = d->next) {
        if (d->is_forward || d->is_external)
            continue;       /* no body: a forward or a host import */
        fn = lower_function(d, d->kind == N_FUNCDECL,
                            NULL, 0);
        *ftail = fn;
        ftail = &fn->next;
    }

    /* chain nested functions */
    *ftail = nested_funcs;
    while (*ftail)
        ftail = &(*ftail)->next;

    /* lower main block as "main" function */
    {
        struct ir_func *main_fn;

        main_fn = ir_new_func(lower_arena, "main");
        main_fn->src_file = pascal_debug ? pascal_src_file : NULL;
        last_loc_line = 0;
        cur_fn = main_fn;
        nloops = 0;
        nslots = 0;
        nparams = 0;
        cur_func_name = NULL;
        ret_slot = -1;

        /* main block may have its own locals (though unusual) */
        sym_base = nsyms;

        /* main(argc, argv): two incoming argument slots so the program can read
           the command line (ParamStr/ParamCount).  A freestanding host that
           passes none leaves them unused. */
        {
            int argc_slot = alloc_slot(4);
            int argv_slot = alloc_slot(PC_PTR_BYTES);
            nparams = 2;
            reset_ptr_flags();
            ins = emit(IR_FUNC);
            ins->sym = arena_strdup(lower_arena, "main");
            ins->nargs = 2;
            {
                int sargs[2];
                struct ir_insn *ld = emit(IR_LDL);
                ld->dst = new_temp();
                ld->slot = argc_slot;
                sargs[0] = ld->dst;
                sargs[1] = emit_load_ptr(argv_slot);
                emit_call("__pascal_set_args", sargs, 2);
            }
        }

        if (block->d)
            lower_stmt(block->d);

        /* implicit exit(0) */
        {
            int args[1];
            args[0] = lower_const(0);
            emit_call("exit", args, 1);
        }
        {
            int z = lower_const(0);
            ins = emit(IR_RETV);
            ins->a = z;
        }
        emit(IR_ENDF);

        main_fn->nparams = nparams;
        main_fn->nslots = nslots;
        if (nslots > 0) {
            main_fn->slot_size = arena_alloc(lower_arena, nslots * sizeof(int));
            memcpy(main_fn->slot_size, slot_sizes,
                   nslots * sizeof(int));
        }

        *ftail = main_fn;
        ftail = &main_fn->next;
    }

    /* append element finalize/retain functions generated for arrays of managed
       elements (all produced during the lowering above) */
    *ftail = gen_funcs;

    free(syms);
    syms = NULL;
    nsyms = sym_cap = 0;

    free(slot_sizes);
    slot_sizes = NULL;
    nslots = slot_cap = 0;

    free(types);
    types = NULL;
    ntypes = type_cap = 0;

    return prog;
}
