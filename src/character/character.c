/**
 * @file character.c
 *
 * Character service.
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

#include "character.h"
#include "boris.h"
#include "freelist.h"
#include "hashtable.h"
#include "muddb.h"
#include "obj.h"

#define LOG_SUBSYSTEM "character"
#include "log.h"

#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * Types
 ******************************************************************************/

struct character {
	LIST_ENTRY(struct character) character_cache; /**< currently loaded characters. */
	int dirty_fl;
	int refcount;
	/* part of the character saved to disk is below this line. */
	unsigned id;
	struct description_string name, desc;
	char *owner, *controllers;
	char *room_current; /**< id of the current room. */
	char *room_home; /**< id of the home room used for certain kinds of resets. */
	struct attr_list extra_values;
};

LIST_HEAD(struct character_cache, struct character);
/******************************************************************************
 * Globals
 ******************************************************************************/
/**
 * definition of every attribute in character record.
 */
static const struct {
	char *name;
	enum value_type type;
	size_t ofs;
} attrinfo[] = {
	{"id", VALUE_TYPE_UINT, offsetof(struct character, id), },
	{"name.short", VALUE_TYPE_STRING, offsetof(struct character, name.short_str), },
	{"name.long", VALUE_TYPE_STRING, offsetof(struct character, name.long_str), },
	{"desc.short", VALUE_TYPE_STRING, offsetof(struct character, desc.short_str), },
	{"desc.long", VALUE_TYPE_STRING, offsetof(struct character, desc.long_str), },
	{"owner", VALUE_TYPE_STRING, offsetof(struct character, owner), },
	{"controllers", VALUE_TYPE_STRING, offsetof(struct character, controllers), },
	{"room.current", VALUE_TYPE_STRING, offsetof(struct character, room_current), },
	{"room.home", VALUE_TYPE_STRING, offsetof(struct character, room_home), },
};

/** all loaded characters, keyed by id for O(1) lookup. */
static struct ht_uint character_ht;

/** LRU list of unreferenced characters (refcount == 0). head is most recent. */
static struct character_cache character_lru;

/** number of unreferenced characters sitting in the LRU. */
static unsigned character_lru_count;

static struct freelist *character_id_freelist;
/******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * deallocate a character structure immediately.
 * removes from hash table and LRU list.
 */
static void
character_ll_free(struct character *ch)
{
	unsigned i;

	assert(ch != NULL);

	if (!ch) return;

	ht_uint_del(&character_ht, ch->id);
	LIST_REMOVE(ch, character_cache);
	LIST_ENTRY_INIT(ch, character_cache);
	if (ch->refcount <= 0 && character_lru_count > 0)
		character_lru_count--;

	for (i = 0; i < NR(attrinfo); i++) {
		if (attrinfo[i].type == VALUE_TYPE_STRING) {
			char **strp = (char**)((char*)ch + attrinfo[i].ofs);
			free(*strp);
			*strp = NULL;
		}
	}

	attr_list_free(&ch->extra_values);

	free(ch);
}

/**
 * allocate an empty character.
 */
static struct character *
character_ll_alloc(void)
{
	struct character *ret;
	ret = calloc(1, sizeof * ret);

	if (!ret) {
		LOG_CRITICAL("out of memory");
	}

	return ret;
}

/**
 *
 */
int
character_attr_set(struct character *ch, const char *name, const char *value)
{
	unsigned i;
	int res;

	assert(ch != NULL);

	if (!ch) return 0;

	for (i = 0; i < NR(attrinfo); i++) {
		if (!strcasecmp(name, attrinfo[i].name)) {
			ch->dirty_fl = 1;
			return value_set(value, attrinfo[i].type, (char*)ch + attrinfo[i].ofs);
		}
	}

	res = parse_attr(name, value, &ch->extra_values);

	if (res) {
		ch->dirty_fl = 1;
	}

	return res;
}

/**
 *
 */
const char *
character_attr_get(struct character *ch, const char *name)
{
	unsigned i;
	struct attr_entry *at;

	assert(ch != NULL);

	if (!ch) return NULL;

	for (i = 0; i < NR(attrinfo); i++) {
		if (!strcasecmp(name, attrinfo[i].name)) {
			return value_get(attrinfo[i].type, (char*)ch + attrinfo[i].ofs);
		}
	}

	at = attr_find(&ch->extra_values, name);

	return at ? at->value : NULL;
}

