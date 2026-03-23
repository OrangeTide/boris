/*
 * Wrapper around tiny-AES-c (https://github.com/kokke/tiny-AES-c)
 * providing the crypto_aes interface expected by the scrypt code.
 *
 * tiny-AES-c is public domain (Unlicense).
 */
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "aes.h"
#include "crypto_aes.h"

struct crypto_aes_key {
	struct AES_ctx ctx;
};

/**
 * crypto_aes_key_expand(key, len):
 * Expand the ${len}-byte AES key ${key} into a structure which can be passed
 * to crypto_aes_encrypt_block.  The length must be 16 or 32.
 */
struct crypto_aes_key *
crypto_aes_key_expand(const uint8_t *key, size_t len)
{
	struct crypto_aes_key *k;

	assert((len == 16) || (len == 32));
	(void)len;

	if ((k = malloc(sizeof(struct crypto_aes_key))) == NULL)
		return (NULL);

	AES_init_ctx(&k->ctx, key);

	return (k);
}

/**
 * crypto_aes_encrypt_block(in, out, key):
 * Using the expanded AES key ${key}, encrypt the block ${in} and write the
 * resulting ciphertext to ${out}.
 */
void
crypto_aes_encrypt_block(const uint8_t *in, uint8_t *out,
    const struct crypto_aes_key *key)
{
	memcpy(out, in, 16);
	AES_ECB_encrypt(&key->ctx, out);
}

/**
 * crypto_aes_key_free(key):
 * Free the expanded AES key ${key}.
 */
void
crypto_aes_key_free(struct crypto_aes_key *key)
{
	if (key == NULL)
		return;

	memset(key, 0, sizeof(struct crypto_aes_key));
	free(key);
}
