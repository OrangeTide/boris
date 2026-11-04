#ifndef _UNISTD_H
#define _UNISTD_H

/* The POSIX I/O syscall wrappers the crt provides (runtime/syscall_rv.S,
   syscall_cf.S, and the start_*.S for the other arches).  getdents64 is the raw
   directory-read syscall libc/dirent.c walks; the rest are the ordinary
   descriptor calls.  Declared once here instead of re-externed in each .c. */
int read(int fd, void *buf, int n);
int write(int fd, const void *buf, int n);
int close(int fd);
long lseek(int fd, long offset, int whence);
int getdents64(int fd, void *buf, int count);

/* The POSIX file-removal calls.  ISO C's remove()/rename() live in <stdio.h>;
   these are the POSIX spellings a self-hosting build expects.  libc/fileops.c
   wraps the crt's *at syscall wrappers with AT_FDCWD. */
int unlink(const char *path);
int rmdir(const char *path);

#endif /* _UNISTD_H */
