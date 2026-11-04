#include <stdio.h>
#include <stddef.h>
#include <unistd.h>
#include "stdio_impl.h"

/* The freestanding tiers (rv32, ColdFire) ship a writev on the shared syscall
   seam, so a bulk write can send the pending buffer and the caller's block in
   one call.  The other targets fall back to two write() calls, which is still
   fewer syscalls than draining byte by byte. */
#if (defined(__riscv) && __riscv_xlen == 32) || defined(__skj_riscv__) || \
    defined(__mcoldfire__) || defined(__skj_m68k__)
#define SKJ_HAVE_WRITEV 1
#include <sys/uio.h>
#endif

/* The buffered-stream core: the three standard streams and the character and
   block I/O over them.  Everything here builds only on the write/read seam the
   crt provides, with no malloc, no open/lseek, and no printf engine, so a
   freestanding runtime that wants buffered console I/O (the Kobold freestanding
   tier) links this object alone.  fopen/fseek/ftell and the printf family live
   in stdio.c, which pulls malloc and the format engine.

   stdout is line buffered, stderr unbuffered, stdin read in BUFSIZ chunks.  The
   crt's normal exit (returning from main) does not flush, so a program that
   leaves output in a buffer should fflush before it returns; line buffering
   means output ending in a newline is already flushed. */

FILE __libc_stdin  = { 0, F_READ,  _IOLBF, 0, 0 };
FILE __libc_stdout = { 1, F_WRITE, _IOLBF, 0, 0 };
FILE __libc_stderr = { 2, F_WRITE, _IONBF, 0, 0 };

int
fflush(FILE *f)
{
    int off;

    if (f == NULL) {                    /* flush every stream we know of */
        int r = 0;
        if (fflush(stdout) == EOF)
            r = EOF;
        if (fflush(stderr) == EOF)
            r = EOF;
        return r;
    }
    if (!(f->flags & F_WRITE) || f->pos == 0)
        return 0;
    if (f->flush)                       /* memory stream: grow the caller's buffer */
        return f->flush(f);
    for (off = 0; off < f->pos; ) {
        int w = write(f->fd, f->buf + off, f->pos - off);
        if (w <= 0) {
            f->flags |= F_ERR;
            return EOF;
        }
        off += w;
    }
    f->pos = 0;
    return 0;
}

int
fputc(int c, FILE *f)
{
    if (!(f->flags & F_WRITE)) {
        f->flags |= F_ERR;
        return EOF;
    }
    f->buf[f->pos++] = (unsigned char)c;
    if (f->pos == BUFSIZ || f->mode == _IONBF ||
        (f->mode == _IOLBF && c == '\n'))
        if (fflush(f) == EOF)
            return EOF;
    return (unsigned char)c;
}

int
putc(int c, FILE *f)
{
    return fputc(c, f);
}

int
putchar(int c)
{
    return fputc(c, stdout);
}

int
fputs(const char *s, FILE *f)
{
    while (*s)
        if (fputc((unsigned char)*s++, f) == EOF)
            return EOF;
    return 0;
}

int
puts(const char *s)
{
    if (fputs(s, stdout) == EOF)
        return EOF;
    if (fputc('\n', stdout) == EOF)
        return EOF;
    return 0;
}

/* Write exactly n bytes of b, retrying a short write; 0 on success, -1 on a
   write error. */
static int
write_all(int fd, const unsigned char *b, int n)
{
    int off = 0;

    while (off < n) {
        int w = write(fd, b + off, n - off);
        if (w <= 0)
            return -1;
        off += w;
    }
    return 0;
}

/* Drain the stream's pending buffer and the caller's block together, in one
   writev where the target has it, then clear the buffer.  0 on success, -1 on
   a write error (the caller flags F_ERR). */
