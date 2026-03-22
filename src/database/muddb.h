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

#endif
