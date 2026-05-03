/* verb_spec.c : typed verb argument pattern matching
 * Made by a machine. PUBLIC DOMAIN (CC0-1.0) */
#include "verb_spec.h"

#include <ctype.h>
#include <string.h>

static const char *
skip_spaces(const char *p)
{
	while (*p && isspace((unsigned char)*p))
		p++;
	return p;
}

static const char *
word_end(const char *p)
{
	while (*p && !isspace((unsigned char)*p))
		p++;
	return p;
}

static int
atom_matches(const struct verb_token *tok, const char *word, int wlen)
{
	for (int i = 0; i < tok->natoms; i++) {
		int alen = (int)strlen(tok->atoms[i]);
		if (alen == wlen &&
		    strncasecmp(word, tok->atoms[i], (size_t)wlen) == 0)
			return 1;
	}
	return 0;
}

static int
parse_typed_token(char *p, char *end, struct verb_token *tok)
{
	*end = '\0';

	char *eq = strchr(p, '=');
	char *type_str = p;
	char *vals = NULL;

	if (eq) {
		*eq = '\0';
		vals = eq + 1;
	}

	if (strcmp(type_str, "obj") == 0)
		tok->type = VTOK_OBJ;
	else if (strcmp(type_str, "player") == 0)
		tok->type = VTOK_PLAYER;
	else if (strcmp(type_str, "atom") == 0)
		tok->type = VTOK_ATOM;
	else if (strcmp(type_str, "any") == 0)
		tok->type = VTOK_ANY;
	else
		return -1;

	if (vals && tok->type == VTOK_ATOM) {
		char *v = vals;
		while (*v) {
			if (tok->natoms >= VERB_SPEC_MAX_ATOMS)
				return -1;
			tok->atoms[tok->natoms++] = v;
			char *pipe = strchr(v, '|');
			if (!pipe)
				break;
			*pipe = '\0';
			v = pipe + 1;
		}
	}

	return 0;
}

int
verb_spec_parse(const char *spec, struct verb_spec *out)
{
	memset(out, 0, sizeof(*out));

	if (!spec || !*spec)
		return 0;

	size_t len = strlen(spec);
	if (len >= VERB_SPEC_BUF_MAX)
		return -1;
	memcpy(out->buf, spec, len + 1);

	char *p = out->buf;
	while (*p) {
		while (*p && isspace((unsigned char)*p))
			p++;
		if (!*p)
			break;

		if (out->ntokens >= VERB_SPEC_MAX_TOKENS)
			return -1;

		struct verb_token *tok = &out->tokens[out->ntokens];

		if (*p == '<') {
			p++;
			char *end = strchr(p, '>');
			if (!end)
				return -1;
			if (parse_typed_token(p, end, tok) < 0)
				return -1;
			p = end + 1;
		} else {
			tok->type = VTOK_ATOM;
			tok->atoms[0] = p;
			tok->natoms = 1;
			while (*p && !isspace((unsigned char)*p))
				p++;
			if (*p) {
				*p = '\0';
				p++;
			}
		}

		out->ntokens++;
	}

	return 0;
}

static int
is_anchor(const struct verb_token *tok)
{
	return tok->type == VTOK_ATOM && tok->natoms > 0;
}

int
verb_spec_match(const struct verb_spec *spec, const char *input,
	struct verb_match *out)
{
	memset(out, 0, sizeof(*out));

	const char *pos = skip_spaces(input);

	if (spec->ntokens == 0)
		return *pos == '\0' ? 0 : -1;

	for (int i = 0; i < spec->ntokens; i++) {
		const struct verb_token *tok = &spec->tokens[i];
		pos = skip_spaces(pos);

		switch (tok->type) {
		case VTOK_ATOM: {
			if (!*pos)
				return -1;
			const char *we = word_end(pos);
			int wlen = (int)(we - pos);
			if (tok->natoms > 0 && !atom_matches(tok, pos, wlen))
				return -1;
			out->segs[i].str = pos;
			out->segs[i].len = wlen;
			pos = we;
			break;
		}

		case VTOK_OBJ:
		case VTOK_PLAYER: {
			if (!*pos)
				return -1;
			int next_anchor = -1;
			if (i + 1 < spec->ntokens &&
			    is_anchor(&spec->tokens[i + 1]))
				next_anchor = i + 1;

			if (next_anchor >= 0) {
				const struct verb_token *anch =
					&spec->tokens[next_anchor];
				const char *scan = pos;
				const char *found = NULL;
				while (*scan) {
					scan = skip_spaces(scan);
					if (!*scan)
						break;
					const char *we = word_end(scan);
					int wlen = (int)(we - scan);
					if (atom_matches(anch, scan, wlen)) {
						found = scan;
						break;
					}
					scan = we;
				}
				if (!found || found == pos)
					return -1;
				const char *seg_end = found;
				while (seg_end > pos &&
				       isspace((unsigned char)seg_end[-1]))
					seg_end--;
				out->segs[i].str = pos;
				out->segs[i].len = (int)(seg_end - pos);
				pos = found;
			} else if (i == spec->ntokens - 1) {
				const char *end = pos + strlen(pos);
				while (end > pos &&
				       isspace((unsigned char)end[-1]))
					end--;
				if (end == pos)
					return -1;
				out->segs[i].str = pos;
				out->segs[i].len = (int)(end - pos);
				pos = end;
			} else {
				const char *we = word_end(pos);
				out->segs[i].str = pos;
				out->segs[i].len = (int)(we - pos);
				pos = we;
			}
			break;
		}

		case VTOK_ANY: {
			int next_anchor = -1;
			if (i + 1 < spec->ntokens &&
			    is_anchor(&spec->tokens[i + 1]))
				next_anchor = i + 1;

			if (next_anchor >= 0) {
				const struct verb_token *anch =
					&spec->tokens[next_anchor];
				const char *scan = pos;
				const char *found = NULL;
				while (*scan) {
					scan = skip_spaces(scan);
					if (!*scan)
						break;
					const char *we = word_end(scan);
					int wlen = (int)(we - scan);
					if (atom_matches(anch, scan, wlen)) {
						found = scan;
						break;
					}
					scan = we;
				}
				if (!found)
					return -1;
				const char *seg_end = found;
				while (seg_end > pos &&
				       isspace((unsigned char)seg_end[-1]))
					seg_end--;
				out->segs[i].str = pos;
				out->segs[i].len = (int)(seg_end - pos);
				pos = found;
			} else if (i == spec->ntokens - 1) {
				const char *end = pos + strlen(pos);
				while (end > pos &&
				       isspace((unsigned char)end[-1]))
					end--;
				out->segs[i].str = pos;
				out->segs[i].len = (int)(end - pos);
				pos = end;
			} else {
				const char *we = word_end(pos);
				out->segs[i].str = pos;
				out->segs[i].len = (int)(we - pos);
				pos = we;
			}
			break;
		}
		}
	}

	out->nsegs = spec->ntokens;
	pos = skip_spaces(pos);
	return *pos == '\0' ? 0 : -1;
}
