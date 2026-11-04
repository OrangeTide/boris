/* rng_glue.c : the guest-facing Random / clock entry points.
 *
 * Thin glue over rng.c and the syscall seam: it holds one fast generator and
 * one CSPRNG for the whole guest, seeds them from host entropy (getrandom),
 * and reads the monotonic clock (clock_gettime).  A guest reaches these through
 * the FFI (`external cdecl`), the way ReadFileStr is reached; a shipped unit
 * will later wrap them so user code calls Random / Randomize / Now / Now /
 * SecureRandom without writing the declarations.  The fast path auto-seeds from
 * entropy on first use, so Random differs each run, while kp_random_seed pins a
 * reproducible sequence and kp_randomize draws fresh entropy on demand. */

#if defined(KP_GLUE_HOSTED)
/* Expose the POSIX monotonic clock from <time.h> under the strict-C99 build;
   must precede every system header. */
#  if defined(__APPLE__)
#    define _DARWIN_C_SOURCE 1
#  else
#    ifndef _DEFAULT_SOURCE
#      define _DEFAULT_SOURCE 1
#    endif
#    ifndef _POSIX_C_SOURCE
#      define _POSIX_C_SOURCE 200809L
#    endif
#  endif
#endif

#include "rng.h"

#include <stddef.h>
#include <stdint.h>

/* The platform seam, isolated to two helpers: filling a small buffer with host
   entropy and reading the monotonic clock in milliseconds.  A hosted build (the
   in-process JIT and the native AOT runtime libkpaot.a) uses the host libc,
   whose timespec has pointer-width fields on an LP64 host and whose getentropy
   takes a size_t.  The freestanding tiers (rv/cf, boris) use the 32-bit syscall
   seam below, unchanged. */
#if defined(KP_GLUE_HOSTED)

#include <time.h>

extern int getentropy(void *buf, size_t buflen);

static int
glue_fill_entropy(void *buf, int len)
{
    return getentropy(buf, (size_t)len) == 0;
}

static long long
glue_now_ms(void)
{
    struct timespec ts;

    if (clock_gettime(CLOCK_MONOTONIC, &ts) != 0)
        return 0;
    return (long long)ts.tv_sec * 1000 + (long long)ts.tv_nsec / 1000000;
}

#else

/* The syscall seam (syscall_rv.S / syscall_cf.S), the same wrappers libc and
   the Kobold freestanding runtime link. */
extern int getrandom(void *buf, int len, unsigned flags);
extern int clock_gettime(int clk_id, void *ts);

static int
glue_fill_entropy(void *buf, int len)
{
    return getrandom(buf, len, 0) == len;
}

static long long
glue_now_ms(void)
{
    int32_t ts[2] = { 0, 0 };           /* {tv_sec, tv_nsec}, the 32-bit seam */

    if (clock_gettime(1, ts) != 0)      /* 1 = monotonic */
        return 0;
    return (long long)ts[0] * 1000 + (long long)ts[1] / 1000000;
}

#endif

static struct kp_rng    g_rng;
static struct kp_csprng g_csprng;
static int              g_rng_seeded;
static int              g_csprng_seeded;

/* Draw a 32-bit seed from host entropy; fall back to a fixed constant if the
   host has no entropy source (so the generator still runs, just not unpredictably). */
static uint32_t
entropy_seed(void)
{
    uint32_t seed = 0x9e3779b9u;
    uint8_t b[4];

    if (glue_fill_entropy(b, (int)sizeof b))
        seed = (uint32_t)b[0] | ((uint32_t)b[1] << 8)
             | ((uint32_t)b[2] << 16) | ((uint32_t)b[3] << 24);
    return seed;
}

static void
ensure_rng(void)
{
    if (!g_rng_seeded) {
        kp_rng_seed(&g_rng, entropy_seed());
        g_rng_seeded = 1;
    }
}

/* Pin a reproducible sequence (Pascal's RandSeed).  The seed is one 32-bit
   word, so it crosses the FFI as a plain Integer (no 64-bit argument shape). */
void
kp_random_seed(int seed)
{
    kp_rng_seed(&g_rng, (uint32_t)seed);
    g_rng_seeded = 1;
}

/* Reseed the fast generator from fresh host entropy (Pascal's Randomize). */
void
kp_randomize(void)
{
    kp_rng_seed(&g_rng, entropy_seed());
    g_rng_seeded = 1;
}

/* Uniform real in [0, 1). */
double
kp_random_real(void)
{
    ensure_rng();
    return kp_rng_real(&g_rng);
}

/* Uniform integer in [0, bound); 0 when bound <= 0.  int (not long) so it is a
   32-bit value on every tier, matching a Kobold Integer across the cdecl FFI. */
int
kp_random_below(int bound)
{
    ensure_rng();
    if (bound <= 0)
        return 0;
    return (int)kp_rng_below(&g_rng, (uint32_t)bound);
}

/* Cryptographic random bytes.  The CSPRNG seeds once from host entropy (a
   32-byte key and a 12-byte nonce), distinct from the fast generator. */
void
kp_secure_bytes(void *buf, long n)
{
    if (n <= 0 || buf == NULL)
        return;
    if (!g_csprng_seeded) {
        uint8_t key[32], nonce[12];

        if (!glue_fill_entropy(key, (int)sizeof key))
            kp_rng_seed(&g_rng, g_rng.s[0]);    /* no entropy: still proceed */
        (void)glue_fill_entropy(nonce, (int)sizeof nonce);
        kp_csprng_seed(&g_csprng, key, nonce);
        g_csprng_seeded = 1;
    }
    kp_csprng_bytes(&g_csprng, (uint8_t *)buf, (size_t)n);
}

/* A cryptographically secure uniform integer in [0, bound); 0 when bound <= 0.
 * Draws 32-bit words from the CSPRNG (over kp_secure_bytes, which seeds it on
 * first use) and rejection-samples to the largest multiple of bound that fits a
 * uint32, so the result is unbiased.  int in and out, a 32-bit value on every
 * tier, matching a Kobold Integer across the cdecl FFI. */
int
kp_secure_below(int bound)
{
    uint32_t b, limit, r;

    if (bound <= 0)
        return 0;
    b = (uint32_t)bound;
    limit = (uint32_t)(0x100000000ull - (0x100000000ull % b)); /* 0 means no reject */
    do {
        kp_secure_bytes(&r, (long)sizeof r);
    } while (limit != 0 && r >= limit);
    return (int)(r % b);
}

/* Monotonic milliseconds (Pascal's GetTickCount / a tick clock). */
long long
kp_now_ms(void)
{
    return glue_now_ms();
}
