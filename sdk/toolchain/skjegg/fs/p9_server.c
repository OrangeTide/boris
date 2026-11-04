/* p9_server: a minimal 9P2000 file server over a host directory (see the
 * header).  It keeps a fixed fid table; each fid names a path relative to the
 * root ("" is the root itself).  Walk names are confined: an absolute step or
 * a ".." that would climb above the root is refused.  Directory reads follow
 * the 9P2000 model: the whole listing is serialized into concatenated stat
 * records once, and Tread serves byte ranges of that buffer. */

#define _GNU_SOURCE
#include "p9_server.h"
#include "p9_wire.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/stat.h>

#define SRV_MAXFID 64
#define SRV_PATHMAX 1024

struct srv_fid {
    int       used;
    int       isdir;
    int       fd;                       /* host fd of an open file, else -1 */
    char      path[SRV_PATHMAX];        /* relative to root, "" == root */
    uint8_t  *dirbuf;                   /* serialized dir listing (dirs only) */
    uint32_t  dirlen;
};

struct p9_server {
    char           root[SRV_PATHMAX];
    struct srv_fid fids[SRV_MAXFID];
};

/* Build the host path (root, then "/" and the relative fid path) into `out`.
 * Assembled with bounded copies rather than a two-field snprintf so no
 * truncation is possible and the paths stay provably in range. */
static void
host_path(struct p9_server *s, const char *rel, char *out, size_t cap)
{
    size_t rl = strlen(s->root), xl = strlen(rel), pos;

    if (cap == 0)
        return;
    if (rl > cap - 1)
        rl = cap - 1;
    memcpy(out, s->root, rl);
    pos = rl;
    if (xl && pos < cap - 1) {
        out[pos++] = '/';
        if (xl > cap - 1 - pos)
            xl = cap - 1 - pos;
        memcpy(out + pos, rel, xl);
        pos += xl;
    }
    out[pos] = 0;
}

static struct srv_fid *
find_fid(struct p9_server *s, uint32_t fid)
{
    int i;
    for (i = 0; i < SRV_MAXFID; i++)
        if (s->fids[i].used && (uint32_t)i == fid)
            return &s->fids[i];
    /* fid number is the slot index here (the client draws fids 0..63). */
    if (fid < SRV_MAXFID && s->fids[fid].used)
        return &s->fids[fid];
    return 0;
}

static struct srv_fid *
bind_fid(struct p9_server *s, uint32_t fid)
{
    struct srv_fid *f;
    if (fid >= SRV_MAXFID)
        return 0;
    f = &s->fids[fid];
    if (f->used && f->fd >= 0) { close(f->fd); f->fd = -1; }
    free(f->dirbuf);
    f->dirbuf = 0;
    f->dirlen = 0;
    f->used = 1;
    f->isdir = 0;
    f->fd = -1;
    f->path[0] = 0;
    return f;
}

static void
clunk_fid(struct srv_fid *f)
{
    if (!f)
        return;
    if (f->fd >= 0) { close(f->fd); f->fd = -1; }
    free(f->dirbuf);
    f->dirbuf = 0;
    f->dirlen = 0;
    f->used = 0;
    f->path[0] = 0;
}

/* Append component `name` to the relative path `rel` in place, applying "." and
 * ".." lexically.  Returns 0, or -1 if the step is unsafe (absolute, or a ".."
 * that climbs above the root). */
static int
path_step(char *rel, const char *name)
{
    size_t n;
    if (name[0] == 0 || strcmp(name, ".") == 0)
        return 0;
    if (strchr(name, '/'))
        return -1;                      /* a single Twalk name has no separator */
    if (strcmp(name, "..") == 0) {
        char *slash;
        if (rel[0] == 0)
            return -1;                  /* already at the root: refuse to climb */
        slash = strrchr(rel, '/');
        if (slash)
            *slash = 0;
        else
            rel[0] = 0;
        return 0;
    }
    n = strlen(rel);
    if (rel[0] == 0)
        snprintf(rel, SRV_PATHMAX, "%s", name);
    else
        snprintf(rel + n, SRV_PATHMAX - n, "/%s", name);
    return 0;
}

static void
fill_qid(const struct stat *st, struct p9_qid *q)
{
    q->type = S_ISDIR(st->st_mode) ? P9_QTDIR : P9_QTFILE;
    q->version = 0;
    q->path = (uint64_t)st->st_ino;
}

