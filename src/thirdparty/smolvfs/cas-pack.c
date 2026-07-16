/* cas-pack.c : packfile format for content-addressable store */
/* Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 * Licensed under BSD-2-Clause-Patent OR MIT */

#define _POSIX_C_SOURCE 200809L

#include "cas-pack.h"
#include "cas-codec.h"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

/****************************************************************
 * Data structures
 ****************************************************************/

struct cas_pack {
	void *map;
	size_t maplen;
	uint64_t entry_count;
	const unsigned char *index;   /* start of the index region in map */
};

/* Field byte offsets within a 64-byte index entry and the footer.  The
 * index and footer sit at arbitrary (unaligned) file offsets in the
 * mmap, so reads go through these offsets with the little-endian
 * helpers rather than a struct cast, which would be a misaligned access
 * for the 8-byte fields. */
#define PACK_IDX_HASH    0
#define PACK_IDX_OFFSET  CAS_HASH_LEN          /* 32 */
#define PACK_IDX_STORED  (CAS_HASH_LEN + 8)    /* 40 */
#define PACK_FT_COUNT    CAS_PACK_MAGIC_LEN    /* 8 */
#define PACK_FT_CKSUM    (CAS_PACK_MAGIC_LEN + 8)  /* 16 */

/****************************************************************
 * Helpers
 ****************************************************************/

static int
write_full(int fd, const void *data, size_t len)
{
	const unsigned char *p = data;

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

/* The index and footer store their 64-bit fields little-endian on
 * disk so a packfile is byte-identical across architectures.  Every
 * multi-byte integer goes through these helpers; the hash and header
 * bytes are already endian-neutral. */
static void
store_le64(unsigned char *p, uint64_t v)
{
	for (int i = 0; i < 8; i++)
		p[i] = (unsigned char)(v >> (i * 8));
}

static uint64_t
load_le64(const unsigned char *p)
{
	uint64_t v = 0;

	for (int i = 0; i < 8; i++)
		v |= (uint64_t)p[i] << (i * 8);
	return v;
}

static int
parse_header(const char *hdr, size_t hdrsz,
             char *type_out, size_t type_bufsz,
             size_t *content_len)
{
	size_t limit = hdrsz < 32 ? hdrsz : 32;
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
		if (len < prev)
			return CAS_ERR;
	}

	memcpy(type_out, hdr, typelen);
	type_out[typelen] = '\0';
	*content_len = len;
	return CAS_OK;
}

/****************************************************************
 * Lifecycle
 ****************************************************************/

struct cas_pack *
cas_pack_open(const char *path)
{
	int fd = open(path, O_RDONLY);

	if (fd < 0)
		return NULL;

	struct stat sb;

	if (fstat(fd, &sb) != 0) {
		close(fd);
		return NULL;
	}

	size_t filesz = (size_t)sb.st_size;

	if (filesz < CAS_PACK_BLOCK) {
		close(fd);
		return NULL;
	}

	void *map = mmap(NULL, filesz, PROT_READ, MAP_PRIVATE, fd, 0);

	close(fd);
	if (map == MAP_FAILED)
		return NULL;

	const unsigned char *ft =
		(const unsigned char *)map + filesz - CAS_PACK_BLOCK;

	static const unsigned char footer_magic[] =
		CAS_PACK_FOOTER_MAGIC_V1;

	if (memcmp(ft, footer_magic, CAS_PACK_MAGIC_LEN) != 0) {
		munmap(map, filesz);
		return NULL;
	}

	uint64_t count = load_le64(ft + PACK_FT_COUNT);
	size_t index_size = (size_t)count * CAS_PACK_BLOCK;
	size_t tail_size = index_size + CAS_PACK_BLOCK;

	if (tail_size > filesz) {
		munmap(map, filesz);
		return NULL;
	}

	const unsigned char *index =
		(const unsigned char *)map + filesz - tail_size;

	size_t check_len = index_size + 16;
	unsigned char expected[CAS_HASH_LEN];

	cas_digest(index, check_len, expected);

	if (memcmp(expected, ft + PACK_FT_CKSUM, CAS_HASH_LEN) != 0) {
		munmap(map, filesz);
		return NULL;
	}

	struct cas_pack *pack = calloc(1, sizeof(*pack));

	if (!pack) {
		munmap(map, filesz);
		return NULL;
	}

	pack->map = map;
	pack->maplen = filesz;
	pack->entry_count = count;
	pack->index = index;
	return pack;
}

