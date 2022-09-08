#ifndef HELP_H_
#define HELP_H_
#include <mud.h>
#define HELP_OK (0)
#define HELP_ERR (-1)
int help_init(void);
void help_shutdown(void);
int help_show(DESCRIPTOR_DATA *d, const char *topic);
#endif
