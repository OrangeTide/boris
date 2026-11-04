/* numfmt.c : the libgcc-free number formatters shared by the C libc printf
   path and the Kobold freestanding runtime (kobold/io_free.c).

   Two formatters live here, factored out of the two copies that used to exist
   (libc/printf.c's float path and io_free.c's hand-rolled fmt_g / itoa):

   - __fmt_udec writes an unsigned value's decimal digits.  It divides by ten
     with constant 16-bit shifts and 32-bit divides, so it needs no 64-bit
     divide helper (__udivdi3) at all.

   - __fmt_greal renders a finite, non-negative double the way C's "%g" does:
     `sig` significant digits, fixed notation when the decimal exponent is in
     [-4, sig) and scientific otherwise, trailing fraction zeros stripped unless
     `alt`.  It extracts digits one at a time with double-to-int (not
     double-to-u64) steps, so it pulls no libgcc double-to-u64 conversion
     (__fixunsdfdi), which the rv32 freestanding tier has no libgcc for.  The C
     libc's %f and %e still use printf.c's own decomposition; only the %g path
     and the Kobold real output share this one.

   The sign, and the NaN / infinity spellings, stay with each caller: printf.c
   handles them before the conversion dispatch, and io_free.c's real output
   wraps this with its own sign and "nan".  __fmt_greal takes a value that is
   already non-negative and finite, and returns the magnitude text only. */

#include <stdint.h>

#include "fmt.h"

/* Divide *n by 10 returning the remainder, in 16-bit-at-a-time 32-bit divides
   (MSB first), so no 64-bit libgcc divide helper is pulled. */
static uint32_t
divmod10(uint64_t *n)
{
    uint64_t v = *n, q = 0;
    uint32_t rem = 0, cur;

    cur = (rem << 16) | (uint32_t)((v >> 48) & 0xFFFF); q = (q << 16) | (cur / 10u); rem = cur % 10u;
    cur = (rem << 16) | (uint32_t)((v >> 32) & 0xFFFF); q = (q << 16) | (cur / 10u); rem = cur % 10u;
    cur = (rem << 16) | (uint32_t)((v >> 16) & 0xFFFF); q = (q << 16) | (cur / 10u); rem = cur % 10u;
    cur = (rem << 16) | (uint32_t)(v & 0xFFFF);         q = (q << 16) | (cur / 10u); rem = cur % 10u;
    *n = q;
    return rem;
}

/* Write v's decimal digits to out (most significant first, no NUL, no sign),
   returning the number of digits written.  Zero writes a single '0'. */
int
__fmt_udec(char *out, uint64_t v)
{
    char tmp[20];                   /* 2^64 is 20 decimal digits */
    int n = 0, i;

    do {
        tmp[n++] = (char)('0' + (int)divmod10(&v));
    } while (v);
    for (i = 0; i < n; i++)
        out[i] = tmp[n - 1 - i];
    return n;
}

/* The widest significand this renders: a double resolves about 17 significant
   decimal digits, so clamp `sig` there (printf permits a larger precision, but
   the extra digits would be noise). */
#define GREAL_MAXSIG 17

/* Render a finite, non-negative double like C's "%g": `sig` significant digits
   (at least one), fixed notation when the decimal exponent lies in [-4, sig)
   and scientific otherwise, with `upper` selecting 'E' over 'e' in the
   exponent.  Trailing fraction zeros and a bare decimal point are stripped
   unless `alt` is set (C's '#' flag), which keeps the full significant width.
   Returns the number of bytes written to out (no NUL). */
int
__fmt_greal(char *out, double v, int sig, int alt, int upper)
{
    int dig[GREAL_MAXSIG + 1];
    int n = 0, exp10 = 0, i, last, nd;
    double m;

    if (sig < 1)
        sig = 1;
    if (sig > GREAL_MAXSIG)
        sig = GREAL_MAXSIG;
    nd = sig;

    if (v == 0.0) {
        out[n++] = '0';
        if (alt && nd > 1) {
            out[n++] = '.';
            for (i = 1; i < nd; i++)
                out[n++] = '0';
        }
        return n;
    }

    /* Normalise the magnitude to [1, 10) and count the decimal exponent. */
    m = v;
    while (m >= 10.0) { m /= 10.0; exp10++; }
    while (m < 1.0)   { m *= 10.0; exp10--; }

    /* Extract nd significant digits, each a double-to-int step, then round to
       the nd-th using the following digit (half away from zero). */
    for (i = 0; i < nd; i++) {
        int d = (int)m;
        if (d < 0) d = 0;
        else if (d > 9) d = 9;
        dig[i] = d;
        m = (m - d) * 10.0;
    }
    if ((int)m >= 5) {                      /* round the last kept digit up */
        i = nd - 1;
        while (i >= 0 && ++dig[i] == 10) { dig[i] = 0; i--; }
        if (i < 0) {                        /* carry past the top: 9.99..->10 */
            for (i = nd - 1; i > 0; i--)
                dig[i] = dig[i - 1];
            dig[0] = 1;
            exp10++;
        }
    }

    if (exp10 < -4 || exp10 >= nd) {        /* scientific */
        out[n++] = (char)('0' + dig[0]);
        last = nd - 1;
        if (!alt)
            while (last > 0 && dig[last] == 0) last--;
        if (alt || last >= 1) {             /* alt keeps the point and all digits */
            out[n++] = '.';
            for (i = 1; i <= last; i++) out[n++] = (char)('0' + dig[i]);
        }
        out[n++] = upper ? 'E' : 'e';
        out[n++] = exp10 < 0 ? '-' : '+';
        {
            int e = exp10 < 0 ? -exp10 : exp10;
            if (e >= 100) { out[n++] = (char)('0' + e / 100); e %= 100; }
            out[n++] = (char)('0' + e / 10);
            out[n++] = (char)('0' + e % 10);
        }
    } else if (exp10 >= 0) {                /* fixed, integer part present */
        for (i = 0; i <= exp10; i++) out[n++] = (char)('0' + dig[i]);
        last = nd - 1;
        if (!alt)
            while (last > exp10 && dig[last] == 0) last--;
        if (alt || last > exp10) {          /* alt keeps the point and all digits */
            out[n++] = '.';
            for (i = exp10 + 1; i <= last; i++) out[n++] = (char)('0' + dig[i]);
        }
    } else {                                /* fixed, 0.00ddd */
        last = nd - 1;
        if (!alt)
            while (last > 0 && dig[last] == 0) last--;
        out[n++] = '0';
        out[n++] = '.';
        for (i = 0; i < (-exp10 - 1); i++) out[n++] = '0';
        for (i = 0; i <= last; i++) out[n++] = (char)('0' + dig[i]);
    }
    return n;
}
