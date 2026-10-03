/* util.h : diagnostics, memory helpers, and error recovery */

#ifndef UTIL_H
#define UTIL_H

#include <setjmp.h>
#include <stddef.h>

#if !defined(NORETURN)
#if __STDC_VERSION__ >= 201112L
#define NORETURN _Noreturn
#elif defined(__GNUC__)
#define NORETURN __attribute__((noreturn))
#else
#define NORETURN
#endif
#endif

/****************************************************************
 * Error recovery
 ****************************************************************/

#define UTIL_CLEANUP_MAX 8

extern jmp_buf util_die_env;
extern int util_die_active;

void util_cleanup_push(void (*fn)(void *), void *ctx);
void util_cleanup_pop(void);
void util_cleanup_run(void);

/****************************************************************
 * Diagnostics
 ****************************************************************/

void util_set_progname(const char *name);
NORETURN void die(const char *fmt, ...);
void warn(const char *fmt, ...);

/****************************************************************
 * Memory helpers
 ****************************************************************/

void *xmalloc(size_t n);
void *xcalloc(size_t n, size_t sz);
char *xstrdup(const char *s);
char *xstrndup(const char *s, size_t n);
char *slurp(const char *path);

#endif /* UTIL_H */
