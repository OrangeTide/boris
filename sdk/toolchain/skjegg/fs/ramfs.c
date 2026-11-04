/* ramfs: an in-memory, non-persistent backend.
 *
 * One shared node pool serves every ramfs mount; a mount's root is just a
 * distinct directory node.  A backend handle is a node index; the file offset
 * and the directory cursor are owned by fs.c and passed in.  File bytes are
 * heap-allocated here (hosted build); the freestanding build swaps the
 * allocator later. */

#include "ramfs.h"
#include "fs_internal.h"

#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <limits.h>

#define RAMFS_MAXNODES 256
#define RAMFS_NAMEMAX  32
#define RNODE_DETACHED (-2)                /* parent of an unlinked-but-open node */

struct rnode {
    int           used;
    int           isdir;
    int           parent;                  /* -1 for a root */
    char          name[RAMFS_NAMEMAX];
    unsigned char *data;                   /* file bytes */
    int           size;
    int           cap;
    int           nopen;                   /* open file handles on this node */
    int           unlinked;                /* removed from the tree, freed on last close */
};

static struct rnode nodes[RAMFS_MAXNODES];

static int
node_alloc(int isdir, int parent, const char *name)
{
    int i;
    for (i = 0; i < RAMFS_MAXNODES; i++) {
        if (!nodes[i].used) {
            memset(&nodes[i], 0, sizeof nodes[i]);
            nodes[i].used = 1;
            nodes[i].isdir = isdir;
            nodes[i].parent = parent;
            strncpy(nodes[i].name, name, RAMFS_NAMEMAX - 1);
            return i;
        }
    }
    return -ENOSPC;
}

static void
node_free(int i)
{
    free(nodes[i].data);
    memset(&nodes[i], 0, sizeof nodes[i]);
}

static int
find_child(int dir, const char *name)
{
    int i;
    for (i = 0; i < RAMFS_MAXNODES; i++)
        if (nodes[i].used && nodes[i].parent == dir &&
            strcmp(nodes[i].name, name) == 0)
            return i;
    return -1;
}

/* Follow an existing path from `base`; "" is `base` itself.  Returns a node
 * index or a negative errno. */
static int
walk(int base, const char *rel)
{
    int cur = base;
    const char *p = rel;
    char comp[RAMFS_NAMEMAX];

    while (*p) {
        int n = 0, c;
        while (*p == '/')
            p++;
        if (!*p)
            break;
        while (*p && *p != '/') {
            if (n < RAMFS_NAMEMAX - 1)
                comp[n++] = *p;
            p++;
        }
        comp[n] = 0;
        if (n == 0 || strcmp(comp, ".") == 0)
            continue;
        if (strcmp(comp, "..") == 0) {
            if (nodes[cur].parent >= 0)
                cur = nodes[cur].parent;
            continue;
        }
        if (!nodes[cur].isdir)
            return -ENOTDIR;
        c = find_child(cur, comp);
        if (c < 0)
            return -ENOENT;
        cur = c;
    }
    return cur;
}

/* Split `rel` into its parent directory path and final component.  Rejects an
 * empty leaf and "."/"..". */
static int
split_leaf(const char *rel, char *dir, int dircap, char *leaf)
{
    int len = (int)strlen(rel), i, ll;
    while (len > 0 && rel[len - 1] == '/')
        len--;
    if (len == 0)
        return -EINVAL;
    i = len - 1;
    while (i >= 0 && rel[i] != '/')
        i--;
    ll = len - 1 - i;
    if (ll >= RAMFS_NAMEMAX)
        return -ENAMETOOLONG;
    memcpy(leaf, rel + i + 1, ll);
    leaf[ll] = 0;
    if (i < 0)
        dir[0] = 0;
    else {
        if (i >= dircap)
            return -ENAMETOOLONG;
        memcpy(dir, rel, i);
        dir[i] = 0;
    }
    if (strcmp(leaf, ".") == 0 || strcmp(leaf, "..") == 0)
        return -EINVAL;
    return 0;
}

static int
ensure_cap(struct rnode *f, int need)
{
    int nc;
    unsigned char *nd;
    if (need <= f->cap)
        return 0;
    nc = f->cap ? f->cap : 64;
    while (nc < need) {
        if (nc > INT_MAX / 2) {         /* doubling would overflow a signed int */
            nc = need;
            break;
        }
        nc *= 2;
    }
    nd = realloc(f->data, nc);
    if (!nd)
        return -ENOMEM;
    f->data = nd;
    f->cap = nc;
    return 0;
}