void
cas_pack_close(struct cas_pack *pack)
{
	if (!pack)
		return;
	if (pack->map)
		munmap(pack->map, pack->maplen);
	free(pack);
}

/****************************************************************
 * Lookup
 ****************************************************************/

static const unsigned char *
find_entry(const struct cas_pack *pack,
           const unsigned char *bin_hash)
{
	uint64_t lo = 0, hi = pack->entry_count;

	while (lo < hi) {
		uint64_t mid = lo + (hi - lo) / 2;
		const unsigned char *e = pack->index + mid * CAS_PACK_BLOCK;
		int cmp = memcmp(e + PACK_IDX_HASH, bin_hash, CAS_HASH_LEN);

		if (cmp < 0)
			lo = mid + 1;
		else if (cmp > 0)
			hi = mid;
		else
			return e;
	}
	return NULL;
}

static void
release_free(struct cas_file *cf)
{
	free(cf->_priv);
}

int
cas_pack_lookup(struct cas_pack *pack, struct cas_file *cf,
                const char *hash, char *type_out,
                size_t type_bufsz)
{
	unsigned char bin[CAS_HASH_LEN];

	if (cas_hex_decode(hash, CAS_HASH_HEX, bin,
	                   sizeof(bin)) != 0)
		return CAS_ERR;

	const unsigned char *e = find_entry(pack, bin);

	if (!e)
		return CAS_ENOTFOUND;

	uint64_t trailer_off = load_le64(e + PACK_IDX_OFFSET);

	if (trailer_off + CAS_PACK_BLOCK > pack->maplen)
		return CAS_ERR;

	const struct cas_pack_trailer *tr =
		(const struct cas_pack_trailer *)
		((char *)pack->map + trailer_off);

	static const unsigned char magic_v1[] = CAS_PACK_TRAILER_MAGIC;
	static const unsigned char magic_v2[] = CAS_PACK_TRAILER_MAGIC_V2;
	int framed;

	if (memcmp(tr->magic, magic_v1, CAS_PACK_MAGIC_LEN) == 0)
		framed = 0;
	else if (memcmp(tr->magic, magic_v2, CAS_PACK_MAGIC_LEN) == 0)
		framed = 1;
	else
		return CAS_ERR;

	char type[CAS_TYPE_MAX + 1];
	size_t content_len;

	if (parse_header(tr->header, CAS_PACK_HEADER_LEN,
	                 type, sizeof(type),
	                 &content_len) != CAS_OK)
		return CAS_ERR;

	/* stored_size is the on-disk region length; a zero value
	 * means "same as the plaintext length" for packs written
	 * before compression existed. */
	uint64_t stored = load_le64(e + PACK_IDX_STORED);
	uint64_t region_size = stored ? stored : content_len;

	if (region_size > trailer_off)
		return CAS_ERR;

	if (type_out) {
		if (strlen(type) >= type_bufsz)
			return CAS_ERR;
		memcpy(type_out, type, strlen(type) + 1);
	}

	const unsigned char *region =
		(const unsigned char *)pack->map + trailer_off - region_size;
	const unsigned char *data;
	size_t len;
	unsigned char *owned;
	int rc = cas_codec_region_decode(region, region_size, framed,
	                                 content_len, &data, &len,
	                                 &owned);

	if (rc != CAS_OK)
		return rc;

	if (owned) {
		cf->_priv = owned;
		cf->_privlen = 0;
		cf->_release = release_free;
	} else {
		/* zero-copy view into the packfile mmap */
		cf->_priv = NULL;
		cf->_privlen = 0;
		cf->_release = NULL;
	}
	cf->data = data;
	cf->len = len;
	return CAS_OK;
}

