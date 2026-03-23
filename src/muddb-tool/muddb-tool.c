/**
 * @file muddb-tool.c
 *
 * Command-line tool for importing and exporting muddb (LMDB) databases.
 *
 * Export writes each domain as a directory of .json files:
 *   <outdir>/<domain>/<key>.json
 *
 * Import reads the same layout back into an LMDB environment.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
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

#define LOG_SUBSYSTEM "muddb-tool"

#include "muddb.h"
#include "obj.h"

#include <dirent.h>
#include <errno.h>
#include <limits.h>
#include <log.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#define JSON_BUFSZ 65536

MUDDB *mud_db;

static void
usage(const char *argv0)
{
	fprintf(stderr,
		"Usage:\n"
		"    %s export <dbpath> <outdir> [domain ...]\n"
		"    %s import <dbpath> <indir>  [domain ...]\n"
		"\n"
		"Export writes each LMDB domain as a directory of .json files.\n"
		"Import reads .json files back into the database.\n"
		"\n"
		"If no domains are given, export dumps all domains and import\n"
		"imports all directories found under <indir>.\n",
		argv0, argv0);
}

/* --- file I/O helpers --------------------------------------------------- */

static int
write_file(const char *path, const char *data, size_t len)
{
	FILE *fp;

	fp = fopen(path, "w");
	if (!fp) {
		LOG_ERROR("fopen(%s): %s", path, strerror(errno));
		return -1;
	}
	if (fwrite(data, 1, len, fp) != len) {
		LOG_ERROR("fwrite(%s): %s", path, strerror(errno));
		fclose(fp);
		return -1;
	}
	/* end with a newline for human readability */
	fputc('\n', fp);
	fclose(fp);
	return 0;
}

static char *
read_file(const char *path, size_t *out_len)
{
	FILE *fp;
	long sz;
	char *buf;
	size_t nread;

	fp = fopen(path, "r");
	if (!fp) {
		LOG_ERROR("fopen(%s): %s", path, strerror(errno));
		return NULL;
	}

	fseek(fp, 0, SEEK_END);
	sz = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	if (sz < 0 || sz > 10 * 1024 * 1024) {
		LOG_ERROR("%s: file too large or unreadable", path);
		fclose(fp);
		return NULL;
	}

	buf = malloc((size_t)sz + 1);
	if (!buf) {
		fclose(fp);
		return NULL;
	}

	nread = fread(buf, 1, (size_t)sz, fp);
	fclose(fp);
	buf[nread] = '\0';

	if (out_len)
		*out_len = nread;
	return buf;
}

static int
mkdirs(const char *path)
{
	if (mkdir(path, 0777) != 0 && errno != EEXIST) {
		LOG_ERROR("mkdir(%s): %s", path, strerror(errno));
		return -1;
	}
	return 0;
}

/* --- key validation ----------------------------------------------------- */

/* reject keys that would escape the directory (slashes, dots-only, etc) */
static int
key_is_safe(const char *key)
{
	if (!key || !key[0])
		return 0;
	if (strchr(key, '/') || strchr(key, '\\'))
		return 0;
	if (strcmp(key, ".") == 0 || strcmp(key, "..") == 0)
		return 0;
	return 1;
}

/* --- export ------------------------------------------------------------- */

static int
export_domain(MUDDB *db, const char *domain, const char *outdir)
{
	MUDDB_ITER *it;
	const char *key;
	char path[PATH_MAX];
	char buf[JSON_BUFSZ];
	int count = 0;

	snprintf(path, sizeof(path), "%s/%s", outdir, domain);
	if (mkdirs(path) != 0)
		return -1;

	it = muddb_iter_begin(db, domain);
	if (!it)
		return 0; /* domain may be empty or not exist -- not an error */

	while ((key = muddb_iter_next(it)) != NULL) {
		OBJ *obj;

		if (!key_is_safe(key)) {
			LOG_ERROR("skipping unsafe key \"%s\" in domain \"%s\"",
				key, domain);
			continue;
		}

		obj = muddb_iter_value(it);
		if (!obj) {
			LOG_ERROR("could not read %s/%s", domain, key);
			continue;
		}

		if (obj_get_json(obj, buf, sizeof(buf)) != OBJ_OK) {
			LOG_ERROR("could not serialize %s/%s", domain, key);
			obj_free(obj);
			continue;
		}
		obj_free(obj);

		snprintf(path, sizeof(path), "%s/%s/%s.json",
			outdir, domain, key);
		if (write_file(path, buf, strlen(buf)) == 0)
			count++;
	}
	muddb_iter_end(it);

	printf("  %s: %d objects\n", domain, count);
	return 0;
}

/* well-known domains -- must match the DOMAIN_* constants in boris.h */
static const char *known_domains[] = {
	"users",
	"rooms",
	"chars",
	NULL
};

