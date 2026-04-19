#ifndef BORIS_RPG_DICE_H_
#define BORIS_RPG_DICE_H_

/**
 * @file dice.h
 *
 * Core dice engine for the boris RPG system. See doc/rpg-system.md §3.
 *
 * A single action roll:
 *   - pool of d6s equal to effective rank (after modifiers),
 *   - each die >= threshold is a "hit" (3 for skill, 4 for combat),
 *   - unmatched 6s pair up and each pair spawns one bonus die rolled at
 *     the same threshold; new 6s chain,
 *   - if effective rank < 1, the "traitor" branch applies: roll 2-rank
 *     dice, all must clear the threshold for a single hit, max 1 hit.
 */

#define RPG_DICE_THRESHOLD_SKILL  3
#define RPG_DICE_THRESHOLD_COMBAT 4

/** Injectable d6 source. Must return 1..6. Default is lib rand(). */
typedef int (*rpg_d6_fn)(void *ctx);

struct rpg_roll_result {
	int hits;           /**< hits after exploding. */
	int sixes;          /**< total sixes rolled (primary + bonus). */
	int dice_rolled;    /**< total dice, including bonus. */
	int traitor;        /**< 1 if traitor branch was used. */
};

/**
 * Roll an action pool.
 *
 * @param rank effective rank; if < 1 the traitor branch is used.
 * @param threshold 3 (skill) or 4 (combat).
 * @param d6 RNG, or NULL to use the default rand()-backed source.
 * @param ctx opaque passed to d6.
 * @param out filled with result; may be NULL.
 * @return hit count.
 */
int rpg_dice_roll(int rank, int threshold, rpg_d6_fn d6, void *ctx,
	struct rpg_roll_result *out);

/**
 * Compare hits to difficulty and return outcome.
 *   -1 bad outcome, 0 partial, 1 full success.
 */
int rpg_dice_outcome(int hits, int difficulty);

#endif
