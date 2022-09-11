/**
 * @file grow.c
 *
 * dynamically resize allocated arrays
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Sep 7
 *
 * Copyright (c) 2013-2015, 2020, 2022 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include "grow.h"

#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* grow allocates a buffer of a minimum size. updating ptr and max
 * ptr is expected to be a pointer to a pointer.
 */
int
grow(void **ptr, unsigned *max, unsigned min, size_t elem)
{
	size_t oldsize = *max * elem;
	size_t newsize = min * elem;
	char *p;

	if (!ptr || !max) {
		return -1; /* error */
	}

	if (newsize <= oldsize) {
		return 0; /* success - no need to change */
	}

	/* round up to next power-of-2 */
	newsize--;
	newsize |= newsize >> 1;
	newsize |= newsize >> 2;
	newsize |= newsize >> 4;
	newsize |= newsize >> 8;
	newsize |= newsize >> 16;
#if (UINT_MAX > 65535)
	newsize |= newsize >> 16;
#if (UINT_MAX > 4294967296L)
	newsize |= newsize >> 32;
#endif
#endif
	newsize++;

	/* allocate the buffer */
	assert(ptr != NULL);
	assert(oldsize <= newsize);
	p = realloc(*(char**)ptr, newsize);
	if (!p) {
		perror(__func__);
		return -1; /* error - unable to allocate new buffer */
	}

	/* clear the new data */
	memset(p + oldsize, 0, newsize - oldsize);

	/* copy paramters back out */
	assert(ptr != NULL && *(void**)ptr != NULL);
	*(void**)ptr = p;
	*max = newsize / elem;

	return 0; /* success */
}
