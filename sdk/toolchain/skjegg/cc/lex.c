/* lex.c : C lexer for skj-cc */

#include "cc.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

static struct arena *lex_arena;
static const char *src_buf;
static const char *src_file;
static const char *p;
static int line;
static const char *line_start;  /* start of the current physical line, for columns */
static int cur_tok_col;         /* column of the token cc_lex_next last returned */
static int peeked;
static struct cc_token peek_tok;

struct kw {
    const char *s;
    int k;
};

static const struct kw keywords[] = {
    { "_Bool",    TOK_BOOL },
    { "_Float16", TOK_FLOAT16 },
    { "asm",      TOK_ASM },
    { "__asm",    TOK_ASM },
    { "__asm__",  TOK_ASM },
    { "auto",     TOK_AUTO },
    { "break",    TOK_BREAK },
    { "case",     TOK_CASE },
    { "char",     TOK_CHAR },
    { "const",    TOK_CONST },
    { "continue", TOK_CONTINUE },
    { "default",  TOK_DEFAULT },
    { "do",       TOK_DO },
    { "double",   TOK_DOUBLE },
    { "else",     TOK_ELSE },
    { "enum",     TOK_ENUM },
    { "extern",   TOK_EXTERN },
    { "float",    TOK_FLOAT },
    { "for",      TOK_FOR },
    { "goto",     TOK_GOTO },
    { "if",       TOK_IF },
    { "inline",   TOK_INLINE },
    { "__inline", TOK_INLINE },
    { "__inline__", TOK_INLINE },
    { "int",      TOK_INT },
    { "long",     TOK_LONG },
    { "restrict", TOK_RESTRICT },
    { "__restrict", TOK_RESTRICT },
    { "__restrict__", TOK_RESTRICT },
    { "register", TOK_REGISTER },
    { "return",   TOK_RETURN },
    { "short",    TOK_SHORT },
    { "signed",   TOK_SIGNED },
    { "sizeof",   TOK_SIZEOF },
    { "_Alignof", TOK_ALIGNOF },
    { "alignof",  TOK_ALIGNOF },
    { "_Alignas", TOK_ALIGNAS },
    { "alignas",  TOK_ALIGNAS },
    { "_Static_assert", TOK_STATIC_ASSERT },
    { "static_assert",  TOK_STATIC_ASSERT },
    { "_Generic", TOK_GENERIC },
    { "static",   TOK_STATIC },
    { "struct",   TOK_STRUCT },
    { "switch",   TOK_SWITCH },
    { "typedef",  TOK_TYPEDEF },
    { "union",    TOK_UNION },
    { "unsigned", TOK_UNSIGNED },
    { "void",     TOK_VOID },
    { "volatile", TOK_VOLATILE },
    { "while",    TOK_WHILE },
    { NULL, 0 },
};

void
cc_lex_init(struct arena *a, const char *src, const char *filename)
{
    lex_arena = a;
    src_buf = src;
    src_file = filename ? filename : "<input>";
    p = src;
    line = 1;
    line_start = src;
    cur_tok_col = 1;
    peeked = 0;
}

int
cc_lex_col(void)
{
    return cur_tok_col;
}

int
cc_lex_line(void)
{
    return line;
}

const char *
cc_lex_file(void)
{
    return src_file;
}

/* A readable name for a token kind, for diagnostics; NULL for a kind this
   table does not cover (the caller prints the number). */
const char *
cc_tok_name(int kind)
{
    const struct kw *k;

    switch (kind) {
    case TOK_EOF:      return "end of file";
    case TOK_INTLIT:   return "integer literal";
    case TOK_FLOATLIT: return "floating literal";
    case TOK_STRLIT:   return "string literal";
    case TOK_CHARLIT:  return "character literal";
    case TOK_IDENT:    return "identifier";
    case TOK_LPAREN:   return "'('";
    case TOK_RPAREN:   return "')'";
    case TOK_LBRACE:   return "'{'";
    case TOK_RBRACE:   return "'}'";
    case TOK_LBRACK:   return "'['";
    case TOK_RBRACK:   return "']'";
    case TOK_SEMI:     return "';'";
    case TOK_COMMA:    return "','";
    case TOK_DOT:      return "'.'";
    case TOK_ARROW:    return "'->'";
    case TOK_ELLIPSIS: return "'...'";
    case TOK_ASSIGN:   return "'='";
    case TOK_QUESTION: return "'?'";
    case TOK_COLON:    return "':'";
    default:           break;
    }
    for (k = keywords; k->s; k++)
        if (k->k == kind)
            return k->s;
    return NULL;
}

