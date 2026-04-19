/* unit test for stress.c */
#define LOG_SUBSYSTEM "test_stress"
#include "log.h"

#include "boris.h"
#include "stress.c"

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

/* ------------------------------------------------------------------
 * Stub character: a small (key,value) table. stress.c only uses
 * character_attr_get / character_attr_set.
 * ------------------------------------------------------------------ */

#define MAX_ATTRS 16
struct stub_char {
	char *keys[MAX_ATTRS];
	char *vals[MAX_ATTRS];
	int n;
};

static int
stub_find(struct stub_char *c, const char *key)
{
	int i;
	for (i = 0; i < c->n; i++)
		if (!strcmp(c->keys[i], key)) return i;
	return -1;
}

const char *
character_attr_get(struct character *ch, const char *name)
{
	struct stub_char *c = (struct stub_char *)ch;
	int i = stub_find(c, name);
	return i < 0 ? NULL : c->vals[i];
}

int
character_attr_set(struct character *ch, const char *name, const char *value)
{
	struct stub_char *c = (struct stub_char *)ch;
	int i = stub_find(c, name);
	if (i < 0) {
		if (c->n >= MAX_ATTRS) return 0;
		i = c->n++;
		c->keys[i] = strdup(name);
	} else {
		free(c->vals[i]);
	}
	c->vals[i] = strdup(value);
	return 1;
}

static void
stub_free(struct stub_char *c)
{
	int i;
	for (i = 0; i < c->n; i++) {
		free(c->keys[i]);
		free(c->vals[i]);
	}
	c->n = 0;
}

/* ------------------------------------------------------------------
 * Scripted d6: returns values from an array, cycling if needed.
 * ------------------------------------------------------------------ */

struct d6_script {
	const int *values;
	int count;
	int pos;
};

static int
scripted_d6(void *ctx)
{
	struct d6_script *s = ctx;
	int v = s->values[s->pos % s->count];
	s->pos++;
	return v;
}

/* ------------------------------------------------------------------ */

static void
test_stress_basic(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;

	check("stress starts at 0", rpg_stress_get(ch) == 0);
	rpg_stress_add(ch, 3);
	check("stress add 3 -> 3", rpg_stress_get(ch) == 3);
	rpg_stress_add(ch, -1);
	check("stress clear 1 -> 2", rpg_stress_get(ch) == 2);
	rpg_stress_add(ch, -99);
	check("stress floors at 0", rpg_stress_get(ch) == 0);

	stub_free(&c);
}

static void
test_stress_overwhelmed(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;
	int gained;

	rpg_stress_set(ch, 8);
	gained = rpg_stress_add(ch, 1);
	check("stress 8+1=9, no overflow", rpg_stress_get(ch) == 9);
	check("no condition gained at cap", gained == 0);
	check("conditions still 0", rpg_conditions_get(ch) == 0);

	gained = rpg_stress_add(ch, 2);
	check("overwhelmed resets stress to 0", rpg_stress_get(ch) == 0);
	check("overwhelmed gained = 1", gained == 1);
	check("conditions now 1", rpg_conditions_get(ch) == 1);

	stub_free(&c);
}

static void
test_conditions_cap(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;
	int i;

	rpg_conditions_set(ch, RPG_CONDITIONS_MAX);
	rpg_stress_set(ch, 9);
	rpg_stress_add(ch, 1);
	check("conditions clamped at max",
		rpg_conditions_get(ch) == RPG_CONDITIONS_MAX);

	rpg_conditions_set(ch, 0);
	for (i = 0; i < 10; i++) rpg_conditions_set(ch, 99);
	check("conditions_set clamps high",
		rpg_conditions_get(ch) == RPG_CONDITIONS_MAX);

	stub_free(&c);
}

static void
test_harm_basic(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;

	check("harm caps: l1=2", rpg_harm_level_cap(1) == 2);
	check("harm caps: l2=2", rpg_harm_level_cap(2) == 2);
	check("harm caps: l3=1", rpg_harm_level_cap(3) == 1);
	check("harm caps: l0=0", rpg_harm_level_cap(0) == 0);
	check("harm caps: l4=0", rpg_harm_level_cap(4) == 0);

	check("apply l1 -> OK",
		rpg_harm_apply(ch, 1) == RPG_HARM_OK);
	check("l1 boxes = 1", rpg_harm_get(ch, 1) == 1);

	stub_free(&c);
}

static void
test_harm_escalation(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;

	/* fill level 1 */
	rpg_harm_apply(ch, 1);
	rpg_harm_apply(ch, 1);
	check("l1 full at 2", rpg_harm_get(ch, 1) == 2);

	/* next l1 should escalate to l2 */
	check("l1 full escalates to l2",
		rpg_harm_apply(ch, 1) == RPG_HARM_ESCALATED);
	check("l2 boxes = 1", rpg_harm_get(ch, 2) == 1);
	check("l1 still 2 (not drained)", rpg_harm_get(ch, 1) == 2);

	/* fill l2 and escalate to l3 */
	rpg_harm_apply(ch, 2);
	check("l2 full at 2", rpg_harm_get(ch, 2) == 2);
	check("l2 full escalates to l3",
		rpg_harm_apply(ch, 2) == RPG_HARM_ESCALATED);
	check("l3 boxes = 1", rpg_harm_get(ch, 3) == 1);
}

static void
test_harm_dying(void)
{
	struct stub_char c = {0};
	struct character *ch = (struct character *)&c;

	/* prefill all levels to full */
	rpg_harm_set(ch, 1, 2);
	rpg_harm_set(ch, 2, 2);
	rpg_harm_set(ch, 3, 1);

	check("full l3 + l3 harm -> DYING",
		rpg_harm_apply(ch, 3) == RPG_HARM_DYING);
	check("full l1 cascade -> DYING",
		rpg_harm_apply(ch, 1) == RPG_HARM_DYING);

	stub_free(&c);
}

static void
test_resist_cost(void)
{
	int highest = 0, sixes = 0;
	int rolls[] = { 1, 3, 4 };
	struct d6_script s = { rolls, 3, 0 };

	rpg_resist_roll(3, scripted_d6, &s, &highest, &sixes);
	check("resist: highest of {1,3,4} = 4", highest == 4);
	check("resist: no sixes", sixes == 0);
	/* caller computes cost = 6 - 4 = 2 */
}

static void
test_resist_clear_on_double_six(void)
{
	int highest = 0, sixes = 0;
	int rolls[] = { 6, 6, 2 };
	struct d6_script s = { rolls, 3, 0 };

	rpg_resist_roll(3, scripted_d6, &s, &highest, &sixes);
	check("resist: highest with two 6s = 6", highest == 6);
	check("resist: two sixes counted", sixes == 2);
}

static void
test_resist_zero_dice(void)
{
	int highest = 9, sixes = 9;
	rpg_resist_roll(0, NULL, NULL, &highest, &sixes);
	check("resist 0 dice: highest 0", highest == 0);
	check("resist 0 dice: sixes 0", sixes == 0);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : stress.c");

	test_stress_basic();
	test_stress_overwhelmed();
	test_conditions_cap();
	test_harm_basic();
	test_harm_escalation();
	test_harm_dying();
	test_resist_cost();
	test_resist_clear_on_double_six();
	test_resist_zero_dice();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
