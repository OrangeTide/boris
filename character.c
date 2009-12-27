/**
 * @file character.c
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2009 Dec 26
 *
 * Plugin that provides a Character service.
 *
 * Copyright 2009 Jon Mayo
 * Ms-RL : See COPYING.txt for complete license text.
 *
 */
#include <assert.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "boris.h"

/******************************************************************************
 * Types
 ******************************************************************************/

/**
 *
 */
struct plugin_character_class {
	struct plugin_basic_class base_class;
	struct plugin_character_interface character_interface;
};

struct character {
	LIST_ENTRY(struct character) character_cache; /**< currently loaded characters. */
	int dirty_fl;
	int refcount;
	/* part of the character saved to disk is below this line. */
	unsigned id;
	struct description_string name, desc;
	char *owner, *controllers;
	struct attr_list extra_values;
};

LIST_HEAD(struct character_cache, struct character);
/******************************************************************************
 * Prototypes
 ******************************************************************************/
extern const struct plugin_character_class plugin_class;

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
};

/** list of all loaded characters. */
static struct character_cache character_cache;

static struct freelist character_id_freelist;
/******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * deallocate a character structure immediately.
 */
static void character_ll_free(struct character *ch) {
	unsigned i;

	assert(ch != NULL);
	if(!ch) return;

	LIST_REMOVE(ch, character_cache);
	LIST_ENTRY_INIT(ch, character_cache);

	for(i=0;i<NR(attrinfo);i++) {
		if(attrinfo[i].type==VALUE_TYPE_STRING) {
			char **strp=(char**)((char*)ch+attrinfo[i].ofs);
			free(*strp);
			*strp=NULL;
		}
	}

	attr_list_free(&ch->extra_values);

	free(ch);
}

/**
 * allocate an empty character.
 */
static struct character *character_ll_alloc(void) {
	struct character *ret;
	ret=calloc(1, sizeof *ret);
	if(!ret) {
		b_log(B_LOG_CRIT, "character", "out of memory");
	}
	return ret;
}

/**
 *
 */
static int character_attr_set(struct character *ch, const char *name, const char *value) {
	unsigned i;
	int res;

	assert(ch != NULL);
	if(!ch) return 0;

	for(i=0;i<NR(attrinfo);i++) {
		if(!strcasecmp(name, attrinfo[i].name)) {
			ch->dirty_fl=1;
			return value_set(value, attrinfo[i].type, (char*)ch+attrinfo[i].ofs);
		}
	}
	res=parse_attr(name, value, &ch->extra_values);
	if(res) {
		ch->dirty_fl=1;
	}
	return res;
}

/**
 *
 */
static const char *character_attr_get(struct character *ch, const char *name) {
	unsigned i;
	struct attr_entry *at;

	assert(ch != NULL);
	if(!ch) return NULL;

	for(i=0;i<NR(attrinfo);i++) {
		if(!strcasecmp(name, attrinfo[i].name)) {
			return value_get(attrinfo[i].type, (char*)ch+attrinfo[i].ofs);
		}
	}
	at=attr_find(&ch->extra_values, name);
	return at ? at->value : NULL;
}

/**
 * load a character from fdb.
 */
static struct character *character_load(unsigned character_id) {
	struct character *ch;
	struct fdb_read_handle *h;
	const char *name, *value;

	assert(character_id > 0);
	if(character_id<=0) return NULL;

	h=fdb.read_begin_uint(DOMAIN_CHARACTER, character_id);
	if(!h) {
		b_log(B_LOG_ERROR, "character", "could not load character \"%u\"", character_id);
		return NULL;
	}

	ch=character_ll_alloc();
	if(!ch) {
		fdb.read_end(h);
		return NULL;
	}

	while(fdb.read_next(h, &name, &value)) {
		if(!character_attr_set(ch, name, value)) {
			b_log(B_LOG_ERROR, "character", "could not load character \"%u\"", character_id);
			character_ll_free(ch);
			fdb.read_end(h);
			return NULL;
		}
	}

	fdb.read_end(h);

	if(character_id!=ch->id) {
		b_log(B_LOG_ERROR, "character", "could not load character \"%u\" (bad, missing or mismatched id)", character_id);
		character_ll_free(ch);
		return NULL;
	}
	return ch;
}

/**
 * save a character record, but only if the dirty_fl is set.
 */
static int character_save(struct character *ch) {
	struct attr_entry *curr;
	struct fdb_write_handle *h;
	unsigned i;

	assert(ch != NULL);
	if(!ch->dirty_fl) return 1; /* already saved - don't do it again. */

	h=fdb.write_begin_uint(DOMAIN_CHARACTER, ch->id);
	if(!h) {
		b_log(B_LOG_ERROR, "character", "could not save character \"%u\"", ch->id);
		return 0; /* failure */
	}

	for(i=0;i<NR(attrinfo);i++) {
		void *base=((char*)ch+attrinfo[i].ofs);
		switch(attrinfo[i].type) {
			case VALUE_TYPE_UINT:
				fdb.write_format(h, attrinfo[i].name, "%u", *(unsigned*)base);
				break;
			case VALUE_TYPE_STRING:
				if(*(char**)base)
					fdb.write_pair(h, attrinfo[i].name, *(char**)base);
				break;
		}
	}
	for(curr=LIST_TOP(ch->extra_values);curr;curr=LIST_NEXT(curr, list)) {
		fdb.write_pair(h, curr->name, curr->value);
	}

	if(!fdb.write_end(h)) {
		b_log(B_LOG_ERROR, "character", "could not save character \"%u\"", ch->id);
		return 0; /* failure */
	}

	ch->dirty_fl=0;
	b_log(B_LOG_INFO, "character", "saved character \"%u\"", ch->id);
	return 1;
}

