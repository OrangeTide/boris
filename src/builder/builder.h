/* builder.h : the single choke point for builder writes */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef BUILDER_H_
#define BUILDER_H_

#include <stddef.h>

#include "acs.h"
#include "obj.h"

#define BUILDER_MAX_WARN 16
#define BUILDER_MSG_MAX  200
#define BUILDER_WARN_MAX 160

enum builder_status {
	BUILDER_OK = 0,     /* saved (possibly with soft warnings) */
	BUILDER_DENIED,     /* actor lacks the Builder flag */
	BUILDER_NO_ACCESS,  /* actor not permitted to edit in this zone */
	BUILDER_REQUIRED,   /* a required field is missing or empty */
	BUILDER_BAD_OWNER,  /* owner set to a user that does not exist */
	BUILDER_EXISTS,     /* create would clobber an existing key */
	BUILDER_ERR,        /* bad request, or commit failed */
};

/*
 * Backend hooks. builder_save is pure policy; these three calls are the
 * only places it touches the world. Production wiring is in builder_ops.c
 * (obj store + user_exists); tests supply a mock so validation and
 * creator-stamping run with no live backend. Get the production set from
 * builder_default_ops().
 */
struct builder_ops {
	/* nonzero if key already exists in the store */
	int (*key_exists)(void *ctx, const char *key);
	/* nonzero if name is a real user (owner legality) */
	int (*owner_exists)(void *ctx, const char *name);
	/* persist obj under key; 0 on success */
	int (*commit)(void *ctx, const char *key, OBJ *obj);
	/* nonzero if actor may edit key (e.g. a zone's builders allow-list).
	 * NULL means edit access is always granted. Wizard bypass is the
	 * hook's concern. */
	int (*may_edit)(void *ctx, const struct acs_info *actor,
		const char *actor_name, const char *key);
	/* record a snapshot of the just-committed edit (doc/snapshot-restore-spec.md
	 * section 4). Called after a successful commit, best-effort: a failure
	 * here never fails the save. NULL means no history is recorded. */
	void (*snapshot)(void *ctx, const char *key, OBJ *obj,
		const char *actor_name);
	void *ctx;
};

struct builder_req {
	const struct acs_info *actor;   /* permission source (required) */
	const char *actor_name;         /* creator stamp on new objects */
	const char *commit_key;         /* store key to write (required) */
	OBJ *obj;                       /* object to validate and save (required) */
	const char *const *required;    /* NULL-terminated required props, or NULL */
	int is_create;                  /* stamp creator and guard duplicates */
	int overwrite;                  /* permit create over an existing key */
	const char *zone_key;           /* enclosing zone's zoneinfo key; if set
	                                 * and absent on create, a soft warning is
	                                 * added (does not block). NULL to skip. */
};

struct builder_result {
	enum builder_status status;
	char message[BUILDER_MSG_MAX];                  /* reason for a hard block */
	char warns[BUILDER_MAX_WARN][BUILDER_WARN_MAX]; /* soft warnings */
	int warn_count;
};

/*
 * The single choke point for builder writes. In order: Builder-flag check,
 * required-field and owner hard blocks, duplicate-key guard on create,
 * creator stamping on create, dangling-exit soft warnings, then commit.
 * A hard block sets res->status and leaves the store untouched; soft
 * warnings collect in res->warns and never block the save. ops is required
 * (see builder_default_ops). Returns res->status.
 */
enum builder_status builder_save(const struct builder_ops *ops,
	const struct builder_req *req, struct builder_result *res);

/*
 * Re-run the read-only soft-warning checks (dangling exits) on obj without
 * committing or requiring permission. Fills res->warns / res->warn_count and
 * returns the warning count. This is the "did I finish" re-check behind the
 * @check command (doc/olc-spec.md 5.4); ops supplies key_exists.
 */
int builder_check(const struct builder_ops *ops, OBJ *obj,
	struct builder_result *res);

/*
 * Build a new room OBJ at "zone/<zone_slug>/<room_id>" (%kind=room),
 * seed name / desc.short / optional %parent template, and save it through
 * builder_save with the room's required fields enforced. On BUILDER_OK the
 * room is committed and *out_key (if non-NULL) receives the key. ops is
 * required. The temporary OBJ is freed before returning; builder_save
 * commits a serialized copy.
 */
enum builder_status room_create(const struct builder_ops *ops,
	const struct acs_info *actor, const char *actor_name,
	const char *zone_slug, const char *room_id,
	const char *name, const char *short_desc, const char *template_ref,
	char *out_key, size_t out_key_len, struct builder_result *res);

/* Production hooks: obj store existence/commit plus user_exists. */
const struct builder_ops *builder_default_ops(void);

#endif
