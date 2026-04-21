/* unit test for obj_cache.c */
#define LOG_SUBSYSTEM "test_obj_cache"

#include "obj_cache.h"
#include "obj.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
	mock_put(&m, "child", "{\"%parent\":\"base\",\"color\":\"blue\"}");
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
	mock_put(&m, "child", "{\"%parent\":\"base\",\"!name\":1}");
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
	mock_put(&m, "n5", "{\"%parent\":\"n6\"}");
	mock_put(&m, "n4", "{\"%parent\":\"n5\"}");
	mock_put(&m, "n3", "{\"%parent\":\"n4\"}");
	mock_put(&m, "n2", "{\"%parent\":\"n3\"}");
	mock_put(&m, "n1", "{\"%parent\":\"n2\"}");
	mock_put(&m, "n0", "{\"%parent\":\"n1\"}");
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

	printf("PASS: %d  FAIL: %d\n", pass_count, fail_count);
	return fail_count ? 1 : 0;
}
