/* cas.c : content-addressable store using BLAKE2b hashing */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

/* IMPLEMENTATION NOTES
 *
 * Path Limits (CAS_PATH_MAX):
 *   Paths are limited to 512 bytes. For basedir/XX/HASH layout, this means
 *   basedir should stay under 400 bytes to be safe. Operations that would
 *   exceed the limit fail with CAS_ERR. Check build_path/build_dir return
 *   values when using very long basedir paths (>350 bytes).
 *
 * Compression:
 *   Objects are compressed only if:
 *   1. Object size >= 512 bytes (skip codec overhead on tiny objects)
 *   2. Compressed form saves > 12% of original size
 *   Threshold: (payload + 1 byte tag) < 87.5% of original.
 *   This avoids wasting CPU on incompressible data (images, video, etc.)
 */

#define _POSIX_C_SOURCE 200809L

#include "cas.h"
#include "cas-pack.h"
#include "cas-codec.h"

#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

/****************************************************************
 * Internal constants
 ****************************************************************/

/** Maximum depot path length (512 bytes).
 *  Paths are constructed as: basedir/XX/HASH where XX is the first
 *  two hex digits of the hash (object sharding).
 *  If a path would exceed 512 bytes (e.g., very long basedir),
 *  build_path and build_dir return CAS_ERR. Callers should use
 *  reasonable basedir paths (< 400 bytes recommended).
 *  This limit is a practical constraint, not a security boundary.
 */
#define CAS_PATH_MAX    512
#define CAS_HEADER_MAX  32
#define BLAKE2B_BLOCKLEN 128

/****************************************************************
 * Error strings
 ****************************************************************/

const char *
cas_strerror(int err)
{
    switch (err) {
    case CAS_OK:        return "success";
    case CAS_ERR:       return "generic error";
    case CAS_ENOTFOUND: return "not found";
    case CAS_ENOMEM:    return "out of memory";
    case CAS_EIO:       return "I/O error";
    case CAS_ETYPE:     return "type mismatch";
    default:            return "unknown error";
    }
}

/****************************************************************
 * Logging (optional, runtime-configurable)
 ****************************************************************/

static cas_log_fn cas__log_callback = NULL;
static void *cas__log_ctx = NULL;

int
cas_log_register(cas_log_fn fn, void *ctx)
{
    cas__log_callback = fn;
    cas__log_ctx = ctx;
    return CAS_OK;
}

void
cas_log_unregister(void)
{
    cas__log_callback = NULL;
    cas__log_ctx = NULL;
}

const char *
cas_log_strerror(int code)
{
    switch (code) {
    /* Open/read operations */
    case CAS_LOG_OPEN_START:        return "open object";
    case CAS_LOG_OPEN_MMAP:         return "mmap region";
    case CAS_LOG_OPEN_DECODE_START: return "decompress start";
    case CAS_LOG_OPEN_DECODE_DONE:  return "decompress done";

    /* Write operations */
    case CAS_LOG_PUT_TEMP_CREATE:   return "create temp file";
    case CAS_LOG_PUT_WRITE_DATA:    return "write data";
    case CAS_LOG_PUT_FSYNC:         return "fsync";
    case CAS_LOG_PUT_RENAME:        return "atomic rename";

    /* Lock operations */
    case CAS_LOG_LOCK_ACQUIRE:      return "acquire lock";
    case CAS_LOG_LOCK_RELEASE:      return "release lock";

    /* Iteration/fsck */
    case CAS_LOG_FOREACH_START:     return "scan depot";
    case CAS_LOG_FSCK_CHECK:        return "check object";

    /* Errors */
    case CAS_LOG_ERR_LOCK_FAILED:   return "lock failed";
    case CAS_LOG_ERR_MALLOC:        return "malloc failed";
    case CAS_LOG_ERR_MMAP:          return "mmap failed";
    case CAS_LOG_ERR_WRITE:         return "write failed";
    case CAS_LOG_ERR_DECODE:        return "decode failed";
    case CAS_LOG_ERR_UNLINK:        return "unlink failed";
    case CAS_LOG_ERR_RENAME:        return "rename failed";
    case CAS_LOG_ERR_FSYNC:         return "fsync failed";
    default:                        return "unknown event";
    }
}

/** Internal helper: emit a log event if callback is registered. */
static inline void
cas__log_emit(int code, const char *file, int line, const char *msg)
{
    if (cas__log_callback != NULL) {
        (*cas__log_callback)(code, file, line, msg, cas__log_ctx);
    }
}

/** Macro for logging events. Compiles away if callback is not registered. */
#define CAS_LOG(code, msg) \
    cas__log_emit(code, __FILE__, __LINE__, msg)

/****************************************************************
 * Compression Policy (global configuration)
 ****************************************************************/

static struct cas_compress_config cas__compress_cfg = {
    .enabled = 1,
    .min_size = 512,        /* default: skip codec overhead on tiny objects */
    .min_savings_pct = 12,  /* default: require >12% savings to justify codec cost */
};

int
cas_compression_config(const struct cas_compress_config *cfg)
{
    if (!cfg)
        return CAS_ERR;

    /* Validate min_savings_pct range. */
    if (cfg->min_savings_pct < 1 || cfg->min_savings_pct > 99)
        return CAS_ERR;

    cas__compress_cfg = *cfg;
    return CAS_OK;
}

void
cas_compression_reset(void)
{
    cas__compress_cfg = (struct cas_compress_config){
        .enabled = 1,
        .min_size = 512,
        .min_savings_pct = 12,
    };
}

/****************************************************************
 * BLAKE2b-256 (RFC 7693)
 ****************************************************************/

struct blake2b {
    uint64_t h[8];
    uint64_t t[2];
    uint64_t f[2];
    uint8_t buf[BLAKE2B_BLOCKLEN];
    size_t buflen;
    size_t outlen;
};

static const uint64_t blake2b_iv[8] = {
    0x6a09e667f3bcc908ULL, 0xbb67ae8584caa73bULL,
    0x3c6ef372fe94f82bULL, 0xa54ff53a5f1d36f1ULL,
    0x510e527fade682d1ULL, 0x9b05688c2b3e6c1fULL,
    0x1f83d9abfb41bd6bULL, 0x5be0cd19137e2179ULL,
};

