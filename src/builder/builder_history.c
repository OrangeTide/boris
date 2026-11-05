/* builder_history.c : builder-facing world-history workflows */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "builder"

#include "builder_history.h"
#include "builder_snapshot.h"
#include "world_restore.h"

#include "obj.h"			/* OBJ_PATH_MAX */

#include <cas.h>
#include <cas-tree.h>

#include <log.h>

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Process-lifetime cursor and checkout tables. Both are small: one entry per
 * (builder, zone) being navigated or per (builder, name) checked out. The
 * tables reset on restart, which is the chosen cursor-persistence model
 * (spec section 14). */
#define NAV_MAX      64
#define CHECKOUT_MAX 64

#define HASHLEN (CAS_HASH_HEX + 1)

/* Prefix that namespaces a wizard checkpoint ref away from the "world" ref, so
 * a checkpoint is spared world-log truncation (spec section 4.3). Ref names
 * cannot contain '/', so the spec's "refs/<label>" becomes this flat form. */
#define CHECKPOINT_PREFIX "cp-"

/* --- small shared helpers -------------------------------------------- */

static void
setmsg(char *msg, size_t msglen, const char *fmt, ...)
{
	va_list ap;

	if (!msg || msglen == 0)
		return;
	va_start(ap, fmt);
	vsnprintf(msg, msglen, fmt, ap);
	va_end(ap);
}

static struct cas_tree *
hist_tree(void)
{
	return builder_snapshot_tree();
}

static int
world_tip(struct cas_tree *ct, char *out)
{
	return cas_tree_ref_read(ct, BUILDER_SNAPSHOT_REF, out) == CAS_OK
		? 0 : -1;
}

/* The slug of a "zone/<slug>[/...]" path, written to buf. Returns 0, or -1 if
 * the path is not under "zone/" with a non-empty first segment. */
static int
zone_slug(const char *zone_path, char *buf, size_t len)
{
	const char *p;
	size_t n;

	if (!zone_path || strncmp(zone_path, "zone/", 5) != 0)
		return -1;
	p = zone_path + 5;
	n = strcspn(p, "/");
	if (n == 0 || n >= len)
		return -1;
	memcpy(buf, p, n);
	buf[n] = '\0';
	return 0;
}

/* Hash of the "<domain>/<key_prefix>" directory in root, or -1 if the subtree
 * is absent. Used for the publish fork-point guard: a zone's subtree hash is a
 * stable fingerprint of its contents. */
static int
subtree_hash(struct cas_tree *ct, const char *root, const char *key_prefix,
	char *out)
{
	char path[OBJ_PATH_MAX];
	char cur[HASHLEN];
	const char *p;

	if ((size_t)snprintf(path, sizeof path, "%s/%s",
		BUILDER_SNAPSHOT_DOMAIN, key_prefix) >= sizeof path)
		return -1;

	memcpy(cur, root, CAS_HASH_HEX);
	cur[CAS_HASH_HEX] = '\0';

	for (p = path; *p; ) {
		const char *slash = strchr(p, '/');
		size_t clen = slash ? (size_t)(slash - p) : strlen(p);
		char comp[CAS_TREE_NAME_MAX + 1];
		struct cas_tree_entry e;

		if (clen == 0 || clen > CAS_TREE_NAME_MAX)
			return -1;
		memcpy(comp, p, clen);
		comp[clen] = '\0';
		if (cas_tree_lookup(ct, cur, comp, &e) != CAS_OK)
			return -1;
		if ((e.mode & CAS_TREE_S_IFMT) != CAS_TREE_S_IFDIR)
			return -1;
		memcpy(cur, e.hash, CAS_HASH_HEX);
		cur[CAS_HASH_HEX] = '\0';
		p = slash ? slash + 1 : p + clen;
	}
	memcpy(out, cur, HASHLEN);
	return 0;
}

/* After a restore writes a subtree into live, record it as a snapshot so the
 * world tip keeps tracking the live store and the operation itself lands in
 * history (spec section 6.1). Best-effort: a failed recording is logged by the
 * bridge and does not undo the live change. */
