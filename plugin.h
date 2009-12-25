/**
 * @file plugin.h
 * Interface definitions for Boris MUD plugins.
 */
#ifndef BORIS_PLUGIN_H
#define BORIS_PLUGIN_H

#define PLUGIN_API 1

struct plugin_basic_class {
	unsigned api_version;
	char *class_name;
	void (*initialize)(void); /**< called before anything else. */
	int (*shutdown)(void); /**< called before unloading, return 0 to refuse. */
};

/**
 * base class for plugins that can allocate instances.
 */
struct plugin_dynamic_class {
	struct plugin_basic_class base_class;
	size_t instance_size; /**< used by the alloc() method */
	void *(*alloc)(const struct plugin_dynamic_class *class); /**< create a instance of this class. */
	void (*destroy)(void *instance); /**< destroy/free/delete an instance. */
};

/**
 * interface common to all logging plugins.
 * this is to be placed inside of a class.
 */
struct plugin_logging_interface {
	/* output a log message. */
	void (*log)(int priority, const char *domain, const char *fmt, ...);
	/* set log filtering level. will print level or below messages. */
	void (*set_level)(int level);
};
#endif
