/* script.c : GNU ld linker script subset parser */

#include "ld.h"

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

static struct arena *script_arena;

/****************************************************************
 * Lexer
 ****************************************************************/

enum token {
    TOK_EOF,
    TOK_IDENT,
    TOK_NUMBER,
    TOK_STRING,
    TOK_LPAREN,
    TOK_RPAREN,
    TOK_LBRACE,
    TOK_RBRACE,
    TOK_COLON,
    TOK_COMMA,
    TOK_SEMI,
    TOK_GT,
    TOK_EQ,
    TOK_DOT,
    TOK_STAR,
    TOK_SLASH,
};

struct lexer {
    const char *src;
    const char *pos;
    enum token tok;
    char text[256];
    uint32_t num;
    int line;
};

static void
skip_ws(struct lexer *lx)
{
    for (;;) {
        while (*lx->pos && isspace((unsigned char)*lx->pos)) {
            if (*lx->pos == '\n')
                lx->line++;
            lx->pos++;
        }
        if (lx->pos[0] == '/' && lx->pos[1] == '*') {
            lx->pos += 2;
            while (*lx->pos && !(lx->pos[0] == '*' && lx->pos[1] == '/')) {
                if (*lx->pos == '\n')
                    lx->line++;
                lx->pos++;
            }
            if (*lx->pos)
                lx->pos += 2;
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

static void
next(struct lexer *lx)
{
    skip_ws(lx);

    if (!*lx->pos) {
        lx->tok = TOK_EOF;
        return;
    }

    char c = *lx->pos;

    if (c == '(') { lx->tok = TOK_LPAREN; lx->pos++; return; }
    if (c == ')') { lx->tok = TOK_RPAREN; lx->pos++; return; }
    if (c == '{') { lx->tok = TOK_LBRACE; lx->pos++; return; }
    if (c == '}') { lx->tok = TOK_RBRACE; lx->pos++; return; }
    if (c == ':') { lx->tok = TOK_COLON;  lx->pos++; return; }
    if (c == ',') { lx->tok = TOK_COMMA;  lx->pos++; return; }
    if (c == ';') { lx->tok = TOK_SEMI;   lx->pos++; return; }
    if (c == '>') { lx->tok = TOK_GT;     lx->pos++; return; }
    if (c == '=') { lx->tok = TOK_EQ;     lx->pos++; return; }
    if (c == '*') { lx->tok = TOK_STAR;   lx->pos++; return; }

    if (c == '.') {
        if (is_ident_char(lx->pos[1])) {
            /* section name like .text or .data.verb_regs */
            const char *start = lx->pos;
            lx->pos++;
            while (is_ident_char(*lx->pos) || *lx->pos == '.')
                lx->pos++;
            /* include trailing * for glob patterns like .text.* */
            if (lx->pos > start + 1 && lx->pos[-1] == '.' &&
                *lx->pos == '*')
                lx->pos++;
            size_t len = (size_t)(lx->pos - start);
            if (len >= sizeof(lx->text))
                die("script:%d: identifier too long", lx->line);
            memcpy(lx->text, start, len);
            lx->text[len] = '\0';
            lx->tok = TOK_IDENT;
            return;
        }
        lx->tok = TOK_DOT;
        lx->pos++;
        return;
    }

    /* /DISCARD/ */
    if (c == '/') {
        if (strncmp(lx->pos, "/DISCARD/", 9) == 0) {
            memcpy(lx->text, "/DISCARD/", 10);
            lx->tok = TOK_IDENT;
            lx->pos += 9;
            return;
        }
        lx->tok = TOK_SLASH;
        lx->pos++;
        return;
    }

    if (c == '"') {
        lx->pos++;
        const char *start = lx->pos;
        while (*lx->pos && *lx->pos != '"')
            lx->pos++;
        size_t len = (size_t)(lx->pos - start);
        if (len >= sizeof(lx->text))
            die("script:%d: string too long", lx->line);
        memcpy(lx->text, start, len);
        lx->text[len] = '\0';
        if (*lx->pos == '"')
            lx->pos++;
        lx->tok = TOK_STRING;
        return;
    }

    if (c == '0' && lx->pos[1] == 'x') {
        lx->num = (uint32_t)strtoul(lx->pos, (char **)&lx->pos, 16);
        if (*lx->pos == 'K') { lx->num *= 1024; lx->pos++; }
        else if (*lx->pos == 'M') { lx->num *= 1024 * 1024; lx->pos++; }
        lx->tok = TOK_NUMBER;
        return;
    }

    if (isdigit((unsigned char)c)) {
        lx->num = (uint32_t)strtoul(lx->pos, (char **)&lx->pos, 10);
        if (*lx->pos == 'K') { lx->num *= 1024; lx->pos++; }
        else if (*lx->pos == 'M') { lx->num *= 1024 * 1024; lx->pos++; }
        lx->tok = TOK_NUMBER;
        return;
    }

    if (is_ident_start(c)) {
        const char *start = lx->pos;
        while (is_ident_char(*lx->pos))
            lx->pos++;
        size_t len = (size_t)(lx->pos - start);
        if (len >= sizeof(lx->text))
            die("script:%d: identifier too long", lx->line);
        memcpy(lx->text, start, len);
        lx->text[len] = '\0';
        lx->tok = TOK_IDENT;
        return;
    }

    die("script:%d: unexpected character '%c'", lx->line, c);
}

static void
expect(struct lexer *lx, enum token tok, const char *what)
{
    if (lx->tok != tok)
        die("script:%d: expected %s", lx->line, what);
    next(lx);
}

static int
match_ident(struct lexer *lx, const char *name)
{
    return lx->tok == TOK_IDENT && strcmp(lx->text, name) == 0;
}

/****************************************************************
 * Parser
 ****************************************************************/

static uint32_t
parse_flags_string(const char *s)
{
    uint32_t f = 0;
    for (; *s; s++) {
        if (*s == 'r') f |= PF_R;
        else if (*s == 'w') f |= PF_W;
        else if (*s == 'x') f |= PF_X;
    }
    return f;
}

static void
parse_output_format(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LPAREN, "'('");
    if (lx->tok != TOK_STRING)
        die("script:%d: expected string for OUTPUT_FORMAT", lx->line);
    sc->output_format = arena_strdup(script_arena,lx->text);
    next(lx);
    expect(lx, TOK_RPAREN, "')'");
}

static void
parse_output_arch(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LPAREN, "'('");
    if (lx->tok != TOK_IDENT)
        die("script:%d: expected identifier for OUTPUT_ARCH", lx->line);
    sc->output_arch = arena_strdup(script_arena,lx->text);
    next(lx);
    expect(lx, TOK_RPAREN, "')'");
}

static void
parse_entry(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LPAREN, "'('");
    if (lx->tok != TOK_IDENT)
        die("script:%d: expected identifier for ENTRY", lx->line);
    sc->entry = arena_strdup(script_arena,lx->text);
    next(lx);
    expect(lx, TOK_RPAREN, "')'");
}

