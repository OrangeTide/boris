/* test_cas_tree.c : unit tests for the CAS-Tree module */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#define _POSIX_C_SOURCE 200809L

#include "cas-tree.h"
#include "cas-pack.h"
#include "cas-codec.h"
#include "test.h"

#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static char tmpdir[] = "/tmp/test_cas_tree_XXXXXX";

static void
cleanup(void)
{
    char cmd[512];

    snprintf(cmd, sizeof(cmd), "rm -rf %s", tmpdir);
    if (system(cmd)) { /* best effort */ }
}

static struct cas *
make_store(const char *name)
{
    char depot[512];

    snprintf(depot, sizeof(depot), "%s/%s", tmpdir, name);
    return cas_new(depot);
}

/****************************************************************
 * Empty tree
 ****************************************************************/

static void
test_empty_tree(void)
{
    struct cas *store = make_store("empty");
    struct cas_tree *ct = cas_tree_new(store);

    ASSERT(ct != NULL);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);
    ASSERT_INT_EQ((int)strlen(hash), CAS_HASH_HEX);

    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct, hash, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 0);

    cas_tree_dir_free(&loaded);
    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Round trip
 ****************************************************************/

static void
test_tree_round_trip(void)
{
    struct cas *store = make_store("roundtrip");
    struct cas_tree *ct = cas_tree_new(store);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "hello", 5, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e1 = {
        .mode = 0100644,
        .uid = 1000,
        .gid = 1000,
        .mtime_s = 1700000000LL,
        .mtime_ns = 123456789,
    };

    memcpy(e1.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e1.name, "file.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e1), CAS_OK);

    struct cas_tree_entry e2 = {
        .mode = 0040755,
        .uid = 0,
        .gid = 0,
        .mtime_s = 1700000001LL,
        .mtime_ns = 0,
    };

    memset(e2.hash, 'a', CAS_HASH_HEX);
    e2.hash[CAS_HASH_HEX] = '\0';
    strcpy(e2.name, "subdir");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e2), CAS_OK);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct, hash, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 2);

    ASSERT_STR_EQ(loaded.entries[0].name, "file.txt");
    ASSERT_INT_EQ(loaded.entries[0].mode, 0100644);
    ASSERT_INT_EQ(loaded.entries[0].uid, 1000);
    ASSERT_INT_EQ(loaded.entries[0].gid, 1000);
    ASSERT(loaded.entries[0].mtime_s == 1700000000LL);
    ASSERT_INT_EQ(loaded.entries[0].mtime_ns, 123456789);
    ASSERT_STR_EQ(loaded.entries[0].hash, blob_hash);

    ASSERT_STR_EQ(loaded.entries[1].name, "subdir");
    ASSERT_INT_EQ(loaded.entries[1].mode, 0040755);

    cas_tree_dir_free(&loaded);
    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Deterministic hashing
 ****************************************************************/

static void
test_tree_deterministic(void)
{
    struct cas *store = make_store("deterministic");
    struct cas_tree *ct = cas_tree_new(store);

    struct cas_tree_entry ea = {
        .mode = 0100644,
        .mtime_s = 100,
    };

    memset(ea.hash, '0', CAS_HASH_HEX);
    ea.hash[CAS_HASH_HEX] = '\0';
    strcpy(ea.name, "alpha");

    struct cas_tree_entry eb = {
        .mode = 0100644,
        .mtime_s = 200,
    };

    memset(eb.hash, '1', CAS_HASH_HEX);
    eb.hash[CAS_HASH_HEX] = '\0';
    strcpy(eb.name, "beta");

    struct cas_tree_dir dir1;

    cas_tree_dir_init(&dir1);
    cas_tree_dir_add(&dir1, &ea);
    cas_tree_dir_add(&dir1, &eb);

    char h1[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir1, h1), CAS_OK);

    struct cas_tree_dir dir2;

    cas_tree_dir_init(&dir2);
    cas_tree_dir_add(&dir2, &eb);
    cas_tree_dir_add(&dir2, &ea);

    char h2[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir2, h2), CAS_OK);

    ASSERT_STR_EQ(h1, h2);

    cas_tree_dir_free(&dir1);
    cas_tree_dir_free(&dir2);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Ref commit and read
 ****************************************************************/

static void
test_ref_commit(void)
{
    struct cas *store = make_store("ref");
    struct cas_tree *ct = cas_tree_new(store);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);
    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", hash, "initial"),
                  CAS_OK);

    char read_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_ref_read(ct, "main", read_hash), CAS_OK);
    ASSERT_STR_EQ(read_hash, hash);

    ASSERT_INT_EQ(cas_tree_ref_read(ct, "nope", read_hash),
                  CAS_ENOTFOUND);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Log reading
 ****************************************************************/

struct log_entry {
    char hash[CAS_HASH_HEX + 1];
    char comment[256];
    int64_t time_s;
};

static int log_count;
static struct log_entry log_entries[8];

static int
log_cb(const char *hash, int64_t time_s, int32_t time_ns,
       const char *comment, void *ctx)
{
    (void)time_ns;
    (void)ctx;
    if (log_count >= 8)
        return -1;

    struct log_entry *e = &log_entries[log_count++];

    memcpy(e->hash, hash, CAS_HASH_HEX + 1);
    snprintf(e->comment, sizeof(e->comment), "%s", comment);
    e->time_s = time_s;
    return 0;
}

