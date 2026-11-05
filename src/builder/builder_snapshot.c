/* builder_snapshot.c : in-process snapshot bridge (LMDB -> CAS history) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "builder_snapshot.h"

#include "obj_cache.h"
#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>

#include <log.h>

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/* Unreferenced-object cache bound for obj_cache_cas_new. The bridge commits
 * after every record, so at most a handful sit uncommitted; this is headroom. */
#define SNAPSHOT_CACHE_SLOTS 64

/*
 * Default retention and GC for the "world" log (section 8). These are the
 * compile-time stand-ins for the per-server config the spec leaves open
 * (section 14); builder_snapshot_set_retention overrides them. Keep the last
 * SNAPSHOT_KEEP_COUNT edits or anything within SNAPSHOT_KEEP_AGE, whichever is
 * larger, and prune-and-sweep every SNAPSHOT_GC_EVERY commits, sparing objects
 * younger than SNAPSHOT_GC_GRACE. The bridge commits on every record, so no
 * save sits uncommitted and the grace is pure headroom.
 */
#define SNAPSHOT_KEEP_COUNT 1000
#define SNAPSHOT_KEEP_AGE   (30L * 24 * 3600)	/* 30 days */
#define SNAPSHOT_GC_EVERY   16
#define SNAPSHOT_GC_GRACE   3600L		/* 1 hour */

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

	builder_snapshot_set_retention(SNAPSHOT_KEEP_COUNT, SNAPSHOT_KEEP_AGE,
		SNAPSHOT_GC_EVERY, SNAPSHOT_GC_GRACE);

	LOG_INFO("Snapshot bridge opened at %s (ref %s).", depot_path,
		BUILDER_SNAPSHOT_REF);
	return 0;
}

void
builder_snapshot_set_retention(int keep_count, long keep_age_s,
	unsigned gc_every_commits, long grace_s)
{
	if (!snap_cache)
		return;
	obj_cache_cas_retention(snap_cache, keep_count, (time_t)keep_age_s);
	obj_cache_cas_gc_policy(snap_cache, gc_every_commits, (time_t)grace_s);
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

/* Build the attribution comment: who did what to which key, and which zone it
 * falls under (section 4.2). Keys are "zone/<slug>/..."; anything else has no
 * zone. verb is the past-tense action ("edited", "removed"). Best-effort text,
 * truncated to fit. */
static void
build_comment(char *buf, size_t bufsz, const char *verb, const char *key,
	const char *actor_name)
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
		snprintf(buf, bufsz, "%s %s %s (zone %s)", who, verb, key, slug);
	else
		snprintf(buf, bufsz, "%s %s %s", who, verb, key);
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

	build_comment(comment, sizeof comment, "edited", key, actor_name);
	if (obj_cache_cas_commit(snap_cache, comment) != OBJ_CACHE_OK) {
		LOG_WARNING("snapshot bridge: could not commit %s", key);
		return;
	}
}

void
builder_snapshot_forget(const char *key, const char *actor_name)
{
	char comment[OBJ_PATH_MAX + 96];

	if (!snap_cache)
		return; /* bridge disabled: no history, world still correct */
	if (!key || !key[0]) {
		LOG_WARNING("snapshot bridge: bad forget request");
		return;
	}

	if (obj_cache_cas_del(snap_cache, key) != OBJ_CACHE_OK) {
		LOG_WARNING("snapshot bridge: could not drop %s", key);
		return;
	}

	build_comment(comment, sizeof comment, "removed", key, actor_name);
	if (obj_cache_cas_commit(snap_cache, comment) != OBJ_CACHE_OK)
		LOG_WARNING("snapshot bridge: could not commit removal of %s",
			key);
}

/* A growable list of keys gathered from obj_foreach_key. */
struct keygrab {
	char **keys;
	size_t count;
	size_t cap;
	int    oom;
};

static void
keygrab_cb(const char *key, void *ctx)
{
	struct keygrab *g = ctx;
	char *dup;

	if (g->count == g->cap) {
		size_t ncap = g->cap ? g->cap * 2 : 32;
		char **nk = realloc(g->keys, ncap * sizeof *nk);

		if (!nk) {
			g->oom = 1;
			return;
		}
		g->keys = nk;
		g->cap = ncap;
	}
	dup = strdup(key);
	if (dup)
		g->keys[g->count++] = dup;
	else
		g->oom = 1;
}

static int
in_keygrab(const struct keygrab *g, const char *key)
{
	size_t i;

	for (i = 0; i < g->count; i++)
		if (g->keys[i] && strcmp(g->keys[i], key) == 0)
			return 1;
	return 0;
}

/* Resolve the tree hash of a slash-separated directory path under root; every
 * component must be a directory. Returns 0 with the hash in out, or -1. */
