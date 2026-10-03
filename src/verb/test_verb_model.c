/* test_verb_model.c : command-verb resolution across the object scope */

#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_verb_model"

#include "verb_model.h"
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

static char tmpdir[] = "/tmp/test_verb_model_XXXXXX";

static int
rm_cb(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf)
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

/* Create an object with an optional %parent prototype, then move it into
 * container (NULL = leave in limbo). */
static void
mkobj(const char *id, const char *parent, const char *container)
{
	OBJ *o = obj_create(id);

	if (!o)
		return;
	if (parent)
		obj_prop_set_internal(o, "%parent", parent);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
	if (container)
		obj_move(id, container);
}

/* Set verb.<word> = packed on an existing object. */
static void
setverb(const char *id, const char *word, const char *packed)
{
	OBJ *o = obj_get(id);
	char prop[80];

	if (!o)
		return;
	snprintf(prop, sizeof prop, "verb.%s", word);
	obj_prop_set(o, prop, packed);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
}

/* Resolve and assert the result and (on a hit) the holder/prog/spec. */
static void
expect(const char *label, const char *actor, const char *word, int want,
       const char *holder, const char *prog, const char *spec)
{
	struct verb_def d;
	int r = verb_resolve(actor, word, &d);

	if (want != 1) {
		check(label, r == want);
		return;
	}
	check(label, r == 1 && !strcmp(d.holder, holder) &&
	      !strcmp(d.prog, prog) && !strcmp(d.spec, spec));
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : verb resolution");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}
	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 64) != 0) {
		LOG_ERROR("store setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	/* A prototype carrying an inherited verb, a room, the actor in it (a child
	 * of the prototype), a held item, and a loose item in the room. */
	mkobj("templates/pc", NULL, NULL);
	mkobj("rooms/cave", NULL, NULL);
	mkobj("chars/1", "templates/pc", "rooms/cave");
	mkobj("items/sword", NULL, "chars/1");
	mkobj("items/rock", NULL, "rooms/cave");

	setverb("templates/pc", "emote", "programs/emote\t<any>");
	setverb("chars/1", "score", "programs/score");      /* no tab: empty spec */
	setverb("rooms/cave", "look", "programs/look\t<any>");
	setverb("items/sword", "wield", "programs/wield\t<obj>");
	setverb("items/rock", "get", "programs/get\t<obj>");

	/* tier 1: the actor's own verb */
	expect("actor verb", "chars/1", "score", 1, "chars/1", "programs/score", "");
	/* tier 1 via prototype walk */
	expect("actor prototype verb", "chars/1", "emote", 1, "chars/1",
	       "programs/emote", "<any>");
	/* tier 2: the location */
	expect("location verb", "chars/1", "look", 1, "rooms/cave",
	       "programs/look", "<any>");
	/* tier 3: a held item */
	expect("held-item verb", "chars/1", "wield", 1, "items/sword",
	       "programs/wield", "<obj>");
	/* tier 4: a loose item in the room */
	expect("room-item verb", "chars/1", "get", 1, "items/rock",
	       "programs/get", "<obj>");

	/* no object in scope defines it */
	expect("no match", "chars/1", "frobnicate", 0, NULL, NULL, NULL);

	/* bad arguments */
	expect("null actor", NULL, "look", -1, NULL, NULL, NULL);
	expect("empty word", "chars/1", "", -1, NULL, NULL, NULL);

	/* precedence: the actor wins over the location for the same word */
	setverb("chars/1", "look", "programs/mylook\t<any>");
	expect("actor beats location", "chars/1", "look", 1, "chars/1",
	       "programs/mylook", "<any>");

	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_verb_model");
}
