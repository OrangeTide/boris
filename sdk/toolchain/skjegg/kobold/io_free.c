/* io_free.c : the freestanding number, file, and entry surface for a Kobold guest.

   The console seam proper (io_write_str/int/char, io_flush, io_halt, and the
   whole read side) is the shared POSIX-fd implementation in kobold/kp_io.c, the
   same code the hosted runtime (kp_host.c) links; this file is the freestanding
   remainder.  io_write_real lives here because the %g renderer is per tier: it
   goes through libc's __fmt_greal (numfmt.c), the same libgcc-free renderer the
   C libc's printf uses, so the rv32 tier pulls no double-to-u64 helper (the
   hosted tier's io_write_real uses the host libc instead).  Integer Str and Val
   stay hand-rolled here (the upstream sandbox's approach): Pascal's Val carries a
   '$' hex prefix and 1-based error-offset codes that C's strtol does not model.
   Real parsing, a plain decimal-float scan, is shared: scan_real routes to libc's
   strtod, so this runtime and a C program built against the same libc parse a
   real the one way.

   The syscall wrappers are the one target-specific piece.  Each is a single trap
   (trap #0 on ColdFire, ecall on rv32) with register-bound operands, which needs
   extended inline asm, so they live in per-target assembly beside this file
   (runtime/io_free_cf.S, runtime/io_free_rv.S) and are declared here.  Streams:
   fd 1 is standard output, fd 2 standard error. */

#include "str.h"
#include "rt_glue.h"
#include "kp_io.h"

#include <stdint.h>
#include <stddef.h>

/****************************************************************
 * The host seam: write, read, exit
 ****************************************************************/

/* The wrappers are defined in the per-target syscall assembly
   (runtime/io_free_cf.S, runtime/io_free_rv.S).  Both targets provide
   open/close/lseek as well as write/read/exit, so both enable the file-I/O
   surface at the end of this file. */
#if (defined(__riscv) && __riscv_xlen == 32) || defined(__skj_riscv__)
#define KP_HAVE_FILE_IO 1
#elif defined(__mcoldfire__) || defined(__skj_m68k__)
#define KP_HAVE_FILE_IO 1
#else
#error "io_free.c is a freestanding console; build it with the rv32 or ColdFire toolchain"
#endif

/* The unified syscall seam: the same POSIX-named wrappers the C libc links
   (runtime/start_rv.S / start.S for a C program; runtime/io_free_*.S for this
   freestanding runtime).  write/read return the count or -errno; _exit ends the
   process. */
int write(int fd, const void *buf, int len);
int read(int fd, void *buf, int len);
void _exit(int code);
#ifdef KP_HAVE_FILE_IO
int open(const char *path, int flags, int mode);
int close(int fd);
long lseek(int fd, long offset, int whence);
int getdents64(int fd, void *buf, int count);
#endif

/****************************************************************
 * The number formatter: libc's numfmt.c, shared with the C runtime
 *
 * __fmt_udec writes an unsigned value's decimal digits (no NUL, no sign) and
 * returns the count; the integer Str helpers below share it.  It is libgcc-free,
 * so the rv32 freestanding tier links it with no 64-bit divide helper.  The
 * whole console seam (io_write_str/int/char/real, io_flush, io_halt, and the
 * read side with its one byte of pushback) is the shared kobold/kp_io.c over the
 * raw write/read syscalls; real output there shares __fmt_greal from this same
 * numfmt.c.  Declared opaquely so this file needs no -Ilibc; keep in step with
 * libc/fmt.h.
 ****************************************************************/
extern int __fmt_udec(char *out, uint64_t v);

/****************************************************************
 * Str and Val for integers (hand-rolled, no libc; the real side is in the
 * soft-float layer).  Ported from the upstream sandbox platform.
 *
 * The whole Str/Val surface is non-faulting (boris B2): a bad or out-of-range
 * parse is reported through a status, never a trap.  scan_int/scan_int64 do only
 * bounded arithmetic (overflow sets the error code, the base is a nonzero
 * constant), kp_str_valcode returns the 1-based offending offset, scan_real
 * routes to libc's lenient strtod over a bounded copy, and the formatters divide
 * only by nonzero constants.  So a guest can parse untrusted input without a
 * fault, and Val's failure is a value the program can handle.
 ****************************************************************/

