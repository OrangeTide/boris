/* fs/ core: the mount table, the one shared fd space, path resolution, the DOS
 * current-mount + per-mount-cwd state, and dispatch to the backends.
 *
 * Mount index 0 is the default root; `ROOT:` (any case) is a resolver alias for
 * it (see is_root_alias), the DOS single-drive convention where one drive is
 * the implicit root.
 *
 * Errno-style negatives here use <errno.h>; when this moves into the
 * freestanding guest build those map to the guest libc's errno codes. */

#include "fs.h"
#include "fs_internal.h"
#ifdef FS_WITH_RAM
#include "ramfs.h"           /* in-guest scratch; omitted when the host grants one */
#endif
#ifdef FS_WITH_HOSTFS
#include "hostfs.h"       /* hosted/dev only; the guest has no direct host fs */
#endif
#ifdef FS_WITH_AMBIENT
#include "ambientfs.h"    /* freestanding guest: the temporary ambient host    */
#endif
#ifdef FS_WITH_HOSTCAP
#include "hostcap.h"      /* freestanding guest: a launcher-granted capability  */
#endif
#ifdef FS_WITH_DEV
#include "devfs.h"        /* null/zero/full character devices                   */
#endif
#ifdef FS_WITH_ROM
#include "romfs.h"        /* read-only packed image                             */
#endif
#ifdef FS_WITH_9P
#include "ninefs.h"       /* 9P2000 client over the launcher channel            */
#endif
#if defined(FS_WITH_9P) && defined(FS_WITH_HOSTCAP)
#include "p9_guest.h"     /* guest transport over the launcher doorbell channel */
#endif

#include <string.h>
#include <errno.h>

/* strchr/strrchr are not in every tier's string set (the Kobold freestanding
   runtime provides memcpy, memcmp, strlen and strcmp but not these), so fs.c
   carries its own; the rest of its string use is universal. */
static const char *
fs_strchr(const char *s, int c)
{
    for (; *s; s++)
        if (*s == (char)c)
            return s;
    return 0;
}

static char *
fs_strrchr(char *s, int c)
{
    char *last = 0;
    for (; *s; s++)
        if (*s == (char)c)
            last = s;
    return last;
}

struct fs_mount fs_mounts[FS_MAX_MOUNTS];
int             fs_mount_count = 0;
int             fs_cur_mount = 0;
struct fs_mount_aux fs_mount_aux[FS_MAX_MOUNTS];

/* The one fd space.  A slot is a file, a directory, a mount root, or a console
 * stream; `h` is the owning backend's opaque handle (a raw host fd for a
 * console slot) and `pos` is the file offset / dir cursor that fs.c keeps on
 * the backend's behalf.  A console slot has no mount: it reaches the host
 * directly through the raw crt seam, so its byte ops bypass backend_for. */
enum { FD_FREE = 0, FD_FILE, FD_DIR, FD_ROOT, FD_STREAM };
/* FD_STREAM is a raw host-fd stream: the standard streams 0/1/2, a pipe end, or
 * any descriptor inherited at spawn.  They are not special here; the sandbox
 * owns its host fd (the host gives each sandbox its own 0/1/2), so fs_close
 * closes it like any other.  Byte ops go straight to the raw crt seam. */
struct fd_slot {
    int      kind;
    int      mount;
    intptr_t h;
    int64_t  pos;
};
static struct fd_slot fd_tab[FS_MAX_FDS];

#ifdef FS_WITH_STREAMS
/* The raw crt seam the host-fd stream slots read/write through.  Only the guest
 * links these (0/1/2, pipe ends, and inherited fds bound to host capability
 * fds); the hosted fs_test build leaves them undefined and never sets
 * FS_WITH_STREAMS, so such a slot never appears. */
int  __sys_read(int fd, void *buf, int n);
int  __sys_write(int fd, const void *buf, int n);
int  __sys_close(int fd);
#endif

/* Descriptors a spawned child inherits (redirects, pipe ends).  The launcher
 * writes this fixed-layout table and fs_init installs it; empty on the root and
 * in the hosted fs_test. */
struct fs_inherit_fd fs_inherit_fds[FS_MAX_FDS];
int                  fs_inherit_n = 0;

