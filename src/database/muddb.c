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

#define MUDDB_MAX_DBS    16
#define MUDDB_MAPSIZE    (64 * 1024 * 1024)  /* 64 MB */
#define MUDDB_PUT_BUFSZ  4096

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

/* open or retrieve a cached dbi handle.
 * when create is set, MDB_CREATE is passed so the domain is created if it
 * does not exist -- this requires a write txn. when create is not set, a
 * missing domain returns MUDDB_NOTFOUND instead of an error. */
static int
muddb_dbi_open(MUDDB *db, MDB_txn *txn, const char *domain, int create,
               MDB_dbi *out)
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

	flags = create ? MDB_CREATE : 0;
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

	rc = mdb_env_open(db->env, path, 0, 0664);
	if (rc != 0) {
		LOG_ERROR("mdb_env_open(%s): %s", path, mdb_strerror(rc));
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

	if (muddb_dbi_open(db, txn, domain, 0, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		return NULL;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);

	rc = mdb_get(txn, dbi, &mkey, &mdata);
	if (rc == MDB_NOTFOUND) {
		mdb_txn_abort(txn);
		return NULL;
	}
	if (rc != 0) {
		LOG_ERROR("mdb_get(%s/%s): %s", domain, key, mdb_strerror(rc));
		mdb_txn_abort(txn);
		return NULL;
	}

	/* mdata.mv_data is not null-terminated -- make a copy */
	char *json = malloc(mdata.mv_size + 1);
	if (!json) {
		mdb_txn_abort(txn);
		return NULL;
	}
	memcpy(json, mdata.mv_data, mdata.mv_size);
	json[mdata.mv_size] = '\0';

	mdb_txn_abort(txn);

	obj = obj_new_from_json(key, json);
	free(json);
	return obj;
}

int
muddb_put(MUDDB *db, const char *domain, const char *key, OBJ *obj)
{
	char stackbuf[MUDDB_PUT_BUFSZ];
	char *buf = stackbuf;
	size_t bufsz = sizeof(stackbuf);
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_val mkey, mdata;
	int rc, result;

	/* serialize OBJ to JSON */
	result = obj_get_json(obj, buf, bufsz);
	while (result == OBJ_ERR_NOMEM) {
		bufsz *= 2;
		buf = (buf == stackbuf) ? malloc(bufsz) : realloc(buf, bufsz);
		if (!buf)
			return MUDDB_ERR;
		result = obj_get_json(obj, buf, bufsz);
	}
	if (result != OBJ_OK) {
		if (buf != stackbuf)
			free(buf);
		return MUDDB_ERR;
	}

	pthread_mutex_lock(&db->lock);

	rc = mdb_txn_begin(db->env, NULL, 0, &txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(write): %s", mdb_strerror(rc));
		pthread_mutex_unlock(&db->lock);
		if (buf != stackbuf)
			free(buf);
		return MUDDB_ERR;
	}

	if (muddb_dbi_open(db, txn, domain, 1, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		pthread_mutex_unlock(&db->lock);
		if (buf != stackbuf)
			free(buf);
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);
	mdata.mv_data = buf;
	mdata.mv_size = strlen(buf);

	rc = mdb_put(txn, dbi, &mkey, &mdata, 0);
	if (rc != 0) {
		LOG_ERROR("mdb_put(%s/%s): %s", domain, key, mdb_strerror(rc));
		mdb_txn_abort(txn);
		pthread_mutex_unlock(&db->lock);
		if (buf != stackbuf)
			free(buf);
		return MUDDB_ERR;
	}

	rc = mdb_txn_commit(txn);
	pthread_mutex_unlock(&db->lock);
	if (buf != stackbuf)
		free(buf);

	if (rc != 0) {
		LOG_ERROR("mdb_txn_commit: %s", mdb_strerror(rc));
		return MUDDB_ERR;
	}

	return MUDDB_OK;
}

int
muddb_del(MUDDB *db, const char *domain, const char *key)
{
	MDB_txn *txn;
	MDB_dbi dbi;
	MDB_val mkey;
	int rc;

	pthread_mutex_lock(&db->lock);

	rc = mdb_txn_begin(db->env, NULL, 0, &txn);
	if (rc != 0) {
		LOG_ERROR("mdb_txn_begin(write): %s", mdb_strerror(rc));
		pthread_mutex_unlock(&db->lock);
		return MUDDB_ERR;
	}

	if (muddb_dbi_open(db, txn, domain, 1, &dbi) != MUDDB_OK) {
		mdb_txn_abort(txn);
		pthread_mutex_unlock(&db->lock);
		return MUDDB_ERR;
	}

	mkey.mv_data = (void *)key;
	mkey.mv_size = strlen(key);

	rc = mdb_del(txn, dbi, &mkey, NULL);
	if (rc != 0 && rc != MDB_NOTFOUND) {
		LOG_ERROR("mdb_del(%s/%s): %s", domain, key, mdb_strerror(rc));
		mdb_txn_abort(txn);
		pthread_mutex_unlock(&db->lock);
		return MUDDB_ERR;
	}

	rc = mdb_txn_commit(txn);
	pthread_mutex_unlock(&db->lock);

	if (rc != 0) {
		LOG_ERROR("mdb_txn_commit: %s", mdb_strerror(rc));
		return MUDDB_ERR;
	}

	return MUDDB_OK;
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

	if (muddb_dbi_open(db, it->txn, domain, 0, &it->dbi) != MUDDB_OK) {
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
	json = malloc(mdata.mv_size + 1);
	if (!json)
		return NULL;
	memcpy(json, mdata.mv_data, mdata.mv_size);
	json[mdata.mv_size] = '\0';

	obj = obj_new_from_json(keybuf, json);
	free(json);
	return obj;
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
