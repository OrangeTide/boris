/**
 * @file entity.c
 *
 * RPG-capable entity layered on obj_cache. See entity.h and
 * doc/entity-system.md.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
 */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "entity"
#endif

#include "entity.h"
#include "obj.h"
#include "obj_cache.h"

#include <log.h>

#include <stdlib.h>
#include <string.h>
#include <strings.h>

static const char *kind_names[] = {
	[ENTITY_KIND_UNKNOWN]  = "unknown",
	[ENTITY_KIND_PC]       = "pc",
	[ENTITY_KIND_NPC]      = "npc",
	[ENTITY_KIND_CREATURE] = "creature",
};

enum entity_kind
entity_kind_from_name(const char *s)
{
	if (!s) return ENTITY_KIND_UNKNOWN;
	if (!strcasecmp(s, "pc")) return ENTITY_KIND_PC;
	if (!strcasecmp(s, "npc")) return ENTITY_KIND_NPC;
	if (!strcasecmp(s, "creature")) return ENTITY_KIND_CREATURE;
	return ENTITY_KIND_UNKNOWN;
}

const char *
entity_kind_name(enum entity_kind k)
{
	if (k < 0 || (unsigned)k >= sizeof(kind_names)/sizeof(kind_names[0]))
		return "unknown";
	return kind_names[k];
}

int
entity_load(struct entity *e, OBJ_CACHE *cache, const char *id)
{
	if (!e || !cache || !id) return -1;
	memset(e, 0, sizeof(*e));
	OBJ *obj = obj_cache_get(cache, id);
	if (!obj) return -1;
	e->id = strdup(id);
	if (!e->id) { obj_cache_release(cache, obj); return -1; }
	e->cache = cache;
	e->obj = obj;
	char *kind_str = obj_prop_get(obj, "%kind");
	e->kind = entity_kind_from_name(kind_str);
	return 0;
}

int
entity_save(struct entity *e)
{
	if (!e || !e->obj || !e->cache) return -1;
	/* Typed fields flush here when the RPG retargeting lands.
	 * For now we only mark dirty -- callers may have mutated obj
	 * directly via obj_prop_set. */
	obj_cache_mark_dirty(e->cache, e->obj);
	return 0;
}

void
entity_unload(struct entity *e)
{
	if (!e) return;
	if (e->obj && e->cache) obj_cache_release(e->cache, e->obj);
	free(e->id);
	memset(e, 0, sizeof(*e));
}

int
entity_create(struct entity *e, OBJ_CACHE *cache, const char *id,
	enum entity_kind kind, const char *template_ref)
{
	if (!e || !cache || !id) return -1;
	if (entity_load(e, cache, id) == 0) {
		LOG_ERROR("entity_create: id=%s already exists", id);
		entity_unload(e);
		return -1;
	}
	/* Backend may or may not auto-create on first get. We synthesize
	 * via obj_new + prime the cache by saving, then load it. To keep
	 * this simple, require callers to pre-insert the record if the
	 * backend is load-on-miss only. */
	OBJ *obj = obj_new(id);
	if (!obj) return -1;
	if (obj_prop_set_internal(obj, "%kind", entity_kind_name(kind))
		!= OBJ_OK) goto fail;
	if (template_ref
		&& obj_prop_set_internal(obj, "%parent", template_ref)
		!= OBJ_OK) goto fail;

	/* Inject into cache by saving through the backend then loading. */
	/* Simpler path: inject directly using a small trick -- we require
	 * the caller's backend to accept puts. We use obj_cache via a put
	 * through the save vtable by marking it dirty then flushing. But
	 * cache doesn't offer "insert". So: drop this entity's obj into
	 * the backend via a direct save-equivalent is not exposed either.
	 *
	 * Instead: most callers will have seeded the record through
	 * muddb_put (or the test backend) before calling entity_load.
	 * We fail here and direct users to that path. */
	obj_free(obj);
	LOG_ERROR("entity_create: cache doesn't support insert-on-create;"
		" seed the backend directly then call entity_load");
	return -1;
fail:
	obj_free(obj);
	return -1;
}

char *
entity_prop_resolve(struct entity *e, const char *propname)
{
	if (!e || !e->obj || !e->cache) return NULL;
	return obj_cache_prop_resolve(e->cache, e->obj, propname);
}
