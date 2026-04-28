/* program.h : program object access */
#ifndef PROGRAM_H
#define PROGRAM_H

#include "obj.h"

int  program_init(void);
void program_shutdown(void);

OBJ *program_get(const char *id);
void program_release(OBJ *obj);

unsigned    program_ram_size(OBJ *obj);
const char *program_interface(OBJ *obj);
int         program_open_image(OBJ *obj);

#endif
