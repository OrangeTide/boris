/* test_verb_spec.c : tests for verb argument spec parsing and matching
 * Made by a machine. PUBLIC DOMAIN (CC0-1.0) */
#include "verb_spec.h"

#include <stdio.h>
#include <string.h>

static int failures;

#define FAIL(fmt, ...) do { \
	fprintf(stderr, "FAIL %s:%d " fmt "\n", \
		__func__, __LINE__, ##__VA_ARGS__); \
	failures++; \
} while (0)

#define OK(label) printf("ok   %s\n", (label))

#define EXPECT(cond, label) do { \
	if (!(cond)) FAIL("%s: expected (%s)", (label), #cond); \
	else OK(label); \
} while (0)

#define EXPECT_EQ(actual, expected, label) do { \
	if ((actual) != (expected)) \
		FAIL("%s: got %d expected %d", (label), \
			(int)(actual), (int)(expected)); \
	else OK(label); \
} while (0)

static int
seg_eq(const struct verb_match *m, int idx, const char *expected)
{
	if (idx >= m->nsegs)
		return 0;
	int elen = (int)strlen(expected);
	return m->segs[idx].len == elen &&
	       memcmp(m->segs[idx].str, expected, (size_t)elen) == 0;
}

/* ------------------------------------------------------------------ */

static void
test_parse_empty(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("", &s), 0, "parse empty");
	EXPECT_EQ(s.ntokens, 0, "parse empty ntokens");
	EXPECT_EQ(verb_spec_parse(NULL, &s), 0, "parse NULL");
}

static void
test_parse_typed_tokens(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("<obj> <atom=to> <player>", &s), 0,
		"parse obj-atom-player");
	EXPECT_EQ(s.ntokens, 3, "ntokens=3");
	EXPECT_EQ(s.tokens[0].type, VTOK_OBJ, "tok0=obj");
	EXPECT_EQ(s.tokens[1].type, VTOK_ATOM, "tok1=atom");
	EXPECT_EQ(s.tokens[1].natoms, 1, "tok1 natoms=1");
	EXPECT(strcmp(s.tokens[1].atoms[0], "to") == 0, "tok1 atom=to");
	EXPECT_EQ(s.tokens[2].type, VTOK_PLAYER, "tok2=player");
}

static void
test_parse_atom_alternation(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("<atom=on|in|above>", &s), 0,
		"parse alternation");
	EXPECT_EQ(s.ntokens, 1, "ntokens=1");
	EXPECT_EQ(s.tokens[0].natoms, 3, "natoms=3");
	EXPECT(strcmp(s.tokens[0].atoms[0], "on") == 0, "atom[0]=on");
	EXPECT(strcmp(s.tokens[0].atoms[1], "in") == 0, "atom[1]=in");
	EXPECT(strcmp(s.tokens[0].atoms[2], "above") == 0, "atom[2]=above");
}

static void
test_parse_bare_word(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("to", &s), 0, "parse bare word");
	EXPECT_EQ(s.ntokens, 1, "ntokens=1");
	EXPECT_EQ(s.tokens[0].type, VTOK_ATOM, "tok=atom");
	EXPECT_EQ(s.tokens[0].natoms, 1, "natoms=1");
	EXPECT(strcmp(s.tokens[0].atoms[0], "to") == 0, "atom=to");
}

static void
test_parse_bare_word_sugar(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("<obj> to <player>", &s), 0,
		"parse with bare word");
	EXPECT_EQ(s.ntokens, 3, "ntokens=3");
	EXPECT_EQ(s.tokens[0].type, VTOK_OBJ, "tok0=obj");
	EXPECT_EQ(s.tokens[1].type, VTOK_ATOM, "tok1=atom");
	EXPECT_EQ(s.tokens[1].natoms, 1, "tok1 natoms=1");
	EXPECT(strcmp(s.tokens[1].atoms[0], "to") == 0, "tok1=to");
	EXPECT_EQ(s.tokens[2].type, VTOK_PLAYER, "tok2=player");
}

static void
test_parse_any(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("<any>", &s), 0, "parse any");
	EXPECT_EQ(s.ntokens, 1, "ntokens=1");
	EXPECT_EQ(s.tokens[0].type, VTOK_ANY, "tok=any");
}

static void
test_parse_errors(void)
{
	struct verb_spec s;
	EXPECT_EQ(verb_spec_parse("<unknown>", &s), -1, "unknown type");
	EXPECT_EQ(verb_spec_parse("<obj", &s), -1, "unclosed bracket");
}

/* ------------------------------------------------------------------ */

static void
test_match_empty(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("", &s);
	EXPECT_EQ(verb_spec_match(&s, "", &m), 0, "empty matches empty");
	EXPECT_EQ(verb_spec_match(&s, "  ", &m), 0,
		"empty matches whitespace");
	EXPECT_EQ(verb_spec_match(&s, "stuff", &m), -1,
		"empty rejects input");
}

static void
test_match_single_obj(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj>", &s);
	EXPECT_EQ(verb_spec_match(&s, "sword", &m), 0, "obj one word");
	EXPECT(seg_eq(&m, 0, "sword"), "obj seg=sword");

	EXPECT_EQ(verb_spec_match(&s, "long sword", &m), 0,
		"obj multi-word");
	EXPECT(seg_eq(&m, 0, "long sword"), "obj seg=long sword");

	EXPECT_EQ(verb_spec_match(&s, "", &m), -1, "obj rejects empty");
}

