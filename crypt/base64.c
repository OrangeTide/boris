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
#include "debug.h"

static const uint8_t base64enc_tab[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static uint8_t *base64dec_tab; /* initialized by base64_decode. */

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

	/* initialize base64dec_tab if not initialized. */
	if (!base64dec_tab) {
		unsigned i;
		base64dec_tab = malloc(256);

		if (!base64dec_tab) {
			PERROR("malloc()");
			return 0;
		}

		memset(base64dec_tab, 255, 256); /**< use 255 indicates a bad value. */

		for (i = 0; i < NR(base64enc_tab); i++) {
			base64dec_tab[base64enc_tab[i]] = i;
		}
	}

	for (io = 0, ii = 0, v = 0, rem = 0; ii < in_len; ii++) {
		unsigned char ch;

		if (isspace(in[ii]))
			continue;

		if (in[ii] == '=')
			break; /* stop at = */

		ch = base64dec_tab[(unsigned)in[ii]];

		if (ch == 255)
			break; /* stop at a parse error */

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
