/* romfs reader: walk a packed read-only image (see romfs.h for the format).
 *
 * The image is keyed by mount index (m - fs_mounts, since fs.c passes the real
 * &fs_mounts[i]); a backend handle is a node index into the image's node table.
 * Every op is read-only. */

#include "romfs.h"
#include "fs_internal.h"

#include <string.h>
#include <errno.h>

/* Per-mount parsed image header. */
struct romfs_img {
    const uint8_t *img;
    size_t         len;
    uint32_t       nnodes;
    uint32_t       nodes_off;
    uint32_t       strs_off;
    uint32_t       data_off;
};

static struct romfs_img images[FS_MAX_MOUNTS];

/* Little-endian field readers, bounds-checked against the image length. */
static uint32_t
rd_u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8)
         | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static struct romfs_img *
img_of(struct fs_mount *m)
{
    return &images[(int)(m - fs_mounts)];
}

/* Node field accessors (a node is ROMFS_NODE_SIZE bytes at nodes_off + i*..). */
static const uint8_t *
node_ptr(struct romfs_img *r, uint32_t i)
{
    return r->img + r->nodes_off + (size_t)i * ROMFS_NODE_SIZE;
}
static uint32_t node_name(struct romfs_img *r, uint32_t i) { return rd_u32(node_ptr(r, i) + 0); }
static uint32_t node_type(struct romfs_img *r, uint32_t i) { return rd_u32(node_ptr(r, i) + 4); }
static int32_t  node_parent(struct romfs_img *r, uint32_t i){ return (int32_t)rd_u32(node_ptr(r, i) + 8); }
static uint32_t node_data(struct romfs_img *r, uint32_t i) { return rd_u32(node_ptr(r, i) + 12); }
static uint32_t node_size(struct romfs_img *r, uint32_t i) { return rd_u32(node_ptr(r, i) + 16); }

static const char *
node_name_str(struct romfs_img *r, uint32_t i)
{
    return (const char *)(r->img + r->strs_off + node_name(r, i));
}

static int
find_child(struct romfs_img *r, int dir, const char *name, int namelen)
{
    uint32_t i;
    for (i = 0; i < r->nnodes; i++) {
        if (node_parent(r, i) != dir)
            continue;
        {
            const char *nm = node_name_str(r, i);
            /* The length check makes this a full-name compare, so memcmp (in
             * the freestanding runtime) stands in for strncmp. */
            if ((int)strlen(nm) == namelen && memcmp(nm, name, (size_t)namelen) == 0)
                return (int)i;
        }
    }
    return -1;
}

/* Resolve `rel` from node `base`; "" is base itself.  Returns a node index or
 * a negative errno. */
static int
walk(struct romfs_img *r, int base, const char *rel)
{
    int cur = base;
    const char *p = rel;

    while (*p) {
        const char *start;
        int n;
        while (*p == '/')
            p++;
        if (!*p)
            break;
        start = p;
        while (*p && *p != '/')
            p++;
        n = (int)(p - start);
        if (n == 1 && start[0] == '.')
            continue;
        if (n == 2 && start[0] == '.' && start[1] == '.') {
            if (node_parent(r, (uint32_t)cur) >= 0)
                cur = node_parent(r, (uint32_t)cur);
            continue;
        }
        if (node_type(r, (uint32_t)cur) != ROMFS_T_DIR)
            return -ENOTDIR;
        cur = find_child(r, cur, start, n);
        if (cur < 0)
            return -ENOENT;
    }
    return cur;
}

static intptr_t
rom_open(struct fs_mount *m, intptr_t base, const char *rel, int flags, int mode)
{
    struct romfs_img *r = img_of(m);
    int node;
    (void)mode;

    if ((flags & FS_O_ACCMODE) != FS_O_RDONLY || (flags & FS_O_CREAT))
        return -EROFS;
    node = walk(r, (int)base, rel);
    if (node < 0)
        return node;
    if (flags & FS_O_DIRECTORY) {
        if (node_type(r, (uint32_t)node) != ROMFS_T_DIR)
            return -ENOTDIR;
        return node;
    }
    if (node_type(r, (uint32_t)node) == ROMFS_T_DIR)
        return -EISDIR;
    return node;
}

