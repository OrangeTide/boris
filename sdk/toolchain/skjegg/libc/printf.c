#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>
#include "fmt.h"

/* The shared formatting engine (used by snprintf here and by the printf family
   in stdio.c).  Supported conversions are c, s, d, i, u, o, x, X, p, and %%,
   with the flags - + space 0 #, a field width, a precision, and the length
   modifiers hh h l ll z t j.  The floating conversions f F e E g G (a A render
   as e E, since a hex float would need its own path) are a compile-time option:
   they are compiled only when SKJ_LIBC_FLOAT is defined, so a target that does
   not want double arithmetic in the link gets an integer-only formatter.  When
   the option is off, a float conversion is echoed verbatim like an unknown one.
   The decomposition is done in plain double arithmetic with no libm, accurate
   to the digits a double carries.  Return value is the number of characters
   that would have been written, C99-style, regardless of truncation. */

#define FL_LEFT  1
#define FL_ZERO  2
#define FL_PLUS  4
#define FL_SPACE 8
#define FL_ALT   16

static void
emit(struct __sink *s, char c)
{
    s->put(s, c);
}

static void
emit_pad(struct __sink *s, char c, int n)
{
    while (n-- > 0)
        emit(s, c);
}

static void
fmt_number(struct __sink *s, unsigned long long val, int base, int upper,
           int neg, int flags, int width, int prec)
{
    char digits[24];            /* 64-bit octal is at most 22 digits */
    const char *alpha = upper ? "0123456789ABCDEF" : "0123456789abcdef";
    int ndig = 0;
    char sign = 0;
    char prefix[2];
    int nprefix = 0;
    int zeros, len, pad;

    if (neg)
        sign = '-';
    else if (flags & FL_PLUS)
        sign = '+';
    else if (flags & FL_SPACE)
        sign = ' ';

    do {
        digits[ndig++] = alpha[val % (unsigned long long)base];
        val /= (unsigned long long)base;
    } while (val);

    if (flags & FL_ALT) {
        if (base == 8 && digits[ndig - 1] != '0')
            prefix[nprefix++] = '0';
        else if (base == 16) {
            prefix[nprefix++] = '0';
            prefix[nprefix++] = upper ? 'X' : 'x';
        }
    }

    /* precision sets a minimum digit count and disables zero-padding */
    zeros = 0;
    if (prec >= 0) {
        if (prec > ndig)
            zeros = prec - ndig;
    } else if ((flags & FL_ZERO) && !(flags & FL_LEFT)) {
        int body = ndig + (sign ? 1 : 0) + nprefix;
        if (width > body)
            zeros = width - body;
    }

    len = ndig + zeros + nprefix + (sign ? 1 : 0);
    pad = width > len ? width - len : 0;

    if (!(flags & FL_LEFT))
        emit_pad(s, ' ', pad);
    if (sign)
        emit(s, sign);
    {
        int i;
        for (i = 0; i < nprefix; i++)
            emit(s, prefix[i]);
    }
    emit_pad(s, '0', zeros);
    while (ndig > 0)
        emit(s, digits[--ndig]);
    if (flags & FL_LEFT)
        emit_pad(s, ' ', pad);
}

static void
fmt_str(struct __sink *s, const char *str, int flags, int width, int prec)
{
    int len = 0;
    int pad;
    if (!str)
        str = "(null)";
    while (str[len] && (prec < 0 || len < prec))
        len++;
    pad = width > len ? width - len : 0;
    if (!(flags & FL_LEFT))
        emit_pad(s, ' ', pad);
    {
        int i;
        for (i = 0; i < len; i++)
            emit(s, str[i]);
    }
    if (flags & FL_LEFT)
        emit_pad(s, ' ', pad);
}

#ifdef SKJ_LIBC_FLOAT

/* Append the decimal digits of an unsigned integer to buf (not NUL
   terminated), returning the new length.  Used for the %f integer part; the
   digits come from the shared libgcc-free __fmt_udec (numfmt.c). */
static int
put_uint(char *buf, int nb, unsigned long long v)
{
    return nb + __fmt_udec(buf + nb, v);
}

