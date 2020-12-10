#ifndef LOG_H_
#define LOG_H_
#include <stdarg.h>
void log_verror(const char *fmt, va_list ap);
void log_vinfo(const char *fmt, va_list ap);
void log_vwarn(const char *fmt, va_list ap);
void log_error(const char *fmt, ...);
void log_info(const char *fmt, ...);
void log_warn(const char *fmt, ...);
void log_errno(const char *reason);
#endif
