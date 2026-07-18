#ifndef HEAPQUEUE_H_
#define HEAPQUEUE_H_
/*
 * heapqueue - a binary min-heap used as a priority queue.
 *
 * Extracted from common.c.  The heap is a module-global singleton.
 */

/** element in the heapqueue. */
struct heapqueue_elm {
	unsigned d; /* key */
	/** @todo put useful data in here */
};

int heapqueue_cancel(unsigned i, struct heapqueue_elm *ret);
void heapqueue_enqueue(struct heapqueue_elm *elm);
int heapqueue_dequeue(struct heapqueue_elm *ret);

#endif
