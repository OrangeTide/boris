#ifndef __STDIO_H
#define __STDIO_H
#include <stdio.h>
#include <string.h>

char *lfgets(FILE *stream, int stripnl, int limit);
#if !defined(__USE_BSD)
int strcasecmp(const char *s1, const char *s2);
int strncasecmp(const char *s1, const char *s2, size_t n);
char *strdup(const char *s);
#endif

#endif
