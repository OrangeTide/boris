/**
 * @file rpg_char.c
 *
 * RPG attribute/skill helpers. See rpg_char.h.
 */

#include "rpg_char.h"
#include "character.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

static const char *action_names[RPG_ACTION_COUNT] = {
	"fight", "move", "endure", "brawn",
	"shoot", "prowl", "nimble", "tinker",
	"hunt", "study", "survey", "attune",
	"command", "consort", "judge", "sway",
};

static const char *attr_names[RPG_ATTR_COUNT] = {
	"body", "finesse", "mind", "presence",
};

const char *
rpg_action_name(enum rpg_action a)
{
	if (a < 0 || a >= RPG_ACTION_COUNT) return NULL;
	return action_names[a];
}

const char *
rpg_attr_name(enum rpg_attr a)
{
	if (a < 0 || a >= RPG_ATTR_COUNT) return NULL;
	return attr_names[a];
}

enum rpg_attr
rpg_action_attr(enum rpg_action a)
{
	return (enum rpg_attr)(a / 4);
}

int
rpg_action_from_name(const char *name)
{
	int i;
	if (!name) return -1;
	for (i = 0; i < RPG_ACTION_COUNT; i++)
		if (!strcasecmp(name, action_names[i])) return i;
	return -1;
}

static void
skill_key(char *buf, size_t sz, enum rpg_action a)
{
	snprintf(buf, sz, "rpg.skill.%s", action_names[a]);
}

int
rpg_skill_get(struct character *ch, enum rpg_action a)
{
	char key[32];
	const char *v;
	if (!ch || a < 0 || a >= RPG_ACTION_COUNT) return 0;
	skill_key(key, sizeof key, a);
	v = character_attr_get(ch, key);
	return v ? atoi(v) : 0;
}

int
rpg_skill_set(struct character *ch, enum rpg_action a, int rank)
{
	char key[32];
	char val[12];
	if (!ch || a < 0 || a >= RPG_ACTION_COUNT) return 0;
	skill_key(key, sizeof key, a);
	snprintf(val, sizeof val, "%d", rank);
	return character_attr_set(ch, key, val);
}

int
rpg_attr_score(struct character *ch, enum rpg_attr at)
{
	int base = (int)at * 4;
	int i, sum = 0;
	if (!ch || at < 0 || at >= RPG_ATTR_COUNT) return 0;
	for (i = 0; i < 4; i++)
		sum += rpg_skill_get(ch, (enum rpg_action)(base + i));
	return sum;
}

int
rpg_stress_get(struct character *ch)
{
	const char *v;
	if (!ch) return 0;
	v = character_attr_get(ch, "rpg.stress");
	return v ? atoi(v) : 0;
}

int
rpg_stress_set(struct character *ch, int s)
{
	char val[12];
	if (!ch) return 0;
	if (s < 0) s = 0;
	if (s > 9) s = 9;
	snprintf(val, sizeof val, "%d", s);
	return character_attr_set(ch, "rpg.stress", val);
}