/* Serialize one stat record (the 9P2000 directory/stat entry layout). */
static void
put_stat(struct wire_out *o, const char *name, const struct stat *st)
{
    uint32_t pos = o->n, stsz;
    struct p9_qid q;
    uint32_t mode = (uint32_t)(st->st_mode & 0777);
    if (S_ISDIR(st->st_mode))
        mode |= P9_DMDIR;
    fill_qid(st, &q);

    wire_put_u16(o, 0);                      /* size: patched below */
    wire_put_u16(o, 0);                      /* type   */
    wire_put_u32(o, 0);                      /* dev    */
    p9o_qid(o, &q);
    wire_put_u32(o, mode);
    wire_put_u32(o, (uint32_t)st->st_atime);
    wire_put_u32(o, (uint32_t)st->st_mtime);
    wire_put_u64(o, S_ISDIR(st->st_mode) ? 0 : (uint64_t)st->st_size);
    wire_put_str(o, name);
    wire_put_str(o, "");                     /* uid  */
    wire_put_str(o, "");                     /* gid  */
    wire_put_str(o, "");                     /* muid */
    stsz = o->n - pos - 2;              /* bytes after this record's size field */
    o->b[pos]     = (uint8_t)(stsz & 0xff);
    o->b[pos + 1] = (uint8_t)((stsz >> 8) & 0xff);
}

/* Build the concatenated-stat listing for an open directory fid. */
static int
build_dirbuf(struct p9_server *s, struct srv_fid *f)
{
    char hp[SRV_PATHMAX];
    DIR *d;
    struct dirent *e;
    struct wire_out o;
    uint32_t cap = 4096;

    if (f->dirbuf)
        return 0;
    host_path(s, f->path, hp, sizeof hp);
    d = opendir(hp);
    if (!d)
        return -errno;
    f->dirbuf = malloc(cap);
    if (!f->dirbuf) { closedir(d); return -ENOMEM; }
    wire_out_init(&o, f->dirbuf, cap);
    while ((e = readdir(d))) {
        struct stat st;
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0)
            continue;
        if (fstatat(dirfd(d), e->d_name, &st, 0) != 0)
            continue;
        /* Grow if a record might not fit (a stat is well under 512 bytes). */
        if (o.n + 512 > cap) {
            uint8_t *nb;
            cap *= 2;
            nb = realloc(f->dirbuf, cap);
            if (!nb) { closedir(d); return -ENOMEM; }
            f->dirbuf = nb;
            o.b = nb;
            o.cap = cap;
        }
        put_stat(&o, e->d_name, &st);
    }
    closedir(d);
    f->dirlen = o.n;
    return 0;
}

/* Reply builders.  Each starts the R-message header, appends the body, and
 * finishes; the result length is returned to the transport. */
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

static int
errno_reply(uint8_t *rx, uint32_t rxcap, uint16_t tag, int err)
{
    return rerror(rx, rxcap, tag, strerror(err < 0 ? -err : err));
}