/* Render a finite double in fixed notation into buf: the integer part, then
   `prec` fraction digits (a decimal point when prec>0 or FL_ALT).  v must be
   non-negative and small enough that its integer part fits in u64 (the caller
   routes larger magnitudes through the scientific path).  Returns the new
   length. */
static int
build_fixed(char *buf, int nb, double v, int prec, int flags)
{
    double r = 0.5;
    double frac;
    unsigned long long ip;
    int k;

    for (k = 0; k < prec; k++)      /* round to prec fraction digits */
        r *= 0.1;
    v += r;

    ip = (unsigned long long)v;
    frac = v - (double)ip;
    nb = put_uint(buf, nb, ip);
    if (prec > 0 || (flags & FL_ALT))
        buf[nb++] = '.';
    for (k = 0; k < prec; k++) {
        int d;
        frac *= 10.0;
        d = (int)frac;
        if (d < 0) d = 0;
        else if (d > 9) d = 9;
        buf[nb++] = (char)('0' + d);
        frac -= d;
    }
    return nb;
}

/* Render a double in scientific notation into buf: one leading digit, `prec`
   fraction digits, then e/E, a sign, and at least two exponent digits.  v must
   be non-negative.  Returns the new length. */
static int
build_sci(char *buf, int nb, double v, int prec, int flags, int upper)
{
    double r = 0.5;
    int exp = 0;
    int k, d, e, ne;
    char eb[8];

    if (v != 0.0) {                 /* normalize mantissa into [1, 10) */
        while (v >= 10.0) { v /= 10.0; exp++; }
        while (v < 1.0)   { v *= 10.0; exp--; }
    }
    for (k = 0; k < prec; k++)      /* round to prec fraction digits */
        r *= 0.1;
    v += r;
    if (v >= 10.0) { v /= 10.0; exp++; }    /* a carry out of the leading digit */

    d = (int)v;
    if (d < 0) d = 0;
    else if (d > 9) d = 9;
    buf[nb++] = (char)('0' + d);
    v -= d;
    if (prec > 0 || (flags & FL_ALT))
        buf[nb++] = '.';
    for (k = 0; k < prec; k++) {
        v *= 10.0;
        d = (int)v;
        if (d < 0) d = 0;
        else if (d > 9) d = 9;
        buf[nb++] = (char)('0' + d);
        v -= d;
    }

    buf[nb++] = upper ? 'E' : 'e';
    buf[nb++] = exp < 0 ? '-' : '+';
    e = exp < 0 ? -exp : exp;
    ne = 0;
    do {
        eb[ne++] = (char)('0' + e % 10);
        e /= 10;
    } while (e);
    while (ne < 2)
        eb[ne++] = '0';
    while (ne > 0)
        buf[nb++] = eb[--ne];
    return nb;
}

/* Floating conversions f/e/g (upper set for F/E/G).  No libm: the magnitude is
   decomposed with plain double arithmetic, so the result is exact to about 15
   significant digits; past that an exact-decimal formatter (glibc) can differ
   in the last place, which is adequate for this library's scope.  a/A route
   here too and
   render as e/E (a hex float would need its own path).  Rounding is
   half-away-from-zero, not the round-half-to-even glibc uses, so an exact tie
   at the last printed digit (for example %.0f of 2.5) can differ by one in the
   last place.  Such ties are rare in real values. */
