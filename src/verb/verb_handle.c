/* verb_handle.c : per-task object-handle table (ARC over the obj cache) */

#include "verb_handle.h"
#include "obj.h"

#include <stddef.h>

void
verb_handle_set_self(struct verb_handles *h, struct obj *self)
{
	if (!h)
		return;
	h->slot[VERB_HANDLE_SELF].ref = self;
	h->slot[VERB_HANDLE_SELF].owned = 0;    /* borrowed: owner releases it */
}

unsigned
verb_handle_add(struct verb_handles *h, struct obj *obj)
{
	unsigned i;

	if (!h || !obj)
		return VERB_HANDLE_NONE;
	/* slots 0 (none) and 1 (self) are reserved; dynamic handles start at 2 */
	for (i = VERB_HANDLE_SELF + 1; i < VERB_HANDLE_MAX; i++) {
		if (!h->slot[i].ref) {
			h->slot[i].ref = obj;
			h->slot[i].owned = 1;
			return i;
		}
	}
	return VERB_HANDLE_NONE;                 /* table full */
}

struct obj *
verb_handle_get(struct verb_handles *h, unsigned handle)
{
	if (!h || handle == VERB_HANDLE_NONE || handle >= VERB_HANDLE_MAX)
		return NULL;
	return h->slot[handle].ref;
}

void
verb_handle_close(struct verb_handles *h, unsigned handle)
{
	/* self and the none handle are not closable; only dynamic handles are */
	if (!h || handle <= VERB_HANDLE_SELF || handle >= VERB_HANDLE_MAX)
		return;
	if (h->slot[handle].ref) {
		if (h->slot[handle].owned)
			obj_release(h->slot[handle].ref);
		h->slot[handle].ref = NULL;
		h->slot[handle].owned = 0;
	}
}

void
verb_handle_clear(struct verb_handles *h)
{
	unsigned i;

	if (!h)
		return;
	for (i = VERB_HANDLE_SELF + 1; i < VERB_HANDLE_MAX; i++) {
		if (h->slot[i].ref && h->slot[i].owned)
			obj_release(h->slot[i].ref);
		h->slot[i].ref = NULL;
		h->slot[i].owned = 0;
	}
}
