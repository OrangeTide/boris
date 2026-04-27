/* unit test for tag.c and position.c */
#define LOG_SUBSYSTEM "test_tag"
#include "log.h"

#include "list.h"
#include "boris.h"

#include "position.c"
#include "tag.c"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

static int pass_count;
static int fail_count;

static inline void
check(const char *description, bool e)
{
	if (e) {
		LOG_INFO("%s: PASSED", description);
		pass_count++;
	} else {
		LOG_ERROR("%s: FAILED", description);
		fail_count++;
	}
}

/* ------------------------------------------------------------------
 * Stubs for symbols tag.c references outside this unit.
 * The test treats the character pointer as an attr_list handle.
 * ------------------------------------------------------------------ */

struct attr_list *
character_attrs_extras(struct character *ch)
{
	return (struct attr_list *)ch;
}

/* tag.c only uses rpg_action_name via rpg_tag_affects. */
const char *
rpg_action_name(enum rpg_action a)
{
	static const char *names[] = {
		"fight", "move", "endure", "brawn",
		"shoot", "prowl", "nimble", "tinker",
		"hunt", "study", "survey", "attune",
		"command", "consort", "judge", "sway",
	};
	if ((int)a < 0 || (int)a >= (int)(sizeof names / sizeof names[0]))
		return "?";
	return names[a];
}

/* ------------------------------------------------------------------
 * attr_list helpers -- build synthetic lists without pulling common.c.
 * ------------------------------------------------------------------ */

static void
al_push(struct attr_list *al, const char *name, const char *value)
{
	struct attr_entry *e = calloc(1, sizeof *e);
	e->name = strdup(name);
	e->value = strdup(value);
	LIST_ENTRY_INIT(e, list);
	LIST_INSERT_HEAD(al, e, list);
}

static void
al_free(struct attr_list *al)
{
	struct attr_entry *e;
	while ((e = LIST_TOP(*al))) {
		LIST_REMOVE(e, list);
		free(e->name);
		free(e->value);
		free(e);
	}
}

/* ------------------------------------------------------------------ */

static void
test_parse_basic(void)
{
	int v, m;
	const char *aff;

	check("parse \"2\"", rpg_tag_parse("2", &v, &m, &aff)
		&& v == 2 && m == RPG_TAG_MODE_POSITION && aff == NULL);

	check("parse \"-1\"", rpg_tag_parse("-1", &v, &m, &aff)
		&& v == -1 && m == RPG_TAG_MODE_POSITION && aff == NULL);

	check("parse \"1:p\"", rpg_tag_parse("1:p", &v, &m, &aff)
		&& v == 1 && m == RPG_TAG_MODE_POSITION && aff == NULL);

	check("parse \"2:d\"", rpg_tag_parse("2:d", &v, &m, &aff)
		&& v == 2 && m == RPG_TAG_MODE_DIFFICULTY && aff == NULL);

	check("parse \"2:d:*\"", rpg_tag_parse("2:d:*", &v, &m, &aff)
		&& v == 2 && m == RPG_TAG_MODE_DIFFICULTY && aff == NULL);

	if (rpg_tag_parse("2:p:move,fight", &v, &m, &aff)) {
		check("parse full form value", v == 2);
		check("parse full form mode", m == RPG_TAG_MODE_POSITION);
		check("parse full form affects",
			aff && !strcmp(aff, "move,fight"));
	} else {
		check("parse full form ok", false);
	}
}

static void
test_parse_edges(void)
{
	int v, m;
	const char *aff;

	check("parse clamps +99 to +3", rpg_tag_parse("99", &v, &m, &aff)
		&& v == 3);
	check("parse clamps -99 to -3", rpg_tag_parse("-99", &v, &m, &aff)
		&& v == -3);
	check("parse rejects empty", !rpg_tag_parse("", &v, &m, &aff));
	check("parse rejects NULL", !rpg_tag_parse(NULL, &v, &m, &aff));
	check("parse rejects non-digit", !rpg_tag_parse("abc", &v, &m, &aff));
	check("parse rejects bad mode",
		!rpg_tag_parse("1:x", &v, &m, &aff));
}

