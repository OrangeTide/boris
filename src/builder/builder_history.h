/* builder_history.h : builder-facing world-history workflows */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef BUILDER_HISTORY_H_
#define BUILDER_HISTORY_H_

#include <stddef.h>
#include <stdint.h>

/*
 * The workflow layer over the snapshot bridge (builder_snapshot.h) and the
 * restore primitive (world_restore.h). It turns the in-game commands
 * (doc/snapshot-restore-spec.md section 10) into engine calls: enumerate the
 * world log filtered to a zone, walk a per-(builder, zone) undo/redo cursor,
 * restore a past entry, check a zone out to a scratch area, and publish a
 * scratch area back with the fork-point guard. The command layer
 * (src/cmd/history_cmd.c) does the telnet parsing, permission checks, and
 * output; this layer holds the history logic so it is testable without a
 * session.
 *
 * All reads go through the shared history depot handle (builder_snapshot_tree);
 * every function is a no-op returning BUILDER_HISTORY_ERR with an explanatory
 * message when the bridge is disabled.
 *
 * Two limitations follow from the dirty-only, additive snapshot bridge (spec
 * section 4.1) and are documented rather than worked around here:
 *   - A restore (undo/redo/@restore) writes live but does not itself append a
 *     snapshot, so it leaves no new log entry. The cursor therefore navigates
 *     the log as frozen at the first step; a real builder edit advances the
 *     world tip and re-anchors the cursor.
 *   - Checkout and publish copy the source from the current world tip (the last
 *     snapshot), which mirrors live except immediately after an undo of that
 *     same subtree. Deletion-aware, restore-recording snapshots are the
 *     follow-up that closes both gaps (spec section 14).
 */

#define BUILDER_HISTORY_OK   (0)
#define BUILDER_HISTORY_ERR  (-1)

/* One world-log entry touching a zone, as builder_history_list returns them
 * (newest first). hash is the snapshot root; comment is the attribution line. */
struct builder_history_entry {
	char    hash[65];	/* CAS_HASH_HEX + 1 */
	int64_t time_s;
	int32_t time_ns;
	char    comment[192];
};

/*
 * List up to max world-log entries whose comment names zone_path's slug,
 * newest first, into out. Writes the count to *n_out. Returns BUILDER_HISTORY_OK
 * (a zone with no history yields OK and 0), or BUILDER_HISTORY_ERR if the depot
 * is unavailable or zone_path is not a "zone/<slug>" path.
 */
int builder_history_list(const char *zone_path,
	struct builder_history_entry *out, int max, int *n_out);

/*
 * Undo / redo move the process-lifetime per-(user, zone) cursor one step over
 * the zone's log subsequence and restore that root's zone subtree in place.
 * force is the wizard override past a dangling-reference integrity failure
 * (spec section 9). msg (up to msglen) receives a human-facing result or reason.
 * Returns BUILDER_HISTORY_OK when a restore was performed, BUILDER_HISTORY_ERR
 * otherwise (msg says why: at an end, no history, or a failed restore).
 */
int builder_history_undo(const char *user, const char *zone_path, int force,
	char *msg, size_t msglen);
int builder_history_redo(const char *user, const char *zone_path, int force,
	char *msg, size_t msglen);

/*
 * Restore entry number entry_no (1-based as builder_history_list numbers them,
 * newest first) of zone_path. When dst_prefix is NULL or equal to zone_path the
 * restore is in place (no rewrite); otherwise it is a cross-path copy with
 * reference rewrite on. force is the wizard override. Returns OK or ERR, msg set.
 */
int builder_history_restore(const char *user, const char *zone_path,
	int entry_no, const char *dst_prefix, int force, char *msg, size_t msglen);

/*
 * Copy the live src_zone subtree into the user's scratch area
 * "zone/scratch/<user>/<name>" with reference rewrite on, recording the
 * fork-point hash for a later guarded publish. name defaults to the zone slug
 * when NULL or empty. Writes the scratch path to scratch_out (up to
 * scratch_len). Returns OK or ERR, msg set.
 */
int builder_history_checkout(const char *user, const char *src_zone,
	const char *name, int force, char *scratch_out, size_t scratch_len,
	char *msg, size_t msglen);

/*
 * The source zone recorded for the user's checkout <name>, written to buf.
 * Returns OK, or ERR if no such checkout is on record (needed by the command
 * layer to resolve and permission-check the default publish target).
 */
int builder_history_scratch_zone(const char *user, const char *name,
	char *buf, size_t len);

/*
 * Copy the user's scratch area <name> back over dst_zone (reference rewrite on),
 * guarded by the fork-point hash recorded at checkout (spec section 6.3):
 * refused if the target moved since the checkout, or into a non-empty different
 * zone. dst_zone defaults to the checkout's source when NULL or empty. force is
 * the wizard override past an integrity failure (not past the fork-point race).
 * Returns OK or ERR, msg set.
 */
int builder_history_publish(const char *user, const char *name,
	const char *dst_zone, int force, char *msg, size_t msglen);

/*
 * Pin the current world root under a named checkpoint ref (wizard surface, spec
 * section 4.3). The ref is namespaced so it is never subject to world-log
 * truncation. Returns OK or ERR, msg set.
 */
int builder_history_checkpoint(const char *label, char *msg, size_t msglen);

#endif
