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

/* acs_setflag sets and clears a flag bit by letter and rejects bad letters. */
static void
test_setflag(void)
{
	struct acs_info ai;

	acs_init(&ai, 0, 0);

	CHECK("set 'w' returns 0", acs_setflag(&ai, 'w', 1) == 0);
	CHECK("'w' now reads set", acs_testflag(&ai, 'w') == 1);
	/* case is ignored: 'W' addresses the same bit as 'w'. */
	CHECK("'W' reads the same bit", acs_testflag(&ai, 'W') == 1);
	CHECK("acs_check fw passes", acs_check(&ai, "fw") == 1);

	CHECK("clear 'w' returns 0", acs_setflag(&ai, 'w', 0) == 0);
	CHECK("'w' now reads clear", acs_testflag(&ai, 'w') == 0);

	/* digits map above the letters; a non-alphanumeric flag is rejected. */
	CHECK("set digit '0' returns 0", acs_setflag(&ai, '0', 1) == 0);
	CHECK("'0' now reads set", acs_testflag(&ai, '0') == 1);
	CHECK("set '-' is rejected", acs_setflag(&ai, '-', 1) == -1);
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
	test_setflag();
	test_combined();

	return ctest_report("test_acs");
}
