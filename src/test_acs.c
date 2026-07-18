/* unit test for acs.c (access control system) */
#define LOG_SUBSYSTEM "test_acs"

/* include the source directly for unit testing */
#include "acs.c"

#include "ctest.h"

/* level checks: 's<n>' passes when the actor level is at least n. */
static void
test_level(void)
{
	struct acs_info ai;

	acs_init(&ai, 4, 0);
	CHECK("level 4 meets s2", acs_check(&ai, "s2") == 1);
	CHECK("level 4 meets s4", acs_check(&ai, "s4") == 1);
	CHECK("level 4 fails s6", acs_check(&ai, "s6") == 0);
}

/* flag checks: 'f<c>' passes when flag c is set. */
static void
test_flags(void)
{
	struct acs_info ai;

	/* bit 0 corresponds to flag 'a'/'A'. */
	acs_init(&ai, 0, 1u << 0);
	CHECK("flag A set passes fA", acs_check(&ai, "fA") == 1);
	CHECK("flag B unset fails fB", acs_check(&ai, "fB") == 0);
}

/* combined terms AND together; '|' introduces an alternative. */
static void
test_combined(void)
{
	struct acs_info ai;

	acs_init(&ai, 4, 0);
	CHECK("level ok but missing flag fails s2fA", acs_check(&ai, "s2fA") == 0);
	CHECK("failing first term, OR recovers on s8|s2", acs_check(&ai, "s8|s2") == 1);
	CHECK("both alternatives fail on s8|s9", acs_check(&ai, "s8|s9") == 0);
}

int
main(void)
{
	test_level();
	test_flags();
	test_combined();

	return ctest_report("test_acs");
}
