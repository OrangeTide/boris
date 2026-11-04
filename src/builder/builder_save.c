/* builder_save.c : builder write choke point (permission, validation, commit) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "builder.h"

#include <log.h>

#include <stdio.h>
#include <string.h>

/*
 * Instance root for placed game objects (doc/zone-spec.md 3). A key under
 * this prefix is a game instance. The name is meant to come from config
 * (olc.zone.base); dotted config keys do not exist yet, so it is a
 * compile-time constant for now.
 */
#define BUILDER_ZONE_BASE "zone"
#define BUILDER_ZONE_INFO_LEAF "zoneinfo"	/* mirrors zone.h ZONE_INFO_LEAF */

static void
result_reset(struct builder_result *res)
{
	res->status = BUILDER_OK;
	res->message[0] = '\0';
	res->warn_count = 0;
}

/* Collect a soft warning for every exit.<dir>.to whose target is absent.
 * Never blocks the save (doc/olc-spec.md 5.4). */
static void
warn_dangling_exits(const struct builder_ops *ops, OBJ *obj,
	struct builder_result *res)
{
	OBJ_ITER *it = obj_iter_begin(obj);
	const char *key, *val;

	while (obj_iter_next(it, &key, &val)) {
		size_t len = strlen(key);

		if (strncmp(key, "exit.", 5) != 0)
			continue;
		if (len < 4 || strcmp(key + len - 4, ".to~") != 0)
			continue;
		if (!val || !val[0])
			continue;
		if (ops->key_exists(ops->ctx, val))
			continue;
		if (res->warn_count < BUILDER_MAX_WARN) {
			snprintf(res->warns[res->warn_count], BUILDER_WARN_MAX,
				"exit %s -> %s: target does not exist yet",
				key, val);
			res->warn_count++;
		}
	}
	obj_iter_end(it);
}

int
builder_check(const struct builder_ops *ops, OBJ *obj,
	struct builder_result *res)
{
	if (!res)
		return 0;
	result_reset(res);
	if (!ops || !ops->key_exists || !obj)
		return 0;
	warn_dangling_exits(ops, obj, res);
	res->status = BUILDER_OK;
	return res->warn_count;
}

/* Soft-warn when a new object's enclosing zone has no zoneinfo yet, so a
 * builder laying out a fresh zone is nudged to create it (doc/zone-spec.md).
 * Never blocks: a builder may create the zoneinfo before or after. */
static void
warn_missing_zone(const struct builder_ops *ops, const struct builder_req *req,
	struct builder_result *res)
{
	const char *slash;
	char zpath[BUILDER_WARN_MAX - 32];	/* leave room for the message */
	size_t zn;

	if (!req->is_create || !req->zone_key || !req->zone_key[0])
		return;
	if (ops->key_exists(ops->ctx, req->zone_key))
		return;
	if (res->warn_count >= BUILDER_MAX_WARN)
		return;
	/* zone_key is "<zonepath>/zoneinfo"; report the zone path itself. */
	slash = strrchr(req->zone_key, '/');
	zn = slash ? (size_t)(slash - req->zone_key) : strlen(req->zone_key);
	if (zn >= sizeof zpath)
		zn = sizeof zpath - 1;
	memcpy(zpath, req->zone_key, zn);
	zpath[zn] = '\0';
	snprintf(res->warns[res->warn_count], BUILDER_WARN_MAX,
		"zone %s does not exist yet", zpath);
	res->warn_count++;
}

enum builder_status
builder_save(const struct builder_ops *ops, const struct builder_req *req,
	struct builder_result *res)
{
	if (!res)
		return BUILDER_ERR;
	result_reset(res);

	if (!ops || !req || !req->obj || !req->commit_key || !req->actor) {
		snprintf(res->message, sizeof res->message,
			"invalid builder request");
		return res->status = BUILDER_ERR;
	}

	/* 1. permission: the Builder flag, or Wizard which implies Builder
	 * (doc/plan.md Phase 0, builder-role card). Level gating lands with
	 * builder-role. */
	if (!acs_check((struct acs_info *)req->actor, "fB|fW")) {
		snprintf(res->message, sizeof res->message,
			"permission denied: builder flag required");
		return res->status = BUILDER_DENIED;
	}

	/* 1b. edit access: a zone's builders allow-list, if the ops enforce
	 * one (doc/zone-spec.md 2.2). Default ops grant access to any builder. */
	if (ops->may_edit && !ops->may_edit(ops->ctx, req->actor,
		req->actor_name, req->commit_key)) {
		snprintf(res->message, sizeof res->message,
			"permission denied: you may not build in this zone");
		return res->status = BUILDER_NO_ACCESS;
	}

