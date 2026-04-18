#ifndef BORIS_RPG_TAG_H_
#define BORIS_RPG_TAG_H_

/**
 * @file tag.h
 *
 * Scene tags. See doc/rpg-system.md §5.
 *
 * Stored on an entity's attribute list with keys of the form
 *   "rpg.tag.<name>" = "<value>:<mode>:<affects>"
 * where:
 *   value   -- integer on the adjective ladder, -3..+3
 *   mode    -- 'p' for position (default) or 'd' for difficulty
 *   affects -- "*" or a comma-separated list of action names
 *              (e.g. "move,fight")
 *
 * Shorter forms are accepted: "<value>" alone defaults to mode=p, affects=*.
 */

#include "rpg_char.h"
#include "position.h"

struct character;
struct room;

#define RPG_TAG_MODE_POSITION 0
#define RPG_TAG_MODE_DIFFICULTY 1

#define RPG_TAG_PREFIX "rpg.tag."
#define RPG_TAG_PREFIX_LEN 8

/**
 * Parse a tag attribute value.
 * Returns 1 on success. affects_out points into the source string or is NULL
 * for "*" / omitted (meaning "applies to all actions").
 */
int rpg_tag_parse(const char *s, int *value, int *mode,
	const char **affects_out);

/**
 * Does this tag's affects predicate fire for the given action?
 * affects_csv may be NULL (interpreted as "*", matches all actions).
 */
int rpg_tag_affects(const char *affects_csv, enum rpg_action a);

/**
 * Iterate tag attrs on character + room relevant to `action`; fold their
 * contribution into *pos and *difficulty. Safe to pass NULL for either
 * entity. *pos and *difficulty must be pre-seeded with the baseline.
 */
void rpg_tags_apply(struct character *actor, struct room *room,
	enum rpg_action action,
	enum rpg_position *pos, int *difficulty);

#endif
