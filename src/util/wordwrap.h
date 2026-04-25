/**
 * @file wordwrap.h
 *
 * Word wrapping with greedy and optimal (Knuth-Plass) algorithms.
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

#ifndef WORDWRAP_H_
#define WORDWRAP_H_

enum ww_style {
	WW_OPTIMAL, /* Knuth-Plass optimal line breaking */
	WW_GREEDY,  /* simple greedy break on whitespace */
};

struct ww_word {
	unsigned off;   /* byte offset into source string */
	unsigned len;   /* byte length */
	unsigned width; /* display width in cells */
};

/* tokenize input into words. allocates *words_out (caller frees).
 * returns word count, or -1 on error (sets errno). */
int ww_wordify(const char *input, unsigned inputlen,
               struct ww_word **words_out);

/* compute line break positions. breaks_out[i] is the word index
 * where line i starts. allocates *breaks_out (caller frees).
 * returns line count, or -1 on error (sets errno). */
int ww_wrap(const struct ww_word *words, unsigned nwords,
            unsigned line_width, enum ww_style style,
            unsigned **breaks_out);

#endif
