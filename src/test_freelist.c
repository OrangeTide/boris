/* unit test for freelist.c */
#define LOG_SUBSYSTEM "test_freelist"

/* include the source directly for unit testing */
#include "freelist.c"

#include "ctest.h"

/* sequential first-fit allocation from a fresh pool. */
static void
test_alloc_sequential(void)
{
	struct freelist *fl = freelist_new(0, 100);

	CHECK("new pool is created", fl != NULL);
	CHECK("first alloc starts at 0", freelist_alloc(fl, 10) == 0);
	CHECK("second alloc follows first", freelist_alloc(fl, 10) == 10);
	CHECK("third alloc takes the rest", freelist_alloc(fl, 80) == 20);
	CHECK("alloc from empty pool fails", freelist_alloc(fl, 1) == -1);

	freelist_free(fl);
}

/* an empty pool refuses allocation until it is stocked. */
static void
test_pool_refill(void)
{
	struct freelist *fl = freelist_new(0, 0);

	CHECK("empty pool alloc fails", freelist_alloc(fl, 1) == -1);
	freelist_pool(fl, 5, 10);
	CHECK("alloc after pool returns pooled offset", freelist_alloc(fl, 10) == 5);
	CHECK("pool is exhausted again", freelist_alloc(fl, 1) == -1);

	freelist_free(fl);
}

/* adjacent pooled ranges coalesce into one contiguous extent. */
static void
test_coalesce(void)
{
	struct freelist *fl = freelist_new(0, 0);

	freelist_pool(fl, 0, 10);
	freelist_pool(fl, 10, 10);
	CHECK("adjacent pools coalesce into one 20-wide extent",
		freelist_alloc(fl, 20) == 0);

	freelist_free(fl);
}

/* thwack carves a hole that later allocations must skip. */
static void
test_thwack_split(void)
{
	struct freelist *fl = freelist_new(0, 100);

	CHECK("thwack of interior range succeeds", freelist_thwack(fl, 50, 10) == 1);
	CHECK("thwack of already-removed range fails", freelist_thwack(fl, 50, 10) == 0);
	CHECK("alloc uses the low half", freelist_alloc(fl, 50) == 0);
	CHECK("alloc uses the high half past the hole", freelist_alloc(fl, 40) == 60);
	CHECK("hole is not allocatable", freelist_alloc(fl, 1) == -1);

	freelist_free(fl);
}

int
main(void)
{
	test_alloc_sequential();
	test_pool_refill();
	test_coalesce();
	test_thwack_split();

	return ctest_report("test_freelist");
}
