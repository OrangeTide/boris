#ifndef OBJ_CACHE_CAS_H_
#define OBJ_CACHE_CAS_H_

#include "obj_cache.h"

#include <time.h>

struct cas_tree;

/*
 * Experimental content-addressable backend for obj_cache, built on
 * the vendored smolvfs CAS modules. Objects are stored as CAS blobs
 * under cas-tree paths of the form "<domain>/<key>", where the key
 * may itself contain slashes (e.g. "objs/rooms/church").
 *
 * Writes are two-phase. ops->save serializes the object, writes the
 * blob to CAS immediately, and buffers a path -> hash update. Nothing
 * is reachable until obj_cache_cas_commit rebuilds the changed tree
 * levels (copy-on-write) and advances the ref. A crash between save
 * and commit leaves only orphaned blobs, which cas_tree_gc collects.
 *
 * Several caches (one per domain) may share one cas_tree and ref;
 * each commit rebuilds from the ref's current root, so sequential
 * commits from sibling caches do not clobber each other.
 *
 * Cross-domain %parent resolution is not implemented yet; %parent
 * values always resolve within the same cache.
 *
 * For large domains, set CAS_TREE_USE_HTREE on the cas_tree before
 * creating caches so directory levels get O(1) lookup.
 */
OBJ_CACHE *obj_cache_cas_new(struct cas_tree *ct, const char *ref,
	const char *domain, unsigned max_unreferenced);

/*
 * Store an object under a key, like muddb_put. This is how new
 * objects enter the backend (obj_cache itself only loads on miss).
 * The blob is written to CAS immediately and buffered for the next
 * commit; a subsequent obj_cache_get sees it before the commit.
 */
int obj_cache_cas_put(OBJ_CACHE *c, const char *id, OBJ *obj);

/*
 * Commit all buffered saves: copy-on-write rebuild of the tree levels
 * touched since the last commit, then advance the ref. No-op when
 * nothing is pending. comment may be NULL.
 */
int obj_cache_cas_commit(OBJ_CACHE *c, const char *comment);

/* Number of buffered saves not yet committed. */
unsigned obj_cache_cas_pending(OBJ_CACHE *c);

/*
 * Run mark-and-sweep GC on the underlying store now. Marking covers
 * every ref's full snapshot log, so committed history is never
 * collected; only objects no commit ever linked are reclaimed
 * (orphaned blobs from crashed or abandoned saves, trees from failed
 * rebuilds). Unreachable objects younger than grace seconds are
 * spared. grace must exceed the longest time a save may sit
 * uncommitted anywhere: a sibling cache's buffered blob is
 * unreachable until that cache commits, and a zero-grace GC would
 * delete it. Pass grace 0 only when nothing is pending on any cache
 * sharing the store. removed may be NULL.
 */
int obj_cache_cas_gc(OBJ_CACHE *c, time_t grace, int *removed);

/*
 * Configure threshold-based automatic GC: after every_commits
 * successful commits from this cache, obj_cache_cas_commit runs GC
 * with the given grace. every_commits 0 disables. Default policy is
 * every 16 commits with a 3600 second grace. A GC failure is logged
 * but does not fail the commit that triggered it.
 */
void obj_cache_cas_gc_policy(OBJ_CACHE *c, unsigned every_commits,
	time_t grace);

/*
 * Configure history retention. When enabled, each automatic GC first
 * prunes the ref's snapshot log with cas_tree_log_truncate: an entry
 * survives if it is among the last keep_count entries (keep_count > 0)
 * or younger than keep_age seconds (keep_age > 0); the newest entry
 * always survives. The sweep then reclaims objects only the pruned
 * snapshots reached.
 *
 * keep_age is a duration, converted to an absolute cutoff at each
 * sweep. Passing 0 for both disables pruning.
 *
 * Retention discards committed history permanently, so it is
 * DISABLED by default: without this call the depot keeps every
 * snapshot forever. Siblings sharing the ref share the history;
 * retention configured on any one of them prunes for all.
 */
void obj_cache_cas_retention(OBJ_CACHE *c, int keep_count,
	time_t keep_age);

/*
 * Free the cache and its backend state. Does not flush or commit;
 * call obj_cache_flush_all and obj_cache_cas_commit first if the
 * buffered state matters.
 */
void obj_cache_cas_free(OBJ_CACHE *c);

#endif
