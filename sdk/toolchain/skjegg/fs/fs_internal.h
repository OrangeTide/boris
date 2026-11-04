/* fs/ internal glue between the core (fs.c) and the backends.  Not part of the
 * public fs.h surface the front ends use. */

#ifndef FS_INTERNAL_H
#define FS_INTERNAL_H

#include "fs.h"

/* Install a mount: allocate a root fd that carries `root_handle` (the backend's
 * identifier for the mount root), append a table entry named `name` of `kind`
 * with `flags`, and return the new mount index (negative errno on failure).
 * The per-backend constructors below call this. */
int fs_install_mount(const char *name, enum fs_kind kind,
                     intptr_t root_handle, uint32_t flags);

#endif /* FS_INTERNAL_H */
