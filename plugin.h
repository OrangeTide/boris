/**
 * @file plugin.h
 *
 * Interface definitions for Boris MUD plugins.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2009 Dec 27
 *
 * Copyright 2009 Jon Mayo
 * Ms-RL : See COPYING.txt for complete license text.
 *
 */
#ifndef BORIS_PLUGIN_H
#define BORIS_PLUGIN_H

/**
 * API version - when plugin api changes significantly then increase this.
 */
#define PLUGIN_API 1

/**
 * a class that is common to any plugin class.
 * the member should be named base_class in derivative classes.
 */
struct plugin_basic_class {
	unsigned api_version;
	char *class_name;
	int (*initialize)(void); /**< called before anything else. */
	int (*shutdown)(void); /**< called before unloading, return 0 to refuse. */
};

/**
 * base class for plugins that can allocate instances.
 */
struct plugin_factory_class {
	struct plugin_basic_class base_class;
	size_t instance_size; /**< used by the alloc() method */
	void *(*alloc)(const struct plugin_factory_class *class); /**< create a instance of this class. */
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

/**
 * interface common to any room plugin.
 */
struct plugin_room_interface {
	/** find a room by id and return it.
	 * increases reference count on a room.
	 */
	struct room *(*get)(unsigned room_id);
	/** reduce reference count on a room */
	void (*put)(struct room *r);
	/**
	 * set an attribute on a room.
	 */
	int (*attr_set)(struct room *r, const char *name, const char *value);
	/**
	 * get an attribute on a room.
	 * value is temporary and may disappear if the room is flushed, changed or
	 * attr_get() is called again.
	 */
	const char *(*attr_get)(struct room *r, const char *name);
	/**
	 * save a room to disk (only if it is dirty).
	 */
	int (*save)(struct room *r);
};

struct plugin_fdb_interface {
	int (*domain_init)(const char *domain);
	struct fdb_write_handle *(*write_begin)(const char *domain, const char *id);
	struct fdb_write_handle *(*write_begin_uint)(const char *domain, unsigned id);
	int (*write_pair)(struct fdb_write_handle *h, const char *name, const char *value_str);
	int (*write_format)(struct fdb_write_handle *h, const char *name, const char *value_fmt, ...);
	int (*write_end)(struct fdb_write_handle *h);
	void (*write_abort)(struct fdb_write_handle *h);
	struct fdb_read_handle *(*read_begin)(const char *domain, const char *id);
	struct fdb_read_handle *(*read_begin_uint)(const char *domain, unsigned id);
	int (*read_next)(struct fdb_read_handle *h, const char **name, const char **value);
	int (*read_end)(struct fdb_read_handle *h);
	struct fdb_iterator *(*iterator_begin)(const char *domain);
	const char *(*iterator_next)(struct fdb_iterator *it);
	void (*iterator_end)(struct fdb_iterator *it);
};

struct plugin_character_interface {
	/**
	 * find a character by id and return it.
	 * increases reference count on a character.
	 */
	struct character *(*get)(unsigned character_id);
	/** reduce reference count on a character */
	void (*put)(struct character *ch);
	/**
	 * create a new character with next available id.
	 * increases reference count on a character.
	 */
	struct character *(*new)(void);
	/**
	 * set an attribute on a character.
	 */
	int (*attr_set)(struct character *ch, const char *name, const char *value);
	/**
	 * get an attribute on a character.
	 * value is temporary and may disappear if the character is flushed,
	 * changed or attr_get() is called again.
	 */
	const char *(*attr_get)(struct character *ch, const char *name);
	/**
	 * save a character to disk (only if it is dirty).
	 */
	int (*save)(struct character *ch);
};

struct plugin_channel_interface {
	int (*join)(struct channel *ch, struct channel_member *cm);
	void (*part)(struct channel *ch, struct channel_member *cm);
	/**
	 * get a channel associated with a public(global) name.
	 */
	struct channel *(*public)(const char *name);
	int (*broadcast)(struct channel *ch, struct channel_member **exclude_list, unsigned exclude_list_len, const char *fmt, ...);
};
#endif
