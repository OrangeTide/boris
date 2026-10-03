/* dir.c : directive dispatcher and main processing loop */

#include "internal.h"
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <stdarg.h>
#include <stdio.h>

void
cpp_error(struct cpp *p, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "skj-cpp: error: ");
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
    p->errors++;
}

static void
file_push(struct cpp *p, const char *path, char *buf)
{
    struct cpp_file *f = xmalloc(sizeof *f);
    f->path = xstrdup(path);
    f->buf = buf;
    f->pos = buf;
    f->line = 1;
    f->up = p->file;
    p->file = f;
}

static void
file_pop(struct cpp *p)
{
    struct cpp_file *f = p->file;
    if (!f)
        return;
    p->file = f->up;
    free(f->buf);
    free((char *)f->path);
    free(f);
}

static int
read_logical_line(struct cpp *p, char *buf, int bufsize)
{
    if (!p->file || !p->file->pos || *p->file->pos == '\0')
        return 0;

    int pos = 0;
    const char *s = p->file->pos;

    for (;;) {
        while (*s && *s != '\n' && pos < bufsize - 2) {
            buf[pos++] = *s++;
        }
        if (*s == '\n') {
            s++;
            p->file->line++;
            /* line continuation */
            if (pos > 0 && buf[pos - 1] == '\\') {
                pos--;
                continue;
            }
        }
        break;
    }

    buf[pos] = '\0';
    p->file->pos = s;
    return pos > 0 || p->file->pos[-1] == '\n' ? 1 : 0;
}

static const char *
skip_ws(const char *s)
{
    while (*s == ' ' || *s == '\t')
        s++;
    return s;
}

static char *
resolve_include(struct cpp *p, const char *name, int is_system)
{
    char path[4096];
    int n;

    if (!is_system && p->file && p->file->path) {
        const char *dir_end = strrchr(p->file->path, '/');
        if (dir_end) {
            int dlen = (int)(dir_end - p->file->path);
            n = snprintf(path, sizeof path, "%.*s/%s", dlen, p->file->path, name);
            if (n > 0 && n < (int)sizeof path) {
                FILE *f = fopen(path, "r");
                if (f) {
                    fclose(f);
                    return xstrdup(path);
                }
            }
        }
    }

    for (int i = 0; i < p->ninclude_paths; i++) {
        n = snprintf(path, sizeof path, "%s/%s", p->include_paths[i], name);
        if (n < 0 || n >= (int)sizeof path)
            continue;
        FILE *f = fopen(path, "r");
        if (f) {
            fclose(f);
            return xstrdup(path);
        }
    }

    return NULL;
}

