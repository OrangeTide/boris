#ifndef BITMAP_H_
#define BITMAP_H_
/*
 * bitmap - a large bit array that can be allocated to any size.
 *
 * Extracted from common.c.
 */
#include <limits.h>
#include <stddef.h>

/** size in bits of a group of bits for struct bitmap. */
#define BITMAP_BITSIZE (sizeof(unsigned)*CHAR_BIT)

/** a large bitarray that can be allocated to any size. */
struct bitmap {
	unsigned *bitmap;
	size_t bitmap_allocbits;
};

void bitmap_init(struct bitmap *bitmap);
void bitmap_free(struct bitmap *bitmap);
int bitmap_resize(struct bitmap *bitmap, size_t newbits);
void bitmap_clear(struct bitmap *bitmap, unsigned ofs, unsigned len);
void bitmap_set(struct bitmap *bitmap, unsigned ofs, unsigned len);
int bitmap_get(struct bitmap *bitmap, unsigned ofs);
int bitmap_next_set(struct bitmap *bitmap, unsigned ofs);
int bitmap_next_clear(struct bitmap *bitmap, unsigned ofs);
void bitmap_loadmem(struct bitmap *bitmap, unsigned char *d, size_t len);
unsigned bitmap_length(struct bitmap *bitmap);

#endif
