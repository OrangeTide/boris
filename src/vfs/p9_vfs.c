/* p9_vfs.c : a 9P2000 file server over the in-world VFS (see p9_vfs.h).
 *
 * The protocol engine mirrors the vendored fs/p9_server.c: a fixed fid table,
 * each fid naming a path relative to the root ("" == root), Twalk names
 * confined so an absolute step or a ".." above the root is refused, and
 * directory reads serialized once into concatenated stat records that Tread
 * serves by byte range. Only the storage leaves differ: the VFS is whole-file
 * (vfs_read / vfs_write), so an open file fid buffers the whole blob -- loaded
 * on open, grown by Twrite, and folded back with vfs_write + vfs_commit on
 * clunk -- the same shape the vendored server already uses for a directory. */

#include "p9_vfs.h"
#include "p9_server.h"          /* p9_server_create/destroy/handle prototypes */
#include "vfs.h"
#include "p9_wire.h"            /* p9 wire helpers and, via ninefs.h, P9_* */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SRV_MAXFID 64

struct srv_fid {
	int       used;
	int       isdir;
	char      path[VFS_PATH_MAX];   /* relative to root, "" == root */

	/* Open regular file: the whole blob, buffered. */
	uint8_t  *buf;
	uint32_t  len;
	uint32_t  cap;
	int       writable;
	int       dirty;

	/* Open directory: the serialized stat listing. */
	uint8_t  *dirbuf;
	uint32_t  dirlen;
};

struct p9_server {
	struct vfs    *v;
	struct srv_fid fids[SRV_MAXFID];
};

/* --- default vfs for the p9_server_create(root) entry point ---------------- */

static struct vfs *g_default_vfs;

void
p9_vfs_set_default(struct vfs *v)
{
	g_default_vfs = v;
}

/* --- path and fid helpers -------------------------------------------------- */

/* Build the absolute VFS path for a fid's relative path. Root ("") is "/". */
static void
vfs_path_of(const char *rel, char *out, size_t cap)
{
	if (rel[0] == 0)
		snprintf(out, cap, "/");
	else
		snprintf(out, cap, "/%s", rel);
}

/* A stable 64-bit id for a path, used as the qid path so the client can tell
 * inodes apart. FNV-1a over the relative path. */
static uint64_t
path_hash(const char *rel)
{
	uint64_t h = 1469598103934665603ull;
	const unsigned char *p = (const unsigned char *)rel;
	for (; *p; p++) {
		h ^= *p;
		h *= 1099511628211ull;
	}
	return h;
}

static struct srv_fid *
find_fid(struct p9_server *s, uint32_t fid)
{
	if (fid < SRV_MAXFID && s->fids[fid].used)
		return &s->fids[fid];
	return 0;
}

/* Reset a fid to a fresh bound state, releasing any buffers it held. */
static struct srv_fid *
bind_fid(struct p9_server *s, uint32_t fid)
{
	struct srv_fid *f;
	if (fid >= SRV_MAXFID)
		return 0;
	f = &s->fids[fid];
	free(f->buf);
	free(f->dirbuf);
	memset(f, 0, sizeof *f);
	f->used = 1;
	return f;
}

/* --- stat serialization ---------------------------------------------------- */

static void
fill_qid(const struct vfs_stat *st, const char *rel, struct p9_qid *q)
{
	q->type = (st->kind == VFS_KIND_DIR) ? P9_QTDIR : P9_QTFILE;
	q->version = 0;
	q->path = path_hash(rel);
}

