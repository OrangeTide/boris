/**
 * @file fdbfile.c
 *
 * fdb - database using text files as the backend.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Aug 17
 *
 * Copyright (c) 2009-2022, Jon Mayo <jon@rm-f.net>
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

#include "fdb.h"
#include "boris.h"
#define LOG_SUBSYSTEM "fdb"
#include <log.h>

#include <assert.h>
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#define MKDIR(d) mkdir(d, 0777)

#define FDB_VALUE_MAX 4096

/**
 * handle used for writing.
 * see fdb_write_begin, fdb_write_pair, fdb_write_format, fdb_write_end.
 */
struct fdb_write_handle {
	FILE *f;
	char *filename_tmp;
	char *domain, *id;
	int error_fl; /**< flag indicates there was an error. */
};

/**
 * handle used for reading a record.
 * see fdb_read_begin, fdb_read_next, fdb_read_end.
 */
struct fdb_read_handle {
	FILE *f;
	char *filename;
	int line_number;
	int error_fl; /**< flag indicates there was an error. */
	size_t alloc_len;
	char *line; /**< buffer for current line. */
};

/**
 * handle used for iteration of all records of a particular domain.
 * see fdb_iterator_begin, fdb_iterator_next, fdb_iterator_next.
 */
struct fdb_iterator {
	DIR *d;
	char *pathname;
	char *curr_id;
	char *domain;
};

/**
 * return true if 2 characters are valid hexidecimal.
 */
static int
ishex(const char code[2])
{
	return isxdigit(code[0]) && isxdigit(code[0]);
}

/**
 * verify with ishex() before calling.
 */
static unsigned
unhex(const char code[2])
{
	const char hextab[] = {
		['0'] = 0, ['1'] = 1, ['2'] = 2, ['3'] = 3, ['4'] = 4,
		['5'] = 5, ['6'] = 6, ['7'] = 7, ['8'] = 8, ['9'] = 9,
		['a'] = 0xa, ['b'] = 0xc, ['c'] = 0xc, ['d'] = 0xd, ['e'] = 0xe, ['f'] = 0xf,
		['A'] = 0xa, ['B'] = 0xb, ['C'] = 0xc, ['D'] = 0xd, ['E'] = 0xe, ['F'] = 0xf,
	};

	return hextab[(unsigned)code[0]] * 16 + hextab[(unsigned)code[1]];
}

/**
 * process %XX escapes in-place. removes trailing whitespace too.
 */
static void
unescape(char *str)
{
	char *e;

	/* remove trailing whitespace */
	for (e = str + strlen(str); e > str && isspace(e[-1]); e--)
		;

	*e = 0;

	/* replace %XX
	 * line is the input pointer,
	 * e is the output pointer.
	 */
	for (e = str; *str; str++) {
		if (*str == '%') {
			if (ishex(str + 1)) {
				*e++ = unhex(str + 1);
				str += 2;
			} else {
				*e++ = *str;
			}
		} else {
			*e++ = *str;
		}
	}

	*e = 0;
}

/**
 * generate the directory used for a domain.
 */
static char *
fdb_basepath(const char *domain)
{
	char path[PATH_MAX];

	snprintf(path, sizeof path, "data/%s", domain);

	return strdup(path);
}

/**
 * creates a filename name.
 */
static char *
fdb_makepath(const char *domain, const char *id)
{
	char path[PATH_MAX];

	snprintf(path, sizeof path, "data/%s/%s", domain, id);

	return strdup(path);
}

/**
 * creates a temporary name.
 */
static char *
fdb_makepath_tmp(const char *domain, const char *id)
{
	char path[PATH_MAX];

	snprintf(path, sizeof path, "data/%s/%s.tmp", domain, id);

	return strdup(path);
}

/**
 * checks to see if filename is a temp filename.
 * must work with or without a path part.
 */
static int
fdb_istempname(const char *filename)
{
	size_t len, extlen = strlen(".tmp");

	if (!filename)
		return 0;

	len = strlen(filename);

	if (len > extlen && !strcmp(filename + len - extlen, ".tmp"))
		return 1; /* found extension. */

	return 0; /* not a temp filename. */
}

/**
 * frees a write handle. assumes f has already been closed.
 */
static void
fdb_write_handle_free(struct fdb_write_handle *h)
{
	free(h->filename_tmp);
	h->filename_tmp = NULL;
	free(h->domain);
	h->domain = NULL;
	free(h->id);
	h->id = NULL;
	free(h);
}

