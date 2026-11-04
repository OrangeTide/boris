/* vfs.h : a content-addressed filesystem for in-world programs.
 *
 * The VFS gives hosted guest programs (the in-world toolchain, tools, a REPL)
 * a path namespace of typed inodes: FILE (a byte blob) and DIR (a name->inode
 * map). It is built on the smolvfs cas-tree layer, so a directory is a tree
 * object, a file's bytes live content-addressed in CAS, and the whole tree is
 * anchored by one named ref. Writes are copy-on-write: a mutation rebuilds only
 * the affected path and advances an in-memory root; vfs_commit folds that root
 * into the ref as a snapshot, reusing the cas-tree dedup, snapshot, and GC.
 *
 * This is the storage core. Paths are absolute within the tree (the per-owner
 * home-directory sandbox and the per-task fd table belong to the host-call
 * layer that will sit above this). See doc/vm-hosting-proposal.md. */

#ifndef VFS_H
#define VFS_H

#include <stddef.h>
#include <stdint.h>

/* Return codes. */
#define VFS_OK         0
#define VFS_ERR       -1       /* unspecified failure (I/O, corruption) */
#define VFS_ENOTFOUND -2       /* no such path */
#define VFS_EEXIST    -3       /* path already exists */
#define VFS_EISDIR    -4       /* a directory where a file was expected */
#define VFS_ENOTDIR   -5       /* a file where a directory was expected */
#define VFS_EINVAL    -6       /* a malformed path */
#define VFS_ENOTEMPTY -7       /* directory not empty */

/* The longest path the VFS accepts, including separators. */
#define VFS_PATH_MAX 1024

enum vfs_kind {
	VFS_KIND_FILE = 1,
	VFS_KIND_DIR  = 2,
};

struct vfs_stat {
	enum vfs_kind kind;
	uint64_t      size;        /* byte length for FILE, entry count for DIR */
	int           mode;        /* permission bits (low 9) */
	int64_t       mtime_s;
};

struct cas_tree;
struct vfs;

/* Open a VFS over a cas-tree, anchored at the named ref. Loads the ref's
 * current root if it has one, else starts empty. Returns NULL on failure. */
struct vfs *vfs_new(struct cas_tree *ct, const char *ref);

void vfs_free(struct vfs *v);

/* Persist the current tree: point the ref at the in-memory root and append a
 * snapshot log entry. With nothing written yet, a no-op returning VFS_OK. */
int vfs_commit(struct vfs *v, const char *comment);

/* Fill *out with the inode metadata at path. The root ("/" or "") is a DIR. */
int vfs_stat(struct vfs *v, const char *path, struct vfs_stat *out);

/* Create a directory at path. Its parent must already exist; the leaf must
 * not. Returns VFS_EEXIST, VFS_ENOTFOUND (missing parent), or VFS_ENOTDIR. */
int vfs_mkdir(struct vfs *v, const char *path);

/* List a directory, calling fn for each entry (its leaf name and stat). A
 * nonzero fn return stops the walk and is returned. */
typedef int (*vfs_readdir_fn)(const char *name, const struct vfs_stat *st,
	void *ctx);
int vfs_readdir(struct vfs *v, const char *path, vfs_readdir_fn fn, void *ctx);

/* Read a whole file into a freshly malloc'd buffer (NUL-terminated for
 * convenience; the terminator is not counted in *len_out). The caller frees
 * *data_out. An empty file yields a 1-byte buffer and *len_out == 0. */
int vfs_read(struct vfs *v, const char *path, void **data_out, size_t *len_out);

/* Create or replace a file at path with the given bytes, folding them into
 * CAS. Parent directories are created as needed. */
int vfs_write(struct vfs *v, const char *path, const void *data, size_t len);

/* Remove a file, or an empty directory. VFS_ENOTEMPTY if a directory still has
 * entries. */
int vfs_unlink(struct vfs *v, const char *path);

#endif /* VFS_H */
