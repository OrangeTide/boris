/**
 * @file tag.c
 */

#include "tag.h"
#include "boris.h"
#include "character.h"

#include <stdlib.h>
#include <string.h>
#include <strings.h>

int
rpg_tag_parse(const char *s, int *value, int *mode, const char **affects_out)
{
	const char *p;
	char *end;
	long v;

	if (!s || !value || !mode) return 0;

	*mode = RPG_TAG_MODE_POSITION;
	if (affects_out) *affects_out = NULL;

	v = strtol(s, &end, 10);
	if (end == s) return 0;
	if (v < -3) v = -3;
	if (v > 3) v = 3;
	*value = (int)v;

	if (*end != ':') return 1;
	p = end + 1;

	switch (*p) {
	case 'p': case 'P': *mode = RPG_TAG_MODE_POSITION; break;
	case 'd': case 'D': *mode = RPG_TAG_MODE_DIFFICULTY; break;
	default: return 0;
	}
	p++;

	if (*p != ':') return 1;
	p++;

	if (*p == '\0' || !strcmp(p, "*")) {
		if (affects_out) *affects_out = NULL;
	} else {
		if (affects_out) *affects_out = p;
	}
	return 1;
}

int
rpg_tag_affects(const char *affects_csv, enum rpg_action a)
{
	const char *name;
	size_t nlen;
	const char *p;

	if (!affects_csv) return 1;
	name = rpg_action_name(a);
	nlen = strlen(name);

	p = affects_csv;
	while (*p) {
		const char *comma = strchr(p, ',');
		size_t seglen = comma ? (size_t)(comma - p) : strlen(p);
		if (seglen == 1 && p[0] == '*') return 1;
		if (seglen == nlen && !strncasecmp(p, name, nlen)) return 1;
		if (!comma) break;
		p = comma + 1;
	}
	return 0;
}

/** fold tags from one attr_list into running sums. */
static void
apply_list(struct attr_list *al, enum rpg_action action,
	int *sum_pos, int *sum_diff)
{
	struct attr_entry *curr;

	if (!al) return;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		int value, mode;
		const char *affects;

		if (strncmp(curr->name, RPG_TAG_PREFIX, RPG_TAG_PREFIX_LEN))
			continue;
		if (!rpg_tag_parse(curr->value, &value, &mode, &affects))
			continue;
		if (!rpg_tag_affects(affects, action))
			continue;

		if (mode == RPG_TAG_MODE_POSITION)
			*sum_pos += value;
		else
			*sum_diff += value;
	}
}

static void
apply_obj(OBJ *obj, enum rpg_action action,
	int *sum_pos, int *sum_diff)
{
	OBJ_ITER *it;
	const char *key, *val;
	int value, mode;
	const char *affects;

	if (!obj) return;

	it = obj_iter_begin(obj);
	if (!it) return;

	while (obj_iter_next(it, &key, &val)) {
		if (strncmp(key, RPG_TAG_PREFIX, RPG_TAG_PREFIX_LEN))
			continue;
		if (!rpg_tag_parse(val, &value, &mode, &affects))
			continue;
		if (!rpg_tag_affects(affects, action))
			continue;

		if (mode == RPG_TAG_MODE_POSITION)
			*sum_pos += value;
		else
			*sum_diff += value;
	}

	obj_iter_end(it);
}

void
rpg_tags_apply(struct character *actor, OBJ *room,
	enum rpg_action action,
	enum rpg_position *pos, int *difficulty)
{
	int sum_pos = 0, sum_diff = 0;
	int d;

	apply_list(character_attrs_extras(actor), action, &sum_pos, &sum_diff);
	apply_obj(room, action, &sum_pos, &sum_diff);

	if (pos)
		*pos = rpg_position_shift(*pos, sum_pos);

	if (difficulty) {
		d = *difficulty - sum_diff;
		if (d < 1) d = 1;
		if (d > 5) d = 5;
		*difficulty = d;
	}
}
