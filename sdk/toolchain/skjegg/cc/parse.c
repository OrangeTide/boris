/* parse.c : recursive-descent C89 parser */

#include "cc.h"

#include <stdlib.h>
#include <string.h>

/* Symbol table for typedefs and tags */
enum sym_kind { SYM_VAR, SYM_TYPEDEF, SYM_ENUM_CONST };

struct symbol {
    char *name;
    int sym_kind;
    struct cc_type *type;
    long enum_val;
    struct symbol *next;
};

struct scope {
    struct symbol *syms;
    struct scope *up;
};

static struct arena *parse_arena;
static struct scope *cur_scope;

/* Tag table (structs/unions/enums) */
struct tag {
    char *name;
    struct cc_type *type;
    struct tag *next;
};

static struct tag *tags;

static struct cc_token cur;
static int have_cur;

static struct cc_token
peek(void)
{
    if (have_cur)
        return cur;
    return cc_lex_peek();
}

static struct cc_token
next(void)
{
    if (have_cur) {
        have_cur = 0;
        return cur;
    }
    return cc_lex_next();
}

static void
ungettok(struct cc_token t)
{
    cur = t;
    have_cur = 1;
}

static struct cc_token
expect(int kind)
{
    struct cc_token t = next();
    if (t.kind != kind) {
        const char *gn = cc_tok_name(t.kind), *en = cc_tok_name(kind);
        cc_lex_print_context(t.line, 5);
        if (t.sval && *t.sval)
            die("parse error at line %d in %s: unexpected %s [%d] \"%s\" "
                "(expected %s [%d])", t.line, cc_lex_file(),
                gn ? gn : "token", t.kind, t.sval, en ? en : "token", kind);
        die("parse error at line %d in %s: unexpected %s [%d] "
            "(expected %s [%d])", t.line, cc_lex_file(),
            gn ? gn : "token", t.kind, en ? en : "token", kind);
    }
    return t;
}

static int
consume(int kind)
{
    struct cc_token t = peek();
    if (t.kind == kind) {
        next();
        return 1;
    }
    return 0;
}

static struct cc_node *
node(int kind, int line)
{
    struct cc_node *n = arena_alloc(parse_arena, sizeof *n);
    memset(n, 0, sizeof *n);
    n->kind = kind;
    n->line = line;
    n->col = cc_lex_col();      /* column of the token being parsed, for -g */
    return n;
}

/* scope management */
static void
push_scope(void)
{
    struct scope *s = arena_alloc(parse_arena, sizeof *s);
    s->syms = NULL;
    s->up = cur_scope;
    cur_scope = s;
}

static void
pop_scope(void)
{
    cur_scope = cur_scope->up;
}

static void
add_sym(const char *name, int kind, struct cc_type *type, long eval)
{
    struct symbol *s;
    if (!name)                  /* a nameless declarator binds no symbol */
        return;
    s = arena_alloc(parse_arena, sizeof *s);
    s->name = arena_strdup(parse_arena,name);
    s->sym_kind = kind;
    s->type = type;
    s->enum_val = eval;
    s->next = cur_scope->syms;
    cur_scope->syms = s;
}

static struct symbol *
find_sym(const char *name)
{
    for (struct scope *sc = cur_scope; sc; sc = sc->up) {
        for (struct symbol *s = sc->syms; s; s = s->next) {
            if (strcmp(s->name, name) == 0)
                return s;
        }
    }
    return NULL;
}

static struct cc_type *
find_tag(const char *name)
{
    if (!name)                  /* an anonymous reference matches no named tag */
        return NULL;
    for (struct tag *t = tags; t; t = t->next) {
        if (strcmp(t->name, name) == 0)
            return t->type;
    }
    return NULL;
}

static void
add_tag(const char *name, struct cc_type *type)
{
    struct tag *t;
    if (!name)                  /* nothing can look an anonymous tag back up */
        return;
    t = arena_alloc(parse_arena, sizeof *t);
    t->name = arena_strdup(parse_arena,name);
    t->type = type;
    t->next = tags;
    tags = t;
}

/* forward declarations */
static struct cc_type *parse_declspec(int *is_static, int *is_extern, int *is_typedef);
static long long const_eval(struct cc_node *n);

/* _Alignas requested by the declspec just parsed (0 = none); read by the
   declaration immediately after parse_declspec returns. */
static int declspec_alignas;
/* `inline` seen in the declspec just parsed; read by the declaration after */
static int declspec_inline;
static struct cc_type *parse_declarator(struct cc_type *base, char **name_out);
static struct cc_node *parse_stmt(void);
static struct cc_node *parse_expr(void);
static struct cc_node *parse_assign_expr(void);
static struct cc_node *parse_initializer(void);
static void parse_static_assert(void);
static struct cc_node *parse_asm_operands(int have_expr);

/* is the next token the start of a type specifier? */
static int
is_type_start(struct cc_token t)
{
    switch (t.kind) {
    case TOK_VOID: case TOK_BOOL: case TOK_CHAR: case TOK_SHORT: case TOK_INT:
    case TOK_LONG: case TOK_FLOAT16: case TOK_FLOAT: case TOK_DOUBLE:
    case TOK_SIGNED: case TOK_UNSIGNED:
    case TOK_STRUCT: case TOK_UNION: case TOK_ENUM:
    case TOK_CONST: case TOK_VOLATILE:
    case TOK_EXTERN: case TOK_STATIC: case TOK_AUTO: case TOK_REGISTER:
    case TOK_TYPEDEF:
        return 1;
    case TOK_IDENT: {
        struct symbol *s = find_sym(t.sval);
        return s && s->sym_kind == SYM_TYPEDEF;
    }
    default:
        return 0;
    }
}

/* parse struct/union field list */
static struct cc_field *
parse_fields(void)
{
    struct cc_field *head = NULL, *tail = NULL;
    while (!consume(TOK_RBRACE)) {
        if (peek().kind == TOK_STATIC_ASSERT) {
            parse_static_assert();
            continue;
        }
        int dummy1 = 0, dummy2 = 0;
        struct cc_type *base = parse_declspec(&dummy1, &dummy2, NULL);
        for (;;) {
            char *name = NULL;
            struct cc_type *ft = parse_declarator(base, &name);
            struct cc_field *f = arena_alloc(parse_arena, sizeof *f);
            memset(f, 0, sizeof *f);
            f->name = name;
            f->type = ft;
            /* bit-field: `type name : width` (name may be absent) */
            if (consume(TOK_COLON)) {
                struct cc_node *w = parse_assign_expr();
                if (w->kind != ND_INTLIT)
                    die("parse error at line %d: bit-field width must be "
                        "a constant", w->line);
                f->bits = (int)w->ival;
                if (f->bits == 0)
                    f->bits = -1;   /* zero-width: alignment only, sentinel */
            }
            if (!head) head = f; else tail->next = f;
            tail = f;
            if (!consume(TOK_COMMA))
                break;
        }
        expect(TOK_SEMI);
    }
    return head;
}

