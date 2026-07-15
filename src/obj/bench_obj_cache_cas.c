/* benchmark: CAS backend (obj_cache_cas) vs muddb/LMDB on real data */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */
#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "bench_obj_cache_cas"

#include "obj_cache_cas.h"
#include "obj.h"
#include "muddb.h"

#include <cas.h>
#include <cas-tree.h>
#include <log.h>

#include <errno.h>
#include <ftw.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>

#define DEFAULT_ROUNDS 100
#define DEFAULT_EDITS 5
#define MAX_RECORDS 4096

static const char *domains[] = { "users", "objs", "chars", NULL };

struct rec {
	const char *domain;
	char *id;
	OBJ *obj;
};

static struct rec records[MAX_RECORDS];
static int record_count;

/****************************************************************
 * Helpers
 ****************************************************************/

static double
now_ms(void)
{
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);
	return (double)ts.tv_sec * 1000.0 + (double)ts.tv_nsec / 1e6;
}

static size_t
obj_json_len(OBJ *obj)
{
	char stackbuf[4096];
	char *buf = stackbuf;
	size_t bufsz = sizeof(stackbuf);
	size_t len = 0;
	int result = obj_get_json(obj, buf, bufsz, &len);

	while (result == OBJ_ERR_NOMEM) {
		bufsz *= 2;
		buf = (buf == stackbuf) ? malloc(bufsz) : realloc(buf, bufsz);
		if (!buf)
			return 0;
		result = obj_get_json(obj, buf, bufsz, &len);
	}
	if (buf != stackbuf)
		free(buf);
	return (result == OBJ_OK) ? len : 0;
}

/* recursive directory statistics via nftw (not thread-safe) */
static long long walk_bytes, walk_disk;
static long walk_files;

static int
walk_cb(const char *path, const struct stat *sb, int typeflag,
	struct FTW *ftwbuf)
{
	(void)path;
	(void)ftwbuf;
	if (typeflag == FTW_F) {
		walk_files++;
		walk_bytes += sb->st_size;
		walk_disk += (long long)sb->st_blocks * 512;
	}
	return 0;
}

struct dirstat {
	long files;
	long long bytes;	/* apparent size */
	long long disk;		/* allocated blocks */
};

static struct dirstat
dir_stat(const char *path)
{
	struct dirstat d = {0};

	walk_files = 0;
	walk_bytes = 0;
	walk_disk = 0;
	if (nftw(path, walk_cb, 16, FTW_PHYS) == 0) {
		d.files = walk_files;
		d.bytes = walk_bytes;
		d.disk = walk_disk;
	}
	return d;
}

/****************************************************************
 * Load real records from muddb
 ****************************************************************/

static int
load_records(MUDDB *db)
{
	for (int d = 0; domains[d]; d++) {
		MUDDB_ITER *it = muddb_iter_begin(db, domains[d]);

		if (!it)
			continue;

		const char *key;

		while ((key = muddb_iter_next(it))) {
			if (record_count >= MAX_RECORDS) {
				muddb_iter_end(it);
				return -1;
			}

			OBJ *obj = muddb_iter_value(it);

			if (!obj)
				continue;
			records[record_count].domain = domains[d];
			records[record_count].id = strdup(key);
			records[record_count].obj = obj;
			record_count++;
		}
		muddb_iter_end(it);
	}
	return 0;
}

/****************************************************************
 * Edit sequence -- identical for both backends
 ****************************************************************/

static void
apply_edit(struct rec *r, int round, int edit)
{
	char val[64];

	snprintf(val, sizeof(val), "round-%d-edit-%d", round, edit);
	obj_prop_set(r->obj, "bench.n", val);
}

/****************************************************************
 * Main
 ****************************************************************/