/* Serialize one 9P2000 stat record for `rel` named `name`. */
static void
put_stat(struct wire_out *o, const char *name, const char *rel,
         const struct vfs_stat *st)
{
	uint32_t pos = o->n, stsz;
	uint32_t mode = (uint32_t)(st->mode & 0777);
	struct p9_qid q;

	if (st->kind == VFS_KIND_DIR)
		mode |= P9_DMDIR;
	fill_qid(st, rel, &q);

	wire_put_u16(o, 0);                  /* size: patched below */
	wire_put_u16(o, 0);                  /* type   */
	wire_put_u32(o, 0);                  /* dev    */
	p9o_qid(o, &q);
	wire_put_u32(o, mode);
	wire_put_u32(o, (uint32_t)st->mtime_s);      /* atime */
	wire_put_u32(o, (uint32_t)st->mtime_s);      /* mtime */
	wire_put_u64(o, st->kind == VFS_KIND_DIR ? 0 : st->size);
	wire_put_str(o, name);
	wire_put_str(o, "");                 /* uid  */
	wire_put_str(o, "");                 /* gid  */
	wire_put_str(o, "");                 /* muid */
	stsz = o->n - pos - 2;          /* bytes after this record's size field */
	o->b[pos]     = (uint8_t)(stsz & 0xff);
	o->b[pos + 1] = (uint8_t)((stsz >> 8) & 0xff);
}

/* Context for build_dirbuf's readdir callback. */
struct dir_ctx {
	struct wire_out o;
	const char   *parent;          /* parent fid's relative path */
	int           err;
};

static int
dir_entry(const char *name, const struct vfs_stat *st, void *ctxp)
{
	struct dir_ctx *c = ctxp;
	char childrel[VFS_PATH_MAX];

	/* child relative path = parent + "/" + name (parent "" is the root). */
	if (c->parent[0] == 0)
		snprintf(childrel, sizeof childrel, "%s", name);
	else
		snprintf(childrel, sizeof childrel, "%s/%s", c->parent, name);

	/* Grow if a record might not fit (a stat is well under 512 bytes). */
	if (c->o.n + 512 > c->o.cap) {
		uint32_t ncap = c->o.cap * 2;
		uint8_t *nb = realloc(c->o.b, ncap);
		if (!nb) {
			c->err = -1;
			return -1;
		}
		c->o.b = nb;
		c->o.cap = ncap;
	}
	put_stat(&c->o, name, childrel, st);
	return 0;
}

/* Build the concatenated-stat listing for an open directory fid. */
static int
build_dirbuf(struct p9_server *s, struct srv_fid *f)
{
	char path[VFS_PATH_MAX];
	struct dir_ctx c;
	uint32_t cap = 4096;
	int rc;

	if (f->dirbuf)
		return 0;
	vfs_path_of(f->path, path, sizeof path);
	c.o.b = malloc(cap);
	if (!c.o.b)
		return VFS_ERR;
	c.o.cap = cap;
	c.o.n = 0;
	c.parent = f->path;
	c.err = 0;
	rc = vfs_readdir(s->v, path, dir_entry, &c);
	if (rc != VFS_OK || c.err) {
		free(c.o.b);
		return rc != VFS_OK ? rc : VFS_ERR;
	}
	f->dirbuf = c.o.b;
	f->dirlen = c.o.n;
	return 0;
}

/* --- Twalk lexical step (confinement), copied from the vendored server ----- */

static int
path_step(char *rel, const char *name)
{
	size_t n;
	if (name[0] == 0 || strcmp(name, ".") == 0)
		return 0;
	if (strchr(name, '/'))
		return -1;              /* a single Twalk name has no separator */
	if (strcmp(name, "..") == 0) {
		char *slash;
		if (rel[0] == 0)
			return -1;      /* already at the root: refuse to climb */
		slash = strrchr(rel, '/');
		if (slash)
			*slash = 0;
		else
			rel[0] = 0;
		return 0;
	}
	n = strlen(rel);
	if (rel[0] == 0)
		snprintf(rel, VFS_PATH_MAX, "%s", name);
	else
		snprintf(rel + n, VFS_PATH_MAX - n, "/%s", name);
	return 0;
}

/* --- reply builders -------------------------------------------------------- */

static int
reply(struct wire_out *o)
{
	return (int)p9o_finish(o);
}

static int
rerror(uint8_t *rx, uint32_t rxcap, uint16_t tag, const char *msg)
{
	struct wire_out o;
	wire_out_init(&o, rx, rxcap);
	p9o_hdr(&o, P9_RERROR, tag);
	wire_put_str(&o, msg);
	return reply(&o);
}

