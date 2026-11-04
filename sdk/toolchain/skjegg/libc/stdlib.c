#include <stdlib.h>
#include <limits.h>
#include <ctype.h>
#include <errno.h>

int
abs(int n)
{
    return n < 0 ? -n : n;
}

long
labs(long n)
{
    return n < 0 ? -n : n;
}

long long
llabs(long long n)
{
    return n < 0 ? -n : n;
}

div_t
div(int num, int den)
{
    div_t r;
    r.quot = num / den;
    r.rem = num % den;
    return r;
}

ldiv_t
ldiv(long num, long den)
{
    ldiv_t r;
    r.quot = num / den;
    r.rem = num % den;
    return r;
}

/* The shared integer parser behind strtol/strtoul.  Reads an optional sign and
   a base-2..36 (or base-0 auto-detect) numeral, clamping on overflow and
   setting *end to the first unconsumed character. */
static unsigned long
parse_ul(const char *s, char **end, int base, int *neg)
{
    const char *start = s;
    unsigned long acc = 0;
    unsigned long cutoff;
    int cutlim;
    int any = 0;
    int overflow = 0;

    while (isspace((unsigned char)*s))
        s++;

    *neg = 0;
    if (*s == '+' || *s == '-') {
        *neg = (*s == '-');
        s++;
    }

    if ((base == 0 || base == 16) &&
        s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
        s += 2;
        base = 16;
    } else if (base == 0 && s[0] == '0') {
        base = 8;
    } else if (base == 0) {
        base = 10;
    }

    cutoff = ULONG_MAX / (unsigned long)base;
    cutlim = (int)(ULONG_MAX % (unsigned long)base);

    for (;; s++) {
        int c = (unsigned char)*s;
        int d;
        if (c >= '0' && c <= '9')
            d = c - '0';
        else if (c >= 'a' && c <= 'z')
            d = c - 'a' + 10;
        else if (c >= 'A' && c <= 'Z')
            d = c - 'A' + 10;
        else
            break;
        if (d >= base)
            break;
        any = 1;
        if (overflow || acc > cutoff || (acc == cutoff && d > cutlim)) {
            overflow = 1;
            continue;
        }
        acc = acc * (unsigned long)base + (unsigned long)d;
    }

    if (end)
        *end = (char *)(any ? s : start);
    if (overflow)
        *neg = (*neg) ? 2 : 3;      /* signal overflow direction to the caller */
    return acc;
}

long
strtol(const char *s, char **end, int base)
{
    int neg;
    unsigned long v = parse_ul(s, end, base, &neg);
    if (neg == 2) {                 /* negative overflow */
        errno = ERANGE;
        return LONG_MIN;
    }
    if (neg == 3) {                 /* positive overflow */
        errno = ERANGE;
        return LONG_MAX;
    }
    if (neg) {
        if (v > (unsigned long)LONG_MAX + 1u) {
            errno = ERANGE;
            return LONG_MIN;
        }
        return -(long)v;
    }
    if (v > (unsigned long)LONG_MAX) {
        errno = ERANGE;
        return LONG_MAX;
    }
    return (long)v;
}

unsigned long
strtoul(const char *s, char **end, int base)
{
    int neg;
    unsigned long v = parse_ul(s, end, base, &neg);
    if (neg == 2 || neg == 3) {
        errno = ERANGE;
        return ULONG_MAX;
    }
    if (neg)
        return (unsigned long)(-(long)v);
    return v;
}

/* The 64-bit twin of parse_ul, behind strtoll/strtoull. */
static unsigned long long
parse_ull(const char *s, char **end, int base, int *neg)
{
    const char *start = s;
    unsigned long long acc = 0;
    unsigned long long cutoff;
    int cutlim;
    int any = 0;
    int overflow = 0;

    while (isspace((unsigned char)*s))
        s++;

    *neg = 0;
    if (*s == '+' || *s == '-') {
        *neg = (*s == '-');
        s++;
    }

    if ((base == 0 || base == 16) &&
        s[0] == '0' && (s[1] == 'x' || s[1] == 'X')) {
        s += 2;
        base = 16;
    } else if (base == 0 && s[0] == '0') {
        base = 8;
    } else if (base == 0) {
        base = 10;
    }

    cutoff = ULLONG_MAX / (unsigned long long)base;
    cutlim = (int)(ULLONG_MAX % (unsigned long long)base);

    for (;; s++) {
        int c = (unsigned char)*s;
        int d;
        if (c >= '0' && c <= '9')
            d = c - '0';
        else if (c >= 'a' && c <= 'z')
            d = c - 'a' + 10;
        else if (c >= 'A' && c <= 'Z')
            d = c - 'A' + 10;
        else
            break;
        if (d >= base)
            break;
        any = 1;
        if (overflow || acc > cutoff || (acc == cutoff && d > cutlim)) {
            overflow = 1;
            continue;
        }
        acc = acc * (unsigned long long)base + (unsigned long long)d;
    }

    if (end)
        *end = (char *)(any ? s : start);
    if (overflow)
        *neg = (*neg) ? 2 : 3;
    return acc;
}

