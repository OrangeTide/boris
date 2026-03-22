/* test_hashtable.c : unit tests for hashtable.c */
#define LOG_SUBSYSTEM "test_hashtable"

/* include the source directly for unit testing */
#include "hashtable.c"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include <log.h>

static int pass_count;
static int fail_count;

static inline void
check(const char *description, bool e)
{
	if (e) {
		LOG_INFO("%s: PASSED", description);
		pass_count++;
	} else {
		LOG_ERROR("%s: FAILED", description);
		fail_count++;
	}
}

/****************************************************************
 * ht_uint tests
 ****************************************************************/

static void
test_uint_basic(void)
{
	struct ht_uint ht;

	check("uint_init", ht_uint_init(&ht, 8) == 0);
	check("uint_empty get", ht_uint_get(&ht, 42) == NULL);

	int a = 1, b = 2, c = 3;
	check("uint_set a", ht_uint_set(&ht, 10, &a) == 0);
	check("uint_set b", ht_uint_set(&ht, 20, &b) == 0);
	check("uint_set c", ht_uint_set(&ht, 30, &c) == 0);

	check("uint_get a", ht_uint_get(&ht, 10) == &a);
	check("uint_get b", ht_uint_get(&ht, 20) == &b);
	check("uint_get c", ht_uint_get(&ht, 30) == &c);
	check("uint_get miss", ht_uint_get(&ht, 99) == NULL);
	check("uint count", ht.count == 3);

	ht_uint_free(&ht);
}

static void
test_uint_overwrite(void)
{
	struct ht_uint ht;
	int a = 1, b = 2;

	ht_uint_init(&ht, 8);
	ht_uint_set(&ht, 10, &a);
	check("uint_ov before", ht_uint_get(&ht, 10) == &a);

	ht_uint_set(&ht, 10, &b);
	check("uint_ov after", ht_uint_get(&ht, 10) == &b);
	check("uint_ov count", ht.count == 1);

	ht_uint_free(&ht);
}

static void
test_uint_delete(void)
{
	struct ht_uint ht;
	int a = 1, b = 2, c = 3;

	ht_uint_init(&ht, 8);
	ht_uint_set(&ht, 10, &a);
	ht_uint_set(&ht, 20, &b);
	ht_uint_set(&ht, 30, &c);

	void *got = ht_uint_del(&ht, 20);
	check("uint_del returns value", got == &b);
	check("uint_del gone", ht_uint_get(&ht, 20) == NULL);
	check("uint_del others intact a", ht_uint_get(&ht, 10) == &a);
	check("uint_del others intact c", ht_uint_get(&ht, 30) == &c);
	check("uint_del count", ht.count == 2);

	check("uint_del miss", ht_uint_del(&ht, 99) == NULL);

	ht_uint_free(&ht);
}

static void
test_uint_grow(void)
{
	struct ht_uint ht;
	int vals[200];
	unsigned i;
	bool all_set = true, all_get = true;

	ht_uint_init(&ht, 8);

	/* insert enough entries to force multiple grows */
	for (i = 0; i < 200; i++) {
		vals[i] = i;
		if (ht_uint_set(&ht, i + 1, &vals[i]) != 0)
			all_set = false;
	}

	check("uint_grow all set", all_set);
	check("uint_grow count", ht.count == 200);
	check("uint_grow capacity grew", ht.capacity > 16);

	/* verify all entries survived */
	for (i = 0; i < 200; i++) {
		if (ht_uint_get(&ht, i + 1) != &vals[i])
			all_get = false;
	}

	check("uint_grow all get", all_get);

	ht_uint_free(&ht);
}

static void
test_uint_delete_rehash(void)
{
	struct ht_uint ht;
	int a = 1, b = 2, c = 3, d = 4;

	/* small table to make collisions likely */
	ht_uint_init(&ht, 16);
	ht_uint_set(&ht, 1, &a);
	ht_uint_set(&ht, 2, &b);
	ht_uint_set(&ht, 3, &c);
	ht_uint_set(&ht, 4, &d);

	/* delete from the middle to test cluster rehashing */
	ht_uint_del(&ht, 2);
	ht_uint_del(&ht, 3);

	check("uint_rehash: 1 intact", ht_uint_get(&ht, 1) == &a);
	check("uint_rehash: 2 gone", ht_uint_get(&ht, 2) == NULL);
	check("uint_rehash: 3 gone", ht_uint_get(&ht, 3) == NULL);
	check("uint_rehash: 4 intact", ht_uint_get(&ht, 4) == &d);
	check("uint_rehash: count", ht.count == 2);

	ht_uint_free(&ht);
}

/****************************************************************
 * ht_str tests
 ****************************************************************/

