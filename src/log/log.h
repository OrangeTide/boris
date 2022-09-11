#ifndef LOG_H_
#define LOG_H_
#include <stdarg.h>

#ifndef LOG_SUBSYSTEM
#define LOG_SUBSYSTEM NULL
#warning Unknown subsystem. Please define LOG_SUBSYSTEM
#endif

#define LOG_OK (0)
#define LOG_ERR (-1)

#define LOG_CRITICAL(...) log_logf(LOG_LEVEL_CRIT, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_ERROR(...) log_logf(LOG_LEVEL_ERROR, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_WARNING(...) log_logf(LOG_LEVEL_WARN, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_INFO(...) log_logf(LOG_LEVEL_INFO, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_TODO(...) log_logf(LOG_LEVEL_TODO, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_DEBUG(...) log_logf(LOG_LEVEL_DEBUG, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_TRACE(...) log_logf(LOG_LEVEL_TRACE, LOG_SUBSYSTEM, __VA_ARGS__)
#define LOG_PERROR(reason) log_perror(LOG_LEVEL_ERROR, LOG_SUBSYSTEM, reason)

enum {
	LOG_LEVEL_ASSERT,
	LOG_LEVEL_CRIT,
	LOG_LEVEL_ERROR,
	LOG_LEVEL_WARN,
	LOG_LEVEL_INFO,
	LOG_LEVEL_TODO,
	LOG_LEVEL_DEBUG,
	LOG_LEVEL_TRACE,
};

int log_init(void);
void log_done(void);
void log_vlogf(int level, const char *subsystem, const char *fmt, va_list ap);
void log_logf(int level, const char *subsystem, const char *fmt, ...);
void log_perror(int level, const char *subsystem, const char *reason);
#endif
