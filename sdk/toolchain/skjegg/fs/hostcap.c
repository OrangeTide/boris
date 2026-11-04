/* hostcap: the confined host backend for the freestanding guest.
 *
 * This is the capability form of host access.  Each mount's root is a sandbox
 * capability fd, a directory fd the launcher opened and granted with --mount
 * (skj-run's kernel keeps the real host fd in its own table and hands the guest
 * only an opaque index; see emu/guest.c).  Every op resolves its path against
 * that capability fd through the crt's `openat` / `statx` / `*at` wrappers, so
 * a path can only name something at or below the granted directory.  It is the
 * confined replacement for the ambient stop-gap (ambientfs.c): there is no
 * AT_FDCWD here and no FS_RAWPATH, so a guest reaches exactly what it was
 * granted and nothing else.
 *
 * `base` is the capability fd.  Paths arrive relative to it with the `name:`
 * selector and any leading '/' already stripped by the resolver, so a path can
 * only descend.  The remaining escape vector, a ".." component, is rejected
 * here, matching hostfs.c.
 *
 * Confinement gap (v1): the guest-side ".." rejection and the kernel's fd-table
 * isolation confine a cooperating guest and keep host fds unreachable, but a
 * hostile guest can still issue a raw openat on the capability fd with a ".."
 * path, which the kernel services without RESOLVE_BENEATH.  Kernel-enforced
 * confinement (openat2 RESOLVE_BENEATH on a GDEV_HOSTFS dirfd) is the planned
 * hardening and is tracked, not done here.  The same openat2 step also closes
 * the symlink-escape gap hostfs.c documents.
 *
 * Structure mirrors ambientfs.c (the dir-buffer table, the private statx
 * record).  The two are kept as separate files deliberately: ambientfs.c is the
 * temporary stop-gap slated for deletion once host access is capability-only,
 * and keeping it self-contained makes that a clean file delete.
 *
 * The file byte ops call the RAW crt wrappers __sys_read/write/close/lseek, not
 * the public names, because the C libc interposes fs/ over those public names
 * (libc/fdio.c); a read() here would recurse back into fs_read.  `openat` and
 * the metadata calls (getdents64, statx, the *at forms) are not interposed, so
 * they keep their public names. */

#include "hostcap.h"
#include "fs_internal.h"

#include <stdint.h>
#include <string.h>
#include <fcntl.h>                    /* O_*, AT_REMOVEDIR, AT_EMPTY_PATH */
#include <unistd.h>                   /* getdents64                       */
#include <sys/stat.h>                 /* statx (opaque), mkdirat           */
#include <errno.h>                    /* EACCES, EMFILE                    */

/* The crt seam this backend issues.  openat takes the capability fd as its
 * dirfd; __sys_* are the un-interposed byte-op wrappers; the *at metadata calls
 * the headers do not declare are crt wrappers too. */
int  openat(int dirfd, const char *path, int flags, int mode);
int  __sys_read(int fd, void *buf, int n);
int  __sys_write(int fd, const void *buf, int n);
int  __sys_close(int fd);
long __sys_lseek(int fd, long off, int whence);
int  unlinkat(int dirfd, const char *path, int flags);
int  renameat2(int ofd, const char *op, int nfd, const char *np, unsigned flags);

/* The statx record, pinned to the kernel ABI (same layout as ambientfs.c's,
 * under a private name since <sys/stat.h> keeps `struct statx` opaque). */
#define HOSTCAP_STATX_BASIC 0x000007ffu
struct hostcap_statx {
    uint32_t stx_mask;
    uint32_t stx_blksize;
    uint64_t stx_attributes;
    uint32_t stx_nlink;
    uint32_t stx_uid;
    uint32_t stx_gid;
    uint16_t stx_mode;
    uint16_t __spare0;
    uint64_t stx_ino;
    uint64_t stx_size;
    uint64_t stx_blocks;
    uint64_t stx_attributes_mask;
    int64_t  stx_atime_sec;  uint32_t stx_atime_nsec; int32_t __ra;
    int64_t  stx_btime_sec;  uint32_t stx_btime_nsec; int32_t __rb;
    int64_t  stx_ctime_sec;  uint32_t stx_ctime_nsec; int32_t __rc;
    int64_t  stx_mtime_sec;  uint32_t stx_mtime_nsec; int32_t __rm;
    uint32_t stx_rdev_major;
    uint32_t stx_rdev_minor;
    uint32_t stx_dev_major;
    uint32_t stx_dev_minor;
    uint64_t stx_mnt_id;
    uint32_t stx_dio_mem_align;
    uint32_t stx_dio_offset_align;
    uint64_t __spare3[12];
};

