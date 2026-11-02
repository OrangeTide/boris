/**
 * @file common.c
 *
 * Several routines that haven't been split up into libraries yet.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/** @mainpage
 *
 * Design Documentation
 *
 *
 * components:
 * - bitfield - manages small staticly sized bitmaps. uses @ref BITFIELD
 * - bitmap - manages large bitmaps
 * - buffer - manages an i/o buffer
 * - heapqueue_elm - priority queue for implementing timers
 * - refcount - macros to provide reference counting. uses @ref REFCOUNT_PUT and @ref REFCOUNT_GET
 * - server - accepts new connections
 * - shvar - process $() macros. implemented by @ref shvar_eval.
 * - user - user account handling. see also user_name_map_entry.
 * - util_strfile - holds contents of a textfile in an array.
 *
 * dependency:
 * - user - uses ref counts.
 *
 * types of records:
 * - objects - base objects for room, mob, or item
 * - instances - instance data for room, mob or item
 * - container - container data for room, mob or item (a type of instance data)
 * - stringmap - maps strings to a data structure (hash table)
 * - numbermap - maps integers to a data structure (hash table)
 * - strings - a large string that can span multiple blocks
 *
 * objects:
 * - base - the following types of objects are defined:
 *   - room
 *   - mob
 *   - item
 * - instance - all instances are the same structure:
 *   - id - object id
 *   - count - all item instances are stackable 1 to 256.
 *   - flags - 24 status flags [A-HJ-KM-Z]
 *   - extra1..extra2 - control values that can be variable
 *
 * containers:
 * - instance parameter holds a id that holds an array of up to 64 objects.
 *
 * database saves the following types of blobs:
 * - player account
 * - room object
 * - mob object (also used for characters)
 * - item object
 * - instances
 * - container slots
 * - help text
 *
 ******************************************************************************/

/******************************************************************************
 * Configuration
 ******************************************************************************/

/* make sure WIN32 is defined when building in a Windows environment */
#if (defined(_MSC_VER) || defined(__WIN32__)) && !defined(WIN32)
#define WIN32
#endif

#define SUBSYSTEM_NAME "server_core"

/**
 * maximum output buffer size for telnet clients.
 * this control output line length. */
#define TELNETCLIENT_OUTPUT_BUFFER_SZ 4096

/**
 * maximum input buffer size fo telnet clients
 * this control input line length */
#define TELNETCLIENT_INPUT_BUFFER_SZ 256

/******************************************************************************
 * Headers
 ******************************************************************************/

#include <assert.h>
#include <ctype.h>
#include <dirent.h>
#include <errno.h>
#include <inttypes.h>
#include <limits.h>
#include <math.h>
#include <signal.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef _XOPEN_SOURCE
#include <strings.h>
#endif
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>

#include "boris.h"
#include "mud.h"
#include "command.h"
#include "channel.h"
#define LOG_SUBSYSTEM "server"
#include <log.h>
#include "debug.h"
#include "eventlog.h"
#include "freelist.h"
#include "list.h"
#include "sha1.h"
#include "sha1crypt.h"
#include "util.h"
#include "config.h"
#include "worldclock.h"

/******************************************************************************
 * Types and data structures
 ******************************************************************************/

/******************************************************************************
 * Globals
 ******************************************************************************/

/** global configuration used in many different places */
MUD_CONFIG mud_config;

/** global mud state used in many different places */
MUD_DATA mud;

/******************************************************************************
 * Prototypes
 ******************************************************************************/

/******************************************************************************
 * name-value parser routines.
 ******************************************************************************/

/**
 * parse a value string into a uint.
 */
int
parse_uint(const char *name, const char *value, unsigned *uint_p)
{
	char *endptr;
	assert(uint_p != NULL);

	if (!uint_p) return 0; /* error */

	if (!value || !*value) {
		LOG_ERROR("%s:Empty string", name);
		return 0; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		LOG_ERROR("%s:Not a number", name);
		return 0; /* error - not a number */
	}

	return 1; /* success */
}