static void
handle_define(struct cpp *p, const char *line)
{
    const char *s = skip_ws(line);
    const char *name_start = s;
    while (*s && (isalnum(*s) || *s == '_'))
        s++;
    int name_len = (int)(s - name_start);
    if (name_len == 0) {
        warn("#define: missing macro name");
        return;
    }
    char *name = xstrndup(name_start, name_len);

    int is_func = 0;
    int nparams = 0;
    int is_variadic = 0;
    char **params = NULL;

    /* function-like macro: '(' immediately after name (no space) */
    if (*s == '(') {
        is_func = 1;
        s++;
        int cap = 8;
        params = xmalloc(cap * sizeof(char *));

        s = skip_ws(s);
        while (*s && *s != ')') {
            if (*s == '.' && s[1] == '.' && s[2] == '.') {
                is_variadic = 1;
                s += 3;
                s = skip_ws(s);
                break;
            }
            const char *pstart = s;
            while (*s && (isalnum(*s) || *s == '_'))
                s++;
            if (s == pstart)
                break;
            if (nparams >= cap) {
                cap *= 2;
                params = realloc(params, cap * sizeof(char *));
            }
            params[nparams++] = xstrndup(pstart, (int)(s - pstart));
            s = skip_ws(s);
            if (*s == ',') {
                s++;
                s = skip_ws(s);
            } else if (*s == '.' && s[1] == '.' && s[2] == '.') {
                is_variadic = 1;
                s += 3;
                s = skip_ws(s);
                break;
            }
        }
        if (*s == ')')
            s++;
    }

    s = skip_ws(s);
    int body_len = (int)strlen(s);
    /* trim trailing whitespace */
    while (body_len > 0 && (s[body_len - 1] == ' ' || s[body_len - 1] == '\t'))
        body_len--;

    struct pp_token *body = NULL;
    if (body_len > 0)
        body = pp_tokenize(s, body_len);

    /* strip spaces adjacent to ## (paste) and between # and param */
    struct pp_token *prev = NULL;
    struct pp_token *cur = body;
    while (cur) {
        if (cur->kind == PP_PUNCT && cur->len == 2 &&
            cur->text[0] == '#' && cur->text[1] == '#') {
            /* remove trailing space on prev */
            if (prev && prev->kind == PP_SPACE) {
                struct pp_token *sp = prev;
                /* re-find the node before sp */
                if (sp == body) {
                    body = cur;
                } else {
                    struct pp_token *pp = body;
                    while (pp->next != sp)
                        pp = pp->next;
                    pp->next = cur;
                    prev = pp;
                }
                free(sp->text);
                free(sp);
            }
            /* remove leading space after ## */
            if (cur->next && cur->next->kind == PP_SPACE) {
                struct pp_token *sp = cur->next;
                cur->next = sp->next;
                free(sp->text);
                free(sp);
            }
        }
        prev = cur;
        cur = cur->next;
    }

    macro_define(p, name, body, is_func, nparams, params, is_variadic);
    free(name);
}

static void
handle_include(struct cpp *p, const char *line)
{
    const char *s = skip_ws(line);
    int is_system = 0;
    char name[4096];

    if (*s == '<') {
        is_system = 1;
        s++;
        int i = 0;
        while (*s && *s != '>' && i < (int)sizeof(name) - 1)
            name[i++] = *s++;
        name[i] = '\0';
    } else if (*s == '"') {
        s++;
        int i = 0;
        while (*s && *s != '"' && i < (int)sizeof(name) - 1)
            name[i++] = *s++;
        name[i] = '\0';
    } else {
        /* macro-expanded include — expand and retry */
        struct pp_token *tokens = pp_tokenize(s, (int)strlen(s));
        struct pp_token *expanded = macro_expand(p, tokens);
        char buf[4096];
        pp_detokenize(expanded, buf, sizeof buf);
        pp_free_tokens(expanded);
        handle_include(p, buf);
        return;
    }

    char *path = resolve_include(p, name, is_system);
    if (!path) {
        cpp_error(p, "%s:%d: cannot find include file '%s'",
                  p->file ? p->file->path : "<unknown>",
                  p->file ? p->file->line : 0, name);
        return;
    }

    char *buf = slurp(path);
    if (!buf) {
        cpp_error(p, "%s:%d: cannot read include file '%s'",
                  p->file ? p->file->path : "<unknown>",
                  p->file ? p->file->line : 0, path);
        free(path);
        return;
    }

    file_push(p, path, buf);
    free(path);
}

static void
handle_ifdef(struct cpp *p, const char *line, int want_defined)
{
    const char *s = skip_ws(line);
    const char *name_start = s;
    while (*s && (isalnum(*s) || *s == '_'))
        s++;
    int name_len = (int)(s - name_start);
    if (name_len == 0) {
        warn("#ifdef/#ifndef: missing identifier");
        cond_push(p, 0);
        return;
    }
    char *name = xstrndup(name_start, name_len);
    int defined = macro_lookup(p, name) != NULL;
    free(name);
    cond_push(p, want_defined ? defined : !defined);
}

