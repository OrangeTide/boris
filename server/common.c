/**
 * @file common.c
 *
 * Several routines that haven't been split up into libraries yet.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/** @mainpage
 *
 * Design Documentation
 *
 *
 * components:
 * - bitfield - manages small staticly sized bitmaps. uses @ref BITFIELD
 * - bitmap - manages large bitmaps
 * - buffer - manages an i/o buffer
 * - heapqueue_elm - priority queue for implementing timers
 * - refcount - macros to provide reference counting. uses @ref REFCOUNT_PUT and @ref REFCOUNT_GET
 * - server - accepts new connections
 * - shvar - process $() macros. implemented by @ref shvar_eval.
 * - user - user account handling. see also user_name_map_entry.
 * - util_strfile - holds contents of a textfile in an array.
 *
 * dependency:
 * - user - uses ref counts.
 *
 * types of records:
 * - objects - base objects for room, mob, or item
 * - instances - instance data for room, mob or item
 * - container - container data for room, mob or item (a type of instance data)
 * - stringmap - maps strings to a data structure (hash table)
 * - numbermap - maps integers to a data structure (hash table)
 * - strings - a large string that can span multiple blocks
 *
 * objects:
 * - base - the following types of objects are defined:
 *   - room
 *   - mob
 *   - item
 * - instance - all instances are the same structure:
 *   - id - object id
 *   - count - all item instances are stackable 1 to 256.
 *   - flags - 24 status flags [A-HJ-KM-Z]
 *   - extra1..extra2 - control values that can be variable
 *
 * containers:
 * - instance parameter holds a id that holds an array of up to 64 objects.
 *
 * database saves the following types of blobs:
 * - player account
 * - room object
 * - mob object (also used for characters)
 * - item object
 * - instances
 * - container slots
 * - help text
 *
 ******************************************************************************/

/******************************************************************************
 * Configuration
 ******************************************************************************/

/* make sure WIN32 is defined when building in a Windows environment */
#if (defined(_MSC_VER) || defined(__WIN32__)) && !defined(WIN32)
#define WIN32
#endif

#define SUBSYSTEM_NAME "server_core"

/**
 * maximum output buffer size for telnet clients.
 * this control output line length. */
#define TELNETCLIENT_OUTPUT_BUFFER_SZ 4096

/**
 * maximum input buffer size fo telnet clients
 * this control input line length */
#define TELNETCLIENT_INPUT_BUFFER_SZ 256

/******************************************************************************
 * Headers
 ******************************************************************************/

#include <assert.h>
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <signal.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _XOPEN_SOURCE
#include <strings.h>
#endif
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <dyad.h>

#include "boris.h"
#include "mud.h"
#include "command.h"
#include "channel.h"
#define LOG_SUBSYSTEM "server"
#include <log.h>
#include "debug.h"
#include "eventlog.h"
#include "fdb.h"
#include "freelist.h"
#include "list.h"
#include "sha1.h"
#include "sha1crypt.h"
#include "util.h"
#include "config.h"
#include "worldclock.h"

/******************************************************************************
 * Types and data structures
 ******************************************************************************/

/******************************************************************************
 * Globals
 ******************************************************************************/

/** global configuration used in many different places */
MUD_CONFIG mud_config;

/** global mud state used in many different places */
MUD_DATA mud;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

/******************************************************************************
 * name-value parser routines.
 ******************************************************************************/

/**
 * parse a value string into a uint.
 */
int
parse_uint(const char *name, const char *value, unsigned *uint_p)
{
	char *endptr;
	assert(uint_p != NULL);

	if (!uint_p) return 0; /* error */

	if (!value || !*value) {
		LOG_ERROR("%s:Empty string", name);
		return 0; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		LOG_ERROR("%s:Not a number", name);
		return 0; /* error - not a number */
	}

	return 1; /* success */
}

/**
 * load a string into str_p, free()ing string at str_p first.
 */
int
parse_str(const char *name UNUSED, const char *value, char **str_p)
{
	assert(str_p != NULL);
	assert(value != NULL);

	if (!str_p) return 0; /* error */

	if (*str_p) free(*str_p);

	*str_p = strdup(value);

	if (!*str_p) {
		LOG_PERROR("strdup()");
		return 0; /* error */
	}

	return 1; /* success */
}

