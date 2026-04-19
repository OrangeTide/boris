/**
 * @file dice.c
 *
 * Core dice engine. See dice.h and doc/rpg-system.md §3.
 */

#include "dice.h"

#include <stdlib.h>

static int
default_d6(void *ctx)
{
	(void)ctx;
	return (rand() % 6) + 1;
}

static int
roll_threshold(int n, int threshold, rpg_d6_fn d6, void *ctx, int *sixes_out)
{
	int hits = 0;
	int sixes = 0;
	int i;

	for (i = 0; i < n; i++) {
		int v = d6(ctx);
		if (v >= threshold) hits++;
		if (v == 6) sixes++;
	}

	if (sixes_out) *sixes_out = sixes;
	return hits;
}

int
rpg_dice_roll(int rank, int threshold, rpg_d6_fn d6, void *ctx,
	struct rpg_roll_result *out)
{
	struct rpg_roll_result r;
	int sixes;
	int dice_rolled;
	int hits;

	r.hits = 0;
	r.sixes = 0;
	r.dice_rolled = 0;
	r.traitor = 0;

	if (!d6) d6 = default_d6;

	if (rank < 1) {
		/* traitor branch: 2-rank dice, all must clear threshold for 1 hit. */
		int n = 2 - rank;
		int i;
		int passed = 0;

		r.traitor = 1;
		r.dice_rolled = n;

		for (i = 0; i < n; i++) {
			int v = d6(ctx);
			if (v >= threshold) passed++;
			if (v == 6) r.sixes++;
		}

		r.hits = (passed == n) ? 1 : 0;

		if (out) *out = r;
		return r.hits;
	}

	dice_rolled = rank;
	hits = roll_threshold(rank, threshold, d6, ctx, &sixes);

	/* exploding pairs of 6s. pair them up, each pair -> one bonus die;
	 * bonus 6s can combine with leftover 6s to chain. */
	{
		int leftover = sixes;
		while (leftover >= 2) {
			int pairs = leftover / 2;
			int bonus_sixes;
			int bonus_hits = roll_threshold(pairs, threshold, d6, ctx, &bonus_sixes);

			hits += bonus_hits;
			dice_rolled += pairs;
			leftover = (leftover % 2) + bonus_sixes;
		}
		r.sixes = sixes; /* primary sixes only; chain accounted for via dice_rolled. */
	}

	r.hits = hits;
	r.dice_rolled = dice_rolled;

	if (out) *out = r;
	return r.hits;
}

int
rpg_dice_outcome(int hits, int difficulty)
{
	if (hits > difficulty) return 1;
	if (hits == difficulty) return 0;
	return -1;
}
