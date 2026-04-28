#define LOG_SUBSYSTEM "objref"
#include <log.h>

#include "objref.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

static int
is_domain_start(int ch)
{
	return isalpha(ch) || ch == '_' || ch == '-';
}

static int
is_domain_char(int ch)
{
	return isalnum(ch) || ch == '_' || ch == '-';
}

int
objref_parse(const char *value, const char *default_domain,
             struct objref *out)
{
	const char *colon;
	size_t dlen;

	if (!value || !out)
		return -1;

	memset(out, 0, sizeof(*out));

	colon = NULL;
	if (is_domain_start(value[0])) {
		const char *p;
		for (p = value + 1; *p && is_domain_char(*p); p++)
			;
		if (*p == ':')
			colon = p;
	}

	if (colon) {
		dlen = (size_t)(colon - value);
		if (dlen >= sizeof(out->domain))
			return -1;
		memcpy(out->domain, value, dlen);
		out->domain[dlen] = '\0';
		snprintf(out->key, sizeof(out->key), "%s", colon + 1);
	} else {
		if (default_domain)
			snprintf(out->domain, sizeof(out->domain), "%s",
			         default_domain);
		snprintf(out->key, sizeof(out->key), "%s", value);
	}

	return 0;
}

int
objref_resolve_path(const char *base_key, const char *rel,
                    char *out, size_t out_size)
{
	char buf[512];
	char *p, *w;
	const char *last_slash;
	size_t base_dir_len;

	if (!rel || !out || out_size == 0)
		return -1;

	if (rel[0] == '/' || !base_key || base_key[0] == '\0') {
		/* absolute path or no base -- strip leading slash */
		const char *start = rel;
		while (*start == '/')
			start++;
		snprintf(buf, sizeof(buf), "%s", start);
	} else {
		/* relative: combine base directory with rel */
		last_slash = strrchr(base_key, '/');
		if (last_slash) {
			base_dir_len = (size_t)(last_slash - base_key);
			snprintf(buf, sizeof(buf), "%.*s/%s",
			         (int)base_dir_len, base_key, rel);
		} else {
			/* base has no directory component */
			snprintf(buf, sizeof(buf), "%s", rel);
		}
	}

	/* normalize: resolve "../" components in place */
	p = buf;
	w = buf;
	while (*p) {
		if (p[0] == '.' && p[1] == '.' && (p[2] == '/' || p[2] == '\0')) {
			/* back up w to previous slash */
			if (w > buf) {
				w--;
				while (w > buf && w[-1] != '/')
					w--;
			}
			p += (p[2] == '/') ? 3 : 2;
		} else if (p[0] == '.' && (p[1] == '/' || p[1] == '\0')) {
			p += (p[1] == '/') ? 2 : 1;
		} else {
			/* copy this path component */
			while (*p && *p != '/') {
				if ((size_t)(w - buf) < sizeof(buf) - 1)
					*w++ = *p;
				p++;
			}
			if (*p == '/') {
				if ((size_t)(w - buf) < sizeof(buf) - 1)
					*w++ = '/';
				p++;
			}
		}
	}

	/* trim trailing slash */
	if (w > buf && w[-1] == '/')
		w--;
	*w = '\0';

	if ((size_t)(w - buf) >= out_size)
		return -1;

	memcpy(out, buf, (size_t)(w - buf) + 1);
	return 0;
}
