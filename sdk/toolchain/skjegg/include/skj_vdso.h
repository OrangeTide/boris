/* skj_vdso.h : the skjegg vDSO ABI.
 *
 * The host (skj-run) maps a small read-only image of pure, stateless leaf
 * functions into a guest and advertises its base, the address of the exported
 * skj_vdso_table, through the auxv tag AT_SKJ_VDSO on the initial stack. A
 * guest finds the table by walking its auxv (environ -> NULL -> auxv) and calls
 * a function through table->fn[ordinal].
 *
 * This is the injection seam: the host decides what runtime a process sees by
 * choosing the image it maps. Only stateless code goes here (str/mem and the
 * like), so one image is safely shared read-only across sandboxes; libc's
 * stateful parts (malloc, stdio, errno, the fs layer) stay per-process.
 *
 * One source of truth for the image (runtime/vdso.c) and any guest that uses
 * it. The host needs only AT_SKJ_VDSO and the table's symbol name, so it does
 * not include this (its pointer width differs); it keeps a matching define.
 */
#ifndef SKJ_VDSO_H
#define SKJ_VDSO_H

#include <stdint.h>

/* Private auxv tag carrying the vDSO base, chosen out of the Linux AT_* range
 * so a real libc walking the same auxv ignores it. Keep in step with the
 * AT_SKJ_VDSO define in emu/guest.c. */
#define AT_SKJ_VDSO 0x7001

#define SKJ_VDSO_MAGIC 0x534b4a56u      /* 'SKJV' */

/* Export ordinals. Append-only: the index is the ABI, so never renumber. */
enum {
    SKJ_VDSO_STRLEN = 0,
    SKJ_VDSO_STRCMP = 1,
    SKJ_VDSO_MEMCPY = 2,
    SKJ_VDSO_MEMSET = 3,
    SKJ_VDSO_MONO_NS = 4,       /* uint64_t (*)(void): monotonic nanoseconds */
    SKJ_VDSO_REAL_NS = 5,       /* uint64_t (*)(void): realtime nanoseconds  */
    SKJ_VDSO_COUNT
};

/* The system page: a small block the host keeps updated and the guest reads
 * directly, with no syscall or doorbell (the vDSO's namesake win). It lives in
 * the shared vDSO image, so one host-updated copy serves every sandbox, and it
 * is read-only to the guest. The clock fields are the first use; the reserved
 * words leave room for more QNX-style state (cpu count, timer rate, ...).
 *
 * A reader of the 64-bit time fields uses the seqlock: the host makes seq odd
 * before a write and even after, so a reader loops while seq is odd or changed
 * across the read. In practice the host updates the page only between guest
 * slices, when the guest is stopped, so a torn read cannot occur; the seqlock
 * is the documented contract and keeps the reader correct if that ever changes.
 * The vDSO functions SKJ_VDSO_MONO_NS / SKJ_VDSO_REAL_NS read it for a guest;
 * a guest may also map the page's address (SKJ_VDSO_SYS, below) and read fields
 * directly. */
#define SKJ_VDSO_SYS_MAGIC 0x53595350u  /* 'SYSP' */

struct skj_vdso_sys {
    uint32_t magic;
    uint32_t version;
    uint32_t seq;               /* seqlock: odd while the host writes */
    uint32_t page_size;
    uint32_t ncpus;
    uint32_t pad;
    uint64_t mono_ns;           /* monotonic nanoseconds */
    uint64_t real_ns;           /* realtime nanoseconds since the epoch */
    uint64_t reserved[8];       /* headroom; append fields, never reorder */
};

/* The export table at the image base: a magic word, the entry count, then one
 * guest address per ordinal. fn[] is typed as bare function pointers; a caller
 * casts each to the real signature at the call site. `sys` points at the system
 * page (above), 0 in an image without one, so a guest can read its fields
 * directly as well as through the clock functions. Appended after fn[], so the
 * ordinals keep their offsets. */
struct skj_vdso {
    uint32_t magic;
    uint32_t count;
    void (*fn[SKJ_VDSO_COUNT])(void);
    const struct skj_vdso_sys *sys;
};

#endif /* SKJ_VDSO_H */
