/**
 * @file util.h
 *
 * Utility routines - fnmatch, load text files, string utilities
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Nov 21
 *
 * Copyright (c) 2009-2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
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
