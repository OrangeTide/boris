/* lex.c : hand-written lexer for Compact Pascal */

#include "pascal.h"
#include "target.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Maximum record field alignment: the target pointer width (4 on ILP32, 8 on
   LP64). Each field is aligned to its own natural boundary capped by this (see
   field_align in lower.c), so a 4-byte integer aligns to 4 on every target
   while a pointer or 64-bit field on LP64 aligns to 8. The 8-byte cap matters
   because an LP64 pointer relocation must land on an 8-aligned offset (the
   Mach-O static linker rejects an unaligned one; GNU ld tolerates it). {$A n}
   lowers the cap (e.g. {$A 1} packs). */
int lex_align = SKJ_PTR_BYTES;
int lex_rangechecks;
int lex_overflowchecks;

static struct arena *lex_arena;
static const char *src_buf;
static const char *src_file;
static const char *p;
static int line;
static int peeked;
static struct token peek_tok;

#define MAX_DEFINES 64
static char *defines[MAX_DEFINES];
static int ndefines;

#define MAX_IFDEF_DEPTH 16
static int ifdef_skip[MAX_IFDEF_DEPTH];
static int ifdef_depth;

/* {$I file} include stack: the lexer splices an included file's text in place,
   resuming the parent source at the include's end. */
#define MAX_INCLUDE 8
static struct {
    const char *p;
    int line;
    const char *src_file;
} inc_stack[MAX_INCLUDE];
static int inc_depth;

/* Read a whole file into a NUL-terminated arena buffer, or NULL if it cannot
   be opened. */
static char *
read_file_z(const char *path)
{
    FILE *f = fopen(path, "rb");
    long n;
    char *buf;

    if (!f)
        return NULL;
    if (fseek(f, 0, SEEK_END) != 0) {
        fclose(f);
        return NULL;
    }
    n = ftell(f);
    if (n < 0 || fseek(f, 0, SEEK_SET) != 0) {
        fclose(f);
        return NULL;
    }
    buf = arena_alloc(lex_arena, (size_t)n + 1);
    if (fread(buf, 1, (size_t)n, f) != (size_t)n) {
        fclose(f);
        return NULL;
    }
    buf[n] = '\0';
    fclose(f);
    return buf;
}

/* Resolve an include path relative to the current source file's directory
   (an absolute path or a src_file with no directory is used as given). */
static const char *
resolve_include(const char *arg)
{
    const char *slash = strrchr(src_file, '/');
    size_t dlen;
    char *full;

    if (arg[0] == '/' || !slash)
        return arg;
    dlen = (size_t)(slash - src_file) + 1;
    full = arena_alloc(lex_arena, dlen + strlen(arg) + 1);
    memcpy(full, src_file, dlen);
    strcpy(full + dlen, arg);
    return full;
}

static int
ci_streq(const char *a, const char *b)
{
    for (; *a && *b; a++, b++)
        if (tolower((unsigned char)*a) != tolower((unsigned char)*b))
            return 0;
    return *a == *b;
}

static int
is_defined(const char *name)
{
    for (int i = 0; i < ndefines; i++)
        if (ci_streq(defines[i], name))
            return 1;
    return 0;
}

static void
add_define(const char *name)
{
    if (is_defined(name))
        return;
    if (ndefines >= MAX_DEFINES)
        die("too many defines");
    defines[ndefines++] = arena_strdup(lex_arena, name);
}

static void
remove_define(const char *name)
{
    for (int i = 0; i < ndefines; i++) {
        if (ci_streq(defines[i], name)) {
            defines[i] = defines[--ndefines];
            return;
        }
    }
}

/* Predefine a conditional symbol (the -d command-line option); call after
   lex_init, which resets the define table. */
void
lex_define(const char *name)
{
    add_define(name);
}

static int
skipping(void)
{
    for (int i = 0; i < ifdef_depth; i++)
        if (ifdef_skip[i])
            return 1;
    return 0;
}

