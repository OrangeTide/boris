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

#include <log.h>

static OBJ_CACHE *obj_global_cache;

int
obj_initialize(struct muddb *db, unsigned cache_size)
{
	obj_global_cache = obj_cache_muddb_new(db, "objs", cache_size);
	if (!obj_global_cache) {
		LOG_ERROR("could not create object cache");
		return -1;
	}
	LOG_INFO("Object cache loaded.");
	return 0;
}

void
obj_shutdown(void)
{
	if (obj_global_cache) {
		obj_cache_flush_all(obj_global_cache);
		obj_cache_free(obj_global_cache);
		obj_global_cache = NULL;
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
