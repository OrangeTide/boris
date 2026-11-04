/* vdso.c : the skjegg vDSO image, the pure leaf functions the host maps into a
 * guest and advertises through auxv (see include/skj_vdso.h).
 *
 * Every function here is stateless: no globals, no syscalls, no allocation, so
 * the compiled image is immutable and one copy is safe to share read-only
 * across sandboxes. It is built freestanding (no libc) and linked at a fixed
 * guest address by runtime/vdso_rv.ld; the host writes it into the guest and
 * passes the address of skj_vdso_table on the initial stack.
 */
#include "skj_vdso.h"

static uint32_t
v_strlen(const char *s)
{
    const char *p = s;
    while (*p)
        p++;
    return (uint32_t)(p - s);
}

static int
v_strcmp(const char *a, const char *b)
{
    while (*a && *a == *b) {
        a++;
        b++;
    }
    return (int)(unsigned char)*a - (int)(unsigned char)*b;
}

static void *
v_memcpy(void *dst, const void *src, uint32_t n)
{
    char *d = dst;
    const char *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}

static void *
v_memset(void *dst, int c, uint32_t n)
{
    char *d = dst;
    while (n--)
        *d++ = (char)c;
    return dst;
}

/* The system page: the host keeps this updated and the guest reads it with no
 * doorbell. It is not stateless like the functions above, but the guest never
 * writes it (the image is read-only), so sharing one host-updated copy across
 * sandboxes stays safe. The host locates it by the skj_vdso_sysinfo symbol and
 * writes the clock fields in the backing buffer between guest slices.
 *
 * It is const so it lands in .rodata (read-only, non-executable), which keeps
 * the image's one LOAD segment free of write permission. From the guest's view
 * the page really is read-only; the host updates the backing host memory, not
 * the guest mapping. The reads below go through volatile, so the compiler never
 * folds a field to its initializer despite the const. */
const struct skj_vdso_sys skj_vdso_sysinfo = {
    SKJ_VDSO_SYS_MAGIC,
    1,                          /* version */
    0,                          /* seq */
    4096,                       /* page_size */
    1,                          /* ncpus */
    0,                          /* pad */
    0,                          /* mono_ns */
    0,                          /* real_ns */
    { 0 },
};

/* Read a 64-bit time field under the seqlock: retry while seq is odd (a write
 * is in flight) or changed across the read, so the two halves never tear. */
static uint64_t
v_sys_read64(const uint64_t *field)
{
    const volatile uint32_t *seqp = &skj_vdso_sysinfo.seq;
    uint32_t s0, s1;
    uint64_t v;

    do {
        s0 = *seqp;
        v = *(const volatile uint64_t *)field;
        s1 = *seqp;
    } while ((s0 & 1u) || s0 != s1);
    return v;
}

static uint64_t
v_mono_ns(void)
{
    return v_sys_read64(&skj_vdso_sysinfo.mono_ns);
}

static uint64_t
v_real_ns(void)
{
    return v_sys_read64(&skj_vdso_sysinfo.real_ns);
}

/* The export table, placed at the image base. The function-pointer slots carry
 * absolute guest addresses the linker fills; a guest reads fn[ordinal] and
 * casts it back to the real signature. */
const struct skj_vdso skj_vdso_table = {
    SKJ_VDSO_MAGIC,
    SKJ_VDSO_COUNT,
    {
        (void (*)(void))v_strlen,
        (void (*)(void))v_strcmp,
        (void (*)(void))v_memcpy,
        (void (*)(void))v_memset,
        (void (*)(void))v_mono_ns,
        (void (*)(void))v_real_ns,
    },
    &skj_vdso_sysinfo,
};
