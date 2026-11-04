/* soft64.c : 64-bit integer helpers built from 32-bit limbs.
 *
 * Two targets need these rather than the toolchain's. The cross
 * toolchain ships no rv32 multilib either, so a freestanding RISC-V
 * link has no libgcc at all to draw on; compiled here by gcc, these
 * carry the platform ABI, which is what the psABI build of the RV
 * backend and a gcc-built runtime both call with.
 *
 * The ColdFire case: -lgcc's __muldi3
 * family is 68020 code: the two-register mulu.l %dh:%dl and divul.l
 * pair forms ColdFire lacks, which a strict host (smolmoo's emulator,
 * real silicon) faults on. These C implementations compile at
 * -mcpu=5475, so their code is ColdFire-legal by construction, and the
 * smolmoo link uses them instead of -lgcc entirely: a helper this file
 * does not provide becomes a link error, never silently-imported 68020
 * code.
 *
 * Written so gcc emits no helper calls of its own: 32-bit limbs,
 * 16-bit limb products, constant shifts only, and no 64-bit multiply
 * or divide operators anywhere inside (the build checks the object has
 * no undefined __*di3 symbols).
 *
 * Division by zero returns 0: callers check the divisor first (the
 * language's divide-by-zero fault fires above this level).
 *
 */

typedef unsigned int u32;
typedef unsigned long long u64;
typedef long long s64;

u64 __muldi3(u64 a, u64 b);
u64 __udivdi3(u64 n, u64 d);
u64 __umoddi3(u64 n, u64 d);
s64 __divdi3(s64 n, s64 d);
s64 __moddi3(s64 n, s64 d);

/* The multiply and the variable shifts are guarded so a consumer that supplies
 * them from elsewhere can drop them and keep only the divide family.  The RISC-V
 * backend emits a stack-ABI __muldi3 and shift family (served by a separate alias
 * into jit/rv_jit_i64.S), so the freestanding Kobold archive builds this file with
 * -DSOFT64_NO_MULSHIFT and takes only the register-ABI __divdi3 family here.  No
 * consumer defines it by default, so every other build is unchanged. */
#ifndef SOFT64_NO_MULSHIFT
/* 32x32 -> 64 via 16-bit limb products: ColdFire mulu.l keeps only the
 * low 32 bits, so the wide product is assembled from four narrow ones */
static u64
mul32x32(u32 a, u32 b)
{
    u32 a0 = a & 0xFFFFu, a1 = a >> 16;
    u32 b0 = b & 0xFFFFu, b1 = b >> 16;
    u32 p00 = a0 * b0;
    u32 p01 = a0 * b1;
    u32 p10 = a1 * b0;
    u32 p11 = a1 * b1;
    u32 mid = p01 + p10;
    u32 lo, hi;

    hi = p11 + (mid >> 16);
    if (mid < p01)                  /* p01 + p10 carried out of 32 bits */
        hi += 0x10000u;
    lo = p00 + (mid << 16);
    if (lo < p00)
        hi += 1u;
    return ((u64)hi << 32) | lo;
}

u64
__muldi3(u64 a, u64 b)
{
    u32 ah = (u32)(a >> 32), al = (u32)a;
    u32 bh = (u32)(b >> 32), bl = (u32)b;
    u64 r = mul32x32(al, bl);
    u32 hi = (u32)(r >> 32);

    hi += al * bh + ah * bl;        /* truncated cross products */
    return ((u64)hi << 32) | (u32)r;
}
#endif /* SOFT64_NO_MULSHIFT */

/* shift-subtract long division: 64 steps of constant-width shifts and
 * a compare, nothing gcc turns back into a division libcall */
static u64
udivmod64(u64 n, u64 d, u64 *rem)
{
    u64 q = 0, r = 0;
    int i;

    if (d == 0) {
        *rem = 0;
        return 0;
    }
    for (i = 0; i < 64; i++) {
        r = (r << 1) | (n >> 63);
        n <<= 1;
        q <<= 1;
        if (r >= d) {
            r -= d;
            q |= 1u;
        }
    }
    *rem = r;
    return q;
}

u64
__udivdi3(u64 n, u64 d)
{
    u64 r;
    return udivmod64(n, d, &r);
}

u64
__umoddi3(u64 n, u64 d)
{
    u64 r;
    udivmod64(n, d, &r);
    return r;
}

s64
__divdi3(s64 n, s64 d)
{
    int neg = 0;
    u64 un, ud, q, r;

    if (n < 0) { un = -(u64)n; neg = !neg; } else { un = (u64)n; }
    if (d < 0) { ud = -(u64)d; neg = !neg; } else { ud = (u64)d; }
    q = udivmod64(un, ud, &r);
    return neg ? -(s64)q : (s64)q;
}

s64
__moddi3(s64 n, s64 d)
{
    int neg = 0;
    u64 un, ud, r;

    if (n < 0) { un = -(u64)n; neg = 1; } else { un = (u64)n; }
    if (d < 0) { ud = -(u64)d; } else { ud = (u64)d; }
    udivmod64(un, ud, &r);
    return neg ? -(s64)r : (s64)r;  /* the sign follows the dividend */
}

#ifndef SOFT64_NO_MULSHIFT
/* The variable shifts. gcc emits a call for a 64-bit shift by a
 * variable amount; the constant-amount cases it expands inline. Written
 * branch-free of any 64-bit shift operator, so the file stays free of
 * calls to itself. */
u64
__ashldi3(u64 a, int b)
{
    u32 lo = (u32)a, hi = (u32)(a >> 32);

    b &= 63;
    if (b == 0)
        return a;
    if (b >= 32)
        return (u64)((u32)(lo << (b - 32))) << 32;
    return ((u64)((hi << b) | (lo >> (32 - b))) << 32) | (u32)(lo << b);
}

u64
__lshrdi3(u64 a, int b)
{
    u32 lo = (u32)a, hi = (u32)(a >> 32);

    b &= 63;
    if (b == 0)
        return a;
    if (b >= 32)
        return hi >> (b - 32);
    return ((u64)(hi >> b) << 32) | ((lo >> b) | (u32)(hi << (32 - b)));
}

s64
__ashrdi3(s64 a, int b)
{
    u32 lo = (u32)a;
    int hi = (int)(u32)((u64)a >> 32);

    b &= 63;
    if (b == 0)
        return a;
    if (b >= 32)
        return (s64)(hi >> (b - 32));
    return ((s64)(hi >> b) << 32) |
           (u32)((lo >> b) | ((u32)hi << (32 - b)));
}
#endif /* SOFT64_NO_MULSHIFT */
