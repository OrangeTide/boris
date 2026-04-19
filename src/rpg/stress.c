/**
 * @file stress.c
 *
 * Stress, harm, conditions, and resistance rolls.
 * See stress.h and doc/rpg-system.md §6, §7.
 */

#include "stress.h"
#include "character.h"

#include <stdio.h>
#include <stdlib.h>

static const int harm_caps[RPG_HARM_LEVEL_MAX + 1] = {
	[0] = 0, /* unused */
	[1] = 2,
	[2] = 2,
	[3] = 1,
};

static const char *harm_keys[RPG_HARM_LEVEL_MAX + 1] = {
	[0] = NULL,
	[1] = "rpg.harm.l1",
	[2] = "rpg.harm.l2",
	[3] = "rpg.harm.l3",
};

int
rpg_harm_level_cap(int level)
{
	if (level < 1 || level > RPG_HARM_LEVEL_MAX) return 0;
	return harm_caps[level];
}

static int
get_int(struct character *ch, const char *key)
{
	const char *v;
	if (!ch) return 0;
	v = character_attr_get(ch, key);
	return v ? atoi(v) : 0;
}

static int
set_int(struct character *ch, const char *key, int n)
{
	char buf[12];
	if (!ch) return 0;
	snprintf(buf, sizeof buf, "%d", n);
	return character_attr_set(ch, key, buf);
}

int
rpg_stress_get(struct character *ch)
{
	return get_int(ch, "rpg.stress");
}

int
rpg_stress_set(struct character *ch, int s)
{
	if (s < 0) s = 0;
	if (s > RPG_STRESS_MAX) s = RPG_STRESS_MAX;
	return set_int(ch, "rpg.stress", s);
}

int
rpg_conditions_get(struct character *ch)
{
	return get_int(ch, "rpg.conditions");
}

int
rpg_conditions_set(struct character *ch, int n)
{
	if (n < 0) n = 0;
	if (n > RPG_CONDITIONS_MAX) n = RPG_CONDITIONS_MAX;
	return set_int(ch, "rpg.conditions", n);
}

int
rpg_harm_get(struct character *ch, int level)
{
	if (level < 1 || level > RPG_HARM_LEVEL_MAX) return 0;
	return get_int(ch, harm_keys[level]);
}

int
rpg_harm_set(struct character *ch, int level, int boxes)
{
	int cap;
	if (level < 1 || level > RPG_HARM_LEVEL_MAX) return 0;
	cap = harm_caps[level];
	if (boxes < 0) boxes = 0;
	if (boxes > cap) boxes = cap;
	return set_int(ch, harm_keys[level], boxes);
}

int
rpg_stress_add(struct character *ch, int n)
{
	int s = rpg_stress_get(ch) + n;
	int gained = 0;

	if (s > RPG_STRESS_MAX) {
		/* overwhelmed: add a condition, reset stress to 0. */
		int cond = rpg_conditions_get(ch);
		if (cond < RPG_CONDITIONS_MAX) rpg_conditions_set(ch, cond + 1);
		s = 0;
		gained = 1;
	}
	if (s < 0) s = 0;
	rpg_stress_set(ch, s);
	return gained;
}

enum rpg_harm_result
rpg_harm_apply(struct character *ch, int level)
{
	int escalated = 0;

	if (!ch || level < 1 || level > RPG_HARM_LEVEL_MAX) return RPG_HARM_OK;

	while (level <= RPG_HARM_LEVEL_MAX) {
		int cur = rpg_harm_get(ch, level);
		if (cur < harm_caps[level]) {
			rpg_harm_set(ch, level, cur + 1);
			return escalated ? RPG_HARM_ESCALATED : RPG_HARM_OK;
		}
		escalated = 1;
		level++;
	}

	/* fell off the end: level 3 was already full. */
	return RPG_HARM_DYING;
}

static int
default_d6(void *ctx)
{
	(void)ctx;
	return (rand() % 6) + 1;
}

void
rpg_resist_roll(int dice, rpg_d6_fn d6, void *ctx,
	int *highest, int *sixes)
{
	int i, hi = 0, six = 0;

	if (!d6) d6 = default_d6;

	for (i = 0; i < dice; i++) {
		int v = d6(ctx);
		if (v < 1) v = 1;
		if (v > 6) v = 6;
		if (v > hi) hi = v;
		if (v == 6) six++;
	}

	if (highest) *highest = hi;
	if (sixes) *sixes = six;
}
