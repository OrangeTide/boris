/**
 * @file sha1crypt.c
 *
 * SHA-1 password hashing
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
#include <stdlib.h>
#include <string.h>
#include "base64.h"
#define LOG_SUBSYSTEM "crypt"
#include "log.h"
#include "debug.h"
#include "sha1.h"
#include "sha1crypt.h"

/**
 * generate a salt for the hash.
 */
static void sha1crypt_gensalt(size_t salt_len, void *salt)
{
	size_t i;

	for (i = 0; i < salt_len; i++) {
		/* TODO: use better random salt */
		((unsigned char*)salt)[i] = (rand() % 96) + ' ';
	}
}

static int sha1crypt_create_password(char *buf, size_t max, const char *plaintext, size_t salt_len, const unsigned char *salt)
{
	struct sha1_ctx ctx;
	/** hold both the digest and the salt. */
	unsigned char digest[SHA1_DIGEST_LENGTH + SHA1CRYPT_GENSALT_MAX];
	/** round up to a multiple of 4, then multiply by 4/3. */
	char tmp[((SHA1_DIGEST_LENGTH + SHA1CRYPT_GENSALT_MAX + 3) / 4 * 4) * 4 / 3 + 1];

	if (salt_len > SHA1CRYPT_GENSALT_MAX) {
		LOG_ERROR("Salt is too large.");
		return 0; /**< salt too large. */
	}

	/* calculate SHA1 of salt+plaintext. */
	sha1_init(&ctx);
	sha1_update(&ctx, salt, salt_len);
	sha1_update(&ctx, plaintext, strlen(plaintext));
	sha1_final(digest, &ctx);

	/* append salt onto end of digest. */
	memcpy(digest + SHA1_DIGEST_LENGTH, salt, salt_len);

	/* encode digest+salt into buf. */
	if (base64_encode(SHA1_DIGEST_LENGTH + salt_len, digest, sizeof tmp, tmp) < 0) {
		LOG_ERROR("Buffer cannot hold password.");
		return 0; /**< no room. */
	}

	/** @todo return an error if snprintf truncated. */
	snprintf(buf, max, "%s%s", SHA1PASSWD_MAGIC, tmp);

	TRACE("Password hash: \"%s\"\n", buf);
	HEXDUMP_TRACE(salt, salt_len, "Password salt(len=%d): ", salt_len);

	return 1; /**< success. */
}

/**
 * @param buf output buffer.
 */
int sha1crypt_makepass(char *buf, size_t max, const char *plaintext)
{
	unsigned char salt[SHA1CRYPT_GENSALT_LEN];

	assert(max > 0);

	/* create a random salt of reasonable length. */
	sha1crypt_gensalt(sizeof salt, salt);

	return sha1crypt_create_password(buf, max, plaintext, sizeof salt, salt);
}

int sha1crypt_checkpass(const char *crypttext, const char *plaintext)
{
	char tmp[SHA1PASSWD_MAX]; /* big enough to hold a re-encoded password. */
	unsigned char digest[SHA1_DIGEST_LENGTH + SHA1CRYPT_GENSALT_MAX];
	unsigned char *salt;
	int res;
	size_t crypttext_len;

	crypttext_len = strlen(crypttext);

	/* check for password magic at beginning. */
	if (crypttext_len <= SHA1PASSWD_MAGIC_LEN || strncmp(crypttext, SHA1PASSWD_MAGIC, SHA1PASSWD_MAGIC_LEN)) {
		LOG_ERROR("not a SHA1 crypt.");
		return 0; /**< bad base64 string, too large or too small. */
	}

	/* get salt from password, and skip over magic. */
	res = base64_decode(crypttext_len - SHA1PASSWD_MAGIC_LEN, crypttext + SHA1PASSWD_MAGIC_LEN, sizeof digest, digest);

	if (res < 0 || res < SHA1_DIGEST_LENGTH) {
		LOG_ERROR("crypt decode error.");
		return 0; /**< bad base64 string, too large or too small. */
	}

	salt = &digest[SHA1_DIGEST_LENGTH];

	/* saltlength = total - digest */
	res = sha1crypt_create_password(tmp, sizeof tmp, plaintext, res - SHA1_DIGEST_LENGTH, salt);

	if (!res) {
		LOG_ERROR("crypt decode error2.");
		return 0; /**< couldn't encode? weird. this shouldn't ever happen. */
	}

	/* encoded successfully - compare them */
	return strcmp(tmp, crypttext) == 0;
}

#ifndef NTEST
#include "boris.h"

/* example:
 * {SSHA}ZIb6984G1q5itn2VUoEb34Jxuq5LUntDZlwK */
void sha1crypt_test(void)
{
	char buf[SHA1PASSWD_MAX];
	int res;
	char salt[SHA1CRYPT_GENSALT_LEN];
	struct {
		char *pass, *hash;
	} examples[] = {
		{ "secret", "{SSHA}2gDsLm/57U00KyShbiYsgvPIsQtzYWx0" },
		{ "abcdef", "{SSHA}AZz7VpGpy0tnrooaGm++zs9zqgZiVHhbKEc=" },
		{ "abcdef", "{SSHA}6Nrfz6LziwIo8HsSAkjm/nCeledLUntDZlw=" },
		{ "abcdeg", "{SSHA}8Lqg317f9lLd0M3EnwIe7BHiH3liVHhbKEc="},
	};
	unsigned i;

	/* generate salt. */
	sha1crypt_gensalt(sizeof salt, salt);
	HEXDUMP(salt, sizeof salt, "%s(): testing sha1crypt_gensalt() : salt=", __func__);

	/* password creation and checking. - positive testing. */
	sha1crypt_makepass(buf, sizeof buf, "abcdef");
	printf("buf=\"%s\"\n", buf);
	res = sha1crypt_checkpass(buf, "abcdef");
	LOG_DEBUG("sha1crypt_checkpass() positive:%s (res=%d)", !res ? "FAILED" : "PASSED", res);

	if (!res) {
		LOG_ERROR("sha1crypt_checkpass() must succeed on positive test.");
		exit(1);
	}

	/* checking - negative testing. */
	res = sha1crypt_checkpass(buf, "abcdeg");
	LOG_DEBUG("sha1crypt_checkpass() negative:%s (res=%d)", res ? "FAILED" : "PASSED", res);

	if (res) {
		LOG_ERROR("sha1crypt_checkpass() must fail on negative test.");
		exit(1);
	}

	/* loop through all hardcoded examples. */
	for (i = 0; i < NR(examples); i++) {
		res = sha1crypt_checkpass(examples[i].hash, examples[i].pass);
		LOG_DEBUG("Example %d:%s (res=%d) hash:%s", i + 1, !res ? "FAILED" : "PASSED", res, examples[i].hash);
	}
}
#endif
