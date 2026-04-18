#ifndef BORIS_RPG_STRESS_H_
#define BORIS_RPG_STRESS_H_

/**
 * @file stress.h
 *
 * Stress, harm, conditions, and resistance rolls.
 * See doc/rpg-system.md §6 and §7.
 *
 * State is stored on the character attribute list:
 *   rpg.stress      -- 0..9
 *   rpg.conditions  -- 0..4
 *   rpg.harm.l1     -- 0..2
 *   rpg.harm.l2     -- 0..2
 *   rpg.harm.l3     -- 0..1
 */

#include "dice.h"

struct character;

#define RPG_STRESS_MAX      9
#define RPG_CONDITIONS_MAX  4
#define RPG_HARM_LEVEL_MAX  3

enum rpg_harm_result {
	RPG_HARM_OK,         /**< harm applied at requested level. */
	RPG_HARM_ESCALATED,  /**< level was full; harm escalated upward. */
	RPG_HARM_DYING       /**< level 3 was full; character is dying. */
};

/* ---- accessors ---- */

int rpg_stress_get(struct character *ch);
int rpg_stress_set(struct character *ch, int s);

int rpg_conditions_get(struct character *ch);
int rpg_conditions_set(struct character *ch, int n);

/** level is 1, 2, or 3. */
int rpg_harm_get(struct character *ch, int level);
int rpg_harm_set(struct character *ch, int level, int boxes);

/** boxes at a given level. */
int rpg_harm_level_cap(int level);

/* ---- engine ---- */

/**
 * Add n stress (n may be negative to clear). If stress would exceed the cap,
 * stress wraps to 0 and conditions increments by 1 ("overwhelmed"). At most
 * one condition is gained per call. Returns conditions gained (0 or 1).
 */
int rpg_stress_add(struct character *ch, int n);

/**
 * Apply harm at level (1..3). If that level is full the harm escalates to
 * the next level, repeating. If level 3 is already full when new severe
 * harm arrives, returns RPG_HARM_DYING (box state unchanged).
 */
enum rpg_harm_result rpg_harm_apply(struct character *ch, int level);

/**
 * Roll `dice` d6s and report the highest value and the count of sixes.
 * Pure dice: does not mutate character state. If dice <= 0, highest=0 and
 * sixes=0. d6 may be NULL for the default rand() source.
 *
 * Caller policy (per §7):
 *   if sixes >= 2  -> clear 1 stress (add -1);
 *   else           -> pay cost = 6 - highest stress.
 */
void rpg_resist_roll(int dice, rpg_d6_fn d6, void *ctx,
	int *highest, int *sixes);

#endif
