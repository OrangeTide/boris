/**
 * @file obj_cache_muddb.c
 *
 * Thin bridge between obj_cache and muddb: exposes a muddb domain as
 * the load/save backend for an obj_cache, and routes %parent lookups
 * across sibling caches when they reference another domain.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
 */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "obj_cache_muddb"
#endif

#include "obj_cache_muddb.h"
#include "muddb.h"

#include <log.h>

#include <stdlib.h>
#include <string.h>

#define MAX_PARENT_LINKS 8

struct parent_link {
	char *domain;     /* e.g. "templates" -- matches "templates/" prefix */
	size_t domain_len;
	OBJ_CACHE *cache;
};

struct bridge {
	MUDDB *db;
	char *domain;
	struct parent_link links[MAX_PARENT_LINKS];
	int link_count;
	OBJ_CACHE *self; /* back-pointer for parent resolution fallback */
};

static OBJ *
bridge_load(void *ctx, const char *id)
{
	struct bridge *b = ctx;
	return muddb_get(b->db, b->domain, id);
}

static int
bridge_save(void *ctx, const char *id, OBJ *obj)
{
	struct bridge *b = ctx;
	return muddb_put(b->db, b->domain, id, obj);
}

static OBJ_CACHE *
bridge_resolve_parent(void *ctx, const char *parent_ref, const char **out_id)
{
	struct bridge *b = ctx;
	const char *slash = strchr(parent_ref, '/');
	if (slash) {
		size_t dlen = (size_t)(slash - parent_ref);
		for (int i = 0; i < b->link_count; i++) {
			if (b->links[i].domain_len == dlen
				&& memcmp(b->links[i].domain, parent_ref, dlen) == 0) {
				*out_id = slash + 1;
				return b->links[i].cache;
			}
		}
		LOG_ERROR("unlinked parent domain in %%parent=%s", parent_ref);
		return NULL;
	}
	/* no slash -- same cache, same domain */
	return NULL;
}

OBJ_CACHE *
obj_cache_muddb_new(MUDDB *db, const char *domain, unsigned max_unreferenced)
{
	if (!db || !domain) return NULL;
	struct bridge *b = calloc(1, sizeof(*b));
	if (!b) return NULL;
	b->db = db;
	b->domain = strdup(domain);
	if (!b->domain) { free(b); return NULL; }
	struct obj_cache_ops ops = {
		.load = bridge_load,
		.save = bridge_save,
		.resolve_parent_cache = bridge_resolve_parent,
	};
	OBJ_CACHE *c = obj_cache_new(max_unreferenced, &ops, b);
	if (!c) { free(b->domain); free(b); return NULL; }
	b->self = c;
	return c;
}

/*
 * NOTE: bridge storage currently leaks on obj_cache_free because the
 * cache doesn't notify the ctx on teardown. For the global caches
 * created at boot this is fine (lives for the process lifetime).
 * If short-lived bridges are ever needed, add a destroy hook.
 */

int
obj_cache_muddb_link_parent(OBJ_CACHE *c, const char *domain,
	OBJ_CACHE *parent_cache)
{
	if (!c || !domain || !parent_cache) return OBJ_CACHE_ERR;
	struct bridge *b = obj_cache_ctx(c);
	if (!b) return OBJ_CACHE_ERR;
	if (b->link_count >= MAX_PARENT_LINKS) {
		LOG_ERROR("too many parent links");
		return OBJ_CACHE_ERR;
	}
	b->links[b->link_count].domain = strdup(domain);
	if (!b->links[b->link_count].domain) return OBJ_CACHE_ERR;
	b->links[b->link_count].domain_len = strlen(domain);
	b->links[b->link_count].cache = parent_cache;
	b->link_count++;
	return OBJ_CACHE_OK;
}
