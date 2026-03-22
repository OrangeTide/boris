/* hashtable.c : open-addressing hash tables with FNV-1a hashing */
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

#include "hashtable.h"

#include <stdlib.h>
#include <string.h>

#define FNV_OFFSET_BASIS 2166136261u
#define FNV_PRIME 16777619u

/** round up to next power of two. minimum 16. */
static unsigned
next_pow2(unsigned v)
{
	if (v < 16)
		v = 16;
	v--;
	v |= v >> 1;
	v |= v >> 2;
	v |= v >> 4;
	v |= v >> 8;
	v |= v >> 16;
	v++;
	return v;
}

static unsigned
hash_uint(unsigned key)
{
	unsigned h = FNV_OFFSET_BASIS;
	unsigned char *p = (unsigned char *)&key;
	unsigned i;

	for (i = 0; i < sizeof key; i++) {
		h ^= p[i];
		h *= FNV_PRIME;
	}
	return h;
}

static unsigned
hash_str(const char *key)
{
	unsigned h = FNV_OFFSET_BASIS;
	const unsigned char *p = (const unsigned char *)key;

	while (*p) {
		h ^= *p++;
		h *= FNV_PRIME;
	}
	return h;
}

/****************************************************************
 * Integer-keyed hash table
 ****************************************************************/

int
ht_uint_init(struct ht_uint *ht, unsigned capacity)
{
	capacity = next_pow2(capacity);
	ht->buckets = calloc(capacity, sizeof *ht->buckets);
	if (!ht->buckets)
		return -1;
	ht->capacity = capacity;
	ht->count = 0;
	return 0;
}

void
ht_uint_free(struct ht_uint *ht)
{
	free(ht->buckets);
	ht->buckets = NULL;
	ht->capacity = 0;
	ht->count = 0;
}

void *
ht_uint_get(struct ht_uint *ht, unsigned key)
{
	unsigned mask = ht->capacity - 1;
	unsigned idx = hash_uint(key) & mask;
	unsigned i;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_uint_entry *e = &ht->buckets[idx];
		if (!e->occupied)
			return NULL;
		if (e->key == key)
			return e->value;
		idx = (idx + 1) & mask;
	}
	return NULL;
}

/** grow the table to double capacity, rehashing all entries. */
static int
ht_uint_grow(struct ht_uint *ht)
{
	struct ht_uint_entry *old = ht->buckets;
	unsigned old_cap = ht->capacity;
	unsigned new_cap = old_cap * 2;
	unsigned i;

	ht->buckets = calloc(new_cap, sizeof *ht->buckets);
	if (!ht->buckets) {
		ht->buckets = old;
		return -1;
	}
	ht->capacity = new_cap;
	ht->count = 0;

	for (i = 0; i < old_cap; i++) {
		if (old[i].occupied)
			ht_uint_set(ht, old[i].key, old[i].value);
	}

	free(old);
	return 0;
}

int
ht_uint_set(struct ht_uint *ht, unsigned key, void *value)
{
	unsigned mask, idx, i;

	/* grow at 70% load */
	if (ht->count * 10 >= ht->capacity * 7) {
		if (ht_uint_grow(ht))
			return -1;
	}

	mask = ht->capacity - 1;
	idx = hash_uint(key) & mask;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_uint_entry *e = &ht->buckets[idx];
		if (!e->occupied) {
			e->key = key;
			e->value = value;
			e->occupied = 1;
			ht->count++;
			return 0;
		}
		if (e->key == key) {
			e->value = value;
			return 0;
		}
		idx = (idx + 1) & mask;
	}
	return -1; // should not happen if load factor is maintained
}

void *
ht_uint_del(struct ht_uint *ht, unsigned key)
{
	unsigned mask = ht->capacity - 1;
	unsigned idx = hash_uint(key) & mask;
	unsigned i;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_uint_entry *e = &ht->buckets[idx];
		if (!e->occupied)
			return NULL;
		if (e->key == key) {
			void *val = e->value;
			e->occupied = 0;
			e->value = NULL;
			ht->count--;

			/* rehash the cluster after the deleted slot */
			idx = (idx + 1) & mask;
			while (ht->buckets[idx].occupied) {
				struct ht_uint_entry tmp = ht->buckets[idx];
				ht->buckets[idx].occupied = 0;
				ht->count--;
				ht_uint_set(ht, tmp.key, tmp.value);
				idx = (idx + 1) & mask;
			}
			return val;
		}
		idx = (idx + 1) & mask;
	}
	return NULL;
}

/****************************************************************
 * String-keyed hash table
 ****************************************************************/

