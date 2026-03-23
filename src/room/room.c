/**
 * @file room.c
 *
 * Room support.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2009-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "room.h"
#include "boris.h"
#include "hashtable.h"
#include "list.h"
#include "muddb.h"
#include "obj.h"

#define LOG_SUBSYSTEM "room"
#include <log.h>

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LOGBASIC_LENGTH_MAX 1024

/******************************************************************************
 * Types
 ******************************************************************************/

struct room {
	LIST_ENTRY(struct room) room_cache; /**< currently loaded rooms. */
	int refcount; /* reference count. */
	int dirty_fl;
	char *id;
	struct {
		char *short_str, *long_str;
	} name;
	struct {
		char *short_str, *long_str;
	} desc;
	char *owner, *creator;
	struct attr_list extra_values; /**< load in other values here. */
};

LIST_HEAD(struct room_cache, struct room);

/******************************************************************************
 * Globals
 ******************************************************************************/

/** all loaded rooms, keyed by id for O(1) lookup. */
static struct ht_str room_ht;

/** LRU list of unreferenced rooms (refcount == 0). head is most recent. */
static struct room_cache room_lru;

/** number of unreferenced rooms sitting in the LRU. */
static unsigned room_lru_count;

/******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * deallocate a room structure immediately.
 * removes from hash table and LRU list.
 */
static void
room_ll_free(struct room *r)
{
	assert(r != NULL);

	if (r->id)
		ht_str_del(&room_ht, r->id);
	LIST_REMOVE(r, room_cache);
	LIST_ENTRY_INIT(r, room_cache);
	if (r->refcount <= 0 && room_lru_count > 0)
		room_lru_count--;

	free(r->id);
	r->id = NULL;
	free(r->name.short_str);
	r->name.short_str = NULL;
	free(r->name.long_str);
	r->name.long_str = NULL;

	free(r->desc.short_str);
	r->desc.short_str = NULL;
	free(r->desc.long_str);
	r->desc.long_str = NULL;

	free(r->owner);
	r->owner = NULL;
	free(r->creator);
	r->creator = NULL;

	attr_list_free(&r->extra_values);

	free(r);
}

/**
 * set an attribute on a room.
 */
int
room_attr_set(struct room *r, const char *name, const char *value)
{
	int res;

	assert(r != NULL);
	assert(name != NULL);
	assert(value != NULL);

	if (!r)
		return 0;

	if (!strcasecmp("id", name))
		res = parse_str(name, value, &r->id);
	else if (!strcasecmp("name.short", name))
		res = parse_str(name, value, &r->name.short_str);
	else if (!strcasecmp("name.long", name))
		res = parse_str(name, value, &r->name.long_str);
	else if (!strcasecmp("desc.short", name))
		res = parse_str(name, value, &r->desc.short_str);
	else if (!strcasecmp("desc.long", name))
		res = parse_str(name, value, &r->desc.long_str);
	else if (!strcasecmp("creator", name))
		res = parse_str(name, value, &r->creator);
	else if (!strcasecmp("owner", name))
		res = parse_str(name, value, &r->owner);
	else
		res = parse_attr(name, value, &r->extra_values);

	if (res)
		r->dirty_fl = 1;

	return res;
}

const char *
room_attr_get(struct room *r, const char *name)
{
	if (!strcasecmp("id", name))
		return r->id;
	else if (!strcasecmp("name.short", name))
		return r->name.short_str;
	else if (!strcasecmp("name.long", name))
		return r->name.long_str;
	else if (!strcasecmp("desc.short", name))
		return r->desc.short_str;
	else if (!strcasecmp("desc.long", name))
		return r->desc.long_str;
	else if (!strcasecmp("creator", name))
		return r->creator;
	else if (!strcasecmp("owner", name))
		return r->owner;
	else {
		struct attr_entry *at;
		at = attr_find(&r->extra_values, name);

		if (at)
			return at->value;
	}

	return NULL; /* failure - not found. */
}

static struct room *
room_load(const char *room_id)
{
	struct room *r;
	OBJ *obj;

	assert(room_id != NULL);
	assert(room_id[0] != '\0');

	if (!room_id || !room_id[0])
		return NULL;

	obj = muddb_get(mud_db, DOMAIN_ROOM, room_id);

	if (!obj) {
		LOG_ERROR("could not load room \"%s\"", room_id);
		return NULL;
	}

	r = calloc(1, sizeof *r);

	if (!r) {
		LOG_ERROR("could not allocate room \"%s\"", room_id);
		obj_free(obj);
		return NULL;
	}

	/* load all properties via room_attr_set */
	{
		OBJ_ITER *it = obj_iter_begin(obj);
		const char *key, *value;

		while (obj_iter_next(it, &key, &value)) {
			if (!room_attr_set(r, key, value)) {
				LOG_ERROR("could not load room \"%s\"", room_id);
				obj_iter_end(it);
				room_ll_free(r);
				obj_free(obj);
				return NULL;
			}
		}
		obj_iter_end(it);
	}

	obj_free(obj);

	if (!r->id) {
		LOG_ERROR("id not set for room \"%s\"", room_id);
		room_ll_free(r);
		return NULL;
	}

	if (strcmp(r->id, room_id)) {
		LOG_ERROR("id was set to \"%s\" but should be \"%s\"", r->id, room_id);
		room_ll_free(r);
		return NULL;
	}

	return r;
}