static void
test_log_read(void)
{
    struct cas *store = make_store("log");
    struct cas_tree *ct = cas_tree_new(store);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    char h1[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, h1), CAS_OK);
    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", h1, "first"),
                  CAS_OK);

    struct cas_tree_entry e = {
        .mode = 0100644,
    };

    memset(e.hash, '0', CAS_HASH_HEX);
    e.hash[CAS_HASH_HEX] = '\0';
    strcpy(e.name, "x");
    cas_tree_dir_add(&dir, &e);

    char h2[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, h2), CAS_OK);
    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", h2, "second"),
                  CAS_OK);

    log_count = 0;
    ASSERT_INT_EQ(cas_tree_log_read(ct, "main", log_cb, NULL),
                  CAS_OK);
    ASSERT_INT_EQ(log_count, 2);
    ASSERT_STR_EQ(log_entries[0].hash, h1);
    ASSERT_STR_EQ(log_entries[0].comment, "first");
    ASSERT_STR_EQ(log_entries[1].hash, h2);
    ASSERT_STR_EQ(log_entries[1].comment, "second");
    ASSERT(log_entries[0].time_s > 0);
    ASSERT(log_entries[1].time_s >= log_entries[0].time_s);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Name validation
 ****************************************************************/

static void
test_name_validation(void)
{
    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = {
        .mode = 0100644,
    };

    memset(e.hash, '0', CAS_HASH_HEX);
    e.hash[CAS_HASH_HEX] = '\0';

    e.name[0] = '\0';
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_ERR);

    strcpy(e.name, "a/b");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_ERR);

    strcpy(e.name, "a\nb");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_ERR);

    strcpy(e.name, "valid");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    cas_tree_dir_free(&dir);
}

/****************************************************************
 * Ref iteration
 ****************************************************************/

struct ref_collect {
	char names[8][256];
	int count;
};

static int
ref_collector(const char *name, void *ctx)
{
	struct ref_collect *rc = ctx;

	if (rc->count >= 8)
		return -1;
	snprintf(rc->names[rc->count], sizeof(rc->names[0]), "%s", name);
	rc->count++;
	return 0;
}

static void
test_ref_foreach(void)
{
	struct cas *store = make_store("ref_foreach");
	struct cas_tree *ct = cas_tree_new(store);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	char hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "alpha", hash, "init"),
	              CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "beta", hash, "init"),
	              CAS_OK);

	struct ref_collect rc = { .count = 0 };

	cas_tree_ref_foreach(ct, ref_collector, &rc);
	ASSERT_INT_EQ(rc.count, 2);

	int found_alpha = 0, found_beta = 0;

	for (int i = 0; i < rc.count; i++) {
		if (strcmp(rc.names[i], "alpha") == 0)
			found_alpha = 1;
		if (strcmp(rc.names[i], "beta") == 0)
			found_beta = 1;
	}
	ASSERT(found_alpha);
	ASSERT(found_beta);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Fsck -- clean store
 ****************************************************************/

struct tree_fsck_result {
	int ok;
	int missing;
	int corrupt;
	int bad_tree;
	int total;
};

static int
tree_fsck_counter(const char *path, const char *hash, int status,
                  void *ctx)
{
	(void)path;
	(void)hash;
	struct tree_fsck_result *r = ctx;

	r->total++;
	if (status == CAS_TREE_FSCK_OK)
		r->ok++;
	else if (status == CAS_TREE_FSCK_MISSING)
		r->missing++;
	else if (status == CAS_TREE_FSCK_CORRUPT)
		r->corrupt++;
	else if (status == CAS_TREE_FSCK_BAD_TREE)
		r->bad_tree++;
	return 0;
}

static void
test_fsck_clean(void)
{
	struct cas *store = make_store("fsck_clean");
	struct cas_tree *ct = cas_tree_new(store);

	char blob_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "content", 7, blob_hash), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e = {
		.mode = 0100644,
	};

	memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
	strcpy(e.name, "file.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_hash,
	              "v1"), CAS_OK);

	struct tree_fsck_result r = {0};

	ASSERT_INT_EQ(cas_tree_fsck(ct, tree_fsck_counter, &r), CAS_OK);
	ASSERT_INT_EQ(r.total, 0);
	ASSERT_INT_EQ(r.missing, 0);
	ASSERT_INT_EQ(r.corrupt, 0);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Fsck -- missing blob
 ****************************************************************/

static void
test_fsck_missing_blob(void)
{
	struct cas *store = make_store("fsck_missing");
	struct cas_tree *ct = cas_tree_new(store);

	char blob_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "data", 4, blob_hash), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e = {
		.mode = 0100644,
	};

	memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
	strcpy(e.name, "gone.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_hash,
	              "v1"), CAS_OK);

	ASSERT_INT_EQ(cas_remove(store, blob_hash), CAS_OK);

	struct tree_fsck_result r = {0};

	ASSERT_INT_EQ(cas_tree_fsck(ct, tree_fsck_counter, &r), CAS_ERR);
	ASSERT_INT_EQ(r.missing, 1);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Fsck -- corrupt blob
 ****************************************************************/

