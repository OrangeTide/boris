/* cas.h : content-addressable store using BLAKE2b hashing */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#ifndef CAS_H
#define CAS_H

#include <stddef.h>
#include <time.h>

/****************************************************************
 * Constants
 ****************************************************************/

#define CAS_HASH_LEN 32  // BLAKE2b-256 digest bytes
#define CAS_HASH_HEX 64  // hex-encoded digest length
#define CAS_TYPE_MAX 16   // max length of object type string

enum {
    CAS_OK        =  0,
    CAS_ERR       = -1,
    CAS_ENOTFOUND = -2,
    CAS_ENOMEM    = -3,
    CAS_EIO       = -4,
    CAS_ETYPE     = -5,
};

/** Return a human-readable string for a CAS error code. */
const char *
cas_strerror(int err);

/****************************************************************
 * Logging (optional, disabled by default)
 ****************************************************************/

/** Logging event codes. Stock messages are provided by cas_log_strerror().
 *  Callers provide context via __FILE__ and __LINE__ pointers.
 */
enum cas_log_code {
    /* Open/read operations */
    CAS_LOG_OPEN_START = 1,
    CAS_LOG_OPEN_MMAP,
    CAS_LOG_OPEN_DECODE_START,
    CAS_LOG_OPEN_DECODE_DONE,

    /* Write operations */
    CAS_LOG_PUT_TEMP_CREATE = 20,
    CAS_LOG_PUT_WRITE_DATA,
    CAS_LOG_PUT_FSYNC,
    CAS_LOG_PUT_RENAME,

    /* Lock operations */
    CAS_LOG_LOCK_ACQUIRE = 40,
    CAS_LOG_LOCK_RELEASE,

    /* Iteration/fsck */
    CAS_LOG_FOREACH_START = 60,
    CAS_LOG_FSCK_CHECK,

    /* Errors */
    CAS_LOG_ERR_LOCK_FAILED = 100,
    CAS_LOG_ERR_MALLOC,
    CAS_LOG_ERR_MMAP,
    CAS_LOG_ERR_WRITE,
    CAS_LOG_ERR_DECODE,
    CAS_LOG_ERR_UNLINK,
    CAS_LOG_ERR_RENAME,
    CAS_LOG_ERR_FSYNC,
};

/** Logging callback type. Called with event code, source location, and optional
 *  message. Stock message is available via cas_log_strerror(code).
 *  msg may be NULL; file and line are always valid.
 */
typedef void (*cas_log_fn)(int code, const char *file, int line,
                           const char *msg, void *ctx);

/** Register a logging callback. Only one callback may be active at a time.
 *  Returns CAS_OK on success, CAS_ENOMEM on allocation failure.
 *  Call cas_log_unregister() to disable logging.
 */
int
cas_log_register(cas_log_fn fn, void *ctx);

/** Unregister the logging callback and disable logging. */
void
cas_log_unregister(void);

/** Return the stock message for a logging event code. */
const char *
cas_log_strerror(int code);

/****************************************************************
 * Compression Policy (optional, defaults apply if not set)
 ****************************************************************/

/** Compression policy configuration.
 *  Controls whether and when cas_put_object_z() compresses objects.
 *  All fields optional; use 0 for defaults.
 */
struct cas_compress_config {
    /** Enable compression (1 = yes, 0 = disable all compression) */
    int enabled;

    /** Minimum object size to attempt compression, in bytes (0 = default 512).
     *  Very small objects add more codec overhead than they save.
     */
    size_t min_size;

    /** Minimum savings to keep compressed form, as percentage (0 = default 12).
     *  If compressed size + tag does not save at least this percentage of
     *  plaintext, store the raw form instead. Range: 1-99.
     */
    int min_savings_pct;
};

/** Set global compression policy. Returns CAS_OK on success.
 *  All fields in cfg are copied; caller retains ownership.
 *  Set cfg to NULL to use hard-coded defaults (512B minimum, 12% savings).
 */
int
cas_compression_config(const struct cas_compress_config *cfg);

/** Reset compression policy to hard-coded defaults.
 *  Equivalent to cas_compression_config(NULL).
 */
void
cas_compression_reset(void);

/****************************************************************
 * Data structures
 ****************************************************************/

