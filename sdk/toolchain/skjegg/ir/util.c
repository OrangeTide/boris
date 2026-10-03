/* util.c : diagnostics, allocation helpers, and error recovery */

#include "util.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************************************************************
 * Error recovery
 ****************************************************************/

jmp_buf util_die_env;
int util_die_active;

static struct {
    void (*fn)(void *);
    void *ctx;
} cleanup_stack[UTIL_CLEANUP_MAX];
static int ncleanups;

void
util_cleanup_push(void (*fn)(void *), void *ctx)
{
    if (ncleanups >= UTIL_CLEANUP_MAX)
        die("cleanup stack overflow");
    cleanup_stack[ncleanups].fn = fn;
    cleanup_stack[ncleanups].ctx = ctx;
    ncleanups++;
}

void
util_cleanup_pop(void)
{
    if (ncleanups > 0)
        ncleanups--;
}

void
util_cleanup_run(void)
{
    while (ncleanups > 0) {
        int i = --ncleanups;
        cleanup_stack[i].fn(cleanup_stack[i].ctx);
    }
}

/****************************************************************
 * Diagnostics
 ****************************************************************/

static const char *progname = "compiler";

void
util_set_progname(const char *name)
{
    progname = name;
}

NORETURN void
die(const char *fmt, ...)
{
    va_list ap;
    int was_active;

    va_start(ap, fmt);
    fprintf(stderr, "%s: error: ", progname);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);

    was_active = util_die_active;
    util_die_active = 0;
    util_cleanup_run();

    if (was_active)
        longjmp(util_die_env, 1);
    exit(1);
}

void
warn(const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    fprintf(stderr, "%s: warning: ", progname);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
}

/****************************************************************
 * Memory helpers
 ****************************************************************/

void *
xmalloc(size_t n)
{
    void *p;

    p = malloc(n);
    if (p == NULL)
        die("out of memory");
    return p;
}

void *
xcalloc(size_t n, size_t sz)
{
    void *p;

    p = calloc(n, sz);
    if (p == NULL)
        die("out of memory");
    return p;
}

char *
xstrdup(const char *s)
{
    size_t n;
    char *p;

    n = strlen(s);
    p = xmalloc(n + 1);
    memcpy(p, s, n + 1);
    return p;
}

char *
xstrndup(const char *s, size_t n)
{
    char *p;

    p = xmalloc(n + 1);
    memcpy(p, s, n);
    p[n] = '\0';
    return p;
}

char *
slurp(const char *path)
{
    FILE *f;
    long n;
    char *buf;

    f = fopen(path, "rb");
    if (!f)
        die("cannot open %s", path);
    if (fseek(f, 0, SEEK_END) != 0 || (n = ftell(f)) < 0) {
        fclose(f);
        die("cannot read %s", path);
    }
    rewind(f);
    buf = malloc((size_t)n + 1);
    if (!buf) {
        fclose(f);
        die("out of memory");
    }
    if (fread(buf, 1, (size_t)n, f) != (size_t)n) {
        free(buf);
        fclose(f);
        die("read failed on %s", path);
    }
    fclose(f);
    buf[n] = '\0';
    return buf;
}
