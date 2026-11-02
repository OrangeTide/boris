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
    /* ftell on a directory or a special file can report a wild size (a
       #include naming a directory is the common way in); cap it so the size is
       never trusted into an absurd allocation. A real source file is far under
       this, and a directory/device then fails cleanly here or on the read. */
    if (n > (1L << 30)) {
        fclose(f);
        die("file too large: %s", path);
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

/****************************************************************
 * String set (open addressing, borrowed keys)
 *
 * Membership for C strings whose storage outlives the set.  Keys are not
 * copied, only pointed at.  Used to turn a linear "is this name already in a
 * list" scan (repeated strcmp against a growing array) into an O(1) lookup.
 ****************************************************************/

static size_t
strset_hash(const char *s)
{
    unsigned long long h = 1469598103934665603ULL;   /* FNV-1a 64-bit */

    while (*s) {
        h ^= (unsigned char)*s++;
        h *= 1099511628211ULL;
    }
    return (size_t)h;
}

void
strset_init(struct strset *s)
{
    s->slots = NULL;
    s->cap = 0;
    s->count = 0;
}

static void
strset_grow(struct strset *s)
{
    size_t newcap = s->cap ? s->cap * 2 : 64;
    const char **ns = xcalloc(newcap, sizeof *ns);
    size_t mask = newcap - 1;
    size_t i;

    for (i = 0; i < s->cap; i++) {
        const char *k = s->slots[i];
        size_t j;
        if (!k)
            continue;
        for (j = strset_hash(k) & mask; ns[j]; j = (j + 1) & mask)
            ;
        ns[j] = k;
    }
    free(s->slots);
    s->slots = ns;
    s->cap = newcap;
}

int
strset_contains(const struct strset *s, const char *key)
{
    size_t mask, i;

    if (!s->cap)
        return 0;
    mask = s->cap - 1;
    for (i = strset_hash(key) & mask; s->slots[i]; i = (i + 1) & mask)
        if (strcmp(s->slots[i], key) == 0)
            return 1;
    return 0;
}

int
strset_add(struct strset *s, const char *key)
{
    size_t mask, i;

    /* keep the load factor under 1/2 so probe chains stay short */
    if (s->count * 2 >= s->cap)
        strset_grow(s);
    mask = s->cap - 1;
    for (i = strset_hash(key) & mask; s->slots[i]; i = (i + 1) & mask)
        if (strcmp(s->slots[i], key) == 0)
            return 0;
    s->slots[i] = key;
    s->count++;
    return 1;
}

void
strset_free(struct strset *s)
{
    free(s->slots);
    s->slots = NULL;
    s->cap = 0;
    s->count = 0;
}
