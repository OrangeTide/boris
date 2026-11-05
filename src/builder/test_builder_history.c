/* unit test for builder_history.c : the world-history workflow engine */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_builder_history"

#include "builder_history.h"
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

static char tmpdir[] = "/tmp/test_builder_history_XXXXXX";
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

/* --- helpers (mirroring test_world_restore.c) ------------------------ */

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
put_json(const char *key, const char *json)
{
	OBJ *o = obj_new_from_json(key, json);

	if (o) {
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

/* mirror the live object under key into history, as a builder save would */
static void
record(const char *key)
{
	OBJ *o = obj_get(key);

	if (o) {
		builder_snapshot_record(key, o, "tester");
		obj_release(o);
	}
}

/* name check that frees the strdup */
static int
name_is(const char *key, const char *want)
{
	char *n = name_of(key);
	int ok = n && strcmp(n, want) == 0;

	free(n);
	return ok;
}

static int
ref_is(const char *key, const char *prop, const char *want)
{
	char *v = ref_of(key, prop);
	int ok = v && strcmp(v, want) == 0;

	free(v);
	return ok;
}

/* --- tests ----------------------------------------------------------- */

/* Round trip: per-edit undo and redo restore the object and its index to the
 * target snapshot, in both directions (spec section 12, round trip). */
static void
round_trip(void)
{
	char msg[256];

	put_named("zone/area/r0", "Room0");
	put_named("zone/area/r1", "Room1");
	put_named("zone/area/lamp", "Lamp");
	check("lamp into r0",
		obj_move("zone/area/lamp", "zone/area/r0") == OBJ_OK);

	/* a coherent baseline: r0, r1, and the lamp inside r0 */
	record("zone/area/r0");
	record("zone/area/r1");
	record("zone/area/lamp");

	/* one edit: move the lamp from r0 to r1, and snapshot it */
	check("lamp r0 -> r1",
		obj_move("zone/area/lamp", "zone/area/r1") == OBJ_OK);
	record("zone/area/lamp");
	check("lamp in r1 (pre-undo)", listed("zone/area/r1", "zone/area/lamp"));

	/* undo the move: the lamp returns to r0 and the index rebuilds */
	check("undo ok", builder_history_undo("tester", "zone/area", 0, msg,
		sizeof msg) == BUILDER_HISTORY_OK);
	check("lamp back in r0 after undo",
		listed("zone/area/r0", "zone/area/lamp"));
	check("lamp not in r1 after undo",
		!listed("zone/area/r1", "zone/area/lamp"));
	{
		char *loc = obj_location("zone/area/lamp");

		check("lamp location is r0 after undo",
			loc && strcmp(loc, "zone/area/r0") == 0);
		free(loc);
	}

	/* redo the move: forward to the lamp in r1 again */
	check("redo ok", builder_history_redo("tester", "zone/area", 0, msg,
		sizeof msg) == BUILDER_HISTORY_OK);
	check("lamp in r1 after redo", listed("zone/area/r1", "zone/area/lamp"));
	check("lamp not in r0 after redo",
		!listed("zone/area/r0", "zone/area/lamp"));

	/* redo again has nowhere to go */
	check("redo at latest refused", builder_history_redo("tester",
		"zone/area", 0, msg, sizeof msg) == BUILDER_HISTORY_ERR);
}

/* Scoping: an undo in zone A restores only A, even though zone B changed after
 * A's target snapshot (spec section 12, scoping). */
static void
scoping(void)
{
	char msg[256];

	put_named("zone/scopea/r", "A1");
	record("zone/scopea/r");
	put_named("zone/scopeb/r", "B1");
	record("zone/scopeb/r");
	set_name("zone/scopea/r", "A2");
	record("zone/scopea/r");
	set_name("zone/scopeb/r", "B2");	/* B changes after A's target */
	record("zone/scopeb/r");

	check("undo scopea ok", builder_history_undo("tester", "zone/scopea", 0,
		msg, sizeof msg) == BUILDER_HISTORY_OK);
	check("scopea restored to A1", name_is("zone/scopea/r", "A1"));
	check("scopeb untouched by scopea undo", name_is("zone/scopeb/r", "B2"));
}

/* @history lists a zone's entries newest first, filtered to that zone. */
static void
history_list(void)
{
	struct builder_history_entry ents[20];
	int n = 0;

	check("list scopea ok", builder_history_list("zone/scopea", ents, 20,
		&n) == BUILDER_HISTORY_OK);
	/* A1, A2, and the undo's recorded restore all touch scopea */
	check("scopea has at least three entries", n >= 3);
	check("newest entry names scopea",
		strstr(ents[0].comment, "(zone scopea)") != NULL);
}

/* Checkout rewrites intra-subtree references into the scratch area and leaves
 * external references and the source alone (spec section 12, rewrite). */
static void
checkout(void)
{
	char scratch[OBJ_PATH_MAX] = "", msg[256];

	put_json("templates/room", "{\"name\":\"Room\"}");
	put_named("zone/world/hall", "Hall");
	put_json("zone/town/square",
		"{\"name\":\"Square\",\"%parent~\":\"templates/room\","
		"\"exit.n.to~\":\"zone/town/market\","
		"\"exit.e.to~\":\"zone/world/hall\"}");
	put_json("zone/town/market", "{\"name\":\"Market\"}");
	put_json("zone/town/stall",
		"{\"name\":\"Stall\",\"%location~\":\"zone/town/square\"}");
	record("templates/room");
	record("zone/world/hall");
	record("zone/town/square");
	record("zone/town/market");
	record("zone/town/stall");

	check("checkout ok", builder_history_checkout("tester", "zone/town",
		NULL, 0, scratch, sizeof scratch, msg, sizeof msg)
		== BUILDER_HISTORY_OK);
	check("scratch path is owned by the user",
		strcmp(scratch, "zone/scratch/tester/town") == 0);

	check("square copied", exists("zone/scratch/tester/town/square"));
	check("market copied", exists("zone/scratch/tester/town/market"));
	check("internal exit remapped to scratch",
		ref_is("zone/scratch/tester/town/square", "exit.n.to",
			"zone/scratch/tester/town/market"));
	check("external exit kept",
		ref_is("zone/scratch/tester/town/square", "exit.e.to",
			"zone/world/hall"));
	check("external parent kept",
		ref_is("zone/scratch/tester/town/square", "%parent",
			"templates/room"));
	{
		char *loc = obj_location("zone/scratch/tester/town/stall");

		check("item location remapped to scratch",
			loc && strcmp(loc, "zone/scratch/tester/town/square")
			== 0);
		free(loc);
	}
	/* the source zone is untouched */
	check("source square intact", ref_is("zone/town/square", "exit.n.to",
		"zone/town/market"));
}

/* Publish fast-forward: with the source zone untouched since checkout, the
 * scratch edits land back over the zone and references resolve (spec section
 * 12, publish fast-forward). */
static void
publish_fast_forward(void)
{
	char msg[256];

	/* edit the checked-out scratch and snapshot it, as a builder save would */
	set_name("zone/scratch/tester/town/square", "Square Edited");
	record("zone/scratch/tester/town/square");

	check("publish ok", builder_history_publish("tester", "town", NULL, 0,
		msg, sizeof msg) == BUILDER_HISTORY_OK);
	check("edit landed over the zone",
		name_is("zone/town/square", "Square Edited"));
	check("internal exit remapped back to the zone",
		ref_is("zone/town/square", "exit.n.to", "zone/town/market"));
	check("external exit still resolves",
		ref_is("zone/town/square", "exit.e.to", "zone/world/hall"));
}

/* Publish race: a concurrent edit to the live zone moves the fork point, so
 * the publish is refused and the live zone is left unchanged (spec section 12,
 * publish race). */
static void
publish_race(void)
{
	char scratch[OBJ_PATH_MAX] = "", msg[256];

	put_named("zone/race/r", "R1");
	record("zone/race/r");

	check("checkout race ok", builder_history_checkout("tester", "zone/race",
		"racecopy", 0, scratch, sizeof scratch, msg, sizeof msg)
		== BUILDER_HISTORY_OK);

	/* someone edits the live zone after the checkout */
	set_name("zone/race/r", "R2-live");
	record("zone/race/r");

	/* and the builder edits their scratch */
	set_name("zone/scratch/tester/racecopy/r", "R-scratch");
	record("zone/scratch/tester/racecopy/r");

	check("publish refused on moved fork point",
		builder_history_publish("tester", "racecopy", NULL, 0, msg,
			sizeof msg) == BUILDER_HISTORY_ERR);
	check("live zone unchanged by refused publish",
		name_is("zone/race/r", "R2-live"));
}

/* A numbered @restore reaches a specific past entry in place. */
static void
restore_entry(void)
{
	struct builder_history_entry ents[20];
	char msg[256];
	int n = 0;

	put_named("zone/rz/r", "v1");
	record("zone/rz/r");
	set_name("zone/rz/r", "v2");
	record("zone/rz/r");
	set_name("zone/rz/r", "v3");
	record("zone/rz/r");

	check("list rz ok", builder_history_list("zone/rz", ents, 20, &n)
		== BUILDER_HISTORY_OK);
	check("rz has three entries", n == 3);

	/* entry 3 is the oldest (v1) in newest-first numbering */
	check("restore entry 3 ok", builder_history_restore("tester", "zone/rz",
		3, NULL, 0, msg, sizeof msg) == BUILDER_HISTORY_OK);
	check("restored to v1", name_is("zone/rz/r", "v1"));

	check("restore out-of-range refused", builder_history_restore("tester",
		"zone/rz", 99, NULL, 0, msg, sizeof msg)
		== BUILDER_HISTORY_ERR);
}

/* Wipe on restore: an undo that drops an object removes it from the history
 * tip too, so a later checkout does not resurrect it (the recomputed wipe, not
 * deletion tracking). */
static void
wipe_on_restore(void)
{
	char scratch[OBJ_PATH_MAX] = "", msg[256];

	put_named("zone/wipe/keep", "Keep");
	record("zone/wipe/keep");
	put_named("zone/wipe/extra", "Extra");
	record("zone/wipe/extra");
	check("extra present pre-undo", exists("zone/wipe/extra"));

	/* undo back to the single-room snapshot: extra leaves live... */
	check("undo wipe ok", builder_history_undo("tester", "zone/wipe", 0,
		msg, sizeof msg) == BUILDER_HISTORY_OK);
	check("keep survives undo", exists("zone/wipe/keep"));
	check("extra gone from live after undo", !exists("zone/wipe/extra"));

	/* ...and a checkout reads the tip, which must no longer carry extra */
	check("checkout wipe ok", builder_history_checkout("tester",
		"zone/wipe", "wcopy", 0, scratch, sizeof scratch, msg,
		sizeof msg) == BUILDER_HISTORY_OK);
	check("keep copied to scratch",
		exists("zone/scratch/tester/wcopy/keep"));
	check("extra not resurrected into scratch",
		!exists("zone/scratch/tester/wcopy/extra"));
}

/* Forget on destroy: builder_snapshot_forget drops a destroyed key from the
 * tip, so a checkout does not carry the dead object. */
static void
forget_on_destroy(void)
{
	char scratch[OBJ_PATH_MAX] = "", msg[256];

	put_named("zone/fg/a", "A");
	put_named("zone/fg/b", "B");
	record("zone/fg/a");
	record("zone/fg/b");

	check("destroy b from live", obj_delete("zone/fg/b") == OBJ_OK);
	builder_snapshot_forget("zone/fg/b", "tester");

	check("checkout fg ok", builder_history_checkout("tester", "zone/fg",
		"fgcopy", 0, scratch, sizeof scratch, msg, sizeof msg)
		== BUILDER_HISTORY_OK);
	check("surviving object copied",
		exists("zone/scratch/tester/fgcopy/a"));
	check("destroyed object not in the tip",
		!exists("zone/scratch/tester/fgcopy/b"));
}

/* @checkpoint pins the current root under a named ref that is not "world". */
static void
checkpoint(void)
{
	char h[CAS_HASH_HEX + 1];
	char msg[256];

	check("checkpoint ok", builder_history_checkpoint("milestone", msg,
		sizeof msg) == BUILDER_HISTORY_OK);
	check("checkpoint ref exists",
		cas_tree_ref_read(builder_snapshot_tree(), "cp-milestone", h)
		== CAS_OK);

	check("checkpoint with a bad label refused",
		builder_history_checkpoint("bad/label", msg, sizeof msg)
		== BUILDER_HISTORY_ERR);
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

	round_trip();
	scoping();
	history_list();
	checkout();
	publish_fast_forward();
	publish_race();
	restore_entry();
	wipe_on_restore();
	forget_on_destroy();
	checkpoint();

	builder_snapshot_shutdown();
	obj_shutdown();
	muddb_close(db);

	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
	return ctest_report("test_builder_history");
}