static void
test_fsck_corrupt_blob(void)
{
	struct cas *store = make_store("fsck_corrupt");
	struct cas_tree *ct = cas_tree_new(store);

	char blob_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "original", 8, blob_hash), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e = {
		.mode = 0100644,
	};

	memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
	strcpy(e.name, "bad.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_hash,
	              "v1"), CAS_OK);

	/* corrupt the blob by appending a byte */
	char path[512];

	snprintf(path, sizeof(path), "%s/%.2s/%s",
	         cas_basedir(store), blob_hash, blob_hash);
	FILE *fp = fopen(path, "a");

	ASSERT(fp != NULL);
	fputc('X', fp);
	fclose(fp);

	struct tree_fsck_result r = {0};

	ASSERT_INT_EQ(cas_tree_fsck(ct, tree_fsck_counter, &r), CAS_ERR);
	ASSERT_INT_EQ(r.corrupt, 1);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Fsck -- single root
 ****************************************************************/

static void
test_fsck_root(void)
{
	struct cas *store = make_store("fsck_root");
	struct cas_tree *ct = cas_tree_new(store);

	char blob_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "hello", 5, blob_hash), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e = {
		.mode = 0100644,
	};

	memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
	strcpy(e.name, "x");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);

	struct tree_fsck_result r = {0};

	ASSERT_INT_EQ(cas_tree_fsck_root(ct, tree_hash,
	              tree_fsck_counter, &r), CAS_OK);
	ASSERT_INT_EQ(r.total, 0);

	ASSERT_INT_EQ(cas_remove(store, blob_hash), CAS_OK);

	memset(&r, 0, sizeof(r));
	ASSERT_INT_EQ(cas_tree_fsck_root(ct, tree_hash,
	              tree_fsck_counter, &r), CAS_ERR);
	ASSERT_INT_EQ(r.missing, 1);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * GC -- remove unreachable
 ****************************************************************/

static void
test_gc_basic(void)
{
	struct cas *store = make_store("gc_basic");
	struct cas_tree *ct = cas_tree_new(store);

	char blob1[CAS_HASH_HEX + 1];
	char blob2[CAS_HASH_HEX + 1];
	char orphan[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "keep1", 5, blob1), CAS_OK);
	ASSERT_INT_EQ(cas_put(store, "keep2", 5, blob2), CAS_OK);
	ASSERT_INT_EQ(cas_put(store, "garbage", 7, orphan), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e1 = { .mode = 0100644 };

	memcpy(e1.hash, blob1, CAS_HASH_HEX + 1);
	strcpy(e1.name, "a.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e1), CAS_OK);

	struct cas_tree_entry e2 = { .mode = 0100644 };

	memcpy(e2.hash, blob2, CAS_HASH_HEX + 1);
	strcpy(e2.name, "b.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e2), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_hash,
	              "v1"), CAS_OK);

	/* orphan blob is not referenced by any tree */
	ASSERT(cas_exists(store, orphan));

	int removed = 0;

	ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_OK);
	ASSERT_INT_EQ(removed, 1);

	/* orphan is gone, reachable objects remain */
	ASSERT(!cas_exists(store, orphan));
	ASSERT(cas_exists(store, blob1));
	ASSERT(cas_exists(store, blob2));
	ASSERT(cas_exists(store, tree_hash));

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * GC -- preserves historical snapshots
 ****************************************************************/

static void
test_gc_preserves_history(void)
{
	struct cas *store = make_store("gc_history");
	struct cas_tree *ct = cas_tree_new(store);

	/* v1: one blob */
	char blob_v1[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "version1", 8, blob_v1), CAS_OK);

	struct cas_tree_dir dir1;

	cas_tree_dir_init(&dir1);

	struct cas_tree_entry e1 = { .mode = 0100644 };

	memcpy(e1.hash, blob_v1, CAS_HASH_HEX + 1);
	strcpy(e1.name, "file");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir1, &e1), CAS_OK);

	char tree_v1[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir1, tree_v1), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_v1, "v1"),
	              CAS_OK);

	/* v2: different blob */
	char blob_v2[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "version2", 8, blob_v2), CAS_OK);

	struct cas_tree_dir dir2;

	cas_tree_dir_init(&dir2);

	struct cas_tree_entry e2 = { .mode = 0100644 };

	memcpy(e2.hash, blob_v2, CAS_HASH_HEX + 1);
	strcpy(e2.name, "file");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir2, &e2), CAS_OK);

	char tree_v2[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir2, tree_v2), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_v2, "v2"),
	              CAS_OK);

	/* GC should remove nothing -- v1 blob is still reachable via log */
	int removed = 0;

	ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_OK);
	ASSERT_INT_EQ(removed, 0);

	ASSERT(cas_exists(store, blob_v1));
	ASSERT(cas_exists(store, blob_v2));
	ASSERT(cas_exists(store, tree_v1));
	ASSERT(cas_exists(store, tree_v2));

	cas_tree_dir_free(&dir1);
	cas_tree_dir_free(&dir2);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * GC -- empty store
 ****************************************************************/

static void
test_gc_empty(void)
{
	struct cas *store = make_store("gc_empty");
	struct cas_tree *ct = cas_tree_new(store);
	int removed = 0;

	ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_OK);
	ASSERT_INT_EQ(removed, 0);

	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * GC -- grace period protects young objects
 ****************************************************************/

