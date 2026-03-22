/* hashtable.h : open-addressing hash tables with FNV-1a hashing */
/*
 * Copyright (c) 2022-2026, Jon Mayo <jon@rm-f.net>
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

#ifndef HASHTABLE_H_
#define HASHTABLE_H_

#include <stddef.h>

/****************************************************************
 * Integer-keyed hash table (for room/character ID lookup)
 ****************************************************************/

struct ht_uint_entry {
	unsigned key;
	void *value;
	int occupied;
};

struct ht_uint {
	struct ht_uint_entry *buckets;
	unsigned capacity;
	unsigned count;
};

int ht_uint_init(struct ht_uint *ht, unsigned capacity);
void ht_uint_free(struct ht_uint *ht);
void *ht_uint_get(struct ht_uint *ht, unsigned key);
int ht_uint_set(struct ht_uint *ht, unsigned key, void *value);
void *ht_uint_del(struct ht_uint *ht, unsigned key);

/****************************************************************
 * String-keyed hash table (for help topic cache)
 ****************************************************************/

struct ht_str_entry {
	char *key;
	void *value;
	int occupied;
};

struct ht_str {
	struct ht_str_entry *buckets;
	unsigned capacity;
	unsigned count;
};

int ht_str_init(struct ht_str *ht, unsigned capacity);
void ht_str_free(struct ht_str *ht, void (*free_value)(void *));
void *ht_str_get(struct ht_str *ht, const char *key);
int ht_str_set(struct ht_str *ht, const char *key, void *value);
void *ht_str_del(struct ht_str *ht, const char *key);

#endif
