/**
 * @file base64.h
 *
 * Base64 encode and decode routines
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2009 Dec 13
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
#ifndef BASE64_H_
#define BASE64_H_
#include <stddef.h>

int base64_encode(size_t in_len, const unsigned char *in, size_t out_len, char *out);
int base64_decode(size_t in_len, const char *in, size_t out_len, unsigned char *out);
#endif
