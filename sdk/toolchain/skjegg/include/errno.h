#ifndef _ERRNO_H
#define _ERRNO_H

/* A single global errno (the library is single threaded, so no per-thread
   indirection).  The three C-standard codes come first; the rest are the
   common POSIX names a hosted program expects, with stable local numbers. */
extern int errno;

#define EDOM    1       /* argument outside a function's domain */
#define ERANGE  2       /* result not representable */
#define EILSEQ  3       /* illegal byte sequence */
#define EINVAL  4       /* invalid argument */
#define ENOMEM  5       /* out of memory */
#define ENOENT  6       /* no such file or directory */
#define EBADF   7       /* bad file descriptor */
#define EIO     8       /* input/output error */
#define EACCES  9       /* permission denied */
#define ENOSPC  10      /* no space left on device */
#define EEXIST  11      /* file exists */
#define ENOTDIR 12      /* not a directory */
#define EISDIR  13      /* is a directory */
#define ENOTEMPTY 14    /* directory not empty */
#define ENAMETOOLONG 15 /* path component too long */
#define EMFILE  16      /* too many open files */
#define EXDEV   17      /* cross-device link */
#define EROFS   18      /* read-only file system */
#define ESPIPE  19      /* illegal seek */
#define ENODEV  20      /* no such device (no backend for the mount) */
#define EPERM   21      /* operation not permitted (an immutable namespace) */
#define EPROTO  22      /* protocol error (a malformed 9p reply) */

#endif
