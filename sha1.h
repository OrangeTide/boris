#include <stdint.h>

/**
 * size of a SHA-1 digest in bytes. SHA-1 is 160-bit.
 */
#define SHA1_DIGEST_LENGTH 20

/**
 * number of 32-bit values in a 512-bit block.
 */
#define SHA1_LBLOCK 16

/**
 * data structure holding the state of the hash processing.
 */
struct sha1_ctx {
	uint_least32_t
		h[5], /**< five hash state values for 160-bits. */
		data[SHA1_LBLOCK]; /**< load data into chunks here. */
	uint_least64_t cnt; /**< total so far in bits. */
	unsigned data_len; /**< number of bytes used in data. (not the number of words/elements) */
};

/* sha1.c */
int sha1_init(struct sha1_ctx *ctx);
int sha1_update(struct sha1_ctx *ctx, const void *data, size_t len);
int sha1_final(unsigned char *md, struct sha1_ctx *ctx);
unsigned char *sha1(const void *data, size_t len, unsigned char *md);
