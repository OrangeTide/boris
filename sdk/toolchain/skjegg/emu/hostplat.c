/* hostplat.c : the per-host-OS implementation of the facilities skj-run needs
 * to service its fixed guest ABI.  This is the ONLY emulator file that branches
 * on the host operating system; guest.c and the rest of the syscall layer stay
 * host-agnostic.  The guest never sees any of this: it meets one fixed ABI
 * (see hostplat.h) whatever OS skj-run runs on. */

#if defined(__APPLE__)
# define _DARWIN_C_SOURCE               /* full Darwin API: syscall(), the *at
                                         * calls, fdopendir, ...                  */
#else
# define _GNU_SOURCE                    /* openat2 / O_PATH / RESOLVE_BENEATH     */
# define _POSIX_C_SOURCE 200809L
# define _DEFAULT_SOURCE
#endif

#include "hostplat.h"

#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <dirent.h>
#include <time.h>
#if defined(__linux__)
# include <sys/syscall.h>               /* SYS_openat2 */
#endif

/* ---- confined open beneath a capability directory fd ----------------------
 *
 * cap_walk, below, is the confinement primitive: a pure-POSIX component walk
 * that every host uses.  Linux keeps one accelerator over it, openat2 with
 * RESOLVE_BENEATH, which enforces the same confinement inside the kernel,
 * atomically and without the walk's narrow rename-race window.  That is the
 * sole host #if here; nothing else needs a non-POSIX call.  A host with neither
 * (an openat that cannot confine) would fail closed rather than leak, but every
 * POSIX host has the walk, so the floor is universal.
 *
 * HP_FORCE_POSIX (a build knob, -DHP_FORCE_POSIX) selects cap_walk even on
 * Linux, so CI compiles and exercises the portable path on the one host where
 * openat2 would otherwise hide it. */
#if defined(__linux__) && !defined(HP_FORCE_POSIX)
# define HP_USE_OPENAT2 1
#else
# define HP_USE_OPENAT2 0
#endif

#if HP_USE_OPENAT2
# ifndef SYS_openat2
#  define SYS_openat2 437               /* synchronized across modern Linux arches */
# endif
# define GUEST_RESOLVE_BENEATH       0x08u
# define GUEST_RESOLVE_NO_MAGICLINKS 0x02u
struct open_how_abi {                   /* the kernel open_how, pinned to the ABI */
    uint64_t flags;
    uint64_t mode;
    uint64_t resolve;
};
#endif /* HP_USE_OPENAT2 */

/* O_PATH (a fd for *at / fstat without read access) is a Linux/FreeBSD flag;
 * where it is missing (macOS) a plain readable open serves. */
#if defined(O_PATH)
# define HP_O_PATH O_PATH
#else
# define HP_O_PATH O_RDONLY
#endif

#if !HP_USE_OPENAT2
/* The portable confinement primitive: descend `path` one component at a time
 * from `dirfd`, each opened O_NOFOLLOW so no component can be a symlink that
 * redirects out, rejecting an absolute path or any ".." lexically (never
 * openat("..") - that would open the real parent, outside the grant).  The
 * final component is opened with the caller's flags plus O_NOFOLLOW.  Stricter
 * than Linux RESOLVE_BENEATH (it refuses in-tree symlinks and any ".." rather
 * than collapsing those that stay beneath), but it never leaks, which is what a
 * confined dev backend needs.  `dirfd` is borrowed; intermediates are closed as
 * the walk advances.  Returns a host fd (>= 0) or -1 with errno set. */
static int
cap_walk(int dirfd, const char *path, int oflags, mode_t mode)
{
    int dir = dirfd, own = 0;
    const char *p = path;
    char comp[256];

    if (path[0] == '/') {
        errno = EACCES;
        return -1;
    }
    for (;;) {
        const char *s;
        int len;

        while (*p == '/')
            p++;
        if (*p == '\0') {               /* empty / trailing slash: the dir itself */
            int fd = openat(dir, ".", oflags | O_NOFOLLOW, mode);
            if (own)
                close(dir);
            return fd;
        }
        s = p;
        while (*p && *p != '/')
            p++;
        len = (int)(p - s);
        if (len == 2 && s[0] == '.' && s[1] == '.') {
            if (own)
                close(dir);
            errno = EACCES;
            return -1;
        }
        if (len >= (int)sizeof comp) {
            if (own)
                close(dir);
            errno = ENAMETOOLONG;
            return -1;
        }
        memcpy(comp, s, (size_t)len);
        comp[len] = '\0';
        if (*p == '\0') {               /* final component: the caller's open */
            int fd = openat(dir, comp, oflags | O_NOFOLLOW, mode);
            if (own)
                close(dir);
            return fd;
        }
        {                               /* intermediate: a non-symlink directory */
            int nd = openat(dir, comp,
                            O_RDONLY | O_DIRECTORY | O_NOFOLLOW | O_CLOEXEC);
            if (own)
                close(dir);
            if (nd < 0)
                return -1;
            dir = nd;
            own = 1;
        }
    }
}
#endif

