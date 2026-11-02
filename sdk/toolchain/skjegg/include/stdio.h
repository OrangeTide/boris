#ifndef _STDIO_H
#define _STDIO_H

#include <stddef.h>
#include <stdarg.h>

#define EOF    (-1)
#define BUFSIZ 1024

/* whence values for fseek */
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

/* buffering modes for setvbuf-style fields (setvbuf itself is not yet here) */
#define _IOFBF 0        /* fully buffered */
#define _IOLBF 1        /* line buffered  */
#define _IONBF 2        /* unbuffered     */

/* A stream.  The buffer is embedded rather than pointed at, so the three
   standard streams need no static pointer initializer (which skj-cc does not
   yet emit).  Fields are private; use the functions. */
typedef struct __FILE {
    int fd;
    int flags;                  /* read/write/eof/error bits */
    int mode;                   /* _IOFBF / _IOLBF / _IONBF */
    int pos;                    /* bytes pending (write) or next index (read) */
    int len;                    /* valid bytes in buf (read) */
    /* Memory-stream backing (open_memstream).  flush is the write-side drain:
       NULL for an fd-backed stream, where fflush calls write; set for a memory
       stream, where fflush grows the caller's buffer instead.  The remaining
       fields are that growable buffer and the caller's out-pointers, all zero
       for an fd-backed stream. */
    int (*flush)(struct __FILE *);
    char *mbuf;                 /* the owned growable buffer */
    size_t mcap;                /* its capacity */
    size_t mlen;                /* bytes written so far (excludes the NUL) */
    char **muserbuf;            /* the caller's buffer pointer, kept current */
    size_t *musersize;          /* the caller's size, kept current */
    unsigned char buf[BUFSIZ];
} FILE;

extern FILE __libc_stdin;
extern FILE __libc_stdout;
extern FILE __libc_stderr;

#define stdin  (&__libc_stdin)
#define stdout (&__libc_stdout)
#define stderr (&__libc_stderr)

FILE *fopen(const char *path, const char *mode);
FILE *open_memstream(char **bufp, size_t *sizep);
int   fclose(FILE *stream);
int   fseek(FILE *stream, long offset, int whence);
long  ftell(FILE *stream);
void  rewind(FILE *stream);
int   fflush(FILE *stream);

int   fputc(int c, FILE *stream);
int   putc(int c, FILE *stream);
int   putchar(int c);
int   fputs(const char *s, FILE *stream);
int   puts(const char *s);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

int   fgetc(FILE *stream);
int   getc(FILE *stream);
int   getchar(void);
char *fgets(char *s, int size, FILE *stream);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);

int   feof(FILE *stream);
int   ferror(FILE *stream);
void  clearerr(FILE *stream);

int   printf(const char *fmt, ...);
int   fprintf(FILE *stream, const char *fmt, ...);
int   vprintf(const char *fmt, va_list ap);
int   vfprintf(FILE *stream, const char *fmt, va_list ap);

int   snprintf(char *buf, size_t size, const char *fmt, ...);
int   vsnprintf(char *buf, size_t size, const char *fmt, va_list ap);
int   sprintf(char *buf, const char *fmt, ...);
int   vsprintf(char *buf, const char *fmt, va_list ap);

int   sscanf(const char *str, const char *fmt, ...);
int   vsscanf(const char *str, const char *fmt, va_list ap);

void  perror(const char *s);

/* File removal and renaming (ISO C).  libc/fileops.c wraps the *at syscalls. */
int   remove(const char *path);
int   rename(const char *oldpath, const char *newpath);

#endif
