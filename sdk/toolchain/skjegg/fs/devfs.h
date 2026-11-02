/* devfs: the sandbox device backend (null, zero, full). */

#ifndef DEVFS_H
#define DEVFS_H

#include "fs.h"

/* The devfs root-directory handle: a sentinel distinct from any device index
 * and from a negative errno.  The launcher-populated guest table carries no
 * backing fd for a devfs mount, so fs_init's adoption pass uses this as the
 * mount root handle directly. */
#define DEVFS_ROOT 100

extern const struct fs_backend dev_backend;

/* Install a devfs mount named `name`.  The backend has a fixed flat set of
 * device files, so there is no backing handle to open; the mount root is a
 * sentinel the backend recognizes. */
int devfs_mount(const char *name, uint32_t flags);

#endif /* DEVFS_H */
