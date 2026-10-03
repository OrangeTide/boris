/* unit test for scope name resolution */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_resolve"

#include "resolve.h"
#include "obj.h"
#include "muddb.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

MUDDB *mud_db;

static char tmpdir[] = "/tmp/test_resolve_XXXXXX";

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

/* create an object with a name.short (and optional aliases), then move it into
 * container (NULL = leave in limbo) */
static void
mkobj(const char *id, const char *name_short, const char *aliases,
	const char *container)
{
	OBJ *o = obj_create(id);

	if (!o)
		return;
	if (name_short)
		obj_prop_set(o, "name.short", name_short);
	if (aliases)
		obj_prop_set(o, "aliases", aliases);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
	if (container)
		obj_move(id, container);
}

/* resolve and assert the result and (for OK) the matched id */
static void
expect(const char *label, const char *actor, const char *name, int players,
	enum resolve_result want, const char *want_id)
{
	char out[128] = "";
	enum resolve_result r = resolve_name(actor, name, players, out,
		sizeof out);

	check(label, r == want &&
		(want != RESOLVE_OK || !strcmp(out, want_id)));
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : scope resolution");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}
	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 64) != 0) {
		LOG_ERROR("setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	/* a room, the actor in it, an occupant, room items, and an inventory item */
	mkobj("rooms/cave", "a dark cave", "cave", NULL);
	mkobj("chars/1", "Hero", NULL, "rooms/cave");
	mkobj("chars/2", "Goblin", "gob", "rooms/cave");
	mkobj("items/sword", "rusty sword", "blade", "rooms/cave");
	mkobj("items/torch", "torch", NULL, "chars/1");

	/* special names */
	expect("me -> actor", "chars/1", "me", 0, RESOLVE_OK, "chars/1");
	expect("self -> actor", "chars/1", "self", 0, RESOLVE_OK, "chars/1");
	expect("here -> room", "chars/1", "here", 0, RESOLVE_OK, "rooms/cave");
	expect("here not a player", "chars/1", "here", 1, RESOLVE_NONE, NULL);

	/* inventory */
	expect("inventory item", "chars/1", "torch", 0, RESOLVE_OK, "items/torch");

	/* room contents by name.short, word prefix, and alias */
	expect("room item whole", "chars/1", "rusty sword", 0, RESOLVE_OK,
		"items/sword");
	expect("room item word", "chars/1", "sword", 0, RESOLVE_OK,
		"items/sword");
	expect("room item word prefix", "chars/1", "swo", 0, RESOLVE_OK,
		"items/sword");
	expect("room item alias", "chars/1", "blade", 0, RESOLVE_OK,
		"items/sword");

	/* occupant, and the room object matched by name */
	expect("occupant", "chars/1", "goblin", 0, RESOLVE_OK, "chars/2");
	expect("occupant alias", "chars/1", "gob", 0, RESOLVE_OK, "chars/2");
	expect("actor by own name", "chars/1", "hero", 0, RESOLVE_OK, "chars/1");
	expect("room by name", "chars/1", "cave", 0, RESOLVE_OK, "rooms/cave");

	/* players_only filters out items but keeps characters */
	expect("players_only skips item", "chars/1", "sword", 1, RESOLVE_NONE,
		NULL);
	expect("players_only occupant", "chars/1", "goblin", 1, RESOLVE_OK,
		"chars/2");

	/* nothing matches */
	expect("no match", "chars/1", "dragon", 0, RESOLVE_NONE, NULL);

	/* ambiguity: a second sword in the room (both only prefix-match "sword") */
	mkobj("items/sword2", "shiny sword", NULL, "rooms/cave");
	expect("ambiguous sword", "chars/1", "sword", 0, RESOLVE_AMBIGUOUS, NULL);
	expect("rusty still unique", "chars/1", "rusty", 0, RESOLVE_OK,
		"items/sword");

	/* an object named exactly "sword" wins over the prefix-only matches */
	mkobj("items/plainsword", "sword", NULL, "rooms/cave");
	expect("exact name beats prefix", "chars/1", "sword", 0, RESOLVE_OK,
		"items/plainsword");

	/* an exact alias token wins over a prefix-only name match */
	mkobj("items/crate", "a wooden crate", "box", "rooms/cave");
	mkobj("items/boxcar", "boxcar", NULL, "rooms/cave");
	expect("exact alias beats prefix", "chars/1", "box", 0, RESOLVE_OK,
		"items/crate");

	/* an actor with no location: only inventory and special names work */
	mkobj("chars/3", "Ghost", NULL, NULL);
	expect("limbo here is none", "chars/3", "here", 0, RESOLVE_NONE, NULL);
	expect("limbo me still works", "chars/3", "me", 0, RESOLVE_OK, "chars/3");

	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_resolve");
}