static void
test_gc_grace_period(void)
{
	struct cas *store = make_store("gc_grace");
	struct cas_tree *ct = cas_tree_new(store);

	char blob1[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "keep", 4, blob1), CAS_OK);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	struct cas_tree_entry e = { .mode = 0100644 };

	memcpy(e.hash, blob1, CAS_HASH_HEX + 1);
	strcpy(e.name, "a.txt");
	ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

	char tree_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", tree_hash, "v1"),
	              CAS_OK);

	/* orphan blob -- unreachable but freshly created */
	char orphan[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_put(store, "orphan", 6, orphan), CAS_OK);
	ASSERT(cas_exists(store, orphan));

	/* GC with large grace period -- orphan is too young to collect */
	int removed = 0;

	ASSERT_INT_EQ(cas_tree_gc(ct, 3600, NULL, NULL, &removed),
	              CAS_OK);
	ASSERT_INT_EQ(removed, 0);
	ASSERT(cas_exists(store, orphan));

	/* GC with no grace period -- orphan is collected */
	ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_OK);
	ASSERT_INT_EQ(removed, 1);
	ASSERT(!cas_exists(store, orphan));

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Log truncation and sparse-tolerant GC
 ****************************************************************/

/* Commit a snapshot whose root tree holds one file "f" -> blob(content).
 * Returns the tree and blob hashes through tree_out / blob_out. */
static void
commit_file_snapshot(struct cas_tree *ct, struct cas *store,
                     const char *ref, const char *content,
                     const char *comment, char *tree_out,
                     char *blob_out)
{
    ASSERT_INT_EQ(cas_put(store, content, strlen(content), blob_out),
                  CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = { .mode = 0100644 };

    memcpy(e.hash, blob_out, CAS_HASH_HEX + 1);
    strcpy(e.name, "f");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);
    ASSERT_INT_EQ(cas_tree_store(ct, &dir, tree_out), CAS_OK);
    ASSERT_INT_EQ(cas_tree_ref_commit(ct, ref, tree_out, comment),
                  CAS_OK);
    cas_tree_dir_free(&dir);
}

static void
test_log_truncate_count(void)
{
    struct cas *store = make_store("trunc_count");
    struct cas_tree *ct = cas_tree_new(store);

    char tree[5][CAS_HASH_HEX + 1];
    char blob[5][CAS_HASH_HEX + 1];
    const char *content[5] = { "snap0", "snap1", "snap2",
                               "snap3", "snap4" };
    const char *comment[5] = { "v0", "v1", "v2", "v3", "v4" };

    for (int i = 0; i < 5; i++)
        commit_file_snapshot(ct, store, "main", content[i],
                             comment[i], tree[i], blob[i]);

    /* Invalid: no bound set would keep nothing. */
    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "main", 0, 0, NULL),
                  CAS_ERR);
    /* Invalid: bad ref name. */
    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "a/b", 3, 0, NULL),
                  CAS_ERR);
    /* No log for an unknown ref. */
    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "other", 3, 0, NULL),
                  CAS_ENOTFOUND);

    /* Keeping more than exist is a no-op. */
    int removed = -1;

    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "main", 10, 0, &removed),
                  CAS_OK);
    ASSERT_INT_EQ(removed, 0);

    log_count = 0;
    ASSERT_INT_EQ(cas_tree_log_read(ct, "main", log_cb, NULL), CAS_OK);
    ASSERT_INT_EQ(log_count, 5);

    /* Keep the last 2 entries. */
    removed = -1;
    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "main", 2, 0, &removed),
                  CAS_OK);
    ASSERT_INT_EQ(removed, 3);

    log_count = 0;
    ASSERT_INT_EQ(cas_tree_log_read(ct, "main", log_cb, NULL), CAS_OK);
    ASSERT_INT_EQ(log_count, 2);
    ASSERT_STR_EQ(log_entries[0].hash, tree[3]);
    ASSERT_STR_EQ(log_entries[0].comment, "v3");
    ASSERT_STR_EQ(log_entries[1].hash, tree[4]);
    ASSERT_STR_EQ(log_entries[1].comment, "v4");

    cas_tree_free(ct);
    cas_free(store);
}

static void
test_log_truncate_keeps_newest(void)
{
    struct cas *store = make_store("trunc_newest");
    struct cas_tree *ct = cas_tree_new(store);

    char tree[3][CAS_HASH_HEX + 1];
    char blob[3][CAS_HASH_HEX + 1];

    commit_file_snapshot(ct, store, "main", "a", "v0", tree[0],
                         blob[0]);
    commit_file_snapshot(ct, store, "main", "b", "v1", tree[1],
                         blob[1]);
    commit_file_snapshot(ct, store, "main", "c", "v2", tree[2],
                         blob[2]);

    /* An age cutoff far in the future would drop every entry, but the
     * newest must survive so GC still protects the live root. */
    int removed = -1;

    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "main", 0,
                                        (time_t)4102444800LL, &removed),
                  CAS_OK);
    ASSERT_INT_EQ(removed, 2);

    log_count = 0;
    ASSERT_INT_EQ(cas_tree_log_read(ct, "main", log_cb, NULL), CAS_OK);
    ASSERT_INT_EQ(log_count, 1);
    ASSERT_STR_EQ(log_entries[0].hash, tree[2]);

    /* GC must not sweep the live world after this. */
    int gc_removed = 0;

    ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &gc_removed), CAS_OK);
    ASSERT(cas_exists(store, tree[2]));
    ASSERT(cas_exists(store, blob[2]));

    cas_tree_free(ct);
    cas_free(store);
}

