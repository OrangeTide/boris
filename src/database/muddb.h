#ifndef MUDDB_H_
#define MUDDB_H_

#include "obj.h"

#define MUDDB_OK       (0)
#define MUDDB_ERR      (-1)
#define MUDDB_NOTFOUND (-2)

typedef struct muddb MUDDB;
typedef struct muddb_iter MUDDB_ITER;

/* global instance -- opened in boris.c */
extern MUDDB *mud_db;

/* lifecycle */
MUDDB *muddb_open(const char *path, unsigned flags);
void muddb_close(MUDDB *db);

/* single-object operations (domain = LMDB named database) */
OBJ *muddb_get(MUDDB *db, const char *domain, const char *key);
int muddb_put(MUDDB *db, const char *domain, const char *key, OBJ *obj);
int muddb_del(MUDDB *db, const char *domain, const char *key);

/* iteration -- returns keys within a domain */
MUDDB_ITER *muddb_iter_begin(MUDDB *db, const char *domain);
const char *muddb_iter_next(MUDDB_ITER *it);
OBJ *muddb_iter_value(MUDDB_ITER *it);
void muddb_iter_end(MUDDB_ITER *it);

/*
 * Indexes: set-valued (DUPSORT) sub-databases for reverse and secondary
 * associations, e.g. container -> members. Each index maps a key to a sorted,
 * deduplicated set of string values (object keys). Names are prefixed "idx." by
 * convention to avoid colliding with object domains, and must be registered
 * once at init before use so their handle is opened under the write lock.
 */
int muddb_index_register(MUDDB *db, const char *index);

/* Standalone index writes, each in its own write transaction. add is idempotent;
 * del of a missing pair succeeds. */
int muddb_index_add(MUDDB *db, const char *index, const char *key,
                    const char *value);
int muddb_index_del(MUDDB *db, const char *index, const char *key,
                    const char *value);

/* Index queries, each in its own read transaction. contains returns 1/0; count
 * returns the number of values under key (0 if absent). */
int  muddb_index_contains(MUDDB *db, const char *index, const char *key,
                          const char *value);
long muddb_index_count(MUDDB *db, const char *index, const char *key);

/* Walk the values under one index key. A missing or empty index yields nothing.
 * The returned pointer is owned by the iterator and valid until the next call. */
typedef struct muddb_index_iter MUDDB_INDEX_ITER;
MUDDB_INDEX_ITER *muddb_index_iter_begin(MUDDB *db, const char *index,
                                         const char *key);
const char *muddb_index_iter_next(MUDDB_INDEX_ITER *it);
void muddb_index_iter_end(MUDDB_INDEX_ITER *it);

/*
 * Multi-op write transaction: bundle an object write with its index deltas so
 * they commit atomically (e.g. an object's %location and the contents index).
 * muddb_txn_begin takes the write lock; commit or abort releases it and frees
 * the handle. Do not call the single-op functions above (which take the same
 * lock) while a transaction is open. A staged op that fails marks the handle so
 * commit aborts instead; the caller should abort on any error.
 */
typedef struct muddb_txn MUDDB_TXN;
MUDDB_TXN *muddb_txn_begin(MUDDB *db);
int  muddb_txn_put(MUDDB_TXN *t, const char *domain, const char *key, OBJ *obj);
int  muddb_txn_del(MUDDB_TXN *t, const char *domain, const char *key);
int  muddb_txn_index_add(MUDDB_TXN *t, const char *index, const char *key,
                         const char *value);
int  muddb_txn_index_del(MUDDB_TXN *t, const char *index, const char *key,
                         const char *value);
int  muddb_txn_commit(MUDDB_TXN *t);
void muddb_txn_abort(MUDDB_TXN *t);

#endif
