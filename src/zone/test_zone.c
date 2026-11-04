/* test_zone.c : core zone model round-trip and resolution tests */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "test_zone"

#include "zone.h"
#include "obj.h"
#include "muddb.h"

#include <log.h>

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ctest.h"

/* Write a zoneinfo fixture straight to the store, no builder layer. */
static void
put_zoneinfo(const char *zone_path, const char *title, const char *tmpl,
	const char *parent_path, const char *builders)
{
	char key[OBJ_PATH_MAX];
	OBJ *z;

	if (zone_info_key(zone_path, key, sizeof key) != 0)
		return;
	z = obj_new(key);
	obj_prop_set_internal(z, "%kind", "zone");
	if (parent_path) {
		char pk[OBJ_PATH_MAX];
		if (zone_info_key(parent_path, pk, sizeof pk) == 0)
			obj_prop_set_ref_internal(z, "%parent", pk);
	}
	if (title)
		obj_prop_set(z, "title", title);
	if (tmpl)
		obj_prop_set_ref(z, "template", tmpl);
	if (builders)
		obj_prop_set(z, "builders", builders);
	obj_prop_set(z, "creator", "rhea");
	obj_put(key, z);
	obj_free(z);
}

/* --- tests ----------------------------------------------------------- */

static void
test_key_and_bounds(void)
{
	char buf[OBJ_PATH_MAX];

	check("zone_info_key builds the zoneinfo key",
		zone_info_key("zone/darkwood", buf, sizeof buf) == 0
		&& strcmp(buf, "zone/darkwood/zoneinfo") == 0);
	check("zone_info_key rejects a non-zone path",
		zone_info_key("users/rhea", buf, sizeof buf) == -1);
}

static void
test_roundtrip(void)
{
	OBJ *z;
	char *v;

	put_zoneinfo("zone/darkwood", "Darkwood", "templates/room/base", NULL, NULL);
	check("zone exists after write", zone_exists("zone/darkwood"));

	z = zone_get("zone/darkwood");
	check("zone_get returns the zoneinfo", z != NULL);
	if (z) {
		v = obj_prop_get(z, "title");
		check("title round-trips", v && strcmp(v, "Darkwood") == 0);
		v = obj_prop_get(z, "%kind");
		check("%kind is zone", v && strcmp(v, "zone") == 0);
		obj_release(z);
	}
}

static void
test_resolve(void)
{
	char buf[OBJ_PATH_MAX];

	check("instance resolves to its zone",
		zone_resolve("zone/darkwood/closet", buf, sizeof buf) == 0
		&& strcmp(buf, "zone/darkwood") == 0);
	check("plain sub-directory is transparent",
		zone_resolve("zone/darkwood/dungeon/room1", buf, sizeof buf) == 0
		&& strcmp(buf, "zone/darkwood") == 0);
	check("non-instance key does not resolve",
		zone_resolve("users/rhea", buf, sizeof buf) == -1);
}

static void
test_nested(void)
{
	char buf[OBJ_PATH_MAX];
	char *v;

	put_zoneinfo("zone/darkwood/mansion", "The Mansion", NULL,
		"zone/darkwood", NULL);
	check("deeper zoneinfo re-roots its subtree",
		zone_resolve("zone/darkwood/mansion/hall", buf, sizeof buf) == 0
		&& strcmp(buf, "zone/darkwood/mansion") == 0);
	check("sibling of the sub-zone still belongs to the parent",
		zone_resolve("zone/darkwood/courtyard", buf, sizeof buf) == 0
		&& strcmp(buf, "zone/darkwood") == 0);

	v = zone_template("zone/darkwood/mansion");
	check("sub-zone inherits parent template",
		v && strcmp(v, "templates/room/base") == 0);
	free(v);
	v = zone_template("zone/darkwood");
	check("root zone reports its own template",
		v && strcmp(v, "templates/room/base") == 0);
	free(v);
}

static void
test_edit_access(void)
{
	check("open by default without a builders list",
		zone_may_edit("zone/darkwood/mansion", "eve"));

	put_zoneinfo("zone/harbor", "The Harbor", NULL, NULL, "rhea bob");
	check("listed builder may edit", zone_may_edit("zone/harbor", "rhea"));
	check("unlisted builder may not edit",
		!zone_may_edit("zone/harbor", "eve"));
	check("substring of a name is not a match",
		!zone_may_edit("zone/harbor", "bo"));
}

int
main(void)
{
	char tmpl[] = "/tmp/zone_test_XXXXXX";
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

	test_key_and_bounds();
	test_roundtrip();
	test_resolve();
	test_nested();
	test_edit_access();

	obj_shutdown();
	muddb_close(db);
	LOG_INFO("depot %s", depot);
	return ctest_report("test_zone");
}
