/* unit test for dice.c */
#define LOG_SUBSYSTEM "test_dice"
#include "log.h"

#include "dice.c"

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

/* scripted d6: returns values from a fixed array in order. */
struct scripted {
	const int *values;
	int count;
	int pos;
};

static int
scripted_d6(void *ctx)
{
	struct scripted *s = ctx;
	if (s->pos >= s->count) {
		LOG_ERROR("scripted_d6: ran off end at pos=%d", s->pos);
		return 1;
	}
	return s->values[s->pos++];
}

static void
test_rank0_traitor_success(void)
{
	/* rank 0 -> roll 2 dice, both >=3 -> 1 hit. */
	int vals[] = { 3, 4 };
	struct scripted s = { vals, 2, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(0, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("rank0 traitor both pass -> 1 hit", hits == 1);
	check("rank0 traitor flag set", r.traitor == 1);
	check("rank0 traitor dice=2", r.dice_rolled == 2);
}

static void
test_rank0_traitor_fail(void)
{
	/* rank 0, one die fails -> 0 hits. */
	int vals[] = { 5, 2 };
	struct scripted s = { vals, 2, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(0, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("rank0 traitor one fail -> 0 hits", hits == 0);
}

static void
test_negrank_traitor(void)
{
	/* rank -1 -> 3 dice, all must pass. */
	int vals[] = { 3, 4, 5 };
	struct scripted s = { vals, 3, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(-1, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("rank-1 traitor all pass -> 1 hit", hits == 1);
	check("rank-1 dice=3", r.dice_rolled == 3);
}

static void
test_basic_skill_hits(void)
{
	/* rank 3, values 2,3,5 -> 2 hits, no sixes. */
	int vals[] = { 2, 3, 5 };
	struct scripted s = { vals, 3, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(3, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("rank3 basic hits", hits == 2);
	check("rank3 dice=3", r.dice_rolled == 3);
	check("rank3 traitor=0", r.traitor == 0);
}

static void
test_combat_threshold(void)
{
	/* rank 3, values 3,4,5 -> threshold 4 -> 2 hits (4,5). */
	int vals[] = { 3, 4, 5 };
	struct scripted s = { vals, 3, 0 };
	int hits = rpg_dice_roll(3, RPG_DICE_THRESHOLD_COMBAT, scripted_d6, &s, NULL);
	check("combat threshold excludes 3s", hits == 2);
}

static void
test_exploding_pair(void)
{
	/* rank 4, values 6,6,2,2 -> 2 primary hits, 1 pair -> 1 bonus die.
	 * bonus value 5 -> +1 hit = 3 total. */
	int vals[] = { 6, 6, 2, 2, 5 };
	struct scripted s = { vals, 5, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(4, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("pair of 6s explodes to +1 hit", hits == 3);
	check("dice_rolled counts bonus", r.dice_rolled == 5);
}

static void
test_exploding_chain(void)
{
	/* rank 4: 6,6,6,6 -> 4 hits, 4 sixes -> 2 pairs -> 2 bonus dice.
	 * bonus 6,6 -> 2 more hits, 2 sixes -> 1 pair -> 1 bonus die.
	 * bonus 4 -> 1 more hit. total 7 hits, 7 dice. */
	int vals[] = { 6, 6, 6, 6, 6, 6, 4 };
	struct scripted s = { vals, 7, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(4, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("chained explode hits=7", hits == 7);
	check("chained explode dice=7", r.dice_rolled == 7);
}

static void
test_exploding_odd_sixes(void)
{
	/* rank 3: 6,6,6 -> 3 hits, 3 sixes -> 1 pair, 1 leftover.
	 * bonus value 6 -> +1 hit, new 6 pairs with leftover -> 1 more bonus.
	 * bonus value 2 -> no more hits. total 4 hits, 5 dice. */
	int vals[] = { 6, 6, 6, 6, 2 };
	struct scripted s = { vals, 5, 0 };
	struct rpg_roll_result r;
	int hits = rpg_dice_roll(3, RPG_DICE_THRESHOLD_SKILL, scripted_d6, &s, &r);
	check("odd sixes chain hits=4", hits == 4);
	check("odd sixes chain dice=5", r.dice_rolled == 5);
}

static void
test_outcome(void)
{
	check("outcome full success", rpg_dice_outcome(3, 2) == 1);
	check("outcome partial", rpg_dice_outcome(2, 2) == 0);
	check("outcome bad", rpg_dice_outcome(1, 2) == -1);
	check("outcome zero vs 1 bad", rpg_dice_outcome(0, 1) == -1);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : dice.c");

	test_rank0_traitor_success();
	test_rank0_traitor_fail();
	test_negrank_traitor();
	test_basic_skill_hits();
	test_combat_threshold();
	test_exploding_pair();
	test_exploding_chain();
	test_exploding_odd_sixes();
	test_outcome();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
