/* zone.c : the light zone grouping model, core (doc/zone-spec.md) */
/* PUBLIC DOMAIN (CC0-1.0) or MIT-0 -- See LICENSE for details. */

#define LOG_SUBSYSTEM "zone"

#include "zone.h"

#include <log.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* True if key is under the instance base ("zone/..."). */
static int
under_base(const char *key)
{
	size_t n = strlen(ZONE_BASE);
	return strncmp(key, ZONE_BASE "/", n + 1) == 0;
}

int
zone_info_key(const char *zone_path, char *buf, size_t len)
{
	if (!zone_path || !under_base(zone_path))
		return -1;
	if ((size_t)snprintf(buf, len, "%s/%s", zone_path, ZONE_INFO_LEAF) >= len)
		return -1;
	return 0;
}

int
zone_exists(const char *zone_path)
{
	OBJ *z = zone_get(zone_path);

	if (z) {
		obj_release(z);
		return 1;
	}
	return 0;
}

OBJ *
zone_get(const char *zone_path)
{
	char key[OBJ_PATH_MAX];

	if (zone_info_key(zone_path, key, sizeof key) != 0)
		return NULL;
	return obj_get(key);
}

int
zone_resolve(const char *object_key, char *buf, size_t len)
{
	char work[OBJ_PATH_MAX];
	char *slash;

	if (!object_key || !under_base(object_key))
		return -1;
	if ((size_t)snprintf(work, sizeof work, "%s", object_key) >= sizeof work)
		return -1;

	/* Walk ancestors from the object's own directory upward. The first
	 * (nearest) ancestor that is at least "zone/<slug>" and carries a
	 * zoneinfo is the owning zone. */
	while ((slash = strrchr(work, '/')) != NULL) {
		*slash = '\0';
		if (strchr(work, '/') == NULL)
			break;			/* only ZONE_BASE left, no slug */
		if (zone_exists(work)) {
			if ((size_t)snprintf(buf, len, "%s", work) >= len)
				return -1;
			return 0;
		}
	}
	return -1;
}

char *
zone_resolve_prop(const char *zone_path, const char *propname)
{
	char key[OBJ_PATH_MAX];

	if (zone_info_key(zone_path, key, sizeof key) != 0)
		return NULL;
	return obj_resolve_prop(key, propname);
}

char *
zone_template(const char *zone_path)
{
	return zone_resolve_prop(zone_path, "template");
}

/* Read a property from the zone's own zoneinfo, not inherited. strdup'd. */
static char *
zone_own_prop(const char *zone_path, const char *propname)
{
	OBJ *z = zone_get(zone_path);
	char *v, *dup;

	if (!z)
		return NULL;
	v = obj_prop_get(z, propname);
	dup = v ? strdup(v) : NULL;
	obj_release(z);
	return dup;
}

/* Whitespace-separated membership test. */
static int
name_in_list(const char *list, const char *name)
{
	size_t namelen = strlen(name);
	const char *p = list;

	while (*p) {
		size_t tok;

		while (*p == ' ' || *p == '\t' || *p == ',')
			p++;
		tok = strcspn(p, " \t,");
		if (tok == namelen && strncmp(p, name, namelen) == 0)
			return 1;
		p += tok;
	}
	return 0;
}

int
zone_may_edit(const char *zone_path, const char *username)
{
	char *list = zone_own_prop(zone_path, "builders");
	int ok;

	if (!list || !list[0]) {
		free(list);
		return 1;			/* open by default */
	}
	ok = username ? name_in_list(list, username) : 0;
	free(list);
	return ok;
}
