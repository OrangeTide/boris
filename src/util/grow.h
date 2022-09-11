#ifndef GROW_H_
#define GROW_H_
#include <stddef.h>
int grow(void **ptr, unsigned *max, unsigned min, size_t elem);
#endif
