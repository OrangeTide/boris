#include <stdio.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <ctype.h>
#include <stdlib.h>

/* A minimal scanf over a NUL-terminated string.  Supported conversions are
   d i u o x X p, f e g E G (and a A, all via strtod), s, c, and %%, each with
   an optional field width and the '*' assignment-suppression flag.  Length
   modifiers h hh (taken as int), l ll z j t (long / long long for integers,
   double for floats), and L (double) are accepted.  The scanset form %[...] is
   not implemented.  Returns the number of items assigned, or EOF when the
   input ends before the first conversion matches.

   Every va_arg is pulled here in vsscanf, never in a helper, so the code does
   not depend on whether a target's va_list is an array or a struct. */

static const char *
skip_ws(const char *p)
{
    while (isspace((unsigned char)*p))
        p++;
    return p;
}

/* Parse an unsigned integer in the given base (0 auto-detects) with an
   optional sign, honoring a field width.  On a match, advances *pin past the
   consumed run and returns 1; otherwise leaves *pin at the whitespace-skipped
   start and returns 0.  The sign is reported separately so the caller casts
   into the destination type. */
static int
scan_uint(const char **pin, int width, int base, int *neg,
          unsigned long long *out)
{
    const char *p = skip_ws(*pin);
    unsigned long long acc = 0;
    int w = width > 0 ? width : 0x7fffffff;
    int anydig = 0;

    *neg = 0;
    if (w > 0 && (*p == '+' || *p == '-')) {
        *neg = (*p == '-');
        p++;
        w--;
    }
    if ((base == 0 || base == 16) && w >= 2 &&
        p[0] == '0' && (p[1] == 'x' || p[1] == 'X')) {
        p += 2;
        w -= 2;
        base = 16;
    } else if (base == 0 && *p == '0') {
        base = 8;
    } else if (base == 0) {
        base = 10;
    }

    while (w > 0) {
        int c = (unsigned char)*p, d;
        if (c >= '0' && c <= '9') d = c - '0';
        else if (c >= 'a' && c <= 'z') d = c - 'a' + 10;
        else if (c >= 'A' && c <= 'Z') d = c - 'A' + 10;
        else break;
        if (d >= base)
            break;
        acc = acc * (unsigned)base + (unsigned)d;
        anydig = 1;
        p++;
        w--;
    }

    if (!anydig) {
        *pin = skip_ws(*pin);
        return 0;
    }
    *pin = p;
    *out = acc;
    return 1;
}

int
vsscanf(const char *str, const char *fmt, va_list ap)
{
    const char *in = str;
    const char *f = fmt;
    int assigned = 0;

    while (*f) {
        int suppress = 0, width = 0, lng = 0;
        char c;

        if (isspace((unsigned char)*f)) {
            f = skip_ws(f);
            in = skip_ws(in);
            continue;
        }
        if (*f != '%') {
            if (*in != *f)
                return assigned;        /* literal mismatch stops the scan */
            in++;
            f++;
            continue;
        }

        f++;                            /* past '%' */
        if (*f == '*') { suppress = 1; f++; }
        while (*f >= '0' && *f <= '9')
            width = width * 10 + (*f++ - '0');
        if (*f == 'h') { f++; if (*f == 'h') f++; }
        else if (*f == 'l') { lng = 1; f++; if (*f == 'l') { lng = 2; f++; } }
        else if (*f == 'L') { lng = 1; f++; }
        else if (*f == 'z' || *f == 'j' || *f == 't') {
            lng = (sizeof(long) == sizeof(long long)) ? 2 : 1;
            f++;
        }
        c = *f;
        if (c == '\0')
            break;
        f++;

        if (c == '%') {
            in = skip_ws(in);
            if (*in != '%')
                return assigned ? assigned : EOF;
            in++;
            continue;
        }

        if (c == 'c') {
            int w = width > 0 ? width : 1;
            int k;
            for (k = 0; k < w; k++)
                if (!in[k])
                    break;
            if (k < w)                  /* fewer than width characters */
                return (assigned == 0) ? EOF : assigned;
            if (!suppress) {
                char *dst = va_arg(ap, char *);
                for (k = 0; k < w; k++)
                    dst[k] = in[k];
                assigned++;
            }
            in += w;
            continue;
        }

        if (c == 's') {
            const char *p = skip_ws(in);
            int w = width > 0 ? width : 0x7fffffff;
            int n = 0;
            if (!*p)
                return (assigned == 0) ? EOF : assigned;
            if (!suppress) {
                char *dst = va_arg(ap, char *);
                while (p[n] && !isspace((unsigned char)p[n]) && n < w) {
                    dst[n] = p[n];
                    n++;
                }
                dst[n] = '\0';
                assigned++;
            } else {
                while (p[n] && !isspace((unsigned char)p[n]) && n < w)
                    n++;
            }
            in = p + n;
            continue;
        }

        if (c == 'd' || c == 'i' || c == 'u' || c == 'o' ||
            c == 'x' || c == 'X' || c == 'p') {
            int base = (c == 'd' || c == 'u') ? 10 :
                       (c == 'i') ? 0 : (c == 'o') ? 8 : 16;
            int is_signed = (c == 'd' || c == 'i');
            int neg;
            unsigned long long acc, v;
            const char *at_end = skip_ws(in);
            if (!scan_uint(&in, width, base, &neg, &acc))
                return (assigned == 0 && *at_end == '\0') ? EOF : assigned;
            v = neg ? (unsigned long long)(-(long long)acc) : acc;
            if (!suppress) {
                if (c == 'p')
                    *va_arg(ap, void **) = (void *)(uintptr_t)v;
                else if (is_signed) {
                    if (lng >= 2) *va_arg(ap, long long *) = (long long)v;
                    else if (lng == 1) *va_arg(ap, long *) = (long)v;
                    else *va_arg(ap, int *) = (int)v;
                } else {
                    if (lng >= 2) *va_arg(ap, unsigned long long *) = v;
                    else if (lng == 1) *va_arg(ap, unsigned long *) = (unsigned long)v;
                    else *va_arg(ap, unsigned *) = (unsigned)v;
                }
                assigned++;
            }
            continue;
        }

        if (c == 'f' || c == 'e' || c == 'g' ||
            c == 'E' || c == 'G' || c == 'a' || c == 'A') {
            const char *p = skip_ws(in);
            char *endp;
            double d;
            if (!*p)
                return (assigned == 0) ? EOF : assigned;
            d = strtod(p, &endp);
            if (endp == p)
                return assigned;        /* no numeral: conversion failure */
            in = endp;
            if (!suppress) {
                if (lng >= 1) *va_arg(ap, double *) = d;
                else *va_arg(ap, float *) = (float)d;
                assigned++;
            }
            continue;
        }

        /* an unknown conversion stops the scan */
        return assigned;
    }

    return assigned;
}

int
sscanf(const char *str, const char *fmt, ...)
{
    va_list ap;
    int n;
    va_start(ap, fmt);
    n = vsscanf(str, fmt, ap);
    va_end(ap);
    return n;
}
