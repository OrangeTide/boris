/**
 * @file freelist.c
 *
 * Allocate ranges of numbers from a pool.
 * uses freelist_entry and freelist_extent.
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
#include "freelist.h"
#include "list.h"
#define LOG_SUBSYSTEM "freelist"
#include "log.h"
#include "debug.h"
#include <stdlib.h>

struct freelist_entry;
/**
 * head for a list of number ranges.
 */
LIST_HEAD(struct freelist_listhead, struct freelist_entry);

/**
 * a pool of number ranges.
 * originally there were many lists, bucketed by length, but it grew cumbersome.
 */
struct freelist {
	/* single list ordered by offset to find adjacent chunks. */
	struct freelist_listhead global;
};

/** range of numbers used to represent part of the freelist. */
struct freelist_extent {
	unsigned length, offset; /* both are in block-sized units */
};

/** linked list entry in the freelist (holds an extent). */
struct freelist_entry {
	LIST_ENTRY(struct freelist_entry) global; /* global list */
	struct freelist_extent extent;
};

#if !defined(NTEST) || !defined(NDEBUG)
/** print a freelist to stderr. */
static void
freelist_dump(struct freelist *fl)
{
	struct freelist_entry *curr;
	unsigned n;
	fprintf(stderr, "::: Dumping freelist :::\n");

	for (curr = LIST_TOP(fl->global), n = 0; curr; curr = LIST_NEXT(curr, global), n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}
}
#endif

/**
 * lowlevel - detach and free an entry.
 */
static void
freelist_ll_free(struct freelist_entry *e)
{
	assert(e != NULL);
	assert(e->global._prev != NULL);
	assert(e->global._prev != (void*)0x99999999);
	LIST_REMOVE(e, global);
#ifndef NDEBUG
	memset(e, 0x99, sizeof * e); /* fill with fake data before freeing */
#endif
	free(e);
}

/**
 * lowlevel - append an extra to the global list at prev
 */
static struct freelist_entry *
freelist_ll_new(struct freelist_entry **prev, unsigned ofs, unsigned count)
{
	struct freelist_entry *new;
	assert(prev != NULL);
	assert(prev != (void*)0x99999999);
	new = malloc(sizeof * new);
	assert(new != NULL);

	if (!new) {
		LOG_PERROR("malloc()");
		return 0;
	}

	new->extent.offset = ofs;
	new->extent.length = count;
	LIST_INSERT_ATPTR(prev, new, global);
	return new;
}

/**
 * checks two extents and determine if they are immediately adjacent.
 * @returns true if a bridge is detected.
 */
static int
freelist_ll_isbridge(struct freelist_extent *prev_ext, unsigned ofs, unsigned count, struct freelist_extent *next_ext)
{
	/*
	LOG_DEBUG("testing for bridge:\n"
			"  last:%6d+%d curr:%6d+%d ofs:%6d+%d",
			prev_ext->offset, prev_ext->length, next_ext->offset, next_ext->length,
			ofs, count
	);
	*/
	return prev_ext->offset + prev_ext->length == ofs && next_ext->offset == ofs + count;
}

/** allocate a new freelist. starts off as empty. */
struct freelist *
freelist_new(unsigned start, unsigned count)
{
	struct freelist *fl = malloc(sizeof(*fl));

	if (!fl) {
		return NULL;
	}

	*fl = (struct freelist){};
	LIST_INIT(&fl->global);
	if (count) {
		freelist_pool(fl, start, count);
	}

	return fl;
}

/** deallocate all entries on the freelist and free it. */
void
freelist_free(struct freelist *fl)
{
	while (LIST_TOP(fl->global)) {
		freelist_ll_free(LIST_TOP(fl->global));
	}

	assert(LIST_TOP(fl->global) == NULL);
	free(fl);
}

/** allocate memory from the pool.
 * @return offset of the allocation. return -1 on failure.
 */
long
freelist_alloc(struct freelist *fl, unsigned count)
{
	struct freelist_entry *curr;

	/* find the first entry that is big enough */
	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		if (curr->extent.length >= count) {
			unsigned ofs;
			ofs = curr->extent.offset;
			curr->extent.offset += count;
			curr->extent.length -= count;

			if (curr->extent.length == 0) {
				freelist_ll_free(curr);
			}

			return ofs; /* success */
		}
	}

	return -1; /* failure */
}

