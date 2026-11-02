/* vfs_compile.h : the in-world guest compile pipeline over the VFS.
 *
 * This is compile-in-world (doc/vm-hosting-proposal.md P3). It reads a guest
 * source from the VFS, runs the skjegg toolchain over temporary host files, and
 * writes the resulting RV32 ELF back into the VFS. The toolchain stages are
 * themselves RV32 guests (skj-cc-rv.elf, skj-as-rv.elf, skj-ld-rv.elf,
 * skj-kpc-rv.elf, skj-kp-rv.elf) run under the embedded runtime, each confined
 * to the build directory through a hostcap mount. No host execve, so the whole
 * pipeline runs inside the security sandbox. Source in, ELF out, both in the
 * VFS tree; the CAS folding is the VFS's.
 *
 * Three guest languages are recognized by the source extension:
 *   .c          C:         skj-cc-rv -> skj-as-rv -> skj-ld-rv
 *   .s, .S      assembly:               skj-as-rv -> skj-ld-rv
 *   .pas, .kp   Kobold:     skj-kpc-rv -> skj-kp-rv -> skj-as-rv -> skj-ld-rv
 * A C or assembly program links the C start files and the confined libc; a
 * Kobold program links its own crt and the freestanding runtime archive. Each
 * supplies its own entry and is a plain program, not a command verb. */

#ifndef VFS_COMPILE_H
#define VFS_COMPILE_H

#include <stddef.h>

struct vfs;

/* Return codes. */
#define VFS_COMPILE_OK        0
#define VFS_COMPILE_ECFG     -1    /* a configured tool or link input is missing */
#define VFS_COMPILE_ESRC     -2    /* the source path is absent or unreadable */
#define VFS_COMPILE_ESTAGE   -3    /* a toolchain stage failed (see errbuf) */
#define VFS_COMPILE_EOUT     -4    /* the ELF could not be read back or written */
#define VFS_COMPILE_EINTERNAL -5   /* temp dir, run, or allocation failure */
#define VFS_COMPILE_ELANG    -6    /* the source extension names no known language */

/* Where the toolchain guests and their link inputs live. These are host paths,
 * not VFS paths: the stage ELFs and the prebuilt link inputs are build products
 * of `make -C sdk/vm toolchain` (toolchain_dir holds skj-{cc,as,ld,kp,kpc}-rv.elf;
 * lib_dir holds the C link inputs crt0.o, va_rv.o, soft64_div.o, libc.a, fini.o
 * and the Kobold link inputs kp_crt_rv.o, libkpaot-rv-free.a). A higher layer
 * supplies them from mud config. include_dir is the guest C header tree mounted
 * read-only for the C front end; it may be NULL for assembly-only use. workdir
 * is the parent for the per-compile build directory; NULL falls back to /tmp.
 * The compile fails with VFS_COMPILE_ECFG if a field it needs is unset or names
 * a missing file. */
struct vfs_compile_cfg {
	const char *toolchain_dir;     /* dir with skj-{cc,as,ld,kp,kpc}-rv.elf */
	const char *lib_dir;           /* dir with the C and Kobold link inputs */
	const char *include_dir;       /* guest C headers (read-only mount); may be NULL */
	const char *workdir;           /* parent for the build dir; NULL => /tmp */
};

/* Compile the guest source at src_path in the VFS to an RV32 ELF written at
 * out_path in the VFS (its parent directories are created as needed). The
 * language is chosen by the source extension (see the header comment); an
 * unknown extension returns VFS_COMPILE_ELANG. On a stage failure
 * (VFS_COMPILE_ESTAGE), errbuf is filled with the failing stage name and the
 * captured diagnostics; errbuf may be NULL. On success (VFS_COMPILE_OK), errbuf
 * holds any non-fatal compiler warnings the stages printed, or stays empty; the
 * caller distinguishes the two by the return code. Returns VFS_COMPILE_OK or a
 * negative code. */
int vfs_compile(struct vfs *v, const char *src_path, const char *out_path,
	const struct vfs_compile_cfg *cfg, char *errbuf, size_t errsz);

#endif /* VFS_COMPILE_H */
