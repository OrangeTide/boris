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

#endif
