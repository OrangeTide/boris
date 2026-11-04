#ifndef _STDBOOL_H
#define _STDBOOL_H

/* C99/C11 <stdbool.h>: bool is _Bool, which stores only 0 or 1 (a conversion to
   it normalizes any nonzero value to 1) and reads back as an int in
   expressions. */
#define bool  _Bool
#define true  1
#define false 0
#define __bool_true_false_are_defined 1

#endif