/* Per-mount current directory as a normalized component path with no leading
 * slash ("" is the root), kept only so fs_getcwd can report it. */
static char cwd_path[FS_MAX_MOUNTS][FS_PATH_MAX];

/* A host mount routes to one of three backends by build and by flag.  The
 * hosted tools link hostfs (direct host libc).  The freestanding guest links
 * both the confined hostcap backend (a launcher-granted capability fd, the
 * default for a host mount) and the temporary ambient backend (AT_FDCWD), which
 * a host mount selects by carrying FS_RAWPATH; fs_init installs exactly that one
 * ambient mount when no --mount was given. */
static const struct fs_backend *
backend_for(const struct fs_mount *mt)
{
    unsigned kind = mt->flags & FS_KIND_MASK;
    switch (kind) {
#ifdef FS_WITH_RAM
    case FS_KIND_RAM:
        return &ramfs_backend;
#endif
#ifdef FS_WITH_DEV
    case FS_KIND_DEV:
        return &dev_backend;
#endif
#ifdef FS_WITH_ROM
    case FS_KIND_ROM:
        return &romfs_backend;
#endif
#ifdef FS_WITH_9P
    case FS_KIND_9P:
        return &ninefs_backend;
#endif
    case FS_KIND_HOST:
#if defined(FS_WITH_HOSTFS)
        return &hostfs_backend;
#else
# if defined(FS_WITH_HOSTCAP)
        if (!(mt->flags & FS_RAWPATH))
            return &hostcap_backend;
# endif
# if defined(FS_WITH_AMBIENT)
        return &ambient_backend;
# endif
        return 0;
#endif
    default:
        return 0;
    }
}

static int
fd_alloc(int kind, int mount, intptr_t h)
{
    int i;
    for (i = FS_FD_BASE; i < FS_MAX_FDS; i++) {
        if (fd_tab[i].kind == FD_FREE) {
            fd_tab[i].kind = kind;
            fd_tab[i].mount = mount;
            fd_tab[i].h = h;
            fd_tab[i].pos = 0;
            return i;
        }
    }
    return -EMFILE;
}

static struct fd_slot *
fd_get(int fd)
{
    if (fd < 0 || fd >= FS_MAX_FDS || fd_tab[fd].kind == FD_FREE)
        return 0;
    return &fd_tab[fd];
}

static void
pad_name(char out[FS_NAME_MAX], const char *name)
{
    int i = 0;
    for (; i < FS_NAME_MAX && name[i]; i++)
        out[i] = name[i];
    for (; i < FS_NAME_MAX; i++)
        out[i] = 0;
}

/* "ROOT" (any case) is the conventional name for the default root, mount index
 * 0.  It is a resolver alias, not a stored mount name: the table never holds a
 * mount literally called ROOT, so this is tried only after an exact match
 * fails, and it works whatever backend happens to sit at index 0.  The model is
 * the DOS single-drive case: almost every workload uses one drive and treats it
 * as the root, so ROOT: names it without the program having to know its real
 * mount name. */
static int
is_root_alias(const char padded[FS_NAME_MAX])
{
    char up[FS_NAME_MAX], want[FS_NAME_MAX];
    int i;
    for (i = 0; i < FS_NAME_MAX; i++) {
        char c = padded[i];
        up[i] = (c >= 'a' && c <= 'z') ? (char)(c - 32) : c;
    }
    pad_name(want, "ROOT");
    return memcmp(up, want, FS_NAME_MAX) == 0;
}

/* The default root (mount index 0) when it is present and live, else -1. */
static int
root_mount(void)
{
    if (fs_mount_count > 0 && fs_mounts[0].fd != -1)
        return 0;
    return -1;
}

