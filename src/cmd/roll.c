/**
 * @file roll.c
 *
 * "roll" command: explicit action roll.
 *   roll <action> [difficulty <n>] [controlled|risky|desperate]
 *
 * Without a position override the engine computes position from character
 * and room tags (see doc/rpg-system.md §4, §5). Difficulty defaults to 1
 * and tag-sum adjustments are folded on top of the player-supplied value.
 */

#include "command.h"
#include <boris.h>
#include "character.h"
#include "room.h"
#include "rpg_char.h"
#include "dice.h"
#include "position.h"
#include "tag.h"
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
	OBJ *room = NULL;
	const char *room_id;
	char action_name[32];
	char word[32];
	int action_id;
	int rank;
	int difficulty = 1;
	int pos_override = -1;
	enum rpg_position pos = RPG_POS_RISKY;
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
		telnetclient_puts(cl,
			"usage: roll <action> [difficulty <n>] "
			"[controlled|risky|desperate]\n");
		return 0;
	}

	arg = util_getword(arg, action_name, sizeof action_name);
	action_id = rpg_action_from_name(action_name);
	if (action_id < 0) {
		telnetclient_printf(cl, "Unknown action \"%s\".\n", action_name);
		return 0;
	}

	while (arg && *arg) {
		int p;
		arg = util_getword(arg, word, sizeof word);
		if (!strcasecmp(word, "difficulty") || !strcasecmp(word, "d")) {
			char nbuf[16];
			if (!arg) break;
			arg = util_getword(arg, nbuf, sizeof nbuf);
			difficulty = atoi(nbuf);
			if (difficulty < 1) difficulty = 1;
			if (difficulty > 5) difficulty = 5;
			continue;
		}
		p = rpg_position_from_name(word);
		if (p >= 0) {
			pos_override = p;
			continue;
		}
		telnetclient_printf(cl, "unknown option \"%s\".\n", word);
	}

	room_id = character_attr_get(ch, "room.current");
	if (room_id) room = room_get(room_id);

	if (pos_override >= 0) {
		pos = (enum rpg_position)pos_override;
	} else {
		rpg_tags_apply(ch, room, (enum rpg_action)action_id,
			&pos, &difficulty);
	}

	rank = rpg_skill_get(ch, (enum rpg_action)action_id);
	rpg_dice_roll(rank, RPG_DICE_THRESHOLD_SKILL, NULL, NULL, &r);

	telnetclient_printf(cl,
		"%s (rank %d) [%s] vs difficulty %d: %d hit%s%s -> %s.\n",
		rpg_action_name((enum rpg_action)action_id),
		rank, rpg_position_name(pos), difficulty,
		r.hits, r.hits == 1 ? "" : "s",
		r.traitor ? " [traitor]" : "",
		outcome_label(rpg_dice_outcome(r.hits, difficulty)));

	if (room) room_put(room);
	character_save(ch);
	return 1;
}