/* Map a VFS return code to a 9P error string. */
static const char *
vfs_errstr(int rc)
{
	switch (rc) {
	case VFS_ENOTFOUND: return "no such file or directory";
	case VFS_EEXIST:    return "file exists";
	case VFS_EISDIR:    return "is a directory";
	case VFS_ENOTDIR:   return "not a directory";
	case VFS_EINVAL:    return "invalid argument";
	case VFS_ENOTEMPTY: return "directory not empty";
	default:            return "i/o error";
	}
}

static int
verror(uint8_t *rx, uint32_t rxcap, uint16_t tag, int rc)
{
	return rerror(rx, rxcap, tag, vfs_errstr(rc));
}

/* --- the dispatch ---------------------------------------------------------- */

int
p9_server_handle(struct p9_server *s, const uint8_t *req, uint32_t reqlen,
                 uint8_t *rx, uint32_t rxcap)
{
	struct wire_in in;
	struct wire_out o;
	uint8_t type;
	uint16_t tag;

	wire_in_init(&in, req, reqlen);
	(void)wire_get_u32(&in);
	type = wire_get_u8(&in);
	tag = wire_get_u16(&in);
	if (!in.ok)
		return rerror(rx, rxcap, 0, "truncated request");

	/* Every message but Tversion needs a filesystem to serve. */
	if (type != P9_TVERSION && !s->v)
		return rerror(rx, rxcap, tag, "no filesystem");

	switch (type) {
	case P9_TVERSION: {
		uint32_t msize = wire_get_u32(&in);
		char ver[32];
		wire_get_str(&in, ver, sizeof ver);
		memset(s->fids, 0, sizeof s->fids);    /* a new session clears fids */
		if (msize > P9_MSIZE)
			msize = P9_MSIZE;
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RVERSION, tag);
		wire_put_u32(&o, msize);
		wire_put_str(&o, strcmp(ver, P9_VERSION) == 0 ? P9_VERSION : "unknown");
		return reply(&o);
	}
	case P9_TATTACH: {
		uint32_t fid = wire_get_u32(&in);
		struct srv_fid *f;
		struct vfs_stat st;
		struct p9_qid q;
		int rc;
		(void)wire_get_u32(&in);                    /* afid */
		wire_get_str(&in, 0, 0);                    /* uname */
		wire_get_str(&in, 0, 0);                    /* aname */
		rc = vfs_stat(s->v, "/", &st);
		if (rc != VFS_OK)
			return verror(rx, rxcap, tag, rc);
		f = bind_fid(s, fid);
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		f->isdir = (st.kind == VFS_KIND_DIR);
		fill_qid(&st, "", &q);
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RATTACH, tag);
		p9o_qid(&o, &q);
		return reply(&o);
	}
	case P9_TWALK: {
		uint32_t fid = wire_get_u32(&in);
		uint32_t newfid = wire_get_u32(&in);
		uint16_t nwname = wire_get_u16(&in);
		struct srv_fid *bf = find_fid(s, fid);
		char cur[VFS_PATH_MAX];
		struct p9_qid qids[P9_MAXWELEM];
		int nq = 0, i, finaldir;

		if (!bf)
			return rerror(rx, rxcap, tag, "bad fid");
		if (nwname > P9_MAXWELEM)
			return rerror(rx, rxcap, tag, "too many walk elements");
		snprintf(cur, sizeof cur, "%s", bf->path);
		finaldir = bf->isdir;
		for (i = 0; i < nwname; i++) {
			char name[256], path[VFS_PATH_MAX];
			struct vfs_stat st;
			wire_get_str(&in, name, sizeof name);
			if (path_step(cur, name) != 0)
				break;
			vfs_path_of(cur, path, sizeof path);
			if (vfs_stat(s->v, path, &st) != VFS_OK)
				break;
			fill_qid(&st, cur, &qids[nq]);
			finaldir = (st.kind == VFS_KIND_DIR);
			nq++;
		}
		if (nwname > 0 && nq == 0)
			return rerror(rx, rxcap, tag, "no such file or directory");
		if (nq == nwname) {                    /* full walk: bind newfid */
			struct srv_fid *nf = bind_fid(s, newfid);
			if (!nf)
				return rerror(rx, rxcap, tag, "bad newfid");
			snprintf(nf->path, sizeof nf->path, "%s", cur);
			nf->isdir = finaldir;
		}
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RWALK, tag);
		wire_put_u16(&o, (uint16_t)nq);
		for (i = 0; i < nq; i++)
			p9o_qid(&o, &qids[i]);
		return reply(&o);
	}
	case P9_TOPEN: {
		uint32_t fid = wire_get_u32(&in);
		uint8_t mode = wire_get_u8(&in);
		struct srv_fid *f = find_fid(s, fid);
		char path[VFS_PATH_MAX];
		struct vfs_stat st;
		struct p9_qid q;
		int rc;
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		vfs_path_of(f->path, path, sizeof path);
		rc = vfs_stat(s->v, path, &st);
		if (rc != VFS_OK)
			return verror(rx, rxcap, tag, rc);
		f->isdir = (st.kind == VFS_KIND_DIR);
		if (f->isdir) {
			rc = build_dirbuf(s, f);
			if (rc != 0)
				return verror(rx, rxcap, tag, rc);
		} else {
			f->writable = (mode & 3) == P9_OWRITE ||
			              (mode & 3) == P9_ORDWR;
			free(f->buf);
			f->buf = 0;
			f->len = f->cap = 0;
			f->dirty = 0;
			if (mode & P9_OTRUNC) {
				f->dirty = f->writable;    /* empty contents to flush */
			} else {
				void *data;
				size_t n;
				rc = vfs_read(s->v, path, &data, &n);
				if (rc != VFS_OK)
					return verror(rx, rxcap, tag, rc);
				f->buf = data;         /* malloc'd by vfs_read */
				f->len = (uint32_t)n;
				f->cap = (uint32_t)n;
			}
		}
		fill_qid(&st, f->path, &q);
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_ROPEN, tag);
		p9o_qid(&o, &q);
		wire_put_u32(&o, 0);                        /* iounit */
		return reply(&o);
	}
	case P9_TCREATE: {
		uint32_t fid = wire_get_u32(&in);
		char name[256];
		uint32_t perm;
		uint8_t mode;
		struct srv_fid *f = find_fid(s, fid);
		char path[VFS_PATH_MAX];
		struct vfs_stat st;
		struct p9_qid q;
		int rc;
		wire_get_str(&in, name, sizeof name);
		perm = wire_get_u32(&in);
		mode = wire_get_u8(&in);
		(void)mode;
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		if (path_step(f->path, name) != 0)
			return rerror(rx, rxcap, tag, "bad name");
		vfs_path_of(f->path, path, sizeof path);
		if (perm & P9_DMDIR) {
			rc = vfs_mkdir(s->v, path);
			if (rc != VFS_OK)
				return verror(rx, rxcap, tag, rc);
			f->isdir = 1;
		} else {
			rc = vfs_write(s->v, path, "", 0);     /* create empty */
			if (rc != VFS_OK)
				return verror(rx, rxcap, tag, rc);
			f->isdir = 0;
			f->writable = 1;
			free(f->buf);
			f->buf = 0;
			f->len = f->cap = 0;
			f->dirty = 0;
		}
		if (vfs_commit(s->v, "p9 create") != VFS_OK)
			return rerror(rx, rxcap, tag, "commit failed");
		rc = vfs_stat(s->v, path, &st);
		if (rc != VFS_OK)
			return verror(rx, rxcap, tag, rc);
		fill_qid(&st, f->path, &q);
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RCREATE, tag);
		p9o_qid(&o, &q);
		wire_put_u32(&o, 0);                        /* iounit */
		return reply(&o);
	}
	case P9_TREAD: {
		uint32_t fid = wire_get_u32(&in);
		uint64_t off = wire_get_u64(&in);
		uint32_t cnt = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		const uint8_t *src;
		uint32_t total, avail;
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		if (cnt > rxcap - 32)
			cnt = rxcap - 32;
		if (f->isdir) {
			src = f->dirbuf;
			total = f->dirlen;
		} else {
			src = f->buf;
			total = f->len;
		}
		avail = off >= total ? 0 : total - (uint32_t)off;
		if (cnt > avail)
			cnt = avail;
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RREAD, tag);
		wire_put_u32(&o, cnt);
		wire_put_bytes(&o, src ? src + off : (const uint8_t *)"", cnt);
		return reply(&o);
	}
	case P9_TWRITE: {
		uint32_t fid = wire_get_u32(&in);
		uint64_t off = wire_get_u64(&in);
		uint32_t cnt = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		uint64_t end;
		if (!f || f->isdir || !f->writable)
			return rerror(rx, rxcap, tag, "bad fid");
		if (in.p + cnt > in.len)
			return rerror(rx, rxcap, tag, "short write");
		end = off + cnt;
		if (end > 0xffffffffu)
			return rerror(rx, rxcap, tag, "file too large");
		if ((uint32_t)end > f->cap) {
			uint32_t ncap = f->cap ? f->cap : 64;
			uint8_t *nb;
			while (ncap < (uint32_t)end)
				ncap *= 2;
			nb = realloc(f->buf, ncap);
			if (!nb)
				return rerror(rx, rxcap, tag, "out of memory");
			f->buf = nb;
			f->cap = ncap;
		}
		if ((uint32_t)off > f->len)             /* gap: zero-fill */
			memset(f->buf + f->len, 0, (uint32_t)off - f->len);
		memcpy(f->buf + off, in.b + in.p, cnt);
		if ((uint32_t)end > f->len)
			f->len = (uint32_t)end;
		f->dirty = 1;
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RWRITE, tag);
		wire_put_u32(&o, cnt);
		return reply(&o);
	}
	case P9_TCLUNK: {
		uint32_t fid = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		if (f) {
			if (!f->isdir && f->dirty && f->writable) {
				char path[VFS_PATH_MAX];
				vfs_path_of(f->path, path, sizeof path);
				if (vfs_write(s->v, path, f->buf ? f->buf : (const void *)"",
				              f->len) == VFS_OK)
					vfs_commit(s->v, "p9 write");
			}
			free(f->buf);
			free(f->dirbuf);
			memset(f, 0, sizeof *f);
		}
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RCLUNK, tag);
		return reply(&o);
	}
	case P9_TREMOVE: {
		uint32_t fid = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		char path[VFS_PATH_MAX];
		int rc;
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		vfs_path_of(f->path, path, sizeof path);
		rc = vfs_unlink(s->v, path);
		free(f->buf);                          /* Tremove clunks even on error */
		free(f->dirbuf);
		memset(f, 0, sizeof *f);
		if (rc != VFS_OK)
			return verror(rx, rxcap, tag, rc);
		vfs_commit(s->v, "p9 remove");
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RREMOVE, tag);
		return reply(&o);
	}
	case P9_TSTAT: {
		uint32_t fid = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		char path[VFS_PATH_MAX];
		struct vfs_stat st;
		const char *nm;
		struct wire_out so;
		uint8_t stbuf[512];
		int slen, rc;
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		vfs_path_of(f->path, path, sizeof path);
		rc = vfs_stat(s->v, path, &st);
		if (rc != VFS_OK)
			return verror(rx, rxcap, tag, rc);
		nm = strrchr(f->path, '/');
		nm = nm ? nm + 1 : (f->path[0] ? f->path : "/");
		wire_out_init(&so, stbuf, sizeof stbuf);
		put_stat(&so, nm, f->path, &st);
		slen = (int)so.n;
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RSTAT, tag);
		wire_put_u16(&o, (uint16_t)slen);           /* outer count */
		wire_put_bytes(&o, stbuf, (uint32_t)slen);
		return reply(&o);
	}
	case P9_TWSTAT: {
		uint32_t fid = wire_get_u32(&in);
		struct srv_fid *f = find_fid(s, fid);
		struct wire_in st;
		char newname[256];
		(void)wire_get_u16(&in);                    /* outer n */
		if (!f)
			return rerror(rx, rxcap, tag, "bad fid");
		/* Parse just enough of the stat to reach the name field. */
		wire_in_init(&st, in.b + in.p, in.len - in.p);
		(void)wire_get_u16(&st);                    /* stat size */
		(void)wire_get_u16(&st);                    /* type   */
		(void)wire_get_u32(&st);                    /* dev    */
		wire_skip(&st, 13);                     /* qid    */
		(void)wire_get_u32(&st);                    /* mode   */
		(void)wire_get_u32(&st);                    /* atime  */
		(void)wire_get_u32(&st);                    /* mtime  */
		(void)wire_get_u64(&st);                    /* length */
		newname[0] = 0;
		wire_get_str(&st, newname, sizeof newname);
		if (newname[0] && strchr(newname, '/') == 0) {
			/* A rename within the directory. The VFS has no rename, and a
			 * directory rename would have to move a whole subtree, so only a
			 * file is renamed, by copy: read the blob, write it under the new
			 * name, unlink the old. */
			char oldrel[VFS_PATH_MAX], newrel[VFS_PATH_MAX];
			char oldp[VFS_PATH_MAX], newp[VFS_PATH_MAX];
			char *slash;
			void *data;
			size_t n;
			int rc;
			struct vfs_stat vst;

			vfs_path_of(f->path, oldp, sizeof oldp);
			if (vfs_stat(s->v, oldp, &vst) != VFS_OK)
				return rerror(rx, rxcap, tag, "no such file or directory");
			if (vst.kind == VFS_KIND_DIR)
				return rerror(rx, rxcap, tag, "cannot rename a directory");
			snprintf(oldrel, sizeof oldrel, "%s", f->path);
			snprintf(newrel, sizeof newrel, "%s", f->path);
			slash = strrchr(newrel, '/');
			if (slash)
				snprintf(slash + 1, sizeof newrel - (size_t)(slash + 1 - newrel),
				         "%s", newname);
			else
				snprintf(newrel, sizeof newrel, "%s", newname);
			vfs_path_of(newrel, newp, sizeof newp);
			rc = vfs_read(s->v, oldp, &data, &n);
			if (rc != VFS_OK)
				return verror(rx, rxcap, tag, rc);
			rc = vfs_write(s->v, newp, data, n);
			free(data);
			if (rc != VFS_OK)
				return verror(rx, rxcap, tag, rc);
			vfs_unlink(s->v, oldp);
			vfs_commit(s->v, "p9 rename");
			snprintf(f->path, sizeof f->path, "%s", newrel);
		}
		wire_out_init(&o, rx, rxcap);
		p9o_hdr(&o, P9_RWSTAT, tag);
		return reply(&o);
	}
	default:
		return rerror(rx, rxcap, tag, "unsupported message");
	}
}

