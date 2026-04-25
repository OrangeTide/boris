/**
 * @file wordwrap.c
 *
 * Word wrapping with greedy and optimal (Knuth-Plass) algorithms.
 *
 * The optimal algorithm uses dynamic programming to minimize total
 * squared slack across all lines, following the approach described in
 * Knuth & Plass, "Breaking Paragraphs into Lines" (1981).
 * For monospace text the glue stretch/shrink terms vanish, leaving a
 * clean DP over word indices with cost = sum of slack^2 per line.
 * The last line is exempt from penalty (as in TeX).
 *
 * Reference: https://github.com/jaroslov/knuth-plass-thoughts/blob/master/plass.md
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2026 Apr 24
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

#include "wordwrap.h"

#include <ctype.h>
#include <errno.h>
#include <float.h>
#include <stdlib.h>

int
ww_wordify(const char *input, unsigned inputlen, struct ww_word **words_out)
{
	if (!input || !words_out) {
		errno = EINVAL;
		return -1;
	}

	*words_out = NULL;

	if (inputlen == 0)
		return 0;

	unsigned nwords = 0;
	unsigned i = 0;

	while (i < inputlen) {
		while (i < inputlen && isspace((unsigned char)input[i]))
			i++;
		if (i >= inputlen)
			break;
		nwords++;
		while (i < inputlen && !isspace((unsigned char)input[i]))
			i++;
	}

	if (nwords == 0)
		return 0;

	struct ww_word *words = malloc(nwords * sizeof *words);
	if (!words)
		return -1;

	unsigned w = 0;

	i = 0;
	while (i < inputlen) {
		while (i < inputlen && isspace((unsigned char)input[i]))
			i++;
		if (i >= inputlen)
			break;
		unsigned start = i;
		while (i < inputlen && !isspace((unsigned char)input[i]))
			i++;
		words[w].off = start;
		words[w].len = i - start;
		words[w].width = i - start;
		w++;
	}

	*words_out = words;
	return (int)nwords;
}

static int
wrap_greedy(const struct ww_word *words, unsigned nwords,
            unsigned line_width, unsigned **breaks_out)
{
	unsigned *breaks = malloc(nwords * sizeof *breaks);
	if (!breaks)
		return -1;

	breaks[0] = 0;
	unsigned nlines = 1;
	unsigned cur = words[0].width;

	for (unsigned i = 1; i < nwords; i++) {
		if (cur + 1 + words[i].width > line_width) {
			breaks[nlines++] = i;
			cur = words[i].width;
		} else {
			cur += 1 + words[i].width;
		}
	}

	*breaks_out = breaks;
	return (int)nlines;
}

static int
wrap_optimal(const struct ww_word *words, unsigned nwords,
             unsigned line_width, unsigned **breaks_out)
{
	double *cost = malloc((nwords + 1) * sizeof *cost);
	unsigned *from = malloc((nwords + 1) * sizeof *from);

	if (!cost || !from) {
		free(cost);
		free(from);
		return -1;
	}

	cost[0] = 0.0;
	from[0] = 0;

	for (unsigned j = 1; j <= nwords; j++) {
		cost[j] = DBL_MAX;
		from[j] = j - 1;
		unsigned w = 0;

		for (unsigned i = j; i-- > 0; ) {
			if (w > 0)
				w += 1;
			w += words[i].width;

			if (w > line_width) {
				if (i + 1 == j) {
					cost[j] = cost[i];
					from[j] = i;
				}
				break;
			}

			double slack = (double)(line_width - w);
			double lc = (j == nwords) ? 0.0 : slack * slack;
			double total = cost[i] + lc;

			if (total < cost[j]) {
				cost[j] = total;
				from[j] = i;
			}
		}
	}

	unsigned nlines = 0;

	for (unsigned idx = nwords; idx > 0; idx = from[idx])
		nlines++;

	unsigned *breaks = malloc(nlines * sizeof *breaks);
	if (!breaks) {
		free(cost);
		free(from);
		return -1;
	}

	unsigned idx = nwords;

	for (unsigned k = nlines; k-- > 0; ) {
		idx = from[idx];
		breaks[k] = idx;
	}

	free(cost);
	free(from);
	*breaks_out = breaks;
	return (int)nlines;
}

int
ww_wrap(const struct ww_word *words, unsigned nwords,
        unsigned line_width, enum ww_style style,
        unsigned **breaks_out)
{
	if (!breaks_out) {
		errno = EINVAL;
		return -1;
	}

	*breaks_out = NULL;

	if (nwords == 0 || line_width == 0)
		return 0;

	switch (style) {
	case WW_GREEDY:
		return wrap_greedy(words, nwords, line_width, breaks_out);
	case WW_OPTIMAL:
		return wrap_optimal(words, nwords, line_width, breaks_out);
	}

	errno = EINVAL;
	return -1;
}