static int
flush_with_block(FILE *f, const unsigned char *p, int n)
{
    int pending = f->pos;
#ifdef SKJ_HAVE_WRITEV
    struct iovec iov[2];
    int want = pending + n;
    int w;

    iov[0].iov_base = f->buf;
    iov[0].iov_len  = (size_t)pending;
    iov[1].iov_base = (void *)p;
    iov[1].iov_len  = (size_t)n;
    w = writev(f->fd, iov, 2);
    if (w == want) {                    /* the common case: a single syscall */
        f->pos = 0;
        return 0;
    }
    if (w > 0) {                        /* a short writev: finish by hand */
        if (w < pending) {
            if (write_all(f->fd, f->buf + w, pending - w) != 0)
                return -1;
            w = 0;                      /* the whole block is still pending */
        } else {
            w -= pending;               /* bytes of the block already out */
        }
        if (write_all(f->fd, p + w, n - w) != 0)
            return -1;
        f->pos = 0;
        return 0;
    }
    if (w < 0)                          /* writev error (w == 0 falls through) */
        return -1;
#endif
    if (write_all(f->fd, f->buf, pending) != 0)
        return -1;
    if (write_all(f->fd, p, n) != 0)
        return -1;
    f->pos = 0;
    return 0;
}

size_t
fwrite(const void *ptr, size_t size, size_t nmemb, FILE *f)
{
    const unsigned char *p = ptr;
    size_t total = size * nmemb;
    size_t i;

    if (size == 0 || nmemb == 0)
        return 0;

    /* A fully-buffered fd stream taking a block that will not fit the buffer
       writes the pending bytes and the block together instead of draining the
       buffer and then the block separately.  Line- and un-buffered streams, and
       memory streams (f->flush set), keep the character path so their flush
       points (on a newline, or every byte) are unchanged. */
    if ((f->flags & F_WRITE) && f->mode == _IOFBF && f->flush == NULL &&
        total > (size_t)(BUFSIZ - f->pos)) {
        if (flush_with_block(f, p, (int)total) != 0) {
            f->flags |= F_ERR;
            return 0;
        }
        return nmemb;
    }

    for (i = 0; i < total; i++)
        if (fputc(p[i], f) == EOF)
            break;
    return i / size;                    /* whole items written */
}

/* Refill an input stream's buffer.  Returns 0, or EOF at end of input. */
static int
refill(FILE *f)
{
    int n = read(f->fd, f->buf, BUFSIZ);
    if (n <= 0) {
        f->flags |= (n == 0) ? F_EOF : F_ERR;
        f->pos = f->len = 0;
        return EOF;
    }
    f->len = n;
    f->pos = 0;
    return 0;
}

int
fgetc(FILE *f)
{
    if (!(f->flags & F_READ)) {
        f->flags |= F_ERR;
        return EOF;
    }
    if (f->pos >= f->len)
        if (refill(f) == EOF)
            return EOF;
    return f->buf[f->pos++];
}

int
getc(FILE *f)
{
    return fgetc(f);
}

int
getchar(void)
{
    return fgetc(stdin);
}

char *
fgets(char *s, int size, FILE *f)
{
    int i = 0;

    if (size <= 0)
        return NULL;
    while (i < size - 1) {
        int c = fgetc(f);
        if (c == EOF)
            break;
        s[i++] = (char)c;
        if (c == '\n')
            break;
    }
    if (i == 0)
        return NULL;                    /* end of input with nothing read */
    s[i] = '\0';
    return s;
}

size_t
fread(void *ptr, size_t size, size_t nmemb, FILE *f)
{
    unsigned char *p = ptr;
    size_t total = size * nmemb;
    size_t i;

    if (size == 0 || nmemb == 0)
        return 0;
    for (i = 0; i < total; i++) {
        int c = fgetc(f);
        if (c == EOF)
            break;
        p[i] = (unsigned char)c;
    }
    return i / size;                    /* whole items read */
}

int
feof(FILE *f)
{
    return (f->flags & F_EOF) != 0;
}

int
ferror(FILE *f)
{
    return (f->flags & F_ERR) != 0;
}

void
clearerr(FILE *f)
{
    f->flags &= ~(F_EOF | F_ERR);
}