static int
do_statx(int dirfd, const char *path, int flags, struct hostcap_statx *sx)
{
    return statx(dirfd, path, flags, HOSTCAP_STATX_BASIC, (struct statx *)(void *)sx);
}

static void
fill_stat(const struct hostcap_statx *sx, struct fs_stat *st)
{
    st->dev = ((uint64_t)sx->stx_dev_major << 8) | sx->stx_dev_minor;
    st->ino = sx->stx_ino;
    st->size = (int64_t)sx->stx_size;
    st->mode = sx->stx_mode;
    st->nlink = sx->stx_nlink;
}

#define HOSTCAP_MAXDIRS 16
#define HOSTCAP_DIRBUF  4096

struct cdir {
    int  used;
    int  fd;                          /* the directory's host (sandbox) fd */
    int  pos;                         /* next unread byte in buf */
    int  len;                         /* valid bytes in buf */
    char buf[HOSTCAP_DIRBUF];
};

static struct cdir cdirs[HOSTCAP_MAXDIRS];

static int
cdir_alloc(int fd)
{
    int i;
    for (i = 0; i < HOSTCAP_MAXDIRS; i++)
        if (!cdirs[i].used) {
            cdirs[i].used = 1;
            cdirs[i].fd = fd;
            cdirs[i].pos = cdirs[i].len = 0;
            return i;
        }
    return -EMFILE;
}

/* getdents64 record (the kernel linux_dirent64). */
struct cdirent64 {
    uint64_t       d_ino;
    int64_t        d_off;
    unsigned short d_reclen;
    unsigned char  d_type;
    char           d_name[];
};
#define CDT_DIR 4
#define CDT_REG 8

static int
to_oflags(int f)
{
    int o;
    switch (f & FS_O_ACCMODE) {
    case FS_O_WRONLY: o = O_WRONLY; break;
    case FS_O_RDWR:   o = O_RDWR;   break;
    default:          o = O_RDONLY; break;
    }
    if (f & FS_O_CREAT)
        o |= O_CREAT;
    if (f & FS_O_TRUNC)
        o |= O_TRUNC;
    if (f & FS_O_APPEND)
        o |= O_APPEND;
    return o;
}

/* "" means the base directory itself; openat/statx want "." for it. */
static const char *
cp(const char *rel)
{
    return rel[0] ? rel : ".";
}

/* Reject any ".." component: it is the one way a selector-stripped, descend-only
 * path could climb out of the granted directory.  Mirrors hostfs.c. */
static int
has_dotdot(const char *rel)
{
    const char *p = rel;
    while (*p) {
        const char *s = p;
        int len;
        while (*p && *p != '/')
            p++;
        len = (int)(p - s);
        if (len == 2 && s[0] == '.' && s[1] == '.')
            return 1;
        while (*p == '/')
            p++;
    }
    return 0;
}

static intptr_t
cap_open(struct fs_mount *m, intptr_t base, const char *rel, int flags, int mode)
{
    int fd;
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    if (flags & FS_O_DIRECTORY) {
        fd = openat((int)base, cp(rel), O_RDONLY, 0);  /* getdents64 reads it */
        if (fd < 0)
            return fd;                        /* crt returns -errno */
        {
            int idx = cdir_alloc(fd);
            if (idx < 0) {
                __sys_close(fd);
                return idx;
            }
            return idx;                       /* a directory handle is a cdir index */
        }
    }
    fd = openat((int)base, cp(rel), to_oflags(flags), mode);
    return fd;                                /* a file handle is a host fd */
}

static int
cap_read(struct fs_mount *m, intptr_t h, void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)pos;                                /* the host fd carries its offset */
    return __sys_read((int)h, buf, n);
}

static int
cap_write(struct fs_mount *m, intptr_t h, const void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)pos;
    return __sys_write((int)h, buf, n);
}

static int64_t
cap_lseek(struct fs_mount *m, intptr_t h, int64_t off, int whence, int64_t *pos)
{
    long r = __sys_lseek((int)h, (long)off, whence);
    (void)m;
    if (r < 0)
        return r;
    *pos = (int64_t)r;
    return (int64_t)r;
}

