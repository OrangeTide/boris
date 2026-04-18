/**
 * @file roll.c
 *
 * "roll" command: explicit action roll. Phase 1 form:
 *   roll <action> [difficulty <n>]
 * No tag/position engine yet — position defaults to risky, difficulty 1.
 */

#include "command.h"
#include <boris.h>
#include "character.h"
#include "rpg_char.h"
#include "dice.h"
#include "util.h"

#include <stdlib.h>
#include <string.h>

static const char *
outcome_label(int outcome)
{
	if (outcome > 0) return "full success";
	if (outcome == 0) return "partial success";
	return "bad outcome";
}

int
command_do_roll(DESCRIPTOR_DATA *cl, struct user *u UNUSED,
	const char *cmd UNUSED, const char *arg)
{
	struct character *ch;
	char action_name[32];
	char word[32];
	int action_id;
	int rank;
	int difficulty = 1;
	struct rpg_roll_result r;

	if (!mud_config.rpg_enabled) {
		telnetclient_puts(cl, "The RPG subsystem is disabled.\n");
		return 0;
	}

	ch = telnetclient_character(cl);
	if (!ch) {
		telnetclient_puts(cl, "No active character.\n");
		return 0;
	}

	if (!arg) {
		telnetclient_puts(cl, "usage: roll <action> [difficulty <n>]\n");
		return 0;
	}

	arg = util_getword(arg, action_name, sizeof action_name);
	action_id = rpg_action_from_name(action_name);
	if (action_id < 0) {
		telnetclient_printf(cl, "Unknown action \"%s\".\n", action_name);
		return 0;
	}

	while (arg && *arg) {
		arg = util_getword(arg, word, sizeof word);
		if (!strcasecmp(word, "difficulty") || !strcasecmp(word, "d")) {
			char nbuf[16];
			if (!arg) break;
			arg = util_getword(arg, nbuf, sizeof nbuf);
			difficulty = atoi(nbuf);
			if (difficulty < 1) difficulty = 1;
			if (difficulty > 5) difficulty = 5;
		}
	}

	rank = rpg_skill_get(ch, (enum rpg_action)action_id);
	rpg_dice_roll(rank, RPG_DICE_THRESHOLD_SKILL, NULL, NULL, &r);

	telnetclient_printf(cl,
		"%s (rank %d) vs difficulty %d: %d hit%s%s -> %s.\n",
		rpg_action_name((enum rpg_action)action_id),
		rank, difficulty,
		r.hits, r.hits == 1 ? "" : "s",
		r.traitor ? " [traitor]" : "",
		outcome_label(rpg_dice_outcome(r.hits, difficulty)));

	character_save(ch);
	return 1;
}
