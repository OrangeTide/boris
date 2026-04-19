/**
 * @file position.c
 */

#include "position.h"

#include <strings.h>

static const char *position_names[] = {
	[RPG_POS_CONTROLLED] = "controlled",
	[RPG_POS_RISKY] = "risky",
	[RPG_POS_DESPERATE] = "desperate",
};

const char *
rpg_position_name(enum rpg_position p)
{
	if ((int)p < 0 || (int)p >= RPG_POS_COUNT) return "?";
	return position_names[p];
}

int
rpg_position_from_name(const char *name)
{
	int i;

	if (!name) return -1;
	for (i = 0; i < RPG_POS_COUNT; i++) {
		if (!strcasecmp(name, position_names[i])) return i;
	}
	return -1;
}

enum rpg_position
rpg_position_shift(enum rpg_position base, int delta)
{
	int v = (int)base - delta;
	if (v < 0) v = 0;
	if (v >= RPG_POS_COUNT) v = RPG_POS_COUNT - 1;
	return (enum rpg_position)v;
}
