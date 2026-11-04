/* unit test for builder_snapshot.c : the LMDB -> CAS snapshot bridge */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_builder_snapshot"

#include "builder_snapshot.h"

#include "obj.h"
#include "obj_cache.h"
#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>
#include <log.h>

#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ctest.h"

static char tmpdir[] = "/tmp/test_builder_snapshot_XXXXXX";

static int
rm_cb(const char *path, const struct stat *sb, int typeflag,
	struct FTW *ftwbuf)
{
	(void)sb;
	(void)typeflag;
	(void)ftwbuf;
	return remove(path);
}

static void
cleanup_tmpdir(void)
{
	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
}

/* capture the newest log entry's comment while counting entries */
struct log_capture {
	int count;
	char comment[256];
};

static int
log_cb(const char *hash, int64_t time_s, int32_t time_ns,
	const char *comment, void *ctx)
{
	struct log_capture *cap = ctx;

	(void)hash;
	(void)time_s;
	(void)time_ns;
	cap->count++;
	if (comment)
		snprintf(cap->comment, sizeof cap->comment, "%s", comment);
	return 0;
}

/* The bridge keeps the depot locked while open, so verification opens its own
 * view only after the bridge has shut down and released the lock. */
static void
depot_path(char *buf, size_t sz, const char *name)
{
	snprintf(buf, sz, "%s/%s", tmpdir, name);
}

/* --- tests ----------------------------------------------------------- */

static void
test_noop_before_init(void)
{
	OBJ *o = obj_new_from_json("zone/world/r", "{\"name\":\"R\"}");

	check("bridge starts disabled", builder_snapshot_enabled() == 0);
	/* a record while disabled must not crash and must stay disabled */
	builder_snapshot_record("zone/world/r", o, "nobody");
	check("still disabled after no-op record",
		builder_snapshot_enabled() == 0);
	obj_free(o);
}

static void
test_record_and_readback(void)
{
	char depot[512];
	OBJ *o;
	struct cas *store;
	struct cas_tree *ct;
	OBJ_CACHE *reader;
	struct log_capture cap = {0};

	depot_path(depot, sizeof depot, "world-depot");

	check("init ok", builder_snapshot_init(depot) == 0);
	check("enabled after init", builder_snapshot_enabled() == 1);

	o = obj_new_from_json("zone/world/tower",
		"{\"name\":\"The Tower\",\"exit.n.to~\":\"zone/world/north\"}");
	check("built object", o != NULL);
	builder_snapshot_record("zone/world/tower", o, "alice");
	obj_free(o);

	/* release the depot lock before opening a reader on the same depot */
	builder_snapshot_shutdown();
	check("disabled after shutdown", builder_snapshot_enabled() == 0);

	store = cas_new(depot);
	ct = store ? cas_tree_new(store) : NULL;
	check("reader depot opened", ct != NULL);
	if (!ct) {
		cas_free(store);
		return;
	}
	cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

	reader = obj_cache_cas_new(ct, "world", "objs", 8);
	check("reader cache created", reader != NULL);

	o = obj_cache_get(reader, "zone/world/tower");
	check("recorded object read back", o != NULL);
	if (o) {
		char *name = obj_prop_get(o, "name");
		char *exit = obj_prop_get_ref(o, "exit.n.to");

		check("name mirrored", name && strcmp(name, "The Tower") == 0);
		check("reference mirrored intact",
			exit && strcmp(exit, "zone/world/north") == 0);
		obj_cache_release(reader, o);
	}

	cas_tree_log_read(ct, "world", log_cb, &cap);
	check("one commit logged", cap.count == 1);
	check("comment names the builder", strstr(cap.comment, "alice") != NULL);
	check("comment names the zone", strstr(cap.comment, "world") != NULL);

	obj_cache_cas_free(reader);
	cas_tree_free(ct);
	cas_free(store);
}

static void
test_noop_after_shutdown(void)
{
	OBJ *o = obj_new_from_json("zone/world/r2", "{\"name\":\"R2\"}");

	/* shutdown is idempotent and a later record is a safe no-op */
	builder_snapshot_shutdown();
	check("disabled", builder_snapshot_enabled() == 0);
	builder_snapshot_record("zone/world/r2", o, "nobody");
	check("still disabled", builder_snapshot_enabled() == 0);
	obj_free(o);
}

int
main(void)
{
	if (!mkdtemp(tmpdir)) {
		perror("mkdtemp");
		return EXIT_FAILURE;
	}

	test_noop_before_init();
	test_record_and_readback();
	test_noop_after_shutdown();

	cleanup_tmpdir();

	return ctest_report("test_builder_snapshot");
}