static int
snap_resolve_dir(const char *root, const char *path, char *out)
{
	char cur[CAS_HASH_HEX + 1];
	const char *p = path;

	memcpy(cur, root, CAS_HASH_HEX);
	cur[CAS_HASH_HEX] = '\0';
	while (*p) {
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);
		char comp[CAS_TREE_NAME_MAX + 1];
		struct cas_tree_entry e;

		if (clen == 0 || clen > CAS_TREE_NAME_MAX)
			return -1;
		memcpy(comp, p, clen);
		comp[clen] = '\0';
		if (cas_tree_lookup(snap_tree, cur, comp, &e) != CAS_OK)
			return -1;
		if ((e.mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return -1;
		memcpy(cur, e.hash, CAS_HASH_HEX);
		cur[CAS_HASH_HEX] = '\0';
		p = slash ? slash + 1 : p + clen;
	}
	memcpy(out, cur, CAS_HASH_HEX + 1);
	return 0;
}

/* Collect the committed leaf keys under the directory dir_hash into g, with rel
 * the key path of that directory (relative to the domain). */
static int
collect_committed(const char *dir_hash, const char *rel, struct keygrab *g)
{
	struct cas_tree_dir dir;
	int i, rc = 0;

	cas_tree_dir_init(&dir);
	if (cas_tree_load(snap_tree, dir_hash, &dir) != CAS_OK) {
		cas_tree_dir_free(&dir);
		return -1;
	}
	for (i = 0; i < dir.count && rc == 0; i++) {
		struct cas_tree_entry *e = &dir.entries[i];
		char child[OBJ_PATH_MAX];

		if ((size_t)snprintf(child, sizeof child, "%s/%s", rel, e->name)
			>= sizeof child) {
			rc = -1;
			break;
		}
		if ((e->mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR)
			rc = collect_committed(e->hash, child, g);
		else
			keygrab_cb(child, g);	/* append this leaf key */
	}
	cas_tree_dir_free(&dir);
	return rc;
}

int
builder_snapshot_subtree(const char *prefix, const char *comment)
{
	struct keygrab live = {0}, had = {0};
	char scan[OBJ_PATH_MAX], dirpath[OBJ_PATH_MAX];
	char root[CAS_HASH_HEX + 1], dirhash[CAS_HASH_HEX + 1];
	size_t i;
	int rc = 0;

	if (!snap_cache)
		return -1;
	if (!prefix || !prefix[0]) {
		LOG_WARNING("snapshot bridge: bad subtree request");
		return -1;
	}
	if ((size_t)snprintf(scan, sizeof scan, "%s/", prefix) >= sizeof scan) {
		LOG_WARNING("snapshot bridge: subtree prefix too long");
		return -1;
	}

	/* the live objects under the path */
	obj_foreach_key(scan, keygrab_cb, &live);

	/* the keys the committed tip still holds under the path, so the ones no
	 * longer live can be dropped. This is the recomputed wipe: rather than
	 * tracking deletions, the snapshot replaces the subtree with exactly the
	 * live set, matching the in-place wipe the LMDB restore already does. */
	if ((size_t)snprintf(dirpath, sizeof dirpath, "%s/%s",
		BUILDER_SNAPSHOT_DOMAIN, prefix) < sizeof dirpath
		&& cas_tree_ref_read(snap_tree, BUILDER_SNAPSHOT_REF, root)
			== CAS_OK
		&& snap_resolve_dir(root, dirpath, dirhash) == 0)
		collect_committed(dirhash, prefix, &had);

	for (i = 0; i < had.count; i++) {
		if (!in_keygrab(&live, had.keys[i])
			&& obj_cache_cas_del(snap_cache, had.keys[i])
				!= OBJ_CACHE_OK) {
			LOG_WARNING("snapshot bridge: could not drop %s",
				had.keys[i]);
			rc = -1;
		}
		free(had.keys[i]);
	}
	free(had.keys);

	for (i = 0; i < live.count; i++) {
		OBJ *o = obj_get(live.keys[i]);

		if (o) {
			if (obj_cache_cas_put(snap_cache, live.keys[i], o)
				!= OBJ_CACHE_OK) {
				LOG_WARNING("snapshot bridge: could not mirror %s",
					live.keys[i]);
				rc = -1;
			}
			obj_release(o);
		}
		free(live.keys[i]);
	}
	free(live.keys);

	if (live.oom || had.oom) {
		LOG_WARNING("snapshot bridge: out of memory scanning %s", prefix);
		rc = -1;
	}
	if (obj_cache_cas_commit(snap_cache, comment) != OBJ_CACHE_OK) {
		LOG_WARNING("snapshot bridge: could not commit subtree %s",
			prefix);
		rc = -1;
	}
	return rc;
}