/** adds a piece to the freelist pool.
 *
 * . allocated
 * _ empty
 * X new entry
 *
 * |.....|_XXX_|......|		normal
 * |.....|_XXX|.......|		grow-next
 * |......|XXX_|......|		grow-prev
 * |......|XXX|.......|		bridge
 *
 * WARNING: passing bad parameters will result in strange data in the list
 */
void
freelist_pool(struct freelist *fl, unsigned ofs, unsigned count)
{
	struct freelist_entry *new, *curr, *last;

	TRACE_ENTER();

	assert(count != 0);

	last = NULL;
	new = NULL;

	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		assert(curr != last);
		assert(curr != (void*)0x99999999);

		if (last) {
			assert(LIST_NEXT(last, global) == curr); /* sanity check */
		}

		/*
		printf(
			"c.ofs:%6d c.len:%6d l.ofs:%6d l.len:%6d ofs:%6d len:%6d\n",
			curr->extent.offset, curr->extent.length,
			last ? last->extent.offset : -1, last ? last->extent.length : -1,
			ofs, count
		);
		*/

		if (ofs == curr->extent.offset) {
			LOG_ERROR("overlap detected in freelist %p at %u+%u!", (void*)fl, ofs, count);
			LOG_TODO("make something out of this");
			DIE();
		} else if (last && freelist_ll_isbridge(&last->extent, ofs, count, &curr->extent)) {
			/* |......|XXX|.......|		bridge */
			LOG_DEBUG("|......|XXX|.......|		bridge. last=%u+%u curr=%u+%u new=%u+%u", last->extent.length, last->extent.offset, curr->extent.offset, curr->extent.length, ofs, count);
			/* we are dealing with 3 entries, the last, the new and the current */
			/* merge the 3 entries into the last entry */
			last->extent.length += curr->extent.length + count;
			assert(LIST_PREVPTR(curr, global) == &LIST_NEXT(last, global));
			freelist_ll_free(curr);
			assert(LIST_TOP(fl->global) != curr);
			assert(LIST_NEXT(last, global) != (void*)0x99999999);
			assert(LIST_NEXT(last, global) != curr); /* deleting it must take it off the list */
			new = curr = last;
			break;
		} else if (curr->extent.offset == ofs + count) {
			/* |.....|_XXX|.......|		grow-next */
			LOG_DEBUG("|.....|_XXX|.......|		grow-next. curr=%u+%u new=%u+%u", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge new entry into a following entry */
			curr->extent.offset = ofs;
			curr->extent.length += count;
			new = curr;
			break;
		} else if (last && curr->extent.offset + curr->extent.length == ofs) {
			/* |......|XXX_|......|		grow-prev */
			LOG_DEBUG("|......|XXX_|......|		grow-prev. curr=%u+%u new=%u+%u\n", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge the new entry into the end of the previous entry */
			curr->extent.length += count;
			new = curr;
			break;
		} else if (ofs < curr->extent.offset) {
			if (ofs + count > curr->extent.offset) {
				LOG_ERROR("overlap detected in freelist %p at %u+%u!", (void*)fl, ofs, count);
				LOG_TODO("make something out of this");
				DIE();
			}

			LOG_DEBUG("|.....|_XXX_|......|		normal new=%u+%u", ofs, count);
			/* create a new entry */
			new = freelist_ll_new(LIST_PREVPTR(curr, global), ofs, count);
			break;
		}

		last = curr; /* save this for finding a bridge */
	}

	if (!curr) {
		if (last) {
			if (last->extent.offset + last->extent.length == ofs) {
				LOG_DEBUG("|......|XXX_|......|		grow-prev. last=%u+%u new=%u+%u", last->extent.offset, last->extent.length, ofs, count);
				last->extent.length += count;
				new = last;
			} else {
				LOG_DEBUG("|............|XXX  |		end. new=%u+%u", ofs, count);
				new = freelist_ll_new(&LIST_NEXT(last, global), ofs, count);
			}
		} else {
			LOG_DEBUG("|XXX               |		initial. new=%u+%u", ofs, count);
			new = freelist_ll_new(&LIST_TOP(fl->global), ofs, count);
		}
	}
}

/**
 * allocates a particular range on a freelist.
 * (assumes that freelist_pool assembles adjacent regions into the largest
 * possible contigious spaces)
 */
int
freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count)
{
	struct freelist_entry *curr;

	assert(count != 0);

	LOG_DEBUG("thwacking %u:%u", ofs, count);

#ifndef NDEBUG
	freelist_dump(fl);
#endif

	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		LOG_DEBUG("checking for %u:%u in curr=%u:%u\n", ofs, count, curr->extent.offset, curr->extent.length);

		if (curr->extent.offset <= ofs && curr->extent.offset + curr->extent.length >= ofs + count) {
			LOG_TRACE("Found entry to thwack at %u:%u for %u:%u", curr->extent.offset, curr->extent.length, ofs, count);

			/* four possible cases:
			 * 1. heads and lengths are the same - free extent
			 * 2. heads are the same, but lengths differ - chop head and shrink
			 * 3. tails are the same - shrink
			 * 4. extent gets split into two extents
			 */
			if (curr->extent.offset == ofs && curr->extent.length == count) {
				/* 1. heads and lengths are the same - free extent */
				freelist_ll_free(curr);
				return 1; /* success */
			} else if (curr->extent.offset == ofs) {
				/* 2. heads are the same, but lengths differ - slice off head */
				curr->extent.offset += count;
				curr->extent.length -= count;
				return 1; /* success */
			} else if ((curr->extent.offset + curr->extent.length) == (ofs + count)) {
				/* 3. tails are the same - shrink */
				curr->extent.length -= count;
				return 1; /* success */
			} else { /* 4. extent gets split into two extents */
				struct freelist_extent new; /* second part */

				/* make curr the first part, and create a new one after
				 * ofs:count for the second */

				new.offset = ofs + count;
				new.length = (curr->extent.offset + curr->extent.length) - new.offset;
				LOG_DEBUG("ofs=%d curr.offset=%d", ofs, curr->extent.offset);
				assert(curr->extent.length >= count + new.length);
				curr->extent.length -= count;
				curr->extent.length -= new.length;
				freelist_pool(fl, new.offset, new.length);
				return 1; /* success */
			}

			LOG_DEBUG("Should not be possible to get here");
			DIE();
		}
	}

	LOG_DEBUG("failed.");
	return 0; /* failure */
}