int
cas_pack_exists(struct cas_pack *pack, const char *hash)
{
	unsigned char bin[CAS_HASH_LEN];

	if (cas_hex_decode(hash, CAS_HASH_HEX, bin,
	                   sizeof(bin)) != 0)
		return 0;
	return find_entry(pack, bin) != NULL;
}

uint64_t
cas_pack_count(struct cas_pack *pack)
{
	return pack->entry_count;
}

/****************************************************************
 * Iteration
 ****************************************************************/

int
cas_pack_foreach(struct cas_pack *pack, cas_pack_foreach_fn fn,
                 void *ctx)
{
	for (uint64_t i = 0; i < pack->entry_count; i++) {
		char hex[CAS_HASH_HEX + 1];

		cas_hex_encode(pack->index + i * CAS_PACK_BLOCK + PACK_IDX_HASH,
		               CAS_HASH_LEN, hex);
		if (fn(hex, ctx) != 0)
			break;
	}
	return CAS_OK;
}

/****************************************************************
 * Fsck
 ****************************************************************/

int
cas_pack_fsck(struct cas_pack *pack, cas_fsck_fn fn, void *ctx)
{
	int errors = 0;

	for (uint64_t i = 0; i < pack->entry_count; i++) {
		const unsigned char *e =
			pack->index + i * CAS_PACK_BLOCK;
		char hex[CAS_HASH_HEX + 1];
		int status;

		cas_hex_encode(e + PACK_IDX_HASH, CAS_HASH_LEN, hex);

		uint64_t trailer_off = load_le64(e + PACK_IDX_OFFSET);

		if (trailer_off + CAS_PACK_BLOCK > pack->maplen) {
			status = CAS_FSCK_IOERR;
			goto report;
		}

		const struct cas_pack_trailer *tr =
			(const struct cas_pack_trailer *)
			((char *)pack->map + trailer_off);

		static const unsigned char magic_v1[] =
			CAS_PACK_TRAILER_MAGIC;
		static const unsigned char magic_v2[] =
			CAS_PACK_TRAILER_MAGIC_V2;
		int framed;

		if (memcmp(tr->magic, magic_v1, CAS_PACK_MAGIC_LEN) == 0)
			framed = 0;
		else if (memcmp(tr->magic, magic_v2,
		                CAS_PACK_MAGIC_LEN) == 0)
			framed = 1;
		else {
			status = CAS_FSCK_CORRUPT;
			goto report;
		}

		char type[CAS_TYPE_MAX + 1];
		size_t content_len;

		if (parse_header(tr->header, CAS_PACK_HEADER_LEN,
		                 type, sizeof(type),
		                 &content_len) != CAS_OK) {
			status = CAS_FSCK_CORRUPT;
			goto report;
		}

		/* an htree is addressed by its text form, not its bytes, so
		 * it is not verifiable here; cas_tree_fsck does it */
		if (cas_type_is_reencoded(type)) {
			status = CAS_FSCK_REENCODED;
			goto report;
		}

		uint64_t stored = load_le64(e + PACK_IDX_STORED);
		uint64_t region_size = stored ? stored : content_len;

		if (region_size > trailer_off) {
			status = CAS_FSCK_CORRUPT;
			goto report;
		}

		const unsigned char *region =
			(const unsigned char *)pack->map +
			trailer_off - region_size;
		const unsigned char *data;
		size_t len;
		unsigned char *owned;
		int rc = cas_codec_region_decode(region, region_size,
		                                 framed, content_len,
		                                 &data, &len, &owned);

		if (rc == CAS_ETYPE) {
			/* codec not compiled in: cannot verify */
			status = CAS_FSCK_NOCODEC;
			goto report;
		}
		if (rc == CAS_ENOMEM) {
			status = CAS_FSCK_IOERR;
			goto report;
		}
		if (rc != CAS_OK) {
			status = CAS_FSCK_CORRUPT;
			goto report;
		}

		unsigned char digest[CAS_HASH_LEN];

		cas_digest_object(type, data, len, digest);
		free(owned);

		if (memcmp(digest, e + PACK_IDX_HASH, CAS_HASH_LEN) != 0) {
			status = CAS_FSCK_CORRUPT;
			goto report;
		}

		status = CAS_FSCK_OK;

	report:
		/* NOCODEC and REENCODED are skips, not corruption */
		if (status != CAS_FSCK_OK && status != CAS_FSCK_NOCODEC &&
		    status != CAS_FSCK_REENCODED)
			errors++;
		if (fn && fn(hex, status, ctx) != 0)
			break;
	}

	return errors ? CAS_ERR : CAS_OK;
}

