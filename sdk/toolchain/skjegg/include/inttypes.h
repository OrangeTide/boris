#ifndef _INTTYPES_H
#define _INTTYPES_H

#include <stdint.h>

/* printf/scanf length-prefixed conversion macros.  int64_t is `long long` and
   int32_t is `int` on every skjegg target (ILP32 with a 64-bit long long), so
   the 64-bit forms carry the "ll" length modifier and the 32-bit forms none. */
#define PRId64  "lld"
#define PRIi64  "lli"
#define PRIu64  "llu"
#define PRIo64  "llo"
#define PRIx64  "llx"
#define PRIX64  "llX"

#define PRId32  "d"
#define PRIi32  "i"
#define PRIu32  "u"
#define PRIo32  "o"
#define PRIx32  "x"
#define PRIX32  "X"

#endif /* _INTTYPES_H */
