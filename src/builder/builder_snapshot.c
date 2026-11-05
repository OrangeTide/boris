/* builder_snapshot.c : in-process snapshot bridge (LMDB -> CAS history) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "builder_snapshot.h"

#include "obj_cache.h"
#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>

#include <log.h>

#include <stdio.h>
#include <string.h>

/* Unreferenced-object cache bound for obj_cache_cas_new. The bridge commits
 * after every record, so at most a handful sit uncommitted; this is headroom. */
#define SNAPSHOT_CACHE_SLOTS 64

static struct cas *snap_store;
static struct cas_tree *snap_tree;
static OBJ_CACHE *snap_cache;

int
builder_snapshot_init(const char *depot_path)
{
	if (snap_cache) {
		LOG_WARNING("snapshot bridge already initialized");
		return 0;
	}
	if (!depot_path || !depot_path[0]) {
		LOG_ERROR("snapshot bridge: no depot path");
		return -1;
	}

	snap_store = cas_new(depot_path);
	snap_tree = snap_store ? cas_tree_new(snap_store) : NULL;
	if (!snap_tree) {
		LOG_ERROR("snapshot bridge: could not open depot at %s",
			depot_path);
		cas_free(snap_store);
		snap_store = NULL;
		return -1;
	}
	cas_tree_set_flags(snap_tree, CAS_TREE_USE_HTREE);

	snap_cache = obj_cache_cas_new(snap_tree, BUILDER_SNAPSHOT_REF,
		BUILDER_SNAPSHOT_DOMAIN, SNAPSHOT_CACHE_SLOTS);
	if (!snap_cache) {
		LOG_ERROR("snapshot bridge: could not create cache");
		cas_tree_free(snap_tree);
		cas_free(snap_store);
		snap_tree = NULL;
		snap_store = NULL;
		return -1;
	}

	LOG_INFO("Snapshot bridge opened at %s (ref %s).", depot_path,
		BUILDER_SNAPSHOT_REF);
	return 0;
}

void
builder_snapshot_shutdown(void)
{
	if (snap_cache) {
		obj_cache_cas_free(snap_cache);
		snap_cache = NULL;
	}
	if (snap_tree) {
		cas_tree_free(snap_tree);
		snap_tree = NULL;
	}
	if (snap_store) {
		cas_free(snap_store);
		snap_store = NULL;
	}
}

int
builder_snapshot_enabled(void)
{
	return snap_cache != NULL;
}

struct cas_tree *
builder_snapshot_tree(void)
{
	return snap_tree;
}

/* Build the attribution comment: who changed what, and which zone it falls
 * under (section 4.2). Keys are "zone/<slug>/..."; anything else has no zone.
 * Best-effort text, truncated to fit. */
static void
build_comment(char *buf, size_t bufsz, const char *key, const char *actor_name)
{
	const char *who = (actor_name && actor_name[0]) ? actor_name : "?";
	char slug[64];

	slug[0] = '\0';
	if (strncmp(key, "zone/", 5) == 0) {
		const char *start = key + 5;
		const char *slash = strchr(start, '/');
		size_t n = slash ? (size_t)(slash - start) : strlen(start);

		if (n > 0 && n < sizeof slug) {
			memcpy(slug, start, n);
			slug[n] = '\0';
		}
	}

	if (slug[0])
		snprintf(buf, bufsz, "%s edited %s (zone %s)", who, key, slug);
	else
		snprintf(buf, bufsz, "%s edited %s", who, key);
}

void
builder_snapshot_record(const char *key, OBJ *obj, const char *actor_name)
{
	char comment[OBJ_PATH_MAX + 96];

	if (!snap_cache)
		return; /* bridge disabled: no history, world still correct */
	if (!key || !key[0] || !obj) {
		LOG_WARNING("snapshot bridge: bad record request");
		return;
	}

	if (obj_cache_cas_put(snap_cache, key, obj) != OBJ_CACHE_OK) {
		LOG_WARNING("snapshot bridge: could not mirror %s", key);
		return;
	}

	build_comment(comment, sizeof comment, key, actor_name);
	if (obj_cache_cas_commit(snap_cache, comment) != OBJ_CACHE_OK) {
		LOG_WARNING("snapshot bridge: could not commit %s", key);
		return;
	}
}