/****************************************************************
 * Import
 ****************************************************************/

struct import_ctx {
	struct cas_pack *pack;
	struct cas *store;
	int policy;
	int codec;
	uint64_t total;
	uint64_t stored;
	int rc;
};

static int
import_one(const char *hash, void *ctx)
{
	struct import_ctx *ic = ctx;
	struct cas_file cf;
	char type[CAS_TYPE_MAX + 1];

	int rc = cas_pack_lookup(ic->pack, &cf, hash, type, sizeof(type));

	if (rc != CAS_OK) {
		ic->rc = rc;
		return 1;
	}

	/* An "htree" object is a lookup-optimized re-encoding of a "tree"
	 * whose address is the hash of the canonical text form, not of the
	 * htree bytes; that text form cannot be rebuilt here, so the bytes
	 * are stored verbatim at the pack's address and trusted (the pack
	 * index is checksummed, and the htree carries its own adler32).
	 * Every other type is self-addressed: its content must hash to the
	 * claimed address, so a tampered object is rejected before it is
	 * written into the depot. */
	int reencoded = cas_type_is_reencoded(type);

	if (!reencoded) {
		char computed[CAS_HASH_HEX + 1];

		cas_hash_object(type, cf.data, cf.len, computed);
		if (strcmp(computed, hash) != 0) {
			cas_close(&cf);
			ic->rc = CAS_ERR;
			return 1;
		}
	}

	int existed = cas_exists(ic->store, hash);

	if (reencoded) {
		rc = cas_put_object_at(ic->store, type, cf.data, cf.len,
		                       hash);
	} else {
		int use = cas_codec_policy(ic->policy, ic->codec,
		                           cf.data, cf.len);
		char out[CAS_HASH_HEX + 1];

		rc = cas_put_object_z(ic->store, type, use, cf.data,
		                      cf.len, out);
	}
	cas_close(&cf);
	if (rc != CAS_OK) {
		ic->rc = rc;
		return 1;
	}

	ic->total++;
	if (!existed)
		ic->stored++;
	return 0;
}

int
cas_pack_import(struct cas_pack *pack, struct cas *store,
                int policy, int codec, uint64_t *total_out,
                uint64_t *stored_out)
{
	struct import_ctx ic = {
		.pack = pack,
		.store = store,
		.policy = policy,
		.codec = codec,
	};

	cas_pack_foreach(pack, import_one, &ic);

	if (ic.rc != CAS_OK)
		return ic.rc;
	if (total_out)
		*total_out = ic.total;
	if (stored_out)
		*stored_out = ic.stored;
	return CAS_OK;
}

/****************************************************************
 * Create
 ****************************************************************/

struct hash_list {
	unsigned char (*hashes)[CAS_HASH_LEN];
	int count;
	int cap;
};

