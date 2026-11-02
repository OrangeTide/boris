#ifndef _SYS_UIO_H
#define _SYS_UIO_H

#include <stddef.h>

/* A scatter/gather buffer.  On the ILP32 freestanding targets an entry is two
   words, the layout the host writev expects. */
struct iovec {
    void  *iov_base;
    size_t iov_len;
};

int writev(int fd, const struct iovec *iov, int iovcnt);

#endif /* _SYS_UIO_H */
