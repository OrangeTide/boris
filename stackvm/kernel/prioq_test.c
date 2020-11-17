
#include <stdio.h>
#define TRACEF(fmt, ...) fprintf(stderr, ">>> %s():" fmt "\n", __func__, ## __VA_ARGS__)

#include "prioq.c"

struct prioq *testpq;

static void
prioq_dump(struct prioq *h)
{
	unsigned i;
	fprintf(stderr, "::: Dumping heapqueue :::\n");
	for (i=0; i < h->heap_len; i++) {
		printf("%03u = %4u (p:%d l:%d r:%d)\n", i, h->heap[i].d, i>0 ? (int)HEAPQUEUE_PARENT(i) : -1, HEAPQUEUE_LEFT(i), HEAPQUEUE_RIGHT(i));
	}
	printf("heap valid? %d (%d entries)\n",
		prioq_test_if_valid(testpq) ? "No" : "Yes",
		h->heap_len);
}

void
heapqueue_test(void)
{
	struct prioq_elm elm, tmp;
	unsigned i;
	const unsigned testdata[] = {
		42, 2, 123, 88, 3, 3, 3, 3, 3, 1, 0,
	};

	testpq = prioq_new(100);

	/* fill remaining with fake data */
	for(i = testpq->heap_len; i < testpq->heap_max; i++)
	{
		testpq->heap[i].d=0xcafe;
		testpq->heap[i].p=(void*)0xdeadbeef;
	}

	for(i=0; i < sizeof(testdata) / sizeof(*testdata); i++)
	{
		prioq_enqueue(testpq, testdata[i], NULL);
	}

	prioq_dump(testpq);

	/* test the cancel function and randomly delete everything */
	while(heap_len>0)
	{
		unsigned valid;
		i=rand()%heap_len;
		if(heapqueue_cancel(i, &tmp))
		{
			printf("canceled at %d (data=%d)\n", i, tmp.d);
		}
		else
		{
			printf("canceled at %d failed!\n", i);
			break;
		}
		// heapqueue_dump();
		valid=prioq_test_if_valid();
		// printf("heap valid? %d (%d entries)\n", valid, heap_len);
		if(!valid)
		{
			printf("BAD HEAP!!!\n");
			heapqueue_dump();
			break;
		}
	}

	heapqueue_dump();

	/* load the queue with test data again */
	for(i=0; i<NR(testdata); i++)
	{
		elm.d=testdata[i];
		heapqueue_enqueue(&elm);
	}

	/* do a normal dequeue of everything */
	while(heapqueue_dequeue(&tmp))
	{
		printf("removed head (data=%d)\n", tmp.d);
	}

	heapqueue_dump();
}
#endif

int main()
{
	heapqueue_test();
	return 0;
}