static int
digit_of(char c, int base)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (base == 16 && c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (base == 16 && c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static void
scan_int(const char *b, int32_t len, int64_t *iv, int32_t *code)
{
    int32_t i = 0, start, neg = 0, base = 10, any = 0, ovf = 0;
    uint32_t v = 0, limit;
    int d;

    *iv = 0;
    if (len > 0 && (b[0] == '+' || b[0] == '-')) { neg = b[0] == '-'; i = 1; }
    if (i < len && b[i] == '$') { base = 16; i++; }
    for (start = i; i < len; i++) {
        d = digit_of(b[i], base);
        if (d < 0) break;
        if (v > (0xFFFFFFFFu - (uint32_t)d) / (uint32_t)base) ovf = 1;
        else v = v * (uint32_t)base + (uint32_t)d;
        any = 1;
    }
    if (!any) { *code = start + 1; return; }
    if (i != len) { *code = i + 1; return; }
    limit = neg ? 0x80000000u : 0x7FFFFFFFu;
    if (ovf || v > limit) { *code = len + 1; return; }
    *iv = neg ? -(int64_t)v : (int64_t)v;
    *code = 0;
}

static void
scan_int64(const char *b, int32_t len, int64_t *iv, int32_t *code)
{
    int32_t i = 0, start, neg = 0, base = 10, any = 0, ovf = 0;
    uint64_t v = 0, limit;
    int d;

    *iv = 0;
    if (len > 0 && (b[0] == '+' || b[0] == '-')) { neg = b[0] == '-'; i = 1; }
    if (i < len && b[i] == '$') { base = 16; i++; }
    for (start = i; i < len; i++) {
        d = digit_of(b[i], base);
        if (d < 0) break;
        any = 1;
        if (base == 16) {
            if (v > (0xFFFFFFFFFFFFFFFFull >> 4)) { ovf = 1; continue; }
            v = (v << 4) + (uint64_t)d;
        } else {
            if (v > 0x1999999999999999ull ||
                (v == 0x1999999999999999ull && d > 5)) { ovf = 1; continue; }
            v = (v << 3) + (v << 1) + (uint64_t)d;
        }
    }
    if (!any) { *code = start + 1; return; }
    if (i != len) { *code = i + 1; return; }
    limit = neg ? 0x8000000000000000ull : 0x7FFFFFFFFFFFFFFFull;
    if (ovf || v > limit) { *code = len + 1; return; }
    *iv = neg ? -(int64_t)v : (int64_t)v;
    *code = 0;
}

kp_gptr
kp_str_from_int(int32_t x)
{
    char buf[16];
    int n = 0;
    uint32_t v = x < 0 ? 0u - (uint32_t)x : (uint32_t)x;

    if (x < 0)
        buf[n++] = '-';
    n += __fmt_udec(buf + n, v);
    return kp_str_new(buf, n);
}

kp_gptr
kp_str_from_int64(int64_t x)
{
    char buf[24];
    int n = 0;
    uint64_t v = x < 0 ? 0ull - (uint64_t)x : (uint64_t)x;

    if (x < 0)
        buf[n++] = '-';
    n += __fmt_udec(buf + n, v);
    return kp_str_new(buf, n);
}

int32_t
kp_str_val_int(kp_gptr s)
{
    int64_t iv;
    int32_t code;

    scan_int(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    (void)code;
    return (int32_t)iv;
}

int64_t
kp_str_val_int64(kp_gptr s)
{
    int64_t iv;
    int32_t code;

    scan_int64(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    (void)code;
    return iv;
}

static double scan_real(const char *b, int32_t len, int32_t *code);   /* defined below */

/* Pascal Val's error code: 0 for a fully valid parse, else the 1-based offset of
   the offending character (kind 0 int32, 1 real, 2 int64).  scan_real reports the
   code the same way the hosted tier (str_fmt.c) does, so a bad real is caught on
   this tier too (the io.console Val surface relies on it). */
int32_t
kp_str_valcode(kp_gptr s, int32_t kind)
{
    int64_t iv;
    int32_t code;

    if (kind == 1) {
        (void)scan_real(kp_str_bytes(s), kp_str_len(s), &code);
        return code;
    }
    if (kind == 2)
        scan_int64(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    else
        scan_int(kp_str_bytes(s), kp_str_len(s), &iv, &code);
    return code;
}

/****************************************************************
 * Reals: parsing and the rv soft-float bit bridge
 *
 * Real output (io_write_real) lives in the shared kobold/kp_io.c now, over the
 * same __fmt_greal both tiers use.  This tier parses a real with libc's strtod
 * (shared from libc, see scan_real below), the same decimal-float parser the
 * hosted tier and a C program built against this libc use.  The rv32 soft-float
 * ABI carries a double across a call as its 64-bit integer bits, not in a float
 * register, so the guest reaches the real routines through the brv_* bridge,
 * which converts the bits to a double and back.
 ****************************************************************/

#if (defined(__riscv) && __riscv_xlen == 32) || defined(__skj_riscv__)
static double
b2d(uint64_t b)
{
    double d;
    memcpy(&d, &b, sizeof d);
    return d;
}

static uint64_t
d2b(double d)
{
    uint64_t b;
    memcpy(&b, &d, sizeof b);
    return b;
}
#endif

/* Scan a real: the freestanding tier parses it with libc's strtod
   (libc/strtod.c), the same decimal-float parser a C program built against this
   libc uses, so the two runtimes share one real parser.  strtod wants a
   NUL-terminated string while this tier's callers pass a counted buffer, so copy
   the (bounded) token into a local NUL-terminated scratch first: a real literal
   never needs more than a few dozen characters, and a double cannot resolve more
   digits than this buffer holds.  When code is non-NULL it carries Val's status:
   0 for a parse that consumes the whole token, else the 1-based offset of the
   first character strtod could not use (empty or no leading number is offset 1),
   matching the hosted str_fmt.c scan_real; on a bad parse the value is 0. */
extern double strtod(const char *s, char **end);

static double
scan_real(const char *b, int32_t len, int32_t *code)
{
    char buf[64], *end;
    int32_t n = len < 0 ? 0 : (len > 63 ? 63 : len);
    double rv;

    if (n == 0) {
        if (code) *code = 1;
        return 0;
    }
    memcpy(buf, b, (size_t)n);
    buf[n] = '\0';
    rv = strtod(buf, &end);
    if (end == buf) {
        if (code) *code = 1;
        return 0;
    }
    if (*end != '\0') {
        if (code) *code = (int32_t)(end - buf) + 1;
        return 0;
    }
    if (code) *code = 0;
    return rv;
}

double
kp_str_val_real(kp_gptr s)
{
    return scan_real(kp_str_bytes(s), kp_str_len(s), (int32_t *)0);
}

/* The rv soft-float bridges: a double rides a call as its 64-bit bits.  Only the
   rv tier remaps the guest's real calls onto these; a target that passes a real
   in a float register (ColdFire) calls io_write_real / kp_str_val_real directly. */
#if (defined(__riscv) && __riscv_xlen == 32) || defined(__skj_riscv__)
void     brv_write_real(int fd, uint64_t x) { io_write_real(fd, b2d(x)); }
uint64_t brv_read_real(void)                { return d2b(io_read_real()); }
uint64_t brv_val_real(kp_gptr s)            { return d2b(kp_str_val_real(s)); }
#endif

/****************************************************************
 * Program arguments (ParamCount / ParamStr over the entry argv)
 *
 * The crt hands the raw entry argument vector (argc then argv pointers) here at
 * startup through kp_set_raw_args; a host that passes none leaves the count 0.
 * ParamStr(0) is the program name, 1..count the arguments, as standard Pascal.
 ****************************************************************/

static int    g_argc;
static char **g_argv;

void
kp_set_raw_args(long *raw)
{
    if (raw == NULL) {
        g_argc = 0;
        g_argv = NULL;
        return;
    }
    g_argc = (int)raw[0];
    g_argv = (char **)&raw[1];
}

int
rt_param_count(void)
{
    return g_argc > 0 ? g_argc - 1 : 0;
}

kp_gptr
rt_param_str(int i)
{
    const char *p;
    int n = 0;

    if (i < 0 || i >= g_argc || g_argv == NULL)
        return kp_str_new("", 0);
    p = g_argv[i];
    if (p == NULL)
        return kp_str_new("", 0);
    while (p[n])
        n++;
    return kp_str_new(p, n);
}

/****************************************************************
 * Entry shim (the shared crt crt_entry_<arch>.S calls main)
 *
 * The shared _start reads argc and argv from the entry stack and calls
 * main(argc, argv), the one entry contract the C runtime uses too.  For a
 * Kobold guest, main records the args for ParamStr / ParamCount and runs the
 * program through kp_guest_entry, the entry skj-kp emits; a normal return
 * exits 0 (a nonzero status comes only from Halt, through io_halt).  The shared
 * _start then runs __libc_fini before it exits; console I/O is unbuffered now
 * (kp_io.c writes straight to the fd), so that is a no-op for a Kobold guest.
 * environ is defined, not just weak, so the Kobold link needs no weak-undefined
 * resolution when _start sets it.
 ****************************************************************/

char **environ;

extern void kp_guest_entry(void);

int
main(int argc, char **argv)
{
    g_argc = argc;
    g_argv = argv;
    kp_guest_entry();
    return 0;
}

void
__libc_fini(void)
{
    /* Console I/O is unbuffered now (kp_io.c writes straight to the fd), so there
       is no stream to flush at exit. */
}

#ifdef KP_HAVE_FILE_IO
/****************************************************************
 * File I/O (ReadFileStr / WriteFileStr)
 *
 * A guest compiler such as kpcom reads its source file by path and writes its
 * output, so the freestanding tier needs file access the console seam does not
 * give.  The host open/read/lseek/close syscalls back these.  ReadFileStr sizes
 * the file first with lseek(SEEK_END), so one allocation holds it rather than
 * growing a 256 KiB buffer and doubling (which matters on a small host heap);
 * a non-seekable fd falls back to growing and reading to EOF.  Both accept a
 * NUL-terminated path copied out of the guest string.  The open / close / lseek
 * wrappers are the per-target syscall assembly above.
 ****************************************************************/

/* asm-generic open flags, shared by the guest and the host. */
#define KP_O_RDONLY  0
#define KP_O_WRONLY  1
#define KP_O_CREAT   0x40
#define KP_O_TRUNC   0x200

/* lseek whence (asm-generic). */
#define KP_SEEK_SET  0
#define KP_SEEK_END  2

/* The fd primitives the file functions below go through.  With fs/
   interposition (SKJ_FS_INTERPOSE) a path resolves through the shared mount
   table and the fd is an fs fd, the Kobold-side shim over the same fs/ core the
   C libc uses; otherwise they are the raw syscall wrappers, as before.  The
   console side (kp_io.c and io_write_real) is unaffected: it stays on the raw
   write/read seam for descriptors 0/1/2. */
#ifdef SKJ_FS_INTERPOSE
#include "fs.h"
#define KPIO_RDONLY   FS_O_RDONLY
#define KPIO_WRCREAT  (FS_O_WRONLY | FS_O_CREAT | FS_O_TRUNC)
#define KPIO_SEEK_SET FS_SEEK_SET
#define KPIO_SEEK_END FS_SEEK_END
/* A console fd (0/1/2) is not fs-managed: a unit may open it directly
   (OpenReader(r, 0)) and hand it to kpf_read/kpf_write, so those descriptors
   go to the raw seam, as in libc/fdio.c. */
static int  kpio_open(const char *p, int f)          { return fs_open(p, f, 0644); }
static long kpio_read(int fd, void *b, long n)       { return fd < FS_FD_BASE ? read(fd, b, (int)n)  : fs_read(fd, b, (int)n); }
static long kpio_write(int fd, const void *b, long n){ return fd < FS_FD_BASE ? write(fd, b, (int)n) : fs_write(fd, b, (int)n); }
static long kpio_lseek(int fd, long o, int w)        { return fd < FS_FD_BASE ? lseek(fd, o, w) : (long)fs_lseek(fd, o, w); }
static void kpio_close(int fd)                       { if (fd >= FS_FD_BASE) fs_close(fd); else close(fd); }
#else
#define KPIO_RDONLY   KP_O_RDONLY
#define KPIO_WRCREAT  (KP_O_WRONLY | KP_O_CREAT | KP_O_TRUNC)
#define KPIO_SEEK_SET KP_SEEK_SET
#define KPIO_SEEK_END KP_SEEK_END
static int  kpio_open(const char *p, int f)          { return (int)open(p, f, 0644); }
static long kpio_read(int fd, void *b, long n)       { return read(fd, b, (int)n); }
static long kpio_write(int fd, const void *b, long n){ return write(fd, b, (int)n); }
static long kpio_lseek(int fd, long o, int w)        { return lseek(fd, o, w); }
static void kpio_close(int fd)                       { close(fd); }
#endif

kp_gptr
ReadFileStr(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    uint32_t cap, len = 0;      /* byte counts */
    kp_gptr buf;                /* guest heap address of the read buffer */
    kp_gptr s;                  /* the result string handle */
    int fd;
    long n, size;

    if (plen < 0 || plen >= (int)sizeof path)
        return kp_str_new("", 0);
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';

    fd = kpio_open(path, KPIO_RDONLY);
    if (fd < 0)
        return kp_str_new("", 0);

    /* Size the file so one allocation holds it.  A non-seekable fd (a pipe, or
       a host without lseek) returns < 0; then fall back to growing the buffer
       and reading to EOF. */
    size = kpio_lseek(fd, 0, KPIO_SEEK_END);
    if (size >= 0 && kpio_lseek(fd, 0, KPIO_SEEK_SET) == 0) {
        cap = (uint32_t)size;
        buf = gheap_alloc(cap ? cap : 1);
        while (len < cap) {
            n = kpio_read(fd, (void *)(uintptr_t)(buf + len), (long)(cap - len));
            if (n <= 0)
                break;              /* short file or read error: keep what we got */
            len += (uint32_t)n;
        }
    } else {
        cap = 65536;
        buf = gheap_alloc(cap);
        for (;;) {
            if (len == cap) {
                cap *= 2;
                buf = gheap_realloc(buf, cap);
            }
            n = kpio_read(fd, (void *)(uintptr_t)(buf + len), (long)(cap - len));
            if (n <= 0)
                break;
            len += (uint32_t)n;
        }
    }
    kpio_close(fd);

    s = kp_str_new_guest(buf, (int)len);
    gheap_free(buf);
    return s;
}

int
WriteFileStr(kp_gptr pathstr, kp_gptr datastr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    uint32_t len;               /* byte count */
    int fd;
    long n;

    if (plen < 0 || plen >= (int)sizeof path)
        return 0;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';

    fd = kpio_open(path, KPIO_WRCREAT);
    if (fd < 0)
        return 0;
    len = (uint32_t)kp_str_len(datastr);
    n = kpio_write(fd, kp_str_bytes(datastr), (long)len);
    kpio_close(fd);
    return n == (long)len;
}

/* The line/stream file primitives the `files` unit builds on: open a handle,
   read one chunk, write bytes, close.  Stateless (the unit holds the fd and does
   its own line buffering), mirroring jit_main.c and aot_rt.c over this tier's
   open/read/write/close syscall seam. */
#define KPF_CHUNK 4096

int
kpf_open_read(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);

    if (plen < 0 || plen >= (int)sizeof path)
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kpio_open(path, KPIO_RDONLY);
}

int
kpf_open_write(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);

    if (plen < 0 || plen >= (int)sizeof path)
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    return kpio_open(path, KPIO_WRCREAT);
}

kp_gptr
kpf_read(int fd)
{
    char tmp[KPF_CHUNK];
    long n = (fd < 0) ? -1 : kpio_read(fd, tmp, (long)sizeof tmp);

    if (n <= 0)
        return kp_str_new("", 0);
    return kp_str_new(tmp, (int)n);
}

int
kpf_write(int fd, kp_gptr datastr)
{
    if (fd < 0)
        return -1;
    return (int)kpio_write(fd, kp_str_bytes(datastr), (long)kp_str_len(datastr));
}

void
kpf_close(int fd)
{
    if (fd >= 0)
        kpio_close(fd);
}

/* The path metadata and operations the `files` unit exposes (exists, size, a
   directory test, delete/rename/mkdir/rmdir) are tier-independent: they call the
   libc stat/unlink/rename/mkdir/rmdir directly (which the crt serves from the
   statx and *at syscalls, the only file-metadata syscalls the rv32 and ColdFire
   kernels give).  That is the same C the hosted tiers use, so one source
   (kobold/kp_rt_meta.c) now serves every tier and this file no longer carries a
   copy. */

/* Directory reads for the `dirs` unit.  A small fixed table of open
   directories: a Kobold handle is a table index, the walk over the raw
   getdents64 buffer is done here so the unit sees one name at a time.  No
   malloc in the freestanding runtime, so the per-handle buffer is in the
   table. */
#define KPD_MAX 8
#define KPD_BUF 2048
static struct {
    int fd;
    int inuse;
    int pos;                    /* next unread byte in buf */
    int len;                    /* valid bytes in buf */
    char buf[KPD_BUF];
} kpd_tab[KPD_MAX];

int
kpd_open(kp_gptr pathstr)
{
    char path[1024];
    int plen = kp_str_len(pathstr);
    int i, fd;

    if (plen < 0 || plen >= (int)sizeof path)
        return -1;
    memcpy(path, kp_str_bytes(pathstr), (size_t)plen);
    path[plen] = '\0';
    for (i = 0; i < KPD_MAX; i++)
        if (!kpd_tab[i].inuse)
            break;
    if (i == KPD_MAX)
        return -1;
#ifdef SKJ_FS_INTERPOSE
    fd = fs_open(path, FS_O_DIRECTORY | FS_O_RDONLY, 0);
#else
    fd = (int)open(path, KP_O_RDONLY, 0);
#endif
    if (fd < 0)
        return -1;
    kpd_tab[i].fd = fd;
    kpd_tab[i].inuse = 1;
    kpd_tab[i].pos = 0;
    kpd_tab[i].len = 0;
    return i;
}

kp_gptr
kpd_next(int h)
{
    if (h < 0 || h >= KPD_MAX || !kpd_tab[h].inuse)
        return kp_str_new("", 0);
#ifdef SKJ_FS_INTERPOSE
    {
        /* A directory fs fd yields one fixed fs_dirent per fs_read; fs.c owns
           the cursor, so the per-handle buffer below is unused on this path. */
        struct fs_dirent fe;
        int nl = 0;
        if (fs_read(kpd_tab[h].fd, &fe, (int)sizeof fe) != (int)sizeof fe)
            return kp_str_new("", 0);
        while (nl < FS_DIRENT_NAMEMAX - 1 && fe.name[nl])
            nl++;
        return kp_str_new(fe.name, nl);
    }
#else
    {
        char *e;
        unsigned short reclen;
        const char *name;
        int nl;

        if (kpd_tab[h].pos >= kpd_tab[h].len) {
            int n = getdents64(kpd_tab[h].fd, kpd_tab[h].buf, KPD_BUF);
            if (n <= 0)
                return kp_str_new("", 0);
            kpd_tab[h].len = n;
            kpd_tab[h].pos = 0;
        }
        e = kpd_tab[h].buf + kpd_tab[h].pos;
        memcpy(&reclen, e + 16, sizeof reclen);   /* linux_dirent64 d_reclen */
        if (reclen < 20) {                        /* guard a malformed entry */
            kpd_tab[h].pos = kpd_tab[h].len;
            return kp_str_new("", 0);
        }
        kpd_tab[h].pos += reclen;
        name = e + 19;                            /* d_name, NUL-terminated */
        nl = 0;
        while (nl < reclen - 19 && name[nl])
            nl++;
        return kp_str_new(name, nl);
    }
#endif
}

void
kpd_close(int h)
{
    if (h >= 0 && h < KPD_MAX && kpd_tab[h].inuse) {
        kpio_close(kpd_tab[h].fd);
        kpd_tab[h].inuse = 0;
    }
}
#endif /* KP_HAVE_FILE_IO */