/**
 * add to an attribute list.
 */
int
parse_attr(const char *name, const char *value, struct attr_list *al)
{
	struct attr_entry *at;

	assert(name != NULL);
	assert(value != NULL);
	assert(al != NULL);

	at = attr_find(al, name);

	if (!at) {
		return attr_add(al, name, value);
	}

	free(at->value);
	at->value = strdup(value);
	return 1; /* success. */
}

/**
 * set a value into p according to type.
 */
int
value_set(const char *value, enum value_type type, void *p)
{
	assert(p != NULL);
	assert(value != NULL);

	if (!p || !value) return 0; /* error */

	switch(type) {
	case VALUE_TYPE_STRING: {
		if (*(char**)p) free(*(char**)p);

		*(char**)p = strdup(value);

		if (!*(char**)p) {
			LOG_PERROR("strdup()");
			return 0; /* error */
		}

		return 1; /* success */
	}

	case VALUE_TYPE_UINT: {
		char *endptr;

		if (!*value) {
			LOG_ERROR("Empty string");
			return 0; /* error - empty string */
		}

		*(unsigned*)p = strtoul(value, &endptr, 0);

		if (*endptr != 0) {
			LOG_ERROR("Not a number:\"%s\"\n", value);
			return 0; /* error - not a number */
		}

		return 1; /* success */
	}
	}

	return 0; /* failure. */
}

/**
 * convert a value at p into a string according to type.
 * string returned is temporary and can change if an object is modified or if
 * this function is called again.
 */
const char *
value_get(enum value_type type, void *p)
{
	static char numbuf[22]; /* big enough for a signed 64-bit decimal */

	switch(type) {
	case VALUE_TYPE_STRING:
		return *(char**)p;

	case VALUE_TYPE_UINT:
		snprintf(numbuf, sizeof numbuf, "%u", *(unsigned*)p);
		return numbuf;
	}

	return NULL;
}

/******************************************************************************
 * Debug and test routines
 ******************************************************************************/

/* enable these routines unless both NDEBUG and NTEST are defined.
 * if debugging or testing is enabled then we need some of these functions.
 */
#if !defined(NTEST) || !defined(NDEBUG)
/**
 * debug routine to convert a number to a string.
 * @param n the value.
 * @param base the output base (2 to 64)
 * @param pad length to use when padding with zeros. 0 means do not pad.
 */
