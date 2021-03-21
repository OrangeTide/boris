/* dynamic string library */
#ifndef DYNSTRING_H
#define DYNSTRING_H
#include "darray.h"
DARRAY_typedef(string_t, char);
DARRAY_APPEND_def(string_t, char, stringCharAppend);
DARRAY_CAT_def(string_t, char, stringCat);
DARRAY_COPY_def(string_t, char, stringCopy);
DARRAY_FREE_def(string_t, char, stringFree);
DARRAY_INIT_def(string_t, char, stringInit);

#endif /* DYNSTRING_H */
