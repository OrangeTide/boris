/* macro.c : macro table and expansion */

#include "internal.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static unsigned
hash_name(const char *name)
{
    unsigned h = 0;
    while (*name)
        h = h * 31 + (unsigned char)*name++;
    return h % CPP_HTAB_SIZE;
}

void
macro_define(struct cpp *p, const char *name, struct pp_token *body,
             int is_func, int nparams, char **params, int is_variadic)
{
    unsigned h = hash_name(name);
    struct cpp_macro *m = p->macros[h];
    while (m) {
        if (strcmp(m->name, name) == 0) {
            pp_free_tokens(m->body);
            for (int i = 0; i < m->nparams; i++)
                free(m->params[i]);
            free(m->params);
            m->body = body;
            m->is_func = is_func;
            m->nparams = nparams;
            m->params = params;
            m->is_variadic = is_variadic;
            m->builtin = BUILTIN_NONE;
            return;
        }
        m = m->next;
    }
    m = xmalloc(sizeof *m);
    m->name = xstrdup(name);
    m->is_func = is_func;
    m->nparams = nparams;
    m->is_variadic = is_variadic;
    m->params = params;
    m->body = body;
    m->builtin = BUILTIN_NONE;
    m->expanding = 0;
    m->next = p->macros[h];
    p->macros[h] = m;
}

void
macro_undef(struct cpp *p, const char *name)
{
    unsigned h = hash_name(name);
    struct cpp_macro **pp = &p->macros[h];
    while (*pp) {
        struct cpp_macro *m = *pp;
        if (strcmp(m->name, name) == 0) {
            *pp = m->next;
            free(m->name);
            pp_free_tokens(m->body);
            for (int i = 0; i < m->nparams; i++)
                free(m->params[i]);
            free(m->params);
            free(m);
            return;
        }
        pp = &m->next;
    }
}

struct cpp_macro *
macro_lookup(struct cpp *p, const char *name)
{
    unsigned h = hash_name(name);
    struct cpp_macro *m = p->macros[h];
    while (m) {
        if (strcmp(m->name, name) == 0)
            return m;
        m = m->next;
    }
    return NULL;
}

static struct pp_token *
skip_space(struct pp_token *t)
{
    while (t && t->kind == PP_SPACE)
        t = t->next;
    return t;
}

static struct pp_token *
stringify_tokens(struct pp_token *list)
{
    char buf[4096];
    int pos = 0;
    buf[pos++] = '"';
    for (struct pp_token *t = list; t; t = t->next) {
        if (t->kind == PP_SPACE) {
            if (pos < (int)sizeof(buf) - 2)
                buf[pos++] = ' ';
            continue;
        }
        for (int i = 0; i < t->len && pos < (int)sizeof(buf) - 3; i++) {
            char c = t->text[i];
            if (c == '"' || c == '\\')
                buf[pos++] = '\\';
            buf[pos++] = c;
        }
    }
    buf[pos++] = '"';
    buf[pos] = '\0';

    struct pp_token *r = xmalloc(sizeof *r);
    r->kind = PP_STRING;
    r->text = xstrndup(buf, pos);
    r->len = pos;
    r->blue = 0;
    r->next = NULL;
    return r;
}

static struct pp_token *
paste_tokens(struct pp_token *left, struct pp_token *right)
{
    int len = left->len + right->len;
    char *text = xmalloc(len + 1);
    memcpy(text, left->text, left->len);
    memcpy(text + left->len, right->text, right->len);
    text[len] = '\0';

    struct pp_token *r = xmalloc(sizeof *r);
    r->len = len;
    r->text = text;
    r->blue = 0;
    r->next = NULL;

    if (len == 0) {
        r->kind = PP_PLACEMARKER;
    } else if (isalpha(text[0]) || text[0] == '_') {
        r->kind = PP_IDENT;
    } else if (isdigit(text[0])) {
        r->kind = PP_NUMBER;
    } else {
        r->kind = PP_PUNCT;
    }
    return r;
}

static int
find_param(struct cpp_macro *m, const char *name, int len)
{
    for (int i = 0; i < m->nparams; i++) {
        if ((int)strlen(m->params[i]) == len &&
            memcmp(m->params[i], name, len) == 0)
            return i;
    }
    if (m->is_variadic && len == 11 &&
        memcmp(name, "__VA_ARGS__", 11) == 0)
        return m->nparams;
    return -1;
}

static struct pp_token *
strip_leading_space(struct pp_token *list)
{
    while (list && list->kind == PP_SPACE) {
        struct pp_token *next = list->next;
        free(list->text);
        free(list);
        list = next;
    }
    return list;
}