static void
parse_memory(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LBRACE, "'{'");

    while (lx->tok == TOK_IDENT && !match_ident(lx, "PHDRS") &&
           !match_ident(lx, "SECTIONS")) {
        if (sc->nregions >= MAX_REGIONS)
            die("script:%d: too many MEMORY regions", lx->line);

        struct ld_mem_region *r = &sc->regions[sc->nregions++];
        r->name = arena_strdup(script_arena,lx->text);
        next(lx);

        expect(lx, TOK_LPAREN, "'('");
        if (lx->tok != TOK_IDENT)
            die("script:%d: expected flags for MEMORY region", lx->line);
        r->flags = parse_flags_string(lx->text);
        next(lx);
        expect(lx, TOK_RPAREN, "')'");

        expect(lx, TOK_COLON, "':'");

        if (!match_ident(lx, "ORIGIN"))
            die("script:%d: expected ORIGIN", lx->line);
        next(lx);
        expect(lx, TOK_EQ, "'='");
        if (lx->tok != TOK_NUMBER)
            die("script:%d: expected number for ORIGIN", lx->line);
        r->origin = lx->num;
        r->cursor = r->origin;
        next(lx);

        expect(lx, TOK_COMMA, "','");

        if (!match_ident(lx, "LENGTH"))
            die("script:%d: expected LENGTH", lx->line);
        next(lx);
        expect(lx, TOK_EQ, "'='");
        if (lx->tok != TOK_NUMBER)
            die("script:%d: expected number for LENGTH", lx->line);
        r->length = lx->num;
        next(lx);
    }

    expect(lx, TOK_RBRACE, "'}'");
}

