/* test_builder_save.c : unit tests for the builder write choke point */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "test_builder"

#include "builder.h"
#include "obj.h"
#include "acs.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include "ctest.h"

#define BUILDER_FLAG (1u << 1)	/* 'B' -> bit 1 (acs_testflag lowercases) */

/* --- mock backend ---------------------------------------------------- */

struct mock {
	const char *keys[16];
	int nkeys;
	const char *users[16];
	int nusers;
	int deny_edit;		/* when set, may_edit refuses */
	int commit_count;
	char last_key[OBJ_PATH_MAX];
	char last_creator[64];
	char last_kind[32];
};

static int
mock_key_exists(void *ctx, const char *key)
{
	struct mock *m = ctx;
	for (int i = 0; i < m->nkeys; i++)
		if (strcmp(m->keys[i], key) == 0)
			return 1;
	return 0;
}

static int
mock_owner_exists(void *ctx, const char *name)
{
	struct mock *m = ctx;
	for (int i = 0; i < m->nusers; i++)
		if (strcmp(m->users[i], name) == 0)
			return 1;
	return 0;
}

static int
mock_commit(void *ctx, const char *key, OBJ *obj)
{
	struct mock *m = ctx;
	char *c = obj_prop_get(obj, "creator");
	char *k = obj_prop_get(obj, "%kind");

	m->commit_count++;
	snprintf(m->last_key, sizeof m->last_key, "%s", key);
	snprintf(m->last_creator, sizeof m->last_creator, "%s", c ? c : "");
	snprintf(m->last_kind, sizeof m->last_kind, "%s", k ? k : "");
	return 0;
}

static int
mock_may_edit(void *ctx, const struct acs_info *actor, const char *name,
	const char *key)
{
	struct mock *m = ctx;
	(void)actor;
	(void)name;
	(void)key;
	return !m->deny_edit;
}

static struct builder_ops
mock_ops(struct mock *m)
{
	struct builder_ops ops = {
		.key_exists = mock_key_exists,
		.owner_exists = mock_owner_exists,
		.commit = mock_commit,
		.ctx = m,
	};
	return ops;
}

/* A room OBJ with the two required fields set. Caller frees. */
static OBJ *
new_room(const char *key)
{
	OBJ *o = obj_new(key);
	obj_prop_set(o, "name", "The Broom Closet");
	obj_prop_set(o, "desc.short", "A cramped broom closet.");
	return o;
}

static const char *const room_req[] = { "name", "desc.short", NULL };

/* --- tests ----------------------------------------------------------- */

static void
test_permission(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info nonbuilder, builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&nonbuilder, 9, 0);		/* high level, no B flag */
	acs_init(&builder, 1, BUILDER_FLAG);	/* low level, B flag */

	req.actor = &nonbuilder;
	check("non-builder is denied",
		builder_save(&ops, &req, &res) == BUILDER_DENIED);
	check("denied save does not commit", m.commit_count == 0);

	req.actor = &builder;
	req.actor_name = "rhea";
	check("builder is allowed",
		builder_save(&ops, &req, &res) == BUILDER_OK);
	check("allowed save commits", m.commit_count == 1);

	obj_free(room);
}

static void
test_required(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = obj_new("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&builder, 1, BUILDER_FLAG);
	obj_prop_set(room, "name", "Closet");	/* desc.short missing */

	check("missing required field blocks",
		builder_save(&ops, &req, &res) == BUILDER_REQUIRED);
	check("blocked-required does not commit", m.commit_count == 0);
	check("required message names the field",
		strstr(res.message, "desc.short") != NULL);

	obj_free(room);
}

static void
test_owner(void)
{
	struct mock m = { .users = { "rhea" }, .nusers = 1 };
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&builder, 1, BUILDER_FLAG);

	obj_prop_set(room, "owner", "ghost");	/* not a real user */
	check("illegal owner blocks",
		builder_save(&ops, &req, &res) == BUILDER_BAD_OWNER);
	check("bad-owner does not commit", m.commit_count == 0);

	obj_prop_set(room, "owner", "rhea");	/* real user */
	check("legal owner passes",
		builder_save(&ops, &req, &res) == BUILDER_OK);

	obj_free(room);
}

static void
test_duplicate(void)
{
	struct mock m = { .keys = { "zone/darkwood/closet" }, .nkeys = 1 };
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&builder, 1, BUILDER_FLAG);

	check("create over existing key blocks",
		builder_save(&ops, &req, &res) == BUILDER_EXISTS);
	check("duplicate does not commit", m.commit_count == 0);

	req.overwrite = 1;
	check("overwrite allows the save",
		builder_save(&ops, &req, &res) == BUILDER_OK);

	obj_free(room);
}

static void
test_creator_stamp(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};
	char *creator;

	acs_init(&builder, 1, BUILDER_FLAG);

	check("create stamps creator",
		builder_save(&ops, &req, &res) == BUILDER_OK);
	creator = obj_prop_get(room, "creator");
	check("creator prop set to actor",
		creator && strcmp(creator, "rhea") == 0);
	check("committed obj carries creator",
		strcmp(m.last_creator, "rhea") == 0);

	/* an existing creator is never rewritten */
	obj_prop_set(room, "creator", "original");
	req.actor_name = "rhea";
	check("re-save keeps original creator",
		builder_save(&ops, &req, &res) == BUILDER_OK);
	creator = obj_prop_get(room, "creator");
	check("creator not overwritten",
		creator && strcmp(creator, "original") == 0);

	obj_free(room);
}