static void
record_subtree(const char *dst_prefix, const char *user, const char *verb)
{
	char slug[64], comment[200];

	if (zone_slug(dst_prefix, slug, sizeof slug) == 0)
		snprintf(comment, sizeof comment, "%s %s %s (zone %s)",
			user ? user : "?", verb, dst_prefix, slug);
	else
		snprintf(comment, sizeof comment, "%s %s %s",
			user ? user : "?", verb, dst_prefix);
	builder_snapshot_subtree(dst_prefix, comment);
}

/* --- world-log collection, filtered to one zone ---------------------- */

struct hentry {
	char    hash[HASHLEN];
	int64_t time_s;
	int32_t time_ns;
	char    comment[192];
};

struct hlog {
	char           slug[64];
	struct hentry *e;
	int            count;
	int            cap;
	int            oom;
};

/* True if comment carries "(zone <slug>)", the zone tag build_comment writes. */
static int
comment_touches_zone(const char *comment, const char *slug)
{
	char needle[80];

	if ((size_t)snprintf(needle, sizeof needle, "(zone %s)", slug)
		>= sizeof needle)
		return 0;
	return comment && strstr(comment, needle) != NULL;
}

static int
hlog_cb(const char *hash, int64_t time_s, int32_t time_ns,
	const char *comment, void *ctx)
{
	struct hlog *hl = ctx;
	struct hentry *he;

	if (!comment_touches_zone(comment, hl->slug))
		return 0;
	if (hl->count == hl->cap) {
		int ncap = hl->cap ? hl->cap * 2 : 64;
		struct hentry *ne = realloc(hl->e, (size_t)ncap * sizeof *ne);

		if (!ne) {
			hl->oom = 1;
			return 1;	/* stop the walk */
		}
		hl->e = ne;
		hl->cap = ncap;
	}
	he = &hl->e[hl->count++];
	memcpy(he->hash, hash, CAS_HASH_HEX);
	he->hash[CAS_HASH_HEX] = '\0';
	he->time_s = time_s;
	he->time_ns = time_ns;
	snprintf(he->comment, sizeof he->comment, "%s", comment ? comment : "");
	return 0;
}

/* Collect the zone's log entries, oldest first (the log's natural order).
 * Caller frees hl->e. Returns 0, or -1 on a bad zone path, OOM, or read error.
 * A ref with no log is not an error: it yields zero entries. */
static int
collect_zone_log(struct cas_tree *ct, const char *zone_path, struct hlog *hl)
{
	int rc;

	memset(hl, 0, sizeof *hl);
	if (zone_slug(zone_path, hl->slug, sizeof hl->slug) != 0)
		return -1;
	rc = cas_tree_log_read(ct, BUILDER_SNAPSHOT_REF, hlog_cb, hl);
	if (hl->oom)
		return -1;
	if (rc != CAS_OK && rc != CAS_ENOTFOUND)
		return -1;
	return 0;
}

/* --- list ------------------------------------------------------------ */

int
builder_history_list(const char *zone_path, struct builder_history_entry *out,
	int max, int *n_out)
{
	struct cas_tree *ct = hist_tree();
	struct hlog hl;
	int i, n = 0;

	if (n_out)
		*n_out = 0;
	if (!ct || !out || max <= 0)
		return BUILDER_HISTORY_ERR;
	if (collect_zone_log(ct, zone_path, &hl) != 0) {
		free(hl.e);
		return BUILDER_HISTORY_ERR;
	}

	/* newest first: walk the chronological list backwards */
	for (i = hl.count - 1; i >= 0 && n < max; i--) {
		struct builder_history_entry *o = &out[n++];

		memcpy(o->hash, hl.e[i].hash, sizeof o->hash);
		o->time_s = hl.e[i].time_s;
		o->time_ns = hl.e[i].time_ns;
		snprintf(o->comment, sizeof o->comment, "%s", hl.e[i].comment);
	}
	free(hl.e);
	if (n_out)
		*n_out = n;
	return BUILDER_HISTORY_OK;
}

/* --- undo / redo cursor ---------------------------------------------- */