static void
parse_phdrs(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LBRACE, "'{'");

    while (lx->tok == TOK_IDENT) {
        if (sc->nphdrs >= MAX_PHDRS)
            die("script:%d: too many PHDRS", lx->line);

        struct ld_phdr *ph = &sc->phdrs[sc->nphdrs++];
        ph->name = arena_strdup(script_arena,lx->text);
        next(lx);

        if (!match_ident(lx, "PT_LOAD"))
            die("script:%d: only PT_LOAD supported", lx->line);
        ph->type = PT_LOAD;
        next(lx);

        if (match_ident(lx, "FLAGS")) {
            next(lx);
            expect(lx, TOK_LPAREN, "'('");
            if (lx->tok != TOK_NUMBER)
                die("script:%d: expected number for FLAGS", lx->line);
            ph->flags = lx->num;
            next(lx);
            expect(lx, TOK_RPAREN, "')'");
        }

        expect(lx, TOK_SEMI, "';'");
    }

    expect(lx, TOK_RBRACE, "'}'");
}

static void
parse_input_spec(struct lexer *lx, struct ld_output_sec *os)
{
    /* *( pattern [, pattern ...] ) */
    next(lx);
    expect(lx, TOK_LPAREN, "'('");

    while (lx->tok != TOK_RPAREN && lx->tok != TOK_EOF) {
        if (os->npatterns >= MAX_PATTERNS)
            die("script:%d: too many input patterns", lx->line);

        struct sec_pattern *pat = &os->patterns[os->npatterns++];

        if (lx->tok == TOK_IDENT && strcmp(lx->text, "COMMON") == 0) {
            pat->name = arena_strdup(script_arena,"COMMON");
            pat->wildcard = 0;
            next(lx);
        } else if (lx->tok == TOK_IDENT) {
            /* .text or .text.* */
            const char *base = lx->text;
            size_t blen = strlen(base);
            /* check for trailing .* wildcard */
            if (blen >= 2 && base[blen - 2] == '.' && base[blen - 1] == '*') {
                /* already includes .* in text, strip it */
                char *s = arena_strdup(script_arena,base);
                s[blen - 2] = '\0';
                pat->name = s;
                pat->wildcard = 1;
            } else {
                pat->name = arena_strdup(script_arena,base);
                pat->wildcard = 0;
            }
            next(lx);
            /* handle case where . and * are separate tokens */
            if (lx->tok == TOK_DOT && !pat->wildcard) {
                next(lx);
                if (lx->tok == TOK_STAR) {
                    pat->wildcard = 1;
                    next(lx);
                }
            }
        } else {
            die("script:%d: expected section pattern", lx->line);
        }

        if (lx->tok == TOK_COMMA)
            next(lx);
    }

    expect(lx, TOK_RPAREN, "')'");
}

static void
parse_sec_body(struct lexer *lx, struct ld_output_sec *os)
{
    int pattern_count = 0;

    while (lx->tok != TOK_RBRACE && lx->tok != TOK_EOF) {
        if (lx->tok == TOK_STAR) {
            parse_input_spec(lx, os);
            pattern_count++;
        } else if (lx->tok == TOK_IDENT) {
            /* sym = . ; */
            char name[256];
            strncpy(name, lx->text, sizeof(name) - 1);
            name[sizeof(name) - 1] = '\0';
            next(lx);

            if (lx->tok != TOK_EQ)
                die("script:%d: expected '=' after '%s'", lx->line, name);
            next(lx);

            if (lx->tok != TOK_DOT)
                die("script:%d: only '. (dot)' supported on RHS of symbol assignment",
                    lx->line);
            next(lx);

            expect(lx, TOK_SEMI, "';'");

            if (os->nassigns >= MAX_ASSIGNS)
                die("script:%d: too many symbol assignments", lx->line);

            struct sym_assign *sa = &os->assigns[os->nassigns++];
            sa->name = arena_strdup(script_arena,name);
            sa->before_inputs = (pattern_count == 0);
            sa->after_pattern = pattern_count;
        } else {
            die("script:%d: unexpected token in section body", lx->line);
        }
    }
}

