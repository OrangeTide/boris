#ifndef STDIO_IMPL_H
#define STDIO_IMPL_H

/* Private FILE.flags bits, shared by the stdio core (stdio_core.c) and the
   fopen family (stdio.c). */
#define F_READ  1
#define F_WRITE 2
#define F_EOF   4
#define F_ERR   8
#define F_ALLOC 16              /* the FILE was malloc'd by fopen (free on close) */
#define F_MEM   32              /* an open_memstream stream (no fd; see f->flush) */

#endif /* STDIO_IMPL_H */
