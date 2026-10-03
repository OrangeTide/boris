/* ir.c : IR construction helpers */

#include "ir.h"

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