/* Print, to stderr, the (preprocessed) source lines from max(1, n - before)
   through n, each with its line number, as context for a parse diagnostic. */
void
cc_lex_print_context(int n, int before)
{
    const char *s = src_buf;
    int cur = 1, from = n - before;

    if (!s || n < 1)
        return;
    if (from < 1)
        from = 1;

    /* The buffer carries GNU line markers (see skip_ws), so the logical source
       line is not the physical line: a `# N "file"` line sets the next line to
       N and is itself neither printed nor counted. */
    while (*s) {
        const char *eol = s;
        while (*eol && *eol != '\n')
            eol++;
        if (*s == '#') {                /* a line marker: reset cur, skip it */
            const char *q = s + 1;
            int ln = 0, got = 0;
            while (*q == ' ' || *q == '\t')
                q++;
            while (*q >= '0' && *q <= '9') { ln = ln * 10 + (*q++ - '0'); got = 1; }
            if (got)
                cur = ln;
            s = (*eol == '\n') ? eol + 1 : eol;
            continue;
        }
        if (cur >= from && cur <= n)
            fprintf(stderr, "  %5d | %.*s\n", cur, (int)(eol - s), s);
        s = (*eol == '\n') ? eol + 1 : eol;
        cur++;
        if (cur > n)
            break;
    }
}

static void
skip_ws(void)
{
    for (;;) {
        while (*p == ' ' || *p == '\t' || *p == '\r')
            p++;
        if (*p == '\n') {
            line++;
            p++;
            line_start = p;
            continue;
        }
        /* GNU line marker `# <line> "<file>"` injected by cc/main.c: reset the
           line counter (and current file) to the true source position, so a
           token after an #include-expanded region is numbered by its source
           line, not its position in the flattened stream.  A `#` cannot occur
           anywhere else in preprocessed C. */
        if (*p == '#') {
            const char *q = p + 1;
            while (*q == ' ' || *q == '\t')
                q++;
            if (*q >= '0' && *q <= '9') {
                int ln = 0;
                while (*q >= '0' && *q <= '9')
                    ln = ln * 10 + (*q++ - '0');
                while (*q == ' ' || *q == '\t')
                    q++;
                if (*q == '"') {
                    const char *fs = ++q;
                    while (*q && *q != '"')
                        q++;
                    {
                        int flen = (int)(q - fs);
                        char *fn = arena_alloc(lex_arena, (size_t)flen + 1);
                        memcpy(fn, fs, (size_t)flen);
                        fn[flen] = '\0';
                        src_file = fn;
                    }
                    if (*q == '"')
                        q++;
                }
                while (*q && *q != '\n')
                    q++;
                if (*q == '\n')
                    q++;
                p = q;
                line = ln;        /* the next line is source line `ln` */
                line_start = p;
                continue;
            }
            /* not a marker: skip the line defensively */
            while (*p && *p != '\n')
                p++;
            continue;
        }
        if (p[0] == '/' && p[1] == '/') {
            while (*p && *p != '\n')
                p++;
            continue;
        }
        if (p[0] == '/' && p[1] == '*') {
            p += 2;
            while (*p && !(p[0] == '*' && p[1] == '/')) {
                if (*p == '\n') {
                    line++;
                    line_start = p + 1;
                }
                p++;
            }
            if (*p)
                p += 2;
            continue;
        }
        break;
    }
}

static int
is_ident_start(char c)
{
    return isalpha((unsigned char)c) || c == '_';
}

static int
is_ident_char(char c)
{
    return isalnum((unsigned char)c) || c == '_';
}

