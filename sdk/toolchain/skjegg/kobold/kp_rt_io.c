/* kp_rt_io.c : the hosted Kobold runtime surface (see kp_rt_io.h).

   One source for the file, directory, file-string, and debug/test entry points
   the stdlib units call by name, shared by the two hosted tiers that used to
   carry byte-identical copies: the AOT start file (aot_rt.c) and the in-process
   JIT driver (jit_main.c). It is compiled once per tier with that tier's
   toolchain.

   The `files` and `dirs` unit fd/directory primitives (kpf_* and kpd_*) route
   through the shared fs/ layer, the same directory and file model
   (fs_open/fs_read/fs_dirent, FS_O_DIRECTORY iterated as records) the sandbox
   runtime uses, so a hosted Kobold program lives on that abstraction rather
   than exposing the host platform directly.  The hosted build links fs/ with a
   hostfs mount rooted at "/" whose current directory tracks the process cwd, so
   an absolute or a cwd-relative path resolves exactly as it did, while the fd
   model is the shared one.  The freestanding tier (io_free.c) routes the same
   names through the fs-interpose wrappers over the raw syscall seam, so every
   tier now sits on the one fs/ abstraction.

   ReadFileStr/WriteFileStr stay on the whole-file host helpers (kp_read_file /
   kp_write_file): their guest-heap versus host-malloc allocation model is a
   deliberate seam, not part of the fd/directory unification.

   The freestanding tier (io_free.c) is deliberately not folded in here: it
   allocates its read buffer from the guest heap and walks directories over the
   fs-interpose seam with no malloc, so its bodies differ rather than merely
   resolving different leaf calls. */

#if !defined(_DARWIN_C_SOURCE)
#define _DEFAULT_SOURCE
#endif

#include "kp_rt_io.h"
#include "str.h"
#include "fs.h"
#include "hostfs.h"

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

/* From kobold/kp_host.c (JIT) or its AOT twin: whole-file read/write. */
char *kp_read_file(const char *path, size_t *lenp);
int kp_write_file(const char *path, const char *data, size_t len);

kp_gptr ReadFileStr(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    char *buf;
    size_t n = 0;
    kp_gptr s;

    if (plen < 0 || plen >= (int)sizeof(path))
        return kp_str_new("", 0);
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    buf = kp_read_file(path, &n);
    s = kp_str_new(buf ? buf : "", (int)n);
    free(buf);
    return s;
}

/* WriteFileStr(path, data): write a guest string to a host file named by another
   guest string, returning 1 on success and 0 on failure.  The front end's `-o`
   uses it to write the KPM1 module without a shell redirect. */
int WriteFileStr(kp_gptr pathstr, kp_gptr datastr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);

    if (plen < 0 || plen >= (int)sizeof(path))
        return 0;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kp_write_file(path, kp_str_bytes(datastr), (size_t)kp_str_len(datastr));
}

/* The hosted tiers reach the host through the shared fs/ layer, not the raw
   platform.  A hostfs mount rooted at "/" is the current mount, and its current
   directory is set to the process cwd once, so an absolute path resolves from
   "/" and a cwd-relative path from the process working directory, exactly as a
   native open did, while the fd and directory model is the one the sandbox
   uses. */
static void
kp_fs_ensure(void)
{
    static int done;
    char cwd[FS_PATH_MAX];
    int idx;

    if (done)
        return;
    done = 1;
    idx = hostfs_mount("host", "/", 0);
    if (idx < 0)
        return;
    fs_mount_set(idx);
    if (getcwd(cwd, sizeof cwd))
        fs_chdir(cwd);
}

/* A console fd (0/1/2) is not fs-managed: a unit may open it directly
   (OpenReader(r, 0)) and hand it to kpf_read/kpf_write, so those descriptors go
   to the raw seam, as in libc/fdio.c and io_free.c. */
static int  kpio_open(const char *p, int f)           { kp_fs_ensure(); return fs_open(p, f, 0644); }
static long kpio_read(int fd, void *b, long n)        { return fd < FS_FD_BASE ? read(fd, b, (size_t)n)  : fs_read(fd, b, (int)n); }
static long kpio_write(int fd, const void *b, long n) { return fd < FS_FD_BASE ? write(fd, b, (size_t)n) : fs_write(fd, b, (int)n); }
static void kpio_close(int fd)                        { if (fd >= FS_FD_BASE) fs_close(fd); else close(fd); }

/* The line/stream file primitives the `files` unit builds on: open a handle,
   read one chunk, write bytes, close.  Stateless (the unit holds the fd and does
   its own line buffering). */
#define KPF_CHUNK 4096

int kpf_open_read(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    if (plen < 0 || plen >= (int)sizeof(path))
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kpio_open(path, FS_O_RDONLY);
}

int kpf_open_write(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    if (plen < 0 || plen >= (int)sizeof(path))
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kpio_open(path, FS_O_WRONLY | FS_O_CREAT | FS_O_TRUNC);
}

kp_gptr kpf_read(int fd)
{
    char tmp[KPF_CHUNK];
    long n = (fd < 0) ? -1 : kpio_read(fd, tmp, (long)sizeof tmp);
    if (n <= 0)
        return kp_str_new("", 0);
    return kp_str_new(tmp, (int)n);
}

int kpf_write(int fd, kp_gptr datastr)
{
    if (fd < 0)
        return -1;
    return (int)kpio_write(fd, kp_str_bytes(datastr), (long)kp_str_len(datastr));
}

void kpf_close(int fd)
{
    if (fd >= 0)
        kpio_close(fd);
}

/* The path metadata and operations the `files` unit exposes (exists, size, a
   directory test, delete/rename/mkdir/rmdir) are tier-independent and live in
   kobold/kp_rt_meta.c, shared with the freestanding tier too. */

/* Directory reads for the `dirs` unit.  A Kobold handle is an fs directory fd:
   fs_open with FS_O_DIRECTORY, iterated one fixed fs_dirent per fs_read, closed
   with fs_close, the same model the sandbox and the freestanding io_free.c
   path use. */
int kpd_open(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    if (plen < 0 || plen >= (int)sizeof(path))
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    kp_fs_ensure();
    return fs_open(path, FS_O_DIRECTORY | FS_O_RDONLY, 0);
}

kp_gptr kpd_next(int h)
{
    struct fs_dirent fe;
    int nl = 0;
    if (h < 0)
        return kp_str_new("", 0);
    if (fs_read(h, &fe, (int)sizeof fe) != (int)sizeof fe)
        return kp_str_new("", 0);
    while (nl < FS_DIRENT_NAMEMAX - 1 && fe.name[nl])
        nl++;
    return kp_str_new(fe.name, nl);
}

void kpd_close(int h)
{
    if (h >= 0)
        fs_close(h);
}
