/* cas-pack.h : packfile format for content-addressable store */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#ifndef CAS_PACK_H
#define CAS_PACK_H

#include "cas.h"
#include <stddef.h>
#include <stdint.h>

/****************************************************************
 * On-disk format
 ****************************************************************
 *
 * All structures are 64-byte aligned for clean packing into
 * system pages.
 *
 * Loose object (new format):
 *
 *   [ data bytes ] [ trailer: 64 bytes ]
 *
 * The trailer contains a magic value followed by a nul-padded
 * header string.  The header is "type len\0" matching the hash
 * input format.  Reading: stat() the file, pread() the last 64
 * bytes, verify magic, parse header up to first '\0'.  Data
 * occupies [0, filesize - 64).
 *
 * Hash input: BLAKE2b-256("type len\0" || data).  The nul
 * padding in the trailer is not part of the hash input.  Here
 * "data" is always the uncompressed plaintext: for a v2 trailer
 * the on-disk data region is a codec tag byte plus payload, but
 * the hash and the header len still describe the plaintext, so
 * the object's address never depends on how it was stored.
 *
 * Packfile layout:
 *
 *   [ obj0_data | obj0_trailer(64) |
 *     obj1_data | obj1_trailer(64) |
 *     ...
 *     objN_data | objN_trailer(64) |
 *     index_entry_0(64) | ... | index_entry_N(64) |
 *     footer(64) ]
 *
 * The index is sorted by hash for binary search.  Each index
 * entry points to the object's trailer offset within the file.
 * From the trailer, the reader extracts the data length and
 * computes the data region as [offset - len, offset).
 *
 * The footer checksum covers index || footer_without_checksum.
 * Object data integrity is verified per-object via BLAKE2b
 * against the hash stored in the index.
 *
 * Byte order: every multi-byte integer in the index and footer
 * (offset, stored_size, entry_count) is stored little-endian, so a
 * packfile is byte-identical and interchangeable across
 * architectures.  The hash, magic, and "type len\0" header bytes
 * are already endian-neutral.
 */

/****************************************************************
 * Constants
 ****************************************************************/

#define CAS_PACK_BLOCK     64

#define CAS_PACK_TRAILER_MAGIC    { 0xCB, 0x4F, 0x42, 0x4A, 0xAA, 0x01, 0x00, 0x00 }
#define CAS_PACK_TRAILER_MAGIC_V2 { 0xCB, 0x4F, 0x42, 0x4A, 0xAA, 0x02, 0x00, 0x00 }
#define CAS_PACK_FOOTER_MAGIC_V1  { 0xCB, 0x50, 0x4B, 0x46, 0xAA, 0x01, 0x00, 0x00 }

#define CAS_PACK_MAGIC_LEN  8
#define CAS_PACK_HEADER_LEN 56  /* 64 - 8 magic */

/****************************************************************
 * On-disk structures (64 bytes each)
 ****************************************************************/

/** Object trailer -- appended after data in both loose objects
 *  and packfile entries.
 *
 *  magic[8] + header[56 nul-padded]
 *  header contains "type len\0" padded with nul bytes to 56.
 *  Max type: 8 chars.  Max len: 18 digits (~4.6 EB).
 *
 *  Two magic values distinguish the data-region encoding.  The v1
 *  magic (CAS_PACK_TRAILER_MAGIC) means the data region is the raw
 *  plaintext.  The v2 magic (CAS_PACK_TRAILER_MAGIC_V2) means the
 *  data region is a one-byte codec tag followed by the codec
 *  payload; the header len is still the uncompressed length and
 *  still the hash input, so the object's address is unchanged.
 */
struct cas_pack_trailer {
	unsigned char magic[CAS_PACK_MAGIC_LEN];
	char header[CAS_PACK_HEADER_LEN];
};

/** Packfile index entry -- one per object, sorted by hash.
 *
 *  hash[32] + offset[8] + stored_size[8] + reserved[16]
 *  offset and stored_size are little-endian.
 *  offset points to the start of the object's trailer.
 *  stored_size is the on-disk data-region length, which differs
 *  from the header (plaintext) length for compressed v2 objects.
 *  A zero stored_size means "same as the header length" so packs
 *  written before compression existed read back unchanged.
 */
struct cas_pack_index_entry {
	unsigned char hash[CAS_HASH_LEN];
	uint64_t offset;
	uint64_t stored_size;
	unsigned char reserved[16];
};

/** Packfile footer -- last 64 bytes of the file.
 *
 *  magic[8] + entry_count[8] + checksum[32] + reserved[16]
 *  entry_count is little-endian.
 *  checksum covers: all index entries || footer without checksum
 *  (the first 16 bytes of the footer: magic + entry_count).
 */