static long long
parse_int_literal(int *is_long, int *is_llong, int *is_unsigned)
{
    unsigned long long val = 0;
    int base = 10;
    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        base = 16;
        p += 2;
        while (isxdigit((unsigned char)*p)) {
            int d = *p >= 'a' ? *p - 'a' + 10 :
                    *p >= 'A' ? *p - 'A' + 10 : *p - '0';
            val = val * 16 + d;
            p++;
        }
    } else if (p[0] == '0' && isdigit((unsigned char)p[1])) {
        base = 8;
        while (*p >= '0' && *p <= '7') {
            val = val * 8 + (*p - '0');
            p++;
        }
    } else {
        while (isdigit((unsigned char)*p)) {
            val = val * 10 + (*p - '0');
            p++;
        }
    }
    /* suffixes: u, l, ul, ll, ull. */
    int nl = 0, nu = 0;
    while (*p == 'u' || *p == 'U' || *p == 'l' || *p == 'L') {
        if (*p == 'l' || *p == 'L')
            nl++;
        else
            nu++;
        p++;
    }

    /* Pick the smallest type that holds the value, following C's rank order.
       A u suffix allows only the unsigned types; a decimal constant without a
       u suffix allows only the signed types; a hex or octal constant allows
       both (signed first at each width). This is what makes 0xdeadbeef an
       unsigned int rather than a wider signed type. */
    unsigned long long imax = 0x7fffffffULL, uimax = 0xffffffffULL;
    unsigned long long lmax  = CC_LONG_SIZE >= 8 ? 0x7fffffffffffffffULL : imax;
    unsigned long long ulmax = CC_LONG_SIZE >= 8 ? 0xffffffffffffffffULL : uimax;
    unsigned long long llmax = 0x7fffffffffffffffULL;
    int suf_u = nu > 0, allow_s = !suf_u, allow_u = suf_u || base != 10;
    int start = nl >= 2 ? 2 : nl >= 1 ? 1 : 0;
    int w, chosen = -1, uns = 0;

    for (w = start; w <= 2 && chosen < 0; w++) {
        unsigned long long smax = w == 0 ? imax  : w == 1 ? lmax  : llmax;
        unsigned long long umax = w == 0 ? uimax : w == 1 ? ulmax : 0xffffffffffffffffULL;
        if (allow_s && val <= smax) { chosen = w; uns = 0; }
        else if (allow_u && val <= umax) { chosen = w; uns = 1; }
    }
    if (chosen < 0) { chosen = 2; uns = 1; }    /* does not fit: widest unsigned */

    if (is_long)     *is_long = (chosen == 1);
    if (is_llong)    *is_llong = (chosen == 2);
    if (is_unsigned) *is_unsigned = uns;
    return (long long)val;
}

static int
parse_escape(void)
{
    p++;
    if (*p == '\0')             /* a backslash at end of input: do not read
                                   past the NUL terminator */
        return 0;
    switch (*p++) {
    case 'a':  return '\a';
    case 'b':  return '\b';
    case 'f':  return '\f';
    case 'n':  return '\n';
    case 'r':  return '\r';
    case 't':  return '\t';
    case 'v':  return '\v';
    case '\\': return '\\';
    case '\'': return '\'';
    case '"':  return '"';
    case '0': case '1': case '2': case '3':
    case '4': case '5': case '6': case '7': {
        int val = p[-1] - '0';
        if (*p >= '0' && *p <= '7') { val = val * 8 + *p++ - '0'; }
        if (*p >= '0' && *p <= '7') { val = val * 8 + *p++ - '0'; }
        return val;
    }
    case 'x': {
        int val = 0;
        while (isxdigit((unsigned char)*p)) {
            int d = *p >= 'a' ? *p - 'a' + 10 :
                    *p >= 'A' ? *p - 'A' + 10 : *p - '0';
            val = val * 16 + d;
            p++;
        }
        return val;
    }
    default: return p[-1];
    }
}

