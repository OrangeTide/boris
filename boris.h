#ifndef BORIS_H
#define BORIS_H
#define B_LOG_ASSERT 0 /**< unexpected condition forcing shutdown. */
#define B_LOG_CRIT 1 /**< critial message - system needs to shutdown. */
#define B_LOG_ERROR 2 /**< error occured - maybe fatal. */
#define B_LOG_WARN 3 /**< warning - something unexpected. */
#define B_LOG_INFO 4 /**< interesting information */
#define B_LOG_TODO 5 /**< messages for incomplete implementation. */
#define B_LOG_DEBUG 6 /**< debug messages. */
#define B_LOG_TRACE 7 /**< trace logging */

extern void (*b_log)(int priority, const char *domain, const char *fmt, ...);

int service_detach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_attach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
#endif