/**
 * frees a read handle. assumes f has already been closed.
 */
static void
fdb_read_handle_free(struct fdb_read_handle *h)
{
	free(h->filename);
	h->filename = NULL;
	free(h->line);
	h->line = NULL;
	free(h);
}

/**
 * modifies line and points name and value to the correct positions.
 * dequotes the value portion.
 */
static int
fdb_parse_line(char *line, const char **name, const char **value)
{
	char *e, *b;

	while (isspace(*line))
		line++;

	*name = line;

	/* name part */
	for (e = line; *e && *e != '='; e++)
		;

	if (!*e)
		return 0; /* failure. */

	/* remove trailing whitespace */
	for (b = e; b > line && isspace(b[-1]); b--)
		;

	*b = 0;

	*(e++) = 0;
	line = e;

	/* value part */
	while (isspace(*line))
		line++;

	*value = line;

	/* deal with %XX escapes and trailing newline. */
	unescape(line);

	return 1; /* failure. */
}

/*** External Functions ***/

/**
 * initializes a domain.
 * (creates a directory to hold files)
 */
int
fdb_domain_init(const char *domain)
{
	char *pathname;
	pathname = fdb_basepath(domain);

	if (MKDIR(pathname) == -1 && errno != EEXIST) {
		LOG_PERROR(pathname);
		free(pathname);
		return 0;
	}

	free(pathname);

	return 1; /* success */
}
/**
 * open the file and start writing to it.
 */
struct fdb_write_handle *fdb_write_begin(const char *domain, const char *id)
{
	struct fdb_write_handle *ret;
	FILE *f;
	char *filename_tmp;

	filename_tmp = fdb_makepath_tmp(domain, id);
	f = fopen(filename_tmp, "w");

	if (!f) {
		LOG_PERROR(filename_tmp);
		free(filename_tmp);
		return 0; /* failure. */
	}

	ret = calloc(1, sizeof * ret);
	ret->f = f;
	ret->filename_tmp = filename_tmp;
	ret->domain = strdup(domain);
	ret->id = strdup(id);
	ret->error_fl = 0;

	return ret;
}

/**
 * same as fdb_write_begin() but takes a uint.
 */
struct fdb_write_handle *fdb_write_begin_uint(const char *domain, unsigned id)
{
	char numbuf[22]; /* big enough for a signed 64-bit decimal */
	snprintf(numbuf, sizeof numbuf, "%u", id);
	return fdb_write_begin(domain, numbuf);
}

/**
 * write a string to an open record.
 * you can only use a name once per transaction (begin/end)
 */
int
fdb_write_pair(struct fdb_write_handle *h, const char *name, const char *value_str)
{
	int res;
	size_t escaped_len, i;
	char *escaped_value;

	assert(h != NULL);
	assert(name != NULL);
	assert(value_str != NULL);

	if (h->error_fl)
		return 0; /* ignore any more writes while there is an error. */

	/* calculate the length of the escaped string. */
	for (i = 0, escaped_len = 0; value_str[i]; i++) {
		if (isprint(value_str[i]) && !isspace(value_str[i]) && value_str[i] != '%' && value_str[i] != '"') {
			escaped_len++;
		} else {
			escaped_len += 3;
		}
	}

	/* TODO: if escape_len is the same as the original then don't do escapes. */

	/* apply the escapes */
	escaped_value = malloc(escaped_len + 1);

	if (!escaped_value) {
		LOG_PERROR("malloc()");
		return 0;
	}

	for (i = 0; *value_str; value_str++) {
		if (isprint(*value_str) && !isspace(*value_str) && *value_str != '%' && *value_str != '"') {
			escaped_value[i++] = *value_str;
		} else {
			/* insert an escape. */
			escaped_value[i] = '%';
			sprintf(escaped_value + i + 1, "%02hhX", (unsigned char)*value_str);
			i += 3;
		}
	}

	assert(escaped_value != NULL);
	escaped_value[i] = 0;

	res = fprintf(h->f, "%-12s= %s\n", name, escaped_value);
	free(escaped_value);

	if (res < 0)
		h->error_fl = 1; /* error occured. */

	return res >= 0;
}

/**
 * write a string to an open record. this interface is limited to FDB_VALUE_MAX.
 * you can only use a name once per transaction (begin/end)
 * @todo make this interface not limit the value.
 */