int
fs_install_mount(const char *name, enum fs_kind kind, intptr_t root_handle,
                 uint32_t flags)
{
    struct fs_mount *mt;
    int m, rfd;

    if (fs_mount_count >= FS_MAX_MOUNTS)
        return -ENOMEM;
    m = fs_mount_count;
    rfd = fd_alloc(FD_ROOT, m, root_handle);
    if (rfd < 0)
        return rfd;

    mt = &fs_mounts[m];
    memset(mt, 0, sizeof *mt);
    pad_name(mt->name, name);
    mt->fd = (int16_t)rfd;
    mt->cwd = -1;                                   /* -1 == use the root */
    mt->flags = (flags & ~(uint32_t)FS_KIND_MASK) | (kind & FS_KIND_MASK);
    cwd_path[m][0] = 0;
    fs_mount_count++;
    return m;
}

/* Split a path into (mount index, subpath after the `name:` selector) and
 * report whether the subpath is mount-absolute (a leading '/').  A ':' counts
 * as a selector only in the first segment (before any '/'). */
static int
split_path(const char *path, const char **sub)
{
    const char *colon = fs_strchr(path, ':');
    const char *slash = fs_strchr(path, '/');

    if (colon && (!slash || colon < slash)) {
        char q[FS_NAME_MAX];
        int nlen = (int)(colon - path), m;
        if (nlen > FS_NAME_MAX)
            return -EINVAL;
        pad_name(q, "");
        memcpy(q, path, nlen);
        m = -1;
        {
            int i;
            for (i = 0; i < fs_mount_count; i++)
                if (fs_mounts[i].fd != -1 &&
                    memcmp(fs_mounts[i].name, q, FS_NAME_MAX) == 0) {
                    m = i;
                    break;
                }
        }
        if (m < 0 && is_root_alias(q))
            m = root_mount();
        if (m < 0)
            return -ENOENT;
        *sub = colon + 1;
        return m;
    }
    if (fs_cur_mount < 0 || fs_cur_mount >= fs_mount_count ||
        fs_mounts[fs_cur_mount].fd == -1)
        return -ENOENT;
    *sub = path;
    return fs_cur_mount;
}

/* Resolve a path for a backend op: the mount, its backend, the base-directory
 * handle (root for an absolute subpath, else the mount's cwd), and the
 * backend-relative remainder.  *absout (optional) gets the absolute flag. */
static int
resolve_op(const char *path, struct fs_mount **mp, const struct fs_backend **bp,
           intptr_t *base, const char **rel, int *absout)
{
    const char *sub;
    struct fs_mount *mt;
    const struct fs_backend *b;
    int m, absolute, basefd;

    fs_init();                          /* idempotent: a no-op once mounted */
    m = split_path(path, &sub);
    if (m < 0)
        return m;
    mt = &fs_mounts[m];
    b = backend_for(mt);
    if (!b)
        return -ENODEV;

    if (mt->flags & FS_RAWPATH) {
        /* Verbatim path: no anchoring, no leading-'/' strip.  base is the
         * mount root handle (the backend ignores it and anchors the path
         * itself, e.g. ambient against AT_FDCWD). */
        *mp = mt;
        *bp = b;
        *base = fd_tab[mt->fd].h;
        *rel = sub;
        if (absout)
            *absout = 0;
        return 0;
    }

    absolute = (sub[0] == '/');
    basefd = absolute ? mt->fd : (mt->cwd >= 0 ? mt->cwd : mt->fd);
    if (!fd_get(basefd))
        return -EBADF;
    while (*sub == '/')
        sub++;

    *mp = mt;
    *bp = b;
    *base = fd_tab[basefd].h;
    *rel = sub;
    if (absout)
        *absout = absolute;
    return 0;
}

int
fs_open(const char *path, int flags, int mode)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base, h;
    const char *rel;
    int rc, fd, isdir;

    rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    if ((mt->flags & FS_RO) &&
        ((flags & FS_O_ACCMODE) != FS_O_RDONLY || (flags & FS_O_CREAT)))
        return -EROFS;

    h = b->open(mt, base, rel, flags, mode);
    if (h < 0)
        return (int)h;
    isdir = (flags & FS_O_DIRECTORY) != 0;
    fd = fd_alloc(isdir ? FD_DIR : FD_FILE, (int)(mt - fs_mounts), h);
    if (fd < 0)
        b->close(mt, h, isdir);
    return fd;
}

