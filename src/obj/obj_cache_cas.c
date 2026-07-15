/**
 * @file obj_cache_cas.c
 *
 * Content-addressable backend for obj_cache built on the vendored
 * smolvfs CAS modules. Objects are serialized to JSON and stored as
 * CAS blobs; a cas-tree maps "<domain>/<key>" paths to blob hashes.
 * Saves write blobs immediately but buffer the path -> hash updates;
 * obj_cache_cas_commit rebuilds the touched tree levels copy-on-write
 * and advances the ref, so every commit is a whole-world snapshot.
 *
 * Made by a machine. PUBLIC DOMAIN (CC0-1.0)
 */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "obj_cache_cas"
#endif

#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>
#include <log.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define SAVE_BUFSZ 4096

/* default automatic GC policy: sweep after this many commits, sparing
 * unreachable objects younger than the grace period so sibling
 * caches' buffered (not yet committed) blobs survive */
#define GC_DEFAULT_EVERY 16
#define GC_DEFAULT_GRACE 3600

/* one buffered save: a blob already in CAS, not yet linked in a tree */
struct pending {
	struct pending *next;
	char hash[CAS_HASH_HEX + 1];
	char *path;		/* "<domain>/<key>" */
};

struct cas_bridge {
	struct cas_tree *ct;
	char *ref;
	char *domain;
	size_t domain_len;
	struct pending *pending;
	unsigned pending_count;
	unsigned gc_every;		/* auto GC after this many commits */
	time_t gc_grace;
	unsigned commits_since_gc;
};

/* view of the pending list used while rebuilding trees */
struct commit_item {
	const char *path;
	const char *hash;
};

/****************************************************************
 * Pending list
 ****************************************************************/

static struct pending *
pending_find(struct cas_bridge *b, const char *id)
{
	struct pending *pd;

	for (pd = b->pending; pd; pd = pd->next)
		if (strcmp(pd->path + b->domain_len + 1, id) == 0)
			return pd;
	return NULL;
}

static int
pending_upsert(struct cas_bridge *b, const char *id, const char *hash)
{
	struct pending *pd = pending_find(b, id);

	if (!pd) {
		pd = calloc(1, sizeof(*pd));
		if (!pd)
			return OBJ_CACHE_ERR;
		size_t n = b->domain_len + 1 + strlen(id) + 1;
		pd->path = malloc(n);
		if (!pd->path) {
			free(pd);
			return OBJ_CACHE_ERR;
		}
		snprintf(pd->path, n, "%s/%s", b->domain, id);
		pd->next = b->pending;
		b->pending = pd;
		b->pending_count++;
	}
	memcpy(pd->hash, hash, CAS_HASH_HEX + 1);
	return OBJ_CACHE_OK;
}

static void
pending_clear(struct cas_bridge *b)
{
	struct pending *pd = b->pending;

	while (pd) {
		struct pending *next = pd->next;
		free(pd->path);
		free(pd);
		pd = next;
	}
	b->pending = NULL;
	b->pending_count = 0;
}

/****************************************************************
 * Load path
 ****************************************************************/

static OBJ *
blob_to_obj(struct cas_bridge *b, const char *id, const char *hash)
{
	struct cas_file cf;
	int rc = cas_open(cas_tree_cas(b->ct), &cf, hash);

	if (rc != CAS_OK) {
		LOG_ERROR("cas_open(%s): %s", hash, cas_strerror(rc));
		return NULL;
	}

	/* cf.data is not null-terminated -- make a copy */
	char *json = malloc(cf.len + 1);

	if (!json) {
		cas_close(&cf);
		return NULL;
	}
	memcpy(json, cf.data, cf.len);
	json[cf.len] = '\0';
	cas_close(&cf);

	OBJ *obj = obj_new_from_json(id, json);
	free(json);
	return obj;
}

/* walk a slash-separated path from a tree root to its final entry */
static int
walk_path(struct cas_tree *ct, const char *root, const char *path,
	struct cas_tree_entry *e_out)
{
	char comp[CAS_TREE_NAME_MAX + 1];
	char cur[CAS_HASH_HEX + 1];
	const char *p = path;

	memcpy(cur, root, CAS_HASH_HEX);
	cur[CAS_HASH_HEX] = '\0';

	while (*p) {
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);

		if (clen == 0 || clen > CAS_TREE_NAME_MAX)
			return CAS_ERR;
		memcpy(comp, p, clen);
		comp[clen] = '\0';

