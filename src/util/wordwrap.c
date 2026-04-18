/**
 * @file wordwrap.c
 *
 * Utility routines - wordwarp
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2026 Mar 23
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
#include <errno.h>

/* design of wordwrap()
 *
 * inputs:
 * - list of word widths
 * - an array of desired line widths for non-rectangular shapes (can we repeat this shape as a general case so that a single line width provides a rectangular shape)
 *
 * outputs:
 * - list of lines indicating the starting word on each line.
 * - optionally: width of each line.
 *
 */

/* design of wordify()
 *
 * utility function to break a string up into words (assumes monospace cell width)
 *
 * inputs:
 * - input string
 *
 * outputs:
 * - list of indexes into string for word start, and word widths
 *
 */

struct wordwrap_info {
    // TODO: rework these members
    char **lines;
    unsigned linecount;
};

/** wordwrap function. expects an initialized wordwrap_info struct and updates
 * it with results. return WORDWRAP_OK on success, WORDWRAP_ERR on failure and
 * sets errno. */
int
wordwrap(const char *input, struct wordwrap_info *ww_info_in_out)
{
    // TODO: change the parameters
    // TODO: implement this
}

// TODO: cite our research
// https://github.com/jaroslov/knuth-plass-thoughts/blob/master/plass.md