int
fs_read(int fd, void *buf, int n)
{
    struct fd_slot *s = fd_get(fd);
    const struct fs_backend *b;
    struct fs_dirent de;
    int rc;

    if (!s)
        return -EBADF;
#ifdef FS_WITH_STREAMS
    if (s->kind == FD_STREAM)
        return __sys_read((int)s->h, buf, n);
#endif
    b = backend_for(&fs_mounts[s->mount]);
    if (s->kind == FD_FILE)
        return b->read(&fs_mounts[s->mount], s->h, buf, n, &s->pos);

    /* A directory or mount-root fd: fs_read yields fixed fs_dirent records. */
    if (n < (int)sizeof de)
        return -EINVAL;
    rc = b->readdir(&fs_mounts[s->mount], s->h, &s->pos, &de);
    if (rc <= 0)
        return rc;                    /* 0 at end, negative on error */
    memcpy(buf, &de, sizeof de);
    return (int)sizeof de;
}

int
fs_write(int fd, const void *buf, int n)
{
    struct fd_slot *s = fd_get(fd);
    const struct fs_backend *b;
    if (!s)
        return -EBADF;
#ifdef FS_WITH_STREAMS
    if (s->kind == FD_STREAM)
        return __sys_write((int)s->h, buf, n);
#endif
    if (s->kind != FD_FILE)
        return -EBADF;
    if (fs_mounts[s->mount].flags & FS_RO)
        return -EROFS;
    b = backend_for(&fs_mounts[s->mount]);
    return b->write(&fs_mounts[s->mount], s->h, buf, n, &s->pos);
}

int64_t
fs_lseek(int fd, int64_t off, int whence)
{
    struct fd_slot *s = fd_get(fd);
    const struct fs_backend *b;
    int64_t r;
    if (!s)
        return -EBADF;
#ifdef FS_WITH_STREAMS
    if (s->kind == FD_STREAM)
        return -ESPIPE;                   /* a stream is not seekable */
#endif
    if (s->kind != FD_FILE)
        return -EBADF;
    b = backend_for(&fs_mounts[s->mount]);
    if (!b->lseek)
        return -ESPIPE;
    r = b->lseek(&fs_mounts[s->mount], s->h, off, whence, &s->pos);
    if (r >= 0)
        s->pos = r;
    return r;
}

int
fs_close(int fd)
{
    struct fd_slot *s = fd_get(fd);
    const struct fs_backend *b;
    int rc;
    if (!s)
        return -EBADF;
#ifdef FS_WITH_STREAMS
    if (s->kind == FD_STREAM) {
        /* The sandbox owns its host fd (its own 0/1/2, pipe end, or inherited
         * stream), so close it: a pipe peer then sees EOF. */
        int rc = __sys_close((int)s->h);
        s->kind = FD_FREE;
        return rc;
    }
#endif
    b = backend_for(&fs_mounts[s->mount]);
    rc = b->close(&fs_mounts[s->mount], s->h, s->kind != FD_FILE);
    s->kind = FD_FREE;
    return rc;
}

int
fs_adopt_pipe(int gfd)
{
    return fd_alloc(FD_STREAM, -1, gfd);
}

int
fs_fd_backing(int fd, int *gfd)
{
    struct fd_slot *s = fd_get(fd);
    if (!s)
        return -EBADF;
    if (s->kind == FD_STREAM) {
        *gfd = (int)s->h;       /* 0/1/2, a pipe end, or an inherited stream */
        return 0;
    }
    if (s->kind == FD_FILE && s->mount >= 0) {
        /* A file on a host-backed mount (hostcap, devfs) carries a host
         * capability index as its handle, the same thing a stream carries, so
         * the host can dup it into a child: this is how a redirect to a file
         * reaches a spawned command. A ramfs, romfs or 9p handle is backend
         * state private to this process and cannot be passed. */
        uint32_t kind = fs_mounts[s->mount].flags & FS_KIND_MASK;
        if (kind == FS_KIND_HOST || kind == FS_KIND_DEV) {
            *gfd = (int)s->h;
            return 0;
        }
    }
    return -EINVAL;                 /* not a host-backed, passable fd */
}

int
fs_exists(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    return b->exists(mt, base, rel);
}

int64_t
fs_size(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    return b->size(mt, base, rel);
}

