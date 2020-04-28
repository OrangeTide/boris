/**
 * @file room.c
 *
 * Plugin that provides basic room support.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Dec 25
 *
 * Copyright (c) 2009-2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */
#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "boris.h"
#include "list.h"
#include "plugin.h"

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

struct plugin_room_class {
	struct plugin_basic_class base_class;
	struct plugin_room_interface room_interface;
};

LIST_HEAD(struct room_cache, struct room);

/******************************************************************************
 * Prototypes
 ******************************************************************************/
extern const struct plugin_room_class plugin_class;

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
static void room_ll_free(struct room *r)
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
static int room_attr_set(struct room *r, const char *name, const char *value)
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

static const char *room_attr_get(struct room *r, const char *name)
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

static struct room *room_load(unsigned room_id)
{
	struct room *r;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */
	struct fdb_read_handle *h;
	const char *name, *value;

	assert(room_id > 0);

	if (room_id <= 0)
		return NULL;

	snprintf(numbuf, sizeof numbuf, "%u", room_id);

	h = fdb_read_begin("rooms", numbuf);

	if (!h) {
		b_log(B_LOG_ERROR, "room", "could not load room \"%s\"", numbuf);
		return NULL;
	}

	r = calloc(1, sizeof * r);

	if (!r) {
		/* TODO: do perror? */
		b_log(B_LOG_ERROR, "calloc", "not allocate room \"%s\"", numbuf);
		fdb_read_end(h);
		return NULL;
	}

	while (fdb_read_next(h, &name, &value)) {
		if (!room_attr_set(r, name, value)) {
			b_log(B_LOG_ERROR, "room", "could not load room \"%s\"", numbuf);
			room_ll_free(r);
			fdb_read_end(h);
			return NULL;
		}
	}

	fdb_read_end(h);

	/* r->id wasn't set, this is a problem. */
	if (!r->id) {
		b_log(B_LOG_ERROR, "room", "id not set for room \"%u\"", room_id);
		room_ll_free(r);
		return NULL;
	}

	/* r->id doesn't match the file the room is stored under. */
	if (r->id != room_id) {
		b_log(B_LOG_ERROR, "room", "id was set to \"%u\" but should be \"%u\"", r->id, room_id);
		room_ll_free(r);
		return NULL;
	}

	return r;
}

/**
 * write a room structure to disk, if it is not dirty (dirty_fl).
 */
static int room_save(struct room *r)
{
	struct attr_entry *curr;
	struct fdb_write_handle *h;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */

	assert(r != NULL);

	if (!r->dirty_fl)
		return 1; /* already saved - don't do it again. */

	/* refuse to save room 0. */
	if (!r->id) {
		b_log(B_LOG_ERROR, "room", "attempted to save room \"%u\", but it is reserved", r->id);
		return 0;
	}

	snprintf(numbuf, sizeof numbuf, "%u", r->id);

	h = fdb_write_begin("rooms", numbuf);

	if (!h) {
		b_log(B_LOG_ERROR, "room", "could not save room \"%s\"", numbuf);
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
		b_log(B_LOG_ERROR, "room", "could not save room \"%s\"", numbuf);
		return 0; /* failure */
	}

	r->dirty_fl = 0;
	b_log(B_LOG_INFO, "room", "saved room \"%s\"", numbuf);
	return 1;
}

/**
 * load room into cache, if not already loaded, then increase reference count
 * of room.
 */
static struct room *room_get(unsigned room_id)
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
		b_log(B_LOG_WARN, "room", "could not access room \"%u\"", room_id);
	}

	return curr;
}

/**
 * reduce reference count of room.
 */
static void room_put(struct room *r)
{
	assert(r != NULL);

	r->refcount--;

	/* TODO: hold onto the room longer to support caching. */
	if (r->refcount <= 0) {
		room_save(r);
		room_ll_free(r);
	}
}

static int initialize(void)
{
	struct fdb_iterator *it;
	const char *id;

	b_log(B_LOG_INFO, "room", "Room system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&room_cache);

	fdb_domain_init("rooms");

	it = fdb_iterator_begin("rooms");

	if (!it) {
		b_log(B_LOG_CRIT, "room", "could not load rooms!");
		return 0; /* could not load. */
	}

	/* preflight all of the rooms. */
	while ((id = fdb_iterator_next(it))) {
		struct room *r;
		unsigned room_id;
		char *endptr;
		b_log(B_LOG_DEBUG, "room", "Found room: \"%s\"", id);
		room_id = strtoul(id, &endptr, 10);

		if (*endptr) {
			b_log(B_LOG_CRIT, "room", "room id \"%s\" is invalid!", id);
			fdb_iterator_end(it);
			return 0; /* could not load */
		}

		r = room_load(room_id);

		if (!r) {
			b_log(B_LOG_CRIT, "room", "could not load rooms!");
			fdb_iterator_end(it);
			return 0; /* could not load */
		}

		room_ll_free(r);
	}

	fdb_iterator_end(it);

	service_attach_room(&plugin_class.base_class, &plugin_class.room_interface);
	return 1;
}

static int room_shutdown(void)
{
	struct room *curr;
	b_log(B_LOG_INFO, "room", "Room system shutting down..");

	/* check to make sure no rooms are still in use. */
	for (curr = LIST_TOP(room_cache); curr; curr = LIST_NEXT(curr, room_cache)) {
		if (curr->refcount > 0) {
			b_log(B_LOG_ERROR, "room", "cannot shut down, room \"%u\" still in use.", curr->id);
			return 0; /* refuse to unload */
		}
	}

	/* save all dirty objects and free all data. */
	while ((curr = LIST_TOP(room_cache))) {
		LIST_REMOVE(curr, room_cache);
		room_save(curr);
		room_ll_free(curr);
	}

	service_detach_room(&plugin_class.base_class);
	b_log(B_LOG_INFO, "room", "Room system ended.");
	return 1;
}

/******************************************************************************
 * Class
 ******************************************************************************/

const struct plugin_room_class plugin_class = {
	.base_class = { PLUGIN_API, "room", initialize, room_shutdown },
	.room_interface = { room_get, room_put, room_attr_set, room_attr_get, room_save }
};