/**
 * write a room structure to the database, if it is dirty (dirty_fl).
 */
int
room_save(struct room *r)
{
	struct attr_entry *curr;
	OBJ *obj;

	assert(r != NULL);

	if (!r->dirty_fl)
		return 1; /* already saved - don't do it again. */

	if (!r->id) {
		LOG_ERROR("attempted to save room with no id");
		return 0;
	}

	obj = obj_new(r->id);

	if (!obj) {
		LOG_ERROR("could not save room \"%s\"", r->id);
		return 0;
	}

	obj_prop_set(obj, "id", r->id);

	if (r->name.short_str)
		obj_prop_set(obj, "name.short", r->name.short_str);

	if (r->name.long_str)
		obj_prop_set(obj, "name.long", r->name.long_str);

	if (r->desc.short_str)
		obj_prop_set(obj, "desc.short", r->desc.short_str);

	if (r->desc.long_str)
		obj_prop_set(obj, "desc.long", r->desc.long_str);

	if (r->owner)
		obj_prop_set(obj, "owner", r->owner);

	if (r->creator)
		obj_prop_set(obj, "creator", r->creator);

	for (curr = LIST_TOP(r->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		obj_prop_set(obj, curr->name, curr->value);
	}

	if (muddb_put(mud_db, DOMAIN_ROOM, r->id, obj) != MUDDB_OK) {
		LOG_ERROR("could not save room \"%s\"", r->id);
		obj_free(obj);
		return 0; /* failure */
	}

	obj_free(obj);
	r->dirty_fl = 0;
	LOG_INFO("saved room \"%s\"", r->id);
	return 1;
}

/** evict the oldest unreferenced room from the LRU tail. */
static void
room_lru_evict_one(void)
{
	struct room *tail;

	/* walk backward from head to find the tail (oldest entry) */
	for (tail = LIST_TOP(room_lru); tail; tail = LIST_NEXT(tail, room_cache)) {
		if (!LIST_NEXT(tail, room_cache))
			break;
	}

	if (tail) {
		room_save(tail);
		room_ll_free(tail);
	}
}

/**
 * load room into cache, if not already loaded, then increase reference count
 * of room.
 */
struct room *
room_get(const char *room_id)
{
	struct room *curr;

	if (!room_id || !room_id[0])
		return NULL;

	/* O(1) hash table lookup. */
	curr = ht_str_get(&room_ht, room_id);

	if (!curr) {
		/* not in the cache -- load from database. */
		curr = room_load(room_id);
		if (curr) {
			ht_str_set(&room_ht, room_id, curr);
		}
	}

	if (curr) {
		if (curr->refcount == 0 && room_lru_count > 0) {
			/* moving from LRU to active -- remove from LRU list */
			LIST_REMOVE(curr, room_cache);
			LIST_ENTRY_INIT(curr, room_cache);
			room_lru_count--;
		}
		curr->refcount++;
	}

	if (!curr) {
		LOG_WARNING("could not access room \"%s\"", room_id);
	}

	return curr;
}

/**
 * reduce reference count of room.
 * when refcount hits zero the room moves to the LRU list instead of
 * being freed immediately. the LRU is capped by cache.room.size.
 */
void
room_put(struct room *r)
{
	assert(r != NULL);

	r->refcount--;

	if (r->refcount <= 0) {
		room_save(r);
		/* move to head of LRU (most recently used) */
		LIST_INSERT_HEAD(&room_lru, r, room_cache);
		room_lru_count++;

		/* evict oldest if over the cap */
		while (room_lru_count > mud_config.room_cache_size)
			room_lru_evict_one();
	}
}

int
room_initialize(void)
{
	MUDDB_ITER *it;
	const char *id;

	LOG_INFO("Room system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&room_lru);
	ht_str_init(&room_ht, 64);

	it = muddb_iter_begin(mud_db, DOMAIN_ROOM);

	if (!it) {
		/* no rooms domain yet -- not an error on first run */
		return 0;
	}

	/* preflight all of the rooms using the iterator's transaction. */
	while ((id = muddb_iter_next(it))) {
		OBJ *obj;
		LOG_DEBUG("Found room: \"%s\"", id);

		obj = muddb_iter_value(it);

		if (!obj) {
			LOG_CRITICAL("could not load room \"%s\"!", id);
			muddb_iter_end(it);
			return -1; /* could not load */
		}

		obj_free(obj);
	}

	muddb_iter_end(it);

	return 0; /* success */
}

void
room_shutdown(void)
{
	struct room *curr;
	unsigned i;

	LOG_INFO("Room system shutting down..");

	/* flush LRU list -- all unreferenced rooms */
	while ((curr = LIST_TOP(room_lru))) {
		room_save(curr);
		room_ll_free(curr);
	}

	/* scan hash table for any rooms still held by reference */
	for (i = 0; i < room_ht.capacity; i++) {
		struct ht_str_entry *e = &room_ht.buckets[i];
		if (e->occupied) {
			curr = e->value;
			LOG_ERROR("room \"%s\" still in use at shutdown (refcount %d)",
				curr->id, curr->refcount);
			room_save(curr);
		}
	}

	ht_str_free(&room_ht, NULL);
	room_lru_count = 0;

	LOG_INFO("Room system ended.");
}
