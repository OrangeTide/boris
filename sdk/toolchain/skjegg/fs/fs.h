/* fs/ - the shared file system switch for the sandbox runtime.
 *
 * A flat mount table of named, independent namespaces with a selected current
 * one.  This is NOT a VFS: there are no subdirectory mounts, no mount-point
 * crossing, and no union, so a path never spans two backends.  It is the old
 * "file system switch" idea: file operations dispatched to a pluggable backend
 * chosen through the mount table.
 *
 * The layer is language-agnostic.  C and Kobold (and every other front end)
 * share one sandbox seam: identical interfaces, data structures, and system
 * calls.  Everything here is plain C.  The C libc file path and the Kobold
 * runtime file path are both thin adapters that convert their own string type
 * to these calls; neither owns this layer.
 *
 * Paths select a mount by a `name:` prefix (name is at most FS_NAME_MAX bytes),
 * or, with no prefix, resolve against the current mount.  Within a mount the
 * grammar follows DOS drive letters:
 *     name:/sub  mount `name`, from its root
 *     name:sub   mount `name`, from that mount's current directory
 *     /sub       current mount, from its root
 *     sub        current mount, from its current directory
 */

#ifndef FS_H
#define FS_H

#include <stdint.h>

#define FS_NAME_MAX    8     /* mount name: fixed field, NUL-padded          */
#define FS_MAX_MOUNTS  16    /* mount-table capacity                         */
#define FS_MAX_FDS     64    /* open fd capacity (files, dirs, mount roots)  */
#define FS_FD_BASE     3     /* fs fds start here; 0/1/2 are the console     */
#define FS_PATH_MAX    256   /* longest path the resolver handles           */

/* fs_open flags (a small POSIX-like subset, backend-translated).  The low two
 * bits are the access mode.  FS_O_DIRECTORY opens a directory as an fd, exactly
 * as BSD/Linux do: the resulting fd is read with fs_read to yield fixed
 * fs_dirent records.  There is no separate "opendir"; a language's
 * opendir/readdir/closedir is a thin wrapper over fs_open/fs_read/fs_close. */
/* The flag bits are the Linux/asm-generic O_* bit positions (so a host-side
 * backend passes them straight to openat); keep the shift counts, which name
 * those positions, rather than renumbering to sequential bits. */
enum {
    FS_O_RDONLY = 0,
    FS_O_WRONLY = 1,
    FS_O_RDWR   = 2,
    FS_O_ACCMODE = 3,
    FS_O_CREAT  = 1 << 6,    /* 0x00040 */
    FS_O_TRUNC  = 1 << 9,    /* 0x00200 */
    FS_O_APPEND = 1 << 10,   /* 0x00400 */
    FS_O_DIRECTORY = 1 << 16, /* 0x10000 */
};

/* Directory entry type. */
enum {
    FS_DT_UNKNOWN = 0,
    FS_DT_REG,
    FS_DT_DIR,
};

/* fs_lseek whence, the POSIX values a front end passes straight through. */
enum {
    FS_SEEK_SET = 0,
    FS_SEEK_CUR = 1,
    FS_SEEK_END = 2,
};

/* A directory read returns a whole number of these.  Fixed 64 bytes so a
 * reader steps the buffer by sizeof(struct fs_dirent); the shared structure is
 * the same for every front end.  `name` is NUL-terminated. */
#define FS_DIRENT_NAMEMAX 56
struct fs_dirent {
    uint32_t ino;                        /* backend id, informational       */
    uint8_t  type;                       /* FS_DT_*                          */
    uint8_t  pad[3];
    char     name[FS_DIRENT_NAMEMAX];
};

/* File-type bits in fs_stat.mode, the POSIX st_mode encoding so a front end
 * copies mode straight into its own struct stat.  Only the two types the
 * backends distinguish are named; the low bits carry the permission mode. */
#define FS_S_IFMT  0170000u
#define FS_S_IFREG 0100000u
#define FS_S_IFDIR 0040000u
#define FS_S_IFCHR 0020000u

/* The metadata fs_stat / fs_fstat report.  A fixed, front-end-neutral subset of
 * POSIX stat: enough for the type and size checks and for matching an object
 * reached two ways (dev + ino).  A backend fills what it has and zeroes the
 * rest. */
struct fs_stat {
    uint64_t dev;
    uint64_t ino;
    int64_t  size;
    uint32_t mode;                       /* FS_S_IF* | permission bits        */
    uint32_t nlink;
};

/* fs_mount.flags bits.  The low byte carries the backend kind; FS_RO and other
 * attributes ride the high bits.  Keeping the kind in flags keeps the entry at
 * 16 bytes with no extra field. */