static void
handle_if(struct cpp *p, const char *line)
{
    struct pp_token *tokens = pp_tokenize(line, (int)strlen(line));
    long long val = cond_eval(p, tokens);
    cond_push(p, val != 0);
}

static void
handle_elif(struct cpp *p, const char *line)
{
    if (!p->cond) {
        cpp_error(p, "#elif without #if");
        return;
    }
    if (p->cond->is_else) {
        cpp_error(p, "#elif after #else");
        return;
    }
    if (p->cond->seen_true) {
        p->cond->active = 0;
    } else {
        struct pp_token *tokens = pp_tokenize(line, (int)strlen(line));
        int parent_active = p->cond->up ? p->cond->up->active : 1;
        long long val = cond_eval(p, tokens);
        if (val && parent_active) {
            p->cond->active = 1;
            p->cond->seen_true = 1;
        } else {
            p->cond->active = 0;
        }
    }
}

static void
handle_else(struct cpp *p)
{
    if (!p->cond) {
        cpp_error(p, "#else without #if");
        return;
    }
    if (p->cond->is_else) {
        cpp_error(p, "duplicate #else");
        return;
    }
    p->cond->is_else = 1;
    if (p->cond->seen_true) {
        p->cond->active = 0;
    } else {
        int parent_active = p->cond->up ? p->cond->up->active : 1;
        p->cond->active = parent_active;
        p->cond->seen_true = 1;
    }
}

static void
handle_error(struct cpp *p, const char *line)
{
    const char *s = skip_ws(line);
    cpp_error(p, "%s:%d: #error %s",
              p->file ? p->file->path : "<unknown>",
              p->file ? p->file->line : 0, s);
}

static void
handle_line_directive(struct cpp *p, const char *line)
{
    const char *s = skip_ws(line);
    char *end;
    long num = strtol(s, &end, 10);
    if (end > s && p->file) {
        p->file->line = (int)num;
        s = skip_ws(end);
        if (*s == '"') {
            s++;
            const char *name_start = s;
            while (*s && *s != '"')
                s++;
            free((char *)p->file->path);
            p->file->path = xstrndup(name_start, (int)(s - name_start));
        }
    }
}

static int
process_directive(struct cpp *p, const char *line, int len)
{
    const char *s = line;
    (void)len;

    /* skip '#' and whitespace */
    s++;
    s = skip_ws(s);

    /* null directive */
    if (*s == '\0' || *s == '\n')
        return 0;

    /* extract directive name */
    const char *dir_start = s;
    while (*s && isalpha(*s))
        s++;
    int dir_len = (int)(s - dir_start);
    s = skip_ws(s);

    /* conditionals that must be processed even when skipping */
    if (dir_len == 5 && memcmp(dir_start, "endif", 5) == 0) {
        cond_pop(p);
        return 0;
    }
    if (dir_len == 5 && memcmp(dir_start, "ifdef", 5) == 0) {
        if (!cond_active(p)) {
            cond_push(p, 0);
            return 0;
        }
        handle_ifdef(p, s, 1);
        return 0;
    }
    if (dir_len == 6 && memcmp(dir_start, "ifndef", 6) == 0) {
        if (!cond_active(p)) {
            cond_push(p, 0);
            return 0;
        }
        handle_ifdef(p, s, 0);
        return 0;
    }
    if (dir_len == 2 && memcmp(dir_start, "if", 2) == 0) {
        if (!cond_active(p)) {
            cond_push(p, 0);
            return 0;
        }
        handle_if(p, s);
        return 0;
    }
    if (dir_len == 4 && memcmp(dir_start, "elif", 4) == 0) {
        handle_elif(p, s);
        return 0;
    }
    if (dir_len == 4 && memcmp(dir_start, "else", 4) == 0) {
        handle_else(p);
        return 0;
    }

    /* all other directives are skipped when not active */
    if (!cond_active(p))
        return 0;

    if (dir_len == 6 && memcmp(dir_start, "define", 6) == 0) {
        handle_define(p, s);
        return 0;
    }
    if (dir_len == 5 && memcmp(dir_start, "undef", 5) == 0) {
        const char *ns = skip_ws(s);
        const char *ne = ns;
        while (*ne && (isalnum(*ne) || *ne == '_'))
            ne++;
        if (ne > ns) {
            char *name = xstrndup(ns, (int)(ne - ns));
            macro_undef(p, name);
            free(name);
        }
        return 0;
    }
    if (dir_len == 7 && memcmp(dir_start, "include", 7) == 0) {
        handle_include(p, s);
        return 0;
    }
    if (dir_len == 5 && memcmp(dir_start, "error", 5) == 0) {
        handle_error(p, s);
        return -1;
    }
    if (dir_len == 7 && memcmp(dir_start, "warning", 7) == 0) {
        const char *msg = skip_ws(s);
        warn("%s:%d: #warning %s",
             p->file ? p->file->path : "<unknown>",
             p->file ? p->file->line : 0, msg);
        return 0;
    }
    if (dir_len == 4 && memcmp(dir_start, "line", 4) == 0) {
        handle_line_directive(p, s);
        return 0;
    }
    if (dir_len == 6 && memcmp(dir_start, "pragma", 6) == 0) {
        return 0;
    }

    warn("%s:%d: unknown directive '#%.*s'",
         p->file ? p->file->path : "<unknown>",
         p->file ? p->file->line : 0, dir_len, dir_start);
    return 0;
}