static const uint8_t blake2b_sigma[12][16] = {
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, },
    { 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3, },
    { 11,  8, 12,  0,  5,  2, 15, 13, 10, 14,  3,  6,  7,  1,  9,  4, },
    {  7,  9,  3,  1, 13, 12, 11, 14,  2,  6,  5, 10,  4,  0, 15,  8, },
    {  9,  0,  5,  7,  2,  4, 10, 15, 14,  1, 11, 12,  6,  8,  3, 13, },
    {  2, 12,  6, 10,  0, 11,  8,  3,  4, 13,  7,  5, 15, 14,  1,  9, },
    { 12,  5,  1, 15, 14, 13,  4, 10,  0,  7,  6,  3,  9,  2,  8, 11, },
    { 13, 11,  7, 14, 12,  1,  3,  9,  5,  0, 15,  4,  8,  6,  2, 10, },
    {  6, 15, 14,  9, 11,  3,  0,  8, 12,  2, 13,  7,  1,  4, 10,  5, },
    { 10,  2,  8,  4,  7,  6,  1,  5, 15, 11,  9, 14,  3, 12, 13,  0, },
    {  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15, },
    { 14, 10,  4,  8,  9, 15, 13,  6,  1, 12,  0,  2, 11,  7,  5,  3, },
};

static uint64_t
load64(const void *src)
{
    const uint8_t *p = src;

    return ((uint64_t)p[0])       | ((uint64_t)p[1] << 8) |
           ((uint64_t)p[2] << 16) | ((uint64_t)p[3] << 24) |
           ((uint64_t)p[4] << 32) | ((uint64_t)p[5] << 40) |
           ((uint64_t)p[6] << 48) | ((uint64_t)p[7] << 56);
}

static void
store64(void *dst, uint64_t w)
{
    uint8_t *p = dst;

    p[0] = (uint8_t)(w);
    p[1] = (uint8_t)(w >> 8);
    p[2] = (uint8_t)(w >> 16);
    p[3] = (uint8_t)(w >> 24);
    p[4] = (uint8_t)(w >> 32);
    p[5] = (uint8_t)(w >> 40);
    p[6] = (uint8_t)(w >> 48);
    p[7] = (uint8_t)(w >> 56);
}

#define ROTR64(x, n) (((x) >> (n)) | ((x) << (64 - (n))))

static void
blake2b_g(uint64_t *v, int a, int b, int c, int d,
          uint64_t x, uint64_t y)
{
    v[a] = v[a] + v[b] + x;
    v[d] = ROTR64(v[d] ^ v[a], 32);
    v[c] = v[c] + v[d];
    v[b] = ROTR64(v[b] ^ v[c], 24);
    v[a] = v[a] + v[b] + y;
    v[d] = ROTR64(v[d] ^ v[a], 16);
    v[c] = v[c] + v[d];
    v[b] = ROTR64(v[b] ^ v[c], 63);
}

static void
blake2b_compress(struct blake2b *S, const uint8_t *block)
{
    uint64_t m[16], v[16];

    for (int i = 0; i < 16; i++)
        m[i] = load64(block + i * 8);

    for (int i = 0; i < 8; i++) {
        v[i] = S->h[i];
        v[i + 8] = blake2b_iv[i];
    }
    v[12] ^= S->t[0];
    v[13] ^= S->t[1];
    v[14] ^= S->f[0];
    v[15] ^= S->f[1];

    for (int i = 0; i < 12; i++) {
        const uint8_t *s = blake2b_sigma[i];

        blake2b_g(v, 0, 4,  8, 12, m[s[ 0]], m[s[ 1]]);
        blake2b_g(v, 1, 5,  9, 13, m[s[ 2]], m[s[ 3]]);
        blake2b_g(v, 2, 6, 10, 14, m[s[ 4]], m[s[ 5]]);
        blake2b_g(v, 3, 7, 11, 15, m[s[ 6]], m[s[ 7]]);
        blake2b_g(v, 0, 5, 10, 15, m[s[ 8]], m[s[ 9]]);
        blake2b_g(v, 1, 6, 11, 12, m[s[10]], m[s[11]]);
        blake2b_g(v, 2, 7,  8, 13, m[s[12]], m[s[13]]);
        blake2b_g(v, 3, 4,  9, 14, m[s[14]], m[s[15]]);
    }

    for (int i = 0; i < 8; i++)
        S->h[i] ^= v[i] ^ v[i + 8];
}

static void
blake2b_init(struct blake2b *S, size_t outlen)
{
    memset(S, 0, sizeof(*S));
    for (int i = 0; i < 8; i++)
        S->h[i] = blake2b_iv[i];
    S->h[0] ^= 0x01010000 ^ (uint64_t)outlen;
    S->outlen = outlen;
}

static void
blake2b_update(struct blake2b *S, const void *data, size_t len)
{
    const uint8_t *p = data;
    size_t left, fill;

    if (len == 0)
        return;

    left = S->buflen;
    fill = BLAKE2B_BLOCKLEN - left;

    if (len > fill) {
        memcpy(S->buf + left, p, fill);
        S->t[0] += BLAKE2B_BLOCKLEN;
        S->t[1] += (S->t[0] < BLAKE2B_BLOCKLEN);
        blake2b_compress(S, S->buf);
        p += fill;
        len -= fill;
        S->buflen = 0;

        while (len > BLAKE2B_BLOCKLEN) {
            S->t[0] += BLAKE2B_BLOCKLEN;
            S->t[1] += (S->t[0] < BLAKE2B_BLOCKLEN);
            blake2b_compress(S, p);
            p += BLAKE2B_BLOCKLEN;
            len -= BLAKE2B_BLOCKLEN;
        }
    }

    memcpy(S->buf + S->buflen, p, len);
    S->buflen += len;
}

static void
blake2b_final(struct blake2b *S, void *out)
{
    uint8_t tmp[64];

    S->t[0] += (uint64_t)S->buflen;
    S->t[1] += (S->t[0] < (uint64_t)S->buflen);
    S->f[0] = ~(uint64_t)0;

    memset(S->buf + S->buflen, 0, BLAKE2B_BLOCKLEN - S->buflen);
    blake2b_compress(S, S->buf);

    for (int i = 0; i < 8; i++)
        store64(tmp + i * 8, S->h[i]);
    memcpy(out, tmp, S->outlen);
}

