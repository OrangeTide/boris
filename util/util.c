/**
 * @file util.c
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

#include "util.h"
#define LOG_SUBSYSTEM "util"
#include "log.h"
#include "debug.h"

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/**
 * clone of the fnmatch() function.
 * Only supports flag UTIL_FNM_CASEFOLD.
 * @param pattern a shell wildcard pattern.
 * @param string string to compare against.
 * @param flags zero or UTIL_FNM_CASEFOLD for case-insensitive matches..
 * @return 0 on a match, UTIL_FNM_NOMATCH on failure.
 */
int
util_fnmatch(const char *pattern, const char *string, int flags)
{
	char c;

	while ((c = *pattern++)) switch(c) {
		case '?':
			if (*string++ == 0) return UTIL_FNM_NOMATCH;

			break;

		case '*':
			if (!*pattern) return 0; /* success */

			for (; *string; string++) {
				/* trace out any paths that match the first character */
				if (((flags & UTIL_FNM_CASEFOLD) ?  tolower(*string) == tolower(*pattern) : *string == *pattern) && util_fnmatch(pattern, string, flags) == 0) {
					return 0; /* recursive check matched */
				}
			}

			return UTIL_FNM_NOMATCH; /* none of the tested paths worked */
			break;

		case '[':
		case ']':
		case '\\':
			LOG_TODO("support [] and \\");

		/* fall through */
		default:
			if ((flags & UTIL_FNM_CASEFOLD) ? tolower(*string++) != tolower(c) : *string++ != c) return UTIL_FNM_NOMATCH;
		}

	if (*string) return UTIL_FNM_NOMATCH;

	return 0; /* success */
}

/**
 * read the contents of a text file into an allocated string.
 * @param filename
 * @return NULL on failure. A malloc'd string containing the file on success.
 */
char *
util_textfile_load(const char *filename)
{
	FILE *f;
	char *ret;
	long len;
	size_t res;

	f = fopen(filename, "r");

	if (!f) {
		LOG_PERROR(filename);
		goto failure0;
	}

	if (fseek(f, 0l, SEEK_END) != 0) {
		LOG_PERROR(filename);
		goto failure1;
	}

	len = ftell(f);

	if (len == EOF) {
		LOG_PERROR(filename);
		goto failure1;
	}

	assert(len >= 0); /* len must not be negative */

	if (fseek(f, 0l, SEEK_SET) != 0) {
		LOG_PERROR(filename);
		goto failure1;
	}

	ret = malloc((unsigned)len + 1);

	if (!ret) {
		LOG_PERROR(filename);
		goto failure1;
	}

	res = fread(ret, 1, (unsigned)len, f);

	if (ferror(f)) {
		LOG_PERROR(filename);
		goto failure2;
	} else if (res != (size_t)len) {
		LOG_ERROR("short read");
		goto failure2;
	}

	ret[len] = 0; /* null terminate the string */

	LOG_DEBUG("%s:loaded %ld bytes\n", filename, len);

	fclose(f);
	return ret;

failure2:
	free(ret);
failure1:
	fclose(f);
failure0:
	return 0; /* failure */
}

/**
 * copies a word into out, silently truncate word if it is too long.
 * return updated position of s.
 */
const char *
util_getword(const char *s, char *out, size_t outlen)
{
	const char *b, *e;

	/* get word */
	for (b = s; isspace(*b); b++) ;

	for (e = b; *e && !isspace(*e); e++) ;

	snprintf(out, outlen, "%.*s", (int)(e - b), b);
	b = e;

	if (*b) b++;

	return b;
}

/******************************************************************************
 * Util_strfile - utility routines for holding a file in one large string.
 ******************************************************************************/

/** initialize a util_strfile with a new string. */
void
util_strfile_open(struct util_strfile *h, const char *buf)
{
	assert(h != NULL);
	assert(buf != NULL);
	h->buf = buf;
}

/** clean up a util_strfile structure. */
void
util_strfile_close(struct util_strfile *h)
{
	h->buf = NULL;
}

/** read line from util_strfile, write length through len pointer.
 * line won't be null terminated or anything useful like that. this abstraction
 * just moves a pointer around.
 */
const char *
util_strfile_readline(struct util_strfile *h, size_t *len)
{
	const char *ret;

	assert(h != NULL);
	assert(h->buf != NULL);
	ret = h->buf;

	while (*h->buf && *h->buf != '\n') h->buf++;

	if (len)
		*len = h->buf - ret;

	if (*h->buf)
		h->buf++;

	return h->buf == ret ? NULL : ret; /* return EOF if the offset couldn't move forward */
}

/**
 * removes a trailing newline if one exists.
 * @param line the string to modify.
 */
void
trim_nl(char *line)
{
	line = strrchr(line, '\n');

	if (line) *line = 0;
}

/**
 * remove beginning and trailing whitespace.
 * @param line the string to modify.
 * @return pointer that may be offset into original string.
 */
char *
trim_whitespace(char *line)
{
	char *tmp;

	while (isspace(*line)) line++;

	for (tmp = line + strlen(line) - 1; line < tmp && isspace(*tmp); tmp--) *tmp = 0;

	return line;
}

/**
 * debug routine to hexdump some bytes.
 * @param f output file stream.
 * @param data pointer to the data.
 * @param len length to hexdump.
 */
void
util_hexdump(FILE *f, const void *data, int len)
{
	fprintf(f, "[%d]", len);

	while (len > 0) {
		unsigned char ch = *(unsigned char*)data;

		if (isprint(ch)) {
			fprintf(f, " '%c'", ch);
		} else {
			fprintf(f, " 0x%02hhx", ch);
		}

		len--;
		data = ((unsigned char*)data) + 1;
	}

	fprintf(f, "\n");
}
