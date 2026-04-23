#include "charset.h"

#define LOG_SUBSYSTEM "charset"
#include "log.h"

#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHARSET_CACHE_MAX 16
#define HIGH_TABLE_SIZE 128 /* 0x80..0xFF */

struct reverse_entry {
	uint32_t codepoint;
	uint8_t byte;
};

struct charset {
	char name[32];
	uint32_t to_unicode[HIGH_TABLE_SIZE];
	struct reverse_entry from_unicode[HIGH_TABLE_SIZE];
	int from_unicode_count;
};

static struct charset *cache[CHARSET_CACHE_MAX];
static int cache_count;

static int
reverse_cmp(const void *a, const void *b)
{
	const struct reverse_entry *ea = a;
	const struct reverse_entry *eb = b;

	if (ea->codepoint < eb->codepoint) return -1;
	if (ea->codepoint > eb->codepoint) return 1;
	return 0;
}

static int
normalize_name(const char *name, char *out, size_t out_size)
{
	size_t j = 0;

	for (size_t i = 0; name[i] && j < out_size - 1; i++) {
		char c = name[i];
		if (c == '-' || c == '_')
			continue;
		out[j++] = toupper((unsigned char)c);
	}
	out[j] = '\0';
	return j > 0;
}

static const char *
find_mapping_file(const char *name, char *path, size_t path_size)
{
	/* map user-facing names to filenames */
	static const struct {
		const char *alias;
		const char *filename;
	} name_map[] = {
		{ "CP437",     "CP437.TXT" },
		{ "CP737",     "CP737.TXT" },
		{ "CP850",     "CP850.TXT" },
		{ "CP860",     "CP860.TXT" },
		{ "CP863",     "CP863.TXT" },
		{ "CP1250",    "CP1250.TXT" },
		{ "CP1252",    "CP1252.TXT" },
		{ "WINDOWS1252", "CP1252.TXT" },
		{ "LATIN1",    "8859-1.TXT" },
		{ "ISO88591",  "8859-1.TXT" },
		{ "88591",     "8859-1.TXT" },
		{ "LATIN6",    "8859-10.TXT" },
		{ "ISO885910", "8859-10.TXT" },
		{ "885910",    "8859-10.TXT" },
		{ "KOI8R",     "KOI8-R.TXT" },
		{ "KOI8U",     "KOI8-U.TXT" },
	};

	char norm[32];
	if (!normalize_name(name, norm, sizeof(norm)))
		return NULL;

	for (size_t i = 0; i < sizeof(name_map) / sizeof(name_map[0]); i++) {
		if (!strcmp(norm, name_map[i].alias)) {
			snprintf(path, path_size, "data/unicode/%s",
				 name_map[i].filename);
			return path;
		}
	}

	return NULL;
}

static struct charset *
charset_parse(const char *name, const char *path)
{
	FILE *f = fopen(path, "r");
	if (!f) {
		LOG_ERROR("cannot open charset file: %s", path);
		return NULL;
	}

	struct charset *cs = calloc(1, sizeof(*cs));
	if (!cs) {
		fclose(f);
		return NULL;
	}

	char norm[32];
	normalize_name(name, norm, sizeof(norm));
	snprintf(cs->name, sizeof(cs->name), "%s", norm);

	char line[256];
	while (fgets(line, sizeof(line), f)) {
		if (line[0] == '#' || line[0] == '\n')
			continue;

		unsigned int legacy_byte, unicode_cp;
		int n = sscanf(line, "0x%x 0x%x", &legacy_byte, &unicode_cp);
		if (n < 1 || legacy_byte > 0xFF)
			continue;
		if (legacy_byte < 0x80)
			continue;
		if (n < 2)
			continue; /* UNDEFINED entry */

		unsigned int idx = legacy_byte - 0x80;
		cs->to_unicode[idx] = unicode_cp;

		if (cs->from_unicode_count < HIGH_TABLE_SIZE) {
			struct reverse_entry *re =
				&cs->from_unicode[cs->from_unicode_count++];
			re->codepoint = unicode_cp;
			re->byte = (uint8_t)legacy_byte;
		}
	}

	fclose(f);

	qsort(cs->from_unicode, cs->from_unicode_count,
	      sizeof(cs->from_unicode[0]), reverse_cmp);

	return cs;
}

static int
reverse_lookup(const struct charset *cs, uint32_t codepoint, uint8_t *out)
{
	int lo = 0, hi = cs->from_unicode_count - 1;

	while (lo <= hi) {
		int mid = lo + (hi - lo) / 2;
		uint32_t cp = cs->from_unicode[mid].codepoint;
		if (cp == codepoint) {
			*out = cs->from_unicode[mid].byte;
			return 1;
		}
		if (cp < codepoint)
			lo = mid + 1;
		else
			hi = mid - 1;
	}

	return 0;
}

