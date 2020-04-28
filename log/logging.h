#ifndef BORIS_LOGGING_H_
#define BORIS_LOGGING_H_

/******************************************************************************
 * Macros
 ******************************************************************************/
#define B_LOG_ASSERT 0 /**< unexpected condition forcing shutdown. */
#define B_LOG_CRIT 1 /**< critial message - system needs to shutdown. */
#define B_LOG_ERROR 2 /**< error occured - maybe fatal. */
#define B_LOG_WARN 3 /**< warning - something unexpected. */
#define B_LOG_INFO 4 /**< interesting information */
#define B_LOG_TODO 5 /**< messages for incomplete implementation. */
#define B_LOG_DEBUG 6 /**< debug messages. */
#define B_LOG_TRACE 7 /**< trace logging */

/******************************************************************************
 * Function-like macros
 ******************************************************************************/
#define b_log logging_do_log

/******************************************************************************
 * Prototypes
 ******************************************************************************/
int logging_initialize(void);
void logging_shutdown(void);
void logging_do_log(int priority, const char *domain, const char *fmt, ...);
void logging_set_level(int level);
#endif