/* compute struct layout.  Bit-fields pack LSB-first into a storage unit of
   their declared type; a field that would overflow the unit, or a zero-width
   field, starts a fresh unit. */
static void
layout_struct(struct cc_type *t)
{
    int offset = 0;
    int max_align = 1;
    int bf_off = -1;     /* byte offset of the open bit-field unit, -1 = none */
    int bf_bits = 0;     /* bits already used in the open unit */
    int bf_unit = 0;     /* the open unit's size in bits */

    for (struct cc_field *f = t->fields; f; f = f->next) {
        if (f->bits != 0) {
            int tsz = cc_type_size(f->type);
            int a = cc_type_align(f->type);
            if (a > max_align) max_align = a;
            if (f->bits < 0) {          /* zero-width: close the unit, realign */
                bf_off = -1;
                bf_bits = 0;
                offset = (offset + a - 1) & ~(a - 1);
                continue;
            }
            if (bf_off < 0 || bf_bits + f->bits > bf_unit) {
                offset = (offset + a - 1) & ~(a - 1);
                bf_off = offset;
                bf_bits = 0;
                bf_unit = tsz * 8;
                offset += tsz;
            }
            f->offset = bf_off;
            f->bit_off = bf_bits;
            bf_bits += f->bits;
        } else {
            int a = cc_type_align(f->type);
            if (a > max_align) max_align = a;
            bf_off = -1;                /* an ordinary field closes the unit */
            bf_bits = 0;
            offset = (offset + a - 1) & ~(a - 1);
            f->offset = offset;
            offset += cc_type_size(f->type);
        }
    }
    t->size = (offset + max_align - 1) & ~(max_align - 1);
    t->align = max_align;
}

/* compute union layout */
static void
layout_union(struct cc_type *t)
{
    int max_size = 0;
    int max_align = 1;
    for (struct cc_field *f = t->fields; f; f = f->next) {
        f->offset = 0;
        int sz = cc_type_size(f->type);
        int a = cc_type_align(f->type);
        if (sz > max_size) max_size = sz;
        if (a > max_align) max_align = a;
    }
    t->size = (max_size + max_align - 1) & ~(max_align - 1);
    t->align = max_align;
}

/* Return a const-qualified copy of a type.  A copy, not an in-place stamp,
   because the base scalars are shared singletons and a typedef or tag type is
   shared through its table; qualifying one in place would qualify every use.
   Type comparison in cc is structural (by kind and size), so the copy behaves
   identically to the original apart from the qualifier. */
static struct cc_type *
cc_type_const(struct cc_type *t)
{
    struct cc_type *u = arena_alloc(parse_arena, sizeof *u);
    *u = *t;
    u->is_const = 1;
    return u;
}

/* parse declaration specifiers (type + storage class) */
static struct cc_type *
parse_declspec(int *is_static, int *is_extern, int *is_typedef)
{
    int saw_type = 0;
    int is_unsigned = 0;
    int is_signed = 0;
    int is_bool = 0;
    int saw_const = 0;
    int base = -1;
    int long_count = 0;
    struct cc_type *result = NULL;

    declspec_alignas = 0;
    declspec_inline = 0;
    if (is_static) *is_static = 0;
    if (is_extern) *is_extern = 0;
    if (is_typedef) *is_typedef = 0;

    for (;;) {
        struct cc_token t = peek();
        switch (t.kind) {
        case TOK_STATIC:
            next();
            if (is_static) *is_static = 1;
            continue;
        case TOK_EXTERN:
            next();
            if (is_extern) *is_extern = 1;
            continue;
        case TOK_TYPEDEF:
            next();
            if (is_typedef) *is_typedef = 1;
            continue;
        case TOK_AUTO: case TOK_REGISTER:
            next();
            continue;
        case TOK_INLINE:
            next();
            declspec_inline = 1;        /* an inline definition may be omitted */
            continue;
        case TOK_CONST:
            next();
            saw_const = 1;
            continue;
        case TOK_VOLATILE:
        case TOK_RESTRICT:
            next();
            continue;
        case TOK_ALIGNAS: {
            /* _Alignas(constant) or _Alignas(type): raise the alignment */
            next();
            expect(TOK_LPAREN);
            int al;
            if (is_type_start(peek())) {
                int saved = declspec_alignas;   /* recursion resets it */
                int d1 = 0, d2 = 0;
                struct cc_type *ty = parse_declspec(&d1, &d2, NULL);
                ty = parse_declarator(ty, NULL);
                al = cc_type_align(ty);
                declspec_alignas = saved;
            } else {
                al = (int)const_eval(parse_assign_expr());
            }
            expect(TOK_RPAREN);
            if (al > declspec_alignas)
                declspec_alignas = al;
            continue;
        }
        case TOK_UNSIGNED:
            next();
            is_unsigned = 1;
            saw_type = 1;
            continue;
        case TOK_SIGNED:
            next();
            is_signed = 1;
            saw_type = 1;
            (void)is_signed;
            continue;
        case TOK_VOID:
            next();
            base = TY_VOID;
            saw_type = 1;
            continue;
        case TOK_BOOL:
            /* _Bool: a 1-byte unsigned integer that holds only 0 or 1 */
            next();
            base = TY_CHAR;
            is_unsigned = 1;
            is_bool = 1;
            saw_type = 1;
            continue;
        case TOK_CHAR:
            next();
            base = TY_CHAR;
            saw_type = 1;
            continue;
        case TOK_SHORT:
            next();
            base = TY_SHORT;
            saw_type = 1;
            continue;
        case TOK_INT:
            next();
            base = TY_INT;
            saw_type = 1;
            continue;
        case TOK_LONG:
            next();
            long_count++;
            saw_type = 1;
            continue;
        case TOK_FLOAT16:
            next();
            base = TY_FLOAT16;
            saw_type = 1;
            continue;
        case TOK_FLOAT:
            next();
            base = TY_FLOAT;
            saw_type = 1;
            continue;
        case TOK_DOUBLE:
            next();
            base = TY_DOUBLE;
            saw_type = 1;
            continue;
        case TOK_STRUCT:
        case TOK_UNION: {
            int is_union = (t.kind == TOK_UNION);
            next();
            char *tag_name = NULL;
            struct cc_token nt = peek();
            if (nt.kind == TOK_IDENT) {
                tag_name = nt.sval;
                next();
            }
            if (consume(TOK_LBRACE)) {
                int kind = is_union ? TY_UNION : TY_STRUCT;
                /* Register the tag as incomplete BEFORE parsing the body, so a
                   self-referential field (`struct header *next` inside
                   `struct header`) resolves to this very type and sees its
                   fields once completed, rather than spawning a fieldless stub.
                   An existing incomplete tag (a forward declaration) is
                   completed in place so pointers taken to it see the body. */
                result = tag_name ? find_tag(tag_name) : NULL;
                if (!result || result->fields || result->kind != kind) {
                    result = arena_alloc(parse_arena, sizeof *result);
                    memset(result, 0, sizeof *result);
                    result->kind = kind;
                    result->tag = tag_name;
                    if (tag_name)
                        add_tag(tag_name, result);
                }
                result->fields = parse_fields();
                if (is_union)
                    layout_union(result);
                else
                    layout_struct(result);
            } else {
                result = find_tag(tag_name);
                if (!result) {
                    result = arena_alloc(parse_arena, sizeof *result);
                    memset(result, 0, sizeof *result);
                    result->kind = is_union ? TY_UNION : TY_STRUCT;
                    result->tag = tag_name;
                    add_tag(tag_name, result);
                }
            }
            saw_type = 1;
            goto done;
        }
        case TOK_ENUM: {
            next();
            char *tag_name = NULL;
            struct cc_token nt = peek();
            if (nt.kind == TOK_IDENT) {
                tag_name = nt.sval;
                next();
            }
            if (consume(TOK_LBRACE)) {
                long eval = 0;
                while (!consume(TOK_RBRACE)) {
                    struct cc_token name = expect(TOK_IDENT);
                    if (consume(TOK_ASSIGN)) {
                        /* fold the whole constant expression, not just a bare
                           literal: `1 << n`, `A | B`, or a prior enum constant
                           (which parses to a literal) all reduce here.  Reading
                           e->ival directly took only ND_INTLIT and silently
                           made every computed enumerator 0. */
                        eval = (long)const_eval(parse_assign_expr());
                    }
                    add_sym(name.sval, SYM_ENUM_CONST, cc_type_int(), eval);
                    eval++;
                    if (!consume(TOK_COMMA))
                        { expect(TOK_RBRACE); break; }
                }
                if (tag_name) {
                    struct cc_type *et = arena_alloc(parse_arena, sizeof *et);
                    memset(et, 0, sizeof *et);
                    et->kind = TY_ENUM;
                    et->tag = tag_name;
                    add_tag(tag_name, et);
                }
            }
            result = arena_alloc(parse_arena, sizeof *result);
            memset(result, 0, sizeof *result);
            result->kind = TY_ENUM;
            result->tag = tag_name;
            saw_type = 1;
            goto done;
        }
        case TOK_IDENT: {
            struct symbol *s = find_sym(t.sval);
            if (s && s->sym_kind == SYM_TYPEDEF && !saw_type) {
                next();
                result = s->type;
                saw_type = 1;
                goto done;
            }
            goto done;
        }
        default:
            goto done;
        }
    }
done:
    if (!saw_type)
        die("expected type specifier at line %d", cc_lex_line());

    if (!result) {
        if (base == -1) {
            if (long_count >= 2)
                base = TY_LONG_LONG;
            else if (long_count == 1)
                base = TY_LONG;
            else
                base = TY_INT;
        } else if (base == TY_DOUBLE && long_count >= 1) {
            base = TY_LDOUBLE;          /* `long double` (either word order) */
        }
        result = arena_alloc(parse_arena, sizeof *result);
        memset(result, 0, sizeof *result);
        result->kind = base;
        result->is_unsigned = is_unsigned;
        result->is_bool = is_bool;
    }
    /* a leading const (const int, const struct S, const T) qualifies the base;
       a const after a * (int * const) is a pointer qualifier, in the
       declarator */
    if (saw_const)
        result = cc_type_const(result);
    return result;
}