/* --- lifecycle ------------------------------------------------------------- */

struct p9_server *
p9_vfs_new(struct vfs *v)
{
	struct p9_server *s = calloc(1, sizeof *s);
	if (!s)
		return 0;
	s->v = v;
	return s;
}

/* Dispatch a concatenation of framed T-messages on one session (the request
 * batching path the sandbox doorbell drives): each frame runs through
 * p9_server_handle, so a fid a Twalk binds is visible to a following message,
 * and the framed R-messages are concatenated. A single message is a stream of
 * one, identical to a bare p9_server_handle. Returns the total reply length. */
int
p9_server_handle_stream(struct p9_server *s, const uint8_t *req, uint32_t reqlen,
                        uint8_t *rx, uint32_t rxcap)
{
	uint32_t roff = 0, woff = 0;

	while (roff + 4 <= reqlen) {
		uint32_t msz = (uint32_t)req[roff] | ((uint32_t)req[roff + 1] << 8)
		             | ((uint32_t)req[roff + 2] << 16)
		             | ((uint32_t)req[roff + 3] << 24);
		int n;

		if (msz < 7 || roff + msz > reqlen)
			break;                  /* a malformed frame ends the stream */
		n = p9_server_handle(s, req + roff, msz, rx + woff, rxcap - woff);
		if (n <= 0)
			break;                  /* no room for the reply: stop short */
		woff += (uint32_t)n;
		roff += msz;
	}
	return (int)woff;
}

struct p9_server *
p9_server_create(const char *root)
{
	(void)root;                     /* the VFS has one tree; root is unused */
	return p9_vfs_new(g_default_vfs);
}

void
p9_server_destroy(struct p9_server *s)
{
	int i;
	if (!s)
		return;
	for (i = 0; i < SRV_MAXFID; i++) {
		free(s->fids[i].buf);
		free(s->fids[i].dirbuf);
	}
	free(s);
}
