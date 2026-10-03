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
static int peeked;
static struct cc_token peek_tok;

struct kw {
    const char *s;
    int k;
};

static const struct kw keywords[] = {
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
    peeked = 0;
}

int
cc_lex_line(void)
{
    return line;
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
                if (*p == '\n')
                    line++;
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

static long
parse_int_literal(int *is_long, int *is_llong)
{
    long val = 0;
    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        p += 2;
        while (isxdigit((unsigned char)*p)) {
            int d = *p >= 'a' ? *p - 'a' + 10 :
                    *p >= 'A' ? *p - 'A' + 10 : *p - '0';
            val = val * 16 + d;
            p++;
        }
    } else if (p[0] == '0' && isdigit((unsigned char)p[1])) {
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
    /* suffixes: u, l, ul, ll, ull.  Count the l's to size the literal. */
    int nl = 0;
    while (*p == 'u' || *p == 'U' || *p == 'l' || *p == 'L') {
        if (*p == 'l' || *p == 'L')
            nl++;
        p++;
    }
    int too_big_for_int = val > 2147483647L;
    if (is_long)
        /* an l suffix, or a value too big for a signed 32-bit int */
        *is_long = (nl >= 1) || too_big_for_int;
    if (is_llong)
        /* an ll suffix, or a value too big for the target's long as well */
        *is_llong = (nl >= 2) || (too_big_for_int && CC_LONG_SIZE < 8);
    return val;
}

static int
parse_escape(void)
{
    p++;
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
            t.ival = parse_int_literal(&t.is_long, &t.is_llong);
        }
        return t;
    }

    /* character literal */
    if (*p == '\'') {
        p++;
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
    if (peeked) {
        peeked = 0;
        return peek_tok;
    }
    return lex_token();
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
