/* unit test for entity.c */
#define LOG_SUBSYSTEM "test_entity"

#include "entity.h"
#include "obj_cache.h"
#include "obj.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int pass_count, fail_count;

static inline void
check(const char *desc, bool e)
{
	if (e) { LOG_INFO("%s: PASSED", desc); pass_count++; }
	else   { LOG_ERROR("%s: FAILED", desc); fail_count++; }
}

/* --- mock backend ---------------------------------------------------- */

#define MAX_STORE 16

struct mock_record { char *id; char *json; };
struct mock_backend {
	struct mock_record records[MAX_STORE];
	int count;
};

static struct mock_record *
mock_find(struct mock_backend *m, const char *id)
{
	for (int i = 0; i < m->count; i++)
		if (strcmp(m->records[i].id, id) == 0) return &m->records[i];
	return NULL;
}

static void
mock_put(struct mock_backend *m, const char *id, const char *json)
{
	struct mock_record *r = mock_find(m, id);
	if (r) { free(r->json); r->json = strdup(json); return; }
	m->records[m->count].id = strdup(id);
	m->records[m->count].json = strdup(json);
	m->count++;
}

static OBJ *
mock_load(void *ctx, const char *id)
{
	struct mock_backend *m = ctx;
	struct mock_record *r = mock_find(m, id);
	if (!r) return NULL;
	return obj_new_from_json(id, r->json);
}

static int
mock_save(void *ctx, const char *id, OBJ *obj)
{
	struct mock_backend *m = ctx;
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
test_load_unload(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "hero", "{\"%kind\":\"pc\",\"name\":\"Hero\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	struct entity e;
	int rc = entity_load(&e, c, "hero");
	check("entity_load ok", rc == 0);
	check("kind is PC", e.kind == ENTITY_KIND_PC);
	check("id stored", e.id && strcmp(e.id, "hero") == 0);
	check("obj pinned", e.obj != NULL);

	entity_unload(&e);
	check("after unload obj NULL", e.obj == NULL);
	check("after unload id NULL", e.id == NULL);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_load_missing(void)
{
	struct mock_backend m = {0};
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	struct entity e;
	int rc = entity_load(&e, c, "nope");
	check("entity_load missing fails", rc == -1);

	obj_cache_free(c);
	mock_free(&m);
}

static void
test_kind_parsing(void)
{
	check("pc",       entity_kind_from_name("pc") == ENTITY_KIND_PC);
	check("npc",      entity_kind_from_name("npc") == ENTITY_KIND_NPC);
	check("creature", entity_kind_from_name("creature") == ENTITY_KIND_CREATURE);
	check("PC case",  entity_kind_from_name("PC") == ENTITY_KIND_PC);
	check("junk",     entity_kind_from_name("junk") == ENTITY_KIND_UNKNOWN);
	check("null",     entity_kind_from_name(NULL) == ENTITY_KIND_UNKNOWN);
	check("name pc",  strcmp(entity_kind_name(ENTITY_KIND_PC), "pc") == 0);
	check("name npc", strcmp(entity_kind_name(ENTITY_KIND_NPC), "npc") == 0);
}

static void
test_prop_resolve_inheritance(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "goblin-template",
		"{\"%kind\":\"creature\",\"hp\":\"10\",\"name\":\"goblin\"}");
	mock_put(&m, "gob1",
		"{\"%kind\":\"creature\",\"%parent\":\"goblin-template\",\"name\":\"Gob-1\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	struct entity e;
	check("load gob1", entity_load(&e, c, "gob1") == 0);

	char *name = entity_prop_resolve(&e, "name");
	check("own name wins", name && strcmp(name, "Gob-1") == 0);
	free(name);

	char *hp = entity_prop_resolve(&e, "hp");
	check("inherited hp", hp && strcmp(hp, "10") == 0);
	free(hp);

	char *missing = entity_prop_resolve(&e, "nothere");
	check("missing null", missing == NULL);

	entity_unload(&e);
	obj_cache_free(c);
	mock_free(&m);
}

static void
test_save_marks_dirty(void)
{
	struct mock_backend m = {0};
	mock_put(&m, "hero", "{\"%kind\":\"pc\",\"name\":\"Hero\"}");
	struct obj_cache_ops ops = { .load = mock_load, .save = mock_save };
	OBJ_CACHE *c = obj_cache_new(4, &ops, &m);

	struct entity e;
	entity_load(&e, c, "hero");
	obj_prop_set(e.obj, "name", "NewName");
	int rc = entity_save(&e);
	check("entity_save ok", rc == 0);

	/* flush and confirm backing store updated */
	obj_cache_flush_all(c);
	struct mock_record *r = mock_find(&m, "hero");
	check("backing store has NewName",
		r && strstr(r->json, "NewName") != NULL);

	entity_unload(&e);
	obj_cache_free(c);
	mock_free(&m);
}

int
main(void)
{
	log_init();
	test_kind_parsing();
	test_load_unload();
	test_load_missing();
	test_prop_resolve_inheritance();
	test_save_marks_dirty();
	printf("\n%d passed, %d failed\n", pass_count, fail_count);
	return fail_count ? 1 : 0;
}
