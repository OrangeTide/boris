/* Directory and path file operations: mkdir, rmdir, unlink, rename, remove.
   Each wraps one of the crt's *at syscall wrappers (runtime/start_*.S) with
   AT_FDCWD, the same way libc/stat.c wraps statx.  The *at forms are the only
   ones the no-bare-syscall arches (rv32, arm64) have, so one implementation
   serves every target. */
#include <sys/stat.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

#ifdef SKJ_FS_INTERPOSE

/* fs/ interposition: the path operations resolve through the mount table, the
   same way open() does, so a `name:` selector and the per-mount cwd apply. */
#include "fs.h"

int
mkdir(const char *path, int mode)
{
    (void)mode;
    return fs_mkdir(path);
}

int
unlink(const char *path)
{
    return fs_unlink(path);
}

int
rmdir(const char *path)
{
    return fs_rmdir(path);
}

int
chmod(const char *path, int mode)
{
    /* No fs/ chmod op (the mount model has no permission bits yet); fall back to
       the ambient host call so a program that chmods keeps working. */
    return fchmodat(AT_FDCWD, path, mode, 0);
}

int
rename(const char *oldpath, const char *newpath)
{
    return fs_rename(oldpath, newpath);
}

int
remove(const char *path)
{
    if (fs_unlink(path) == 0)
        return 0;
    return fs_rmdir(path);
}

#else /* raw *at wrappers */

int
mkdir(const char *path, int mode)
{
    return mkdirat(AT_FDCWD, path, mode);
}

int
unlink(const char *path)
{
    return unlinkat(AT_FDCWD, path, 0);
}

int
rmdir(const char *path)
{
    return unlinkat(AT_FDCWD, path, AT_REMOVEDIR);
}

int
chmod(const char *path, int mode)
{
    return fchmodat(AT_FDCWD, path, mode, 0);
}

int
rename(const char *oldpath, const char *newpath)
{
    return renameat2(AT_FDCWD, oldpath, AT_FDCWD, newpath, 0);
}

/* ISO C remove(): a file or an empty directory.  Try the file form first, then
   the directory form, so a caller need not know which it is removing. */
int
remove(const char *path)
{
    if (unlinkat(AT_FDCWD, path, 0) == 0)
        return 0;
    return unlinkat(AT_FDCWD, path, AT_REMOVEDIR);
}

#endif /* SKJ_FS_INTERPOSE */
