/**
 * @file util.h
 *
 * Utility routines - fnmatch, load text files, string utilities
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Aug 17
 *
 * Copyright (c) 2009-2022 Jon Mayo <jon@rm-f.net>
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

#ifndef UTIL_H_
#define UTIL_H_
#include <stdio.h>

/** util_fnmatch returns this value when a match was not found. */
#define UTIL_FNM_NOMATCH 1

/** util_fnmatch accepts this as a paramter to perform case insensitive matches. */
#define UTIL_FNM_CASEFOLD 16

/** do file-like operations on a string. */
struct util_strfile {
	const char *buf; /** buffer holding the contents of the entire file. */
};

int util_fnmatch(const char *pattern, const char *string, int flags);
char *util_textfile_load(const char *filename);
const char *util_getword(const char *s, char *out, size_t outlen);
void util_strfile_open(struct util_strfile *h, const char *buf);
void util_strfile_close(struct util_strfile *h);
const char *util_strfile_readline(struct util_strfile *h, size_t *len);
void trim_nl(char *line);
char *trim_whitespace(char *line);
void util_hexdump(FILE *f, const void *data, int len);
#endif