/* NULL until lowering installs its type resolver; see cc.h. */
struct cc_type *(*cc_const_sizeof_typer)(struct cc_node *n) = NULL;

static long long
const_eval(struct cc_node *n)
{
    if (!n)
        die("expected constant expression");
    switch (n->kind) {
    case ND_INTLIT:
        return n->ival;
    case ND_BINOP: {
        long long a = const_eval(n->a);
        long long b = const_eval(n->b);
        switch (n->op) {
        case TOK_PLUS:    return a + b;
        case TOK_MINUS:   return a - b;
        case TOK_STAR:    return a * b;
        case TOK_SLASH:   return b ? a / b : 0;
        case TOK_PERCENT: return b ? a % b : 0;
        case TOK_AMP:     return a & b;
        case TOK_PIPE:    return a | b;
        case TOK_CARET:   return a ^ b;
        case TOK_SHL:     return a << b;
        case TOK_SHR:     return a >> b;
        case TOK_ANDAND:  return a && b;
        case TOK_OROR:    return a || b;
        case TOK_EQ:      return a == b;
        case TOK_NE:      return a != b;
        case TOK_LT:      return a < b;
        case TOK_LE:      return a <= b;
        case TOK_GT:      return a > b;
        case TOK_GE:      return a >= b;
        default:
            die("unsupported operator in constant expression");
            return 0;
        }
    }
    case ND_UNOP: {
        long long a = const_eval(n->a);
        switch (n->op) {
        case TOK_MINUS: return -a;
        case TOK_TILDE: return ~a;
        case TOK_BANG:  return !a;
        default:
            die("unsupported unary operator in constant expression");
            return 0;
        }
    }
    case ND_TERNARY:
        return const_eval(n->a) ? const_eval(n->b) : const_eval(n->c);
    case ND_SIZEOF: {
        struct cc_type *t = n->decl_type ? n->decl_type
                          : (n->a ? n->a->type : NULL);
        /* An expression operand carries no type at parse time; during lowering
           the typing hook resolves it, so sizeof a declared array or struct
           folds to its real size rather than defaulting to int. */
        if (!t && n->a && cc_const_sizeof_typer)
            t = cc_const_sizeof_typer(n->a);
        if (!t)
            t = cc_type_int();
        return n->op == TOK_ALIGNOF ? cc_type_align(t) : cc_type_size(t);
    }
    case ND_CAST:
        return const_eval(n->a);
    case ND_INDEX:
        /* a constant index of a string literal is the byte at that position,
           e.g. "abc"[1] is 'b' (index slen is the terminating NUL) */
        if (n->a && n->a->kind == ND_STRLIT) {
            long long i = const_eval(n->b);
            if (i < 0 || i > n->a->slen)
                die("string literal index %lld out of range at line %d",
                    i, n->line);
            return i == n->a->slen ? 0 : (unsigned char)n->a->sval[i];
        }
        die("expected constant expression at line %d", n->line);
        return 0;
    default:
        die("expected constant expression at line %d", n->line);
        return 0;
    }
}

/* Public entry: fold an integer constant expression. Used by the lowering to
   evaluate a scalar static/global initializer that is a constant expression
   rather than a bare literal. Dies (like the array-size path) when the node is
   not a constant expression, which is the correct diagnostic for a static
   initializer. */
long long
cc_const_eval(struct cc_node *n)
{
    return const_eval(n);
}

