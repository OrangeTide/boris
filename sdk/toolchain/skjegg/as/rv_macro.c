/* rv_macro.c : GAS .macro / .endm expansion for the RV32 assembler.
 *
 * A line-based pre-pass run once before the sizing and emit passes, so the
 * multi-pass assembler core never sees a macro.  Supports parameterless
 * macros (what the runtime uses) and positional parameters substituted as
 * `\name` in the body.  Macro bodies may invoke earlier macros (bounded
 * recursion); definitions must precede use. */

#include "rv.h"

#include <stdlib.h>
#include <string.h>

#define MAX_PARAMS 16
#define MAX_MACROS 64
#define EXPAND_DEPTH 32

struct macro {
    char *name;
    char *params[MAX_PARAMS];
    int nparams;
    char *body;                 /* the text between .macro and .endm */
};

struct buf {
    char *p;
    size_t len;
    size_t cap;
};

static void
buf_add(struct buf *b, const char *s, size_t n)
{
    if (b->len + n + 1 > b->cap) {
        while (b->len + n + 1 > b->cap)
            b->cap = b->cap ? b->cap * 2 : 1024;
        b->p = realloc(b->p, b->cap);
    }
    memcpy(b->p + b->len, s, n);
    b->len += n;
    b->p[b->len] = '\0';
}

/* The first whitespace-delimited token of a line, stopping at ':' too so a
 * label is not mistaken for a macro call.  Returns the token bounds and the
 * offset just past it. */
static const char *
first_token(const char *line, const char **tok, int *toklen, char *stop_colon)
{
    const char *p = line;
    const char *t;
    while (*p == ' ' || *p == '\t')
        p++;
    t = p;
    while (*p && *p != ' ' && *p != '\t' && *p != '\n'
           && *p != ',' && *p != ':')
        p++;
    *tok = t;
    *toklen = (int)(p - t);
    *stop_colon = (*p == ':');
    return p;
}

static int
tokeq(const char *tok, int len, const char *s)
{
    return (int)strlen(s) == len && strncmp(tok, s, (size_t)len) == 0;
}

/* Copy the macro body to the output, substituting \param with the call's
 * argument text, recursing so a body may call another macro. */
static void expand_line(struct buf *out, const char *line, size_t linelen,
                        struct macro *macros, int nmacros, int depth);

static void
expand_call(struct buf *out, struct macro *m, const char *args,
            struct macro *macros, int nmacros, int depth)
{
    char *argv[MAX_PARAMS];
    int argc = 0;
    char *argbuf;
    const char *body;

    /* split args by comma, trimming surrounding whitespace */
    {
        const char *p = args;
        struct buf ab = {0};
        while (*p && *p != '\n' && argc < MAX_PARAMS) {
            const char *s;
            const char *e;
            while (*p == ' ' || *p == '\t')
                p++;
            s = p;
            while (*p && *p != ',' && *p != '\n')
                p++;
            e = p;
            while (e > s && (e[-1] == ' ' || e[-1] == '\t'))
                e--;
            argv[argc] = (char *)(uintptr_t)ab.len;   /* offset for now */
            buf_add(&ab, s, (size_t)(e - s));
            buf_add(&ab, "", 1);                       /* NUL terminator */
            argc++;
            if (*p == ',')
                p++;
        }
        argbuf = ab.p;
        /* resolve offsets to pointers */
        {
            int i;
            for (i = 0; i < argc; i++)
                argv[i] = argbuf + (size_t)(uintptr_t)argv[i];
        }
    }

    /* walk the body, emitting a line at a time with \param substitution */
    body = m->body;
    while (*body) {
        struct buf line = {0};
        const char *nl = strchr(body, '\n');
        const char *end = nl ? nl + 1 : body + strlen(body);
        const char *p = body;
        while (p < end) {
            if (*p == '\\' && p + 1 < end) {
                /* match the longest parameter name */
                int i, best = -1, blen = 0;
                for (i = 0; i < m->nparams; i++) {
                    int pl = (int)strlen(m->params[i]);
                    if (pl > blen
                        && strncmp(p + 1, m->params[i], (size_t)pl) == 0) {
                        best = i; blen = pl;
                    }
                }
                if (best >= 0 && best < argc) {
                    buf_add(&line, argv[best], strlen(argv[best]));
                    p += 1 + blen;
                    continue;
                }
                if (best >= 0) {            /* param with no argument */
                    p += 1 + blen;
                    continue;
                }
            }
            buf_add(&line, p, 1);
            p++;
        }
        expand_line(out, line.p ? line.p : "", line.len,
                    macros, nmacros, depth + 1);
        free(line.p);
        body = end;
    }

    free(argbuf);
}

static void
expand_line(struct buf *out, const char *line, size_t linelen,
            struct macro *macros, int nmacros, int depth)
{
    const char *tok;
    int toklen;
    char is_label;
    const char *rest;
    int i;

    if (depth > EXPAND_DEPTH) {
        buf_add(out, line, linelen);
        return;
    }

    rest = first_token(line, &tok, &toklen, &is_label);
    if (!is_label && toklen > 0) {
        for (i = 0; i < nmacros; i++) {
            if (tokeq(tok, toklen, macros[i].name)) {
                expand_call(out, &macros[i], rest, macros, nmacros, depth);
                return;
            }
        }
    }
    buf_add(out, line, linelen);
}

char *
rv_expand_macros(struct arena *a, const char *src)
{
    struct macro macros[MAX_MACROS];
    int nmacros = 0;
    struct buf out = {0};
    const char *p = src;
    char *result;

    while (*p) {
        const char *nl = strchr(p, '\n');
        const char *end = nl ? nl + 1 : p + strlen(p);
        const char *tok;
        int toklen;
        char is_label;

        first_token(p, &tok, &toklen, &is_label);

        if (tokeq(tok, toklen, ".macro") && nmacros < MAX_MACROS) {
            struct macro *m = &macros[nmacros];
            const char *q = tok + toklen;
            struct buf body = {0};

            memset(m, 0, sizeof(*m));
            /* macro name */
            while (*q == ' ' || *q == '\t') q++;
            {
                const char *s = q;
                while (*q && *q != ' ' && *q != '\t' && *q != '\n'
                       && *q != ',')
                    q++;
                m->name = arena_strndup(a, s, (size_t)(q - s));
            }
            /* parameters */
            while (*q && *q != '\n' && m->nparams < MAX_PARAMS) {
                const char *s;
                while (*q == ' ' || *q == '\t' || *q == ',') q++;
                if (*q == '\n' || !*q) break;
                s = q;
                while (*q && *q != ' ' && *q != '\t' && *q != '\n'
                       && *q != ',')
                    q++;
                if (q > s)
                    m->params[m->nparams++] =
                        arena_strndup(a, s, (size_t)(q - s));
            }

            /* collect the body up to .endm */
            p = end;
            while (*p) {
                const char *bnl = strchr(p, '\n');
                const char *bend = bnl ? bnl + 1 : p + strlen(p);
                const char *bt;
                int btl;
                char bl;
                first_token(p, &bt, &btl, &bl);
                if (tokeq(bt, btl, ".endm")) {
                    p = bend;
                    break;
                }
                buf_add(&body, p, (size_t)(bend - p));
                p = bend;
            }
            m->body = arena_strndup(a, body.p ? body.p : "", body.len);
            free(body.p);
            nmacros++;
            continue;
        }

        expand_line(&out, p, (size_t)(end - p), macros, nmacros, 0);
        p = end;
    }

    result = arena_strndup(a, out.p ? out.p : "", out.len);
    free(out.p);
    return result;
}