struct nav {
	int   in_use;
	char  user[64];
	char  zone[OBJ_PATH_MAX];
	char (*roots)[HASHLEN];		/* frozen zone-touching roots, chronological */
	int   count;
	int   pos;			/* index in roots that live is synced to */
	char  last_tip[HASHLEN];	/* world tip at the cursor's anchor */
};

static struct nav navs[NAV_MAX];

static struct nav *
nav_find(const char *user, const char *zone)
{
	int i;

	for (i = 0; i < NAV_MAX; i++)
		if (navs[i].in_use && !strcmp(navs[i].user, user)
			&& !strcmp(navs[i].zone, zone))
			return &navs[i];
	return NULL;
}

static struct nav *
nav_alloc(const char *user, const char *zone)
{
	struct nav *n = NULL;
	int i;

	for (i = 0; i < NAV_MAX; i++)
		if (!navs[i].in_use) {
			n = &navs[i];
			break;
		}
	if (!n)
		n = &navs[0];		/* table full: evict the first slot */
	free(n->roots);
	memset(n, 0, sizeof *n);
	n->in_use = 1;
	snprintf(n->user, sizeof n->user, "%s", user);
	snprintf(n->zone, sizeof n->zone, "%s", zone);
	return n;
}

/* (Re)load the zone's frozen root list from the current log and anchor the
 * cursor at the tip (the current live state). */
static int
nav_rebuild(struct cas_tree *ct, struct nav *n, const char *tip)
{
	struct hlog hl;
	int i;

	if (collect_zone_log(ct, n->zone, &hl) != 0) {
		free(hl.e);
		return -1;
	}
	free(n->roots);
	n->roots = NULL;
	n->count = 0;
	if (hl.count > 0) {
		n->roots = malloc((size_t)hl.count * sizeof *n->roots);
		if (!n->roots) {
			free(hl.e);
			return -1;
		}
		for (i = 0; i < hl.count; i++)
			memcpy(n->roots[i], hl.e[i].hash, HASHLEN);
		n->count = hl.count;
	}
	free(hl.e);
	n->pos = n->count - 1;		/* tip = current live state */
	snprintf(n->last_tip, sizeof n->last_tip, "%s", tip);
	return 0;
}

/* dir is -1 for undo (toward older), +1 for redo (toward newer). */
static int
nav_step(const char *user, const char *zone_path, int dir, int force,
	char *msg, size_t msglen)
{
	struct cas_tree *ct = hist_tree();
	char tip[HASHLEN];
	struct nav *n;
	int target;

	if (!ct) {
		setmsg(msg, msglen, "History is not available.");
		return BUILDER_HISTORY_ERR;
	}
	if (world_tip(ct, tip) != 0) {
		setmsg(msg, msglen, "There is no world history yet.");
		return BUILDER_HISTORY_ERR;
	}

	n = nav_find(user, zone_path);
	/* A fresh cursor, or one whose anchor tip the log has moved past (a real
	 * edit happened since), re-anchors at the current tip. A restore does not
	 * advance the tip, so a run of undo/redo keeps the same frozen list. */
	if (!n || strcmp(n->last_tip, tip) != 0) {
		if (!n)
			n = nav_alloc(user, zone_path);
		if (nav_rebuild(ct, n, tip) != 0) {
			setmsg(msg, msglen, "Could not read the history.");
			return BUILDER_HISTORY_ERR;
		}
	}
	if (n->count == 0) {
		setmsg(msg, msglen, "No snapshots touch %s.", zone_path);
		return BUILDER_HISTORY_ERR;
	}

	target = n->pos + dir;
	if (target < 0) {
		setmsg(msg, msglen, "Already at the earliest snapshot of %s.",
			zone_path);
		return BUILDER_HISTORY_ERR;
	}
	if (target >= n->count) {
		setmsg(msg, msglen, "Already at the latest snapshot of %s.",
			zone_path);
		return BUILDER_HISTORY_ERR;
	}

	if (world_restore(ct, n->roots[target], zone_path, zone_path, 0, force)
		!= WORLD_RESTORE_OK) {
		setmsg(msg, msglen, "%s of %s failed: a reference would dangle%s.",
			dir < 0 ? "Undo" : "Redo", zone_path,
			force ? "" : " (a wizard may force)");
		return BUILDER_HISTORY_ERR;
	}
	n->pos = target;
	/* record the restore and keep navigating from the tip it produced, so a
	 * run of undo/redo stays on the same frozen list (nav_find's anchor
	 * check) while a later real edit still re-anchors the cursor. */
	record_subtree(zone_path, user, dir < 0 ? "undid" : "redid");
	if (world_tip(ct, tip) == 0)
		snprintf(n->last_tip, sizeof n->last_tip, "%s", tip);
	setmsg(msg, msglen, "%s %s to snapshot %d of %d.",
		dir < 0 ? "Undid" : "Redid", zone_path, target + 1, n->count);
	return BUILDER_HISTORY_OK;
}

