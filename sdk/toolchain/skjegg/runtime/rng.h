/* rng.h : the guest random generators, pure and seed-driven.
 *
 * No syscalls and no libc: a caller seeds a generator (from host entropy via
 * getrandom, or a fixed seed for a reproducible run) and draws from it.  Two
 * generators share this file: a fast general-purpose one (splitmix32 seeding
 * xoshiro128**) for gameplay and sampling, and a cryptographic one (ChaCha20)
 * for values an adversary must not predict.  They are not interchangeable; a
 * caller picks by intent.  Both languages' runtimes build their Random /
 * SecureRandom on these, so the generators live in the shared freestanding
 * layer.
 *
 * Both generators are 32-bit: every operation is on a 32-bit word, so the draw
 * path needs no 64-bit runtime helpers on a 32-bit guest (rv32, ColdFire).
 * xoshiro128** is the 32-bit member of the xoshiro family (state is four 32-bit
 * words), not the look-alike 64-bit xoroshiro128**. */

#ifndef KP_RNG_H
#define KP_RNG_H

#include <stddef.h>
#include <stdint.h>

/* splitmix32: advances *state and returns one well-mixed 32-bit value.  It is
 * the seed expander xoshiro needs (a single seed word must not become a sparse
 * state), and a serviceable generator on its own. */
uint32_t kp_splitmix32(uint32_t *state);

/* xoshiro128**: the fast generator.  128-bit state in four 32-bit words. */
struct kp_rng {
    uint32_t s[4];
};

/* Seed the generator from one 32-bit value (expanded through splitmix32, so
 * even seed 0 gives a well-mixed state). */
void     kp_rng_seed(struct kp_rng *r, uint32_t seed);
uint32_t kp_rng_u32(struct kp_rng *r);
double   kp_rng_real(struct kp_rng *r);                  /* uniform in [0, 1) */
uint32_t kp_rng_below(struct kp_rng *r, uint32_t bound); /* uniform in [0, bound); 0 if bound==0 */

/* ChaCha20 CSPRNG: the 20-round keystream is the random output (no plaintext).
 * Seed from a 32-byte key and a 12-byte nonce (both from host entropy); the
 * block counter starts at 0 and the keystream is drawn a block at a time. */
struct kp_csprng {
    uint32_t state[16];
    uint8_t  block[64];
    int      avail;             /* unused keystream bytes left in block */
};

void kp_csprng_seed(struct kp_csprng *c, const uint8_t key[32],
                    const uint8_t nonce[12]);
void kp_csprng_bytes(struct kp_csprng *c, uint8_t *out, size_t n);

#endif /* KP_RNG_H */