/* C11 _Static_assert ( constant-expression , string-literal ) ; evaluated at
   parse time. The message string is optional (the C23 form). A failed
   assertion dies with the message; a passing one produces no AST node. Appears
   at file scope, as a block item, and as a struct/union member. */
static void
parse_static_assert(void)
{
    int ln = cc_lex_line();
    expect(TOK_STATIC_ASSERT);
    expect(TOK_LPAREN);
    long long val = const_eval(parse_assign_expr());
    const char *msg = NULL;
    if (consume(TOK_COMMA)) {
        struct cc_token m = expect(TOK_STRLIT);
        msg = m.sval;
    }
    expect(TOK_RPAREN);
    expect(TOK_SEMI);
    if (val == 0) {
        if (msg)
            die("static assertion failed at line %d: %s", ln, msg);
        die("static assertion failed at line %d", ln);
    }
}

/* parse abstract or concrete declarator */
static struct cc_type *
parse_declarator(struct cc_type *base, char **name_out)
{
    /* pointer prefixes */
    while (consume(TOK_STAR)) {
        base = cc_type_ptr(parse_arena,base);
        /* qualifiers after a * apply to the pointer itself (int * const p is a
           const pointer).  base is the fresh pointer type, safe to stamp. */
        while (peek().kind == TOK_CONST || peek().kind == TOK_VOLATILE ||
               peek().kind == TOK_RESTRICT) {
            if (peek().kind == TOK_CONST)
                base->is_const = 1;
            next();
        }
    }

    struct cc_type *inner = NULL;
    char *name = NULL;

    if (peek().kind == TOK_LPAREN) {
        /* could be grouping parens in declarator or function params */
        /* disambiguate: if next after '(' is type or ')' it's params */
        struct cc_token lp = next();
        struct cc_token after = peek();
        if (after.kind == TOK_STAR ||
            (after.kind == TOK_IDENT && !is_type_start(after)) ||
            after.kind == TOK_LPAREN) {
            /* grouping: parse inner declarator */
            inner = parse_declarator(base, &name);
            expect(TOK_RPAREN);
        } else {
            /* not grouping — put back the '(' */
            ungettok(lp);
        }
    } else if (peek().kind == TOK_IDENT) {
        struct cc_token nt = next();
        name = nt.sval;
    }

    /* postfix: arrays and function params */
    for (;;) {
        if (peek().kind == TOK_LBRACK) {
            /* Collect the whole run of dimensions in source order, then wrap
               them innermost-last so the first-written dimension is the
               outermost: `int a[3][2]` is array[3] of array[2] of int, not the
               reverse.  Only the first dimension may be unspecified (`[]`). */
            int dims[32];
            int ndim = 0;
            while (consume(TOK_LBRACK)) {
                int len = -1;
                if (peek().kind != TOK_RBRACK) {
                    struct cc_node *e = parse_assign_expr();
                    len = (int)const_eval(e);
                }
                expect(TOK_RBRACK);
                if (ndim >= 32)
                    die("too many array dimensions at line %d", cc_lex_line());
                dims[ndim++] = len;
            }
            for (int i = ndim - 1; i >= 0; i--)
                base = cc_type_array(parse_arena, base, dims[i]);
        } else if (consume(TOK_LPAREN)) {
            struct cc_type *ft = cc_type_func(parse_arena,base);
            struct cc_param *phead = NULL, *ptail = NULL;
            if (!consume(TOK_RPAREN)) {
                if (peek().kind == TOK_VOID) {
                    struct cc_token v = next();
                    if (peek().kind == TOK_RPAREN) {
                        next();
                    } else {
                        ungettok(v);
                        goto parse_params;
                    }
                } else {
                parse_params:
                    for (;;) {
                        if (consume(TOK_ELLIPSIS)) {
                            ft->is_variadic = 1;
                            break;
                        }
                        int d1 = 0, d2 = 0;
                        struct cc_type *pt = parse_declspec(&d1, &d2, NULL);
                        char *pname = NULL;
                        pt = parse_declarator(pt, &pname);
                        /* C99 6.7.5.3p7: a parameter of array type is adjusted
                           to a pointer to its element, and a parameter of
                           function type to a pointer to the function.  Without
                           this, a forwarded array (notably va_list, an array of
                           one tag) meets a by-value aggregate parameter and the
                           call ABI mismatches. */
                        if (pt && pt->kind == TY_ARRAY)
                            pt = cc_type_ptr(parse_arena, pt->base);
                        else if (pt && pt->kind == TY_FUNC)
                            pt = cc_type_ptr(parse_arena, pt);
                        struct cc_param *pp = arena_alloc(parse_arena, sizeof *pp);
                        memset(pp, 0, sizeof *pp);
                        pp->name = pname;
                        pp->type = pt;
                        if (!phead) phead = pp; else ptail->next = pp;
                        ptail = pp;
                        if (!consume(TOK_COMMA))
                            break;
                    }
                    expect(TOK_RPAREN);
                }
            }
            ft->params = phead;
            base = ft;
        } else {
            break;
        }
    }

    if (name_out)
        *name_out = name;

    if (inner) {
        /* patch: inner declarator wraps around base */
        /* find the innermost base of inner and replace it */
        struct cc_type *scan = inner;
        while (scan->base && (scan->base->kind == TY_PTR ||
               scan->base->kind == TY_ARRAY || scan->base->kind == TY_FUNC))
            scan = scan->base;
        scan->base = base;
        return inner;
    }
    return base;
}

/* parse initializer (single expr or { list }) */
static struct cc_node *
parse_initializer(void)
{
    if (consume(TOK_LBRACE)) {
        struct cc_node *n = node(ND_INIT_LIST, cc_lex_line());
        struct cc_node *head = NULL, *tail = NULL;
        while (!consume(TOK_RBRACE)) {
            struct cc_node *elem;
            /* designator: .field = ... or [const] = ... (one level) */
            if (peek().kind == TOK_DOT || peek().kind == TOK_LBRACK) {
                struct cc_node *d = node(ND_DESIG, cc_lex_line());
                if (consume(TOK_DOT)) {
                    struct cc_token id = expect(TOK_IDENT);
                    d->name = arena_strdup(parse_arena, id.sval);
                } else {
                    expect(TOK_LBRACK);
                    struct cc_node *idx = parse_assign_expr();
                    if (idx->kind != ND_INTLIT)
                        die("parse error at line %d: array designator "
                            "must be a constant", idx->line);
                    d->ival = idx->ival;   /* name stays null -> index */
                    expect(TOK_RBRACK);
                }
                expect(TOK_ASSIGN);
                d->a = parse_initializer();
                elem = d;
            } else {
                elem = parse_initializer();
            }
            if (!head) head = elem; else tail->next = elem;
            tail = elem;
            if (!consume(TOK_COMMA))
                { expect(TOK_RBRACE); break; }
        }
        n->body = head;
        return n;
    }
    return parse_assign_expr();
}

