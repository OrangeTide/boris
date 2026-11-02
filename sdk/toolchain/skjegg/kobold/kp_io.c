/* kp_io.c : the single Kobold console I/O implementation (see kp_io.h).

   Console I/O lowers to a POSIX-style fd, not a stdio FILE*.  The guest's
   write/writeln/read/readln builtins carry fd 1 (stdout) / 2 (stderr), read from
   stdin (fd 0), and reach the OS through the write/read seam.  An fd is a small
   int, so it needs no guest pointer the way a FILE* would, and it is the
   sandbox's own boundary (boris/smolmoo expose write/read, not stdio).  There is
   no stream buffering: the only state here is a single byte of input pushback,
   the irreducible lookahead the Pascal reads need.  read(int)/read(real) stop at
   a delimiter they must not consume, and read(str) leaves the terminating newline
   for a following readln.  Any larger buffering, or a general ungetc, is an
   application concern, not a runtime one.

   Numeric output routes through the shared C-runtime formatters (libc/numfmt.c):
   io_write_int through __fmt_udec and io_write_real through __fmt_greal, the same
   libgcc-free renderers the C libc's %g path uses, so a Kobold program and a C
   program built against the same libc print a number identically.  Real input
   uses the tier's strtod (libc/strtod.c freestanding, the host libc hosted), a
   decimal-float scan either way. */

#include "kp_io.h"

#include <stdint.h>
#include <stddef.h>

#if (defined(__riscv) && __riscv_xlen == 32) || defined(__skj_riscv__) || \
    defined(__mcoldfire__) || defined(__skj_m68k__)
/* Freestanding: the POSIX-named wrappers are per-target syscall assembly
   (runtime/io_free_rv.S, runtime/io_free_cf.S), with an int-width count. */
int  read(int fd, void *buf, int len);
int  write(int fd, const void *buf, int len);
void _exit(int code);
extern double strtod(const char *s, char **end);   /* libc/strtod.c */
#define KP_IO_EXIT(c) _exit(c)
#else
#include <unistd.h>     /* read, write */
#include <stdlib.h>     /* exit, strtod */
#define KP_IO_EXIT(c) exit(c)
#endif

/* The libgcc-free number formatters shared with the C libc's %g path (libc/
   numfmt.c).  __fmt_udec writes an unsigned value's decimal digits (most
   significant first, no NUL, no sign); __fmt_greal renders a finite, non-negative
   double like "%g".  Declared here because this file carries no -Ilibc; keep in
   step with libc/fmt.h. */
extern int __fmt_udec(char *out, uint64_t v);
extern int __fmt_greal(char *out, double v, int sig, int alt, int upper);

/****************************************************************
 * Output (over the write seam, one call per value; no buffering)
 ****************************************************************/

static void
out_bytes(int fd, const char *b, int n)
{
    if (n > 0) {
        int r = (int)write(fd, b, n);
        (void)r;            /* best-effort console write; a short write is not retried */
    }
}

void
io_write_str(int fd, kp_gptr s)
{
    out_bytes(fd, kp_str_bytes(s), (int)kp_str_len(s));
}

void
io_write_char(int fd, int ch)
{
    char c = (char)ch;
    out_bytes(fd, &c, 1);
}

/* A decimal integer: the sign here, the magnitude's digits from the shared
   __fmt_udec (numfmt.c).  INT_MIN is safe: the magnitude is taken in unsigned. */
void
io_write_int(int fd, int v)
{
    char out[12];
    int j = 0;
    unsigned int m = v < 0 ? 0u - (unsigned int)v : (unsigned int)v;

    if (v < 0)
        out[j++] = '-';
    j += __fmt_udec(out + j, (uint64_t)m);
    out_bytes(fd, out, j);
}