struct kw {
    const char *s;
    int k;
};

static const struct kw keywords[] = {
    { "and",       T_AND },
    { "begin",     T_BEGIN },
    { "boolean",   T_BOOLEAN },
    { "break",     T_BREAK },
    { "byte",      T_BYTE },
    { "case",      T_CASE },
    { "char",      T_CHAR },
    { "const",     T_CONST },
    { "continue",  T_CONTINUE },
    { "div",       T_DIV },
    { "do",        T_DO },
    { "downto",    T_DOWNTO },
    { "else",      T_ELSE },
    { "end",       T_END },
    { "false",     T_FALSE },
    { "for",       T_FOR },
    { "forward",   T_FORWARD },
    { "function",  T_FUNCTION },
    { "if",        T_IF },
    { "in",        T_IN },
    { "integer",   T_INTEGER },
    { "mod",       T_MOD },
    { "not",       T_NOT },
    { "of",        T_OF },
    { "or",        T_OR },
    { "procedure", T_PROCEDURE },
    { "program",   T_PROGRAM },
    { "repeat",    T_REPEAT },
    { "set",       T_SET },
    { "shl",       T_SHL },
    { "sizeof",    T_SIZEOF },
    { "shr",       T_SHR },
    { "then",      T_THEN },
    { "to",        T_TO },
    { "true",      T_TRUE },
    { "type",      T_TYPE },
    { "until",     T_UNTIL },
    { "var",       T_VAR },
    { "while",     T_WHILE },
    { "with",      T_WITH },
    /* `word` is a predefined type identifier, not a reserved word, so a program
       may also use it as an ordinary name (kpcom has a local called word);
       accept_type resolves the bare identifier as the Word type. */
    { NULL, 0 },
};

void
lex_init(struct arena *a, const char *src, const char *filename)
{
    lex_arena = a;
    src_buf = src;
    src_file = filename ? filename : "<input>";
    p = src;
    line = 1;
    peeked = 0;
    ndefines = 0;
    ifdef_depth = 0;
    inc_depth = 0;
    lex_align = SKJ_PTR_BYTES;
    lex_rangechecks = 0;
    lex_overflowchecks = 0;
    add_define("CPAS");
}

