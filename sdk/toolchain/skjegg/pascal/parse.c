/* parse.c : recursive-descent parser for Compact Pascal */

#include "pascal.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Helpers
 ****************************************************************/

static struct arena *parse_arena;
static struct token cur;
static struct node *anon_types;
static struct node **anon_ttail;
static int anon_ctr;

static void
advance(void)
{
    cur = lex_next();
}

static int
accept(int k)
{
    if (cur.kind == k) {
        advance();
        return 1;
    }
    return 0;
}

static void
expect(int k, const char *what)
{
    if (cur.kind != k)
        die("parse:%d: expected %s", cur.line, what);
    advance();
}

static struct node *
new_node(int kind, int line)
{
    struct node *n;

    n = arena_zalloc(parse_arena, sizeof(*n));
    n->kind = kind;
    n->line = line;
    return n;
}

/****************************************************************
 * Expressions
 *
 * Pascal precedence (low to high):
 *   comparison: = <> < <= > >=
 *   add/sub/or: + - or
 *   mul/div/and: * div mod and shl shr
 *   unary: not  -  +
 ****************************************************************/

static struct node *parse_expr(void);
static struct node *parse_simple_expr(void);

static struct node *
parse_postfix(struct node *n)
{
    while (cur.kind == T_DOT || cur.kind == T_LBRACK) {
        if (cur.kind == T_DOT) {
            struct node *dot;
            advance();
            if (cur.kind != T_IDENT)
                die("parse:%d: expected field name after '.'",
                    cur.line);
            dot = new_node(N_DOT, cur.line);
            dot->a = n;
            dot->name = cur.sval;
            advance();
            n = dot;
        } else {
            advance();
            for (;;) {
                struct node *idx;
                idx = new_node(N_INDEX, cur.line);
                idx->op = lex_rangechecks;
                idx->a = n;
                idx->b = parse_expr();
                n = idx;
                if (!accept(T_COMMA))
                    break;
            }
            expect(T_RBRACK, "]");
        }
    }
    return n;
}

static struct node *
parse_factor(void)
{
    struct node *n;
    struct token t;

    t = cur;

    if (t.kind == T_NUMBER) {
        advance();
        n = new_node(N_NUM, t.line);
        n->ival = t.nval;
        return n;
    }
    if (t.kind == T_REAL) {
        advance();
        n = new_node(N_REAL, t.line);
        n->fval = t.fval;
        return n;
    }
    if (t.kind == T_STRING) {
        advance();
        n = new_node(N_STR, t.line);
        n->sval = t.sval;
        n->slen = t.slen;
        return n;
    }
    if (t.kind == T_TRUE || t.kind == T_FALSE) {
        advance();
        n = new_node(N_BOOL, t.line);
        n->ival = (t.kind == T_TRUE);
        return n;
    }
    if (t.kind == T_IDENT) {
        advance();
        n = new_node(N_NAME, t.line);
        n->name = t.sval;
        /* function/procedure call */
        if (cur.kind == T_LPAREN) {
            struct node *call, *args, **tail;
            int ln = cur.line;
            advance();
            args = NULL;
            tail = &args;
            if (cur.kind != T_RPAREN) {
                for (;;) {
                    struct node *a = parse_expr();
                    *tail = a;
                    tail = &a->next;
                    if (!accept(T_COMMA))
                        break;
                }
            }
            expect(T_RPAREN, ")");
            call = new_node(N_CALL, ln);
            call->a = n;
            call->b = args;
            return call;
        }
        return parse_postfix(n);
    }
    if (t.kind == T_LPAREN) {
        advance();
        n = parse_expr();
        expect(T_RPAREN, ")");
        return n;
    }
    if (t.kind == T_NOT) {
        advance();
        n = new_node(N_UNOP, t.line);
        n->op = T_NOT;
        n->a = parse_factor();
        return n;
    }
    if (t.kind == T_MINUS) {
        advance();
        n = new_node(N_UNOP, t.line);
        n->op = T_MINUS;
        n->a = parse_factor();
        return n;
    }
    if (t.kind == T_PLUS) {
        advance();
        return parse_factor();
    }
    if ((t.kind == T_INTEGER || t.kind == T_CHAR ||
         t.kind == T_BOOLEAN || t.kind == T_BYTE ||
         t.kind == T_WORD) && lex_peek().kind == T_LPAREN) {
        struct node *call, *name;
        const char *cast_name;
        advance();
        switch (t.kind) {
        case T_INTEGER: cast_name = "integer"; break;
        case T_CHAR:    cast_name = "char"; break;
        case T_BOOLEAN: cast_name = "boolean"; break;
        case T_BYTE:    cast_name = "byte"; break;
        default:        cast_name = "word"; break;
        }
        name = new_node(N_NAME, t.line);
        name->name = arena_strdup(parse_arena,cast_name);
        advance();
        call = new_node(N_CALL, t.line);
        call->a = name;
        call->b = parse_expr();
        expect(T_RPAREN, ")");
        return call;
    }
    if (t.kind == T_SIZEOF) {
        advance();
        expect(T_LPAREN, "(");
        if (cur.kind != T_IDENT)
            die("parse:%d: expected type name in sizeof",
                cur.line);
        n = new_node(N_SIZEOF, cur.line);
        n->name = cur.sval;
        advance();
        expect(T_RPAREN, ")");
        return n;
    }
    if (t.kind == T_LBRACK) {
        struct node *elems, **etail;
        advance();
        n = new_node(N_SET, t.line);
        elems = NULL;
        etail = &elems;
        if (cur.kind != T_RBRACK) {
            for (;;) {
                struct node *e = parse_simple_expr();
                if (cur.kind == T_DOTDOT) {
                    struct node *r;
                    advance();
                    r = new_node(N_SETRANGE, cur.line);
                    r->a = e;
                    r->b = parse_simple_expr();
                    e = r;
                }
                *etail = e;
                etail = &e->next;
                if (!accept(T_COMMA))
                    break;
            }
        }
        expect(T_RBRACK, "]");
        n->a = elems;
        return n;
    }
    die("parse:%d: unexpected token in expression", t.line);
    return NULL;
}

