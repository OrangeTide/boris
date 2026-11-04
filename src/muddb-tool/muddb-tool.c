/**
 * @file muddb-tool.c
 *
 * Command-line tool for importing and exporting muddb (LMDB) databases.
 *
 * Export writes each domain as a tree of .json files:
 *   <outdir>/<domain>/<key>.json
 * Keys may contain '/' (e.g. "rooms/tower-entrance"), producing nested
 * subdirectories under the domain directory.
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
#include "objref.h"
#include "obj_cache_cas.h"

#include <cas.h>
#include <cas-tree.h>

#define JSMN_HEADER
#include <jsmn.h>

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
		"    %s export       <dbpath> <outdir> [domain ...]\n"
		"    %s import       <dbpath> <indir>  [domain ...]\n"
		"    %s to-cas       <dbpath> <depot> [ref] [domain ...]\n"
		"    %s migrate-refs <dbpath> [domain ...]\n"
		"\n"
		"Export writes each LMDB domain as a directory of .json files.\n"
		"Import reads .json files back into the database.\n"
		"To-cas imports LMDB domains into a CAS depot (default ref\n"
		"\"world\") for the cas object store backend.\n"
		"Migrate-refs rewrites each object in place to the '~'-marked\n"
		"reference form: it flattens nested \"exit\" objects to flat\n"
		"exit.<dir>.to / exit.<dir>.desc keys and marks reference keys\n"
		"(%%parent, %%location, template, exit.<dir>.to) with the '~'\n"
		"suffix. It is idempotent: already-marked objects are left\n"
		"untouched.\n"
		"\n"
		"If no domains are given, all domains are used (import scans\n"
		"directories found under <indir>).\n",
		argv0, argv0, argv0, argv0);
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

/* reject keys that would escape the directory. allows '/' for hierarchical
 * keys but rejects '..' components, empty components, and backslashes. */
static int
key_is_safe(const char *key)
{
	const char *seg, *p;
	size_t len;

	if (!key || !key[0])
		return 0;
	if (key[0] == '/' || strchr(key, '\\'))
		return 0;

	for (p = key; ; ) {
		seg = p;
		p = strchr(seg, '/');
		len = p ? (size_t)(p - seg) : strlen(seg);

		if (len == 0)
			return 0;
		if (len == 1 && seg[0] == '.')
			return 0;
		if (len == 2 && seg[0] == '.' && seg[1] == '.')
			return 0;

		if (!p)
			break;
		p++;
	}
	return 1;
}

