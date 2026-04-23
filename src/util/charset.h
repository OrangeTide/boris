#ifndef CHARSET_H_
#define CHARSET_H_

#include <stddef.h>
#include <stdint.h>

struct charset;

struct charset *charset_load(const char *name);
void charset_free(struct charset *cs);
const char *charset_name(const struct charset *cs);

int charset_from_utf8(const struct charset *cs,
		      const char *utf8, size_t utf8_len,
		      char *out, size_t out_size);

int charset_to_utf8(const struct charset *cs,
		    const char *legacy, size_t legacy_len,
		    char *out, size_t out_size);

void charset_shutdown(void);

#endif
