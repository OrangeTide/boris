/* muddb_export.c : export muddb domains as JSON-record directories */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "muddb_export"

#include "muddb_export.h"

#include "muddb.h"
#include "obj.h"

#include <log.h>

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#define EXPORT_JSON_BUFSZ 65536

/* well-known domains -- must match the DOMAIN_* constants in boris.h */
static const char *default_domains[] = {
	"users",
	"objs",
	"chars",
	NULL
};

static int
write_file(const char *path, const char *data, size_t len)
{
	FILE *fp = fopen(path, "w");

	if (!fp) {
		LOG_ERROR("fopen(%s): %s", path, strerror(errno));
		return -1;
	}
	if (fwrite(data, 1, len, fp) != len) {
		LOG_ERROR("fwrite(%s): %s", path, strerror(errno));
		fclose(fp);
		return -1;
	}
	fputc('\n', fp);	/* end with a newline for readability */
	fclose(fp);
	return 0;
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

/* create all parent directories of path (components before the last slash) */
static int
mkdirs_parents(const char *path)
{
	char tmp[PATH_MAX];
	char *slash;

	if ((size_t)snprintf(tmp, sizeof tmp, "%s", path) >= sizeof tmp)
		return -1;
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

/* reject keys that would escape the directory: absolute, backslashes, "..",
 * or empty components. '/' for hierarchical keys is allowed. */
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

static int
export_one(struct muddb *db, const char *domain, const char *outdir,
	muddb_export_progress_fn progress, void *ctx)
{
	MUDDB_ITER *it;
	const char *key;
	char path[PATH_MAX];
	char buf[EXPORT_JSON_BUFSZ];
	int count = 0;

	if ((size_t)snprintf(path, sizeof path, "%s/%s", outdir, domain)
		>= sizeof path || mkdirs(path) != 0)
		return -1;

	it = muddb_iter_begin(db, domain);
	if (!it)
		return 0;	/* empty or nonexistent domain is not an error */

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
		if (obj_get_json(obj, buf, sizeof buf, NULL) != OBJ_OK) {
			LOG_ERROR("could not serialize %s/%s", domain, key);
			obj_free(obj);
			continue;
		}
		obj_free(obj);

		if ((size_t)snprintf(path, sizeof path, "%s/%s/%s.json",
			outdir, domain, key) >= sizeof path)
			continue;
		if (mkdirs_parents(path) != 0)
			continue;
		if (write_file(path, buf, strlen(buf)) == 0)
			count++;
	}
	muddb_iter_end(it);

	if (progress)
		progress(domain, count, ctx);
	return 0;
}

int
muddb_export(struct muddb *db, const char *outdir,
	const char *const *domains, size_t ndomains,
	muddb_export_progress_fn progress, void *ctx)
{
	size_t i;

	if (!db || !outdir || !outdir[0])
		return -1;
	if (mkdirs_parents(outdir) != 0 || mkdirs(outdir) != 0)
		return -1;

	if (ndomains == 0) {
		const char **dp;

		for (dp = default_domains; *dp; dp++)
			export_one(db, *dp, outdir, progress, ctx);
	} else {
		for (i = 0; i < ndomains; i++)
			export_one(db, domains[i], outdir, progress, ctx);
	}
	return 0;
}
