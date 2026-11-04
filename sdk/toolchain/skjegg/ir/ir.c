/* ir.c : IR construction helpers */

#include "ir.h"

/* The AOT overflow-trap policy (see ir.h).  Hardware by default; a trapping front
   end's driver raises it before target_emit. */
int target_aot_trap_guarded = 0;

struct ir_func *
ir_new_func(struct arena *a, const char *name)
{
    struct ir_func *fn;

    fn = arena_zalloc(a, sizeof(*fn));
    fn->arena = a;
    fn->name = arena_strdup(a, name);
    return fn;
}

int
ir_new_temp(struct ir_func *fn)
{
    return fn->ntemps++;
}

/* A source-line marker for debug info (-g): no code, no value, the line in
   imm.  The source file is on fn->src_file. */
struct ir_insn *
ir_loc(struct ir_func *fn, int line)
{
    struct ir_insn *i = ir_emit(fn, IR_LOC);
    i->imm = line;
    return i;
}

int
ir_new_label(struct ir_func *fn)
{
    return fn->nlabels++;
}

int
ir_op_is_float_def(int op)
{
    switch (op) {
    case IR_FADD: case IR_FSUB: case IR_FMUL: case IR_FDIV:
    case IR_FNEG: case IR_FABS: case IR_FSQRT:
    case IR_ITOF:
    case IR_F32TOF64: case IR_F64TOF32:
    case IR_FLS: case IR_FLD:
    case IR_FLH:
    case IR_FLDL:
    case IR_FCALL: case IR_FCALLI:
        return 1;
    default:
        return 0;
    }
}

/* Classify each float temp's register storage format: out[t] = 1 when temp t
   holds f32 (single) format, 0 when f64.  The two front ends differ: the C front
   end keeps `float` values as f32 in registers (every non-boundary float op on
   them carries FWIDTH_F32), while the Kobold front end keeps every float as f64
   and marks only the call-boundary ops (FARG/FCALL/FRETV) with the f32 wire
   width.  The register format is therefore read from the non-boundary float ops
   that touch a temp, never from the boundary markers: a temp is f32 only when some
   non-boundary op treats it as single and none treats it as double.  A temp seen
   only by boundary ops defaults to f64, so a backend widens an f32 call result to
   f64 and narrows it back, which is the identity for a pass-through value.  `out`
   must have room for fn->ntemps entries; it is fully written. */
void
ir_classify_f32(struct ir_func *fn, unsigned char *out)
{
    struct ir_insn *in;
    int n = fn->ntemps, t;

    /* Accumulate two markers per temp inside out itself: bit 0 = seen as f32, bit
       1 = seen as f64.  This needs no scratch allocation, keeping the IR core free
       of the heap (it builds everything through the arena). */
    for (t = 0; t < n; t++)
        out[t] = 0;

#define MARK(t, f32) do { \
        int t_ = (t); \
        if (t_ >= 0 && t_ < n) out[t_] |= (unsigned char)((f32) ? 1 : 2); \
    } while (0)

    for (in = fn->head; in; in = in->next) {
        int w32 = in->imm == FWIDTH_F32;
        switch (in->op) {
        case IR_FADD: case IR_FSUB: case IR_FMUL: case IR_FDIV:
            MARK(in->dst, w32); MARK(in->a, w32); MARK(in->b, w32);
            break;
        case IR_FCMPEQ: case IR_FCMPLT: case IR_FCMPLE:
            MARK(in->a, w32); MARK(in->b, w32);     /* dst is an int flag */
            break;
        case IR_FNEG: case IR_FABS: case IR_FSQRT:
            MARK(in->dst, w32); MARK(in->a, w32);
            break;
        case IR_FLDL:
            MARK(in->dst, w32);
            break;
        case IR_FSTL:
            MARK(in->a, w32);                       /* a is the float value */
            break;
        case IR_ITOF:
            MARK(in->dst, w32);                     /* a is an int */
            break;
        case IR_FTOI: case IR_FROUND:
            MARK(in->a, w32);                       /* dst is an int */
            break;
        case IR_F64TOF32:
            MARK(in->dst, 1); MARK(in->a, 0);
            break;
        case IR_F32TOF64:
            MARK(in->dst, 0); MARK(in->a, 1);
            break;
        case IR_FLD:
            MARK(in->dst, w32);                      /* load float, width from imm */
            break;
        case IR_FSD:
            MARK(in->b, w32);                        /* store float value b, width from imm */
            break;
        case IR_FLS: case IR_FLH:
            MARK(in->dst, 0);                        /* load single/half, widened to f64 */
            break;
        case IR_FSS: case IR_FSH:
            MARK(in->b, 0);                          /* b is the f64 value, narrowed */
            break;
        /* FARG, FRETV, FCALL, FCALLI carry the ABI wire width, not the register
           format, so they do not determine a temp's format. */
        default:
            break;
        }
    }

#undef MARK

    /* f32 format only when a non-boundary op saw the temp as single (bit 0) and
       none saw it as double (bit 1): markers 1, never 3. */
    for (t = 0; t < n; t++)
        out[t] = (unsigned char)(out[t] == 1);
}

int
ir_op_is_i64_def(int op)
{
    switch (op) {
    case IR_LIC64:
    case IR_ADD64: case IR_SUB64: case IR_MUL64:
    case IR_DIVS64: case IR_DIVU64: case IR_MODS64: case IR_MODU64:
    case IR_AND64: case IR_OR64: case IR_XOR64:
    case IR_SHL64: case IR_SHRS64: case IR_SHRU64:
    case IR_NEG64:
    case IR_LD64:
    case IR_LDL64:
    case IR_LEA64: case IR_ADL64:
    case IR_SEXT64: case IR_ZEXT64:
    case IR_CALL64: case IR_CALLI64:
        return 1;
    default:
        return 0;
    }
}

struct ir_insn *
ir_emit(struct ir_func *fn, int op)
{
    struct ir_insn *i;

    i = arena_zalloc(fn->arena, sizeof(*i));
    i->op = op;
    i->dst = -1;
    i->a = -1;
    i->b = -1;
    i->slot = -1;
    i->label = -1;
    if (!fn->head)
        fn->head = i;
    else
        fn->tail->next = i;
    fn->tail = i;
    return i;
}
