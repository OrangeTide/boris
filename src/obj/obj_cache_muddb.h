#ifndef OBJ_CACHE_MUDDB_H_
#define OBJ_CACHE_MUDDB_H_

#include "obj_cache.h"

struct muddb;

/*
 * Convenience: build an OBJ_CACHE that reads/writes a single muddb
 * domain via the global mud_db (or an explicit MUDDB pointer).
 *
 * For cross-domain prototype chains (e.g. entity parent is a template),
 * attach a sibling cache via obj_cache_muddb_link_parent so %parent
 * values of the form "templates/id" dispatch to the templates cache.
 * If no sibling is linked, %parent is treated as an id in the same
 * domain.
 */
OBJ_CACHE *obj_cache_muddb_new(struct muddb *db, const char *domain,
	unsigned max_unreferenced);

/*
 * Register a sibling cache keyed by a domain prefix. When a %parent
 * value starts with "<domain>/", lookup dispatches to that cache and
 * the id passed in is the suffix after the slash.
 */
int obj_cache_muddb_link_parent(OBJ_CACHE *c, const char *domain,
	OBJ_CACHE *parent_cache);

#endif
