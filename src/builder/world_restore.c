/* world_restore.c : scoped CAS -> LMDB restore (the copy primitive) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "world_restore.h"
#include "builder_snapshot.h"

#include "obj.h"

#include <cas.h>
#include <cas-tree.h>

#include <log.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* A growable list of (key, obj) read from a snapshot subtree. The keys are
 * relative to the domain (e.g. "zone/world/tower"); the objects are owned by
 * the list until it is freed. */
struct objlist {
	char **keys;
	OBJ **objs;
	size_t count;
	size_t cap;
};

static int
objlist_add(struct objlist *l, char *key, OBJ *obj)
{
	if (l->count == l->cap) {
		size_t ncap = l->cap ? l->cap * 2 : 32;
		char **nk = realloc(l->keys, ncap * sizeof(*nk));
		OBJ **no = realloc(l->objs, ncap * sizeof(*no));

		if (!nk || !no) {
			free(nk);
			free(no);
			return -1;
		}
		/* realloc may have moved one and not the other; keep both. */
		l->keys = nk;
		l->objs = no;
		l->cap = ncap;
	}
	l->keys[l->count] = key;
	l->objs[l->count] = obj;
	l->count++;
	return 0;
}

static void
objlist_free(struct objlist *l)
{
	size_t i;

	for (i = 0; i < l->count; i++) {
		free(l->keys[i]);
		obj_free(l->objs[i]);
	}
	free(l->keys);
	free(l->objs);
	l->keys = NULL;
	l->objs = NULL;
	l->count = l->cap = 0;
}

/* A growable list of live keys under the destination prefix. */
struct keylist {
	char **keys;
	size_t count;
	size_t cap;
};

static void
keylist_collect(const char *key, void *ctx)
{
	struct keylist *kl = ctx;
	char *dup;

	if (kl->count == kl->cap) {
		size_t ncap = kl->cap ? kl->cap * 2 : 32;
		char **nk = realloc(kl->keys, ncap * sizeof(*nk));

		if (!nk)
			return; /* drop on OOM: a missed delete is not corruption */
		kl->keys = nk;
		kl->cap = ncap;
	}
	dup = strdup(key);
	if (dup)
		kl->keys[kl->count++] = dup;
}

static void
keylist_free(struct keylist *kl)
{
	size_t i;

	for (i = 0; i < kl->count; i++)
		free(kl->keys[i]);
	free(kl->keys);
}

/* Read one CAS blob into a fresh OBJ under id, or NULL on failure. */
static OBJ *
blob_to_obj(struct cas_tree *ct, const char *id, const char *hash)
{
	struct cas_file cf;
	char *json;
	OBJ *obj;

	if (cas_open(cas_tree_cas(ct), &cf, hash) != CAS_OK) {
		LOG_ERROR("restore: cas_open(%s) failed for %s", hash, id);
		return NULL;
	}
	json = malloc(cf.len + 1);
	if (!json) {
		cas_close(&cf);
		return NULL;
	}
	memcpy(json, cf.data, cf.len);
	json[cf.len] = '\0';
	cas_close(&cf);

	obj = obj_new_from_json(id, json);
	free(json);
	return obj;
}

/* Resolve the tree hash of a slash-separated directory path from a root. Every
 * component, including the last, must be a directory. Returns CAS_OK with the
 * hash in hash_out, or a CAS error code. */
static int
resolve_dir(struct cas_tree *ct, const char *root, const char *path,
	char *hash_out)
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
		int rc;

		if (clen == 0 || clen > CAS_TREE_NAME_MAX)
			return CAS_ERR;
		memcpy(comp, p, clen);
		comp[clen] = '\0';

		rc = cas_tree_lookup(ct, cur, comp, &e);
		if (rc != CAS_OK)
			return rc;
		if ((e.mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return CAS_ENOTFOUND;
		memcpy(cur, e.hash, CAS_HASH_HEX);
		cur[CAS_HASH_HEX] = '\0';
		p = slash ? slash + 1 : p + clen;
	}
	memcpy(hash_out, cur, CAS_HASH_HEX + 1);
	return CAS_OK;
}

/* Recursively collect every object under the directory dir_hash. rel is the
 * key path, relative to the domain, of that directory. */
static int
collect_dir(struct cas_tree *ct, const char *dir_hash, const char *rel,
	struct objlist *out)
{
	struct cas_tree_dir dir;
	int i, rc = 0;

