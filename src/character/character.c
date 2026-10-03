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
#include "muddb.h"
#include "obj.h"

#define LOG_SUBSYSTEM "character"
#include "log.h"

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * A character is an OBJ in the unified cache, keyed "chars/<id>" in the objs
 * domain. struct character is a thin, per-reference handle over that OBJ: it
 * pins the object (obj_get/obj_create) for its lifetime and releases it on
 * character_put. Attributes are object properties; the location attribute
 * "room.current" maps to the %location forward pointer and the contents index
 * via obj_move/obj_location, with the "rooms/" prefix stripped or prepended so
 * the bare-room-id contract the rest of the code relies on is preserved.
 */

/* the prototype every player character inherits from (see vm-object-model L6) */
#define CHARACTER_PROTOTYPE DOMAIN_TEMPLATE "/pc"

/* "rooms/" length, used to strip/prepend the room-object prefix */
#define ROOM_PREFIX ROOM_ROOTDIR "/"
#define ROOM_PREFIX_LEN (sizeof(ROOM_PREFIX) - 1)

/******************************************************************************
 * Types
 ******************************************************************************/

/*
 * A per-reference handle over a character OBJ. ch->obj is a pinned reference
 * owned by this handle; ch->obj_id is its cache id ("chars/<id>"). Two handles
 * for the same id hold two pins over the same cached object, which is fine --
 * each character_put releases one.
 */
struct character {
	OBJ *obj;             /**< pinned backing object */
	unsigned id;          /**< numeric identity */
	char obj_id[24];      /**< "chars/<id>" cache key */
	char *room_scratch;   /**< borrowed-return buffer for room.current */
	struct attr_list extras_view; /**< transient non-builtin view */
};

/******************************************************************************
 * Globals
 ******************************************************************************/

/* built-in attribute names, excluded from the extras view */
static const char *const builtin_attrs[] = {
	"id", "name.short", "name.long", "desc.short", "desc.long",
	"owner", "controllers", "room.current", "room.home", NULL,
};

static struct freelist *character_id_freelist;

/******************************************************************************
 * Functions
 ******************************************************************************/

static int
is_builtin(const char *name)
{
	int i;

	for (i = 0; builtin_attrs[i]; i++)
		if (!strcasecmp(name, builtin_attrs[i]))
			return 1;
	return 0;
}

/* allocate a handle wrapping an already-pinned object */
static struct character *
handle_new(OBJ *obj, unsigned id)
{
	struct character *ch = calloc(1, sizeof *ch);

	if (!ch) {
		LOG_CRITICAL("out of memory");
		return NULL;
	}
	ch->obj = obj;
	ch->id = id;
	snprintf(ch->obj_id, sizeof ch->obj_id, "%s/%u", DOMAIN_CHARACTER, id);
	LIST_INIT(&ch->extras_view);
	return ch;
}

int
character_attr_set(struct character *ch, const char *name, const char *value)
{
	if (!ch || !name)
		return 0;

	/* location is the %location forward pointer, written via obj_move. The
	 * stored value is the full room object id; callers pass a bare room id. */
	if (!strcasecmp(name, "room.current")) {
		char container[OBJ_PATH_MAX];

		if (value && *value) {
			snprintf(container, sizeof container, "%s%s",
				ROOM_PREFIX, value);
			return obj_move(ch->obj_id, container) == OBJ_OK;
		}
		return obj_move(ch->obj_id, NULL) == OBJ_OK;
	}

	if (obj_prop_set(ch->obj, name, value) != OBJ_OK)
		return 0;
	obj_mark_dirty(ch->obj);
	return 1;
}

const char *
character_attr_get(struct character *ch, const char *name)
{
	if (!ch || !name)
		return NULL;

	if (!strcasecmp(name, "room.current")) {
		char *loc = obj_location(ch->obj_id);
		const char *bare;

		free(ch->room_scratch);
		ch->room_scratch = NULL;
		if (!loc)
			return NULL;
		bare = loc;
		if (!strncmp(loc, ROOM_PREFIX, ROOM_PREFIX_LEN))
			bare = loc + ROOM_PREFIX_LEN;
		ch->room_scratch = strdup(bare);
		free(loc);
		return ch->room_scratch;
	}

	return obj_prop_get(ch->obj, name);
}

struct attr_list *
character_attrs_extras(struct character *ch)
{
	OBJ_ITER *it;
	const char *key, *value;

	if (!ch)
		return NULL;

	/* rebuild the transient view from the object's non-builtin props */
	attr_list_free(&ch->extras_view);
	LIST_INIT(&ch->extras_view);

	it = obj_iter_begin(ch->obj);
	if (!it)
		return &ch->extras_view;
	while (obj_iter_next(it, &key, &value)) {
		if (key[0] == '%' || key[0] == '!')
			continue;               /* structural / tombstone */
		if (is_builtin(key))
			continue;
		attr_add(&ch->extras_view, key, value);
	}
	obj_iter_end(it);

	return &ch->extras_view;
}

OBJ *
character_obj(struct character *ch)
{
	return ch ? ch->obj : NULL;
}

const char *
character_obj_id(struct character *ch)
{
	return ch ? ch->obj_id : NULL;
}

int
character_save(struct character *ch)
{
	if (!ch)
		return 0;
	return obj_save(ch->obj_id) == OBJ_OK;
}