static void
test_edit_access(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&builder, 1, BUILDER_FLAG);
	ops.may_edit = mock_may_edit;

	m.deny_edit = 1;
	check("may_edit denial blocks the save",
		builder_save(&ops, &req, &res) == BUILDER_NO_ACCESS);
	check("no-access does not commit", m.commit_count == 0);

	m.deny_edit = 0;
	check("may_edit grant allows the save",
		builder_save(&ops, &req, &res) == BUILDER_OK);
	check("granted edit commits", m.commit_count == 1);

	obj_free(room);
}

static void
test_dangling_exit(void)
{
	struct mock m = { .keys = { "zone/darkwood/mud-room" }, .nkeys = 1 };
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	OBJ *room = new_room("zone/darkwood/closet");
	struct builder_req req = {
		.actor = &builder,
		.actor_name = "rhea",
		.commit_key = "zone/darkwood/closet",
		.obj = room,
		.required = room_req,
		.is_create = 1,
	};

	acs_init(&builder, 1, BUILDER_FLAG);

	obj_prop_set_ref(room, "exit.out.to", "zone/darkwood/mud-room");	/* exists */
	obj_prop_set_ref(room, "exit.n.to", "zone/darkwood/void");		/* missing */

	check("dangling exit still saves",
		builder_save(&ops, &req, &res) == BUILDER_OK);
	check("dangling exit committed", m.commit_count == 1);
	check("one soft warning for the missing target", res.warn_count == 1);
	check("warning names the dangling exit",
		strstr(res.warns[0], "void") != NULL);

	obj_free(room);
}

/* builder_check re-runs the soft-warning validation read-only: no
 * permission, no owner, no commit; just the dangling-exit warnings. */
static void
test_check(void)
{
	struct mock m = { .keys = { "zone/darkwood/mud-room" }, .nkeys = 1 };
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	OBJ *room = new_room("zone/darkwood/closet");

	obj_prop_set_ref(room, "exit.out.to", "zone/darkwood/mud-room");	/* exists */
	obj_prop_set_ref(room, "exit.n.to", "zone/darkwood/void");		/* missing */

	check("builder_check reports the dangling exit",
		builder_check(&ops, room, &res) == 1);
	check("builder_check names the missing target",
		res.warn_count == 1 && strstr(res.warns[0], "void") != NULL);
	check("builder_check never commits", m.commit_count == 0);

	/* a clean room yields no warnings */
	obj_prop_delete_ref(room, "exit.n.to");
	check("builder_check clean room has no warnings",
		builder_check(&ops, room, &res) == 0);

	obj_free(room);
}

static void
test_room_create(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	char key[OBJ_PATH_MAX];
	enum builder_status st;

	acs_init(&builder, 1, BUILDER_FLAG);

	st = room_create(&ops, &builder, "rhea", "darkwood", "closet",
		"The Broom Closet", "A cramped broom closet.", NULL,
		key, sizeof key, &res);
	check("room_create succeeds", st == BUILDER_OK);
	check("room_create builds the zone key",
		strcmp(key, "zone/darkwood/closet") == 0);
	check("room_create commits that key",
		strcmp(m.last_key, "zone/darkwood/closet") == 0);
	check("room_create stamps %kind=room",
		strcmp(m.last_kind, "room") == 0);
	check("room_create stamps creator",
		strcmp(m.last_creator, "rhea") == 0);

	/* a missing required field is rejected before commit */
	st = room_create(&ops, &builder, "rhea", "darkwood", "empty",
		NULL, "only a short desc", NULL, key, sizeof key, &res);
	check("room_create without a name is rejected",
		st == BUILDER_REQUIRED);
	check("rejected room_create did not commit twice",
		m.commit_count == 1);
}

/* room_create soft-warns when the target zone has no zoneinfo yet, but still
 * commits: a builder may lay out rooms before creating the zone record. */
static void
test_missing_zone(void)
{
	struct mock m = {0};
	struct builder_ops ops = mock_ops(&m);
	struct builder_result res;
	struct acs_info builder;
	char key[OBJ_PATH_MAX];
	enum builder_status st;

	acs_init(&builder, 1, BUILDER_FLAG);

	st = room_create(&ops, &builder, "rhea", "newzone", "hall",
		"The Hall", "A long hall.", NULL, key, sizeof key, &res);
	check("missing-zone room still saves", st == BUILDER_OK);
	check("missing-zone room committed", m.commit_count == 1);
	check("missing zone yields one soft warning", res.warn_count == 1);
	check("warning names the missing zone",
		strstr(res.warns[0], "zone/newzone") != NULL);

	/* with the zoneinfo present, no zone warning */
	m.keys[m.nkeys++] = "zone/newzone/zoneinfo";
	st = room_create(&ops, &builder, "rhea", "newzone", "study",
		"The Study", "A quiet study.", NULL, key, sizeof key, &res);
	check("present-zone room saves", st == BUILDER_OK);
	check("present zone yields no zone warning", res.warn_count == 0);
}

int
main(void)
{
	test_permission();
	test_required();
	test_owner();
	test_duplicate();
	test_edit_access();
	test_creator_stamp();
	test_dangling_exit();
	test_check();
	test_room_create();
	test_missing_zone();

	return ctest_report("test_builder");
}
