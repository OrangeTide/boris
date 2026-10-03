/* arena.h : bump allocator with mark/release */

#ifndef ARENA_H
#define ARENA_H

#include <stddef.h>

struct arena_page;

struct arena {
    struct arena_page *cur;
    size_t offset;
};

struct arena_mark {
    struct arena_page *page;
    size_t offset;
};

void  arena_init(struct arena *a);
void  arena_free(struct arena *a);
void *arena_alloc(struct arena *a, size_t n);
void *arena_zalloc(struct arena *a, size_t n);
char *arena_strdup(struct arena *a, const char *s);
char *arena_strndup(struct arena *a, const char *s, size_t n);
struct arena_mark arena_save(struct arena *a);
void  arena_release(struct arena *a, struct arena_mark m);

#endif /* ARENA_H */