int
fs_isdir(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    return b->isdir(mt, base, rel);
}

int
fs_stat(const char *path, struct fs_stat *st)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    return b->stat(mt, base, rel, st);
}

int
fs_fstat(int fd, struct fs_stat *st)
{
    struct fd_slot *s = fd_get(fd);
    const struct fs_backend *b;
    if (!s)
        return -EBADF;
#ifdef FS_WITH_STREAMS
    if (s->kind == FD_STREAM) {
        memset(st, 0, sizeof *st);
        st->mode = FS_S_IFCHR | 0666u;    /* a raw stream: a character device */
        st->nlink = 1;
        return 0;
    }
#endif
    b = backend_for(&fs_mounts[s->mount]);
    return b->fstat(&fs_mounts[s->mount], s->h, s->kind != FD_FILE, st);
}

int
fs_unlink(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    if (mt->flags & FS_RO)
        return -EROFS;
    return b->unlink(mt, base, rel);
}

int
fs_mkdir(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    if (mt->flags & FS_RO)
        return -EROFS;
    return b->mkdir(mt, base, rel);
}

int
fs_rmdir(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base;
    const char *rel;
    int rc = resolve_op(path, &mt, &b, &base, &rel, 0);
    if (rc < 0)
        return rc;
    if (mt->flags & FS_RO)
        return -EROFS;
    return b->rmdir(mt, base, rel);
}

int
fs_rename(const char *from, const char *to)
{
    struct fs_mount *m1, *m2;
    const struct fs_backend *b1, *b2;
    intptr_t base1, base2;
    const char *r1, *r2;
    int rc;

    rc = resolve_op(from, &m1, &b1, &base1, &r1, 0);
    if (rc < 0)
        return rc;
    rc = resolve_op(to, &m2, &b2, &base2, &r2, 0);
    if (rc < 0)
        return rc;
    if (m1 != m2)
        return -EXDEV;              /* each mount is its own namespace */
    if (base1 != base2)
        return -EINVAL;             /* v1: both ends share one base (root/cwd) */
    if (m1->flags & FS_RO)
        return -EROFS;
    return b1->rename(m1, base1, r1, r2);
}

int
fs_mount_set(int index)
{
    if (index < 0 || index >= fs_mount_count || fs_mounts[index].fd == -1)
        return -EINVAL;
    fs_cur_mount = index;
    return 0;
}

int
fs_mount_current(void)
{
    return fs_cur_mount;
}

int
fs_mount_find(const char *name)
{
    char q[FS_NAME_MAX];
    int i;
    pad_name(q, name);
    for (i = 0; i < fs_mount_count; i++)
        if (fs_mounts[i].fd != -1 &&
            memcmp(fs_mounts[i].name, q, FS_NAME_MAX) == 0)
            return i;
    if (is_root_alias(q))
        return root_mount();
    return -1;
}

/* Fold `rel` (a backend-relative path, already selector-stripped) onto `out`,
 * which starts as the base component-path ("" for root).  Handles "." and
 * "..".  Produces a normalized component path with no leading slash. */
static void
normalize_cwd(char *out, const char *rel)
{
    char comp[FS_PATH_MAX];
    const char *p = rel;

    while (*p) {
        int n = 0;
        while (*p == '/')
            p++;
        while (*p && *p != '/' && n < (int)sizeof comp - 1)
            comp[n++] = *p++;
        comp[n] = 0;
        if (n == 0 || strcmp(comp, ".") == 0)
            continue;
        if (strcmp(comp, "..") == 0) {
            char *slash = fs_strrchr(out, '/');
            if (slash)
                *slash = 0;
            else
                out[0] = 0;
            continue;
        }
        if (out[0]) {
            size_t len = strlen(out);
            if (len + 1 + n < FS_PATH_MAX) {
                out[len] = '/';
                memcpy(out + len + 1, comp, n + 1);
            }
        } else if (n < FS_PATH_MAX) {
            memcpy(out, comp, n + 1);
        }
    }
}

