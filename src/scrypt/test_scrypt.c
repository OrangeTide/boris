#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "crypto_scrypt.h"

static struct scrypt_test {
	const char * passwd;
	const char * salt;
	uint64_t N;
	uint32_t r;
	uint32_t p;
} tests[4] = {
	{ "", "", 16, 1, 1 },
	{ "password", "NaCl", 1024, 8, 16 },
	{ "pleaseletmein", "SodiumChloride", 16384, 8, 1 },
	{ "pleaseletmein", "SodiumChloride", 1048576, 8, 1 }
};

int
main(int argc, char * argv[])
{
	struct scrypt_test * test;
	char kbuf[64];
	size_t i;

	(void)argc; /* UNUSED */
	(void)argv; /* UNUSED */

	for (test = tests;
	    test < tests + sizeof(tests) / sizeof(tests[0]);
	    test++) {
		int result;
		result = crypto_scrypt((const uint8_t *)test->passwd,
		    strlen(test->passwd), (const uint8_t *)test->salt,
		    strlen(test->salt), test->N, test->r, test->p,
		    (uint8_t *)kbuf, 64);
		if (result) {
			fprintf(stderr, "error! code=%d\n", result);
			return (1);
		}
		printf("scrypt(\"%s\", \"%s\", %u, %u, %u, 64) =\n",
		    test->passwd, test->salt, (unsigned int)test->N,
		    (unsigned int)(test->r), (unsigned int)test->p);
		for (i = 0; i < 64; i++) {
			printf("%02x ", (uint8_t)kbuf[i]);
			if ((i % 16) == 15)
				printf("\n");
		}
	}

	return (0);
}
