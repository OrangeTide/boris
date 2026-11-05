/* builder_snapshot.h : in-process snapshot bridge (LMDB -> CAS history) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef BUILDER_SNAPSHOT_H_
#define BUILDER_SNAPSHOT_H_

#include "obj.h"

struct cas_tree;

/*
 * The live object cache keeps every game object in one muddb domain, "objs"
 * (obj_store.c). Snapshots mirror that domain, so a CAS object lives at the
 * tree path "objs/<key>". The snapshot bridge and the restore path share this.
 */
#define BUILDER_SNAPSHOT_DOMAIN "objs"

/* The ref that holds the single live world's history (spec section 3.1). */
#define BUILDER_SNAPSHOT_REF "world"

/*
 * The snapshot bridge records world history as a side effect of builder
 * edits (doc/snapshot-restore-spec.md section 4). After builder_save commits
 * an edit to LMDB (the working tree and single source of truth), it hands the
 * just-written key to the bridge, which mirrors that one object into a
 * CAS-backed cache on the "world" ref and appends a commit. Snapshots are
 * incremental and dirty-only: one object per save.
 *
 * Recording is best-effort history, never part of the edit's success
 * condition (section 4.4). A failure to snapshot is logged and swallowed; the
 * LMDB edit has already succeeded and the world is correct.
 */

/*
 * Open the snapshot depot at depot_path and ready the "world" ref for
 * recording. Call once at startup, after obj_initialize. Returns 0 on success
 * or -1 on failure; on failure the bridge stays disabled and builder_snapshot_record
 * is a no-op, so the server still runs without history.
 */
int builder_snapshot_init(const char *depot_path);

/*
 * Free the depot and its caches. Call at shutdown. Safe if init was never
 * called or failed.
 */
void builder_snapshot_shutdown(void);

/*
 * Record one just-committed builder edit: mirror obj (stored under key in the
 * live tree) into the CAS and append a commit attributed to actor_name. A
 * no-op when the bridge is disabled. Never fails the caller.
 */
void builder_snapshot_record(const char *key, OBJ *obj, const char *actor_name);

/* True if the bridge is open and recording (for tests and status). */
int builder_snapshot_enabled(void);

/*
 * Configure history retention and garbage collection on the "world" log
 * (doc/snapshot-restore-spec.md section 8). Per-save snapshots grow the log by
 * one entry per edit, so retention is mandatory; builder_snapshot_init applies
 * defaults, and this overrides them (used by tests and, later, config).
 *
 *   keep_count        keep at least the last N log entries (0 disables).
 *   keep_age_s        also keep entries younger than this many seconds (0
 *                     disables). The two bounds form a union; the newest entry
 *                     always survives. Both 0 disables pruning.
 *   gc_every_commits  run a prune-and-sweep after this many commits (0 off).
 *   grace_s           spare unreachable objects younger than this at a sweep.
 *                     Must exceed the longest a save may sit uncommitted.
 *
 * A no-op when the bridge is disabled.
 */
void builder_snapshot_set_retention(int keep_count, long keep_age_s,
	unsigned gc_every_commits, long grace_s);

/*
 * The cas_tree backing the history depot, or NULL when the bridge is disabled.
 * The restore path reads snapshots through this shared handle, because the
 * depot lock is exclusive and a second cas on the same depot would block.
 */
struct cas_tree *builder_snapshot_tree(void);

#endif