/* Dispatch one T-message (req) and build the R-message (rx). */
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

    switch (type) {
    case P9_TVERSION: {
        uint32_t msize = wire_get_u32(&in);
        char ver[32];
        wire_get_str(&in, ver, sizeof ver);
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
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
        struct stat st;
        struct p9_qid q;
        (void)wire_get_u32(&in);                    /* afid */
        wire_get_str(&in, 0, 0);                    /* uname */
        wire_get_str(&in, 0, 0);                    /* aname */
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (stat(s->root, &st) != 0)
            return errno_reply(rx, rxcap, tag, errno);
        f = bind_fid(s, fid);
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        f->isdir = S_ISDIR(st.st_mode);
        fill_qid(&st, &q);
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
        char cur[SRV_PATHMAX];
        struct p9_qid qids[P9_MAXWELEM];
        int nq = 0, i, finaldir = 0;

        if (!bf)
            return rerror(rx, rxcap, tag, "bad fid");
        if (nwname > P9_MAXWELEM)
            return rerror(rx, rxcap, tag, "too many walk elements");
        snprintf(cur, sizeof cur, "%s", bf->path);
        finaldir = bf->isdir;
        for (i = 0; i < nwname; i++) {
            char name[256], hp[SRV_PATHMAX];
            struct stat st;
            wire_get_str(&in, name, sizeof name);
            if (path_step(cur, name) != 0)
                break;
            host_path(s, cur, hp, sizeof hp);
            if (stat(hp, &st) != 0)
                break;
            fill_qid(&st, &qids[nq]);
            finaldir = S_ISDIR(st.st_mode);
            nq++;
        }
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (nwname > 0 && nq == 0)
            return rerror(rx, rxcap, tag, "no such file");
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
        char hp[SRV_PATHMAX];
        struct stat st;
        struct p9_qid q;
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        host_path(s, f->path, hp, sizeof hp);
        if (stat(hp, &st) != 0)
            return errno_reply(rx, rxcap, tag, errno);
        f->isdir = S_ISDIR(st.st_mode);
        if (f->isdir) {
            int rc = build_dirbuf(s, f);
            if (rc < 0)
                return errno_reply(rx, rxcap, tag, rc);
        } else {
            int of;
            switch (mode & 3) {
            case P9_OWRITE: of = O_WRONLY; break;
            case P9_ORDWR:  of = O_RDWR;   break;
            default:        of = O_RDONLY; break;
            }
            if (mode & P9_OTRUNC)
                of |= O_TRUNC;
            f->fd = open(hp, of);
            if (f->fd < 0)
                return errno_reply(rx, rxcap, tag, errno);
        }
        fill_qid(&st, &q);
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
        char hp[SRV_PATHMAX];
        struct stat st;
        struct p9_qid q;
        wire_get_str(&in, name, sizeof name);
        perm = wire_get_u32(&in);
        mode = wire_get_u8(&in);
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        if (path_step(f->path, name) != 0)
            return rerror(rx, rxcap, tag, "bad name");
        host_path(s, f->path, hp, sizeof hp);
        if (perm & P9_DMDIR) {
            if (mkdir(hp, perm & 0777) != 0)
                return errno_reply(rx, rxcap, tag, errno);
            f->isdir = 1;
        } else {
            int of = O_CREAT | O_TRUNC;
            of |= (mode & 3) == P9_OREAD ? O_RDONLY
                : (mode & 3) == P9_OWRITE ? O_WRONLY : O_RDWR;
            if ((of & O_ACCMODE) == O_RDONLY)
                of = (of & ~O_ACCMODE) | O_RDWR;   /* a new file must be writable */
            f->fd = open(hp, of, perm & 0777);
            if (f->fd < 0)
                return errno_reply(rx, rxcap, tag, errno);
            f->isdir = 0;
        }
        if (stat(hp, &st) != 0)
            return errno_reply(rx, rxcap, tag, errno);
        fill_qid(&st, &q);
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
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        if (cnt > rxcap - 32)
            cnt = rxcap - 32;
        wire_out_init(&o, rx, rxcap);
        p9o_hdr(&o, P9_RREAD, tag);
        if (f->isdir) {
            uint32_t avail = off >= f->dirlen ? 0 : f->dirlen - (uint32_t)off;
            if (cnt > avail) cnt = avail;
            wire_put_u32(&o, cnt);
            wire_put_bytes(&o, f->dirbuf + off, cnt);
        } else {
            ssize_t got;
            uint8_t tmp[P9_MSIZE];
            if (cnt > sizeof tmp) cnt = sizeof tmp;
            got = pread(f->fd, tmp, cnt, (off_t)off);
            if (got < 0)
                return errno_reply(rx, rxcap, tag, errno);
            wire_put_u32(&o, (uint32_t)got);
            wire_put_bytes(&o, tmp, (uint32_t)got);
        }
        return reply(&o);
    }
    case P9_TWRITE: {
        uint32_t fid = wire_get_u32(&in);
        uint64_t off = wire_get_u64(&in);
        uint32_t cnt = wire_get_u32(&in);
        struct srv_fid *f = find_fid(s, fid);
        ssize_t put;
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f || f->fd < 0)
            return rerror(rx, rxcap, tag, "bad fid");
        if (in.p + cnt > in.len)
            return rerror(rx, rxcap, tag, "short write");
        put = pwrite(f->fd, in.b + in.p, cnt, (off_t)off);
        if (put < 0)
            return errno_reply(rx, rxcap, tag, errno);
        wire_out_init(&o, rx, rxcap);
        p9o_hdr(&o, P9_RWRITE, tag);
        wire_put_u32(&o, (uint32_t)put);
        return reply(&o);
    }
    case P9_TCLUNK: {
        uint32_t fid = wire_get_u32(&in);
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        clunk_fid(find_fid(s, fid));
        wire_out_init(&o, rx, rxcap);
        p9o_hdr(&o, P9_RCLUNK, tag);
        return reply(&o);
    }
    case P9_TREMOVE: {
        uint32_t fid = wire_get_u32(&in);
        struct srv_fid *f = find_fid(s, fid);
        char hp[SRV_PATHMAX];
        int rc;
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        host_path(s, f->path, hp, sizeof hp);
        rc = f->isdir ? rmdir(hp) : unlink(hp);
        clunk_fid(f);                          /* Tremove clunks even on error */
        if (rc != 0)
            return errno_reply(rx, rxcap, tag, errno);
        wire_out_init(&o, rx, rxcap);
        p9o_hdr(&o, P9_RREMOVE, tag);
        return reply(&o);
    }
    case P9_TSTAT: {
        uint32_t fid = wire_get_u32(&in);
        struct srv_fid *f = find_fid(s, fid);
        char hp[SRV_PATHMAX];
        struct stat st;
        const char *nm;
        struct wire_out so;
        uint8_t stbuf[512];
        int slen;
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
        if (!f)
            return rerror(rx, rxcap, tag, "bad fid");
        host_path(s, f->path, hp, sizeof hp);
        if (stat(hp, &st) != 0)
            return errno_reply(rx, rxcap, tag, errno);
        nm = strrchr(f->path, '/');
        nm = nm ? nm + 1 : (f->path[0] ? f->path : "/");
        wire_out_init(&so, stbuf, sizeof stbuf);
        put_stat(&so, nm, &st);
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
        if (!in.ok)
            return rerror(rx, rxcap, tag, "truncated request");
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
        if (newname[0]) {                      /* a rename within the directory */
            char oldp[SRV_PATHMAX], newrel[SRV_PATHMAX], newp[SRV_PATHMAX];
            char *slash;
            host_path(s, f->path, oldp, sizeof oldp);
            snprintf(newrel, sizeof newrel, "%s", f->path);
            slash = strrchr(newrel, '/');
            if (slash)
                snprintf(slash + 1, sizeof newrel - (size_t)(slash + 1 - newrel),
                         "%s", newname);
            else
                snprintf(newrel, sizeof newrel, "%s", newname);
            host_path(s, newrel, newp, sizeof newp);
            if (rename(oldp, newp) != 0)
                return errno_reply(rx, rxcap, tag, errno);
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

struct p9_server *
p9_server_create(const char *root)
{
    struct p9_server *s = calloc(1, sizeof *s);
    int i;
    if (!s)
        return 0;
    snprintf(s->root, sizeof s->root, "%s", root);
    for (i = 0; i < SRV_MAXFID; i++)
        s->fids[i].fd = -1;
    return s;
}

void
p9_server_destroy(struct p9_server *s)
{
    int i;
    if (!s)
        return;
    for (i = 0; i < SRV_MAXFID; i++) {
        if (s->fids[i].fd >= 0)
            close(s->fids[i].fd);
        free(s->fids[i].dirbuf);
    }
    free(s);
}

int
p9_server_handle_stream(struct p9_server *s, const uint8_t *req, uint32_t reqlen,
                        uint8_t *rx, uint32_t rxcap)
{
    uint32_t roff = 0, woff = 0;

    /* Dispatch each framed T-message in turn on the same session, so a fid a
     * Twalk binds is visible to a following message, and append each framed
     * R-message.  One message is a stream of one, so the plain path is just
     * this with reqlen naming a single message. */
    while (roff + 4 <= reqlen) {
        uint32_t msz = (uint32_t)req[roff] | ((uint32_t)req[roff + 1] << 8)
                     | ((uint32_t)req[roff + 2] << 16)
                     | ((uint32_t)req[roff + 3] << 24);
        int n;

        if (msz < 7 || msz > reqlen - roff)
            break;                      /* a malformed frame ends the stream;
                                         * reqlen - roff avoids the roff + msz
                                         * overflow a guest could use to slip a
                                         * bogus frame length past the guard */
        n = p9_server_handle(s, req + roff, msz, rx + woff, rxcap - woff);
        if (n <= 0)
            break;                      /* no room for the reply: stop short */
        woff += (uint32_t)n;
        roff += msz;
    }
    return (int)woff;
}

static int
srv_rpc(void *ctx, const uint8_t *tx, uint32_t txlen, uint8_t *rx, uint32_t rxcap)
{
    return p9_server_handle_stream((struct p9_server *)ctx, tx, txlen, rx, rxcap);
}

int
p9_server_open(const char *root, struct p9_transport *out)
{
    struct p9_server *s = p9_server_create(root);
    if (!s)
        return -ENOMEM;
    out->rpc = srv_rpc;
    out->ctx = s;
    return 0;
}

void
p9_server_close(struct p9_transport *t)
{
    p9_server_destroy((struct p9_server *)t->ctx);
    t->ctx = 0;
}