static int
utf8_encode(uint32_t cp, char *out, size_t out_size)
{
	if (cp < 0x80) {
		if (out_size < 1) return 0;
		out[0] = (char)cp;
		return 1;
	}
	if (cp < 0x800) {
		if (out_size < 2) return 0;
		out[0] = (char)(0xC0 | (cp >> 6));
		out[1] = (char)(0x80 | (cp & 0x3F));
		return 2;
	}
	if (cp < 0x10000) {
		if (out_size < 3) return 0;
		out[0] = (char)(0xE0 | (cp >> 12));
		out[1] = (char)(0x80 | ((cp >> 6) & 0x3F));
		out[2] = (char)(0x80 | (cp & 0x3F));
		return 3;
	}
	if (cp < 0x110000) {
		if (out_size < 4) return 0;
		out[0] = (char)(0xF0 | (cp >> 18));
		out[1] = (char)(0x80 | ((cp >> 12) & 0x3F));
		out[2] = (char)(0x80 | ((cp >> 6) & 0x3F));
		out[3] = (char)(0x80 | (cp & 0x3F));
		return 4;
	}
	return 0;
}

static int
utf8_decode(const char *s, size_t len, uint32_t *cp, size_t *consumed)
{
	unsigned char c = (unsigned char)s[0];

	if (c < 0x80) {
		*cp = c;
		*consumed = 1;
		return 1;
	}

	size_t seqlen;
	uint32_t val;

	if ((c & 0xE0) == 0xC0) {
		seqlen = 2;
		val = c & 0x1F;
	} else if ((c & 0xF0) == 0xE0) {
		seqlen = 3;
		val = c & 0x0F;
	} else if ((c & 0xF8) == 0xF0) {
		seqlen = 4;
		val = c & 0x07;
	} else {
		*cp = '?';
		*consumed = 1;
		return 0;
	}

	if (seqlen > len) {
		*cp = '?';
		*consumed = 1;
		return 0;
	}

	for (size_t i = 1; i < seqlen; i++) {
		unsigned char cont = (unsigned char)s[i];
		if ((cont & 0xC0) != 0x80) {
			*cp = '?';
			*consumed = i;
			return 0;
		}
		val = (val << 6) | (cont & 0x3F);
	}

	*cp = val;
	*consumed = seqlen;
	return 1;
}

struct charset *
charset_load(const char *name)
{
	if (!name || !*name)
		return NULL;

	char norm[32];
	if (!normalize_name(name, norm, sizeof(norm)))
		return NULL;

	for (int i = 0; i < cache_count; i++) {
		if (!strcmp(cache[i]->name, norm))
			return cache[i];
	}

	char path[256];
	if (!find_mapping_file(name, path, sizeof(path))) {
		LOG_ERROR("unknown charset: %s", name);
		return NULL;
	}

	struct charset *cs = charset_parse(name, path);
	if (!cs)
		return NULL;

	if (cache_count < CHARSET_CACHE_MAX) {
		cache[cache_count++] = cs;
	}

	LOG_INFO("loaded charset %s from %s (%d mappings)",
		 cs->name, path, cs->from_unicode_count);

	return cs;
}

void
charset_free(struct charset *cs)
{
	if (!cs)
		return;

	for (int i = 0; i < cache_count; i++) {
		if (cache[i] == cs) {
			cache[i] = cache[--cache_count];
			break;
		}
	}

	free(cs);
}

const char *
charset_name(const struct charset *cs)
{
	return cs ? cs->name : "UTF8";
}

int
charset_from_utf8(const struct charset *cs,
		  const char *utf8, size_t utf8_len,
		  char *out, size_t out_size)
{
	assert(cs != NULL);

	size_t in_pos = 0;
	size_t out_pos = 0;

	while (in_pos < utf8_len && out_pos < out_size - 1) {
		unsigned char c = (unsigned char)utf8[in_pos];

		/* ASCII passthrough */
		if (c < 0x80) {
			out[out_pos++] = utf8[in_pos++];
			continue;
		}

		uint32_t cp;
		size_t consumed;
		utf8_decode(utf8 + in_pos, utf8_len - in_pos, &cp, &consumed);

		uint8_t legacy;
		if (reverse_lookup(cs, cp, &legacy)) {
			out[out_pos++] = (char)legacy;
		} else {
			out[out_pos++] = '?';
		}
		in_pos += consumed;
	}

	out[out_pos] = '\0';
	return (int)out_pos;
}

int
charset_to_utf8(const struct charset *cs,
		const char *legacy, size_t legacy_len,
		char *out, size_t out_size)
{
	assert(cs != NULL);

	size_t in_pos = 0;
	size_t out_pos = 0;

	while (in_pos < legacy_len && out_pos < out_size - 4) {
		unsigned char c = (unsigned char)legacy[in_pos++];

		/* ASCII passthrough */
		if (c < 0x80) {
			out[out_pos++] = (char)c;
			continue;
		}

		uint32_t cp = cs->to_unicode[c - 0x80];
		if (cp == 0) {
			out[out_pos++] = '?';
			continue;
		}

		int n = utf8_encode(cp, out + out_pos, out_size - out_pos);
		if (n == 0)
			break;
		out_pos += n;
	}

	out[out_pos] = '\0';
	return (int)out_pos;
}

void
charset_shutdown(void)
{
	while (cache_count > 0)
		charset_free(cache[0]);
}
