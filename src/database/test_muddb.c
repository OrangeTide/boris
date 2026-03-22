/* unit test for muddb.c */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_muddb"

#include "muddb.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>

static int pass_count;
static int fail_count;

static char tmpdir[] = "/tmp/test_muddb_XXXXXX";

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

/* recursive remove for temp directory cleanup */
static int
rm_cb(const char *fpath, const struct stat *sb, int typeflag,
	struct FTW *ftwbuf)
{
	(void)sb;
	(void)typeflag;
	(void)ftwbuf;
	return remove(fpath);
}

static void
cleanup_tmpdir(void)
{
	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
}

static void
test_open_close(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open database", db != NULL);

	if (db)
		muddb_close(db);
}

static void
test_put_get(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for put_get", db != NULL);
	if (!db) return;

	OBJ *obj = obj_new_from_json("room1",
		"{\"name\":\"Town Square\",\"desc\":\"A bustling square\"}");
	check("create obj", obj != NULL);

	int rc = muddb_put(db, "rooms", "room1", obj);
	check("put obj", rc == MUDDB_OK);
	obj_free(obj);

	OBJ *got = muddb_get(db, "rooms", "room1");
	check("get obj", got != NULL);

	if (got) {
		char *name = obj_prop_get(got, "name");
		check("get name prop", name != NULL &&
			strcmp(name, "Town Square") == 0);

		char *desc = obj_prop_get(got, "desc");
		check("get desc prop", desc != NULL &&
			strcmp(desc, "A bustling square") == 0);

		obj_free(got);
	}

	muddb_close(db);
}

static void
test_overwrite(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for overwrite", db != NULL);
	if (!db) return;

	OBJ *obj1 = obj_new_from_json("room1",
		"{\"name\":\"Old Name\"}");
	muddb_put(db, "rooms", "room1", obj1);
	obj_free(obj1);

	OBJ *obj2 = obj_new_from_json("room1",
		"{\"name\":\"New Name\"}");
	int rc = muddb_put(db, "rooms", "room1", obj2);
	check("overwrite put", rc == MUDDB_OK);
	obj_free(obj2);

	OBJ *got = muddb_get(db, "rooms", "room1");
	check("overwrite get", got != NULL);
	if (got) {
		char *name = obj_prop_get(got, "name");
		check("overwrite value",
			name != NULL && strcmp(name, "New Name") == 0);
		obj_free(got);
	}

	muddb_close(db);
}

static void
test_delete(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for delete", db != NULL);
	if (!db) return;

	OBJ *obj = obj_new_from_json("del1", "{\"x\":\"1\"}");
	muddb_put(db, "rooms", "del1", obj);
	obj_free(obj);

	int rc = muddb_del(db, "rooms", "del1");
	check("delete ok", rc == MUDDB_OK);

	OBJ *got = muddb_get(db, "rooms", "del1");
	check("deleted key returns null", got == NULL);

	muddb_close(db);
}

static void
test_missing_key(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for missing", db != NULL);
	if (!db) return;

	OBJ *got = muddb_get(db, "rooms", "nonexistent");
	check("missing key returns null", got == NULL);

	muddb_close(db);
}

static void
test_iteration(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for iteration", db != NULL);
	if (!db) return;

	/* clear and insert fresh data in a separate domain */
	OBJ *a = obj_new_from_json("a", "{\"v\":\"1\"}");
	OBJ *b = obj_new_from_json("b", "{\"v\":\"2\"}");
	OBJ *c = obj_new_from_json("c", "{\"v\":\"3\"}");
	muddb_put(db, "iter_test", "alpha", a);
	muddb_put(db, "iter_test", "beta", b);
	muddb_put(db, "iter_test", "gamma", c);
	obj_free(a);
	obj_free(b);
	obj_free(c);

	/* iterate and collect keys */
	MUDDB_ITER *it = muddb_iter_begin(db, "iter_test");
	check("iter begin", it != NULL);

	int count = 0;
	int found_alpha = 0, found_beta = 0, found_gamma = 0;
	const char *key;

	while ((key = muddb_iter_next(it)) != NULL) {
		if (strcmp(key, "alpha") == 0) found_alpha = 1;
		else if (strcmp(key, "beta") == 0) found_beta = 1;
		else if (strcmp(key, "gamma") == 0) found_gamma = 1;
		count++;
	}
	muddb_iter_end(it);

	check("iter count", count == 3);
	check("iter found alpha", found_alpha);
	check("iter found beta", found_beta);
	check("iter found gamma", found_gamma);

	muddb_close(db);
}

static void
test_multiple_domains(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("open for domains", db != NULL);
	if (!db) return;

	OBJ *user = obj_new_from_json("alice",
		"{\"name\":\"Alice\"}");
	OBJ *room = obj_new_from_json("lobby",
		"{\"name\":\"Lobby\"}");
	muddb_put(db, "users", "alice", user);
	muddb_put(db, "rooms", "lobby", room);
	obj_free(user);
	obj_free(room);

	/* cross-domain isolation */
	OBJ *got;

	got = muddb_get(db, "users", "lobby");
	check("users/lobby is null", got == NULL);

	got = muddb_get(db, "rooms", "alice");
	check("rooms/alice is null", got == NULL);

	got = muddb_get(db, "users", "alice");
	check("users/alice exists", got != NULL);
	if (got) {
		char *name = obj_prop_get(got, "name");
		check("users/alice name",
			name != NULL && strcmp(name, "Alice") == 0);
		obj_free(got);
	}

	got = muddb_get(db, "rooms", "lobby");
	check("rooms/lobby exists", got != NULL);
	if (got) {
		char *name = obj_prop_get(got, "name");
		check("rooms/lobby name",
			name != NULL && strcmp(name, "Lobby") == 0);
		obj_free(got);
	}

	muddb_close(db);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : muddb.c");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}

	test_open_close();
	test_put_get();
	test_overwrite();
	test_delete();
	test_missing_key();
	test_iteration();
	test_multiple_domains();

	cleanup_tmpdir();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
