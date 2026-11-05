/* unit test for muddb_export.c : JSON-record export of muddb domains */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_muddb_export"

#include "muddb_export.h"

#include "obj.h"
#include "muddb.h"

#include <ftw.h>
#include <log.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "ctest.h"

static char tmpdir[] = "/tmp/test_muddb_export_XXXXXX";

static int
rm_cb(const char *path, const struct stat *sb, int typeflag, struct FTW *f)
{
	(void)sb;
	(void)typeflag;
	(void)f;
	return remove(path);
}

static void
put_json(const char *key, const char *json)
{
	OBJ *o = obj_new_from_json(key, json);

	if (o) {
		obj_put(key, o);
		obj_free(o);
	}
}

/* read a whole file into a NUL-terminated buffer the caller frees, or NULL */
static char *
slurp(const char *path)
{
	FILE *fp = fopen(path, "r");
	char *buf;
	long sz;
	size_t n;

	if (!fp)
		return NULL;
	fseek(fp, 0, SEEK_END);
	sz = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	if (sz < 0) {
		fclose(fp);
		return NULL;
	}
	buf = malloc((size_t)sz + 1);
	if (!buf) {
		fclose(fp);
		return NULL;
	}
	n = fread(buf, 1, (size_t)sz, fp);
	fclose(fp);
	buf[n] = '\0';
	return buf;
}

static int
file_exists(const char *path)
{
	struct stat st;

	return stat(path, &st) == 0 && S_ISREG(st.st_mode);
}

struct counts {
	int objs;
};

static void
count_cb(const char *domain, int count, void *ctx)
{
	struct counts *c = ctx;

	if (strcmp(domain, "objs") == 0)
		c->objs = count;
}

int
main(void)
{
	char dbdir[256], outdir[256], path[512];
	const char *domains[1] = { "objs" };
	struct counts c = {0};
	MUDDB *db;
	char *body;

	if (!mkdtemp(tmpdir)) {
		perror("mkdtemp");
		return EXIT_FAILURE;
	}
	snprintf(dbdir, sizeof dbdir, "%s/db", tmpdir);
	snprintf(outdir, sizeof outdir, "%s/out/stamp", tmpdir);	/* nested */
	mkdir(dbdir, 0777);

	db = muddb_open(dbdir, 0);
	if (!db || obj_initialize(db, 32) != 0) {
		LOG_ERROR("could not open store");
		return EXIT_FAILURE;
	}

	/* a flat object and one under a nested key (tests nested dirs) */
	put_json("zone/world/hall", "{\"name\":\"The Hall\"}");
	put_json("zone/world/sub/closet", "{\"name\":\"Closet\"}");
	obj_sync();

	check("obj_db is available", obj_db() == db);

	check("export ok", muddb_export(db, outdir, domains, 1, count_cb, &c)
		== 0);
	check("export counted two objs", c.objs == 2);

	/* the nested output directory and both record files exist */
	snprintf(path, sizeof path, "%s/objs/zone/world/hall.json", outdir);
	check("flat record written", file_exists(path));
	body = slurp(path);
	check("flat record has its content", body
		&& strstr(body, "The Hall") != NULL);
	free(body);

	snprintf(path, sizeof path, "%s/objs/zone/world/sub/closet.json", outdir);
	check("nested record written", file_exists(path));
	body = slurp(path);
	check("nested record has its content", body
		&& strstr(body, "Closet") != NULL);
	free(body);

	/* default-domain export (ndomains 0) reaches objs too */
	snprintf(outdir, sizeof outdir, "%s/out2", tmpdir);
	check("default-domain export ok",
		muddb_export(db, outdir, NULL, 0, NULL, NULL) == 0);
	snprintf(path, sizeof path, "%s/objs/zone/world/hall.json", outdir);
	check("default export wrote objs", file_exists(path));

	obj_shutdown();
	muddb_close(db);
	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
	return ctest_report("test_muddb_export");
}
