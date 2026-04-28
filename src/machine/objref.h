/* objref.h : domain-qualified object reference parsing and path resolution */
#ifndef OBJREF_H
#define OBJREF_H

#include <stddef.h>

struct objref {
	char domain[32];
	char key[256];
};

int objref_parse(const char *value, const char *default_domain,
                 struct objref *out);

int objref_resolve_path(const char *base_key, const char *rel,
                        char *out, size_t out_size);

#endif
