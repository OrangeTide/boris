#ifndef OBJ_H_
#define OBJ_H_

#include <stddef.h>

struct muddb;

#define OBJ_OK (0)
#define OBJ_ERR (-1)
#define OBJ_ERR_NOMEM (-2)
#define OBJ_ERR_PROTECTED (-3)

#define OBJ_PATH_MAX 256

typedef struct obj OBJ;

OBJ *obj_new(const char *key);
OBJ *obj_new_from_json(const char *key, const char *json);
void obj_free(OBJ *obj);

/* the object's key (its cache id), borrowed and valid for the object's life */
const char *obj_key(OBJ *obj);

/* returns borrowed pointer -- valid until next mutation or obj_free */
char *obj_prop_get(OBJ *obj, const char *propname);

/* Resolve propname through the prototype chain: the object's own value, else
 * the first ancestor (%parent) that defines it, stopping at a local tombstone.
 * Returns a strdup'd string the caller frees, or NULL if unset. Structural
 * (%) and tombstone (!) names are not resolvable and return NULL. */
char *obj_prop_resolve(OBJ *obj, const char *propname);

/*
 * Public setters/deleter. Reject propnames starting with '%' (structural
 * fields like %parent, %kind) with OBJ_ERR_PROTECTED. Use the _internal
 * variants when writing those from privileged code paths.
 */
int obj_prop_set(OBJ *obj, const char *propname, const char *value);
int obj_prop_set_int(OBJ *obj, const char *propname, int value);
int obj_prop_delete(OBJ *obj, const char *propname);

/* Privileged variants -- bypass the %-prefix protection and tombstone
 * semantics. Used internally by the prototype/cache layer. */
int obj_prop_set_internal(OBJ *obj, const char *propname, const char *value);
int obj_prop_delete_internal(OBJ *obj, const char *propname);

/* True if this object carries a local tombstone for propname ("!propname").
 * Only meaningful at the prototype-walk layer. */
int obj_prop_is_tombstoned(OBJ *obj, const char *propname);

/*
 * Object references.
 *
 * A reference is a property whose stored key carries the reserved reference
 * marker '~' as a trailing character (e.g. "exit.e.to~", "%parent~"), with the
 * referenced object's path-id as a plain string value. The marker makes a
 * reference distinguishable from a string by the key alone, so a path rewrite
 * or an integrity scan can act on references and never on other string content.
 * See doc/snapshot-restore-spec.md section 5.1. A list of references is a set
 * of indexed reference keys ("keys.0~", "keys.1~"), not an array value.
 *
 * The accessors below take the logical name WITHOUT the marker and add it
 * internally. The generic obj_prop_set / obj_prop_delete reject a marked key
 * (OBJ_ERR_PROTECTED), so a reference is written only through these, which
 * validate the value as a path-id.
 */
#define OBJ_REF_MARK '~'

/* True if propname is a reference key: its last character is the marker and it
 * is not a tombstone. Takes a stored key (with the marker), as iteration
 * yields it. */
int obj_prop_is_ref(const char *propname);

/* Get the path-id stored under reference `name` (the marker is added
 * internally). Returns a borrowed pointer valid until the next mutation or
 * obj_free, or NULL if unset. */
char *obj_prop_get_ref(OBJ *obj, const char *name);

/* Set reference `name` to path-id `value` (the marker is added internally).
 * Rejects a `name` beginning with '%' or '!' (OBJ_ERR_PROTECTED) and a `value`
 * that is not a well-formed path-id (OBJ_ERR). Returns OBJ_OK or an error. */
int obj_prop_set_ref(OBJ *obj, const char *name, const char *value);

/* Privileged variant: writes a structural reference ('%parent', '%location')
 * without the %-prefix protection. Used by the cache and the migration. */
int obj_prop_set_ref_internal(OBJ *obj, const char *name, const char *value);

/* Delete reference `name` (the marker is added internally). Rejects a `name`
 * beginning with '%' or '!'. Returns OBJ_OK. */
int obj_prop_delete_ref(OBJ *obj, const char *name);

/* Privileged variant: deletes a structural reference ('%location') raw, with
 * no %-prefix protection and no tombstone. Used by the containment path. */
int obj_prop_delete_ref_internal(OBJ *obj, const char *name);

int obj_get_json(OBJ *obj, char *buf, size_t len, size_t *out_len);
int obj_compact(OBJ *obj);

void obj_debug_dump(OBJ *obj, void (*output_str)(const char *s));

/* property iteration -- walks all properties in token order.
 * returned key/value pointers are borrowed from the OBJ and valid
 * until the next mutation or obj_free. */
typedef struct obj_iter OBJ_ITER;
OBJ_ITER *obj_iter_begin(OBJ *obj);
int obj_iter_next(OBJ_ITER *it, const char **key, const char **value);
void obj_iter_end(OBJ_ITER *it);

/* global object cache, backed by muddb */
int obj_initialize(struct muddb *db, unsigned cache_size);
void obj_shutdown(void);

/* The muddb handle backing the global object cache, or NULL before
 * obj_initialize. For callers that read the store directly, such as export. */
struct muddb *obj_db(void);

/* Flush every dirty cached object to the backing store, so a direct read of
 * muddb (e.g. export) reflects live edits. Returns OBJ_OK or OBJ_ERR. */
int obj_sync(void);
OBJ *obj_get(const char *id);
void obj_release(OBJ *obj);

/*
 * Insert a new object into the global store under id. Write-through wrapper
 * over the cache's put: the object is serialized to muddb immediately and
 * ownership stays with the caller. Use for new keys; edit an existing object
 * through obj_get + obj_release instead. Returns OBJ_OK or OBJ_ERR.
 */
