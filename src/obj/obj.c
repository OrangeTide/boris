/**
 * @file obj.c
 *
 * MUD Object database as a mutable JSON structure
 *
 * Objects hold a parsed JSON buffer (via jsmn) for zero-copy reads.
 * Mutations modify the token array directly -- inserting, removing,
 * or replacing tokens via memmove. New string values are appended
 * to the data buffer. Compaction re-serializes and re-parses to
 * reclaim dead space in the data buffer.
 *
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

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM "obj"
#endif
#include "obj.h"

#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <jsmn.h>
#include <log.h>

#define OBJ_JSON_INIT_TOKENS 64
#define OBJ_JSON_MAX_TOKENS 16384

/* sentinel returned by data_append on allocation failure */
#define DATA_APPEND_FAIL UINT_MAX

struct obj {
	char *key;
	bool dirty;

	/* data buffer -- holds original JSON followed by appended strings */
	unsigned json_len;	/* length of original/compacted JSON */
	unsigned data_used;	/* total bytes consumed in data */
	unsigned data_alloc;	/* allocated size of data */
	char *data;

	unsigned tokens_alloc;
	unsigned tokens_used;
	jsmntok_t *tokens;
};

/* compare a jsmn token to a null-terminated string */
static int
json_token_streq(const char *json, const jsmntok_t *t, const char *s)
{
	return strncmp(json + t->start, s, t->end - t->start) == 0
		&& strlen(s) == (size_t)(t->end - t->start);
}

/* return a pointer into the json buffer for a string or primitive token.
 * modifies the buffer by writing a null terminator. */
static char *
json_token_tostr(char *json, const jsmntok_t *t)
{
	if (t->type != JSMN_STRING && t->type != JSMN_PRIMITIVE) {
		return NULL;
	}
	json[t->end] = '\0';
	return json + t->start;
}

static int
obj_parse(OBJ *obj)
{
	jsmn_parser p;

	if (!obj || !obj->data) {
		return OBJ_ERR;
	}

	jsmn_init(&p);

	free(obj->tokens);
	obj->tokens = NULL;
	obj->tokens_alloc = OBJ_JSON_INIT_TOKENS;

	for (;;) {
		jsmntok_t *tokens;
		int r;

		if (obj->tokens_alloc > OBJ_JSON_MAX_TOKENS) {
			LOG_ERROR("object too complex (>%d tokens): %.64s",
				OBJ_JSON_MAX_TOKENS, obj->data);
			goto fail;
		}

		tokens = realloc(obj->tokens,
			sizeof(*tokens) * obj->tokens_alloc);
		if (!tokens) {
			LOG_ERROR("failed to allocate tokens (count=%u): %.64s",
				obj->tokens_alloc, obj->data);
			goto fail;
		}
		obj->tokens = tokens;

		r = jsmn_parse(&p, obj->data, obj->json_len,
			tokens, obj->tokens_alloc);
		if (r >= 0) {
			obj->tokens_used = r;
			return OBJ_OK;
		}
		if (r != JSMN_ERROR_NOMEM) {
			LOG_ERROR("JSON parse error %d: %.64s", r, obj->data);
			goto fail;
		}

		obj->tokens_alloc *= 2;
	}

fail:
	free(obj->tokens);
	obj->tokens = NULL;
	obj->tokens_alloc = 0;
	obj->tokens_used = 0;
	return OBJ_ERR;
}

/* append a null-terminated string to obj->data, return its offset.
 * returns DATA_APPEND_FAIL on allocation failure. */
static unsigned
data_append(OBJ *obj, const char *s, unsigned slen)
{
	unsigned off;
	unsigned need = obj->data_used + slen + 1;

	if (need > obj->data_alloc) {
		unsigned new_alloc = obj->data_alloc ? obj->data_alloc * 2 : 128;
		char *new_data;

		while (new_alloc < need)
			new_alloc *= 2;
		new_data = realloc(obj->data, new_alloc);
		if (!new_data)
			return DATA_APPEND_FAIL;
		obj->data = new_data;
		obj->data_alloc = new_alloc;
	}

	off = obj->data_used;
	memcpy(obj->data + off, s, slen);
	obj->data[off + slen] = '\0';
	obj->data_used += slen + 1;
	return off;
}