struct cas_pack_footer {
	unsigned char magic[CAS_PACK_MAGIC_LEN];
	uint64_t entry_count;
	unsigned char checksum[CAS_HASH_LEN];
	unsigned char reserved[16];
};

/****************************************************************
 * Compile-time layout checks
 ****************************************************************/

_Static_assert(sizeof(struct cas_pack_trailer) == CAS_PACK_BLOCK,
               "trailer must be 64 bytes");
_Static_assert(sizeof(struct cas_pack_index_entry) == CAS_PACK_BLOCK,
               "index entry must be 64 bytes");
_Static_assert(sizeof(struct cas_pack_footer) == CAS_PACK_BLOCK,
               "footer must be 64 bytes");

/****************************************************************
 * API
 ****************************************************************/

/** Opaque packfile handle. */
struct cas_pack;

/** Open a packfile for reading. Returns NULL on failure. */
struct cas_pack *
cas_pack_open(const char *path);

/** Close a packfile handle. */
void
cas_pack_close(struct cas_pack *pack);

/** Create a packfile from all loose objects in the store.
 *  Returns CAS_OK on success.  If the store is empty, returns
 *  CAS_OK without creating a file.
 */
int
cas_pack_create(struct cas *store, const char *path);

/** Create a packfile, compressing objects with codec (a tag from
 *  cas-codec.h) under policy (a CAS_COMPRESS_* mode) where that
 *  saves space.  A raw object is compressed into the packfile only
 *  if the policy selects it, it beats its stored size by a
 *  comfortable margin, and an encoder for codec is compiled in;
 *  already-compressed objects are copied unchanged.  Object
 *  addresses are unaffected.  Pass CAS_COMPRESS_NEVER for no
 *  compression (identical to cas_pack_create).
 *
 *  Returns CAS_OK on success.
 */
int
cas_pack_create_z(struct cas *store, const char *path, int policy,
                  int codec);

/** Look up an object in a packfile by hex hash.
 *  On success, cf->data and cf->len are set.  For an uncompressed
 *  object the data points into the packfile mmap and cas_close()
 *  is a no-op; a compressed object is decoded into a heap buffer
 *  that cas_close() frees.
 */
int
cas_pack_lookup(struct cas_pack *pack, struct cas_file *cf,
                const char *hash, char *type_out, size_t type_bufsz);

/** Check whether an object exists in a packfile.
 *  Returns nonzero if present.
 */
int
cas_pack_exists(struct cas_pack *pack, const char *hash);

/** Return the number of objects in a packfile. */
uint64_t
cas_pack_count(struct cas_pack *pack);

/** Callback for cas_pack_foreach.  Return 0 to continue. */
typedef int (*cas_pack_foreach_fn)(const char *hash, void *ctx);

/** Iterate over all objects in a packfile. */
int
cas_pack_foreach(struct cas_pack *pack, cas_pack_foreach_fn fn,
                 void *ctx);

/** Check integrity of all objects in a packfile.
 *  Uses cas_fsck_fn from cas.h for per-object reporting.
 */
int
cas_pack_fsck(struct cas_pack *pack, cas_fsck_fn fn, void *ctx);

/** Merge every object from a packfile into store, deduplicated by
 *  address.  Each object's address is re-verified against its decoded
 *  content, so a bundle downloaded from an untrusted server cannot
 *  poison the depot: a mismatch aborts with CAS_ERR before that object
 *  is stored (objects merged earlier in the same call remain, so an
 *  import is not atomic).  Objects already present are skipped.
 *
 *  An "htree" object is addressed by the hash of its canonical text
 *  form rather than of its own bytes, so it is stored verbatim at the
 *  bundle's address and trusted (the pack index is checksummed and the
 *  htree carries an internal adler32); only self-addressed objects
 *  (blobs, text trees, compressed blobs) get the content re-hash check.
 *
 *  Objects are stored compressed per policy and codec (a CAS_COMPRESS_*
 *  mode and codec tag from cas-codec.h), exactly as cas_put_object_z
 *  would; pass CAS_COMPRESS_NEVER to store everything raw.  The address
 *  is the plaintext hash regardless, so it matches the bundle.
 *
 *  If non-NULL, *total_out receives the number of objects processed and
 *  *stored_out the number newly written (those not already present).
 *  Returns CAS_OK on success.
 */
int
cas_pack_import(struct cas_pack *pack, struct cas *store,
                int policy, int codec, uint64_t *total_out,
                uint64_t *stored_out);

#endif /* CAS_PACK_H */
