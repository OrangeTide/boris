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
#include "list.h"
#include "fdb.h"

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
	unsigned id;
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

/** list of all loaded rooms. */
static struct room_cache room_cache;

/******************************************************************************
 * Functions
 ******************************************************************************/

/**
 * deallocate a room structure immediately.
 */
static void
room_ll_free(struct room *r)
{
	assert(r != NULL);

	LIST_REMOVE(r, room_cache);
	LIST_ENTRY_INIT(r, room_cache);

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
		res = parse_uint(name, value, &r->id);
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
	static char numbuf[22]; /* big enough for a signed 64-bit decimal */

	if (!strcasecmp("id", name)) {
		snprintf(numbuf, sizeof numbuf, "%u", r->id);
		return numbuf;
	} else if (!strcasecmp("name.short", name))
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
room_load(unsigned room_id)
{
	struct room *r;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */
	struct fdb_read_handle *h;
	const char *name, *value;

	assert(room_id > 0);

	if (room_id <= 0)
		return NULL;

	snprintf(numbuf, sizeof numbuf, "%u", room_id);

	h = fdb_read_begin(DOMAIN_ROOM, numbuf);

	if (!h) {
		LOG_ERROR("could not load room \"%s\"", numbuf);
		return NULL;
	}

	r = calloc(1, sizeof * r);

	if (!r) {
		/* TODO: do perror? */
		LOG_ERROR("not allocate room \"%s\"", numbuf);
		fdb_read_end(h);
		return NULL;
	}

	while (fdb_read_next(h, &name, &value)) {
		if (!room_attr_set(r, name, value)) {
			LOG_ERROR("could not load room \"%s\"", numbuf);
			room_ll_free(r);
			fdb_read_end(h);
			return NULL;
		}
	}

	fdb_read_end(h);

	/* r->id wasn't set, this is a problem. */
	if (!r->id) {
		LOG_ERROR("id not set for room \"%u\"", room_id);
		room_ll_free(r);
		return NULL;
	}

	/* r->id doesn't match the file the room is stored under. */
	if (r->id != room_id) {
		LOG_ERROR("id was set to \"%u\" but should be \"%u\"", r->id, room_id);
		room_ll_free(r);
		return NULL;
	}

	return r;
}

/**
 * write a room structure to disk, if it is not dirty (dirty_fl).
 */
int
room_save(struct room *r)
{
	struct attr_entry *curr;
	struct fdb_write_handle *h;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */

	assert(r != NULL);

	if (!r->dirty_fl)
		return 1; /* already saved - don't do it again. */

	/* refuse to save room 0. */
	if (!r->id) {
		LOG_ERROR("attempted to save room \"%u\", but it is reserved", r->id);
		return 0;
	}

	snprintf(numbuf, sizeof numbuf, "%u", r->id);

	h = fdb_write_begin(DOMAIN_ROOM, numbuf);

	if (!h) {
		LOG_ERROR("could not save room \"%s\"", numbuf);
		return 0; /* failure */
	}

	fdb_write_format(h, "id", "%u", r->id);

	if (r->name.short_str)
		fdb_write_pair(h, "name.short", r->name.short_str);

	if (r->name.long_str)
		fdb_write_pair(h, "name.long", r->name.long_str);

	if (r->desc.short_str)
		fdb_write_pair(h, "desc.short", r->desc.short_str);

	if (r->desc.long_str)
		fdb_write_pair(h, "desc.long", r->desc.long_str);

	if (r->owner)
		fdb_write_pair(h, "owner", r->owner);

	if (r->creator)
		fdb_write_pair(h, "creator", r->creator);

	for (curr = LIST_TOP(r->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		fdb_write_pair(h, curr->name, curr->value);
	}

	if (!fdb_write_end(h)) {
		LOG_ERROR("could not save room \"%s\"", numbuf);
		return 0; /* failure */
	}

	r->dirty_fl = 0;
	LOG_INFO("saved room \"%s\"", numbuf);
	return 1;
}

/**
 * load room into cache, if not already loaded, then increase reference count
 * of room.
 */
struct room *room_get(unsigned room_id)
{
	struct room *curr;

	/* refuse to open room 0. */
	if (!room_id)
		return NULL;

	/* look for room in the cache. */
	for (curr = LIST_TOP(room_cache); curr; curr = LIST_NEXT(curr, room_cache)) {
		if (curr->id == room_id) break;
	}

	if (!curr) {
		/* not in the cache? load the room. */
		curr = room_load(room_id);
	}

	if (curr) {
		/* place entry at the top of the cache. */
		LIST_INSERT_HEAD(&room_cache, curr, room_cache);
		curr->refcount++;
	}

	if (!curr) {
		LOG_WARNING("could not access room \"%u\"", room_id);
	}

	return curr;
}

/**
 * reduce reference count of room.
 */
void
room_put(struct room *r)
{
	assert(r != NULL);

	r->refcount--;

	/* TODO: hold onto the room longer to support caching. */
	if (r->refcount <= 0) {
		room_save(r);
		room_ll_free(r);
	}
}

int
room_initialize(void)
{
	struct fdb_iterator *it;
	const char *id;

	LOG_INFO("Room system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&room_cache);

	if (!fdb_domain_init(DOMAIN_ROOM)) {
		LOG_CRITICAL("could not load rooms!");
		return -1; /* could not load. */
	}

	it = fdb_iterator_begin(DOMAIN_ROOM);

	if (!it) {
		LOG_CRITICAL("could not load rooms!");
		return -1; /* could not load. */
	}

	/* preflight all of the rooms. */
	while ((id = fdb_iterator_next(it))) {
		struct room *r;
		unsigned room_id;
		char *endptr;
		LOG_DEBUG("Found room: \"%s\"", id);
		room_id = strtoul(id, &endptr, 10);

		if (*endptr) {
			LOG_CRITICAL("room id \"%s\" is invalid!", id);
			fdb_iterator_end(it);
			return -1; /* could not load */
		}

		r = room_load(room_id);

		if (!r) {
			LOG_CRITICAL("could not load rooms!");
			fdb_iterator_end(it);
			return -1; /* could not load */
		}

		room_ll_free(r);
	}

	fdb_iterator_end(it);

	return 0; /* success */
}

void
room_shutdown(void)
{
	struct room *curr;
	struct room_cache blocked_cache;

	LOG_INFO("Room system shutting down..");

	/* save all dirty objects and free all data. */
	LIST_INIT(&blocked_cache); /* keep a temporary list of unfreed rooms */

	while ((curr = LIST_TOP(room_cache))) {
		LIST_REMOVE(curr, room_cache);
		room_save(curr);

		/* check to make sure no rooms are still in use. */
		if (curr->refcount > 0) {
			LOG_ERROR("cannot shut down, room \"%u\" still in use.", curr->id);
			LIST_INSERT_HEAD(&blocked_cache, curr, room_cache);
		} else {
			room_ll_free(curr);
		}
	}

	if (LIST_TOP(blocked_cache)) {
		/* we could not free these rooms, sorry! */
		room_cache = blocked_cache;
	}

	LOG_INFO("Room system ended.");
}
