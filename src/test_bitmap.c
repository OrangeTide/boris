/* unit test for bitmap.c (large resizable bit array) */
#define LOG_SUBSYSTEM "test_bitmap"

/* include the source directly for unit testing */
#include "bitmap.c"

#include "ctest.h"

int
main(void)
{
	struct bitmap bm;

	bitmap_init(&bm);
	CHECK("resize succeeds", bitmap_resize(&bm, 1024) == 1);
	CHECK("length reflects allocated bytes", bitmap_length(&bm) == 1024 / CHAR_BIT);
	CHECK("fresh bitmap has no set bits", bitmap_next_set(&bm, 0) == -1);

	/* set and read back a single bit. */
	bitmap_set(&bm, 101, 1);
	CHECK("set bit reads back as 1", bitmap_get(&bm, 101) == 1);
	CHECK("neighbouring bit stays 0", bitmap_get(&bm, 100) == 0);
	CHECK("neighbouring bit stays 0 (high side)", bitmap_get(&bm, 102) == 0);
	CHECK("next_set finds the lone set bit", bitmap_next_set(&bm, 0) == 101);

	bitmap_clear(&bm, 101, 1);
	CHECK("cleared bit reads back as 0", bitmap_get(&bm, 101) == 0);
	CHECK("next_set is empty again", bitmap_next_set(&bm, 0) == -1);

	/* set a contiguous run spanning two whole words. */
	bitmap_set(&bm, 0, 64);
	CHECK("first bit of run is set", bitmap_get(&bm, 0) == 1);
	CHECK("last bit of run is set", bitmap_get(&bm, 63) == 1);
	CHECK("bit just past the run is clear", bitmap_get(&bm, 64) == 0);
	CHECK("next_clear finds the first bit past a full run",
		bitmap_next_clear(&bm, 0) == 64);

	bitmap_clear(&bm, 0, 64);
	CHECK("bitmap is fully clear after clearing the run",
		bitmap_next_set(&bm, 0) == -1);

	bitmap_free(&bm);
	return ctest_report("test_bitmap");
}
