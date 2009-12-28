/**
 * @file boris.h
 *
 * A plugin oriented MUD.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2009 Dec 27
 *
 * Copyright 2009 Jon Mayo
 * Ms-RL : See COPYING.txt for complete license text.
 *
 */
#ifndef BORIS_H
#define BORIS_H
/******************************************************************************
 * Forward declarations
 ******************************************************************************/
struct channel;
struct channel_member;
struct freelist_entry;

/******************************************************************************
 * Includes
 ******************************************************************************/
#include "plugin.h"
#include "list.h"

/******************************************************************************
 * Defines and macros
 ******************************************************************************/

/** get number of elements in an array. */
#define NR(x) (sizeof(x)/sizeof*(x))

/** round up on a boundry. */
#define ROUNDUP(a,n) (((a)+(n)-1)/(n)*(n))

/** round down on a boundry. */
#define ROUNDDOWN(a,n) ((a)-((a)%(n)))

#define B_LOG_ASSERT 0 /**< unexpected condition forcing shutdown. */
#define B_LOG_CRIT 1 /**< critial message - system needs to shutdown. */
#define B_LOG_ERROR 2 /**< error occured - maybe fatal. */
#define B_LOG_WARN 3 /**< warning - something unexpected. */
#define B_LOG_INFO 4 /**< interesting information */
#define B_LOG_TODO 5 /**< messages for incomplete implementation. */
#define B_LOG_DEBUG 6 /**< debug messages. */
#define B_LOG_TRACE 7 /**< trace logging */

/* names of various domains */
#define DOMAIN_USER "users"
#define DOMAIN_ROOM "rooms"
#define DOMAIN_CHARACTER "chars"

/** max id in any domain */
#define ID_MAX 32767

/******************************************************************************
 * Types
 ******************************************************************************/

/**
 * holds an entry.
 */
struct attr_entry {
	LIST_ENTRY(struct attr_entry) list;
	char *name;
	char *value;
};

/**
 * attribute list.
 * it's just a list of name=value pairs (all strings)
 */
LIST_HEAD(struct attr_list, struct attr_entry);

/**
 * used for value_set() and value_get().
 */
enum value_type {
	VALUE_TYPE_STRING,
	VALUE_TYPE_UINT,
};

/**
 * used in situations where a field has both a short form and long form.
 */
struct description_string {
	char *short_str;
	char *long_str;
};

/**
 * head for a list of number ranges.
 */
LIST_HEAD(struct freelist_listhead, struct freelist_entry);

/**
 * a pool of number ranges.
 * originally there were many lists, bucketed by length, but it grew cumbersome.
 */
struct freelist {
	/* single list ordered by offset to find adjacent chunks. */
	struct freelist_listhead global;
};

/**
 * used to subscribe to a channel.
 * see channel.join() and channel.part().
 *
 * HINT: a fancy macro using offsetof() and casting could be used to find the
 * pointer of the containing struct and avoid the need for the void *p.
 */
struct channel_member {
	void (*send)(struct channel_member *cm, struct channel *ch, const char *msg);
	void *p;
};

/******************************************************************************
 * Protos
 ******************************************************************************/

extern void (*b_log)(int priority, const char *domain, const char *fmt, ...);
extern struct plugin_fdb_interface fdb;

int service_detach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_attach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_detach_fdb(const struct plugin_basic_class *cls);
void service_attach_fdb(const struct plugin_basic_class *cls, const struct plugin_fdb_interface *interface);
void service_detach_room(const struct plugin_basic_class *cls);
void service_attach_room(const struct plugin_basic_class *cls, const struct plugin_room_interface *interface);
void service_detach_character(const struct plugin_basic_class *cls);
void service_attach_character(const struct plugin_basic_class *cls, const struct plugin_character_interface *interface);
void service_detach_channel(const struct plugin_basic_class *cls);
void service_attach_channel(const struct plugin_basic_class *cls, const struct plugin_channel_interface *interface);

struct attr_entry *attr_find(struct attr_list *al, const char *name);
int attr_add(struct attr_list *al, const char *name, const char *value);
void attr_list_free(struct attr_list *al);

int parse_uint(const char *name, const char *value, unsigned *uint_p);
int parse_str(const char *name, const char *value, char **str_p);
int parse_attr(const char *name, const char *value, struct attr_list *al);
int value_set(const char *value, enum value_type type, void *p);
const char *value_get(enum value_type type, void *p);

void freelist_init(struct freelist *fl);
void freelist_free(struct freelist *fl);
long freelist_alloc(struct freelist *fl, unsigned count);
void freelist_pool(struct freelist *fl, unsigned ofs, unsigned count);
int freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count);
#ifndef NTEST
void freelist_test(void);
#endif

#endif
