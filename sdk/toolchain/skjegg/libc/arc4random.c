#include <stdlib.h>

#include "../runtime/rng.h"

/* The arc4random family: the C-idiomatic CSPRNG surface, over the same ChaCha20
   keystream (runtime/rng.c) that Kobold's std.random SecureRandom draws from.
   There is no seeding API by contract; the generator seeds itself once from
   host entropy (the getrandom syscall on the shared seam) on first use, so the
   output is unpredictable without the caller managing a seed.  This mirrors the
   freestanding rng_glue.c kp_secure_* path, so the two languages' secure draws
   are the same code.  Single threaded, so no locking.

   getrandom lives on the freestanding syscall seam (syscall_rv.S/syscall_cf.S),
   which the RV32 and ColdFire crts link.  This object is pulled into a link
   only when a program calls arc4random, so a hosted target that never uses it
   needs no getrandom wrapper. */
extern int getrandom(void *buf, int len, unsigned flags);

static struct kp_csprng csprng;
static int              seeded;

static void
ensure_seeded(void)
{
    uint8_t key[32], nonce[12];
    int i;

    if (seeded)
        return;
    /* Fill the key and nonce from host entropy.  If the host has no entropy
       source, fall back to a fixed seed so the generator still runs (degraded,
       not unpredictable), matching kp_secure_bytes. */
    if (getrandom(key, (int)sizeof key, 0) != (int)sizeof key)
        for (i = 0; i < (int)sizeof key; i++)
            key[i] = (uint8_t)(0x9e + i);
    if (getrandom(nonce, (int)sizeof nonce, 0) != (int)sizeof nonce)
        for (i = 0; i < (int)sizeof nonce; i++)
            nonce[i] = (uint8_t)(0x37 + i);
    kp_csprng_seed(&csprng, key, nonce);
    seeded = 1;
}

uint32_t
arc4random(void)
{
    uint32_t v;

    ensure_seeded();
    kp_csprng_bytes(&csprng, (uint8_t *)&v, sizeof v);
    return v;
}

void
arc4random_buf(void *buf, size_t n)
{
    if (buf == NULL || n == 0)
        return;
    ensure_seeded();
    kp_csprng_bytes(&csprng, (uint8_t *)buf, n);
}

uint32_t
arc4random_uniform(uint32_t bound)
{
    uint32_t lim, x;

    if (bound < 2)
        return 0;
    /* Rejection sampling: discard the lowest (2^32 mod bound) outcomes so the
       kept range is an exact multiple of bound, leaving no modulo bias.
       (0 - bound) as unsigned is 2^32 - bound, whose remainder is 2^32 mod bound. */
    lim = (0u - bound) % bound;
    do {
        x = arc4random();
    } while (x < lim);
    return x % bound;
}
