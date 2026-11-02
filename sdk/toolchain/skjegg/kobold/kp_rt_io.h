/* kp_rt_io.h : the hosted Kobold runtime surface shared by the AOT start file
   (aot_rt.c) and the JIT driver (jit_main.c).

   These are the file, directory, file-string, and debug/test entry points the
   stdlib units call by name. The bodies are one source (kp_rt_io.c) compiled
   twice: host-native and linked into skj-kp-jit (the driver binds each name to
   the linked symbol), and target-native and linked into an AOT program (the
   guest calls each directly). The freestanding tier (io_free.c) is a separate
   implementation over the fs-interpose seam, a guest heap, and raw getdents64,
   so it does not share these bodies. */

#ifndef KP_RT_IO_H
#define KP_RT_IO_H

#include "str.h"

#include <stdint.h>

/* The small debug/test stubs (printInt/emit/emit64/emitf) are NOT here: the JIT
   byte sink (jit/code.h) already owns the C symbols emit and emit64, so the JIT
   driver keeps its own statically-named copies and binds the guest names to
   them, while the AOT runtime needs the literal symbol names the guest links
   against. They are four one-liners, left per-tier for that reason. */

/* Whole-file string I/O (the front end's own -o path uses WriteFileStr). */
kp_gptr ReadFileStr(kp_gptr pathstr);
int WriteFileStr(kp_gptr pathstr, kp_gptr datastr);

/* The `files` unit's line/stream primitives (split: kp_rt_io.c for the hosted
   tiers, io_free.c for the freestanding one). */
int kpf_open_read(kp_gptr pathstr);
int kpf_open_write(kp_gptr pathstr);
kp_gptr kpf_read(int fd);
int kpf_write(int fd, kp_gptr datastr);
void kpf_close(int fd);

/* The `files` unit's path metadata and operations.  These call the POSIX
   stat/unlink/rename/mkdir/rmdir directly, so one source (kp_rt_meta.c) serves
   every tier (hosted and freestanding); only the symbol resolution differs. */
int kpf_exists(kp_gptr pathstr);
int64_t kpf_size(kp_gptr pathstr);
int kpf_isdir(kp_gptr pathstr);
int kpf_delete(kp_gptr pathstr);
int kpf_rename(kp_gptr oldstr, kp_gptr newstr);
int kpf_mkdir(kp_gptr pathstr);
int kpf_rmdir(kp_gptr pathstr);

/* The `dirs` unit's directory reads. */
int kpd_open(kp_gptr pathstr);
kp_gptr kpd_next(int h);
void kpd_close(int h);

#endif /* KP_RT_IO_H */