static struct node *
parse_term(void)
{
    struct node *lhs, *rhs, *b;
    int op, line;

    lhs = parse_factor();
    while (cur.kind == T_STAR || cur.kind == T_SLASH ||
           cur.kind == T_DIV  || cur.kind == T_MOD  || cur.kind == T_AND ||
           cur.kind == T_SHL  || cur.kind == T_SHR) {
        op = cur.kind;
        line = cur.line;
        advance();
        if (op == T_AND && cur.kind == T_THEN) {
            advance();
            op = T_AND_THEN;
        }
        rhs = parse_factor();
        b = new_node(N_BINOP, line);
        b->op = op;
        if (op == T_STAR)
            b->ival = lex_overflowchecks;
        b->a = lhs;
        b->b = rhs;
        lhs = b;
    }
    return lhs;
}

static struct node *
parse_simple_expr(void)
{
    struct node *lhs, *rhs, *b;
    int op, line;

    lhs = parse_term();
    while (cur.kind == T_PLUS || cur.kind == T_MINUS ||
           cur.kind == T_OR) {
        op = cur.kind;
        line = cur.line;
        advance();
        if (op == T_OR && cur.kind == T_ELSE) {
            advance();
            op = T_OR_ELSE;
        }
        rhs = parse_term();
        b = new_node(N_BINOP, line);
        b->op = op;
        if (op == T_PLUS || op == T_MINUS)
            b->ival = lex_overflowchecks;
        b->a = lhs;
        b->b = rhs;
        lhs = b;
    }
    return lhs;
}

static struct node *
parse_expr(void)
{
    struct node *lhs, *rhs, *b;
    int op, line;

    lhs = parse_simple_expr();
    if (cur.kind == T_IN) {
        line = cur.line;
        advance();
        rhs = parse_simple_expr();
        b = new_node(N_BINOP, line);
        b->op = T_IN;
        b->a = lhs;
        b->b = rhs;
        return b;
    }
    if (cur.kind == T_EQ || cur.kind == T_NE ||
        cur.kind == T_LT || cur.kind == T_LE ||
        cur.kind == T_GT || cur.kind == T_GE) {
        op = cur.kind;
        line = cur.line;
        advance();
        rhs = parse_simple_expr();
        b = new_node(N_BINOP, line);
        b->op = op;
        b->a = lhs;
        b->b = rhs;
        return b;
    }
    return lhs;
}

/****************************************************************
 * Statements
 ****************************************************************/

static struct node *parse_stmt(void);
static struct node *parse_block(void);

static int
is_stmt_end(int k)
{
    return k == T_END || k == T_ELSE || k == T_UNTIL || k == T_EOF;
}

static struct node *
parse_compound(void)
{
    struct node *n, *stmts, **tail;
    int line;

    line = cur.line;
    expect(T_BEGIN, "begin");
    stmts = NULL;
    tail = &stmts;
    if (!is_stmt_end(cur.kind)) {
        struct node *s = parse_stmt();
        *tail = s;
        tail = &s->next;
        while (accept(T_SEMI)) {
            if (is_stmt_end(cur.kind))
                break;
            s = parse_stmt();
            *tail = s;
            tail = &s->next;
        }
    }
    expect(T_END, "end");
    n = new_node(N_COMPOUND, line);
    n->a = stmts;
    return n;
}