struct character *
character_get(unsigned character_id)
{
	char idbuf[24];
	OBJ *obj;
	struct character *ch;

	if (character_id == 0)
		return NULL;

	snprintf(idbuf, sizeof idbuf, "%s/%u", DOMAIN_CHARACTER, character_id);
	obj = obj_get(idbuf);
	if (!obj) {
		LOG_WARNING("could not access character \"%u\"", character_id);
		return NULL;
	}

	ch = handle_new(obj, character_id);
	if (!ch)
		obj_release(obj);
	return ch;
}

void
character_put(struct character *ch)
{
	if (!ch)
		return;

	character_save(ch);             /* durability point (e.g. logout) */
	obj_release(ch->obj);
	attr_list_free(&ch->extras_view);
	free(ch->room_scratch);
	free(ch);
}

struct character *
character_new(void)
{
	char idbuf[32];
	char numbuf[22];
	long id;
	OBJ *obj;
	struct character *ch;

	id = freelist_alloc(character_id_freelist, 1);
	if (id < 0) {
		LOG_CRITICAL("could not allocate new character id.");
		return NULL;
	}

	snprintf(idbuf, sizeof idbuf, "%s/%ld", DOMAIN_CHARACTER, id);
	obj = obj_create(idbuf);
	if (!obj) {
		LOG_ERROR("could not create character object \"%s\"", idbuf);
		freelist_pool(character_id_freelist, (unsigned)id, 1);
		return NULL;
	}

	/* seed identity and the player-character prototype */
	snprintf(numbuf, sizeof numbuf, "%ld", id);
	obj_prop_set(obj, "id", numbuf);
	obj_prop_set_internal(obj, "%parent", CHARACTER_PROTOTYPE);
	obj_mark_dirty(obj);

	ch = handle_new(obj, (unsigned)id);
	if (!ch) {
		obj_release(obj);
		return NULL;
	}

	character_save(ch);             /* persist on creation */
	return ch;
}

/* reserve the ids of existing character records so they are not reused. New
 * records live as "chars/<id>" in the objs domain; legacy records are bare
 * keys in the chars domain. A cross-source duplicate is expected, not an
 * error, so the thwack result is ignored. */
static void
seed_freelist_from(const char *domain, int require_prefix)
{
	MUDDB_ITER *it;
	const char *key;
	const size_t plen = sizeof(DOMAIN_CHARACTER "/") - 1;

	it = muddb_iter_begin(mud_db, domain);
	if (!it)
		return;
	while ((key = muddb_iter_next(it))) {
		const char *idstr = key;
		unsigned long id;
		char *endptr;

		if (require_prefix) {
			if (strncmp(key, DOMAIN_CHARACTER "/", plen))
				continue;       /* a non-character object */
			idstr = key + plen;
		}
		id = strtoul(idstr, &endptr, 10);
		if (*endptr || id == 0 || id > (unsigned long)ID_MAX) {
			LOG_WARNING("character key \"%s\": unparseable id", key);
			continue;
		}
		freelist_thwack(character_id_freelist, (unsigned)id, 1);
	}
	muddb_iter_end(it);
}

/* seed a minimal prototype so %parent = templates/pc resolves (L6) */
static void
seed_prototype(void)
{
	OBJ *proto = obj_get(CHARACTER_PROTOTYPE);

	if (proto) {
		obj_release(proto);
		return;                         /* already present */
	}
	proto = obj_create(CHARACTER_PROTOTYPE);
	if (!proto) {
		LOG_WARNING("could not seed prototype \"%s\"", CHARACTER_PROTOTYPE);
		return;
	}
	obj_prop_set(proto, "name.short", "a person");
	obj_mark_dirty(proto);
	obj_save(CHARACTER_PROTOTYPE);
	obj_release(proto);
}

/* ensure a reserved owner identity exists. These are stable non-player
 * characters that admin content and agents can be owned by via @chown, so an
 * object need not be owned by a real player. Seeded on every startup, so an
 * existing database is retrofitted too. */
static void
seed_owner(const char *key, const char *name)
{
	OBJ *o = obj_get(key);

	if (o) {
		obj_release(o);
		return;                         /* already present */
	}
	o = obj_create(key);
	if (!o) {
		LOG_WARNING("could not seed owner \"%s\"", key);
		return;
	}
	obj_prop_set(o, "name.short", name);
	obj_mark_dirty(o);
	obj_save(key);
	obj_release(o);
}

int
character_initialize(void)
{
	LOG_INFO("Character sub-system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");

	character_id_freelist = freelist_new(1, ID_MAX);
	if (!character_id_freelist) {
		LOG_CRITICAL("could not allocate IDs!");
		return -1;
	}

	/* reserve ids from both the new and legacy record layouts */
	seed_freelist_from(DOMAIN_OBJS, 1);
	seed_freelist_from(DOMAIN_CHARACTER, 0);

	seed_prototype();
	seed_owner("chars/system", "system");
	seed_owner("chars/nobody", "nobody");

	return 0;
}

void
character_shutdown(void)
{
	LOG_INFO("Character sub-system shutting down...");

	/* character objects are flushed by obj_shutdown (registered earlier, so
	 * it runs after this atexit handler); nothing to save here. */
	freelist_free(character_id_freelist);
	character_id_freelist = NULL;

	LOG_INFO("Character sub-system ended.");
}
