/* cas-codec.h : compile-time compression codec table for CAS */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

#ifndef CAS_CODEC_H
#define CAS_CODEC_H

#include <stddef.h>

/****************************************************************
 * Codec table
 ****************************************************************
 *
 * A CAS object may store its data compressed while its address
 * stays the BLAKE2b hash of the uncompressed content.  The
 * on-disk data region of such an object is a codec tag byte
 * followed by the codec payload; the tag selects which decoder
 * turns the payload back into the plaintext.
 *
 * The set of codecs is fixed at compile time -- there is no
 * runtime registry and no global mutable state.  Only
 * CAS_CODEC_NONE is intrinsic.  The optional bundled DEFLATE
 * codec (miniz) is compiled in with -DCAS_WITH_MINIZ.  An
 * application that wants its own codec (for example its own zlib)
 * defines CAS_CODEC_USER when building cas-codec.c:
 *
 *   int myz_decode(const void *, size_t, void *, size_t);
 *   int myz_encode(const void *, size_t, void *, size_t *);
 *   #define CAS_CODEC_USER(X) \
 *       X(CAS_CODEC_DEFLATE, myz_decode, myz_encode, "myzlib")
 *
 * Each X(tag, decode, encode, name) becomes one table entry.
 */

/** Codec tag bytes.  Printable ASCII so objects stay greppable,
 *  mirroring the tree body format byte.
 */
enum {
    CAS_CODEC_NONE    = '%',  /* stored raw, payload is plaintext */
    CAS_CODEC_DEFLATE = 'Z',  /* zlib/DEFLATE stream */
    CAS_CODEC_ZSTD    = 'S',  /* zstd frame */
    CAS_CODEC_XZ      = 'X',  /* xz/LZMA stream */
    CAS_CODEC_LZ4     = '4',  /* LZ4 */
};

/****************************************************************
 * Compression policy
 ****************************************************************
 *
 * A tool that ingests blobs decides per blob whether to attempt
 * compression.  The library offers a minimal, data-only policy and
 * leaves the real authority with the caller, who picks the mode.
 *
 *   NEVER  -- never compress; store raw.
 *   ALWAYS -- always attempt (the size threshold in
 *             cas_put_object_z still discards a losing result).
 *   GUESS  -- attempt only if the data looks like text.  Text
 *             compresses well; binary (including already-compressed
 *             images, audio, video, archives) usually does not, so
 *             this skips the wasted attempt without a format list.
 *
 * GUESS classifies by the fraction of non-text control bytes in a
 * short prefix -- no filename, no format table.  Both bounds are
 * compile-time overridable.
 */
enum {
    CAS_COMPRESS_NEVER,
    CAS_COMPRESS_ALWAYS,
    CAS_COMPRESS_GUESS,
};

#ifndef CAS_TEXT_SNIFF
#define CAS_TEXT_SNIFF 512  /* prefix bytes examined by GUESS */
#endif
#ifndef CAS_TEXT_MAX_NONTEXT_PCT
#define CAS_TEXT_MAX_NONTEXT_PCT 10  /* above this, treat as binary */
#endif

/** Decode inlen bytes at in into out, which has capacity outlen.
 *  The caller knows the exact plaintext length in advance, so a
 *  decoder must produce exactly outlen bytes.  Returns CAS_OK on
 *  success, CAS_ERR on failure or a length mismatch.
 */
typedef int (*cas_decode_fn)(const void *in, size_t inlen,
                             void *out, size_t outlen);

/** Compress inlen bytes at in into out.  On entry *outlen is the
 *  capacity of out; on success it is set to the number of bytes
 *  written.  Returns CAS_OK on success, CAS_ERR if the payload
 *  does not fit or compression fails.
 */
typedef int (*cas_encode_fn)(const void *in, size_t inlen,
                             void *out, size_t *outlen);

/** One codec: a tag and its operations.  encode may be NULL for
 *  a decode-only codec.
 */
struct cas_codec {
    int tag;
    cas_decode_fn decode;
    cas_encode_fn encode;
    const char *name;
};

/** Pick a codec to attempt for a blob under the given policy.
 *  Returns CAS_CODEC_NONE (store raw) or codec (attempt it).  For
 *  CAS_COMPRESS_GUESS, returns codec only if the data looks like
 *  text.  Pair with cas_put_object_z, which applies the size
 *  threshold to the attempt.
 */
int
cas_codec_policy(int policy, int codec, const void *data, size_t len);

/** Return nonzero if a decoder is available for the codec tag.
 *  CAS_CODEC_NONE is always supported.
 */
int
cas_codec_supported(int codec);

/** Return nonzero if an encoder is available for the codec tag.
 *  CAS_CODEC_NONE is always supported.
 */
int
cas_codec_can_encode(int codec);

/** Decode a codec payload into a caller-supplied plaintext buffer
 *  of exactly outlen bytes.  Returns CAS_OK on success, CAS_ETYPE
 *  if the tag is not in the codec table, CAS_ERR on a decode
 *  failure or length mismatch.
 */
int
cas_codec_decode(int codec, const void *in, size_t inlen,
                 void *out, size_t outlen);

/** Encode plaintext into a caller-supplied payload buffer.  On
 *  entry *outlen is the buffer capacity; on success it holds the
 *  payload size.  Returns CAS_OK on success, CAS_ETYPE if the tag
 *  has no encoder in the table, CAS_ERR on failure.
 */
int
cas_codec_encode(int codec, const void *in, size_t inlen,
                 void *out, size_t *outlen);

/****************************************************************
 * Decode bounds
 ****************************************************************
 *
 * A compressed object's plaintext length comes from its trailer,
 * which is not covered by the address on an untrusted read.  These
 * bounds cap how much a single object may inflate, so a crafted
 * header cannot trigger a huge allocation.  Both are compile-time
 * overridable; they apply only to genuinely compressed codecs, not
 * to raw or NONE objects (already bounded by the stored size).
 */
#ifndef CAS_CODEC_MAX_PLAINTEXT
#define CAS_CODEC_MAX_PLAINTEXT ((size_t)100 << 20)  /* 100 MiB ceiling */
#endif
#ifndef CAS_CODEC_MAX_RATIO
#define CAS_CODEC_MAX_RATIO 256  /* max plaintext:payload expansion */
#endif

/** Decode an on-disk object data region into a plaintext view.
 *
 *  region/region_size is the stored data region.  framed is
 *  nonzero for a v2 object (a leading codec tag byte followed by
 *  the payload) and zero for a legacy raw object (the region is
 *  the plaintext).  plaintext_len is the uncompressed length taken
 *  from the object header.
 *
 *  On success *data and *len describe the plaintext.  If *owned is
 *  non-NULL the plaintext lives in a malloc'd buffer the caller
 *  must eventually free, and the source region may be released
 *  immediately; if *owned is NULL, *data points into region and
 *  the caller must keep region mapped until done.
 *
 *  Returns CAS_OK, CAS_ETYPE if the tag is not in the codec table,
 *  or CAS_ERR on a malformed region, decode failure, or length
 *  mismatch.
 */
int
cas_codec_region_decode(const unsigned char *region, size_t region_size,
                        int framed, size_t plaintext_len,
                        const unsigned char **data, size_t *len,
                        unsigned char **owned);

#endif /* CAS_CODEC_H */
