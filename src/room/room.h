#ifndef BORIS_ROOM_H_
#define BORIS_ROOM_H_

#include "obj.h"

OBJ *room_get(const char *room_id);
void room_put(OBJ *r);

#endif