/**
 * load a character from the database.
 */
static struct character *
character_load(unsigned character_id)
{
	struct character *ch;
	char numbuf[22];
	OBJ *obj;

	assert(character_id > 0);

	if (character_id <= 0) return NULL;

	snprintf(numbuf, sizeof numbuf, "%u", character_id);

	obj = muddb_get(mud_db, DOMAIN_CHARACTER, numbuf);

	if (!obj) {
		LOG_ERROR("could not load character \"%u\"", character_id);
		return NULL;
	}

	ch = character_ll_alloc();

	if (!ch) {
		obj_free(obj);
		return NULL;
	}

	/* load all properties via character_attr_set */
	{
		OBJ_ITER *it = obj_iter_begin(obj);
		const char *key, *value;

		while (obj_iter_next(it, &key, &value)) {
			if (!character_attr_set(ch, key, value)) {
				LOG_ERROR("could not load character \"%u\"", character_id);
				obj_iter_end(it);
				character_ll_free(ch);
				obj_free(obj);
				return NULL;
			}
		}
		obj_iter_end(it);
	}

	obj_free(obj);

	if (character_id != ch->id) {
		LOG_ERROR("could not load character \"%u\" (bad, missing or mismatched id)", character_id);
		character_ll_free(ch);
		return NULL;
	}

	return ch;
}

/**
 * save a character record, but only if the dirty_fl is set.
 */
