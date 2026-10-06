/* cas-gc.c : reachability mark-and-sweep garbage collection for cas-tree */

#define _POSIX_C_SOURCE 200809L

#include "cas-tree.h"
#include "cas-pack.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

struct hash_set {
    char (*hashes)[CAS_HASH_HEX + 1];
    int count;
    int cap;
};

static void
hash_set_init(struct hash_set *hs)
{
    hs->hashes = NULL;
    hs->count = 0;
    hs->cap = 0;
}

static void
hash_set_free(struct hash_set *hs)
{
    free(hs->hashes);
    hs->hashes = NULL;
    hs->count = 0;
    hs->cap = 0;
}

static int
hash_set_contains(struct hash_set *hs, const char *hash)
{
    for (int i = 0; i < hs->count; i++)
        if (strcmp(hs->hashes[i], hash) == 0)
            return 1;
    return 0;
}

static int
hash_set_add(struct hash_set *hs, const char *hash)
{
    if (hash_set_contains(hs, hash))
        return CAS_OK;
    if (hs->count >= hs->cap) {
        int newcap = hs->cap ? hs->cap * 2 : 64;
        void *p = realloc(hs->hashes,
            (size_t)newcap * sizeof(*hs->hashes));

        if (!p)
            return CAS_ENOMEM;
        hs->hashes = p;
        hs->cap = newcap;
    }
    memcpy(hs->hashes[hs->count++], hash, CAS_HASH_HEX + 1);
    return CAS_OK;
}

static int
mark_tree(struct cas_tree *ct, struct hash_set *reachable,
          const char *tree_hash)
{
    if (hash_set_contains(reachable, tree_hash))
        return CAS_OK;
    if (hash_set_add(reachable, tree_hash) != CAS_OK)
        return CAS_ENOMEM;

    struct cas_tree_dir dir;
    int rc = cas_tree_load(ct, tree_hash, &dir);

    /* A missing object is a sparse boundary, not an error: history may
     * have been pruned out from under a still-referenced ref.  The hash
     * stays marked (harmless, nothing to sweep) and we stop descending
     * here since the entry list is gone.  Corruption or I/O errors are
     * still real failures and abort the mark. */
    if (rc == CAS_ENOTFOUND)
        return CAS_OK;
    if (rc != CAS_OK)
        return rc;

    for (int i = 0; i < dir.count; i++) {
        struct cas_tree_entry *e = &dir.entries[i];
        int type = e->mode & CAS_TREE_S_IFMT;

        if (type == CAS_TREE_S_IFDIR) {
            rc = mark_tree(ct, reachable, e->hash);
            if (rc != CAS_OK) {
                cas_tree_dir_free(&dir);
                return rc;
            }
        } else {
            if (hash_set_add(reachable, e->hash) != CAS_OK) {
                cas_tree_dir_free(&dir);
                return CAS_ENOMEM;
            }
        }
    }

    cas_tree_dir_free(&dir);
    return CAS_OK;
}

struct mark_ref_ctx {
    struct cas_tree *ct;
    struct hash_set *reachable;
    int rc;
};

static int
mark_log_entry(const char *hash, int64_t time_s, int32_t time_ns,
               const char *comment, void *ctx)
{
    (void)time_s;
    (void)time_ns;
    (void)comment;
    struct mark_ref_ctx *mc = ctx;

    int rc = mark_tree(mc->ct, mc->reachable, hash);

    if (rc != CAS_OK) {
        mc->rc = rc;
        return 1;
    }
    return 0;
}

static int
mark_ref(const char *name, void *ctx)
{
    struct mark_ref_ctx *mc = ctx;

    cas_tree_log_read(mc->ct, name, mark_log_entry, mc);
    return mc->rc != CAS_OK ? 1 : 0;
}

struct sweep_ctx {
    struct cas *store;
    struct hash_set *reachable;
    cas_tree_gc_fn fn;
    void *ctx;
    time_t cutoff;
    int removed;
};