int
builder_history_undo(const char *user, const char *zone_path, int force,
	char *msg, size_t msglen)
{
	return nav_step(user, zone_path, -1, force, msg, msglen);
}

int
builder_history_redo(const char *user, const char *zone_path, int force,
	char *msg, size_t msglen)
{
	return nav_step(user, zone_path, +1, force, msg, msglen);
}

/* --- restore a numbered entry ---------------------------------------- */

int
builder_history_restore(const char *user, const char *zone_path, int entry_no,
	const char *dst_prefix, int force, char *msg, size_t msglen)
{
	struct cas_tree *ct = hist_tree();
	struct hlog hl;
	char root[HASHLEN];
	const char *dst;
	int idx, rewrite;

	if (!ct) {
		setmsg(msg, msglen, "History is not available.");
		return BUILDER_HISTORY_ERR;
	}
	if (collect_zone_log(ct, zone_path, &hl) != 0) {
		free(hl.e);
		setmsg(msg, msglen, "%s is not a zone with history.", zone_path);
		return BUILDER_HISTORY_ERR;
	}
	if (hl.count == 0) {
		free(hl.e);
		setmsg(msg, msglen, "No snapshots touch %s.", zone_path);
		return BUILDER_HISTORY_ERR;
	}
	if (entry_no < 1 || entry_no > hl.count) {
		setmsg(msg, msglen, "No such entry %d (have 1..%d).", entry_no,
			hl.count);
		free(hl.e);
		return BUILDER_HISTORY_ERR;
	}
	/* entry 1 is newest = the last chronological element */
	idx = hl.count - entry_no;
	memcpy(root, hl.e[idx].hash, sizeof root);
	free(hl.e);

	dst = (dst_prefix && dst_prefix[0]) ? dst_prefix : zone_path;
	rewrite = strcmp(dst, zone_path) != 0;
	if (world_restore(ct, root, zone_path, dst, rewrite, force)
		!= WORLD_RESTORE_OK) {
		setmsg(msg, msglen, "Restore of %s entry %d failed: a reference "
			"would dangle%s.", zone_path, entry_no,
			force ? "" : " (a wizard may force)");
		return BUILDER_HISTORY_ERR;
	}
	record_subtree(dst, user, "restored");
	setmsg(msg, msglen, "Restored %s from entry %d of %s.", dst, entry_no,
		zone_path);
	return BUILDER_HISTORY_OK;
}

/* --- checkout / publish ---------------------------------------------- */

struct checkout {
	int  in_use;
	char user[64];
	char name[64];
	char src_zone[OBJ_PATH_MAX];
	char fork_hash[HASHLEN];	/* src_zone subtree hash at checkout */
};

static struct checkout checkouts[CHECKOUT_MAX];

static struct checkout *
checkout_find(const char *user, const char *name)
{
	int i;

	for (i = 0; i < CHECKOUT_MAX; i++)
		if (checkouts[i].in_use && !strcmp(checkouts[i].user, user)
			&& !strcmp(checkouts[i].name, name))
			return &checkouts[i];
	return NULL;
}

static struct checkout *
checkout_alloc(const char *user, const char *name)
{
	struct checkout *c = checkout_find(user, name);
	int i;

	if (c)
		return c;		/* re-checkout overwrites the record */
	for (i = 0; i < CHECKOUT_MAX; i++)
		if (!checkouts[i].in_use) {
			c = &checkouts[i];
			break;
		}
	if (!c)
		c = &checkouts[0];	/* table full: evict the first slot */
	memset(c, 0, sizeof *c);
	c->in_use = 1;
	snprintf(c->user, sizeof c->user, "%s", user);
	snprintf(c->name, sizeof c->name, "%s", name);
	return c;
}

