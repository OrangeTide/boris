#include <stdlib.h>

#include "../runtime/rng.h"

/* rand/srand over the shared fast generator (runtime/rng.c), so a C guest draws
   from the same xoshiro128** that Kobold's std.random Random/RandomBelow use.
   The C contract still holds: the sequence is deterministic, srand(seed) pins
   it, and a program that never calls srand behaves as if srand(1) ran.  So the
   state is seeded to 1 on first use rather than auto-seeded from host entropy
   (that is arc4random's job).  Single threaded, so no locking. */
static struct kp_rng state;
static int           seeded;

int
rand(void)
{
    if (!seeded) {
        kp_rng_seed(&state, 1);
        seeded = 1;
    }
    /* RAND_MAX is 32767, so return the top 15 bits of the 32-bit draw; the high
       bits of xoshiro128** are the well-mixed ones. */
    return (int)(kp_rng_u32(&state) >> 17);
}

void
srand(unsigned seed)
{
    kp_rng_seed(&state, (uint32_t)seed);
    seeded = 1;
}
