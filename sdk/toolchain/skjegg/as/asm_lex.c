/* asm_lex.c : arch-neutral GAS-syntax tokenizer */

#include "asm_lex.h"
#include "arena.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void
lex_init(struct lexer *l, const char *src, char comment_ch, int reloc_pct)
{
    l->src = src;
    l->pos = src;
    l->line = 1;
    l->str_buf = NULL;
    l->str_cap = 0;
    l->tok.type = T_NEWLINE;
    l->comment_ch = comment_ch;
    l->reloc_pct = reloc_pct;
    l->dollar_reg = 0;
    l->base_src = src;
    l->dir = NULL;
    l->base_dir = NULL;
    l->inc_depth = 0;
}

void
lex_rewind(struct lexer *l)
{
    l->src = l->base_src;
    l->pos = l->base_src;
    l->line = 1;
    l->tok.type = T_NEWLINE;
    l->dir = l->base_dir;
    l->inc_depth = 0;
}

void
lex_restore(struct lexer *l, const struct lexer *saved)
{
    /* Rewind the scan position but keep the live scratch buffer.  A lex between
       the save and the restore may have grown str_buf, which reallocs and frees
       the old block, so copying the saved str_buf/str_cap back would resurrect a
       freed pointer (a use-after-free the next string lex writes through).  The
       buffer holds only the token just scanned, which the next lex overwrites,
       so keeping the current allocation is correct. */
    char *buf = l->str_buf;
    int cap = l->str_cap;

    *l = *saved;
    l->str_buf = buf;
    l->str_cap = cap;
}

/* Directory part of a path, as an arena copy ("" when there is no slash). */
static const char *
dir_of(struct arena *a, const char *path)
{
    const char *slash = strrchr(path, '/');

    if (slash == NULL)
        return "";
    return arena_strndup(a, path, (size_t)(slash - path));
}

void
lex_set_source_path(struct lexer *l, const char *path)
{
    l->base_dir = dir_of(l->arena, path);
    l->dir = l->base_dir;
}

int
lex_include(struct lexer *l, const char *name)
{
    char path[1024];
    char *buf;
    long size;
    size_t got;
    FILE *f;

    if (l->inc_depth >= LEX_INCLUDE_DEPTH)
        return -1;

    if (name[0] == '/' || l->dir == NULL || l->dir[0] == '\0') {
        if ((size_t)snprintf(path, sizeof path, "%s", name) >= sizeof path)
            return -1;
    } else if ((size_t)snprintf(path, sizeof path, "%s/%s", l->dir, name)
               >= sizeof path) {
        return -1;
    }

    f = fopen(path, "rb");
    /* Fall back to the name as given, i.e. relative to the current working
       directory (the way GNU as searches), when the include is not beside the
       including file.  This lets one spelling name a fragment shared across
       directories, since every build runs from the repository root. */
    if (f == NULL && name[0] != '/' && strcmp(path, name) != 0) {
        if ((size_t)snprintf(path, sizeof path, "%s", name) < sizeof path)
            f = fopen(path, "rb");
    }
    if (f == NULL)
        return -1;
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return -1; }
    size = ftell(f);
    if (size < 0 || size > LEX_INCLUDE_MAX) { fclose(f); return -1; }
    rewind(f);

    buf = arena_alloc(l->arena, (size_t)size + 1);
    got = fread(buf, 1, (size_t)size, f);
    fclose(f);
    buf[got] = '\0';

    /* save the current file and switch to the included one */
    l->inc[l->inc_depth].src = l->src;
    l->inc[l->inc_depth].pos = l->pos;
    l->inc[l->inc_depth].line = l->line;
    l->inc[l->inc_depth].dir = l->dir;
    l->inc_depth++;

    l->src = buf;
    l->pos = buf;
    l->line = 1;
    l->dir = dir_of(l->arena, path);
    return 0;
}

static void
str_buf_push(struct lexer *l, int *len, char c)
{
    if (*len >= l->str_cap) {
        l->str_cap = l->str_cap ? l->str_cap * 2 : 64;
        l->str_buf = realloc(l->str_buf, l->str_cap);
    }
    l->str_buf[(*len)++] = c;
}

static void
skip_line_comment(struct lexer *l)
{
    while (*l->pos && *l->pos != '\n')
        l->pos++;
}

