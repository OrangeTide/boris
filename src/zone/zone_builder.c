/* zone_builder.c : zone creation on top of the core zone model */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "zone"

#include "zone_builder.h"

#include <stdio.h>

enum builder_status
zone_create(const struct builder_ops *ops, const struct acs_info *actor,
	const char *actor_name, const char *zone_path, const char *title,
	const char *template_ref, const char *parent_path,
	struct builder_result *res)
{
	static const char *const zone_required[] = { "title", NULL };
	char key[OBJ_PATH_MAX];
	char parent_key[OBJ_PATH_MAX];
	struct builder_req req;
	enum builder_status st;
	OBJ *zi;

	if (!res)
		return BUILDER_ERR;
	res->status = BUILDER_OK;
	res->message[0] = '\0';
	res->warn_count = 0;

	if (zone_info_key(zone_path, key, sizeof key) != 0) {
		snprintf(res->message, sizeof res->message,
			"invalid zone path: %s", zone_path ? zone_path : "(null)");
		return res->status = BUILDER_ERR;
	}

	zi = obj_new(key);
	if (!zi) {
		snprintf(res->message, sizeof res->message, "out of memory");
		return res->status = BUILDER_ERR;
	}

	obj_prop_set_internal(zi, "%kind", "zone");
	if (parent_path && parent_path[0]) {
		if (zone_info_key(parent_path, parent_key, sizeof parent_key) != 0) {
			obj_free(zi);
			snprintf(res->message, sizeof res->message,
				"invalid parent zone: %s", parent_path);
			return res->status = BUILDER_ERR;
		}
		obj_prop_set_ref_internal(zi, "%parent", parent_key);
	}
	if (title && title[0])
		obj_prop_set(zi, "title", title);
	if (template_ref && template_ref[0])
		obj_prop_set_ref(zi, "template", template_ref);

	req = (struct builder_req){
		.actor = actor,
		.actor_name = actor_name,
		.commit_key = key,
		.obj = zi,
		.required = zone_required,
		.is_create = 1,
		.overwrite = 0,
	};
	st = builder_save(ops, &req, res);

	obj_free(zi);
	return st;
}