/* expression parsing: precedence climbing */
static struct cc_node *parse_unary(void);
static struct cc_node *parse_cast(void);

static struct cc_node *
parse_primary(void)
{
    struct cc_token t = next();
    switch (t.kind) {
    case TOK_INTLIT: {
        struct cc_node *n = node(ND_INTLIT, t.line);
        struct cc_type *bt;
        n->ival = t.ival;
        bt = t.is_llong ? cc_type_long_long()
           : t.is_long  ? cc_type_long()
           :              cc_type_int();
        if (t.is_unsigned) {        /* a copy, since the base types are shared */
            struct cc_type *u = arena_alloc(parse_arena, sizeof *u);
            *u = *bt;
            u->is_unsigned = 1;
            bt = u;
        }
        n->type = bt;
        return n;
    }
    case TOK_FLOATLIT: {
        struct cc_node *n = node(ND_FLOATLIT, t.line);
        n->fval = t.fval;
        struct cc_type *ft = arena_alloc(parse_arena, sizeof *ft);
        memset(ft, 0, sizeof *ft);
        ft->kind = t.is_half ? TY_FLOAT16 : t.is_float ? TY_FLOAT : TY_DOUBLE;
        n->type = ft;
        return n;
    }
    case TOK_CHARLIT: {
        struct cc_node *n = node(ND_INTLIT, t.line);
        n->ival = t.ival;
        n->type = cc_type_int();
        return n;
    }
    case TOK_STRLIT: {
        struct cc_node *n = node(ND_STRLIT, t.line);
        n->sval = t.sval;
        n->slen = t.slen;
        /* A string literal is an array char[len+1] (the +1 is the trailing
           NUL), not a pointer, so sizeof measures the storage.  It decays to
           char* in value contexts through the ordinary TY_ARRAY decay, and the
           lowering returns the string's address directly (it never reads this
           type), so every value use is unchanged. */
        n->type = cc_type_array(parse_arena, cc_type_char(), t.slen + 1);
        return n;
    }
    case TOK_IDENT: {
        struct symbol *s = find_sym(t.sval);
        if (s && s->sym_kind == SYM_ENUM_CONST) {
            struct cc_node *n = node(ND_INTLIT, t.line);
            n->ival = s->enum_val;
            n->type = cc_type_int();
            return n;
        }
        struct cc_node *n = node(ND_VAR, t.line);
        n->name = t.sval;
        return n;
    }
    case TOK_GENERIC: {
        /* C11 _Generic ( assignment-expression , generic-assoc-list ). Each
           association is `type-name : expr` or `default : expr`; the node holds
           the controlling expression in a and the association list in b (each a
           node with decl_type = the type-name, NULL for default, and a = the
           result expression). The branch is chosen at lowering, where the
           controlling expression's type is known. */
        struct cc_node *n = node(ND_GENERIC, t.line);
        expect(TOK_LPAREN);
        n->a = parse_assign_expr();
        expect(TOK_COMMA);
        struct cc_node *head = NULL, *tail = NULL;
        int ndefault = 0;
        for (;;) {
            struct cc_node *assoc = node(ND_GENERIC, t.line);
            if (consume(TOK_DEFAULT)) {
                assoc->decl_type = NULL;
                if (++ndefault > 1)
                    die("_Generic: more than one default association "
                        "at line %d", assoc->line);
            } else {
                int d1 = 0, d2 = 0;
                struct cc_type *ty = parse_declspec(&d1, &d2, NULL);
                assoc->decl_type = parse_declarator(ty, NULL);
            }
            expect(TOK_COLON);
            assoc->a = parse_assign_expr();
            if (!head) head = assoc; else tail->next = assoc;
            tail = assoc;
            if (!consume(TOK_COMMA))
                break;
        }
        expect(TOK_RPAREN);
        n->b = head;
        return n;
    }
    case TOK_LPAREN: {
        /* could be cast or grouping */
        struct cc_token ahead = peek();
        if (is_type_start(ahead)) {
            int d1 = 0, d2 = 0;
            struct cc_type *ty = parse_declspec(&d1, &d2, NULL);
            ty = parse_declarator(ty, NULL);
            expect(TOK_RPAREN);
            if (peek().kind == TOK_LBRACE) {
                /* compound literal (type){ init }: an anonymous object of the
                   named type, not a cast of a braced expression */
                struct cc_node *n = node(ND_COMPOUND_LIT, t.line);
                n->decl_type = ty;
                n->type = ty;
                n->a = parse_initializer();
                return n;
            }
            struct cc_node *n = node(ND_CAST, t.line);
            n->decl_type = ty;
            n->a = parse_cast();
            n->type = ty;
            return n;
        }
        struct cc_node *n = parse_expr();
        expect(TOK_RPAREN);
        return n;
    }
    default:
        die("unexpected token %d at line %d in expression", t.kind, t.line);
        return NULL;
    }
}

static struct cc_node *
parse_postfix(void)
{
    struct cc_node *n = parse_primary();
    for (;;) {
        int ln = cc_lex_line();
        if (consume(TOK_LBRACK)) {
            struct cc_node *idx = parse_expr();
            expect(TOK_RBRACK);
            struct cc_node *r = node(ND_INDEX, ln);
            r->a = n;
            r->b = idx;
            n = r;
        } else if (consume(TOK_LPAREN)) {
            struct cc_node *r = node(ND_CALL, ln);
            r->a = n;
            if (n->kind == ND_VAR &&
                strcmp(n->name, "__builtin_va_arg") == 0) {
                /* __builtin_va_arg(ap, type): the second operand is a type
                   name, not an expression (what the real <stdarg.h> va_arg
                   expands to).  Parse it and carry it on the call node; the
                   lowering classifies it and types the result. */
                r->b = parse_assign_expr();
                expect(TOK_COMMA);
                int vd1 = 0, vd2 = 0;
                struct cc_type *vty = parse_declspec(&vd1, &vd2, NULL);
                vty = parse_declarator(vty, NULL);
                r->decl_type = vty;
                expect(TOK_RPAREN);
                n = r;
                continue;
            }
            struct cc_node *head = NULL, *tail = NULL;
            if (!consume(TOK_RPAREN)) {
                for (;;) {
                    struct cc_node *arg = parse_assign_expr();
                    if (!head) head = arg; else tail->next = arg;
                    tail = arg;
                    if (!consume(TOK_COMMA))
                        break;
                }
                expect(TOK_RPAREN);
            }
            r->b = head;
            n = r;
        } else if (consume(TOK_DOT)) {
            struct cc_token f = expect(TOK_IDENT);
            struct cc_node *r = node(ND_MEMBER, ln);
            r->a = n;
            r->name = f.sval;
            n = r;
        } else if (consume(TOK_ARROW)) {
            struct cc_token f = expect(TOK_IDENT);
            struct cc_node *r = node(ND_MEMBER, ln);
            r->a = node(ND_DEREF, ln);
            r->a->a = n;
            r->name = f.sval;
            n = r;
        } else if (consume(TOK_INC)) {
            struct cc_node *r = node(ND_POST_INC, ln);
            r->a = n;
            n = r;
        } else if (consume(TOK_DEC)) {
            struct cc_node *r = node(ND_POST_DEC, ln);
            r->a = n;
            n = r;
        } else {
            break;
        }
    }
    return n;
}