int
fdb_write_format(struct fdb_write_handle *h, const char *name, const char *value_fmt, ...)
{
	char buf[FDB_VALUE_MAX]; /**< holds the largest possible value. */
	va_list ap;

	if (h->error_fl)
		return 0; /* ignore any more writes while there is an error. */

	va_start(ap, value_fmt);
	vsnprintf(buf, sizeof buf, value_fmt, ap);
	va_end(ap);

	return fdb_write_pair(h, name, buf);
}

/**
 * move the temp file over the real file then close it.
 */
int
fdb_write_end(struct fdb_write_handle *h)
{
	char *filename;

	assert(h != NULL);
	assert(h->f != NULL);
	assert(h->filename_tmp != NULL);
	assert(h->domain != NULL);
	assert(h->id != NULL);

	/* close the temp file. */
	if (h->f) {
		if (fclose(h->f)) {
			perror(h->filename_tmp);
			h->error_fl = 1;
		}

		h->f = NULL;
	}

	if (h->error_fl) {
		/* remove the temp file. */
		if (!remove(h->filename_tmp)) {
			perror(h->filename_tmp);
		}

		/* clean up */
		fdb_write_handle_free(h);
		return 0; /* failure */
	} else {
		/* cleanly close */

		/* move temp file over the real file. */
		filename = fdb_makepath(h->domain, h->id);

		if (rename(h->filename_tmp, filename)) {
			perror(h->filename_tmp);
			free(filename);
			fdb_write_handle_free(h);
			return 0; /* failure */
		}

		free(filename);

		/* clean up */
		fdb_write_handle_free(h);
		return 1; /* success */
	}
}

/**
 * terminate the creation of this record.
 * it is still necessary to call fdb_write_end()
 */
void
fdb_write_abort(struct fdb_write_handle *h)
{
	h->error_fl = 1;
}

/**
 * start reading.
 */
struct fdb_read_handle *fdb_read_begin(const char *domain, const char *id)
{
	struct fdb_read_handle *ret;
	FILE *f;
	char *filename;

	filename = fdb_makepath(domain, id);
	f = fopen(filename, "r");

	if (!f) {
		LOG_PERROR(filename);
		free(filename);
		return 0; /* failure. */
	}

	ret = calloc(1, sizeof * ret);
	ret->f = f;
	ret->filename = filename;
	ret->line_number = 0;
	ret->error_fl = 0;
	ret->alloc_len = 4;
	ret->line = malloc(ret->alloc_len);

	return ret;
}

struct fdb_read_handle *fdb_read_begin_uint(const char *domain, unsigned id)
{
	char numbuf[22]; /* big enough for a signed 64-bit decimal */

	snprintf(numbuf, sizeof numbuf, "%u", id);

	return fdb_read_begin(domain, numbuf);
}

/**
 * read a line of data from the file.
 */
int
fdb_read_next(struct fdb_read_handle *h, const char **name, const char **value)
{
	size_t ofs, newofs;

	assert(h != NULL);
	assert(h->f != NULL);
	assert(h->alloc_len > 0);

	h->line_number++;
	ofs = 0;

	while (!feof(h->f)) {
		if (!fgets(h->line + ofs, h->alloc_len - ofs, h->f)) {
			if (ofs) {
				LOG_INFO("%s:%d:missing newline before EOF.", h->filename, h->line_number);
				h->error_fl = 1;
			}

			return 0;
		}

		newofs = ofs + strlen(h->line + ofs);

		if (strchr(h->line + ofs, '\n')) {
			/* complete line has been read. */
			return fdb_parse_line(h->line, name, value);
		}

		ofs = newofs;

		/* if buffer is more than half used, double it. */
		if (newofs * 2 >= h->alloc_len) {
			char *newline;
			size_t newlen;
			/* round up in 4K chunks. */
			newlen = ((newofs * 2) + 4096 - 1) * 4096 / 4096;
			newline = realloc(h->line, newlen);

			if (!newline) {
				LOG_PERROR(h->filename);
				h->error_fl = 1;
				return 0;
			}

			h->line = newline;
			h->alloc_len = newlen;
		}
	}

	return 0;
}

/**
 * end reading process, close the file and free the handle.
 */
int
fdb_read_end(struct fdb_read_handle *h)
{
	int ret;

	assert(h != NULL);
	assert(h->f != NULL);

	ret = !h->error_fl;

	if (h->f) {
		fclose(h->f);
		h->f = NULL;
	}

	fdb_read_handle_free(h);

	return ret;
}

/**
 * get an iterator that lists all records in domain.
 */
