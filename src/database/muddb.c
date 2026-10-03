/**
 * @file muddb.c
 *
 * LMDB-backed object database for the MUD.
 *
 * Stores and retrieves OBJ instances as JSON blobs in LMDB named
 * databases. Each domain (users, rooms, characters, ...) maps to a
 * separate LMDB named database. DBI handles are cached for the
 * lifetime of the environment.
 *
 * Copyright (c) 2022-2026, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "muddb"
#endif
#include "muddb.h"

#include <pthread.h>
#include <stdlib.h>
#include <string.h>

#include <lmdb.h>
#include <log.h>

#define MUDDB_MAX_DBS    32
#define MUDDB_MAPSIZE    (64 * 1024 * 1024)  /* 64 MB */
#define MUDDB_PUT_BUFSZ  4096
/* Largest index value the iterator returns. Index values are object keys,
 * bounded by OBJ_PATH_MAX (256), so this has headroom. The write path does not
 * enforce it; a value longer than MUDDB_INDEX_VALSZ-1 is stored in full but
 * truncated when muddb_index_iter_next copies it out. Keep index values to
 * object keys and this never bites. */
#define MUDDB_INDEX_VALSZ 512

struct muddb_dbi_entry {
	char *name;
	MDB_dbi dbi;
};

struct muddb {
	MDB_env *env;
	pthread_mutex_t lock;		/* serialize write transactions */
	unsigned dbi_count;
	struct muddb_dbi_entry dbi_cache[MUDDB_MAX_DBS];
};

struct muddb_iter {
	MUDDB *db;
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_cursor *cursor;
	MDB_val cur_key;		/* current key from cursor */
	int started;
};

struct muddb_txn {
	MUDDB *db;
	MDB_txn *txn;
	int failed;			/* a staged op failed; commit must abort */
	unsigned dbi_mark;		/* dbi_count at begin; see dbi_cache_rollback */
};

struct muddb_index_iter {
	MDB_txn *txn;
	MDB_cursor *cursor;		/* NULL for an empty iterator */
	char *key;			/* index key, for MDB_SET_KEY */
	size_t keylen;
	int started;
	char valbuf[MUDDB_INDEX_VALSZ];	/* current value, NUL-terminated */
};

/* open or retrieve a cached dbi handle.
 * when create is set, MDB_CREATE is passed so the domain is created if it
 * does not exist -- this requires a write txn. when create is not set, a
 * missing domain returns MUDDB_NOTFOUND instead of an error. extra_flags adds
 * db flags (e.g. MDB_DUPSORT for an index) and only takes effect the first time
 * a name is opened; later calls hit the cache and return the existing handle. */
static int
muddb_dbi_open(MUDDB *db, MDB_txn *txn, const char *domain, int create,
               unsigned extra_flags, MDB_dbi *out)
{
	unsigned i;
	unsigned flags;
	int rc;

	/* check cache */
	for (i = 0; i < db->dbi_count; i++) {
		if (strcmp(db->dbi_cache[i].name, domain) == 0) {
			*out = db->dbi_cache[i].dbi;
			return MUDDB_OK;
		}
	}

	/* open new dbi */
	if (db->dbi_count >= MUDDB_MAX_DBS) {
		LOG_ERROR("too many domains (max %d)", MUDDB_MAX_DBS);
		return MUDDB_ERR;
	}

	flags = (create ? MDB_CREATE : 0) | extra_flags;
	rc = mdb_dbi_open(txn, domain, flags, out);
	if (rc == MDB_NOTFOUND) {
		return MUDDB_NOTFOUND;
	}
	if (rc != 0) {
		LOG_ERROR("mdb_dbi_open(%s): %s", domain, mdb_strerror(rc));
		return MUDDB_ERR;
	}

	db->dbi_cache[db->dbi_count].name = strdup(domain);
	if (!db->dbi_cache[db->dbi_count].name) {
		LOG_ERROR("strdup failed for domain name");
		return MUDDB_ERR;
	}
	db->dbi_cache[db->dbi_count].dbi = *out;
	db->dbi_count++;

	return MUDDB_OK;
}

/* Forget dbi_cache entries added at or after mark, freeing their names. LMDB
 * closes a DBI opened inside a transaction if that transaction aborts (see
 * lmdb.h mdb_dbi_open), so a write txn that created a new named DB and then
 * aborted would otherwise leave a closed handle cached under its name. A write
 * transaction records dbi_count at begin and rolls back to it on any failure,
 * so the handle is re-opened cleanly on next use. */