/**
 * load a string into str_p, free()ing string at str_p first.
 */
int
parse_str(const char *name UNUSED, const char *value, char **str_p)
{
	assert(str_p != NULL);
	assert(value != NULL);

	if (!str_p) return 0; /* error */

	if (*str_p) free(*str_p);

	*str_p = strdup(value);

	if (!*str_p) {
		LOG_PERROR("strdup()");
		return 0; /* error */
	}

	return 1; /* success */
}

/**
 * add to an attribute list.
 */
int
parse_attr(const char *name, const char *value, struct attr_list *al)
{
	struct attr_entry *at;

	assert(name != NULL);
	assert(value != NULL);
	assert(al != NULL);

	at = attr_find(al, name);

	if (!at) {
		return attr_add(al, name, value);
	}

	free(at->value);
	at->value = strdup(value);
	return 1; /* success. */
}

/**
 * set a value into p according to type.
 */
int
value_set(const char *value, enum value_type type, void *p)
{
	assert(p != NULL);
	assert(value != NULL);

	if (!p || !value) return 0; /* error */

	switch(type) {
	case VALUE_TYPE_STRING: {
		if (*(char**)p) free(*(char**)p);

		*(char**)p = strdup(value);

		if (!*(char**)p) {
			LOG_PERROR("strdup()");
			return 0; /* error */
		}

		return 1; /* success */
	}

	case VALUE_TYPE_UINT: {
		char *endptr;

		if (!*value) {
			LOG_ERROR("Empty string");
			return 0; /* error - empty string */
		}

		*(unsigned*)p = strtoul(value, &endptr, 0);

		if (*endptr != 0) {
			LOG_ERROR("Not a number:\"%s\"", value);
			return 0; /* error - not a number */
		}

		return 1; /* success */
	}
	}

	return 0; /* failure. */
}

/**
 * convert a value at p into a string according to type.
 * string returned is temporary and can change if an object is modified or if
 * this function is called again.
 */
const char *
value_get(enum value_type type, void *p)
{
	static char numbuf[22]; /* big enough for a signed 64-bit decimal */

	switch(type) {
	case VALUE_TYPE_STRING:
		return *(char**)p;

	case VALUE_TYPE_UINT:
		snprintf(numbuf, sizeof numbuf, "%u", *(unsigned*)p);
		return numbuf;
	}

	return NULL;
}

/******************************************************************************
 * Debug and test routines
 ******************************************************************************/


/******************************************************************************
 * shvar - shell variables
 ******************************************************************************/

/** maximum number of characters in a $(). */
#define SHVAR_ID_MAX 128

/** escape character used. */
#define SHVAR_ESCAPE '$'

/** evaluate "shell variables", basically expand ${FOO} in a string. */
int
shvar_eval(char *out, size_t len, const char *src, const char *(*match)(const char *key))
{
	const char *old;
	char key[SHVAR_ID_MAX];

	while (*src && len > 0) {
		if (*src == SHVAR_ESCAPE) {
			const char *key_start, *key_end;
			old = src; /* save old position */
			src++;

			if (*src == '{' || *src == '(') {
				char end_char;
				end_char = *src == '{' ? '}' : ')';
				src++;
				key_start = key_end = src;

				while (*src != end_char) {
					if (!*src) {
						size_t tmplen;
						tmplen = strlen(old);

						if (tmplen >= len) tmplen = len - 1;

						memcpy(out, old, tmplen);
						out[tmplen] = 0;
						return 0; /* failure */
					}

					src++;
				}

				key_end = src;
				src++;
			} else if (*src == SHVAR_ESCAPE) {
				*out++ = *src++;
				len--;
				continue;
			} else {
				key_start = src;

				while (*src && len > 0) {
					if (!isalnum(*src) && *src != '_') {
						break;
					}

					src++;
				}

				key_end = src;
			}

			if (match && key_end >= key_start) {
				const char *tmp;
				size_t tmplen;
				assert(key_start <= key_end);
				memcpy(key, key_start, (size_t)(key_end - key_start));
				key[key_end - key_start] = 0;
				tmp = match(key);

				if (tmp) {
					tmplen = strlen(tmp);

					if (tmplen > len) return 0; /* failure */

					memcpy(out, tmp, tmplen);
					out += tmplen;
					len -= tmplen;
				}
			}
		} else {
			*out++ = *src++;
			len--;
		}
	}

	if (len > 0) {
		*out++ = 0;
		len--;
		return *src == 0;
	}

	*out = 0;
	return 0; /* failure */
}