static void
strip_block_comments(struct cpp *p)
{
    char *src = p->linebuf;
    char *dst = p->linebuf;

    if (p->in_comment) {
        char *close = strstr(src, "*/");
        if (!close) {
            p->linebuf[0] = '\0';
            return;
        }
        src = close + 2;
        p->in_comment = 0;
        *dst++ = ' ';
    }

    while (*src) {
        if (*src == '"' || *src == '\'') {
            char quote = *src;
            *dst++ = *src++;
            while (*src && *src != quote) {
                if (*src == '\\' && src[1])
                    *dst++ = *src++;
                *dst++ = *src++;
            }
            if (*src)
                *dst++ = *src++;
            continue;
        }
        if (src[0] == '/' && src[1] == '/') {
            break;
        }
        if (src[0] == '/' && src[1] == '*') {
            char *close = strstr(src + 2, "*/");
            if (close) {
                *dst++ = ' ';
                src = close + 2;
                continue;
            }
            p->in_comment = 1;
            break;
        }
        *dst++ = *src++;
    }

    *dst = '\0';
}

/* Public API implementation */

static unsigned
hash_name(const char *name)
{
    unsigned h = 0;
    while (*name)
        h = h * 31 + (unsigned char)*name++;
    return h % CPP_HTAB_SIZE;
}

static void
define_builtin(struct cpp *p, const char *name, int id)
{
    unsigned h = hash_name(name);
    struct cpp_macro *m = xmalloc(sizeof *m);
    m->name = xstrdup(name);
    m->is_func = 0;
    m->nparams = 0;
    m->is_variadic = 0;
    m->params = NULL;
    m->body = NULL;
    m->builtin = id;
    m->expanding = 0;
    m->next = p->macros[h];
    p->macros[h] = m;
}

struct cpp *
cpp_new(void)
{
    struct cpp *p = xcalloc(1, sizeof *p);

    time_t now = time(NULL);
    struct tm *tm = localtime(&now);
    char buf[32];
    strftime(buf, sizeof buf, "\"%b %e %Y\"", tm);
    p->date_str = xstrdup(buf);
    strftime(buf, sizeof buf, "\"%H:%M:%S\"", tm);
    p->time_str = xstrdup(buf);

    define_builtin(p, "__FILE__", BUILTIN_FILE);
    define_builtin(p, "__LINE__", BUILTIN_LINE);
    define_builtin(p, "__DATE__", BUILTIN_DATE);
    define_builtin(p, "__TIME__", BUILTIN_TIME);
    define_builtin(p, "__STDC__", BUILTIN_STDC);
    define_builtin(p, "__STDC_VERSION__", BUILTIN_STDC_VERSION);

    return p;
}