static int
cap_readdir(struct fs_mount *m, intptr_t h, int64_t *cursor, struct fs_dirent *de)
{
    struct cdir *d = &cdirs[h];
    (void)m;
    (void)cursor;                             /* the cdir buffer carries the cursor */
    for (;;) {
        struct cdirent64 *e;
        if (d->pos >= d->len) {
            int n = getdents64(d->fd, d->buf, HOSTCAP_DIRBUF);
            if (n < 0)
                return n;
            if (n == 0)
                return 0;
            d->len = n;
            d->pos = 0;
        }
        e = (struct cdirent64 *)(d->buf + d->pos);
        d->pos += e->d_reclen;
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0)
            continue;
        de->ino = (uint32_t)e->d_ino;
        de->type = (e->d_type == CDT_DIR) ? FS_DT_DIR
                 : (e->d_type == CDT_REG) ? FS_DT_REG
                 : FS_DT_UNKNOWN;
        de->pad[0] = de->pad[1] = de->pad[2] = 0;
        strncpy(de->name, e->d_name, FS_DIRENT_NAMEMAX - 1);
        de->name[FS_DIRENT_NAMEMAX - 1] = 0;
        return 1;
    }
}

static int
cap_close(struct fs_mount *m, intptr_t h, int is_dir)
{
    (void)m;
    if (is_dir) {
        int fd = cdirs[h].fd;
        cdirs[h].used = 0;
        return __sys_close(fd);
    }
    return __sys_close((int)h);
}

static int
cap_exists(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct hostcap_statx sx;
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    return do_statx((int)base, cp(rel), 0, &sx) == 0 ? 1 : 0;
}

static int64_t
cap_size(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct hostcap_statx sx;
    int rc;
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    rc = do_statx((int)base, cp(rel), 0, &sx);
    if (rc < 0)
        return rc;
    return (int64_t)sx.stx_size;
}

static int
cap_isdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct hostcap_statx sx;
    (void)m;
    if (has_dotdot(rel))
        return 0;
    if (do_statx((int)base, cp(rel), 0, &sx) < 0)
        return 0;
    return (sx.stx_mode & FS_S_IFMT) == FS_S_IFDIR ? 1 : 0;
}

static int
cap_stat(struct fs_mount *m, intptr_t base, const char *rel, struct fs_stat *st)
{
    struct hostcap_statx sx;
    int rc;
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    rc = do_statx((int)base, cp(rel), 0, &sx);
    if (rc < 0)
        return rc;
    fill_stat(&sx, st);
    return 0;
}

static int
cap_fstat(struct fs_mount *m, intptr_t h, int is_dir, struct fs_stat *st)
{
    struct hostcap_statx sx;
    int fd = is_dir ? cdirs[h].fd : (int)h;
    int rc;
    (void)m;
    rc = do_statx(fd, "", AT_EMPTY_PATH, &sx);
    if (rc < 0)
        return rc;
    fill_stat(&sx, st);
    return 0;
}

static int
cap_unlink(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    return unlinkat((int)base, cp(rel), 0);
}

static int
cap_mkdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    return mkdirat((int)base, cp(rel), 0777);
}

static int
cap_rmdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    if (has_dotdot(rel))
        return -EACCES;
    return unlinkat((int)base, cp(rel), AT_REMOVEDIR);
}

static int
cap_rename(struct fs_mount *m, intptr_t base, const char *from, const char *to)
{
    (void)m;
    if (has_dotdot(from) || has_dotdot(to))
        return -EACCES;
    return renameat2((int)base, cp(from), (int)base, cp(to), 0);
}

const struct fs_backend hostcap_backend = {
    FS_KIND_HOST, "hostcap",
    cap_open, cap_read, cap_write, cap_lseek, cap_readdir, cap_close,
    cap_exists, cap_size, cap_isdir, cap_stat, cap_fstat,
    cap_unlink, cap_rename, cap_mkdir, cap_rmdir,
};

int
hostcap_mount(const char *name, int capfd, uint32_t flags)
{
    /* The root handle is the capability fd; openat resolves against it.  No
     * FS_RAWPATH: the resolver anchors each path and strips the leading '/', so
     * the backend only ever sees a descend-only relative path. */
    return fs_install_mount(name, FS_KIND_HOST, (intptr_t)capfd, flags);
}
