/* unit test for obj_cache_cas.c */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_obj_cache_cas"

#include "obj_cache_cas.h"
#include "obj.h"

#include <cas.h>
#include <cas-tree.h>
#include <log.h>

#include <ftw.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char tmpdir[] = "/tmp/test_obj_cache_cas_XXXXXX";

static int pass_count, fail_count;

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

/* fresh store + tree per test, in its own depot under tmpdir */
static struct cas_tree *
make_tree(const char *name)
{
	char depot[512];

	snprintf(depot, sizeof(depot), "%s/%s", tmpdir, name);

	struct cas *store = cas_new(depot);

	if (!store)
		return NULL;

	struct cas_tree *ct = cas_tree_new(store);

	if (!ct) {
		cas_free(store);
		return NULL;
	}
	cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);
	return ct;
}

static void
free_tree(struct cas_tree *ct)
{
	struct cas *store = cas_tree_cas(ct);

	cas_tree_free(ct);
	cas_free(store);
}

/* put a fresh object with one property, freeing the OBJ after */
static int
put_json(OBJ_CACHE *c, const char *id, const char *json)
{
	OBJ *o = obj_new_from_json(id, json);

	if (!o)
		return OBJ_CACHE_ERR;

	int rc = obj_cache_cas_put(c, id, o);

	obj_free(o);
	return rc;
}

/* --- tests ----------------------------------------------------------- */

