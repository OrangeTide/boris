/* test_zone_builder.c : zone_create through builder_save */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "test_zone_builder"

#include "zone_builder.h"
#include "zone.h"
#include "obj.h"
#include "muddb.h"
#include "builder.h"
#include "acs.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ctest.h"

#define BUILDER_FLAG (1u << 1)	/* 'B' -> bit 1 */

/* builder ops backed by the live obj store, no user subsystem */
static int
t_key_exists(void *ctx, const char *key)
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
t_owner_exists(void *ctx, const char *name)
{
	(void)ctx;
	(void)name;
	return 1;
}

static int
t_commit(void *ctx, const char *key, OBJ *obj)
{
	(void)ctx;
	if (obj_put(key, obj) != OBJ_OK)
		return -1;
	return 0;
}

static const struct builder_ops T_OPS = {
	.key_exists = t_key_exists,
	.owner_exists = t_owner_exists,
	.commit = t_commit,
	.ctx = NULL,
};

static struct acs_info builder_actor, plain_actor;

static void
test_create(void)
{
	struct builder_result res;
	OBJ *z;
	char *v;

	check("zone_create succeeds",
		zone_create(&T_OPS, &builder_actor, "rhea", "zone/darkwood",
		"Darkwood", "templates/room/base", NULL, &res) == BUILDER_OK);
	check("created zone exists", zone_exists("zone/darkwood"));

	z = zone_get("zone/darkwood");
	if (z) {
		v = obj_prop_get(z, "%kind");
		check("zone_create stamps %kind=zone", v && strcmp(v, "zone") == 0);
		v = obj_prop_get(z, "creator");
		check("zone_create stamps creator", v && strcmp(v, "rhea") == 0);
		v = obj_prop_get(z, "title");
		check("zone_create sets title", v && strcmp(v, "Darkwood") == 0);
		obj_release(z);
	}
}

static void
test_permission_and_dup(void)
{
	struct builder_result res;

	check("non-builder cannot create a zone",
		zone_create(&T_OPS, &plain_actor, "eve", "zone/forge",
		"The Forge", NULL, NULL, &res) == BUILDER_DENIED);
	check("denied zone was not created", !zone_exists("zone/forge"));

	check("duplicate zone_create is blocked",
		zone_create(&T_OPS, &builder_actor, "rhea", "zone/darkwood",
		"Darkwood Again", NULL, NULL, &res) == BUILDER_EXISTS);
}

static void
test_nested_parent(void)
{
	struct builder_result res;
	OBJ *z;
	char *v;

	check("nested zone_create succeeds",
		zone_create(&T_OPS, &builder_actor, "rhea", "zone/darkwood/mansion",
		"The Mansion", NULL, "zone/darkwood", &res) == BUILDER_OK);

	z = zone_get("zone/darkwood/mansion");
	if (z) {
		v = obj_prop_get(z, "%parent");
		check("sub-zone %parent points at the enclosing zoneinfo",
			v && strcmp(v, "zone/darkwood/zoneinfo") == 0);
		obj_release(z);
	}
	/* template inherits from the parent zone */
	v = zone_template("zone/darkwood/mansion");
	check("sub-zone inherits parent template through zone_create",
		v && strcmp(v, "templates/room/base") == 0);
	free(v);
}

int
main(void)
{
	char tmpl[] = "/tmp/zone_builder_test_XXXXXX";
	char *depot = mkdtemp(tmpl);
	struct muddb *db;

	if (!depot) {
		LOG_ERROR("could not create temp dir");
		return 1;
	}
	db = muddb_open(depot, 0);
	if (!db || obj_initialize(db, 64) != 0) {
		LOG_ERROR("could not init muddb backend at %s", depot);
		return 1;
	}
	acs_init(&builder_actor, 1, BUILDER_FLAG);
	acs_init(&plain_actor, 9, 0);

	test_create();
	test_permission_and_dup();
	test_nested_parent();

	obj_shutdown();
	muddb_close(db);
	LOG_INFO("depot %s", depot);
	return ctest_report("test_zone_builder");
}
