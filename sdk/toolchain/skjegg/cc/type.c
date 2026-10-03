/* type.c : C type system helpers */

#include "cc.h"

#include "arena.h"

#include <string.h>

static struct cc_type ty_void_s  = { .kind = TY_VOID };
static struct cc_type ty_char_s  = { .kind = TY_CHAR };
static struct cc_type ty_int_s   = { .kind = TY_INT };
static struct cc_type ty_long_s  = { .kind = TY_LONG };
static struct cc_type ty_llong_s = { .kind = TY_LONG_LONG };

struct cc_type *
cc_type_void(void)
{
    return &ty_void_s;
}

struct cc_type *
cc_type_char(void)
{
    return &ty_char_s;
}

struct cc_type *
cc_type_int(void)
{
    return &ty_int_s;
}

struct cc_type *
cc_type_long(void)
{
    return &ty_long_s;
}

struct cc_type *
cc_type_long_long(void)
{
    return &ty_llong_s;
}

struct cc_type *
cc_type_ptr(struct arena *a, struct cc_type *base)
{
    struct cc_type *t = arena_zalloc(a, sizeof *t);
    t->kind = TY_PTR;
    t->base = base;
    return t;
}

struct cc_type *
cc_type_array(struct arena *a, struct cc_type *base, int len)
{
    struct cc_type *t = arena_zalloc(a, sizeof *t);
    t->kind = TY_ARRAY;
    t->base = base;
    t->array_len = len;
    return t;
}

struct cc_type *
cc_type_func(struct arena *a, struct cc_type *ret)
{
    struct cc_type *t = arena_zalloc(a, sizeof *t);
    t->kind = TY_FUNC;
    t->base = ret;
    return t;
}

int
cc_type_size(struct cc_type *t)
{
    if (!t)
        return 4;
    switch (t->kind) {
    case TY_VOID:   return 1;
    case TY_CHAR:   return 1;
    case TY_SHORT:  return 2;
    case TY_INT:    return 4;
    case TY_LONG:      return CC_LONG_SIZE;
    case TY_LONG_LONG: return 8;
    case TY_FLOAT16: return 2;
    case TY_FLOAT:  return 4;
    case TY_DOUBLE: return 8;
#ifdef CC_M68K
    case TY_LDOUBLE: return 12;      /* m68k 80-bit extended in 96 bits */
#else
    case TY_LDOUBLE: return 16;      /* x86-64/arm64/rv64 (16-byte ABI slot);
                                        value operations are rejected in
                                        lowering, so this only sizes sizeof */
#endif
    case TY_PTR:    return CC_PTR_SIZE;
    case TY_ARRAY:  return cc_type_size(t->base) * t->array_len;
    case TY_ENUM:   return 4;
    case TY_STRUCT:
    case TY_UNION:
        return t->size;
    case TY_FUNC:   return CC_PTR_SIZE;
    }
    return 4;
}

int
cc_type_align(struct cc_type *t)
{
    if (!t)
        return 4;
    switch (t->kind) {
    case TY_VOID:      return 1;
    case TY_CHAR:      return 1;
    case TY_SHORT:     return 2;
    case TY_INT:       return 4;
    case TY_LONG:      return CC_LONG_SIZE;
    /* 8-byte types are 8-aligned in a struct, matching the RV32 psABI and the
       64-bit targets (arm64, rv64, x86-64) so an fld/fsd on a double field is
       never misaligned.  See the ABI-compatibility note in PLAN.md. */
    case TY_LONG_LONG: return 8;
    case TY_FLOAT16:   return 2;
    case TY_FLOAT:     return 4;
    case TY_DOUBLE:    return 8;
#ifdef CC_M68K
    case TY_LDOUBLE:   return 4;
#else
    case TY_LDOUBLE:   return 16;
#endif
    case TY_PTR:    return CC_PTR_SIZE;
    case TY_ARRAY:  return cc_type_align(t->base);
    case TY_ENUM:   return 4;
    case TY_STRUCT:
    case TY_UNION:
        return t->align;
    case TY_FUNC:   return CC_PTR_SIZE;
    }
    return 4;
}

int
cc_type_is_integer(struct cc_type *t)
{
    return t->kind >= TY_CHAR && t->kind <= TY_LONG_LONG;
}

int
cc_type_is_arith(struct cc_type *t)
{
    return cc_type_is_integer(t) ||
           t->kind == TY_FLOAT16 ||
           t->kind == TY_FLOAT || t->kind == TY_DOUBLE ||
           t->kind == TY_ENUM;
}

int
cc_type_is_ptr(struct cc_type *t)
{
    return t->kind == TY_PTR || t->kind == TY_ARRAY;
}

int
cc_type_is_scalar(struct cc_type *t)
{
    return cc_type_is_arith(t) || cc_type_is_ptr(t);
}