static struct node *
parse_stmt(void)
{
    struct node *n;
    int line;

    line = cur.line;

    if (cur.kind == T_BEGIN)
        return parse_compound();

    if (cur.kind == T_IF) {
        advance();
        n = new_node(N_IF, line);
        n->a = parse_expr();
        expect(T_THEN, "then");
        n->b = parse_stmt();
        if (accept(T_ELSE))
            n->c = parse_stmt();
        return n;
    }

    if (cur.kind == T_WHILE) {
        advance();
        n = new_node(N_WHILE, line);
        n->a = parse_expr();
        expect(T_DO, "do");
        n->b = parse_stmt();
        return n;
    }

    if (cur.kind == T_FOR) {
        advance();
        n = new_node(N_FOR, line);
        if (cur.kind != T_IDENT)
            die("parse:%d: expected identifier after 'for'",
                cur.line);
        n->name = cur.sval;
        advance();
        expect(T_ASSIGN, ":=");
        n->a = parse_expr();
        if (accept(T_DOWNTO))
            n->downto = 1;
        else
            expect(T_TO, "to or downto");
        n->b = parse_expr();
        expect(T_DO, "do");
        n->c = parse_stmt();
        return n;
    }

    if (cur.kind == T_REPEAT) {
        struct node *stmts, **tail, *s;
        advance();
        n = new_node(N_REPEAT, line);
        stmts = NULL;
        tail = &stmts;
        if (cur.kind != T_UNTIL) {
            s = parse_stmt();
            *tail = s;
            tail = &s->next;
            while (accept(T_SEMI)) {
                if (cur.kind == T_UNTIL)
                    break;
                s = parse_stmt();
                *tail = s;
                tail = &s->next;
            }
        }
        expect(T_UNTIL, "until");
        n->a = stmts;
        n->b = parse_expr();
        return n;
    }

    if (cur.kind == T_BREAK) {
        advance();
        return new_node(N_BREAK, line);
    }

    if (cur.kind == T_CONTINUE) {
        advance();
        return new_node(N_CONTINUE, line);
    }

    if (cur.kind == T_CASE) {
        struct node *arms, **atail, *arm;
        struct node *labels, **ltail, *lab;
        advance();
        n = new_node(N_CASE, line);
        n->a = parse_expr();
        expect(T_OF, "of");
        arms = NULL;
        atail = &arms;
        while (cur.kind != T_END && cur.kind != T_ELSE &&
               cur.kind != T_EOF) {
            int aline = cur.line;
            labels = NULL;
            ltail = &labels;
            for (;;) {
                lab = new_node(N_CASELABEL, cur.line);
                lab->b = parse_expr();
                if (accept(T_DOTDOT))
                    lab->a = parse_expr();
                *ltail = lab;
                ltail = &lab->next;
                if (!accept(T_COMMA))
                    break;
            }
            expect(T_COLON, ":");
            arm = new_node(N_CASEARM, aline);
            arm->a = labels;
            arm->b = parse_stmt();
            *atail = arm;
            atail = &arm->next;
            accept(T_SEMI);
        }
        n->b = arms;
        if (accept(T_ELSE)) {
            struct node *stmts, **stail, *s;
            stmts = NULL;
            stail = &stmts;
            if (cur.kind != T_END) {
                s = parse_stmt();
                *stail = s;
                stail = &s->next;
                while (accept(T_SEMI)) {
                    if (cur.kind == T_END)
                        break;
                    s = parse_stmt();
                    *stail = s;
                    stail = &s->next;
                }
            }
            {
                struct node *comp;
                comp = new_node(N_COMPOUND, line);
                comp->a = stmts;
                n->c = comp;
            }
        }
        expect(T_END, "end");
        return n;
    }

    if (cur.kind == T_WITH) {
        struct node **wtail;
        n = new_node(N_WITH, line);
        advance();
        wtail = &n->a;
        for (;;) {
            struct node *w = parse_expr();
            *wtail = w;
            wtail = &w->next;
            if (!accept(T_COMMA))
                break;
        }
        expect(T_DO, "do");
        n->b = parse_stmt();
        return n;
    }

    /* assignment or procedure call */
    if (cur.kind == T_IDENT) {
        struct node *lhs;
        struct token id = cur;
        advance();
        lhs = new_node(N_NAME, id.line);
        lhs->name = id.sval;
        /* function/procedure call */
        if (cur.kind == T_LPAREN) {
            struct node *args, **atail;
            advance();
            args = NULL;
            atail = &args;
            if (cur.kind != T_RPAREN) {
                for (;;) {
                    struct node *a = parse_expr();
                    *atail = a;
                    atail = &a->next;
                    if (!accept(T_COMMA))
                        break;
                }
            }
            expect(T_RPAREN, ")");
            n = new_node(N_CALL, line);
            n->a = lhs;
            n->b = args;
            return n;
        }
        lhs = parse_postfix(lhs);
        if (cur.kind == T_ASSIGN) {
            advance();
            n = new_node(N_ASSIGN, line);
            n->a = lhs;
            n->b = parse_expr();
            return n;
        }
        /* bare identifier as procedure call (no parens) */
        n = new_node(N_CALL, line);
        n->a = lhs;
        return n;
    }

    /* an empty statement: a token that ends the enclosing statement list or
       branch stands for an empty statement (if c then else ..., if c then ; ,
       a ;; gap, a bare else arm), which is valid Pascal. */
    if (is_stmt_end(cur.kind) || cur.kind == T_SEMI)
        return new_node(N_COMPOUND, line);

    die("parse:%d: unexpected token in statement", line);
    return NULL;
}

