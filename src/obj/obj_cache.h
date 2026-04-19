#ifndef OBJ_CACHE_H_
#define OBJ_CACHE_H_

#include "obj.h"

#define OBJ_CACHE_OK (0)
#define OBJ_CACHE_ERR (-1)
#define OBJ_CACHE_NOTFOUND (-2)

/* Maximum prototype chain depth. Walks that exceed this abort with NULL. */
#define OBJ_CACHE_MAX_PROTO_DEPTH 5

typedef struct obj_cache OBJ_CACHE;

/*
 * Backing-store interface. The cache calls these to load on miss and
 * flush dirty objects on eviction. resolve_parent maps a %parent value
 * (an opaque string -- typically "domain/id" or just "id") to the cache
 * that owns that parent. Returning NULL means "parent lives in this
 * cache"; the walker then does obj_cache_get on the same cache.
 */
struct obj_cache_ops {
	OBJ *(*load)(void *ctx, const char *id);
	int (*save)(void *ctx, const char *id, OBJ *obj);
	/* may be NULL -- if NULL, %parent values are always looked up in
	 * the same cache. */
	OBJ_CACHE *(*resolve_parent_cache)(void *ctx, const char *parent_ref,
		const char **out_id);
};

OBJ_CACHE *obj_cache_new(unsigned max_unreferenced,
	const struct obj_cache_ops *ops, void *ctx);
void obj_cache_free(OBJ_CACHE *c);

/*
 * Acquire a pinned reference to the object with the given id. Loads via
 * ops->load on miss. Returns NULL if not found or on error. Caller must
 * call obj_cache_release when done.
 */
OBJ *obj_cache_get(OBJ_CACHE *c, const char *id);

/* Release a pinned reference. When refcount hits zero, the object moves
 * to the LRU and is eligible for eviction. */
void obj_cache_release(OBJ_CACHE *c, OBJ *obj);

/* Mark obj as dirty; it will be saved before eviction or on flush_all. */
void obj_cache_mark_dirty(OBJ_CACHE *c, OBJ *obj);

/* Save all dirty objects via ops->save. Returns OBJ_CACHE_OK on full
 * success, OBJ_CACHE_ERR if any save failed. */
int obj_cache_flush_all(OBJ_CACHE *c);

/*
 * Resolve a property via the prototype chain. Starts at obj, then walks
 * %parent up to OBJ_CACHE_MAX_PROTO_DEPTH levels. Stops and returns NULL
 * if a tombstone ("!propname") is encountered. Returns a strdup'd value
 * (caller frees) or NULL if unset/tombstoned/missing.
 *
 * obj must already be pinned by the caller. The walker pins/releases
 * intermediate parents internally.
 */
char *obj_cache_prop_resolve(OBJ_CACHE *c, OBJ *obj, const char *propname);

/* Test/debug helpers. */
unsigned obj_cache_size(OBJ_CACHE *c);     /* total objects held */
unsigned obj_cache_lru_count(OBJ_CACHE *c); /* unreferenced count */

/* Retrieve the ctx pointer passed to obj_cache_new. Used by backend
 * shims (e.g. obj_cache_muddb) to reach their own state. */
void *obj_cache_ctx(OBJ_CACHE *c);

#endif
