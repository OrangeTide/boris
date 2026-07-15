/* obj_store.c : global object cache backed by muddb */
/* Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS.
 */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "obj"
#endif

#include "obj.h"
#include "obj_cache.h"
#include "obj_cache_muddb.h"
#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>

#include <log.h>

static OBJ_CACHE *obj_global_cache;

/* CAS backend state; NULL when the muddb backend is active */
static struct cas *obj_cas_store;
static struct cas_tree *obj_cas_tree;

int
obj_initialize(struct muddb *db, unsigned cache_size)
{
	obj_global_cache = obj_cache_muddb_new(db, "objs", cache_size);
	if (!obj_global_cache) {
		LOG_ERROR("could not create object cache");
		return -1;
	}
	LOG_INFO("Object cache loaded (muddb backend).");
	return 0;
}

int
obj_initialize_cas(const char *depot_path, const char *ref,
	unsigned cache_size, unsigned retain)
{
	obj_cas_store = cas_new(depot_path);
	if (!obj_cas_store) {
		LOG_ERROR("could not open CAS depot at %s", depot_path);
		return -1;
	}

	obj_cas_tree = cas_tree_new(obj_cas_store);
	if (!obj_cas_tree) {
		LOG_ERROR("could not create CAS tree");
		cas_free(obj_cas_store);
		obj_cas_store = NULL;
		return -1;
	}
	cas_tree_set_flags(obj_cas_tree, CAS_TREE_USE_HTREE);

	obj_global_cache = obj_cache_cas_new(obj_cas_tree, ref, "objs",
		cache_size);
	if (!obj_global_cache) {
		LOG_ERROR("could not create object cache");
		cas_tree_free(obj_cas_tree);
		cas_free(obj_cas_store);
		obj_cas_tree = NULL;
		obj_cas_store = NULL;
		return -1;
	}
	if (retain > 0)
		obj_cache_cas_retention(obj_global_cache, (int)retain, 0);
	LOG_INFO("Object cache loaded (cas backend, depot %s, ref %s,"
		" retain %u).", depot_path, ref, retain);
	return 0;
}

void
obj_commit(void)
{
	if (!obj_global_cache || !obj_cas_tree)
		return;	/* muddb backend saves on evict; nothing to do */
	if (obj_cache_flush_all(obj_global_cache) != OBJ_CACHE_OK)
		LOG_ERROR("object flush failed");
	if (obj_cache_cas_pending(obj_global_cache) > 0
		&& obj_cache_cas_commit(obj_global_cache, "periodic")
			!= OBJ_CACHE_OK)
		LOG_ERROR("object commit failed");
}

void
obj_shutdown(void)
{
	if (obj_global_cache) {
		obj_cache_flush_all(obj_global_cache);
		if (obj_cas_tree) {
			obj_cache_cas_commit(obj_global_cache, "shutdown");
			obj_cache_cas_free(obj_global_cache);
		} else {
			obj_cache_free(obj_global_cache);
		}
		obj_global_cache = NULL;
	}
	if (obj_cas_tree) {
		cas_tree_free(obj_cas_tree);
		obj_cas_tree = NULL;
	}
	if (obj_cas_store) {
		cas_free(obj_cas_store);
		obj_cas_store = NULL;
	}
	LOG_INFO("Object cache ended.");
}

OBJ *
obj_get(const char *id)
{
	if (!id)
		return NULL;
	return obj_cache_get(obj_global_cache, id);
}

void
obj_release(OBJ *obj)
{
	if (obj)
		obj_cache_release(obj_global_cache, obj);
}

void
obj_set_load_cb(obj_notify_fn cb, void *arg)
{
	obj_cache_set_load_cb(obj_global_cache,
	                      (obj_cache_notify_fn)cb, arg);
}

void
obj_set_evict_cb(obj_notify_fn cb, void *arg)
{
	obj_cache_set_evict_cb(obj_global_cache,
	                       (obj_cache_notify_fn)cb, arg);
}
