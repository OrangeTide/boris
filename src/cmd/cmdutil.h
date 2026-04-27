#ifndef CMDUTIL_H_
#define CMDUTIL_H_
#include "boris.h"
#include "room.h"

/* sink state for streaming expand_string output to a telnetclient.
 * buffers small chunks on the stack and flushes via telnetclient_puts
 * so the expander never has to allocate. */
struct _tc_sink {
	DESCRIPTOR_DATA	*cl;
	char		buf[256];
	unsigned	len;
};

/* internal use by functions in cmd module */
void _tc_flush(struct _tc_sink *s);
int _tc_sink(void *user, const char *data, unsigned n);

/* communication utility functions */
void show_gametime(DESCRIPTOR_DATA *cl);
int show_ambient(DESCRIPTOR_DATA *cl);
int show_pose(DESCRIPTOR_DATA *cl);
void show_room(DESCRIPTOR_DATA *cl, OBJ *r);

#endif
