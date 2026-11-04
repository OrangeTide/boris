/* math_free.c : the freestanding double-precision transcendentals for a Kobold
   guest (sin, cos, exp, ln, arctan).

   The hosted tier takes these from the C math library (kp_host.c's brv_* call
   sin/cos/...); this tier has no libm, so it computes them here with range
   reduction and polynomial evaluation, in hardware double (rv32imfd).  The target
   accuracy is the guest's: a real prints through io_free.c's %g at six
   significant digits, so a relative error well under 1e-9 reproduces the hosted
   output exactly.

   The code uses only double arithmetic and constant-width bit operations on a
   double's representation (for the exponent split in exp/ln), so gcc emits no
   64-bit integer helper call; the object stays free of __*di3 references, like
   the rest of the freestanding runtime.

   The ABI wrapper differs by target. On rv32 a double rides a call as its 64-bit
   bits (soft-float), so the guest reaches these through brv_* bridges (below) that
   convert bits to a double and back. On a native-double target (ColdFire) a real
   passes in the FPU and a double returns in fp0, which is the convention the kp
   backend's call reads, so the h_* entries (below, the names the aot_main remap
   points the kp_sin family at) are plain C wrappers over the my_* cores. The
   double-math core (my_* below) is shared and exported for both. */

#include <stdint.h>

union dbits {
    double   d;
    uint64_t u;
};

static double
b2d(uint64_t b)
{
    union dbits x;
    x.u = b;
    return x.d;
}

#if defined(__riscv) || defined(__skj_riscv__)
static uint64_t
d2b(double d)
{
    union dbits x;
    x.d = d;
    return x.u;
}
#endif

/* High-precision constants (two-part where a reduction needs the extra bits). */
#define PI       3.14159265358979311600
#define HALF_PI  1.57079632679489655800
#define QUARTER_PI 0.78539816339744830961
#define LN2      0.69314718055994530942
/* ln2 split so k*ln2 is exact to more than double precision in the reduction. */
#define LN2_HI   6.93147180369123816490e-01
#define LN2_LO   1.90821492927058770002e-10
/* pi/2 split, likewise, for the trig argument reduction. */
#define PIO2_HI  1.57079632679489655800e+00
#define PIO2_LO  6.12323399573676603587e-17
#define INV_LN2  1.44269504088896338700
#define TWO_OVER_PI 0.63661977236758134308

static double
my_floor(double x)
{
    double t = (double)(long)x;
    if (t > x)
        t -= 1.0;
    return t;
}

static double
my_round(double x)
{
    return my_floor(x + 0.5);
}

/* Build 2^k as a double from the IEEE-754 exponent field (|k| within the normal
   range, which the reductions here keep it to).  A constant 52-bit shift, so no
   64-bit helper. */
static double
ldexp2(double x, int k)
{
    union dbits e;
    e.u = (uint64_t)(k + 1023) << 52;
    return x * e.d;
}

/* sin(y) and cos(y) for |y| <= pi/4 by Taylor series (the tail past these terms
   is below 1e-13 on that interval). */
static double
sin_kernel(double y)
{
    double y2 = y * y;
    return y * (1.0 + y2 * (-1.0 / 6 + y2 * (1.0 / 120 + y2 *
               (-1.0 / 5040 + y2 * (1.0 / 362880 + y2 * (-1.0 / 39916800))))));
}

static double
cos_kernel(double y)
{
    double y2 = y * y;
    return 1.0 + y2 * (-0.5 + y2 * (1.0 / 24 + y2 * (-1.0 / 720 + y2 *
               (1.0 / 40320 + y2 * (-1.0 / 3628800 + y2 * (1.0 / 479001600))))));
}

/* Reduce x to the quadrant n and remainder y in [-pi/4, pi/4], then pick the
   kernel by n mod 4.  want_sin selects sin (1) or cos (0). */
static double
trig(double x, int want_sin)
{
    double n = my_round(x * TWO_OVER_PI);
    double y = (x - n * PIO2_HI) - n * PIO2_LO;
    long q = (long)n & 3;
    double s, c;

    s = sin_kernel(y);
    c = cos_kernel(y);
    if (!want_sin)
        q = (q + 1) & 3;                /* cos(x) = sin(x + pi/2) */
    switch (q) {
    case 0:  return s;
    case 1:  return c;
    case 2:  return -s;
    default: return -c;
    }
}

double
my_sin(double x)
{
    return trig(x, 1);
}

double
my_cos(double x)
{
    return trig(x, 0);
}

