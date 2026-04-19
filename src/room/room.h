#ifndef BORIS_ROOM_H_
#define BORIS_ROOM_H_

struct attr_list;

int room_initialize(void);
void room_shutdown(void);
/** find a room by id and return it.
 * increases reference count on a room.
 */
struct room *room_get(const char *room_id);
/** reduce reference count on a room */
void room_put(struct room *r);
/**
 * set an attribute on a room.
 */
int room_attr_set(struct room *r, const char *name, const char *value);
/**
 * get an attribute on a room.
 * value is temporary and may disappear if the room is flushed, changed or
 * attr_get() is called again.
 */
const char *room_attr_get(struct room *r, const char *name);
/**
 * save a room to disk (only if it is dirty).
 */
int room_save(struct room *r);
/**
 * return the extra-attributes list for iteration (extras only, not built-in
 * fields). Never returns NULL for a valid r.
 */
struct attr_list *room_attrs_extras(struct room *r);

#endif