/* count tokens consumed by a token and its children */
static int
token_span(const jsmntok_t *t, unsigned count)
{
	int i, j;

	if (count == 0) {
		return 0;
	}

	switch (t->type) {
	case JSMN_PRIMITIVE:
	case JSMN_STRING:
		return 1;
	case JSMN_OBJECT:
		j = 1;
		for (i = 0; i < t->size; i++) {
			j += token_span(t + j, count - j); /* key */
			j += token_span(t + j, count - j); /* value */
		}
		return j;
	case JSMN_ARRAY:
		j = 1;
		for (i = 0; i < t->size; i++) {
			j += token_span(t + j, count - j);
		}
		return j;
	default:
		return 1;
	}
}

/** find property by name in token array.
 *
 * Returns the token index of the matching key, or -1 if not found.
 * Handles complex values correctly via token_span.
 */
static int
find_prop(OBJ *obj, const char *name)
{
	const jsmntok_t *t;
	int i, pos;

	if (!obj->tokens || obj->tokens_used == 0)
		return -1;
	t = obj->tokens;
	if (t->type != JSMN_OBJECT)
		return -1;

	pos = 1;
	for (i = 0; i < t[0].size; i++) {
		int val_span;

		if (json_token_streq(obj->data, &t[pos], name))
			return pos;

		val_span = token_span(&t[pos + 1], obj->tokens_used - pos - 1);
		pos += 1 + val_span;
	}
	return -1;
}

/* ensure tokens array has room for at least n more tokens */
static int
tokens_grow(OBJ *obj, unsigned n)
{
	unsigned need = obj->tokens_used + n;

	if (need <= obj->tokens_alloc)
		return OBJ_OK;

	unsigned new_alloc = obj->tokens_alloc ? obj->tokens_alloc : OBJ_JSON_INIT_TOKENS;
	while (new_alloc < need)
		new_alloc *= 2;

	jsmntok_t *new_tokens = realloc(obj->tokens,
		sizeof(*new_tokens) * new_alloc);
	if (!new_tokens)
		return OBJ_ERR_NOMEM;

	obj->tokens = new_tokens;
	obj->tokens_alloc = new_alloc;
	return OBJ_OK;
}

/* append bytes to output buffer, respecting limit */
static int
buf_append(char *buf, size_t len, int pos, const char *src, int srclen)
{
	if (pos < 0) {
		return pos;
	}
	if ((size_t)(pos + srclen) < len) {
		memcpy(buf + pos, src, srclen);
	}
	return pos + srclen;
}

/* emit a JSON-quoted string */
static int
buf_append_quoted(char *buf, size_t len, int pos, const char *s, int slen)
{
	int i;

	pos = buf_append(buf, len, pos, "\"", 1);
	for (i = 0; i < slen && pos >= 0; i++) {
		char c = s[i];
		switch (c) {
		case '"':
			pos = buf_append(buf, len, pos, "\\\"", 2);
			break;
		case '\\':
			pos = buf_append(buf, len, pos, "\\\\", 2);
			break;
		case '\n':
			pos = buf_append(buf, len, pos, "\\n", 2);
			break;
		case '\r':
			pos = buf_append(buf, len, pos, "\\r", 2);
			break;
		case '\t':
			pos = buf_append(buf, len, pos, "\\t", 2);
			break;
		default:
			if ((unsigned char)c < 0x20) {
				char esc[7];
				snprintf(esc, sizeof(esc), "\\u%04x", (unsigned char)c);
				pos = buf_append(buf, len, pos, esc, 6);
			} else {
				pos = buf_append(buf, len, pos, &c, 1);
			}
		}
	}
	pos = buf_append(buf, len, pos, "\"", 1);
	return pos;
}