static void
test_prune_gc_reclaims(void)
{
    struct cas *store = make_store("prune_gc");
    struct cas_tree *ct = cas_tree_new(store);

    char tree[5][CAS_HASH_HEX + 1];
    char blob[5][CAS_HASH_HEX + 1];
    const char *content[5] = { "e0", "e1", "e2", "e3", "e4" };

    for (int i = 0; i < 5; i++)
        commit_file_snapshot(ct, store, "main", content[i], "v",
                             tree[i], blob[i]);

    int removed = 0;

    ASSERT_INT_EQ(cas_tree_log_truncate(ct, "main", 2, 0, &removed),
                  CAS_OK);
    ASSERT_INT_EQ(removed, 3);

    /* GC over the pruned depot: the mark phase never trips over the
     * now-unreferenced old objects, and the sweep reclaims them. */
    int gc_removed = 0;

    ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &gc_removed), CAS_OK);
    ASSERT_INT_EQ(gc_removed, 6);

    for (int i = 0; i < 3; i++) {
        ASSERT(!cas_exists(store, tree[i]));
        ASSERT(!cas_exists(store, blob[i]));
    }
    for (int i = 3; i < 5; i++) {
        ASSERT(cas_exists(store, tree[i]));
        ASSERT(cas_exists(store, blob[i]));
    }

    /* The two surviving snapshots still walk fully. */
    for (int i = 3; i < 5; i++) {
        struct cas_tree_dir d;

        ASSERT_INT_EQ(cas_tree_load(ct, tree[i], &d), CAS_OK);
        ASSERT_INT_EQ(d.count, 1);
        ASSERT(cas_exists(store, d.entries[0].hash));
        cas_tree_dir_free(&d);
    }

    /* fsck walks the live root only and stays clean after pruning. */
    ASSERT_INT_EQ(cas_tree_fsck(ct, NULL, NULL), CAS_OK);

    cas_tree_free(ct);
    cas_free(store);
}

static void
test_gc_sparse_boundary(void)
{
    struct cas *store = make_store("gc_sparse");
    struct cas_tree *ct = cas_tree_new(store);

    /* leaf blob */
    char leaf[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "leaf", 4, leaf), CAS_OK);

    /* subdirectory tree holding the leaf */
    struct cas_tree_dir sub;

    cas_tree_dir_init(&sub);

    struct cas_tree_entry fe = { .mode = 0100644 };

    memcpy(fe.hash, leaf, CAS_HASH_HEX + 1);
    strcpy(fe.name, "leaf");
    ASSERT_INT_EQ(cas_tree_dir_add(&sub, &fe), CAS_OK);

    char sub_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &sub, sub_hash), CAS_OK);
    cas_tree_dir_free(&sub);

    /* root tree referencing the subdirectory */
    struct cas_tree_dir root;

    cas_tree_dir_init(&root);

    struct cas_tree_entry de = { .mode = 0040000 };

    memcpy(de.hash, sub_hash, CAS_HASH_HEX + 1);
    strcpy(de.name, "d");
    ASSERT_INT_EQ(cas_tree_dir_add(&root, &de), CAS_OK);

    char root_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &root, root_hash), CAS_OK);
    cas_tree_dir_free(&root);

    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", root_hash, "v"),
                  CAS_OK);

    /* Manually prune the subtree object: the ref now references content
     * the depot no longer stores, a sparse reference. */
    ASSERT_INT_EQ(cas_remove(store, sub_hash), CAS_OK);
    ASSERT(!cas_exists(store, sub_hash));

    /* GC must treat the missing subtree as a boundary, not an error. */
    int removed = 0;

    ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_OK);
    ASSERT(cas_exists(store, root_hash));

    cas_tree_free(ct);
    cas_free(store);
}

static void
test_gc_corruption_still_errors(void)
{
    struct cas *store = make_store("gc_corrupt");
    struct cas_tree *ct = cas_tree_new(store);

    /* a blob object */
    char blob[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "x", 1, blob), CAS_OK);

    /* root tree with a directory entry pointing at the blob: a type
     * mismatch, which is corruption rather than a sparse boundary. */
    struct cas_tree_dir root;

    cas_tree_dir_init(&root);

    struct cas_tree_entry de = { .mode = 0040000 };

    memcpy(de.hash, blob, CAS_HASH_HEX + 1);
    strcpy(de.name, "d");
    ASSERT_INT_EQ(cas_tree_dir_add(&root, &de), CAS_OK);

    char root_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &root, root_hash), CAS_OK);
    cas_tree_dir_free(&root);

    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", root_hash, "v"),
                  CAS_OK);

    /* The mark phase must still abort on a real error. */
    int removed = 0;

    ASSERT_INT_EQ(cas_tree_gc(ct, 0, NULL, NULL, &removed), CAS_ETYPE);

    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Ref name validation
 ****************************************************************/

static void
test_ref_invalid_name(void)
{
	struct cas *store = make_store("ref_badname");
	struct cas_tree *ct = cas_tree_new(store);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	char hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "", hash, "x"), CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, ".", hash, "x"), CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "..", hash, "x"), CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "a/b", hash, "x"),
	              CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "a\\b", hash, "x"),
	              CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "a\nb", hash, "x"),
	              CAS_ERR);

	char read_hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_ref_read(ct, "", read_hash), CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_read(ct, "..", read_hash), CAS_ERR);

	ASSERT_INT_EQ(cas_tree_log_read(ct, "", NULL, NULL), CAS_ERR);
	ASSERT_INT_EQ(cas_tree_log_read(ct, "a/b", NULL, NULL), CAS_ERR);

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Ref hash validation
 ****************************************************************/