static void
fmt_float(struct __sink *s, double v, int conv, int upper, int flags,
          int width, int prec)
{
    union { double d; unsigned long long u; } pun;
    char body[512];
    int nb = 0;
    char sign = 0;
    int neg, special = 0;
    int i, total, pad;

    if (prec < 0)
        prec = 6;
    if (prec > 400)             /* keep the integer+fraction body within body[] */
        prec = 400;

    /* Read the sign bit directly so negative zero keeps its sign, as C
       requires, without a trapping compare or a division.  Bit 63 of the u64
       alias is the IEEE sign bit on both byte orders. */
    pun.d = v;
    neg = (int)(pun.u >> 63);
    if (neg) v = -v;
    if (neg) sign = '-';
    else if (flags & FL_PLUS) sign = '+';
    else if (flags & FL_SPACE) sign = ' ';

    if (v != v) {                           /* NaN: no sign */
        const char *t = upper ? "NAN" : "nan";
        for (i = 0; t[i]; i++) body[nb++] = t[i];
        sign = 0;
        special = 1;
    } else if (v > 0.0 && v + v == v) {     /* Inf */
        const char *t = upper ? "INF" : "inf";
        for (i = 0; t[i]; i++) body[nb++] = t[i];
        special = 1;
    } else if (conv == 'g') {
        /* %g shares the libgcc-free renderer in numfmt.c with the Kobold
           freestanding runtime (sig digits, fixed-vs-scientific by exponent,
           trailing zeros stripped unless '#').  %f and %e keep the
           decomposition below, which is hosted-libc only. */
        nb = __fmt_greal(body, v, prec == 0 ? 1 : prec, flags & FL_ALT, upper);
    } else if (conv == 'f') {
        if (v >= 18446744073709551615.0)     /* integer part exceeds u64 */
            nb = build_sci(body, nb, v, prec, flags, upper);
        else
            nb = build_fixed(body, nb, v, prec, flags);
    } else {                                /* 'e', and a/A fall through here */
        nb = build_sci(body, nb, v, prec, flags, upper);
    }

    total = nb + (sign ? 1 : 0);
    pad = width > total ? width - total : 0;

    if (!(flags & FL_LEFT)) {
        if ((flags & FL_ZERO) && !special) {
            if (sign) emit(s, sign);
            emit_pad(s, '0', pad);
        } else {
            emit_pad(s, ' ', pad);
            if (sign) emit(s, sign);
        }
        for (i = 0; i < nb; i++) emit(s, body[i]);
    } else {
        if (sign) emit(s, sign);
        for (i = 0; i < nb; i++) emit(s, body[i]);
        emit_pad(s, ' ', pad);
    }
}

#endif /* SKJ_LIBC_FLOAT */