long long
strtoll(const char *s, char **end, int base)
{
    int neg;
    unsigned long long v = parse_ull(s, end, base, &neg);
    if (neg == 2) {
        errno = ERANGE;
        return LLONG_MIN;
    }
    if (neg == 3) {
        errno = ERANGE;
        return LLONG_MAX;
    }
    if (neg) {
        if (v > (unsigned long long)LLONG_MAX + 1ull) {
            errno = ERANGE;
            return LLONG_MIN;
        }
        return -(long long)v;
    }
    if (v > (unsigned long long)LLONG_MAX) {
        errno = ERANGE;
        return LLONG_MAX;
    }
    return (long long)v;
}

unsigned long long
strtoull(const char *s, char **end, int base)
{
    int neg;
    unsigned long long v = parse_ull(s, end, base, &neg);
    if (neg == 2 || neg == 3) {
        errno = ERANGE;
        return ULLONG_MAX;
    }
    if (neg)
        return (unsigned long long)(-(long long)v);
    return v;
}

int
atoi(const char *s)
{
    return (int)strtol(s, NULL, 10);
}

long
atol(const char *s)
{
    return strtol(s, NULL, 10);
}

void *
bsearch(const void *key, const void *base, size_t n, size_t size,
        int (*cmp)(const void *, const void *))
{
    const unsigned char *b = base;
    size_t lo = 0;
    size_t hi = n;
    while (lo < hi) {
        size_t mid = lo + (hi - lo) / 2;
        const void *p = b + mid * size;
        int c = cmp(key, p);
        if (c < 0)
            hi = mid;
        else if (c > 0)
            lo = mid + 1;
        else
            return (void *)p;
    }
    return NULL;
}

static void
swap_bytes(unsigned char *a, unsigned char *b, size_t size)
{
    while (size--) {
        unsigned char t = *a;
        *a++ = *b;
        *b++ = t;
    }
}

/* Shellsort with the Knuth gap sequence.  No recursion and no scratch buffer
   (elements swap in place byte-wise), so element size need not be known at
   compile time, which the compiler's lack of VLAs would otherwise require. */
void
qsort(void *base, size_t n, size_t size,
      int (*cmp)(const void *, const void *))
{
    unsigned char *b = base;
    size_t gap = 1;

    if (n < 2 || size == 0)
        return;

    while (gap < n / 3)
        gap = gap * 3 + 1;

    for (; gap > 0; gap /= 3) {
        size_t i;
        for (i = gap; i < n; i++) {
            size_t j = i;
            while (j >= gap &&
                   cmp(b + (j - gap) * size, b + j * size) > 0) {
                swap_bytes(b + (j - gap) * size, b + j * size, size);
                j -= gap;
            }
        }
    }
}

/* Ask the host for a symbolized backtrace before terminating.  On RISC-V and
   ColdFire the crt provides __skj_trap_backtrace (the skj-run RV_SYS_FATAL ecall
   / CF_SYS_FATAL trap, a no-op off skj-run); elsewhere there is no such facility
   yet, so a file-local no-op keeps abort portable and control falls through to
   the plain exit below. */
#if defined(__skj_riscv__) || defined(__skj_m68k__)
extern void __skj_trap_backtrace(int code);
#else
static void __skj_trap_backtrace(int code) { (void)code; }
#endif

void
abort(void)
{
    __skj_trap_backtrace(134);      /* under skj-run: backtrace, then exit 134 */
    exit(134);                      /* 128 + SIGABRT, as a kernel would report */
}