static void
dbi_cache_rollback(MUDDB *db, unsigned mark)
{
	while (db->dbi_count > mark) {
		db->dbi_count--;
		free(db->dbi_cache[db->dbi_count].name);
		db->dbi_cache[db->dbi_count].name = NULL;
	}
}

/* pre-open all known domains in a single write transaction so DBI
 * handles are valid for the lifetime of the environment. LMDB
 * requires that named database open operations be serialized. */
static int
muddb_preopen_domains(MUDDB *db)
{
	static const char *known_domains[] = {
		"users", "objs", "chars", NULL
	};
	MDB_txn *txn;
	MDB_dbi dbi;
	int i, rc;

	rc = mdb_txn_begin(db->env, NULL, 0, &txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(init): %s", mdb_strerror(rc));
		return MUDDB_ERR;
	}

	for (i = 0; known_domains[i]; i++) {
		if (muddb_dbi_open(db, txn, known_domains[i], 1, 0, &dbi) != MUDDB_OK) {
			LOG_ERROR("could not open domain \"%s\"", known_domains[i]);
			mdb_txn_abort(txn);
			return MUDDB_ERR;
		}
	}

	mdb_txn_commit(txn);
	return MUDDB_OK;
}

MUDDB *
muddb_open(const char *path, unsigned flags)
{
	MUDDB *db;
	int rc;

	(void)flags;

	db = calloc(1, sizeof(*db));
	if (!db) {
		LOG_ERROR("failed to allocate muddb");
		return NULL;
	}

	pthread_mutex_init(&db->lock, NULL);

	rc = mdb_env_create(&db->env);
	if (rc != 0) {
		LOG_ERROR("mdb_env_create: %s", mdb_strerror(rc));
		goto fail;
	}

	mdb_env_set_mapsize(db->env, MUDDB_MAPSIZE);
	mdb_env_set_maxdbs(db->env, MUDDB_MAX_DBS);

	/* MDB_NOTLS: tie reader slot to the MDB_txn object, not TLS.
	 * required because we nest read txns on one thread (e.g. a
	 * muddb_iter_begin loop calling muddb_get per key). */
	rc = mdb_env_open(db->env, path, MDB_NOTLS, 0664);
	if (rc != 0) {
		LOG_ERROR("mdb_env_open(%s): %s", path, mdb_strerror(rc));
		mdb_env_close(db->env);
		goto fail;
	}

	if (muddb_preopen_domains(db) != MUDDB_OK) {
		mdb_env_close(db->env);
		goto fail;
	}

	return db;

fail:
	pthread_mutex_destroy(&db->lock);
	free(db);
	return NULL;
}

void
muddb_close(MUDDB *db)
{
	unsigned i;

	if (!db)
		return;

	for (i = 0; i < db->dbi_count; i++)
		free(db->dbi_cache[i].name);

	mdb_env_close(db->env);
	pthread_mutex_destroy(&db->lock);
	free(db);
}

OBJ *
muddb_get(MUDDB *db, const char *domain, const char *key)
{
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_val mkey, mdata;
	OBJ *obj;
	int rc;

	rc = mdb_txn_begin(db->env, NULL, MDB_RDONLY, &txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(read): %s", mdb_strerror(rc));
		return NULL;
	}

	rc = muddb_dbi_open(db, txn, domain, 0, 0, &dbi);
	if (rc != MUDDB_OK) {
		LOG_DEBUG("muddb_get: dbi_open(%s) failed rc=%d", domain, rc);
		mdb_txn_abort(txn);
		return NULL;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);

	rc = mdb_get(txn, dbi, &mkey, &mdata);
	if (rc == MDB_NOTFOUND) {
		LOG_DEBUG("muddb_get: key \"%s\" not found in domain \"%s\"", key, domain);
		mdb_txn_abort(txn);
		return NULL;
	}
	if (rc != 0) {
		LOG_ERROR("mdb_get(%s/%s): %s", domain, key, mdb_strerror(rc));
		mdb_txn_abort(txn);
		return NULL;
	}

	/* mdata.mv_data is not null-terminated -- make a copy */
	{
		size_t json_len = mdata.mv_size;
		char *json = malloc(json_len + 1);

		if (!json) {
			mdb_txn_abort(txn);
			return NULL;
		}
		memcpy(json, mdata.mv_data, json_len);
		json[json_len] = '\0';

		mdb_txn_abort(txn);

		/* check and strip record sentinel */
		if (json_len > 0 && json[json_len - 1] == '\n') {
			json_len--;
			json[json_len] = '\0';
		} else {
			LOG_WARNING("record %s/%s: missing sentinel"
				" (possible truncation)", domain, key);
		}

		obj = obj_new_from_json(key, json);
		free(json);
		return obj;
	}
}