int
__vformat(struct __sink *s, const char *fmt, va_list ap)
{
    for (; *fmt; fmt++) {
        int flags = 0;
        int width = 0;
        int prec = -1;
        int lng = 0;            /* 0 int, 1 long, 2 long long */
        const char *spec;

        if (*fmt != '%') {
            emit(s, *fmt);
            continue;
        }
        spec = fmt++;

        for (;; fmt++) {
            if (*fmt == '-') flags |= FL_LEFT;
            else if (*fmt == '0') flags |= FL_ZERO;
            else if (*fmt == '+') flags |= FL_PLUS;
            else if (*fmt == ' ') flags |= FL_SPACE;
            else if (*fmt == '#') flags |= FL_ALT;
            else break;
        }

        if (*fmt == '*') {
            width = va_arg(ap, int);
            if (width < 0) {
                flags |= FL_LEFT;
                width = -width;
            }
            fmt++;
        } else {
            while (*fmt >= '0' && *fmt <= '9')
                width = width * 10 + (*fmt++ - '0');
        }

        if (*fmt == '.') {
            fmt++;
            if (*fmt == '*') {
                prec = va_arg(ap, int);
                fmt++;
            } else {
                prec = 0;
                while (*fmt >= '0' && *fmt <= '9')
                    prec = prec * 10 + (*fmt++ - '0');
            }
            if (prec < 0)
                prec = -1;
        }

        if (*fmt == 'h') {
            fmt++;
            if (*fmt == 'h')
                fmt++;
        } else if (*fmt == 'l') {
            lng = 1;
            fmt++;
            if (*fmt == 'l') {
                lng = 2;
                fmt++;
            }
        } else if (*fmt == 'z' || *fmt == 't') {
            lng = (sizeof(long) == sizeof(long long)) ? 2 : 1;
            fmt++;
        } else if (*fmt == 'j') {
            lng = 2;
            fmt++;
        }

        switch (*fmt) {
        case 'd':
        case 'i': {
            long long v;
            int neg;
            unsigned long long mag;
            if (lng == 2) v = va_arg(ap, long long);
            else if (lng == 1) v = va_arg(ap, long);
            else v = va_arg(ap, int);
            neg = v < 0;
            /* -(INT/LLONG)MIN overflows, so form the magnitude from -(v+1)+1.
               Written as if/else rather than ?: deliberately. */
            if (neg)
                mag = (unsigned long long)(-(v + 1)) + 1ull;
            else
                mag = (unsigned long long)v;
            fmt_number(s, mag, 10, 0, neg, flags, width, prec);
            break;
        }
        case 'u':
        case 'o':
        case 'x':
        case 'X': {
            unsigned long long v;
            int base = (*fmt == 'o') ? 8 : (*fmt == 'u') ? 10 : 16;
            int upper = (*fmt == 'X');
            if (lng == 2) v = va_arg(ap, unsigned long long);
            else if (lng == 1) v = va_arg(ap, unsigned long);
            else v = va_arg(ap, unsigned int);
            fmt_number(s, v, base, upper, 0, flags, width, prec);
            break;
        }
        case 'p': {
            void *v = va_arg(ap, void *);
            if (!v) {
                fmt_str(s, "(nil)", flags, width, -1);
            } else {
                fmt_number(s, (unsigned long long)(uintptr_t)v, 16, 0, 0,
                           flags | FL_ALT, width, prec);
            }
            break;
        }
        case 'c': {
            int v = va_arg(ap, int);
            char ch = (char)v;
            int pad = width > 1 ? width - 1 : 0;
            if (!(flags & FL_LEFT))
                emit_pad(s, ' ', pad);
            emit(s, ch);
            if (flags & FL_LEFT)
                emit_pad(s, ' ', pad);
            break;
        }
        case 's':
            fmt_str(s, va_arg(ap, const char *), flags, width, prec);
            break;
        case '%':
            emit(s, '%');
            break;
#ifdef SKJ_LIBC_FLOAT
        case 'f': case 'F': case 'e': case 'E':
        case 'g': case 'G': case 'a': case 'A': {
            double v = va_arg(ap, double);
            int upper = (*fmt >= 'A' && *fmt <= 'Z');
            int conv = upper ? (*fmt - 'A' + 'a') : *fmt;
            fmt_float(s, v, conv, upper, flags, width, prec);
            break;
        }
#endif
        default:
            /* unknown or truncated spec: echo verbatim from the % */
            {
                const char *p;
                for (p = spec; p <= fmt && *p; p++)
                    emit(s, *p);
                if (*fmt == '\0')
                    fmt--;      /* the loop's fmt++ must not pass the NUL */
            }
            break;
        }
    }

    return (int)s->count;
}

/* The memory sink behind snprintf: store each character while it fits, and
   count every one so the C99 return value is the length that would be
   produced.  The base __sink is first, so the engine's pointer casts here. */
struct mem_sink {
    struct __sink base;
    char  *dst;
    size_t cap;         /* total buffer size, including the NUL slot */
};

static void
mem_put(struct __sink *s, char c)
{
    struct mem_sink *m = (struct mem_sink *)s;
    if (s->count + 1 < m->cap)
        m->dst[s->count] = c;
    s->count++;
}

int
vsnprintf(char *buf, size_t size, const char *fmt, va_list ap)
{
    struct mem_sink m;
    m.base.put = mem_put;
    m.base.count = 0;
    m.dst = buf;
    m.cap = size;

    __vformat(&m.base, fmt, ap);

    if (size > 0) {
        size_t end = m.base.count < size - 1 ? m.base.count : size - 1;
        buf[end] = '\0';
    }
    return (int)m.base.count;
}

int
snprintf(char *buf, size_t size, const char *fmt, ...)
{
    va_list ap;
    int n;
    va_start(ap, fmt);
    n = vsnprintf(buf, size, fmt, ap);
    va_end(ap);
    return n;
}

int
vsprintf(char *buf, const char *fmt, va_list ap)
{
    return vsnprintf(buf, (size_t)-1, fmt, ap);
}

int
sprintf(char *buf, const char *fmt, ...)
{
    va_list ap;
    int n;
    va_start(ap, fmt);
    n = vsnprintf(buf, (size_t)-1, fmt, ap);
    va_end(ap);
    return n;
}