void
cpp_free(struct cpp *p)
{
    if (!p)
        return;
    while (p->file)
        file_pop(p);
    while (p->cond)
        cond_pop(p);
    for (int i = 0; i < CPP_HTAB_SIZE; i++) {
        struct cpp_macro *m = p->macros[i];
        while (m) {
            struct cpp_macro *next = m->next;
            free(m->name);
            pp_free_tokens(m->body);
            for (int j = 0; j < m->nparams; j++)
                free(m->params[j]);
            free(m->params);
            free(m);
            m = next;
        }
    }
    for (int i = 0; i < p->ninclude_paths; i++)
        free((void *)p->include_paths[i]);
    free(p->include_paths);
    free(p->date_str);
    free(p->time_str);
    free(p);
}

void
cpp_add_include_path(struct cpp *p, const char *dir)
{
    if (p->ninclude_paths >= p->include_paths_cap) {
        p->include_paths_cap = p->include_paths_cap ? p->include_paths_cap * 2 : 8;
        p->include_paths = realloc(p->include_paths,
                                   p->include_paths_cap * sizeof(const char *));
    }
    p->include_paths[p->ninclude_paths++] = xstrdup(dir);
}

void
cpp_define(struct cpp *p, const char *name, const char *value)
{
    struct pp_token *body = NULL;
    if (value && *value)
        body = pp_tokenize(value, (int)strlen(value));
    macro_define(p, name, body, 0, 0, NULL, 0);
}

void
cpp_undef(struct cpp *p, const char *name)
{
    macro_undef(p, name);
}

int
cpp_open(struct cpp *p, const char *path)
{
    char *buf = slurp(path);
    if (!buf)
        return -1;
    file_push(p, path, buf);
    return 0;
}

int
cpp_get_line_number(struct cpp *p)
{
    return p->file ? p->file->line : 0;
}

const char *
cpp_get_filename(struct cpp *p)
{
    return p->file ? p->file->path : NULL;
}

int
cpp_next_line(struct cpp *p, char *buf, int bufsize)
{
    for (;;) {
        if (!p->file)
            return 0;

        if (!read_logical_line(p, p->linebuf, sizeof p->linebuf)) {
            file_pop(p);
            continue;
        }

        strip_block_comments(p);

        const char *s = skip_ws(p->linebuf);
        if (*s == '#') {
            int rc = process_directive(p, s, (int)strlen(s));
            if (rc < 0)
                return -1;
            continue;
        }

        if (!cond_active(p))
            continue;

        /* expand macros in the line */
        struct pp_token *tokens = pp_tokenize(p->linebuf,
                                              (int)strlen(p->linebuf));
        struct pp_token *expanded = macro_expand(p, tokens);
        int len = pp_detokenize(expanded, buf, bufsize - 1);
        pp_free_tokens(expanded);
        if (len == 0)
            continue;
        buf[len++] = '\n';
        buf[len] = '\0';
        return len;
    }
}

int
cpp_process_file(struct cpp *p, const char *path, FILE *out)
{
    if (cpp_open(p, path) < 0)
        return -1;

    char buf[8192];
    int rc;
    while ((rc = cpp_next_line(p, buf, sizeof buf)) > 0) {
        fwrite(buf, 1, rc, out);
    }

    /* A conditional left open at end of input is a constraint violation. */
    while (p->cond) {
        cpp_error(p, "unterminated #if (missing #endif)");
        cond_pop(p);
    }

    /* Any counted error (a #error, an unbalanced conditional, a missing
     * include) fails the run, so the exit code reflects the diagnostics
     * rather than only a hard read failure. */
    return (rc < 0 || p->errors) ? -1 : 0;
}