/****************************************************************
 * Declarations
 ****************************************************************/

static const char *
builtin_type_name(int kind)
{
    switch (kind) {
    case T_INTEGER: return "integer";
    case T_BOOLEAN: return "boolean";
    case T_CHAR:    return "char";
    case T_BYTE:    return "byte";
    case T_WORD:    return "word";
    default:        return NULL;
    }
}

static int
accept_type(char **out_name)
{
    const char *btn = builtin_type_name(cur.kind);
    if (btn) {
        if (out_name)
            *out_name = (char *)btn;
        advance();
        return 1;
    }
    if (cur.kind == T_IDENT && strcmp(cur.sval, "string") == 0) {
        int maxlen = 255;
        char buf[64];
        struct node *td;
        int sline = cur.line;
        advance();
        if (accept(T_LBRACK)) {
            if (cur.kind != T_NUMBER)
                die("parse:%d: expected string length", sline);
            maxlen = (int)cur.nval;
            advance();
            expect(T_RBRACK, "]");
        }
        snprintf(buf, sizeof(buf), "__str_%d", anon_ctr++);
        td = new_node(N_TYPEDEF, sline);
        td->name = arena_strdup(parse_arena,buf);
        td->op = 2;
        td->ival = maxlen;
        *anon_ttail = td;
        anon_ttail = &td->next;
        if (out_name)
            *out_name = arena_strdup(parse_arena,buf);
        return 1;
    }
    if (cur.kind == T_IDENT && strcmp(cur.sval, "array") == 0) {
        struct node *dims[8];
        char *etname = NULL;
        int ndims = 0;
        char buf[64];
        int aline = cur.line;
        advance();
        if (cur.kind == T_OF) {
            /* dynamic array: array of T */
            struct node *td;
            char *etname2 = NULL;
            advance();
            if (!accept_type(&etname2))
                die("parse:%d: expected element type", aline);
            td = new_node(N_TYPEDEF, aline);
            td->op = 6;
            td->sval = etname2;
            snprintf(buf, sizeof(buf), "__anon_%d", anon_ctr++);
            td->name = arena_strdup(parse_arena, buf);
            *anon_ttail = td;
            anon_ttail = &td->next;
            if (out_name)
                *out_name = arena_strdup(parse_arena, buf);
            return 1;
        }
        expect(T_LBRACK, "[");
        for (;;) {
            struct node *td;
            if (ndims >= 8)
                die("parse:%d: too many dimensions", aline);
            td = new_node(N_TYPEDEF, aline);
            td->op = 1;
            td->b = parse_expr();
            if (accept(T_DOTDOT))
                td->c = parse_expr();
            else
                td->c = NULL;   /* array[OrdinalType]: bounds from the type */
            dims[ndims++] = td;
            if (!accept(T_COMMA))
                break;
        }
        expect(T_RBRACK, "]");
        expect(T_OF, "of");
        if (!accept_type(&etname))
            die("parse:%d: expected element type", aline);
        snprintf(buf, sizeof(buf), "__anon_%d", anon_ctr++);
        for (int i = ndims - 1; i >= 0; i--) {
            dims[i]->sval = etname;
            if (i == 0) {
                dims[i]->name = arena_strdup(parse_arena,buf);
            } else {
                char dbuf[80];
                snprintf(dbuf, sizeof(dbuf), "%s_d%d", buf, i);
                dims[i]->name = arena_strdup(parse_arena,dbuf);
            }
            *anon_ttail = dims[i];
            anon_ttail = &dims[i]->next;
            etname = dims[i]->name;
        }
        if (out_name)
            *out_name = arena_strdup(parse_arena,buf);
        return 1;
    }
    if (cur.kind == T_SET) {
        char buf[64];
        struct node *td;
        int sline = cur.line;
        advance();
        expect(T_OF, "of");
        td = new_node(N_TYPEDEF, sline);
        td->op = 3;
        if (cur.kind == T_INTEGER || cur.kind == T_CHAR ||
            cur.kind == T_BYTE || cur.kind == T_WORD)
            advance();
        else if (cur.kind == T_NUMBER || cur.kind == T_STRING) {
            advance();
            expect(T_DOTDOT, "..");
            if (cur.kind == T_NUMBER || cur.kind == T_STRING)
                advance();
            else
                die("parse:%d: expected bound after '..'",
                    sline);
        } else if (cur.kind == T_IDENT) {
            advance();
            if (cur.kind == T_DOTDOT) {
                advance();
                if (cur.kind == T_IDENT)
                    advance();
                else
                    die("parse:%d: expected bound after '..'",
                        sline);
            } else if (cur.kind == T_LPAREN) {
                advance();
                expect(T_IDENT, "identifier");
                expect(T_DOTDOT, "..");
                expect(T_IDENT, "identifier");
                expect(T_RPAREN, ")");
            }
        } else
            die("parse:%d: expected base type after 'set of'",
                sline);
        snprintf(buf, sizeof(buf), "__set_%d", anon_ctr++);
        td->name = arena_strdup(parse_arena,buf);
        *anon_ttail = td;
        anon_ttail = &td->next;
        if (out_name)
            *out_name = arena_strdup(parse_arena,buf);
        return 1;
    }
    if (cur.kind == T_IDENT) {
        if (out_name)
            *out_name = cur.sval;
        advance();
        return 1;
    }
    return 0;
}

