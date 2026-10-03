/* unit test for obj containment: obj_move / obj_contents / obj_location */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_obj_contain"

#include "obj.h"
#include "muddb.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

static char tmpdir[] = "/tmp/test_obj_contain_XXXXXX";

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

/* create a persistent object and drop the create pin immediately */
static void
mk(const char *id)
{
	OBJ *o = obj_create(id);
	if (o)
		obj_release(o);
}

/* does the contents index list member under container? */
static int
listed(const char *container, const char *member)
{
	OBJ_CONTENTS_ITER *it = obj_contents_begin(container);
	const char *v;
	int found = 0;

	if (!it)
		return 0;
	while ((v = obj_contents_next(it)) != NULL) {
		if (strcmp(v, member) == 0) {
			found = 1;
			break;
		}
	}
	obj_contents_end(it);
	return found;
}

/* compare obj_location(member) to want (NULL means limbo) */
static int
located_at(const char *member, const char *want)
{
	char *loc = obj_location(member);
	int ok;

	if (!want)
		ok = (loc == NULL);
	else
		ok = (loc != NULL && strcmp(loc, want) == 0);
	free(loc);
	return ok;
}

static void
test_basic_move(void)
{
	mk("room");
	mk("sword");

	check("new object is in limbo", located_at("sword", NULL));
	check("empty container count 0", obj_contents_count("room") == 0);

	check("move into room", obj_move("sword", "room") == OBJ_OK);
	check("location is room", located_at("sword", "room"));
	check("room count 1", obj_contents_count("room") == 1);
	check("room lists sword", listed("room", "sword"));
}

static void
test_move_between(void)
{
	mk("bag");

	check("move sword to bag", obj_move("sword", "bag") == OBJ_OK);
	check("location now bag", located_at("sword", "bag"));
	check("bag count 1", obj_contents_count("bag") == 1);
	check("bag lists sword", listed("bag", "sword"));
	check("old room count 0", obj_contents_count("room") == 0);
	check("room no longer lists sword", !listed("room", "sword"));
}

static void
test_limbo(void)
{
	check("move sword to limbo", obj_move("sword", NULL) == OBJ_OK);
	check("location cleared", located_at("sword", NULL));
	check("bag count 0", obj_contents_count("bag") == 0);
	check("bag no longer lists sword", !listed("bag", "sword"));
}

static void
test_cycle(void)
{
	mk("box");
	mk("lid");

	check("lid into box", obj_move("lid", "box") == OBJ_OK);
	check("box contains lid", listed("box", "lid"));

	/* box into its own member lid would form a cycle */
	check("cycle refused", obj_move("box", "lid") == OBJ_ERR);
	check("self-containment refused", obj_move("box", "box") == OBJ_ERR);

	/* refused moves changed nothing */
	check("lid still in box", located_at("lid", "box"));
	check("box still in limbo", located_at("box", NULL));
	check("box count still 1", obj_contents_count("box") == 1);
}

static void
test_missing(void)
{
	check("missing member refused", obj_move("ghost", "room") == OBJ_ERR);
	check("missing container refused", obj_move("sword", "ghost") == OBJ_ERR);
	check("ghost has no location", located_at("ghost", NULL));
}

/* After a fresh reopen nothing is cached, so these reads come entirely from
 * the persisted index and object records. */
static void
test_persist_after_reopen(void)
{
	check("box count persisted", obj_contents_count("box") == 1);
	check("box still lists lid", listed("box", "lid"));
	check("lid location persisted", located_at("lid", "box"));
	check("sword still in limbo", located_at("sword", NULL));
}

static void
test_owner_index(void)
{
	mk("gem");
	mk("ring");

	check("unowned count 0", obj_owner_count("alice") == 0);

	check("set gem owner", obj_set_owner("gem", "alice") == OBJ_OK);
	check("alice owns 1", obj_owner_count("alice") == 1);

	check("set ring owner", obj_set_owner("ring", "alice") == OBJ_OK);
	check("alice owns 2", obj_owner_count("alice") == 2);

	/* Re-owning moves the object between tallies. */
	check("reassign ring to bob", obj_set_owner("ring", "bob") == OBJ_OK);
	check("alice back to 1", obj_owner_count("alice") == 1);
	check("bob owns 1", obj_owner_count("bob") == 1);

	/* Destroying an owned object clears its index entry. gem is in limbo and
	 * empty, so it can be destroyed. */
	check("destroy gem", obj_destroy("gem") == OBJ_OK);
	check("alice back to 0", obj_owner_count("alice") == 0);
	check("bob still 1", obj_owner_count("bob") == 1);
}

int
main(void)
{
	MUDDB *db;

	LOG_INFO("%%%%%%%%%%%% START-TEST : obj containment");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}

	db = muddb_open(tmpdir, 0);
	if (!db || obj_initialize(db, 32) != 0) {
		LOG_ERROR("setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	test_basic_move();
	test_move_between();
	test_limbo();
	test_cycle();
	test_missing();
	test_owner_index();

	obj_shutdown();
	muddb_close(db);

	/* reopen with an empty cache and confirm containment persisted */
	db = muddb_open(tmpdir, 0);
	if (!db || obj_initialize(db, 32) != 0) {
		LOG_ERROR("reopen failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}
	test_persist_after_reopen();
	obj_shutdown();
	muddb_close(db);

	cleanup_tmpdir();

	return ctest_report("test_obj_contain");
}
