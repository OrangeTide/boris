#ifndef RESOLVE_H_
#define RESOLVE_H_

#include <stddef.h>

enum resolve_result {
	RESOLVE_NONE = 0,	/* nothing in scope matched */
	RESOLVE_OK,		/* exactly one match; out holds its object id */
	RESOLVE_AMBIGUOUS,	/* more than one match; out holds the first */
};

/*
 * Resolve name to an object id within actor's scope.
 *
 * The special names "me" and "self" resolve to the actor, and "here" to the
 * actor's location. Otherwise the search covers, in order, the actor's
 * inventory (contents of the actor), then the actor's location: its contents
 * (occupants and items, which include the actor) and the location object
 * itself. A candidate matches when name is a case-insensitive prefix of its
 * name.short (whole string or any word) or of any whitespace-separated token of
 * its aliases property.
 *
 * When players_only is non-zero, only character objects (ids under "chars/")
 * are considered, so "here" and non-character items never match.
 *
 * On RESOLVE_OK the single match's id is copied into out; on RESOLVE_AMBIGUOUS
 * the first match is copied, so a caller that wants "pick the first" can use it.
 * Requires the muddb backend, since scope comes from the containment index.
 */
enum resolve_result resolve_name(const char *actor_id, const char *name,
	int players_only, char *out, size_t out_sz);

#endif