static void
skip_ws(void)
{
    for (;;) {
        /* at the end of an included file, resume the parent source */
        if (*p == '\0' && inc_depth > 0) {
            inc_depth--;
            p = inc_stack[inc_depth].p;
            line = inc_stack[inc_depth].line;
            src_file = inc_stack[inc_depth].src_file;
            continue;
        }
        while (*p == ' ' || *p == '\t' || *p == '\r')
            p++;
        if (*p == '\n') {
            line++;
            p++;
            continue;
        }
        /* // line comment */
        if (p[0] == '/' && p[1] == '/') {
            while (*p && *p != '\n')
                p++;
            continue;
        }
        /* { brace comment } — with directive handling */
        if (*p == '{') {
            p++;
            if (*p == '$') {
                char dir[32], arg[64];
                int di = 0, ai = 0;
                p++;
                while (*p && *p != '}' && !isspace((unsigned char)*p) &&
                       di < (int)sizeof(dir) - 1)
                    dir[di++] = (char)toupper((unsigned char)*p++);
                dir[di] = '\0';
                while (*p && *p != '}' && isspace((unsigned char)*p)) {
                    if (*p == '\n')
                        line++;
                    p++;
                }
                while (*p && *p != '}' &&
                       ai < (int)sizeof(arg) - 1) {
                    if (*p == '\n')
                        line++;
                    arg[ai++] = *p++;
                }
                arg[ai] = '\0';
                while (ai > 0 && isspace((unsigned char)arg[ai - 1]))
                    arg[--ai] = '\0';
                if (*p == '}')
                    p++;
                if (strcmp(dir, "IFDEF") == 0) {
                    if (ifdef_depth >= MAX_IFDEF_DEPTH)
                        die("%s:%d: ifdef nesting too deep",
                            src_file, line);
                    ifdef_skip[ifdef_depth++] =
                        !is_defined(arg);
                } else if (strcmp(dir, "IFNDEF") == 0) {
                    if (ifdef_depth >= MAX_IFDEF_DEPTH)
                        die("%s:%d: ifdef nesting too deep",
                            src_file, line);
                    ifdef_skip[ifdef_depth++] =
                        is_defined(arg);
                } else if (strcmp(dir, "ELSE") == 0) {
                    if (ifdef_depth == 0)
                        die("%s:%d: $ELSE without $IFDEF",
                            src_file, line);
                    ifdef_skip[ifdef_depth - 1] =
                        !ifdef_skip[ifdef_depth - 1];
                } else if (strcmp(dir, "ENDIF") == 0) {
                    if (ifdef_depth == 0)
                        die("%s:%d: $ENDIF without $IFDEF",
                            src_file, line);
                    ifdef_depth--;
                } else if (!skipping()) {
                    if (strcmp(dir, "I") == 0 ||
                        strcmp(dir, "INCLUDE") == 0) {
                        /* splice an included file's text in place */
                        const char *path = resolve_include(arg);
                        char *content = read_file_z(path);
                        if (!content)
                            content = read_file_z(arg);
                        if (!content)
                            die("%s:%d: cannot open include '%s'",
                                src_file, line, arg);
                        if (inc_depth >= MAX_INCLUDE)
                            die("%s:%d: include nesting too deep",
                                src_file, line);
                        inc_stack[inc_depth].p = p;
                        inc_stack[inc_depth].line = line;
                        inc_stack[inc_depth].src_file = src_file;
                        inc_depth++;
                        p = content;
                        line = 1;
                        src_file = arena_strdup(lex_arena, arg);
                    } else if (strcmp(dir, "DEFINE") == 0)
                        add_define(arg);
                    else if (strcmp(dir, "UNDEF") == 0)
                        remove_define(arg);
                    else if (strcmp(dir, "ALIGN") == 0) {
                        int v = atoi(arg);
                        if (v == 1 || v == 2 ||
                            v == 4 || v == 8 ||
                            v == 16)
                            lex_align = v;
                    } else if (strcmp(dir, "R+") == 0)
                        lex_rangechecks = 1;
                    else if (strcmp(dir, "R-") == 0)
                        lex_rangechecks = 0;
                    else if (strcmp(dir, "Q+") == 0)
                        lex_overflowchecks = 1;
                    else if (strcmp(dir, "Q-") == 0)
                        lex_overflowchecks = 0;
                }
                continue;
            }
            while (*p && *p != '}') {
                if (*p == '\n')
                    line++;
                p++;
            }
            if (*p)
                p++;
            continue;
        }
        /* (* paren-star comment *) */
        if (p[0] == '(' && p[1] == '*') {
            p += 2;
            while (*p && !(p[0] == '*' && p[1] == ')')) {
                if (*p == '\n')
                    line++;
                p++;
            }
            if (*p)
                p += 2;
            continue;
        }
        /* #! shebang on first line */
        if (p[0] == '#' && p[1] == '!' && p == src_buf) {
            while (*p && *p != '\n')
                p++;
            continue;
        }
        if (skipping() && *p) {
            if (*p == '\'') {
                p++;
                while (*p && *p != '\'') {
                    if (*p == '\n')
                        line++;
                    p++;
                }
                if (*p)
                    p++;
            } else {
                if (*p == '\n')
                    line++;
                p++;
            }
            continue;
        }
        break;
    }
}

static int
ci_match(const char *kw, const char *id, size_t len)
{
    if (strlen(kw) != len)
        return 0;
    for (size_t i = 0; i < len; i++) {
        if (tolower((unsigned char)id[i]) != kw[i])
            return 0;
    }
    return 1;
}

