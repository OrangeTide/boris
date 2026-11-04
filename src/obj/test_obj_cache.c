/* unit test for obj_cache.c */
#define LOG_SUBSYSTEM "test_obj_cache"

#include "obj_cache.h"
#include "obj.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ctest.h"

/* --- mock backend ---------------------------------------------------- */

#define MAX_STORE 32

struct mock_record {
	char *id;
	char *json;
};

struct mock_backend {
	struct mock_record records[MAX_STORE];
	int count;
	int load_calls;
	int save_calls;
};

static struct mock_record *
mock_find(struct mock_backend *m, const char *id)
{
	for (int i = 0; i < m->count; i++)
		if (strcmp(m->records[i].id, id) == 0)
			return &m->records[i];
	return NULL;
}

static void
mock_put(struct mock_backend *m, const char *id, const char *json)
{
	struct mock_record *r = mock_find(m, id);
	if (r) {
		free(r->json);
		r->json = strdup(json);
		return;
	}
	m->records[m->count].id = strdup(id);
	m->records[m->count].json = strdup(json);
	m->count++;
}

static OBJ *
mock_load(void *ctx, const char *id)
{
	struct mock_backend *m = ctx;
	m->load_calls++;
	struct mock_record *r = mock_find(m, id);
	if (!r) return NULL;
	return obj_new_from_json(id, r->json);
}

static int
mock_save(void *ctx, const char *id, OBJ *obj)
{
	struct mock_backend *m = ctx;
	m->save_calls++;
	char buf[1024];
	if (obj_get_json(obj, buf, sizeof(buf), NULL) < 0) return -1;
	mock_put(m, id, buf);
	return 0;
}

static int
mock_del(void *ctx, const char *id)
{
	struct mock_backend *m = ctx;
	for (int i = 0; i < m->count; i++) {
		if (strcmp(m->records[i].id, id) == 0) {
			free(m->records[i].id);
			free(m->records[i].json);
			m->records[i] = m->records[--m->count];
			return 0;
		}
	}
	return 0;       /* missing key is success, like muddb */
}

static void
mock_free(struct mock_backend *m)
{
	for (int i = 0; i < m->count; i++) {
		free(m->records[i].id);
		free(m->records[i].json);
	}
	m->count = 0;
}

/* --- tests ----------------------------------------------------------- */

