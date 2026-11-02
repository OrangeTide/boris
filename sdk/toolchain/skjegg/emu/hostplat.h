/* hostplat.h : the host facilities skj-run uses to service the guest ABI.
 *
 * The guest ABI skj-run presents (the GSYS_* syscalls, the 32-bit timespec
 * seam, linux_dirent64, the -errno convention) is fixed and host-independent: a
 * guest binary behaves identically whatever OS skj-run runs on.  This header is
 * the one seam where that fixed ABI meets the real host.  Everything here is
 * implemented per host OS in hostplat.c; the guest syscall layer (guest.c) calls
 * these and carries no host #ifdefs of its own.
 *
 * The operations collected here are the ones that differ by host: confined
 * (RESOLVE_BENEATH-style) opens, directory enumeration, the clock, and random
 * bytes.  Plain POSIX calls the whole range of hosts share (openat against
 * AT_FDCWD, fstatat, mkdirat, read/write, ...) stay as direct calls in the
 * handlers; only the host-varying primitives live behind this shim. */

#ifndef HOSTPLAT_H
#define HOSTPLAT_H

#include <stdint.h>
#include <sys/stat.h>

/* ---- confinement: resolve a path beneath a capability directory fd --------
 * Each refuses an escape (a "..", an absolute path, or a symlink that climbs
 * out) and fails rather than leak; `dirfd` is always a real directory fd, never
 * AT_FDCWD (the caller handles the unconfined ambient case directly). */

/* Open `path` beneath `dirfd` honoring `flags`/`mode`.  Host fd (>= 0) or -1. */
int hp_open_beneath(int dirfd, const char *path, int flags, int mode);

/* Stat `path` beneath `dirfd` into *st.  0 or -1. */
int hp_stat_beneath(int dirfd, const char *path, struct stat *st);

/* Open the confined parent directory of `path` beneath `dirfd` and point *base
 * at the final component (in place; `path` is modified), for a namespace op the
 * caller then runs with a plain *at against the returned fd.  Dir fd or -1. */
int hp_parent_beneath(int dirfd, char *path, const char **base);

/* ---- directory enumeration (for getdents64) -------------------------------
 * An opaque stream over the host's directory API.  hp_diropen dups `dirfd`, so
 * closing the stream leaves the caller's own fd open. */
typedef struct hp_dir hp_dir;

hp_dir *hp_diropen(int dirfd);
/* Next entry: 1 filled (ino, type, name set; name valid until the next call),
 * 0 at end, -1 on error.  type is a Linux/BSD DT_* value (shared constants). */
int  hp_dirnext(hp_dir *d, uint64_t *ino, unsigned *type, const char **name);
long hp_dirtell(hp_dir *d);
void hp_dirseek(hp_dir *d, long cookie);
void hp_dirclose(hp_dir *d);

/* ---- clock / sleep / random ----------------------------------------------- */

/* Fill sec and nsec: realtime (wall clock) when `realtime`, else a monotonic
 * clock.  0 or -1.  The 32-bit narrowing is the guest's timespec seam. */
int hp_clock(int realtime, uint32_t *sec, uint32_t *nsec);

/* Sleep for sec + nsec, resuming across a host signal.  0 or -1. */
int hp_sleep(uint32_t sec, uint32_t nsec);

/* Yield the processor: the cooperative hint the guest's sched_yield lowers to. */
void hp_yield(void);

/* Fill buf with len random bytes; returns the count, or -1. */
int hp_random(void *buf, int len);

#endif /* HOSTPLAT_H */
