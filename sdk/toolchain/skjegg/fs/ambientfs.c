/* ambientfs: the temporary ambient host backend for the freestanding guest.
 *
 * It issues the crt's AT_FDCWD syscall wrappers directly, so a bare path
 * reaches the host cwd exactly as the libc did before the fs/ layer existed.
 * `base` is ignored: every op resolves against AT_FDCWD, which is what every
 * libc path call did before.  So this backend is deliberately UNCONFINED and
 * has no per-mount cwd; it is a stop-gap that lets the fd model route through
 * fs/ while real host access is still ambient.
 *
 * It goes away once host access is capability-only: a --mount granted dirfd
 * reached through a confined backend (openat on the capability fd, with
 * RESOLVE_BENEATH).  Until then fs_init installs one ambient mount and points
 * the current mount at it.  Guest/freestanding only (FS_WITH_AMBIENT); the
 * hosted tools use hostfs.c.
 *
 * The file byte ops call the RAW crt wrappers __sys_open/read/write/close/lseek,
 * never the public open/read/write/close/lseek: the C libc interposes fs/ over
 * those public names (libc/fdio.c), so an open() here would recurse back into
 * fs_open.  The __sys_* aliases are the weak wrappers' raw entry points
 * (runtime/syscall_rv.S, syscall_cf.S).  The metadata calls (getdents64, the
 * *at forms, statx) are not interposed, so they keep their public names. */

#include "ambientfs.h"
#include "fs_internal.h"

#include <stdint.h>
#include <string.h>
#include <fcntl.h>                    /* O_*, AT_FDCWD, AT_REMOVEDIR, AT_EMPTY_PATH */
#include <unistd.h>                   /* getdents64                                */
#include <sys/stat.h>                 /* statx (opaque), mkdirat                    */
#include <errno.h>                    /* EMFILE                                     */

/* The raw syscall seam this backend issues.  __sys_* are the crt wrappers'
 * un-interposed entry points; the *at metadata calls the headers do not
 * declare are crt wrappers too. */
int  __sys_open(const char *path, int flags, int mode);
int  __sys_read(int fd, void *buf, int n);
int  __sys_write(int fd, const void *buf, int n);
int  __sys_close(int fd);
long __sys_lseek(int fd, long off, int whence);
int  unlinkat(int dirfd, const char *path, int flags);
int  renameat2(int ofd, const char *op, int nfd, const char *np, unsigned flags);

/* The statx record, pinned to the kernel ABI, so the fields this backend reads
 * line up.  <sys/stat.h> keeps `struct statx` opaque (libc/stat.c has its own
 * copy); this is the same layout under a private name. */
#define AMBIENT_STATX_BASIC 0x000007ffu
struct ambient_statx {
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
do_statx(int dirfd, const char *path, int flags, struct ambient_statx *sx)
{
    return statx(dirfd, path, flags, AMBIENT_STATX_BASIC, (struct statx *)(void *)sx);
}

static void
fill_stat(const struct ambient_statx *sx, struct fs_stat *st)
{
    st->dev = ((uint64_t)sx->stx_dev_major << 8) | sx->stx_dev_minor;
    st->ino = sx->stx_ino;
    st->size = (int64_t)sx->stx_size;
    st->mode = sx->stx_mode;
    st->nlink = sx->stx_nlink;
}

#define AMBIENT_MAXDIRS 16
#define AMBIENT_DIRBUF  4096

struct adir {
    int  used;
    int  fd;                          /* the directory's host fd */
    int  pos;                         /* next unread byte in buf */
    int  len;                         /* valid bytes in buf */
    char buf[AMBIENT_DIRBUF];
};

static struct adir adirs[AMBIENT_MAXDIRS];

static int
adir_alloc(int fd)
{
    int i;
    for (i = 0; i < AMBIENT_MAXDIRS; i++)
        if (!adirs[i].used) {
            adirs[i].used = 1;
            adirs[i].fd = fd;
            adirs[i].pos = adirs[i].len = 0;
            return i;
        }
    return -EMFILE;
}

/* getdents64 record (the kernel linux_dirent64). */
struct adirent64 {
    uint64_t       d_ino;
    int64_t        d_off;
    unsigned short d_reclen;
    unsigned char  d_type;
    char           d_name[];
};
#define ADT_DIR 4
#define ADT_REG 8

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

static const char *
ap(const char *rel)
{
    return rel[0] ? rel : ".";
}

static intptr_t
amb_open(struct fs_mount *m, intptr_t base, const char *rel, int flags, int mode)
{
    int fd;
    (void)m;
    (void)base;
    if (flags & FS_O_DIRECTORY) {
        fd = __sys_open(ap(rel), O_RDONLY, 0);     /* getdents64 reads it below */
        if (fd < 0)
            return fd;                        /* crt returns -errno */
        {
            int idx = adir_alloc(fd);
            if (idx < 0) {
                __sys_close(fd);
                return idx;
            }
            return idx;                       /* a directory handle is an adir index */
        }
    }
    fd = __sys_open(ap(rel), to_oflags(flags), mode);
    return fd;                                /* a file handle is a host fd */
}

static int
amb_read(struct fs_mount *m, intptr_t h, void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)pos;                                /* the host fd carries its offset */
    return __sys_read((int)h, buf, n);
}