static int
export_all_domains(MUDDB *db, const char *outdir)
{
	const char **dp;

	for (dp = known_domains; *dp; dp++)
		export_domain(db, *dp, outdir);

	return 0;
}

static int
cmd_export(const char *dbpath, const char *outdir,
           int argc, char **argv)
{
	MUDDB *db;
	int i;

	db = muddb_open(dbpath, 0);
	if (!db) {
		LOG_ERROR("could not open database at %s", dbpath);
		return 1;
	}

	if (mkdirs(outdir) != 0) {
		muddb_close(db);
		return 1;
	}

	printf("Exporting %s -> %s\n", dbpath, outdir);

	if (argc == 0) {
		export_all_domains(db, outdir);
	} else {
		for (i = 0; i < argc; i++)
			export_domain(db, argv[i], outdir);
	}

	muddb_close(db);
	return 0;
}

/* --- import ------------------------------------------------------------- */

static int
import_domain(MUDDB *db, const char *domain, const char *indir)
{
	char dirpath[PATH_MAX];
	DIR *dp;
	struct dirent *ent;
	int count = 0;

	snprintf(dirpath, sizeof(dirpath), "%s/%s", indir, domain);
	dp = opendir(dirpath);
	if (!dp) {
		LOG_ERROR("opendir(%s): %s", dirpath, strerror(errno));
		return -1;
	}

	while ((ent = readdir(dp)) != NULL) {
		char filepath[PATH_MAX];
		char *json;
		char *dot;
		char key[256];
		OBJ *obj;
		size_t namelen;

		/* skip non-.json files and hidden files */
		if (ent->d_name[0] == '.')
			continue;
		dot = strrchr(ent->d_name, '.');
		if (!dot || strcmp(dot, ".json") != 0)
			continue;

		/* derive key from filename (strip .json) */
		namelen = (size_t)(dot - ent->d_name);
		if (namelen == 0 || namelen >= sizeof(key))
			continue;
		memcpy(key, ent->d_name, namelen);
		key[namelen] = '\0';

		if (!key_is_safe(key)) {
			LOG_ERROR("skipping unsafe key \"%s\"", key);
			continue;
		}

		snprintf(filepath, sizeof(filepath), "%s/%s",
			dirpath, ent->d_name);
		json = read_file(filepath, NULL);
		if (!json)
			continue;

		obj = obj_new_from_json(key, json);
		free(json);
		if (!obj) {
			LOG_ERROR("could not parse %s", filepath);
			continue;
		}

		if (muddb_put(db, domain, key, obj) != MUDDB_OK) {
			LOG_ERROR("could not store %s/%s", domain, key);
			obj_free(obj);
			continue;
		}
		obj_free(obj);
		count++;
	}
	closedir(dp);

	printf("  %s: %d objects\n", domain, count);
	return 0;
}

static int
import_all_domains(MUDDB *db, const char *indir)
{
	DIR *dp;
	struct dirent *ent;
	struct stat st;
	char path[PATH_MAX];

	dp = opendir(indir);
	if (!dp) {
		LOG_ERROR("opendir(%s): %s", indir, strerror(errno));
		return -1;
	}

	while ((ent = readdir(dp)) != NULL) {
                /* ignore . .. and hidden files */
		if (ent->d_name[0] == '.')
			continue;

		snprintf(path, sizeof(path), "%s/%s", indir, ent->d_name);
		if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode))
			continue;

		import_domain(db, ent->d_name, indir);
	}
	closedir(dp);

	return 0;
}

static int
cmd_import(const char *dbpath, const char *indir,
           int argc, char **argv)
{
	MUDDB *db;
	int i;

	/* ensure the LMDB directory exists */
	if (mkdirs(dbpath) != 0)
		return 1;

	db = muddb_open(dbpath, 0);
	if (!db) {
		LOG_ERROR("could not open database at %s", dbpath);
		return 1;
	}

	printf("Importing %s -> %s\n", indir, dbpath);

	if (argc == 0) {
		import_all_domains(db, indir);
	} else {
		for (i = 0; i < argc; i++) {
			import_domain(db, argv[i], indir);
                }
	}

	muddb_close(db);
	return 0;
}

/* --- main --------------------------------------------------------------- */

int
main(int argc, char **argv)
{
	log_init();

	if (argc < 4) {
		usage(argv[0]);
		return 1;
	}

	if (strcmp(argv[1], "export") == 0) {
		return cmd_export(argv[2], argv[3],
			argc - 4, argv + 4);
	} else if (strcmp(argv[1], "import") == 0) {
		return cmd_import(argv[2], argv[3],
			argc - 4, argv + 4);
	} else {
		fprintf(stderr, "Unknown command: %s\n", argv[1]);
		usage(argv[0]);
		return 1;
	}
}