/* Build "zone/scratch/<user>/<name>" into buf. Returns 0 or -1 on overflow.
 * The reserved "zone/scratch/<user>/" prefix is owned by the user by
 * construction (spec section 9). The literal base matches zone.h ZONE_BASE
 * without this engine layer depending on the zone module. */
static int
scratch_path(const char *user, const char *name, char *buf, size_t len)
{
	if ((size_t)snprintf(buf, len, "zone/scratch/%s/%s", user, name) >= len)
		return -1;
	return 0;
}

int
builder_history_checkout(const char *user, const char *src_zone,
	const char *name, int force, char *scratch_out, size_t scratch_len,
	char *msg, size_t msglen)
{
	struct cas_tree *ct = hist_tree();
	char tip[HASHLEN];
	char slug[64];
	char scratch[OBJ_PATH_MAX];
	const char *nm;
	struct checkout *co;

	if (!ct) {
		setmsg(msg, msglen, "History is not available.");
		return BUILDER_HISTORY_ERR;
	}
	if (world_tip(ct, tip) != 0) {
		setmsg(msg, msglen, "There is no world history yet.");
		return BUILDER_HISTORY_ERR;
	}
	if (zone_slug(src_zone, slug, sizeof slug) != 0) {
		setmsg(msg, msglen, "%s is not a zone path.", src_zone);
		return BUILDER_HISTORY_ERR;
	}
	nm = (name && name[0]) ? name : slug;
	if (scratch_path(user, nm, scratch, sizeof scratch) != 0) {
		setmsg(msg, msglen, "That scratch name is too long.");
		return BUILDER_HISTORY_ERR;
	}

	if (world_restore(ct, tip, src_zone, scratch, 1, force)
		!= WORLD_RESTORE_OK) {
		setmsg(msg, msglen, "Checkout of %s failed: the zone is empty or "
			"a reference would dangle%s.", src_zone,
			force ? "" : " (a wizard may force)");
		return BUILDER_HISTORY_ERR;
	}

	co = checkout_alloc(user, nm);
	snprintf(co->src_zone, sizeof co->src_zone, "%s", src_zone);
	if (subtree_hash(ct, tip, src_zone, co->fork_hash) != 0)
		co->fork_hash[0] = '\0';	/* fork point unknown */

	/* record the scratch area so the tip holds it for a later publish, even
	 * for objects the builder never re-saves in scratch. */
	record_subtree(scratch, user, "checked out");

	if (scratch_out)
		snprintf(scratch_out, scratch_len, "%s", scratch);
	setmsg(msg, msglen, "Checked out %s to %s.", src_zone, scratch);
	return BUILDER_HISTORY_OK;
}

int
builder_history_scratch_zone(const char *user, const char *name, char *buf,
	size_t len)
{
	struct checkout *co = checkout_find(user, name);

	if (!co)
		return BUILDER_HISTORY_ERR;
	snprintf(buf, len, "%s", co->src_zone);
	return BUILDER_HISTORY_OK;
}