int
main(int argc, char **argv)
{
	if (argc < 3) {
		fprintf(stderr,
			"usage: %s <muddb-path> <workdir> [rounds] [edits]\n"
			"muddb-path must be a scratch COPY of the database:"
			" the benchmark writes to it.\n",
			argv[0]);
		return EXIT_FAILURE;
	}

	const char *dbpath = argv[1];
	const char *workdir = argv[2];
	int rounds = (argc > 3) ? atoi(argv[3]) : DEFAULT_ROUNDS;
	int edits = (argc > 4) ? atoi(argv[4]) : DEFAULT_EDITS;

	MUDDB *db = muddb_open(dbpath, 0);

	if (!db) {
		fprintf(stderr, "cannot open muddb at %s\n", dbpath);
		return EXIT_FAILURE;
	}
	if (load_records(db) != 0 || record_count == 0) {
		fprintf(stderr, "no records loaded\n");
		return EXIT_FAILURE;
	}

	long long json_total = 0;

	for (int i = 0; i < record_count; i++)
		json_total += (long long)obj_json_len(records[i].obj);

	char mdbfile[512];

	snprintf(mdbfile, sizeof(mdbfile), "%s/data.mdb", dbpath);

	struct dirstat lmdb0 = dir_stat(mdbfile);

	printf("== baseline ==\n");
	printf("objects: %d, json payload: %lld bytes\n",
		record_count, json_total);
	printf("lmdb data.mdb: %lld bytes apparent, %lld on disk\n",
		lmdb0.bytes, lmdb0.disk);
	printf("workload: %d rounds x %d edits (%d puts)\n\n",
		rounds, edits, rounds * edits);

	/* --- CAS import ------------------------------------------- */
	char depot[512];

	if (mkdir(workdir, 0755) != 0 && errno != EEXIST) {
		fprintf(stderr, "cannot create workdir %s\n", workdir);
		return EXIT_FAILURE;
	}
	snprintf(depot, sizeof(depot), "%s/depot", workdir);

	struct cas *store = cas_new(depot);
	struct cas_tree *ct = cas_tree_new(store);

	if (!store || !ct) {
		fprintf(stderr, "cannot create CAS store\n");
		return EXIT_FAILURE;
	}
	cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

	OBJ_CACHE *cache[8] = {0};

	for (int d = 0; domains[d]; d++) {
		cache[d] = obj_cache_cas_new(ct, "world", domains[d], 64);
		/* explicit GC below; keep churn timing clean */
		obj_cache_cas_gc_policy(cache[d], 0, 0);
	}

	double t0 = now_ms();

	for (int i = 0; i < record_count; i++) {
		for (int d = 0; domains[d]; d++) {
			if (records[i].domain == domains[d]) {
				obj_cache_cas_put(cache[d], records[i].id,
					records[i].obj);
				break;
			}
		}
	}
	for (int d = 0; domains[d]; d++)
		obj_cache_cas_commit(cache[d], "import");

	double t_import = now_ms() - t0;
	struct dirstat cas0 = dir_stat(depot);

	printf("== CAS import (all objects, one commit per domain) ==\n");
	printf("time: %.1f ms\n", t_import);
	printf("depot: %ld files, %lld bytes apparent, %lld on disk\n\n",
		cas0.files, cas0.bytes, cas0.disk);

	/* --- CAS churn --------------------------------------------- */
	t0 = now_ms();
	for (int r = 0; r < rounds; r++) {
		for (int e = 0; e < edits; e++) {
			struct rec *rec =
				&records[(r * edits + e) % record_count];

			apply_edit(rec, r, e);
			for (int d = 0; domains[d]; d++) {
				if (rec->domain == domains[d]) {
					obj_cache_cas_put(cache[d], rec->id,
						rec->obj);
					break;
				}
			}
		}
		for (int d = 0; domains[d]; d++)
			if (obj_cache_cas_pending(cache[d]))
				obj_cache_cas_commit(cache[d], "churn");
	}

	double t_cas_churn = now_ms() - t0;
	struct dirstat cas1 = dir_stat(depot);

	printf("== CAS churn (%d rounds, commit per touched domain) ==\n",
		rounds);
	printf("time: %.1f ms total, %.2f ms/round\n",
		t_cas_churn, t_cas_churn / rounds);
	printf("depot: %ld files (+%ld), %lld bytes (+%lld),"
		" %lld on disk (+%lld)\n",
		cas1.files, cas1.files - cas0.files,
		cas1.bytes, cas1.bytes - cas0.bytes,
		cas1.disk, cas1.disk - cas0.disk);
	printf("growth per round: %.1f files, %.0f bytes apparent\n\n",
		(double)(cas1.files - cas0.files) / rounds,
		(double)(cas1.bytes - cas0.bytes) / rounds);

	/* --- CAS GC ------------------------------------------------ */
	int removed = 0;

	t0 = now_ms();
	obj_cache_cas_gc(cache[0], 0, &removed);

	double t_gc = now_ms() - t0;
	struct dirstat cas2 = dir_stat(depot);

	printf("== CAS gc (grace 0) ==\n");
	printf("time: %.1f ms, removed: %d objects\n", t_gc, removed);
	printf("depot after gc: %ld files, %lld bytes apparent,"
		" %lld on disk\n",
		cas2.files, cas2.bytes, cas2.disk);
	printf("(history is retained by design: every commit stays"
		" reachable via the ref log)\n\n");

	/* --- LMDB churn (same edit sequence) ----------------------- */
	t0 = now_ms();
	for (int r = 0; r < rounds; r++) {
		for (int e = 0; e < edits; e++) {
			struct rec *rec =
				&records[(r * edits + e) % record_count];

			apply_edit(rec, r, e);
			muddb_put(db, rec->domain, rec->id, rec->obj);
		}
	}

	double t_lmdb_churn = now_ms() - t0;
	struct dirstat lmdb1 = dir_stat(mdbfile);

	printf("== LMDB churn (%d rounds, txn per put) ==\n", rounds);
	printf("time: %.1f ms total, %.2f ms/round\n",
		t_lmdb_churn, t_lmdb_churn / rounds);
	printf("data.mdb: %lld bytes apparent (+%lld),"
		" %lld on disk (+%lld)\n\n",
		lmdb1.bytes, lmdb1.bytes - lmdb0.bytes,
		lmdb1.disk, lmdb1.disk - lmdb0.disk);

	/* --- summary ------------------------------------------------ */
	printf("== summary ==\n");
	printf("%-28s %14s %14s\n", "", "CAS", "LMDB");
	printf("%-28s %11.1f ms %11.1f ms\n", "churn time",
		t_cas_churn, t_lmdb_churn);
	printf("%-28s %10lld B %10lld B\n", "disk growth over churn",
		cas1.disk - cas0.disk, lmdb1.disk - lmdb0.disk);
	printf("%-28s %14lld %14lld\n", "disk total after",
		cas2.disk, lmdb1.disk);

	/* --- teardown ----------------------------------------------- */
	for (int d = 0; domains[d]; d++)
		obj_cache_cas_free(cache[d]);
	cas_tree_free(ct);
	cas_free(store);
	for (int i = 0; i < record_count; i++) {
		free(records[i].id);
		obj_free(records[i].obj);
	}
	muddb_close(db);
	return EXIT_SUCCESS;
}