OBJ *
obj_new(const char *key)
{
	OBJ *obj = calloc(1, sizeof(*obj));

	if (!obj) {
		LOG_ERROR("failed to allocate object");
		return NULL;
	}
	obj->key = strdup(key);
	if (!obj->key) {
		free(obj);
		return NULL;
	}

	/* synthetic empty object root token */
	obj->tokens = malloc(sizeof(jsmntok_t) * OBJ_JSON_INIT_TOKENS);
	if (!obj->tokens) {
		free(obj->key);
		free(obj);
		return NULL;
	}
	obj->tokens_alloc = OBJ_JSON_INIT_TOKENS;
	obj->tokens_used = 1;
	obj->tokens[0].type = JSMN_OBJECT;
	obj->tokens[0].start = 0;
	obj->tokens[0].end = 0;
	obj->tokens[0].size = 0;

	return obj;
}

OBJ *
obj_new_from_json(const char *key, const char *json)
{
	size_t len = strlen(json);
	size_t alloc = len + 1;
	char *data;
	OBJ *obj;

	data = malloc(alloc);
	if (!data) {
		return NULL;
	}
	memcpy(data, json, alloc);

	obj = calloc(1, sizeof(*obj));
	if (!obj) {
		free(data);
		LOG_ERROR("failed to allocate object");
		return NULL;
	}
	obj->key = strdup(key);
	if (!obj->key) {
		free(data);
		free(obj);
		return NULL;
	}
	obj->json_len = len;
	obj->data_used = alloc;
	obj->data_alloc = alloc;
	obj->data = data;

	if (obj_parse(obj) != OBJ_OK) {
		obj_free(obj);
		return NULL;
	}

	/* trim json_len to the actual JSON extent (root token end),
	 * so trailing whitespace from file I/O is not preserved. */
	if (obj->tokens_used > 0 && obj->tokens[0].end > 0)
		obj->json_len = (size_t)obj->tokens[0].end;

	return obj;
}

void
obj_free(OBJ *obj)
{
	if (!obj) {
		return;
	}
	free(obj->key);
	free(obj->data);
	free(obj->tokens);
	free(obj);
}

char *
obj_prop_get(OBJ *obj, const char *propname)
{
	int key_idx = find_prop(obj, propname);

	if (key_idx < 0)
		return NULL;
	return json_token_tostr(obj->data, &obj->tokens[key_idx + 1]);
}

int
obj_prop_set_internal(OBJ *obj, const char *propname, const char *value)
{
	unsigned val_off, val_len;
	int key_idx;

	val_len = strlen(value);
	val_off = data_append(obj, value, val_len);
	if (val_off == DATA_APPEND_FAIL)
		return OBJ_ERR_NOMEM;

	key_idx = find_prop(obj, propname);
	if (key_idx >= 0) {
		/* update existing property: replace value token in place */
		jsmntok_t *val_tok = &obj->tokens[key_idx + 1];
		int old_span = token_span(val_tok,
			obj->tokens_used - key_idx - 1);

		if (old_span > 1) {
			/* complex value: remove extra tokens */
			int remove_count = old_span - 1;
			int src = key_idx + 1 + old_span;
			int remaining = obj->tokens_used - src;

			memmove(&obj->tokens[key_idx + 2],
				&obj->tokens[src],
				sizeof(jsmntok_t) * remaining);
			obj->tokens_used -= remove_count;
		}

		/* re-seat after possible memmove */
		val_tok = &obj->tokens[key_idx + 1];
		val_tok->type = JSMN_PRIMITIVE;
		val_tok->start = val_off;
		val_tok->end = val_off + val_len;
		val_tok->size = 0;
	} else {
		/* new property: append key and value tokens */
		unsigned key_off, key_len;
		int insert_pos, i;

		key_len = strlen(propname);
		key_off = data_append(obj, propname, key_len);
		if (key_off == DATA_APPEND_FAIL)
			return OBJ_ERR_NOMEM;

		/* find insertion point after all existing pairs */
		insert_pos = 1;
		for (i = 0; i < obj->tokens[0].size; i++) {
			int vs = token_span(&obj->tokens[insert_pos + 1],
				obj->tokens_used - insert_pos - 1);
			insert_pos += 1 + vs;
		}

		if (tokens_grow(obj, 2) != OBJ_OK)
			return OBJ_ERR_NOMEM;

		/* shift trailing tokens (if any) to make room */
		if (insert_pos < (int)obj->tokens_used) {
			memmove(&obj->tokens[insert_pos + 2],
				&obj->tokens[insert_pos],
				sizeof(jsmntok_t) *
					(obj->tokens_used - insert_pos));
		}

		obj->tokens[insert_pos].type = JSMN_STRING;
		obj->tokens[insert_pos].start = key_off;
		obj->tokens[insert_pos].end = key_off + key_len;
		obj->tokens[insert_pos].size = 1;

		obj->tokens[insert_pos + 1].type = JSMN_PRIMITIVE;
		obj->tokens[insert_pos + 1].start = val_off;
		obj->tokens[insert_pos + 1].end = val_off + val_len;
		obj->tokens[insert_pos + 1].size = 0;

		obj->tokens_used += 2;
		obj->tokens[0].size += 1;
	}

	obj->dirty = true;
	return OBJ_OK;
}

