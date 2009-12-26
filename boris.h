#ifndef BORIS_H
#define BORIS_H
#include "plugin.h"
#include "list.h"

/**
 * holds an entry.
 */
struct attr_entry {
	LIST_ENTRY(struct attr_entry) list;
	char *name;
	char *value;
};

LIST_HEAD(struct attr_list, struct attr_entry);

#define B_LOG_ASSERT 0 /**< unexpected condition forcing shutdown. */
#define B_LOG_CRIT 1 /**< critial message - system needs to shutdown. */
#define B_LOG_ERROR 2 /**< error occured - maybe fatal. */
#define B_LOG_WARN 3 /**< warning - something unexpected. */
#define B_LOG_INFO 4 /**< interesting information */
#define B_LOG_TODO 5 /**< messages for incomplete implementation. */
#define B_LOG_DEBUG 6 /**< debug messages. */
#define B_LOG_TRACE 7 /**< trace logging */

extern void (*b_log)(int priority, const char *domain, const char *fmt, ...);
extern struct plugin_fdb_interface fdb;

int service_detach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_attach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_detach_fdb(const struct plugin_basic_class *cls);
void service_attach_fdb(const struct plugin_basic_class *cls, const struct plugin_fdb_interface *interface);

struct attr_entry *attr_find(struct attr_list *al, const char *name);
int attr_add(struct attr_list *al, const char *name, const char *value);
void attr_list_free(struct attr_list *al);

int parse_uint(const char *name, const char *value, unsigned *uint_p);
int parse_str(const char *name, const char *value, char **str_p);
int parse_attr(const char *name, const char *value, struct attr_list *al);
#endif
