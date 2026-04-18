#ifndef BORIS_RPG_CHAR_H_
#define BORIS_RPG_CHAR_H_

/**
 * @file rpg_char.h
 *
 * RPG attribute/skill helpers layered over the character attribute store.
 * See doc/rpg-system.md §2.
 */

struct character;

enum rpg_attr {
	RPG_ATTR_BODY,
	RPG_ATTR_FINESSE,
	RPG_ATTR_MIND,
	RPG_ATTR_PRESENCE,
	RPG_ATTR_COUNT
};

enum rpg_action {
	/* body */
	RPG_ACTION_FIGHT, RPG_ACTION_MOVE, RPG_ACTION_ENDURE, RPG_ACTION_BRAWN,
	/* finesse */
	RPG_ACTION_SHOOT, RPG_ACTION_PROWL, RPG_ACTION_NIMBLE, RPG_ACTION_TINKER,
	/* mind */
	RPG_ACTION_HUNT, RPG_ACTION_STUDY, RPG_ACTION_SURVEY, RPG_ACTION_ATTUNE,
	/* presence */
	RPG_ACTION_COMMAND, RPG_ACTION_CONSORT, RPG_ACTION_JUDGE, RPG_ACTION_SWAY,
	RPG_ACTION_COUNT
};

const char *rpg_action_name(enum rpg_action a);
const char *rpg_attr_name(enum rpg_attr a);

/** map an action to its parent attribute. */
enum rpg_attr rpg_action_attr(enum rpg_action a);

/** look up an action by case-insensitive name; -1 if unknown. */
int rpg_action_from_name(const char *name);

/** look up an attribute by case-insensitive name; -1 if unknown. */
int rpg_attr_from_name(const char *name);

/** get a skill rank (0 if unset). */
int rpg_skill_get(struct character *ch, enum rpg_action a);

/** set a skill rank. Returns 1 on success. */
int rpg_skill_set(struct character *ch, enum rpg_action a, int rank);

/** derived attribute score = sum of its four action ranks. */
int rpg_attr_score(struct character *ch, enum rpg_attr at);

#endif