/* create all parent directories for a file path */
static int
mkdirs_parents(const char *filepath)
{
	char tmp[PATH_MAX];
	char *slash;

	snprintf(tmp, sizeof(tmp), "%s", filepath);

	for (slash = tmp + 1; (slash = strchr(slash, '/')) != NULL; slash++) {
		*slash = '\0';
		if (mkdir(tmp, 0777) != 0 && errno != EEXIST) {
			LOG_ERROR("mkdir(%s): %s", tmp, strerror(errno));
			*slash = '/';
			return -1;
		}
		*slash = '/';
	}
	return 0;
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

		if (obj_get_json(obj, buf, sizeof(buf), NULL) != OBJ_OK) {
			LOG_ERROR("could not serialize %s/%s", domain, key);
			obj_free(obj);
			continue;
		}
		obj_free(obj);

		snprintf(path, sizeof(path), "%s/%s/%s.json",
			outdir, domain, key);
		if (mkdirs_parents(path) != 0) {
			continue;
		}
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
	"objs",
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
import_tree(MUDDB *db, const char *domain, const char *dirpath,
            const char *prefix, int *count)
{
	DIR *dp;
	struct dirent *ent;
	struct stat st;

	dp = opendir(dirpath);
	if (!dp) {
		LOG_ERROR("opendir(%s): %s", dirpath, strerror(errno));
		return -1;
	}

	while ((ent = readdir(dp)) != NULL) {
		char filepath[PATH_MAX];
		int n;

		if (ent->d_name[0] == '.')
			continue;

		n = snprintf(filepath, sizeof(filepath), "%s/%s",
			dirpath, ent->d_name);
		if (n < 0 || (size_t)n >= sizeof(filepath))
			continue;

		if (stat(filepath, &st) == 0 && S_ISDIR(st.st_mode)) {
			char subprefix[512];

			if (prefix[0])
				snprintf(subprefix, sizeof(subprefix),
					"%s/%s", prefix, ent->d_name);
			else
				snprintf(subprefix, sizeof(subprefix),
					"%s", ent->d_name);
			import_tree(db, domain, filepath, subprefix, count);
			continue;
		}

		char *dot = strrchr(ent->d_name, '.');
		if (!dot || strcmp(dot, ".json") != 0)
			continue;

		size_t namelen = (size_t)(dot - ent->d_name);
		if (namelen == 0)
			continue;

		char key[512];
		char *json;
		OBJ *obj;

		if (prefix[0])
			snprintf(key, sizeof(key), "%s/%.*s",
				prefix, (int)namelen, ent->d_name);
		else
			snprintf(key, sizeof(key), "%.*s",
				(int)namelen, ent->d_name);

		if (!key_is_safe(key)) {
			LOG_ERROR("skipping unsafe key \"%s\"", key);
			continue;
		}

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
		(*count)++;
	}
	closedir(dp);

	return 0;
}

static int
import_domain(MUDDB *db, const char *domain, const char *indir)
{
	char dirpath[PATH_MAX];
	int count = 0;

	snprintf(dirpath, sizeof(dirpath), "%s/%s", indir, domain);
	if (import_tree(db, domain, dirpath, "", &count) != 0)
		return -1;

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

/* --- to-cas ------------------------------------------------------------- */

/* import one muddb domain into a CAS-backed cache; buffered saves are
 * committed by the caller. */
static int
to_cas_domain(MUDDB *db, OBJ_CACHE *cache, const char *domain)
{
	MUDDB_ITER *it;
	const char *key;
	int count = 0;

	it = muddb_iter_begin(db, domain);
	if (!it) {
		LOG_ERROR("could not iterate domain \"%s\"", domain);
		return -1;
	}

	while ((key = muddb_iter_next(it))) {
		OBJ *obj = muddb_iter_value(it);

		if (!obj) {
			LOG_ERROR("could not read %s/%s", domain, key);
			continue;
		}

		if (obj_cache_cas_put(cache, key, obj) != OBJ_CACHE_OK)
			LOG_ERROR("could not store %s/%s", domain, key);
		else
			count++;

		obj_free(obj);
	}

	muddb_iter_end(it);
	printf("  %s: %d objects\n", domain, count);
	return 0;
}

/* import one domain into the depot and commit it */
static int
to_cas_one(MUDDB *db, struct cas_tree *ct, const char *ref,
           const char *domain)
{
	OBJ_CACHE *cache = obj_cache_cas_new(ct, ref, domain, 16);
	int rc = 0;

	if (!cache) {
		LOG_ERROR("could not create cache for \"%s\"", domain);
		return 1;
	}

	if (to_cas_domain(db, cache, domain) != 0)
		rc = 1;
	else if (obj_cache_cas_commit(cache, "muddb-tool to-cas")
		!= OBJ_CACHE_OK) {
		LOG_ERROR("commit failed for \"%s\"", domain);
		rc = 1;
	}

	obj_cache_cas_free(cache);
	return rc;
}

static int
cmd_to_cas(const char *dbpath, const char *depot, const char *ref,
           int argc, char **argv)
{
	MUDDB *db;
	struct cas *store;
	struct cas_tree *ct;
	int rc = 0;

	db = muddb_open(dbpath, 0);
	if (!db) {
		LOG_ERROR("could not open database at %s", dbpath);
		return 1;
	}

	store = cas_new(depot);
	ct = store ? cas_tree_new(store) : NULL;
	if (!ct) {
		LOG_ERROR("could not create CAS depot at %s", depot);
		cas_free(store);
		muddb_close(db);
		return 1;
	}
	cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

	printf("Importing %s -> %s (ref %s)\n", dbpath, depot, ref);

	if (argc == 0) {
		const char **dp;

		for (dp = known_domains; *dp; dp++)
			if (to_cas_one(db, ct, ref, *dp) != 0)
				rc = 1;
	} else {
		int i;

		for (i = 0; i < argc; i++)
			if (to_cas_one(db, ct, ref, argv[i]) != 0)
				rc = 1;
	}

	cas_tree_free(ct);
	cas_free(store);
	muddb_close(db);
	return rc;
}

/* --- migrate-refs ------------------------------------------------------- */

/*
 * One-time migration from the legacy object shape to the '~'-marked reference
 * form (doc/snapshot-restore-spec.md section 5.1 and implementation step 0).
 *
 * It rewrites each object's JSON directly rather than through the OBJ API,
 * because the OBJ property iterator reports only flat scalar keys and skips the
 * nested "exit" object the migration must flatten. The rewrite copies every
 * value byte-for-byte and touches only the two things the new shape requires:
 *
 *   1. a nested "exit" object is flattened to flat dotted keys, so
 *      "exit":{"n":{"to":X,"desc":Y}} becomes "exit.n.to~":X,"exit.n.desc":Y;
 *   2. a reference key (objref_is_ref_name) gains the '~' suffix, so
 *      "%parent":X becomes "%parent~":X and a flat "exit.n.to":X becomes
 *      "exit.n.to~":X.
 *
 * A key already carrying the '~' marker is passed through unchanged, so the
 * pass is idempotent and an object that needs no change is not rewritten.
 */

#define MIGRATE_OUTSZ (2 * JSON_BUFSZ)

/* number of tokens occupied by the subtree rooted at t (t itself included).
 * ntok is the number of tokens available from t onward. Mirrors the span walk
 * used inside obj.c. */
static int
tok_span(const jsmntok_t *t, int ntok)
{
	int i, j;

	if (ntok <= 0)
		return 0;

	switch (t->type) {
	case JSMN_PRIMITIVE:
	case JSMN_STRING:
		return 1;
	case JSMN_OBJECT:
		j = 1;
		for (i = 0; i < t->size; i++) {
			j += tok_span(t + j, ntok - j); /* key */
			j += tok_span(t + j, ntok - j); /* value */
		}
		return j;
	case JSMN_ARRAY:
		j = 1;
		for (i = 0; i < t->size; i++)
			j += tok_span(t + j, ntok - j);
		return j;
	default:
		return 1;
	}
}

struct outbuf {
	char *p;
	char *end;
	int overflow;
};

static void
ob_put(struct outbuf *b, const char *s, size_t n)
{
	if (b->overflow)
		return;
	if ((size_t)(b->end - b->p) < n) {
		b->overflow = 1;
		return;
	}
	memcpy(b->p, s, n);
	b->p += n;
}

static void
ob_putc(struct outbuf *b, char c)
{
	ob_put(b, &c, 1);
}

static void
ob_puts(struct outbuf *b, const char *s)
{
	ob_put(b, s, strlen(s));
}

/* emit a value token verbatim from the source JSON. For a string the token
 * spans the content between the quotes, so the quotes are re-added; for a
 * primitive, object or array the token span is the literal text. */
static void
ob_value(struct outbuf *b, const char *json, const jsmntok_t *t)
{
	if (t->type == JSMN_STRING) {
		ob_putc(b, '"');
		ob_put(b, json + t->start, (size_t)(t->end - t->start));
		ob_putc(b, '"');
	} else {
		ob_put(b, json + t->start, (size_t)(t->end - t->start));
	}
}

/* copy a string token's raw bytes into buf as a C string; returns 0 on success
 * or -1 if it does not fit (treated by the caller as a pass-through key). */
static int
tok_str(const char *json, const jsmntok_t *t, char *buf, size_t bufsz)
{
	size_t n = (size_t)(t->end - t->start);

	if (t->type != JSMN_STRING || n >= bufsz)
		return -1;
	memcpy(buf, json + t->start, n);
	buf[n] = '\0';
	return 0;
}

/* flatten a nested "exit" object (at token index ei) into flat dotted keys. */
static void
flatten_exit(struct outbuf *b, const char *json, const jsmntok_t *tokens,
             int ntok, int ei, int *first)
{
	const jsmntok_t *exittok = &tokens[ei];
	int d, j;

	j = ei + 1; /* first direction key */
	for (d = 0; d < exittok->size; d++) {
		const jsmntok_t *dirkey = &tokens[j];
		const jsmntok_t *dirval = &tokens[j + 1];
		char dir[64];

		if (tok_str(json, dirkey, dir, sizeof(dir)) != 0) {
			/* unparseable direction name: skip the whole pair */
			j += 1 + tok_span(dirval, ntok - (j + 1));
			continue;
		}

		if (dirval->type == JSMN_OBJECT) {
			int l, k = j + 2; /* first leaf key */

			for (l = 0; l < dirval->size; l++) {
				const jsmntok_t *leafkey = &tokens[k];
				const jsmntok_t *leafval = &tokens[k + 1];
				char leaf[64];

				if (tok_str(json, leafkey, leaf,
					sizeof(leaf)) != 0) {
					k += 1 + tok_span(leafval,
						ntok - (k + 1));
					continue;
				}

				if (!*first)
					ob_putc(b, ',');
				*first = 0;

				ob_putc(b, '"');
				ob_puts(b, "exit.");
				ob_puts(b, dir);
				ob_putc(b, '.');
				ob_puts(b, leaf);
				if (strcmp(leaf, "to") == 0)
					ob_putc(b, OBJ_REF_MARK);
				ob_putc(b, '"');
				ob_putc(b, ':');
				ob_value(b, json, leafval);

				k += 1 + tok_span(leafval, ntok - (k + 1));
			}
			j = k;
		} else {
			/* "exit.<dir>" holds a scalar: keep it as a flat key
			 * without inventing a leaf. */
			if (!*first)
				ob_putc(b, ',');
			*first = 0;
			ob_putc(b, '"');
			ob_puts(b, "exit.");
			ob_puts(b, dir);
			ob_putc(b, '"');
			ob_putc(b, ':');
			ob_value(b, json, dirval);
			j += 1 + tok_span(dirval, ntok - (j + 1));
		}
	}
}

/*
 * Rewrite one object's JSON. Writes the migrated form into out and sets
 * *changed when the shape actually changed. Returns 0 on success, -1 on a parse
 * error or output overflow (the caller then leaves the object untouched).
 */
static int
migrate_json(const char *json, char *out, size_t outsz, int *changed)
{
	jsmn_parser p;
	jsmntok_t *tokens;
	int ntok, pair, i;
	struct outbuf b;

	*changed = 0;

	jsmn_init(&p);
	ntok = jsmn_parse(&p, json, strlen(json), NULL, 0);
	if (ntok < 1)
		return -1;

	tokens = calloc((size_t)ntok, sizeof(*tokens));
	if (!tokens)
		return -1;

	jsmn_init(&p);
	if (jsmn_parse(&p, json, strlen(json), tokens, (unsigned)ntok) < 0) {
		free(tokens);
		return -1;
	}

	if (tokens[0].type != JSMN_OBJECT) {
		/* not a property map: nothing to migrate */
		free(tokens);
		return -1;
	}

	b.p = out;
	b.end = out + outsz - 1; /* leave room for the NUL */
	b.overflow = 0;

	ob_putc(&b, '{');

	i = 1; /* first key token */
	{
		int first = 1;

		for (pair = 0; pair < tokens[0].size; pair++) {
			const jsmntok_t *ktok = &tokens[i];
			const jsmntok_t *vtok = &tokens[i + 1];
			char name[OBJ_PATH_MAX];
			int marked, is_ref, named;

			named = tok_str(json, ktok, name, sizeof(name)) == 0;
			marked = named && name[0] &&
				name[strlen(name) - 1] == OBJ_REF_MARK;

			if (!marked && named && strcmp(name, "exit") == 0 &&
				vtok->type == JSMN_OBJECT) {
				flatten_exit(&b, json, tokens, ntok, i + 1,
					&first);
				*changed = 1;
			} else {
				if (!first)
					ob_putc(&b, ',');
				first = 0;

				is_ref = !marked && named &&
					objref_is_ref_name(name);
				if (is_ref) {
					ob_putc(&b, '"');
					ob_puts(&b, name);
					ob_putc(&b, OBJ_REF_MARK);
					ob_putc(&b, '"');
					*changed = 1;
				} else {
					ob_putc(&b, '"');
					ob_put(&b, json + ktok->start,
						(size_t)(ktok->end -
							ktok->start));
					ob_putc(&b, '"');
				}
				ob_putc(&b, ':');
				ob_value(&b, json, vtok);
			}

			i += 1 + tok_span(vtok, ntok - (i + 1));
		}
	}

	ob_putc(&b, '}');
	free(tokens);

	if (b.overflow)
		return -1;
	*b.p = '\0';
	return 0;
}

/* collect every key of a domain, so the store can be rewritten without
 * mutating it under an open cursor. */
struct keylist {
	char **keys;
	int count;
	int cap;
};

static int
keylist_add(struct keylist *kl, const char *key)
{
	if (kl->count == kl->cap) {
		int ncap = kl->cap ? kl->cap * 2 : 64;
		char **nk = realloc(kl->keys, (size_t)ncap * sizeof(*nk));

		if (!nk)
			return -1;
		kl->keys = nk;
		kl->cap = ncap;
	}
	kl->keys[kl->count] = strdup(key);
	if (!kl->keys[kl->count])
		return -1;
	kl->count++;
	return 0;
}

static void
keylist_free(struct keylist *kl)
{
	int i;

	for (i = 0; i < kl->count; i++)
		free(kl->keys[i]);
	free(kl->keys);
	kl->keys = NULL;
	kl->count = kl->cap = 0;
}

static int
migrate_domain(MUDDB *db, const char *domain)
{
	struct keylist kl = {0};
	MUDDB_ITER *it;
	const char *key;
	char *json = NULL;
	char *out = NULL;
	int i, migrated = 0, rc = 0;

	it = muddb_iter_begin(db, domain);
	if (it) {
		while ((key = muddb_iter_next(it)) != NULL) {
			if (keylist_add(&kl, key) != 0) {
				LOG_ERROR("out of memory listing \"%s\"",
					domain);
				rc = -1;
				break;
			}
		}
		muddb_iter_end(it);
	}

	json = malloc(JSON_BUFSZ);
	out = malloc(MIGRATE_OUTSZ);
	if (!json || !out) {
		LOG_ERROR("out of memory");
		rc = -1;
		goto done;
	}

	for (i = 0; i < kl.count && rc == 0; i++) {
		OBJ *obj = muddb_get(db, domain, kl.keys[i]);
		OBJ *newobj;
		int changed = 0;

		if (!obj) {
			LOG_ERROR("could not read %s/%s", domain, kl.keys[i]);
			continue;
		}

		if (obj_get_json(obj, json, JSON_BUFSZ, NULL) != OBJ_OK) {
			LOG_ERROR("could not serialize %s/%s", domain,
				kl.keys[i]);
			obj_free(obj);
			continue;
		}
		obj_free(obj);

		if (migrate_json(json, out, MIGRATE_OUTSZ, &changed) != 0) {
			LOG_ERROR("could not migrate %s/%s", domain,
				kl.keys[i]);
			continue;
		}
		if (!changed)
			continue;

		newobj = obj_new_from_json(kl.keys[i], out);
		if (!newobj) {
			LOG_ERROR("migrated %s/%s did not parse back",
				domain, kl.keys[i]);
			continue;
		}
		if (muddb_put(db, domain, kl.keys[i], newobj) != MUDDB_OK) {
			LOG_ERROR("could not store %s/%s", domain, kl.keys[i]);
			obj_free(newobj);
			continue;
		}
		obj_free(newobj);
		migrated++;
	}

	printf("  %s: %d objects, %d migrated\n", domain, kl.count, migrated);

done:
	free(json);
	free(out);
	keylist_free(&kl);
	return rc;
}

static int
cmd_migrate_refs(const char *dbpath, int argc, char **argv)
{
	MUDDB *db;
	int rc = 0;

	db = muddb_open(dbpath, 0);
	if (!db) {
		LOG_ERROR("could not open database at %s", dbpath);
		return 1;
	}

	printf("Migrating references in %s\n", dbpath);

	if (argc == 0) {
		const char **dp;

		for (dp = known_domains; *dp; dp++)
			if (migrate_domain(db, *dp) != 0)
				rc = 1;
	} else {
		int i;

		for (i = 0; i < argc; i++)
			if (migrate_domain(db, argv[i]) != 0)
				rc = 1;
	}

	muddb_close(db);
	return rc;
}

/* --- main --------------------------------------------------------------- */

int
main(int argc, char **argv)
{
	log_init();

	if (argc < 3) {
		usage(argv[0]);
		return 1;
	}

	if (strcmp(argv[1], "migrate-refs") == 0) {
		return cmd_migrate_refs(argv[2], argc - 3, argv + 3);
	}

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
	} else if (strcmp(argv[1], "to-cas") == 0) {
		return cmd_to_cas(argv[2], argv[3],
			argc > 4 ? argv[4] : "world",
			argc > 5 ? argc - 5 : 0, argv + 5);
	} else {
		fprintf(stderr, "Unknown command: %s\n", argv[1]);
		usage(argv[0]);
		return 1;
	}
}
