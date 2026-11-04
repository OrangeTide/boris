/* p9_guest: the guest side of the 9p launcher channel (see the header).
 *
 * The channel is a shared region in guest memory the launcher allocated: two
 * length words followed by a request and a reply buffer, each P9_MSIZE.  An rpc
 * copies the T-message into req, stores its length, and issues the doorbell
 * hostcall; the launcher services the request inline (reads req, runs its 9p
 * server, writes rsp and rsp_len) so the reply is ready when the hostcall
 * returns.  The hostcall is an opaque call, which orders the stores before it
 * and the loads after it. */

#include "p9_guest.h"

#include <string.h>

/* The reserved private selector the hostcall uses (emu/sched.h SKJ_SYS_P9).
 * The crt wrapper issues it; off a sandbox (bare qemu) it returns nonzero and
 * the rpc fails cleanly. */
extern long __skj_p9_doorbell(void *chan);

/* Channel layout, shared with the launcher (emu/guest.c). */
struct p9_chan {
    uint32_t req_len;
    uint32_t rsp_len;
    uint8_t  req[P9_MSIZE];
    uint8_t  rsp[P9_MSIZE];
};

static int
chan_rpc(void *ctx, const uint8_t *tx, uint32_t txlen, uint8_t *rx, uint32_t rxcap)
{
    struct p9_chan *c = (struct p9_chan *)ctx;
    uint32_t n;

    if (txlen > P9_MSIZE)
        return -1;
    memcpy(c->req, tx, txlen);
    c->req_len = txlen;
    if (__skj_p9_doorbell(c) != 0)
        return -1;
    n = c->rsp_len;
    if (n > rxcap)
        n = rxcap;
    if (n > P9_MSIZE)
        n = P9_MSIZE;
    memcpy(rx, c->rsp, n);
    return (int)n;
}

void
p9_guest_transport(uint32_t chan, struct p9_transport *out)
{
    out->rpc = chan_rpc;
    out->ctx = (void *)(uintptr_t)chan;
}
