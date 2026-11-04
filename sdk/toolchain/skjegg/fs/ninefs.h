/* ninefs: a 9P2000 client backend for the sandbox.
 *
 * The mount speaks the Plan 9 file protocol (the original 9P2000 dialect) to a
 * file server reached through a pluggable transport.  The backend is the
 * client: every fs op turns into one or more 9p request/reply exchanges.  The
 * transport carries a framed T-message and returns the matching R-message; it
 * is synchronous and single request at a time, which is all a single-threaded
 * guest needs.  In the sandbox the transport is the launcher shared-memory
 * channel; the hosted test uses an in-process server (see p9_server.h).
 *
 * All wire fields are little-endian, assembled and parsed through explicit byte
 * helpers, so the client is correct on any host byte order. */

#ifndef NINEFS_H
#define NINEFS_H

#include <stddef.h>
#include <stdint.h>

#include "fs.h"

/* 9P2000 message types (T from client, R the server's reply). */
enum {
    P9_TVERSION = 100, P9_RVERSION = 101,
    P9_TAUTH    = 102, P9_RAUTH    = 103,
    P9_TATTACH  = 104, P9_RATTACH  = 105,
    P9_RERROR   = 107,
    P9_TFLUSH   = 108, P9_RFLUSH   = 109,
    P9_TWALK    = 110, P9_RWALK    = 111,
    P9_TOPEN    = 112, P9_ROPEN    = 113,
    P9_TCREATE  = 114, P9_RCREATE  = 115,
    P9_TREAD    = 116, P9_RREAD    = 117,
    P9_TWRITE   = 118, P9_RWRITE   = 119,
    P9_TCLUNK   = 120, P9_RCLUNK   = 121,
    P9_TREMOVE  = 122, P9_RREMOVE  = 123,
    P9_TSTAT    = 124, P9_RSTAT    = 125,
    P9_TWSTAT   = 126, P9_RWSTAT   = 127,
};

/* qid.type bits and the matching dir bit in stat.mode. */
enum {
    P9_QTDIR  = 0x80,
    P9_QTFILE = 0x00,
};
#define P9_DMDIR 0x80000000u            /* directory bit in a stat mode word */

/* Topen/Tcreate mode byte (Plan 9 open modes, not POSIX O_* flags). */
enum {
    P9_OREAD  = 0,
    P9_OWRITE = 1,
    P9_ORDWR  = 2,
    P9_OEXEC  = 3,
    P9_OTRUNC = 0x10,
    P9_ORCLOSE = 0x40,
};

#define P9_MAXWELEM 16                  /* names per Twalk (protocol limit)   */
#define P9_NOFID   0xffffffffu          /* "no fid" sentinel                  */
#define P9_NOTAG   0xffff               /* the Tversion tag                   */
#define P9_MSIZE   8192                 /* negotiated max message size        */
#define P9_VERSION "9P2000"

/* A 13-byte qid: the server's unique handle for a file. */
struct p9_qid {
    uint8_t  type;                      /* P9_QT* */
    uint32_t version;
    uint64_t path;
};

/* The synchronous transport.  rpc() sends one already-framed T-message (tx,
 * txlen bytes, size[4] prefix included) and receives the R-message into rx
 * (capacity rxcap), returning its total length or a negative errno.  The same
 * ctx is handed to every call. */
struct p9_transport {
    int  (*rpc)(void *ctx, const uint8_t *tx, uint32_t txlen,
                uint8_t *rx, uint32_t rxcap);
    void *ctx;
};

/* Mount a 9p share reached through `t`.  The client performs Tversion + Tattach
 * at mount time; the attached root fid becomes the mount root handle.  Returns
 * the mount index or a negative errno. */
extern const struct fs_backend ninefs_backend;
int ninefs_mount(const char *name, const struct p9_transport *t, uint32_t flags);

/* Bind the transport for an already-installed mount at index `idx` (the
 * launcher path): performs the version+attach handshake and records the
 * session.  Returns the attached root fid handle, or a negative errno. */
intptr_t ninefs_adopt(int idx, const struct p9_transport *t);

#endif /* NINEFS_H */
