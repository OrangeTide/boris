/*
 * heapqueue.c - binary min-heap priority queue.
 *
 * Extracted from common.c for independent unit testing.
 */
#include "heapqueue.h"
#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "heapqueue"
#endif
#include "log.h"
#include "debug.h"
#include <assert.h>

#ifndef NR
#define NR(x) (sizeof(x)/sizeof*(x))
#endif

/** the left child of i. */
#define HEAPQUEUE_LEFT(i) (2*(i)+1)

/** the right child of i. */
#define HEAPQUEUE_RIGHT(i) (2*(i)+2)

/** the parent of i. i should be signed else the parent of the root will be a
 * little weird.*/
#define HEAPQUEUE_PARENT(i) (((i)-1)/2)

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