static void
test_ref_invalid_hash(void)
{
	struct cas *store = make_store("ref_badhash");
	struct cas_tree *ct = cas_tree_new(store);

	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", "bad", "x"),
	              CAS_ERR);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", "", "x"),
	              CAS_ERR);

	char almost[CAS_HASH_HEX + 1];

	memset(almost, 'g', CAS_HASH_HEX);
	almost[CAS_HASH_HEX] = '\0';
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "main", almost, "x"),
	              CAS_ERR);

	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Log tolerates truncated final line
 ****************************************************************/

static void
test_log_truncated(void)
{
	struct cas *store = make_store("log_trunc");
	struct cas_tree *ct = cas_tree_new(store);

	struct cas_tree_dir dir;

	cas_tree_dir_init(&dir);

	char hash[CAS_HASH_HEX + 1];

	ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);
	ASSERT_INT_EQ(cas_tree_ref_commit(ct, "trunc", hash, "good"),
	              CAS_OK);

	/* append a truncated line (no trailing newline) to simulate crash */
	char logpath[512];

	snprintf(logpath, sizeof(logpath), "%s/refs/trunc.log",
	         cas_basedir(store));
	FILE *fp = fopen(logpath, "a");

	ASSERT(fp != NULL);
	fprintf(fp, "%s 999 0 partial", hash);
	fclose(fp);

	/* log_read should return the one good entry, skip the truncated one */
	log_count = 0;
	ASSERT_INT_EQ(cas_tree_log_read(ct, "trunc", log_cb, NULL),
	              CAS_OK);
	ASSERT_INT_EQ(log_count, 1);
	ASSERT_STR_EQ(log_entries[0].comment, "good");

	cas_tree_dir_free(&dir);
	cas_tree_free(ct);
	cas_free(store);
}

/****************************************************************
 * Htree: round trip
 ****************************************************************/

static void
test_htree_round_trip(void)
{
    struct cas *store = make_store("htree_rt");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "hello", 5, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e1 = {
        .mode = 0100644,
        .uid = 1000,
        .gid = 1000,
        .mtime_s = 1700000000LL,
        .mtime_ns = 123456789,
    };

    memcpy(e1.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e1.name, "file.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e1), CAS_OK);

    struct cas_tree_entry e2 = {
        .mode = 0040755,
        .uid = 0,
        .gid = 0,
        .mtime_s = 1700000001LL,
        .mtime_ns = 0,
    };

    memset(e2.hash, 'a', CAS_HASH_HEX);
    e2.hash[CAS_HASH_HEX] = '\0';
    strcpy(e2.name, "subdir");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e2), CAS_OK);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct, hash, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 2);

    ASSERT_STR_EQ(loaded.entries[0].name, "file.txt");
    ASSERT_INT_EQ(loaded.entries[0].mode, 0100644);
    ASSERT_INT_EQ(loaded.entries[0].uid, 1000);
    ASSERT_INT_EQ(loaded.entries[0].gid, 1000);
    ASSERT_INT_EQ((int)(loaded.entries[0].mtime_s >> 32), 0);
    ASSERT_INT_EQ((int)loaded.entries[0].mtime_s, 1700000000);
    ASSERT_INT_EQ(loaded.entries[0].mtime_ns, 123456789);
    ASSERT_STR_EQ(loaded.entries[0].hash, blob_hash);

    ASSERT_STR_EQ(loaded.entries[1].name, "subdir");
    ASSERT_INT_EQ(loaded.entries[1].mode, 0040755);

    cas_tree_dir_free(&loaded);
    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: same hash as text tree
 ****************************************************************/

static void
test_htree_same_hash(void)
{
    struct cas *store_text = make_store("htree_hash_txt");
    struct cas *store_htree = make_store("htree_hash_ht");
    struct cas_tree *ct_text = cas_tree_new(store_text);
    struct cas_tree *ct_htree = cas_tree_new(store_htree);

    cas_tree_set_flags(ct_htree, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store_text, "data", 4, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = {
        .mode = 0100644,
        .uid = 500,
        .gid = 500,
        .mtime_s = 1700000000LL,
        .mtime_ns = 0,
    };

    memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e.name, "test.dat");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    char hash_text[CAS_HASH_HEX + 1];
    char hash_htree[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct_text, &dir, hash_text), CAS_OK);
    ASSERT_INT_EQ(cas_tree_store(ct_htree, &dir, hash_htree), CAS_OK);
    ASSERT_STR_EQ(hash_text, hash_htree);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct_htree);
    cas_tree_free(ct_text);
    cas_free(store_htree);
    cas_free(store_text);
}

/****************************************************************
 * Htree: O(1) lookup
 ****************************************************************/

