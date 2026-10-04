/* stred.c : online string editor core (doc/string-editor-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "stred.h"

#include <ctype.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

struct stred {
	enum stred_mode mode;
	char *lines[STRED_MAX_LINES];
	unsigned nr_lines;
	int insert_at;			/* -1 = append; else insert index for next line */
	char *original;			/* seed value, never NULL */
	char result[STRED_BUF_MAX];	/* assembled on save */
	void (*out)(void *ctx, const char *text);
	void *ctx;
};

/* --- helpers --------------------------------------------------------- */

static void
emit(struct stred *s, const char *text)
{
	if (s->out)
		s->out(s->ctx, text);
}

static void
emitf(struct stred *s, const char *fmt, ...)
{
	char buf[STRED_LINE_MAX + 64];
	va_list ap;

	if (!s->out)
		return;
	va_start(ap, fmt);
	vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);
	s->out(s->ctx, buf);
}

static void
clear_lines(struct stred *s)
{
	unsigned i;

	for (i = 0; i < s->nr_lines; i++) {
		free(s->lines[i]);
		s->lines[i] = NULL;
	}
	s->nr_lines = 0;
}

/* Append or insert a content line. */
static void
add_line(struct stred *s, const char *text)
{
	char *dup;
	unsigned at;

	if (s->mode == STRED_SINGLE) {		/* one line: replace */
		clear_lines(s);
		if (!(dup = strdup(text)))
			return;
		s->lines[0] = dup;
		s->nr_lines = 1;
		return;
	}
	if (s->nr_lines >= STRED_MAX_LINES) {
		emit(s, "Buffer is full.");
		return;
	}
	if (!(dup = strdup(text)))
		return;
	at = (s->insert_at >= 0 && (unsigned)s->insert_at <= s->nr_lines)
		? (unsigned)s->insert_at : s->nr_lines;
	memmove(&s->lines[at + 1], &s->lines[at],
		(s->nr_lines - at) * sizeof s->lines[0]);
	s->lines[at] = dup;
	s->nr_lines++;
	s->insert_at = -1;			/* one-shot */
}

/* Split seed on '\n' into lines. */
static void
seed(struct stred *s, const char *current)
{
	const char *p = current;

	if (!current || !*current)
		return;
	if (s->mode == STRED_SINGLE) {
		add_line(s, current);		/* newlines collapsed to one line below */
		/* strip any newline for single-line */
		if (s->nr_lines) {
			char *nl = strchr(s->lines[0], '\n');
			if (nl)
				*nl = '\0';
		}
		return;
	}
	for (;;) {
		const char *nl = strchr(p, '\n');
		char tmp[STRED_LINE_MAX];
		size_t len = nl ? (size_t)(nl - p) : strlen(p);

		if (len >= sizeof tmp)
			len = sizeof tmp - 1;
		memcpy(tmp, p, len);
		tmp[len] = '\0';
		add_line(s, tmp);
		if (!nl)
			break;
		p = nl + 1;
	}
}

/* Assemble lines into result (joined by '\n'). Returns result. */
static const char *
assemble(struct stred *s)
{
	size_t off = 0;
	unsigned i;

	s->result[0] = '\0';
	for (i = 0; i < s->nr_lines; i++) {
		int n = snprintf(s->result + off, sizeof s->result - off,
			"%s%s", i ? "\n" : "", s->lines[i]);
		if (n < 0 || (size_t)n >= sizeof s->result - off)
			break;
		off += (size_t)n;
	}
	return s->result;
}

/* --- command set (spec 4) -------------------------------------------- */

enum cmd { C_SAVE, C_ABORT, C_CLEAR, C_REPLACE, C_LIST, C_FORMAT,
	C_HELP, C_DELETE, C_INSERT, C_NONE };

static const struct {
	char ch;
	const char *name;
	enum cmd id;
} commands[] = {
	{ 's', "save",    C_SAVE },
	{ 'a', "abort",   C_ABORT },
	{ 'c', "clear",   C_CLEAR },
	{ 'r', "replace", C_REPLACE },
	{ 'l', "list",    C_LIST },
	{ 'f', "format",  C_FORMAT },
	{ 'h', "help",    C_HELP },
	{ 'd', "delete",  C_DELETE },
	{ 'i', "insert",  C_INSERT },
};

/* Match a command word (without the leading '/'): a single-letter short form,
 * or an unambiguous prefix of a long form. Returns C_NONE if unknown. */
static enum cmd
match_cmd(const char *word)
{
	unsigned i;
	size_t len = strlen(word);
	enum cmd hit = C_NONE;

	if (len == 1) {
		for (i = 0; i < sizeof commands / sizeof commands[0]; i++)
			if (tolower((unsigned char)word[0]) == commands[i].ch)
				return commands[i].id;
		return C_NONE;
	}
	for (i = 0; i < sizeof commands / sizeof commands[0]; i++)
		if (strncasecmp(word, commands[i].name, len) == 0) {
			if (hit != C_NONE)
				return C_NONE;	/* ambiguous */
			hit = commands[i].id;
		}
	return hit;
}

static void
do_list(struct stred *s)
{
	unsigned i;

	if (!s->nr_lines) {
		emit(s, "(empty)");
		return;
	}
	for (i = 0; i < s->nr_lines; i++)
		emitf(s, "%3u: %s", i + 1, s->lines[i]);
}

static void
do_help(struct stred *s)
{
	emit(s, "String editor commands:");
	emit(s, "  /s save   /a abort   /c clear   /r replace");
	emit(s, "  /l list   /f format  /h help    /d <n> delete  /i <n> insert");
	emit(s, "  a line starting with // is content with one leading slash.");
}

