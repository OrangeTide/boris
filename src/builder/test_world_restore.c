/* unit test for world_restore.c : scoped CAS -> LMDB restore */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_world_restore"

#include "world_restore.h"
#include "builder_snapshot.h"

#include "obj.h"
#include "muddb.h"

#include <cas.h>
#include <cas-tree.h>

#include <ftw.h>
#include <log.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "ctest.h"

static char tmpdir[] = "/tmp/test_world_restore_XXXXXX";
static char dbdir[256];
static char depotdir[256];

static int
rm_cb(const char *path, const struct stat *sb, int typeflag,
	struct FTW *ftwbuf)
{
	(void)sb;
	(void)typeflag;
	(void)ftwbuf;
	return remove(path);
}

/* --- helpers --------------------------------------------------------- */

/* write-through create of a persistent object with one name property */
static void
put_named(const char *key, const char *name)
{
	OBJ *o = obj_new(key);

	if (o) {
		obj_prop_set(o, "name", name);
		obj_put(key, o);
		obj_free(o);
	}
}

static void
set_name(const char *key, const char *name)
{
	OBJ *o = obj_get(key);

	if (o) {
		obj_prop_set(o, "name", name);
		obj_mark_dirty(o);
		obj_save(key);
		obj_release(o);
	}
}

static char *
name_of(const char *key)
{
	OBJ *o = obj_get(key);
	char *out = NULL;

	if (o) {
		char *n = obj_prop_get(o, "name");

		if (n)
			out = strdup(n);
		obj_release(o);
	}
	return out;
}

static int
exists(const char *key)
{
	OBJ *o = obj_get(key);

	if (o) {
		obj_release(o);
		return 1;
	}
	return 0;
}

/* is member listed in container's contents index? */
static int
listed(const char *container, const char *member)
{
	OBJ_CONTENTS_ITER *it = obj_contents_begin(container);
	const char *v;
	int found = 0;

	if (!it)
		return 0;
	while ((v = obj_contents_next(it)) != NULL)
		if (strcmp(v, member) == 0) {
			found = 1;
			break;
		}
	obj_contents_end(it);
	return found;
}

/* snapshot the current live object under key into history */
static void
record(const char *key)
{
	OBJ *o = obj_get(key);

	if (o) {
		builder_snapshot_record(key, o, "tester");
		obj_release(o);
	}
}

/* --- test ------------------------------------------------------------ */

static void
run(void)
{
	char root0[CAS_HASH_HEX + 1];
	char *nm;

	/* 1. build an initial world: a hall with a lamp inside, and an old
	 * room that will later be deleted. */
	put_named("zone/world/hall", "Hall v1");
	put_named("zone/world/lamp", "Lamp");
	put_named("zone/world/old", "Old Room");
	check("lamp into hall",
		obj_move("zone/world/lamp", "zone/world/hall") == OBJ_OK);
	check("lamp is in hall (pre)", listed("zone/world/hall",
		"zone/world/lamp"));

	/* 2. snapshot that state and capture its root. */
	record("zone/world/hall");
	record("zone/world/lamp");
	record("zone/world/old");
	check("captured snapshot root",
		cas_tree_ref_read(builder_snapshot_tree(), "world", root0)
		== CAS_OK);

	/* 3. mutate the live world away from the snapshot. */
	set_name("zone/world/hall", "Hall v2");
	check("lamp out to limbo",
		obj_move("zone/world/lamp", NULL) == OBJ_OK);
	check("lamp no longer in hall (mutated)",
		!listed("zone/world/hall", "zone/world/lamp"));
	put_named("zone/world/new", "New Room");
	check("old room destroyed",
		obj_destroy("zone/world/old") == OBJ_OK);
	check("new room exists (mutated)", exists("zone/world/new"));
	check("old room gone (mutated)", !exists("zone/world/old"));

	/* 4. restore the zone in place from the snapshot root. */
	check("restore ok", world_restore(builder_snapshot_tree(), root0,
		"zone/world", "zone/world", 0) == WORLD_RESTORE_OK);

	/* 5. the live world matches the snapshot again. */
	nm = name_of("zone/world/hall");
	check("hall name restored", nm && strcmp(nm, "Hall v1") == 0);
	free(nm);

	nm = name_of("zone/world/old");
	check("old room restored", nm && strcmp(nm, "Old Room") == 0);
	free(nm);

	check("new room removed by restore", !exists("zone/world/new"));

	{
		char *loc = obj_location("zone/world/lamp");

		check("lamp location restored",
			loc && strcmp(loc, "zone/world/hall") == 0);
		free(loc);
	}
	check("contents index rebuilt",
		listed("zone/world/hall", "zone/world/lamp"));
	check("hall contents count is one",
		obj_contents_count("zone/world/hall") == 1);
}

int
main(void)
{
	MUDDB *db;

	if (!mkdtemp(tmpdir)) {
		perror("mkdtemp");
		return EXIT_FAILURE;
	}
	snprintf(dbdir, sizeof dbdir, "%s/db", tmpdir);
	snprintf(depotdir, sizeof depotdir, "%s/depot", tmpdir);
	mkdir(dbdir, 0777);

	db = muddb_open(dbdir, 0);
	if (!db || obj_initialize(db, 32) != 0) {
		LOG_ERROR("could not open store");
		return EXIT_FAILURE;
	}
	if (builder_snapshot_init(depotdir) != 0) {
		LOG_ERROR("could not open snapshot depot");
		return EXIT_FAILURE;
	}

	run();

	builder_snapshot_shutdown();
	obj_shutdown();
	muddb_close(db);

	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
	return ctest_report("test_world_restore");
}
