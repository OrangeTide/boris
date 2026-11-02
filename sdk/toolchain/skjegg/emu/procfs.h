/* procfs.h : the host-served content for the proc: pseudo filesystem.
 *
 * A proc: mount is a capability of kind GDEV_PROC (emu/guest.h).  The guest
 * drives it with the ordinary hostcap backend (openat / read / getdents64 /
 * statx / lseek / close on the capability fd); emu/guest.c routes those to the
 * functions here, which generate their answers from the scheduler's process
 * table.  Nothing here runs in the guest: the content is produced host-side and
 * handed back a byte range at a time.
 *
 * The namespace is read-only:
 *     proc:                 the root directory
 *     proc:self             an alias for the opening process's own directory
 *     proc:<id>             one directory per live process (id == slot + 1,
 *                           matching skj-run's "[proc N]" convention)
 *     proc:<id>/status      key:value process metadata
 */

#ifndef PROCFS_H
#define PROCFS_H

#include <stdint.h>

struct sched;
struct fs_stat;
struct fs_dirent;

/* Open a proc: entry for the opening process (caller_slot is its slot, used to
 * resolve "self").  `rel` is the capability-relative path hostcap passes: "" or
 * "." is the root.  Returns an opaque open handle, or NULL with *err set to a
 * negative errno. */
void   *procfs_open(struct sched *S, int caller_slot, const char *rel, int *err);

int     procfs_is_dir(const void *h);

/* File byte ops; a directory handle returns -EISDIR. */
int     procfs_read(void *h, void *buf, int n);
int64_t procfs_lseek(void *h, int64_t off, int whence);

/* Directory iteration: fill the next entry (1), or report the end (0). */
int     procfs_getdent(void *h, struct fs_dirent *de);

/* Step the listing cursor back by one, so an entry that did not fit in the
 * caller's buffer is re-offered on the next getdents call. */
void    procfs_rewind1(void *h);

int     procfs_fstat(const void *h, struct fs_stat *st);
void    procfs_free(void *h);

/* Stat a path without opening it (hostcap's statx on the capability). 0 or a
 * negative errno. */
int     procfs_stat(struct sched *S, int caller_slot, const char *rel,
                    struct fs_stat *st);

#endif /* PROCFS_H */
