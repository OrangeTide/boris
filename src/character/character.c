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
#include "fdb.h"

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
	unsigned room_current; /**< id of the current room. */
	unsigned room_home; /**< id of the home room used for certain kinds of resets. */
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
	{"room.current", VALUE_TYPE_UINT, offsetof(struct character, room_current), },
	{"room.home", VALUE_TYPE_UINT, offsetof(struct character, room_home), },
};

/** list of all loaded characters. */
static struct character_cache character_cache;

static struct freelist *character_id_freelist;
/******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * deallocate a character structure immediately.
 */
static void
character_ll_free(struct character *ch)
{
	unsigned i;

	assert(ch != NULL);

	if (!ch) return;

	LIST_REMOVE(ch, character_cache);
	LIST_ENTRY_INIT(ch, character_cache);

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
 * load a character from fdb.
 */
static struct character *
character_load(unsigned character_id)
{
	struct character *ch;
	struct fdb_read_handle *h;
	const char *name, *value;

	assert(character_id > 0);

	if (character_id <= 0) return NULL;

	h = fdb_read_begin_uint(DOMAIN_CHARACTER, character_id);

	if (!h) {
		LOG_ERROR("could not load character \"%u\"", character_id);
		return NULL;
	}

	ch = character_ll_alloc();

	if (!ch) {
		fdb_read_end(h);
		return NULL;
	}

	while (fdb_read_next(h, &name, &value)) {
		if (!character_attr_set(ch, name, value)) {
			LOG_ERROR("could not load character \"%u\"", character_id);
			character_ll_free(ch);
			fdb_read_end(h);
			return NULL;
		}
	}

	fdb_read_end(h);

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
	struct fdb_write_handle *h;
	unsigned i;

	assert(ch != NULL);

	if (!ch->dirty_fl) return 1; /* already saved - don't do it again. */

	h = fdb_write_begin_uint(DOMAIN_CHARACTER, ch->id);

	if (!h) {
		LOG_ERROR("could not save character \"%u\"", ch->id);
		return 0; /* failure */
	}

	for (i = 0; i < NR(attrinfo); i++) {
		void *base = ((char*)ch + attrinfo[i].ofs);

		switch(attrinfo[i].type) {
		case VALUE_TYPE_UINT:
			fdb_write_format(h, attrinfo[i].name, "%u", *(unsigned*)base);
			break;

		case VALUE_TYPE_STRING:
			if (*(char**)base)
				fdb_write_pair(h, attrinfo[i].name, *(char**)base);

			break;
		}
	}

	for (curr = LIST_TOP(ch->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		fdb_write_pair(h, curr->name, curr->value);
	}

	if (!fdb_write_end(h)) {
		LOG_ERROR("could not save character \"%u\"", ch->id);
		return 0; /* failure */
	}

	ch->dirty_fl = 0;
	LOG_INFO("saved character \"%u\"", ch->id);

	return 1;
}

/**
 * load character into active list, if not already loaded, then increase
 * reference count of character.
 */
struct character *character_get(unsigned character_id)
{
	struct character *curr;

	/* look for character in the cache. */
	for (curr = LIST_TOP(character_cache); curr; curr = LIST_NEXT(curr, character_cache)) {
		if (curr->id == character_id) break;
	}

	if (!curr) {
		/* not in the cache? load the character. */
		curr = character_load(character_id);
	}

	if (curr) {
		/* place entry at the top of the cache. */
		LIST_INSERT_HEAD(&character_cache, curr, character_cache);
		curr->refcount++;
	}

	if (!curr) {
		LOG_WARNING("could not access character \"%u\"", character_id);
	}

	return curr;
}

/**
 * reduce reference count of character.
 */
void
character_put(struct character *ch)
{
	assert(ch != NULL);

	ch->refcount--;

	/* TODO: hold onto the character longer to support caching. */
	if (ch->refcount <= 0) {
		character_save(ch);
		character_ll_free(ch);
	}
}

struct character *character_new(void)
{
	struct character *ret;
	long id;

	ret = character_ll_alloc();

	if (!ret) return NULL;

	/* allocate next entry from a pool. */
	id = freelist_alloc(character_id_freelist, 1);

	if (id < 0) {
		LOG_CRITICAL("could not allocate new character id.");
		character_ll_free(ret);
		return NULL;
	}

	ret->id = id;

	/* save character immediately on creation. */
	ret->dirty_fl = 1;
	character_save(ret);

	/* place entry at the top of the cache. */
	LIST_INSERT_HEAD(&character_cache, ret, character_cache);
	ret->refcount++;

	return ret;
}

/**
 * preflight all of the characters by loading every one of them.
 */
static int
character_preflight(void)
{
	struct fdb_iterator *it;
	const char *id;

	it = fdb_iterator_begin(DOMAIN_CHARACTER);

	if (!it) {
		LOG_CRITICAL("could not load characters!");
		return 0; /* could not load. */
	}

	while ((id = fdb_iterator_next(it))) {
		struct character *ch;
		unsigned character_id;
		char *endptr;
		LOG_DEBUG("Found character: \"%s\"", id);
		character_id = strtoul(id, &endptr, 10);

		if (*endptr) {
			LOG_CRITICAL("character id \"%s\" is invalid!", id);
			fdb_iterator_end(it);
			return 0; /* could not load */
		}

		ch = character_load(character_id);

		if (!ch) {
			LOG_CRITICAL("could not load character id \"%u\"", character_id);
			fdb_iterator_end(it);
			return 0; /* could not load */
		}

		/* compare ch->id with character_id */
		if (ch->id != character_id) {
			LOG_CRITICAL("bad or non-matching character id \"%u\"", character_id);
			character_ll_free(ch);
			fdb_iterator_end(it);
		}

		/* allocate id from the pool */
		if (!freelist_thwack(character_id_freelist, ch->id, 1)) {
			LOG_CRITICAL("bad or duplicate character id \"%u\"", character_id);
			character_ll_free(ch);
			fdb_iterator_end(it);
			return 0; /* could not load */
		}

		character_ll_free(ch);
	}

	fdb_iterator_end(it);

	return 1; /* success */
}
/**
 *
 */
int
character_initialize(void)
{
	LOG_INFO("Character sub-system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	character_id_freelist = freelist_new(1, ID_MAX);
	if (!character_id_freelist) {
		LOG_CRITICAL("could not allocate IDs!");
		return -1;
	}

	if (!fdb_domain_init(DOMAIN_CHARACTER)) {
		LOG_CRITICAL("could not access database!");
		return -1;
	}

	/* load all characters to check and to configure pool space. */
	if (!character_preflight()) {
		LOG_CRITICAL("could not load characters!");
		return -1;
	}

	return 0;
}

/**
 *
 */
void
character_shutdown(void)
{
	LOG_INFO("Character sub-system shutting down...");
	LOG_INFO("Character sub-system ended.");
}
