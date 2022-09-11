#ifndef WORLDCLOCK_H_
#define WORLDCLOCK_H_
#include <stddef.h>
#include <stdint.h>

typedef int64_t worldclock_t;

int worldclock_init(void);
worldclock_t worldclock_now(void);
int worldclock_datetimestr(char *s, size_t max, worldclock_t t);
int worldclock_datestr(char *s, size_t max, worldclock_t t);
int worldclock_timestr(char *s, size_t max, worldclock_t t);
#endif