int
builder_history_publish(const char *user, const char *name,
	const char *dst_zone_arg, int force, char *msg, size_t msglen)
{
	struct cas_tree *ct = hist_tree();
	char tip[HASHLEN];
	char scratch[OBJ_PATH_MAX];
	char cur_hash[HASHLEN];
	const char *dst_zone;
	struct checkout *co;
	int same_zone;

	if (!ct) {
		setmsg(msg, msglen, "History is not available.");
		return BUILDER_HISTORY_ERR;
	}
	if (world_tip(ct, tip) != 0) {
		setmsg(msg, msglen, "There is no world history yet.");
		return BUILDER_HISTORY_ERR;
	}
	co = checkout_find(user, name);
	if (!co) {
		setmsg(msg, msglen, "No checkout named \"%s\" on record; "
			"@checkout first.", name);
		return BUILDER_HISTORY_ERR;
	}
	dst_zone = (dst_zone_arg && dst_zone_arg[0]) ? dst_zone_arg
		: co->src_zone;
	if (scratch_path(user, name, scratch, sizeof scratch) != 0) {
		setmsg(msg, msglen, "That scratch name is too long.");
		return BUILDER_HISTORY_ERR;
	}

	/* Fork-point guard (spec section 6.3). Publishing back to the checked-out
	 * zone is a fast-forward only if that zone has not moved since checkout.
	 * Publishing into a different zone has no fork point, so it is allowed only
	 * into an empty target, to keep the no-clobber promise. */
	same_zone = strcmp(dst_zone, co->src_zone) == 0;
	if (same_zone) {
		if (subtree_hash(ct, tip, dst_zone, cur_hash) != 0
			|| co->fork_hash[0] == '\0'
			|| strcmp(cur_hash, co->fork_hash) != 0) {
			setmsg(msg, msglen, "%s changed since checkout; the fork "
				"point moved. Re-checkout and reapply.", dst_zone);
			return BUILDER_HISTORY_ERR;
		}
	} else if (subtree_hash(ct, tip, dst_zone, cur_hash) == 0) {
		setmsg(msg, msglen, "Target zone %s already exists; a cross-zone "
			"publish only fills an empty target.", dst_zone);
		return BUILDER_HISTORY_ERR;
	}

	if (world_restore(ct, tip, scratch, dst_zone, 1, force)
		!= WORLD_RESTORE_OK) {
		setmsg(msg, msglen, "Publish of %s over %s failed: a reference "
			"would dangle%s.", scratch, dst_zone,
			force ? "" : " (a wizard may force)");
		return BUILDER_HISTORY_ERR;
	}

	/* record the published zone (advancing the tip to match live), then
	 * re-anchor the fork point to that just-published state so an immediate
	 * re-publish of the same scratch is a clean fast-forward rather than a
	 * spurious "changed" refusal. */
	record_subtree(dst_zone, user, "published");
	snprintf(co->src_zone, sizeof co->src_zone, "%s", dst_zone);
	if (world_tip(ct, tip) != 0
		|| subtree_hash(ct, tip, dst_zone, co->fork_hash) != 0)
		co->fork_hash[0] = '\0';

	setmsg(msg, msglen, "Published %s over %s.", scratch, dst_zone);
	return BUILDER_HISTORY_OK;
}

/* --- checkpoint ------------------------------------------------------ */

int
builder_history_checkpoint(const char *label, char *msg, size_t msglen)
{
	struct cas_tree *ct = hist_tree();
	char tip[HASHLEN];
	char ref[80];
	char comment[128];
	size_t i;

	if (!ct) {
		setmsg(msg, msglen, "History is not available.");
		return BUILDER_HISTORY_ERR;
	}
	if (!label || !label[0]) {
		setmsg(msg, msglen, "usage: @checkpoint <label>");
		return BUILDER_HISTORY_ERR;
	}
	for (i = 0; label[i]; i++)
		if (label[i] == '/' || label[i] == '\\'
			|| (unsigned char)label[i] < 0x20) {
			setmsg(msg, msglen, "A checkpoint label may not contain "
				"'/', '\\', or control characters.");
			return BUILDER_HISTORY_ERR;
		}
	if (world_tip(ct, tip) != 0) {
		setmsg(msg, msglen, "There is no world history to pin yet.");
		return BUILDER_HISTORY_ERR;
	}
	if ((size_t)snprintf(ref, sizeof ref, "%s%s", CHECKPOINT_PREFIX, label)
		>= sizeof ref) {
		setmsg(msg, msglen, "That label is too long.");
		return BUILDER_HISTORY_ERR;
	}
	snprintf(comment, sizeof comment, "checkpoint %s", label);
	if (cas_tree_ref_commit(ct, ref, tip, comment) != CAS_OK) {
		setmsg(msg, msglen, "Could not pin checkpoint \"%s\".", label);
		return BUILDER_HISTORY_ERR;
	}
	setmsg(msg, msglen, "Pinned checkpoint \"%s\" at the current root.",
		label);
	return BUILDER_HISTORY_OK;
}
