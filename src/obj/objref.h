#ifndef OBJREF_H_
#define OBJREF_H_

/*
 * Reference-name schema.
 *
 * The '~' marker mechanics in obj.c are schema-neutral: obj.c only knows that a
 * key ending in the marker is a reference. This file holds boris's policy of
 * which logical property names hold object references, shared by the OLC editor
 * choke points and the store migration so they cannot disagree about what to
 * mark. See doc/snapshot-restore-spec.md section 5.1.
 *
 * The names are given WITHOUT the marker. Exits are flat dotted keys
 * ("exit.<dir>.to") after the nested-to-flat normalization.
 */

/* True if `name` (an unmarked logical key) names an object reference:
 * "%parent", "%location", "template", or "exit.<dir>.to". */
int objref_is_ref_name(const char *name);

struct obj;

/*
 * Rewrite every reference in obj whose value falls inside the subtree rooted at
 * src_prefix, moving it to dst_prefix (doc/snapshot-restore-spec.md section 5).
 * A reference value is "inside" when it equals src_prefix or begins with
 * "src_prefix/"; its prefix is then replaced with dst_prefix. References
 * pointing outside the subtree (a template, another zone) and all non-reference
 * properties are left untouched: the pass acts on '~'-marked keys only, never
 * on string content. This is the rewrite the copy primitive applies when a
 * subtree is copied to a different prefix (checkout and publish).
 *
 * Returns the number of references rewritten (>= 0), or -1 on an allocation
 * failure or if a rewritten value would exceed OBJ_PATH_MAX (the object is then
 * left unchanged so the caller can refuse the copy).
 */
int objref_rewrite_prefix(struct obj *obj, const char *src_prefix,
	const char *dst_prefix);

#endif
