/* unit test for sha1crypt.c (salted SHA-1 password hashing) */
#define LOG_SUBSYSTEM "test_sha1crypt"

/* include the source directly for unit testing; base64.c and sha1.c come from
 * the crypt library (see module.mk). */
#include "sha1crypt.c"

#include "ctest.h"

/* a freshly made hash must verify against its own password and reject others. */
static void
test_roundtrip(void)
{
	char buf[SHA1PASSWD_MAX];

	CHECK("makepass succeeds", sha1crypt_makepass(buf, sizeof buf, "abcdef") != 0);
	CHECK("makepass output carries the SSHA magic",
		strncmp(buf, SHA1PASSWD_MAGIC, SHA1PASSWD_MAGIC_LEN) == 0);
	CHECK("checkpass accepts correct password",
		sha1crypt_checkpass(buf, "abcdef") != 0);
	CHECK("checkpass rejects wrong password",
		sha1crypt_checkpass(buf, "abcdeg") == 0);
}

/* precomputed hashes must verify against their known plaintext. */
static void
test_known_vectors(void)
{
	static const struct { const char *pass, *hash; } ex[] = {
		{ "secret", "{SSHA}2gDsLm/57U00KyShbiYsgvPIsQtzYWx0" },
		{ "abcdef", "{SSHA}AZz7VpGpy0tnrooaGm++zs9zqgZiVHhbKEc=" },
		{ "abcdef", "{SSHA}6Nrfz6LziwIo8HsSAkjm/nCeledLUntDZlw=" },
		{ "abcdeg", "{SSHA}8Lqg317f9lLd0M3EnwIe7BHiH3liVHhbKEc=" },
	};
	unsigned i;

	for (i = 0; i < sizeof ex / sizeof ex[0]; i++) {
		char label[64];

		snprintf(label, sizeof label, "known vector %u verifies", i + 1);
		CHECK(label, sha1crypt_checkpass(ex[i].hash, ex[i].pass) != 0);
	}

	CHECK("known vector rejects a wrong password",
		sha1crypt_checkpass(ex[0].hash, "wrong") == 0);
}

int
main(void)
{
	test_roundtrip();
	test_known_vectors();

	return ctest_report("test_sha1crypt");
}