/****************************************************************
 * Hex encoding and hash validation
 ****************************************************************/

static const char hex_chars[] = "0123456789abcdef";

/** Encode binary to hex string.
 *  Encodes len bytes from bin into out as null-terminated hex string.
 *  out must be at least len*2+1 bytes.
 */
static void
to_hex(const uint8_t *bin, size_t len, char *out)
{
    for (size_t i = 0; i < len; i++) {
        out[i * 2]     = hex_chars[bin[i] >> 4];
        out[i * 2 + 1] = hex_chars[bin[i] & 0x0f];
    }
    out[len * 2] = '\0';
}

/** Validate hex hash string format.
 *  Checks that hash is exactly CAS_HASH_HEX characters of valid hex.
 *  Returns nonzero if valid, 0 if invalid.
 */
static int
valid_hash(const char *hash)
{
    if (strlen(hash) != CAS_HASH_HEX)
        return 0;
    for (int i = 0; i < CAS_HASH_HEX; i++) {
        char c = hash[i];

        if (!((c >= '0' && c <= '9') ||
              (c >= 'a' && c <= 'f') ||
              (c >= 'A' && c <= 'F')))
            return 0;
    }
    return 1;
}

/****************************************************************
 * Path helpers
 ****************************************************************/

struct cas {
    char *basedir;
    struct cas_pack *pack;
    int lock_fd;  /* exclusive lock on depot directory */
};

/** Validate basedir to prevent path traversal attacks.
 *  Returns 0 if valid, -1 if suspicious patterns detected.
 *  Checks: no ".." components, no symlinks leading outside.
 *  (realpath() requires the path to exist, so we do best-effort validation)
 */
static int
validate_basedir(const char *basedir)
{
    if (!basedir || !*basedir)
        return -1;

    /* Check for ".." path traversal attempts */
    const char *p = basedir;
    while (*p) {
        if (p[0] == '.' && p[1] == '.' && (p[2] == '/' || p[2] == '\0'))
            return -1;  /* ".." found */
        p++;
    }

    /* If path exists, verify it resolves cleanly.  realpath() can write
     * up to PATH_MAX bytes, which exceeds any fixed CAS_PATH_MAX buffer,
     * so let it allocate the result and free it. */
    if (access(basedir, F_OK) == 0) {
        char *canonical = realpath(basedir, NULL);

        if (canonical == NULL)
            return -1;  /* realpath failed or path is invalid */
        free(canonical);
    }

    return 0;
}

static int
build_path(const struct cas *store, const char *hash,
           char *buf, size_t bufsz)
{
    /* Construct object path: basedir/XX/HASH
     * Returns CAS_ERR if path would exceed buffer size (typically CAS_PATH_MAX).
     * If basedir is very long (>400 bytes), this will fail.
     * Use reasonable basedir paths to avoid truncation issues.
     */
    int n = snprintf(buf, bufsz, "%s/%.2s/%s",
                     store->basedir, hash, hash);

    if (n < 0 || (size_t)n >= bufsz)
        return CAS_ERR;
    return CAS_OK;
}

static int
build_dir(const struct cas *store, const char *hash,
          char *buf, size_t bufsz)
{
    /* Construct bucket directory path: basedir/XX
     * Returns CAS_ERR if path would exceed buffer size (typically CAS_PATH_MAX).
     * See build_path for notes on path length limits.
     */
    int n = snprintf(buf, bufsz, "%s/%.2s",
                     store->basedir, hash);

    if (n < 0 || (size_t)n >= bufsz)
        return CAS_ERR;
    return CAS_OK;
}

/****************************************************************
 * Locking
 ****************************************************************/

/** Acquire an exclusive lock on the depot.
 *  Opens .lock file in basedir and locks it with fcntl.
 *  Returns the open fd on success, or -1 on failure.
 *  The lock is held until cas_unlock_depot() or process exit.
 */
static int
cas_lock_depot(const char *basedir)
{
    char lockpath[CAS_PATH_MAX];
    int n = snprintf(lockpath, sizeof(lockpath), "%s/.lock", basedir);

    if (n < 0 || (size_t)n >= sizeof(lockpath))
        return -1;

    int fd = open(lockpath, O_WRONLY | O_CREAT, 0644);

    if (fd < 0)
        return -1;

    struct flock lock = {
        .l_type = F_WRLCK,     /* exclusive write lock */
        .l_whence = SEEK_SET,
        .l_start = 0,
        .l_len = 0,            /* lock entire file */
    };

    if (fcntl(fd, F_SETLKW, &lock) < 0) {
        CAS_LOG(CAS_LOG_ERR_LOCK_FAILED, NULL);
        close(fd);
        return -1;
    }

    CAS_LOG(CAS_LOG_LOCK_ACQUIRE, NULL);
    return fd;
}

/** Release the depot lock.
 *  Closes the lock fd, which implicitly releases the lock.
 */
static void
cas_unlock_depot(int lock_fd)
{
    if (lock_fd >= 0) {
        CAS_LOG(CAS_LOG_LOCK_RELEASE, NULL);
        close(lock_fd);
    }
}

/****************************************************************
 * Lifecycle
 ****************************************************************/

struct cas *
cas_new(const char *basedir)
{
    struct cas *store = calloc(1, sizeof(*store));

    if (!store)
        return NULL;
    store->basedir = strdup(basedir ? basedir : "depot");
    if (!store->basedir) {
        free(store);
        return NULL;
    }

    if (validate_basedir(store->basedir) != 0) {
        free(store->basedir);
        free(store);
        return NULL;
    }

    /* The lock file lives inside the depot, so the depot directory must
     * exist before we can create it.  Historically the depot was made
     * lazily on first write; the depot-wide lock now forces it here. */
    mkdir(store->basedir, 0755);

    store->lock_fd = cas_lock_depot(store->basedir);
    if (store->lock_fd < 0) {
        free(store->basedir);
        free(store);
        return NULL;
    }

    char packpath[CAS_PATH_MAX];

    if (snprintf(packpath, sizeof(packpath), "%s/pack.dat",
                 store->basedir) < (int)sizeof(packpath))
        store->pack = cas_pack_open(packpath);

    return store;
}

