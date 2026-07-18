/*
 * bitmap.c - large resizable bit array.
 *
 * Extracted from common.c for independent unit testing.
 */
#include "bitmap.h"
#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "bitmap"
#endif
#include "log.h"
#include "debug.h"
#include <assert.h>
#include <stdlib.h>
#include <string.h>

#ifndef ROUNDUP
#define ROUNDUP(a,n) (((a)+(n)-1)/(n)*(n))
#endif

/**
 * initialize an bitmap structure to be empty.
 */
void
bitmap_init(struct bitmap *bitmap)
{
	assert(bitmap != NULL);
	bitmap->bitmap = 0;
	bitmap->bitmap_allocbits = 0;
}

/**
 * free a bitmap structure.
 */
void
bitmap_free(struct bitmap *bitmap)
{
	assert(bitmap != NULL); /* catch when calling free on NULL */

	if (bitmap) {
		free(bitmap->bitmap);
		bitmap_init(bitmap);
	}
}

/**
 * resize (grow or shrink) a struct bitmap.
 * @param bitmap the bitmap structure.
 * @param newbits is in bits (not bytes).
 */
int
bitmap_resize(struct bitmap *bitmap, size_t newbits)
{
	unsigned *tmp;

	newbits = ROUNDUP(newbits, BITMAP_BITSIZE);
	LOG_DEBUG("Allocating %zd bytes", newbits / CHAR_BIT);
	tmp = realloc(bitmap->bitmap, newbits / CHAR_BIT);

	if (!tmp) {
		LOG_PERROR("realloc()");
		return 0; /* failure */
	}

	if (bitmap->bitmap_allocbits < newbits) {
		/* clear out the new bits */
		size_t len;
		len = (newbits - bitmap->bitmap_allocbits) / CHAR_BIT;
		LOG_DEBUG("Clearing %zd bytes (ofs %zd)", len, bitmap->bitmap_allocbits / BITMAP_BITSIZE);
		memset(tmp + bitmap->bitmap_allocbits / BITMAP_BITSIZE, 0, len);
	}

	bitmap->bitmap = tmp;
	bitmap->bitmap_allocbits = newbits;
	return 1; /* success */
}

/**
 * set a range of bits to 0.
 * @param bitmap the bitmap structure.
 * @param ofs first bit to clear.
 * @param len number of bits to clear.
 */
void
bitmap_clear(struct bitmap *bitmap, unsigned ofs, unsigned len)
{
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if (ofs + len > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs + len);
	}

	p = bitmap->bitmap + ofs / BITMAP_BITSIZE; /* point to the first word */

	head_ofs = ofs % BITMAP_BITSIZE;
	head_len = len > BITMAP_BITSIZE - ofs ? BITMAP_BITSIZE - ofs : len;

	/* head */
	if (head_len < BITMAP_BITSIZE) {
		len -= head_len;
		mask = ~(~((~0U) << head_len) << head_ofs);
		*p++ &= mask;
	}

	for (; len >= BITMAP_BITSIZE; len -= BITMAP_BITSIZE) {
		*p++ = 0U;
	}

	if (len > 0) {
		/* tail */
		mask = ~((~0U) >> (BITMAP_BITSIZE - len));
		mask = (~0U) >> len;
		*p &= mask;
	}
}

/**
 * set a range of bits to 1.
 * @param bitmap the bitmap structure.
 * @param ofs first bit to set.
 * @param len number of bits to set.
 */
void
bitmap_set(struct bitmap *bitmap, unsigned ofs, unsigned len)
{
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if (ofs + len > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs + len);
	}

	p = bitmap->bitmap + ofs / BITMAP_BITSIZE; /* point to the first word */

	head_ofs = ofs % BITMAP_BITSIZE;
	head_len = len > BITMAP_BITSIZE - ofs ? BITMAP_BITSIZE - ofs : len;

	/* head */
	if (head_len < BITMAP_BITSIZE) {
		len -= head_len;
		mask = (~((~0U) << head_len)) << head_ofs;
		*p++ |= mask;
	}

	for (; len >= BITMAP_BITSIZE; len -= BITMAP_BITSIZE) {
		*p++ = ~0U;
	}

	if (len > 0) {
		/* tail */
		mask = (~0U) >> (BITMAP_BITSIZE - len);
		*p |= mask;
	}
}