static int
amb_write(struct fs_mount *m, intptr_t h, const void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)pos;
    return __sys_write((int)h, buf, n);
}

static int64_t
amb_lseek(struct fs_mount *m, intptr_t h, int64_t off, int whence, int64_t *pos)
{
    long r = __sys_lseek((int)h, (long)off, whence);
    (void)m;
    if (r < 0)
        return r;
    *pos = (int64_t)r;
    return (int64_t)r;
}

static int
amb_readdir(struct fs_mount *m, intptr_t h, int64_t *cursor, struct fs_dirent *de)
{
    struct adir *d = &adirs[h];
    (void)m;
    (void)cursor;                             /* the adir buffer carries the cursor */
    for (;;) {
        struct adirent64 *e;
        if (d->pos >= d->len) {
            int n = getdents64(d->fd, d->buf, AMBIENT_DIRBUF);
            if (n < 0)
                return n;
            if (n == 0)
                return 0;
            d->len = n;
            d->pos = 0;
        }
        e = (struct adirent64 *)(d->buf + d->pos);
        d->pos += e->d_reclen;
        if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0)
            continue;
        de->ino = (uint32_t)e->d_ino;
        de->type = (e->d_type == ADT_DIR) ? FS_DT_DIR
                 : (e->d_type == ADT_REG) ? FS_DT_REG
                 : FS_DT_UNKNOWN;
        de->pad[0] = de->pad[1] = de->pad[2] = 0;
        strncpy(de->name, e->d_name, FS_DIRENT_NAMEMAX - 1);
        de->name[FS_DIRENT_NAMEMAX - 1] = 0;
        return 1;
    }
}

static int
amb_close(struct fs_mount *m, intptr_t h, int is_dir)
{
    (void)m;
    if (is_dir) {
        int fd = adirs[h].fd;
        adirs[h].used = 0;
        return __sys_close(fd);
    }
    return __sys_close((int)h);
}

static int
amb_exists(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct ambient_statx sx;
    (void)m;
    (void)base;
    return do_statx(AT_FDCWD, ap(rel), 0, &sx) == 0 ? 1 : 0;
}

static int64_t
amb_size(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct ambient_statx sx;
    int rc;
    (void)m;
    (void)base;
    rc = do_statx(AT_FDCWD, ap(rel), 0, &sx);
    if (rc < 0)
        return rc;
    return (int64_t)sx.stx_size;
}

static int
amb_isdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct ambient_statx sx;
    (void)m;
    (void)base;
    if (do_statx(AT_FDCWD, ap(rel), 0, &sx) < 0)
        return 0;
    return (sx.stx_mode & FS_S_IFMT) == FS_S_IFDIR ? 1 : 0;
}

static int
amb_stat(struct fs_mount *m, intptr_t base, const char *rel, struct fs_stat *st)
{
    struct ambient_statx sx;
    int rc;
    (void)m;
    (void)base;
    rc = do_statx(AT_FDCWD, ap(rel), 0, &sx);
    if (rc < 0)
        return rc;
    fill_stat(&sx, st);
    return 0;
}

static int
amb_fstat(struct fs_mount *m, intptr_t h, int is_dir, struct fs_stat *st)
{
    struct ambient_statx sx;
    int fd = is_dir ? adirs[h].fd : (int)h;
    int rc;
    (void)m;
    rc = do_statx(fd, "", AT_EMPTY_PATH, &sx);
    if (rc < 0)
        return rc;
    fill_stat(&sx, st);
    return 0;
}

static int
amb_unlink(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    return unlinkat(AT_FDCWD, ap(rel), 0);
}

static int
amb_mkdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    return mkdirat(AT_FDCWD, ap(rel), 0777);
}

static int
amb_rmdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    return unlinkat(AT_FDCWD, ap(rel), AT_REMOVEDIR);
}

static int
amb_rename(struct fs_mount *m, intptr_t base, const char *from, const char *to)
{
    (void)m;
    (void)base;
    return renameat2(AT_FDCWD, ap(from), AT_FDCWD, ap(to), 0);
}

const struct fs_backend ambient_backend = {
    FS_KIND_HOST, "ambient",
    amb_open, amb_read, amb_write, amb_lseek, amb_readdir, amb_close,
    amb_exists, amb_size, amb_isdir, amb_stat, amb_fstat,
    amb_unlink, amb_rename, amb_mkdir, amb_rmdir,
};

int
ambient_mount(const char *name, uint32_t flags)
{
    /* base is always AT_FDCWD, so the root handle is an unused sentinel.
     * FS_RAWPATH makes the resolver hand this backend the path verbatim, so a
     * guest path reaches openat(AT_FDCWD, path) exactly as before the layer. */
    return fs_install_mount(name, FS_KIND_HOST, 0, flags | FS_RAWPATH);
}