/* build "!propname" into out. Returns a heap pointer if propname is long
 * enough that stack_buf can't hold it; NULL on allocation failure. Caller
 * frees the returned pointer only if it differs from stack_buf. */
static char *
tombstone_name(const char *propname, char *stack_buf, size_t stack_len)
{
	size_t n = strlen(propname);

	if (n + 2 <= stack_len) {
		stack_buf[0] = '!';
		memcpy(stack_buf + 1, propname, n + 1);
		return stack_buf;
	}
	char *buf = malloc(n + 2);
	if (!buf)
		return NULL;
	buf[0] = '!';
	memcpy(buf + 1, propname, n + 1);
	return buf;
}

int
obj_prop_set(OBJ *obj, const char *propname, const char *value)
{
	char stack_buf[128];
	char *tomb;
	int rc;

	if (propname && propname[0] == '%')
		return OBJ_ERR_PROTECTED;
	/* Prevent callers from directly manipulating tombstones; they must
	 * use obj_prop_delete/obj_prop_set to drive the mechanism. */
	if (propname && propname[0] == '!')
		return OBJ_ERR_PROTECTED;
	rc = obj_prop_set_internal(obj, propname, value);
	if (rc != OBJ_OK)
		return rc;
	/* Setting a value clears any prior tombstone for this key. */
	tomb = tombstone_name(propname, stack_buf, sizeof(stack_buf));
	if (!tomb)
		return OBJ_ERR_NOMEM;
	obj_prop_delete_internal(obj, tomb);
	if (tomb != stack_buf)
		free(tomb);
	return OBJ_OK;
}

int
obj_prop_set_int(OBJ *obj, const char *propname, int value)
{
	char buf[32];

	snprintf(buf, sizeof(buf), "%d", value);
	return obj_prop_set(obj, propname, buf);
}

int
obj_prop_delete_internal(OBJ *obj, const char *propname)
{
	int key_idx = find_prop(obj, propname);
	int val_span, total, remaining;

	if (key_idx < 0)
		return OBJ_OK;

	val_span = token_span(&obj->tokens[key_idx + 1],
		obj->tokens_used - key_idx - 1);
	total = 1 + val_span; /* key token + value token(s) */
	remaining = obj->tokens_used - key_idx - total;

	if (remaining > 0) {
		memmove(&obj->tokens[key_idx],
			&obj->tokens[key_idx + total],
			sizeof(jsmntok_t) * remaining);
	}
	obj->tokens_used -= total;
	obj->tokens[0].size -= 1;
	obj->dirty = true;
	return OBJ_OK;
}