static void
test_basic_get_release(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "foo", "{\"name\":\"foo-name\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);
	check("cache created", c != NULL);

	OBJ *o1 = obj_cache_get(c, "foo");
	check("loaded foo", o1 != NULL);
	check("load called once", m.load_calls == 1);
	check("size is 1", obj_cache_size(c) == 1);
	check("lru empty (pinned)", obj_cache_lru_count(c) == 0);

	/* second get should hit cache, not reload */
	OBJ *o2 = obj_cache_get(c, "foo");
	check("same ptr on 2nd get", o1 == o2);
	check("load NOT called again", m.load_calls == 1);

	obj_cache_release(c, o1);
	check("still pinned after 1 release", obj_cache_lru_count(c) == 0);
	obj_cache_release(c, o2);
	check("in LRU after full release", obj_cache_lru_count(c) == 1);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_eviction(void)
{
	struct mock_backend m = {0};
	for (int i = 0; i < 5; i++) {
		char id[8], json[32];
		snprintf(id, sizeof(id), "r%d", i);
		snprintf(json, sizeof(json), "{\"n\":%d}", i);
		mock_put(&m, id, json);
	}
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(2, &ops, &m);

	OBJ *o[5];
	for (int i = 0; i < 5; i++) {
		char id[8];
		snprintf(id, sizeof(id), "r%d", i);
		o[i] = obj_cache_get(c, id);
	}
	check("all 5 loaded", obj_cache_size(c) == 5);
	for (int i = 0; i < 5; i++) obj_cache_release(c, o[i]);
	check("LRU capped at max_unref=2", obj_cache_lru_count(c) == 2);
	check("total shrunk to 2", obj_cache_size(c) == 2);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_dirty_save_on_evict(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "a", "{\"k\":\"v\"}");
	mock_put(&m, "b", "{\"k\":\"v\"}");
	mock_put(&m, "c", "{\"k\":\"v\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(1, &ops, &m);

	OBJ *a = obj_cache_get(c, "a");
	obj_prop_set(a, "k", "modified");
	obj_cache_mark_dirty(c, a);
	obj_cache_release(c, a); /* in LRU, dirty */

	OBJ *b = obj_cache_get(c, "b");
	obj_cache_release(c, b); /* in LRU, clean, evicts 'a' */

	OBJ *cc = obj_cache_get(c, "c");
	obj_cache_release(c, cc); /* evicts 'b' */

	check("dirty 'a' was saved on evict", m.save_calls == 1);
	struct mock_record *r = mock_find(&m, "a");
	check("saved content reflects mutation",
		r && strstr(r->json, "modified") != NULL);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_prop_resolve_local(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "x", "{\"name\":\"local\"}");
	struct obj_cache_ops ops = { .load = mock_load };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *o = obj_cache_get(c, "x");
	char *v = obj_cache_prop_resolve(c, o, "name");
	check("resolved local", v && strcmp(v, "local") == 0);
	free(v);
	obj_cache_release(c, o);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_prop_resolve_inherited(void)
{
	struct mock_backend m = {0};
	/* parent has name, child has only %parent */
	mock_put(&m, "base", "{\"name\":\"base-name\",\"color\":\"red\"}");
	mock_put(&m, "child", "{\"%parent~\":\"base\",\"color\":\"blue\"}");
	struct obj_cache_ops ops = { .load = mock_load };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *o = obj_cache_get(c, "child");
	char *n = obj_cache_prop_resolve(c, o, "name");
	check("inherited name from parent", n && strcmp(n, "base-name") == 0);
	free(n);
	char *col = obj_cache_prop_resolve(c, o, "color");
	check("local color overrides parent",
		col && strcmp(col, "blue") == 0);
	free(col);
	obj_cache_release(c, o);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_prop_resolve_tombstone(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "base", "{\"name\":\"base-name\"}");
	mock_put(&m, "child", "{\"%parent~\":\"base\",\"!name\":1}");
	struct obj_cache_ops ops = { .load = mock_load };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *o = obj_cache_get(c, "child");
	char *n = obj_cache_prop_resolve(c, o, "name");
	check("tombstone hides parent value", n == NULL);
	free(n);
	obj_cache_release(c, o);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_prop_resolve_depth_limit(void)
{
	struct mock_backend m = {0};
	/* chain 0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6; name only at depth 6.
	 * MAX_PROTO_DEPTH is 5, so it should NOT resolve. */
	mock_put(&m, "n6", "{\"name\":\"deep\"}");
	mock_put(&m, "n5", "{\"%parent~\":\"n6\"}");
	mock_put(&m, "n4", "{\"%parent~\":\"n5\"}");
	mock_put(&m, "n3", "{\"%parent~\":\"n4\"}");
	mock_put(&m, "n2", "{\"%parent~\":\"n3\"}");
	mock_put(&m, "n1", "{\"%parent~\":\"n2\"}");
	mock_put(&m, "n0", "{\"%parent~\":\"n1\"}");
	struct obj_cache_ops ops = { .load = mock_load };
	OBJ_CACHE *c = obj_cache_new(16, &ops, &m);

	OBJ *o = obj_cache_get(c, "n0");
	char *n = obj_cache_prop_resolve(c, o, "name");
	check("too-deep chain returns NULL", n == NULL);
	free(n);
	obj_cache_release(c, o);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_flush_all(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "a", "{\"k\":\"v\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *a = obj_cache_get(c, "a");
	obj_prop_set(a, "k", "changed");
	obj_cache_mark_dirty(c, a);
	int rc = obj_cache_flush_all(c);
	check("flush_all ok", rc == OBJ_CACHE_OK);
	check("saved once", m.save_calls == 1);
	/* second flush -- clean now, no extra save */
	obj_cache_flush_all(c);
	check("clean -> no extra save", m.save_calls == 1);
	obj_cache_release(c, a);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_missing_key(void)
{
	struct mock_backend m = {0};
	struct obj_cache_ops ops = { .load = mock_load };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);
	OBJ *o = obj_cache_get(c, "does-not-exist");
	check("missing returns NULL", o == NULL);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_create_and_flush(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "seeded", "{\"k\":\"v\"}");
	struct obj_cache_ops ops = {
		.load = mock_load, .save = mock_save, .del = mock_del,
	};
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *o = obj_cache_create(c, "fresh");
	check("create returns an object", o != NULL);
	check("nothing saved yet", m.save_calls == 0);
	check("in cache", obj_cache_size(c) == 1);

	/* creating over a cached id, or a persisted-but-uncached id, fails */
	check("create over cached id fails", obj_cache_create(c, "fresh") == NULL);
	check("create over persisted id fails",
		obj_cache_create(c, "seeded") == NULL);

	obj_prop_set(o, "k", "v");
	obj_cache_release(c, o);
	check("flush persists the created object",
		obj_cache_flush_all(c) == OBJ_CACHE_OK);
	check("saved once", m.save_calls == 1);
	check("record now in backend", mock_find(&m, "fresh") != NULL);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_destroy(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "gone", "{\"k\":\"v\"}");
	struct obj_cache_ops ops = {
		.load = mock_load, .save = mock_save, .del = mock_del,
	};
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	/* destroy a persisted object that is not currently cached */
	check("destroy persisted-only ok",
		obj_cache_destroy(c, "gone") == OBJ_CACHE_OK);
	check("removed from backend", mock_find(&m, "gone") == NULL);

	/* create, release, destroy */
	OBJ *o = obj_cache_create(c, "tmp");
	obj_cache_release(c, o);
	check("destroy unpinned cached ok",
		obj_cache_destroy(c, "tmp") == OBJ_CACHE_OK);
	check("dropped from cache", obj_cache_size(c) == 0);

	/* a pinned object cannot be destroyed */
	OBJ *p = obj_cache_create(c, "pin");
	check("destroy pinned fails",
		obj_cache_destroy(c, "pin") == OBJ_CACHE_ERR);
	check("still cached after refused destroy", obj_cache_size(c) == 1);
	obj_cache_release(c, p);
	check("destroy after release ok",
		obj_cache_destroy(c, "pin") == OBJ_CACHE_OK);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_destroy_no_del_op(void)
{
	struct mock_backend m = {0};
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	OBJ *o = obj_cache_create(c, "x");
	obj_cache_release(c, o);
	check("destroy without a del op fails",
		obj_cache_destroy(c, "x") == OBJ_CACHE_ERR);
	check("refused destroy left it in cache", obj_cache_size(c) == 1);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_forget(void)
{
	struct mock_backend m = {0};
	struct obj_cache_ops ops = {
		.load = mock_load, .save = mock_save, .del = mock_del,
	};
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	/* forget a freshly created object while still holding its only pin */
	OBJ *o = obj_cache_create(c, "scratch");
	check("created scratch", o != NULL);
	check("forget while pinned ok",
		obj_cache_forget(c, "scratch") == OBJ_CACHE_OK);
	check("dropped from cache", obj_cache_size(c) == 0);
	check("never saved to backend",
		m.save_calls == 0 && mock_find(&m, "scratch") == NULL);

	/* a shared object (refcount > 1) is refused */
	mock_put(&m, "shared", "{}");
	OBJ *a = obj_cache_get(c, "shared");
	OBJ *b = obj_cache_get(c, "shared");
	check("forget shared refused",
		obj_cache_forget(c, "shared") == OBJ_CACHE_ERR);
	check("shared still cached", obj_cache_size(c) == 1);
	obj_cache_release(c, a);
	obj_cache_release(c, b);

	/* forgetting an uncached id is a no-op success */
	check("forget uncached ok", obj_cache_forget(c, "nope") == OBJ_CACHE_OK);

	obj_cache_free(c);
	mock_free(&m);
}

int
main(void)
{
	test_basic_get_release();
	test_eviction();
	test_dirty_save_on_evict();
	test_prop_resolve_local();
	test_prop_resolve_inherited();
	test_prop_resolve_tombstone();
	test_prop_resolve_depth_limit();
	test_flush_all();
	test_missing_key();
	test_create_and_flush();
	test_destroy();
	test_destroy_no_del_op();
	test_forget();

	return ctest_report("test_obj_cache");
}
