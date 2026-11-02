/* str_fmt.c : number formatting and parsing (Str and Val), adapted from
   src/str_fmt.c for the Skjegg JIT host.

   The only change from the Kobold source is dropping the explicit kp_vm
   parameter: under the freestanding tier the string runtime takes no vm, so
   these call kp_str_new/kp_str_bytes/kp_str_len without one.  The algorithms
   (FPC's Val code convention, hex via `$`, int32/int64/real ranges) and the use
   of libc (snprintf, strtod) are unchanged. */

#include "str.h"

#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* Scan an integer: an optional sign, then decimal digits, or a `$` and hex digits
   (the Pascal forms).  Set *iv to the value and *code to 0 for a fully valid
   parse, else the 1-based position of the first offending character, or len + 1
   on a 32-bit overflow.  FPC's Val code convention. */
static void
scan_int(const char *b, int32_t len, int64_t *iv, int32_t *code)
{
    int32_t i = 0, start, neg = 0, base = 10, any = 0;
    uint64_t v = 0, limit;

    *iv = 0;
    if (len > 0 && (b[0] == '+' || b[0] == '-')) {
        neg = (b[0] == '-');
        i = 1;
    }
    if (i < len && b[i] == '$') {
        base = 16;
        i++;
    }
    for (start = i; i < len; i++) {
        char c = b[i];
        int d;

        if (c >= '0' && c <= '9')
            d = c - '0';
        else if (base == 16 && c >= 'a' && c <= 'f')
            d = c - 'a' + 10;
        else if (base == 16 && c >= 'A' && c <= 'F')
            d = c - 'A' + 10;
        else
            break;
        v = v * (uint64_t)base + (uint64_t)d;
        if (v > 0x100000000ULL)
            v = 0x100000000ULL;
        any = 1;
    }
    if (!any) {
        *code = start + 1;
        return;
    }
    if (i != len) {
        *code = i + 1;
        return;
    }
    limit = neg ? 0x80000000ULL : 0x7FFFFFFFULL;
    if (v > limit) {
        *code = len + 1;
        return;
    }
    *iv = neg ? -(int64_t)v : (int64_t)v;
    *code = 0;
}

/* Scan a signed 64-bit integer, the same way but over the full int64 range. */
static void
scan_int64(const char *b, int32_t len, int64_t *iv, int32_t *code)
{
    int32_t i = 0, start, neg = 0, base = 10, any = 0, ovf = 0;
    uint64_t v = 0, limit;

    *iv = 0;
    if (len > 0 && (b[0] == '+' || b[0] == '-')) {
        neg = (b[0] == '-');
        i = 1;
    }
    if (i < len && b[i] == '$') {
        base = 16;
        i++;
    }
    for (start = i; i < len; i++) {
        char c = b[i];
        int d;

        if (c >= '0' && c <= '9')
            d = c - '0';
        else if (base == 16 && c >= 'a' && c <= 'f')
            d = c - 'a' + 10;
        else if (base == 16 && c >= 'A' && c <= 'F')
            d = c - 'A' + 10;
        else
            break;
        if (v > (UINT64_MAX - (uint64_t)d) / (uint64_t)base)
            ovf = 1;
        v = v * (uint64_t)base + (uint64_t)d;
        any = 1;
    }
    if (!any) {
        *code = start + 1;
        return;
    }
    if (i != len) {
        *code = i + 1;
        return;
    }
    limit = neg ? 0x8000000000000000ULL : 0x7FFFFFFFFFFFFFFFULL;
    if (ovf || v > limit) {
        *code = len + 1;
        return;
    }
    *iv = neg ? -(int64_t)v : (int64_t)v;
    *code = 0;
}

/* Scan a real with strtod over the NUL-terminated bytes, same code convention. */
static void
scan_real(const char *b, int32_t len, double *rv, int32_t *code)
{
    char *end;

    *rv = 0;
    if (len == 0) {
        *code = 1;
        return;
    }
    errno = 0;
    *rv = strtod(b, &end);
    if (end == b) {
        *rv = 0;
        *code = 1;
        return;
    }
    if (*end != '\0') {
        *rv = 0;
        *code = (int32_t)(end - b) + 1;
        return;
    }
    *code = (errno == ERANGE) ? len + 1 : 0;
}

kp_gptr
kp_str_from_int(int32_t x)
{
    char buf[16];
    int n = snprintf(buf, sizeof buf, "%d", (int)x);

    return kp_str_new(buf, n);
}

kp_gptr
kp_str_from_int64(int64_t x)
{
    char buf[24];
    int n = snprintf(buf, sizeof buf, "%lld", (long long)x);

    return kp_str_new(buf, n);
}

int32_t
kp_str_val_int(kp_gptr s)
{
    int64_t iv;
    int32_t code;

    scan_int(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    return (int32_t)iv;
}

int64_t
kp_str_val_int64(kp_gptr s)
{
    int64_t iv;
    int32_t code;

    scan_int64(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    return iv;
}

KP_REAL
kp_str_val_real(kp_gptr s)
{
    double rv;
    int32_t code;

    scan_real(kp_str_bytes(s), kp_str_len(s), &rv, &code);
    return (KP_REAL)rv;
}

int32_t
kp_str_valcode(kp_gptr s, int32_t kind)
{
    int64_t iv;
    double rv;
    int32_t code;

    if (kind == 1)
        scan_real(kp_str_bytes(s), kp_str_len(s), &rv, &code);
    else if (kind == 2)
        scan_int64(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    else
        scan_int(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    return code;
}