static void
parse_sections(struct lexer *lx, struct ld_script *sc)
{
    next(lx);
    expect(lx, TOK_LBRACE, "'{'");

    while (lx->tok != TOK_RBRACE && lx->tok != TOK_EOF) {
        if (sc->nsections >= MAX_OUT_SECS)
            die("script:%d: too many output sections", lx->line);

        struct ld_output_sec *os = &sc->sections[sc->nsections];
        memset(os, 0, sizeof(*os));

        if (lx->tok != TOK_IDENT)
            die("script:%d: expected section name", lx->line);

        int is_discard = (strcmp(lx->text, "/DISCARD/") == 0);
        os->name = arena_strdup(script_arena,lx->text);
        os->discard = is_discard;
        next(lx);

        expect(lx, TOK_COLON, "':'");
        expect(lx, TOK_LBRACE, "'{'");

        parse_sec_body(lx, os);

        expect(lx, TOK_RBRACE, "'}'");

        /* > REGION : PHDR */
        if (!is_discard && lx->tok == TOK_GT) {
            next(lx);
            if (lx->tok != TOK_IDENT)
                die("script:%d: expected region name after '>'", lx->line);
            os->region = arena_strdup(script_arena,lx->text);
            next(lx);

            if (lx->tok == TOK_COLON) {
                next(lx);
                if (lx->tok != TOK_IDENT)
                    die("script:%d: expected phdr name after ':'", lx->line);
                os->phdr = arena_strdup(script_arena,lx->text);
                next(lx);
            }
        }

        sc->nsections++;
    }

    expect(lx, TOK_RBRACE, "'}'");
}

/****************************************************************
 * Public API
 ****************************************************************/

void
ld_parse_script(struct arena *a, struct ld_script *script, const char *src)
{
    struct lexer lx;

    script_arena = a;
    memset(script, 0, sizeof(*script));
    memset(&lx, 0, sizeof(lx));
    lx.src = src;
    lx.pos = src;
    lx.line = 1;

    next(&lx);

    while (lx.tok != TOK_EOF) {
        if (lx.tok != TOK_IDENT)
            die("script:%d: expected top-level directive", lx.line);

        if (match_ident(&lx, "OUTPUT_FORMAT"))
            parse_output_format(&lx, script);
        else if (match_ident(&lx, "OUTPUT_ARCH"))
            parse_output_arch(&lx, script);
        else if (match_ident(&lx, "ENTRY"))
            parse_entry(&lx, script);
        else if (match_ident(&lx, "MEMORY"))
            parse_memory(&lx, script);
        else if (match_ident(&lx, "PHDRS"))
            parse_phdrs(&lx, script);
        else if (match_ident(&lx, "SECTIONS"))
            parse_sections(&lx, script);
        else
            die("script:%d: unknown directive '%s'", lx.line, lx.text);
    }
}

void
ld_default_script(struct arena *a, struct ld_script *script)
{
    static const char default_script[] =
        "OUTPUT_FORMAT(\"elf32-m68k\")\n"
        "ENTRY(_start)\n"
        "MEMORY { RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 1M }\n"
        "SECTIONS {\n"
        "    .text : { *(.text .text.*) } > RAM\n"
        "    .rodata : { *(.rodata .rodata.*) } > RAM\n"
        "    .data : { *(.data .data.*) } > RAM\n"
        "    .bss : { __bss_start = .; *(.bss .bss.*) *(COMMON)"
        " __bss_end = .; } > RAM\n"
        "    /DISCARD/ : { *(.note .note.*) *(.comment)"
        " *(.eh_frame) *(.gnu.hash) }\n"
        "}\n";

    ld_parse_script(a, script, default_script);
}
