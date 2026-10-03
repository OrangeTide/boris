/* unit test for the per-task object-handle table */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_verb_handle"

#include "verb_handle.h"
#include "obj.h"
#include "muddb.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

MUDDB *mud_db;

static char tmpdir[] = "/tmp/test_verb_handle_XXXXXX";

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

/* create a pinned object (caller gives up the pin to whoever takes it) */
static OBJ *
mk(const char *id)
{
	return obj_create(id);
}

static void
test_self_is_borrowed(void)
{
	struct verb_handles h;
	OBJ *self = mk("test/self");

	memset(&h, 0, sizeof h);
	check("created self", self != NULL);
	if (!self)
		return;

	verb_handle_set_self(&h, self);
	check("self resolves", verb_handle_get(&h, VERB_HANDLE_SELF) == self);
	check("none resolves NULL", verb_handle_get(&h, VERB_HANDLE_NONE) == NULL);
	check("out-of-range resolves NULL", verb_handle_get(&h, 999) == NULL);

	/* closing self is a no-op; it stays resolvable */
	verb_handle_close(&h, VERB_HANDLE_SELF);
	check("self still resolves after close",
		verb_handle_get(&h, VERB_HANDLE_SELF) == self);

	/* clear must not release the borrowed self: it is still pinned by us, so
	 * destroy refuses (refcount > 0) until we release our own reference */
	verb_handle_clear(&h);
	check("self survives clear", verb_handle_get(&h, VERB_HANDLE_SELF) == self);
	check("self still pinned after clear", obj_destroy("test/self") == OBJ_ERR);

	obj_release(self);
	check("self destroyable once released", obj_destroy("test/self") == OBJ_OK);
}

static void
test_add_and_close(void)
{
	struct verb_handles h;
	OBJ *a = mk("test/a");
	unsigned ha;

	memset(&h, 0, sizeof h);
	check("created a", a != NULL);
	if (!a)
		return;

	ha = verb_handle_add(&h, a);
	check("add returns a dynamic handle", ha >= VERB_HANDLE_SELF + 1);
	check("added handle resolves", verb_handle_get(&h, ha) == a);

	/* the table owns a's only pin; closing releases it */
	verb_handle_close(&h, ha);
	check("closed handle resolves NULL", verb_handle_get(&h, ha) == NULL);
	check("object unpinned after close", obj_destroy("test/a") == OBJ_OK);
}

static void
test_full_and_clear(void)
{
	struct verb_handles h;
	int ndyn = VERB_HANDLE_MAX - (VERB_HANDLE_SELF + 1);
	int i, ok = 1;
	char id[32];
	OBJ *extra;

	memset(&h, 0, sizeof h);

	/* fill every dynamic slot */
	for (i = 0; i < ndyn; i++) {
		OBJ *o;
		snprintf(id, sizeof id, "test/d%d", i);
		o = mk(id);
		if (!o || verb_handle_add(&h, o) == VERB_HANDLE_NONE)
			ok = 0;
	}
	check("filled all dynamic slots", ok);

	/* one more add fails and leaves ownership with the caller */
	extra = mk("test/extra");
	check("created extra", extra != NULL);
	check("add to full table fails", verb_handle_add(&h, extra)
		== VERB_HANDLE_NONE);
	obj_release(extra);             /* caller keeps the pin on failure */
	check("extra destroyable", obj_destroy("test/extra") == OBJ_OK);

	/* clear releases every owned handle, so each object is now destroyable */
	verb_handle_clear(&h);
	ok = 1;
	for (i = 0; i < ndyn; i++) {
		snprintf(id, sizeof id, "test/d%d", i);
		if (obj_destroy(id) != OBJ_OK)
			ok = 0;
	}
	check("clear released every owned handle", ok);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : verb handle table");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}
	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 64) != 0) {
		LOG_ERROR("setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	test_self_is_borrowed();
	test_add_and_close();
	test_full_and_clear();

	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_verb_handle");
}