static struct pp_token **
collect_args(struct pp_token *open, int nparams, int is_variadic, int *nargs)
{
    struct pp_token *t = open->next;
    t = skip_space(t);

    int cap = nparams > 0 ? nparams : 1;
    if (is_variadic)
        cap++;
    struct pp_token **args = xcalloc(cap + 1, sizeof(struct pp_token *));
    struct pp_token *arg_heads[64] = {0};
    struct pp_token *arg_tails[64] = {0};
    int argc = 0;
    int depth = 0;

    while (t) {
        if (t->kind == PP_PUNCT && t->len == 1 && t->text[0] == '(') {
            depth++;
        } else if (t->kind == PP_PUNCT && t->len == 1 && t->text[0] == ')') {
            if (depth == 0)
                break;
            depth--;
        } else if (t->kind == PP_PUNCT && t->len == 1 &&
                   t->text[0] == ',' && depth == 0) {
            if (!is_variadic || argc < nparams) {
                argc++;
                if (argc >= 64)
                    break;
                t = t->next;
                continue;
            }
        }

        struct pp_token *copy = pp_token_dup(t);
        if (!arg_heads[argc]) {
            arg_heads[argc] = copy;
            arg_tails[argc] = copy;
        } else {
            arg_tails[argc]->next = copy;
            arg_tails[argc] = copy;
        }
        t = t->next;
    }
    argc++;

    for (int i = 0; i < argc && i <= cap; i++)
        args[i] = strip_leading_space(arg_heads[i]);
    *nargs = argc;
    return args;
}

static struct pp_token *
find_closing_paren(struct pp_token *open)
{
    struct pp_token *t = open->next;
    int depth = 0;
    while (t) {
        if (t->kind == PP_PUNCT && t->len == 1 && t->text[0] == '(')
            depth++;
        else if (t->kind == PP_PUNCT && t->len == 1 && t->text[0] == ')') {
            if (depth == 0)
                return t;
            depth--;
        }
        t = t->next;
    }
    return NULL;
}

static struct pp_token *
substitute(struct cpp *p, struct cpp_macro *m, struct pp_token **args, int nargs)
{
    struct pp_token head = {0};
    struct pp_token *tail = &head;
    (void)p;

    struct pp_token *b = m->body;
    while (b) {
        /* stringification: # param */
        if (b->kind == PP_PUNCT && b->len == 1 && b->text[0] == '#' &&
            b->next && b->next->kind == PP_IDENT) {
            int idx = find_param(m, b->next->text, b->next->len);
            if (idx >= 0 && idx < nargs) {
                tail->next = stringify_tokens(args[idx]);
                tail = tail->next;
                b = b->next->next;
                continue;
            }
        }

        /* token pasting: X ## Y */
        if (b->next && b->next->kind == PP_PUNCT && b->next->len == 2 &&
            b->next->text[0] == '#' && b->next->text[1] == '#' &&
            b->next->next) {
            struct pp_token *lhs;
            int lidx = (b->kind == PP_IDENT) ?
                       find_param(m, b->text, b->len) : -1;
            if (lidx >= 0 && lidx < nargs && args[lidx]) {
                struct pp_token *al = pp_list_dup(args[lidx]);
                struct pp_token *last = al;
                while (last && last->next)
                    last = last->next;
                lhs = last;
                if (al != last) {
                    tail->next = al;
                    while (tail->next != last)
                        tail = tail->next;
                }
            } else if (lidx >= 0) {
                lhs = NULL;
            } else {
                lhs = pp_token_dup(b);
            }

            struct pp_token *rhs_tok = b->next->next;
            int ridx = (rhs_tok->kind == PP_IDENT) ?
                       find_param(m, rhs_tok->text, rhs_tok->len) : -1;
            struct pp_token *rhs;
            struct pp_token *rhs_rest = NULL;
            if (ridx >= 0 && ridx < nargs && args[ridx]) {
                struct pp_token *ar = pp_list_dup(args[ridx]);
                rhs = ar;
                if (ar)
                    rhs_rest = ar->next;
            } else if (ridx >= 0) {
                rhs = NULL;
            } else {
                rhs = pp_token_dup(rhs_tok);
            }

            if (lhs && rhs) {
                tail->next = paste_tokens(lhs, rhs);
                tail = tail->next;
                pp_free_tokens(lhs);
                pp_free_tokens(rhs);
            } else if (lhs) {
                tail->next = lhs;
                tail = tail->next;
            } else if (rhs) {
                tail->next = rhs;
                tail = tail->next;
            }

            if (rhs_rest) {
                tail->next = rhs_rest;
                while (tail->next)
                    tail = tail->next;
            }

            b = rhs_tok->next;
            continue;
        }

        /* parameter substitution */
        if (b->kind == PP_IDENT) {
            int idx = find_param(m, b->text, b->len);
            if (idx >= 0 && idx < nargs) {
                struct pp_token *expanded = macro_expand(p, pp_list_dup(args[idx]));
                if (expanded) {
                    tail->next = expanded;
                    while (tail->next)
                        tail = tail->next;
                }
                b = b->next;
                continue;
            }
        }

        tail->next = pp_token_dup(b);
        tail = tail->next;
        b = b->next;
    }

    return head.next;
}

