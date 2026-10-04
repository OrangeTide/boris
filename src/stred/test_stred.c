/* test_stred.c : unit tests for the string editor core */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "test_stred"

#include "stred.h"

#include <stdio.h>
#include <string.h>
#include "ctest.h"

/* feed a NULL-terminated list of lines, return the final status */
static enum stred_status
feed_all(struct stred *s, const char *const *lines)
{
	enum stred_status st = STRED_CONTINUE;
	unsigned i;

	for (i = 0; lines[i]; i++) {
		st = stred_feed(s, lines[i]);
		if (st != STRED_CONTINUE)
			break;
	}
	return st;
}

static void
test_multiline_assembly(void)
{
	struct stred *s = stred_new(NULL, STRED_MULTI, NULL, NULL);
	const char *const in[] = { "line one", "line two", "/s", NULL };

	check("save returns SAVED", feed_all(s, in) == STRED_SAVED);
	check("lines joined by newline",
		strcmp(stred_result(s), "line one\nline two") == 0);
	check("new content is changed", stred_changed(s));
	stred_free(s);
}

static void
test_keep(void)
{
	struct stred *s = stred_new("hello", STRED_MULTI, NULL, NULL);
	const char *const in[] = { "/s", NULL };

	check("save with no edits keeps the value",
		feed_all(s, in) == STRED_SAVED
		&& strcmp(stred_result(s), "hello") == 0);
	check("unchanged reports not changed", !stred_changed(s));
	stred_free(s);
}

static void
test_clear(void)
{
	struct stred *s = stred_new("hello", STRED_MULTI, NULL, NULL);
	const char *const in[] = { "/c", "/s", NULL };

	check("clear then save yields empty",
		feed_all(s, in) == STRED_SAVED && stred_result(s)[0] == '\0');
	check("clearing a value is a change", stred_changed(s));
	stred_free(s);
}

static void
test_abort(void)
{
	struct stred *s = stred_new("hello", STRED_MULTI, NULL, NULL);
	const char *const in[] = { "junk", "/a", NULL };

	check("abort returns ABORTED", feed_all(s, in) == STRED_ABORTED);
	check("abort keeps the original",
		strcmp(stred_original(s), "hello") == 0);
	stred_free(s);
}

static void
test_replace(void)
{
	struct stred *s = stred_new("old", STRED_MULTI, NULL, NULL);
	const char *const in[] = { "/r", "new", "/s", NULL };

	check("replace discards and starts fresh",
		feed_all(s, in) == STRED_SAVED
		&& strcmp(stred_result(s), "new") == 0);
	stred_free(s);
}

static void
test_slash_escape(void)
{
	struct stred *s = stred_new(NULL, STRED_MULTI, NULL, NULL);
	const char *const in[] = { "//not a command", "/s", NULL };

	check("// yields a literal-slash content line",
		feed_all(s, in) == STRED_SAVED
		&& strcmp(stred_result(s), "/not a command") == 0);
	stred_free(s);
}

static void
test_command_forms(void)
{
	/* short, prefix, and long forms all reach save */
	struct stred *a = stred_new("x", STRED_MULTI, NULL, NULL);
	struct stred *b = stred_new("x", STRED_MULTI, NULL, NULL);
	struct stred *c = stred_new("x", STRED_MULTI, NULL, NULL);
	const char *const sa[] = { "/s", NULL };
	const char *const sb[] = { "/sa", NULL };
	const char *const sc[] = { "/save", NULL };

	check("/s saves", feed_all(a, sa) == STRED_SAVED);
	check("/sa saves (prefix)", feed_all(b, sb) == STRED_SAVED);
	check("/save saves (long)", feed_all(c, sc) == STRED_SAVED);
	stred_free(a);
	stred_free(b);
	stred_free(c);
}

static void
test_delete_insert(void)
{
	struct stred *s = stred_new("a\nc", STRED_MULTI, NULL, NULL);
	const char *const del[] = { "/d 1", "/s", NULL };
	struct stred *s2 = stred_new("a\nc", STRED_MULTI, NULL, NULL);
	const char *const ins[] = { "/i 2", "b", "/s", NULL };

	check("delete line 1 removes it",
		feed_all(s, del) == STRED_SAVED
		&& strcmp(stred_result(s), "c") == 0);
	check("insert before line 2 places the next line there",
		feed_all(s2, ins) == STRED_SAVED
		&& strcmp(stred_result(s2), "a\nb\nc") == 0);
	stred_free(s);
	stred_free(s2);
}

static void
test_single_line(void)
{
	struct stred *s = stred_new("old", STRED_SINGLE, NULL, NULL);
	const char *const in[] = { "brand new", "/s", NULL };

	check("single-line typing replaces the value",
		feed_all(s, in) == STRED_SAVED
		&& strcmp(stred_result(s), "brand new") == 0);
	stred_free(s);
}

int
main(void)
{
	test_multiline_assembly();
	test_keep();
	test_clear();
	test_abort();
	test_replace();
	test_slash_escape();
	test_command_forms();
	test_delete_insert();
	test_single_line();
	return ctest_report("test_stred");
}
