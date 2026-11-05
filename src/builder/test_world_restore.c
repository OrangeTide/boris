/* unit test for world_restore.c : scoped CAS -> LMDB restore */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_world_restore"

#include "world_restore.h"
#include "builder_snapshot.h"

#include "obj.h"
#include "objref.h"
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

/* write-through create from a JSON body */
static void
put_json(const char *key, const char *json)
{
	OBJ *o = obj_new_from_json(key, json);

	if (o) {
		obj_put(key, o);
		obj_free(o);
	}
}

/* read a reference property (strdup'd), or NULL */
static char *
ref_of(const char *key, const char *name)
{
	OBJ *o = obj_get(key);
	char *out = NULL;

	if (o) {
		char *v = obj_prop_get_ref(o, name);

		if (v)
			out = strdup(v);
		obj_release(o);
	}
	return out;
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
		"zone/world", "zone/world", 0, 0) == WORLD_RESTORE_OK);

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

/* the rewrite primitive in isolation: marked in-subtree references move, and
 * out-of-subtree references and non-reference properties do not. */
static void
test_rewrite_primitive(void)
{
	OBJ *o = obj_new_from_json("zone/town/square",
		"{\"name\":\"zone/town/decoy\","	/* a path-looking string value */
		"\"%parent~\":\"templates/room\","
		"\"exit.n.to~\":\"zone/town/market\","
		"\"exit.e.to~\":\"zone/world/hall\","
		"\"%location~\":\"zone/town\"}");
	int n;
	char *v;

	check("built rewrite fixture", o != NULL);
	n = objref_rewrite_prefix(o, "zone/town", "zone/scratch/w");
	check("two in-subtree refs rewritten", n == 2);

	v = obj_prop_get_ref(o, "exit.n.to");
	check("in-subtree exit remapped",
		v && strcmp(v, "zone/scratch/w/market") == 0);
	v = obj_prop_get_ref(o, "%location");
	check("exact-prefix location remapped",
		v && strcmp(v, "zone/scratch/w") == 0);
	v = obj_prop_get_ref(o, "exit.e.to");
	check("out-of-subtree exit untouched",
		v && strcmp(v, "zone/world/hall") == 0);
	v = obj_prop_get_ref(o, "%parent");
	check("external parent untouched",
		v && strcmp(v, "templates/room") == 0);
	v = obj_prop_get(o, "name");
	check("path-looking string value untouched",
		v && strcmp(v, "zone/town/decoy") == 0);

	obj_free(o);
}

/* cross-path copy (checkout): the subtree is copied to a new prefix with its
 * internal references remapped, external references kept, and the source left
 * in place. */
static void
checkout(void)
{
	char root[CAS_HASH_HEX + 1];
	char *v;

	/* the shared template the square inherits from must resolve */
	put_json("templates/room", "{\"name\":\"Room\"}");
	put_json("zone/town/square",
		"{\"name\":\"Square\",\"%parent~\":\"templates/room\","
		"\"exit.n.to~\":\"zone/town/market\","
		"\"exit.e.to~\":\"zone/world/hall\"}");
	put_json("zone/town/market", "{\"name\":\"Market\"}");
	put_json("zone/town/stall",
		"{\"name\":\"Stall\",\"%location~\":\"zone/town/square\"}");

	record("zone/town/square");
	record("zone/town/market");
	record("zone/town/stall");
	check("captured town root",
		cas_tree_ref_read(builder_snapshot_tree(), "world", root)
		== CAS_OK);

	check("checkout ok", world_restore(builder_snapshot_tree(), root,
		"zone/town", "zone/scratch/w", 1, 0) == WORLD_RESTORE_OK);

	/* destination objects exist with references remapped where internal */
	check("square copied", exists("zone/scratch/w/square"));
	check("market copied", exists("zone/scratch/w/market"));

	v = ref_of("zone/scratch/w/square", "exit.n.to");
	check("internal exit remapped to scratch",
		v && strcmp(v, "zone/scratch/w/market") == 0);
	free(v);
	v = ref_of("zone/scratch/w/square", "exit.e.to");
	check("external exit kept",
		v && strcmp(v, "zone/world/hall") == 0);
	free(v);
	v = ref_of("zone/scratch/w/square", "%parent");
	check("external parent kept",
		v && strcmp(v, "templates/room") == 0);
	free(v);

	v = obj_location("zone/scratch/w/stall");
	check("item location remapped to scratch",
		v && strcmp(v, "zone/scratch/w/square") == 0);
	free(v);
	check("contents index built at destination",
		listed("zone/scratch/w/square", "zone/scratch/w/stall"));

	/* the source zone is untouched by a checkout */
	check("source square still present", exists("zone/town/square"));
	v = ref_of("zone/town/square", "exit.n.to");
	check("source exit unchanged",
		v && strcmp(v, "zone/town/market") == 0);
	free(v);
}

/* outbound integrity: a snapshot whose object references a room that will not
 * exist is refused, and the refusal leaves the live store untouched; a wizard
 * force applies it anyway. */
static void
outbound_integrity(void)
{
	char root[CAS_HASH_HEX + 1];

	put_json("zone/bad/room",
		"{\"name\":\"Bad\",\"exit.n.to~\":\"zone/bad/ghost\"}");
	record("zone/bad/room");
	check("captured bad root",
		cas_tree_ref_read(builder_snapshot_tree(), "world", root)
		== CAS_OK);

	/* remove it from live so the restore is a fresh write of the snapshot */
	check("bad room destroyed",
		obj_destroy("zone/bad/room") == OBJ_OK);

	check("restore refused on dangling outbound",
		world_restore(builder_snapshot_tree(), root, "zone/bad",
			"zone/bad", 0, 0) == WORLD_RESTORE_ERR);
	check("nothing written on refusal", !exists("zone/bad/room"));

	check("forced restore applies",
		world_restore(builder_snapshot_tree(), root, "zone/bad",
			"zone/bad", 0, 1) == WORLD_RESTORE_OK);
	check("forced restore wrote the object", exists("zone/bad/room"));
}

/* inbound integrity: restoring a zone to a root that lacks a room an external
 * object still references is refused (the restore would orphan that external
 * reference), and a wizard force applies it. */
static void
inbound_integrity(void)
{
	char root_early[CAS_HASH_HEX + 1];

	/* snapshot the zone before the referenced room exists */
	put_json("zone/vic/other", "{\"name\":\"Other\"}");
	record("zone/vic/other");
	check("captured early root",
		cas_tree_ref_read(builder_snapshot_tree(), "world", root_early)
		== CAS_OK);

	/* now add the room and an external object that points at it */
	put_json("zone/vic/target", "{\"name\":\"Target\"}");
	put_json("zone/keep/anchor",
		"{\"name\":\"Anchor\",\"exit.e.to~\":\"zone/vic/target\"}");

	/* restoring zone/vic to the early root would delete target, orphaning
	 * the anchor's exit */
	check("restore refused on dangling inbound",
		world_restore(builder_snapshot_tree(), root_early, "zone/vic",
			"zone/vic", 0, 0) == WORLD_RESTORE_ERR);
	check("target survives refusal", exists("zone/vic/target"));

	check("forced restore applies",
		world_restore(builder_snapshot_tree(), root_early, "zone/vic",
			"zone/vic", 0, 1) == WORLD_RESTORE_OK);
	check("target removed by forced restore", !exists("zone/vic/target"));
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

	test_rewrite_primitive();
	run();
	checkout();
	outbound_integrity();
	inbound_integrity();

	builder_snapshot_shutdown();
	obj_shutdown();
	muddb_close(db);

	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
	return ctest_report("test_world_restore");
}
