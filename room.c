/**
 * @file room.c
 *
 * basic room support.
 *
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
static void room_ll_free(struct room *r) {
	assert(r != NULL);

	LIST_REMOVE(r, room_cache);
	LIST_ENTRY_INIT(r, room_cache);

	free(r->name.short_str); r->name.short_str=NULL;
	free(r->name.long_str); r->name.long_str=NULL;

	free(r->desc.short_str); r->desc.short_str=NULL;
	free(r->desc.long_str); r->desc.long_str=NULL;

	free(r->owner); r->owner=NULL;
	free(r->creator); r->creator=NULL;

	attr_list_free(&r->extra_values);

	free(r);
}

/**
 * set an attribute on a room.
 */
static int room_attr_set(struct room *r, const char *name, const char *value) {
	int res;

	assert(r != NULL);
	assert(name != NULL);
	assert(value != NULL);

	if(!r) return 0;

	if(!strcasecmp("id", name))
		res=parse_uint(name, value, &r->id);
	else if(!strcasecmp("name.short", name))
		res=parse_str(name, value, &r->name.short_str);
	else if(!strcasecmp("name.long", name))
		res=parse_str(name, value, &r->name.long_str);
	else if(!strcasecmp("desc.short", name))
		res=parse_str(name, value, &r->desc.short_str);
	else if(!strcasecmp("desc.long", name))
		res=parse_str(name, value, &r->desc.long_str);
	else if(!strcasecmp("creator", name))
		res=parse_str(name, value, &r->creator);
	else if(!strcasecmp("owner", name))
		res=parse_str(name, value, &r->owner);
	else
		res=parse_attr(name, value, &r->extra_values);

	if(res)
		r->dirty_fl=1;
	return res;
}

static const char *room_attr_get(struct room *r, const char *name) {
	static char numbuf[22]; /* big enough for a signed 64-bit decimal */

	if(!strcasecmp("id", name)) {
		snprintf(numbuf, sizeof numbuf, "%u", r->id);
	} else if(!strcasecmp("name.short", name))
		return r->name.short_str;
	else if(!strcasecmp("name.long", name))
		return r->name.long_str;
	else if(!strcasecmp("desc.short", name))
		return r->desc.short_str;
	else if(!strcasecmp("desc.long", name))
		return r->desc.long_str;
	else if(!strcasecmp("creator", name))
		return r->creator;
	else if(!strcasecmp("owner", name))
		return r->owner;
	else {
		struct attr_entry *at;
		at=attr_find(&r->extra_values, name);
		if(at) return at->value;
	}

	return NULL; /* failure - not found. */
}

static struct room *room_load(int room_id) {
	struct room *r;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */
	struct fdb_read_handle *h;
	const char *name, *value;

	assert(room_id > 0);
	if(room_id<=0) return NULL;

	snprintf(numbuf, sizeof numbuf, "%u", room_id);

	h=fdb.read_begin("rooms", numbuf);
	if(!h) {
		b_log(B_LOG_ERROR, "room", "could not load room \"%s\"", numbuf);
		return NULL;
	}

	r=calloc(1, sizeof *r);
	if(!r) {
		/* TODO: do perror? */
		b_log(B_LOG_ERROR, "calloc", "not allocate room \"%s\"", numbuf);
		fdb.read_end(h);
		return NULL;
	}

	while(fdb.read_next(h, &name, &value)) {
		if(!room_attr_set(r, name, value)) {
			b_log(B_LOG_ERROR, "room", "could not load room \"%s\"", numbuf);
			room_ll_free(r);
			fdb.read_end(h);
			return NULL;
		}
	}

	fdb.read_end(h);
	return NULL;
}

static int room_save(struct room *r) {
	struct attr_entry *curr;
	struct fdb_write_handle *h;
	char numbuf[22]; /* big enough for a signed 64-bit decimal */


	assert(r != NULL);
	if(!r->dirty_fl) return 1; /* already saved - don't do it again. */

	snprintf(numbuf, sizeof numbuf, "%u", r->id);

	h=fdb.write_begin("rooms", numbuf);
	if(!h) {
		b_log(B_LOG_ERROR, "room", "could not save room \"%s\"", numbuf);
		return 0; /* failure */
	}

	fdb.write_format(h, "id", "%u", r->id);
	if(r->name.short_str)
		fdb.write_pair(h, "name.short", r->name.short_str);
	if(r->name.long_str)
		fdb.write_pair(h, "name.long", r->name.short_str);
	if(r->desc.short_str)
		fdb.write_pair(h, "desc.short", r->desc.short_str);
	if(r->desc.long_str)
		fdb.write_pair(h, "desc.long", r->desc.short_str);
	if(r->owner)
		fdb.write_pair(h, "owner", r->owner);
	if(r->creator)
		fdb.write_pair(h, "creator", r->creator);

	for(curr=LIST_TOP(r->extra_values);curr;curr=LIST_NEXT(curr, list)) {
		fdb.write_pair(h, curr->name, curr->value);
	}

	if(!fdb.write_end(h)) {
		b_log(B_LOG_ERROR, "room", "could not save room \"%s\"", numbuf);
		return 0; /* failure */
	}

	r->dirty_fl=0;
	return 1;
}

/**
 * load room into cache, if not already loaded, then increase reference count
 * of room.
 */
static struct room *room_get(unsigned room_id) {
	struct room *curr;

	/* look for room in the cache. */
	for(curr=LIST_TOP(room_cache);curr;curr=LIST_NEXT(curr, room_cache)) {
		if(curr->id==room_id) break;
	}

	if(!curr) {
		/* not in the cache? load the room. */
		curr=room_load(room_id);
	}
	if(curr) {
		/* place entry at the top of the cache. */
		LIST_INSERT_HEAD(&room_cache, curr, room_cache);
		curr->refcount++;
	}
	return curr; /* failure. */
}

/**
 * reduce reference count of room.
 */
static void room_put(struct room *r) {
	assert(r != NULL);

	r->refcount--;
	if(r->refcount<=0) {
		room_save(r);
		room_ll_free(r);
	}
}

static int initialize(void) {
	struct fdb_iterator *it;
	const char *id;

	b_log(B_LOG_INFO, "room", "Room system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");
	LIST_INIT(&room_cache);

	fdb.domain_init("rooms");

	it=fdb.iterator_begin("rooms");
	if(!it) {
		b_log(B_LOG_CRIT, "room", "ERROR:could not load rooms!");
	}

	while((id=fdb.iterator_next(it))) {
		b_log(B_LOG_DEBUG, "room", "Found room: \"%s\"", id);
	}
	fdb.iterator_end(it);
}

static int shutdown(void) {
	/* TODO: save all dirty objects and free all data. */
	return 0; /* refuse to unload */
}

/******************************************************************************
 * Class
 ******************************************************************************/

const struct plugin_room_class plugin_class = {
	.base_class = { PLUGIN_API, "room", initialize, shutdown },
	.room_interface = { room_get, room_put, room_attr_set, room_attr_get }
};
