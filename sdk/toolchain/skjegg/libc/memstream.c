#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include "stdio_impl.h"

/* open_memstream: a write-only stream backed by a growable malloc'd buffer
   rather than a file descriptor.  The buffered-stream core (stdio_core.c)
   drains a write through f->flush when it is set, so a memory stream plugs in
   without the core needing malloc; mem_flush here appends the core's pending
   bytes to the buffer, keeps it NUL-terminated, and republishes the caller's
   pointer and size.  POSIX makes both current after every fflush and after
   fclose, and the buffer's ownership passes to the caller, who frees it.

   This libc's memory streams are append-only (fseek is rejected), which is all
   open_memstream's own contract requires: the position only advances as bytes
   are written. */

static int
mem_flush(FILE *f)
{
    size_t need = f->mlen + (size_t)f->pos + 1;     /* +1 for the NUL */

    if (need > f->mcap) {
        size_t cap = f->mcap ? f->mcap : 64;
        char *nb;

        while (cap < need)
            cap *= 2;
        nb = realloc(f->mbuf, cap);
        if (nb == NULL) {
            f->flags |= F_ERR;
            return EOF;
        }
        f->mbuf = nb;
        f->mcap = cap;
    }
    memcpy(f->mbuf + f->mlen, f->buf, (size_t)f->pos);
    f->mlen += (size_t)f->pos;
    f->mbuf[f->mlen] = '\0';
    f->pos = 0;
    *f->muserbuf = f->mbuf;
    *f->musersize = f->mlen;
    return 0;
}

FILE *
open_memstream(char **bufp, size_t *sizep)
{
    FILE *f;

    if (bufp == NULL || sizep == NULL)
        return NULL;
    f = malloc(sizeof *f);
    if (f == NULL)
        return NULL;
    f->mbuf = malloc(64);
    if (f->mbuf == NULL) {
        free(f);
        return NULL;
    }
    f->fd = -1;
    f->flags = F_WRITE | F_ALLOC | F_MEM;
    f->mode = _IOFBF;
    f->pos = 0;
    f->len = 0;
    f->flush = mem_flush;
    f->mcap = 64;
    f->mlen = 0;
    f->mbuf[0] = '\0';
    f->muserbuf = bufp;
    f->musersize = sizep;
    *bufp = f->mbuf;                    /* valid immediately: an empty string */
    *sizep = 0;
    return f;
}
