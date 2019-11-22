/**
 * @file sha1.h
 *
 * SHA-1 hashing routines.
 * see RFC3174 for the SHA-1 algorithm.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Nov 21
 *
 * Written in 2009 by Jon Mayo <jon.mayo@gmail.com>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#ifndef SHA1_H_
#define SHA1_H_
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

int sha1_init(struct sha1_ctx *ctx);
int sha1_update(struct sha1_ctx *ctx, const void *data, size_t len);
int sha1_final(unsigned char *md, struct sha1_ctx *ctx);
unsigned char *sha1(const void *data, size_t len, unsigned char *md);
#endif
