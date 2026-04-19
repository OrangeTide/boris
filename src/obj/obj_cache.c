/**
 * @file obj_cache.c
 *
 * Shared LRU cache + prototype-walking loader for OBJ-backed stores.
 * Sits between muddb (or any load/save backend via ops) and callers
 * like room/character/entity caches.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
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
#define LOG_SUBSYSTEM "obj_cache"
#endif

#include "obj_cache.h"
#include "obj.h"
#include "hashtable.h"

#include <log.h>

#include <stdlib.h>
#include <string.h>

struct cache_entry {
	char *id;
	OBJ *obj;
	int refcount;
	int dirty;
	struct cache_entry *lru_prev, *lru_next;
	OBJ_CACHE *owner;
};

struct obj_cache {
	struct ht_str ht;
	unsigned max_unref;
	unsigned total;
	unsigned unref_count;
	/* LRU: head is most-recently unreferenced, tail is oldest. */
	struct cache_entry *lru_head, *lru_tail;
	struct obj_cache_ops ops;
	void *ctx;
};

/* --- LRU helpers ----------------------------------------------------- */

static void
lru_unlink(OBJ_CACHE *c, struct cache_entry *e)
{
	if (e->lru_prev) e->lru_prev->lru_next = e->lru_next;
	else c->lru_head = e->lru_next;
	if (e->lru_next) e->lru_next->lru_prev = e->lru_prev;
	else c->lru_tail = e->lru_prev;
	e->lru_prev = e->lru_next = NULL;
	c->unref_count--;
}

static void
lru_push_head(OBJ_CACHE *c, struct cache_entry *e)
{
	e->lru_prev = NULL;
	e->lru_next = c->lru_head;
	if (c->lru_head) c->lru_head->lru_prev = e;
	c->lru_head = e;
	if (!c->lru_tail) c->lru_tail = e;
	c->unref_count++;
}

static int
flush_entry(OBJ_CACHE *c, struct cache_entry *e)
{
	if (!e->dirty) return OBJ_CACHE_OK;
	if (!c->ops.save) return OBJ_CACHE_OK;
	if (c->ops.save(c->ctx, e->id, e->obj) != 0) {
		LOG_ERROR("save failed for id=%s", e->id);
		return OBJ_CACHE_ERR;
	}
	e->dirty = 0;
	return OBJ_CACHE_OK;
}

static void
drop_entry(OBJ_CACHE *c, struct cache_entry *e)
{
	ht_str_del(&c->ht, e->id);
	obj_free(e->obj);
	free(e->id);
	free(e);
	c->total--;
}

static void
evict_until_under_limit(OBJ_CACHE *c)
{
	while (c->unref_count > c->max_unref && c->lru_tail) {
		struct cache_entry *e = c->lru_tail;
		flush_entry(c, e);
		lru_unlink(c, e);
		drop_entry(c, e);
	}
}

/* --- lifecycle ------------------------------------------------------- */

OBJ_CACHE *
obj_cache_new(unsigned max_unreferenced, const struct obj_cache_ops *ops,
	void *ctx)
{
	if (!ops || !ops->load) return NULL;
	OBJ_CACHE *c = calloc(1, sizeof(*c));
	if (!c) return NULL;
	if (ht_str_init(&c->ht, 64) != 0) {
		free(c);
		return NULL;
	}
	c->max_unref = max_unreferenced;
	c->ops = *ops;
	c->ctx = ctx;
	return c;
}

static void
free_entry_value(void *v)
{
	struct cache_entry *e = v;
	/* No flush here -- caller must call flush_all first if they care. */
	obj_free(e->obj);
	free(e->id);
	free(e);
}

void
obj_cache_free(OBJ_CACHE *c)
{
	if (!c) return;
	ht_str_free(&c->ht, free_entry_value);
	free(c);
}

/* --- get / release --------------------------------------------------- */

OBJ *
obj_cache_get(OBJ_CACHE *c, const char *id)
{
	if (!c || !id) return NULL;
	struct cache_entry *e = ht_str_get(&c->ht, id);
	if (e) {
		if (e->refcount == 0) lru_unlink(c, e);
		e->refcount++;
		return e->obj;
	}
	OBJ *obj = c->ops.load(c->ctx, id);
	if (!obj) return NULL;
	e = calloc(1, sizeof(*e));
	if (!e) { obj_free(obj); return NULL; }
	e->id = strdup(id);
	if (!e->id) { free(e); obj_free(obj); return NULL; }
	e->obj = obj;
	e->refcount = 1;
	e->owner = c;
	if (ht_str_set(&c->ht, e->id, e) != 0) {
		free(e->id);
		free(e);
		obj_free(obj);
		return NULL;
	}
	c->total++;
	return obj;
}

