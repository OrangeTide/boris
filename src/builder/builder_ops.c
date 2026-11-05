/* builder_ops.c : production backend hooks for builder_save */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "builder.h"
#include "builder_snapshot.h"
#include "obj.h"
#include "user.h"

static int
default_key_exists(void *ctx, const char *key)
{
	OBJ *o;

	(void)ctx;
	o = obj_get(key);
	if (o) {
		obj_release(o);
		return 1;
	}
	return 0;
}

static int
default_owner_exists(void *ctx, const char *name)
{
	(void)ctx;
	return user_exists(name);
}

static int
default_commit(void *ctx, const char *key, OBJ *obj)
{
	(void)ctx;
	if (obj_put(key, obj) != OBJ_OK)
		return -1;
	/* obj_put is write-through to muddb, so the record is already durable.
	 * obj is a scratch, not the cached object; drop any stale cached copy
	 * of key so the next obj_get reloads what we just wrote (editing an
	 * already-cached object, e.g. a zone's zoneinfo). */
	obj_forget(key);
	return 0;
}

/* Mirror the committed edit into world history. A no-op until
 * builder_snapshot_init runs at startup, so a test or tool using the default
 * ops without a depot simply records nothing. */
static void
default_snapshot(void *ctx, const char *key, OBJ *obj, const char *actor_name)
{
	(void)ctx;
	builder_snapshot_record(key, obj, actor_name);
}

static const struct builder_ops default_ops = {
	.key_exists = default_key_exists,
	.owner_exists = default_owner_exists,
	.commit = default_commit,
	.snapshot = default_snapshot,
	.ctx = NULL,
};

const struct builder_ops *
builder_default_ops(void)
{
	return &default_ops;
}
