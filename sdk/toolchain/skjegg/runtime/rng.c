/* rng.c : splitmix32, xoshiro128** and ChaCha20, the guest generators.
 *
 * Pure code: no syscalls, no libc beyond memcpy-free byte moves done by hand,
 * so it links in the freestanding runtime as well as the hosted tools.  Every
 * operation is 32-bit, so the draw path needs no 64-bit runtime helpers on a
 * 32-bit guest.  The algorithms follow their published references
 * (Blackman/Vigna xoshiro128**, RFC 8439 ChaCha20; splitmix32 is the 32-bit
 * analogue of Steele/Lea SplitMix64 as the seed expander). */

#include "rng.h"

static uint32_t
rotl32(uint32_t x, int k)
{
    return (x << k) | (x >> (32 - k));
}

/****************************************************************
 * splitmix32
 ****************************************************************/

uint32_t
kp_splitmix32(uint32_t *state)
{
    uint32_t z = (*state += 0x9e3779b9u);
    z = (z ^ (z >> 16)) * 0x21f0aaadu;
    z = (z ^ (z >> 15)) * 0x735a2d97u;
    return z ^ (z >> 15);
}

/****************************************************************
 * xoshiro128**
 ****************************************************************/

void
kp_rng_seed(struct kp_rng *r, uint32_t seed)
{
    uint32_t sm = seed;
    int i, all_zero = 1;

    for (i = 0; i < 4; i++) {
        r->s[i] = kp_splitmix32(&sm);
        if (r->s[i] != 0)
            all_zero = 0;
    }
    /* An all-zero state is the one fixed point; splitmix32 will not land four
       zeros in a row, but guard anyway so a hostile seed cannot wedge it. */
    if (all_zero)
        r->s[0] = 0x9e3779b9u;
}

uint32_t
kp_rng_u32(struct kp_rng *r)
{
    uint32_t result = rotl32(r->s[1] * 5, 7) * 9;
    uint32_t t = r->s[1] << 9;

    r->s[2] ^= r->s[0];
    r->s[3] ^= r->s[1];
    r->s[1] ^= r->s[2];
    r->s[0] ^= r->s[3];
    r->s[2] ^= t;
    r->s[3] = rotl32(r->s[3], 11);
    return result;
}

double
kp_rng_real(struct kp_rng *r)
{
    /* A 32-bit draw over 2^32 gives a uniform double in [0, 1); the 32-bit
       numerator is exact in a double's 53-bit mantissa. */
    return (double)kp_rng_u32(r) * (1.0 / 4294967296.0);
}

uint32_t
kp_rng_below(struct kp_rng *r, uint32_t bound)
{
    uint32_t lim, x;

    if (bound == 0)
        return 0;
    /* Rejection sampling: discard the lowest (2^32 mod bound) outcomes so the
       remaining range is an exact multiple of bound, leaving no modulo bias.
       (0 - bound) as unsigned is 2^32 - bound, whose remainder is 2^32 mod bound. */
    lim = (0u - bound) % bound;
    do {
        x = kp_rng_u32(r);
    } while (x < lim);
    return x % bound;
}

/****************************************************************
 * ChaCha20 (RFC 8439)
 ****************************************************************/

static uint32_t
rd32le(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8)
         | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

static void
wr32le(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

#define QR(a, b, c, d)                          \
    do {                                        \
        a += b; d ^= a; d = rotl32(d, 16);      \
        c += d; b ^= c; b = rotl32(b, 12);      \
        a += b; d ^= a; d = rotl32(d, 8);       \
        c += d; b ^= c; b = rotl32(b, 7);       \
    } while (0)

/* Produce one 64-byte keystream block from the state and bump the counter. */
static void
chacha20_block(struct kp_csprng *c)
{
    uint32_t w[16];
    int i;

    for (i = 0; i < 16; i++)
        w[i] = c->state[i];

    for (i = 0; i < 10; i++) {          /* 20 rounds = 10 column + diagonal */
        QR(w[0], w[4], w[8],  w[12]);
        QR(w[1], w[5], w[9],  w[13]);
        QR(w[2], w[6], w[10], w[14]);
        QR(w[3], w[7], w[11], w[15]);
        QR(w[0], w[5], w[10], w[15]);
        QR(w[1], w[6], w[11], w[12]);
        QR(w[2], w[7], w[8],  w[13]);
        QR(w[3], w[4], w[9],  w[14]);
    }

    for (i = 0; i < 16; i++)
        wr32le(c->block + i * 4, w[i] + c->state[i]);

    if (++c->state[12] == 0)            /* 32-bit counter, carry into the nonce */
        c->state[13]++;
    c->avail = 64;
}

void
kp_csprng_seed(struct kp_csprng *c, const uint8_t key[32],
               const uint8_t nonce[12])
{
    int i;

    c->state[0] = 0x61707865u;          /* "expand 32-byte k" */
    c->state[1] = 0x3320646eu;
    c->state[2] = 0x79622d32u;
    c->state[3] = 0x6b206574u;
    for (i = 0; i < 8; i++)
        c->state[4 + i] = rd32le(key + i * 4);
    c->state[12] = 0;                   /* block counter */
    for (i = 0; i < 3; i++)
        c->state[13 + i] = rd32le(nonce + i * 4);
    c->avail = 0;
}

void
kp_csprng_bytes(struct kp_csprng *c, uint8_t *out, size_t n)
{
    size_t i;

    for (i = 0; i < n; i++) {
        if (c->avail == 0)
            chacha20_block(c);
        out[i] = c->block[64 - c->avail];
        c->avail--;
    }
}