static void
test_match_obj_atom_player(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj> <atom=to|at> <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "sword to jane", &m), 0,
		"basic match");
	EXPECT(seg_eq(&m, 0, "sword"), "dobj=sword");
	EXPECT(seg_eq(&m, 1, "to"), "prep=to");
	EXPECT(seg_eq(&m, 2, "jane"), "iobj=jane");

	EXPECT_EQ(verb_spec_match(&s, "long sword to jane", &m), 0,
		"multi-word dobj");
	EXPECT(seg_eq(&m, 0, "long sword"), "dobj=long sword");
	EXPECT(seg_eq(&m, 1, "to"), "prep=to");
	EXPECT(seg_eq(&m, 2, "jane"), "iobj=jane");

	EXPECT_EQ(verb_spec_match(&s, "sword at jane the great", &m), 0,
		"alt prep + multi-word iobj");
	EXPECT(seg_eq(&m, 0, "sword"), "dobj=sword");
	EXPECT(seg_eq(&m, 1, "at"), "prep=at");
	EXPECT(seg_eq(&m, 2, "jane the great"), "iobj=jane the great");
}

static void
test_match_obj_atom_player_fail(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj> <atom=to|at> <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "sword", &m), -1,
		"missing prep and iobj");
	EXPECT_EQ(verb_spec_match(&s, "sword with jane", &m), -1,
		"wrong prep");
	EXPECT_EQ(verb_spec_match(&s, "to jane", &m), -1,
		"missing dobj");
}

static void
test_match_bare_word_anchor(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj> to <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "sword to jane", &m), 0,
		"bare word anchor");
	EXPECT(seg_eq(&m, 0, "sword"), "dobj=sword");
	EXPECT(seg_eq(&m, 1, "to"), "prep=to");
	EXPECT(seg_eq(&m, 2, "jane"), "iobj=jane");
}

static void
test_match_any(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<any>", &s);

	EXPECT_EQ(verb_spec_match(&s, "hello world", &m), 0,
		"any matches text");
	EXPECT(seg_eq(&m, 0, "hello world"), "any seg=hello world");

	EXPECT_EQ(verb_spec_match(&s, "", &m), 0, "any matches empty");
	EXPECT_EQ(m.segs[0].len, 0, "any seg len=0");
}

static void
test_match_atom_any(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<atom=cast> <any>", &s);

	EXPECT_EQ(verb_spec_match(&s, "cast fireball", &m), 0,
		"atom+any");
	EXPECT(seg_eq(&m, 0, "cast"), "atom=cast");
	EXPECT(seg_eq(&m, 1, "fireball"), "any=fireball");

	EXPECT_EQ(verb_spec_match(&s, "cast", &m), 0,
		"atom+any, empty tail");
	EXPECT(seg_eq(&m, 0, "cast"), "atom=cast");
	EXPECT_EQ(m.segs[1].len, 0, "any seg len=0");

	EXPECT_EQ(verb_spec_match(&s, "heal fireball", &m), -1,
		"wrong atom");
}

static void
test_match_any_anchored(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<any> <atom=at> <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "fireball at jane", &m), 0,
		"any before anchor");
	EXPECT(seg_eq(&m, 0, "fireball"), "any=fireball");
	EXPECT(seg_eq(&m, 1, "at"), "atom=at");
	EXPECT(seg_eq(&m, 2, "jane"), "player=jane");

	EXPECT_EQ(verb_spec_match(&s, "at jane", &m), 0,
		"empty any before anchor");
	EXPECT_EQ(m.segs[0].len, 0, "any seg len=0");
}

static void
test_match_case_insensitive(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj> <atom=TO|AT> <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "sword to jane", &m), 0,
		"case insensitive lower");
	EXPECT_EQ(verb_spec_match(&s, "sword TO jane", &m), 0,
		"case insensitive upper");
	EXPECT_EQ(verb_spec_match(&s, "sword To jane", &m), 0,
		"case insensitive mixed");
}

static void
test_match_wildcard_atom(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<atom> <atom=at> <player>", &s);

	EXPECT_EQ(verb_spec_match(&s, "fireball at jane", &m), 0,
		"wildcard atom");
	EXPECT(seg_eq(&m, 0, "fireball"), "atom=fireball");
	EXPECT(seg_eq(&m, 1, "at"), "prep=at");
	EXPECT(seg_eq(&m, 2, "jane"), "player=jane");
}

static void
test_match_obj_obj(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<obj> <obj>", &s);

	EXPECT_EQ(verb_spec_match(&s, "sword shield", &m), 0,
		"obj obj two words");
	EXPECT(seg_eq(&m, 0, "sword"), "first=sword");
	EXPECT(seg_eq(&m, 1, "shield"), "second=shield");
}

static void
test_match_leftover_rejected(void)
{
	struct verb_spec s;
	struct verb_match m;
	verb_spec_parse("<atom=look>", &s);

	EXPECT_EQ(verb_spec_match(&s, "look", &m), 0, "exact match");
	EXPECT_EQ(verb_spec_match(&s, "look around", &m), -1,
		"leftover rejected");
}

/* ------------------------------------------------------------------ */

int
main(void)
{
	printf("%%%%%%%%%%%% START-TEST test_verb_spec\n");

	test_parse_empty();
	test_parse_typed_tokens();
	test_parse_atom_alternation();
	test_parse_bare_word();
	test_parse_bare_word_sugar();
	test_parse_any();
	test_parse_errors();

	test_match_empty();
	test_match_single_obj();
	test_match_obj_atom_player();
	test_match_obj_atom_player_fail();
	test_match_bare_word_anchor();
	test_match_any();
	test_match_atom_any();
	test_match_any_anchored();
	test_match_case_insensitive();
	test_match_wildcard_atom();
	test_match_obj_obj();
	test_match_leftover_rejected();

	printf("%%%%%%%%%%%% END-TEST test_verb_spec\n");
	printf("%d failures\n", failures);
	return failures ? 1 : 0;
}
