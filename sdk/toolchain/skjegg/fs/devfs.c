/* devfs: a fixed, flat set of device files for the sandbox.
 *
 * The classic character devices a program expects to exist: null (discards
 * writes, reads as end-of-file), zero (an endless source of zero bytes,
 * discards writes), and full (reads as zero, every write fails with ENOSPC).
 * The set is fixed, so there is nothing to allocate: a backend handle is the
 * device index, and the mount root is a sentinel handle the directory ops
 * recognize.  The mount is immutable (no create, unlink, rename, mkdir). */

#include "devfs.h"
#include "fs_internal.h"

#include <string.h>
#include <errno.h>

enum { DEV_NULL, DEV_ZERO, DEV_FULL, DEV_COUNT };

/* The root-directory handle, distinct from any device index (0..DEV_COUNT-1)
 * and from a negative errno, so a caller tells all three apart.  Exposed to the
 * guest adoption pass as DEVFS_ROOT (see devfs.h). */
#define DEV_DIR DEVFS_ROOT

static const char *const dev_names[DEV_COUNT] = { "null", "zero", "full" };

/* Resolve a backend-relative name to a device index, DEV_DIR for the root, or
 * a negative errno.  The set is flat: a name with a path separator cannot
 * exist. */
static int
dev_lookup(const char *rel)
{
    int i;

    while (*rel == '/')
        rel++;
    if (*rel == 0)
        return DEV_DIR;
    for (i = 0; i < DEV_COUNT; i++)
        if (strcmp(rel, dev_names[i]) == 0)
            return i;
    return -ENOENT;
}

static intptr_t
dev_open(struct fs_mount *m, intptr_t base, const char *rel, int flags, int mode)
{
    int h = dev_lookup(rel);
    (void)m;
    (void)base;
    (void)mode;

    if (flags & FS_O_DIRECTORY) {
        if (h == DEV_DIR)
            return DEV_DIR;
        if (h >= 0)
            return -ENOTDIR;
        return h;
    }
    if (h == DEV_DIR)
        return -EISDIR;
    if (h >= 0)
        return h;
    /* not found: devfs is fixed, so a create cannot add one */
    if (flags & FS_O_CREAT)
        return -EPERM;
    return h;
}

static int
dev_read(struct fs_mount *m, intptr_t h, void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)pos;
    if (n <= 0)
        return 0;
    switch ((int)h) {
    case DEV_NULL:
        return 0;                       /* end of file */
    case DEV_ZERO:
    case DEV_FULL:
        memset(buf, 0, (size_t)n);      /* an endless run of zero bytes */
        return n;
    default:
        return -EBADF;
    }
}

static int
dev_write(struct fs_mount *m, intptr_t h, const void *buf, int n, int64_t *pos)
{
    (void)m;
    (void)buf;
    (void)pos;
    switch ((int)h) {
    case DEV_NULL:
    case DEV_ZERO:
        return n;                       /* discarded */
    case DEV_FULL:
        return -ENOSPC;                 /* the device is always full */
    default:
        return -EBADF;
    }
}

static int64_t
dev_lseek(struct fs_mount *m, intptr_t h, int64_t off, int whence, int64_t *pos)
{
    (void)m;
    (void)h;
    (void)off;
    (void)whence;
    *pos = 0;                           /* a character device has no position */
    return 0;
}

static void
dev_fill_stat(int is_dir, struct fs_stat *st)
{
    st->dev = 0x6446;                   /* 'dF': a constant devfs device id */
    st->ino = 0;
    st->size = 0;
    st->mode = is_dir ? (FS_S_IFDIR | 0555u) : (FS_S_IFREG | 0666u);
    st->nlink = 1;
}

static int
dev_readdir(struct fs_mount *m, intptr_t h, int64_t *cursor, struct fs_dirent *de)
{
    int i = (int)*cursor;
    (void)m;
    if (h != DEV_DIR)
        return -ENOTDIR;
    if (i < 0 || i >= DEV_COUNT)
        return 0;
    de->ino = (uint32_t)(i + 1);
    de->type = FS_DT_REG;
    de->pad[0] = de->pad[1] = de->pad[2] = 0;
    strncpy(de->name, dev_names[i], FS_DIRENT_NAMEMAX - 1);
    de->name[FS_DIRENT_NAMEMAX - 1] = 0;
    *cursor = i + 1;
    return 1;
}

static int
dev_close(struct fs_mount *m, intptr_t h, int is_dir)
{
    (void)m;
    (void)h;
    (void)is_dir;
    return 0;
}

static int
dev_exists(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    return dev_lookup(rel) >= 0 ? 1 : 0;
}

static int64_t
dev_size(struct fs_mount *m, intptr_t base, const char *rel)
{
    int h = dev_lookup(rel);
    (void)m;
    (void)base;
    return h >= 0 ? 0 : h;
}

static int
dev_isdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    return dev_lookup(rel) == DEV_DIR ? 1 : 0;
}

static int
dev_stat(struct fs_mount *m, intptr_t base, const char *rel, struct fs_stat *st)
{
    int h = dev_lookup(rel);
    (void)m;
    (void)base;
    if (h < 0)
        return h;
    dev_fill_stat(h == DEV_DIR, st);
    return 0;
}

static int
dev_fstat(struct fs_mount *m, intptr_t h, int is_dir, struct fs_stat *st)
{
    (void)m;
    (void)h;
    dev_fill_stat(is_dir, st);
    return 0;
}

static int
dev_ro(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    (void)base;
    (void)rel;
    return -EPERM;                       /* devfs is immutable */
}

static int
dev_ro2(struct fs_mount *m, intptr_t base, const char *from, const char *to)
{
    (void)m;
    (void)base;
    (void)from;
    (void)to;
    return -EPERM;
}

const struct fs_backend dev_backend = {
    FS_KIND_DEV, "devfs",
    dev_open, dev_read, dev_write, dev_lseek, dev_readdir, dev_close,
    dev_exists, dev_size, dev_isdir, dev_stat, dev_fstat,
    dev_ro, dev_ro2, dev_ro, dev_ro,
};

int
devfs_mount(const char *name, uint32_t flags)
{
    /* Not FS_RO: the devices take write opens (null and zero swallow writes,
     * full fails them).  The backend itself rejects the mutating directory ops
     * (create, unlink, rename, mkdir), so the namespace is still immutable. */
    return fs_install_mount(name, FS_KIND_DEV, (intptr_t)DEV_DIR, flags);
}
