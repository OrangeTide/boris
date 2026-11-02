/* p9_vfs.h : a 9P2000 file server backed by the in-world VFS.
 *
 * It provides the p9_server_* entry points the embedded emulator's doorbell
 * (emu/guest.c) drives, but serves them from a content-addressed vfs rather
 * than a host directory, so a guest reaching a mount through the stock fs/ +
 * ninefs + p9_guest client talks to the in-world object store and never to the
 * host filesystem. The protocol engine mirrors the vendored fs/p9_server.c;
 * only the storage leaves differ (vfs_* in place of host open/read/write/stat).
 *
 * Walk names are confined exactly as upstream: an absolute step or a ".." that
 * would climb above the root is refused. Because every access goes through the
 * vfs, which has one flat tree and no host paths, there is no host escape to
 * confine in the first place. */

#ifndef P9_VFS_H
#define P9_VFS_H

struct vfs;
struct p9_server;

/* Create a 9P server that serves `v` (which must outlive the server). Returns
 * NULL on allocation failure. This is boris's own constructor; the host binds
 * the result into a task's guest p9 channel. */
struct p9_server *p9_vfs_new(struct vfs *v);

/* Register the vfs that the p9_server_create(root) entry point (the one the
 * emulator's mount launcher calls) should serve. The server ignores its `root`
 * string and serves this vfs. Pass NULL to clear it. */
void p9_vfs_set_default(struct vfs *v);

#endif /* P9_VFS_H */
