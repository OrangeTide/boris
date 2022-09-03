/* passwd.c - very low security password hashing library */
/* Copyright 2009-2018, Jon Mayo <jon@rm-f.net> */
/* See COPYING.txt for complete license text. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "passwd.h"

#define SHA1_DIGEST_LENGTH 20
#define SHA1_LBLOCK 16

#define SHA1_K0 0x5a827999
#define SHA1_K1 0x6ed9eba1
#define SHA1_K2 0x8f1bbcdc
#define SHA1_K3 0xca62c1d6
#define ROL(f, v, b) \
	((((v) << (b)) | ((v) >> ((f) - (b)))) & (0xfffffffful >> (32 - (f))))

struct sha1_ctx {
	uint32_t h[5], data[SHA1_LBLOCK];
	uint32_t cnt; /**< support only 4Gb of data. */
	unsigned data_len; /**< number of bytes used in data. (not the number of words/elements) */
};

static void
sha1_init(struct sha1_ctx *ctx)
{
	ctx->h[0] = 0x67452301lu;
	ctx->h[1] = 0xefcdab89lu;
	ctx->h[2] = 0x98badcfelu;
	ctx->h[3] = 0x10325476lu;
	ctx->h[4] = 0xc3d2e1f0lu;
	ctx->cnt = 0;
	ctx->data_len = 0;
	memset(ctx->data, 0, sizeof(ctx->data));
}

static int
sha1_update(struct sha1_ctx *ctx, const void *data, size_t len)
{
	unsigned i;
	uint32_t v[5], f, k, tmp, w[16];
	const unsigned char *p=data;

	if (!ctx || (!data && !len))
		return 0; /* failure */

	while (len > 0) {
		while (ctx->data_len < 4 * SHA1_LBLOCK) {
			if (len <= 0)
				return 1; /* continue this later. */
			switch ((ctx->cnt / 8) % 4) {
			case 0:
				ctx->data[ctx->data_len++ / 4] = ((uint32_t)*p) << 24;
				break;
			case 1:
				ctx->data[ctx->data_len++ / 4] |= ((uint32_t)*p) << 16;
				break;
			case 2:
				ctx->data[ctx->data_len++ / 4] |= ((uint32_t)*p) << 8;
				break;
			case 3: 
				ctx->data[ctx->data_len++ / 4] |= *p;
				break;
			}
			ctx->cnt += 8; /* 8 bits were added. */
			p++;
			len--; /* we've used up a byte. */
		}

		for (i=0; i < 5; i++)
			v[i] = ctx->h[i];

		for (i=0; i < 80; i++) {
			unsigned t = i & 15;

			if (i < 16) {
				/* load 16 words of data into w[]. */
				w[i]=ctx->data[i];
			} else {
				/* 16 to 79 - perform this calculation. */
				w[t]^=w[(t+13)&15]^w[(t+8)&15]^w[(t+2)&15];
				w[t]=ROL(32, w[t], 1); /* left rotate 1. */
			}

			if (i < 20) {
				f=(v[1]&v[2])|(~v[1]&v[3]);
				k=SHA1_K0;
			} else if (i < 40) {
				f=v[1]^v[2]^v[3];
				k=SHA1_K1;
			} else if (i < 60) {
				f=(v[1]&v[2])|(v[1]&v[3])|(v[2]&v[3]);
				k=SHA1_K2;
			} else {
				f=v[1]^v[2]^v[3];
				k=SHA1_K3;
			}

			tmp=ROL(32, v[0], 5); /* left rotate 5. */
			tmp+=f+v[4]+k+w[t];
			v[4]=v[3];
			v[3]=v[2];
			v[2]=ROL(32, v[1], 30); /* left rotate 30. */
			v[1]=v[0];
			v[0]=tmp;

		}

		/* add a, b, c, d, e to the hash state. */
		for (i=0; i < 5; i++)
			ctx->h[i] += v[i];

		/* erase the variables to avoid leaving useful data behind. */
		memset(v, 0, sizeof(v));

		ctx->data_len=0;
	}

	return 1; /* success */
}

static void
sha1_final(unsigned char *md, struct sha1_ctx *ctx)
{
	unsigned char lendata[] = {
		0, 0, 0, 0, ctx->cnt >> 24, ctx->cnt >> 16, ctx->cnt >> 8, ctx->cnt,
	};
	unsigned i;

	sha1_update(ctx, "\x80", 1); /* binary 10000000. */
	while (ctx->cnt%512 != 448) { /* pad remaining block with 0s. */
		sha1_update(ctx, "", 1); /* insert 0. */
	}
	sha1_update(ctx, lendata, sizeof(lendata)); /* add 64-bit count of bits */
	for (i=0; i < 5; i++) {
		md[i * 4] = ctx->h[i] >> 24;
		md[i * 4 + 1] = ctx->h[i] >> 16;
		md[i * 4 + 2] = ctx->h[i] >> 8;
		md[i * 4 + 3] = ctx->h[i];
	}
	sha1_init(ctx);
}

void
gensalt(void *salt, size_t salt_len)
{
    size_t i;
    for (i=0; i < salt_len; i++) {
        ((unsigned char*)salt)[i] = (rand() % 96) + ' ';
    }
}

void
mkpass(struct password *p, const unsigned char salt[8], const char *plaintext)
{
	struct sha1_ctx ctx;
	memcpy(p->salt, salt, sizeof(p->salt));
	sha1_init(&ctx);
	sha1_update(&ctx, p->salt, sizeof(p->salt));
	sha1_update(&ctx, plaintext, strlen(plaintext));
	sha1_final(p->digest, &ctx);
}

/* the salt of a and b must be the same. */
int
ckpass(const struct password *a, const struct password *b)
{
	return !memcmp(a->digest, b->digest, sizeof(a->digest));
}