		int rc = cas_tree_lookup(ct, cur, comp, e_out);
		if (rc != CAS_OK)
			return rc;
		if (!slash)
			return CAS_OK;
		if ((e_out->mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return CAS_ENOTFOUND;
		memcpy(cur, e_out->hash, CAS_HASH_HEX);
		cur[CAS_HASH_HEX] = '\0';
		p = slash + 1;
	}
	return CAS_ERR;
}

static OBJ *
bridge_load(void *ctx, const char *id)
{
	struct cas_bridge *b = ctx;

	/* a buffered save is newer than anything committed */
	struct pending *pd = pending_find(b, id);
	if (pd)
		return blob_to_obj(b, id, pd->hash);

	char root[CAS_HASH_HEX + 1];
	int rc = cas_tree_ref_read(b->ct, b->ref, root);

	if (rc == CAS_ENOTFOUND)
		return NULL;	/* nothing committed yet */
	if (rc != CAS_OK) {
		LOG_ERROR("ref \"%s\": %s", b->ref, cas_strerror(rc));
		return NULL;
	}

	char path[OBJ_PATH_MAX];
	if (snprintf(path, sizeof(path), "%s/%s", b->domain, id)
		>= (int)sizeof(path)) {
		LOG_ERROR("path too long: %s/%s", b->domain, id);
		return NULL;
	}

	struct cas_tree_entry e;
	rc = walk_path(b->ct, root, path, &e);
	if (rc == CAS_ENOTFOUND) {
		LOG_DEBUG("\"%s\" not found", path);
		return NULL;
	}
	if (rc != CAS_OK) {
		LOG_ERROR("walk \"%s\": %s", path, cas_strerror(rc));
		return NULL;
	}
	if ((e.mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFREG) {
		LOG_ERROR("\"%s\" is not a regular entry", path);
		return NULL;
	}
	return blob_to_obj(b, id, e.hash);
}

/****************************************************************
 * Save path
 ****************************************************************/

static int
bridge_save(void *ctx, const char *id, OBJ *obj)
{
	struct cas_bridge *b = ctx;
	char stackbuf[SAVE_BUFSZ];
	char *buf = stackbuf;
	size_t bufsz = sizeof(stackbuf);
	size_t json_len = 0;
	int result = obj_get_json(obj, buf, bufsz, &json_len);

	while (result == OBJ_ERR_NOMEM) {
		bufsz *= 2;
		buf = (buf == stackbuf) ? malloc(bufsz) : realloc(buf, bufsz);
		if (!buf)
			return OBJ_CACHE_ERR;
		result = obj_get_json(obj, buf, bufsz, &json_len);
	}
	if (result != OBJ_OK) {
		if (buf != stackbuf)
			free(buf);
		return OBJ_CACHE_ERR;
	}

	char hash[CAS_HASH_HEX + 1];
	int rc = cas_put(cas_tree_cas(b->ct), buf, json_len, hash);

	if (buf != stackbuf)
		free(buf);
	if (rc != CAS_OK) {
		LOG_ERROR("cas_put(%s/%s): %s", b->domain, id,
			cas_strerror(rc));
		return OBJ_CACHE_ERR;
	}
	return pending_upsert(b, id, hash);
}

/****************************************************************
 * Commit: copy-on-write tree rebuild
 ****************************************************************/

static int
item_cmp(const void *va, const void *vb)
{
	const struct commit_item *a = va;
	const struct commit_item *b = vb;

	return strcmp(a->path, b->path);
}

static struct cas_tree_entry *
dir_find(struct cas_tree_dir *dir, const char *name)
{
	for (int i = 0; i < dir->count; i++)
		if (strcmp(dir->entries[i].name, name) == 0)
			return &dir->entries[i];
	return NULL;
}

/* replace an entry's hash, or add a new entry. rejects a change of
 * entry type (file vs directory) under the same name. */
static int
dir_set(struct cas_tree_dir *dir, const char *name, const char *hash,
	int mode)
{
	struct cas_tree_entry *e = dir_find(dir, name);

	if (e) {
		if ((e->mode & CAS_TREE_S_IFMT) != (mode & CAS_TREE_S_IFMT)) {
			LOG_ERROR("\"%s\" changes entry type", name);
			return CAS_ERR;
		}
		memcpy(e->hash, hash, CAS_HASH_HEX + 1);
		e->mtime_s = time(NULL);
		return CAS_OK;
	}

	struct cas_tree_entry ne = {
		.mode = mode,
		.mtime_s = time(NULL),
	};

	if (strlen(name) > CAS_TREE_NAME_MAX)
		return CAS_ERR;
	strcpy(ne.name, name);
	memcpy(ne.hash, hash, CAS_HASH_HEX + 1);
	return cas_tree_dir_add(dir, &ne);
}

/* Rebuild one directory level copy-on-write. items are sorted by path
 * and offset bytes of each path have been consumed by parent levels.
 * dir_hash is the existing tree object at this level, or NULL when
 * the level does not exist yet. */
static int
rebuild_level(struct cas_tree *ct, const char *dir_hash,
	const struct commit_item *items, int count, size_t offset,
	char *hash_out)
{
	struct cas_tree_dir dir;
	int rc;

	if (dir_hash) {
		rc = cas_tree_load(ct, dir_hash, &dir);
		if (rc != CAS_OK)
			return rc;
	} else {
		cas_tree_dir_init(&dir);
	}

	int i = 0;

	while (i < count) {
		const char *p = items[i].path + offset;
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);
		char comp[CAS_TREE_NAME_MAX + 1];

		if (clen == 0 || clen > CAS_TREE_NAME_MAX) {
			LOG_ERROR("bad path component in \"%s\"",
				items[i].path);
			rc = CAS_ERR;
			goto out;
		}
		memcpy(comp, p, clen);
		comp[clen] = '\0';

		/* find the run of items sharing this component. sorting
		 * guarantees a terminal item ("a") precedes any item that
		 * descends through it ("a/b"). */
		int j = i + 1;
		while (j < count) {
			const char *q = items[j].path + offset;
			if (strncmp(q, comp, clen) != 0)
				break;
			if (q[clen] != '/' && q[clen] != '\0')
				break;
			j++;
		}

		if (!slash) {
			if (j - i > 1) {
				LOG_ERROR("key conflict at \"%s\"",
					items[i].path);
				rc = CAS_ERR;
				goto out;
			}
			rc = dir_set(&dir, comp, items[i].hash,
				CAS_TREE_S_IFREG | 0644);
			if (rc != CAS_OK)
				goto out;
		} else {
			char child_old[CAS_HASH_HEX + 1];
			const char *child_hash = NULL;
			struct cas_tree_entry *e = dir_find(&dir, comp);

			if (e) {
				if ((e->mode & CAS_TREE_S_IFMT)
					!= CAS_TREE_S_IFDIR) {
					LOG_ERROR("\"%s\" exists as an object,"
						" cannot descend", comp);
					rc = CAS_ERR;
					goto out;
				}
				memcpy(child_old, e->hash, CAS_HASH_HEX + 1);
				child_hash = child_old;
			}

			char child_new[CAS_HASH_HEX + 1];

			rc = rebuild_level(ct, child_hash, items + i, j - i,
				offset + clen + 1, child_new);
			if (rc != CAS_OK)
				goto out;
			rc = dir_set(&dir, comp, child_new,
				CAS_TREE_S_IFDIR | 0755);
			if (rc != CAS_OK)
				goto out;
		}
		i = j;
	}

	rc = cas_tree_store(ct, &dir, hash_out);
out:
	cas_tree_dir_free(&dir);
	return rc;
}

int
obj_cache_cas_commit(OBJ_CACHE *c, const char *comment)
{
	if (!c)
		return OBJ_CACHE_ERR;

	struct cas_bridge *b = obj_cache_ctx(c);

	if (!b)
		return OBJ_CACHE_ERR;
	if (b->pending_count == 0)
		return OBJ_CACHE_OK;

	struct commit_item *items = calloc(b->pending_count,
		sizeof(*items));

	if (!items)
		return OBJ_CACHE_ERR;

	unsigned n = 0;

	for (struct pending *pd = b->pending; pd; pd = pd->next) {
		items[n].path = pd->path;
		items[n].hash = pd->hash;
		n++;
	}
	qsort(items, n, sizeof(*items), item_cmp);

	/* start from the ref's current root so commits from sibling
	 * caches sharing this ref are preserved */
	char root[CAS_HASH_HEX + 1];
	const char *root_in = NULL;
	int rc = cas_tree_ref_read(b->ct, b->ref, root);

	if (rc == CAS_OK) {
		root_in = root;
	} else if (rc != CAS_ENOTFOUND) {
		LOG_ERROR("ref \"%s\": %s", b->ref, cas_strerror(rc));
		free(items);
		return OBJ_CACHE_ERR;
	}

	char new_root[CAS_HASH_HEX + 1];

	rc = rebuild_level(b->ct, root_in, items, (int)n, 0, new_root);
	free(items);
	if (rc != CAS_OK) {
		LOG_ERROR("tree rebuild failed: %s", cas_strerror(rc));
		return OBJ_CACHE_ERR;
	}

	rc = cas_tree_ref_commit(b->ct, b->ref, new_root,
		comment ? comment : "obj_cache_cas commit");
	if (rc != CAS_OK) {
		LOG_ERROR("ref commit \"%s\": %s", b->ref, cas_strerror(rc));
		return OBJ_CACHE_ERR;
	}

	pending_clear(b);

	if (b->gc_every && ++b->commits_since_gc >= b->gc_every) {
		b->commits_since_gc = 0;

		int removed = 0;

		rc = cas_tree_gc(b->ct, b->gc_grace, NULL, NULL, &removed);
		if (rc != CAS_OK)
			LOG_ERROR("auto gc: %s", cas_strerror(rc));
		else if (removed > 0)
			LOG_INFO("auto gc removed %d unreachable objects",
				removed);
		/* the commit itself succeeded either way */
	}
	return OBJ_CACHE_OK;
}

/****************************************************************
 * Garbage collection
 ****************************************************************/

int
obj_cache_cas_gc(OBJ_CACHE *c, time_t grace, int *removed)
{
	if (!c)
		return OBJ_CACHE_ERR;

	struct cas_bridge *b = obj_cache_ctx(c);

	if (!b)
		return OBJ_CACHE_ERR;

	int rc = cas_tree_gc(b->ct, grace, NULL, NULL, removed);

	if (rc != CAS_OK) {
		LOG_ERROR("gc: %s", cas_strerror(rc));
		return OBJ_CACHE_ERR;
	}
	return OBJ_CACHE_OK;
}

void
obj_cache_cas_gc_policy(OBJ_CACHE *c, unsigned every_commits, time_t grace)
{
	if (!c)
		return;

	struct cas_bridge *b = obj_cache_ctx(c);

	if (!b)
		return;
	b->gc_every = every_commits;
	b->gc_grace = grace;
	b->commits_since_gc = 0;
}

/****************************************************************
 * Lifecycle
 ****************************************************************/

OBJ_CACHE *
obj_cache_cas_new(struct cas_tree *ct, const char *ref,
	const char *domain, unsigned max_unreferenced)
{
	if (!ct || !ref || !domain)
		return NULL;

	struct cas_bridge *b = calloc(1, sizeof(*b));

	if (!b)
		return NULL;
	b->ct = ct;
	b->ref = strdup(ref);
	b->domain = strdup(domain);
	if (!b->ref || !b->domain)
		goto fail;
	b->domain_len = strlen(domain);
	b->gc_every = GC_DEFAULT_EVERY;
	b->gc_grace = GC_DEFAULT_GRACE;

	struct obj_cache_ops ops = {
		.load = bridge_load,
		.save = bridge_save,
	};
	OBJ_CACHE *c = obj_cache_new(max_unreferenced, &ops, b);

	if (!c)
		goto fail;
	return c;

fail:
	free(b->ref);
	free(b->domain);
	free(b);
	return NULL;
}

int
obj_cache_cas_put(OBJ_CACHE *c, const char *id, OBJ *obj)
{
	if (!c || !id || !obj)
		return OBJ_CACHE_ERR;

	struct cas_bridge *b = obj_cache_ctx(c);

	if (!b)
		return OBJ_CACHE_ERR;
	return bridge_save(b, id, obj);
}

unsigned
obj_cache_cas_pending(OBJ_CACHE *c)
{
	if (!c)
		return 0;

	struct cas_bridge *b = obj_cache_ctx(c);

	return b ? b->pending_count : 0;
}

void
obj_cache_cas_free(OBJ_CACHE *c)
{
	if (!c)
		return;

	struct cas_bridge *b = obj_cache_ctx(c);

	obj_cache_free(c);
	if (b) {
		pending_clear(b);
		free(b->ref);
		free(b->domain);
		free(b);
	}
}