/******************************************************************************
 * attribute list
 ******************************************************************************/

/**
 * find an attr by name.
 */
struct attr_entry *attr_find(struct attr_list *al, const char *name)
{
	struct attr_entry *curr;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		/* case sensitive. */
		if (!strcmp(curr->name, name)) {
			return curr;
		}
	}

	return NULL; /* not found. */
}

/**
 * add an entry to the end, preserves the order.
 * refuse to add a duplicate entry.
 */
int
attr_add(struct attr_list *al, const char *name, const char *value)
{
	struct attr_entry *curr, *prev, *item;

	assert(al != NULL);

	/* track prev to use later as a tail. */
	prev = NULL;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		/* case sensitive. */
		if (!strcmp(curr->name, name)) {
			LOG_ERROR("WARNING:attribute '%s' already exists.", curr->name);
			return 0; /**< duplicate found, refuse to add. */
		}

		prev = curr;
	}

	/* create the new entry. */
	item = calloc(1, sizeof * item);

	if (!item) {
		LOG_PERROR("calloc()");
		return 0; /**< out of memory. */
	}

	item->name = strdup(name);

	if (!item->name) {
		LOG_PERROR("strdup()");
		free(item);
		return 0; /**< out of memory. */
	}

	item->value = strdup(value);

	if (!item->value) {
		LOG_PERROR("strdup()");
		free(item->name);
		free(item);
		return 0; /**< out of memory. */
	}

	/* if head of list use LIST_INSERT_HEAD, else insert after curr. */
	if (prev) {
		assert(curr == NULL);
		LIST_INSERT_AFTER(prev, item, list);
	} else {
		LIST_INSERT_HEAD(al, item, list);
	}

	return 1; /**< success. */
}

/**
 * free every element on the list.
 */
void
attr_list_free(struct attr_list *al)
{
	struct attr_entry *curr;

	assert(al != NULL);

	while ((curr = LIST_TOP(*al))) {
		LIST_REMOVE(curr, list);
		free(curr->name);
		curr->name = NULL;
		free(curr->value);
		curr->value = NULL;
		free(curr);
	}
}

/******************************************************************************
 * Mud Config
 ******************************************************************************/

