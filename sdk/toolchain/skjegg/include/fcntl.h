#ifndef _FCNTL_H
#define _FCNTL_H

/* The Linux open flags, as the host passes them through unchanged.  The
   access-mode bits are the same everywhere; the create/truncate/append bits
   are the asm-generic values on every target except MIPS, which predates
   asm-generic and keeps the older pdp-derived values (O_CREAT 0x100, O_APPEND
   0x8).  Only the subset the libc needs. */
#define O_RDONLY    0
#define O_WRONLY    1
#define O_RDWR      2
#ifdef __skj_mips__
#define O_CREAT     00400       /* 0x100 */
#define O_APPEND    00010       /* 0x8   */
#define O_TRUNC     01000       /* 0x200 */
#else
#define O_CREAT     0100        /* 0x40  */
#define O_TRUNC     01000       /* 0x200 */
#define O_APPEND    02000       /* 0x400 */
#endif

/* AT_FDCWD, for openat-based hosts; open() below hides the openat shim. */
#define AT_FDCWD    (-100)

/* AT_REMOVEDIR: unlinkat() removes a directory (the rmdir case) instead of a
   file.  libc/fileops.c uses it for rmdir(). */
#define AT_REMOVEDIR 0x200

/* AT_EMPTY_PATH: operate on dirfd itself when the path is "" (libc/stat.c uses
   it so fstat() reaches statx with the descriptor and an empty path). */
#define AT_EMPTY_PATH 0x1000

/* open() is the crt syscall wrapper (runtime/start_rv.S), a fixed three-argument
   form over openat(AT_FDCWD, ...).  mode matters only with O_CREAT. */
int open(const char *path, int flags, int mode);

/* The remaining *at wrappers the crt exposes, used by libc/fileops.c with
   AT_FDCWD.  mkdirat/fchmodat live in <sys/stat.h> with the mkdir family. */
int unlinkat(int dirfd, const char *path, int flags);
int renameat2(int olddirfd, const char *oldpath,
              int newdirfd, const char *newpath, unsigned flags);

#endif /* _FCNTL_H */
