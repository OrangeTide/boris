/* romfs: a read-only packed-image backend for the sandbox.
 *
 * An image is a single self-describing blob: a header, a node table (the
 * directory tree, by parent index), a string table of names, and a data blob
 * of file contents.  All multi-byte fields are little-endian and read through
 * explicit byte assembly, so one image is valid on every target regardless of
 * host byte order.  The reader is freestanding-safe (it only walks the blob in
 * memory); the builder is host-only (it walks a real directory). */

#ifndef ROMFS_H
#define ROMFS_H

#include <stddef.h>
#include <stdint.h>

#include "fs.h"

#define ROMFS_MAGIC    "SKJROMFS"       /* 8 bytes, no NUL */
#define ROMFS_VERSION  1
#define ROMFS_HDR_SIZE 32
#define ROMFS_NODE_SIZE 20
enum { ROMFS_T_FILE = 0, ROMFS_T_DIR = 1 };

/* Mount a romfs image already in memory.  The image must outlive the mount
 * (the reader holds the pointer, it does not copy).  Returns the mount index
 * or a negative errno. */
extern const struct fs_backend romfs_backend;
int romfs_mount(const char *name, const void *image, size_t len, uint32_t flags);

/* Register an in-memory image for an already-installed mount at index `idx`
 * (the launcher path: the entry exists, this fills the per-mount image state
 * and marks it read-only).  Returns the root node handle (0) or a negative
 * errno.  `image` must outlive the mount. */
intptr_t romfs_adopt(int idx, const void *image, size_t len);

/* Host-only builder: pack the directory tree rooted at `dir` into a freshly
 * malloc'd image, written through *out / *out_len (caller frees *out).  Returns
 * 0, or a negative errno.  Regular files and subdirectories are included;
 * anything else is skipped. */
int romfs_build_dir(const char *dir, void **out, size_t *out_len);

#endif /* ROMFS_H */