static const char *
util_convertnumber(unsigned n, unsigned base, unsigned pad)
{
	static char number_buffer[65];
	static const char tab[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-";
	char *o; /* output */
	size_t len;

	if (base < 2) base = 2;

	if (base > sizeof tab) base = sizeof tab;

	o = number_buffer + sizeof number_buffer;
	*--o = 0;

	do {
		*--o = tab[n % base];
		n /= base;
	} while (n);

	len = number_buffer + sizeof number_buffer - 1 - o;

	if (pad && len < pad) {
		for (pad = pad - len; pad; pad--) {
			*--o = tab[0];
		}
	}

	return o;
}
#endif

/******************************************************************************
 * shvar - shell variables
 ******************************************************************************/

/** maximum number of characters in a $(). */
#define SHVAR_ID_MAX 128

/** escape character used. */
#define SHVAR_ESCAPE '$'

/** evaluate "shell variables", basically expand ${FOO} in a string. */
int
shvar_eval(char *out, size_t len, const char *src, const char *(*match)(const char *key))
{
	const char *old;
	char key[SHVAR_ID_MAX];

	while (*src && len > 0) {
		if (*src == SHVAR_ESCAPE) {
			const char *key_start, *key_end;
			old = src; /* save old position */
			src++;

			if (*src == '{' || *src == '(') {
				char end_char;
				end_char = *src == '{' ? '}' : ')';
				src++;
				key_start = key_end = src;

				while (*src != end_char) {
					if (!*src) {
						size_t tmplen;
						tmplen = strlen(old);

						if (tmplen >= len) tmplen = len - 1;

						memcpy(out, old, tmplen);
						out[tmplen] = 0;
						return 0; /* failure */
					}

					src++;
				}

				key_end = src;
				src++;
			} else if (*src == SHVAR_ESCAPE) {
				*out++ = *src++;
				len--;
				continue;
			} else {
				key_start = src;

				while (*src && len > 0) {
					if (!isalnum(*src) && *src != '_') {
						break;
					}

					src++;
				}

				key_end = src;
			}

			if (match && key_end >= key_start) {
				const char *tmp;
				size_t tmplen;
				assert(key_start <= key_end);
				memcpy(key, key_start, (size_t)(key_end - key_start));
				key[key_end - key_start] = 0;
				tmp = match(key);

				if (tmp) {
					tmplen = strlen(tmp);

					if (tmplen > len) return 0; /* failure */

					memcpy(out, tmp, tmplen);
					out += tmplen;
					len -= tmplen;
				}
			}
		} else {
			*out++ = *src++;
			len--;
		}
	}

	if (len > 0) {
		*out++ = 0;
		len--;
		return *src == 0;
	}

	*out = 0;
	return 0; /* failure */
}

/******************************************************************************
 * heapqueue - a binary heap used as a priority queue
 ******************************************************************************/

/** the left child of i. */
#define HEAPQUEUE_LEFT(i) (2*(i)+1)

/** the right child of i. */
#define HEAPQUEUE_RIGHT(i) (2*(i)+2)

/** the parent of i. i should be signed else the parent of the root will be a
 * little weird.*/
#define HEAPQUEUE_PARENT(i) (((i)-1)/2)

/** element in the heapqueue. */
struct heapqueue_elm {
	unsigned d; /* key */
	/** @todo put useful data in here */
};

/** heap of 512 entries max. */
static struct heapqueue_elm heap[512];

/** currently used length of the heap. */
static unsigned heap_len;

/**
 * min heap is sorted by lowest value at root.
 * @return non-zero if a>b
 */
static inline int
heapqueue_greaterthan(struct heapqueue_elm *a, struct heapqueue_elm *b)
{
	assert(a != NULL);
	assert(b != NULL);
	return a->d > b->d;
}

/**
 * @param i the "hole" location
 * @param elm the value to compare against
 * @return new position of hole
 */
static int
heapqueue_ll_siftdown(unsigned i, struct heapqueue_elm *elm)
{
	assert(elm != NULL);
	assert(i < heap_len || i == 0);

	while (HEAPQUEUE_LEFT(i) < heap_len) { /* keep going until at a leaf node */
		unsigned child = HEAPQUEUE_LEFT(i);

		/* compare left and right(child+1) - use the smaller of the two */
		if (child + 1 < heap_len && heapqueue_greaterthan(&heap[child], &heap[child + 1])) {
			child++; /* left is bigger than right, use right */
		}

		/* child is the smallest child, if elm is smaller or equal then we're done */
		if (!(heapqueue_greaterthan(elm, &heap[child]))) { /* elm <= child */
			break;
		}

		/* swap "hole" and selected child */
		TRACE("swap hole %d with entry %d\n", i, child);
		heap[i] = heap[child];
		i = child;
	}

	TRACE("chosen position %d for hole.\n", i);
	return i;
}

/**
 * @param i the "hole" location
 * @param elm the value to compare against
 * @return the new position of the hole
 */
static int
heapqueue_ll_siftup(unsigned i, struct heapqueue_elm *elm)
{
	assert(elm != NULL);
	assert(i < heap_len);

	while (i > 0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], elm)) { /* Compare the element with parent */
		/* swap element with parent and keep going (keep tracking the "hole") */
		heap[i] = heap[HEAPQUEUE_PARENT(i)];
		i = HEAPQUEUE_PARENT(i);
	}

	return i;
}

/**
 * removes entry at i. */
