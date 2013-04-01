/**
 * @file util.h
 *
 * Utility routines
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2013 Apr 1
 *
 * Copyright 2009-2013 Jon Mayo
 * Ms-RL : See COPYING.txt for complete license text.
 *
 */
#ifndef UTIL_H
#define UTIL_H

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
#endif
