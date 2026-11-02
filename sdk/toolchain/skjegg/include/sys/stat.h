#ifndef _SYS_STAT_H
#define _SYS_STAT_H

#include <stdint.h>

/* A minimal POSIX stat.  The stat family fills it from the kernel's statx (the
   "new" architectures, rv32 among them, have no stat/fstat syscall), so this
   layout is the library's own and crosses no syscall boundary. */
struct stat {
    uint64_t st_dev;
    uint64_t st_ino;
    uint32_t st_mode;
    uint32_t st_nlink;
    uint32_t st_uid;
    uint32_t st_gid;
    uint64_t st_rdev;
    int64_t  st_size;
    int32_t  st_blksize;
    int64_t  st_blocks;
    int64_t  st_atime;
    int64_t  st_mtime;
    int64_t  st_ctime;
};

/* File-type bits (the standard octal values) and the type predicates. */
#define S_IFMT   0170000
#define S_IFSOCK 0140000
#define S_IFLNK  0120000
#define S_IFREG  0100000
#define S_IFBLK  0060000
#define S_IFDIR  0040000
#define S_IFCHR  0020000
#define S_IFIFO  0010000

#define S_ISREG(m)  (((m) & S_IFMT) == S_IFREG)
#define S_ISDIR(m)  (((m) & S_IFMT) == S_IFDIR)
#define S_ISCHR(m)  (((m) & S_IFMT) == S_IFCHR)
#define S_ISBLK(m)  (((m) & S_IFMT) == S_IFBLK)
#define S_ISFIFO(m) (((m) & S_IFMT) == S_IFIFO)
#define S_ISLNK(m)  (((m) & S_IFMT) == S_IFLNK)
#define S_ISSOCK(m) (((m) & S_IFMT) == S_IFSOCK)

int stat(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int mkdir(const char *path, int mode);
int chmod(const char *path, int mode);

/* The *at primitives the crt wrappers expose (the only file-metadata syscalls
   the "new" arches have).  statx fills the kernel's statx record, whose layout
   libc/stat.c owns; it is opaque here, named only through a pointer. */
struct statx;
int statx(int dirfd, const char *path, int flags, unsigned mask,
          struct statx *buf);
int mkdirat(int dirfd, const char *path, int mode);
int fchmodat(int dirfd, const char *path, int mode, int flags);

#endif /* _SYS_STAT_H */