int
character_save(struct character *ch)
{
	struct attr_entry *curr;
	OBJ *obj;
	char numbuf[22];
	unsigned i;

	assert(ch != NULL);

	if (!ch->dirty_fl) return 1; /* already saved - don't do it again. */

	snprintf(numbuf, sizeof numbuf, "%u", ch->id);

	obj = obj_new(numbuf);

	if (!obj) {
		LOG_ERROR("could not save character \"%u\"", ch->id);
		return 0; /* failure */
	}

	for (i = 0; i < NR(attrinfo); i++) {
		void *base = ((char*)ch + attrinfo[i].ofs);

		switch (attrinfo[i].type) {
		case VALUE_TYPE_UINT:
			snprintf(numbuf, sizeof numbuf, "%u", *(unsigned*)base);
			obj_prop_set(obj, attrinfo[i].name, numbuf);
			break;

		case VALUE_TYPE_STRING:
			if (*(char**)base)
				obj_prop_set(obj, attrinfo[i].name, *(char**)base);
			break;
		}
	}

	for (curr = LIST_TOP(ch->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		obj_prop_set(obj, curr->name, curr->value);
	}

	if (muddb_put(mud_db, DOMAIN_CHARACTER, numbuf, obj) != MUDDB_OK) {
		LOG_ERROR("could not save character \"%u\"", ch->id);
		obj_free(obj);
		return 0; /* failure */
	}

	obj_free(obj);
	ch->dirty_fl = 0;
	LOG_INFO("saved character \"%u\"", ch->id);

	return 1;
}

/** evict the oldest unreferenced character from the LRU tail. */
static void
character_lru_evict_one(void)
{
	struct character *tail;

	for (tail = LIST_TOP(character_lru); tail; tail = LIST_NEXT(tail, character_cache)) {
		if (!LIST_NEXT(tail, character_cache))
			break;
	}

	if (tail) {
		character_save(tail);
		character_ll_free(tail);
	}
}

/**
 * load character into cache, if not already loaded, then increase
 * reference count of character.
 */
struct character *
character_get(unsigned character_id)
{
	struct character *curr;

	/* O(1) hash table lookup. */
	curr = ht_uint_get(&character_ht, character_id);

	if (!curr) {
		/* not in the cache -- load from database. */
		curr = character_load(character_id);
		if (curr) {
			ht_uint_set(&character_ht, character_id, curr);
		}
	}

	if (curr) {
		if (curr->refcount == 0 && character_lru_count > 0) {
			/* moving from LRU to active -- remove from LRU list */
			LIST_REMOVE(curr, character_cache);
			LIST_ENTRY_INIT(curr, character_cache);
			character_lru_count--;
		}
		curr->refcount++;
	}

	if (!curr) {
		LOG_WARNING("could not access character \"%u\"", character_id);
	}

	return curr;
}

/**
 * reduce reference count of character.
 * when refcount hits zero the character moves to the LRU list instead of
 * being freed immediately. the LRU is capped by cache.character.size.
 */
void
character_put(struct character *ch)
{
	assert(ch != NULL);

	ch->refcount--;

	if (ch->refcount <= 0) {
		character_save(ch);
		/* move to head of LRU (most recently used) */
		LIST_INSERT_HEAD(&character_lru, ch, character_cache);
		character_lru_count++;

		/* evict oldest if over the cap */
		while (character_lru_count > mud_config.character_cache_size)
			character_lru_evict_one();
	}
}

struct character *
character_new(void)
{
	struct character *ret;
	long id;

	ret = character_ll_alloc();

	if (!ret) return NULL;

	/* allocate next entry from a pool. */
	id = freelist_alloc(character_id_freelist, 1);

	if (id < 0) {
		LOG_CRITICAL("could not allocate new character id.");
		free(ret);
		return NULL;
	}

	ret->id = id;

	/* save character immediately on creation. */
	ret->dirty_fl = 1;
	character_save(ret);

	/* insert into hash table and bump refcount. */
	ht_uint_set(&character_ht, ret->id, ret);
	ret->refcount++;

	return ret;
}

/**
 * preflight all of the characters by loading every one of them.
 */
static int
character_preflight(void)
{
	MUDDB_ITER *it;
	const char *id;

	it = muddb_iter_begin(mud_db, DOMAIN_CHARACTER);

	if (!it) {
		/* no characters domain yet -- not an error on first run */
		return 1;
	}

	while ((id = muddb_iter_next(it))) {
		struct character *ch;
		unsigned character_id;
		char *endptr;
		LOG_DEBUG("Found character: \"%s\"", id);
		character_id = strtoul(id, &endptr, 10);

		if (*endptr) {
			LOG_CRITICAL("character id \"%s\" is invalid!", id);
			muddb_iter_end(it);
			return 0; /* could not load */
		}

		ch = character_load(character_id);

		if (!ch) {
			LOG_CRITICAL("could not load character id \"%u\"", character_id);
			muddb_iter_end(it);
			return 0; /* could not load */
		}

		/* compare ch->id with character_id */
		if (ch->id != character_id) {
			LOG_CRITICAL("bad or non-matching character id \"%u\"", character_id);
			character_ll_free(ch);
			muddb_iter_end(it);
			return 0; /* could not load */
		}

		/* allocate id from the pool */
		if (!freelist_thwack(character_id_freelist, ch->id, 1)) {
			LOG_CRITICAL("bad or duplicate character id \"%u\"", character_id);
			character_ll_free(ch);
			muddb_iter_end(it);
			return 0; /* could not load */
		}

		character_ll_free(ch);
	}

	muddb_iter_end(it);

	return 1; /* success */
}

int
character_initialize(void)
{
	LOG_INFO("Character sub-system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&character_lru);
	ht_uint_init(&character_ht, 64);

	character_id_freelist = freelist_new(1, ID_MAX);
	if (!character_id_freelist) {
		LOG_CRITICAL("could not allocate IDs!");
		return -1;
	}

	/* load all characters to check and to configure pool space. */
	if (!character_preflight()) {
		LOG_CRITICAL("could not load characters!");
		return -1;
	}

	return 0;
}

void
character_shutdown(void)
{
	struct character *curr;
	unsigned i;

	LOG_INFO("Character sub-system shutting down...");

	/* flush LRU list -- all unreferenced characters */
	while ((curr = LIST_TOP(character_lru))) {
		character_save(curr);
		character_ll_free(curr);
	}

	/* scan hash table for any characters still held by reference */
	for (i = 0; i < character_ht.capacity; i++) {
		struct ht_uint_entry *e = &character_ht.buckets[i];
		if (e->occupied) {
			curr = e->value;
			LOG_ERROR("character \"%u\" still in use at shutdown (refcount %d)",
				curr->id, curr->refcount);
			character_save(curr);
		}
	}

	ht_uint_free(&character_ht);
	character_lru_count = 0;

	LOG_INFO("Character sub-system ended.");
}