static int
collect_hash(const char *hash, void *ctx)
{
	struct hash_list *hl = ctx;

	if (hl->count >= hl->cap) {
		int newcap = hl->cap ? hl->cap * 2 : 64;
		void *p = realloc(hl->hashes,
		                   (size_t)newcap * CAS_HASH_LEN);

		if (!p)
			return -1;
		hl->hashes = p;
		hl->cap = newcap;
	}

	cas_hex_decode(hash, CAS_HASH_HEX,
	               hl->hashes[hl->count], CAS_HASH_LEN);
	hl->count++;
	return 0;
}

static int
hash_cmp(const void *a, const void *b)
{
	return memcmp(a, b, CAS_HASH_LEN);
}

/* Build a packfile from all loose objects.  policy/codec decide per
 * object whether to compress a raw (v1) object into the packfile;
 * compression is kept only if it saves space, and already-compressed
 * objects are copied verbatim.  The address of every object is
 * unchanged. */
static int
pack_create(struct cas *store, const char *path, int policy, int codec)
{
	struct hash_list hl = {0};

	cas_foreach(store, collect_hash, &hl);

	if (hl.count == 0) {
		free(hl.hashes);
		return CAS_OK;
	}

	qsort(hl.hashes, (size_t)hl.count, CAS_HASH_LEN, hash_cmp);

	int unique = 1;

	for (int i = 1; i < hl.count; i++) {
		if (memcmp(hl.hashes[i], hl.hashes[unique - 1],
		           CAS_HASH_LEN) != 0) {
			if (i != unique)
				memcpy(hl.hashes[unique],
				       hl.hashes[i], CAS_HASH_LEN);
			unique++;
		}
	}
	hl.count = unique;

	char tmp[512];

	if (snprintf(tmp, sizeof(tmp), "%s.XXXXXX", path) >=
	    (int)sizeof(tmp)) {
		free(hl.hashes);
		return CAS_ERR;
	}

	int fd = mkstemp(tmp);

	if (fd < 0) {
		free(hl.hashes);
		return CAS_EIO;
	}

	struct cas_pack_index_entry *index =
		calloc((size_t)hl.count, sizeof(*index));

	if (!index) {
		close(fd);
		unlink(tmp);
		free(hl.hashes);
		return CAS_ENOMEM;
	}

	uint64_t offset = 0;

	for (int i = 0; i < hl.count; i++) {
		char hex[CAS_HASH_HEX + 1];

		cas_hex_encode(hl.hashes[i], CAS_HASH_LEN, hex);

		/* copy the raw on-disk encoding verbatim so compressed
		 * objects stay compressed and their trailer (v1 or v2
		 * magic) is preserved unchanged */
		struct cas_file cf;
		struct cas_pack_trailer tr;
		int rc = cas_open_loose_raw(store, &cf, hex, &tr);

		if (rc != CAS_OK) {
			close(fd);
			unlink(tmp);
			free(index);
			free(hl.hashes);
			return rc;
		}

		char type[CAS_TYPE_MAX + 1];
		size_t content_len;

		if (parse_header(tr.header, CAS_PACK_HEADER_LEN,
		                 type, sizeof(type),
		                 &content_len) != CAS_OK) {
			cas_close(&cf);
			close(fd);
			unlink(tmp);
			free(index);
			free(hl.hashes);
			return CAS_ERR;
		}

		static const unsigned char magic_v2[] =
			CAS_PACK_TRAILER_MAGIC_V2;
		int framed_in = memcmp(tr.magic, magic_v2,
		                       CAS_PACK_MAGIC_LEN) == 0;

		/* bytes to write for this object: raw region by default */
		const unsigned char *emit = cf.data;
		uint64_t emit_size = cf.len;
		unsigned char *scratch = NULL;

		/* a raw object is the plaintext, so the policy can judge
		 * it; already-compressed (framed) objects are left alone */
		int use = (!framed_in && cf.len > 0)
		          ? cas_codec_policy(policy, codec, cf.data, cf.len)
		          : CAS_CODEC_NONE;

		if (use != CAS_CODEC_NONE && cas_codec_can_encode(use)) {
			scratch = malloc(cf.len + 1);
			if (scratch) {
				size_t plen = cf.len;
				int erc = cas_codec_encode(use, cf.data,
				                           cf.len, scratch + 1,
				                           &plen);

				if (erc == CAS_OK &&
				    plen + 1 < cf.len - cf.len / 8) {
					scratch[0] = (unsigned char)use;
					emit = scratch;
					emit_size = plen + 1;
					/* header stays "type plaintext_len\0";
					 * only the framing magic changes */
					memcpy(tr.magic, magic_v2,
					       CAS_PACK_MAGIC_LEN);
				} else {
					free(scratch);
					scratch = NULL;
				}
			}
		}

		if (emit_size > 0) {
			rc = write_full(fd, emit, emit_size);
			if (rc != CAS_OK) {
				free(scratch);
				cas_close(&cf);
				close(fd);
				unlink(tmp);
				free(index);
				free(hl.hashes);
				return rc;
			}
		}
		free(scratch);
		cas_close(&cf);
		offset += emit_size;

		rc = write_full(fd, &tr, sizeof(tr));
		if (rc != CAS_OK) {
			close(fd);
			unlink(tmp);
			free(index);
			free(hl.hashes);
			return rc;
		}

		memcpy(index[i].hash, hl.hashes[i], CAS_HASH_LEN);
		store_le64((unsigned char *)&index[i].offset, offset);
		/* a compressed region differs from the plaintext length,
		 * so record it; leave zero when they match for
		 * compatibility with packs written before compression */
		store_le64((unsigned char *)&index[i].stored_size,
		           (emit_size == content_len) ? 0 : emit_size);

		offset += CAS_PACK_BLOCK;
	}

	free(hl.hashes);

	size_t index_size = (size_t)hl.count * sizeof(*index);
	int rc = write_full(fd, index, index_size);

	if (rc != CAS_OK) {
		close(fd);
		unlink(tmp);
		free(index);
		return rc;
	}

	struct cas_pack_footer ft;
	static const unsigned char footer_magic[] =
		CAS_PACK_FOOTER_MAGIC_V1;

	memcpy(ft.magic, footer_magic, CAS_PACK_MAGIC_LEN);
	store_le64((unsigned char *)&ft.entry_count, (uint64_t)hl.count);
	memset(ft.reserved, 0, sizeof(ft.reserved));
	memset(ft.checksum, 0, sizeof(ft.checksum));

	size_t check_len = index_size + 16;
	unsigned char *check_buf = malloc(check_len);

	if (!check_buf) {
		close(fd);
		unlink(tmp);
		free(index);
		return CAS_ENOMEM;
	}

	memcpy(check_buf, index, index_size);
	memcpy(check_buf + index_size, ft.magic,
	       CAS_PACK_MAGIC_LEN);
	memcpy(check_buf + index_size + CAS_PACK_MAGIC_LEN,
	       &ft.entry_count, sizeof(ft.entry_count));

	cas_digest(check_buf, check_len, ft.checksum);
	free(check_buf);
	free(index);

	rc = write_full(fd, &ft, sizeof(ft));
	if (rc != CAS_OK) {
		close(fd);
		unlink(tmp);
		return rc;
	}

	close(fd);

	if (rename(tmp, path) != 0) {
		unlink(tmp);
		return CAS_EIO;
	}

	return CAS_OK;
}

int
cas_pack_create(struct cas *store, const char *path)
{
	return pack_create(store, path, CAS_COMPRESS_NEVER, CAS_CODEC_NONE);
}

int
cas_pack_create_z(struct cas *store, const char *path, int policy,
                  int codec)
{
	return pack_create(store, path, policy, codec);
}
