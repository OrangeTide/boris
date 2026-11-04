/* 9P2000 wire codec: the 9P-typed helpers (qid, message header and finish)
 * layered over the protocol-neutral little-endian cursor in wire.h.  A 9P
 * string is wire.h's length-prefixed string (wire_put_str / wire_get_str); the
 * integer primitives are the wire_put_* / wire_get_* ones directly.  Shared by
 * the ninefs client and the host test server; header-only and
 * freestanding-safe. */

#ifndef P9_WIRE_H
#define P9_WIRE_H

#include <stdint.h>

#include "wire.h"
#include "ninefs.h"      /* struct p9_qid, the message-type and flag constants */

static inline void
p9o_qid(struct wire_out *o, const struct p9_qid *q)
{
    wire_put_u8(o, q->type);
    wire_put_u32(o, q->version);
    wire_put_u64(o, q->path);
}

/* Write the message header with a placeholder size, to be patched at finish. */
static inline void
p9o_hdr(struct wire_out *o, uint8_t type, uint16_t tag)
{
    wire_put_u32(o, 0);                 /* size placeholder */
    wire_put_u8(o, type);
    wire_put_u16(o, tag);
}

/* Patch size[4] at the front and return the framed length, or 0 on overflow. */
static inline uint32_t
p9o_finish(struct wire_out *o)
{
    uint32_t n;
    if (!o->ok)
        return 0;
    n = o->n;
    o->b[0] = (uint8_t)(n & 0xff);
    o->b[1] = (uint8_t)((n >> 8) & 0xff);
    o->b[2] = (uint8_t)((n >> 16) & 0xff);
    o->b[3] = (uint8_t)((n >> 24) & 0xff);
    return n;
}

static inline void
p9i_qid(struct wire_in *in, struct p9_qid *q)
{
    q->type = wire_get_u8(in);
    q->version = wire_get_u32(in);
    q->path = wire_get_u64(in);
}

#endif /* P9_WIRE_H */