static void
test_htree_lookup(void)
{
    struct cas *store = make_store("htree_lookup");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char h1[CAS_HASH_HEX + 1], h2[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "aaa", 3, h1), CAS_OK);
    ASSERT_INT_EQ(cas_put(store, "bbb", 3, h2), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e1 = {
        .mode = 0100644, .uid = 1, .gid = 2,
        .mtime_s = 100, .mtime_ns = 50,
    };

    memcpy(e1.hash, h1, CAS_HASH_HEX + 1);
    strcpy(e1.name, "alpha.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e1), CAS_OK);

    struct cas_tree_entry e2 = {
        .mode = 0100755, .uid = 3, .gid = 4,
        .mtime_s = 200, .mtime_ns = 99,
    };

    memcpy(e2.hash, h2, CAS_HASH_HEX + 1);
    strcpy(e2.name, "beta.bin");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e2), CAS_OK);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_entry found;

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "beta.bin", &found),
                  CAS_OK);
    ASSERT_STR_EQ(found.name, "beta.bin");
    ASSERT_INT_EQ(found.mode, 0100755);
    ASSERT_INT_EQ(found.uid, 3);
    ASSERT_INT_EQ(found.gid, 4);
    ASSERT_INT_EQ((int)found.mtime_s, 200);
    ASSERT_INT_EQ(found.mtime_ns, 99);
    ASSERT_STR_EQ(found.hash, h2);

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "alpha.txt", &found),
                  CAS_OK);
    ASSERT_STR_EQ(found.name, "alpha.txt");
    ASSERT_STR_EQ(found.hash, h1);

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "missing", &found),
                  CAS_ENOTFOUND);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: empty tree
 ****************************************************************/

static void
test_htree_empty(void)
{
    struct cas *store = make_store("htree_empty");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct, hash, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 0);

    struct cas_tree_entry found;

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "anything", &found),
                  CAS_ENOTFOUND);

    cas_tree_dir_free(&loaded);
    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: fsck validates htree objects
 ****************************************************************/

static void
test_htree_fsck(void)
{
    struct cas *store = make_store("htree_fsck");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "data", 4, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = {
        .mode = 0100644, .uid = 0, .gid = 0,
        .mtime_s = 1700000000LL, .mtime_ns = 0,
    };

    memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e.name, "file.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);
    ASSERT_INT_EQ(cas_tree_ref_commit(ct, "htfsck", hash, "test"),
                  CAS_OK);
    ASSERT_INT_EQ(cas_tree_fsck(ct, NULL, NULL), CAS_OK);
    ASSERT_INT_EQ(cas_tree_fsck_root(ct, hash, NULL, NULL), CAS_OK);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: text tree lookup works too
 ****************************************************************/

static void
test_text_tree_lookup(void)
{
    struct cas *store = make_store("text_lookup");
    struct cas_tree *ct = cas_tree_new(store);

    char h1[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "x", 1, h1), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = {
        .mode = 0100644, .uid = 0, .gid = 0,
        .mtime_s = 100, .mtime_ns = 0,
    };

    memcpy(e.hash, h1, CAS_HASH_HEX + 1);
    strcpy(e.name, "only.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_entry found;

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "only.txt", &found),
                  CAS_OK);
    ASSERT_STR_EQ(found.hash, h1);
    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "nope", &found),
                  CAS_ENOTFOUND);

    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: many entries (hash collision coverage)
 ****************************************************************/

static void
test_htree_many_entries(void)
{
    struct cas *store = make_store("htree_many");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "x", 1, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    for (int i = 0; i < 512; i++) {
        struct cas_tree_entry e = {
            .mode = 0100644, .uid = i, .gid = 0,
            .mtime_s = (int64_t)i, .mtime_ns = 0,
        };

        memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
        snprintf(e.name, sizeof(e.name), "file_%04d.txt", i);
        ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);
    }

    char hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, hash), CAS_OK);

    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct, hash, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 512);

    struct cas_tree_entry found;

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "file_0000.txt", &found),
                  CAS_OK);
    ASSERT_INT_EQ(found.uid, 0);

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "file_0255.txt", &found),
                  CAS_OK);
    ASSERT_INT_EQ(found.uid, 255);

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "file_0511.txt", &found),
                  CAS_OK);
    ASSERT_INT_EQ(found.uid, 511);

    ASSERT_INT_EQ(cas_tree_lookup(ct, hash, "file_0512.txt", &found),
                  CAS_ENOTFOUND);

    ASSERT_INT_EQ(cas_tree_fsck_root(ct, hash, NULL, NULL), CAS_OK);

    cas_tree_dir_free(&loaded);
    cas_tree_dir_free(&dir);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Htree: survives a bundle import
 *
 * An htree object is stored at the address of its canonical text
 * form, not of its own bytes.  cas_pack_import must preserve that
 * address (store the htree verbatim) rather than recompute it, or the
 * imported directory would be unreadable.
 ****************************************************************/

