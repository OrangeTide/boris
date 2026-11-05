/* olc.c : shared building blocks for the OLC editors (doc/olc-spec.md 3.1) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#include "olc.h"
#include <boris.h>
#include "telnetclient.h"
#include "builder.h"
#include "objref.h"

#include <stdio.h>

void
olc_copy_props(OBJ *dst, OBJ *src)
{
	OBJ_ITER *it = obj_iter_begin(src);
	const char *k, *v;

	while (obj_iter_next(it, &k, &v)) {
		/* %-keys and reference keys (marked with '~') are rejected by the
		 * public setter, so copy them raw through the internal setter. */
		if (k[0] == '%' || obj_prop_is_ref(k))
			obj_prop_set_internal(dst, k, v);
		else
			obj_prop_set(dst, k, v);
	}
	obj_iter_end(it);
}

char *
olc_field_get(OBJ *o, const char *key)
{
	return objref_is_ref_name(key) ? obj_prop_get_ref(o, key)
		: obj_prop_get(o, key);
}

int
olc_field_set(OBJ *o, const char *key, const char *value)
{
	if (objref_is_ref_name(key))
		return (key[0] == '%') ? obj_prop_set_ref_internal(o, key, value)
			: obj_prop_set_ref(o, key, value);
	return (key[0] == '%') ? obj_prop_set_internal(o, key, value)
		: obj_prop_set(o, key, value);
}

OBJ *
olc_make_scratch(DESCRIPTOR_DATA *cl, const char *key, int is_create)
{
	OBJ *scratch = obj_new(key);
	OBJ *live;

	if (!scratch) {
		telnetclient_puts(cl, "Out of memory.\n");
		return NULL;
	}
	if (is_create) {
		if ((live = obj_get(key))) {	/* refuse to clobber */
			obj_release(live);
			obj_free(scratch);
			telnetclient_printf(cl, "%s already exists.\n", key);
			return NULL;
		}
		return scratch;
	}
	live = obj_get(key);
	if (!live) {
		obj_free(scratch);
		telnetclient_printf(cl, "No object \"%s\".\n", key);
		return NULL;
	}
	olc_copy_props(scratch, live);
	obj_release(live);
	return scratch;
}

int
olc_submit(DESCRIPTOR_DATA *cl, const struct builder_ops *ops,
	struct builder_req *req)
{
	struct builder_result res;
	int i;

	if (builder_save(ops, req, &res) != BUILDER_OK) {
		telnetclient_printf(cl, "Could not save: %s\n", res.message);
		return -1;			/* stay open, edits intact */
	}
	telnetclient_printf(cl, "Saved %s.\n", req->commit_key);
	for (i = 0; i < res.warn_count; i++)
		telnetclient_printf(cl, "  warning: %s\n", res.warns[i]);
	return 0;				/* accept -> pop -> on_close */
}
