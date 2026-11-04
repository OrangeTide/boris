/* p9_guest: the guest-side 9p transport over the launcher channel.
 *
 * Freestanding (guest-only).  The launcher binds a shared channel in guest
 * memory and records its address in fs_mount_aux; this builds a p9_transport
 * whose rpc() writes a framed T-message into the channel, rings the doorbell
 * hostcall, and reads the R-message back. */

#ifndef P9_GUEST_H
#define P9_GUEST_H

#include <stdint.h>

#include "ninefs.h"

/* Fill `out` with a transport over the channel at guest address `chan`. */
void p9_guest_transport(uint32_t chan, struct p9_transport *out);

#endif /* P9_GUEST_H */