static void
lex_string(struct lexer *l)
{
    int len = 0;

    l->pos++;
    while (*l->pos && *l->pos != '"') {
        if (*l->pos == '\\') {
            l->pos++;
            /* a backslash at end of input: stop rather than consume the NUL
               terminator and read past it on the next loop iteration */
            if (*l->pos == '\0')
                break;
            switch (*l->pos) {
            case 'n':
                str_buf_push(l, &len, '\n');
                l->pos++;
                break;
            case 't':
                str_buf_push(l, &len, '\t');
                l->pos++;
                break;
            case 'r':
                str_buf_push(l, &len, '\r');
                l->pos++;
                break;
            case '\\':
                str_buf_push(l, &len, '\\');
                l->pos++;
                break;
            case '"':
                str_buf_push(l, &len, '"');
                l->pos++;
                break;
            case '0': case '1': case '2': case '3':
            case '4': case '5': case '6': case '7': {
                int val = 0;
                int k;
                for (k = 0; k < 3 && *l->pos >= '0' && *l->pos <= '7'; k++) {
                    val = val * 8 + (*l->pos - '0');
                    l->pos++;
                }
                str_buf_push(l, &len, (char)val);
                break;
            }
            default:
                str_buf_push(l, &len, *l->pos);
                l->pos++;
                break;
            }
        } else {
            str_buf_push(l, &len, *l->pos);
            l->pos++;
        }
    }
    if (*l->pos == '"')
        l->pos++;
    str_buf_push(l, &len, '\0');
    l->tok.type = T_STRING;
    l->tok.str = l->str_buf;
    l->tok.str_len = len - 1;
}

static int
is_ident_char(char c)
{
    return isalnum((unsigned char)c) || c == '_';
}

static void
lex_ident(struct lexer *l, int dot_prefix)
{
    const char *start;
    int len;

    if (dot_prefix)
        start = l->pos - 1;
    else
        start = l->pos;

    /* '$' is a symbol continuation char where it is not the register sigil
       (ColdFire and RISC-V use % / plain names for registers, so dollar_reg is
       off there).  Mangled Kobold names such as AddMember$0 carry it, and GNU as
       accepts it in a symbol; MIPS keeps '$' for its register sigil, handled
       separately, so it is excluded here. */
    while (is_ident_char(*l->pos) || *l->pos == '.' ||
           (*l->pos == '$' && !l->dollar_reg))
        l->pos++;

    len = (int)(l->pos - start);
    l->tok.type = dot_prefix ? T_DOT_IDENT : T_IDENT;
    l->tok.str = arena_strndup(l->arena, start, len);
    l->tok.str_len = len;
}

static void
lex_number(struct lexer *l)
{
    char *end;

    l->tok.type = T_INT;
    /* Parse unsigned so a full-width immediate such as 0x8000000000000000 (the
       x86-64 double sign mask) keeps its bit pattern instead of clamping at
       LONG_MAX.  A literal is always non-negative here; a leading '-' is a
       separate T_MINUS the parser applies. */
    if (l->pos[0] == '0' && (l->pos[1] == 'x' || l->pos[1] == 'X'))
        l->tok.ival = (long)strtoull(l->pos, &end, 16);
    else
        l->tok.ival = (long)strtoull(l->pos, &end, 10);
    l->pos = end;
}

/* A character constant 'c' (with the common C escapes) as an integer token, the
   way `as` reads `.byte 'h'` and an immediate like `cmp al, 'A'`.  `l->pos` is on
   the opening quote.  An unterminated or empty literal yields 0. */
static void
lex_char(struct lexer *l)
{
    int v = 0;

    l->tok.type = T_INT;
    l->pos++;                           /* opening ' */
    if (*l->pos == '\\') {
        l->pos++;
        switch (*l->pos) {
        case 'n':  v = '\n'; break;
        case 't':  v = '\t'; break;
        case 'r':  v = '\r'; break;
        case '0':  v = '\0'; break;
        case 'b':  v = '\b'; break;
        case 'f':  v = '\f'; break;
        case 'v':  v = '\v'; break;
        case 'a':  v = '\a'; break;
        case '\\': v = '\\'; break;
        case '\'': v = '\''; break;
        case '"':  v = '"';  break;
        default:   v = (unsigned char)*l->pos; break;
        }
        if (*l->pos)
            l->pos++;
    } else if (*l->pos) {
        v = (unsigned char)*l->pos;
        l->pos++;
    }
    if (*l->pos == '\'')                 /* closing ' */
        l->pos++;
    l->tok.ival = v;
}

