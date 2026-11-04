/* hostcap: the confined host backend for the freestanding guest.  See
 * hostcap.c.  Compiled only in the guest/freestanding fs build
 * (FS_WITH_HOSTCAP); the hosted tools use hostfs.c instead. */

#ifndef FS_HOSTCAP_H
#define FS_HOSTCAP_H

#include "fs.h"

extern const struct fs_backend hostcap_backend;

/* Install a confined host mount whose root is the sandbox capability fd
 * `capfd` (a directory fd the launcher granted).  Returns the mount index or a
 * negative errno.  The launcher-populated table reaches the same backend
 * through fs_init's adoption pass, so this is the hosted/test entry point. */
int hostcap_mount(const char *name, int capfd, uint32_t flags);

#endif /* FS_HOSTCAP_H */