static struct token
make(int k)
{
    struct token t;

    t.kind = k;
    t.nval = 0;
    t.fval = 0;
    t.sval = NULL;
    t.slen = 0;
    t.line = line;
    return t;
}

static void
str_append(char **buf, size_t *cap, size_t *len, int ch)
{
    if (*len + 1 >= *cap) {
        *cap *= 2;
        *buf = realloc(*buf, *cap);
        if (!*buf)
            die("oom");
    }
    (*buf)[(*len)++] = (char)ch;
}

static struct token
lex_string(void)
{
    struct token t;
    char *buf;
    size_t cap, len;

    cap = 16;
    len = 0;
    buf = xmalloc(cap);

    for (;;) {
        if (*p == '\'') {
            p++;
            for (;;) {
                if (*p == '\0')
                    die("%s:%d: unterminated string",
                        src_file, line);
                if (*p == '\'') {
                    p++;
                    if (*p != '\'')
                        break;
                    str_append(&buf, &cap, &len, '\'');
                    p++;
                    continue;
                }
                if (*p == '\n')
                    die("%s:%d: newline in string",
                        src_file, line);
                str_append(&buf, &cap, &len,
                           (unsigned char)*p++);
            }
        } else if (*p == '#') {
            /* #nn character constant concatenation */
            long v;
            p++;
            if (*p == '$') {
                p++;
                if (!isxdigit((unsigned char)*p))
                    die("%s:%d: bad #$ escape",
                        src_file, line);
                v = 0;
                while (isxdigit((unsigned char)*p)) {
                    int d;
                    int c = (unsigned char)*p;
                    if (c >= '0' && c <= '9')
                        d = c - '0';
                    else if (c >= 'a' && c <= 'f')
                        d = 10 + c - 'a';
                    else
                        d = 10 + c - 'A';
                    v = (v << 4) | d;
                    p++;
                }
            } else {
                if (!isdigit((unsigned char)*p))
                    die("%s:%d: bad # escape",
                        src_file, line);
                v = 0;
                while (isdigit((unsigned char)*p)) {
                    v = v * 10 + (*p - '0');
                    p++;
                }
            }
            if (v > 255)
                die("%s:%d: character constant %ld out of range",
                    src_file, line, v);
            str_append(&buf, &cap, &len, (int)v);
        } else {
            break;
        }
    }

    buf[len] = '\0';
    t = make(T_STRING);
    t.sval = arena_strndup(lex_arena, buf, len);
    t.slen = (int)len;
    free(buf);
    return t;
}

