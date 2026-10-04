/* olc.h : shared building blocks for the OLC editors (@redit, @medit, ...) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */
#ifndef OLC_H_
#define OLC_H_

#include <stddef.h>
#include "obj.h"

struct descriptor_data;
struct builder_ops;
struct builder_req;

/*
 * Copy every property of src onto dst, %-prefixed keys through the internal
 * (protection-bypassing) setter. Used to seed an edit scratch from a live
 * object.
 */
void olc_copy_props(OBJ *dst, OBJ *src);

/*
 * Build the editing scratch OBJ for key. On create it refuses when the key
 * already exists; on edit it seeds a detached copy of the live object. On any
 * error the client is messaged and NULL is returned. The caller owns the
 * returned OBJ (obj_free) and, on create, stamps %kind / %parent.
 */
OBJ *olc_make_scratch(struct descriptor_data *cl, const char *key,
	int is_create);

/*
 * Commit req through builder_save(ops): on success print "Saved <key>" plus
 * any soft warnings and return 0 (the editor pops); on a hard block print the
 * reason and return -1 (the editor stays open with edits intact).
 */
int olc_submit(struct descriptor_data *cl, const struct builder_ops *ops,
	struct builder_req *req);

#endif
