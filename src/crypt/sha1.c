/**
 * @file sha1.c
 *
 * SHA-1 hashing routines.
 * see RFC3174 for the SHA-1 algorithm.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2019 Dec 25
 *
 * Written in 2009 by Jon Mayo <jon@rm-f.net>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "sha1.h"

/**
 * SHA-1 Constants.
 */
#define SHA1_K0 0x5a827999
#define SHA1_K1 0x6ed9eba1
#define SHA1_K2 0x8f1bbcdc
#define SHA1_K3 0xca62c1d6

/**
 * rotate a value in an f-bit field left by b bits.
 * truncate to 32-bits.
 */
#define ROL(f, v, b) ((((v)<<(b))|((v)>>((f)-(b))))&(0xfffffffful>>(32-(f))))
/* here is a version that doens't truncate, useful for f-bit sized environments.
 * #define ROL(f, v, b) (((v)<<(b))|((v)>>((f)-(b))))
 */
#define ROL32(v, b) ROL(32, v, b)

/**
 * initialize the hash context.
 */
int sha1_init(struct sha1_ctx *ctx)
{
	if (!ctx)
		return 0; /* failure */

	/* initialize h state. */
	ctx->h[0] = 0x67452301lu;
	ctx->h[1] = 0xefcdab89lu;
	ctx->h[2] = 0x98badcfelu;
	ctx->h[3] = 0x10325476lu;
	ctx->h[4] = 0xc3d2e1f0lu;

	ctx->cnt = 0;
	ctx->data_len = 0;
	memset(ctx->data, 0, sizeof ctx->data);

	return 1; /* success */
}

/**
 * do this transformation for each chunk, chunk assumed to be loaded into ctx->data[].
 */
static void sha1_transform_chunk(struct sha1_ctx *ctx)
{
	unsigned i;
	uint_least32_t
	v[5], /**< called a, b, c, d, e in the documentation. */
	f, k, tmp, w[16];

	assert(ctx != NULL);

	/* load a, b, c, d, e with the current hash state. */
	for (i = 0; i < 5; i++) {
		v[i] = ctx->h[i];
	}

	for (i = 0; i < 80; i++) {
		unsigned t = i & 15;

		if (i < 16) {
			/* load 16 words of data into w[]. */
			w[i] = ctx->data[i];
		} else {
			/* 16 to 79 - perform this calculation. */
			w[t] ^= w[(t + 13) & 15] ^ w[(t + 8) & 15] ^ w[(t + 2) & 15];
			w[t] = ROL32(w[t], 1); /* left rotate 1. */
		}

		if (i < 20) {
			f = (v[1] & v[2]) | (~v[1] & v[3]);
			k = SHA1_K0;
		} else if (i < 40) {
			f = v[1] ^ v[2] ^ v[3];
			k = SHA1_K1;
		} else if (i < 60) {
			f = (v[1] & v[2]) | (v[1] & v[3]) | (v[2] & v[3]);
			k = SHA1_K2;
		} else {
			f = v[1] ^ v[2] ^ v[3];
			k = SHA1_K3;
		}

		tmp = ROL32(v[0], 5); /* left rotate 5. */
		tmp += f + v[4] + k + w[t];
		v[4] = v[3];
		v[3] = v[2];
		v[2] = ROL32(v[1], 30); /* left rotate 30. */
		v[1] = v[0];
		v[0] = tmp;

	}

	/* add a, b, c, d, e to the hash state. */
	for (i = 0; i < 5; i++) {
		ctx->h[i] += v[i];
	}

	memset(v, 0, sizeof v); /* erase the variables to avoid leaving useful data behind. */
}

/**
 * hash more data to the stream.
 */
int sha1_update(struct sha1_ctx *ctx, const void *data, size_t len)
{
	if (!ctx || (!data && !len))
		return 0; /* failure */

	while (len > 0) {
		/* load a chunk into ctx->data[]. return on short chunk.
		 * load data in endian neutral way.
		 */

		while (ctx->data_len < 4 * SHA1_LBLOCK) {
			if (len <= 0)
				return 1; /* continue this later. */

			/* fill out the buffer in big-endian order. */
			switch((ctx->cnt / 8) % 4) {
			case 0:
				ctx->data[ctx->data_len++ / 4] = ((uint_least32_t) * (const unsigned char*)data) << 24;
				break;

			case 1:
				ctx->data[ctx->data_len++ / 4] |= ((uint_least32_t) * (const unsigned char*)data) << 16;
				break;

			case 2:
				ctx->data[ctx->data_len++ / 4] |= ((uint_least32_t) * (const unsigned char*)data) << 8;
				break;

			case 3:
				ctx->data[ctx->data_len++ / 4] |= *(const unsigned char*)data;
				break;
			}

			ctx->cnt += 8; /* 8 bits were added. */
			data = (const unsigned char*)data + 1; /* next byte. */
			len--; /* we've used up a byte. */
		}

		assert(ctx->data_len == 4 * SHA1_LBLOCK); /* the loop condition above ensures this. */

		sha1_transform_chunk(ctx);

		ctx->data_len = 0;
	}

	return 1; /* success */
}