static void
test_str_basic(void)
{
	struct ht_str ht;

	check("str_init", ht_str_init(&ht, 8) == 0);
	check("str_empty get", ht_str_get(&ht, "hello") == NULL);

	int a = 1, b = 2, c = 3;
	check("str_set a", ht_str_set(&ht, "alpha", &a) == 0);
	check("str_set b", ht_str_set(&ht, "beta", &b) == 0);
	check("str_set c", ht_str_set(&ht, "gamma", &c) == 0);

	check("str_get a", ht_str_get(&ht, "alpha") == &a);
	check("str_get b", ht_str_get(&ht, "beta") == &b);
	check("str_get c", ht_str_get(&ht, "gamma") == &c);
	check("str_get miss", ht_str_get(&ht, "delta") == NULL);
	check("str count", ht.count == 3);

	ht_str_free(&ht, NULL);
}

static void
test_str_overwrite(void)
{
	struct ht_str ht;
	int a = 1, b = 2;

	ht_str_init(&ht, 8);
	ht_str_set(&ht, "key", &a);
	check("str_ov before", ht_str_get(&ht, "key") == &a);

	ht_str_set(&ht, "key", &b);
	check("str_ov after", ht_str_get(&ht, "key") == &b);
	check("str_ov count", ht.count == 1);

	ht_str_free(&ht, NULL);
}

static void
test_str_delete(void)
{
	struct ht_str ht;
	int a = 1, b = 2, c = 3;

	ht_str_init(&ht, 8);
	ht_str_set(&ht, "alpha", &a);
	ht_str_set(&ht, "beta", &b);
	ht_str_set(&ht, "gamma", &c);

	void *got = ht_str_del(&ht, "beta");
	check("str_del returns value", got == &b);
	check("str_del gone", ht_str_get(&ht, "beta") == NULL);
	check("str_del others intact a", ht_str_get(&ht, "alpha") == &a);
	check("str_del others intact c", ht_str_get(&ht, "gamma") == &c);
	check("str_del count", ht.count == 2);

	check("str_del miss", ht_str_del(&ht, "nope") == NULL);

	ht_str_free(&ht, NULL);
}

static void
test_str_grow(void)
{
	struct ht_str ht;
	int vals[200];
	char key[16];
	unsigned i;
	bool all_set = true, all_get = true;

	ht_str_init(&ht, 8);

	for (i = 0; i < 200; i++) {
		vals[i] = i;
		snprintf(key, sizeof key, "key_%u", i);
		if (ht_str_set(&ht, key, &vals[i]) != 0)
			all_set = false;
	}

	check("str_grow all set", all_set);
	check("str_grow count", ht.count == 200);
	check("str_grow capacity grew", ht.capacity > 16);

	for (i = 0; i < 200; i++) {
		snprintf(key, sizeof key, "key_%u", i);
		if (ht_str_get(&ht, key) != &vals[i])
			all_get = false;
	}

	check("str_grow all get", all_get);

	ht_str_free(&ht, NULL);
}

static void
test_str_free_values(void)
{
	struct ht_str ht;

	ht_str_init(&ht, 8);

	/* values are malloc'd strings -- ht_str_free should free them */
	ht_str_set(&ht, "one", strdup("hello"));
	ht_str_set(&ht, "two", strdup("world"));
	check("str_free_values count", ht.count == 2);

	/* this should not leak (verified by valgrind) */
	ht_str_free(&ht, free);
	check("str_free_values done", ht.buckets == NULL);
}

static void
test_str_delete_rehash(void)
{
	struct ht_str ht;
	int a = 1, b = 2, c = 3, d = 4;

	ht_str_init(&ht, 16);
	ht_str_set(&ht, "aa", &a);
	ht_str_set(&ht, "bb", &b);
	ht_str_set(&ht, "cc", &c);
	ht_str_set(&ht, "dd", &d);

	ht_str_del(&ht, "bb");
	ht_str_del(&ht, "cc");

	check("str_rehash: aa intact", ht_str_get(&ht, "aa") == &a);
	check("str_rehash: bb gone", ht_str_get(&ht, "bb") == NULL);
	check("str_rehash: cc gone", ht_str_get(&ht, "cc") == NULL);
	check("str_rehash: dd intact", ht_str_get(&ht, "dd") == &d);
	check("str_rehash: count", ht.count == 2);

	ht_str_free(&ht, NULL);
}

/****************************************************************
 * main
 ****************************************************************/

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : hashtable.c");

	test_uint_basic();
	test_uint_overwrite();
	test_uint_delete();
	test_uint_grow();
	test_uint_delete_rehash();

	test_str_basic();
	test_str_overwrite();
	test_str_delete();
	test_str_grow();
	test_str_free_values();
	test_str_delete_rehash();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