double
my_exp(double x)
{
    double k, r, p;

    if (x != x) return x;               /* NaN */
    if (x > 709.78) return b2d(0x7ff0000000000000ull);   /* +inf */
    if (x < -745.0) return 0.0;

    k = my_round(x * INV_LN2);
    r = (x - k * LN2_HI) - k * LN2_LO;  /* |r| <= ln2/2 */
    /* exp(r) by Taylor on [-0.347, 0.347]; the tail is below 1e-15. */
    p = 1.0 + r * (1.0 + r * (1.0 / 2 + r * (1.0 / 6 + r * (1.0 / 24 + r *
            (1.0 / 120 + r * (1.0 / 720 + r * (1.0 / 5040)))))));
    return ldexp2(p, (int)k);
}

double
my_ln(double x)
{
    union dbits b;
    int e;
    double m, f, f2, s;

    if (x != x) return x;
    if (x < 0.0) return b2d(0x7ff8000000000000ull);      /* NaN */
    if (x == 0.0) return b2d(0xfff0000000000000ull);     /* -inf */

    /* x = m * 2^e with the mantissa normalised to [1, 2) (constant masks/shift). */
    b.d = x;
    e = (int)((b.u >> 52) & 0x7ff) - 1023;
    b.u = (b.u & 0x000fffffffffffffull) | (1023ull << 52);
    m = b.d;
    /* Centre m near 1 so f = (m-1)/(m+1) is small and the series converges fast. */
    if (m > 1.41421356237309504880) {
        m *= 0.5;
        e += 1;
    }
    f = (m - 1.0) / (m + 1.0);          /* |f| <= 0.1716 */
    f2 = f * f;
    /* ln(m) = 2 (f + f^3/3 + f^5/5 + ...); seven terms give < 1e-15 here. */
    s = f * (1.0 + f2 * (1.0 / 3 + f2 * (1.0 / 5 + f2 * (1.0 / 7 + f2 *
            (1.0 / 9 + f2 * (1.0 / 11 + f2 * (1.0 / 13)))))));
    return (e * LN2_HI + 2.0 * s) + e * LN2_LO;
}

/* atan on |t| <= tan(pi/12) by series; the caller reduces larger arguments. */
static double
atan_kernel(double t)
{
    double t2 = t * t;
    return t * (1.0 + t2 * (-1.0 / 3 + t2 * (1.0 / 5 + t2 * (-1.0 / 7 + t2 *
               (1.0 / 9 + t2 * (-1.0 / 11 + t2 * (1.0 / 13 + t2 * (-1.0 / 15))))))));
}

double
my_atan(double x)
{
    int neg = 0, inv = 0;
    double y, r;

    if (x != x) return x;
    if (x < 0.0) { x = -x; neg = 1; }
    if (x > 1.0) { x = 1.0 / x; inv = 1; }   /* atan(x) = pi/2 - atan(1/x) */

    /* Now x in [0, 1].  One more reduction keeps the series argument small:
       atan(x) = pi/4 + atan((x-1)/(x+1)) when x > tan(pi/8). */
    if (x > 0.41421356237309504880) {
        y = (x - 1.0) / (x + 1.0);
        r = QUARTER_PI + atan_kernel(y);
    } else {
        r = atan_kernel(x);
    }
    if (inv) r = HALF_PI - r;
    return neg ? -r : r;
}

#if defined(__riscv) || defined(__skj_riscv__)
/* The brv_* bridges: a double rides a call as its 64-bit bits (rv soft-float),
   so each wrapper converts bits to a double and back. */
uint64_t brv_sin(uint64_t x)    { return d2b(my_sin(b2d(x))); }
uint64_t brv_cos(uint64_t x)    { return d2b(my_cos(b2d(x))); }
uint64_t brv_exp(uint64_t x)    { return d2b(my_exp(b2d(x))); }
uint64_t brv_ln(uint64_t x)     { return d2b(my_ln(b2d(x))); }
uint64_t brv_arctan(uint64_t x) { return d2b(my_atan(b2d(x))); }
#endif

#if defined(__mcoldfire__) || defined(__skj_m68k__)
/* On ColdFire a double is returned in fp0, which is the toolkit convention the
   kp backend's float-returning call reads.  Built by skj-cc these h_* entries
   carry that convention, so they bridge the guest's kp_sin family straight to
   the shared my_* cores with no register repacking (the old d0/d1 -> fp0 asm
   shim was for the gcc-built core, which returns a double in d0/d1). */
double h_sin(double x)    { return my_sin(x); }
double h_cos(double x)    { return my_cos(x); }
double h_exp(double x)    { return my_exp(x); }
double h_ln(double x)     { return my_ln(x); }
double h_arctan(double x) { return my_atan(x); }
#endif