/* Open `path` beneath `dirfd`, confined to it.  Returns a host fd (>= 0) or -1. */
static int
open_beneath(int dirfd, const char *path, int oflags, mode_t mode)
{
#if HP_USE_OPENAT2
    struct open_how_abi how;
    long fd;

    memset(&how, 0, sizeof how);
    how.flags = (uint64_t)(unsigned)oflags;
    how.mode = (oflags & O_CREAT) ? (uint64_t)mode : 0u;
    how.resolve = GUEST_RESOLVE_BENEATH | GUEST_RESOLVE_NO_MAGICLINKS;
    fd = syscall(SYS_openat2, dirfd, path, &how, sizeof how);
    return (int)fd;
#else                                   /* every other host: the portable walk */
    return cap_walk(dirfd, path, oflags, mode);
#endif
}

int
hp_open_beneath(int dirfd, const char *path, int flags, int mode)
{
    return open_beneath(dirfd, path, flags, (mode_t)mode);
}

int
hp_stat_beneath(int dirfd, const char *path, struct stat *st)
{
    int fd = open_beneath(dirfd, path, HP_O_PATH, 0);
    int rc;

    if (fd < 0)
        return -1;
    rc = fstat(fd, st);
    close(fd);
    return rc;
}

int
hp_parent_beneath(int dirfd, char *path, const char **base)
{
    char *slash = strrchr(path, '/');
    const char *dir;

    if (slash == path) {                /* "/x": absolute; the open will reject */
        dir = "/";
        *base = path + 1;
    } else if (slash) {
        *slash = '\0';
        dir = path;
        *base = slash + 1;
    } else {                            /* "x": parent is the mount root itself */
        dir = ".";
        *base = path;
    }
    if ((*base)[0] == '\0')             /* trailing slash: no final component */
        return -1;
    return open_beneath(dirfd, dir, HP_O_PATH | O_DIRECTORY, 0);
}

/* ---- directory enumeration ------------------------------------------------
 * readdir/telldir/seekdir are POSIX, so one implementation serves every host;
 * hp_dir is just a DIR* behind an opaque pointer. */

hp_dir *
hp_diropen(int dirfd)
{
    int fd = dup(dirfd);                /* a private fd so closedir keeps dirfd */
    DIR *d;

    if (fd < 0)
        return 0;
    d = fdopendir(fd);
    if (!d) {
        close(fd);
        return 0;
    }
    return (hp_dir *)d;
}

int
hp_dirnext(hp_dir *h, uint64_t *ino, unsigned *type, const char **name)
{
    struct dirent *e = readdir((DIR *)h);

    if (!e)
        return 0;                       /* end of directory (NULL is also error) */
    *ino = (uint64_t)e->d_ino;
    *type = (unsigned)e->d_type;        /* Linux and BSD share the DT_* values */
    *name = e->d_name;
    return 1;
}

long
hp_dirtell(hp_dir *h)
{
    return telldir((DIR *)h);
}

void
hp_dirseek(hp_dir *h, long cookie)
{
    seekdir((DIR *)h, cookie);
}

void
hp_dirclose(hp_dir *h)
{
    closedir((DIR *)h);
}

/* ---- clock / sleep / random ----------------------------------------------- */

int
hp_clock(int realtime, uint32_t *sec, uint32_t *nsec)
{
    struct timespec ts;

    if (clock_gettime(realtime ? CLOCK_REALTIME : CLOCK_MONOTONIC, &ts) != 0)
        return -1;
    *sec = (uint32_t)ts.tv_sec;         /* the guest's 32-bit timespec seam */
    *nsec = (uint32_t)ts.tv_nsec;
    return 0;
}

int
hp_sleep(uint32_t sec, uint32_t nsec)
{
    struct timespec req;

    req.tv_sec = (time_t)sec;
    req.tv_nsec = (long)nsec;
    while (nanosleep(&req, &req) != 0) {
        if (errno != EINTR)
            return -1;                  /* resume only across a host signal */
    }
    return 0;
}

/* sched_yield is POSIX, but <sched.h> is shadowed by the emulator's own
 * scheduler header on the -Iemu include path, so declare the prototype here
 * rather than include it. */
extern int sched_yield(void);

void
hp_yield(void)
{
    sched_yield();
}

/* Random bytes come from /dev/urandom: a plain open and read, so one pure-POSIX
 * path serves every host.  getrandom (Linux) and getentropy (macOS/BSD) would
 * each be a separate non-POSIX call for no gain here; the device is the kernel
 * CSPRNG on Linux, macOS and the BSDs alike.  Returns the count filled, or -1
 * if nothing could be read. */
int
hp_random(void *buf, int len)
{
    unsigned char *p = buf;
    int done = 0, fd;

    if (len <= 0)
        return 0;
    fd = open("/dev/urandom", O_RDONLY | O_CLOEXEC);
    if (fd < 0)
        return -1;
    while (done < len) {
        ssize_t n = read(fd, p + done, (size_t)(len - done));
        if (n > 0)
            done += (int)n;
        else if (n < 0 && errno == EINTR)
            continue;
        else
            break;                      /* error, or an unexpected end of device */
    }
    close(fd);
    return done > 0 ? done : -1;
}