int
heapqueue_cancel(unsigned i, struct heapqueue_elm *ret)
{
	/* 1. copy the value at i into ret
	 * 2. put last node into empty position
	 * 3. sift-up if moved node smaller than parent, sift-down if larger than either child
	 */
	struct heapqueue_elm *last;
	assert(ret != NULL);
	assert(i < heap_len);
	assert(heap_len < NR(heap));
	*ret = heap[i]; /* copy the value at i into ret */
	TRACE("canceling entry #%d: val=%d (parent=%d:>%u) (left %d:>%u) (right %d:>%u) (last %d)\n",
	      i, ret->d,
	      i > 0 ? (int)HEAPQUEUE_PARENT(i) : -1,
	      i > 0 ? heap[HEAPQUEUE_PARENT(i)].d : 0,
	      HEAPQUEUE_LEFT(i) < heap_len ? (int)HEAPQUEUE_LEFT(i) : -1,
	      HEAPQUEUE_LEFT(i) < heap_len ? heap[HEAPQUEUE_LEFT(i)].d : 0,
	      HEAPQUEUE_RIGHT(i) < heap_len ? (int)HEAPQUEUE_RIGHT(i) : -1,
	      HEAPQUEUE_RIGHT(i) < heap_len ? heap[HEAPQUEUE_RIGHT(i)].d : 0,
	      heap[heap_len - 1].d);

	/* move last entry to the empty position */
	heap_len--;
	last = &heap[heap_len];

	/* i now holds the position of the last entry, we will move this "hole" until
	 * it is in the correct place for last */

	if (i > 0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], last)) {
		/* we already did the compare, so we'll perform the first move here */
		TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_PARENT(i));
		heap[i] = heap[HEAPQUEUE_PARENT(i)]; /* move parent down */
		i = heapqueue_ll_siftup(HEAPQUEUE_PARENT(i), last); /* sift the "hole" up */
	} else if (HEAPQUEUE_RIGHT(i) < heap_len && (heapqueue_greaterthan(last, &heap[HEAPQUEUE_RIGHT(i)]) || heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)]))) {
		/* if right is on the list, then left is as well */
		if (heapqueue_greaterthan(&heap[HEAPQUEUE_LEFT(i)], &heap[HEAPQUEUE_RIGHT(i)])) {
			/* left is larger - use the right hole */
			TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_RIGHT(i));
			heap[i] = heap[HEAPQUEUE_RIGHT(i)]; /* move right up */
			i = heapqueue_ll_siftdown(HEAPQUEUE_RIGHT(i), last); /* sift the "hole" down */
		} else {
			/* right is the larger or equal - use the left hole */
			TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_LEFT(i));
			heap[i] = heap[HEAPQUEUE_LEFT(i)]; /* move left up */
			i = heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
		}
	} else if (HEAPQUEUE_LEFT(i) < heap_len && heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)])) {
		/* at this point there is no right node */
		TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_LEFT(i));
		heap[i] = heap[HEAPQUEUE_LEFT(i)]; /* move left up */
		i = heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
	}

	heap[i] = *last;
	return 1;
}

/**
 * sift-up operation for enqueueing.
 * -# Add the element on the bottom level of the heap.
 * -# Compare the added element with its parent; if they are in the correct order, stop.
 * -# If not, swap the element with its parent and return to the previous step.
 */
void
heapqueue_enqueue(struct heapqueue_elm *elm)
{
	unsigned i;
	assert(elm != NULL);
	assert(heap_len < NR(heap));

	i = heap_len++; /* add the element to the bottom of the heap (create a "hole") */
	i = heapqueue_ll_siftup(i, elm);
	heap[i] = *elm; /* fill in the "hole" */
}

/**
 * sift-down operation for dequeueing.
 * removes the root entry and copies it to ret.
 */
int
heapqueue_dequeue(struct heapqueue_elm *ret)
{
	unsigned i;
	assert(ret != NULL);

	if (heap_len <= 0)
		return 0; /* nothing to dequeue */

	*ret = heap[0]; /* we have to copy the root element somewhere because we're removing it */

	/* move last entry to the root, then sift-down */
	heap_len--;
	i = heapqueue_ll_siftdown(0, &heap[heap_len]);
	heap[i] = heap[heap_len];
	return 1;
}

#ifndef NTEST

/**
 * checks the heap to see that it is valid.
 */