/** Opaque store handle. */
struct cas;

/** Handle to an open object.
 *
 *  data/len are the object's plaintext.  The remaining fields are
 *  private teardown state: cas_close() invokes _release (if set)
 *  to unmap or free whatever backs the data, so callers never
 *  handle the storage kind themselves.  An uncompressed object
 *  points data straight into an mmap; a compressed object is
 *  decoded into a heap buffer.
 */
struct cas_file {
    const unsigned char *data;
    size_t len;
    void *_priv;
    size_t _privlen;
    void (*_release)(struct cas_file *cf);
};

/****************************************************************
 * Lifecycle
 ****************************************************************/

/** Create a new CAS rooted at basedir (e.g. "depot").
 *  Returns NULL on alloc failure.
 */
struct cas *
cas_new(const char *basedir);

/** Destroy a CAS handle and free memory. */
void
cas_free(struct cas *store);

/** Return the base directory path. */
const char *
cas_basedir(struct cas *store);

/****************************************************************
 * Operations
 ****************************************************************/

/** Open a blob by hex hash for reading (mmap).
 *  On success cf->data and cf->len are set.
 *  Returns CAS_ETYPE if the stored object is not a blob.
 */
int
cas_open(struct cas *store, struct cas_file *cf, const char *hash);

/** Open a typed object by hex hash for reading (mmap).
 *  If type_out is non-NULL, the object type is copied there.
 */
int
cas_open_object(struct cas *store, struct cas_file *cf,
                const char *hash, char *type_out, size_t type_bufsz);

/** Close a previously opened object. */
void
cas_close(struct cas_file *cf);

/** Store data as a blob and return its hash as hex.
 *  hash_out must be at least CAS_HASH_HEX + 1 bytes.
 */
int
cas_put(struct cas *store, const void *data, size_t len,
        char *hash_out);

/** Store a typed object and return its hash as hex.
 *  The hash covers "type len\0" || data.
 */
int
cas_put_object(struct cas *store, const char *type,
               const void *data, size_t len, char *hash_out);

/** Store a typed object at a caller-supplied hash address.
 *  The hash is NOT recomputed — the caller is responsible for
 *  providing the correct canonical hash.
 */
int
cas_put_object_at(struct cas *store, const char *type,
                  const void *data, size_t len,
                  const char *hash);

/** Store a typed object, compressing it with codec if that saves
 *  enough space.  The object is hashed over its plaintext, so the
 *  address is identical to cas_put_object regardless of whether
 *  compression wins.  The compressed form is kept only when it
 *  beats the raw size by a comfortable margin and an encoder for
 *  codec is registered (see cas-codec.h); otherwise the object is
 *  stored raw.  Already-compressed or incompressible data thus
 *  costs nothing but a compression attempt.
 *
 *  Returns CAS_OK on success, CAS_ERR on a bad type/length, or an
 *  I/O error code on write failure.
 */
int
cas_put_object_z(struct cas *store, const char *type, int codec,
                 const void *data, size_t len, char *hash_out);

/** Store an already-compressed object at its plaintext hash
 *  address without compressing, hashing, or decompressing.
 *
 *  codec is the codec tag (see cas-codec.h) describing payload;
 *  payload/payload_len is the stored codec payload; plaintext_len
 *  is the uncompressed length, which is what the header records
 *  and what the address is derived from.  The caller supplies the
 *  canonical hash, which is not recomputed or verified here.
 *
 *  This is the ingest path for pre-compressed downloads: the blob
 *  stays small over the wire and on disk, and the client does no
 *  compression work.  Reads transparently decode it, provided a
 *  decoder for codec is registered.
 *
 *  Returns CAS_OK on success (or if the object already exists),
 *  CAS_ERR on a bad hash or oversized header, CAS_EIO on I/O
 *  failure.
 */
int
cas_put_precompressed(struct cas *store, const char *type, int codec,
                      const void *payload, size_t payload_len,
                      size_t plaintext_len, const char *hash);

/** Check whether an object with the given hex hash exists.
 *  Returns nonzero if present, 0 if not.
 */
int
cas_exists(struct cas *store, const char *hash);

