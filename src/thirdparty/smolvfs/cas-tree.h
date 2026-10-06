/* cas-tree.h : tree-structured content layer on CAS */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#ifndef CAS_TREE_H
#define CAS_TREE_H

#include "cas.h"

#include <stdint.h>

/****************************************************************
 * Constants
 ****************************************************************/

#define CAS_TREE_NAME_MAX 255
#define CAS_TREE_S_IFMT   0170000
#define CAS_TREE_S_IFDIR  0040000
#define CAS_TREE_S_IFREG  0100000

#define CAS_TREE_USE_HTREE 0x1

/****************************************************************
 * Data structures
 ****************************************************************/

struct cas_tree;

struct cas_tree_entry {
    int mode;
    int uid;
    int gid;
    int64_t mtime_s;
    int32_t mtime_ns;
    char hash[CAS_HASH_HEX + 1];
    char name[CAS_TREE_NAME_MAX + 1];
};

struct cas_tree_dir {
    struct cas_tree_entry *entries;
    int count;
    int _cap;
};

/****************************************************************
 * Lifecycle
 ****************************************************************/

struct cas_tree *
cas_tree_new(struct cas *store);

/** Return the underlying CAS store. */
struct cas *
cas_tree_cas(struct cas_tree *ct);

void
cas_tree_set_flags(struct cas_tree *ct, unsigned flags);

unsigned
cas_tree_get_flags(struct cas_tree *ct);

void
cas_tree_free(struct cas_tree *ct);

/****************************************************************
 * Directory building
 ****************************************************************/

void
cas_tree_dir_init(struct cas_tree_dir *dir);

void
cas_tree_dir_free(struct cas_tree_dir *dir);

int
cas_tree_dir_add(struct cas_tree_dir *dir,
                 const struct cas_tree_entry *e);

/****************************************************************
 * Tree store / load
 ****************************************************************/

/** Serialize a directory as a "tree" object and store it in CAS. */
int
cas_tree_store(struct cas_tree *ct, struct cas_tree_dir *dir,
               char *hash_out);

/** Load a "tree" or "htree" object from CAS into a directory listing. */
int
cas_tree_load(struct cas_tree *ct, const char *hash,
              struct cas_tree_dir *dir);

/** Look up a single entry by name within a tree/htree object.
 *  O(1) for htree, O(n) for text tree.
 */
int
cas_tree_lookup(struct cas_tree *ct, const char *tree_hash,
                const char *name, struct cas_tree_entry *e_out);

/****************************************************************
 * Refs and log
 ****************************************************************/

int
cas_tree_ref_read(struct cas_tree *ct, const char *name,
                  char *hash_out);

int
cas_tree_ref_commit(struct cas_tree *ct, const char *name,
                    const char *root_hash, const char *comment);

typedef int (*cas_tree_log_fn)(const char *hash, int64_t time_s,
                               int32_t time_ns, const char *comment,
                               void *ctx);

int
cas_tree_log_read(struct cas_tree *ct, const char *name,
                  cas_tree_log_fn fn, void *ctx);

/** Prune a ref's snapshot log, bounding depot growth for a
 *  mutation-heavy ref.  An entry survives if it is among the last
 *  keep_count entries (when keep_count > 0) OR its commit time is at
 *  least keep_since (when keep_since > 0); the two bounds form a union.
 *  The newest entry is always kept: it is the ref's current root, and a
 *  live tree is protected from GC only by its log entries.  The log is
 *  rewritten atomically and fsynced under the ref lock.
 *
 *  Pruned entries are removed outright, so the objects they alone
 *  reached become collectable by a subsequent cas_tree_gc (whose mark
 *  phase now tolerates the resulting missing objects).
 *
 *  Sets *removed to the count of dropped entries (if non-NULL).
 *  Returns CAS_OK on success, CAS_ENOTFOUND if the ref has no log,
 *  CAS_ERR on a bad name or if both bounds are unset (which would keep
 *  nothing), or CAS_EIO on I/O failure.
 */
int
cas_tree_log_truncate(struct cas_tree *ct, const char *name,
                      int keep_count, time_t keep_since, int *removed);

/****************************************************************
 * Fsck
 ****************************************************************/

/** Fsck issue codes. */
enum {
    CAS_TREE_FSCK_OK,
    CAS_TREE_FSCK_MISSING,
    CAS_TREE_FSCK_CORRUPT,
    CAS_TREE_FSCK_BAD_TREE,
    CAS_TREE_FSCK_NOCODEC,  /* compressed blob, no decoder to verify */
    CAS_TREE_FSCK_FOREIGN,  /* ref points at something that is not a
                               directory; valid, just not ours to walk */
};

/** Callback for cas_tree_fsck.
 *  path is the logical tree path (e.g. "/src/main.c").
 *  hash is the CAS hash of the object.
 *  status is one of CAS_TREE_FSCK_* codes.
 *  Return 0 to continue, nonzero to stop.
 */
typedef int (*cas_tree_fsck_fn)(const char *path, const char *hash,
                                int status, void *ctx);

/** Walk all refs, verify reachable tree structure and blobs.
 *  Returns CAS_OK if everything is clean, CAS_ERR on any issue.
 */
int
cas_tree_fsck(struct cas_tree *ct, cas_tree_fsck_fn fn, void *ctx);