/**
 * load character into active list, if not already loaded, then increase
 * reference count of character.
 */
static struct character *character_get(unsigned character_id) {
	struct character *curr;

	/* look for character in the cache. */
	for(curr=LIST_TOP(character_cache);curr;curr=LIST_NEXT(curr, character_cache)) {
		if(curr->id==character_id) break;
	}

	if(!curr) {
		/* not in the cache? load the character. */
		curr=character_load(character_id);
	}
	if(curr) {
		/* place entry at the top of the cache. */
		LIST_INSERT_HEAD(&character_cache, curr, character_cache);
		curr->refcount++;
	}
	if(!curr) {
		b_log(B_LOG_WARN, "character", "could not access character \"%u\"", character_id);
	}
	return curr;
}

/**
 * reduce reference count of character.
 */
static void character_put(struct character *ch) {
	assert(ch != NULL);

	ch->refcount--;
	/* TODO: hold onto the character longer to support caching. */
	if(ch->refcount<=0) {
		character_save(ch);
		character_ll_free(ch);
	}
}

static struct character *character_new(void) {
	struct character *ret;
	long id;

	ret=character_ll_alloc();
	if(!ret) return NULL;

	/* allocate next entry from a pool. */
	id=freelist_alloc(&character_id_freelist, 1);
	if(id<0) {
		b_log(B_LOG_CRIT, "character", "could not allocate new character id.");
		character_ll_free(ret);
		return NULL;
	}
	ret->id=id;

	/* save character immediately on creation. */
	ret->dirty_fl=1;
	character_save(ret);

	/* place entry at the top of the cache. */
	LIST_INSERT_HEAD(&character_cache, ret, character_cache);
	ret->refcount++;
	return ret;
}

/**
 * preflight all of the characters by loading every one of them.
 */
static int character_preflight(void) {
	struct fdb_iterator *it;
	const char *id;

	it=fdb.iterator_begin(DOMAIN_CHARACTER);
	if(!it) {
		b_log(B_LOG_CRIT, "character", "could not load characters!");
		return 0; /* could not load. */
	}

	while((id=fdb.iterator_next(it))) {
		struct character *ch;
		unsigned character_id;
		char *endptr;
		b_log(B_LOG_DEBUG, "character", "Found character: \"%s\"", id);
		character_id=strtoul(id, &endptr, 10);
		if(*endptr) {
			b_log(B_LOG_CRIT, "character", "character id \"%s\" is invalid!", id);
			fdb.iterator_end(it);
			return 0; /* could not load */
		}
		ch=character_load(character_id);
		if(!ch) {
			b_log(B_LOG_CRIT, "character", "could not load character id \"%u\"", character_id);
			fdb.iterator_end(it);
			return 0; /* could not load */
		}
		/* compare ch->id with character_id */
		if(ch->id!=character_id) {
			b_log(B_LOG_CRIT, "character", "bad or non-matching character id \"%u\"", character_id);
			character_ll_free(ch);
			fdb.iterator_end(it);
		}
		/* allocate id from the pool */
		if(!freelist_thwack(&character_id_freelist, ch->id, 1)) {
			b_log(B_LOG_CRIT, "character", "bad or duplicate character id \"%u\"", character_id);
			character_ll_free(ch);
			fdb.iterator_end(it);
			return 0; /* could not load */
		}
		character_ll_free(ch);
	}
	fdb.iterator_end(it);
	return 1; /* success */
}
/**
 *
 */
static int initialize(void) {
	b_log(B_LOG_INFO, "character", "Character plugin loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	freelist_init(&character_id_freelist);
	freelist_pool(&character_id_freelist, 1, ID_MAX);

	fdb.domain_init(DOMAIN_CHARACTER);
	/* load all characters to check and to configure pool space. */
	if(!character_preflight()) {
		b_log(B_LOG_CRIT, "character", "could not load characters!");
		return 0;
	}
	service_attach_character(&plugin_class.base_class, &plugin_class.character_interface);
	return 1;
}

/**
 *
 */
static int shutdown(void) {
	b_log(B_LOG_INFO, "character", "Character plugin shutting down...");
	service_detach_character(&plugin_class.base_class);
	b_log(B_LOG_INFO, "character", "Character plugin ended.");
	return 1;
}


/******************************************************************************
 * Class
 ******************************************************************************/

/**
 *
 */
const struct plugin_character_class plugin_class = {
	.base_class = { PLUGIN_API, "character", initialize, shutdown },
	.character_interface = {
		character_get, character_put, character_new,
		character_attr_set, character_attr_get,
		character_save
	},
};