int
obj_prop_delete(OBJ *obj, const char *propname)
{
	char stack_buf[128];
	char *tomb;
	int rc;

	if (propname && propname[0] == '%')
		return OBJ_ERR_PROTECTED;
	if (propname && propname[0] == '!')
		return OBJ_ERR_PROTECTED;

	/* If this object has no prototype parent, a delete is a plain
	 * delete -- no tombstone needed because nothing would be inherited
	 * anyway. */
	if (find_prop(obj, "%parent") < 0)
		return obj_prop_delete_internal(obj, propname);

	/* Prototype-aware delete: insert a tombstone so prototype-chain
	 * walking stops here, and hard-delete any local value. */
	obj_prop_delete_internal(obj, propname);
	tomb = tombstone_name(propname, stack_buf, sizeof(stack_buf));
	if (!tomb)
		return OBJ_ERR_NOMEM;
	rc = obj_prop_set_internal(obj, tomb, "1");
	if (tomb != stack_buf)
		free(tomb);
	return rc;
}

int
obj_prop_is_tombstoned(OBJ *obj, const char *propname)
{
	char stack_buf[128];
	char *tomb;
	int present;

	if (!propname || propname[0] == '!' || propname[0] == '%')
		return 0;
	tomb = tombstone_name(propname, stack_buf, sizeof(stack_buf));
	if (!tomb)
		return 0;
	present = find_prop(obj, tomb) >= 0;
	if (tomb != stack_buf)
		free(tomb);
	return present;
}

int
obj_get_json(OBJ *obj, char *buf, size_t len)
{
	const jsmntok_t *t;
	int pos, i, tok_pos;

	if (!obj->dirty && obj->data && obj->json_len > 0) {
		/* fast path: no mutations */
		if (obj->json_len >= len) {
			return OBJ_ERR_NOMEM;
		}
		memcpy(buf, obj->data, obj->json_len);
		buf[obj->json_len] = '\0';
		return OBJ_OK;
	}

	if (!obj->tokens || obj->tokens_used == 0) {
		return OBJ_ERR;
	}

	t = obj->tokens;
	if (t->type != JSMN_OBJECT) {
		return OBJ_ERR;
	}

	pos = 0;
	pos = buf_append(buf, len, pos, "{", 1);

	tok_pos = 1;
	for (i = 0; i < t[0].size; i++) {
		const jsmntok_t *key_tok = &obj->tokens[tok_pos];
		const jsmntok_t *val_tok = &obj->tokens[tok_pos + 1];
		int klen = key_tok->end - key_tok->start;
		int val_span_n;

		if (i > 0)
			pos = buf_append(buf, len, pos, ",", 1);

		/* emit key */
		pos = buf_append_quoted(buf, len, pos,
			obj->data + key_tok->start, klen);
		pos = buf_append(buf, len, pos, ":", 1);

		/* emit value */
		val_span_n = token_span(val_tok,
			obj->tokens_used - tok_pos - 1);
		if (val_tok->type == JSMN_STRING) {
			int slen = val_tok->end - val_tok->start;

			pos = buf_append(buf, len, pos, "\"", 1);
			pos = buf_append(buf, len, pos,
				obj->data + val_tok->start, slen);
			pos = buf_append(buf, len, pos, "\"", 1);
		} else {
			/* primitive, object, or array -- emit raw bytes */
			const jsmntok_t *end_tok = val_tok + val_span_n - 1;
			int vlen = end_tok->end - val_tok->start;

			pos = buf_append(buf, len, pos,
				obj->data + val_tok->start, vlen);
		}

		tok_pos += 1 + val_span_n;
	}

	pos = buf_append(buf, len, pos, "}", 1);

	if (pos < 0 || (size_t)pos >= len) {
		return OBJ_ERR_NOMEM;
	}
	buf[pos] = '\0';
	return OBJ_OK;
}

