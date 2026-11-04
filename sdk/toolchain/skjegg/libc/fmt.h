#ifndef _LIBC_FMT_H
#define _LIBC_FMT_H

/* The shared conversion engine behind snprintf and the printf family.  It
   renders into an abstract sink, so one formatter serves a caller buffer
   (snprintf) and a stream (fprintf) without duplicating the conversions.
   `put` receives one character at a time and is responsible for counting it in
   `count`; the engine returns `count`, the number of characters a conversion
   produced regardless of whether the sink stored them (C99 snprintf rule). */

#include <stddef.h>
#include <stdarg.h>
#include <stdint.h>

struct __sink {
    void (*put)(struct __sink *s, char c);
    size_t count;
};

int __vformat(struct __sink *s, const char *fmt, va_list ap);

/* The libgcc-free number formatters shared with the Kobold freestanding
   runtime (libc/numfmt.c).  __fmt_udec writes an unsigned value's decimal
   digits (most significant first, no NUL, no sign) and returns the count.
   __fmt_greal renders a finite, non-negative double like "%g" with `sig`
   significant digits (`alt` keeps trailing zeros, `upper` selects 'E'),
   returning the byte count; the sign and NaN/infinity are the caller's. */
int __fmt_udec(char *out, uint64_t v);
int __fmt_greal(char *out, double v, int sig, int alt, int upper);

#endif