static void
parse_param_list(struct node **out_params)
{
    struct node *params, **tail, *p, *group_start;
    int is_var;

    params = NULL;
    tail = &params;

    expect(T_LPAREN, "(");
    if (cur.kind != T_RPAREN) {
        for (;;) {
            is_var = 0;
            if (accept(T_VAR))
                is_var = 1;
            else if (accept(T_CONST))
                is_var = 2;
            else if (cur.kind == T_IDENT && strcmp(cur.sval, "out") == 0 &&
                     lex_peek().kind == T_IDENT) {
                /* `out p: T` is a by-reference parameter like `var`; the
                   distinction (the callee must assign it) is not enforced.
                   `out` is not reserved, so a parameter literally named out
                   (out: T, or out, x: T) keeps its identifier meaning. */
                advance();
                is_var = 1;
            }
            group_start = NULL;
            for (;;) {
                if (cur.kind != T_IDENT)
                    die("parse:%d: expected parameter name",
                        cur.line);
                p = new_node(N_PARAM, cur.line);
                p->name = cur.sval;
                p->op = is_var;
                advance();
                *tail = p;
                tail = &p->next;
                if (!group_start)
                    group_start = p;
                if (!accept(T_COMMA))
                    break;
            }
            expect(T_COLON, ":");
            {
                char *ptname = NULL;
                if (!accept_type(&ptname))
                    die("parse:%d: expected type",
                        cur.line);
                for (p = group_start; p; p = p->next)
                    p->sval = ptname;
            }
            if (!accept(T_SEMI))
                break;
        }
    }
    expect(T_RPAREN, ")");
    *out_params = params;
}

static struct node *
parse_init_list(void)
{
    struct node *n;
    struct node *head, **tail;
    int line = cur.line;
    int is_record = 0;

    expect(T_LPAREN, "(");
    n = new_node(N_INITLIST, line);
    head = NULL;
    tail = &head;

    if (cur.kind == T_IDENT) {
        struct token pk = lex_peek();
        if (pk.kind == T_COLON)
            is_record = 1;
    }

    for (;;) {
        struct node *elem;
        if (is_record) {
            if (cur.kind != T_IDENT)
                die("parse:%d: expected field name", cur.line);
            advance();
            expect(T_COLON, ":");
        }
        if (cur.kind == T_LPAREN) {
            elem = parse_init_list();
        } else {
            elem = parse_expr();
        }
        *tail = elem;
        tail = &elem->next;
        if (is_record) {
            if (!accept(T_SEMI))
                break;
        } else {
            if (!accept(T_COMMA))
                break;
        }
    }
    expect(T_RPAREN, ")");
    n->a = head;
    return n;
}

static struct node *
parse_const_section(struct node ***vtail)
{
    struct node *head, **tail, *n;
    int line;

    head = NULL;
    tail = &head;
    expect(T_CONST, "const");
    while (cur.kind == T_IDENT) {
        line = cur.line;
        n = new_node(N_CONSTDECL, line);
        n->name = cur.sval;
        advance();
        if (accept(T_COLON)) {
            char *tname = NULL;
            if (!accept_type(&tname))
                die("parse:%d: expected type", line);
            expect(T_EQ, "=");
            n->kind = N_VARDECL;
            n->sval = tname;
            if (cur.kind == T_LPAREN) {
                n->a = parse_init_list();
            } else {
                n->a = parse_expr();
            }
            expect(T_SEMI, ";");
            **vtail = n;
            *vtail = &n->next;
            continue;
        }
        expect(T_EQ, "=");
        n->a = parse_expr();
        expect(T_SEMI, ";");
        *tail = n;
        tail = &n->next;
    }
    return head;
}

