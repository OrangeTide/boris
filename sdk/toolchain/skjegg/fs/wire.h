/* wire: little-endian build and parse cursors with a sticky `ok` flag.  A
 * cursor carries its buffer and a one-time validity bit: a write past the end
 * or a read past the end latches `ok` to 0 and becomes a no-op (a read then
 * yields 0), so a caller checks `ok` once at the end instead of after every
 * field.  Header-only and freestanding-safe (no libc beyond string.h); every
 * field is assembled byte by byte, so the encoding is identical on any host
 * byte order.  The 9P codec (p9_wire.h) is one client; the primitives here are
 * protocol-neutral. */

#ifndef WIRE_H
#define WIRE_H

#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Build cursor.  `ok` latches 0 on overflow. */
struct wire_out {
    uint8_t *b;
    uint32_t cap;
    uint32_t n;
    int      ok;
};

static inline void
wire_out_init(struct wire_out *o, uint8_t *b, uint32_t cap)
{
    o->b = b; o->cap = cap; o->n = 0; o->ok = 1;
}

static inline void
wire_put_u8(struct wire_out *o, uint8_t v)
{
    if (o->n + 1 > o->cap) { o->ok = 0; return; }
    o->b[o->n++] = v;
}

static inline void
wire_put_u16(struct wire_out *o, uint16_t v)
{
    if (o->n + 2 > o->cap) { o->ok = 0; return; }
    o->b[o->n++] = (uint8_t)(v & 0xff);
    o->b[o->n++] = (uint8_t)(v >> 8);
}

static inline void
wire_put_u32(struct wire_out *o, uint32_t v)
{
    if (o->n + 4 > o->cap) { o->ok = 0; return; }
    o->b[o->n++] = (uint8_t)(v & 0xff);
    o->b[o->n++] = (uint8_t)((v >> 8) & 0xff);
    o->b[o->n++] = (uint8_t)((v >> 16) & 0xff);
    o->b[o->n++] = (uint8_t)((v >> 24) & 0xff);
}

static inline void
wire_put_u64(struct wire_out *o, uint64_t v)
{
    wire_put_u32(o, (uint32_t)(v & 0xffffffffu));
    wire_put_u32(o, (uint32_t)(v >> 32));
}

static inline void
wire_put_bytes(struct wire_out *o, const void *p, uint32_t len)
{
    if (o->n + len > o->cap) { o->ok = 0; return; }
    memcpy(o->b + o->n, p, len);
    o->n += len;
}

/* A length-prefixed string: a 2-byte length then the bytes, no NUL on the
 * wire. */
static inline void
wire_put_str(struct wire_out *o, const char *s)
{
    size_t len = s ? strlen(s) : 0;
    if (len > 0xffff) { o->ok = 0; return; }
    wire_put_u16(o, (uint16_t)len);
    wire_put_bytes(o, s, (uint32_t)len);
}

/* Parse cursor.  Every read checks bounds and latches `ok` to 0 past the end;
 * a short read then yields zeroes, so a caller validates `ok` before trusting
 * the decoded values. */
struct wire_in {
    const uint8_t *b;
    uint32_t       len;
    uint32_t       p;
    int            ok;
};

static inline void
wire_in_init(struct wire_in *in, const uint8_t *b, uint32_t len)
{
    in->b = b; in->len = len; in->p = 0; in->ok = 1;
}

static inline uint8_t
wire_get_u8(struct wire_in *in)
{
    if (in->p + 1 > in->len) { in->ok = 0; return 0; }
    return in->b[in->p++];
}

static inline uint16_t
wire_get_u16(struct wire_in *in)
{
    uint16_t v;
    if (in->p + 2 > in->len) { in->ok = 0; return 0; }
    v = (uint16_t)in->b[in->p] | ((uint16_t)in->b[in->p + 1] << 8);
    in->p += 2;
    return v;
}

static inline uint32_t
wire_get_u32(struct wire_in *in)
{
    uint32_t v;
    if (in->p + 4 > in->len) { in->ok = 0; return 0; }
    v = (uint32_t)in->b[in->p] | ((uint32_t)in->b[in->p + 1] << 8)
      | ((uint32_t)in->b[in->p + 2] << 16) | ((uint32_t)in->b[in->p + 3] << 24);
    in->p += 4;
    return v;
}

static inline uint64_t
wire_get_u64(struct wire_in *in)
{
    uint64_t lo = wire_get_u32(in);
    uint64_t hi = wire_get_u32(in);
    return lo | (hi << 32);
}

/* Copy a length-prefixed string into `dst` (NUL-terminated, truncated to cap)
 * and return its on-wire byte length.  dst may be NULL to skip the field. */
static inline uint32_t
wire_get_str(struct wire_in *in, char *dst, uint32_t cap)
{
    uint32_t len = wire_get_u16(in);
    uint32_t i;
    if (in->p + len > in->len) { in->ok = 0; return 0; }
    for (i = 0; i < len; i++) {
        if (dst && i + 1 < cap)
            dst[i] = (char)in->b[in->p + i];
    }
    if (dst && cap > 0)
        dst[len < cap ? len : cap - 1] = 0;
    in->p += len;
    return len;
}

static inline void
wire_skip(struct wire_in *in, uint32_t n)
{
    if (in->p + n > in->len) { in->ok = 0; return; }
    in->p += n;
}

#endif /* WIRE_H */