int
ht_str_init(struct ht_str *ht, unsigned capacity)
{
	capacity = next_pow2(capacity);
	ht->buckets = calloc(capacity, sizeof *ht->buckets);
	if (!ht->buckets)
		return -1;
	ht->capacity = capacity;
	ht->count = 0;
	return 0;
}

void
ht_str_free(struct ht_str *ht, void (*free_value)(void *))
{
	unsigned i;

	if (!ht->buckets)
		return;

	for (i = 0; i < ht->capacity; i++) {
		if (ht->buckets[i].occupied) {
			free(ht->buckets[i].key);
			if (free_value)
				free_value(ht->buckets[i].value);
		}
	}
	free(ht->buckets);
	ht->buckets = NULL;
	ht->capacity = 0;
	ht->count = 0;
}

void *
ht_str_get(struct ht_str *ht, const char *key)
{
	unsigned mask = ht->capacity - 1;
	unsigned idx = hash_str(key) & mask;
	unsigned i;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_str_entry *e = &ht->buckets[idx];
		if (!e->occupied)
			return NULL;
		if (strcmp(e->key, key) == 0)
			return e->value;
		idx = (idx + 1) & mask;
	}
	return NULL;
}

/** grow the string table to double capacity, rehashing all entries. */
static int
ht_str_grow(struct ht_str *ht)
{
	struct ht_str_entry *old = ht->buckets;
	unsigned old_cap = ht->capacity;
	unsigned new_cap = old_cap * 2;
	unsigned i;

	ht->buckets = calloc(new_cap, sizeof *ht->buckets);
	if (!ht->buckets) {
		ht->buckets = old;
		return -1;
	}
	ht->capacity = new_cap;
	ht->count = 0;

	for (i = 0; i < old_cap; i++) {
		if (old[i].occupied) {
			/* reuse existing key string, no copy needed */
			unsigned mask = new_cap - 1;
			unsigned idx = hash_str(old[i].key) & mask;
			unsigned j;

			for (j = 0; j < new_cap; j++) {
				struct ht_str_entry *e = &ht->buckets[idx];
				if (!e->occupied) {
					e->key = old[i].key;
					e->value = old[i].value;
					e->occupied = 1;
					ht->count++;
					break;
				}
				idx = (idx + 1) & mask;
			}
		}
	}

	free(old);
	return 0;
}

int
ht_str_set(struct ht_str *ht, const char *key, void *value)
{
	unsigned mask, idx, i;

	/* grow at 70% load */
	if (ht->count * 10 >= ht->capacity * 7) {
		if (ht_str_grow(ht))
			return -1;
	}

	mask = ht->capacity - 1;
	idx = hash_str(key) & mask;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_str_entry *e = &ht->buckets[idx];
		if (!e->occupied) {
			e->key = strdup(key);
			if (!e->key)
				return -1;
			e->value = value;
			e->occupied = 1;
			ht->count++;
			return 0;
		}
		if (strcmp(e->key, key) == 0) {
			e->value = value;
			return 0;
		}
		idx = (idx + 1) & mask;
	}
	return -1;
}

void *
ht_str_del(struct ht_str *ht, const char *key)
{
	unsigned mask = ht->capacity - 1;
	unsigned idx = hash_str(key) & mask;
	unsigned i;

	for (i = 0; i < ht->capacity; i++) {
		struct ht_str_entry *e = &ht->buckets[idx];
		if (!e->occupied)
			return NULL;
		if (strcmp(e->key, key) == 0) {
			void *val = e->value;
			free(e->key);
			e->key = NULL;
			e->value = NULL;
			e->occupied = 0;
			ht->count--;

			/* rehash the cluster after the deleted slot */
			idx = (idx + 1) & mask;
			while (ht->buckets[idx].occupied) {
				struct ht_str_entry tmp = ht->buckets[idx];
				ht->buckets[idx].occupied = 0;
				ht->buckets[idx].key = NULL;
				ht->count--;
				/* reinsert directly to avoid strdup */
				unsigned m = ht->capacity - 1;
				unsigned ri = hash_str(tmp.key) & m;
				unsigned j;
				for (j = 0; j < ht->capacity; j++) {
					struct ht_str_entry *re = &ht->buckets[ri];
					if (!re->occupied) {
						re->key = tmp.key;
						re->value = tmp.value;
						re->occupied = 1;
						ht->count++;
						break;
					}
					ri = (ri + 1) & m;
				}
				idx = (idx + 1) & mask;
			}
			return val;
		}
		idx = (idx + 1) & mask;
	}
	return NULL;
}