/* serialize obj to JSON with the trailing record sentinel. on return *bufp
 * points at stackbuf or a heap buffer the caller frees when *bufp != stackbuf. */
static int
serialize_record(OBJ *obj, char *stackbuf, size_t stacksz, char **bufp,
                 size_t *lenp)
{
	char *buf = stackbuf;
	size_t bufsz = stacksz;
	size_t json_len = 0;
	int result = obj_get_json(obj, buf, bufsz - 1, &json_len);

	while (result == OBJ_ERR_NOMEM) {
		bufsz *= 2;
		buf = (buf == stackbuf) ? malloc(bufsz) : realloc(buf, bufsz);
		if (!buf)
			return MUDDB_ERR;
		result = obj_get_json(obj, buf, bufsz - 1, &json_len);
	}
	if (result != OBJ_OK) {
		if (buf != stackbuf)
			free(buf);
		return MUDDB_ERR;
	}
	buf[json_len] = '\n';		/* record sentinel */
	json_len++;
	*bufp = buf;
	*lenp = json_len;
	return MUDDB_OK;
}

/* --- write transactions ---------------------------------------------- */

MUDDB_TXN *
muddb_txn_begin(MUDDB *db)
{
	MUDDB_TXN *t;
	int rc;

	if (!db)
		return NULL;
	t = calloc(1, sizeof(*t));
	if (!t)
		return NULL;

	pthread_mutex_lock(&db->lock);
	rc = mdb_txn_begin(db->env, NULL, 0, &t->txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(write): %s", mdb_strerror(rc));
		pthread_mutex_unlock(&db->lock);
		free(t);
		return NULL;
	}
	t->db = db;
	t->dbi_mark = db->dbi_count;
	return t;
}

