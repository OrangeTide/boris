/* fdio.c: the fd primitives that route a path and an fd through the shared fs/
   layer.  Built only when the fs/ interposition is selected (SKJ_FS_INTERPOSE,
   the freestanding VM tiers rv and cf); otherwise this file is empty and the
   raw crt wrappers (runtime/syscall_*.S) stand.

   The crt wrappers are weak, so these strong definitions override open / read /
   write / lseek / close for a program linked against this libc.  Every fd lives
   in the one fs/ fd space, including 0/1/2: fs_init binds them to the sandbox's
   own stdin/out/err as ordinary stream slots, so every op routes through fs_*
   and they can be rebound or passed to a child like any other fd.  Each op
   installs the default mount policy (fs_init) on first use. */

#ifdef SKJ_FS_INTERPOSE

#include "fs.h"
#include <fcntl.h>

static int fs_ready;

static void
ensure_fs(void)
{
    if (!fs_ready) {
        fs_ready = 1;
        fs_init();
    }
}

static int
to_fsflags(int f)
{
    int r;
    switch (f & 3) {                    /* access mode: O_RDONLY/WRONLY/RDWR */
    case O_WRONLY: r = FS_O_WRONLY; break;
    case O_RDWR:   r = FS_O_RDWR;   break;
    default:       r = FS_O_RDONLY; break;
    }
    if (f & O_CREAT)
        r |= FS_O_CREAT;
    if (f & O_TRUNC)
        r |= FS_O_TRUNC;
    if (f & O_APPEND)
        r |= FS_O_APPEND;
    return r;
}

int
open(const char *path, int flags, int mode)
{
    ensure_fs();
    return fs_open(path, to_fsflags(flags), mode);
}

int
read(int fd, void *buf, int n)
{
    ensure_fs();
    return fs_read(fd, buf, n);
}

int
write(int fd, const void *buf, int n)
{
    ensure_fs();
    return fs_write(fd, buf, n);
}

long
lseek(int fd, long off, int whence)
{
    ensure_fs();
    return (long)fs_lseek(fd, off, whence);
}

int
close(int fd)
{
    ensure_fs();
    return fs_close(fd);
}

/* SKJ_SYS_PIPE: the host creates a host pipe and hands back the two capability
 * indices backing its read and write ends.  pipe() adopts each as an fs pipe
 * fd, so the ends live in the one fd space and can be passed to a child. */
int skj_pipe(unsigned *ends);

int
pipe(int fd[2])
{
    unsigned ends[2];
    int r, w;

    ensure_fs();
    if (skj_pipe(ends) != 0)
        return -1;
    r = fs_adopt_pipe((int)ends[0]);
    if (r < 0)
        return -1;
    w = fs_adopt_pipe((int)ends[1]);
    if (w < 0) {
        fs_close(r);
        return -1;
    }
    fd[0] = r;
    fd[1] = w;
    return 0;
}

#endif /* SKJ_FS_INTERPOSE */
