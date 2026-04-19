#ifndef ENTITY_H_
#define ENTITY_H_

#include "obj.h"
#include "obj_cache.h"

/**
 * @file entity.h
 *
 * RPG-capable entity. PC/NPC/creature wrapper structs embed this so
 * the RPG APIs can operate on any of them uniformly. See
 * doc/entity-system.md.
 */

enum entity_kind {
	ENTITY_KIND_UNKNOWN = 0,
	ENTITY_KIND_PC,
	ENTITY_KIND_NPC,
	ENTITY_KIND_CREATURE
};

struct entity {
	char *id;
	enum entity_kind kind;
	OBJ *obj;          /* pinned in cache; NULL if detached */
	OBJ_CACHE *cache;  /* cache holding obj */

	/* typed RPG fields land here as phases mature. Kept empty for now
	 * so callers can start using entity_import/export without churn
	 * when fields appear. */
};

/* Parse "pc" / "npc" / "creature"; returns ENTITY_KIND_UNKNOWN otherwise. */
enum entity_kind entity_kind_from_name(const char *s);
const char *entity_kind_name(enum entity_kind k);

/*
 * Pin the record with id `id` from cache and populate `e`. On
 * success e owns a cache pin and must be released via entity_unload.
 * Returns 0 on success, -1 if the id is not found.
 */
int entity_load(struct entity *e, OBJ_CACHE *cache, const char *id);

/*
 * Flush any typed-field changes back to the underlying obj (via
 * obj_prop_set_*) and mark the obj dirty. Does not commit to muddb;
 * call obj_cache_flush_all to persist.
 */
int entity_save(struct entity *e);

/* Release the cache pin and clear the struct. Safe on an already
 * cleared entity. */
void entity_unload(struct entity *e);

/*
 * Create a new instance record in the given cache, parented to
 * template_ref (may be NULL for a freestanding entity). Writes %kind
 * and %parent (if any) via the privileged setters. Returns 0 and
 * populates e on success; caller owns a pin and must entity_unload.
 *
 * Note: this calls obj_cache_mark_dirty. Caller is responsible for
 * flushing if they want the new record to be durable.
 */
int entity_create(struct entity *e, OBJ_CACHE *cache, const char *id,
	enum entity_kind kind, const char *template_ref);

/*
 * Resolve a property through the prototype chain. Convenience wrapper
 * over obj_cache_prop_resolve. Returns a strdup'd string (caller
 * frees) or NULL.
 */
char *entity_prop_resolve(struct entity *e, const char *propname);

#endif
