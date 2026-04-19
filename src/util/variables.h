/**
 * @file variables.h
 *
 * Variable expansion and quoting for strings.
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

#ifndef VARIABLES_H_
#define VARIABLES_H_

/**
 * maximum length of a variable name in $NAME or ${NAME}.
 */
#define VAR_MAXNAME 64

/**
 * lookup callback used by expand_string() for named variables.
 * return value is borrowed -- expand_string() copies what it needs
 * before the next call. return NULL for undefined names (expands to
 * empty string).
 */
typedef const char *(*var_lookup_fn)(void *user, const char *name);

/**
 * context passed to expand_string(). any field may be zero/NULL if
 * the caller does not want to supply that source.
 *
 * named variables     -- lookup(user, name). room descs, character
 *                        attrs, globals all go through the caller's
 *                        lookup.
 * positional $0-$9    -- argv[N] if 0 <= N < argc. argv[0] is the
 *                        command/alias name by convention.
 * $#                  -- number of argument words, i.e. argc-1
 *                        (clamped to >= 0).
 * $* and $@           -- argstr: the raw remainder after the command
 *                        word, preserved as a single string. if
 *                        argstr is NULL, these expand to empty.
 * $?                  -- last_status.
 * $$                  -- process id (no context needed).
 */
struct var_ctx {
	var_lookup_fn	lookup;
	void		*user;
	int		argc;
	const char *const *argv;
	const char	*argstr;
	int		last_status;
};

/**
 * sink used by expand_string_stream() to consume expanded output in
 * pieces. data is NOT nul-terminated -- len bytes exactly. return 0
 * to continue or non-zero to abort the expansion (the return value
 * bubbles back out of expand_string_stream()).
 */
typedef int (*expand_sink_fn)(void *user, const char *data, unsigned len);

/**
 * stream variable expansion and quoting through a sink callback.
 * no heap allocation: literal runs are passed through in batches and
 * variable values are forwarded as-is. ctx may be NULL. returns 0 on
 * success, or the first non-zero value the sink returned.
 *
 * quoting rules:
 *   '...'       literal, no expansion
 *   "..."       expand $vars, literal everything else
 *   \x          outside single quotes, copy x literally
 *
 * $(cmd) command substitution is NOT supported; a literal "$(" is
 * emitted and parsing continues.
 */
int expand_string_stream(const char *s, const struct var_ctx *ctx,
			 expand_sink_fn sink, void *user);

/**
 * convenience: expand into a malloc()'d, nul-terminated string. caller
 * must free(). returns NULL on allocation failure. prefer
 * expand_string_stream() when you already have an output buffer or
 * sink.
 */
char *expand_string(const char *s, const struct var_ctx *ctx);

#endif /* VARIABLES_H_ */