static void
test_empty_store(void)
{
	struct cas_tree *ct = make_tree("empty");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	check("cache created", c != NULL);
	check("get on empty store is NULL",
		obj_cache_get(c, "nope") == NULL);
	check("nothing pending", obj_cache_cas_pending(c) == 0);
	check("empty commit is a no-op",
		obj_cache_cas_commit(c, NULL) == OBJ_CACHE_OK);

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_put_commit_get(void)
{
	struct cas_tree *ct = make_tree("basic");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	check("put ok",
		put_json(c, "church", "{\"name\":\"A church\"}")
			== OBJ_CACHE_OK);
	check("one pending", obj_cache_cas_pending(c) == 1);

	/* visible through the pending buffer before any commit */
	OBJ *o = obj_cache_get(c, "church");

	check("get before commit", o != NULL);
	if (o) {
		char *v = obj_prop_get(o, "name");
		check("prop before commit", v && strcmp(v, "A church") == 0);
		obj_cache_release(c, o);
	}

	check("commit ok",
		obj_cache_cas_commit(c, "add church") == OBJ_CACHE_OK);
	check("pending drained", obj_cache_cas_pending(c) == 0);

	obj_cache_cas_free(c);

	/* a brand-new cache on the same tree and ref sees the commit */
	c = obj_cache_cas_new(ct, "world", "objs", 4);
	o = obj_cache_get(c, "church");
	check("get after reopen", o != NULL);
	if (o) {
		char *v = obj_prop_get(o, "name");
		check("prop after reopen", v && strcmp(v, "A church") == 0);
		obj_cache_release(c, o);
	}

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_nested_keys(void)
{
	struct cas_tree *ct = make_tree("nested");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 8);

	check("put rooms/church",
		put_json(c, "rooms/church", "{\"name\":\"church\"}")
			== OBJ_CACHE_OK);
	check("put rooms/tavern",
		put_json(c, "rooms/tavern", "{\"name\":\"tavern\"}")
			== OBJ_CACHE_OK);
	check("put programs/anim/fountain",
		put_json(c, "programs/anim/fountain", "{\"name\":\"f\"}")
			== OBJ_CACHE_OK);
	check("commit nested",
		obj_cache_cas_commit(c, "nested") == OBJ_CACHE_OK);
	obj_cache_cas_free(c);

	c = obj_cache_cas_new(ct, "world", "objs", 8);

	OBJ *o = obj_cache_get(c, "programs/anim/fountain");

	check("deep key found", o != NULL);
	if (o)
		obj_cache_release(c, o);

	o = obj_cache_get(c, "rooms/tavern");
	check("sibling key found", o != NULL);
	if (o)
		obj_cache_release(c, o);

	check("missing deep key is NULL",
		obj_cache_get(c, "programs/anim/nope") == NULL);
	check("missing subdir is NULL",
		obj_cache_get(c, "sounds/bell") == NULL);

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_update_and_history(void)
{
	struct cas_tree *ct = make_tree("update");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	put_json(c, "rooms/church", "{\"name\":\"old name\"}");
	obj_cache_cas_commit(c, "first");

	char root1[CAS_HASH_HEX + 1];

	check("ref readable after first commit",
		cas_tree_ref_read(ct, "world", root1) == CAS_OK);

	put_json(c, "rooms/church", "{\"name\":\"new name\"}");
	check("commit update",
		obj_cache_cas_commit(c, "second") == OBJ_CACHE_OK);

	char root2[CAS_HASH_HEX + 1];

	check("ref advanced",
		cas_tree_ref_read(ct, "world", root2) == CAS_OK
		&& strcmp(root1, root2) != 0);
	obj_cache_cas_free(c);

	/* current ref serves the new value */
	c = obj_cache_cas_new(ct, "world", "objs", 4);

	OBJ *o = obj_cache_get(c, "rooms/church");

	check("updated value visible", o != NULL);
	if (o) {
		char *v = obj_prop_get(o, "name");
		check("value is new", v && strcmp(v, "new name") == 0);
		obj_cache_release(c, o);
	}
	obj_cache_cas_free(c);

	/* the old snapshot root is still a valid, readable tree */
	struct cas_tree_entry e;

	check("old snapshot still walks",
		cas_tree_lookup(ct, root1, "objs", &e) == CAS_OK);

	free_tree(ct);
}

static void
test_sibling_domains_share_ref(void)
{
	struct cas_tree *ct = make_tree("siblings");
	OBJ_CACHE *objs = obj_cache_cas_new(ct, "world", "objs", 4);
	OBJ_CACHE *users = obj_cache_cas_new(ct, "world", "users", 4);

	put_json(objs, "rooms/church", "{\"name\":\"church\"}");
	check("commit objs",
		obj_cache_cas_commit(objs, NULL) == OBJ_CACHE_OK);

	put_json(users, "boris", "{\"name\":\"boris\"}");
	check("commit users",
		obj_cache_cas_commit(users, NULL) == OBJ_CACHE_OK);

	/* the second commit must not clobber the first domain */
	OBJ *o = obj_cache_get(objs, "rooms/church");

	check("objs survives users commit", o != NULL);
	if (o)
		obj_cache_release(objs, o);

	o = obj_cache_get(users, "boris");
	check("users readable", o != NULL);
	if (o)
		obj_cache_release(users, o);

	obj_cache_cas_free(objs);
	obj_cache_cas_free(users);
	free_tree(ct);
}

static void
test_dirty_flush_commit(void)
{
	struct cas_tree *ct = make_tree("dirty");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	put_json(c, "rooms/church", "{\"name\":\"church\"}");
	obj_cache_cas_commit(c, "seed");

	/* the normal mutation flow: get, modify, mark dirty, flush */
	OBJ *o = obj_cache_get(c, "rooms/church");

	check("loaded for edit", o != NULL);
	if (o) {
		check("edit prop",
			obj_prop_set(o, "name", "renovated") == OBJ_OK);
		obj_cache_mark_dirty(c, o);
		obj_cache_release(c, o);
	}

	check("flush_all ok", obj_cache_flush_all(c) == OBJ_CACHE_OK);
	check("flush buffered one save", obj_cache_cas_pending(c) == 1);
	check("commit flushed edit",
		obj_cache_cas_commit(c, "edit") == OBJ_CACHE_OK);
	obj_cache_cas_free(c);

	c = obj_cache_cas_new(ct, "world", "objs", 4);
	o = obj_cache_get(c, "rooms/church");
	check("edited object reloads", o != NULL);
	if (o) {
		char *v = obj_prop_get(o, "name");
		check("edit persisted", v && strcmp(v, "renovated") == 0);
		obj_cache_release(c, o);
	}

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_gc_explicit(void)
{
	struct cas_tree *ct = make_tree("gc");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	obj_cache_cas_gc_policy(c, 0, 0);	/* manual GC only */

	/* an orphan: a blob in CAS that no commit ever links */
	char orphan[CAS_HASH_HEX + 1];

	check("orphan blob written",
		cas_put(cas_tree_cas(ct), "orphan", 6, orphan) == CAS_OK);

	put_json(c, "rooms/church", "{\"name\":\"church\"}");
	obj_cache_cas_commit(c, "first");

	char root1[CAS_HASH_HEX + 1];

	cas_tree_ref_read(ct, "world", root1);

	put_json(c, "rooms/church", "{\"name\":\"redone\"}");
	obj_cache_cas_commit(c, "second");

	int removed = -1;

	check("gc ok", obj_cache_cas_gc(c, 0, &removed) == OBJ_CACHE_OK);
	check("gc removed something", removed >= 1);
	check("orphan is gone",
		cas_exists(cas_tree_cas(ct), orphan) == 0);

	/* committed data survives */
	OBJ *o = obj_cache_get(c, "rooms/church");

	check("current object survives gc", o != NULL);
	if (o)
		obj_cache_release(c, o);

	/* superseded snapshots are in the ref log, so they survive too */
	struct cas_tree_entry e;

	check("old snapshot survives gc",
		cas_tree_lookup(ct, root1, "objs", &e) == CAS_OK);

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_gc_threshold(void)
{
	struct cas_tree *ct = make_tree("gcauto");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	obj_cache_cas_gc_policy(c, 2, 0);	/* GC every 2nd commit */

	char orphan[CAS_HASH_HEX + 1];

	cas_put(cas_tree_cas(ct), "orphan2", 7, orphan);

	put_json(c, "a", "{\"name\":\"a\"}");
	obj_cache_cas_commit(c, NULL);
	check("orphan survives first commit",
		cas_exists(cas_tree_cas(ct), orphan) != 0);

	put_json(c, "b", "{\"name\":\"b\"}");
	obj_cache_cas_commit(c, NULL);
	check("threshold gc collected the orphan",
		cas_exists(cas_tree_cas(ct), orphan) == 0);

	/* committed objects still readable after auto gc */
	OBJ *o = obj_cache_get(c, "a");

	check("object survives auto gc", o != NULL);
	if (o)
		obj_cache_release(c, o);

	obj_cache_cas_free(c);
	free_tree(ct);
}

static void
test_parent_links(void)
{
	struct cas_tree *ct = make_tree("parent");
	OBJ_CACHE *objs = obj_cache_cas_new(ct, "world", "objs", 8);
	OBJ_CACHE *chars = obj_cache_cas_new(ct, "world", "chars", 8);

	check("link objs into chars",
		obj_cache_cas_link_parent(chars, "objs", objs)
			== OBJ_CACHE_OK);

	put_json(objs, "templates/goblin",
		"{\"name\":\"goblin\",\"speed\":\"fast\"}");
	put_json(objs, "programs/base", "{\"color\":\"green\"}");
	put_json(objs, "rooms/church",
		"{\"%parent\":\"programs/base\",\"name\":\"church\"}");
	obj_cache_cas_commit(objs, "seed objs");

	put_json(chars, "1",
		"{\"%parent\":\"objs/templates/goblin\","
		"\"name\":\"grik\"}");
	put_json(chars, "2",
		"{\"%parent\":\"objs/templates/goblin\","
		"\"!speed\":\"1\"}");
	obj_cache_cas_commit(chars, "seed chars");

	/* prototype chain crosses into the linked objs cache */
	OBJ *o = obj_cache_get(chars, "1");

	check("char loads", o != NULL);
	if (o) {
		char *v = obj_cache_prop_resolve(chars, o, "speed");

		check("speed inherited across domains",
			v && strcmp(v, "fast") == 0);
		free(v);
		v = obj_cache_prop_resolve(chars, o, "name");
		check("own property wins", v && strcmp(v, "grik") == 0);
		free(v);
		obj_cache_release(chars, o);
	}

	/* a local tombstone stops the cross-domain walk */
	o = obj_cache_get(chars, "2");
	check("tombstoned char loads", o != NULL);
	if (o) {
		char *v = obj_cache_prop_resolve(chars, o, "speed");

		check("tombstone blocks inheritance", v == NULL);
		free(v);
		obj_cache_release(chars, o);
	}

	/* a slashed %parent with an unlinked prefix stays same-domain */
	o = obj_cache_get(objs, "rooms/church");
	check("room loads", o != NULL);
	if (o) {
		char *v = obj_cache_prop_resolve(objs, o, "color");

		check("slashed same-domain parent resolves",
			v && strcmp(v, "green") == 0);
		free(v);
		obj_cache_release(objs, o);
	}

	obj_cache_cas_free(objs);
	obj_cache_cas_free(chars);
	free_tree(ct);
}

static int
count_log_entry(const char *hash, int64_t time_s, int32_t time_ns,
	const char *comment, void *ctx)
{
	(void)hash;
	(void)time_s;
	(void)time_ns;
	(void)comment;
	(*(int *)ctx)++;
	return 0;
}

static void
test_retention(void)
{
	struct cas_tree *ct = make_tree("retain");
	OBJ_CACHE *c = obj_cache_cas_new(ct, "world", "objs", 4);

	obj_cache_cas_gc_policy(c, 1, 0);	/* GC every commit */
	obj_cache_cas_retention(c, 2, 0);	/* keep last 2 snapshots */

	put_json(c, "a", "{\"name\":\"v1\"}");
	obj_cache_cas_commit(c, "v1");

	char root1[CAS_HASH_HEX + 1];

	cas_tree_ref_read(ct, "world", root1);

	for (int i = 2; i <= 5; i++) {
		char json[64];

		snprintf(json, sizeof(json), "{\"name\":\"v%d\"}", i);
		put_json(c, "a", json);
		obj_cache_cas_commit(c, "vN");
	}

	/* the v1 snapshot fell outside the retention window */
	check("pruned root collected",
		cas_exists(cas_tree_cas(ct), root1) == 0);

	int entries = 0;

	cas_tree_log_read(ct, "world", count_log_entry, &entries);
	check("log kept 2 entries", entries == 2);

	/* the current world is intact */
	OBJ *o = obj_cache_get(c, "a");

	check("current object survives retention", o != NULL);
	if (o) {
		char *v = obj_prop_get(o, "name");
		check("current value is newest", v && strcmp(v, "v5") == 0);
		obj_cache_release(c, o);
	}

	obj_cache_cas_free(c);
	free_tree(ct);
}

int
main(void)
{
	if (!mkdtemp(tmpdir)) {
		perror("mkdtemp");
		return EXIT_FAILURE;
	}

	test_empty_store();
	test_put_commit_get();
	test_nested_keys();
	test_update_and_history();
	test_sibling_domains_share_ref();
	test_dirty_flush_commit();
	test_gc_explicit();
	test_gc_threshold();
	test_retention();
	test_parent_links();

	cleanup_tmpdir();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);
	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
