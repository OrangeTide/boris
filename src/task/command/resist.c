/**
 * @file resist.c
 *
 * "resist" command: spend stress to reduce a consequence.
 *   resist <body|finesse|mind|presence>
 *
 * Rolls d6s equal to the chosen attribute score. Cost = 6 - highest die,
 * paid as stress. Two or more sixes clear 1 stress instead. See
 * doc/rpg-system.md §7.
 */

#include "command.h"
#include <boris.h>
#include "character.h"
#include "rpg_char.h"
#include "stress.h"
#include "util.h"

#include <stdlib.h>

int
command_do_resist(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	struct character *ch;
	char word[32];
	int attr_id;
	int dice;
	int highest = 0, sixes = 0;
	int gained = 0;

	if (!mud_config.rpg_enabled) {
		telnetclient_puts(cl, "The RPG subsystem is disabled.\n");
		return 0;
	}

	ch = telnetclient_character(cl);
	if (!ch) {
		telnetclient_puts(cl, "No active character.\n");
		return 0;
	}

	if (!arg || !*arg) {
		telnetclient_puts(cl,
			"usage: resist <body|finesse|mind|presence>\n");
		return 0;
	}

	arg = util_getword(arg, word, sizeof word);
	attr_id = rpg_attr_from_name(word);
	if (attr_id < 0) {
		telnetclient_printf(cl, "Unknown attribute \"%s\".\n", word);
		return 0;
	}

	dice = rpg_attr_score(ch, (enum rpg_attr)attr_id);
	rpg_resist_roll(dice, NULL, NULL, &highest, &sixes);

	if (sixes >= 2) {
		rpg_stress_add(ch, -1);
		telnetclient_printf(cl,
			"resist %s (%d dice): highest %d, %d sixes -> clear 1 stress.\n",
			rpg_attr_name((enum rpg_attr)attr_id),
			dice, highest, sixes);
	} else {
		int cost = 6 - highest;
		if (cost < 0) cost = 0;
		gained = rpg_stress_add(ch, cost);
		telnetclient_printf(cl,
			"resist %s (%d dice): highest %d -> %d stress%s.\n",
			rpg_attr_name((enum rpg_attr)attr_id),
			dice, highest, cost,
			gained ? " [overwhelmed: +1 condition]" : "");
	}

	character_save(ch);
	return 1;
}
