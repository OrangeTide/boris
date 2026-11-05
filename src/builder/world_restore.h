/* world_restore.h : scoped CAS -> LMDB restore (the copy primitive) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef WORLD_RESTORE_H_
#define WORLD_RESTORE_H_

struct cas_tree;

#define WORLD_RESTORE_OK   (0)
#define WORLD_RESTORE_ERR  (-1)

/*
 * Restore a subtree from a CAS snapshot into the live LMDB store
 * (doc/snapshot-restore-spec.md sections 3.1, 6 and 7). This is the
 * cas-to-muddb half of the copy(src, dst, rewrite) primitive.
 *
 *   ct         the cas_tree holding the history depot (the shared handle from
 *              builder_snapshot_tree() on a live server).
 *   root_hash  the snapshot root to read the source subtree from (a hash from
 *              the ref's log). Must be non-NULL.
 *   src_prefix the source subtree, a key prefix with no trailing slash
 *              (e.g. "zone/world"). Everything under "<src_prefix>/" is read.
 *   dst_prefix the destination subtree prefix in the live tree.
 *   rewrite    when nonzero, rewrite intra-subtree references as keys move from
 *              src_prefix to dst_prefix.
 *
 * The restore reads the source objects from CAS, then in one transaction
 * writes them into live, deletes live keys under the destination that are
 * absent from the source, rebuilds the contents and owner indexes, and
 * invalidates the object cache (obj_apply_restore).
 *
 * Step 2 implements the in-place case (src_prefix == dst_prefix, rewrite off),
 * which is undo, redo, and same-path restore. Cross-path copy with reference
 * rewrite (checkout and publish) lands with the rewrite pass (spec step 3);
 * until then a cross-path or rewrite request returns WORLD_RESTORE_ERR.
 *
 * Returns WORLD_RESTORE_OK, or WORLD_RESTORE_ERR with nothing changed.
 */
int world_restore(struct cas_tree *ct, const char *root_hash,
	const char *src_prefix, const char *dst_prefix, int rewrite);

#endif