static intptr_t
ram_open(struct fs_mount *m, intptr_t base, const char *rel, int flags, int mode)
{
    int node, parent;
    char dir[FS_PATH_MAX], leaf[RAMFS_NAMEMAX];
    (void)m;
    (void)mode;

    if (flags & FS_O_DIRECTORY) {
        node = walk((int)base, rel);
        if (node < 0)
            return node;
        if (!nodes[node].isdir)
            return -ENOTDIR;
        return node;
    }

    node = walk((int)base, rel);
    if (node >= 0) {
        if (nodes[node].isdir)
            return -EISDIR;
        if ((flags & FS_O_TRUNC) && (flags & FS_O_ACCMODE) != FS_O_RDONLY)
            nodes[node].size = 0;
        nodes[node].nopen++;            /* held until ram_close (unlink defers) */
        return node;
    }
    if (node != -ENOENT || !(flags & FS_O_CREAT))
        return node;

    if (split_leaf(rel, dir, sizeof dir, leaf) < 0)
        return -EINVAL;
    parent = walk((int)base, dir);
    if (parent < 0)
        return parent;
    if (!nodes[parent].isdir)
        return -ENOTDIR;
    node = node_alloc(0, parent, leaf);
    if (node >= 0)
        nodes[node].nopen++;
    return node;
}

static int
ram_read(struct fs_mount *m, intptr_t h, void *buf, int n, int64_t *pos)
{
    struct rnode *f = &nodes[h];
    int avail;
    (void)m;
    if (*pos < 0 || *pos >= f->size)
        return 0;
    avail = f->size - (int)*pos;
    if (n > avail)
        n = avail;
    memcpy(buf, f->data + *pos, n);
    *pos += n;
    return n;
}

static int
ram_write(struct fs_mount *m, intptr_t h, const void *buf, int n, int64_t *pos)
{
    struct rnode *f = &nodes[h];
    int rc;
    (void)m;
    /* The offset and length are int-width in a ramfs node; a 64-bit seek far
     * past the end would truncate to a small int and land the write inside a
     * tiny allocation.  Bound the end to INT_MAX instead. */
    if (*pos < 0 || n < 0 || *pos > (int64_t)INT_MAX - n)
        return -ENOSPC;
    rc = ensure_cap(f, (int)*pos + n);
    if (rc < 0)
        return rc;
    memcpy(f->data + *pos, buf, n);
    *pos += n;
    if ((int)*pos > f->size)
        f->size = (int)*pos;
    return n;
}

static int64_t
ram_lseek(struct fs_mount *m, intptr_t h, int64_t off, int whence, int64_t *pos)
{
    struct rnode *f = &nodes[h];
    int64_t np;
    (void)m;
    switch (whence) {
    case FS_SEEK_SET: np = off;               break;
    case FS_SEEK_CUR: np = *pos + off;        break;
    case FS_SEEK_END: np = (int64_t)f->size + off; break;
    default:          return -EINVAL;
    }
    if (np < 0)
        return -EINVAL;
    *pos = np;
    return np;
}

/* Fill the type/size/ident fields; a ramfs node has no real dev, so a fixed
 * synthetic dev plus the node index as ino gives a stable (dev, ino) pair. */
static void
ram_fill_stat(int node, struct fs_stat *st)
{
    st->dev = 0x7246;                    /* 'rF': a constant ramfs device id  */
    st->ino = (uint64_t)node + 1;
    st->size = nodes[node].isdir ? 0 : nodes[node].size;
    st->mode = nodes[node].isdir ? (FS_S_IFDIR | 0777u) : (FS_S_IFREG | 0666u);
    st->nlink = 1;
}

static int
ram_stat(struct fs_mount *m, intptr_t base, const char *rel, struct fs_stat *st)
{
    int node = walk((int)base, rel);
    (void)m;
    if (node < 0)
        return node;
    ram_fill_stat(node, st);
    return 0;
}

static int
ram_fstat(struct fs_mount *m, intptr_t h, int is_dir, struct fs_stat *st)
{
    (void)m;
    (void)is_dir;
    ram_fill_stat((int)h, st);
    return 0;
}

static int
ram_readdir(struct fs_mount *m, intptr_t h, int64_t *cursor, struct fs_dirent *de)
{
    int i;
    (void)m;
    for (i = (int)*cursor; i < RAMFS_MAXNODES; i++) {
        if (nodes[i].used && nodes[i].parent == (int)h) {
            de->ino = (uint32_t)i;
            de->type = nodes[i].isdir ? FS_DT_DIR : FS_DT_REG;
            de->pad[0] = de->pad[1] = de->pad[2] = 0;
            strncpy(de->name, nodes[i].name, FS_DIRENT_NAMEMAX - 1);
            de->name[FS_DIRENT_NAMEMAX - 1] = 0;
            *cursor = i + 1;
            return 1;
        }
    }
    return 0;
}