static int
rom_read(struct fs_mount *m, intptr_t h, void *buf, int n, int64_t *pos)
{
    struct romfs_img *r = img_of(m);
    uint32_t sz = node_size(r, (uint32_t)h);
    uint32_t off = r->data_off + node_data(r, (uint32_t)h);
    int64_t avail;

    if (*pos < 0 || *pos >= (int64_t)sz)
        return 0;
    avail = (int64_t)sz - *pos;             /* 64-bit: never a negative int */
    if ((int64_t)n > avail)
        n = (int)avail;
    memcpy(buf, r->img + off + (uint32_t)*pos, (size_t)n);
    *pos += n;
    return n;
}

static int
rom_write(struct fs_mount *m, intptr_t h, const void *buf, int n, int64_t *pos)
{
    (void)m; (void)h; (void)buf; (void)n; (void)pos;
    return -EROFS;
}

static int64_t
rom_lseek(struct fs_mount *m, intptr_t h, int64_t off, int whence, int64_t *pos)
{
    struct romfs_img *r = img_of(m);
    int64_t np;
    switch (whence) {
    case FS_SEEK_SET: np = off; break;
    case FS_SEEK_CUR: np = *pos + off; break;
    case FS_SEEK_END: np = (int64_t)node_size(r, (uint32_t)h) + off; break;
    default: return -EINVAL;
    }
    if (np < 0)
        return -EINVAL;
    *pos = np;
    return np;
}

static void
rom_fill_stat(struct romfs_img *r, uint32_t node, struct fs_stat *st)
{
    int isdir = node_type(r, node) == ROMFS_T_DIR;
    st->dev = 0x724D;                    /* 'rM': a constant romfs device id */
    st->ino = (uint64_t)node + 1;
    st->size = isdir ? 0 : (int64_t)node_size(r, node);
    st->mode = isdir ? (FS_S_IFDIR | 0555u) : (FS_S_IFREG | 0444u);
    st->nlink = 1;
}

static int
rom_readdir(struct fs_mount *m, intptr_t h, int64_t *cursor, struct fs_dirent *de)
{
    struct romfs_img *r = img_of(m);
    uint32_t i;
    for (i = (uint32_t)*cursor; i < r->nnodes; i++) {
        if (node_parent(r, i) != (int)h)
            continue;
        de->ino = i + 1;
        de->type = node_type(r, i) == ROMFS_T_DIR ? FS_DT_DIR : FS_DT_REG;
        de->pad[0] = de->pad[1] = de->pad[2] = 0;
        strncpy(de->name, node_name_str(r, i), FS_DIRENT_NAMEMAX - 1);
        de->name[FS_DIRENT_NAMEMAX - 1] = 0;
        *cursor = i + 1;
        return 1;
    }
    return 0;
}

static int
rom_close(struct fs_mount *m, intptr_t h, int is_dir)
{
    (void)m; (void)h; (void)is_dir;
    return 0;
}

static int
rom_exists(struct fs_mount *m, intptr_t base, const char *rel)
{
    return walk(img_of(m), (int)base, rel) >= 0 ? 1 : 0;
}

static int64_t
rom_size(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct romfs_img *r = img_of(m);
    int node = walk(r, (int)base, rel);
    if (node < 0)
        return node;
    return node_type(r, (uint32_t)node) == ROMFS_T_DIR ? 0 : (int64_t)node_size(r, (uint32_t)node);
}

static int
rom_isdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    struct romfs_img *r = img_of(m);
    int node = walk(r, (int)base, rel);
    return (node >= 0 && node_type(r, (uint32_t)node) == ROMFS_T_DIR) ? 1 : 0;
}

static int
rom_stat(struct fs_mount *m, intptr_t base, const char *rel, struct fs_stat *st)
{
    struct romfs_img *r = img_of(m);
    int node = walk(r, (int)base, rel);
    if (node < 0)
        return node;
    rom_fill_stat(r, (uint32_t)node, st);
    return 0;
}

static int
rom_fstat(struct fs_mount *m, intptr_t h, int is_dir, struct fs_stat *st)
{
    (void)is_dir;
    rom_fill_stat(img_of(m), (uint32_t)h, st);
    return 0;
}

