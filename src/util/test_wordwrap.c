#include "wordwrap.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int failures;

#define FAIL(fmt, ...) do { \
	fprintf(stderr, "FAIL %s:%d " fmt "\n", __func__, __LINE__, ##__VA_ARGS__); \
	failures++; \
} while (0)

#define OK(label) printf("ok   %s\n", (label))

#define EXPECT(cond, label) do { \
	if (!(cond)) FAIL("%s: expected (%s)", (label), #cond); \
	else OK(label); \
} while (0)

#define EXPECT_INT(got, want, label) do { \
	int g_ = (got), w_ = (want); \
	if (g_ != w_) FAIL("%s: got %d want %d", (label), g_, w_); \
	else OK(label); \
} while (0)

/* ---- wordify tests ---- */

static void
test_wordify_basic(void)
{
	struct ww_word *words = NULL;
	const char *s = "hello world foo";
	int n = ww_wordify(s, (unsigned)strlen(s), &words);

	EXPECT_INT(n, 3, "wordify basic count");
	if (n == 3) {
		EXPECT_INT(words[0].off, 0, "word0 off");
		EXPECT_INT(words[0].len, 5, "word0 len");
		EXPECT_INT(words[0].width, 5, "word0 width");
		EXPECT_INT(words[1].off, 6, "word1 off");
		EXPECT_INT(words[1].len, 5, "word1 len");
		EXPECT_INT(words[2].off, 12, "word2 off");
		EXPECT_INT(words[2].len, 3, "word2 len");
	}
	free(words);
}

static void
test_wordify_empty(void)
{
	struct ww_word *words = NULL;
	int n = ww_wordify("", 0, &words);

	EXPECT_INT(n, 0, "wordify empty count");
	EXPECT(words == NULL, "wordify empty null");
}

static void
test_wordify_whitespace_only(void)
{
	struct ww_word *words = NULL;
	const char *s = "   \t\n  ";
	int n = ww_wordify(s, (unsigned)strlen(s), &words);

	EXPECT_INT(n, 0, "wordify whitespace count");
	EXPECT(words == NULL, "wordify whitespace null");
}

static void
test_wordify_multiple_spaces(void)
{
	struct ww_word *words = NULL;
	const char *s = "  aaa   bb  c  ";
	int n = ww_wordify(s, (unsigned)strlen(s), &words);

	EXPECT_INT(n, 3, "wordify multi-space count");
	if (n == 3) {
		EXPECT_INT(words[0].off, 2, "ms word0 off");
		EXPECT_INT(words[0].len, 3, "ms word0 len");
		EXPECT_INT(words[1].off, 8, "ms word1 off");
		EXPECT_INT(words[1].len, 2, "ms word1 len");
		EXPECT_INT(words[2].off, 12, "ms word2 off");
		EXPECT_INT(words[2].len, 1, "ms word2 len");
	}
	free(words);
}

static void
test_wordify_single_word(void)
{
	struct ww_word *words = NULL;
	const char *s = "hello";
	int n = ww_wordify(s, (unsigned)strlen(s), &words);

	EXPECT_INT(n, 1, "wordify single count");
	if (n == 1) {
		EXPECT_INT(words[0].off, 0, "single word0 off");
		EXPECT_INT(words[0].len, 5, "single word0 len");
	}
	free(words);
}

/* ---- greedy wrap tests ---- */

static void
test_greedy_basic(void)
{
	/* "the quick brown fox" width 10 -> "the quick" / "brown fox" */
	struct ww_word words[] = {
		{ 0, 3, 3 }, /* the */
		{ 4, 5, 5 }, /* quick */
		{ 10, 5, 5 }, /* brown */
		{ 16, 3, 3 }, /* fox */
	};
	unsigned *breaks = NULL;
	int n = ww_wrap(words, 4, 10, WW_GREEDY, &breaks);

	EXPECT_INT(n, 2, "greedy basic lines");
	if (n == 2) {
		EXPECT_INT(breaks[0], 0, "greedy line0 start");
		EXPECT_INT(breaks[1], 2, "greedy line1 start");
	}
	free(breaks);
}

static void
test_greedy_all_fit(void)
{
	struct ww_word words[] = {
		{ 0, 2, 2 },
		{ 3, 2, 2 },
		{ 6, 2, 2 },
	};
	unsigned *breaks = NULL;
	int n = ww_wrap(words, 3, 20, WW_GREEDY, &breaks);

	EXPECT_INT(n, 1, "greedy all-fit lines");
	if (n == 1)
		EXPECT_INT(breaks[0], 0, "greedy all-fit start");
	free(breaks);
}

static void
test_greedy_one_per_line(void)
{
	struct ww_word words[] = {
		{ 0, 5, 5 },
		{ 6, 5, 5 },
		{ 12, 5, 5 },
	};
	unsigned *breaks = NULL;
	int n = ww_wrap(words, 3, 5, WW_GREEDY, &breaks);

	EXPECT_INT(n, 3, "greedy one-per-line");
	if (n == 3) {
		EXPECT_INT(breaks[0], 0, "opl line0");
		EXPECT_INT(breaks[1], 1, "opl line1");
		EXPECT_INT(breaks[2], 2, "opl line2");
	}
	free(breaks);
}

/* ---- optimal wrap tests ---- */

static void
test_optimal_basic(void)
{
	struct ww_word words[] = {
		{ 0, 3, 3 },
		{ 4, 5, 5 },
		{ 10, 5, 5 },
		{ 16, 3, 3 },
	};
	unsigned *breaks = NULL;
	int n = ww_wrap(words, 4, 10, WW_OPTIMAL, &breaks);

	EXPECT_INT(n, 2, "optimal basic lines");
	if (n == 2) {
		EXPECT_INT(breaks[0], 0, "optimal line0 start");
		EXPECT_INT(breaks[1], 2, "optimal line1 start");
	}
	free(breaks);
}

