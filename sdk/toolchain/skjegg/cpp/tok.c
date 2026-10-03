/* tok.c : preprocessor tokenizer */

#include "internal.h"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

static struct pp_token *
new_token(int kind, const char *text, int len)
{
    struct pp_token *t = xmalloc(sizeof *t);
    t->kind = kind;
    t->text = xstrndup(text, len);
    t->len = len;
    t->blue = 0;
    t->next = NULL;
    return t;
}

void
pp_free_tokens(struct pp_token *list)
{
    while (list) {
        struct pp_token *next = list->next;
        free(list->text);
        free(list);
        list = next;
    }
}

struct pp_token *
pp_token_dup(struct pp_token *tok)
{
    if (!tok)
        return NULL;
    struct pp_token *t = xmalloc(sizeof *t);
    t->kind = tok->kind;
    t->text = xstrndup(tok->text, tok->len);
    t->len = tok->len;
    t->blue = tok->blue;
    t->next = NULL;
    return t;
}

struct pp_token *
pp_list_dup(struct pp_token *list)
{
    struct pp_token head = {0};
    struct pp_token *tail = &head;
    while (list) {
        tail->next = pp_token_dup(list);
        tail = tail->next;
        list = list->next;
    }
    return head.next;
}

static int
is_ident_start(int c)
{
    return isalpha(c) || c == '_';
}

static int
is_ident_char(int c)
{
    return isalnum(c) || c == '_';
}

static int
is_punct2(const char *s)
{
    if (!s[0] || !s[1])
        return 0;
    char a = s[0], b = s[1];
    return (a == '#' && b == '#') ||
           (a == '<' && b == '<') ||
           (a == '>' && b == '>') ||
           (a == '<' && b == '=') ||
           (a == '>' && b == '=') ||
           (a == '=' && b == '=') ||
           (a == '!' && b == '=') ||
           (a == '&' && b == '&') ||
           (a == '|' && b == '|') ||
           (a == '+' && b == '=') ||
           (a == '-' && b == '=') ||
           (a == '*' && b == '=') ||
           (a == '/' && b == '=') ||
           (a == '%' && b == '=') ||
           (a == '&' && b == '=') ||
           (a == '|' && b == '=') ||
           (a == '^' && b == '=') ||
           (a == '-' && b == '>');
}

static const char *
skip_string(const char *p, char quote)
{
    p++;
    while (*p && *p != quote) {
        if (*p == '\\' && p[1])
            p++;
        p++;
    }
    if (*p == quote)
        p++;
    return p;
}

struct pp_token *
pp_tokenize(const char *line, int len)
{
    struct pp_token head = {0};
    struct pp_token *tail = &head;
    const char *p = line;
    const char *end = line + len;

    while (p < end) {
        if (*p == '\n' || *p == '\r') {
            break;
        }

        if (*p == ' ' || *p == '\t') {
            const char *start = p;
            while (p < end && (*p == ' ' || *p == '\t'))
                p++;
            tail->next = new_token(PP_SPACE, start, (int)(p - start));
            tail = tail->next;
            continue;
        }

        if (is_ident_start(*p)) {
            const char *start = p;
            while (p < end && is_ident_char(*p))
                p++;
            tail->next = new_token(PP_IDENT, start, (int)(p - start));
            tail = tail->next;
            continue;
        }

        if (isdigit(*p) || (*p == '.' && p + 1 < end && isdigit(p[1]))) {
            const char *start = p;
            while (p < end && (isalnum(*p) || *p == '.' ||
                   *p == '+' || *p == '-' || *p == '_')) {
                if ((*p == '+' || *p == '-') && p > start &&
                    tolower(p[-1]) != 'e' && tolower(p[-1]) != 'p')
                    break;
                p++;
            }
            tail->next = new_token(PP_NUMBER, start, (int)(p - start));
            tail = tail->next;
            continue;
        }

        if (*p == '"') {
            const char *start = p;
            p = skip_string(p, '"');
            tail->next = new_token(PP_STRING, start, (int)(p - start));
            tail = tail->next;
            continue;
        }

        if (*p == '\'') {
            const char *start = p;
            p = skip_string(p, '\'');
            tail->next = new_token(PP_CHAR, start, (int)(p - start));
            tail = tail->next;
            continue;
        }

        if (*p == '/' && p + 1 < end && p[1] == '/') {
            break;
        }

        if (*p == '/' && p + 1 < end && p[1] == '*') {
            p += 2;
            while (p < end && !(p[-1] == '*' && *p == '/'))
                p++;
            if (p < end)
                p++;
            tail->next = new_token(PP_SPACE, " ", 1);
            tail = tail->next;
            continue;
        }

        if (is_punct2(p)) {
            tail->next = new_token(PP_PUNCT, p, 2);
            tail = tail->next;
            p += 2;
            continue;
        }

        tail->next = new_token(PP_PUNCT, p, 1);
        tail = tail->next;
        p++;
    }

    return head.next;
}

int
pp_detokenize(struct pp_token *list, char *buf, int bufsize)
{
    int pos = 0;
    for (struct pp_token *t = list; t; t = t->next) {
        if (pos + t->len >= bufsize - 1)
            break;
        memcpy(buf + pos, t->text, t->len);
        pos += t->len;
    }
    buf[pos] = '\0';
    return pos;
}
