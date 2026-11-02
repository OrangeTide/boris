#ifndef _LIMITS_H
#define _LIMITS_H

#define CHAR_BIT   8

/* char is signed on every skj target. */
#define SCHAR_MIN  (-128)
#define SCHAR_MAX  127
#define UCHAR_MAX  255
#define CHAR_MIN   SCHAR_MIN
#define CHAR_MAX   SCHAR_MAX

#define SHRT_MIN   (-32768)
#define SHRT_MAX   32767
#define USHRT_MAX  65535

#define INT_MIN    (-2147483647 - 1)
#define INT_MAX    2147483647
#define UINT_MAX   4294967295u

#define LLONG_MIN  (-9223372036854775807LL - 1)
#define LLONG_MAX  9223372036854775807LL
#define ULLONG_MAX 18446744073709551615ULL

#ifdef __skj_lp64__
#define LONG_MIN   LLONG_MIN
#define LONG_MAX   LLONG_MAX
#define ULONG_MAX  ULLONG_MAX
#else
#define LONG_MIN   INT_MIN
#define LONG_MAX   INT_MAX
#define ULONG_MAX  UINT_MAX
#endif

#endif
