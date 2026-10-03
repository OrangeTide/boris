/* unit test for the character adapter over the obj cache */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_character"

#include "character.h"
#include "obj.h"
#include "muddb.h"
#include "boris.h"              /* struct attr_list/attr_entry, LIST_* */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

/* the global handle character.c reaches for freelist seeding */
MUDDB *mud_db;

/*
 * Minimal stand-ins for the two common.c helpers character.c links against.
 * The real versions live in the server core, which this unit test does not
 * pull in. The extras view rebuilds a fresh list each call, so append-only
 * with no duplicate handling is enough.
 */
int
attr_add(struct attr_list *al, const char *name, const char *value)
{
	struct attr_entry *e = calloc(1, sizeof *e);

	if (!e)
		return 0;
	e->name = strdup(name);
	e->value = strdup(value);
	LIST_INSERT_HEAD(al, e, list);
	return 1;
}

void
attr_list_free(struct attr_list *al)
{
	struct attr_entry *e;

	while ((e = LIST_TOP(*al))) {
		LIST_REMOVE(e, list);
		free(e->name);
		free(e->value);
		free(e);
	}
}

static char tmpdir[] = "/tmp/test_character_XXXXXX";

static int
rm_cb(const char *fpath, const struct stat *sb, int typeflag,
	struct FTW *ftwbuf)
{
	(void)sb;
	(void)typeflag;
	(void)ftwbuf;
	return remove(fpath);
}

static void
cleanup_tmpdir(void)
{
	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
}

/* make a room object so characters have somewhere to stand */
static void
mkroom(const char *id)
{
	OBJ *r = obj_create(id);

	if (r)
		obj_release(r);
}

/* does the room's contents index list this member object? */
static int
room_has(const char *room, const char *member)
{
	OBJ_CONTENTS_ITER *it = obj_contents_begin(room);
	const char *v;
	int found = 0;

	if (!it)
		return 0;
	while ((v = obj_contents_next(it)) != NULL) {
		if (strcmp(v, member) == 0) {
			found = 1;
			break;
		}
	}
	obj_contents_end(it);
	return found;
}

static void
test_create_and_attrs(void)
{
	struct character *ch = character_new();
	const char *v;

	check("character_new", ch != NULL);
	if (!ch)
		return;

	check("obj id is chars/1", !strcmp(character_obj_id(ch), "chars/1"));
	check("backing obj present", character_obj(ch) != NULL);

	v = character_attr_get(ch, "id");
	check("id prop is 1", v && !strcmp(v, "1"));
	v = obj_prop_get(character_obj(ch), "%parent");
	check("prototype seeded", v && !strcmp(v, "templates/pc"));

	check("set name.short", character_attr_set(ch, "name.short", "Bob"));
	v = character_attr_get(ch, "name.short");
	check("get name.short", v && !strcmp(v, "Bob"));

	check("new character is nowhere",
		character_attr_get(ch, "room.current") == NULL);

	character_put(ch);
}

static void
test_room_bridge(void)
{
	struct character *ch = character_new();         /* chars/2 */
	const char *v;

	check("character_new (2)", ch != NULL);
	if (!ch)
		return;

	check("enter start", character_attr_set(ch, "room.current", "start"));
	v = character_attr_get(ch, "room.current");
	check("room.current is bare 'start'", v && !strcmp(v, "start"));
	v = obj_prop_get(character_obj(ch), "%location");
	check("%location is rooms/start", v && !strcmp(v, "rooms/start"));
	check("start count 1", obj_contents_count("rooms/start") == 1);
	check("start lists chars/2", room_has("rooms/start", "chars/2"));

	check("move to hall", character_attr_set(ch, "room.current", "hall"));
	v = character_attr_get(ch, "room.current");
	check("room.current now 'hall'", v && !strcmp(v, "hall"));
	check("start count 0", obj_contents_count("rooms/start") == 0);
	check("hall count 1", obj_contents_count("rooms/hall") == 1);
	check("hall lists chars/2", room_has("rooms/hall", "chars/2"));

	check("to limbo", character_attr_set(ch, "room.current", NULL));
	check("nowhere again", character_attr_get(ch, "room.current") == NULL);
	check("hall count 0", obj_contents_count("rooms/hall") == 0);

	character_put(ch);
}

static void
test_extras(void)
{
	struct character *ch = character_new();         /* chars/3 */
	struct attr_list *extras;
	struct attr_entry *e;
	int saw_tag = 0, saw_builtin = 0;

	check("character_new (3)", ch != NULL);
	if (!ch)
		return;

	character_attr_set(ch, "name.short", "Zed");    /* builtin */
	character_attr_set(ch, "rpg.tag.foo", "bar");   /* extra */

	extras = character_attrs_extras(ch);
	check("extras non-null", extras != NULL);
	for (e = LIST_TOP(*extras); e; e = LIST_NEXT(e, list)) {
		if (!strcmp(e->name, "rpg.tag.foo"))
			saw_tag = 1;
		if (!strcmp(e->name, "name.short"))
			saw_builtin = 1;
	}
	check("extras include custom attr", saw_tag);
	check("extras exclude builtin attr", !saw_builtin);

	character_put(ch);
}

static void
test_reload(void)
{
	struct character *ch = character_new();         /* chars/4 */
	const char *v;

	check("character_new (4)", ch != NULL);
	if (!ch)
		return;
	character_attr_set(ch, "name.short", "Ann");
	character_attr_set(ch, "room.current", "hall");
	character_put(ch);                              /* saves and releases */

	ch = character_get(4);
	check("reload chars/4", ch != NULL);
	if (!ch)
		return;
	v = character_attr_get(ch, "name.short");
	check("name persisted", v && !strcmp(v, "Ann"));
	v = character_attr_get(ch, "room.current");
	check("location persisted", v && !strcmp(v, "hall"));
	character_put(ch);

	check("missing character is NULL", character_get(9999) == NULL);
}

static void
test_seeded_owners(void)
{
	OBJ *o;
	const char *v;

	/* character_initialize seeds the reserved owner identities so @chown
	 * can assign them without a real player existing. */
	o = obj_get("chars/system");
	check("chars/system seeded", o != NULL);
	if (o) {
		v = obj_prop_get(o, "name.short");
		check("chars/system name", v && !strcmp(v, "system"));
		obj_release(o);
	}

	o = obj_get("chars/nobody");
	check("chars/nobody seeded", o != NULL);
	if (o) {
		v = obj_prop_get(o, "name.short");
		check("chars/nobody name", v && !strcmp(v, "nobody"));
		obj_release(o);
	}
}

static void
test_freelist_reseed(void)
{
	struct character *ch;

	/* a fresh init must reserve the existing ids from the persisted records */
	character_shutdown();
	check("reinitialize", character_initialize() == 0);

	ch = character_new();
	check("next id not reused (chars/5)",
		ch && !strcmp(character_obj_id(ch), "chars/5"));
	if (ch)
		character_put(ch);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : character adapter");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}

	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 32) != 0) {
		LOG_ERROR("setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}
	mkroom("rooms/start");
	mkroom("rooms/hall");
	if (character_initialize() != 0) {
		LOG_ERROR("character_initialize failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	test_create_and_attrs();
	test_room_bridge();
	test_extras();
	test_reload();
	test_seeded_owners();
	test_freelist_reseed();

	character_shutdown();
	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_character");
}