static void
test_optimal_vs_greedy(void)
{
	/* words: "aaa" "bb" "cc" "ddddd", line_width=6
	 *
	 * greedy:  "aaa bb" / "cc"    / "ddddd"  (slacks: 0, 4, -)
	 * optimal: "aaa"    / "bb cc" / "ddddd"  (slacks: 3, 1, -)
	 *
	 * greedy cost  = 0 + 16 = 16
	 * optimal cost = 9 + 1  = 10
	 */
	struct ww_word words[] = {
		{ 0, 3, 3 },
		{ 4, 2, 2 },
		{ 7, 2, 2 },
		{ 10, 5, 5 },
	};

	unsigned *gbreaks = NULL;
	int gn = ww_wrap(words, 4, 6, WW_GREEDY, &gbreaks);

	EXPECT_INT(gn, 3, "vs-greedy lines");
	if (gn == 3) {
		EXPECT_INT(gbreaks[0], 0, "vs-greedy line0");
		EXPECT_INT(gbreaks[1], 2, "vs-greedy line1");
		EXPECT_INT(gbreaks[2], 3, "vs-greedy line2");
	}

	unsigned *obreaks = NULL;
	int on = ww_wrap(words, 4, 6, WW_OPTIMAL, &obreaks);

	EXPECT_INT(on, 3, "vs-optimal lines");
	if (on == 3) {
		EXPECT_INT(obreaks[0], 0, "vs-optimal line0");
		EXPECT_INT(obreaks[1], 1, "vs-optimal line1");
		EXPECT_INT(obreaks[2], 3, "vs-optimal line2");
	}

	free(gbreaks);
	free(obreaks);
}

static void
test_optimal_last_line_free(void)
{
	/* last line should not be penalized for being short.
	 * "aaaa bbbb c", width=9
	 * without free last line: might split "aaaa" / "bbbb c" (slack 5,4)
	 * with free last line:    "aaaa bbbb" / "c" (slack 0, free) = cost 0
	 */
	struct ww_word words[] = {
		{ 0, 4, 4 },
		{ 5, 4, 4 },
		{ 10, 1, 1 },
	};
	unsigned *breaks = NULL;
	int n = ww_wrap(words, 3, 9, WW_OPTIMAL, &breaks);

	EXPECT_INT(n, 2, "last-line-free lines");
	if (n == 2) {
		EXPECT_INT(breaks[0], 0, "llf line0");
		EXPECT_INT(breaks[1], 2, "llf line1");
	}
	free(breaks);
}

/* ---- edge cases ---- */

static void
test_overlong_word(void)
{
	struct ww_word words[] = {
		{ 0, 3, 3 },
		{ 4, 10, 10 },
		{ 15, 3, 3 },
	};
	unsigned *breaks = NULL;

	int gn = ww_wrap(words, 3, 6, WW_GREEDY, &breaks);
	EXPECT_INT(gn, 3, "overlong greedy lines");
	free(breaks);
	breaks = NULL;

	int on = ww_wrap(words, 3, 6, WW_OPTIMAL, &breaks);
	EXPECT_INT(on, 3, "overlong optimal lines");
	if (on == 3) {
		EXPECT_INT(breaks[0], 0, "overlong line0");
		EXPECT_INT(breaks[1], 1, "overlong line1");
		EXPECT_INT(breaks[2], 2, "overlong line2");
	}
	free(breaks);
}

static void
test_single_word(void)
{
	struct ww_word words[] = { { 0, 5, 5 } };
	unsigned *breaks = NULL;

	int n = ww_wrap(words, 1, 10, WW_OPTIMAL, &breaks);
	EXPECT_INT(n, 1, "single word lines");
	if (n == 1)
		EXPECT_INT(breaks[0], 0, "single word start");
	free(breaks);
}

static void
test_empty_wrap(void)
{
	unsigned *breaks = NULL;
	int n = ww_wrap(NULL, 0, 10, WW_OPTIMAL, &breaks);

	EXPECT_INT(n, 0, "empty wrap lines");
	EXPECT(breaks == NULL, "empty wrap null");
}

/* ---- end-to-end: wordify then wrap ---- */

static void
test_end_to_end(void)
{
	const char *s = "The quick brown fox jumps over the lazy dog";
	struct ww_word *words = NULL;
	int nw = ww_wordify(s, (unsigned)strlen(s), &words);

	EXPECT_INT(nw, 9, "e2e word count");

	unsigned *breaks = NULL;
	int nl = ww_wrap(words, (unsigned)nw, 20, WW_OPTIMAL, &breaks);

	EXPECT(nl >= 2, "e2e has multiple lines");

	if (nl > 0)
		EXPECT_INT(breaks[0], 0, "e2e first line at 0");

	free(breaks);
	free(words);
}

int
main(void)
{
	test_wordify_basic();
	test_wordify_empty();
	test_wordify_whitespace_only();
	test_wordify_multiple_spaces();
	test_wordify_single_word();

	test_greedy_basic();
	test_greedy_all_fit();
	test_greedy_one_per_line();

	test_optimal_basic();
	test_optimal_vs_greedy();
	test_optimal_last_line_free();

	test_overlong_word();
	test_single_word();
	test_empty_wrap();

	test_end_to_end();

	if (failures) {
		fprintf(stderr, "%d test(s) failed\n", failures);
		return 1;
	}
	printf("all tests passed\n");
	return 0;
}
