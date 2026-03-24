#ifndef COMUTIL_H_
#define COMUTIL_H_
#include "boris.h"
#include "room.h"

/* communication utility functions */
void show_gametime(DESCRIPTOR_DATA *cl);
void show_room(DESCRIPTOR_DATA *cl, struct room *r);

#endif