static int
ram_close(struct fs_mount *m, intptr_t h, int is_dir)
{
    (void)m;
    if (!is_dir) {                   /* a file handle holds an open reference */
        struct rnode *f = &nodes[h];
        if (f->nopen > 0)
            f->nopen--;
        if (f->nopen == 0 && f->unlinked)
            node_free((int)h);       /* last close of an unlinked file frees it */
    }
    return 0;                        /* a live node lives on in the tree */
}

static int
ram_exists(struct fs_mount *m, intptr_t base, const char *rel)
{
    (void)m;
    return walk((int)base, rel) >= 0 ? 1 : 0;
}

static int64_t
ram_size(struct fs_mount *m, intptr_t base, const char *rel)
{
    int node = walk((int)base, rel);
    (void)m;
    if (node < 0)
        return node;
    return nodes[node].isdir ? 0 : nodes[node].size;
}

static int
ram_isdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    int node = walk((int)base, rel);
    (void)m;
    return (node >= 0 && nodes[node].isdir) ? 1 : 0;
}

static int
ram_unlink(struct fs_mount *m, intptr_t base, const char *rel)
{
    int parent, child;
    char dir[FS_PATH_MAX], leaf[RAMFS_NAMEMAX];
    (void)m;
    if (split_leaf(rel, dir, sizeof dir, leaf) < 0)
        return -EINVAL;
    parent = walk((int)base, dir);
    if (parent < 0)
        return parent;
    child = find_child(parent, leaf);
    if (child < 0)
        return -ENOENT;
    if (nodes[child].isdir)
        return -EISDIR;
    /* Unlink detaches the node from the tree now, but a still-open handle keeps
     * the bytes alive until its last close.  Freeing the slot here while an fd
     * holds its index would let a later create reuse the slot and alias the two
     * files (the write then lands in the wrong node). */
    if (nodes[child].nopen > 0) {
        nodes[child].unlinked = 1;
        nodes[child].parent = RNODE_DETACHED;   /* out of every name lookup */
    } else {
        node_free(child);
    }
    return 0;
}

static int
ram_mkdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    int parent;
    char dir[FS_PATH_MAX], leaf[RAMFS_NAMEMAX];
    (void)m;
    if (split_leaf(rel, dir, sizeof dir, leaf) < 0)
        return -EINVAL;
    parent = walk((int)base, dir);
    if (parent < 0)
        return parent;
    if (!nodes[parent].isdir)
        return -ENOTDIR;
    if (find_child(parent, leaf) >= 0)
        return -EEXIST;
    return node_alloc(1, parent, leaf) < 0 ? -ENOSPC : 0;
}

static int
ram_rmdir(struct fs_mount *m, intptr_t base, const char *rel)
{
    int node, i;
    (void)m;
    node = walk((int)base, rel);
    if (node < 0)
        return node;
    if (!nodes[node].isdir)
        return -ENOTDIR;
    for (i = 0; i < RAMFS_MAXNODES; i++)
        if (nodes[i].used && nodes[i].parent == node)
            return -ENOTEMPTY;
    node_free(node);
    return 0;
}

static int
ram_rename(struct fs_mount *m, intptr_t base, const char *from, const char *to)
{
    int src, parent;
    char dir[FS_PATH_MAX], leaf[RAMFS_NAMEMAX];
    (void)m;
    src = walk((int)base, from);
    if (src < 0)
        return src;
    if (split_leaf(to, dir, sizeof dir, leaf) < 0)
        return -EINVAL;
    parent = walk((int)base, dir);
    if (parent < 0)
        return parent;
    if (!nodes[parent].isdir)
        return -ENOTDIR;
    /* Refuse moving a directory into itself or its own subtree: it would make
     * the node its own ancestor, detaching the subtree and creating a cycle
     * that walk / rmdir would loop on.  Walk the target's parent chain to the
     * root; hitting src means the target is inside src. */
    if (nodes[src].isdir) {
        int a = parent;
        while (a >= 0) {
            if (a == src)
                return -EINVAL;
            a = nodes[a].parent;
        }
    }
    if (find_child(parent, leaf) >= 0)
        return -EEXIST;
    nodes[src].parent = parent;
    memcpy(nodes[src].name, leaf, strlen(leaf) + 1);   /* leaf < RAMFS_NAMEMAX */
    return 0;
}

const struct fs_backend ramfs_backend = {
    FS_KIND_RAM, "ramfs",
    ram_open, ram_read, ram_write, ram_lseek, ram_readdir, ram_close,
    ram_exists, ram_size, ram_isdir, ram_stat, ram_fstat,
    ram_unlink, ram_rename, ram_mkdir, ram_rmdir,
};

int
ramfs_mount(const char *name, uint32_t flags)
{
    int root = node_alloc(1, -1, "");
    if (root < 0)
        return root;
    return fs_install_mount(name, FS_KIND_RAM, (intptr_t)root, flags);
}
