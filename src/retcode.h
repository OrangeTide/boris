#ifndef RETCODE_H_
#define RETCODE_H_
/*
 * retcode.h - return values for most simple functions.
 *
 * Kept in a tiny standalone header so any translation unit (including unit
 * tests that cannot pull in boris.h) can use these without extra dependencies.
 */

#define OK (0)
#define ERR (-1)

#endif