static int
sweep_visitor(const char *hash, void *ctx)
{
    struct sweep_ctx *sc = ctx;

    if (hash_set_contains(sc->reachable, hash))
        return 0;

    if (sc->cutoff > 0) {
        time_t mtime;

        if (cas_object_mtime(sc->store, hash, &mtime) == CAS_OK &&
            mtime >= sc->cutoff)
            return 0;
    }

    if (cas_remove(sc->store, hash) == CAS_OK) {
        sc->removed++;
        if (sc->fn && sc->fn(hash, sc->ctx) != 0)
            return 1;
    }
    return 0;
}

int
cas_tree_gc(struct cas_tree *ct, time_t grace, cas_tree_gc_fn fn,
            void *ctx, int *removed)
{
    struct hash_set reachable;

    hash_set_init(&reachable);

    struct mark_ref_ctx mc = {
        .ct = ct,
        .reachable = &reachable,
        .rc = CAS_OK,
    };

    cas_tree_ref_foreach(ct, mark_ref, &mc);
    if (mc.rc != CAS_OK) {
        hash_set_free(&reachable);
        return mc.rc;
    }

    struct sweep_ctx sc = {
        .store = cas_tree_cas(ct),
        .reachable = &reachable,
        .fn = fn,
        .ctx = ctx,
        .cutoff = grace > 0 ? time(NULL) - grace : 0,
        .removed = 0,
    };

    cas_foreach(cas_tree_cas(ct), sweep_visitor, &sc);

    if (removed)
        *removed = sc.removed;

    hash_set_free(&reachable);
    return CAS_OK;
}

static int
keep_reachable(const char *hash, void *ctx)
{
    return hash_set_contains((struct hash_set *)ctx, hash);
}

int
cas_tree_gc_pack(struct cas_tree *ct, time_t grace, int policy, int codec,
                 cas_tree_gc_fn fn, void *ctx, int *removed,
                 uint64_t *reclaimed)
{
    struct hash_set reachable;

    hash_set_init(&reachable);

    struct mark_ref_ctx mc = {
        .ct = ct,
        .reachable = &reachable,
        .rc = CAS_OK,
    };

    cas_tree_ref_foreach(ct, mark_ref, &mc);
    if (mc.rc != CAS_OK) {
        hash_set_free(&reachable);
        return mc.rc;
    }

    struct cas *store = cas_tree_cas(ct);
    char path[512];

    if (snprintf(path, sizeof(path), "%s/pack.dat",
                 cas_basedir(store)) >= (int)sizeof(path)) {
        hash_set_free(&reachable);
        return CAS_ERR;
    }

    /* Rebuild the pack with only reachable objects.  Unreachable objects
     * are left out whether they were loose or already in the pack, so
     * garbage trapped in the pack is expunged here.  The depot write lock
     * is held for the store's lifetime, so this reachability set is a
     * consistent snapshot with no concurrent writer to race. */
    int rc = cas_pack_create_filtered(store, path, policy, codec,
                                      keep_reachable, &reachable);

    if (rc != CAS_OK) {
        hash_set_free(&reachable);
        return rc;
    }

    /* Reclaim the loose copies now safely in the pack (the reachable set),
     * which also points the live store at the rebuilt pack. */
    uint64_t rc_count = 0;

    cas_pack_reclaim(store, path, &rc_count);

    /* Sweep unreachable loose objects past the grace period, exactly as
     * cas_tree_gc does.  A recently written unreachable loose object stays,
     * protected by grace until its ref is created or it truly ages out. */
    struct sweep_ctx sc = {
        .store = store,
        .reachable = &reachable,
        .fn = fn,
        .ctx = ctx,
        .cutoff = grace > 0 ? time(NULL) - grace : 0,
        .removed = 0,
    };

    cas_foreach(store, sweep_visitor, &sc);

    if (removed)
        *removed = sc.removed;
    if (reclaimed)
        *reclaimed = rc_count;

    hash_set_free(&reachable);
    return CAS_OK;
}