static int
heapqueue_isvalid(void)
{
	unsigned i;

	for (i = 1; i < heap_len; i++) {
		if (heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], &heap[i])) {
			LOG_DEBUG("Bad heap at %d\n", i);
			return 0; /* not a valid heap */
		}
	}

	return 1; /* success */
}

/** dump the entire heapqueue data structure to stderr. */
static void
heapqueue_dump(void)
{
	unsigned i;
	fprintf(stderr, "::: Dumping heapqueue :::\n");

	for (i = 0; i < heap_len; i++) {
		printf("%03u = %4u (p:%d l:%d r:%d)\n", i, heap[i].d, i > 0 ? (int)HEAPQUEUE_PARENT(i) : -1, HEAPQUEUE_LEFT(i), HEAPQUEUE_RIGHT(i));
	}

	printf("heap valid? %d (%d entries)\n", heapqueue_isvalid(), heap_len);
}

/** test the heapqueue system. */
void
heapqueue_test(void)
{
	struct heapqueue_elm elm, tmp;
	unsigned i;
	const unsigned testdata[] = {
		42, 2, 123, 88, 3, 3, 3, 3, 3, 1, 0,
	};

	/* initialize the array */
	heap_len = 0;
#ifndef NDEBUG

	/* fill remaining with fake data */
	for (i = heap_len; i < NR(heap); i++) {
		heap[i].d = 0xdead;
	}

#endif

	for (i = 0; i < NR(testdata); i++) {
		elm.d = testdata[i];
		heapqueue_enqueue(&elm);
	}

	heapqueue_dump();

	/* test the cancel function and randomly delete everything */
	while (heap_len > 0) {
		unsigned valid;
		i = rand() % heap_len;

		if (heapqueue_cancel(i, &tmp)) {
			printf("canceled at %d (data=%d)\n", i, tmp.d);
		} else {
			printf("canceled at %d failed!\n", i);
			break;
		}

		// heapqueue_dump();
		valid = heapqueue_isvalid();

		// printf("heap valid? %d (%d entries)\n", valid, heap_len);
		if (!valid) {
			printf("BAD HEAP!!!\n");
			heapqueue_dump();
			break;
		}
	}

	heapqueue_dump();

	/* load the queue with test data again */
	for (i = 0; i < NR(testdata); i++) {
		elm.d = testdata[i];
		heapqueue_enqueue(&elm);
	}

	/* do a normal dequeue of everything */
	while (heapqueue_dequeue(&tmp)) {
		printf("removed head (data=%d)\n", tmp.d);
	}

	heapqueue_dump();
}
#endif

/******************************************************************************
 * Bitmap API
 ******************************************************************************/

/** size in bits of a group of bits for struct bitmap. */
#define BITMAP_BITSIZE (sizeof(unsigned)*CHAR_BIT)

/**
 * a large bitarray that can be allocated to any size.
 * @see bitmap_init bitmap_free bitmap_resize bitmap_clear bitmap_set
 *      bitmap_next_set bitmap_next_clear bitmap_loadmem bitmap_length
 *      bitmap_test
 */
struct bitmap {
	unsigned *bitmap;
	size_t bitmap_allocbits;
};

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
	LOG_DEBUG("Allocating %zd bytes\n", newbits / CHAR_BIT);
	tmp = realloc(bitmap->bitmap, newbits / CHAR_BIT);

	if (!tmp) {
		LOG_PERROR("realloc()");
		return 0; /* failure */
	}

	if (bitmap->bitmap_allocbits < newbits) {
		/* clear out the new bits */
		size_t len;
		len = (newbits - bitmap->bitmap_allocbits) / CHAR_BIT;
		LOG_DEBUG("Clearing %zd bytes (ofs %zd)\n", len, bitmap->bitmap_allocbits / BITMAP_BITSIZE);
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

#ifndef NTEST
/**
 * unit tests for struct bitmap data structure.
 */
void
bitmap_test(void)
{
	int i;
	struct bitmap bitmap;

	bitmap_init(&bitmap);
	bitmap_resize(&bitmap, 1024);

	/* fill in with a test pattern */
	for (i = 0; i < 5; i++) {
		bitmap.bitmap[i] = 0x12345678;
	}

	bitmap_set(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_clear():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_clear():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 0, BITMAP_BITSIZE * 5);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE * 5);
	bitmap_set(&bitmap, 101, 1);
	printf("word at bit 101 = 0x%08x\n", bitmap.bitmap[101 / BITMAP_BITSIZE]);
	printf("next set starting at 9 = %d\n", bitmap_next_set(&bitmap, 9));
	bitmap_clear(&bitmap, 101, 1);

	bitmap_set(&bitmap, 0, 101);
	printf("next clear starting at 9 = %d\n", bitmap_next_clear(&bitmap, 9));
	bitmap_clear(&bitmap, 0, 101);

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE * 5);
	printf("next set should return -1 = %d\n", bitmap_next_set(&bitmap, 0));

	bitmap_free(&bitmap);
}
#endif