int
obj_compact(OBJ *obj)
{
	char *new_data;
	size_t new_alloc;
	size_t new_len;
	int result;

	if (!obj->dirty) {
		return OBJ_OK;
	}

	/* estimate needed size */
	new_alloc = obj->data_used + 128;

	for (;;) {
		new_data = malloc(new_alloc);
		if (!new_data) {
			return OBJ_ERR_NOMEM;
		}

		result = obj_get_json(obj, new_data, new_alloc);
		if (result == OBJ_OK) {
			break;
		}
		free(new_data);
		if (result != OBJ_ERR_NOMEM) {
			return result;
		}
		new_alloc *= 2;
	}

	/* replace buffer entirely */
	free(obj->data);
	new_len = strlen(new_data);
	obj->json_len = new_len;
	obj->data_used = new_len + 1;
	obj->data_alloc = new_alloc;
	obj->data = new_data;

	/* re-parse */
	result = obj_parse(obj);
	if (result != OBJ_OK) {
		return result;
	}

	obj->dirty = false;
	return OBJ_OK;
}

/****************************************************************
 * Property iteration
 ****************************************************************/

struct obj_iter {
	OBJ *obj;
	int pair_idx;		/* 0..root.size-1 */
	int token_pos;		/* token index of current key */
};

OBJ_ITER *
obj_iter_begin(OBJ *obj)
{
	OBJ_ITER *it;

	if (!obj)
		return NULL;
	it = calloc(1, sizeof(*it));
	if (!it)
		return NULL;
	it->obj = obj;
	it->pair_idx = 0;
	it->token_pos = 1;
	return it;
}

int
obj_iter_next(OBJ_ITER *it, const char **key, const char **value)
{
	OBJ *obj = it->obj;
	const jsmntok_t *t;
	const jsmntok_t *key_tok, *val_tok;
	int val_span_n;

	if (!obj->tokens || obj->tokens_used == 0)
		return 0;
	t = obj->tokens;
	if (t->type != JSMN_OBJECT)
		return 0;
	if (it->pair_idx >= t[0].size)
		return 0;

	key_tok = &obj->tokens[it->token_pos];
	val_tok = &obj->tokens[it->token_pos + 1];

	*key = json_token_tostr(obj->data, key_tok);
	*value = json_token_tostr(obj->data, val_tok);

	/* advance past this key-value pair */
	val_span_n = token_span(val_tok, obj->tokens_used - it->token_pos - 1);
	it->token_pos += 1 + val_span_n;
	it->pair_idx++;

	return 1;
}

void
obj_iter_end(OBJ_ITER *it)
{
	free(it);
}

/****************************************************************
 * Debug
 ****************************************************************/

/* debug dump -- walks tokens */
static int
jsmn_dump(const char *json, const jsmntok_t *t, unsigned count,
	void (*output_str)(const char *s))
{
	char scratch[512];
	int i, j;

	if (!count) {
		return 0;
	}

	switch (t->type) {
	case JSMN_PRIMITIVE:
		snprintf(scratch, sizeof(scratch), "%.*s",
			t->end - t->start, json + t->start);
		output_str(scratch);
		return 1;

	case JSMN_STRING:
		snprintf(scratch, sizeof(scratch), "'%.*s'",
			t->end - t->start, json + t->start);
		output_str(scratch);
		return 1;

	case JSMN_OBJECT:
		output_str("{");
		j = 0;
		for (i = 0; i < t->size; i++) {
			const jsmntok_t *next = t + 1 + j;

			j += jsmn_dump(json, next, count - j, output_str);
			if (next->size > 0) {
				output_str(": ");
				next = t + 1 + j;
				j += jsmn_dump(json, next, count - j,
					output_str);
			}
			if (i + 1 < t->size) {
				output_str(", ");
			}
		}
		output_str("}");
		return j + 1;

	case JSMN_ARRAY:
		output_str("[");
		j = 0;
		for (i = 0; i < t->size; i++) {
			if (i > 0) {
				output_str(", ");
			}
			j += jsmn_dump(json, t + 1 + j, count - j, output_str);
		}
		output_str("]");
		return j + 1;

	default:
		return 0;
	}

	return 0;
}

void
obj_debug_dump(OBJ *obj, void (*output_str)(const char *s))
{
	LOG_INFO("// Object [%.64s] :", obj->key);
	if (obj->tokens && obj->tokens_used > 0) {
		jsmn_dump(obj->data, obj->tokens, obj->tokens_used, output_str);
	}
}
