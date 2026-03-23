/**
 * @file base64.c
 *
 * Base64 encode and decode routines
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Aug 17
 *
 * Written in 2009-2022 by Jon Mayo <jon@rm-f.net>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#include <ctype.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "base64.h"
#include "boris.h"
#define LOG_SUBSYSTEM "crypt"
#include "log.h"
#include "debug.h"

static const uint8_t base64enc_tab[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/* uses 0 to indicate illegal value. holds value+1 for legal values (so you
 * must subtract to get the correct value). */
static const uint8_t base64dec_tab[256] = {
	['+'] = 62 + 1, ['/'] = 63 + 1, ['0'] = 52 + 1, ['1'] = 53 + 1,
	['2'] = 54 + 1, ['3'] = 55 + 1, ['4'] = 56 + 1, ['5'] = 57 + 1,
	['6'] = 58 + 1, ['7'] = 59 + 1, ['8'] = 60 + 1, ['9'] = 61 + 1,
	['A'] = 0 + 1,  ['B'] = 1 + 1,  ['C'] = 2 + 1,  ['D'] = 3 + 1,
	['E'] = 4 + 1,  ['F'] = 5 + 1,  ['G'] = 6 + 1,  ['H'] = 7 + 1,
	['I'] = 8 + 1,  ['J'] = 9 + 1,  ['K'] = 10 + 1, ['L'] = 11 + 1,
	['M'] = 12 + 1, ['N'] = 13 + 1, ['O'] = 14 + 1, ['P'] = 15 + 1,
	['Q'] = 16 + 1, ['R'] = 17 + 1, ['S'] = 18 + 1, ['T'] = 19 + 1,
	['U'] = 20 + 1, ['V'] = 21 + 1, ['W'] = 22 + 1, ['X'] = 23 + 1,
	['Y'] = 24 + 1, ['Z'] = 25 + 1, ['a'] = 26 + 1, ['b'] = 27 + 1,
	['c'] = 28 + 1, ['d'] = 29 + 1, ['e'] = 30 + 1, ['f'] = 31 + 1,
	['g'] = 32 + 1, ['h'] = 33 + 1, ['i'] = 34 + 1, ['j'] = 35 + 1,
	['k'] = 36 + 1, ['l'] = 37 + 1, ['m'] = 38 + 1, ['n'] = 39 + 1,
	['o'] = 40 + 1, ['p'] = 41 + 1, ['q'] = 42 + 1, ['r'] = 43 + 1,
	['s'] = 44 + 1, ['t'] = 45 + 1, ['u'] = 46 + 1, ['v'] = 47 + 1,
	['w'] = 48 + 1, ['x'] = 49 + 1, ['y'] = 50 + 1, ['z'] = 51 + 1,
};

/**
 * base64_encodes as ./0123456789a-zA-Z.
 *
 */
int base64_encode(size_t in_len, const unsigned char *in, size_t out_len, char *out)
{
	unsigned ii, io;
	uint_least32_t v;
	unsigned rem;

	for (io = 0, ii = 0, v = 0, rem = 0; ii < in_len; ii++) {
		unsigned char ch;
		ch = in[ii];
		v = (v << 8) | ch;
		rem += 8;

		while (rem >= 6) {
			rem -= 6;

			if (io >= out_len)
				return -1; /* truncation is failure */

			out[io++] = base64enc_tab[(v >> rem) & 63];
		}
	}

	if (rem) {
		v <<= (6 - rem);

		if (io >= out_len)
			return -1; /* truncation is failure */

		out[io++] = base64enc_tab[v & 63];
	}

	while (io & 3) {
		if (io >= out_len)
			return -1; /* truncation is failure */

		out[io++] = '=';
	}

	if (io >= out_len)
		return -1; /* no room for null terminator */

	out[io] = 0;
	return io;
}

/* decode a base64 string in one shot */
int base64_decode(size_t in_len, const char *in, size_t out_len, unsigned char *out)
{
	unsigned ii, io;
	uint_least32_t v;
	unsigned rem;

	for (io = 0, ii = 0, v = 0, rem = 0; ii < in_len; ii++) {
		unsigned char ch;

		if (isspace(in[ii]))
			continue;

		if (in[ii] == '=')
			break; /* stop at = */

		ch = base64dec_tab[(unsigned)in[ii]];

		if (!ch)
			break; /* stop at a parse error */
		ch--;

		v = (v << 6) | ch;
		rem += 6;

		if (rem >= 8) {
			rem -= 8;

			if (io >= out_len)
				return -1; /* truncation is failure */

			out[io++] = (v >> rem) & 255;
		}
	}

	if (rem >= 8) {
		rem -= 8;

		if (io >= out_len)
			return -1; /* truncation is failure */

		out[io++] = (v >> rem) & 255;
	}

	return io;
}

#if 0 // Code used to generate our table //
int
main()
{
	uint8_t *base64dec_tab;
	/* initialize base64dec_tab if not initialized. */
	if (!base64dec_tab) {
		unsigned i;
		base64dec_tab = calloc(1, 256);

		if (!base64dec_tab) {
			LOG_PERROR("malloc()");
			return 0;
		}

		for (i = 0; i < NR(base64enc_tab); i++) {
			base64dec_tab[base64enc_tab[i]] = i + 1;
		}
	}

	/* dump the table */
	{
	    unsigned i, out = 0;
	    for (i = 0 ; i < 256 ; i++) {
		uint8_t c = base64dec_tab[i];
		if (c) {
		    if (out == 0)
			printf("\t");
		    if (isprint(i)) {
			printf("['%c'] = %u + 1, ", i, c - 1);
		    } else {
			printf("[%u] = %u + 1, ", i, c - 1);
		    }
		    if (++out == 4) {
			printf("\n");
			out = 0;
		    }
		}
	    }
	    if (out)
		printf("\n");
	}
    return 0;
}
#endif
