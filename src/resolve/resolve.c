/* resolve.c : resolve a name to an object id within an actor's scope */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "resolve"
#endif

#include "resolve.h"
#include "obj.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

/* the character id prefix; matches DOMAIN_CHARACTER "/" without pulling boris.h */
#define CHARS_PREFIX "chars/"
#define CHARS_PREFIX_LEN (sizeof(CHARS_PREFIX) - 1)

/* true if q (length ql) is a case-insensitive prefix of word (length wordlen) */
static int
ci_prefix(const char *q, size_t ql, const char *word, size_t wordlen)
{
	return ql > 0 && ql <= wordlen && strncasecmp(q, word, ql) == 0;
}

/* true if q is a prefix of s as a whole, or a prefix of any word of s */
static int
prefix_whole_or_word(const char *q, const char *s)
{
	size_t ql = strlen(q);
	const char *p;

	if (ci_prefix(q, ql, s, strlen(s)))
		return 1;
	for (p = s; *p; ) {
		const char *w;

		while (*p && isspace((unsigned char)*p))
			p++;
		w = p;
		while (*p && !isspace((unsigned char)*p))
			p++;
		if (p > w && ci_prefix(q, ql, w, (size_t)(p - w)))
			return 1;
	}
	return 0;
}

/* true if q equals any whitespace-separated token of s (case-insensitive) */
static int
token_equals(const char *q, const char *s)
{
	size_t ql = strlen(q);
	const char *p;

	for (p = s; *p; ) {
		const char *w;

		while (*p && isspace((unsigned char)*p))
			p++;
		w = p;
		while (*p && !isspace((unsigned char)*p))
			p++;
		if ((size_t)(p - w) == ql && strncasecmp(q, w, ql) == 0)
			return 1;
	}
	return 0;
}

enum match_mode {
	MATCH_EXACT,	/* whole name.short, or a whole alias token */
	MATCH_PREFIX,	/* prefix of name.short (whole or word) or alias token */
};

/* does the object match the query under the given mode? */
static int
name_matches(enum match_mode mode, const char *q, OBJ *o)
{
	const char *ns = obj_prop_get(o, "name.short");
	const char *al;

	/* ns is consumed before the next obj_prop_get invalidates it */
	if (mode == MATCH_EXACT) {
		if (ns && strcasecmp(q, ns) == 0)
			return 1;
		al = obj_prop_get(o, "aliases");
		return al && token_equals(q, al);
	}

	if (ns && prefix_whole_or_word(q, ns))
		return 1;
	al = obj_prop_get(o, "aliases");
	return al && prefix_whole_or_word(q, al);
}

struct match_ctx {
	const char *query;
	int players_only;
	enum match_mode mode;
	char *out;
	size_t out_sz;
	int count;
};

static void
consider(struct match_ctx *m, const char *id)
{
	OBJ *o;

	if (m->players_only && strncmp(id, CHARS_PREFIX, CHARS_PREFIX_LEN))
		return;
	o = obj_get(id);
	if (!o)
		return;
	if (name_matches(m->mode, m->query, o)) {
		if (m->count == 0)
			snprintf(m->out, m->out_sz, "%s", id);
		m->count++;
	}
	obj_release(o);
}

static void
scan_container(struct match_ctx *m, const char *container)
{
	OBJ_CONTENTS_ITER *it = obj_contents_begin(container);
	const char *id;

	if (!it)
		return;
	while ((id = obj_contents_next(it)) != NULL)
		consider(m, id);
	obj_contents_end(it);
}

/* walk the actor's scope once under the current match mode */
static void
scan_scope(struct match_ctx *m, const char *actor_id, const char *room)
{
	scan_container(m, actor_id);            /* the actor's inventory */
	if (room) {
		scan_container(m, room);        /* occupants and items in the room */
		consider(m, room);              /* the room object itself */
	}
}

enum resolve_result
resolve_name(const char *actor_id, const char *name, int players_only,
	char *out, size_t out_sz)
{
	struct match_ctx m;
	char *room;

	if (!actor_id || !name || !*name || !out || out_sz == 0)
		return RESOLVE_NONE;

	/* "me"/"self" is the actor itself */
	if (!strcasecmp(name, "me") || !strcasecmp(name, "self")) {
		if (players_only && strncmp(actor_id, CHARS_PREFIX,
			CHARS_PREFIX_LEN))
			return RESOLVE_NONE;
		snprintf(out, out_sz, "%s", actor_id);
		return RESOLVE_OK;
	}

	room = obj_location(actor_id);          /* full "rooms/<id>" or NULL */

	/* "here" is the actor's location */
	if (!strcasecmp(name, "here")) {
		enum resolve_result r = RESOLVE_NONE;

		if (room && !players_only) {
			snprintf(out, out_sz, "%s", room);
			r = RESOLVE_OK;
		}
		free(room);
		return r;
	}

	m.query = name;
	m.players_only = players_only;
	m.out = out;
	m.out_sz = out_sz;

	/* an exact name wins outright; prefix matching is the fallback */
	m.mode = MATCH_EXACT;
	m.count = 0;
	scan_scope(&m, actor_id, room);
	if (m.count == 0) {
		m.mode = MATCH_PREFIX;
		scan_scope(&m, actor_id, room);
	}
	free(room);

	if (m.count == 0)
		return RESOLVE_NONE;
	if (m.count == 1)
		return RESOLVE_OK;
	return RESOLVE_AMBIGUOUS;
}