static struct cc_node *
parse_unary(void)
{
    int ln = cc_lex_line();
    struct cc_token t = peek();
    switch (t.kind) {
    case TOK_INC: {
        next();
        struct cc_node *n = node(ND_PRE_INC, ln);
        n->a = parse_unary();
        return n;
    }
    case TOK_DEC: {
        next();
        struct cc_node *n = node(ND_PRE_DEC, ln);
        n->a = parse_unary();
        return n;
    }
    case TOK_AMP: {
        next();
        struct cc_node *n = node(ND_ADDR, ln);
        n->a = parse_cast();
        return n;
    }
    case TOK_ANDAND: {
        /* GNU labels as values: &&label is the address of a label, a void*.
           A prefix && is unambiguous (logical-and is strictly binary). */
        struct cc_token lab;
        struct cc_node *n;
        next();
        lab = expect(TOK_IDENT);
        n = node(ND_LABELADDR, ln);
        n->name = lab.sval;
        return n;
    }
    case TOK_STAR: {
        next();
        struct cc_node *n = node(ND_DEREF, ln);
        n->a = parse_cast();
        return n;
    }
    case TOK_PLUS: {
        next();
        return parse_cast();
    }
    case TOK_MINUS: {
        next();
        struct cc_node *n = node(ND_UNOP, ln);
        n->op = TOK_MINUS;
        n->a = parse_cast();
        return n;
    }
    case TOK_TILDE: {
        next();
        struct cc_node *n = node(ND_UNOP, ln);
        n->op = TOK_TILDE;
        n->a = parse_cast();
        return n;
    }
    case TOK_BANG: {
        next();
        struct cc_node *n = node(ND_UNOP, ln);
        n->op = TOK_BANG;
        n->a = parse_cast();
        return n;
    }
    case TOK_SIZEOF:
    case TOK_ALIGNOF: {
        int is_alignof = t.kind == TOK_ALIGNOF;
        next();
        struct cc_node *n = node(ND_SIZEOF, ln);
        n->op = is_alignof ? TOK_ALIGNOF : TOK_SIZEOF;
        /* _Alignof requires a parenthesized type; sizeof also takes an expr */
        if (consume(TOK_LPAREN)) {
            struct cc_token ahead = peek();
            if (is_type_start(ahead)) {
                int d1 = 0, d2 = 0;
                struct cc_type *ty = parse_declspec(&d1, &d2, NULL);
                ty = parse_declarator(ty, NULL);
                n->decl_type = ty;
                expect(TOK_RPAREN);
            } else {
                struct cc_node *e = parse_expr();
                expect(TOK_RPAREN);
                n->a = e;
            }
        } else {
            n->a = parse_unary();
        }
        n->type = cc_type_int();
        return n;
    }
    default:
        return parse_postfix();
    }
}

static struct cc_node *
parse_cast(void)
{
    return parse_unary();
}

/* binary operators with precedence climbing */
static int
binop_prec(int kind)
{
    switch (kind) {
    case TOK_STAR: case TOK_SLASH: case TOK_PERCENT: return 13;
    case TOK_PLUS: case TOK_MINUS: return 12;
    case TOK_SHL: case TOK_SHR: return 11;
    case TOK_LT: case TOK_LE: case TOK_GT: case TOK_GE: return 10;
    case TOK_EQ: case TOK_NE: return 9;
    case TOK_AMP: return 8;
    case TOK_CARET: return 7;
    case TOK_PIPE: return 6;
    case TOK_ANDAND: return 5;
    case TOK_OROR: return 4;
    default: return -1;
    }
}

static struct cc_node *
parse_binop(int min_prec)
{
    struct cc_node *lhs = parse_cast();
    for (;;) {
        struct cc_token t = peek();
        int prec = binop_prec(t.kind);
        if (prec < min_prec)
            break;
        next();
        struct cc_node *rhs = parse_binop(prec + 1);
        struct cc_node *n = node(ND_BINOP, t.line);
        n->op = t.kind;
        n->a = lhs;
        n->b = rhs;
        lhs = n;
    }
    return lhs;
}

static struct cc_node *
parse_ternary(void)
{
    struct cc_node *cond = parse_binop(4);
    if (consume(TOK_QUESTION)) {
        struct cc_node *n = node(ND_TERNARY, cond->line);
        n->a = cond;
        n->b = parse_expr();
        expect(TOK_COLON);
        n->c = parse_ternary();
        return n;
    }
    return cond;
}

static struct cc_node *
parse_assign_expr(void)
{
    struct cc_node *lhs = parse_ternary();
    struct cc_token t = peek();
    if (t.kind == TOK_ASSIGN) {
        next();
        struct cc_node *n = node(ND_ASSIGN, t.line);
        n->a = lhs;
        n->b = parse_assign_expr();
        return n;
    }
    if (t.kind >= TOK_PLUS_EQ && t.kind <= TOK_SHR_EQ) {
        next();
        struct cc_node *n = node(ND_COMPOUND_ASSIGN, t.line);
        n->op = t.kind;
        n->a = lhs;
        n->b = parse_assign_expr();
        return n;
    }
    return lhs;
}

static struct cc_node *
parse_expr(void)
{
    struct cc_node *n = parse_assign_expr();
    while (consume(TOK_COMMA)) {
        struct cc_node *r = node(ND_COMMA, n->line);
        r->a = n;
        r->b = parse_assign_expr();
        n = r;
    }
    return n;
}

/* statement parsing */
static struct cc_node *parse_block(void);

static struct cc_node *
parse_local_decl(struct cc_type *base, int is_static, int is_extern)
{
    struct cc_node *head = NULL, *tail = NULL;
    for (;;) {
        char *name = NULL;
        struct cc_type *dt = parse_declarator(base, &name);
        struct cc_node *n = node(ND_LOCAL_DECL, cc_lex_line());
        n->name = name;
        n->decl_type = dt;
        n->is_static = is_static;
        n->is_extern = is_extern;
        /* GNU local register variable: register T x __asm__("$reg").  The
           asm("...") binding follows the declarator; the register name is
           carried on sval/slen for the lowering to pin asm operands to. */
        if (peek().kind == TOK_ASM) {
            struct cc_token r;
            next();
            expect(TOK_LPAREN);
            r = expect(TOK_STRLIT);
            expect(TOK_RPAREN);
            n->sval = r.sval;
            n->slen = r.slen;
        }
        if (name)
            add_sym(name, SYM_VAR, dt, 0);
        if (consume(TOK_ASSIGN))
            n->a = parse_initializer();
        if (!head) head = n; else tail->next = n;
        tail = n;
        if (!consume(TOK_COMMA))
            break;
    }
    expect(TOK_SEMI);
    return head;
}