static struct node *
parse_type_section(void)
{
    struct node *head, **tail;

    head = NULL;
    tail = &head;
    expect(T_TYPE, "type");
    while (cur.kind == T_IDENT) {
        int line = cur.line;
        char *type_name = cur.sval;
        advance();
        expect(T_EQ, "=");
        if (cur.kind == T_LPAREN) {
            /* enum type: TypeName = (Id1, Id2, ...).  Each identifier is an
               integer constant 0, 1, 2, ...; the type itself is registered as
               an ordinal scalar (op 7) carrying the member count. */
            long ordinal = 0;
            struct node *et = new_node(N_TYPEDEF, line);
            et->name = type_name;
            et->op = 7;
            *tail = et;
            tail = &et->next;
            advance();
            for (;;) {
                struct node *c;
                if (cur.kind != T_IDENT)
                    die("parse:%d: expected enum value",
                        cur.line);
                c = new_node(N_CONSTDECL, cur.line);
                c->name = cur.sval;
                c->a = new_node(N_NUM, cur.line);
                c->a->ival = ordinal++;
                advance();
                *tail = c;
                tail = &c->next;
                if (!accept(T_COMMA))
                    break;
            }
            expect(T_RPAREN, ")");
            et->ival = ordinal;         /* member count (cardinality) */
        } else if (cur.kind == T_IDENT &&
                   strcmp(cur.sval, "record") == 0) {
            struct node *td, *fields, **ftail;
            advance();
            td = new_node(N_TYPEDEF, line);
            td->name = type_name;
            td->ival = lex_align;
            fields = NULL;
            ftail = &fields;
            while (cur.kind != T_END && cur.kind != T_CASE) {
                struct node *group_start = NULL;
                for (;;) {
                    struct node *f;
                    if (cur.kind != T_IDENT)
                        die("parse:%d: expected field name",
                            cur.line);
                    f = new_node(N_FIELDDECL, cur.line);
                    f->name = cur.sval;
                    advance();
                    *ftail = f;
                    ftail = &f->next;
                    if (!group_start)
                        group_start = f;
                    if (!accept(T_COMMA))
                        break;
                }
                expect(T_COLON, ":");
                {
                    char *ftname = NULL;
                    if (!accept_type(&ftname))
                        die("parse:%d: expected field type",
                            cur.line);
                    for (; group_start; group_start = group_start->next)
                        group_start->sval = ftname;
                }
                if (cur.kind != T_END && cur.kind != T_CASE)
                    expect(T_SEMI, ";");
            }
            if (cur.kind == T_CASE) {
                struct node *vp;
                struct node *arms, **atail;
                int vline = cur.line;
                char *tag_type = NULL;
                advance();
                vp = new_node(N_VARIANTPART, vline);
                if (cur.kind == T_IDENT) {
                    struct token pk = lex_peek();
                    if (pk.kind == T_COLON) {
                        vp->name = cur.sval;
                        advance();
                        advance();
                    }
                }
                if (!accept_type(&tag_type))
                    die("parse:%d: expected tag type",
                        vline);
                vp->sval = tag_type;
                expect(T_OF, "of");
                arms = NULL;
                atail = &arms;
                while (cur.kind != T_END) {
                    struct node *arm;
                    struct node *labels, **ltail;
                    struct node *vfields, **vftail;
                    int aline = cur.line;
                    arm = new_node(N_CASEARM, aline);
                    labels = NULL;
                    ltail = &labels;
                    for (;;) {
                        struct node *lb;
                        lb = new_node(N_CASELABEL,
                            cur.line);
                        lb->b = parse_expr();
                        *ltail = lb;
                        ltail = &lb->next;
                        if (!accept(T_COMMA))
                            break;
                    }
                    expect(T_COLON, ":");
                    expect(T_LPAREN, "(");
                    vfields = NULL;
                    vftail = &vfields;
                    while (cur.kind != T_RPAREN) {
                        struct node *gs = NULL;
                        for (;;) {
                            struct node *f;
                            if (cur.kind != T_IDENT)
                                die("parse:%d: "
                                    "expected "
                                    "field name",
                                    cur.line);
                            f = new_node(
                                N_FIELDDECL,
                                cur.line);
                            f->name = cur.sval;
                            advance();
                            *vftail = f;
                            vftail = &f->next;
                            if (!gs)
                                gs = f;
                            if (!accept(T_COMMA))
                                break;
                        }
                        expect(T_COLON, ":");
                        {
                            char *ft = NULL;
                            if (!accept_type(&ft))
                                die("parse:%d: "
                                    "expected "
                                    "field type",
                                    cur.line);
                            for (; gs;
                                gs = gs->next)
                                gs->sval = ft;
                        }
                        if (cur.kind != T_RPAREN)
                            expect(T_SEMI, ";");
                    }
                    expect(T_RPAREN, ")");
                    arm->a = labels;
                    arm->b = vfields;
                    *atail = arm;
                    atail = &arm->next;
                    if (cur.kind != T_END) {
                        if (!accept(T_SEMI))
                            break;
                    }
                }
                vp->a = arms;
                *ftail = vp;
                ftail = &vp->next;
            }
            expect(T_END, "end");
            td->a = fields;
            *tail = td;
            tail = &td->next;
        } else if (cur.kind == T_IDENT &&
                   strcmp(cur.sval, "array") == 0) {
            struct node *dims[8], *td;
            char *etname = NULL;
            int ndims = 0;
            advance();
            if (cur.kind == T_OF) {
                /* dynamic array: TypeName = array of T */
                char *etname2 = NULL;
                advance();
                if (!accept_type(&etname2))
                    die("parse:%d: expected element type",
                        cur.line);
                td = new_node(N_TYPEDEF, line);
                td->op = 6;
                td->name = type_name;
                td->sval = etname2;
                *tail = td;
                tail = &td->next;
            } else {
            expect(T_LBRACK, "[");
            for (;;) {
                if (ndims >= 8)
                    die("parse:%d: too many dimensions",
                        cur.line);
                td = new_node(N_TYPEDEF, line);
                td->op = 1;
                td->b = parse_expr();
                if (accept(T_DOTDOT))
                    td->c = parse_expr();
                else
                    td->c = NULL;   /* array[OrdinalType] */
                dims[ndims++] = td;
                if (!accept(T_COMMA))
                    break;
            }
            expect(T_RBRACK, "]");
            expect(T_OF, "of");
            if (!accept_type(&etname))
                die("parse:%d: expected element type",
                    cur.line);
            for (int i = ndims - 1; i >= 0; i--) {
                dims[i]->sval = etname;
                if (i == 0) {
                    dims[i]->name = type_name;
                } else {
                    char buf[64];
                    snprintf(buf, sizeof(buf),
                             "__%s_dim%d",
                             type_name, i);
                    dims[i]->name = arena_strdup(parse_arena,buf);
                }
                *tail = dims[i];
                tail = &dims[i]->next;
                etname = dims[i]->name;
            }
            }
        } else if (cur.kind == T_SET) {
            struct node *td;
            advance();
            expect(T_OF, "of");
            td = new_node(N_TYPEDEF, line);
            td->name = type_name;
            td->op = 3;
            if (cur.kind == T_INTEGER || cur.kind == T_CHAR ||
                cur.kind == T_BYTE || cur.kind == T_WORD)
                advance();
            else if (cur.kind == T_NUMBER ||
                     cur.kind == T_STRING) {
                advance();
                expect(T_DOTDOT, "..");
                if (cur.kind == T_NUMBER ||
                    cur.kind == T_STRING)
                    advance();
                else
                    die("parse:%d: expected bound after '..'",
                        cur.line);
            } else if (cur.kind == T_IDENT) {
                advance();
                if (cur.kind == T_DOTDOT) {
                    advance();
                    if (cur.kind == T_IDENT)
                        advance();
                    else
                        die("parse:%d: expected bound after '..'",
                            cur.line);
                } else if (cur.kind == T_LPAREN) {
                    advance();
                    expect(T_IDENT, "identifier");
                    expect(T_DOTDOT, "..");
                    expect(T_IDENT, "identifier");
                    expect(T_RPAREN, ")");
                }
            } else
                die("parse:%d: expected base type after 'set of'",
                    cur.line);
            *tail = td;
            tail = &td->next;
        } else if (cur.kind == T_NUMBER || cur.kind == T_STRING ||
                   cur.kind == T_MINUS ||
                   (cur.kind == T_IDENT &&
                    lex_peek().kind == T_DOTDOT)) {
            /* subrange: TypeName = lo..hi; */
            struct node *td = new_node(N_TYPEDEF, line);
            td->name = type_name;
            td->op = 5;
            td->b = parse_expr();
            expect(T_DOTDOT, "..");
            td->c = parse_expr();
            *tail = td;
            tail = &td->next;
        } else {
            /* type alias: TypeName = OtherType; */
            char *aliased = NULL;
            struct node *td;
            if (!accept_type(&aliased))
                die("parse:%d: unsupported type declaration", line);
            td = new_node(N_TYPEDEF, line);
            td->name = type_name;
            td->op = 4;
            td->sval = aliased;
            *tail = td;
            tail = &td->next;
        }
        expect(T_SEMI, ";");
    }
    return head;
}