	/* 2. required fields (hard block) */
	if (req->required) {
		for (const char *const *p = req->required; *p; p++) {
			char *v = obj_prop_get(req->obj, *p);

			if (!v || !v[0]) {
				snprintf(res->message, sizeof res->message,
					"missing required field: %s", *p);
				return res->status = BUILDER_REQUIRED;
			}
		}
	}

	/* 3. owner legality (hard block). An empty owner is fine; a set owner
	 * must be a real user (doc/olc-spec.md 5.4). */
	{
		char *owner = obj_prop_get(req->obj, "owner");

		if (owner && owner[0] && !ops->owner_exists(ops->ctx, owner)) {
			snprintf(res->message, sizeof res->message,
				"illegal owner: no such user '%s'", owner);
			return res->status = BUILDER_BAD_OWNER;
		}
	}

	/* 4. duplicate-key guard on create */
	if (req->is_create && !req->overwrite
		&& ops->key_exists(ops->ctx, req->commit_key)) {
		snprintf(res->message, sizeof res->message,
			"key already exists: %s", req->commit_key);
		return res->status = BUILDER_EXISTS;
	}

	/* 5. creator stamping on create; never rewrite an existing creator */
	if (req->is_create && req->actor_name && req->actor_name[0]) {
		char *cur = obj_prop_get(req->obj, "creator");

		if (!cur || !cur[0])
			obj_prop_set(req->obj, "creator", req->actor_name);
	}

	/* 6. soft warnings (do not block) */
	warn_dangling_exits(ops, req->obj, res);
	warn_missing_zone(ops, req, res);

	/* 7. commit. */
	if (ops->commit(ops->ctx, req->commit_key, req->obj) != 0) {
		snprintf(res->message, sizeof res->message,
			"commit failed for %s", req->commit_key);
		return res->status = BUILDER_ERR;
	}

	/* 8. snapshot the accepted edit (doc/snapshot-restore-spec.md section 4).
	 * Best-effort history: the commit above already succeeded, so a snapshot
	 * failure never changes the result. */
	if (ops->snapshot)
		ops->snapshot(ops->ctx, req->commit_key, req->obj,
			req->actor_name);

	return res->status = BUILDER_OK;
}

enum builder_status
room_create(const struct builder_ops *ops, const struct acs_info *actor,
	const char *actor_name, const char *zone_slug, const char *room_id,
	const char *name, const char *short_desc, const char *template_ref,
	char *out_key, size_t out_key_len, struct builder_result *res)
{
	static const char *const room_required[] = { "name", "desc.short", NULL };
	char key[OBJ_PATH_MAX];
	char zone_key[OBJ_PATH_MAX];
	struct builder_req req;
	enum builder_status st;
	OBJ *room;

	if (!res)
		return BUILDER_ERR;
	result_reset(res);

	if (!zone_slug || !zone_slug[0] || !room_id || !room_id[0]) {
		snprintf(res->message, sizeof res->message,
			"zone slug and room id are required");
		return res->status = BUILDER_ERR;
	}
	if (snprintf(key, sizeof key, "%s/%s/%s", BUILDER_ZONE_BASE,
		zone_slug, room_id) >= (int)sizeof key) {
		snprintf(res->message, sizeof res->message,
			"room key too long");
		return res->status = BUILDER_ERR;
	}

	room = obj_new(key);
	if (!room) {
		snprintf(res->message, sizeof res->message, "out of memory");
		return res->status = BUILDER_ERR;
	}

	obj_prop_set_internal(room, "%kind", "room");
	if (template_ref && template_ref[0])
		obj_prop_set_ref_internal(room, "%parent", template_ref);
	if (name && name[0])
		obj_prop_set(room, "name", name);
	if (short_desc && short_desc[0])
		obj_prop_set(room, "desc.short", short_desc);

	snprintf(zone_key, sizeof zone_key, "%s/%s/%s", BUILDER_ZONE_BASE,
		zone_slug, BUILDER_ZONE_INFO_LEAF);

	req = (struct builder_req){
		.actor = actor,
		.actor_name = actor_name,
		.commit_key = key,
		.obj = room,
		.required = room_required,
		.is_create = 1,
		.overwrite = 0,
		.zone_key = zone_key,
	};
	st = builder_save(ops, &req, res);

	if (st == BUILDER_OK && out_key && out_key_len)
		snprintf(out_key, out_key_len, "%s", key);

	obj_free(room);
	return st;
}