int
fs_chdir(const char *path)
{
    struct fs_mount *mt;
    const struct fs_backend *b;
    intptr_t base, h;
    const char *rel;
    int rc, absolute, m, fd;
    char newcwd[FS_PATH_MAX];

    rc = resolve_op(path, &mt, &b, &base, &rel, &absolute);
    if (rc < 0)
        return rc;
    m = (int)(mt - fs_mounts);

    h = b->open(mt, base, rel, FS_O_DIRECTORY | FS_O_RDONLY, 0);  /* dir only */
    if (h < 0)
        return (int)h;

    if (absolute)
        newcwd[0] = 0;
    else {
        size_t len = strlen(cwd_path[m]);
        memcpy(newcwd, cwd_path[m], len + 1);
    }
    normalize_cwd(newcwd, rel);

    /* Replace the old cwd fd (if any; -1 is the root sentinel). */
    if (mt->cwd >= 0) {
        struct fd_slot *old = fd_get(mt->cwd);
        if (old) {
            b->close(mt, old->h, 1);
            old->kind = FD_FREE;
        }
    }
    fd = fd_alloc(FD_DIR, m, h);
    if (fd < 0) {
        b->close(mt, h, 1);
        mt->cwd = -1;
        return fd;
    }
    mt->cwd = (int16_t)fd;
    memcpy(cwd_path[m], newcwd, strlen(newcwd) + 1);
    return 0;
}

int
fs_getcwd(int index, char *buf, int cap)
{
    const char *p;
    int n;
    if (index < 0 || index >= fs_mount_count || fs_mounts[index].fd == -1)
        return -EINVAL;
    p = cwd_path[index];
    n = (int)strlen(p);
    if (n + 2 > cap)                   /* leading '/' + NUL */
        return -ERANGE;
    buf[0] = '/';
    memcpy(buf + 1, p, n + 1);
    return n + 1;
}

