/* arena.c : bump allocator with mark/release */

#include "arena.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PAGE_SIZE 65536
#define ALIGN     8

struct arena_page {
    struct arena_page *prev;
    size_t size;
    char data[];
};

static struct arena_page *
page_new(size_t size)
{
    struct arena_page *p;

    p = malloc(sizeof(*p) + size);
    if (!p) {
        fprintf(stderr, "arena: out of memory\n");
        abort();
    }
    p->prev = NULL;
    p->size = size;
    return p;
}

void
arena_init(struct arena *a)
{
    a->cur = page_new(PAGE_SIZE);
    a->offset = 0;
}

void
arena_free(struct arena *a)
{
    struct arena_page *p, *prev;

    for (p = a->cur; p; p = prev) {
        prev = p->prev;
        free(p);
    }
    a->cur = NULL;
    a->offset = 0;
}

void *
arena_alloc(struct arena *a, size_t n)
{
    size_t aligned;
    struct arena_page *p;
    size_t pgsz;

    aligned = (a->offset + ALIGN - 1) & ~(size_t)(ALIGN - 1);
    if (aligned + n <= a->cur->size) {
        a->offset = aligned + n;
        return a->cur->data + aligned;
    }

    pgsz = PAGE_SIZE;
    if (n > pgsz)
        pgsz = n;
    p = page_new(pgsz);
    p->prev = a->cur;
    a->cur = p;
    a->offset = n;
    return p->data;
}

void *
arena_zalloc(struct arena *a, size_t n)
{
    void *p;

    p = arena_alloc(a, n);
    memset(p, 0, n);
    return p;
}

char *
arena_strdup(struct arena *a, const char *s)
{
    size_t n;
    char *p;

    n = strlen(s);
    p = arena_alloc(a, n + 1);
    memcpy(p, s, n + 1);
    return p;
}

char *
arena_strndup(struct arena *a, const char *s, size_t n)
{
    char *p;

    p = arena_alloc(a, n + 1);
    memcpy(p, s, n);
    p[n] = '\0';
    return p;
}

struct arena_mark
arena_save(struct arena *a)
{
    struct arena_mark m;

    m.page = a->cur;
    m.offset = a->offset;
    return m;
}

void
arena_release(struct arena *a, struct arena_mark m)
{
    struct arena_page *p, *prev;

    for (p = a->cur; p != m.page; p = prev) {
        prev = p->prev;
        free(p);
    }
    a->cur = m.page;
    a->offset = m.offset;
}
