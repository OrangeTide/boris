/**
 * @file buf.c
 *
 * Memory buffer routines.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Sept 5
 *
 * Copyright (c) 2022, Jon Mayo <jon@rm-f.net>
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

#include "buf.h"
#include <stdlib.h>
#include <limits.h>
#include <string.h>

#define ERR (-1)
#define OK (0)

struct buf {
	int error_flag;
	unsigned length;
	unsigned capacity;
	unsigned limit;
	char *data;
};

static int
buf_grow(char **data, unsigned length, unsigned increase, unsigned *capacity, unsigned limit, unsigned elemsz)
{
	if (length + increase > *capacity) {
		unsigned newsize = length + increase;
		newsize--;
		newsize |= newsize >> 1;
		newsize |= newsize >> 2;
		newsize |= newsize >> 4;
		newsize |= newsize >> 8;
#if (UINT_MAX > 65535)
		newsize |= newsize >> 16;
#if (UINT_MAX > 4294967296L)
		newsize |= newsize >> 32;
#endif
#endif
		newsize++;

		if (limit && newsize >= limit) {
			return ERR;
		}

		void *p = realloc(*data, (size_t)newsize * elemsz);
		if (!p)
			return ERR;

		*capacity = newsize;
		*data = p;
	}

	return OK;
}

static int
buf_increment(char **data, unsigned length, unsigned *capacity, unsigned limit, unsigned elemsz)
{
	if (length >= *capacity) {
		size_t newcap = *capacity;

		if (newcap) {
			newcap *= 2;
		} else {
			newcap = 1;
		}

		if (limit && newcap >= limit) {
			return ERR;
		}

		void *p = realloc(*data, newcap * elemsz);
		if (!p)
			return ERR;

		*capacity = newcap;
		*data = p;
	}

	return OK;
}

struct buf *
buf_new(void)
{
	struct buf *b = malloc(sizeof(*b));
	if (!b)
		return NULL;

	const int capacity = 8;
	*b = (struct buf){
		.data = malloc(capacity),
		.capacity = capacity,
		};

	if (!b->data) {
		free(b);
		return NULL;
	}

	return b;
}

void
buf_set_limit(struct buf *b, size_t limit)
{
	b->limit = limit;
}

void
buf_free(struct buf *b)
{
	if (!b) {
		return;
	}

	free(b->data);
	b->data = NULL;

	b->length = b->capacity = 0;
	b->error_flag = ERR;

	free(b);
}

bool
buf_check(struct buf *b)
{
	return b && b->error_flag == OK && b->length <= b->capacity;
}

void
buf_append(struct buf *b, char v)
{
	if (!b || b->error_flag || (b->error_flag = buf_increment(&b->data, b->length, &b->capacity, b->limit, sizeof(*b->data)))) {
		return;
	}
	b->data[b->length++] = v;
}

void
buf_write(struct buf *b, const void *data, size_t len)
{
	if (!b || b->error_flag || (b->error_flag = buf_grow(&b->data, b->length, len, &b->capacity, b->limit, sizeof(*b->data)))) {
		return;
	}
	memcpy(b->data + b->length, data, len);
	b->length += len;
}

size_t
buf_read(struct buf *b, void *data, size_t maxlen)
{
	if (!b || b->error_flag) {
		return 0;
	}
	size_t len = maxlen > b->length ? b->length : maxlen;
	memcpy(data, b->data, len);
	b->length -= len;
	if (b->length) {
		memmove(b->data, b->data + len, b->length);
	}

	return len;
}

/* buf_data gets a readable buffer.
 * To function like read, use with buf_consume() to remove data from head of buffer. */
void *
buf_data(struct buf *b, size_t *len_out)
{
	if (!b) {
		if (len_out)
			*len_out = 0;
		return NULL;
	}

	if (len_out) {
		*len_out = b->length;
	}

	return b->data;
}

/* buf_reserve gets a writable buffer of a minimum size(minlen).
 * finish with buf_commit() */
void *
buf_reserve(struct buf *b, size_t *len_out, size_t minlen)
{
	if (!b || b->error_flag || (b->error_flag = buf_grow(&b->data, b->length, minlen, &b->capacity, b->limit, sizeof(*b->data)))) {
		return NULL;
	}

	if (len_out) {
		*len_out = b->capacity - b->length;
	}

	return b->data + b->length;
}

/* buf_commit adjusts buffer length to include uncommitted data. */
void
buf_commit(struct buf *b, size_t addlen)
{
	if (!b || b->error_flag || (b->error_flag = buf_grow(&b->data, b->length, addlen, &b->capacity, b->limit, sizeof(*b->data)))) {
		return;
	}
	b->length += addlen;
}

/* buf_consume removes data from head of a buffer.
 * return true if buffer is completely empty (b->length is 0). */
bool
buf_consume(struct buf *b, size_t len)
{
	if (!b || b->error_flag) {
		return true;
	}
	if (len > b->length) {
		len = b->length;
	}

	b->length -= len;
	memmove(b->data, b->data + len, b->length);

	return b->length == 0;
}