static struct token
lex_one(void)
{
    struct token t;
    const char *start;
    int c;
    unsigned long n;        /* accumulate unsigned so an over-long literal
                               wraps (defined) instead of overflowing a long */

    skip_ws();
    t = make(T_EOF);
    if (*p == '\0')
        return t;

    c = (unsigned char)*p;

    if (isalpha(c) || c == '_') {
        const struct kw *kw;
        size_t sz;
        start = p;
        while (isalnum((unsigned char)*p) || *p == '_')
            p++;
        sz = (size_t)(p - start);
        for (kw = keywords; kw->s; kw++) {
            if (ci_match(kw->s, start, sz))
                return make(kw->k);
        }
        t = make(T_IDENT);
        t.sval = arena_strndup(lex_arena, start, sz);
        t.raw = arena_strndup(lex_arena, start, sz);   /* original case */
        /* normalize to lowercase */
        for (size_t i = 0; i < sz; i++)
            t.sval[i] = (char)tolower((unsigned char)t.sval[i]);
        return t;
    }

    if (isdigit(c)) {
        n = 0;
        if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
            p += 2;
            if (!isxdigit((unsigned char)*p))
                die("%s:%d: bad hex literal",
                    src_file, line);
            while (isxdigit((unsigned char)*p)) {
                int d;
                c = (unsigned char)*p;
                if (c >= '0' && c <= '9')
                    d = c - '0';
                else if (c >= 'a' && c <= 'f')
                    d = 10 + c - 'a';
                else
                    d = 10 + c - 'A';
                n = (n << 4) | d;
                p++;
            }
        } else if (p[0] == '0' && (p[1] == 'o' || p[1] == 'O')) {
            p += 2;
            if (*p < '0' || *p > '7')
                die("%s:%d: bad octal literal",
                    src_file, line);
            while (*p >= '0' && *p <= '7') {
                n = (n << 3) | (*p - '0');
                p++;
            }
        } else if (p[0] == '0' && (p[1] == 'b' || p[1] == 'B')) {
            p += 2;
            if (*p != '0' && *p != '1')
                die("%s:%d: bad binary literal",
                    src_file, line);
            while (*p == '0' || *p == '1') {
                n = (n << 1) | (*p - '0');
                p++;
            }
        } else {
            const char *num_start = p;
            while (isdigit((unsigned char)*p))
                p++;
            /* real literal: a fractional part (dot then digit, not the `..`
               range operator) or an exponent */
            if ((p[0] == '.' && isdigit((unsigned char)p[1])) ||
                p[0] == 'e' || p[0] == 'E') {
                if (p[0] == '.') {
                    p++;
                    while (isdigit((unsigned char)*p))
                        p++;
                }
                if (p[0] == 'e' || p[0] == 'E') {
                    p++;
                    if (*p == '+' || *p == '-')
                        p++;
                    while (isdigit((unsigned char)*p))
                        p++;
                }
                t = make(T_REAL);
                t.fval = strtod(num_start, NULL);
                return t;
            }
            for (const char *q = num_start; q < p; q++)
                n = n * 10 + (unsigned long)(*q - '0');
        }
        t = make(T_NUMBER);
        t.nval = (long)n;
        return t;
    }

    /* $FF hex literal (TP-style) */
    if (c == '$' && isxdigit((unsigned char)p[1])) {
        p++;
        n = 0;
        while (isxdigit((unsigned char)*p)) {
            int d;
            c = (unsigned char)*p;
            if (c >= '0' && c <= '9')
                d = c - '0';
            else if (c >= 'a' && c <= 'f')
                d = 10 + c - 'a';
            else
                d = 10 + c - 'A';
            n = (n << 4) | d;
            p++;
        }
        t = make(T_NUMBER);
        t.nval = (long)n;
        return t;
    }

    /* string literals and #nn character constants */
    if (c == '\'' || c == '#')
        return lex_string();

    switch (c) {
    case '(': p++; return make(T_LPAREN);
    case ')': p++; return make(T_RPAREN);
    case '[': p++; return make(T_LBRACK);
    case ']': p++; return make(T_RBRACK);
    case ',': p++; return make(T_COMMA);
    case ';': p++; return make(T_SEMI);
    case '+': p++; return make(T_PLUS);
    case '-': p++; return make(T_MINUS);
    case '*': p++; return make(T_STAR);
    case '/': p++; return make(T_SLASH);
    case '=': p++; return make(T_EQ);
    case '^': p++; return make(T_CARET);
    case ':':
        p++;
        if (*p == '=') { p++; return make(T_ASSIGN); }
        return make(T_COLON);
    case '.':
        p++;
        if (*p == '.') { p++; return make(T_DOTDOT); }
        return make(T_DOT);
    case '<':
        p++;
        if (*p == '=') { p++; return make(T_LE); }
        if (*p == '>') { p++; return make(T_NE); }
        return make(T_LT);
    case '>':
        p++;
        if (*p == '=') { p++; return make(T_GE); }
        return make(T_GT);
    }

    die("%s:%d: unexpected character 0x%02x", src_file, line, c);
    return t;
}

struct token
lex_next(void)
{
    if (peeked) {
        peeked = 0;
        return peek_tok;
    }
    return lex_one();
}

struct token
lex_peek(void)
{
    if (!peeked) {
        peek_tok = lex_one();
        peeked = 1;
    }
    return peek_tok;
}
