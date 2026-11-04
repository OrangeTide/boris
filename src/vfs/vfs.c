/* vfs.c : a content-addressed filesystem for in-world programs.
 *
 * Directories are cas-tree objects (name -> {mode, mtime, child hash}); a file
 * is a CAS blob the inode names by hash. The VFS keeps the current root tree
 * hash in memory and rebuilds it copy-on-write on each mutation, so a write is
 * visible to the next read in the same session. vfs_commit advances the ref to
 * that root. The path walker and the COW level rebuild mirror the ones in
 * obj_cache_cas.c, specialized here for a two-kind (FILE/DIR) filesystem. See
 * vfs.h. */

#define LOG_SUBSYSTEM "vfs"

#include "vfs.h"

#include "cas.h"
#include "cas-tree.h"

#include <log.h>

#include <stdlib.h>
#include <string.h>
#include <time.h>

struct vfs {
	struct cas_tree *ct;
	char            *ref;
	char             root[CAS_HASH_HEX + 1];  /* current root tree hash */
	int              has_root;                /* 0 until the first write */
};

/****************************************************************
 * Path handling
 ****************************************************************/

/* Normalize an absolute path into a root-relative form: strip a leading '/',
 * collapse repeated and trailing separators, and reject "." and ".." so a
 * path cannot escape the tree. The root ("/" or "") yields "". Returns VFS_OK
 * or VFS_EINVAL on a bad component or overflow. */
static int
norm_path(const char *path, char *out, size_t outsz)
{
	const char *p = path;
	size_t n = 0;

	while (*p == '/')
		p++;
	while (*p) {
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);

		if (clen == 0) {               /* collapse "//" */
			p = slash + 1;
			continue;
		}
		if (clen > CAS_TREE_NAME_MAX)
			return VFS_EINVAL;
		if (clen == 1 && p[0] == '.')
			return VFS_EINVAL;
		if (clen == 2 && p[0] == '.' && p[1] == '.')
			return VFS_EINVAL;
		if (n != 0) {
			if (n + 1 >= outsz)
				return VFS_EINVAL;
			out[n++] = '/';
		}
		if (n + clen >= outsz)
			return VFS_EINVAL;
		memcpy(out + n, p, clen);
		n += clen;
		if (!slash)
			break;
		p = slash + 1;
	}
	out[n] = '\0';
	return VFS_OK;
}

/* Split a non-empty relative path into its parent and leaf. "a" -> parent "",
 * leaf "a"; "a/b/c" -> parent "a/b", leaf "c". */
static void
split_parent(const char *rel, char *parent, size_t psz, const char **leaf)
{
	const char *slash = strrchr(rel, '/');

	if (!slash) {
		parent[0] = '\0';
		*leaf = rel;
		return;
	}
	size_t plen = (size_t)(slash - rel);
	if (plen >= psz)
		plen = psz - 1;
	memcpy(parent, rel, plen);
	parent[plen] = '\0';
	*leaf = slash + 1;
}

/****************************************************************
 * cas error mapping
 ****************************************************************/

static int
from_cas(int rc)
{
	switch (rc) {
	case CAS_OK:        return VFS_OK;
	case CAS_ENOTFOUND: return VFS_ENOTFOUND;
	default:            return VFS_ERR;
	}
}

/****************************************************************
 * Directory primitives
 ****************************************************************/

static struct cas_tree_entry *
dir_find(struct cas_tree_dir *dir, const char *name)
{
	for (int i = 0; i < dir->count; i++)
		if (strcmp(dir->entries[i].name, name) == 0)
			return &dir->entries[i];
	return NULL;
}

/* Add or replace an entry, rejecting a change of kind (file vs directory)
 * under the same name. */