static struct node *
parse_var_section(void)
{
    struct node *head, **tail, *names, **ntail, *n;

    head = NULL;
    tail = &head;
    expect(T_VAR, "var");
    while (cur.kind == T_IDENT) {
        names = NULL;
        ntail = &names;
        for (;;) {
            if (cur.kind != T_IDENT)
                die("parse:%d: expected variable name",
                    cur.line);
            n = new_node(N_VARDECL, cur.line);
            n->name = cur.sval;
            advance();
            *ntail = n;
            ntail = &n->next;
            if (!accept(T_COMMA))
                break;
        }
        expect(T_COLON, ":");
        {
            char *tname = NULL;
            if (!accept_type(&tname))
                die("parse:%d: expected type", cur.line);
            for (n = names; n; n = n->next)
                n->sval = tname;
        }
        if (accept(T_EQ))
            names->a = parse_expr();
        expect(T_SEMI, ";");
        /* append names list to head */
        *tail = names;
        while (*tail)
            tail = &(*tail)->next;
    }
    return head;
}

static struct node *
parse_block(void)
{
    struct node *n;
    struct node *consts, *vars, *procs;
    struct node **ctail, **vtail, **ptail;
    struct node *saved_anon_types;
    struct node **saved_anon_ttail;
    int line;

    line = cur.line;
    consts = NULL;
    vars = NULL;
    procs = NULL;
    ctail = &consts;
    vtail = &vars;
    ptail = &procs;
    saved_anon_types = anon_types;
    saved_anon_ttail = anon_ttail;
    anon_types = NULL;
    anon_ttail = &anon_types;

    for (;;) {
        if (cur.kind == T_CONST) {
            struct node *c = parse_const_section(&vtail);
            *ctail = c;
            while (*ctail)
                ctail = &(*ctail)->next;
            continue;
        }
        if (cur.kind == T_TYPE) {
            struct node *c = parse_type_section();
            *ctail = c;
            while (*ctail)
                ctail = &(*ctail)->next;
            continue;
        }
        if (cur.kind == T_VAR) {
            struct node *v = parse_var_section();
            *vtail = v;
            while (*vtail)
                vtail = &(*vtail)->next;
            continue;
        }
        if (cur.kind == T_PROCEDURE || cur.kind == T_FUNCTION) {
            struct node *decl;
            int is_func = (cur.kind == T_FUNCTION);
            int dline = cur.line;
            advance();

            decl = new_node(is_func ? N_FUNCDECL :
                                      N_PROCDECL, dline);
            if (cur.kind != T_IDENT)
                die("parse:%d: expected %s name",
                    cur.line,
                    is_func ? "function" : "procedure");
            decl->name = cur.sval;
            decl->raw_name = cur.raw;   /* for an external symbol's exact case */
            advance();

            if (cur.kind == T_LPAREN)
                parse_param_list(&decl->a);

            if (is_func) {
                char *rtname = NULL;
                expect(T_COLON, ":");
                if (!accept_type(&rtname))
                    die("parse:%d: expected return type",
                        cur.line);
                decl->sval = rtname;
            }
            expect(T_SEMI, ";");

            /* optional `export;` marks the routine visible across the FFI; for
               a standalone link it has no effect, so it is consumed. */
            if (cur.kind == T_IDENT && strcmp(cur.sval, "export") == 0) {
                advance();
                expect(T_SEMI, ";");
            }

            if (accept(T_FORWARD)) {
                decl->is_forward = 1;
                expect(T_SEMI, ";");
            } else if (cur.kind == T_IDENT &&
                       strcmp(cur.sval, "external") == 0) {
                /* a host import: `external [cdecl];` has no body.  cdecl names
                   the C/SysV calling convention, which is already how the
                   compiler emits an external call, so it is accepted and
                   ignored.  `external`/`cdecl` are not reserved words. */
                decl->is_external = 1;
                advance();
                if (cur.kind == T_IDENT && strcmp(cur.sval, "cdecl") == 0)
                    advance();
                expect(T_SEMI, ";");
            } else {
                decl->b = parse_block();
                expect(T_SEMI, ";");
            }

            *ptail = decl;
            ptail = &decl->next;
            continue;
        }
        break;
    }

    if (anon_types) {
        struct node *last = anon_types;
        while (last->next)
            last = last->next;
        last->next = consts;
        consts = anon_types;
    }
    anon_types = saved_anon_types;
    anon_ttail = saved_anon_ttail;

    n = new_node(N_BLOCK, line);
    n->a = consts;
    n->b = vars;
    n->c = procs;
    n->d = parse_compound();
    return n;
}

/****************************************************************
 * Top level
 ****************************************************************/

struct node *
parse_program(struct arena *a)
{
    parse_arena = a;
    struct node *prog;
    int line;

    advance();
    line = cur.line;
    expect(T_PROGRAM, "program");
    prog = new_node(N_PROGRAM, line);
    if (cur.kind != T_IDENT)
        die("parse:%d: expected program name", cur.line);
    prog->name = cur.sval;
    advance();
    expect(T_SEMI, ";");
    prog->a = parse_block();
    expect(T_DOT, ".");
    return prog;
}
