#include "objref.h"
#include "obj.h"

#include <stddef.h>
#include <stdlib.h>
#include <string.h>

int
objref_is_ref_name(const char *name)
{
	size_t n;

	if (!name)
		return 0;
	if (!strcmp(name, "%parent") || !strcmp(name, "%location")
		|| !strcmp(name, "template"))
		return 1;
	/* exit.<dir>.to : flat dotted exit destination, dir non-empty */
	n = strlen(name);
	if (n >= 9 && !strncmp(name, "exit.", 5)
		&& !strcmp(name + n - 3, ".to"))
		return 1;
	return 0;
}

/* A reference value is inside the subtree when it equals prefix or begins with
 * "prefix/", so "zone/world" matches "zone/world" and "zone/world/hall" but
 * not "zone/world2/x". */
static int
value_in_subtree(const char *value, const char *prefix, size_t plen)
{
	if (strncmp(value, prefix, plen) != 0)
		return 0;
	return value[plen] == '\0' || value[plen] == '/';
}

/* one pending rewrite: a logical reference name (no marker) and its new value */
struct ref_rewrite {
	char name[OBJ_PATH_MAX];
	char value[OBJ_PATH_MAX];
};

int
objref_rewrite_prefix(struct obj *obj, const char *src_prefix,
	const char *dst_prefix)
{
	OBJ_ITER *it;
	const char *key, *val;
	size_t slen, dlen;
	struct ref_rewrite *todo = NULL;
	size_t n = 0, cap = 0, i;
	int rc = 0;

	if (!obj || !src_prefix || !dst_prefix)
		return 0;
	slen = strlen(src_prefix);
	dlen = strlen(dst_prefix);

	it = obj_iter_begin(obj);
	if (!it)
		return 0;

	/* Collect every in-subtree reference first: applying a set mutates the
	 * object buffer and invalidates the borrowed iteration pointers. */
	while (obj_iter_next(it, &key, &val)) {
		size_t klen, suffixlen;

		if (!obj_prop_is_ref(key) || !val)
			continue;
		if (!value_in_subtree(val, src_prefix, slen))
			continue;

		klen = strlen(key);		/* includes the trailing marker */
		suffixlen = strlen(val) - slen;	/* bytes after src_prefix */
		if (klen < 2 || klen - 1 >= OBJ_PATH_MAX
			|| dlen + suffixlen >= OBJ_PATH_MAX) {
			rc = -1;		/* name or value would not fit */
			break;
		}

		if (n == cap) {
			size_t ncap = cap ? cap * 2 : 8;
			struct ref_rewrite *nt = realloc(todo,
				ncap * sizeof(*nt));

			if (!nt) {
				rc = -1;
				break;
			}
			todo = nt;
			cap = ncap;
		}

		memcpy(todo[n].name, key, klen - 1);	/* drop the marker */
		todo[n].name[klen - 1] = '\0';
		memcpy(todo[n].value, dst_prefix, dlen);
		memcpy(todo[n].value + dlen, val + slen, suffixlen + 1);
		n++;
	}
	obj_iter_end(it);

	if (rc == 0) {
		for (i = 0; i < n; i++)
			if (obj_prop_set_ref_internal(obj, todo[i].name,
				todo[i].value) == OBJ_OK)
				rc++;
	}

	free(todo);
	return rc;
}
