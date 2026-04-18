/**
 * @file stat.c
 *
 * "stat" command: show the acting character's attributes, skill ranks,
 * stress, and harm. See doc/rpg-system.md §2.
 */

#include "command.h"
#include <boris.h>
#include "character.h"
#include "rpg_char.h"
#include "util.h"

#include <stdlib.h>

static void
show_attribute(DESCRIPTOR_DATA *cl, struct character *ch, enum rpg_attr at)
{
	int base = (int)at * 4;
	int i;

	telnetclient_printf(cl, "  %-8s (%d):",
		rpg_attr_name(at), rpg_attr_score(ch, at));
	for (i = 0; i < 4; i++) {
		enum rpg_action a = (enum rpg_action)(base + i);
		telnetclient_printf(cl, " %s=%d",
			rpg_action_name(a), rpg_skill_get(ch, a));
	}
	telnetclient_puts(cl, "\n");
}

int
command_do_stat(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg UNUSED)
{
	struct character *ch;
	enum rpg_attr at;

	if (!mud_config.rpg_enabled) {
		telnetclient_puts(cl, "The RPG subsystem is disabled.\n");
		return 0;
	}

	ch = telnetclient_character(cl);
	if (!ch) {
		telnetclient_puts(cl, "No active character.\n");
		return 0;
	}

	telnetclient_printf(cl, "Character: %s\n",
		character_attr_get(ch, "name.short"));
	telnetclient_puts(cl, "Attributes:\n");
	for (at = 0; at < RPG_ATTR_COUNT; at++)
		show_attribute(cl, ch, at);

	telnetclient_printf(cl, "Stress: %d/9\n", rpg_stress_get(ch));

	return 1;
}
