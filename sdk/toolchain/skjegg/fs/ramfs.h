/* ramfs: an in-memory, non-persistent backend.  Index 0 is conventionally an
 * empty scratch RAM disk and the startup default mount. */

#ifndef FS_RAMFS_H
#define FS_RAMFS_H

#include "fs.h"

extern const struct fs_backend ramfs_backend;

/* Create a fresh (empty) ramfs instance and install it as a mount named `name`
 * with `flags`.  Returns the new mount index or a negative errno. */
int ramfs_mount(const char *name, uint32_t flags);

#endif /* FS_RAMFS_H */