void
lex_next(struct lexer *l)
{
    for (;;) {
        while (*l->pos == ' ' || *l->pos == '\t')
            l->pos++;

        l->tok.line = l->line;

        if (*l->pos == '\0') {
            if (l->inc_depth > 0) {     /* end of an included file: pop back */
                l->inc_depth--;
                l->src = l->inc[l->inc_depth].src;
                l->pos = l->inc[l->inc_depth].pos;
                l->line = l->inc[l->inc_depth].line;
                l->dir = l->inc[l->inc_depth].dir;
                continue;
            }
            l->tok.type = T_EOF;
            return;
        }

        if (*l->pos == '\n') {
            l->pos++;
            l->line++;
            l->tok.type = T_NEWLINE;
            return;
        }

        if (*l->pos == l->comment_ch) {
            skip_line_comment(l);
            continue;
        }

        /* C++-style line comment (the AArch64 GAS line comment; harmless on the
           other targets, which never emit it). */
        if (l->pos[0] == '/' && l->pos[1] == '/') {
            skip_line_comment(l);
            continue;
        }

        /* C-style block comment (GAS accepts it on every target) */
        if (l->pos[0] == '/' && l->pos[1] == '*') {
            l->pos += 2;
            while (*l->pos && !(l->pos[0] == '*' && l->pos[1] == '/')) {
                if (*l->pos == '\n')
                    l->line++;
                l->pos++;
            }
            if (*l->pos)
                l->pos += 2;            /* consume the closing */
            continue;
        }

        if (*l->pos == '"') {
            lex_string(l);
            return;
        }

        if (*l->pos == '.') {
            l->pos++;
            if (is_ident_char(*l->pos)) {
                lex_ident(l, 1);
                return;
            }
            l->tok.type = T_DOT_IDENT;
            l->tok.str = ".";
            l->tok.str_len = 1;
            return;
        }

        if (isalpha((unsigned char)*l->pos) || *l->pos == '_') {
            lex_ident(l, 0);
            return;
        }

        if (isdigit((unsigned char)*l->pos)) {
            const char *start = l->pos;
            lex_number(l);
            if ((*l->pos == 'b' || *l->pos == 'f') &&
                !is_ident_char(l->pos[1])) {
                l->pos = start;
                lex_ident(l, 0);
                return;
            }
            return;
        }

        /* MIPS register sigil: '$t0', '$f12', '$0' lex as one identifier that
         * keeps the leading '$', so the register lookup is unambiguous against
         * a bare symbol or integer.  Off by default (m68k and RISC-V). */
        if (l->dollar_reg && *l->pos == '$') {
            const char *start = l->pos;
            int len;
            l->pos++;
            while (is_ident_char(*l->pos))
                l->pos++;
            len = (int)(l->pos - start);
            l->tok.type = T_IDENT;
            l->tok.str = arena_strndup(l->arena, start, len);
            l->tok.str_len = len;
            return;
        }

        if (*l->pos == '\'') {          /* character constant 'c' -> T_INT */
            lex_char(l);
            return;
        }

        switch (*l->pos) {
        case '#': l->pos++; l->tok.type = T_HASH; return;
        case ',': l->pos++; l->tok.type = T_COMMA; return;
        case ':': l->pos++; l->tok.type = T_COLON; return;
        case '(': l->pos++; l->tok.type = T_LPAREN; return;
        case ')': l->pos++; l->tok.type = T_RPAREN; return;
        case '[': l->pos++; l->tok.type = T_LBRACKET; return;
        case ']': l->pos++; l->tok.type = T_RBRACKET; return;
        case '*': l->pos++; l->tok.type = T_STAR; return;
        case '=': l->pos++; l->tok.type = T_EQUAL; return;
        case '@': l->pos++; l->tok.type = T_AT; return;
        case '-': l->pos++; l->tok.type = T_MINUS; return;
        case '+': l->pos++; l->tok.type = T_PLUS; return;
        case '%':
            l->pos++;
            if (l->reloc_pct) {
                lex_ident(l, 0);
                l->tok.type = T_RELOC;
            } else {
                lex_ident(l, 0);
            }
            return;
        default:
            l->pos++;
            continue;
        }
    }
}