/* One extended-asm section (outputs, inputs, or clobbers), stopping at the
   next ':' or ')'.  The introducing ':' is already consumed.  An operand is
   "constraint"(expr) when have_expr; a clobber is just "string".  Returns a
   ->next-chained list of ND_ASM_OP nodes, or NULL for an empty section. */
static struct cc_node *
parse_asm_operands(int have_expr)
{
    struct cc_node *head = NULL, *tail = NULL;

    if (peek().kind == TOK_COLON || peek().kind == TOK_RPAREN)
        return NULL;                    /* empty section */
    for (;;) {
        int ln = cc_lex_line();
        struct cc_node *op = node(ND_ASM_OP, ln);
        struct cc_token c = expect(TOK_STRLIT);
        op->sval = c.sval;
        op->slen = c.slen;
        if (have_expr) {
            expect(TOK_LPAREN);
            op->a = parse_assign_expr();
            expect(TOK_RPAREN);
        }
        if (!head) head = op; else tail->next = op;
        tail = op;
        if (!consume(TOK_COMMA))
            break;
    }
    return head;
}

static struct cc_node *
parse_stmt(void)
{
    int ln = cc_lex_line();
    struct cc_token t = peek();

    /* check for declaration */
    if (is_type_start(t)) {
        int is_static = 0, is_extern = 0;
        struct cc_type *base = parse_declspec(&is_static, &is_extern, NULL);
        return parse_local_decl(base, is_static, is_extern);
    }

    switch (t.kind) {
    case TOK_LBRACE:
        return parse_block();
    case TOK_IF: {
        next();
        struct cc_node *n = node(ND_IF, ln);
        expect(TOK_LPAREN);
        n->a = parse_expr();
        expect(TOK_RPAREN);
        n->b = parse_stmt();
        if (consume(TOK_ELSE))
            n->c = parse_stmt();
        return n;
    }
    case TOK_WHILE: {
        next();
        struct cc_node *n = node(ND_WHILE, ln);
        expect(TOK_LPAREN);
        n->a = parse_expr();
        expect(TOK_RPAREN);
        n->b = parse_stmt();
        return n;
    }
    case TOK_DO: {
        next();
        struct cc_node *n = node(ND_DO_WHILE, ln);
        n->a = parse_stmt();
        expect(TOK_WHILE);
        expect(TOK_LPAREN);
        n->b = parse_expr();
        expect(TOK_RPAREN);
        expect(TOK_SEMI);
        return n;
    }
    case TOK_FOR: {
        next();
        struct cc_node *n = node(ND_FOR, ln);
        expect(TOK_LPAREN);
        if (!consume(TOK_SEMI)) {
            if (is_type_start(peek())) {
                int d1 = 0, d2 = 0;
                struct cc_type *base = parse_declspec(&d1, &d2, NULL);
                n->a = parse_local_decl(base, d1, d2);
            } else {
                n->a = node(ND_EXPR_STMT, ln);
                n->a->a = parse_expr();
                expect(TOK_SEMI);
            }
        }
        if (!consume(TOK_SEMI)) {
            n->b = parse_expr();
            expect(TOK_SEMI);
        }
        if (peek().kind != TOK_RPAREN)
            n->c = parse_expr();
        expect(TOK_RPAREN);
        n->d = parse_stmt();
        return n;
    }
    case TOK_SWITCH: {
        next();
        struct cc_node *n = node(ND_SWITCH, ln);
        expect(TOK_LPAREN);
        n->a = parse_expr();
        expect(TOK_RPAREN);
        n->b = parse_stmt();
        return n;
    }
    case TOK_CASE: {
        next();
        struct cc_node *n = node(ND_CASE, ln);
        n->a = parse_expr();
        expect(TOK_COLON);
        n->b = parse_stmt();
        return n;
    }
    case TOK_DEFAULT: {
        next();
        struct cc_node *n = node(ND_DEFAULT, ln);
        expect(TOK_COLON);
        n->a = parse_stmt();
        return n;
    }
    case TOK_BREAK:
        next();
        expect(TOK_SEMI);
        return node(ND_BREAK, ln);
    case TOK_CONTINUE:
        next();
        expect(TOK_SEMI);
        return node(ND_CONTINUE, ln);
    case TOK_RETURN: {
        next();
        struct cc_node *n = node(ND_RETURN, ln);
        if (peek().kind != TOK_SEMI)
            n->a = parse_expr();
        expect(TOK_SEMI);
        return n;
    }
    case TOK_GOTO: {
        next();
        struct cc_node *n = node(ND_GOTO, ln);
        if (consume(TOK_STAR)) {
            /* GNU computed goto: goto *expr, where expr is a label address.
               The target expression is carried in a; name stays null. */
            n->a = parse_expr();
        } else {
            struct cc_token lab = expect(TOK_IDENT);
            n->name = lab.sval;
        }
        expect(TOK_SEMI);
        return n;
    }
    case TOK_ASM: {
        /* inline asm: asm [volatile] ( template [: outputs [: inputs
           [: clobbers]]] ) ;  With no colon sections it is basic asm (the
           template is emitted verbatim).  Extended asm numbers its operands
           %0.. (outputs first); each operand is "constraint"(expr), each
           clobber a string. */
        struct cc_node *n = node(ND_ASM, ln);
        struct cc_token s;
        next();
        n->ival = consume(TOK_VOLATILE) ? 1 : 0;
        expect(TOK_LPAREN);
        s = expect(TOK_STRLIT);
        n->sval = s.sval;
        n->slen = s.slen;
        if (consume(TOK_COLON)) {           /* outputs section */
            n->a = parse_asm_operands(1);   /* "constraint"(expr) list */
            if (consume(TOK_COLON)) {       /* inputs section */
                n->b = parse_asm_operands(1);
                if (consume(TOK_COLON))     /* clobbers: bare strings */
                    n->c = parse_asm_operands(0);
            }
        }
        expect(TOK_RPAREN);
        expect(TOK_SEMI);
        return n;
    }
    case TOK_IDENT: {
        /* check for label: ident ':' */
        struct cc_token id = next();
        if (consume(TOK_COLON)) {
            struct cc_node *n = node(ND_LABEL, ln);
            n->name = id.sval;
            n->a = parse_stmt();
            return n;
        }
        ungettok(id);
        struct cc_node *n = node(ND_EXPR_STMT, ln);
        n->a = parse_expr();
        expect(TOK_SEMI);
        return n;
    }
    case TOK_SEMI:
        next();
        return node(ND_EXPR_STMT, ln);
    default: {
        struct cc_node *n = node(ND_EXPR_STMT, ln);
        n->a = parse_expr();
        expect(TOK_SEMI);
        return n;
    }
    }
}