	cas_tree_dir_init(&dir);
	if (cas_tree_load(ct, dir_hash, &dir) != CAS_OK) {
		LOG_ERROR("restore: could not load tree %s", dir_hash);
		cas_tree_dir_free(&dir);
		return -1;
	}

	for (i = 0; i < dir.count && rc == 0; i++) {
		struct cas_tree_entry *e = &dir.entries[i];
		size_t n = strlen(rel) + 1 + strlen(e->name) + 1;
		char *child = malloc(n);

		if (!child) {
			rc = -1;
			break;
		}
		snprintf(child, n, "%s/%s", rel, e->name);

		if ((e->mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR) {
			rc = collect_dir(ct, e->hash, child, out);
			free(child);
		} else {
			OBJ *obj = blob_to_obj(ct, child, e->hash);

			if (!obj) {
				free(child);
				rc = -1;
				break;
			}
			/* child and obj hand off to the list on success */
			if (objlist_add(out, child, obj) != 0) {
				free(child);
				obj_free(obj);
				rc = -1;
			}
		}
	}

	cas_tree_dir_free(&dir);
	return rc;
}

static int
in_objlist(const struct objlist *l, const char *key)
{
	size_t i;

	for (i = 0; i < l->count; i++)
		if (strcmp(l->keys[i], key) == 0)
			return 1;
	return 0;
}

int
world_restore(struct cas_tree *ct, const char *root_hash,
	const char *src_prefix, const char *dst_prefix, int rewrite)
{
	char subtree_path[OBJ_PATH_MAX];
	char dir_hash[CAS_HASH_HEX + 1];
	char scan_prefix[OBJ_PATH_MAX];
	struct objlist src = {0};
	struct keylist live = {0};
	const char **del_keys = NULL;
	size_t n_del = 0, i;
	int rc = WORLD_RESTORE_ERR;

	if (!ct || !root_hash || !src_prefix || !src_prefix[0] || !dst_prefix
		|| !dst_prefix[0]) {
		LOG_ERROR("restore: bad arguments");
		return WORLD_RESTORE_ERR;
	}

	/* Step 2 covers the in-place case only; cross-path copy needs the
	 * reference rewrite pass (spec step 3). */
	if (rewrite || strcmp(src_prefix, dst_prefix) != 0) {
		LOG_ERROR("restore: cross-path copy and rewrite not yet "
			"implemented (spec step 3)");
		return WORLD_RESTORE_ERR;
	}

	/* 1. read the source subtree from the snapshot. */
	if (snprintf(subtree_path, sizeof subtree_path, "%s/%s",
		BUILDER_SNAPSHOT_DOMAIN, src_prefix) >= (int)sizeof subtree_path) {
		LOG_ERROR("restore: subtree path too long");
		return WORLD_RESTORE_ERR;
	}
	if (resolve_dir(ct, root_hash, subtree_path, dir_hash) != CAS_OK) {
		LOG_ERROR("restore: subtree \"%s\" not found in snapshot",
			subtree_path);
		return WORLD_RESTORE_ERR;
	}
	if (collect_dir(ct, dir_hash, src_prefix, &src) != 0) {
		LOG_ERROR("restore: could not read subtree \"%s\"", src_prefix);
		goto done;
	}

	/* 2. list the live keys under the destination, so keys absent from the
	 * source subtree can be deleted. Match the subtree exactly by scanning
	 * "<dst_prefix>/". */
	if (snprintf(scan_prefix, sizeof scan_prefix, "%s/", dst_prefix)
		>= (int)sizeof scan_prefix) {
		LOG_ERROR("restore: scan prefix too long");
		goto done;
	}
	obj_foreach_key(scan_prefix, keylist_collect, &live);

	if (live.count) {
		del_keys = malloc(live.count * sizeof(*del_keys));
		if (!del_keys)
			goto done;
		for (i = 0; i < live.count; i++)
			if (!in_objlist(&src, live.keys[i]))
				del_keys[n_del++] = live.keys[i];
	}

	/* 3. apply writes, deletes, index rebuild, and cache invalidation in one
	 * transaction. */
	if (obj_apply_restore((const char *const *)src.keys,
		(OBJ *const *)src.objs, src.count, del_keys, n_del) != OBJ_OK) {
		LOG_ERROR("restore: apply failed for \"%s\"", dst_prefix);
		goto done;
	}

	LOG_INFO("restored \"%s\": %zu objects, %zu removed", dst_prefix,
		src.count, n_del);
	rc = WORLD_RESTORE_OK;

done:
	free(del_keys);
	keylist_free(&live);
	objlist_free(&src);
	return rc;
}