int
muddb_txn_put(MUDDB_TXN *t, const char *domain, const char *key, OBJ *obj)
{
	char stackbuf[MUDDB_PUT_BUFSZ];
	char *buf = NULL;
	size_t len = 0;
	MDB_dbi dbi;
	MDB_val mkey, mdata;
	int rc;

	if (!t || t->failed)
		return MUDDB_ERR;
	if (serialize_record(obj, stackbuf, sizeof(stackbuf), &buf, &len)
		!= MUDDB_OK) {
		t->failed = 1;
		return MUDDB_ERR;
	}
	if (muddb_dbi_open(t->db, t->txn, domain, 1, 0, &dbi) != MUDDB_OK) {
		if (buf != stackbuf)
			free(buf);
		t->failed = 1;
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	mdata.mv_data = buf;
	mdata.mv_size = len;

	rc = mdb_put(t->txn, dbi, &mkey, &mdata, 0);
	if (buf != stackbuf)
		free(buf);
	if (rc != 0) {
		LOG_ERROR("mdb_put(%s/%s): %s", domain, key, mdb_strerror(rc));
		t->failed = 1;
		return MUDDB_ERR;
	}
	return MUDDB_OK;
}

int
muddb_txn_del(MUDDB_TXN *t, const char *domain, const char *key)
{
	MDB_dbi dbi;
	MDB_val mkey;
	int rc;

	if (!t || t->failed)
		return MUDDB_ERR;
	if (muddb_dbi_open(t->db, t->txn, domain, 1, 0, &dbi) != MUDDB_OK) {
		t->failed = 1;
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);

	rc = mdb_del(t->txn, dbi, &mkey, NULL);
	if (rc != 0 && rc != MDB_NOTFOUND) {
		LOG_ERROR("mdb_del(%s/%s): %s", domain, key, mdb_strerror(rc));
		t->failed = 1;
		return MUDDB_ERR;
	}
	return MUDDB_OK;
}

int
muddb_txn_index_add(MUDDB_TXN *t, const char *index, const char *key,
                    const char *value)
{
	MDB_dbi dbi;
	MDB_val mkey, mval;
	int rc;

	if (!t || t->failed)
		return MUDDB_ERR;
	if (muddb_dbi_open(t->db, t->txn, index, 1, MDB_DUPSORT, &dbi)
		!= MUDDB_OK) {
		t->failed = 1;
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	mval.mv_data = (void *)value;
	mval.mv_size = strlen(value);

	rc = mdb_put(t->txn, dbi, &mkey, &mval, MDB_NODUPDATA);
	if (rc == MDB_KEYEXIST)
		return MUDDB_OK;		/* pair already present; idempotent */
	if (rc != 0) {
		LOG_ERROR("index add(%s: %s -> %s): %s", index, key, value,
			mdb_strerror(rc));
		t->failed = 1;
		return MUDDB_ERR;
	}
	return MUDDB_OK;
}

int
muddb_txn_index_del(MUDDB_TXN *t, const char *index, const char *key,
                    const char *value)
{
	MDB_dbi dbi;
	MDB_val mkey, mval;
	int rc;

	if (!t || t->failed)
		return MUDDB_ERR;
	if (muddb_dbi_open(t->db, t->txn, index, 1, MDB_DUPSORT, &dbi)
		!= MUDDB_OK) {
		t->failed = 1;
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	mval.mv_data = (void *)value;
	mval.mv_size = strlen(value);

	rc = mdb_del(t->txn, dbi, &mkey, &mval);	/* remove the exact pair */
	if (rc != 0 && rc != MDB_NOTFOUND) {
		LOG_ERROR("index del(%s: %s -> %s): %s", index, key, value,
			mdb_strerror(rc));
		t->failed = 1;
		return MUDDB_ERR;
	}
	return MUDDB_OK;
}

int
muddb_txn_commit(MUDDB_TXN *t)
{
	int rc;

	if (!t)
		return MUDDB_ERR;
	if (t->failed) {
		muddb_txn_abort(t);
		return MUDDB_ERR;
	}
	rc = mdb_txn_commit(t->txn);
	if (rc != 0) {
		/* a failed commit aborts the txn, closing any DBI it created */
		LOG_ERROR("mdb_txn_commit: %s", mdb_strerror(rc));
		dbi_cache_rollback(t->db, t->dbi_mark);
		pthread_mutex_unlock(&t->db->lock);
		free(t);
		return MUDDB_ERR;
	}
	pthread_mutex_unlock(&t->db->lock);
	free(t);
	return MUDDB_OK;
}

void
muddb_txn_abort(MUDDB_TXN *t)
{
	if (!t)
		return;
	mdb_txn_abort(t->txn);
	dbi_cache_rollback(t->db, t->dbi_mark);
	pthread_mutex_unlock(&t->db->lock);
	free(t);
}

/* --- single-object operations (wrappers over a one-op transaction) ---- */

int
muddb_put(MUDDB *db, const char *domain, const char *key, OBJ *obj)
{
	MUDDB_TXN *t = muddb_txn_begin(db);

	if (!t)
		return MUDDB_ERR;
	if (muddb_txn_put(t, domain, key, obj) != MUDDB_OK) {
		muddb_txn_abort(t);
		return MUDDB_ERR;
	}
	return muddb_txn_commit(t);
}

int
muddb_del(MUDDB *db, const char *domain, const char *key)
{
	MUDDB_TXN *t = muddb_txn_begin(db);

	if (!t)
		return MUDDB_ERR;
	if (muddb_txn_del(t, domain, key) != MUDDB_OK) {
		muddb_txn_abort(t);
		return MUDDB_ERR;
	}
	return muddb_txn_commit(t);
}

MUDDB_ITER *
muddb_iter_begin(MUDDB *db, const char *domain)
{
	MUDDB_ITER *it;
	int rc;

	it = calloc(1, sizeof(*it));
	if (!it)
		return NULL;

	it->db = db;

	rc = mdb_txn_begin(db->env, NULL, MDB_RDONLY, &it->txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(iter): %s", mdb_strerror(rc));
		free(it);
		return NULL;
	}

	if (muddb_dbi_open(db, it->txn, domain, 0, 0, &it->dbi) != MUDDB_OK) {
		mdb_txn_abort(it->txn);
		free(it);
		return NULL;
	}

	rc = mdb_cursor_open(it->txn, it->dbi, &it->cursor);
	if (rc != 0) {
		LOG_ERROR("mdb_cursor_open: %s", mdb_strerror(rc));
		mdb_txn_abort(it->txn);
		free(it);
		return NULL;
	}

	return it;
}

const char *
muddb_iter_next(MUDDB_ITER *it)
{
	MDB_val mdata;
	MDB_cursor_op op;
	int rc;

	if (!it)
		return NULL;

	op = it->started ? MDB_NEXT : MDB_FIRST;
	it->started = 1;

	rc = mdb_cursor_get(it->cursor, &it->cur_key, &mdata, op);
	if (rc == MDB_NOTFOUND)
		return NULL;
	if (rc != 0) {
		LOG_ERROR("mdb_cursor_get: %s", mdb_strerror(rc));
		return NULL;
	}

	/* null-terminate the key in place -- LMDB data is in mmap,
	 * so we need to copy it. use a static buffer since iteration
	 * is single-threaded and keys are short. */
	{
		static char keybuf[256];
		size_t len = it->cur_key.mv_size;

		if (len >= sizeof(keybuf))
			len = sizeof(keybuf) - 1;
		memcpy(keybuf, it->cur_key.mv_data, len);
		keybuf[len] = '\0';
		return keybuf;
	}
}

OBJ *
muddb_iter_value(MUDDB_ITER *it)
{
	MDB_val mkey, mdata;
	MDB_cursor_op op;
	char *json;
	char keybuf[256];
	size_t len;
	OBJ *obj;
	int rc;

	if (!it)
		return NULL;

	/* re-fetch the current position */
	op = MDB_GET_CURRENT;
	rc = mdb_cursor_get(it->cursor, &mkey, &mdata, op);
	if (rc != 0)
		return NULL;

	/* null-terminate the key */
	len = mkey.mv_size;
	if (len >= sizeof(keybuf))
		len = sizeof(keybuf) - 1;
	memcpy(keybuf, mkey.mv_data, len);
	keybuf[len] = '\0';

	/* null-terminate the value */
	{
		size_t json_len = mdata.mv_size;

		json = malloc(json_len + 1);
		if (!json)
			return NULL;
		memcpy(json, mdata.mv_data, json_len);
		json[json_len] = '\0';

		/* check and strip record sentinel */
		if (json_len > 0 && json[json_len - 1] == '\n') {
			json_len--;
			json[json_len] = '\0';
		} else {
			LOG_WARNING("record %s: missing sentinel"
				" (possible truncation)", keybuf);
		}

		obj = obj_new_from_json(keybuf, json);
		free(json);
		return obj;
	}
}

void
muddb_iter_end(MUDDB_ITER *it)
{
	if (!it)
		return;

	mdb_cursor_close(it->cursor);
	mdb_txn_abort(it->txn);
	free(it);
}

/* --- indexes (DUPSORT set-associations) ------------------------------ */

/*
 * The read-path queries below (contains, count, iter) open their DBI with
 * create=0 and take no lock. Once an index has been registered, that open is a
 * cache hit, so no mdb_dbi_open runs here. Reading an existing but unregistered
 * index would open its DBI under no lock, which LMDB requires to be serialized
 * against other opens; that is safe only under the current single-threaded
 * model. Register every index at init (muddb_index_register) to keep these
 * reads to cache hits.
 */
int
muddb_index_register(MUDDB *db, const char *index)
{
	MDB_txn *txn;
	MDB_dbi dbi;
	int rc;

	if (!db || !index)
		return MUDDB_ERR;

	pthread_mutex_lock(&db->lock);
	rc = mdb_txn_begin(db->env, NULL, 0, &txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(index register): %s", mdb_strerror(rc));
		pthread_mutex_unlock(&db->lock);
		return MUDDB_ERR;
	}
	if (muddb_dbi_open(db, txn, index, 1, MDB_DUPSORT, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		pthread_mutex_unlock(&db->lock);
		return MUDDB_ERR;
	}
	rc = mdb_txn_commit(txn);
	pthread_mutex_unlock(&db->lock);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_commit(index register): %s", mdb_strerror(rc));
		return MUDDB_ERR;
	}
	return MUDDB_OK;
}

int
muddb_index_add(MUDDB *db, const char *index, const char *key,
                const char *value)
{
	MUDDB_TXN *t = muddb_txn_begin(db);

	if (!t)
		return MUDDB_ERR;
	if (muddb_txn_index_add(t, index, key, value) != MUDDB_OK) {
		muddb_txn_abort(t);
		return MUDDB_ERR;
	}
	return muddb_txn_commit(t);
}

int
muddb_index_del(MUDDB *db, const char *index, const char *key,
                const char *value)
{
	MUDDB_TXN *t = muddb_txn_begin(db);

	if (!t)
		return MUDDB_ERR;
	if (muddb_txn_index_del(t, index, key, value) != MUDDB_OK) {
		muddb_txn_abort(t);
		return MUDDB_ERR;
	}
	return muddb_txn_commit(t);
}

int
muddb_index_contains(MUDDB *db, const char *index, const char *key,
                     const char *value)
{
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_cursor *cur;
	MDB_val mkey, mval;
	int found = 0;

	if (!db || !index || !key || !value)
		return 0;
	if (mdb_txn_begin(db->env, NULL, MDB_RDONLY, &txn) != 0)
		return 0;
	if (muddb_dbi_open(db, txn, index, 0, MDB_DUPSORT, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		return 0;
	}
	if (mdb_cursor_open(txn, dbi, &cur) != 0) {
		mdb_txn_abort(txn);
		return 0;
	}
	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	mval.mv_data = (void *)value;
	mval.mv_size = strlen(value);
	found = (mdb_cursor_get(cur, &mkey, &mval, MDB_GET_BOTH) == 0);
	mdb_cursor_close(cur);
	mdb_txn_abort(txn);
	return found;
}

long
muddb_index_count(MUDDB *db, const char *index, const char *key)
{
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_cursor *cur;
	MDB_val mkey, mval;
	mdb_size_t count = 0;
	long result = 0;

	if (!db || !index || !key)
		return 0;
	if (mdb_txn_begin(db->env, NULL, MDB_RDONLY, &txn) != 0)
		return 0;
	if (muddb_dbi_open(db, txn, index, 0, MDB_DUPSORT, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		return 0;
	}
	if (mdb_cursor_open(txn, dbi, &cur) != 0) {
		mdb_txn_abort(txn);
		return 0;
	}
	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	if (mdb_cursor_get(cur, &mkey, &mval, MDB_SET) == 0
		&& mdb_cursor_count(cur, &count) == 0)
		result = (long)count;
	mdb_cursor_close(cur);
	mdb_txn_abort(txn);
	return result;
}

MUDDB_INDEX_ITER *
muddb_index_iter_begin(MUDDB *db, const char *index, const char *key)
{
	MUDDB_INDEX_ITER *it;
	MDB_dbi dbi;

	if (!db || !index || !key)
		return NULL;
	it = calloc(1, sizeof(*it));
	if (!it)
		return NULL;
	if (mdb_txn_begin(db->env, NULL, MDB_RDONLY, &it->txn) != 0) {
		free(it);
		return NULL;
	}
	/* a missing index is a valid but empty iterator (cursor stays NULL) */
	if (muddb_dbi_open(db, it->txn, index, 0, MDB_DUPSORT, &dbi) != MUDDB_OK)
		return it;
	if (mdb_cursor_open(it->txn, dbi, &it->cursor) != 0) {
		it->cursor = NULL;
		return it;
	}
	it->key = strdup(key);
	if (!it->key) {			/* OOM -> empty iterator */
		mdb_cursor_close(it->cursor);
		it->cursor = NULL;
		return it;
	}
	it->keylen = strlen(key);
	return it;
}

const char *
muddb_index_iter_next(MUDDB_INDEX_ITER *it)
{
	MDB_val mkey, mval;
	MDB_cursor_op op;
	size_t len;

	if (!it || !it->cursor)
		return NULL;

	if (!it->started) {
		mkey.mv_data = it->key;
		mkey.mv_size = it->keylen;
		op = MDB_SET_KEY;	/* position at the key, first value */
		it->started = 1;
	} else {
		op = MDB_NEXT_DUP;	/* next value under the same key */
	}
	if (mdb_cursor_get(it->cursor, &mkey, &mval, op) != 0)
		return NULL;

	len = mval.mv_size;
	if (len >= sizeof(it->valbuf))
		len = sizeof(it->valbuf) - 1;
	memcpy(it->valbuf, mval.mv_data, len);
	it->valbuf[len] = '\0';
	return it->valbuf;
}

void
muddb_index_iter_end(MUDDB_INDEX_ITER *it)
{
	if (!it)
		return;
	if (it->cursor)
		mdb_cursor_close(it->cursor);
	mdb_txn_abort(it->txn);
	free(it->key);
	free(it);
}