/* real printed like C's "%g" (six significant digits): the sign and the NaN /
   infinity spellings here, the finite magnitude through the shared __fmt_greal
   (numfmt.c), the same renderer the C libc's %g uses.  The dialect has no
   field-width formatting.  The bytes go straight to the fd like every other
   console write, so a hosted program never interleaves a buffered stdio stream
   with them.  NaN and infinity are detected without <float.h> (absent on the
   freestanding tier) by IEEE identities, like the NaN test the C libc shares:
   `v != v` is NaN, and a positive value that equals its own double is infinity
   (no finite positive v satisfies v + v == v). */
static int
fmt_g(double v, char *out)
{
    int n = 0;

    if (v != v) { out[0] = 'n'; out[1] = 'a'; out[2] = 'n'; return 3; }
    if (v < 0.0) { out[n++] = '-'; v = -v; }
    if (v > 0.0 && v + v == v) {    /* infinity */
        out[n++] = 'i'; out[n++] = 'n'; out[n++] = 'f';
        return n;
    }
    return n + __fmt_greal(out + n, v, 6, 0, 0);
}

void
io_write_real(int fd, double x)
{
    char buf[40];
    int n = fmt_g(x, buf);

    out_bytes(fd, buf, n);
}

void io_flush(int fd) { (void)fd; }     /* unbuffered: nothing to flush */
void io_halt(int code) { KP_IO_EXIT(code); }

/****************************************************************
 * Input (over the read seam, with one byte of pushback)
 ****************************************************************/

static int g_peek = -2;     /* -2 empty, else a buffered byte 0..255 */
static int g_eof;           /* sticky: set once a read returns no byte */

static int
read_byte(void)
{
    unsigned char b;
    int n = (int)read(0, &b, 1);

    if (n <= 0) {
        g_eof = 1;
        return -1;
    }
    return (int)b;
}

static int
next_byte(void)
{
    int c;

    if (g_peek != -2) {
        c = g_peek;
        g_peek = -2;
        return c;
    }
    return read_byte();
}

static void
push_byte(int c)
{
    g_peek = c;
}

/* The sticky end-of-input latch (io.console's Eof): a one-byte lookahead, true
   once no buffered byte remains and the stream has ended.  A newline-less final
   line is still delivered first, since the latch is set only when a read returns
   no byte. */
int
io_eof(void)
{
    int c;

    if (g_peek != -2)
        return 0;
    if (g_eof)
        return 1;
    c = read_byte();
    if (c == -1)
        return 1;           /* read_byte latched g_eof */
    g_peek = c;
    return 0;
}

static int
skip_space(void)
{
    int c;

    do {
        c = next_byte();
    } while (c == ' ' || c == '\t' || c == '\n' || c == '\r');
    return c;
}

int64_t
io_read_int(void)
{
    int c = skip_space(), neg = 0;
    int64_t v = 0;

    if (c == '+' || c == '-') {
        neg = (c == '-');
        c = next_byte();
    }
    while (c >= '0' && c <= '9') {
        v = v * 10 + (c - '0');
        c = next_byte();
    }
    if (c != -1)
        push_byte(c);       /* the delimiter stays for the next read */
    return neg ? -v : v;
}

double
io_read_real(void)
{
    char tok[64];
    int n = 0, c = skip_space();

    while (c != -1 && c != ' ' && c != '\t' && c != '\n' && c != '\r' &&
           n < (int)sizeof tok - 1)
        tok[n++] = (char)c, c = next_byte();
    if (c != -1)
        push_byte(c);
    tok[n] = '\0';
    return n ? strtod(tok, (char **)0) : 0.0;
}

int
io_read_char(void)
{
    return next_byte();     /* -1 at end of input; guard with io_eof */
}

void
io_read_ln(void)
{
    int c;

    do {
        c = next_byte();
    } while (c != '\n' && c != -1);
}

/* Read a line into a fresh guest string, leaving the terminating newline on the
   stream (standard Pascal read; a following readln consumes it). */
kp_gptr
io_read_str(void)
{
    char buf[256];
    int n = 0, c = next_byte();

    while (c != '\n' && c != -1 && n < (int)sizeof buf)
        buf[n++] = (char)c, c = next_byte();
    if (c == '\n')
        push_byte(c);
    return kp_str_new(buf, n);
}