int obj_put(const char *id, OBJ *obj);

/*
 * Resolve a property on the object at id, walking the %parent prototype
 * chain (up to the cache's max depth). Returns a strdup'd value the caller
 * frees, or NULL if id is missing or the property is unset/tombstoned.
 * Used for inherited defaults (a room's template, a zone's ambient props).
 */
char *obj_resolve_prop(const char *id, const char *propname);

/*
 * As obj_resolve_prop, but for a reference property: the '~' marker is added
 * to `name` internally, so a caller resolves an inherited reference (e.g. a
 * zone's "template") without spelling the marker.
 */
char *obj_resolve_prop_ref(const char *id, const char *name);

/*
 * Delete id from the global store and drop any cached copy. Returns OBJ_OK,
 * or OBJ_ERR if the delete failed.
 */
int obj_delete(const char *id);

/*
 * Apply a scoped restore to the live store in one transaction: write each
 * put_objs[i] under put_keys[i], delete each del_keys[j], rebuild the contents
 * and owner indexes for every touched key, and invalidate the object cache
 * (doc/snapshot-restore-spec.md sections 6 and 7). The put objects are borrowed
 * (serialized into the store; the caller keeps ownership). On success the whole
 * set is committed atomically; on any error the transaction is aborted and the
 * store is left unchanged. The cache is flushed before the writes so pending
 * edits are not lost, and the touched keys are forgotten so a later obj_get
 * reloads the restored state. Returns OBJ_OK or OBJ_ERR. muddb backend only.
 */
int obj_apply_restore(const char *const *put_keys, OBJ *const *put_objs,
	size_t n_put, const char *const *del_keys, size_t n_del);

/*
 * Drop a cached copy of id without deleting it from the store, so the next
 * obj_get reloads the current stored value. Use after a write-through obj_put
 * to a key that may already be cached (editing an existing object), keeping
 * the cache coherent. A copy still held by more than one caller is left in
 * place. No-op if id is not cached.
 */
void obj_forget(const char *id);

/*
 * Enumerate object keys beginning with prefix (all keys if prefix is NULL or
 * empty), calling cb(key, ctx) for each in key order. Read-only over the
 * store's key space. Returns the number of keys visited, or -1 on error. The
 * key passed to cb is valid only for that call; copy it to retain it. Fetch
 * values with obj_get so cached edits are honored.
 */
int obj_foreach_key(const char *prefix,
	void (*cb)(const char *key, void *ctx), void *ctx);
/* Create a new persistent object with the given id, inserted into the global
 * cache as a pinned, dirty object (written through on flush or eviction).
 * Returns the pinned object (release with obj_release), or NULL if the id is
 * already taken or on error. */
OBJ *obj_create(const char *id);

/* Destroy the object with the given id: drop it from the cache and delete it
 * from the backing store. Fails if the object is still pinned or the backend
 * cannot delete. Returns OBJ_OK or OBJ_ERR. */
int obj_destroy(const char *id);

/* Mark obj dirty so it is saved on eviction, flush, or obj_save. Call after
 * mutating a cached object (e.g. obj_prop_set) so the change is not lost. */
void obj_mark_dirty(OBJ *obj);

/* Persist the object with the given id now if it is cached and dirty. A no-op
 * when it is not cached or already clean. Returns OBJ_OK or OBJ_ERR. */
int obj_save(const char *id);

/*
 * Containment. An object carries %location (its container's id) as a cheap
 * forward pointer; the reverse view (container -> members) is a persisted
 * secondary index maintained on the write path. Only available on the muddb
 * backend, which has the index facility and multi-op transactions.
 */

/* Move member into container, or to limbo when container is NULL. Writes
 * %location and the old and new contents-index entries in one transaction, so
 * the forward pointer and the reverse view cannot diverge. Refuses a move that
 * would form a cycle (member into itself or into one of its own descendants).
 * Returns OBJ_OK or OBJ_ERR. */
int obj_move(const char *member, const char *container);

/* Return the container id of member (strdup'd, caller frees), or NULL if the
 * object is in limbo, missing, or on error. */
char *obj_location(const char *member);

/* Number of members directly contained by container (0 if none or on error). */
long obj_contents_count(const char *container);

/* Set an object's owner (%owner) and keep the owner index in step, so
 * obj_owner_count stays a cheap per-owner tally. Returns OBJ_OK or OBJ_ERR. On
 * the CAS backend the property is written but no index is kept. */
int obj_set_owner(const char *id, const char *owner);

/* Number of objects owned by `owner`, from the owner index (0 if none, or on
 * the CAS backend which keeps no index). Counts only objects whose owner was
 * set through obj_set_owner. */
long obj_owner_count(const char *owner);

/* Walk the ids of the members directly contained by container. The returned id
 * is borrowed from the iterator and valid only until the next call. A missing
 * or empty container yields nothing. Members need not be currently loaded. */
typedef struct obj_contents_iter OBJ_CONTENTS_ITER;
OBJ_CONTENTS_ITER *obj_contents_begin(const char *container);
const char *obj_contents_next(OBJ_CONTENTS_ITER *it);
void obj_contents_end(OBJ_CONTENTS_ITER *it);

typedef void (*obj_notify_fn)(OBJ *obj, const char *id, void *arg);
void obj_set_load_cb(obj_notify_fn cb, void *arg);
void obj_set_evict_cb(obj_notify_fn cb, void *arg);

#endif