struct pp_token *
macro_expand(struct cpp *p, struct pp_token *input)
{
    struct pp_token head = {0};
    struct pp_token *tail = &head;

    struct pp_token *t = input;
    while (t) {
        if (t->kind != PP_IDENT || t->blue) {
            struct pp_token *copy = pp_token_dup(t);
            tail->next = copy;
            tail = tail->next;
            t = t->next;
            continue;
        }

        struct cpp_macro *m = macro_lookup(p, t->text);
        if (!m || m->expanding) {
            tail->next = pp_token_dup(t);
            tail = tail->next;
            t = t->next;
            continue;
        }

        /* builtin macros */
        if (m->builtin) {
            char buf[64];
            switch (m->builtin) {
            case BUILTIN_LINE:
                snprintf(buf, sizeof buf, "%d",
                         p->file ? p->file->line : 0);
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup(buf);
                tail->next->len = (int)strlen(buf);
                tail->next->kind = PP_NUMBER;
                break;
            case BUILTIN_FILE:
                snprintf(buf, sizeof buf, "\"%s\"",
                         p->file ? p->file->path : "");
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup(buf);
                tail->next->len = (int)strlen(buf);
                tail->next->kind = PP_STRING;
                break;
            case BUILTIN_DATE:
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup(p->date_str);
                tail->next->len = (int)strlen(p->date_str);
                tail->next->kind = PP_STRING;
                break;
            case BUILTIN_TIME:
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup(p->time_str);
                tail->next->len = (int)strlen(p->time_str);
                tail->next->kind = PP_STRING;
                break;
            case BUILTIN_STDC:
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup("1");
                tail->next->len = 1;
                tail->next->kind = PP_NUMBER;
                break;
            case BUILTIN_STDC_VERSION:
                tail->next = pp_token_dup(t);
                free(tail->next->text);
                tail->next->text = xstrdup("199901L");
                tail->next->len = 7;
                tail->next->kind = PP_NUMBER;
                break;
            }
            tail = tail->next;
            t = t->next;
            continue;
        }

        if (!m->is_func) {
            struct pp_token *replacement = pp_list_dup(m->body);
            struct pp_token *rest = t->next;
            m->expanding = 1;
            struct pp_token *expanded = macro_expand(p, replacement);
            m->expanding = 0;
            /* Blue-paint self-references to prevent re-expansion */
            int namelen = (int)strlen(m->name);
            for (struct pp_token *tok = expanded; tok; tok = tok->next) {
                if (tok->kind == PP_IDENT && tok->len == namelen &&
                    memcmp(tok->text, m->name, namelen) == 0)
                    tok->blue = 1;
            }
            if (expanded) {
                tail->next = expanded;
                while (tail->next)
                    tail = tail->next;
            }
            t = rest;
            continue;
        }

        /* function-like macro: need '(' */
        struct pp_token *after_name = t->next;
        struct pp_token *lparen = skip_space(after_name);
        if (!lparen || lparen->kind != PP_PUNCT ||
            lparen->len != 1 || lparen->text[0] != '(') {
            tail->next = pp_token_dup(t);
            tail = tail->next;
            t = t->next;
            continue;
        }

        struct pp_token *rparen = find_closing_paren(lparen);
        if (!rparen) {
            warn("unterminated macro arguments for '%s'", m->name);
            tail->next = pp_token_dup(t);
            tail = tail->next;
            t = t->next;
            continue;
        }

        int nargs = 0;
        struct pp_token **args = collect_args(lparen, m->nparams,
                                              m->is_variadic, &nargs);

        struct pp_token *replacement = substitute(p, m, args, nargs);
        m->expanding = 1;
        struct pp_token *expanded = macro_expand(p, replacement);
        m->expanding = 0;
        /* Blue-paint self-references to prevent re-expansion */
        int namelen = (int)strlen(m->name);
        for (struct pp_token *tok = expanded; tok; tok = tok->next) {
            if (tok->kind == PP_IDENT && tok->len == namelen &&
                memcmp(tok->text, m->name, namelen) == 0)
                tok->blue = 1;
        }

        for (int i = 0; i < nargs; i++)
            pp_free_tokens(args[i]);
        free(args);

        if (expanded) {
            struct pp_token *last = expanded;
            while (last->next)
                last = last->next;
            struct cpp_macro *bm = NULL;
            if (last->kind == PP_IDENT && !last->blue)
                bm = macro_lookup(p, last->text);
            if (bm && bm->is_func && !bm->expanding) {
                struct pp_token *peek = skip_space(rparen->next);
                if (peek && peek->kind == PP_PUNCT &&
                    peek->len == 1 && peek->text[0] == '(') {
                    last->next = rparen->next;
                    rparen->next = NULL;
                    struct pp_token *final = macro_expand(p, expanded);
                    if (final) {
                        tail->next = final;
                        while (tail->next)
                            tail = tail->next;
                    }
                    t = NULL;
                    continue;
                }
            }
            tail->next = expanded;
            while (tail->next)
                tail = tail->next;
        }
        t = rparen->next;
    }

    pp_free_tokens(input);
    return head.next;
}
