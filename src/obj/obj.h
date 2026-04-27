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

/* returns borrowed pointer -- valid until next mutation or obj_free */
char *obj_prop_get(OBJ *obj, const char *propname);

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

/* global object cache backed by muddb */
int obj_initialize(struct muddb *db, unsigned cache_size);
void obj_shutdown(void);
OBJ *obj_get(const char *id);
void obj_release(OBJ *obj);

#endif