static struct cc_token
lex_token(void)
{
    struct cc_token t = {0};

    skip_ws();
    t.line = line;
    t.col = (int)(p - line_start) + 1;

    if (*p == '\0') {
        t.kind = TOK_EOF;
        return t;
    }

    /* identifier or keyword */
    if (is_ident_start(*p)) {
        const char *start = p;
        while (is_ident_char(*p))
            p++;
        int len = (int)(p - start);
        for (const struct kw *k = keywords; k->s; k++) {
            if ((int)strlen(k->s) == len &&
                memcmp(k->s, start, len) == 0) {
                t.kind = k->k;
                return t;
            }
        }
        if (len == 13 && memcmp(start, "__attribute__", 13) == 0) {
            /* GNU __attribute__((...)): skip it and its balanced parens so the
               parser never sees it.  skj-cc honours no attributes, so dropping
               them is safe; this lets it compile sources that carry hints like
               __attribute__((noreturn)).  A run of attributes falls out of the
               tail recursion.  String literals inside an attribute are rare and
               not handled; the plain paren count suffices for the hints in use. */
            skip_ws();
            if (*p == '(') {
                int depth = 0;
                do {
                    if (*p == '(')
                        depth++;
                    else if (*p == ')')
                        depth--;
                    else if (*p == '\n')
                        line++;
                    p++;
                } while (*p && depth > 0);
            }
            return lex_token();
        }
        t.kind = TOK_IDENT;
        t.sval = arena_strndup(lex_arena,start, len);
        t.slen = len;
        return t;
    }

    /* numeric literal */
    if (isdigit((unsigned char)*p) ||
        (*p == '.' && isdigit((unsigned char)p[1]))) {
        const char *start = p;
        /* check for float */
        int is_float = (*p == '.');
        if (!is_float) {
            /* skip integer part */
            if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
                p += 2;
                while (isxdigit((unsigned char)*p))
                    p++;
            } else {
                while (isdigit((unsigned char)*p))
                    p++;
            }
            if (*p == '.' || *p == 'e' || *p == 'E')
                is_float = 1;
        }
        p = start;
        if (is_float) {
            t.kind = TOK_FLOATLIT;
            t.fval = strtod(p, (char **)&p);
            if ((p[0] == 'f' || p[0] == 'F') && p[1] == '1' && p[2] == '6') {
                t.is_half = 1;          /* _Float16 literal: 1.5f16 */
                p += 3;
            } else if (*p == 'f' || *p == 'F') {
                t.is_float = 1;
                p++;
            } else if (*p == 'l' || *p == 'L') {
                p++;
            }
        } else {
            t.kind = TOK_INTLIT;
            t.ival = parse_int_literal(&t.is_long, &t.is_llong, &t.is_unsigned);
        }
        return t;
    }

    /* character literal */
    if (*p == '\'') {
        p++;
        if (*p == '\0') {       /* unterminated at end of input: stop rather
                                   than read past the NUL terminator */
            t.kind = TOK_CHARLIT;
            t.ival = 0;
            return t;
        }
        if (*p == '\\')
            t.ival = parse_escape();
        else
            t.ival = (unsigned char)*p++;
        if (*p == '\'')
            p++;
        t.kind = TOK_CHARLIT;
        return t;
    }

    /* string literal */
    if (*p == '"') {
        char buf[4096];
        int pos = 0;
        p++;
        while (*p && *p != '"') {
            int c;
            if (*p == '\\')
                c = parse_escape();
            else
                c = (unsigned char)*p++;
            if (pos < (int)sizeof(buf) - 1)
                buf[pos++] = (char)c;
        }
        if (*p == '"')
            p++;
        /* handle adjacent string literals */
        for (;;) {
            const char *saved = p;
            int saved_line = line;
            skip_ws();
            if (*p != '"') {
                p = saved;
                line = saved_line;
                break;
            }
            p++;
            while (*p && *p != '"') {
                int c;
                if (*p == '\\')
                    c = parse_escape();
                else
                    c = (unsigned char)*p++;
                if (pos < (int)sizeof(buf) - 1)
                    buf[pos++] = (char)c;
            }
            if (*p == '"')
                p++;
        }
        buf[pos] = '\0';
        t.kind = TOK_STRLIT;
        t.sval = arena_strndup(lex_arena,buf, pos);
        t.slen = pos;
        return t;
    }

    /* punctuation and operators */
    char c = *p++;
    switch (c) {
    case '(': t.kind = TOK_LPAREN; break;
    case ')': t.kind = TOK_RPAREN; break;
    case '{': t.kind = TOK_LBRACE; break;
    case '}': t.kind = TOK_RBRACE; break;
    case '[': t.kind = TOK_LBRACK; break;
    case ']': t.kind = TOK_RBRACK; break;
    case ';': t.kind = TOK_SEMI; break;
    case ',': t.kind = TOK_COMMA; break;
    case '~': t.kind = TOK_TILDE; break;
    case '?': t.kind = TOK_QUESTION; break;
    case ':': t.kind = TOK_COLON; break;
    case '.':
        if (p[0] == '.' && p[1] == '.') {
            p += 2;
            t.kind = TOK_ELLIPSIS;
        } else {
            t.kind = TOK_DOT;
        }
        break;
    case '+':
        if (*p == '+') { p++; t.kind = TOK_INC; }
        else if (*p == '=') { p++; t.kind = TOK_PLUS_EQ; }
        else t.kind = TOK_PLUS;
        break;
    case '-':
        if (*p == '-') { p++; t.kind = TOK_DEC; }
        else if (*p == '>') { p++; t.kind = TOK_ARROW; }
        else if (*p == '=') { p++; t.kind = TOK_MINUS_EQ; }
        else t.kind = TOK_MINUS;
        break;
    case '*':
        if (*p == '=') { p++; t.kind = TOK_STAR_EQ; }
        else t.kind = TOK_STAR;
        break;
    case '/':
        if (*p == '=') { p++; t.kind = TOK_SLASH_EQ; }
        else t.kind = TOK_SLASH;
        break;
    case '%':
        if (*p == '=') { p++; t.kind = TOK_PERCENT_EQ; }
        else t.kind = TOK_PERCENT;
        break;
    case '&':
        if (*p == '&') { p++; t.kind = TOK_ANDAND; }
        else if (*p == '=') { p++; t.kind = TOK_AMP_EQ; }
        else t.kind = TOK_AMP;
        break;
    case '|':
        if (*p == '|') { p++; t.kind = TOK_OROR; }
        else if (*p == '=') { p++; t.kind = TOK_PIPE_EQ; }
        else t.kind = TOK_PIPE;
        break;
    case '^':
        if (*p == '=') { p++; t.kind = TOK_CARET_EQ; }
        else t.kind = TOK_CARET;
        break;
    case '=':
        if (*p == '=') { p++; t.kind = TOK_EQ; }
        else t.kind = TOK_ASSIGN;
        break;
    case '!':
        if (*p == '=') { p++; t.kind = TOK_NE; }
        else t.kind = TOK_BANG;
        break;
    case '<':
        if (*p == '<') {
            p++;
            if (*p == '=') { p++; t.kind = TOK_SHL_EQ; }
            else t.kind = TOK_SHL;
        } else if (*p == '=') { p++; t.kind = TOK_LE; }
        else t.kind = TOK_LT;
        break;
    case '>':
        if (*p == '>') {
            p++;
            if (*p == '=') { p++; t.kind = TOK_SHR_EQ; }
            else t.kind = TOK_SHR;
        } else if (*p == '=') { p++; t.kind = TOK_GE; }
        else t.kind = TOK_GT;
        break;
    default:
        die("unexpected character '%c' (0x%02x) at line %d",
            c, (unsigned char)c, line);
    }
    return t;
}

struct cc_token
cc_lex_next(void)
{
    struct cc_token t;
    if (peeked) {
        peeked = 0;
        cur_tok_col = peek_tok.col;
        return peek_tok;
    }
    t = lex_token();
    cur_tok_col = t.col;
    return t;
}

struct cc_token
cc_lex_peek(void)
{
    if (!peeked) {
        peek_tok = lex_token();
        peeked = 1;
    }
    return peek_tok;
}