struct fdb_iterator *fdb_iterator_begin(const char *domain)
{
	char *pathname;
	DIR *d;
	struct fdb_iterator *it;

	assert(domain != NULL);

	pathname = fdb_basepath(domain);

	d = opendir(pathname);

	if (!d) {
		LOG_PERROR(pathname);
		free(pathname);
		return 0; /* failure */
	}

	it = calloc(1, sizeof * it);

	if (!it) {
		LOG_PERROR("calloc()");
		free(pathname);
		return 0;
	}

	it->d = d;
	it->pathname = pathname;
	it->curr_id = NULL;
	it->domain = strdup(domain);

	return it;
}

/**
 * get id of record.
 * return NULL if no more ids.
 */
const char *
fdb_iterator_next(struct fdb_iterator *it)
{
	struct dirent *de;
	struct stat st;
	char *filename;

	assert(it != NULL);
	assert(it->d != NULL);

	/* read files and filter out junk filenames. */
next:
	de = readdir(it->d);

	if (!de)
		return NULL;

	if (de->d_name[0] == '.')
		goto next; /* ignore hidden files */

	if (fdb_istempname(de->d_name)) {
		goto next; /* ignore temp files. */
	}

	if (de->d_name[0] && de->d_name[strlen(de->d_name) - 1] == '~') {
		LOG_INFO("skip things that don't look like data files:%s", de->d_name);
		goto next; /* ignore temp files. */
	}

	/* stat the file - ignore directories and non-regular files. */
	filename = fdb_makepath(it->domain, de->d_name);

	if (stat(filename, &st)) {
		LOG_PERROR(filename);
		free(filename);
		goto next;
	}

	free(filename);

	if (!S_ISREG(st.st_mode)) {
		LOG_INFO("Ignoring directories and other non-regular files:%s", de->d_name);
		goto next;
	}

	free(it->curr_id);

	return it->curr_id = strdup(de->d_name);
}

/**
 * finish the iterator.
 */
void
fdb_iterator_end(struct fdb_iterator *it)
{
	assert(it != NULL);
	closedir(it->d);
	free(it->pathname);
	it->pathname = NULL;
	free(it->curr_id);
	it->curr_id = NULL;
	free(it->domain);
	it->domain = NULL;
	free(it);
}

int
fdb_initialize(void)
{
	fprintf(stderr, "loaded %s\n", "fdb");
	LOG_INFO("FDB-file system loaded (" __FILE__ " compiled " __TIME__ " " __DATE__ ")");

	return 0;
}

void
fdb_shutdown(void)
{
}

/* compile with STAND_ALONE_TEST for unit test. */
#ifdef STAND_ALONE_TEST
static int
fdb_test1(void)
{
	struct fdb_write_handle *h;

	fdb_domain_init("room");

	h = fdb_write_begin("room", "123");

	if (!h)
		return 0;

	fdb_write_format(h, "id", "%d", 123);
	fdb_write_pair(h, "owner", "orange");
	fdb_write_pair(h, "description", "  Hello World\nThis is great stuff.");

	fdb_write_end(h);

	return 1;
}

static int
fdb_test2(void)
{
	struct fdb_iterator *it;
	const char *id;

	it = fdb_iterator_begin("users");

	if (!it)
		return 0;

	while ((id = fdb_iterator_next(it))) {
		LOG_INFO("Found item \"%s\"", id);
	}

	fdb_iterator_end(it);

	return 1;
}

static int
fdb_test3(void)
{
	struct fdb_read_handle *h;
	const char *name, *id;
	int res;

	fdb_domain_init("room");

	h = fdb_read_begin("room", "123");

	if (!h) return 0;

	while (fdb_read_next(h, &name, &id)) {
		LOG_INFO("Read \"%s\"=\"%s\"", name, id);
	}

	res = fdb_read_end(h);

	if (!res) {
		LOG_INFO("Read failure.");
	}

	return res;
}

/**
 * domain/id/name=value
 */
int
main()
{
	fdb_initialize();

	LOG_INFO("*** TEST 1 ***");

	if (!fdb_test1())
		goto failure;

	LOG_INFO("*** TEST 2 ***");

	if (!fdb_test2())
		goto failure;

	LOG_INFO("*** TEST 3 ***");

	if (!fdb_test3())
		goto failure;

	fdb_shutdown();
	return 0;
failure:
	fprintf(stderr, "It didn't work.");

	fdb_shutdown();
	return 1;
}
#else
#endif
