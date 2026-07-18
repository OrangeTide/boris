#ifndef CTEST_H_
#define CTEST_H_
/*
 * ctest.h - tiny single-header unit test harness.
 *
 * Include this from a test_*.c file.  It provides labelled boolean checks,
 * running pass/fail counters, and a standardized summary line that the
 * aggregate runner (src/tests/run_unit_tests.sh) parses to total results
 * across every test binary.
 *
 * Typical use:
 *
 *     #include "ctest.h"
 *
 *     int main(void) {
 *         CHECK("addition works", 2 + 2 == 4);
 *         EXPECT(strcmp(a, b) == 0, "strings match");
 *         return ctest_report("mytest");
 *     }
 */
#include <stdio.h>
#include <stdlib.h>

/* running totals for the current test binary. */
static int ctest_pass;
static int ctest_fail;

/* record one labelled result; ok != 0 counts as a pass. */
static inline void
ctest_check(const char *label, int ok)
{
	if (ok) {
		printf("ok   %s\n", label);
		ctest_pass++;
	} else {
		printf("FAIL %s\n", label);
		ctest_fail++;
	}
}

/*
 * A test file includes the module source first and ctest.h last, so undefining
 * these here lets the harness reclaim the names for the test body without
 * disturbing the already-compiled source above.  Note: OK/ERR are project
 * return codes (see retcode.h); the harness deliberately does NOT define OK,
 * using PASS for an unconditional pass instead.
 */
#undef CHECK
#undef check
#undef PASS
#undef FAIL
#undef EXPECT
#undef EXPECT_EQ
#undef EXPECT_INT
#undef EXPECT_EQ_X

/* CHECK(label, expr): record expr as a labelled result. */
#define CHECK(label, expr) ctest_check((label), (expr) ? 1 : 0)

/* check(label, ok): lowercase alias for the common existing idiom. */
#define check(label, ok) ctest_check((label), (ok) ? 1 : 0)

/* PASS(label): unconditional pass. (Not named OK; see retcode.h.) */
#define PASS(label) ctest_check((label), 1)

/* FAIL(fmt, ...): unconditional failure with a printf-style reason. */
#define FAIL(...) do { \
	fprintf(stderr, "  FAIL at %s:%d: ", __FILE__, __LINE__); \
	fprintf(stderr, __VA_ARGS__); \
	fputc('\n', stderr); \
	ctest_fail++; \
} while (0)

/* EXPECT(cond, label): pass when cond is true, else fail and note the source. */
#define EXPECT(cond, label) do { \
	if (cond) { \
		ctest_check((label), 1); \
	} else { \
		fprintf(stderr, "  at %s:%d: expected (%s)\n", __FILE__, __LINE__, #cond); \
		ctest_check((label), 0); \
	} \
} while (0)

/* EXPECT_EQ(actual, expected, label): integer equality with a value report. */
#define EXPECT_EQ(actual, expected, label) do { \
	long long ctest_a_ = (long long)(actual); \
	long long ctest_e_ = (long long)(expected); \
	if (ctest_a_ == ctest_e_) { \
		ctest_check((label), 1); \
	} else { \
		fprintf(stderr, "  at %s:%d: %s == %s : got %lld, want %lld\n", \
			__FILE__, __LINE__, #actual, #expected, ctest_a_, ctest_e_); \
		ctest_check((label), 0); \
	} \
} while (0)

/* EXPECT_INT: alias of EXPECT_EQ for tests that used that spelling. */
#define EXPECT_INT(got, want, label) EXPECT_EQ((got), (want), (label))

/* EXPECT_EQ_X(actual, expected, label): like EXPECT_EQ but reports in hex. */
#define EXPECT_EQ_X(actual, expected, label) do { \
	unsigned long long ctest_a_ = (unsigned long long)(actual); \
	unsigned long long ctest_e_ = (unsigned long long)(expected); \
	if (ctest_a_ == ctest_e_) { \
		ctest_check((label), 1); \
	} else { \
		fprintf(stderr, "  at %s:%d: %s == %s : got 0x%llx, want 0x%llx\n", \
			__FILE__, __LINE__, #actual, #expected, ctest_a_, ctest_e_); \
		ctest_check((label), 0); \
	} \
} while (0)

/*
 * print the machine-readable summary line and return a process exit code.
 * the runner greps for "## CTEST-SUMMARY" to aggregate pass/fail totals.
 */
static inline int
ctest_report(const char *suite)
{
	printf("## CTEST-SUMMARY %s pass=%d fail=%d\n", suite, ctest_pass, ctest_fail);
	return ctest_fail ? EXIT_FAILURE : EXIT_SUCCESS;
}

#endif