static void
test_htree_pack_import(void)
{
    char packpath[512];

    snprintf(packpath, sizeof(packpath), "%s/htree.pack", tmpdir);

    struct cas *src = make_store("htimp_src");
    struct cas_tree *ct = cas_tree_new(src);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(src, "payload", 7, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = {
        .mode = 0100644,
        .uid = 1000,
        .gid = 1000,
        .mtime_s = 1700000000LL,
    };

    memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e.name, "file.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    char root[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, root), CAS_OK);
    cas_tree_dir_free(&dir);
    ASSERT_INT_EQ(cas_pack_create(src, packpath), CAS_OK);
    cas_tree_free(ct);
    cas_free(src);

    /* import the bundle into a fresh depot */
    struct cas *tgt = make_store("htimp_tgt");
    struct cas_pack *pack = cas_pack_open(packpath);

    ASSERT(pack != NULL);

    uint64_t total = 0, stored = 0;

    ASSERT_INT_EQ(cas_pack_import(pack, tgt, CAS_COMPRESS_NEVER,
                  CAS_CODEC_NONE, &total, &stored), CAS_OK);
    ASSERT_INT_EQ((int)total, 2);
    ASSERT_INT_EQ((int)stored, 2);
    cas_pack_close(pack);

    /* the htree root kept its address and reads back as a directory */
    ASSERT(cas_exists(tgt, root));
    ASSERT(cas_exists(tgt, blob_hash));

    struct cas_tree *ct2 = cas_tree_new(tgt);
    struct cas_tree_dir loaded;

    ASSERT_INT_EQ(cas_tree_load(ct2, root, &loaded), CAS_OK);
    ASSERT_INT_EQ(loaded.count, 1);
    ASSERT_STR_EQ(loaded.entries[0].name, "file.txt");
    ASSERT_STR_EQ(loaded.entries[0].hash, blob_hash);

    cas_tree_dir_free(&loaded);
    cas_tree_free(ct2);
    cas_free(tgt);
}

/****************************************************************
 * Htree: object-layer fsck reports it as a skip, not corrupt
 *
 * An htree is addressed by its canonical text form, so cas_fsck and
 * cas_pack_fsck cannot verify it by re-hashing its bytes.  They must
 * report CAS_FSCK_REENCODED (a skip) instead of CAS_FSCK_CORRUPT, and
 * still count self-addressed objects normally.
 ****************************************************************/

struct fsck_tally {
    int ok;
    int reencoded;
    int other;
};

static int
fsck_tallier(const char *hash, int status, void *ctx)
{
    struct fsck_tally *t = ctx;

    (void)hash;
    if (status == CAS_FSCK_OK)
        t->ok++;
    else if (status == CAS_FSCK_REENCODED)
        t->reencoded++;
    else
        t->other++;
    return 0;
}

static void
test_htree_fsck_skips(void)
{
    char packpath[512];

    snprintf(packpath, sizeof(packpath), "%s/htfsck.pack", tmpdir);

    struct cas *store = make_store("htfsck");
    struct cas_tree *ct = cas_tree_new(store);

    cas_tree_set_flags(ct, CAS_TREE_USE_HTREE);

    char blob_hash[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_put(store, "payload", 7, blob_hash), CAS_OK);

    struct cas_tree_dir dir;

    cas_tree_dir_init(&dir);

    struct cas_tree_entry e = { .mode = 0100644 };

    memcpy(e.hash, blob_hash, CAS_HASH_HEX + 1);
    strcpy(e.name, "file.txt");
    ASSERT_INT_EQ(cas_tree_dir_add(&dir, &e), CAS_OK);

    char root[CAS_HASH_HEX + 1];

    ASSERT_INT_EQ(cas_tree_store(ct, &dir, root), CAS_OK);
    cas_tree_dir_free(&dir);

    /* object-layer fsck: htree is a skip, blob verifies normally */
    ASSERT_INT_EQ(cas_fsck_object(store, root), CAS_FSCK_REENCODED);
    ASSERT_INT_EQ(cas_fsck_object(store, blob_hash), CAS_FSCK_OK);

    /* whole-store fsck: htree counted as a skip, not an error */
    struct fsck_tally wt = {0};

    ASSERT_INT_EQ(cas_fsck(store, fsck_tallier, &wt), CAS_OK);
    ASSERT_INT_EQ(wt.ok, 1);
    ASSERT_INT_EQ(wt.reencoded, 1);
    ASSERT_INT_EQ(wt.other, 0);

    /* pack fsck: htree reported reencoded, blob ok, no errors */
    ASSERT_INT_EQ(cas_pack_create(store, packpath), CAS_OK);

    struct cas_pack *pack = cas_pack_open(packpath);

    ASSERT(pack != NULL);

    struct fsck_tally t = {0};

    ASSERT_INT_EQ(cas_pack_fsck(pack, fsck_tallier, &t), CAS_OK);
    ASSERT_INT_EQ(t.ok, 1);
    ASSERT_INT_EQ(t.reencoded, 1);
    ASSERT_INT_EQ(t.other, 0);

    cas_pack_close(pack);
    cas_tree_free(ct);
    cas_free(store);
}

/****************************************************************
 * Main
 ****************************************************************/

int
main(void)
{
    if (!mkdtemp(tmpdir)) {
        perror("mkdtemp");
        return 1;
    }
    atexit(cleanup);

    fprintf(stderr, "--- cas-tree tests ---\n");

    RUN(test_empty_tree);
    RUN(test_tree_round_trip);
    RUN(test_tree_deterministic);
    RUN(test_ref_commit);
    RUN(test_log_read);
    RUN(test_name_validation);
    RUN(test_ref_foreach);
    RUN(test_fsck_clean);
    RUN(test_fsck_missing_blob);
    RUN(test_fsck_corrupt_blob);
    RUN(test_fsck_root);
    RUN(test_gc_basic);
    RUN(test_gc_preserves_history);
    RUN(test_gc_empty);
    RUN(test_gc_grace_period);
    RUN(test_log_truncate_count);
    RUN(test_log_truncate_keeps_newest);
    RUN(test_prune_gc_reclaims);
    RUN(test_gc_sparse_boundary);
    RUN(test_gc_corruption_still_errors);
    RUN(test_ref_invalid_name);
    RUN(test_ref_invalid_hash);
    RUN(test_log_truncated);
    RUN(test_htree_round_trip);
    RUN(test_htree_same_hash);
    RUN(test_htree_lookup);
    RUN(test_htree_empty);
    RUN(test_htree_fsck);
    RUN(test_text_tree_lookup);
    RUN(test_htree_many_entries);
    RUN(test_htree_pack_import);
    RUN(test_htree_fsck_skips);

    TEST_REPORT();
}