/* Reflow multi-line paragraphs to 72 columns (blank line = paragraph break). */
static void
do_format(struct stred *s)
{
	char *words[STRED_MAX_LINES * 16];
	char *newlines[STRED_MAX_LINES];
	unsigned nr_new = 0, i;
	char line[80];
	size_t ll = 0;
	unsigned nw = 0;

	if (s->mode != STRED_MULTI)
		return;
	/* gather words, keeping blank lines as paragraph breaks */
	for (i = 0; i < s->nr_lines && nw < sizeof words / sizeof words[0]; i++) {
		char *tok, *save;
		char tmp[STRED_LINE_MAX];

		if (s->lines[i][0] == '\0') {
			words[nw++] = NULL;	/* paragraph break marker */
			continue;
		}
		snprintf(tmp, sizeof tmp, "%s", s->lines[i]);
		for (tok = strtok_r(tmp, " \t", &save); tok && nw < sizeof words / sizeof words[0];
			tok = strtok_r(NULL, " \t", &save))
			words[nw++] = strdup(tok);
	}
	/* rewrap */
	line[0] = '\0';
	for (i = 0; i < nw && nr_new < STRED_MAX_LINES; i++) {
		if (!words[i]) {		/* paragraph break */
			if (ll)
				newlines[nr_new++] = strdup(line);
			if (nr_new < STRED_MAX_LINES)
				newlines[nr_new++] = strdup("");
			line[0] = '\0';
			ll = 0;
			continue;
		}
		size_t wl = strlen(words[i]);
		if (ll && ll + 1 + wl > 72) {
			newlines[nr_new++] = strdup(line);
			line[0] = '\0';
			ll = 0;
		}
		ll += snprintf(line + ll, sizeof line - ll, "%s%s", ll ? " " : "",
			words[i]);
		free(words[i]);
	}
	if (ll && nr_new < STRED_MAX_LINES)
		newlines[nr_new++] = strdup(line);

	clear_lines(s);
	for (i = 0; i < nr_new; i++)
		s->lines[i] = newlines[i];
	s->nr_lines = nr_new;
	emit(s, "Reflowed.");
}

/* Handle a '/' command line. Returns the resulting status. */
static enum stred_status
do_command(struct stred *s, const char *line)
{
	char word[32];
	const char *arg;
	size_t wl;
	enum cmd c;

	line++;				/* skip '/' */
	wl = strcspn(line, " \t");
	if (wl >= sizeof word)
		wl = sizeof word - 1;
	memcpy(word, line, wl);
	word[wl] = '\0';
	arg = line + wl;
	while (*arg == ' ' || *arg == '\t')
		arg++;

	c = match_cmd(word);
	switch (c) {
	case C_SAVE:
		assemble(s);
		return STRED_SAVED;
	case C_ABORT:
		return STRED_ABORTED;
	case C_CLEAR:
	case C_REPLACE:
		clear_lines(s);
		s->insert_at = -1;
		emit(s, c == C_CLEAR ? "Cleared." : "Replaced -- start fresh.");
		return STRED_CONTINUE;
	case C_LIST:
		do_list(s);
		return STRED_CONTINUE;
	case C_FORMAT:
		do_format(s);
		return STRED_CONTINUE;
	case C_HELP:
		do_help(s);
		return STRED_CONTINUE;
	case C_DELETE: {
		unsigned n = (unsigned)atoi(arg);
		if (s->mode != STRED_MULTI || n < 1 || n > s->nr_lines) {
			emit(s, "Usage: /d <line number>");
			return STRED_CONTINUE;
		}
		free(s->lines[n - 1]);
		memmove(&s->lines[n - 1], &s->lines[n],
			(s->nr_lines - n) * sizeof s->lines[0]);
		s->nr_lines--;
		return STRED_CONTINUE;
	}
	case C_INSERT: {
		unsigned n = (unsigned)atoi(arg);
		if (s->mode != STRED_MULTI || n < 1 || n > s->nr_lines + 1) {
			emit(s, "Usage: /i <line number>");
			return STRED_CONTINUE;
		}
		s->insert_at = (int)(n - 1);	/* next content line inserts here */
		emitf(s, "Next line inserts before line %u.", n);
		return STRED_CONTINUE;
	}
	default:
		emitf(s, "Unknown command \"/%s\"; /h for help.", word);
		return STRED_CONTINUE;
	}
}

/* --- public core ----------------------------------------------------- */

struct stred *
stred_new(const char *current, enum stred_mode mode,
	void (*out)(void *ctx, const char *text), void *ctx)
{
	struct stred *s = calloc(1, sizeof *s);

	if (!s)
		return NULL;
	s->mode = mode;
	s->insert_at = -1;
	s->out = out;
	s->ctx = ctx;
	s->original = strdup(current ? current : "");
	if (!s->original) {
		free(s);
		return NULL;
	}
	seed(s, current);
	return s;
}

void
stred_free(struct stred *s)
{
	if (!s)
		return;
	clear_lines(s);
	free(s->original);
	free(s);
}

enum stred_status
stred_feed(struct stred *s, const char *line)
{
	if (line[0] == '/') {
		if (line[1] == '/') {		/* // -> literal content with one / */
			add_line(s, line + 1);
			return STRED_CONTINUE;
		}
		return do_command(s, line);
	}
	add_line(s, line);
	return STRED_CONTINUE;
}

const char *
stred_result(struct stred *s)
{
	return s->result;
}

const char *
stred_original(struct stred *s)
{
	return s->original;
}

int
stred_changed(struct stred *s)
{
	return strcmp(assemble(s), s->original) != 0;
}
