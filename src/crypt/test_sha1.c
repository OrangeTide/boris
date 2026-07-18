/* unit test for sha1.c */
#define LOG_SUBSYSTEM "test_sha1"

/* include the source directly for unit testing */
#include "sha1.c"

#include "ctest.h"

/* compare a computed digest against an expected 20-byte vector. */
static void
check_vector(const char *label, const char *msg, const unsigned char *expect)
{
	unsigned char md[SHA1_DIGEST_LENGTH];

	memset(md, 0, sizeof md);
	CHECK("sha1() returns the digest buffer",
		sha1(msg, strlen(msg), md) == md);
	CHECK(label, memcmp(md, expect, SHA1_DIGEST_LENGTH) == 0);
}

int
main(void)
{
	/* well-known FIPS/RFC test vectors. */
	static const unsigned char empty[SHA1_DIGEST_LENGTH] = {
		0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d, 0x32, 0x55,
		0xbf, 0xef, 0x95, 0x60, 0x18, 0x90, 0xaf, 0xd8, 0x07, 0x09,
	};
	static const unsigned char abc[SHA1_DIGEST_LENGTH] = {
		0xa9, 0x99, 0x3e, 0x36, 0x47, 0x06, 0x81, 0x6a, 0xba, 0x3e,
		0x25, 0x71, 0x78, 0x50, 0xc2, 0x6c, 0x9c, 0xd0, 0xd8, 0x9d,
	};
	static const unsigned char fox[SHA1_DIGEST_LENGTH] = {
		0x2f, 0xd4, 0xe1, 0xc6, 0x7a, 0x2d, 0x28, 0xfc, 0xed, 0x84,
		0x9e, 0xe1, 0xbb, 0x76, 0xe7, 0x39, 0x1b, 0x93, 0xeb, 0x12,
	};

	check_vector("empty string vector", "", empty);
	check_vector("\"abc\" vector", "abc", abc);
	check_vector("quick brown fox vector",
		"The quick brown fox jumps over the lazy dog", fox);

	return ctest_report("test_sha1");
}
