/* roomdraw.h
 * Copyright 2007-2020 Jon Mayo - Read LICENSE for licensing terms
 * initial: 2007-10-08
 * updated: 2020-12-10
 */
#ifndef ROOM_H_
#define ROOM_H_
#include <stddef.h>
/* returns the size of the buffer necessary to render a certain sized room */
#define ROOM_BUF_SZ(w, h) (((h)+2)*((w)+4)+1)
void room_draw(char *buf, size_t n, int width, int height, unsigned exits);
#endif