void
cas_free(struct cas *store)
{
    if (!store)
        return;
    cas_pack_close(store->pack);
    cas_unlock_depot(store->lock_fd);
    free(store->basedir);
    free(store);
}

const char *
cas_basedir(struct cas *store)
{
    return store->basedir;
}

/****************************************************************
 * Write / header helpers
 ****************************************************************/

/** Write data to fd, handling partial writes and EINTR.
 *  Continues until all len bytes are written or an error occurs.
 *  Returns CAS_OK on success, CAS_EIO on I/O error.
 */
static int
write_full(int fd, const void *data, size_t len)
{
    const uint8_t *p = data;

    while (len > 0) {
        ssize_t n = write(fd, p, len);

        if (n < 0) {
            if (errno == EINTR)
                continue;
            return CAS_EIO;
        }
        p += n;
        len -= (size_t)n;
    }
    return CAS_OK;
}

/** Format "type len\0" into buf, return total length including NUL. */
static int
format_header(char *buf, size_t bufsz, const char *type, size_t len)
{
    /* Validate type before formatting to prevent silent corruption.
     * type must be non-empty and within CAS_TYPE_MAX.
     * These preconditions match the expectations of parse_header.
     */
    if (!type || !*type)
        return -1;
    size_t typelen = strlen(type);
    if (typelen > CAS_TYPE_MAX)
        return -1;

    int n = snprintf(buf, bufsz, "%s %zu", type, len);

    if (n < 0 || (size_t)n + 1 > bufsz)
        return -1;
    return n + 1;
}

/** Parse "type len\0" from a nul-padded header buffer.
 *  Copies type into type_out (NUL-terminated).
 *  Sets content_len on success.
 */
static int
parse_header(const char *hdr, size_t hdrsz,
             char *type_out, size_t type_bufsz,
             size_t *content_len)
{
    size_t limit = hdrsz < CAS_HEADER_MAX ? hdrsz : CAS_HEADER_MAX;
    const char *nul = memchr(hdr, '\0', limit);

    if (!nul)
        return CAS_ERR;

    const char *sp = memchr(hdr, ' ', (size_t)(nul - hdr));

    if (!sp)
        return CAS_ERR;

    size_t typelen = (size_t)(sp - hdr);

    if (typelen == 0 || typelen > CAS_TYPE_MAX ||
        typelen + 1 > type_bufsz)
        return CAS_ERR;

    const char *d = sp + 1;

    if (d >= nul)
        return CAS_ERR;

    size_t len = 0;

    for (; d < nul; d++) {
        if (*d < '0' || *d > '9')
            return CAS_ERR;
        size_t prev = len;

        len = len * 10 + (size_t)(*d - '0');
        /* Detect overflow: wrapped value will be < prev.
         * Also apply reasonable upper bound (1GB) to reject absurdly
         * large sizes that can't be allocated or processed.
         * Note: cas-codec uses 1GB as its default upper limit.
         */
        if (len < prev || len > (size_t)1 << 30)
            return CAS_ERR;
    }

    memcpy(type_out, hdr, typelen);
    type_out[typelen] = '\0';
    *content_len = len;
    return CAS_OK;
}

/****************************************************************
 * Operations
 ****************************************************************/

int
cas_hash(const void *data, size_t len, char *hash_out)
{
    struct blake2b state;
    uint8_t digest[CAS_HASH_LEN];

    blake2b_init(&state, CAS_HASH_LEN);
    blake2b_update(&state, data, len);
    blake2b_final(&state, digest);
    to_hex(digest, CAS_HASH_LEN, hash_out);
    return CAS_OK;
}

int
cas_hash_object(const char *type, const void *data, size_t len,
                char *hash_out)
{
    char hdr[CAS_HEADER_MAX];
    int hdrlen = format_header(hdr, sizeof(hdr), type, len);

    if (hdrlen < 0)
        return CAS_ERR;

    struct blake2b state;
    uint8_t digest[CAS_HASH_LEN];

    blake2b_init(&state, CAS_HASH_LEN);
    blake2b_update(&state, hdr, (size_t)hdrlen);
    blake2b_update(&state, data, len);
    blake2b_final(&state, digest);
    to_hex(digest, CAS_HASH_LEN, hash_out);
    return CAS_OK;
}

/****************************************************************
 * cas_file teardown
 ****************************************************************/

/** Cleanup for mmap-backed cas_file.
 *  Unmaps the mmap region. Used as _release callback.
 */
static void
release_munmap(struct cas_file *cf)
{
    munmap(cf->_priv, cf->_privlen);
}

/** Cleanup for malloc-backed cas_file.
 *  Frees the heap buffer. Used as _release callback.
 */
static void
release_free(struct cas_file *cf)
{
    free(cf->_priv);
}

