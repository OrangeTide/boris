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
#include "ctest.h"

static char tmpdir[] = "/tmp/test_muddb_XXXXXX";

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
test_missing_domain(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("missing_dom: open", db != NULL);
	if (!db) return;

	/* get on nonexistent domain returns NULL */
	OBJ *got = muddb_get(db, "no_such_domain", "key1");
	check("missing_dom: get returns null", got == NULL);

	/* iter on nonexistent domain returns NULL */
	MUDDB_ITER *it = muddb_iter_begin(db, "no_such_domain");
	check("missing_dom: iter returns null", it == NULL);

	muddb_close(db);
}

static void
test_delete_missing_key(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("del_missing: open", db != NULL);
	if (!db) return;

	/* put one key so the domain exists */
	OBJ *obj = obj_new_from_json("x", "{\"v\":\"1\"}");
	muddb_put(db, "del_test", "exists", obj);
	obj_free(obj);

	/* delete a key that was never written */
	int rc = muddb_del(db, "del_test", "ghost");
	check("del_missing: returns ok", rc == MUDDB_OK);

	/* original key still intact */
	OBJ *got = muddb_get(db, "del_test", "exists");
	check("del_missing: other key intact", got != NULL);
	obj_free(got);

	muddb_close(db);
}

static void
test_reopen(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	check("reopen: open first", db != NULL);
	if (!db) return;

	OBJ *obj = obj_new_from_json("r1",
		"{\"name\":\"Persistent\"}");
	muddb_put(db, "reopen_test", "r1", obj);
	obj_free(obj);

	muddb_close(db);

	/* reopen and verify data survived */
	db = muddb_open(tmpdir, 0);
	check("reopen: open second", db != NULL);
	if (!db) return;

	OBJ *got = muddb_get(db, "reopen_test", "r1");
	check("reopen: data persisted", got != NULL);
	if (got) {
		char *name = obj_prop_get(got, "name");
		check("reopen: value intact",
			name != NULL && strcmp(name, "Persistent") == 0);
		obj_free(got);
	}

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

static void
test_index(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	MUDDB_INDEX_ITER *it;
	const char *v;
	int n;

	check("open for index", db != NULL);
	if (!db) return;

	check("register index",
		muddb_index_register(db, "idx.contents") == MUDDB_OK);

	/* an empty index has no values and counts zero */
	check("empty count zero",
		muddb_index_count(db, "idx.contents", "rooms/altar") == 0);
	it = muddb_index_iter_begin(db, "idx.contents", "rooms/altar");
	check("empty iter begins", it != NULL);
	check("empty iter yields nothing", it && muddb_index_iter_next(it) == NULL);
	muddb_index_iter_end(it);

	check("add sword", muddb_index_add(db, "idx.contents", "rooms/altar",
		"objs/sword") == MUDDB_OK);
	check("add shield", muddb_index_add(db, "idx.contents", "rooms/altar",
		"objs/shield") == MUDDB_OK);
	check("add char", muddb_index_add(db, "idx.contents", "rooms/altar",
		"chars/7") == MUDDB_OK);
	check("add to other container",
		muddb_index_add(db, "idx.contents", "rooms/vault", "objs/gold")
		== MUDDB_OK);

	/* a duplicate pair is idempotent, not double-counted */
	check("dup add ok", muddb_index_add(db, "idx.contents", "rooms/altar",
		"objs/sword") == MUDDB_OK);
	check("count is 3",
		muddb_index_count(db, "idx.contents", "rooms/altar") == 3);

	check("contains present",
		muddb_index_contains(db, "idx.contents", "rooms/altar", "chars/7"));
	check("not contains cross-container",
		!muddb_index_contains(db, "idx.contents", "rooms/altar", "objs/gold"));

	n = 0;
	it = muddb_index_iter_begin(db, "idx.contents", "rooms/altar");
	while ((v = muddb_index_iter_next(it)) != NULL)
		n++;
	muddb_index_iter_end(it);
	check("iter yields all 3", n == 3);

	check("other container isolated",
		muddb_index_count(db, "idx.contents", "rooms/vault") == 1);

	check("del one pair", muddb_index_del(db, "idx.contents", "rooms/altar",
		"objs/shield") == MUDDB_OK);
	check("count now 2",
		muddb_index_count(db, "idx.contents", "rooms/altar") == 2);
	check("del of missing pair ok",
		muddb_index_del(db, "idx.contents", "rooms/altar", "nope")
		== MUDDB_OK);

	/* index data survives a reopen */
	muddb_close(db);
	db = muddb_open(tmpdir, 0);
	check("reopen for index", db != NULL);
	check("re-register ok",
		muddb_index_register(db, "idx.contents") == MUDDB_OK);
	check("count persisted across reopen",
		muddb_index_count(db, "idx.contents", "rooms/altar") == 2);
	muddb_close(db);
}

static void
test_txn_atomic(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	MUDDB_TXN *t;
	OBJ *obj, *got;

	check("open for txn", db != NULL);
	if (!db) return;
	check("register idx",
		muddb_index_register(db, "idx.contents") == MUDDB_OK);

	/* a committed transaction lands the object and the index delta together */
	obj = obj_new_from_json("objs/lamp", "{\"name\":\"brass lamp\"}");
	t = muddb_txn_begin(db);
	check("txn begin", t != NULL);
	check("txn put", muddb_txn_put(t, "objs", "objs/lamp", obj) == MUDDB_OK);
	check("txn index add",
		muddb_txn_index_add(t, "idx.contents", "rooms/cave", "objs/lamp")
		== MUDDB_OK);
	check("txn commit", muddb_txn_commit(t) == MUDDB_OK);
	obj_free(obj);

	got = muddb_get(db, "objs", "objs/lamp");
	check("committed object present", got != NULL);
	if (got) obj_free(got);
	check("committed index present",
		muddb_index_contains(db, "idx.contents", "rooms/cave", "objs/lamp"));

	/* an aborted transaction lands nothing */
	obj = obj_new_from_json("objs/ghost", "{\"name\":\"ghost\"}");
	t = muddb_txn_begin(db);
	check("txn2 put", muddb_txn_put(t, "objs", "objs/ghost", obj) == MUDDB_OK);
	check("txn2 index add",
		muddb_txn_index_add(t, "idx.contents", "rooms/cave", "objs/ghost")
		== MUDDB_OK);
	muddb_txn_abort(t);
	obj_free(obj);

	got = muddb_get(db, "objs", "objs/ghost");
	check("aborted object absent", got == NULL);
	if (got) obj_free(got);
	check("aborted index absent",
		!muddb_index_contains(db, "idx.contents", "rooms/cave", "objs/ghost"));

	muddb_close(db);
}

static void
test_txn_rollback(void)
{
	MUDDB *db = muddb_open(tmpdir, 0);
	MUDDB_TXN *t;

	check("open for rollback", db != NULL);
	if (!db)
		return;

	/* Create a brand-new index inside a transaction, then abort. LMDB
	 * closes the DBI it opened on abort, so muddb must not keep it cached;
	 * otherwise the name would later resolve to a closed handle. */
	t = muddb_txn_begin(db);
	check("rollback txn begin", t != NULL);
	check("stage add to new index",
		muddb_txn_index_add(t, "idx.scratch", "k", "v") == MUDDB_OK);
	muddb_txn_abort(t);

	/* the aborted creation left nothing on disk */
	check("aborted index empty",
		muddb_index_count(db, "idx.scratch", "k") == 0);

	/* registering and using the same name now works on a fresh handle */
	check("register after abort",
		muddb_index_register(db, "idx.scratch") == MUDDB_OK);
	check("add after abort",
		muddb_index_add(db, "idx.scratch", "k", "v") == MUDDB_OK);
	check("contains after abort",
		muddb_index_contains(db, "idx.scratch", "k", "v"));
	check("count after abort",
		muddb_index_count(db, "idx.scratch", "k") == 1);

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
	test_missing_domain();
	test_delete_missing_key();
	test_reopen();
	test_iteration();
	test_multiple_domains();
	test_index();
	test_txn_atomic();
	test_txn_rollback();

	cleanup_tmpdir();

	return ctest_report("test_muddb");
}