enum {
    FS_KIND_MASK = 0x00ffu,  /* backend kind, an enum fs_kind value          */
    FS_RO        = 0x0100u,  /* mount is read-only; mutating ops return -EROFS */
    FS_RAWPATH   = 0x0200u,  /* pass the selector-stripped path to the backend
                              * verbatim (no root/cwd anchoring, no leading-'/'
                              * strip): the backend anchors it itself.  The
                              * temporary ambient host mount uses this so a guest
                              * path reaches openat(AT_FDCWD, path) exactly as it
                              * did before the fs/ layer, absolute '/' included. */
};

enum fs_kind {
    FS_KIND_NONE = 0,        /* empty slot                                   */
    FS_KIND_RAM,             /* ramfs: in-memory, non-persistent             */
    FS_KIND_HOST,            /* hostfs: real host tree, strict confinement   */
    FS_KIND_ROM,             /* romfs: read-only packed image (later)        */
    FS_KIND_9P,              /* 9pfs: served over the launcher channel (later) */
    FS_KIND_DEV,             /* devfs: null/zero/console/random (later)      */
};

/* A mount-table entry.  Exactly 16 bytes, no padding.  The launcher populates
 * the table in guest memory before the program runs (it opens the capability
 * fds and fills these in); the guest never mounts.  `fd` is the mount's root
 * capability; `cwd` is this mount's current directory (DOS keeps one per
 * drive).  An all-zero name with fd == -1 is an empty slot.  Unmounting is just
 * closing `fd` and zeroing the entry. */
struct fs_mount {
    char     name[FS_NAME_MAX];  /* NUL-padded; all-zero == empty slot       */
    int16_t  fd;                 /* root capability fd; -1 == empty          */
    int16_t  cwd;                /* current-directory fd; -1 == use the root */
    uint32_t flags;              /* FS_KIND_* in the low byte, FS_RO, ...     */
};

/* The well-known globals the launcher fills (by resolving these guest-ELF
 * symbols on the VM, or by the hosted startup code from flags/env).  The table
 * and the current-mount index are the whole persistent namespace state. */
extern struct fs_mount fs_mounts[FS_MAX_MOUNTS];
extern int             fs_mount_count;   /* entries in use at the low end     */
extern int             fs_cur_mount;     /* the current/default mount index   */

/* Per-mount parameters a backend root needs but the 16-byte fs_mount entry
 * cannot hold.  The launcher resolves this symbol and fills it before the guest
 * runs; fs_init reads it during adoption.  Meaning is per backend kind: romfs
 * uses p0 = the image's guest address, p1 = its length; 9pfs uses p0 = the
 * guest address of its transport channel.  Unused for ram/host/dev.  The two
 * words are guest addresses, so ILP32 on the freestanding guest tiers. */
struct fs_mount_aux {
    uint32_t p0;
    uint32_t p1;
};
extern struct fs_mount_aux fs_mount_aux[FS_MAX_MOUNTS];

/* Inherited descriptors handed to a spawned child.  The launcher writes this
 * fixed-layout table (two ints per entry, so the host marshals it without the
 * private fd_slot layout) before the child runs; fs_init installs each as an
 * fd-space slot.  `gfd` is the index into the child's own capability table that
 * backs the fd (the host dup'd the resource into the child).  An inherited fd
 * is always a stream the child owns: this is how a redirected stream or a pipe
 * end reaches a child, since there is no fork/dup2. */
struct fs_inherit_fd {
    int dst;                    /* fd id the child should see it as             */
    int gfd;                    /* the child's capability index backing it      */
};
extern struct fs_inherit_fd fs_inherit_fds[FS_MAX_FDS];
extern int                   fs_inherit_n;

/* A backend's operation table: one shared instance per backend kind.
 *
 * fs.c owns the one shared fd space and all per-fd state; a backend handle is
 * an opaque value the backend alone understands (ramfs uses a node index, host
 * uses a host fd or DIR*).  Path ops receive `base`, the backend handle of the
 * directory to resolve against (fs.c has already picked root vs cwd per the DOS
 * grammar and stripped the `name:` selector and any leading '/', so `rel` is a
 * backend-relative path, "" meaning the base directory itself).  Confinement to
 * the mount is the backend's job (hostfs: host openat + RESOLVE_BENEATH; ramfs:
 * it only has its own nodes).  `open` returns a backend handle (fs.c wraps it in
 * an fd); FS_O_DIRECTORY opens a directory handle, which `readdir` then walks.
 * `read`/`write`/`readdir` get a pointer to the fd's position/cursor that fs.c
 * stores, so a backend that tracks its own offset (host, via the kernel fd or
 * DIR*) may ignore it.  `close` gets an is_dir hint so a backend that uses a
 * distinct directory handle (hostfs's DIR*) frees the right thing.
 *
 * Returns follow the kpf_* convention: >= 0 on success (a handle, a byte count,
 * or a boolean), negative errno-style on failure.  Byte counts are bounded by
 * sandbox buffer sizes, so `int` is sufficient; a file size is 64-bit. */
struct fs_backend {
    enum fs_kind kind;
    const char  *name;           /* "ramfs", "hostfs", ...                   */

