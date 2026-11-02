#include <stdio.h>
#include <stddef.h>
#include <stdarg.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "fmt.h"
#include "stdio_impl.h"

/* fopen'd real files and the FILE-directed printf family.  The buffered-stream
   core (the three standard streams and the character/block I/O over them) lives
   in stdio_core.c, which builds only on the write/read seam; the pieces here add
   the malloc'd FILE of fopen and the format engine (__vformat), so a program
   that only needs buffered console output pulls stdio_core.o without this
   object's malloc and printf dependencies. */

/* Open a real file.  The three standard streams stay static; a fopen'd stream
   is a malloc'd FILE buffering over the open/read/write/close/lseek crt
   syscalls.  Modes r/w/a with optional b (ignored) and + (read-write). */
FILE *
fopen(const char *path, const char *mode)
{
    int flags, fl, fd, plus = 0;
    const char *m;
    FILE *f;

    for (m = mode; *m; m++)
        if (*m == '+')
            plus = 1;

    switch (mode[0]) {
    case 'r':
        flags = plus ? O_RDWR : O_RDONLY;
        fl = plus ? (F_READ | F_WRITE) : F_READ;
        break;
    case 'w':
        flags = (plus ? O_RDWR : O_WRONLY) | O_CREAT | O_TRUNC;
        fl = plus ? (F_READ | F_WRITE) : F_WRITE;
        break;
    case 'a':
        flags = (plus ? O_RDWR : O_WRONLY) | O_CREAT | O_APPEND;
        fl = plus ? (F_READ | F_WRITE) : F_WRITE;
        break;
    default:
        return NULL;
    }
    fd = open(path, flags, 0666);
    if (fd < 0)
        return NULL;
    f = malloc(sizeof *f);
    if (f == NULL) {
        close(fd);
        return NULL;
    }
    f->fd = fd;
    f->flags = fl | F_ALLOC;
    f->mode = _IOFBF;
    f->pos = 0;
    f->len = 0;
    f->flush = 0;                       /* fd-backed: fflush uses write */
    return f;
}

int
fclose(FILE *f)
{
    int r = fflush(f);

    /* A memory stream has no fd, and its grown buffer belongs to the caller
       (published on each flush), so it is not freed here. */
    if (!(f->flags & F_MEM) && close(f->fd) != 0)
        r = EOF;
    if (f->flags & F_ALLOC)
        free(f);
    return r;
}

/* Seek: flush a write buffer, drop a read buffer, then move the fd. */
int
fseek(FILE *f, long offset, int whence)
{
    if (f->flags & F_MEM)               /* a memory stream is append-only here */
        return -1;
    if ((f->flags & F_WRITE) && fflush(f) == EOF)
        return -1;
    f->pos = 0;
    f->len = 0;
    if (lseek(f->fd, offset, whence) < 0)
        return -1;
    f->flags &= ~F_EOF;
    return 0;
}

long
ftell(FILE *f)
{
    long off;

    if (f->flags & F_MEM)               /* current write position = bytes so far */
        return (long)(f->mlen + f->pos);
    off = lseek(f->fd, 0, SEEK_CUR);
    if (off < 0)
        return -1;
    if (f->flags & F_WRITE)
        off += f->pos;                  /* buffered, not yet written */
    else
        off -= (f->len - f->pos);       /* read ahead, not yet consumed */
    return off;
}

void
rewind(FILE *f)
{
    fseek(f, 0, SEEK_SET);
    f->flags &= ~F_ERR;
}

/* The stream sink behind the printf family: each character goes to the FILE,
   and every one is counted for the return value.  The base __sink is first, so
   the engine's pointer casts here. */
struct file_sink {
    struct __sink base;
    FILE *f;
};

static void
file_put(struct __sink *s, char c)
{
    struct file_sink *fs = (struct file_sink *)s;
    fputc((unsigned char)c, fs->f);
    s->count++;
}

int
vfprintf(FILE *f, const char *fmt, va_list ap)
{
    struct file_sink fs;
    fs.base.put = file_put;
    fs.base.count = 0;
    fs.f = f;
    __vformat(&fs.base, fmt, ap);
    return (int)fs.base.count;
}

int
fprintf(FILE *f, const char *fmt, ...)
{
    va_list ap;
    int n;
    va_start(ap, fmt);
    n = vfprintf(f, fmt, ap);
    va_end(ap);
    return n;
}

int
vprintf(const char *fmt, va_list ap)
{
    return vfprintf(stdout, fmt, ap);
}

int
printf(const char *fmt, ...)
{
    va_list ap;
    int n;
    va_start(ap, fmt);
    n = vfprintf(stdout, fmt, ap);
    va_end(ap);
    return n;
}