/******************************************************************************
 * attribute list
 ******************************************************************************/

/**
 * find an attr by name.
 */
struct attr_entry *attr_find(struct attr_list *al, const char *name)
{
	struct attr_entry *curr;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		/* case sensitive. */
		if (!strcmp(curr->name, name)) {
			return curr;
		}
	}

	return NULL; /* not found. */
}

/**
 * add an entry to the end, preserves the order.
 * refuse to add a duplicate entry.
 */
int
attr_add(struct attr_list *al, const char *name, const char *value)
{
	struct attr_entry *curr, *prev, *item;

	assert(al != NULL);

	/* track prev to use later as a tail. */
	prev = NULL;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		/* case sensitive. */
		if (!strcmp(curr->name, name)) {
			LOG_ERROR("WARNING:attribute '%s' already exists.\n", curr->name);
			return 0; /**< duplicate found, refuse to add. */
		}

		prev = curr;
	}

	/* create the new entry. */
	item = calloc(1, sizeof * item);

	if (!item) {
		LOG_PERROR("calloc()");
		return 0; /**< out of memory. */
	}

	item->name = strdup(name);

	if (!item->name) {
		LOG_PERROR("strdup()");
		free(item);
		return 0; /**< out of memory. */
	}

	item->value = strdup(value);

	if (!item->value) {
		LOG_PERROR("strdup()");
		free(item->name);
		free(item);
		return 0; /**< out of memory. */
	}

	/* if head of list use LIST_INSERT_HEAD, else insert after curr. */
	if (prev) {
		assert(curr == NULL);
		LIST_INSERT_AFTER(prev, item, list);
	} else {
		LIST_INSERT_HEAD(al, item, list);
	}

	return 1; /**< success. */
}

/**
 * free every element on the list.
 */
void
attr_list_free(struct attr_list *al)
{
	struct attr_entry *curr;

	assert(al != NULL);

	while ((curr = LIST_TOP(*al))) {
		LIST_REMOVE(curr, list);
		free(curr->name);
		curr->name = NULL;
		free(curr->value);
		curr->value = NULL;
		free(curr);
	}
}

/******************************************************************************
 * Mud Config
 ******************************************************************************/