static int
dir_set(struct cas_tree_dir *dir, const char *name, const char *hash, int mode)
{
	struct cas_tree_entry *e = dir_find(dir, name);

	if (e) {
		if ((e->mode & CAS_TREE_S_IFMT) != (mode & CAS_TREE_S_IFMT))
			return (mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR
				? VFS_ENOTDIR : VFS_EISDIR;
		memcpy(e->hash, hash, CAS_HASH_HEX + 1);
		e->mtime_s = time(NULL);
		return VFS_OK;
	}

	struct cas_tree_entry ne = {
		.mode = mode,
		.mtime_s = time(NULL),
	};

	if (strlen(name) > CAS_TREE_NAME_MAX)
		return VFS_EINVAL;
	strcpy(ne.name, name);
	memcpy(ne.hash, hash, CAS_HASH_HEX + 1);
	return cas_tree_dir_add(dir, &ne) == CAS_OK ? VFS_OK : VFS_ERR;
}

/* Drop an entry. Returns 1 if removed, 0 if absent. */
static int
dir_remove(struct cas_tree_dir *dir, const char *name)
{
	for (int i = 0; i < dir->count; i++) {
		if (strcmp(dir->entries[i].name, name) == 0) {
			dir->entries[i] = dir->entries[dir->count - 1];
			dir->count--;
			return 1;
		}
	}
	return 0;
}

/****************************************************************
 * Path walk and copy-on-write mutation
 ****************************************************************/

/* Walk a root-relative path from a tree root to its final entry. rel must be
 * non-empty. */
static int
walk(struct cas_tree *ct, const char *root, const char *rel,
	struct cas_tree_entry *e_out)
{
	char cur[CAS_HASH_HEX + 1];
	const char *p = rel;

	memcpy(cur, root, CAS_HASH_HEX + 1);
	while (*p) {
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);
		char comp[CAS_TREE_NAME_MAX + 1];
		int rc;

		memcpy(comp, p, clen);
		comp[clen] = '\0';
		rc = cas_tree_lookup(ct, cur, comp, e_out);
		if (rc != CAS_OK)
			return from_cas(rc);
		if (!slash)
			return VFS_OK;
		if ((e_out->mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return VFS_ENOTDIR;
		memcpy(cur, e_out->hash, CAS_HASH_HEX + 1);
		p = slash + 1;
	}
	return VFS_ERR;                        /* unreachable: rel is non-empty */
}

/* Set or remove one leaf in the directory tree rooted at dir_hash (NULL for an
 * empty level), rebuilding each level copy-on-write and writing the new level
 * hash to hash_out. On set, leaf_hash/leaf_mode are linked at the final
 * component and missing parents are created. On remove, the final component is
 * dropped. */
static int
tree_put(struct cas_tree *ct, const char *dir_hash, const char *rel,
	const char *leaf_hash, int leaf_mode, int do_remove, char *hash_out)
{
	struct cas_tree_dir dir;
	const char *slash = strchr(rel, '/');
	size_t clen = slash ? (size_t)(slash - rel) : strlen(rel);
	char comp[CAS_TREE_NAME_MAX + 1];
	int rc;

	if (clen == 0 || clen > CAS_TREE_NAME_MAX)
		return VFS_EINVAL;
	memcpy(comp, rel, clen);
	comp[clen] = '\0';

	if (dir_hash) {
		rc = cas_tree_load(ct, dir_hash, &dir);
		if (rc != CAS_OK)
			return from_cas(rc);
	} else {
		cas_tree_dir_init(&dir);
	}

	if (!slash) {                          /* leaf level */
		if (do_remove) {
			if (!dir_remove(&dir, comp)) {
				rc = VFS_ENOTFOUND;
				goto out;
			}
		} else {
			rc = dir_set(&dir, comp, leaf_hash, leaf_mode);
			if (rc != VFS_OK)
				goto out;
		}
	} else {                               /* descend */
		struct cas_tree_entry *e = dir_find(&dir, comp);
		const char *child_hash = NULL;
		char child_new[CAS_HASH_HEX + 1];

		if (e) {
			if ((e->mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR) {
				rc = VFS_ENOTDIR;
				goto out;
			}
			child_hash = e->hash;
		} else if (do_remove) {
			rc = VFS_ENOTFOUND;            /* parent path is absent */
			goto out;
		}
		rc = tree_put(ct, child_hash, slash + 1, leaf_hash, leaf_mode,
			do_remove, child_new);
		if (rc != VFS_OK)
			goto out;
		rc = dir_set(&dir, comp, child_new, CAS_TREE_S_IFDIR | 0755);
		if (rc != VFS_OK)
			goto out;
	}

	rc = from_cas(cas_tree_store(ct, &dir, hash_out));
out:
	cas_tree_dir_free(&dir);
	return rc;
}

/* Apply a set/remove to the current root and, on success, adopt the new root.
 * A write to an empty VFS starts the root from nothing. */
static int
root_put(struct vfs *v, const char *rel, const char *leaf_hash, int leaf_mode,
	int do_remove)
{
	char new_root[CAS_HASH_HEX + 1];
	const char *base = v->has_root ? v->root : NULL;
	int rc;

	if (!base && do_remove)
		return VFS_ENOTFOUND;
	rc = tree_put(v->ct, base, rel, leaf_hash, leaf_mode, do_remove,
		new_root);
	if (rc != VFS_OK)
		return rc;
	memcpy(v->root, new_root, CAS_HASH_HEX + 1);
	v->has_root = 1;
	return VFS_OK;
}

/* The byte length of a FILE blob, for stat. */
static int
blob_len(struct cas_tree *ct, const char *hash, uint64_t *len_out)
{
	struct cas_file cf;
	int rc = cas_open(cas_tree_cas(ct), &cf, hash);

	if (rc != CAS_OK)
		return from_cas(rc);
	*len_out = cf.len;
	cas_close(&cf);
	return VFS_OK;
}

/****************************************************************
 * Public API
 ****************************************************************/

struct vfs *
vfs_new(struct cas_tree *ct, const char *ref)
{
	struct vfs *v;
	int rc;

	if (!ct || !ref)
		return NULL;
	v = calloc(1, sizeof *v);
	if (!v)
		return NULL;
	v->ct = ct;
	v->ref = strdup(ref);
	if (!v->ref) {
		free(v);
		return NULL;
	}

	rc = cas_tree_ref_read(ct, ref, v->root);
	if (rc == CAS_OK) {
		v->has_root = 1;
	} else if (rc == CAS_ENOTFOUND) {
		v->has_root = 0;               /* empty tree, nothing committed */
	} else {
		LOG_ERROR("vfs ref \"%s\": %s", ref, cas_strerror(rc));
		free(v->ref);
		free(v);
		return NULL;
	}
	return v;
}

void
vfs_free(struct vfs *v)
{
	if (!v)
		return;
	free(v->ref);
	free(v);
}

int
vfs_commit(struct vfs *v, const char *comment)
{
	int rc;

	if (!v)
		return VFS_EINVAL;
	if (!v->has_root)
		return VFS_OK;                 /* nothing written to persist */
	rc = cas_tree_ref_commit(v->ct, v->ref, v->root, comment);
	if (rc != CAS_OK) {
		LOG_ERROR("vfs commit \"%s\": %s", v->ref, cas_strerror(rc));
		return from_cas(rc);
	}
	return VFS_OK;
}

int
vfs_stat(struct vfs *v, const char *path, struct vfs_stat *out)
{
	char rel[VFS_PATH_MAX];
	struct cas_tree_entry e;
	int rc;

	if (!v || !out)
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;

	if (rel[0] == '\0') {                  /* the root directory */
		out->kind = VFS_KIND_DIR;
		out->mode = 0755;
		out->mtime_s = 0;
		out->size = 0;
		if (v->has_root) {
			struct cas_tree_dir dir;
			if (cas_tree_load(v->ct, v->root, &dir) != CAS_OK)
				return VFS_ERR;
			out->size = (uint64_t)dir.count;
			cas_tree_dir_free(&dir);
		}
		return VFS_OK;
	}
	if (!v->has_root)
		return VFS_ENOTFOUND;

	rc = walk(v->ct, v->root, rel, &e);
	if (rc != VFS_OK)
		return rc;

	out->mode = e.mode & 0777;
	out->mtime_s = e.mtime_s;
	if ((e.mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR) {
		struct cas_tree_dir dir;
		out->kind = VFS_KIND_DIR;
		out->size = 0;
		if (cas_tree_load(v->ct, e.hash, &dir) == CAS_OK) {
			out->size = (uint64_t)dir.count;
			cas_tree_dir_free(&dir);
		}
	} else {
		out->kind = VFS_KIND_FILE;
		out->size = 0;
		blob_len(v->ct, e.hash, &out->size);
	}
	return VFS_OK;
}

int
vfs_mkdir(struct vfs *v, const char *path)
{
	char rel[VFS_PATH_MAX];
	char parent[VFS_PATH_MAX];
	const char *leaf;
	struct cas_tree_dir empty;
	char eh[CAS_HASH_HEX + 1];
	struct vfs_stat st;
	int rc;

	if (!v)
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;
	if (rel[0] == '\0')
		return VFS_EEXIST;             /* the root always exists */

	if (vfs_stat(v, path, &st) == VFS_OK)
		return VFS_EEXIST;

	/* The parent must already exist and be a directory. */
	split_parent(rel, parent, sizeof parent, &leaf);
	if (parent[0] != '\0') {
		rc = vfs_stat(v, parent, &st);
		if (rc != VFS_OK)
			return rc;
		if (st.kind != VFS_KIND_DIR)
			return VFS_ENOTDIR;
	}

	/* An empty directory object, linked at the leaf. */
	cas_tree_dir_init(&empty);
	rc = from_cas(cas_tree_store(v->ct, &empty, eh));
	cas_tree_dir_free(&empty);
	if (rc != VFS_OK)
		return rc;

	return root_put(v, rel, eh, CAS_TREE_S_IFDIR | 0755, 0);
}

int
vfs_readdir(struct vfs *v, const char *path, vfs_readdir_fn fn, void *ctx)
{
	char rel[VFS_PATH_MAX];
	char dir_hash[CAS_HASH_HEX + 1];
	struct cas_tree_dir dir;
	int rc;

	if (!v || !fn)
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;

	if (rel[0] == '\0') {
		if (!v->has_root)
			return VFS_OK;         /* an empty tree lists nothing */
		memcpy(dir_hash, v->root, CAS_HASH_HEX + 1);
	} else {
		struct cas_tree_entry e;
		if (!v->has_root)
			return VFS_ENOTFOUND;
		rc = walk(v->ct, v->root, rel, &e);
		if (rc != VFS_OK)
			return rc;
		if ((e.mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return VFS_ENOTDIR;
		memcpy(dir_hash, e.hash, CAS_HASH_HEX + 1);
	}

	rc = cas_tree_load(v->ct, dir_hash, &dir);
	if (rc != CAS_OK)
		return from_cas(rc);

	rc = VFS_OK;
	for (int i = 0; i < dir.count; i++) {
		struct cas_tree_entry *e = &dir.entries[i];
		struct vfs_stat st;

		st.mode = e->mode & 0777;
		st.mtime_s = e->mtime_s;
		if ((e->mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR) {
			st.kind = VFS_KIND_DIR;
			st.size = 0;
		} else {
			st.kind = VFS_KIND_FILE;
			st.size = 0;
			blob_len(v->ct, e->hash, &st.size);
		}
		if (fn(e->name, &st, ctx) != 0) {
			rc = VFS_ERR;
			break;
		}
	}
	cas_tree_dir_free(&dir);
	return rc;
}

int
vfs_read(struct vfs *v, const char *path, void **data_out, size_t *len_out)
{
	char rel[VFS_PATH_MAX];
	struct cas_tree_entry e;
	struct cas_file cf;
	char *buf;
	int rc;

	if (!v || !data_out || !len_out)
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;
	if (rel[0] == '\0')
		return VFS_EISDIR;
	if (!v->has_root)
		return VFS_ENOTFOUND;

	rc = walk(v->ct, v->root, rel, &e);
	if (rc != VFS_OK)
		return rc;
	if ((e.mode & CAS_TREE_S_IFMT) == CAS_TREE_S_IFDIR)
		return VFS_EISDIR;

	rc = cas_open(cas_tree_cas(v->ct), &cf, e.hash);
	if (rc != CAS_OK)
		return from_cas(rc);

	buf = malloc(cf.len + 1);
	if (!buf) {
		cas_close(&cf);
		return VFS_ERR;
	}
	memcpy(buf, cf.data, cf.len);
	buf[cf.len] = '\0';
	*data_out = buf;
	*len_out = cf.len;
	cas_close(&cf);
	return VFS_OK;
}

int
vfs_write(struct vfs *v, const char *path, const void *data, size_t len)
{
	char rel[VFS_PATH_MAX];
	char hash[CAS_HASH_HEX + 1];
	int rc;

	if (!v || (!data && len))
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;
	if (rel[0] == '\0')
		return VFS_EISDIR;

	rc = cas_put(cas_tree_cas(v->ct), data ? data : "", len, hash);
	if (rc != CAS_OK)
		return from_cas(rc);
	return root_put(v, rel, hash, CAS_TREE_S_IFREG | 0644, 0);
}

int
vfs_unlink(struct vfs *v, const char *path)
{
	char rel[VFS_PATH_MAX];
	struct vfs_stat st;
	int rc;

	if (!v)
		return VFS_EINVAL;
	rc = norm_path(path, rel, sizeof rel);
	if (rc != VFS_OK)
		return rc;
	if (rel[0] == '\0')
		return VFS_EISDIR;             /* refuse to unlink the root */

	rc = vfs_stat(v, path, &st);
	if (rc != VFS_OK)
		return rc;
	if (st.kind == VFS_KIND_DIR && st.size > 0)
		return VFS_ENOTEMPTY;

	return root_put(v, rel, NULL, 0, 1);
}
