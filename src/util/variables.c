/**
 * @file variables.c
 *
 * Variable expansion and quoting for strings. See variables.h for the
 * public API and supported syntax.
 *
 * Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "variables.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

/* helper: emit a string value via the sink, tolerant of NULL. */
static int
sink_puts(expand_sink_fn sink, void *user, const char *v)
{
	if (!v || !*v) return 0;
	return sink(user, v, (unsigned)strlen(v));
}

/* emit the value of a named variable via the ctx lookup. undefined -> empty. */
static int
emit_named(expand_sink_fn sink, void *user,
	   const struct var_ctx *ctx, const char *name)
{
	if (!ctx || !ctx->lookup) return 0;
	return sink_puts(sink, user, ctx->lookup(ctx->user, name));
}

/* parse a name starting at *sp into name_buf; advances *sp past the name.
 * when braced != 0, the caller has already consumed '{' and the name ends
 * at '}' (which is also consumed). otherwise the name is [A-Za-z0-9_]*. */
static void
parse_name(const char **sp, char *name_buf, int braced)
{
	const char *s = *sp;
	const char *start = s;
	int len;

	if (braced) {
		while (*s && *s != '}') s++;
	} else {
		while (isalnum((unsigned char)*s) || *s == '_') s++;
	}

	len = (int)(s - start);
	if (len >= VAR_MAXNAME) len = VAR_MAXNAME - 1;
	memcpy(name_buf, start, (size_t)len);
	name_buf[len] = '\0';

	if (braced && *s == '}') s++;

	*sp = s;
}

/* handle everything after the leading '$'. returns 0 or the sink's
 * non-zero error code. */
static int
expand_dollar(expand_sink_fn sink, void *user, const char **sp,
	      const struct var_ctx *ctx)
{
	const char *s = *sp;
	char name_buf[VAR_MAXNAME];
	char num_buf[16];
	int rc = 0;

	if (*s == '?') {
		snprintf(num_buf, sizeof(num_buf), "%d",
			 ctx ? ctx->last_status : 0);
		rc = sink(user, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '$') {
		snprintf(num_buf, sizeof(num_buf), "%d", (int)getpid());
		rc = sink(user, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '#') {
		int n = 0;
		if (ctx && ctx->argc > 1) n = ctx->argc - 1;
		snprintf(num_buf, sizeof(num_buf), "%d", n);
		rc = sink(user, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '*' || *s == '@') {
		if (ctx) rc = sink_puts(sink, user, ctx->argstr);
		s++;
	} else if (*s >= '0' && *s <= '9') {
		int idx = *s - '0';
		s++;
		if (ctx && idx < ctx->argc && ctx->argv)
			rc = sink_puts(sink, user, ctx->argv[idx]);
	} else if (*s == '{') {
		s++;
		parse_name(&s, name_buf, 1);
		rc = emit_named(sink, user, ctx, name_buf);
	} else if (isalpha((unsigned char)*s) || *s == '_') {
		parse_name(&s, name_buf, 0);
		rc = emit_named(sink, user, ctx, name_buf);
	} else {
		/* bare '$' at end, or '$(' (unsupported): emit literal '$'
		 * and let the main loop pick up from the next char. */
		rc = sink(user, "$", 1);
	}

	*sp = s;
	return rc;
}

int
expand_string_stream(const char *s, const struct var_ctx *ctx,
		     expand_sink_fn sink, void *user)
{
	int quoting = 0;		/* 0 none, 1 single, 2 double */
	const char *run = NULL;		/* start of current literal run */
	int rc = 0;

	if (!s || !sink) return 0;

#define FLUSH() do {						\
		if (run) {					\
			rc = sink(user, run, (unsigned)(s - run)); \
			run = NULL;				\
			if (rc) goto out;			\
		}						\
	} while (0)

	while (*s) {
		if (*s == '\'' && quoting != 2) {
			FLUSH();
			quoting = (quoting == 1) ? 0 : 1;
			s++;
		} else if (*s == '"' && quoting != 1) {
			FLUSH();
			quoting = (quoting == 2) ? 0 : 2;
			s++;
		} else if (quoting == 1) {
			/* literal; include in run */
			if (!run) run = s;
			s++;
		} else if (*s == '\\' && s[1]) {
			FLUSH();
			s++;			/* skip the backslash */
			rc = sink(user, s, 1);	/* emit the escaped char */
			if (rc) goto out;
			s++;
		} else if (*s == '$') {
			FLUSH();
			s++;
			rc = expand_dollar(sink, user, &s, ctx);
			if (rc) goto out;
		} else {
			if (!run) run = s;
			s++;
		}
	}
	FLUSH();

#undef FLUSH

out:
	return rc;
}

/* growable output buffer used by expand_string(). */
struct out {
	char		*buf;
	unsigned	len;
	unsigned	cap;
	int		oom;
};

static int
out_sink(void *user, const char *data, unsigned n)
{
	struct out *o = user;
	unsigned need = o->len + n + 1;
	unsigned cap;
	char *p;

	if (need > o->cap) {
		cap = o->cap ? o->cap : 64;
		while (cap < need) cap *= 2;
		p = realloc(o->buf, cap);
		if (!p) { o->oom = 1; return -1; }
		o->buf = p;
		o->cap = cap;
	}
	memcpy(o->buf + o->len, data, n);
	o->len += n;
	return 0;
}

char *
expand_string(const char *s, const struct var_ctx *ctx)
{
	struct out o = { NULL, 0, 0, 0 };

	expand_string_stream(s, ctx, out_sink, &o);
	if (o.oom) { free(o.buf); return NULL; }

	/* ensure room for terminator (buffer may still be empty). */
	if (o.len + 1 > o.cap) {
		char *p = realloc(o.buf, o.len + 1);
		if (!p) { free(o.buf); return NULL; }
		o.buf = p;
	}
	o.buf[o.len] = '\0';
	return o.buf;
}
