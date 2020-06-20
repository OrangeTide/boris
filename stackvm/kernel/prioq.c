/* prioq.c - priority queue, implement as a heap holding a complete binary tree
 * This software is PUBLIC DOMAIN as of September 2008. No copyright is claimed.
 * Jon Mayo <jon.mayo@gmail.com>
 * Initial: September 1, 2008
 * Updated: June 19, 2020
 */
/* TODO:
 * + support growth of queue through realloc()
 * + return error codes and error strings, remove stdio.h
 */
#include "prioq.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define errorf(fmt, ...) fprintf(stderr, "ERROR:" fmt "\n", ## __VA_ARGS__)

#ifndef TRACEF
#define TRACEF(fmt, ...) /* ignored */
#endif

#define LEFT(i) (2*(i)+1)
#define RIGHT(i) (2*(i)+2)
#define PARENT(i) (((i)-1)/2)

/* min heap is sorted by lowest value at root
 * return non-zero if a>b (greater-than)
 */
static inline int
compare(const struct prioq_elm *a, const struct prioq_elm *b)
{
	assert(a != NULL);
	assert(b != NULL);
	return a->d > b->d;
}

/* i is the "hole" location
 * elm is the value to compare against
 * return new position of hole */
static int
siftdown(struct prioq *h, unsigned i, const struct prioq_elm *elm)
{
	assert(elm != NULL);
	assert(i < h->heap_len || i == 0);
	while (LEFT(i) < h->heap_len) { /* keep going until at a leaf node */
		unsigned child = LEFT(i);

		/* compare left and right(child+1) - use the smaller of the two */
		if (child + 1 < h->heap_len && compare(&h->heap[child], &h->heap[child+1])) {
			child++; /* left is bigger than right, use right */
		}

		/* child is the smallest child, if elm is smaller or equal then we're done */
		if (!compare(elm, &h->heap[child])) /* elm <= child */
			break;

		/* swap "hole" and selected child */
		TRACEF("%s():swap hole %d with entry %d", __func__, i, child);
		h->heap[i] = h->heap[child];
		i = child;
	}
	TRACEF("%s():chosen position %d for hole.", __func__, i);

	return i;
}

/* i is the "hole" location
 * elm is the value to compare against
 * return the new position of the hole
 * return -1 on error (EINVAL)
 */
static int
siftup(struct prioq *h, unsigned hole, const struct prioq_elm *elm)
{
	assert(h != NULL);
	assert(elm != NULL);
	assert(hole < h->heap_len);

	if (!h || !elm || hole >= h->heap_len)
		return -1;

	int i = hole;
	while (i > 0) {
		/* Compare the element with parent */
		if (!compare(&h->heap[PARENT(i)], elm)) {
			return i;
		}
		/* swap element with parent and keep going (keep tracking the "hole") */
		h->heap[i] = h->heap[PARENT(i)];
		i = PARENT(i);
	}

	return i;
}

////////////////////////////////////////////////////////////////////////

struct prioq *
prioq_new(unsigned max_size)
{
	struct prioq *h = calloc(1, sizeof(*h));
	if (!h)
		return NULL; /* failed to allocate prioq */

	h->heap_len = 0;
	h->heap_max = max_size;

	h->heap = calloc(h->heap_max, sizeof(*h->heap));
	if (!h->heap) {
		free(h);
		return NULL; /* failed to allocate max_size */
	}

	return h;
}

void
prioq_free(struct prioq *h)
{
	if (!h)
		return;
	free(h->heap);
	h->heap = NULL;
	h->heap_max = 0;
	h->heap_len = 0;
	free(h);
}

/* sift-up operation for enqueueing
 * 1. Add the element on the bottom level of the heap.
 * 2. Compare the added element with its parent; if they are in the correct order, stop.
 * 3. If not, swap the element with its parent and return to the previous step.
 */
int
prioq_enqueue(struct prioq *h, const struct prioq_elm *elm)
{
	unsigned i;

	if (h->heap_len >= h->heap_max)
		return -1; /* error: heap is full (TODO: realloc) */

	i = h->heap_len++; /* add the element to the bottom of the heap (create a "hole") */
	i = siftup(h, i, elm);
	h->heap[i] = *elm; /* fill in the "hole" */

	return 0;
}

/* sift-down operation for dequeueing
 * removes the root entry and copies it to ret
 */
