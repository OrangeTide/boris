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
#include "muddb.h"

#include <log.h>

#include <stdlib.h>
#include <string.h>

/* The contents index: container id -> set of directly-contained member ids. */
#define OBJ_CONTENTS_INDEX "idx.contents"

/* The owner index: owner id -> set of objects it owns. Maintained when an
 * object's %owner is set (obj_set_owner) and cleared when it is destroyed, so
 * obj_owner_count is a cheap per-owner tally. */
#define OBJ_OWNER_INDEX "idx.owner"

/* Cap on how far obj_move walks the %location chain for its cycle check. A
 * chain longer than this is treated as corrupt and the move is refused. */
#define OBJ_CONTAIN_MAX_DEPTH 64

static OBJ_CACHE *obj_global_cache;

static MUDDB *store_muddb(void);

int
obj_initialize(struct muddb *db, unsigned cache_size)
{
	obj_global_cache = obj_cache_muddb_new(db, "objs", cache_size);
	if (!obj_global_cache) {
		LOG_ERROR("could not create object cache");
		return -1;
	}
	if (muddb_index_register(db, OBJ_CONTENTS_INDEX) != MUDDB_OK) {
		LOG_ERROR("could not register contents index");
		obj_cache_free(obj_global_cache);
		obj_global_cache = NULL;
		return -1;
	}
	if (muddb_index_register(db, OBJ_OWNER_INDEX) != MUDDB_OK) {
		LOG_ERROR("could not register owner index");
		obj_cache_free(obj_global_cache);
		obj_global_cache = NULL;
		return -1;
	}
	LOG_INFO("Object cache loaded (muddb backend).");
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

int
obj_put(const char *id, OBJ *obj)
{
	if (!obj_global_cache || !id || !obj)
		return OBJ_ERR;
	return obj_cache_put(obj_global_cache, id, obj) == OBJ_CACHE_OK
		? OBJ_OK : OBJ_ERR;
}

int
obj_delete(const char *id)
{
	if (!obj_global_cache || !id)
		return OBJ_ERR;
	return obj_cache_del(obj_global_cache, id) == OBJ_CACHE_OK
		? OBJ_OK : OBJ_ERR;
}

void
obj_forget(const char *id)
{
	if (obj_global_cache && id)
		obj_cache_forget(obj_global_cache, id);
}

char *
obj_resolve_prop(const char *id, const char *propname)
{
	OBJ *o;
	char *v;

	if (!obj_global_cache || !id || !propname)
		return NULL;
	o = obj_cache_get(obj_global_cache, id);
	if (!o)
		return NULL;
	v = obj_cache_prop_resolve(obj_global_cache, o, propname);
	obj_cache_release(obj_global_cache, o);
	return v;
}

char *
obj_resolve_prop_ref(const char *id, const char *name)
{
	char marked[OBJ_PATH_MAX + 2];
	size_t n;

	if (!id || !name)
		return NULL;
	n = strlen(name);
	if (n + 2 > sizeof(marked))
		return NULL;
	memcpy(marked, name, n);
	marked[n] = OBJ_REF_MARK;
	marked[n + 1] = '\0';
	return obj_resolve_prop(id, marked);
}

int
obj_foreach_key(const char *prefix,
	void (*cb)(const char *key, void *ctx), void *ctx)
{
	MUDDB *db = store_muddb();
	MUDDB_ITER *it;
	const char *key;
	size_t plen = prefix ? strlen(prefix) : 0;
	int n = 0;

	if (!cb || !db)
		return -1;
	it = muddb_iter_begin(db, "objs");
	if (!it)
		return -1;
	while ((key = muddb_iter_next(it))) {
		if (plen && strncmp(key, prefix, plen) != 0)
			continue;
		cb(key, ctx);
		n++;
	}
	muddb_iter_end(it);
	return n;
}

/*
 * The contents and owner index coordinates an object currently occupies,
 * captured from the store before a restore changes it so the stale entries can
 * be removed. Both may be NULL (unset).
 */
struct obj_coord {
	char *loc;
	char *owner;
};

/* Read key's current %location and %owner straight from the store (not the
 * cache), so a restore can clear the index entries they point at. */
static void
capture_coord(MUDDB *db, const char *domain, const char *key,
	struct obj_coord *oc)
{
	OBJ *o;
	char *l, *w;

	oc->loc = NULL;
	oc->owner = NULL;
	o = muddb_get(db, domain, key);
	if (!o)
		return;
	l = obj_prop_get_ref(o, "%location");
	if (l && *l)
		oc->loc = strdup(l);
	w = obj_prop_get(o, "%owner");
	if (w && *w)
		oc->owner = strdup(w);
	obj_free(o);
}

int
obj_apply_restore(const char *const *put_keys, OBJ *const *put_objs,
	size_t n_put, const char *const *del_keys, size_t n_del)
{
	MUDDB *db = store_muddb();
	const char *domain;
	struct obj_coord *pc = NULL, *dc = NULL;
	MUDDB_TXN *t = NULL;
	size_t i;
	int rc = OBJ_ERR;

	if (!db) {
		LOG_ERROR("obj_apply_restore requires the muddb backend");
		return OBJ_ERR;
	}
	if ((n_put && (!put_keys || !put_objs)) || (n_del && !del_keys))
		return OBJ_ERR;
	if (!n_put && !n_del)
		return OBJ_OK; /* nothing to do */

	domain = obj_cache_muddb_domain(obj_global_cache);

	/* Persist any pending cached edits first, so the coordinates we read and
	 * the indexes we maintain reflect the true current state (section 7). */
	obj_cache_flush_all(obj_global_cache);

	if (n_put && !(pc = calloc(n_put, sizeof(*pc))))
		goto done;
	if (n_del && !(dc = calloc(n_del, sizeof(*dc))))
		goto done;

	for (i = 0; i < n_put; i++)
		capture_coord(db, domain, put_keys[i], &pc[i]);
	for (i = 0; i < n_del; i++)
		capture_coord(db, domain, del_keys[i], &dc[i]);

	/* Drop cached copies before the store changes underneath the cache. */
	for (i = 0; i < n_put; i++)
		obj_forget(put_keys[i]);
	for (i = 0; i < n_del; i++)
		obj_forget(del_keys[i]);

	t = muddb_txn_begin(db);
	if (!t)
		goto done;

	for (i = 0; i < n_put; i++) {
		char *nl, *nw;

		if (pc[i].loc && muddb_txn_index_del(t, OBJ_CONTENTS_INDEX,
				pc[i].loc, put_keys[i]) != MUDDB_OK)
			goto abort;
		if (pc[i].owner && muddb_txn_index_del(t, OBJ_OWNER_INDEX,
				pc[i].owner, put_keys[i]) != MUDDB_OK)
			goto abort;
		if (muddb_txn_put(t, domain, put_keys[i], put_objs[i])
				!= MUDDB_OK)
			goto abort;
		nl = obj_prop_get_ref(put_objs[i], "%location");
		if (nl && *nl && muddb_txn_index_add(t, OBJ_CONTENTS_INDEX,
				nl, put_keys[i]) != MUDDB_OK)
			goto abort;
		nw = obj_prop_get(put_objs[i], "%owner");
		if (nw && *nw && muddb_txn_index_add(t, OBJ_OWNER_INDEX,
				nw, put_keys[i]) != MUDDB_OK)
			goto abort;
	}
	for (i = 0; i < n_del; i++) {
		if (dc[i].loc && muddb_txn_index_del(t, OBJ_CONTENTS_INDEX,
				dc[i].loc, del_keys[i]) != MUDDB_OK)
			goto abort;
		if (dc[i].owner && muddb_txn_index_del(t, OBJ_OWNER_INDEX,
				dc[i].owner, del_keys[i]) != MUDDB_OK)
			goto abort;
		if (muddb_txn_del(t, domain, del_keys[i]) != MUDDB_OK)
			goto abort;
	}

	if (muddb_txn_commit(t) != MUDDB_OK)
		goto done; /* commit frees the txn even on failure */
	t = NULL;
	rc = OBJ_OK;

	/* Forget again so the next read loads the committed restored state. */
	for (i = 0; i < n_put; i++)
		obj_forget(put_keys[i]);
	for (i = 0; i < n_del; i++)
		obj_forget(del_keys[i]);
	goto done;

abort:
	muddb_txn_abort(t);
	t = NULL;

done:
	if (pc) {
		for (i = 0; i < n_put; i++) {
			free(pc[i].loc);
			free(pc[i].owner);
		}
		free(pc);
	}
	if (dc) {
		for (i = 0; i < n_del; i++) {
			free(dc[i].loc);
			free(dc[i].owner);
		}
		free(dc);
	}
	return rc;
}

OBJ *
obj_create(const char *id)
{
	if (!id)
		return NULL;
	return obj_cache_create(obj_global_cache, id);
}

int
obj_destroy(const char *id)
{
	MUDDB *db;
	char *owner = NULL;
	int rc;

	if (!id)
		return OBJ_ERR;

	/* Capture the owner before the record is gone, so the owner index can be
	 * cleared to match. The get/release is pin-neutral, so it does not block
	 * the destroy. */
	db = store_muddb();
	if (db) {
		OBJ *o = obj_get(id);

		if (o) {
			const char *w = obj_prop_get(o, "%owner");

			if (w && *w)
				owner = strdup(w);
			obj_release(o);
		}
	}

	rc = obj_cache_destroy(obj_global_cache, id) == OBJ_CACHE_OK
		? OBJ_OK : OBJ_ERR;
	if (rc == OBJ_OK && owner)
		muddb_index_del(db, OBJ_OWNER_INDEX, owner, id);
	free(owner);
	return rc;
}

void
obj_mark_dirty(OBJ *obj)
{
	if (obj)
		obj_cache_mark_dirty(obj_global_cache, obj);
}

int
obj_save(const char *id)
{
	if (!id)
		return OBJ_ERR;
	return obj_cache_save(obj_global_cache, id) == OBJ_CACHE_OK
		? OBJ_OK : OBJ_ERR;
}

char *
obj_prop_resolve(OBJ *obj, const char *propname)
{
	return obj_cache_prop_resolve(obj_global_cache, obj, propname);
}

/* The muddb handle backing the global cache. */
static MUDDB *
store_muddb(void)
{
	if (!obj_global_cache)
		return NULL;
	return obj_cache_muddb_db(obj_global_cache);
}

/* True if containing member inside container would form a cycle, i.e. container
 * is member itself or one of member's own descendants. Walks up the %location
 * chain from container; reaching member means container sits inside it. */
static int
would_cycle(const char *member, const char *container)
{
	char *cur = strdup(container);
	int depth = 0, cycle = 0;

	while (cur) {
		char *next;
		OBJ *o;
		char *loc;

		if (strcmp(cur, member) == 0) {
			cycle = 1;
			break;
		}
		if (++depth > OBJ_CONTAIN_MAX_DEPTH) {
			LOG_ERROR("containment chain from %s too deep", container);
			cycle = 1;
			break;
		}
		o = obj_get(cur);
		if (!o)
			break;                  /* chain ends at an unloadable id */
		loc = obj_prop_get_ref(o, "%location");
		next = (loc && *loc) ? strdup(loc) : NULL;
		obj_release(o);
		free(cur);
		cur = next;
	}
	free(cur);
	return cycle;
}

int
obj_move(const char *member, const char *container)
{
	MUDDB *db = store_muddb();
	const char *domain;
	int to_limbo = (!container || !*container);
	OBJ *m, *c = NULL;
	MUDDB_TXN *t;
	char *old = NULL;
	char *loc;
	int rc;

	if (!member || !*member)
		return OBJ_ERR;
	if (!db) {
		LOG_ERROR("obj_move requires the muddb backend");
		return OBJ_ERR;
	}

	if (!to_limbo) {
		if (strcmp(member, container) == 0) {
			LOG_ERROR("obj_move: %s cannot contain itself", member);
			return OBJ_ERR;
		}
		if (would_cycle(member, container)) {
			LOG_ERROR("obj_move: %s into %s would form a cycle",
				member, container);
			return OBJ_ERR;
		}
	}

	m = obj_get(member);
	if (!m) {
		LOG_ERROR("obj_move: no such member %s", member);
		return OBJ_ERR;
	}
	if (!to_limbo) {
		c = obj_get(container);
		if (!c) {
			LOG_ERROR("obj_move: no such container %s", container);
			obj_release(m);
			return OBJ_ERR;
		}
	}

	loc = obj_prop_get_ref(m, "%location");
	if (loc && *loc)
		old = strdup(loc);

	/* Set the forward pointer in memory before staging the record, so the
	 * serialized object carries the new %location. */
	rc = to_limbo ? obj_prop_delete_ref_internal(m, "%location")
		: obj_prop_set_ref_internal(m, "%location", container);
	if (rc != OBJ_OK) {
		LOG_ERROR("obj_move: could not set %%location on %s", member);
		goto fail_revert;
	}

	domain = obj_cache_muddb_domain(obj_global_cache);
	t = muddb_txn_begin(db);
	if (!t)
		goto fail_revert;
	if (muddb_txn_put(t, domain, member, m) != MUDDB_OK)
		goto fail_abort;
	if (old && muddb_txn_index_del(t, OBJ_CONTENTS_INDEX, old, member)
			!= MUDDB_OK)
		goto fail_abort;
	if (!to_limbo && muddb_txn_index_add(t, OBJ_CONTENTS_INDEX, container,
			member) != MUDDB_OK)
		goto fail_abort;
	if (muddb_txn_commit(t) != MUDDB_OK)
		goto fail_revert;

	/* The record is persisted by the transaction, so the cache need not
	 * save it again. */
	obj_cache_mark_clean(obj_global_cache, m);
	free(old);
	if (c)
		obj_release(c);
	obj_release(m);
	return OBJ_OK;

fail_abort:
	muddb_txn_abort(t);
fail_revert:
	/* Restore the in-memory %location so the cache matches the unchanged
	 * store. */
	if (old)
		obj_prop_set_ref_internal(m, "%location", old);
	else
		obj_prop_delete_ref_internal(m, "%location");
	free(old);
	if (c)
		obj_release(c);
	obj_release(m);
	return OBJ_ERR;
}

char *
obj_location(const char *member)
{
	OBJ *m;
	char *loc, *out = NULL;

	if (!member || !*member)
		return NULL;
	m = obj_get(member);
	if (!m)
		return NULL;
	loc = obj_prop_get_ref(m, "%location");
	if (loc && *loc)
		out = strdup(loc);
	obj_release(m);
	return out;
}

long
obj_contents_count(const char *container)
{
	MUDDB *db = store_muddb();

	if (!db || !container || !*container)
		return 0;
	return muddb_index_count(db, OBJ_CONTENTS_INDEX, container);
}

int
obj_set_owner(const char *id, const char *owner)
{
	MUDDB *db = store_muddb();
	OBJ *o;
	char *prev = NULL;
	const char *cur;
	int rc;

	if (!id || !owner)
		return OBJ_ERR;
	o = obj_get(id);
	if (!o)
		return OBJ_ERR;
	cur = obj_prop_get(o, "%owner");
	if (cur && *cur)
		prev = strdup(cur);
	rc = obj_prop_set_internal(o, "%owner", owner);
	if (rc == OBJ_OK) {
		obj_mark_dirty(o);
		rc = obj_save(id);
	}
	obj_release(o);
	if (rc != OBJ_OK) {
		free(prev);
		return rc;
	}

	/* Keep the owner index in step. The record is already persisted; the
	 * index is maintained separately (as for the contents index), so a crash
	 * between the two can only undercount, never grant extra quota. */
	if (db) {
		if (prev && strcmp(prev, owner) != 0)
			muddb_index_del(db, OBJ_OWNER_INDEX, prev, id);
		muddb_index_add(db, OBJ_OWNER_INDEX, owner, id);
	}
	free(prev);
	return OBJ_OK;
}

long
obj_owner_count(const char *owner)
{
	MUDDB *db = store_muddb();

	if (!db || !owner || !*owner)
		return 0;
	return muddb_index_count(db, OBJ_OWNER_INDEX, owner);
}

struct obj_contents_iter {
	MUDDB_INDEX_ITER *it;
};

OBJ_CONTENTS_ITER *
obj_contents_begin(const char *container)
{
	MUDDB *db = store_muddb();
	OBJ_CONTENTS_ITER *ci;

	if (!db || !container || !*container)
		return NULL;
	ci = calloc(1, sizeof(*ci));
	if (!ci)
		return NULL;
	ci->it = muddb_index_iter_begin(db, OBJ_CONTENTS_INDEX, container);
	if (!ci->it) {
		free(ci);
		return NULL;
	}
	return ci;
}

const char *
obj_contents_next(OBJ_CONTENTS_ITER *ci)
{
	if (!ci)
		return NULL;
	return muddb_index_iter_next(ci->it);
}

void
obj_contents_end(OBJ_CONTENTS_ITER *ci)
{
	if (!ci)
		return;
	muddb_index_iter_end(ci->it);
	free(ci);
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