/** undocumented - please add documentation. */
static int
do_config_prompt(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	char **target;
	size_t len;

	if (!strcasecmp(id, "prompt.menu")) {
		target = &mud_config.menu_prompt;
	} else if (!strcasecmp(id, "prompt.form")) {
		target = &mud_config.form_prompt;
	} else if (!strcasecmp(id, "prompt.command")) {
		target = &mud_config.command_prompt;
	} else {
		LOG_ERROR("problem with config option '%s' = '%s'\n", id, value);
		return 1; /* failure - continue looking for matches */
	}

	free(*target);
	len = strlen(value) + 2; /* leave room for a space */
	*target = malloc(len);
	snprintf(*target, len, "%s ", value);

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int
do_config_msg(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	size_t len;
	unsigned i;
	const struct {
		const char *id;
		char **target;
	} info[] = {
		{ "msg.unsupported", &mud_config.msg_unsupported },
		{ "msg.invalidselection", &mud_config.msg_invalidselection },
		{ "msg.invalidusername", &mud_config.msg_invalidusername },
		{ "msg.tryagain", &mud_config.msg_tryagain },
		{ "msg.errormain", &mud_config.msg_errormain },
		{ "msg.usermin3", &mud_config.msg_usermin3 },
		{ "msg.invalidcommand", &mud_config.msg_invalidcommand },
		{ "msg.useralphanumeric", &mud_config.msg_useralphanumeric },
		{ "msg.userexists", &mud_config.msg_userexists },
		{ "msg.usercreatesuccess", &mud_config.msg_usercreatesuccess },
	};

	for (i = 0; i < NR(info); i++) {
		if (!strcasecmp(id, info[i].id)) {
			free(*info[i].target);
			len = strlen(value) + 2; /* leave room for a newline */
			*info[i].target = malloc(len);
			snprintf(*info[i].target, len, "%s\n", value);
			return 0; /* success - terminate the callback chain */
		}
	}

	LOG_ERROR("problem with config option '%s' = '%s'\n", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int
do_config_msgfile(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	unsigned i;
	const struct {
		const char *id;
		char **target;
	} info[] = {
		{ "msgfile.noaccount", &mud_config.msgfile_noaccount },
		{ "msgfile.badpassword", &mud_config.msgfile_badpassword },
		{ "msgfile.welcome", &mud_config.msgfile_welcome },
		{ "msgfile.newuser_create", &mud_config.msgfile_newuser_create },
		{ "msgfile.newuser_deny", &mud_config.msgfile_newuser_deny },
	};

	for (i = 0; i < NR(info); i++) {
		if (!strcasecmp(id, info[i].id)) {
			free(*info[i].target);
			*info[i].target = util_textfile_load(value);

			/* if we could not load the file, install a fake message */
			if (!*info[i].target) {
				char buf[128];
				snprintf(buf, sizeof buf, "<<fileNotFound:%s>>\n", value);
				*info[i].target = strdup(buf);
			}

			return 0; /* success - terminate the callback chain */
		}
	}

	LOG_ERROR("problem with config option '%s' = '%s'\n", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int
do_config_string(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
{
	char **target = extra;
	assert(value != NULL);
	assert(target != NULL);

	free(*target);
	*target = strdup(value);

	return 0; /* success - terminate the callback chain */
}

/**
 * @brief handles the 'server.port' property.
 */
static int
do_config_port(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	char *endptr;

	errno = 0;
	mud.params.port = strtoul(value, &endptr, 0);
	if (errno || *endptr != 0) {
		LOG_ERROR("Not a number. problem with config option '%s' = '%s'\n", id, value);
		return -1; /* error - not a number */
	}

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int
do_config_uint(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
{
	char *endptr;
	unsigned *uint_p = extra;
	assert(extra != NULL);

	if (!extra) return -1; /* error */

	if (!*value) {
		LOG_DEBUG("Empty string");
		return -1; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		LOG_DEBUG("Not a number");
		return -1; /* error - empty string */
	}

	return 0; /* success - terminate the callback chain */
}

/**
 * intialize default configuration. Config file overrides these defaults.
 */
void
mud_config_init(void)
{
	mud_config.config_filename = strdup("boris.cfg");
	mud_config.menu_prompt = strdup("Selection: ");
	mud_config.form_prompt = strdup("Selection: ");
	mud_config.command_prompt = strdup("> ");
	mud_config.msg_errormain = strdup("ERROR: going back to main menu!\n");
	mud_config.msg_invalidselection = strdup("Invalid selection!\n");
	mud_config.msg_invalidusername = strdup("Invalid username\n");
	mud_config.msgfile_noaccount = strdup("\nInvalid password or account not found!\n\n");
	mud_config.msgfile_badpassword = strdup("\nInvalid password or account not found!\n\n");
	mud_config.msg_tryagain = strdup("Try again!\n");
	mud_config.msg_unsupported = strdup("Not supported!\n");
	mud_config.msg_useralphanumeric = strdup("Username must only contain alphanumeric characters and must start with a letter!\n");
	mud_config.msg_usercreatesuccess = strdup("Account successfully created!\n");
	mud_config.msg_userexists = strdup("Username already exists!\n");
	mud_config.msg_usermin3 = strdup("Username must contain at least 3 characters!\n");
	mud_config.msg_invalidcommand = strdup("Invalid command!\n");
	mud_config.msgfile_welcome = strdup("Welcome\n\n");
	mud_config.newuser_level = 5;
	mud_config.newuser_flags = 0;
	mud_config.newuser_allowed = 0;
	mud_config.eventlog_filename = strdup("boris.log\n");
	mud_config.eventlog_timeformat = strdup("%y%m%d-%H%M"); /* another good one: %Y.%j-%H%M */
	mud_config.msgfile_newuser_create = strdup("\nPlease enter only correct information in this application.\n\n");
	mud_config.msgfile_newuser_deny = strdup("\nNot accepting new user applications!\n\n");
	mud_config.default_channels = strdup("@system,@wiz,OOC,auction,chat,newbie");
	mud_config.webserver_port = 0; /* default is to disable. */
	mud_config.form_newuser_filename = strdup("data/forms/newuser.form");
	mud_config.default_family = 0;
}

/**
 * free all configuration data.
 */
void
mud_config_shutdown(void)
{
	char **targets[] = {
		&mud_config.menu_prompt,
		&mud_config.form_prompt,
		&mud_config.command_prompt,
		&mud_config.msg_errormain,
		&mud_config.msg_invalidselection,
		&mud_config.msg_invalidusername,
		&mud_config.msgfile_noaccount,
		&mud_config.msgfile_badpassword,
		&mud_config.msg_tryagain,
		&mud_config.msg_unsupported,
		&mud_config.msg_useralphanumeric,
		&mud_config.msg_usercreatesuccess,
		&mud_config.msg_userexists,
		&mud_config.msg_usermin3,
		&mud_config.msg_invalidcommand,
		&mud_config.msgfile_welcome,
		&mud_config.eventlog_filename,
		&mud_config.eventlog_timeformat,
		&mud_config.msgfile_newuser_create,
		&mud_config.msgfile_newuser_deny,
		&mud_config.default_channels,
		&mud_config.form_newuser_filename,
	};
	unsigned i;

	for (i = 0; i < NR(targets); i++) {
		free(*targets[i]);
		*targets[i] = NULL;
	}
}

#if !defined(NDEBUG) && !defined(NTEST)
/** test routine to dump a config option. */
static int
mud_config_show(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	printf("MUD-CONFIG: %s=%s\n", id, value);

	return 1;
}
#endif

/**
 * setup config loging callback functions then reads in a configuration file.
 * @return 0 on failure, 1 on success.
 */
int
mud_config_process(void)
{
	struct config cfg;

	config_setup(&cfg);
	config_watch(&cfg, "server.port", do_config_port, 0);
	config_watch(&cfg, "prompt.*", do_config_prompt, 0);
	config_watch(&cfg, "msg.*", do_config_msg, 0);
	config_watch(&cfg, "msgfile.*", do_config_msgfile, 0);
	config_watch(&cfg, "newuser.level", do_config_uint, &mud_config.newuser_level);
	config_watch(&cfg, "newuser.allowed", do_config_uint, &mud_config.newuser_allowed);
	config_watch(&cfg, "newuser.flags", do_config_uint, &mud_config.newuser_flags);
	config_watch(&cfg, "eventlog.filename", do_config_string, &mud_config.eventlog_filename);
	config_watch(&cfg, "eventlog.timeformat", do_config_string, &mud_config.eventlog_timeformat);
	config_watch(&cfg, "channels.default", do_config_string, &mud_config.default_channels);
	config_watch(&cfg, "webserver.port", do_config_uint, &mud_config.webserver_port);
	config_watch(&cfg, "form.newuser.filename", do_config_string, &mud_config.form_newuser_filename);
#if !defined(NDEBUG) && !defined(NTEST)
	config_watch(&cfg, "*", mud_config_show, 0);
#endif

	if (!config_load(mud_config.config_filename, &cfg)) {
		config_free(&cfg);
		return 0; /* failure */
	}

	config_free(&cfg);

	return 1; /* success */
}
