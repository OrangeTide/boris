/* cond.c : conditional directives and #if expression evaluator */

#include "internal.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

void
cond_push(struct cpp *p, int active)
{
    struct cpp_cond *c = xmalloc(sizeof *c);
    c->active = active && cond_active(p);
    c->seen_true = active;
    c->is_else = 0;
    c->up = p->cond;
    p->cond = c;
}

void
cond_pop(struct cpp *p)
{
    if (!p->cond) {
        cpp_error(p, "unmatched #endif");
        return;
    }
    struct cpp_cond *c = p->cond;
    p->cond = c->up;
    free(c);
}

int
cond_active(struct cpp *p)
{
    if (!p->cond)
        return 1;
    return p->cond->active;
}

/* Expression evaluator — recursive descent */

struct eval_ctx {
    struct cpp *cpp;
    struct pp_token *cur;
};

static void
eval_advance(struct eval_ctx *e)
{
    if (e->cur)
        e->cur = e->cur->next;
    while (e->cur && e->cur->kind == PP_SPACE)
        e->cur = e->cur->next;
}

static long long eval_ternary(struct eval_ctx *e);

static long long
eval_primary(struct eval_ctx *e)
{
    if (!e->cur)
        return 0;

    /* defined(X) or defined X */
    if (e->cur->kind == PP_IDENT && e->cur->len == 7 &&
        memcmp(e->cur->text, "defined", 7) == 0) {
        eval_advance(e);
        int paren = 0;
        if (e->cur && e->cur->kind == PP_PUNCT &&
            e->cur->len == 1 && e->cur->text[0] == '(') {
            paren = 1;
            eval_advance(e);
        }
        long long result = 0;
        if (e->cur && e->cur->kind == PP_IDENT) {
            result = macro_lookup(e->cpp, e->cur->text) ? 1 : 0;
            eval_advance(e);
        }
        if (paren && e->cur && e->cur->kind == PP_PUNCT &&
            e->cur->len == 1 && e->cur->text[0] == ')')
            eval_advance(e);
        return result;
    }

    /* number literal */
    if (e->cur->kind == PP_NUMBER) {
        char *end;
        long long val = strtoll(e->cur->text, &end, 0);
        /* skip suffixes: u, l, ll, ul, ull */
        eval_advance(e);
        return val;
    }

    /* character constant */
    if (e->cur->kind == PP_CHAR) {
        long long val = 0;
        const char *s = e->cur->text;
        if (*s == '\'') {
            s++;
            if (*s == '\\') {
                s++;
                switch (*s) {
                case 'n':  val = '\n'; break;
                case 't':  val = '\t'; break;
                case 'r':  val = '\r'; break;
                case '0':  val = '\0'; break;
                case '\\': val = '\\'; break;
                case '\'': val = '\''; break;
                case 'a':  val = '\a'; break;
                case 'b':  val = '\b'; break;
                case 'f':  val = '\f'; break;
                case 'v':  val = '\v'; break;
                case 'x':
                    s++;
                    val = strtoll(s, NULL, 16);
                    break;
                default:
                    if (*s >= '0' && *s <= '7')
                        val = strtoll(s, NULL, 8);
                    break;
                }
            } else {
                val = (unsigned char)*s;
            }
        }
        eval_advance(e);
        return val;
    }

    /* parenthesized expression */
    if (e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
        e->cur->text[0] == '(') {
        eval_advance(e);
        long long val = eval_ternary(e);
        if (e->cur && e->cur->kind == PP_PUNCT &&
            e->cur->len == 1 && e->cur->text[0] == ')')
            eval_advance(e);
        return val;
    }

    /* unknown identifier → 0 (per spec) */
    if (e->cur->kind == PP_IDENT) {
        eval_advance(e);
        return 0;
    }

    eval_advance(e);
    return 0;
}

static long long
eval_unary(struct eval_ctx *e)
{
    if (!e->cur)
        return 0;
    if (e->cur->kind == PP_PUNCT && e->cur->len == 1) {
        char op = e->cur->text[0];
        if (op == '!' || op == '~' || op == '-' || op == '+') {
            eval_advance(e);
            long long val = eval_unary(e);
            switch (op) {
            case '!': return !val;
            case '~': return ~val;
            case '-': return -val;
            case '+': return val;
            }
        }
    }
    return eval_primary(e);
}

static long long
eval_mul(struct eval_ctx *e)
{
    long long val = eval_unary(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1) {
        char op = e->cur->text[0];
        if (op != '*' && op != '/' && op != '%')
            break;
        eval_advance(e);
        long long rhs = eval_unary(e);
        if (op == '*') val *= rhs;
        else if (op == '/' && rhs != 0) val /= rhs;
        else if (op == '%' && rhs != 0) val %= rhs;
    }
    return val;
}

static long long
eval_add(struct eval_ctx *e)
{
    long long val = eval_mul(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1) {
        char op = e->cur->text[0];
        if (op != '+' && op != '-')
            break;
        eval_advance(e);
        long long rhs = eval_mul(e);
        if (op == '+') val += rhs;
        else val -= rhs;
    }
    return val;
}

