#ifndef BORIS_RPG_POSITION_H_
#define BORIS_RPG_POSITION_H_

/**
 * @file position.h
 *
 * Position: how bad a bad outcome gets. See doc/rpg-system.md §4.1.
 */

enum rpg_position {
	RPG_POS_CONTROLLED = 0,
	RPG_POS_RISKY = 1,
	RPG_POS_DESPERATE = 2,
	RPG_POS_COUNT
};

const char *rpg_position_name(enum rpg_position p);

/** parse a position name; -1 if unknown. case-insensitive. */
int rpg_position_from_name(const char *name);

/**
 * Shift a position by delta tiers. Positive delta = toward controlled
 * (better for actor); negative = toward desperate. Clamps to valid range.
 */
enum rpg_position rpg_position_shift(enum rpg_position base, int delta);

#endif