static struct cache_entry *
find_entry_by_obj(OBJ_CACHE *c, OBJ *obj)
{
	/* scan -- cache is small. If this becomes hot, add a reverse map. */
	for (unsigned i = 0; i < c->ht.capacity; i++) {
		struct ht_str_entry *he = &c->ht.buckets[i];
		if (!he->occupied) continue;
		struct cache_entry *e = he->value;
		if (e && e->obj == obj) return e;
	}
	return NULL;
}

void
obj_cache_release(OBJ_CACHE *c, OBJ *obj)
{
	if (!c || !obj) return;
	struct cache_entry *e = find_entry_by_obj(c, obj);
	if (!e) {
		LOG_ERROR("release of unknown obj");
		return;
	}
	if (e->refcount <= 0) {
		LOG_ERROR("release with refcount=%d id=%s", e->refcount, e->id);
		return;
	}
	if (--e->refcount == 0) {
		lru_push_head(c, e);
		evict_until_under_limit(c);
	}
}

void
obj_cache_mark_dirty(OBJ_CACHE *c, OBJ *obj)
{
	if (!c || !obj) return;
	struct cache_entry *e = find_entry_by_obj(c, obj);
	if (e) e->dirty = 1;
}

int
obj_cache_flush_all(OBJ_CACHE *c)
{
	if (!c) return OBJ_CACHE_ERR;
	int rc = OBJ_CACHE_OK;
	for (unsigned i = 0; i < c->ht.capacity; i++) {
		struct ht_str_entry *he = &c->ht.buckets[i];
		if (!he->occupied) continue;
		struct cache_entry *e = he->value;
		if (!e) continue;
		if (flush_entry(c, e) != OBJ_CACHE_OK) rc = OBJ_CACHE_ERR;
	}
	return rc;
}

/* --- prototype walk -------------------------------------------------- */

char *
obj_cache_prop_resolve(OBJ_CACHE *c, OBJ *obj, const char *propname)
{
	if (!c || !obj || !propname) return NULL;
	if (propname[0] == '%' || propname[0] == '!') return NULL;

	OBJ *current = obj;
	OBJ_CACHE *cur_cache = c;
	OBJ *pinned = NULL; /* additional pin beyond caller's root pin */
	OBJ_CACHE *pinned_cache = NULL;
	char *result = NULL;

	for (int depth = 0; depth <= OBJ_CACHE_MAX_PROTO_DEPTH; depth++) {
		if (obj_prop_is_tombstoned(current, propname)) break;
		char *v = obj_prop_get(current, propname);
		if (v) { result = strdup(v); break; }

		char *parent_ref = obj_prop_get(current, "%parent");
		if (!parent_ref) break;

		/* copy parent_ref before resolve -- obj_prop_get returns a
		 * borrowed pointer that may be invalidated by cache ops. */
		char *pref = strdup(parent_ref);
		if (!pref) break;

		OBJ_CACHE *next_cache = cur_cache;
		const char *next_id = pref;
		if (cur_cache->ops.resolve_parent_cache) {
			const char *resolved_id = NULL;
			OBJ_CACHE *nc = cur_cache->ops.resolve_parent_cache(
				cur_cache->ctx, pref, &resolved_id);
			if (nc) {
				next_cache = nc;
				if (resolved_id) next_id = resolved_id;
			}
		}

		OBJ *parent = obj_cache_get(next_cache, next_id);
		free(pref);
		if (!parent) break;

		/* release previous pin if any */
		if (pinned) obj_cache_release(pinned_cache, pinned);
		pinned = parent;
		pinned_cache = next_cache;
		current = parent;
		cur_cache = next_cache;
	}

	if (pinned) obj_cache_release(pinned_cache, pinned);
	return result;
}

unsigned
obj_cache_size(OBJ_CACHE *c)
{
	return c ? c->total : 0;
}

unsigned
obj_cache_lru_count(OBJ_CACHE *c)
{
	return c ? c->unref_count : 0;
}
