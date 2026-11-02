#ifndef _TIME_H
#define _TIME_H

#include <stddef.h>

typedef long time_t;

struct tm {
    int tm_sec;     /* 0..60 */
    int tm_min;     /* 0..59 */
    int tm_hour;    /* 0..23 */
    int tm_mday;    /* 1..31 */
    int tm_mon;     /* 0..11 */
    int tm_year;    /* years since 1900 */
    int tm_wday;    /* 0..6, Sunday = 0 */
    int tm_yday;    /* 0..365 */
    int tm_isdst;
};

time_t     time(time_t *t);
struct tm *localtime(const time_t *t);
struct tm *gmtime(const time_t *t);
size_t     strftime(char *s, size_t max, const char *fmt, const struct tm *tm);

#endif /* _TIME_H */