/**
 * gets a single bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit.
 * @return 0 or 1 depending on value of the bit.
 */
int
bitmap_get(struct bitmap *bitmap, unsigned ofs)
{
	if (ofs < bitmap->bitmap_allocbits) {
		return (bitmap->bitmap[ofs / BITMAP_BITSIZE] >> (ofs % BITMAP_BITSIZE)) & 1;
	} else {
		return 0; /* outside of the range, the bits are cleared */
	}
}

/**
 * scan a bitmap structure for the next set bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit to begin scanning.
 * @return the position of the next set bit. -1 if the end of the bits was reached
 */
int
bitmap_next_set(struct bitmap *bitmap, unsigned ofs)
{
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len = bitmap->bitmap_allocbits / BITMAP_BITSIZE;
	LOG_TODO("check the head"); /* I don't remember what these TODO's are for */

	for (i = ofs / BITMAP_BITSIZE; i < len; i++) {
		if (bitmap->bitmap[i] != 0) {
			/* found a set bit - scan the word to find the position */
			for (bofs = 0; ((bitmap->bitmap[i] >> bofs) & 1) == 0; bofs++) ;

			return i * BITMAP_BITSIZE + bofs;
		}
	}

	LOG_TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/**
 * scan a bitmap structure for the next clear bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit to begin scanning.
 * @return the position of the next cleared bit. -1 if the end of the bits was reached
 */
int
bitmap_next_clear(struct bitmap *bitmap, unsigned ofs)
{
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len = bitmap->bitmap_allocbits / BITMAP_BITSIZE;
	LOG_TODO("check the head"); /* I don't remember what these TODO's are for */

	for (i = ofs / BITMAP_BITSIZE; i < len; i++) {
		if (bitmap->bitmap[i] != ~0U) {
			/* found a set bit - scan the word to find the position */
			for (bofs = 0; ((bitmap->bitmap[i] >> bofs) & 1) == 1; bofs++) ;

			return i * BITMAP_BITSIZE + bofs;
		}
	}

	LOG_TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/**
 * loads a chunk of memory into the bitmap structure.
 * erases previous bitmap buffer, resizes bitmap buffer to make room if necessary.
 * @param bitmap the bitmap structure.
 * @param d a buffer to use for initializing the bitmap.
 * @param len length in bytes of the buffer d.
 */
void
bitmap_loadmem(struct bitmap *bitmap, unsigned char *d, size_t len)
{
	unsigned *p, word_count, i;

	/* resize if too small */
	if ((len * CHAR_BIT) > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, len * CHAR_BIT);
	}

	p = bitmap->bitmap;
	word_count = len / sizeof * p; /* number of words in d */

	/* first do the words */
	while (word_count > 0) {
		i = sizeof * p - 1;
		*p = 0;

		do {
			*p |= *d << (i * CHAR_BIT);
			d++;
		} while (--i);

		p++;
		word_count--;
		len -= sizeof * p;
	}

	/* finish the remaining */
	i = sizeof * p - 1;

	while (len > 0) {
		*p &= 0xff << (i * CHAR_BIT);
		*p |= *d << (i * CHAR_BIT);
		i--;
		d++;
		len--;
	}
}

/**
 * Get the length (in bytes) of the bitmap table.
 * @return the length in bytes of the entire bitmap table.
 */
unsigned
bitmap_length(struct bitmap *bitmap)
{
	return bitmap ? ROUNDUP(bitmap->bitmap_allocbits, CHAR_BIT) / CHAR_BIT : 0;
}
