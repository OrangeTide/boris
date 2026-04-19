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

/* growable output buffer used while building the expansion. */
struct out {
	char		*buf;
	unsigned	len;	/* bytes used, not counting terminator */
	unsigned	cap;
};

static int
out_reserve(struct out *o, unsigned extra)
{
	unsigned need = o->len + extra + 1;
	unsigned cap;
	char *p;

	if (need <= o->cap) return 0;

	cap = o->cap ? o->cap : 64;
	while (cap < need) cap *= 2;

	p = realloc(o->buf, cap);
	if (!p) return -1;

	o->buf = p;
	o->cap = cap;
	return 0;
}

static int
out_putc(struct out *o, char c)
{
	if (out_reserve(o, 1) < 0) return -1;
	o->buf[o->len++] = c;
	return 0;
}

static int
out_puts(struct out *o, const char *s, unsigned n)
{
	if (!s || n == 0) return 0;
	if (out_reserve(o, n) < 0) return -1;
	memcpy(o->buf + o->len, s, n);
	o->len += n;
	return 0;
}

/* emit the value of a named variable via the ctx lookup. undefined -> empty. */
static int
emit_named(struct out *o, const struct var_ctx *ctx, const char *name)
{
	const char *v;

	if (!ctx || !ctx->lookup) return 0;
	v = ctx->lookup(ctx->user, name);
	if (!v) return 0;
	return out_puts(o, v, strlen(v));
}

/* parse a name starting at *sp into name_buf; advances *sp past the name.
 * supports ${NAME} (already past the '{') and bare $NAME forms; caller
 * decides which by passing braced != 0 when it has consumed the '{'. */
static int
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
	return len;
}

/* handle everything after the leading '$'. returns 0 on success, -1 on OOM. */
static int
expand_dollar(struct out *o, const char **sp, const struct var_ctx *ctx)
{
	const char *s = *sp;
	char name_buf[VAR_MAXNAME];
	char num_buf[16];
	int rc = 0;

	if (*s == '?') {
		snprintf(num_buf, sizeof(num_buf), "%d",
			 ctx ? ctx->last_status : 0);
		rc = out_puts(o, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '$') {
		snprintf(num_buf, sizeof(num_buf), "%d", (int)getpid());
		rc = out_puts(o, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '#') {
		int n = 0;
		if (ctx && ctx->argc > 1) n = ctx->argc - 1;
		snprintf(num_buf, sizeof(num_buf), "%d", n);
		rc = out_puts(o, num_buf, (unsigned)strlen(num_buf));
		s++;
	} else if (*s == '*' || *s == '@') {
		if (ctx && ctx->argstr)
			rc = out_puts(o, ctx->argstr,
				      (unsigned)strlen(ctx->argstr));
		s++;
	} else if (*s >= '0' && *s <= '9') {
		int idx = *s - '0';
		s++;
		if (ctx && idx < ctx->argc && ctx->argv && ctx->argv[idx])
			rc = out_puts(o, ctx->argv[idx],
				      (unsigned)strlen(ctx->argv[idx]));
	} else if (*s == '{') {
		s++;
		parse_name(&s, name_buf, 1);
		rc = emit_named(o, ctx, name_buf);
	} else if (isalpha((unsigned char)*s) || *s == '_') {
		parse_name(&s, name_buf, 0);
		rc = emit_named(o, ctx, name_buf);
	} else {
		/* bare '$' with nothing to expand, or $(cmd) (unsupported):
		 * emit literal '$' and let the main loop consume the next
		 * character normally. */
		rc = out_putc(o, '$');
	}

	*sp = s;
	return rc;
}

char *
expand_string(const char *s, const struct var_ctx *ctx)
{
	struct out o = { NULL, 0, 0 };
	int quoting = 0;	/* 0 none, 1 single, 2 double */
	int rc = 0;

	if (!s) s = "";

	while (*s && rc == 0) {
		if (*s == '\'' && quoting != 2) {
			quoting = (quoting == 1) ? 0 : 1;
			s++;
		} else if (*s == '"' && quoting != 1) {
			quoting = (quoting == 2) ? 0 : 2;
			s++;
		} else if (quoting == 1) {
			rc = out_putc(&o, *s++);
		} else if (*s == '\\' && s[1]) {
			s++;
			rc = out_putc(&o, *s++);
		} else if (*s == '$') {
			s++;
			rc = expand_dollar(&o, &s, ctx);
		} else {
			rc = out_putc(&o, *s++);
		}
	}

	if (rc == 0) rc = out_reserve(&o, 0);
	if (rc < 0) {
		free(o.buf);
		return NULL;
	}
	o.buf[o.len] = '\0';
	return o.buf;
}
