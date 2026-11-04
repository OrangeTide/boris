/* ambientfs: the temporary ambient host backend for the freestanding guest.
 * See ambientfs.c.  Compiled only in the guest/freestanding fs build
 * (FS_WITH_AMBIENT); the hosted tools use hostfs.c instead.  It is no longer the
 * default: fs_init lands on the scratch ramfs, and installs this ambient mount
 * as the current one only under FS_AMBIENT_DEFAULT (the documented temporary
 * override for harnesses that run under bare qemu with no --mount). */

#ifndef FS_AMBIENTFS_H
#define FS_AMBIENTFS_H

#include "fs.h"

extern const struct fs_backend ambient_backend;

/* Install an ambient host mount (base is always AT_FDCWD).  Returns the mount
 * index or a negative errno. */
int ambient_mount(const char *name, uint32_t flags);

#endif /* FS_AMBIENTFS_H */