    intptr_t (*open)(struct fs_mount *m, intptr_t base, const char *rel,
                     int flags, int mode);
    int      (*read)(struct fs_mount *m, intptr_t h, void *buf, int n,
                     int64_t *pos);
    int      (*write)(struct fs_mount *m, intptr_t h, const void *buf, int n,
                      int64_t *pos);
    int64_t  (*lseek)(struct fs_mount *m, intptr_t h, int64_t off, int whence,
                      int64_t *pos);   /* new absolute offset, or <0 errno    */
    int      (*readdir)(struct fs_mount *m, intptr_t h, int64_t *cursor,
                        struct fs_dirent *de);   /* 1 filled, 0 end, <0 err  */
    int      (*close)(struct fs_mount *m, intptr_t h, int is_dir);

    int      (*exists)(struct fs_mount *m, intptr_t base, const char *rel);
    int64_t  (*size)(struct fs_mount *m, intptr_t base, const char *rel);
    int      (*isdir)(struct fs_mount *m, intptr_t base, const char *rel);
    int      (*stat)(struct fs_mount *m, intptr_t base, const char *rel,
                     struct fs_stat *st);
    int      (*fstat)(struct fs_mount *m, intptr_t h, int is_dir,
                      struct fs_stat *st);
    int      (*unlink)(struct fs_mount *m, intptr_t base, const char *rel);
    int      (*rename)(struct fs_mount *m, intptr_t base, const char *from,
                       const char *to);
    int      (*mkdir)(struct fs_mount *m, intptr_t base, const char *rel);
    int      (*rmdir)(struct fs_mount *m, intptr_t base, const char *rel);
};

/* Front API.  A path is resolved to a mount, the selector stripped, and the
 * call dispatched to that mount's backend.  fs_open allocates an fd in the one
 * shared fd space (files, directories, and mount roots all live there; 0/1/2
 * are pre-reserved by convention for the console and are not fs-managed), and
 * the other fd-taking calls take an fs fd.  Open flags/mode mirror the POSIX
 * subset the backends need.
 *
 * A directory is opened with FS_O_DIRECTORY and iterated by fs_read, which on a
 * directory fd returns a whole number of `struct fs_dirent` records (0 at the
 * end).  There is no opendir/readdir/closedir in this layer; each front end
 * provides that as a thin wrapper over fs_open/fs_read/fs_close. */
int     fs_open(const char *path, int flags, int mode);
int     fs_read(int fd, void *buf, int n);
int     fs_write(int fd, const void *buf, int n);
int64_t fs_lseek(int fd, int64_t off, int whence);
int     fs_close(int fd);

/* Adopt a host capability index (a pipe end the SKJ_SYS_PIPE host call handed
 * back) as a pipe fd-space slot; returns the fd or a negative errno.  The slot
 * reads/writes the raw host fd and closes it on fs_close. */
int     fs_adopt_pipe(int gfd);

/* Report the capability index backing a console or pipe fd, for building a
 * spawn fd map.  Returns 0 and sets `*gfd`, or a negative errno if fd is not a
 * passable (host-backed) descriptor. */
int     fs_fd_backing(int fd, int *gfd);

int     fs_exists(const char *path);
int64_t fs_size(const char *path);
int     fs_isdir(const char *path);
int     fs_stat(const char *path, struct fs_stat *st);
int     fs_fstat(int fd, struct fs_stat *st);
int     fs_unlink(const char *path);
int     fs_rename(const char *from, const char *to);
int     fs_mkdir(const char *path);
int     fs_rmdir(const char *path);

/* Namespace control (runtime functions, never a path trick).  The DOS model:
 * fs_mount_set is _chdrive (change the current mount only), fs_chdir is CD
 * (move one mount's current directory without changing the current mount). */
int     fs_mount_set(int index);               /* set fs_cur_mount           */
int     fs_mount_current(void);                /* read fs_cur_mount          */
int     fs_mount_find(const char *name);       /* name -> index, or -1       */
int     fs_chdir(const char *path);            /* move the resolved mount cwd */
int     fs_getcwd(int index, char *buf, int cap);

/* Startup default policy.  Runs once (idempotent).  The default landing spot is
 * a safe empty scratch ramfs, which the current mount points at, so a bare path
 * stays in RAM and the host is reachable only through a mount that grants it:
 *   - launcher --mount table: adopt the capability grants, then add scratch and
 *     land on it (host access is capability-only and confined);
 *   - no table: install scratch alone and land on it.
 * FS_AMBIENT_DEFAULT is a documented, temporary override (needs FS_WITH_AMBIENT)
 * that instead lands on an unconfined ambient host mount so a bare path reaches
 * the host cwd as it did before this layer; it is for the test harnesses that
 * run an fs/-interpose guest under bare qemu, which cannot be handed a --mount.
 * The hosted fs_test installs its own mounts and does not reach this. */
void    fs_init(void);

#endif /* FS_H */