/** Low-level: open a loose object's raw on-disk data region
 *  without decoding it.  cf->data points to the stored region
 *  (codec framing intact for v2 objects) and cf->len is the
 *  region length, not the plaintext length.  The 64-byte trailer
 *  is copied to trailer_out (which must be at least
 *  CAS_PACK_BLOCK bytes).  Used by the packer to roll objects up
 *  without inflating compressed ones.  Close with cas_close.
 *
 *  Returns CAS_OK, CAS_ENOTFOUND if not a loose object, CAS_ERR
 *  on a bad hash or malformed trailer, CAS_EIO on I/O failure.
 */
int
cas_open_loose_raw(struct cas *store, struct cas_file *cf,
                   const char *hash, void *trailer_out);

/** Compute the raw BLAKE2b-256 hash of data without storing. */
int
cas_hash(const void *data, size_t len, char *hash_out);

/** Compute the hash of a typed object without storing.
 *  Hashes "type len\0" || data.
 */
int
cas_hash_object(const char *type, const void *data, size_t len,
                char *hash_out);

/****************************************************************
 * Iteration
 ****************************************************************/

/** Callback for cas_foreach.  Called with each object hash.
 *  Return 0 to continue, nonzero to stop.
 */
typedef int (*cas_foreach_fn)(const char *hash, void *ctx);

/** Iterate over all objects in the store. */
int
cas_foreach(struct cas *store, cas_foreach_fn fn, void *ctx);

/****************************************************************
 * Fsck
 ****************************************************************/

/** Result codes for cas_fsck_fn callback. */
enum {
    CAS_FSCK_OK,
    CAS_FSCK_CORRUPT,
    CAS_FSCK_BADNAME,
    CAS_FSCK_IOERR,
    CAS_FSCK_NOCODEC,    /* compressed, but no decoder to verify with */
    CAS_FSCK_REENCODED,  /* re-encoded object (htree); verify at the
                            tree layer with cas_tree_fsck */
};

/** Callback for cas_fsck.  Called for each object checked.  status
 *  is one of CAS_FSCK_OK/CORRUPT/BADNAME/IOERR/NOCODEC/REENCODED.
 *  NOCODEC means the object is compressed with a codec not compiled
 *  in, so it could not be verified.  REENCODED means the object is an
 *  htree, whose address commits to its canonical text form rather than
 *  to its stored bytes; this layer does not decode it, so verifying it
 *  is left to cas_tree_fsck.  Both are reported but not counted as a
 *  failure.  Return 0 to continue, nonzero to stop.
 */
typedef int (*cas_fsck_fn)(const char *hash, int status, void *ctx);

/** Whether an object type is stored under an address that commits to a
 *  canonical form other than its stored bytes (currently only "htree",
 *  addressed by the hash of its equivalent "tree" text).  Such objects
 *  cannot be verified by re-hashing their bytes at the CAS layer.
 */
int
cas_type_is_reencoded(const char *type);

/** Check integrity of all objects: rehash and compare.
 *  Returns CAS_OK if all objects passed, CAS_ERR if any failed.
 */
int
cas_fsck(struct cas *store, cas_fsck_fn fn, void *ctx);

/** Check integrity of a single object by hash. */
int
cas_fsck_object(struct cas *store, const char *hash);

/** Delete a single object by hash. */
int
cas_remove(struct cas *store, const char *hash);

/** Get the modification time of a loose object.
 *  Returns CAS_OK on success, CAS_ENOTFOUND if missing.
 */
int
cas_object_mtime(struct cas *store, const char *hash, time_t *mtime_out);

/****************************************************************
 * Binary hash helpers
 ****************************************************************/

/** Compute binary BLAKE2b-256 digest. */
void
cas_digest(const void *data, size_t len, unsigned char *out);

/** Compute binary BLAKE2b-256 digest of a typed object. */
void
cas_digest_object(const char *type, const void *data, size_t len,
                  unsigned char *out);

/** Encode binary to hex string. out must be at least len*2+1 bytes. */
void
cas_hex_encode(const unsigned char *bin, size_t len, char *out);

/** Decode hex string to binary. Returns 0 on success. */
int
cas_hex_decode(const char *hex, size_t hexlen,
               unsigned char *out, size_t outsz);

/** Validate a hex hash string. Returns nonzero if valid. */
int
cas_valid_hash(const char *hash);

#endif /* CAS_H */