static void
test_affects(void)
{
	check("affects NULL -> match", rpg_tag_affects(NULL, RPG_ACTION_MOVE));
	check("affects \"*\" -> match",
		rpg_tag_affects("*", RPG_ACTION_MOVE));
	check("affects single match",
		rpg_tag_affects("move", RPG_ACTION_MOVE));
	check("affects csv match",
		rpg_tag_affects("fight,move,shoot", RPG_ACTION_MOVE));
	check("affects csv no-match",
		!rpg_tag_affects("fight,shoot", RPG_ACTION_MOVE));
	check("affects case-insensitive",
		rpg_tag_affects("MOVE", RPG_ACTION_MOVE));
	check("affects no partial match",
		!rpg_tag_affects("mover", RPG_ACTION_MOVE));
}

static void
test_position_shift(void)
{
	check("shift +1 from risky -> controlled",
		rpg_position_shift(RPG_POS_RISKY, 1) == RPG_POS_CONTROLLED);
	check("shift -1 from risky -> desperate",
		rpg_position_shift(RPG_POS_RISKY, -1) == RPG_POS_DESPERATE);
	check("shift clamps high",
		rpg_position_shift(RPG_POS_CONTROLLED, 5)
			== RPG_POS_CONTROLLED);
	check("shift clamps low",
		rpg_position_shift(RPG_POS_DESPERATE, -5)
			== RPG_POS_DESPERATE);
	check("shift 0 identity",
		rpg_position_shift(RPG_POS_RISKY, 0) == RPG_POS_RISKY);
}

static void
test_apply_folds_actor_and_room(void)
{
	struct attr_list actor;
	OBJ *room;
	enum rpg_position pos = RPG_POS_RISKY;
	int diff = 2;

	LIST_INIT(&actor);

	/* +1 pos globally, applies to move */
	al_push(&actor, "rpg.tag.focused", "1");
	/* room tags: +2 difficulty reduction (move only), -1 pos (fight only) */
	room = obj_new_from_json("test-room",
		"{\"rpg.tag.tools\":\"2:d:move\","
		"\"rpg.tag.noisy\":\"-1:p:fight\"}");

	rpg_tags_apply((struct character *)&actor,
		room, RPG_ACTION_MOVE, &pos, &diff);

	check("apply: pos shifted to controlled",
		pos == RPG_POS_CONTROLLED);
	check("apply: difficulty reduced to 1 (2-2 clamp)", diff == 1);

	al_free(&actor);
	obj_free(room);
}

static void
test_apply_ignores_non_prefix(void)
{
	struct attr_list actor;
	enum rpg_position pos = RPG_POS_RISKY;
	int diff = 3;

	LIST_INIT(&actor);
	al_push(&actor, "room.current", "zone/foo");
	al_push(&actor, "rpg.skill.move", "2");

	rpg_tags_apply((struct character *)&actor, NULL,
		RPG_ACTION_MOVE, &pos, &diff);

	check("apply: unrelated attrs ignored (pos)", pos == RPG_POS_RISKY);
	check("apply: unrelated attrs ignored (diff)", diff == 3);

	al_free(&actor);
}

static void
test_apply_clamps_difficulty_high(void)
{
	struct attr_list actor;
	enum rpg_position pos = RPG_POS_RISKY;
	int diff = 3;

	LIST_INIT(&actor);
	/* -3:d raises difficulty by 3, should clamp to 5 */
	al_push(&actor, "rpg.tag.harsh", "-3:d");

	rpg_tags_apply((struct character *)&actor, NULL,
		RPG_ACTION_MOVE, &pos, &diff);

	check("apply: difficulty clamps to 5", diff == 5);

	al_free(&actor);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : tag.c");

	test_parse_basic();
	test_parse_edges();
	test_affects();
	test_position_shift();
	test_apply_folds_actor_and_room();
	test_apply_ignores_non_prefix();
	test_apply_clamps_difficulty_high();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
