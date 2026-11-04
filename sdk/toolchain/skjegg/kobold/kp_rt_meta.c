/* kp_rt_meta.c : the tier-independent path metadata and operations for a Kobold
   guest's `files` unit (exists, size, a directory test, delete, rename, mkdir,
   rmdir), shared by every runtime tier.

   These call the POSIX stat/unlink/rename/mkdir/rmdir directly, so the body is
   the same C whether the symbols resolve to the host libc (the in-process JIT
   driver, built host-native) or to the guest libc that lowers them to the
   sandbox statx and *at syscalls (the AOT and freestanding tiers, built with the
   target toolchain). That is the whole of the per-tier difference, so unlike the
   stream, whole-file, and directory-read surface (which differs by allocation
   model and the fs-interpose seam, and so stays split between kp_rt_io.c for the
   hosted tiers and io_free.c for the freestanding one) these eight routines are
   one source compiled once per tier. */

#include "kp_rt_io.h"
#include "str.h"

#include <stdint.h>
#include <string.h>
#include <sys/stat.h>   /* struct stat, stat, mkdir, S_ISDIR */
#include <unistd.h>     /* unlink, rmdir */
#include <stdio.h>      /* rename */

/* A guest string is copied to a NUL-terminated path first; -1 on overflow. */
static int kpf_pathcopy(kp_gptr s, char *buf, int cap)
{
    int n = kp_str_len(s);
    if (n < 0 || n >= cap)
        return -1;
    memcpy(buf, kp_str_bytes(s), (size_t)n);
    buf[n] = '\0';
    return n;
}

int kpf_exists(kp_gptr pathstr)
{
    char path[1024];
    struct stat st;
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return 0;
    return stat(path, &st) == 0;
}

int64_t kpf_size(kp_gptr pathstr)
{
    char path[1024];
    struct stat st;
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return -1;
    if (stat(path, &st) != 0)
        return -1;
    return (int64_t)st.st_size;
}

int kpf_isdir(kp_gptr pathstr)
{
    char path[1024];
    struct stat st;
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return 0;
    if (stat(path, &st) != 0)
        return 0;
    return S_ISDIR(st.st_mode) ? 1 : 0;
}

int kpf_delete(kp_gptr pathstr)
{
    char path[1024];
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return 0;
    return unlink(path) == 0;
}

int kpf_rename(kp_gptr oldstr, kp_gptr newstr)
{
    char oldp[1024], newp[1024];
    if (kpf_pathcopy(oldstr, oldp, sizeof oldp) < 0)
        return 0;
    if (kpf_pathcopy(newstr, newp, sizeof newp) < 0)
        return 0;
    return rename(oldp, newp) == 0;
}

int kpf_mkdir(kp_gptr pathstr)
{
    char path[1024];
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return 0;
    return mkdir(path, 0755) == 0;
}

int kpf_rmdir(kp_gptr pathstr)
{
    char path[1024];
    if (kpf_pathcopy(pathstr, path, sizeof path) < 0)
        return 0;
    return rmdir(path) == 0;
}
