/* verb_model.c : command-verb resolution over the object scope.
 *
 * Given an actor and a command word, find the object whose verb.<word> property
 * applies. Objects are checked in scope order (actor, its location, its held
 * items, the room contents), each through a prototype walk. The contents tiers
 * snapshot their member ids before loading any object: the contents iterator
 * holds an open read transaction, so an obj_get while it is live would nest a
 * transaction (see L5 sys_next). */

#include "verb_model.h"

#include "obj.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Split the packed "<prog>\t<spec>" value into out, with the holder id. */
static void
fill_def(struct verb_def *out, const char *holder, char *value)
{
	char *tab = strchr(value, '\t');

	if (tab)
		*tab = '\0';
	snprintf(out->holder, sizeof out->holder, "%s", holder);
	snprintf(out->prog, sizeof out->prog, "%s", value);
	snprintf(out->spec, sizeof out->spec, "%s", tab ? tab + 1 : "");
}

/* If object `id` defines `propname` (prototype-walked), fill out and return 1. */
static int
try_object(const char *id, const char *propname, struct verb_def *out)
{
	OBJ *o = obj_get(id);
	char *value;

	if (!o)
		return 0;
	value = obj_prop_resolve(o, propname);
	obj_release(o);
	if (!value)
		return 0;
	fill_def(out, id, value);
	free(value);
	return 1;
}

/* Snapshot a container's direct member ids into a single growing buffer of
 * NUL-terminated ids. Returns the buffer (caller frees) and its used length in
 * *len, or NULL with *len 0 when empty or on allocation failure. */
static char *
snapshot_members(const char *container, size_t *len)
{
	OBJ_CONTENTS_ITER *it = obj_contents_begin(container);
	const char *m;
	char *buf = NULL;
	size_t used = 0, cap = 0;

	*len = 0;
	if (!it)
		return NULL;
	while ((m = obj_contents_next(it)) != NULL) {
		size_t mlen = strlen(m) + 1;

		if (used + mlen > cap) {
			size_t ncap = (used + mlen) * 2;
			char *nb = realloc(buf, ncap);

			if (!nb) {
				free(buf);
				obj_contents_end(it);
				*len = 0;
				return NULL;
			}
			buf = nb;
			cap = ncap;
		}
		memcpy(buf + used, m, mlen);
		used += mlen;
	}
	obj_contents_end(it);
	*len = used;
	return buf;
}

/* Try each direct member of `container` in turn. */
static int
scan_contents(const char *container, const char *propname, struct verb_def *out)
{
	size_t len = 0, off;
	char *ids;
	int found = 0;

	if (!container || !*container)
		return 0;
	ids = snapshot_members(container, &len);
	for (off = 0; off < len; off += strlen(ids + off) + 1) {
		if (try_object(ids + off, propname, out)) {
			found = 1;
			break;
		}
	}
	free(ids);
	return found;
}

int
verb_resolve(const char *actor_id, const char *word, struct verb_def *out)
{
	char propname[5 + VERB_WORD_MAX + 1];
	char *loc;
	int found = 0;

	if (!actor_id || !*actor_id || !word || !*word || !out)
		return -1;
	if (strlen(word) > VERB_WORD_MAX)
		return 0;
	snprintf(propname, sizeof propname, "verb.%s", word);

	loc = obj_location(actor_id);

	/* 1. the actor, 2. its location */
	if (try_object(actor_id, propname, out) ||
	    (loc && try_object(loc, propname, out))) {
		found = 1;
	/* 3. the actor's held items, 4. the room contents */
	} else if (scan_contents(actor_id, propname, out) ||
	           (loc && scan_contents(loc, propname, out))) {
		found = 1;
	}

	free(loc);
	return found;
}