void
fs_init(void)
{
    static int started;

    if (started)
        return;
    started = 1;

#ifdef FS_WITH_STREAMS
    /* Bind 0/1/2 to the sandbox's own stdin/stdout/stderr as stream slots so
     * they live in the one fd space like every other fd, with no special case:
     * the host gave this sandbox its own host fds for them.  fd_alloc starts at
     * FS_FD_BASE, so a later open never lands on them.  Runs on every path,
     * before the table-adoption return below. */
    {
        int i;
        for (i = 0; i < FS_FD_BASE; i++) {
            fd_tab[i].kind = FD_STREAM;
            fd_tab[i].mount = -1;
            fd_tab[i].h = i;
            fd_tab[i].pos = 0;
        }
    }

    /* Install the descriptors a parent passed at spawn (redirects, pipe ends),
     * each a host-fd stream the child owns.  These override the defaults above
     * and claim their slots before the mount adoption below allocates any, so
     * fd_alloc skips them. */
    {
        int i;
        for (i = 0; i < fs_inherit_n && i < FS_MAX_FDS; i++) {
            int dst = fs_inherit_fds[i].dst;
            if (dst < 0 || dst >= FS_MAX_FDS)
                continue;
            fd_tab[dst].kind = FD_STREAM;
            fd_tab[dst].mount = -1;
            fd_tab[dst].h = fs_inherit_fds[i].gfd;
            fd_tab[dst].pos = 0;
        }
    }
#endif

    if (fs_mount_count > 0) {
        /* The table is already populated: either the launcher filled it (the
         * guest --mount path) or a hosted caller installed its own mounts
         * through fs_install_mount (the fs_test harness).  Only the launcher
         * path needs adoption, and only the guest build links it, so the pass
         * is gated on FS_WITH_HOSTCAP; a hosted table is left untouched. */
#ifdef FS_WITH_HOSTCAP
        /* The launcher wrote each entry's `fd` as a sandbox capability fd: a raw
         * directory fd its kernel resolves paths against, not an fs.c fd-space
         * slot.  Adopt each into the fd space by allocating an FD_ROOT slot
         * whose backend handle is that capability fd, then repointing mt->fd at
         * the slot, so resolve_op hands the confined hostcap backend the
         * capability fd as its base.  A host mount here carries no FS_RAWPATH,
         * so backend_for routes it to the confined backend, not the ambient
         * stop-gap.  (A table that fs_install_mount built would already have its
         * root slots allocated; the guest never installs mounts before this
         * runs, so the pass only ever sees a launcher table.) */
        int ngrants = fs_mount_count, i, scratch;
        for (i = 0; i < ngrants; i++) {
            struct fs_mount *mt = &fs_mounts[i];
            enum fs_kind kind = (enum fs_kind)(mt->flags & FS_KIND_MASK);
            intptr_t root;
            int slot;
            switch (kind) {
            case FS_KIND_HOST:
                /* The launcher wrote a raw capability fd in `fd`: a directory
                 * fd its kernel resolves paths against, the hostcap backend's
                 * root handle. */
                if (mt->fd < 0)
                    continue;
                root = (intptr_t)mt->fd;
                break;
#ifdef FS_WITH_DEV
            case FS_KIND_DEV:
                /* devfs has no backing fd; its root is a fixed sentinel. */
                root = (intptr_t)DEVFS_ROOT;
                break;
#endif
#ifdef FS_WITH_ROM
            case FS_KIND_ROM:
                /* The launcher loaded the image into guest memory; the aux
                 * entry carries its address and length.  romfs_adopt parses it
                 * and registers it for this mount, returning the root handle. */
                root = romfs_adopt(i, (const void *)(uintptr_t)fs_mount_aux[i].p0,
                                   (size_t)fs_mount_aux[i].p1);
                break;
#endif
#ifdef FS_WITH_9P
            case FS_KIND_9P: {
                /* The launcher bound a doorbell channel; aux p0 is its guest
                 * address.  Build the channel transport and hand it to the 9p
                 * client, which does the version+attach handshake. */
                struct p9_transport t9;
                p9_guest_transport(fs_mount_aux[i].p0, &t9);
                root = ninefs_adopt(i, &t9);
                break;
            }
#endif
            default:
                continue;
            }
            if (root < 0)
                continue;               /* the backend rejected this grant */
            slot = fd_alloc(FD_ROOT, i, root);
            if (slot < 0)
                break;                  /* fd space full: leave the rest unusable */
            mt->fd = (int16_t)slot;
            mt->cwd = -1;               /* -1 == use the root */
            cwd_path[i][0] = 0;
        }
        /* Land on scratch, the default spot where a bare path resolves.  When
         * the host grants an ephemeral "scratch" directory (skj-run does), it is
         * already in the table as a confined host mount, so just select it and
         * the guest needs no in-guest filesystem at all.  When no host scratch
         * was granted the table still holds the always-on proc: mount, so this
         * pass runs even with nothing to land on; fall back to the same default
         * landing the no-table path installs, so a bare path resolves the way it
         * would if the table were empty: the in-guest ramfs scratch, overridden
         * by the unconfined ambient host when FS_AMBIENT_DEFAULT is set. */
        scratch = fs_mount_find("scratch");
        if (scratch < 0) {
#ifdef FS_WITH_RAM
            scratch = ramfs_mount("scratch", 0);
#endif
#ifdef FS_AMBIENT_DEFAULT
            {
                int h = ambient_mount("host", 0);
                if (h >= 0)
                    scratch = h;
            }
#endif
        }
        if (scratch >= 0)
            fs_cur_mount = scratch;
#endif
        return;
    }

    /* No table was handed in.  Install the safe empty scratch ramfs at index 0
     * and land on it: that is the default policy, so a bare path stays in RAM
     * and the host is not reachable unless a mount grants it.
     *
     * FS_AMBIENT_DEFAULT is the documented, temporary override that restores the
     * pre-fs behaviour (a bare path reaching the host cwd through an unconfined
     * AT_FDCWD mount).  It is kept only for the test harnesses that run an
     * fs/-interpose guest under bare qemu, where no launcher can grant a
     * --mount; it needs FS_WITH_AMBIENT and goes away once those migrate to a
     * capability mount. */
#ifdef FS_WITH_RAM
    ramfs_mount("scratch", 0);         /* index 0: the safe empty scratch disk */
    fs_cur_mount = 0;
#endif
#ifdef FS_AMBIENT_DEFAULT
    {
        int h = ambient_mount("host", 0);
        if (h >= 0)
            fs_cur_mount = h;
    }
#endif
}