static struct cc_node *
parse_block(void)
{
    int ln = cc_lex_line();
    expect(TOK_LBRACE);
    push_scope();
    struct cc_node *n = node(ND_BLOCK, ln);
    struct cc_node *head = NULL, *tail = NULL;
    while (!consume(TOK_RBRACE)) {
        if (peek().kind == TOK_STATIC_ASSERT) {
            parse_static_assert();
            continue;
        }
        struct cc_node *s = parse_stmt();
        while (s) {
            struct cc_node *nxt = s->next;
            s->next = NULL;
            if (!head) head = s; else tail->next = s;
            tail = s;
            s = nxt;
        }
    }
    n->body = head;
    pop_scope();
    return n;
}

/* top-level parsing */
static struct cc_node *
parse_top_decl(void)
{
    if (peek().kind == TOK_STATIC_ASSERT) {
        parse_static_assert();
        return NULL;
    }

    int is_static = 0, is_extern = 0, is_typedef = 0;
    struct cc_type *base = parse_declspec(&is_static, &is_extern, &is_typedef);
    int dspec_align = declspec_alignas;
    int dspec_inline = declspec_inline;

    /* bare struct/enum declaration */
    if (consume(TOK_SEMI))
        return NULL;

    char *name = NULL;
    struct cc_type *dt = parse_declarator(base, &name);

    /* A top-level declarator with no name is invalid (the nameless bare
       struct/enum declaration was already consumed by the TOK_SEMI above), and
       a NULL name would otherwise reach add_sym / add_global as a NUL string. */
    if (!name)
        die("parse error at line %d: declarator has no name", cc_lex_line());

    /* typedef */
    if (is_typedef) {
        add_sym(name, SYM_TYPEDEF, dt, 0);
        while (consume(TOK_COMMA)) {
            char *n2 = NULL;
            struct cc_type *dt2 = parse_declarator(base, &n2);
            if (!n2)
                die("parse error at line %d: declarator has no name",
                    cc_lex_line());
            add_sym(n2, SYM_TYPEDEF, dt2, 0);
        }
        expect(TOK_SEMI);
        return NULL;
    }

    /* function definition? */
    if (dt->kind == TY_FUNC && peek().kind == TOK_LBRACE) {
        struct cc_node *n = node(ND_FUNC_DEF, cc_lex_line());
        n->file = cc_lex_file();        /* the file this function is defined in */
        n->name = name;
        n->decl_type = dt;
        n->is_static = is_static;
        n->is_inline = dspec_inline;
        /* add params to scope */
        push_scope();
        for (struct cc_param *pp = dt->params; pp; pp = pp->next) {
            if (pp->name)
                add_sym(pp->name, SYM_VAR, pp->type, 0);
        }
        n->body = parse_block();
        pop_scope();
        return n;
    }

    /* global variable declaration */
    struct cc_node *head = NULL, *tail = NULL;
    {
        struct cc_node *n = node(ND_GLOBAL_DECL, cc_lex_line());
        n->name = name;
        n->decl_type = dt;
        n->is_static = is_static;
        n->is_extern = is_extern;
        n->align = dspec_align;
        if (consume(TOK_ASSIGN))
            n->a = parse_initializer();
        head = n;
        tail = n;
    }
    while (consume(TOK_COMMA)) {
        char *n2 = NULL;
        struct cc_type *dt2 = parse_declarator(base, &n2);
        struct cc_node *n;
        if (!n2)
            die("parse error at line %d: declarator has no name",
                cc_lex_line());
        n = node(ND_GLOBAL_DECL, cc_lex_line());
        n->name = n2;
        n->decl_type = dt2;
        n->is_static = is_static;
        n->is_extern = is_extern;
        n->align = dspec_align;
        if (consume(TOK_ASSIGN))
            n->a = parse_initializer();
        tail->next = n;
        tail = n;
    }
    expect(TOK_SEMI);
    return head;
}

struct cc_node *
cc_parse_program(struct arena *a)
{
    struct cc_node *prog;
    struct cc_node *head = NULL, *tail = NULL;

    parse_arena = a;
    /* Reset the file-scope symbol and tag tables, which hold pointers into the
       parse arena: a prior compile's die() (or an in-process reuse) would
       otherwise leave cur_scope and tags chained onto that compile's freed
       arena, and find_sym / find_tag would walk into it. */
    cur_scope = NULL;
    tags = NULL;
    prog = node(ND_PROGRAM, 1);
    push_scope();

    /* Builtin va_list, laid out per the target ABI.  cc never reads the fields
       by name; the backend's IR_VA_START and the runtime __va_arg agree on the
       layout, so only the size and field types must be right.  SysV (x86-64):
       { unsigned gp_offset, fp_offset; void *overflow_arg_area, *reg_save_area; }.
       AAPCS64 (arm64): { void *__stack, *__gr_top, *__vr_top; int __gr_offs,
       __vr_offs; }. */
    {
        struct cc_type *u = arena_zalloc(parse_arena, sizeof *u);
        u->kind = TY_INT;
        u->is_unsigned = 1;
        struct cc_type *si = cc_type_int();
        struct cc_type *vp = cc_type_ptr(parse_arena, cc_type_void());
#ifdef CC_ARM64
        const char *nm[5] = { "__stack", "__gr_top", "__vr_top",
                              "__gr_offs", "__vr_offs" };
        struct cc_type *ty[5] = { vp, vp, vp, si, si };
        int nf = 5;
#else
        (void)si;
        const char *nm[5] = { "gp_offset", "fp_offset",
                              "overflow_arg_area", "reg_save_area", NULL };
        struct cc_type *ty[5] = { u, u, vp, vp, NULL };
        int nf = 4;
#endif
        struct cc_field *f[5];
        for (int k = 0; k < nf; k++) {
            f[k] = arena_alloc(parse_arena, sizeof *f[k]);
            memset(f[k], 0, sizeof *f[k]);
            f[k]->name = arena_strdup(parse_arena, nm[k]);
            f[k]->type = ty[k];
            f[k]->next = NULL;
            if (k > 0)
                f[k - 1]->next = f[k];
        }
        struct cc_type *st = arena_zalloc(parse_arena, sizeof *st);
        st->kind = TY_STRUCT;
        st->tag = arena_strdup(parse_arena, "__va_list_tag");
        st->fields = f[0];
        layout_struct(st);
        add_tag("__va_list_tag", st);
        add_sym("__builtin_va_list", SYM_TYPEDEF,
                cc_type_array(parse_arena, st, 1), 0);
    }
    while (peek().kind != TOK_EOF) {
        struct cc_node *decl = parse_top_decl();
        while (decl) {
            struct cc_node *nxt = decl->next;
            decl->next = NULL;
            if (!head) head = decl; else tail->next = decl;
            tail = decl;
            decl = nxt;
        }
    }
    pop_scope();

    prog->body = head;
    return prog;
}