int
prioq_dequeue(struct prioq *h, struct prioq_elm *out)
{
	assert(out != NULL);

	if (h->heap_len <= 0)
		return 0; /* nothing to dequeue */

	*out = h->heap[0]; /* we have to copy the root element somewhere because we're removing it */

	/* move last entry to the root, then sift-down */
	h->heap_len--;
	int i = siftdown(h, 0, &h->heap[h->heap_len]);
	h->heap[i] = h->heap[h->heap_len];

	return 1;
}

/* removes entry at i */
int
prioq_cancel(struct prioq *h, unsigned i, struct prioq_elm *out)
{
	/* 1. copy the value at i into out
	 * 2. put last node into empty position
	 * 3. sift-up if moved node smaller than parent, sift-down if larger than either child
	 */
	assert(out != NULL);
	assert(i < h->heap_len);
	assert(h->heap_len < h->heap_max);

	*out = h->heap[i]; /* copy the value at i into ret */
	TRACEF("canceling entry #%d: val=%d (parent=%d:>%u) (left %d:>%u) (right %d:>%u) (last %d)",
		  i, ret->d,
		  i>0 ? (int)PARENT(i) : -1,
		  i>0 ? heap[PARENT(i)].d : 0,
		  LEFT(i)<heap_len ? (int)LEFT(i) : -1,
		  LEFT(i)<heap_len ? heap[LEFT(i)].d : 0,
		  RIGHT(i)<heap_len ? (int)RIGHT(i) : -1,
		  RIGHT(i)<heap_len ? heap[RIGHT(i)].d : 0,
		  heap[heap_len-1].d
		 );

	/* move last entry to the empty position */
	h->heap_len--;
	struct prioq_elm *last = &h->heap[h->heap_len];

	/* i now holds the position of the last entry, we will move this "hole" until
	 * it is in the correct place for last */

	if (i > 0 && compare(&h->heap[PARENT(i)], last)) {
		/* we already did the compare, so we'll perform the first move here */
		TRACEF("%s():swap hole %d with entry %d", __func__, i, PARENT(i));
		h->heap[i] = h->heap[PARENT(i)]; /* move parent down */
		i = siftup(h, PARENT(i), last); /* sift the "hole" up */
	} else if ((RIGHT(i) < h->heap_len) && (compare(last, &h->heap[RIGHT(i)]) || compare(last, &h->heap[LEFT(i)]))) {
		/* if right is on the list, then left is as well */
		if (compare(&h->heap[LEFT(i)], &h->heap[RIGHT(i)])) {
			/* left is larger - use the right hole */
			TRACEF("%s():swap hole %d with entry %d", __func__, i, RIGHT(i));
			h->heap[i] = h->heap[RIGHT(i)]; /* move right up */
			i = siftdown(h, RIGHT(i), last); /* sift the "hole" down */
		} else {
			/* right is the larger or equal - use the left hole */
			TRACEF("%s():swap hole %d with entry %d", __func__, i, LEFT(i));
			h->heap[i] = h->heap[LEFT(i)]; /* move left up */
			i = siftdown(h, LEFT(i), last); /* sift the "hole" down */
		}
	} else if (LEFT(i) < h->heap_len && compare(last, &h->heap[LEFT(i)])) {
		/* at this point there is no right node */
		TRACEF("%s():swap hole %d with entry %d", __func__, i, LEFT(i));
		h->heap[i] = h->heap[LEFT(i)]; /* move left up */
		i = siftdown(h, LEFT(i), last); /* sift the "hole" down */
	}

	h->heap[i] = *last;

	return 1;
}

int
prioq_find(struct prioq *h, const void *p)
{
	unsigned i;
	for (i = 1; i < h->heap_len; i++) {
		if (h->heap[i].p == p)
			return i;

	}

	return -1; // not found
}

/* checks the heap to see that it is valid. */
int
prioq_test_if_valid(struct prioq *h)
{
	unsigned i;
	for (i = 1; i < h->heap_len; i++) {
		if (compare(&h->heap[PARENT(i)], &h->heap[i])) {
			// TODO: remove stdio.h usage, set some error code instead
			errorf("%p:Bad heap at %d", (void*)h, i);
			return -1; /* not a valid heap */
		}
	}
	return 0; /* success */
}
