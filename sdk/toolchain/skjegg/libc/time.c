/* A minimal time implementation.  There is no clock syscall in the sandbox
   runtime, so time() returns a fixed timestamp; the point of this file is to
   let the preprocessor's __DATE__ / __TIME__ macros (cpp/dir.c) resolve to a
   valid, reproducible date rather than to report the wall clock.  gmtime and
   strftime are correct for the value they are given. */
#include <time.h>

/* 2024-01-01 00:00:00 UTC, a fixed, plausible build time. */
#define FIXED_EPOCH 1704067200L

time_t
time(time_t *t)
{
    if (t)
        *t = FIXED_EPOCH;
    return FIXED_EPOCH;
}

static int
is_leap(int y)
{
    return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
}

struct tm *
gmtime(const time_t *tp)
{
    static struct tm tm;
    static const int mdays[12] = { 31, 28, 31, 30, 31, 30,
                                   31, 31, 30, 31, 30, 31 };
    long secs = tp ? *tp : 0;
    long days = secs / 86400;
    long rem = secs % 86400;
    int y = 1970, m = 0;

    if (rem < 0) {
        rem += 86400;
        days--;
    }
    tm.tm_hour = (int)(rem / 3600);
    tm.tm_min = (int)((rem % 3600) / 60);
    tm.tm_sec = (int)(rem % 60);
    tm.tm_wday = (int)((days + 4) % 7);     /* 1970-01-01 was a Thursday */
    if (tm.tm_wday < 0)
        tm.tm_wday += 7;

    while (days >= (is_leap(y) ? 366 : 365)) {
        days -= is_leap(y) ? 366 : 365;
        y++;
    }
    tm.tm_year = y - 1900;
    tm.tm_yday = (int)days;
    while (days >= mdays[m] + (m == 1 && is_leap(y) ? 1 : 0)) {
        days -= mdays[m] + (m == 1 && is_leap(y) ? 1 : 0);
        m++;
    }
    tm.tm_mon = m;
    tm.tm_mday = (int)days + 1;
    tm.tm_isdst = 0;
    return &tm;
}

struct tm *
localtime(const time_t *tp)
{
    return gmtime(tp);              /* no timezone support: UTC */
}

static char *
put2(char *p, int v)
{
    *p++ = (char)('0' + (v / 10) % 10);
    *p++ = (char)('0' + v % 10);
    return p;
}

size_t
strftime(char *s, size_t max, const char *fmt, const struct tm *tm)
{
    static const char *const mon[12] = { "Jan", "Feb", "Mar", "Apr", "May",
                                         "Jun", "Jul", "Aug", "Sep", "Oct",
                                         "Nov", "Dec" };
    char buf[128];
    char *p = buf;
    const char *f = fmt;
    size_t n;

    while (*f && (size_t)(p - buf) < sizeof(buf) - 4) {
        if (*f != '%') {
            *p++ = *f++;
            continue;
        }
        f++;
        switch (*f) {
        case 'Y': {
            int y = tm->tm_year + 1900;
            *p++ = (char)('0' + (y / 1000) % 10);
            *p++ = (char)('0' + (y / 100) % 10);
            *p++ = (char)('0' + (y / 10) % 10);
            *p++ = (char)('0' + y % 10);
            break;
        }
        case 'm': p = put2(p, tm->tm_mon + 1); break;
        case 'd': p = put2(p, tm->tm_mday); break;
        case 'H': p = put2(p, tm->tm_hour); break;
        case 'M': p = put2(p, tm->tm_min); break;
        case 'S': p = put2(p, tm->tm_sec); break;
        case 'b': {
            const char *m = mon[tm->tm_mon % 12];
            *p++ = m[0]; *p++ = m[1]; *p++ = m[2];
            break;
        }
        case 'e':                               /* day, space-padded to 2 */
            if (tm->tm_mday < 10) {
                *p++ = ' ';
                *p++ = (char)('0' + tm->tm_mday);
            } else {
                p = put2(p, tm->tm_mday);
            }
            break;
        case '%': *p++ = '%'; break;
        case '\0': continue;
        default:  *p++ = '%'; *p++ = *f; break;
        }
        f++;
    }
    *p = '\0';

    n = (size_t)(p - buf);
    if (n >= max) {
        if (max > 0)
            s[0] = '\0';
        return 0;
    }
    {
        size_t i;
        for (i = 0; i <= n; i++)
            s[i] = buf[i];
    }
    return n;
}