int
cas_open_object(struct cas *store, struct cas_file *cf,
                const char *hash, char *type_out, size_t type_bufsz)
{
    CAS_LOG(CAS_LOG_OPEN_START, hash);

    if (!valid_hash(hash))
        return CAS_ERR;

    if (store->pack) {
        int rc = cas_pack_lookup(store->pack, cf, hash,
                                 type_out, type_bufsz);

        if (rc != CAS_ENOTFOUND)
            return rc;
    }

    char path[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;

    int fd = open(path, O_RDONLY);

    if (fd < 0)
        return CAS_ENOTFOUND;

    struct stat sb;

    if (fstat(fd, &sb) != 0) {
        close(fd);
        return CAS_EIO;
    }

    /* Validate file size before casting and mmapping.
     * st_size is signed (off_t); a negative value indicates corruption.
     * Also enforce an upper bound (1GB) to prevent memory exhaustion
     * and match cas-codec limits.
     */
    if (sb.st_size < (off_t)CAS_PACK_BLOCK || sb.st_size > (off_t)(1 << 30)) {
        close(fd);
        return CAS_ERR;
    }

    size_t filesz = (size_t)sb.st_size;

    void *ptr = mmap(NULL, filesz, PROT_READ, MAP_PRIVATE, fd, 0);

    close(fd);
    if (ptr == MAP_FAILED) {
        CAS_LOG(CAS_LOG_ERR_MMAP, NULL);
        return CAS_EIO;
    }

    CAS_LOG(CAS_LOG_OPEN_MMAP, NULL);

    const struct cas_pack_trailer *tr =
        (const struct cas_pack_trailer *)
        ((char *)ptr + filesz - CAS_PACK_BLOCK);

    static const unsigned char magic_v1[] = CAS_PACK_TRAILER_MAGIC;
    static const unsigned char magic_v2[] = CAS_PACK_TRAILER_MAGIC_V2;
    int framed;

    if (memcmp(tr->magic, magic_v1, CAS_PACK_MAGIC_LEN) == 0)
        framed = 0;
    else if (memcmp(tr->magic, magic_v2, CAS_PACK_MAGIC_LEN) == 0)
        framed = 1;
    else {
        munmap(ptr, filesz);
        return CAS_ERR;
    }

    char type[CAS_TYPE_MAX + 1];
    size_t content_len;

    if (parse_header(tr->header, CAS_PACK_HEADER_LEN,
                     type, sizeof(type),
                     &content_len) != CAS_OK) {
        munmap(ptr, filesz);
        return CAS_ERR;
    }

    if (type_out) {
        if (strlen(type) >= type_bufsz) {
            munmap(ptr, filesz);
            return CAS_ERR;
        }
        memcpy(type_out, type, strlen(type) + 1);
    }

    const unsigned char *data;
    size_t len;
    unsigned char *owned;

    CAS_LOG(CAS_LOG_OPEN_DECODE_START, NULL);
    int rc = cas_codec_region_decode(ptr, filesz - CAS_PACK_BLOCK,
                                     framed, content_len,
                                     &data, &len, &owned);

    if (rc != CAS_OK) {
        CAS_LOG(CAS_LOG_ERR_DECODE, NULL);
        munmap(ptr, filesz);
        return rc;
    }

    CAS_LOG(CAS_LOG_OPEN_DECODE_DONE, NULL);

    if (owned) {
        /* decoded into a heap buffer; the source is no longer needed */
        munmap(ptr, filesz);
        cf->_priv = owned;
        cf->_privlen = 0;
        cf->_release = release_free;
    } else {
        /* zero-copy view into the mmap */
        cf->_priv = ptr;
        cf->_privlen = filesz;
        cf->_release = release_munmap;
    }
    cf->data = data;
    cf->len = len;
    return CAS_OK;
}

int
cas_open_loose_raw(struct cas *store, struct cas_file *cf,
                   const char *hash, void *trailer_out)
{
    if (!valid_hash(hash))
        return CAS_ERR;

    char path[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;

    int fd = open(path, O_RDONLY);

    if (fd < 0)
        return CAS_ENOTFOUND;

    struct stat sb;

    if (fstat(fd, &sb) != 0) {
        close(fd);
        return CAS_EIO;
    }

    /* Validate file size before casting and mmapping.
     * st_size is signed (off_t); a negative value indicates corruption.
     * Also enforce an upper bound (1GB) to prevent memory exhaustion
     * and match cas-codec limits.
     */
    if (sb.st_size < (off_t)CAS_PACK_BLOCK || sb.st_size > (off_t)(1 << 30)) {
        close(fd);
        return CAS_ERR;
    }

    size_t filesz = (size_t)sb.st_size;

    void *ptr = mmap(NULL, filesz, PROT_READ, MAP_PRIVATE, fd, 0);

    close(fd);
    if (ptr == MAP_FAILED)
        return CAS_EIO;

    const struct cas_pack_trailer *tr =
        (const struct cas_pack_trailer *)
        ((char *)ptr + filesz - CAS_PACK_BLOCK);

    static const unsigned char magic_v1[] = CAS_PACK_TRAILER_MAGIC;
    static const unsigned char magic_v2[] = CAS_PACK_TRAILER_MAGIC_V2;

    if (memcmp(tr->magic, magic_v1, CAS_PACK_MAGIC_LEN) != 0 &&
        memcmp(tr->magic, magic_v2, CAS_PACK_MAGIC_LEN) != 0) {
        munmap(ptr, filesz);
        return CAS_ERR;
    }

    memcpy(trailer_out, tr, CAS_PACK_BLOCK);

    cf->_priv = ptr;
    cf->_privlen = filesz;
    cf->_release = release_munmap;
    cf->data = (const unsigned char *)ptr;
    cf->len = filesz - CAS_PACK_BLOCK;
    return CAS_OK;
}

int
cas_open(struct cas *store, struct cas_file *cf, const char *hash)
{
    char type[CAS_TYPE_MAX + 1];
    int rc = cas_open_object(store, cf, hash, type, sizeof(type));

    if (rc != CAS_OK)
        return rc;
    if (strcmp(type, "blob") != 0) {
        cas_close(cf);
        return CAS_ETYPE;
    }
    return CAS_OK;
}

void
cas_close(struct cas_file *cf)
{
    /* Save and clear the release function pointer before calling it.
     * This makes cas_close idempotent: calling it multiple times is safe.
     * On the second call, _release is NULL, so nothing happens.
     */
    void (*release_fn)(struct cas_file *cf) = cf->_release;
    cf->_release = NULL;

    if (release_fn)
        release_fn(cf);

    cf->data = NULL;
    cf->len = 0;
    cf->_priv = NULL;
    cf->_privlen = 0;
}

int
cas_put_object(struct cas *store, const char *type,
               const void *data, size_t len, char *hash_out)
{
    char hdr[CAS_HEADER_MAX];
    int hdrlen = format_header(hdr, sizeof(hdr), type, len);

    if (hdrlen < 0 || (size_t)hdrlen > CAS_PACK_HEADER_LEN)
        return CAS_ERR;

    struct blake2b state;
    uint8_t digest[CAS_HASH_LEN];

    blake2b_init(&state, CAS_HASH_LEN);
    blake2b_update(&state, hdr, (size_t)hdrlen);
    blake2b_update(&state, data, len);
    blake2b_final(&state, digest);

    char hash[CAS_HASH_HEX + 1];

    to_hex(digest, CAS_HASH_LEN, hash);

    char path[CAS_PATH_MAX];
    char dir[CAS_PATH_MAX];
    char tmp[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;
    if (build_dir(store, hash, dir, sizeof(dir)) != CAS_OK)
        return CAS_ERR;

    if (access(path, F_OK) == 0 ||
        (store->pack && cas_pack_exists(store->pack, hash))) {
        memcpy(hash_out, hash, CAS_HASH_HEX + 1);
        return CAS_OK;
    }

    mkdir(store->basedir, 0755);
    mkdir(dir, 0755);

    /* Check that temp filename fits in buffer before mkstemp. */
    if (snprintf(tmp, sizeof(tmp), "%s/.cas.XXXXXX", dir) >=
        (int)sizeof(tmp))
        return CAS_ERR;

    int fd = mkstemp(tmp);

    if (fd < 0)
        return CAS_EIO;

    CAS_LOG(CAS_LOG_PUT_TEMP_CREATE, NULL);

    int rc;

    if (len > 0) {
        rc = write_full(fd, data, len);
        if (rc != CAS_OK) {
            CAS_LOG(CAS_LOG_ERR_WRITE, NULL);
            close(fd);
            unlink(tmp);
            return rc;
        }
        CAS_LOG(CAS_LOG_PUT_WRITE_DATA, NULL);
    }

    struct cas_pack_trailer tr;
    static const unsigned char magic[] = CAS_PACK_TRAILER_MAGIC;

    memcpy(tr.magic, magic, CAS_PACK_MAGIC_LEN);
    memset(tr.header, 0, CAS_PACK_HEADER_LEN);
    memcpy(tr.header, hdr, (size_t)hdrlen);

    rc = write_full(fd, &tr, sizeof(tr));
    if (rc != CAS_OK) {
        close(fd);
        unlink(tmp);
        return rc;
    }

    if (fsync(fd) != 0) {
        CAS_LOG(CAS_LOG_ERR_FSYNC, NULL);
        close(fd);
        unlink(tmp);
        return CAS_EIO;
    }

    CAS_LOG(CAS_LOG_PUT_FSYNC, NULL);
    close(fd);

    /* Atomically move temp file to final location.
     * If rename fails (rare on local filesystems, possible on NFS),
     * check if the target already exists. This handles dedup: if another
     * process wrote the same hash before our rename completed, the target
     * file is already there. With the depot lock held (Item 2), only
     * external processes can create races; internal concurrent access is
     * serialized. Treat target existence as a dedup success.
     */
    if (rename(tmp, path) != 0) {
        CAS_LOG(CAS_LOG_ERR_RENAME, NULL);
        unlink(tmp);
        if (access(path, F_OK) != 0)
            return CAS_EIO;
        /* Target exists: dedup success, fall through */
    } else {
        CAS_LOG(CAS_LOG_PUT_RENAME, NULL);
    }

    memcpy(hash_out, hash, CAS_HASH_HEX + 1);
    return CAS_OK;
}

int
cas_put_object_at(struct cas *store, const char *type,
                  const void *data, size_t len,
                  const char *hash)
{
    if (!valid_hash(hash))
        return CAS_ERR;

    char hdr[CAS_HEADER_MAX];
    int hdrlen = format_header(hdr, sizeof(hdr), type, len);

    if (hdrlen < 0 || (size_t)hdrlen > CAS_PACK_HEADER_LEN)
        return CAS_ERR;

    char path[CAS_PATH_MAX];
    char dir[CAS_PATH_MAX];
    char tmp[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;
    if (build_dir(store, hash, dir, sizeof(dir)) != CAS_OK)
        return CAS_ERR;

    if (access(path, F_OK) == 0 ||
        (store->pack && cas_pack_exists(store->pack, hash)))
        return CAS_OK;

    mkdir(store->basedir, 0755);
    mkdir(dir, 0755);

    /* Check that temp filename fits in buffer before mkstemp. */
    if (snprintf(tmp, sizeof(tmp), "%s/.cas.XXXXXX", dir) >=
        (int)sizeof(tmp))
        return CAS_ERR;

    int fd = mkstemp(tmp);

    if (fd < 0)
        return CAS_EIO;

    int rc;

    if (len > 0) {
        rc = write_full(fd, data, len);
        if (rc != CAS_OK) {
            close(fd);
            unlink(tmp);
            return rc;
        }
    }

    struct cas_pack_trailer tr;
    static const unsigned char magic[] = CAS_PACK_TRAILER_MAGIC;

    memcpy(tr.magic, magic, CAS_PACK_MAGIC_LEN);
    memset(tr.header, 0, CAS_PACK_HEADER_LEN);
    memcpy(tr.header, hdr, (size_t)hdrlen);

    rc = write_full(fd, &tr, sizeof(tr));
    if (rc != CAS_OK) {
        close(fd);
        unlink(tmp);
        return rc;
    }

    if (fsync(fd) != 0) {
        close(fd);
        unlink(tmp);
        return CAS_EIO;
    }

    close(fd);

    /* Atomically move temp file to final location.
     * See cas_put_object for dedup logic and TOCTOU analysis.
     */
    if (rename(tmp, path) != 0) {
        unlink(tmp);
        if (access(path, F_OK) != 0)
            return CAS_EIO;
        /* Target exists: dedup success, fall through */
    }

    return CAS_OK;
}

int
cas_put_precompressed(struct cas *store, const char *type, int codec,
                      const void *payload, size_t payload_len,
                      size_t plaintext_len, const char *hash)
{
    if (!valid_hash(hash) || codec < 0 || codec > 255)
        return CAS_ERR;

    /* an uncompressed payload must match the plaintext length */
    if (codec == CAS_CODEC_NONE && payload_len != plaintext_len)
        return CAS_ERR;

    char hdr[CAS_HEADER_MAX];
    int hdrlen = format_header(hdr, sizeof(hdr), type, plaintext_len);

    if (hdrlen < 0 || (size_t)hdrlen > CAS_PACK_HEADER_LEN)
        return CAS_ERR;

    char path[CAS_PATH_MAX];
    char dir[CAS_PATH_MAX];
    char tmp[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;
    if (build_dir(store, hash, dir, sizeof(dir)) != CAS_OK)
        return CAS_ERR;

    if (access(path, F_OK) == 0 ||
        (store->pack && cas_pack_exists(store->pack, hash)))
        return CAS_OK;

    mkdir(store->basedir, 0755);
    mkdir(dir, 0755);

    /* Check that temp filename fits in buffer before mkstemp. */
    if (snprintf(tmp, sizeof(tmp), "%s/.cas.XXXXXX", dir) >=
        (int)sizeof(tmp))
        return CAS_ERR;

    int fd = mkstemp(tmp);

    if (fd < 0)
        return CAS_EIO;

    /* data region: [ codec tag(1) | payload ] */
    unsigned char cb = (unsigned char)codec;
    int rc = write_full(fd, &cb, 1);

    if (rc == CAS_OK && payload_len > 0)
        rc = write_full(fd, payload, payload_len);
    if (rc != CAS_OK) {
        close(fd);
        unlink(tmp);
        return rc;
    }

    struct cas_pack_trailer tr;
    static const unsigned char magic[] = CAS_PACK_TRAILER_MAGIC_V2;

    memcpy(tr.magic, magic, CAS_PACK_MAGIC_LEN);
    memset(tr.header, 0, CAS_PACK_HEADER_LEN);
    memcpy(tr.header, hdr, (size_t)hdrlen);

    rc = write_full(fd, &tr, sizeof(tr));
    if (rc != CAS_OK) {
        close(fd);
        unlink(tmp);
        return rc;
    }

    if (fsync(fd) != 0) {
        close(fd);
        unlink(tmp);
        return CAS_EIO;
    }

    close(fd);

    /* Atomically move temp file to final location.
     * See cas_put_object for dedup logic and TOCTOU analysis.
     */
    if (rename(tmp, path) != 0) {
        unlink(tmp);
        if (access(path, F_OK) != 0)
            return CAS_EIO;
        /* Target exists: dedup success, fall through */
    }

    return CAS_OK;
}

int
cas_put_object_z(struct cas *store, const char *type, int codec,
                 const void *data, size_t len, char *hash_out)
{
    char hash[CAS_HASH_HEX + 1];

    if (cas_hash_object(type, data, len, hash) != CAS_OK)
        return CAS_ERR;

    /* skip a pointless compression attempt on a known object */
    if (cas_exists(store, hash)) {
        memcpy(hash_out, hash, CAS_HASH_HEX + 1);
        return CAS_OK;
    }

    /* Try to compress if enabled and object is large enough.
     * Keep compressed form only if savings justify codec overhead.
     * The savings threshold is configurable via cas_compression_config().
     * Already-compressed data (e.g., JPEG) is not re-compressed,
     * so codec attempt is a sunk cost; keep result only if it wins.
     */
    if (cas__compress_cfg.enabled && codec != CAS_CODEC_NONE &&
        len >= cas__compress_cfg.min_size &&
        cas_codec_can_encode(codec)) {
        unsigned char *buf = malloc(len);

        if (buf) {
            size_t plen = len;
            int rc = cas_codec_encode(codec, data, len, buf, &plen);

            /* Calculate minimum savings required (in bytes).
             * Example: 1000B object, 12% savings = 120B savings required
             * So compressed must be < 1000 - 120 = 880 bytes (plus 1 byte for codec tag)
             */
            size_t min_savings = len * (size_t)cas__compress_cfg.min_savings_pct / 100;

            if (rc == CAS_OK && plen + 1 < len - min_savings) {
                rc = cas_put_precompressed(store, type, codec, buf,
                                           plen, len, hash);
                free(buf);
                if (rc == CAS_OK)
                    memcpy(hash_out, hash, CAS_HASH_HEX + 1);
                return rc;
            }
            free(buf);
        }
    }

    /* not worth compressing: store raw at the same address */
    int rc = cas_put_object_at(store, type, data, len, hash);

    if (rc == CAS_OK)
        memcpy(hash_out, hash, CAS_HASH_HEX + 1);
    return rc;
}

int
cas_put(struct cas *store, const void *data, size_t len,
        char *hash_out)
{
    return cas_put_object(store, "blob", data, len, hash_out);
}

int
cas_exists(struct cas *store, const char *hash)
{
    if (!valid_hash(hash))
        return 0;
    if (store->pack && cas_pack_exists(store->pack, hash))
        return 1;

    char path[CAS_PATH_MAX];

    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return 0;
    return access(path, F_OK) == 0;
}

/****************************************************************
 * Iteration
 ****************************************************************/

int
cas_foreach(struct cas *store, cas_foreach_fn fn, void *ctx)
{
    DIR *top = opendir(store->basedir);

    if (!top) {
        /* Distinguish between "directory not found" (OK for new depot)
         * and other errors (permission, I/O, etc., which should be
         * reported so callers can detect corruption/access issues).
         */
        if (errno == ENOENT)
            return CAS_OK;  /* Depot dir not created yet; OK */
        return CAS_EIO;     /* Other error: permission, I/O, etc. */
    }

    struct dirent *bucket;

    while ((bucket = readdir(top)) != NULL) {
        if (strlen(bucket->d_name) != 2)
            continue;
        if (!((bucket->d_name[0] >= '0' && bucket->d_name[0] <= '9') ||
              (bucket->d_name[0] >= 'a' && bucket->d_name[0] <= 'f')))
            continue;

        char subpath[CAS_PATH_MAX];

        if (snprintf(subpath, sizeof(subpath), "%s/%s",
                     store->basedir, bucket->d_name) >=
            (int)sizeof(subpath))
            continue;

        DIR *sub = opendir(subpath);

        if (!sub)
            continue;

        struct dirent *ent;

        while ((ent = readdir(sub)) != NULL) {
            if (!valid_hash(ent->d_name))
                continue;
            if (strncmp(ent->d_name, bucket->d_name, 2) != 0)
                continue;
            if (fn(ent->d_name, ctx) != 0) {
                closedir(sub);
                closedir(top);
                return CAS_OK;
            }
        }
        closedir(sub);
    }
    closedir(top);
    return CAS_OK;
}

/****************************************************************
 * Fsck
 ****************************************************************/

int
cas_type_is_reencoded(const char *type)
{
    return strcmp(type, "htree") == 0;
}

int
cas_fsck_object(struct cas *store, const char *hash)
{
    if (!valid_hash(hash))
        return CAS_FSCK_BADNAME;

    struct cas_file cf;
    struct cas_pack_trailer tr;
    int rc = cas_open_loose_raw(store, &cf, hash, &tr);

    if (rc == CAS_ENOTFOUND || rc == CAS_EIO)
        return CAS_FSCK_IOERR;
    if (rc != CAS_OK)
        return CAS_FSCK_CORRUPT;

    static const unsigned char magic_v2[] = CAS_PACK_TRAILER_MAGIC_V2;
    int framed = memcmp(tr.magic, magic_v2, CAS_PACK_MAGIC_LEN) == 0;

    char type[CAS_TYPE_MAX + 1];
    size_t content_len;

    if (parse_header(tr.header, CAS_PACK_HEADER_LEN,
                     type, sizeof(type), &content_len) != CAS_OK) {
        cas_close(&cf);
        return CAS_FSCK_CORRUPT;
    }

    /* An htree is addressed by its canonical text form, not its own
     * bytes, so it cannot be verified here; cas_tree_fsck does it. */
    if (cas_type_is_reencoded(type)) {
        cas_close(&cf);
        return CAS_FSCK_REENCODED;
    }

    /* decode to plaintext, then rehash "type len\0" || plaintext */
    const unsigned char *data;
    size_t len;
    unsigned char *owned;

    rc = cas_codec_region_decode(cf.data, cf.len, framed, content_len,
                                 &data, &len, &owned);
    if (rc == CAS_ETYPE) {
        /* codec not compiled in: the object cannot be verified */
        cas_close(&cf);
        return CAS_FSCK_NOCODEC;
    }
    if (rc == CAS_ENOMEM) {
        cas_close(&cf);
        return CAS_FSCK_IOERR;
    }
    if (rc != CAS_OK) {
        cas_close(&cf);
        return CAS_FSCK_CORRUPT;
    }

    unsigned char digest[CAS_HASH_LEN];
    char actual[CAS_HASH_HEX + 1];

    cas_digest_object(type, data, len, digest);
    to_hex(digest, CAS_HASH_LEN, actual);

    free(owned);
    cas_close(&cf);

    return strcmp(actual, hash) == 0 ? CAS_FSCK_OK : CAS_FSCK_CORRUPT;
}

struct cas_fsck_ctx {
    struct cas *store;
    cas_fsck_fn fn;
    void *ctx;
    int errors;
};

static int
fsck_visitor(const char *hash, void *ctx)
{
    struct cas_fsck_ctx *fc = ctx;
    int status = cas_fsck_object(fc->store, hash);

    /* NOCODEC and REENCODED are skips, not corruption: reported,
     * not counted */
    if (status != CAS_FSCK_OK && status != CAS_FSCK_NOCODEC &&
        status != CAS_FSCK_REENCODED)
        fc->errors++;
    if (fc->fn)
        return fc->fn(hash, status, fc->ctx);
    return 0;
}

int
cas_fsck(struct cas *store, cas_fsck_fn fn, void *ctx)
{
    struct cas_fsck_ctx fc = {
        .store = store,
        .fn = fn,
        .ctx = ctx,
        .errors = 0,
    };

    cas_foreach(store, fsck_visitor, &fc);
    return fc.errors ? CAS_ERR : CAS_OK;
}

/****************************************************************
 * Remove
 ****************************************************************/

int
cas_remove(struct cas *store, const char *hash)
{
    char path[CAS_PATH_MAX];

    if (!valid_hash(hash))
        return CAS_ERR;
    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;
    if (unlink(path) != 0)
        return errno == ENOENT ? CAS_ENOTFOUND : CAS_EIO;
    return CAS_OK;
}

int
cas_object_mtime(struct cas *store, const char *hash, time_t *mtime_out)
{
    char path[CAS_PATH_MAX];

    if (!valid_hash(hash))
        return CAS_ERR;
    if (build_path(store, hash, path, sizeof(path)) != CAS_OK)
        return CAS_ERR;

    struct stat sb;

    if (stat(path, &sb) != 0)
        return errno == ENOENT ? CAS_ENOTFOUND : CAS_EIO;
    *mtime_out = sb.st_mtime;
    return CAS_OK;
}

/****************************************************************
 * Public binary hash helpers
 ****************************************************************/

void
cas_digest(const void *data, size_t len, unsigned char *out)
{
    struct blake2b state;

    blake2b_init(&state, CAS_HASH_LEN);
    blake2b_update(&state, data, len);
    blake2b_final(&state, out);
}

void
cas_digest_object(const char *type, const void *data, size_t len,
                  unsigned char *out)
{
    char hdr[CAS_HEADER_MAX];
    int hdrlen = snprintf(hdr, sizeof(hdr), "%s %zu", type, len);

    if (hdrlen < 0 || (size_t)hdrlen >= sizeof(hdr))
        return;
    hdrlen++;

    struct blake2b state;

    blake2b_init(&state, CAS_HASH_LEN);
    blake2b_update(&state, hdr, (size_t)hdrlen);
    blake2b_update(&state, data, len);
    blake2b_final(&state, out);
}

void
cas_hex_encode(const unsigned char *bin, size_t len, char *out)
{
    to_hex(bin, len, out);
}

int
cas_hex_decode(const char *hex, size_t hexlen,
               unsigned char *out, size_t outsz)
{
    if (hexlen % 2 != 0 || hexlen / 2 > outsz)
        return CAS_ERR;
    for (size_t i = 0; i < hexlen; i += 2) {
        int hi, lo;
        char c;

        c = hex[i];
        if (c >= '0' && c <= '9')      hi = c - '0';
        else if (c >= 'a' && c <= 'f')  hi = c - 'a' + 10;
        else if (c >= 'A' && c <= 'F')  hi = c - 'A' + 10;
        else return CAS_ERR;

        c = hex[i + 1];
        if (c >= '0' && c <= '9')      lo = c - '0';
        else if (c >= 'a' && c <= 'f')  lo = c - 'a' + 10;
        else if (c >= 'A' && c <= 'F')  lo = c - 'A' + 10;
        else return CAS_ERR;

        out[i / 2] = (unsigned char)((hi << 4) | lo);
    }
    return CAS_OK;
}

int
cas_valid_hash(const char *hash)
{
    return valid_hash(hash);
}