/**
 * pad SHA-1 with 1s followed by 0s and a 64-bit value of the number of bits.
 */
static void sha1_append_length(struct sha1_ctx *ctx)
{
	unsigned char lendata[8];

	assert(ctx != NULL);

	/* write out the total number of bits procesed by the hash into a buffer. */
	lendata[0] = ctx->cnt >> 56;
	lendata[1] = ctx->cnt >> 48;
	lendata[2] = ctx->cnt >> 40;
	lendata[3] = ctx->cnt >> 32;
	lendata[4] = ctx->cnt >> 24;
	lendata[5] = ctx->cnt >> 16;
	lendata[6] = ctx->cnt >> 8;
	lendata[7] = ctx->cnt;

	/* insert 1 bit followed by 0s. */
	sha1_update(ctx, "\x80", 1); /* binary 10000000. */

	while (ctx->cnt % 512 != 448) {
		sha1_update(ctx, "", 1); /* insert 0. */
	}

	/* write out the big-endian value holding the number of bits processed. */
	sha1_update(ctx, lendata, sizeof lendata);

	assert(ctx->cnt % 512 == 0); /* above should have triggered a sha1_transform_chunk(). */
}

/**
 * finish up the hash, and pad in the special SHA-1 way with the length.
 */
int sha1_final(unsigned char *md, struct sha1_ctx *ctx)
{
	assert(ctx != NULL);
	assert(md != NULL);

	sha1_append_length(ctx);

	assert(ctx->cnt % 512 == 0);

	/* combine h0, h1, h2, h3, h4 into digest. */
	if (md) {
		unsigned i;

		for (i = 0; i < 5; i++) {
			/* big-endian */
			md[i * 4] = ctx->h[i] >> 24;
			md[i * 4 + 1] = ctx->h[i] >> 16;
			md[i * 4 + 2] = ctx->h[i] >> 8;
			md[i * 4 + 3] = ctx->h[i];
		}
	}

	sha1_init(ctx); /* rub out the old data. */

	return 1; /* success */
}

/**
 * quick calculation of SHA1 on buffer data.
 * @param data pointer.
 * @param len length of data at pointer data.
 * @param md if NULL use a static array.
 * @return return md, of md is NULL then return static array.
 */
unsigned char *sha1(const void *data, size_t len, unsigned char *md)
{
	struct sha1_ctx ctx;
	static unsigned char tmp[SHA1_DIGEST_LENGTH];
	sha1_init(&ctx);
	sha1_update(&ctx, data, len);

	if (!md) md = tmp;

	sha1_final(md, &ctx);
	return md;
}

#ifndef NTEST
static void sha1_print_digest(const unsigned char *md)
{
	unsigned i;

	for (i = 0; i < SHA1_DIGEST_LENGTH; i++) {
		printf("%02X", md[i]);

		if (i < SHA1_DIGEST_LENGTH - 1) printf(":");
	}

	printf("\n");
}

int sha1_test(void)
{
	const char test1[] = "The quick brown fox jumps over the lazy dog";
	const unsigned char test1_digest[SHA1_DIGEST_LENGTH] = {
		0x2f, 0xd4, 0xe1, 0xc6, 0x7a, 0x2d, 0x28, 0xfc, 0xed, 0x84, 0x9e, 0xe1, 0xbb, 0x76, 0xe7, 0x39, 0x1b, 0x93, 0xeb, 0x12,
	};
	unsigned char digest[SHA1_DIGEST_LENGTH];

	memset(digest, 0, sizeof digest);

	if (!sha1(test1, strlen(test1), digest)) {
		printf("failed.\n");
		return 0;
	}

	printf("calculated : ");
	sha1_print_digest(digest);

	printf("known      : ");
	sha1_print_digest(test1_digest);

	printf("test1: %s\n", memcmp(digest, test1_digest, SHA1_DIGEST_LENGTH) ? "FAILED" : "PASSED");

	return 1;
}
#endif
