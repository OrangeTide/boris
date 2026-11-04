/* p9_server: a minimal 9P2000 file server over a real host directory.
 *
 * Host-only (it uses the host libc directory and file API), it exists to drive
 * and test the ninefs client without an external file server, and it seeds the
 * server the sandbox launcher will run behind its shared-memory channel.  It
 * serves one session over an in-process transport: a request handed to the
 * transport is dispatched inline and the reply is ready when the call returns,
 * exactly like the synchronous doorbell the real channel provides. */

#ifndef P9_SERVER_H
#define P9_SERVER_H

#include <stdint.h>

#include "ninefs.h"

struct p9_server;       /* opaque: the fid table + root (see p9_server.c) */

/* Create a server rooted at host directory `root`, or NULL on failure.  The
 * caller drives it with p9_server_handle and releases it with
 * p9_server_destroy. */
struct p9_server *p9_server_create(const char *root);
void              p9_server_destroy(struct p9_server *s);

/* Dispatch one framed 9P2000 T-message (req, reqlen bytes) and build the
 * R-message into rx (capacity rxcap).  Returns the reply length.  This is the
 * seam both the in-process transport and the sandbox doorbell call. */
int  p9_server_handle(struct p9_server *s, const uint8_t *req, uint32_t reqlen,
                      uint8_t *rx, uint32_t rxcap);

/* Dispatch a concatenation of framed T-messages (the request batching path):
 * each message runs through p9_server_handle on the same session, so a fid a
 * Twalk binds is visible to a following message, and the framed R-messages are
 * concatenated into rx.  A single message is a stream of one, identical to a
 * bare p9_server_handle.  Returns the total reply length. */
int  p9_server_handle_stream(struct p9_server *s, const uint8_t *req,
                             uint32_t reqlen, uint8_t *rx, uint32_t rxcap);

/* Open a server rooted at `root` and fill `out` with an in-process transport
 * that talks to it (a request is dispatched inline, the reply ready on return).
 * The ctx holds server state that must outlive every mount using it.  Returns 0
 * or a negative errno. */
int  p9_server_open(const char *root, struct p9_transport *out);

/* Release a server created by p9_server_open (closes any open host fds). */
void p9_server_close(struct p9_transport *t);

#endif /* P9_SERVER_H */