/** undocumented - please add documentation. */
static int
do_config_prompt(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	char **target;
	size_t len;

	if (!strcasecmp(id, "prompt.menu")) {
		target = &mud_config.menu_prompt;
	} else if (!strcasecmp(id, "prompt.form")) {
		target = &mud_config.form_prompt;
	} else if (!strcasecmp(id, "prompt.command")) {
		target = &mud_config.command_prompt;
	} else {
		LOG_ERROR("problem with config option '%s' = '%s'", id, value);
		return 1; /* failure - continue looking for matches */
	}

	free(*target);
	len = strlen(value) + 2; /* leave room for a space */
	*target = malloc(len);
	snprintf(*target, len, "%s ", value);

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int
do_config_msg(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	size_t len;
	unsigned i;
	const struct {
		const char *id;
		char **target;
	} info[] = {
		{ "msg.unsupported", &mud_config.msg_unsupported },
		{ "msg.invalidselection", &mud_config.msg_invalidselection },
		{ "msg.invalidusername", &mud_config.msg_invalidusername },
		{ "msg.tryagain", &mud_config.msg_tryagain },
		{ "msg.errormain", &mud_config.msg_errormain },
		{ "msg.usermin3", &mud_config.msg_usermin3 },
		{ "msg.invalidcommand", &mud_config.msg_invalidcommand },
		{ "msg.verbnomatch", &mud_config.msg_verbnomatch },
		{ "msg.verbbadarg", &mud_config.msg_verbbadarg },
		{ "msg.useralphanumeric", &mud_config.msg_useralphanumeric },
		{ "msg.userexists", &mud_config.msg_userexists },
		{ "msg.usercreatesuccess", &mud_config.msg_usercreatesuccess },
	};

	for (i = 0; i < NR(info); i++) {
		if (!strcasecmp(id, info[i].id)) {
			free(*info[i].target);
			len = strlen(value) + 2; /* leave room for a newline */
			*info[i].target = malloc(len);
			snprintf(*info[i].target, len, "%s\n", value);
			return 0; /* success - terminate the callback chain */
		}
	}

	LOG_ERROR("problem with config option '%s' = '%s'", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int
do_config_msgfile(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	unsigned i;
	const struct {
		const char *id;
		char **target;
	} info[] = {
		{ "msgfile.noaccount", &mud_config.msgfile_noaccount },
		{ "msgfile.badpassword", &mud_config.msgfile_badpassword },
		{ "msgfile.welcome", &mud_config.msgfile_welcome },
		{ "msgfile.newuser_create", &mud_config.msgfile_newuser_create },
		{ "msgfile.newuser_deny", &mud_config.msgfile_newuser_deny },
	};

	for (i = 0; i < NR(info); i++) {
		if (!strcasecmp(id, info[i].id)) {
			free(*info[i].target);
			*info[i].target = util_textfile_load(value);

			/* if we could not load the file, install a fake message */
			if (!*info[i].target) {
				char buf[128];
				snprintf(buf, sizeof buf, "<<fileNotFound:%s>>\n", value);
				*info[i].target = strdup(buf);
			}

			return 0; /* success - terminate the callback chain */
		}
	}

	LOG_ERROR("problem with config option '%s' = '%s'", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int
do_config_string(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
{
	char **target = extra;
	assert(value != NULL);
	assert(target != NULL);

	free(*target);
	*target = strdup(value);

	return 0; /* success - terminate the callback chain */
}

/**
 * @brief handles the 'server.port' property.
 */
static int
do_config_port(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	char *endptr;

	errno = 0;
	mud.params.port = strtoul(value, &endptr, 0);
	if (errno || *endptr != 0) {
		LOG_ERROR("Not a number. problem with config option '%s' = '%s'", id, value);
		return -1; /* error - not a number */
	}

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int
do_config_uint(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
{
	char *endptr;
	unsigned *uint_p = extra;
	assert(extra != NULL);

	if (!extra) return -1; /* error */

	if (!*value) {
		LOG_DEBUG("Empty string");
		return -1; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		LOG_DEBUG("Not a number");
		return -1; /* error - empty string */
	}

	return 0; /* success - terminate the callback chain */
}

/**
 * intialize default configuration. Config file overrides these defaults.
 */
void
mud_config_init(void)
{
	mud_config.config_filename = strdup("boris.cfg");
	mud_config.menu_prompt = strdup("Selection: ");
	mud_config.form_prompt = strdup("Selection: ");
	mud_config.command_prompt = strdup("> ");
	mud_config.msg_errormain = strdup("ERROR: going back to main menu!\n");
	mud_config.msg_invalidselection = strdup("Invalid selection!\n");
	mud_config.msg_invalidusername = strdup("Invalid username\n");
	mud_config.msgfile_noaccount = strdup("\nInvalid password or account not found!\n\n");
	mud_config.msgfile_badpassword = strdup("\nInvalid password or account not found!\n\n");
	mud_config.msg_tryagain = strdup("Try again!\n");
	mud_config.msg_unsupported = strdup("Not supported!\n");
	mud_config.msg_useralphanumeric = strdup("Username must only contain alphanumeric characters and must start with a letter!\n");
	mud_config.msg_usercreatesuccess = strdup("Account successfully created!\n");
	mud_config.msg_userexists = strdup("Username already exists!\n");
	mud_config.msg_usermin3 = strdup("Username must contain at least 3 characters!\n");
	mud_config.msg_invalidcommand = strdup("Invalid command!\n");
	mud_config.msg_verbnomatch = strdup("You can't do that.\n");
	mud_config.msg_verbbadarg = strdup("You don't see that here.\n");
	mud_config.msgfile_welcome = strdup("Welcome\n\n");
	mud_config.newuser_level = 5;
	mud_config.newuser_flags = 0;
	mud_config.newuser_allowed = 0;
	mud_config.eventlog_filename = strdup("boris.log\n");
	mud_config.eventlog_timeformat = strdup("%y%m%d-%H%M"); /* another good one: %Y.%j-%H%M */
	mud_config.msgfile_newuser_create = strdup("\nPlease enter only correct information in this application.\n\n");
	mud_config.msgfile_newuser_deny = strdup("\nNot accepting new user applications!\n\n");
	mud_config.default_channels = strdup("@system,@wiz,OOC,auction,chat,newbie");
	mud_config.webserver_port = 0; /* default is to disable. */
	mud_config.invite_required = 0;
	mud_config.form_newuser_filename = strdup("data/forms/newuser.form");
	mud_config.default_family = 0;
	mud_config.newuser_room = strdup("zone/world/tower-entrance");
	mud_config.obj_cache_size = 256;
	mud_config.character_cache_size = 128;
	mud_config.vm_image_path = strdup("data/vm");
	mud_config.vm_resident = strdup("");
	mud_config.vm_create_max = 64;
	mud_config.vm_owned_max = 1024;
	mud_config.vm_toolchain_dir = strdup("data/vm/toolchain");
	mud_config.vm_lib_dir = strdup("data/vm/lib");
	mud_config.vm_include_dir = strdup("sdk/toolchain/skjegg/include");
	mud_config.vm_tmpdir = strdup("data/tmp");
#ifdef CONFIG_LANDLOCK
	mud_config.security_landlock = 1;
#endif
#ifdef CONFIG_SECCOMP
	mud_config.security_seccomp = 1;
#endif
	mud_config.daemonize = 0;
	mud_config.pid_file = strdup("boris.pid");
}

/**
 * free all configuration data.
 */
void
mud_config_shutdown(void)
{
	char **targets[] = {
		&mud_config.menu_prompt,
		&mud_config.form_prompt,
		&mud_config.command_prompt,
		&mud_config.msg_errormain,
		&mud_config.msg_invalidselection,
		&mud_config.msg_invalidusername,
		&mud_config.msgfile_noaccount,
		&mud_config.msgfile_badpassword,
		&mud_config.msg_tryagain,
		&mud_config.msg_unsupported,
		&mud_config.msg_useralphanumeric,
		&mud_config.msg_usercreatesuccess,
		&mud_config.msg_userexists,
		&mud_config.msg_usermin3,
		&mud_config.msg_invalidcommand,
		&mud_config.msg_verbnomatch,
		&mud_config.msg_verbbadarg,
		&mud_config.msgfile_welcome,
		&mud_config.eventlog_filename,
		&mud_config.eventlog_timeformat,
		&mud_config.msgfile_newuser_create,
		&mud_config.msgfile_newuser_deny,
		&mud_config.default_channels,
		&mud_config.form_newuser_filename,
		&mud_config.newuser_room,
		&mud_config.vm_image_path,
		&mud_config.vm_resident,
		&mud_config.vm_toolchain_dir,
		&mud_config.vm_lib_dir,
		&mud_config.vm_include_dir,
		&mud_config.vm_tmpdir,
	};
	unsigned i;

	for (i = 0; i < NR(targets); i++) {
		free(*targets[i]);
		*targets[i] = NULL;
	}
}

#if !defined(NDEBUG) && !defined(NTEST)
/** test routine to dump a config option. */
static int
mud_config_show(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	printf("MUD-CONFIG: %s=%s\n", id, value);

	return 1;
}
#endif

/**
 * setup config loging callback functions then reads in a configuration file.
 * @return 0 on failure, 1 on success.
 */
int
mud_config_process(void)
{
	struct config cfg;

	config_setup(&cfg);
	config_watch(&cfg, "server.port", do_config_port, 0);
	config_watch(&cfg, "prompt.*", do_config_prompt, 0);
	config_watch(&cfg, "msg.*", do_config_msg, 0);
	config_watch(&cfg, "msgfile.*", do_config_msgfile, 0);
	config_watch(&cfg, "newuser.level", do_config_uint, &mud_config.newuser_level);
	config_watch(&cfg, "newuser.allowed", do_config_uint, &mud_config.newuser_allowed);
	config_watch(&cfg, "newuser.flags", do_config_uint, &mud_config.newuser_flags);
	config_watch(&cfg, "eventlog.filename", do_config_string, &mud_config.eventlog_filename);
	config_watch(&cfg, "eventlog.timeformat", do_config_string, &mud_config.eventlog_timeformat);
	config_watch(&cfg, "channels.default", do_config_string, &mud_config.default_channels);
	config_watch(&cfg, "webserver.port", do_config_uint, &mud_config.webserver_port);
	config_watch(&cfg, "form.newuser.filename", do_config_string, &mud_config.form_newuser_filename);
	config_watch(&cfg, "newuser.room", do_config_string, &mud_config.newuser_room);
	config_watch(&cfg, "vm.image_path", do_config_string, &mud_config.vm_image_path);
	config_watch(&cfg, "vm.resident", do_config_string, &mud_config.vm_resident);
	config_watch(&cfg, "vm.create_max", do_config_uint, &mud_config.vm_create_max);
	config_watch(&cfg, "vm.owned_max", do_config_uint, &mud_config.vm_owned_max);
	config_watch(&cfg, "vm.toolchain_dir", do_config_string, &mud_config.vm_toolchain_dir);
	config_watch(&cfg, "vm.lib_dir", do_config_string, &mud_config.vm_lib_dir);
	config_watch(&cfg, "vm.include_dir", do_config_string, &mud_config.vm_include_dir);
	config_watch(&cfg, "vm.tmpdir", do_config_string, &mud_config.vm_tmpdir);
	config_watch(&cfg, "cache.obj.size", do_config_uint, &mud_config.obj_cache_size);
	config_watch(&cfg, "cache.character.size", do_config_uint, &mud_config.character_cache_size);
	config_watch(&cfg, "rpg.enabled", do_config_uint, &mud_config.rpg_enabled);
	config_watch(&cfg, "invite.required", do_config_uint, &mud_config.invite_required);
#ifdef CONFIG_LANDLOCK
	config_watch(&cfg, "security.landlock", do_config_uint, &mud_config.security_landlock);
#endif
#ifdef CONFIG_SECCOMP
	config_watch(&cfg, "security.seccomp", do_config_uint, &mud_config.security_seccomp);
#endif
	config_watch(&cfg, "server.daemonize", do_config_uint, &mud_config.daemonize);
	config_watch(&cfg, "server.pidfile", do_config_string, &mud_config.pid_file);
#if !defined(NDEBUG) && !defined(NTEST)
	config_watch(&cfg, "*", mud_config_show, 0);
#endif

	if (!config_load(mud_config.config_filename, &cfg)) {
		config_free(&cfg);
		return 0; /* failure */
	}

	config_free(&cfg);

	return 1; /* success */
}