static long long
eval_shift(struct eval_ctx *e)
{
    long long val = eval_add(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 2) {
        if (memcmp(e->cur->text, "<<", 2) == 0) {
            eval_advance(e);
            val <<= eval_add(e);
        } else if (memcmp(e->cur->text, ">>", 2) == 0) {
            eval_advance(e);
            val >>= eval_add(e);
        } else {
            break;
        }
    }
    return val;
}

static long long
eval_relational(struct eval_ctx *e)
{
    long long val = eval_shift(e);
    while (e->cur && e->cur->kind == PP_PUNCT) {
        if (e->cur->len == 2 && memcmp(e->cur->text, "<=", 2) == 0) {
            eval_advance(e);
            val = val <= eval_shift(e);
        } else if (e->cur->len == 2 && memcmp(e->cur->text, ">=", 2) == 0) {
            eval_advance(e);
            val = val >= eval_shift(e);
        } else if (e->cur->len == 1 && e->cur->text[0] == '<') {
            eval_advance(e);
            val = val < eval_shift(e);
        } else if (e->cur->len == 1 && e->cur->text[0] == '>') {
            eval_advance(e);
            val = val > eval_shift(e);
        } else {
            break;
        }
    }
    return val;
}

static long long
eval_equality(struct eval_ctx *e)
{
    long long val = eval_relational(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 2) {
        if (memcmp(e->cur->text, "==", 2) == 0) {
            eval_advance(e);
            val = val == eval_relational(e);
        } else if (memcmp(e->cur->text, "!=", 2) == 0) {
            eval_advance(e);
            val = val != eval_relational(e);
        } else {
            break;
        }
    }
    return val;
}

static long long
eval_bitand(struct eval_ctx *e)
{
    long long val = eval_equality(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
           e->cur->text[0] == '&') {
        /* make sure it's not && */
        if (e->cur->next && e->cur->next->kind == PP_PUNCT &&
            e->cur->next->len == 1 && e->cur->next->text[0] == '&')
            break;
        eval_advance(e);
        val &= eval_equality(e);
    }
    return val;
}

static long long
eval_bitxor(struct eval_ctx *e)
{
    long long val = eval_bitand(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
           e->cur->text[0] == '^') {
        eval_advance(e);
        val ^= eval_bitand(e);
    }
    return val;
}

static long long
eval_bitor(struct eval_ctx *e)
{
    long long val = eval_bitxor(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
           e->cur->text[0] == '|') {
        /* make sure it's not || */
        if (e->cur->next && e->cur->next->kind == PP_PUNCT &&
            e->cur->next->len == 1 && e->cur->next->text[0] == '|')
            break;
        eval_advance(e);
        val |= eval_bitxor(e);
    }
    return val;
}

static long long
eval_logand(struct eval_ctx *e)
{
    long long val = eval_bitor(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 2 &&
           memcmp(e->cur->text, "&&", 2) == 0) {
        eval_advance(e);
        long long rhs = eval_bitor(e);
        val = val && rhs;
    }
    return val;
}

static long long
eval_logor(struct eval_ctx *e)
{
    long long val = eval_logand(e);
    while (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 2 &&
           memcmp(e->cur->text, "||", 2) == 0) {
        eval_advance(e);
        long long rhs = eval_logand(e);
        val = val || rhs;
    }
    return val;
}

static long long
eval_ternary(struct eval_ctx *e)
{
    long long val = eval_logor(e);
    if (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
        e->cur->text[0] == '?') {
        eval_advance(e);
        long long then_val = eval_ternary(e);
        if (e->cur && e->cur->kind == PP_PUNCT && e->cur->len == 1 &&
            e->cur->text[0] == ':')
            eval_advance(e);
        long long else_val = eval_ternary(e);
        val = val ? then_val : else_val;
    }
    return val;
}

static void
protect_defined(struct pp_token *list)
{
    for (struct pp_token *t = list; t; t = t->next) {
        if (t->kind != PP_IDENT || t->len != 7 ||
            memcmp(t->text, "defined", 7) != 0)
            continue;
        struct pp_token *arg = t->next;
        while (arg && arg->kind == PP_SPACE)
            arg = arg->next;
        if (!arg)
            break;
        if (arg->kind == PP_PUNCT && arg->len == 1 && arg->text[0] == '(') {
            struct pp_token *name = arg->next;
            while (name && name->kind == PP_SPACE)
                name = name->next;
            if (name && name->kind == PP_IDENT)
                name->blue = 1;
        } else if (arg->kind == PP_IDENT) {
            arg->blue = 1;
        }
    }
}

long long
cond_eval(struct cpp *p, struct pp_token *expr)
{
    protect_defined(expr);
    struct pp_token *expanded = macro_expand(p, expr);
    struct eval_ctx e;
    e.cpp = p;
    e.cur = expanded;
    while (e.cur && e.cur->kind == PP_SPACE)
        e.cur = e.cur->next;
    long long result = eval_ternary(&e);
    pp_free_tokens(expanded);
    return result;
}
