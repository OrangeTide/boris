/* unit test for heapqueue.c (binary min-heap priority queue) */
#define LOG_SUBSYSTEM "test_heapqueue"

/* include the source directly to reach the module-static heap[]/heap_len. */
#include "heapqueue.c"

#include "ctest.h"

/* verify the min-heap property holds across the whole heap. */
static int
heap_is_valid(void)
{
	unsigned i;

	for (i = 1; i < heap_len; i++) {
		if (heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], &heap[i]))
			return 0;
	}
	return 1;
}

/* enqueueing keeps the heap valid and dequeue returns keys in sorted order. */
static void
test_enqueue_dequeue_order(void)
{
	static const unsigned keys[] = { 50, 10, 40, 10, 30, 90, 20, 60, 5, 70 };
	struct heapqueue_elm elm, out;
	unsigned i;
	int ordered = 1;
	unsigned prev = 0;

	heap_len = 0;
	for (i = 0; i < sizeof keys / sizeof keys[0]; i++) {
		elm.d = keys[i];
		heapqueue_enqueue(&elm);
		if (!heap_is_valid())
			ordered = 0;
	}
	CHECK("heap stays valid through all enqueues", ordered);
	CHECK("heap length matches enqueue count",
		heap_len == sizeof keys / sizeof keys[0]);

	ordered = 1;
	for (i = 0; i < sizeof keys / sizeof keys[0]; i++) {
		CHECK("dequeue succeeds while non-empty", heapqueue_dequeue(&out) == 1);
		if (i > 0 && out.d < prev)
			ordered = 0;
		prev = out.d;
	}
	CHECK("dequeued keys come out in non-decreasing order", ordered);
	CHECK("smallest key came out first", prev == 90); /* last out is the max */
	CHECK("heap is empty after draining", heap_len == 0);
	CHECK("dequeue from empty heap fails", heapqueue_dequeue(&out) == 0);
}

/* cancelling arbitrary entries preserves the heap property. */
static void
test_cancel(void)
{
	struct heapqueue_elm elm, out;
	unsigned i;
	int valid = 1;

	heap_len = 0;
	for (i = 0; i < 16; i++) {
		elm.d = (i * 7 + 3) % 23; /* scattered keys */
		heapqueue_enqueue(&elm);
	}

	/* repeatedly cancel the root; heap must stay valid and shrink. */
	while (heap_len > 0) {
		unsigned before = heap_len;

		if (!heapqueue_cancel(0, &out)) {
			valid = 0;
			break;
		}
		if (heap_len != before - 1 || !heap_is_valid()) {
			valid = 0;
			break;
		}
	}
	CHECK("cancel drains the heap while keeping it valid", valid);
}

int
main(void)
{
	test_enqueue_dequeue_order();
	test_cancel();

	return ctest_report("test_heapqueue");
}