#ifndef NTEST
/** test the freelist. */
void
freelist_test(void)
{
	struct freelist *fl;
	unsigned n;
	fl = freelist_new(fl, 0, 0);
	fprintf(stderr, "::: Making some fragments :::\n");

	for (n = 0; n < 60; n += 12) {
		freelist_pool(fl, n, 6);
	}

	fprintf(stderr, "::: Filling in gaps :::\n");

	for (n = 0; n < 60; n += 12) {
		freelist_pool(fl, n + 6, 6);
	}

	fprintf(stderr, "::: Walking backwards :::\n");

	for (n = 120; n > 60;) {
		n -= 6;
		freelist_pool(fl, n, 6);
	}

	freelist_dump(fl);

	/* test freelist_alloc() */
	fprintf(stderr, "::: Allocating :::\n");

	for (n = 0; n < 60; n += 6) {
		long ofs;
		ofs = freelist_alloc(fl, 6);
		TRACE("alloc: %lu+%u\n", ofs, 6);
	}

	freelist_dump(fl);

	fprintf(stderr, "::: Allocating :::\n");

	for (n = 0; n < 60; n += 6) {
		long ofs;
		ofs = freelist_alloc(fl, 6);
		TRACE("alloc: %lu+%u\n", ofs, 6);
	}

	freelist_dump(fl);
	fprintf(stderr, "<freelist should be empty>\n");

	freelist_pool(fl, 1003, 1015);

	freelist_dump(fl);

	freelist_thwack(fl, 1007, 1005);

	freelist_thwack(fl, 2012, 6);

	freelist_thwack(fl, 1003, 4);

	freelist_dump(fl);
	fprintf(stderr, "<freelist should be empty>\n");

	freelist_free(fl);
}
#endif