static int
rom_ro(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m; (void)base; (void)rel;
    return -EROFS;
}

static int
rom_ro2(struct fs_mount *m, intptr_t base, const char *from, const char *to)
{
    (void)m; (void)base; (void)from; (void)to;
    return -EROFS;
}

const struct fs_backend romfs_backend = {
    FS_KIND_ROM, "romfs",
    rom_open, rom_read, rom_write, rom_lseek, rom_readdir, rom_close,
    rom_exists, rom_size, rom_isdir, rom_stat, rom_fstat,
    rom_ro, rom_ro2, rom_ro, rom_ro,
};

/* Validate an in-memory image and fill `out`.  Returns 0 or a negative errno.
 *
 * The image is untrusted: a consumer may load a guest-supplied or downloaded
 * one, so a crafted image must never make an accessor read outside the blob.
 * The header tables are bounded here, then every node is validated once (its
 * name string, type, parent index, and file data range), so the accessors
 * above, which the walk and the ops call freely, need no per-call checks.  All
 * table arithmetic is 64-bit so an offset or a count near 2^32 cannot wrap the
 * bound on an ILP32 target. */
static int
romfs_parse(const void *image, size_t len, struct romfs_img *out)
{
    const uint8_t *p = image;
    uint32_t i;

    if (len < ROMFS_HDR_SIZE || memcmp(p, ROMFS_MAGIC, 8) != 0)
        return -EINVAL;
    if (rd_u32(p + 8) != ROMFS_VERSION)
        return -EINVAL;
    out->img = p;
    out->len = len;
    out->nnodes = rd_u32(p + 12);
    out->nodes_off = rd_u32(p + 16);
    out->strs_off = rd_u32(p + 20);
    out->data_off = rd_u32(p + 24);
    /* Reject an image whose tables fall outside its own length. */
    if (out->nnodes == 0
        || (uint64_t)out->nodes_off + (uint64_t)out->nnodes * ROMFS_NODE_SIZE > len
        || out->strs_off > len || out->data_off > len)
        return -EINVAL;
    for (i = 0; i < out->nnodes; i++) {
        const uint8_t *np = p + out->nodes_off + (size_t)i * ROMFS_NODE_SIZE;
        uint32_t name = rd_u32(np + 0);
        uint32_t type = rd_u32(np + 4);
        int32_t  parent = (int32_t)rd_u32(np + 8);
        uint32_t data = rd_u32(np + 12);
        uint32_t size = rd_u32(np + 16);
        uint64_t nameoff = (uint64_t)out->strs_off + name;
        uint32_t j;
        int term = 0;

        if (type != ROMFS_T_FILE && type != ROMFS_T_DIR)
            return -EINVAL;
        if (parent < -1 || parent >= (int32_t)out->nnodes)
            return -EINVAL;                 /* keeps node_parent() in range */
        if (nameoff >= len)
            return -EINVAL;                 /* name offset past the image */
        for (j = (uint32_t)nameoff; j < len; j++)
            if (p[j] == 0) { term = 1; break; }
        if (!term)
            return -EINVAL;                 /* name string is not terminated */
        if (type == ROMFS_T_FILE
            && (uint64_t)out->data_off + data + size > len)
            return -EINVAL;                 /* file bytes fall outside the blob */
    }
    return 0;
}

int
romfs_mount(const char *name, const void *image, size_t len, uint32_t flags)
{
    struct romfs_img parsed;
    int m, rc = romfs_parse(image, len, &parsed);

    if (rc < 0)
        return rc;
    m = fs_install_mount(name, FS_KIND_ROM, (intptr_t)0, flags | FS_RO);
    if (m < 0)
        return m;
    images[m] = parsed;
    return m;
}

intptr_t
romfs_adopt(int idx, const void *image, size_t len)
{
    struct romfs_img parsed;
    int rc = romfs_parse(image, len, &parsed);

    if (rc < 0)
        return rc;
    fs_mounts[idx].flags |= FS_RO;      /* a romfs mount is always read-only */
    images[idx] = parsed;
    return 0;                           /* node 0 is the image root */
}