/** Fsck a single tree root by hash, recursively. */
int
cas_tree_fsck_root(struct cas_tree *ct, const char *root_hash,
                   cas_tree_fsck_fn fn, void *ctx);

/** Verify one directory object against the address it is stored under,
 *  without descending into it.  Returns a CAS_FSCK_* code.
 *
 *  This is the verification cas_fsck_object cannot perform: an htree is
 *  addressed by the canonical text form of the directory it encodes, not
 *  by its own bytes, so checking it needs the tree layer.  A caller
 *  accepting an htree from an untrusted source must use this rather than
 *  the object-level check, which reports CAS_FSCK_REENCODED and defers.
 *
 *  A `tree` is delegated to cas_fsck_object.  An htree must both encode
 *  the entry set whose text form hashes to the address and reproduce its
 *  own bytes when that entry set is re-encoded; see FORMAT.md,
 *  "Verifying an htree", for why one check without the other is not
 *  enough.
 *
 *  An object of some other type returns CAS_FSCK_FOREIGN rather than
 *  CAS_FSCK_CORRUPT.  Nothing constrains a ref to name a directory, and
 *  a signed topic head deliberately names a version record, so calling
 *  that corruption would be this layer claiming authority over types it
 *  does not own.
 */
int
cas_tree_verify(struct cas_tree *ct, const char *hash);

/** Check an in-memory object against the address it claims, without
 *  storing it or touching a depot.
 *
 *  An `htree` is checked by the two rules of cas_tree_verify.  A `tree`
 *  must hash to `hash` and be spelled canonically.  Any other type must
 *  hash to `hash`.  `data` is the plaintext, not a stored form.
 *
 *  Returns CAS_OK if the object may be admitted, CAS_ERR otherwise.  The
 *  signature matches cas_pack_verify_fn, so it can be handed to
 *  cas_pack_import directly.
 */
int
cas_tree_check_object(const char *type, const void *data, size_t len,
                      const char *hash);

/** Store an object obtained from outside, checking it first.
 *
 *  This is the trust boundary.  Objects are validated as they enter the
 *  depot, and objects already in the depot are trusted when read, so a
 *  reader does no work to re-establish what this call established.  Use
 *  it for anything a peer, an origin, or a user supplied.
 *
 *  cas_put_object_at is the unchecked primitive underneath: it writes
 *  the bytes at whatever address the caller names and verifies nothing.
 *  Only a caller that has already verified may use it.
 *
 *  An `htree` gets the two checks of cas_tree_verify.  A `tree` must
 *  hash to `hash` and be spelled canonically.  Any other type must hash
 *  to `hash`.  Returns CAS_OK on success, CAS_ERR if the object fails
 *  its check, and nothing is stored in that case.
 *
 *  fsck re-runs the equivalent checks periodically, which catches what
 *  happened to an object after it was admitted rather than what it was
 *  when it arrived.
 */
int
cas_tree_put_checked(struct cas_tree *ct, const char *type,
                     const void *data, size_t len, const char *hash);

/****************************************************************
 * Garbage collection
 ****************************************************************/

/* Implemented in cas-gc.c, a separate translation unit.  A consumer that
 * uses the tree layer only as a content-addressed store, with no garbage
 * collection, can leave cas-gc.c out of the build; nothing else in the
 * tree layer depends on it. */

/** Callback for cas_tree_gc progress reporting.
 *  Called for each removed hash.
 *  Return 0 to continue, nonzero to stop.
 */
typedef int (*cas_tree_gc_fn)(const char *hash, void *ctx);

/** Remove unreachable objects older than grace seconds.
 *
 *  Objects not reachable from any ref AND whose mtime is at least
 *  grace seconds old are deleted.  Pass 0 to skip the grace period
 *  and delete all unreachable objects immediately.
 *  Sets *removed to the count of deleted objects (if non-NULL).
 */
int
cas_tree_gc(struct cas_tree *ct, time_t grace, cas_tree_gc_fn fn,
            void *ctx, int *removed);

/** Compacting gc: rebuild the pack from only the reachable objects, then
 *  reclaim their loose copies and sweep unreachable loose objects past the
 *  grace period.
 *
 *  Unlike cas_tree_gc, this expunges unreachable objects trapped in the
 *  pack (a pack entry has no grace, since it predates the pack it sits in),
 *  and it moves reachable loose objects into the pack.  policy and codec
 *  set the pack's compression (a CAS_COMPRESS_* mode and codec tag from
 *  cas-codec.h; pass CAS_COMPRESS_NEVER / CAS_CODEC_NONE for none).
 *
 *  Sets *removed to the count of unreachable loose objects deleted and
 *  *reclaimed to the count of loose copies folded into the pack (both if
 *  non-NULL).  Returns CAS_OK on success.
 */
int
cas_tree_gc_pack(struct cas_tree *ct, time_t grace, int policy, int codec,
                 cas_tree_gc_fn fn, void *ctx, int *removed,
                 uint64_t *reclaimed);

/****************************************************************
 * Ref iteration
 ****************************************************************/

/** Callback for cas_tree_ref_foreach.
 *  Called with each ref name (without extension).
 *  Return 0 to continue, nonzero to stop.
 */
typedef int (*cas_tree_ref_fn)(const char *name, void *ctx);

/** Iterate over all refs in the store. */
int
cas_tree_ref_foreach(struct cas_tree *ct, cas_tree_ref_fn fn,
                     void *ctx);

#endif /* CAS_TREE_H */
