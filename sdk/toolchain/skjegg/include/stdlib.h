#ifndef _STDLIB_H
#define _STDLIB_H

#include <stddef.h>
#include <stdint.h>

#define EXIT_SUCCESS 0
#define EXIT_FAILURE 1
#define RAND_MAX     32767

typedef struct { int quot; int rem; } div_t;
typedef struct { long quot; long rem; } ldiv_t;

int        abs(int n);
long       labs(long n);
long long  llabs(long long n);
div_t      div(int num, int den);
ldiv_t     ldiv(long num, long den);

int                atoi(const char *s);
long               atol(const char *s);
double             atof(const char *s);
long               strtol(const char *s, char **end, int base);
unsigned long      strtoul(const char *s, char **end, int base);
long long          strtoll(const char *s, char **end, int base);
unsigned long long strtoull(const char *s, char **end, int base);
double             strtod(const char *s, char **end);

int   rand(void);
void  srand(unsigned seed);

/* The CSPRNG surface, seeded from host entropy on first use (no seed API). */
uint32_t arc4random(void);
void     arc4random_buf(void *buf, size_t n);
uint32_t arc4random_uniform(uint32_t bound);

void  *malloc(size_t size);
void  *calloc(size_t n, size_t size);
void  *realloc(void *ptr, size_t size);
void   free(void *ptr);

void  *bsearch(const void *key, const void *base, size_t n, size_t size,
               int (*cmp)(const void *, const void *));
void   qsort(void *base, size_t n, size_t size,
             int (*cmp)(const void *, const void *));

void   abort(void);
void   exit(int code);
int    atexit(void (*fn)(void));

extern char **environ;
char  *getenv(const char *name);

#endif
