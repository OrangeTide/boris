/* verb_spec.h : typed verb argument pattern matching
 * PUBLIC DOMAIN (CC0-1.0) */
#ifndef VERB_SPEC_H_
#define VERB_SPEC_H_

#define VERB_SPEC_MAX_TOKENS 8
#define VERB_SPEC_MAX_ATOMS 8
#define VERB_SPEC_BUF_MAX 256

enum verb_token_type {
	VTOK_OBJ,	/* <obj> -- match object name in scope */
	VTOK_PLAYER,	/* <player> -- match player name */
	VTOK_ATOM,	/* <atom>, <atom=x>, <atom=x|y>, or bare word */
	VTOK_ANY,	/* <any> -- match remaining text */
};

struct verb_token {
	enum verb_token_type type;
	int natoms;
	char *atoms[VERB_SPEC_MAX_ATOMS];
};

struct verb_spec {
	int ntokens;
	struct verb_token tokens[VERB_SPEC_MAX_TOKENS];
	char buf[VERB_SPEC_BUF_MAX];
};

struct verb_match_seg {
	const char *str;
	int len;
};

struct verb_match {
	int nsegs;
	struct verb_match_seg segs[VERB_SPEC_MAX_TOKENS];
};

/*
 * Parse a verb argument spec string into a verb_spec structure.
 *
 * Spec language:
 *   <obj>           match an object name (one or more words)
 *   <player>        match a player name (one or more words)
 *   <atom>          match any single word
 *   <atom=word>     match a specific word (case-insensitive)
 *   <atom=a|b|c>    match any of the listed words
 *   <any>           match all remaining text (may be empty)
 *   bareword        sugar for <atom=bareword>
 *
 * Returns 0 on success, -1 on parse error.
 */
int verb_spec_parse(const char *spec, struct verb_spec *out);

/*
 * Match an input string against a parsed verb spec.
 *
 * On success, out->segs[i] contains the matched substring for each
 * token (pointer + length into the input string, not NUL-terminated).
 *
 * Returns 0 on match, -1 on mismatch.
 */
int verb_spec_match(const struct verb_spec *spec, const char *input,
	struct verb_match *out);

#endif
