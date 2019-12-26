/**
 * @file boris.c
 *
 * A plugin oriented MUD.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @version 0.6
 * @date 2019 Dec 25
 *
 * Copyright (c) 2008-2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */

/* major, minor and patch level for version. */
#define BORIS_VERSION_MAJ 0
#define BORIS_VERSION_MIN 6
#define BORIS_VERSION_PAT 0
/** @mainpage
 *
 * Design Documentation
 *
 *
 * components:
 * - acs_info - access control string
 * - bitfield - manages small staticly sized bitmaps. uses @ref BITFIELD
 * - bitmap - manages large bitmaps
 * - buffer - manages an i/o buffer
 * - channel_group
 * - channel_member
 * - config - represent a configuration parser. uses config_watcher as entries.
 * - dll - low-level api to open modules (.dll or .so). uses @ref dll_open and @ref dll_close
 * - plugin - open plug-ins using dll.
 * - fdb - file database. holds data in regular files.
 * - form - uses formitem.
 * - form_state
 * - freelist - allocate ranges of numbers from a pool. uses freelist_entry and freelist_extent.
 * - heapqueue_elm - priority queue for implementing timers
 * - menuinfo - draws menus to a telnetclient
 * - refcount - macros to provide reference counting. uses @ref REFCOUNT_PUT and @ref REFCOUNT_GET
 * - server - accepts new connections
 * - sha1 - SHA1 hashing.
 * - sha1crypt - SHA1 passwd hashing.
 * - shvar - process $() macros. implemented by @ref shvar_eval.
 * - socketio_handle - manages network sockets
 * - telnetclient - processes data from a socket for Telnet protocol
 * - user - user account handling. see also user_name_map_entry.
 * - util_strfile - holds contents of a textfile in an array.
 *
 * dependency:
 * - socketio_handle - uses ref counts to determine when to free linked lists items
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

#if defined(WIN32)
/** detected a Win32 system, default to using winsock2. */
#define USE_WIN32_SOCKETS

/**
 * tell some compilers to use the library.
 * GCC users will have to specify manually
 */
#ifndef __GNUC__
#pragma comment(lib, "ws2_32.lib")
#endif

#ifndef _WIN32_WINNT
/** require at least NT5.1 API for getaddinfo() and others */
#define _WIN32_WINNT 0x0501
#endif

/** macro used to wrap mkdir() function from UNIX and Windows */
#define MKDIR(d) mkdir(d)
#else
/** detected system with BSD compatible sockets. */
#define USE_BSD_SOCKETS

/** macro used to wrap mkdir() function from UNIX and Windows */
#define MKDIR(d) mkdir(d, 0777)
#endif

/** number of connections that can be queues waiting for accept(). */
#define SOCKETIO_LISTEN_QUEUE 10

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

#if defined(USE_BSD_SOCKETS)
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#elif defined(USE_WIN32_SOCKETS)
#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#error Must define either USE_BSD_SOCKETS or USE_WIN32_SOCKETS
#endif

#include "boris.h"
#include "debug.h"
#include "list.h"
#include "plugin.h"
#include "sha1.h"
#include "sha1crypt.h"
#include "util.h"
#include "config.h"
#include "worldclock.h"
#include "comutil.h"

/******************************************************************************
 * Macros
 ******************************************************************************/
#if !defined(__STDC_VERSION__) || !(__STDC_VERSION__ >= 199901L)
#warning Requires C99
#endif

/*=* General purpose macros *=*/

/** make four ASCII characters into a 32-bit integer. */
#define FOURCC(a,b,c,d)	( \
	((uint_least32_t)(d)<<24) \
	|((uint_least32_t)(c)<<16) \
	|((uint_least32_t)(b)<<8) \
	|(a))

/** _make_name2 is used by VAR and _make_name. */
#define _make_name2(x,y) x##y

/** _make_name is used by var. */
#define _make_name(x,y) _make_name2(x,y)

/** _make_string2 is used by _make_string */
#define _make_string2(x) #x

/** _make_string is used to turn an value into a string. */
#define _make_string(x) _make_string2(x)

/** VAR() is used for making temp variables in macros. */
#define VAR(x) _make_name(x,__LINE__)

#if defined(BORIS_VERSION_PAT) && (BORIS_VERSION_PAT > 0)
/** BORIS_VERSION_STR contains the version as a string. */
#  define BORIS_VERSION_STR \
	_make_string(BORIS_VERSION_MAJ) "." \
	_make_string(BORIS_VERSION_MIN) "p" \
	_make_string(BORIS_VERSION_PAT)
#else
#  define BORIS_VERSION_STR \
	_make_string(BORIS_VERSION_MAJ) "." \
	_make_string(BORIS_VERSION_MIN)
#endif

/* controls how external functions are exported */
#ifndef NDEBUG
/** tag a function as being an exported symbol. */
#define EXPORT
#else
/** fake out the export and keep the functions internal. */
#define EXPORT static
#endif

/*=* Byte-order functions *=*/

/** WRite Big-Endian 32-bit value. */
#define WR_BE32(dest, offset, value) do { \
		unsigned VAR(tmp)=value; \
		(dest)[offset]=(VAR(tmp)/16777216L)%256; \
		(dest)[(offset)+1]=(VAR(tmp)/65536L)%256; \
		(dest)[(offset)+2]=(VAR(tmp)/256)%256; \
		(dest)[(offset)+3]=VAR(tmp)%256; \
	} while (0)

/** WRite Big-Endian 16-bit value. */
#define WR_BE16(dest, offset, value) do { \
		unsigned VAR(tmp)=value; \
		(dest)[offset]=(VAR(tmp)/256)%256; \
		(dest)[(offset)+1]=VAR(tmp)%256; \
	} while (0)

/** WRite Big-Endian 64-bit value. */
#define WR_BE64(dest, offset, value) do { \
		unsigned long long VAR(tmp)=value; \
		(dest)[offset]=((VAR(tmp))>>56)&255; \
		(dest)[(offset)+1]=((VAR(tmp))>>48)&255; \
		(dest)[(offset)+2]=((VAR(tmp))>>40)&255; \
		(dest)[(offset)+3]=((VAR(tmp))>>32)&255; \
		(dest)[(offset)+4]=((VAR(tmp))>>24)&255; \
		(dest)[(offset)+5]=((VAR(tmp))>>16)&255; \
		(dest)[(offset)+6]=((VAR(tmp))>>8)&255; \
		(dest)[(offset)+7]=(VAR(tmp))&255; \
	} while (0)

/** ReaD Big-Endian 16-bit value. */
#define RD_BE16(src, offset) ((((src)[offset]&255u)<<8)|((src)[(offset)+1]&255u))

/** ReaD Big-Endian 32-bit value. */
#define RD_BE32(src, offset) (\
	(((src)[offset]&255ul)<<24) \
	|(((src)[(offset)+1]&255ul)<<16) \
	|(((src)[(offset)+2]&255ul)<<8) \
	|((src)[(offset)+3]&255ul))

/** ReaD Big-Endian 64-bit value. */
#define RD_BE64(src, offset) (\
		(((src)[offset]&255ull)<<56) \
		|(((src)[(offset)+1]&255ull)<<48) \
		|(((src)[(offset)+2]&255ull)<<40) \
		|(((src)[(offset)+3]&255ull)<<32) \
		|(((src)[(offset)+4]&255ull)<<24) \
		|(((src)[(offset)+5]&255ull)<<16) \
		|(((src)[(offset)+6]&255ull)<<8) \
		|((src)[(offset)+7]&255ull))

/*=* Bitfield operations *=*/

/** return in type sized elements to create a bitfield of 'bits' bits. */
#define BITFIELD(bits, type) (((bits)+(CHAR_BIT*sizeof(type))-1)/(CHAR_BIT*sizeof(type)))

/** set bit position 'bit' in bitfield x. */
#define BITSET(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]|=1<<((bit)&((CHAR_BIT*sizeof *(x))-1))

/** clear bit position 'bit' in bitfield x */
#define BITCLR(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]&=~(1<<((bit)&((CHAR_BIT*sizeof *(x))-1)))

/** toggle bit position 'bit' in bitfield x. */
#define BITINV(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]^=1<<((bit)&((CHAR_BIT*sizeof *(x))-1))

/** return a large non-zero number if the bit is set, zero if clear. */
#define BITTEST(x, bit) ((x)[(bit)/((CHAR_BIT*sizeof *(x)))]&(1<<((bit)&((CHAR_BIT*sizeof *(x))-1))))

/** checks that bit is in range for bitfield x. */
#define BITRANGE(x, bit) ((bit)<(sizeof(x)*CHAR_BIT))

/*=* reference counting macros *=*/

/** data type used for reference counting. */
#define REFCOUNT_TYPE int

/** member name used for the refcounting field in a struct. */
#define REFCOUNT_NAME _referencecount

/** initialize the reference count in a struct (passed as obj). */
#define REFCOUNT_INIT(obj) ((obj)->REFCOUNT_NAME=0)

/**
 * decrement the reference count on struct obj, and eval free_action if it is
 * zero or less.
 */
#define REFCOUNT_PUT(obj, free_action) do { \
		assert((obj)->REFCOUNT_NAME>0); \
		if (--(obj)->REFCOUNT_NAME<=0) { \
			free_action; \
		} \
	} while (0)

/** increment the reference count on struct obj. */
#define REFCOUNT_GET(obj) do { (obj)->REFCOUNT_NAME++; } while (0)

/*=* Compiler macros *=*/
#ifdef __GNUC__
/** using GCC, enable special GCC options. */
#define GCC_ONLY(x) x
#else
/** this version defined if not using GCC. */
#define GCC_ONLY(x)
#endif

/** macro to mark function parameters as unused, used to supress warnings. */
#define UNUSED GCC_ONLY(__attribute__((unused)))

/******************************************************************************
 * Types and data structures
 ******************************************************************************/

struct socketio_handle;

struct menuitem;

/** defines a menu. */
struct menuinfo {
	LIST_HEAD(struct, struct menuitem) items;
	char *title;
	size_t title_width;
	struct menuitem *tail;
};

/** defines a form entry. */
struct formitem {
	LIST_ENTRY(struct formitem) item;
	unsigned value_index; /* used to index the form_state->value[] array */
	char *name;
	unsigned flags;
	int (*form_check)(struct telnetclient *cl, const char *str);
	char *description;
	char *prompt;
};

/** current status of a form, list of filled out data. */
struct form_state {
	const struct form *form;
	const struct formitem *curritem;
	unsigned curr_i;
	unsigned nr_value;
	char **value;
	int done;
};

/** defines a form. */
struct form {
	LIST_HEAD(struct, struct formitem) items;
	struct formitem *tail;
	char *form_title;
	void (*form_close)(struct telnetclient *cl, struct form_state *fs);
	unsigned item_count; /* number of items */
	const char *message; /* display this message on start - points to one allocated elsewhere */
};

/******************************************************************************
 * Globals
 ******************************************************************************/

/** login form and main menu. */
static struct menuinfo gamemenu_login, gamemenu_main;

/** global configuration of the mud. */
static struct mud_config {
	char *config_filename;
	char *menu_prompt;
	char *form_prompt;
	char *command_prompt;
	char *msg_errormain;
	char *msg_invalidselection;
	char *msg_invalidusername;
	char *msgfile_noaccount;
	char *msgfile_badpassword;
	char *msg_tryagain;
	char *msg_unsupported;
	char *msg_useralphanumeric;
	char *msg_usercreatesuccess;
	char *msg_userexists;
	char *msg_usermin3;
	char *msg_invalidcommand;
	char *msgfile_welcome;
	unsigned newuser_level;
	unsigned newuser_flags;
	unsigned newuser_allowed; /* true if we're allowing newuser applications */
	char *eventlog_filename;
	char *eventlog_timeformat;
	char *msgfile_newuser_create;
	char *msgfile_newuser_deny;
	char *default_channels;
	unsigned webserver_port;
	char *form_newuser_filename;
	char *plugins;
} mud_config;

/******************************************************************************
 * Prototypes
 ******************************************************************************/
EXPORT void telnetclient_close(struct telnetclient *cl);
EXPORT void menu_show(struct telnetclient *cl, const struct menuinfo *mi);
EXPORT void menu_input(struct telnetclient *cl, const struct menuinfo *mi, const char *line);
static void form_menu_lineinput(struct telnetclient *cl, const char *line);

/******************************************************************************
 * dummy services - functions that are used as a default for services.
 ******************************************************************************/

/**
 * a default log function to use if none is defined.
 */
static void b_log_dummy(int priority UNUSED, const char *domain UNUSED, const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	fprintf(stderr, fmt, ap);
	va_end(ap);
	fputc('\n', stderr); /* assume there is no trainling newline. */
}

/* dummy functions that return failure for everything. */
static int dummy_fdb_domain_init(const char *domain UNUSED)
{
	return 0;
}

static struct fdb_write_handle *dummy_fdb_write_begin(const char *domain UNUSED, const char *id UNUSED)
{
	return NULL;
}

static struct fdb_write_handle *dummy_fdb_write_begin_uint(const char *domain UNUSED, unsigned id UNUSED)
{
	return NULL;
}

static int dummy_fdb_write_pair(struct fdb_write_handle *h UNUSED, const char *name UNUSED, const char *value_str UNUSED)
{
	return 0;
}

static int dummy_fdb_write_format(struct fdb_write_handle *h UNUSED, const char *name UNUSED, const char *value_fmt UNUSED, ...)
{
	return 0;
}

static int dummy_fdb_write_end(struct fdb_write_handle *h UNUSED)
{
	return 0;
}

static void dummy_fdb_write_abort(struct fdb_write_handle *h UNUSED) { }

static struct fdb_read_handle *dummy_fdb_read_begin(const char *domain UNUSED, const char *id UNUSED)
{
	return NULL;
}

static struct fdb_read_handle *dummy_fdb_read_begin_uint(const char *domain UNUSED, unsigned id UNUSED)
{
	return NULL;
}

static int dummy_fdb_read_next(struct fdb_read_handle *h UNUSED, const char **name UNUSED, const char **value UNUSED)
{
	return 0;
}

static int dummy_fdb_read_end(struct fdb_read_handle *h UNUSED)
{
	return 0;
}

static struct fdb_iterator *dummy_fdb_iterator_begin(const char *domain UNUSED)
{
	return NULL;
}

static const char *dummy_fdb_iterator_next(struct fdb_iterator *it UNUSED)
{
	return NULL;
}

static void dummy_fdb_iterator_end(struct fdb_iterator *it UNUSED) { }

/******************************************************************************
 * Services
 ******************************************************************************/

void (*b_log)(int priority, const char *domain, const char *fmt, ...) = b_log_dummy;
struct plugin_fdb_interface fdb = {
	dummy_fdb_domain_init,
	dummy_fdb_write_begin,
	dummy_fdb_write_begin_uint,
	dummy_fdb_write_pair,
	dummy_fdb_write_format,
	dummy_fdb_write_end,
	dummy_fdb_write_abort,
	dummy_fdb_read_begin,
	dummy_fdb_read_begin_uint,
	dummy_fdb_read_next,
	dummy_fdb_read_end,
	dummy_fdb_iterator_begin,
	dummy_fdb_iterator_next,
	dummy_fdb_iterator_end,
};
static const struct plugin_basic_class *fdb_owner;

struct plugin_room_interface room;
static const struct plugin_basic_class *room_owner;

struct plugin_character_interface character;
static const struct plugin_basic_class *character_owner;

struct plugin_channel_interface channel;
static const struct plugin_basic_class *channel_owner;

/**
 * detach the function pointer providing the log service.
 */
int service_detach_log(void (*log)(int priority, const char *domain, const char *fmt, ...))
{
	if (log == b_log) {
		b_log = b_log_dummy;
		return 1;
	}

	return 0; /* was not attached. */
}

/**
 * attach a function pointer to provide log service.
 */
void service_attach_log(void (*log)(int priority, const char *domain, const char *fmt, ...))
{
	b_log = log ? log : b_log_dummy;
}

/**
 * deattach an interface from fdb, but only if class is the current owner.
 * if class is NULL or current owner, sets fdb to use dummy functions.
 */
void service_detach_fdb(const struct plugin_basic_class *cls)
{
	const struct plugin_fdb_interface dummy = {
		dummy_fdb_domain_init,
		dummy_fdb_write_begin,
		dummy_fdb_write_begin_uint,
		dummy_fdb_write_pair,
		dummy_fdb_write_format,
		dummy_fdb_write_end,
		dummy_fdb_write_abort,
		dummy_fdb_read_begin,
		dummy_fdb_read_begin_uint,
		dummy_fdb_read_next,
		dummy_fdb_read_end,
		dummy_fdb_iterator_begin,
		dummy_fdb_iterator_next,
		dummy_fdb_iterator_end,
	};

	if (!cls || fdb_owner == cls) {
		fdb_owner = NULL;
		fdb = dummy;
	}
}

/**
 * attach an interface to fdb.
 */
void service_attach_fdb(const struct plugin_basic_class *cls, const struct plugin_fdb_interface *interface)
{
	fdb_owner = cls;

	if (interface) {
		fdb = *interface;
	}
}

void service_detach_room(const struct plugin_basic_class *cls)
{
	if (!cls || room_owner == cls) {
		room_owner = NULL;
		memset(&room, 0, sizeof room);
	}
}

void service_attach_room(const struct plugin_basic_class *cls, const struct plugin_room_interface *interface)
{
	room_owner = cls;

	if (interface) {
		room = *interface;
	}
}

void service_detach_character(const struct plugin_basic_class *cls)
{
	if (!cls || character_owner == cls) {
		character_owner = NULL;
		memset(&character, 0, sizeof character);
	}
}

void service_attach_character(const struct plugin_basic_class *cls, const struct plugin_character_interface *interface)
{
	character_owner = cls;

	if (interface) {
		character = *interface;
	}
}

void service_detach_channel(const struct plugin_basic_class *cls)
{
	if (!cls || channel_owner == cls) {
		channel_owner = NULL;
		memset(&channel, 0, sizeof channel);
	}
}

void service_attach_channel(const struct plugin_basic_class *cls, const struct plugin_channel_interface *interface)
{
	channel_owner = cls;

	if (interface) {
		channel = *interface;
	}
}

/******************************************************************************
 * name-value parser routines.
 ******************************************************************************/

/**
 * parse a value string into a uint.
 */
int parse_uint(const char *name, const char *value, unsigned *uint_p)
{
	char *endptr;
	assert(uint_p != NULL);

	if (!uint_p) return 0; /* error */

	if (!value || !*value) {
		ERROR_FMT("%s:Empty string", name);
		return 0; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		ERROR_FMT("%s:Not a number", name);
		return 0; /* error - not a number */
	}

	return 1; /* success */
}

/**
 * load a string into str_p, free()ing string at str_p first.
 */
int parse_str(const char *name UNUSED, const char *value, char **str_p)
{
	assert(str_p != NULL);
	assert(value != NULL);

	if (!str_p) return 0; /* error */

	if (*str_p) free(*str_p);

	*str_p = strdup(value);

	if (!*str_p) {
		PERROR("strdup()");
		return 0; /* error */
	}

	return 1; /* success */
}

/**
 * add to an attribute list.
 */
int parse_attr(const char *name, const char *value, struct attr_list *al)
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
int value_set(const char *value, enum value_type type, void *p)
{
	assert(p != NULL);
	assert(value != NULL);

	if (!p || !value) return 0; /* error */

	switch(type) {
	case VALUE_TYPE_STRING: {
		if (*(char**)p) free(*(char**)p);

		*(char**)p = strdup(value);

		if (!*(char**)p) {
			PERROR("strdup()");
			return 0; /* error */
		}

		return 1; /* success */
	}

	case VALUE_TYPE_UINT: {
		char *endptr;

		if (!*value) {
			ERROR_MSG("Empty string");
			return 0; /* error - empty string */
		}

		*(unsigned*)p = strtoul(value, &endptr, 0);

		if (*endptr != 0) {
			ERROR_FMT("Not a number:\"%s\"\n", value);
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
const char *value_get(enum value_type type, void *p)
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
 * DLL / Plug-in routines.
 ******************************************************************************/

#ifdef WIN32
#include <windows.h>
/**
 * handle for an open DLL used by dll_open() and dll_close().
 */
typedef HMODULE dll_handle_t;
typedef FARPROC dll_func_t;
typedef void *dll_symbol_t;
#define SOEXT ".dll"
#else
#include <dlfcn.h>
/**
 * handle for an open DLL used by dll_open() and dll_close().
 */
typedef struct {
	void *h;
} dll_handle_t;
typedef int (*dll_func_t)();
typedef void *dll_symbol_t;
#ifdef __APPLE__
#define SOEXT ".dylib"
#else
#define SOEXT ".so"
#endif
#endif

/**
 * internal function for reporting errors on last operation with a DLL.
 * @see dll_open dll_close
 */
static void dll_show_error(const char *reason)
{
#ifdef WIN32
	LPTSTR lpMsgBuf;
	FormatMessage(
	        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM
	        | FORMAT_MESSAGE_IGNORE_INSERTS, NULL, GetLastError(),
	        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPTSTR)&lpMsgBuf, 0, NULL);

	if (reason) {
		fprintf(stderr, "%s:%s\n", reason, lpMsgBuf);
	} else {
		fprintf(stderr, "%s\n", lpMsgBuf);
	}

	LocalFree(lpMsgBuf);
#else
	const char *msg;
	msg = dlerror();

	if (msg) {
		if (reason) {
			fprintf(stderr, "%s:%s\n", reason, msg);
		} else {
			fprintf(stderr, "%s\n", msg);
		}
	}

#endif
}

/**
 * opens a file and updates the handle at h.
 * file extension is optional, and it is best not to specify it.
 * @param h pointer to the handle to be updated. set to NULL on failure.
 * @param filename name of the DLL file to open. should not contain an
 *                 extension, that will be added.
 * @return non-zero on success, 0 on failure.
 * @see dll_close
 */
EXPORT int dll_open(dll_handle_t *h, const char *filename)
{
	char path[PATH_MAX];
#ifdef WIN32
	unsigned i;

	/* convert / to \ in the filename, as required by LoadLibrary(). */
	for (i = 0; filename[i] && i < sizeof path - 1; i++) {
		path[i] = filename[i] == '/' ? '\\' : filename[i];
	}

	path[i] = 0; /* null terminate */

	if (!strstr(filename, SOEXT)) {
		strcat(path, SOEXT);
	}

	/* TODO: convert filename to windows text encoding */
	*h = LoadLibrary(filename);

	if (!*h) {
#else
	strcpy(path, filename);

	if (!strstr(filename, SOEXT)) {
		strcat(path, SOEXT);
	}

	TRACE("dlopen(%s)\n", path);
	h->h = dlopen(path, RTLD_NOW | RTLD_LOCAL);

	if (!h->h) {
#endif
		dll_show_error(path);
		return 0;
	}

	return 1;
}

/**
 * closes an open DLL file handle. ignores NULL handles.
 * @param h handle to close
 * @see dll_open
 */
EXPORT void dll_close(dll_handle_t h)
{
#ifdef WIN32

	if (h.h) {
		if (!FreeLibrary(h)) {
			dll_show_error("FreeLibrary()");
		}
	}

#else

	if (h.h) {
		if (dlclose(h.h)) {
			dll_show_error("dlclose()");
		}
	}

#endif
}

/**
 * get a function's address from a DLL.
 * name must by a symbol name for a function.
 * @param h handle
 * @param name a symbol name, must be a function.
 * @return NULL on error. address of exported symbol on success.
 */
EXPORT dll_symbol_t dll_symbol(dll_handle_t h, const char *name)
{
	dll_symbol_t ret;
#ifdef WIN32
	ret = GetProcAddress(h, name);
#else
	ret = dlsym(h.h, name);
#endif

	if (!ret) {
		dll_show_error(name);
	}

	return ret;
}

/* not used at this time. */
#if 0
EXPORT dll_func_t dll_func(dll_handle_t h, const char *name)
{
	return (int(*)())dll_symbol(h, name);
}
#endif

/******************************************************************************
 * Debug and test routines
 ******************************************************************************/

/* enable these routines unless both NDEBUG and NTEST are defined.
 * if debugging or testing is enabled then we need some of these functions.
 */
#if !defined(NTEST) || !defined(NDEBUG)
/**
 * debug routine to convert a number to a string.
 * @param n the value.
 * @param base the output base (2 to 64)
 * @param pad length to use when padding with zeros. 0 means do not pad.
 */
static const char *util_convertnumber(unsigned n, unsigned base, unsigned pad)
{
	static char number_buffer[65];
	static const char tab[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-";
	char *o; /* output */
	size_t len;

	if (base < 2) base = 2;

	if (base > sizeof tab) base = sizeof tab;

	o = number_buffer + sizeof number_buffer;
	*--o = 0;

	do {
		*--o = tab[n % base];
		n /= base;
	} while (n);

	len = number_buffer + sizeof number_buffer - 1 - o;

	if (pad && len < pad) {
		for (pad = pad - len; pad; pad--) {
			*--o = tab[0];
		}
	}

	return o;
}

/**
 * debug routine to hexdump some bytes.
 * @param f output file stream.
 * @param data pointer to the data.
 * @param len length to hexdump.
 */
static void util_hexdump(FILE *f, const void *data, int len)
{
	fprintf(f, "[%d]", len);

	while (len > 0) {
		unsigned char ch = *(unsigned char*)data;

		if (isprint(ch)) {
			fprintf(f, " '%c'", ch);
		} else {
			fprintf(f, " 0x%02hhx", ch);
		}

		len--;
		data = ((unsigned char*)data) + 1;
	}

	fprintf(f, "\n");
}
#endif

/******************************************************************************
 * shvar - shell variables
 ******************************************************************************/

/** maximum number of characters in a $(). */
#define SHVAR_ID_MAX 128

/** escape character used. */
#define SHVAR_ESCAPE '$'

/** evaluate "shell variables", basically expand ${FOO} in a string. */
EXPORT int shvar_eval(char *out, size_t len, const char *src, const char *(*match)(const char *key))
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
 * heapqueue - a binary heap used as a priority queue
 ******************************************************************************/

/** the left child of i. */
#define HEAPQUEUE_LEFT(i) (2*(i)+1)

/** the right child of i. */
#define HEAPQUEUE_RIGHT(i) (2*(i)+2)

/** the parent of i. i should be signed else the parent of the root will be a
 * little weird.*/
#define HEAPQUEUE_PARENT(i) (((i)-1)/2)

/** element in the heapqueue. */
struct heapqueue_elm {
	unsigned d; /* key */
	/** @todo put useful data in here */
};

/** heap of 512 entries max. */
static struct heapqueue_elm heap[512];

/** currently used length of the heap. */
static unsigned heap_len;

/**
 * min heap is sorted by lowest value at root.
 * @return non-zero if a>b
 */
static inline int heapqueue_greaterthan(struct heapqueue_elm *a, struct heapqueue_elm *b)
{
	assert(a != NULL);
	assert(b != NULL);
	return a->d > b->d;
}

/**
 * @param i the "hole" location
 * @param elm the value to compare against
 * @return new position of hole
 */
static int heapqueue_ll_siftdown(unsigned i, struct heapqueue_elm *elm)
{
	assert(elm != NULL);
	assert(i < heap_len || i == 0);

	while (HEAPQUEUE_LEFT(i) < heap_len) { /* keep going until at a leaf node */
		unsigned child = HEAPQUEUE_LEFT(i);

		/* compare left and right(child+1) - use the smaller of the two */
		if (child + 1 < heap_len && heapqueue_greaterthan(&heap[child], &heap[child + 1])) {
			child++; /* left is bigger than right, use right */
		}

		/* child is the smallest child, if elm is smaller or equal then we're done */
		if (!(heapqueue_greaterthan(elm, &heap[child]))) { /* elm <= child */
			break;
		}

		/* swap "hole" and selected child */
		TRACE("swap hole %d with entry %d\n", i, child);
		heap[i] = heap[child];
		i = child;
	}

	TRACE("chosen position %d for hole.\n", i);
	return i;
}

/**
 * @param i the "hole" location
 * @param elm the value to compare against
 * @return the new position of the hole
 */
static int heapqueue_ll_siftup(unsigned i, struct heapqueue_elm *elm)
{
	assert(elm != NULL);
	assert(i < heap_len);

	while (i > 0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], elm)) { /* Compare the element with parent */
		/* swap element with parent and keep going (keep tracking the "hole") */
		heap[i] = heap[HEAPQUEUE_PARENT(i)];
		i = HEAPQUEUE_PARENT(i);
	}

	return i;
}

/**
 * removes entry at i. */
EXPORT int heapqueue_cancel(unsigned i, struct heapqueue_elm *ret)
{
	/* 1. copy the value at i into ret
	 * 2. put last node into empty position
	 * 3. sift-up if moved node smaller than parent, sift-down if larger than either child
	 */
	struct heapqueue_elm *last;
	assert(ret != NULL);
	assert(i < heap_len);
	assert(heap_len < NR(heap));
	*ret = heap[i]; /* copy the value at i into ret */
	TRACE("canceling entry #%d: val=%d (parent=%d:>%u) (left %d:>%u) (right %d:>%u) (last %d)\n",
	      i, ret->d,
	      i > 0 ? (int)HEAPQUEUE_PARENT(i) : -1,
	      i > 0 ? heap[HEAPQUEUE_PARENT(i)].d : 0,
	      HEAPQUEUE_LEFT(i) < heap_len ? (int)HEAPQUEUE_LEFT(i) : -1,
	      HEAPQUEUE_LEFT(i) < heap_len ? heap[HEAPQUEUE_LEFT(i)].d : 0,
	      HEAPQUEUE_RIGHT(i) < heap_len ? (int)HEAPQUEUE_RIGHT(i) : -1,
	      HEAPQUEUE_RIGHT(i) < heap_len ? heap[HEAPQUEUE_RIGHT(i)].d : 0,
	      heap[heap_len - 1].d
	     );

	/* move last entry to the empty position */
	heap_len--;
	last = &heap[heap_len];

	/* i now holds the position of the last entry, we will move this "hole" until
	 * it is in the correct place for last */

	if (i > 0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], last)) {
		/* we already did the compare, so we'll perform the first move here */
		TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_PARENT(i));
		heap[i] = heap[HEAPQUEUE_PARENT(i)]; /* move parent down */
		i = heapqueue_ll_siftup(HEAPQUEUE_PARENT(i), last); /* sift the "hole" up */
	} else if (HEAPQUEUE_RIGHT(i) < heap_len && (heapqueue_greaterthan(last, &heap[HEAPQUEUE_RIGHT(i)]) || heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)]))) {
		/* if right is on the list, then left is as well */
		if (heapqueue_greaterthan(&heap[HEAPQUEUE_LEFT(i)], &heap[HEAPQUEUE_RIGHT(i)])) {
			/* left is larger - use the right hole */
			TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_RIGHT(i));
			heap[i] = heap[HEAPQUEUE_RIGHT(i)]; /* move right up */
			i = heapqueue_ll_siftdown(HEAPQUEUE_RIGHT(i), last); /* sift the "hole" down */
		} else {
			/* right is the larger or equal - use the left hole */
			TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_LEFT(i));
			heap[i] = heap[HEAPQUEUE_LEFT(i)]; /* move left up */
			i = heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
		}
	} else if (HEAPQUEUE_LEFT(i) < heap_len && heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)])) {
		/* at this point there is no right node */
		TRACE("swap hole %d with entry %d\n", i, HEAPQUEUE_LEFT(i));
		heap[i] = heap[HEAPQUEUE_LEFT(i)]; /* move left up */
		i = heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
	}

	heap[i] = *last;
	return 1;
}

/**
 * sift-up operation for enqueueing.
 * -# Add the element on the bottom level of the heap.
 * -# Compare the added element with its parent; if they are in the correct order, stop.
 * -# If not, swap the element with its parent and return to the previous step.
 */
EXPORT void heapqueue_enqueue(struct heapqueue_elm *elm)
{
	unsigned i;
	assert(elm != NULL);
	assert(heap_len < NR(heap));

	i = heap_len++; /* add the element to the bottom of the heap (create a "hole") */
	i = heapqueue_ll_siftup(i, elm);
	heap[i] = *elm; /* fill in the "hole" */
}

/**
 * sift-down operation for dequeueing.
 * removes the root entry and copies it to ret.
 */
EXPORT int heapqueue_dequeue(struct heapqueue_elm *ret)
{
	unsigned i;
	assert(ret != NULL);

	if (heap_len <= 0)
		return 0; /* nothing to dequeue */

	*ret = heap[0]; /* we have to copy the root element somewhere because we're removing it */

	/* move last entry to the root, then sift-down */
	heap_len--;
	i = heapqueue_ll_siftdown(0, &heap[heap_len]);
	heap[i] = heap[heap_len];
	return 1;
}

#ifndef NTEST

/**
 * checks the heap to see that it is valid.
 */
static int heapqueue_isvalid(void)
{
	unsigned i;

	for (i = 1; i < heap_len; i++) {
		if (heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], &heap[i])) {
			DEBUG("Bad heap at %d\n", i);
			return 0; /* not a valid heap */
		}
	}

	return 1; /* success */
}

/** dump the entire heapqueue data structure to stderr. */
static void heapqueue_dump(void)
{
	unsigned i;
	fprintf(stderr, "::: Dumping heapqueue :::\n");

	for (i = 0; i < heap_len; i++) {
		printf("%03u = %4u (p:%d l:%d r:%d)\n", i, heap[i].d, i > 0 ? (int)HEAPQUEUE_PARENT(i) : -1, HEAPQUEUE_LEFT(i), HEAPQUEUE_RIGHT(i));
	}

	printf("heap valid? %d (%d entries)\n", heapqueue_isvalid(), heap_len);
}

/** test the heapqueue system. */
EXPORT void heapqueue_test(void)
{
	struct heapqueue_elm elm, tmp;
	unsigned i;
	const unsigned testdata[] = {
		42, 2, 123, 88, 3, 3, 3, 3, 3, 1, 0,
	};

	/* initialize the array */
	heap_len = 0;
#ifndef NDEBUG

	/* fill remaining with fake data */
	for (i = heap_len; i < NR(heap); i++) {
		heap[i].d = 0xdead;
	}

#endif

	for (i = 0; i < NR(testdata); i++) {
		elm.d = testdata[i];
		heapqueue_enqueue(&elm);
	}

	heapqueue_dump();

	/* test the cancel function and randomly delete everything */
	while (heap_len > 0) {
		unsigned valid;
		i = rand() % heap_len;

		if (heapqueue_cancel(i, &tmp)) {
			printf("canceled at %d (data=%d)\n", i, tmp.d);
		} else {
			printf("canceled at %d failed!\n", i);
			break;
		}

		// heapqueue_dump();
		valid = heapqueue_isvalid();

		// printf("heap valid? %d (%d entries)\n", valid, heap_len);
		if (!valid) {
			printf("BAD HEAP!!!\n");
			heapqueue_dump();
			break;
		}
	}

	heapqueue_dump();

	/* load the queue with test data again */
	for (i = 0; i < NR(testdata); i++) {
		elm.d = testdata[i];
		heapqueue_enqueue(&elm);
	}

	/* do a normal dequeue of everything */
	while (heapqueue_dequeue(&tmp)) {
		printf("removed head (data=%d)\n", tmp.d);
	}

	heapqueue_dump();
}
#endif

/******************************************************************************
 * Freelist
 ******************************************************************************/

/** range of numbers used to represent part of the freelist. */
struct freelist_extent {
	unsigned length, offset; /* both are in block-sized units */
};

/** linked list entry in the freelist (holds an extent). */
struct freelist_entry {
	LIST_ENTRY(struct freelist_entry) global; /* global list */
	struct freelist_extent extent;
};

#if !defined(NTEST) || !defined(NDEBUG)
/** print a freelist to stderr. */
static void freelist_dump(struct freelist *fl)
{
	struct freelist_entry *curr;
	unsigned n;
	fprintf(stderr, "::: Dumping freelist :::\n");

	for (curr = LIST_TOP(fl->global), n = 0; curr; curr = LIST_NEXT(curr, global), n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}
}
#endif

/**
 * lowlevel - detach and free an entry.
 */
static void freelist_ll_free(struct freelist_entry *e)
{
	assert(e != NULL);
	assert(e->global._prev != NULL);
	assert(e->global._prev != (void*)0x99999999);
	LIST_REMOVE(e, global);
#ifndef NDEBUG
	memset(e, 0x99, sizeof * e); /* fill with fake data before freeing */
#endif
	free(e);
}

/**
 * lowlevel - append an extra to the global list at prev
 */
static struct freelist_entry *freelist_ll_new(struct freelist_entry **prev, unsigned ofs, unsigned count)
{
	struct freelist_entry *new;
	assert(prev != NULL);
	assert(prev != (void*)0x99999999);
	new = malloc(sizeof * new);
	assert(new != NULL);

	if (!new) {
		PERROR("malloc()");
		return 0;
	}

	new->extent.offset = ofs;
	new->extent.length = count;
	LIST_INSERT_ATPTR(prev, new, global);
	return new;
}

/**
 * checks two extents and determine if they are immediately adjacent.
 * @returns true if a bridge is detected.
 */
static int freelist_ll_isbridge(struct freelist_extent *prev_ext, unsigned ofs, unsigned count, struct freelist_extent *next_ext)
{
	/*
	DEBUG("testing for bridge:\n"
			"  last:%6d+%d curr:%6d+%d ofs:%6d+%d\n",
			prev_ext->offset, prev_ext->length, next_ext->offset, next_ext->length,
			ofs, count
	);
	*/
	return prev_ext->offset + prev_ext->length == ofs && next_ext->offset == ofs + count;
}

/** initialize a freelist. starts off as empty. */
void freelist_init(struct freelist *fl)
{
	LIST_INIT(&fl->global);
}

/** deallocate all entries on the freelist. */
void freelist_free(struct freelist *fl)
{
	while (LIST_TOP(fl->global)) {
		freelist_ll_free(LIST_TOP(fl->global));
	}

	assert(LIST_TOP(fl->global) == NULL);
}

/** allocate memory from the pool.
 * @return offset of the allocation. return -1 on failure.
 */
long freelist_alloc(struct freelist *fl, unsigned count)
{
	struct freelist_entry *curr;

	/* find the first entry that is big enough */
	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		if (curr->extent.length >= count) {
			unsigned ofs;
			ofs = curr->extent.offset;
			curr->extent.offset += count;
			curr->extent.length -= count;

			if (curr->extent.length == 0) {
				freelist_ll_free(curr);
			}

			return ofs; /* success */
		}
	}

	return -1; /* failure */
}

/** adds a piece to the freelist pool.
 *
 * . allocated
 * _ empty
 * X new entry
 *
 * |.....|_XXX_|......|		normal
 * |.....|_XXX|.......|		grow-next
 * |......|XXX_|......|		grow-prev
 * |......|XXX|.......|		bridge
 *
 * WARNING: passing bad parameters will result in strange data in the list
 */
void freelist_pool(struct freelist *fl, unsigned ofs, unsigned count)
{
	struct freelist_entry *new, *curr, *last;

	TRACE_ENTER();

	assert(count != 0);

	last = NULL;
	new = NULL;

	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		assert(curr != last);
		assert(curr != (void*)0x99999999);

		if (last) {
			assert(LIST_NEXT(last, global) == curr); /* sanity check */
		}

		/*
		printf(
			"c.ofs:%6d c.len:%6d l.ofs:%6d l.len:%6d ofs:%6d len:%6d\n",
			curr->extent.offset, curr->extent.length,
			last ? last->extent.offset : -1, last ? last->extent.length : -1,
			ofs, count
		);
		*/

		if (ofs == curr->extent.offset) {
			ERROR_FMT("overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
			TODO("make something out of this");
			DIE();
		} else if (last && freelist_ll_isbridge(&last->extent, ofs, count, &curr->extent)) {
			/* |......|XXX|.......|		bridge */
			DEBUG("|......|XXX|.......|		bridge. last=%u+%u curr=%u+%u new=%u+%u\n", last->extent.length, last->extent.offset, curr->extent.offset, curr->extent.length, ofs, count);
			/* we are dealing with 3 entries, the last, the new and the current */
			/* merge the 3 entries into the last entry */
			last->extent.length += curr->extent.length + count;
			assert(LIST_PREVPTR(curr, global) == &LIST_NEXT(last, global));
			freelist_ll_free(curr);
			assert(LIST_TOP(fl->global) != curr);
			assert(LIST_NEXT(last, global) != (void*)0x99999999);
			assert(LIST_NEXT(last, global) != curr); /* deleting it must take it off the list */
			new = curr = last;
			break;
		} else if (curr->extent.offset == ofs + count) {
			/* |.....|_XXX|.......|		grow-next */
			DEBUG("|.....|_XXX|.......|		grow-next. curr=%u+%u new=%u+%u\n", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge new entry into a following entry */
			curr->extent.offset = ofs;
			curr->extent.length += count;
			new = curr;
			break;
		} else if (last && curr->extent.offset + curr->extent.length == ofs) {
			/* |......|XXX_|......|		grow-prev */
			DEBUG("|......|XXX_|......|		grow-prev. curr=%u+%u new=%u+%u\n", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge the new entry into the end of the previous entry */
			curr->extent.length += count;
			new = curr;
			break;
		} else if (ofs < curr->extent.offset) {
			if (ofs + count > curr->extent.offset) {
				ERROR_FMT("overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
				TODO("make something out of this");
				DIE();
			}

			DEBUG("|.....|_XXX_|......|		normal new=%u+%u\n", ofs, count);
			/* create a new entry */
			new = freelist_ll_new(LIST_PREVPTR(curr, global), ofs, count);
			break;
		}

		last = curr; /* save this for finding a bridge */
	}

	if (!curr) {
		if (last) {
			if (last->extent.offset + last->extent.length == ofs) {
				DEBUG("|......|XXX_|......|		grow-prev. last=%u+%u new=%u+%u\n", last->extent.offset, last->extent.length, ofs, count);
				last->extent.length += count;
				new = last;
			} else {
				DEBUG("|............|XXX  |		end. new=%u+%u\n", ofs, count);
				new = freelist_ll_new(&LIST_NEXT(last, global), ofs, count);
			}
		} else {
			DEBUG("|XXX               |		initial. new=%u+%u\n", ofs, count);
			new = freelist_ll_new(&LIST_TOP(fl->global), ofs, count);
		}
	}
}

/**
 * allocates a particular range on a freelist.
 * (assumes that freelist_pool assembles adjacent regions into the largest
 * possible contigious spaces)
 */
int freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count)
{
	struct freelist_entry *curr;

	assert(count != 0);

	DEBUG("thwacking %u:%u\n", ofs, count);

#ifndef NDEBUG
	freelist_dump(fl);
#endif

	for (curr = LIST_TOP(fl->global); curr; curr = LIST_NEXT(curr, global)) {
		DEBUG("checking for %u:%u in curr=%u:%u\n", ofs, count, curr->extent.offset, curr->extent.length);

		if (curr->extent.offset <= ofs && curr->extent.offset + curr->extent.length >= ofs + count) {
			TRACE("Found entry to thwack at %u:%u for %u:%u\n", curr->extent.offset, curr->extent.length, ofs, count);

			/* four possible cases:
			 * 1. heads and lengths are the same - free extent
			 * 2. heads are the same, but lengths differ - chop head and shrink
			 * 3. tails are the same - shrink
			 * 4. extent gets split into two extents
			 */
			if (curr->extent.offset == ofs && curr->extent.length == count) {
				/* 1. heads and lengths are the same - free extent */
				freelist_ll_free(curr);
				return 1; /* success */
			} else if (curr->extent.offset == ofs) {
				/* 2. heads are the same, but lengths differ - slice off head */
				curr->extent.offset += count;
				curr->extent.length -= count;
				return 1; /* success */
			} else if ((curr->extent.offset + curr->extent.length) == (ofs + count)) {
				/* 3. tails are the same - shrink */
				curr->extent.length -= count;
				return 1; /* success */
			} else { /* 4. extent gets split into two extents */
				struct freelist_extent new; /* second part */

				/* make curr the first part, and create a new one after
				 * ofs:count for the second */

				new.offset = ofs + count;
				new.length = (curr->extent.offset + curr->extent.length) - new.offset;
				DEBUG("ofs=%d curr.offset=%d\n", ofs, curr->extent.offset);
				assert(curr->extent.length >= count + new.length);
				curr->extent.length -= count;
				curr->extent.length -= new.length;
				freelist_pool(fl, new.offset, new.length);
				return 1; /* success */
			}

			DEBUG_MSG("Should not be possible to get here");
			DIE();
		}
	}

	DEBUG_MSG("failed.");
	return 0; /* failure */
}

#ifndef NTEST
/** test the freelist. */
EXPORT void freelist_test(void)
{
	struct freelist fl;
	unsigned n;
	freelist_init(&fl);
	fprintf(stderr, "::: Making some fragments :::\n");

	for (n = 0; n < 60; n += 12) {
		freelist_pool(&fl, n, 6);
	}

	fprintf(stderr, "::: Filling in gaps :::\n");

	for (n = 0; n < 60; n += 12) {
		freelist_pool(&fl, n + 6, 6);
	}

	fprintf(stderr, "::: Walking backwards :::\n");

	for (n = 120; n > 60;) {
		n -= 6;
		freelist_pool(&fl, n, 6);
	}

	freelist_dump(&fl);

	/* test freelist_alloc() */
	fprintf(stderr, "::: Allocating :::\n");

	for (n = 0; n < 60; n += 6) {
		long ofs;
		ofs = freelist_alloc(&fl, 6);
		TRACE("alloc: %lu+%u\n", ofs, 6);
	}

	freelist_dump(&fl);

	fprintf(stderr, "::: Allocating :::\n");

	for (n = 0; n < 60; n += 6) {
		long ofs;
		ofs = freelist_alloc(&fl, 6);
		TRACE("alloc: %lu+%u\n", ofs, 6);
	}

	freelist_dump(&fl);
	fprintf(stderr, "<freelist should be empty>\n");

	freelist_pool(&fl, 1003, 1015);

	freelist_dump(&fl);

	freelist_thwack(&fl, 1007, 1005);

	freelist_thwack(&fl, 2012, 6);

	freelist_thwack(&fl, 1003, 4);

	freelist_dump(&fl);
	fprintf(stderr, "<freelist should be empty>\n");

	freelist_free(&fl);
}
#endif

/******************************************************************************
 * eventlog - writes logging information based on events
 ******************************************************************************/
/*-* eventlog:globals *-*/

/** output file used for eventlogging. */
static FILE *eventlog_file;

/*-* eventlog:internal functions *-*/

/*-* eventlog:external functions *-*/

/**
 * initialize the eventlog component.
 */
EXPORT int eventlog_init(void)
{
	eventlog_file = fopen(mud_config.eventlog_filename, "a");

	if (!eventlog_file) {
		PERROR(mud_config.eventlog_filename);
		return 0; /* failure */
	}

	setvbuf(eventlog_file, NULL, _IOLBF, 0);

	return 1; /* success */
}

/** clean up eventlog module and close the logging file. */
EXPORT void eventlog_shutdown(void)
{
	if (eventlog_file) {
		fclose(eventlog_file);
		eventlog_file = 0;
	}
}

/** log a message to the eventlog. */
EXPORT void eventlog(const char *type, const char *fmt, ...)
{
	va_list ap;
	char buf[512];
	int n;
	time_t t;
	char timestamp[64];

	va_start(ap, fmt);
	n = vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);

	if (n < 0) {
		ERROR_MSG("vsnprintf() failure");
		return; /* failure */
	}

	if (n >= (int)sizeof buf) { /* output was truncated */
		n = strlen(buf);
	}

	/* make certain the last character is a newline */
	if (n > 0 && buf[n - 1] != '\n') {
		if (n == sizeof buf) n--;

		buf[n] = '\n';
		buf[n + 1] = 0;
		DEBUG_MSG("Adding newline to message");
	}

	time(&t);
	strftime(timestamp, sizeof timestamp, mud_config.eventlog_timeformat, gmtime(&t));

	if (fprintf(eventlog_file ? eventlog_file : stderr, "%s:%s:%s", timestamp, type, buf) < 0) {
		/* there was a write error */
		PERROR(eventlog_file ? mud_config.eventlog_filename : "stderr");
	}
}

/**
 * report that a connection has occured.
 */
EXPORT void eventlog_connect(const char *peer_str)
{
	eventlog("CONNECT", "remote=%s\n", peer_str);
}

/** report the startup of the server. */
EXPORT void eventlog_server_startup(void)
{
	eventlog("STARTUP", "\n");
}

/** report the shutdown of the server. */
EXPORT void eventlog_server_shutdown(void)
{
	eventlog("SHUTDOWN", "\n");
}

/** report a failed login attempt. */
EXPORT void eventlog_login_failattempt(const char *username, const char *peer_str)
{
	eventlog("LOGINFAIL", "remote=%s name='%s'\n", peer_str, username);
}

/** report a successful login(sign-on) to eventlog. */
EXPORT void eventlog_signon(const char *username, const char *peer_str)
{
	eventlog("SIGNON", "remote=%s name='%s'\n", peer_str, username);
}

/** report a signoff to the eventlog. */
EXPORT void eventlog_signoff(const char *username, const char *peer_str)
{
	eventlog("SIGNOFF", "remote=%s name='%s'\n", peer_str, username);
}

/** report that a connection was rejected because there are already too many
 * connections. */
EXPORT void eventlog_toomany(void)
{
	/** @todo we could get the peername from the fd and log that? */
	eventlog("TOOMANY", "\n");
}

/**
 * log commands that a user enters.
 */
EXPORT void eventlog_commandinput(const char *remote, const char *username, const char *line)
{
	eventlog("COMMAND", "remote=\"%s\" user=\"%s\" command=\"%s\"\n", remote, username, line);
}

/** report that a new public channel was created. */
EXPORT void eventlog_channel_new(const char *channel_name)
{
	eventlog("CHANNEL-NEW", "channel=\"%s\"\n", channel_name);
}

/** report that a public channel was removed. */
EXPORT void eventlog_channel_remove(const char *channel_name)
{
	eventlog("CHANNEL-REMOVE", "channel=\"%s\"\n", channel_name);
}

/** report a user joining a public channel. */
EXPORT void eventlog_channel_join(const char *remote, const char *channel_name, const char *username)
{
	if (!remote) {
		eventlog("CHANNEL-JOIN", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-JOIN", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/** report a user leaving a public channel. */
EXPORT void eventlog_channel_part(const char *remote, const char *channel_name, const char *username)
{
	if (!remote) {
		eventlog("CHANNEL-PART", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-PART", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/**
 * logs an HTTP GET action.
 */
EXPORT void eventlog_webserver_get(const char *remote, const char *uri)
{
	eventlog("WEBSITE-GET", "remote=\"%s\" uri=\"%s\"\n", remote ? remote : "", uri ? uri : "");
}
/******************************************************************************
 * Bitmap API
 ******************************************************************************/

/** size in bits of a group of bits for struct bitmap. */
#define BITMAP_BITSIZE (sizeof(unsigned)*CHAR_BIT)

/**
 * a large bitarray that can be allocated to any size.
 * @see bitmap_init bitmap_free bitmap_resize bitmap_clear bitmap_set
 *      bitmap_next_set bitmap_next_clear bitmap_loadmem bitmap_length
 *      bitmap_test
 */
struct bitmap {
	unsigned *bitmap;
	size_t bitmap_allocbits;
};

/**
 * initialize an bitmap structure to be empty.
 */
EXPORT void bitmap_init(struct bitmap *bitmap)
{
	assert(bitmap != NULL);
	bitmap->bitmap = 0;
	bitmap->bitmap_allocbits = 0;
}

/**
 * free a bitmap structure.
 */
EXPORT void bitmap_free(struct bitmap *bitmap)
{
	assert(bitmap != NULL); /* catch when calling free on NULL */

	if (bitmap) {
		free(bitmap->bitmap);
		bitmap_init(bitmap);
	}
}

/**
 * resize (grow or shrink) a struct bitmap.
 * @param bitmap the bitmap structure.
 * @param newbits is in bits (not bytes).
 */
EXPORT int bitmap_resize(struct bitmap *bitmap, size_t newbits)
{
	unsigned *tmp;

	newbits = ROUNDUP(newbits, BITMAP_BITSIZE);
	DEBUG("Allocating %zd bytes\n", newbits / CHAR_BIT);
	tmp = realloc(bitmap->bitmap, newbits / CHAR_BIT);

	if (!tmp) {
		PERROR("realloc()");
		return 0; /* failure */
	}

	if (bitmap->bitmap_allocbits < newbits) {
		/* clear out the new bits */
		size_t len;
		len = (newbits - bitmap->bitmap_allocbits) / CHAR_BIT;
		DEBUG("Clearing %zd bytes (ofs %zd)\n", len, bitmap->bitmap_allocbits / BITMAP_BITSIZE);
		memset(tmp + bitmap->bitmap_allocbits / BITMAP_BITSIZE, 0, len);
	}

	bitmap->bitmap = tmp;
	bitmap->bitmap_allocbits = newbits;
	return 1; /* success */
}

/**
 * set a range of bits to 0.
 * @param bitmap the bitmap structure.
 * @param ofs first bit to clear.
 * @param len number of bits to clear.
 */
EXPORT void bitmap_clear(struct bitmap *bitmap, unsigned ofs, unsigned len)
{
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if (ofs + len > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs + len);
	}

	p = bitmap->bitmap + ofs / BITMAP_BITSIZE; /* point to the first word */

	head_ofs = ofs % BITMAP_BITSIZE;
	head_len = len > BITMAP_BITSIZE - ofs ? BITMAP_BITSIZE - ofs : len;

	/* head */
	if (head_len < BITMAP_BITSIZE) {
		len -= head_len;
		mask = ~(~((~0U) << head_len) << head_ofs);
		*p++ &= mask;
	}

	for (; len >= BITMAP_BITSIZE; len -= BITMAP_BITSIZE) {
		*p++ = 0U;
	}

	if (len > 0) {
		/* tail */
		mask = ~((~0U) >> (BITMAP_BITSIZE - len));
		mask = (~0U) >> len;
		*p &= mask;
	}
}

/**
 * set a range of bits to 1.
 * @param bitmap the bitmap structure.
 * @param ofs first bit to set.
 * @param len number of bits to set.
 */
EXPORT void bitmap_set(struct bitmap *bitmap, unsigned ofs, unsigned len)
{
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if (ofs + len > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs + len);
	}

	p = bitmap->bitmap + ofs / BITMAP_BITSIZE; /* point to the first word */

	head_ofs = ofs % BITMAP_BITSIZE;
	head_len = len > BITMAP_BITSIZE - ofs ? BITMAP_BITSIZE - ofs : len;

	/* head */
	if (head_len < BITMAP_BITSIZE) {
		len -= head_len;
		mask = (~((~0U) << head_len)) << head_ofs;
		*p++ |= mask;
	}

	for (; len >= BITMAP_BITSIZE; len -= BITMAP_BITSIZE) {
		*p++ = ~0U;
	}

	if (len > 0) {
		/* tail */
		mask = (~0U) >> (BITMAP_BITSIZE - len);
		*p |= mask;
	}
}

/**
 * gets a single bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit.
 * @return 0 or 1 depending on value of the bit.
 */
EXPORT int bitmap_get(struct bitmap *bitmap, unsigned ofs)
{
	if (ofs < bitmap->bitmap_allocbits) {
		return (bitmap->bitmap[ofs / BITMAP_BITSIZE] >> (ofs % BITMAP_BITSIZE)) & 1;
	} else {
		return 0; /* outside of the range, the bits are cleared */
	}
}

/**
 * scan a bitmap structure for the next set bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit to begin scanning.
 * @return the position of the next set bit. -1 if the end of the bits was reached
 */
EXPORT int bitmap_next_set(struct bitmap *bitmap, unsigned ofs)
{
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len = bitmap->bitmap_allocbits / BITMAP_BITSIZE;
	TODO("check the head"); /* I don't remember what these TODO's are for */

	for (i = ofs / BITMAP_BITSIZE; i < len; i++) {
		if (bitmap->bitmap[i] != 0) {
			/* found a set bit - scan the word to find the position */
			for (bofs = 0; ((bitmap->bitmap[i] >> bofs) & 1) == 0; bofs++) ;

			return i * BITMAP_BITSIZE + bofs;
		}
	}

	TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/**
 * scan a bitmap structure for the next clear bit.
 * @param bitmap the bitmap structure.
 * @param ofs the index of the bit to begin scanning.
 * @return the position of the next cleared bit. -1 if the end of the bits was reached
 */
EXPORT int bitmap_next_clear(struct bitmap *bitmap, unsigned ofs)
{
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len = bitmap->bitmap_allocbits / BITMAP_BITSIZE;
	TODO("check the head"); /* I don't remember what these TODO's are for */

	for (i = ofs / BITMAP_BITSIZE; i < len; i++) {
		if (bitmap->bitmap[i] != ~0U) {
			/* found a set bit - scan the word to find the position */
			for (bofs = 0; ((bitmap->bitmap[i] >> bofs) & 1) == 1; bofs++) ;

			return i * BITMAP_BITSIZE + bofs;
		}
	}

	TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/**
 * loads a chunk of memory into the bitmap structure.
 * erases previous bitmap buffer, resizes bitmap buffer to make room if necessary.
 * @param bitmap the bitmap structure.
 * @param d a buffer to use for initializing the bitmap.
 * @param len length in bytes of the buffer d.
 */
EXPORT void bitmap_loadmem(struct bitmap *bitmap, unsigned char *d, size_t len)
{
	unsigned *p, word_count, i;

	/* resize if too small */
	if ((len * CHAR_BIT) > bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, len * CHAR_BIT);
	}

	p = bitmap->bitmap;
	word_count = len / sizeof * p; /* number of words in d */

	/* first do the words */
	while (word_count > 0) {
		i = sizeof * p - 1;
		*p = 0;

		do {
			*p |= *d << (i * CHAR_BIT);
			d++;
		} while (--i);

		p++;
		word_count--;
		len -= sizeof * p;
	}

	/* finish the remaining */
	i = sizeof * p - 1;

	while (len > 0) {
		*p &= 0xff << (i * CHAR_BIT);
		*p |= *d << (i * CHAR_BIT);
		i--;
		d++;
		len--;
	}
}

/**
 * Get the length (in bytes) of the bitmap table.
 * @return the length in bytes of the entire bitmap table.
 */
EXPORT unsigned bitmap_length(struct bitmap *bitmap)
{
	return bitmap ? ROUNDUP(bitmap->bitmap_allocbits, CHAR_BIT) / CHAR_BIT : 0;
}

#ifndef NTEST
/**
 * unit tests for struct bitmap data structure.
 */
EXPORT void bitmap_test(void)
{
	int i;
	struct bitmap bitmap;

	bitmap_init(&bitmap);
	bitmap_resize(&bitmap, 1024);

	/* fill in with a test pattern */
	for (i = 0; i < 5; i++) {
		bitmap.bitmap[i] = 0x12345678;
	}

	bitmap_set(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_clear():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_clear():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 0, BITMAP_BITSIZE * 5);
	/* display the test pattern */
	printf("bitmap_set():\n");

	for (i = 0; i < 5; i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], util_convertnumber(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE * 5);
	bitmap_set(&bitmap, 101, 1);
	printf("word at bit 101 = 0x%08x\n", bitmap.bitmap[101 / BITMAP_BITSIZE]);
	printf("next set starting at 9 = %d\n", bitmap_next_set(&bitmap, 9));
	bitmap_clear(&bitmap, 101, 1);

	bitmap_set(&bitmap, 0, 101);
	printf("next clear starting at 9 = %d\n", bitmap_next_clear(&bitmap, 9));
	bitmap_clear(&bitmap, 0, 101);

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE * 5);
	printf("next set should return -1 = %d\n", bitmap_next_set(&bitmap, 0));

	bitmap_free(&bitmap);
}
#endif

/******************************************************************************
 * acs - access control string
 ******************************************************************************/
#include <limits.h>

/** access control system - holds all data to use acs functions. */
struct acs_info {
	unsigned char level;
	unsigned flags;
};

/** initializes acs_info to some values. */
static void acs_init(struct acs_info *ai, unsigned level, unsigned flags)
{
	ai->level = level <= UCHAR_MAX ? level : UCHAR_MAX;
	ai->flags = flags;
}

/** test if a flag is set in acs_info. */
static int acs_testflag(struct acs_info *ai, unsigned flag)
{
	unsigned i;
	flag = tolower((char)flag);

	if (flag >= 'a' && flag <= 'z') {
		i = flag - 'a';
	} else if (flag >= '0' && flag <= '9') {
		i = flag - '0' + 26;
	} else {
		ERROR_FMT("unknown flag '%c'\n", flag);
		return 0;
	}

	return ((ai->flags >> i) & 1) == 1;
}

/** check a string against acs_info.
 * the string can contain levels (s) or flags(f).
 * use | to OR things toegether. */
static int acs_check(struct acs_info *ai, const char *acsstring)
{
	const char *s = acsstring;
	const char *endptr;
	unsigned long level;
retry:

	while (*s) switch(*s++) {
		case 's':
			level = strtoul(s, (char**)&endptr, 10);

			if (endptr == acsstring) {
				goto parse_failure;
			}

			if (ai->level < level) goto did_not_pass;

			s = endptr;
			break;

		case 'f':
			if (!acs_testflag(ai, (unsigned)*s)) goto did_not_pass;

			s++;
			break;

		case '|':
			return 1; /* short circuit the OR */

		default:
			goto parse_failure;
		}

	return 1; /* everything matched */
did_not_pass:

	while (*s) if (*s++ == '|') goto retry; /* look for an | */

	return 0;
parse_failure:
	ERROR_FMT("acs parser failure '%s' (off=%td)\n", acsstring, s - acsstring);
	return 0;
}

#ifndef NTEST

/** test routine for acs_info. */
void acs_test(void)
{
	struct acs_info ai_test;

	acs_init(&ai_test, 4, 0);

	printf("acs_check() %d\n", acs_check(&ai_test, "s6fA"));
	printf("acs_check() %d\n", acs_check(&ai_test, "s2"));
	printf("acs_check() %d\n", acs_check(&ai_test, "s2fA"));
	printf("acs_check() %d\n", acs_check(&ai_test, "s8|s2"));
}
#endif

/******************************************************************************
 * Telnet protocol constants
 ******************************************************************************/
/** @todo prefix these to clean up the namespace */

/** telnet protocol escape */
#define IAC '\377'

/** telnet protocol directive. */
#define DONT '\376'

/** telnet protocol directive. */
#define DO '\375'

/** telnet protocol directive. */
#define WONT '\374'

/** telnet protocol directive. */
#define WILL '\373'

/** telnet protocol to start multiple bytes of data. */
#define SB '\372'

/** telnet directive - go ahead. */
#define GA '\371'

/** undocumented - please add documentation. */
#define EL '\370'

/** undocumented - please add documentation. */
#define EC '\367'

/** undocumented - please add documentation. */
#define AYT '\366'

/** undocumented - please add documentation. */
#define AO '\365'

/** undocumented - please add documentation. */
#define IP '\364'

/** undocumented - please add documentation. */
#define BREAK '\363'

/** undocumented - please add documentation. */
#define DM '\362'

/** undocumented - please add documentation. */
#define NOP '\361'

/** undocumented - please add documentation. */
#define SE '\360'

/** undocumented - please add documentation. */
#define EOR '\357'

/** undocumented - please add documentation. */
#define ABORT '\356'

/** undocumented - please add documentation. */
#define SUSP '\355'

/** undocumented - please add documentation. */
#define xEOF '\354' /* this is what BSD arpa/telnet.h calls the EOF */

/** undocumented - please add documentation. */
#define SYNCH '\362'

/*=* telnet options *=*/

/** undocumented - please add documentation. */
#define TELOPT_ECHO 1

/** undocumented - please add documentation. */
#define TELOPT_SGA 3

/** undocumented - please add documentation. */
#define TELOPT_TTYPE 24		/* terminal type - rfc1091 */

/** undocumented - please add documentation. */
#define TELOPT_NAWS 31		/* negotiate about window size - rfc1073 */

/** undocumented - please add documentation. */
#define TELOPT_LINEMODE 34	/* line mode option - rfc1116 */

/*=* generic sub-options *=*/

/** undocumented - please add documentation. */
#define TELQUAL_IS 0

/** undocumented - please add documentation. */
#define TELQUAL_SEND 1

/** undocumented - please add documentation. */
#define TELQUAL_INFO 2

/*=* Linemode sub-options *=*/

/** undocumented - please add documentation. */
#define	LM_MODE 1

/** undocumented - please add documentation. */
#define	LM_FORWARDMASK 2

/** undocumented - please add documentation. */
#define	LM_SLC 3

/*=* linemode modes *=*/

/** undocumented - please add documentation. */
#define	MODE_EDIT 1

/** undocumented - please add documentation. */
#define	MODE_TRAPSIG 2

/** undocumented - please add documentation. */
#define	MODE_ACK 4

/** undocumented - please add documentation. */
#define MODE_SOFT_TAB 8

/** undocumented - please add documentation. */
#define MODE_LIT_ECHO 16

/** undocumented - please add documentation. */
#define	MODE_MASK 31

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
int attr_add(struct attr_list *al, const char *name, const char *value)
{
	struct attr_entry *curr, *prev, *item;

	assert(al != NULL);

	/* track prev to use later as a tail. */
	prev = NULL;

	for (curr = LIST_TOP(*al); curr; curr = LIST_NEXT(curr, list)) {
		/* case sensitive. */
		if (!strcmp(curr->name, name)) {
			ERROR_FMT("WARNING:attribute '%s' already exists.\n", curr->name);
			return 0; /**< duplicate found, refuse to add. */
		}

		prev = curr;
	}

	/* create the new entry. */
	item = calloc(1, sizeof * item);

	if (!item) {
		PERROR("calloc()");
		return 0; /**< out of memory. */
	}

	item->name = strdup(name);

	if (!item->name) {
		PERROR("strdup()");
		free(item);
		return 0; /**< out of memory. */
	}

	item->value = strdup(value);

	if (!item->value) {
		PERROR("strdup()");
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
void attr_list_free(struct attr_list *al)
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
 * users
 ******************************************************************************/
/** user:configuration **/

/*=* defaults for new users *=*/

/** default level for new users. */
#define USER_LEVEL_NEWUSER mud_config.newuser_level

/** default flags for new users. */
#define USER_FLAGS_NEWUSER mud_config.newuser_flags

/*=* user:types *=*/

/** datastructure that describes a user record. */
struct user {
	unsigned id;
	char *username;
	char *password_crypt;
	char *email;
	struct acs_info acs;
	REFCOUNT_TYPE REFCOUNT_NAME;
	struct attr_list extra_values; /**< load an other values here. */
};

struct userdb_entry {
	struct user *u;
	LIST_ENTRY(struct userdb_entry) list;
};

/*=* user:globals *=*/

/** list of all users. */
static LIST_HEAD(struct, struct userdb_entry) user_list;

/** pool of available user ids. */
static struct freelist user_id_freelist;

/*=* user:prototypes. *=*/

EXPORT int user_illegal(const char *username);
EXPORT int user_exists(const char *username);

/*=* user:internal functions *=*/

/**
 * only free the structure data.
 */
static void user_ll_free(struct user *u)
{
	if (!u) return;

	attr_list_free(&u->extra_values);
	LIST_INIT(&u->extra_values);
	free(u->username);
	u->username = 0;
	free(u->password_crypt);
	u->password_crypt = 0;
	free(u->email);
	u->email = 0;
	free(u);
}

/** free a user structure. */
static void user_free(struct user *u)
{
	if (!u) return;

	user_ll_free(u);
}

/**
 * allocate a default struct.
 */
static struct user *user_defaults(void)
{
	struct user *u;
	u = calloc(1, sizeof * u);

	if (!u) {
		PERROR("malloc()");
		return NULL;
	}

	u->id = 0;
	REFCOUNT_INIT(u);
	u->username = NULL;
	u->password_crypt = NULL;
	u->email = NULL;
	u->acs.level = USER_LEVEL_NEWUSER;
	u->acs.flags = USER_FLAGS_NEWUSER;
	LIST_INIT(&u->extra_values);
	return u;
}

/**
 * insert a user into user_list, but only if it is not already on the list.
 */
static int user_ll_add(struct user *u)
{
	struct userdb_entry *ent;
	assert(u != NULL);
	assert(u->username != NULL);

	if (!u) return 0; /**< failure. */

	if (user_exists(u->username)) {
		return 0; /**< failure. */
	}

	ent = calloc(1, sizeof * ent);

	if (!ent)
		return 0; /**< failure. */

	ent->u = u;
	LIST_INSERT_HEAD(&user_list, ent, list);
	return 1; /**< success. */
}

/** load a user by username. */
static struct user *user_load_byname(const char *username)
{
	struct user *u;
	struct fdb_read_handle *h;
	const char *name, *value;

	h = fdb.read_begin("users", username);

	if (!h) {
		ERROR_FMT("Could not find user \"%s\"\n", username);
		return 0; /* failure. */
	}

	u = user_defaults(); /* allocate a default struct */

	if (!u) {
		ERROR_MSG("Could not allocate user structure");
		fdb.read_end(h);
		return 0; /* failure */
	}

	while (fdb.read_next(h, &name, &value)) {
		if (!strcasecmp("id", name))
			parse_uint(name, value, &u->id);
		else if (!strcasecmp("username", name))
			parse_str(name, value, &u->username);
		else if (!strcasecmp("pwcrypt", name))
			parse_str(name, value, &u->password_crypt);
		else if (!strcasecmp("email", name))
			parse_str(name, value, &u->email);
		else if (!strcasecmp("acs.level", name))
			sscanf(value, "%hhu", &u->acs.level); /* TODO: add error checking. */
		else if (!strcasecmp("acs.flags", name))
			parse_uint(name, value, &u->acs.flags);
		else
			parse_attr(name, value, &u->extra_values);
	}

	if (!fdb.read_end(h)) {
		ERROR_FMT("Error loading user \"%s\"\n", username);
		goto failure;
	}

	if (u->id <= 0) {
		ERROR_FMT("User id for user '%s' was not set or set to zero.\n", username);
		goto failure;
	}

	if (!u->username || strcasecmp(username, u->username)) {
		ERROR_FMT("User name field for user '%s' was not set or does not math.\n", username);
		goto failure;
	}

	/** @todo check all fields of u to verify they are correct. */

	if (!freelist_thwack(&user_id_freelist, u->id, 1)) {
		ERROR_FMT("Could not use user id %d (bad id or id already used?)\n", u->id);
		goto failure;
	}

	DEBUG("Loaded user '%s'\n", username);

	return u; /* success */

failure:
	user_ll_free(u);
	return 0; /* failure */
}

/** write a user file. */
static int user_write(const struct user *u)
{
	struct fdb_write_handle *h;
	struct attr_entry *curr;

	assert(u != NULL);
	assert(u->username != NULL);

	h = fdb.write_begin("users", u->username);

	if (!h) {
		ERROR_FMT("Could not write user \"%s\"\n", u->username);
		return 0;
	}

	fdb.write_format(h, "id", "%u", u->id);
	fdb.write_pair(h, "username", u->username);
	fdb.write_pair(h, "pwcrypt", u->password_crypt);
	fdb.write_pair(h, "email", u->email);
	fdb.write_format(h, "acs.level", "%u", u->acs.level);
	fdb.write_format(h, "acs.flags", "0x%08x", u->acs.flags);

	for (curr = LIST_TOP(u->extra_values); curr; curr = LIST_NEXT(curr, list)) {
		fdb.write_pair(h, curr->name, curr->value);
	}

	if (!fdb.write_end(h)) {
		ERROR_FMT("Could not write user \"%s\"\n", u->username);
		return 0; /* failure. */
	}

	return 1; /* success */
}

/*=* user:external functions *=*/

/** test to see if a username is illegal.
 * username must start with a letter. Remaining character can only be letters,
 * numbers, and _ */
EXPORT int user_illegal(const char *username)
{
	const char *s;

	if (!username || !*username)
		return 1; // illegal username

	s = username;

	if (!isalpha(*s))
		return 1; // illegal username

	while (*++s) {
		if (!isalnum(*s) && *s != '_')
			return 1; // illegal username
	}

	return 0; // OK - it's good
}

/** test to see if a user exists. */
EXPORT int user_exists(const char *username)
{
	struct userdb_entry *curr;

	if (user_illegal(username))
		return 0; /**< illegal users never exist */

	for (curr = LIST_TOP(user_list); curr; curr = LIST_NEXT(curr, list)) {
		const struct user *u = curr->u;
		assert(u != NULL);
		assert(u->username != NULL);

		if (!strcasecmp(u->username, username)) {
			return 1; /**< user exists. */
		}
	}

	return 0; /* user not found */
}

/**
 * loads a user into the cache.
 */
EXPORT struct user *user_lookup(const char *username)
{
	struct userdb_entry *curr;

	for (curr = LIST_TOP(user_list); curr; curr = LIST_NEXT(curr, list)) {
		struct user *u = curr->u;

		assert(u != NULL);
		assert(u->username != NULL);

		/*
		 * load from disk if not loaded:
		 * if (!strcasecmp(curr->cached_username, username)) {
		 *   u=user_load_byname(username);
		 *   user_ll_add(u);
		 *   return u;
		 * }
		 */

		if (!strcasecmp(u->username, username)) {
			return u; /**< user exists. */
		}
	}

	return NULL; /* user not found. */
}

/** create a user and initialize the password. */
EXPORT struct user *user_create(const char *username, const char *password, const char *email)
{
	struct user *u;
	long id;
	char password_crypt[SHA1PASSWD_MAX];

	if (!username || !*username) {
		ERROR_MSG("Username was NULL or empty");
		return NULL; /* failure */
	}

	if (user_illegal(username))
		return NULL; /**< illegal users never exist */

	if (user_exists(username)) {
		ERROR_FMT("Username '%s' already exists.\n", username);
		return NULL; /* failure */
	}

	/* encrypt password */
	if (!sha1crypt_makepass(password_crypt, sizeof password_crypt, password)) {
		ERROR_MSG("Could not hash password");
		return NULL; /* failure */
	}

	u = user_defaults(); /* allocate a default struct */

	if (!u) {
		DEBUG_MSG("Could not allocate user structure");
		return NULL; /* failure */
	}

	id = freelist_alloc(&user_id_freelist, 1);

	if (id < 0) {
		ERROR_FMT("Could not allocate user id for username(%s)\n", username);
		user_free(u);
		return NULL; /* failure */
	}

	assert(id >= 0);

	u->id = id;
	u->username = strdup(username);
	u->password_crypt = strdup(password_crypt);
	u->email = strdup(email);

	if (!user_write(u)) {
		ERROR_FMT("Could not save account username(%s)\n", u->username);
		user_free(u);
		return NULL; /* failure */
	}

	return u; /* success */
}

/** initialize the user system. */
EXPORT int user_init(void)
{
	struct fdb_iterator *it;
	const char *id;

	LIST_INIT(&user_list);

	freelist_init(&user_id_freelist);
	freelist_pool(&user_id_freelist, 1, 32768);

	fdb.domain_init("users");

	it = fdb.iterator_begin("users");

	if (!it) {
		return 0;
	}

	/* scan for account files */

	while ((id = fdb.iterator_next(it))) {
		struct user *u;

		DEBUG("Found user record '%s'\n", id);
		/* Load user file */
		u = user_load_byname(id);

		if (!u) {
			ERROR_FMT("Could not load user from file '%s'\n", id);
			goto failure;
		}

		/** add all users to a list */
		user_ll_add(u);
	}

	fdb.iterator_end(it);
	return 1; /* success */
failure:
	fdb.iterator_end(it);
	return 0; /* failure */
}

/** shutdown the user system. */
EXPORT void user_shutdown(void)
{
	/** @todo free all loaded users. */
	freelist_free(&user_id_freelist);
}

/**
 * decrement a reference count.
 */
EXPORT void user_put(struct user **user)
{
	if (user && *user) {
		REFCOUNT_PUT(*user, user_free(*user); *user = NULL);
	}
}

/**
 * increment the reference count.
 */
EXPORT void user_get(struct user *user)
{
	if (user) {
		REFCOUNT_GET(user);
		DEBUG("user refcount=%d\n", user->REFCOUNT_NAME);
	}
}

/******************************************************************************
 * Socket Buffers
 ******************************************************************************/

/** buffer used for socket I/O.
 * some functions will expand LF to CR/LF because it assumes TELNET protocol.
 */
struct buffer {
	char *data;
	size_t used, max;
};

/** initialize a buffer to a particular maximum size.
 * space is left in the buffer for null terminator, so best to make the size a
 * multiple of a power of 2 minus 1.
 */
EXPORT void buffer_init(struct buffer *b, size_t max)
{
	assert(b != NULL);
	b->data = malloc(max + 1); /* allocate an extra byte past max for null */
	b->used = 0;
	b->max = max;
}

/**
 * free the buffer.
 */
EXPORT void buffer_free(struct buffer *b)
{
	free(b->data);
	b->data = NULL;
	b->used = 0;
	b->max = 0;
}

/**
 * expand newlines into CR/LF startin at used.
 * @return length of processed string or -1 on overflow
 */
static int buffer_ll_expandnl(struct buffer *b, size_t len)
{
	size_t rem;
	char *p, *e;

	assert(b != NULL);

	for (p = b->data + b->used, rem = len; (e = memchr(p, '\n', rem)); rem -= e - p, p = e + 2) {
		/* check b->max for overflow */
		if (p - b->data >= (ptrdiff_t)b->max) {
			DEBUG_MSG("Overflow detected");
			return -1;
		}

		memmove(e + 1, e, rem);
		*e = '\r';
		len++; /* grew by 1 byte */
	}

	assert(b->used + len <= b->max);
	return len;
}

/**
 * special write that does not expand its input.
 * unlike the other calls, truncation will not load partial data into a buffer
 */
EXPORT int buffer_write_noexpand(struct buffer *b, const void *data, size_t len)
{
	if (b->used + len > b->max) {
		DEBUG_MSG("Overflow detected. refusing to send any data.\n");
		return -1;
	}

	memcpy(&b->data[b->used], data, len);
	b->used += len;

	assert(b->used <= b->max);
	return len;
}

/**
 * writes data and exapands newline to CR/LF.
 */
EXPORT int buffer_write(struct buffer *b, const char *str, size_t len)
{
	size_t i, j;
	int ret;
	assert(b != NULL);

	if (b->used >= b->max) {
		DEBUG("Buffer %p is full\n", (void*)b);
		return -1; /* buffer is full */
	}

	/* copy the data into the buffer, while expanding newlines */
	for (i = 0, j = b->used; i < len && j < b->max; i++) {
		if (str[i] == '\n') {
			b->data[j++] = '\r';
		}

		b->data[j++] = str[i];
	}

	ret = j - b->used;
	b->used = j;
	assert(ret >= 0);
	assert(b->used <= b->max);

	if (i < len) {
		DEBUG("Truncation detected in buffer %p\n", (void*)b);
		return -1;
	}

	TRACE("Wrote %d bytes to buffer %p\n", j, (void*)b);
	return j;
}

/**
 * puts data in a client's output buffer.
 */
static int buffer_puts(struct buffer *b, const char *str)
{
	return buffer_write(b, str, strlen(str));
}

/**
 * printfs and expands newline to CR/LF.
 */
EXPORT int buffer_vprintf(struct buffer *b, const char *fmt, va_list ap)
{
	int res;
	assert(b != NULL);

	if (!b)
		return -1; /* failure */

	if (b->used >= b->max) {
		DEBUG("Buffer %p is full\n", (void*)b);
		return -1; /* buffer is full */
	}

	/* we allocated an extra byte past max for null terminators */
	res = vsnprintf(&b->data[b->used], b->max - b->used + 1, fmt, ap);

	if (res < 0) { /* some libcs return -1 on truncation */
		res = b->max - b->used + 2; /* trigger the truncation code below */
	}

	/* snprintf does not include the null terminator in its count */
	if ((unsigned)res > b->max - b->used) {
		/* truncation occured */
		TODO("grow the buffer and try again?");
		DEBUG("Truncation detected in buffer %p\n", (void*)b);
		res = b->max - b->used;
	}

	res = buffer_ll_expandnl(b, (unsigned)res);

	if (res == -1) {
		TODO("test this code");
		ERROR_FMT("Overflow in buffer %p\n", (void*)b);
		return -1;
	}

	b->used += res;
	TRACE("Wrote %d bytes to buffer %p\n", res, (void*)b);
	return res;
}

/**
 * printfs data in a client's output buffer.
 */
static int buffer_printf(struct buffer *b, const char *fmt, ...)
{
	va_list ap;
	int res;
	va_start(ap, fmt);
	res = buffer_vprintf(b, fmt, ap);
	va_end(ap);
	return res;
}

/** return the current data in the buffer and update len with the length. */
EXPORT const char *buffer_data(struct buffer *b, size_t *len)
{
	assert(b != NULL);
	assert(len != NULL);

	if (!b) {
		*len = 0;
		return NULL;
	}

	*len = b->used;
	return b->data;
}

/**
 * used for adding more data to the buffer.
 * @return a pointer to the start of the buffer
 * @param b a buffer
 * @param len the amount remaining in the buffer
 */
EXPORT char *buffer_load(struct buffer *b, size_t *len)
{
	assert(b != NULL);
	assert(len != NULL);

	if (!b) {
		*len = 0;
		return NULL;
	}

	*len = b->max - b->used; /* remaining */
	return b->data + b->used;
}

/**
 * @return the remaining data in the buffer
 */
EXPORT unsigned buffer_consume(struct buffer *b, size_t len)
{
	assert(b != NULL);
	DEBUG("len=%zu used=%zu rem=%zu\n", len, b->used, b->max - b->used);
	assert(len <= b->used);

	if (len > b->used) {
		ERROR_FMT("WARNING:attempted ovewflow of output buffer %p\n", (void*)b);
		len = b->used;
	}

	b->used -= len;
	assert((signed)b->used >= 0);
	memmove(b->data, b->data + len, b->used);
	return b->used;
}

/**
 * commits data to buffer.
 */
EXPORT void buffer_emit(struct buffer *b, size_t len)
{
	assert(b != NULL);
	assert(b->used <= b->max);
	assert(b->used + len <= b->max);
	b->used += len;

	if (b->used > b->max) {
		ERROR_FMT("WARNING:attempted ovewflow of input buffer %p\n", (void*)b);
		b->used = b->max;
	}
}

/**
 * callback returns the number of items consumed.
 * if a line is incomplete (which it will be if an IAC is incomplete, then return NULL
 */
static char *buffer_findnl(char *d, size_t *len, size_t (*iac_process)(const char *data, size_t len, void *p), void *p)
{
	size_t res, tmplen;

	assert(d != NULL);
	assert(len != NULL);

	/* just look for newlines if we aren't processing IACs */
	if (!iac_process) {
		return memchr(d, '\n', *len);
	}

	/* look for IACs and newlines */

	assert((int)*len >= 0);

	for (tmplen = *len; tmplen;) {
		TRACE("%d: len=%d tmplen=%d\n", __LINE__, *len, tmplen);
		assert((int)tmplen > 0);

		if (*d == IAC) {
			assert(iac_process != NULL);
			res = iac_process(d, *len, p);

			if (!res) {
				/* incomplete IAC sequence, wait for more data */
				DEBUG_MSG("Incomplete IAC sequence, wait for more data\n");
				return NULL;
			}

			DEBUG("Telnet control data processed (%zd bytes)\n", res);
			TRACE("%d: res=%d len=%d tmplen=%d\n", __LINE__, res, *len, tmplen);
			assert((int)res <= (int)*len);
			assert((int)tmplen > 0);
			assert((int)res <= (int)tmplen);
			tmplen -= res;
			*len -= res; /* the overall length was just reduced */
			assert((int)tmplen >= 0);
			memmove(d, d + res, tmplen);
			continue;
		}

		if (*d == '\n') {
			return d;
		}

		tmplen--;
		d++;
		assert((int)tmplen >= 0);
	}

	return NULL; /* not found */
}

/** read a line of data from the buffer.
 * handles CR/LF and LF terminated lines.
 */
EXPORT const char *buffer_getline(struct buffer *b, size_t *consumed_len, size_t (*iac_process)(const char *data, size_t len, void *p), void *p)
{
	char *d;
	assert(b != NULL);
	assert(consumed_len != NULL);
	d = buffer_findnl(b->data, &b->used, iac_process, p);

	if (!d) {
		/* no newline found */
		return NULL;
	}

	if (d > b->data && d[-1] == '\r') {
		d[-1] = 0; /* rub out CR */
	}

	*d = 0; /* rub out LF */
	*consumed_len = d - b->data + 1;
	return b->data;
}

/******************************************************************************
 * Socket I/O API
 ******************************************************************************/
#ifndef USE_WIN32_SOCKETS
/** define SOCKET on POSIX systems because Winsock2 uses this typedef too,
 * but it is good to remember that ws2's sockets are unsigned int handles
 * while POSIX/BSD systems use a signed int, with -1 as flag value for an
 * unused or freed socket.
 */
typedef int SOCKET;

/** value used to inidicate an uninitialized socket handle. */
#define INVALID_SOCKET (-1)

/** value returned by most of the socket functions to indicate error. */
#define SOCKET_ERROR (-1)
#endif

/** check e, if true then print an error message containing the last socket
 * error. */
#define SOCKETIO_FAILON(e, reason, fail_label) do { if (e) { fprintf(stderr, "ERROR:%s:%s\n", reason, socketio_strerror()); goto fail_label; } } while (0)

/** generic socket handle. */
struct socketio_handle {
	unsigned type; /* 0 = server, 1 = telnetclient */
	LIST_ENTRY(struct socketio_handle) list;
	SOCKET fd;
	char *name;
	unsigned delete_flag: 1; /* if set, then this entry should be deleted */
	void (*write_event)(struct socketio_handle *sh, SOCKET fd, void *p);
	void (*read_event)(struct socketio_handle *sh, SOCKET fd, void *p);
	void *extra;
	void (*extra_free)(struct socketio_handle *sh, void *extra);
};

/** list of all open sockets. */
static LIST_HEAD(struct socketio_handle_list, struct socketio_handle) socketio_handle_list;

/** bitarray of sockets for select(). */
static fd_set *socketio_readfds,
       /** bitarray of sockets for select(). */
       *socketio_writefds;

/** size of socketio_readfds and socketio_writefds.
 * yes you can allocate a variable number of fds with select().
 */
static unsigned socketio_fdset_sz;

#if defined(USE_WIN32_SOCKETS)

/** current maximum socket number - not used for winsock. */
#define socketio_fdmax 0 /* not used on Win32 */

/** count of number of open sockets.
 * WIN32: the limit of fd_set is the count not the fd number */
static unsigned socketio_socket_count;
#else

/** current maximum socket number - not used for winsock. */
static SOCKET socketio_fdmax = INVALID_SOCKET; /* used by select() to limit the number of fds to check */
#endif

/** counts the number of pending deletions */
static unsigned socketio_delete_count = 0;

#if defined(USE_WIN32_SOCKETS) && !defined(gai_strerror)

/** handles string errors from getaddrinfo related functions. */
static const char *gai_strerror(int err)
{
	switch(err) {
	case EAI_AGAIN:
		return "Temporary failure in name resolution";

	case EAI_BADFLAGS:
		return "Bad value for ai_flags";

	case EAI_FAIL:
		return "Non-recoverable failure in name resolution";

	case EAI_FAMILY:
		return "ai_family not supported";

	case EAI_MEMORY:
		return "Memory allocation failure";

	case EAI_NONAME:
		return "Name or service not known";

	case EAI_SERVICE:
		return "Servname not supported for ai_socktype";

	case EAI_SOCKTYPE:
		return "ai_socktype not supported";
	}

	return "Unknown resolution error";
}
#endif

/** gets the last socket error as a string. */
EXPORT const char *socketio_strerror(void)
{
#if defined(USE_WIN32_SOCKETS)
	static char buf[64];
	int res;
	res = WSAGetLastError();

	if (res == 0)
		return "winsock successful";

	snprintf(buf, sizeof buf, "winsock error %d", res);
	return buf;
#else
	return strerror(errno);
#endif
}

/**
 * @return true if the last recv()/send() call would have blocked.
 */
EXPORT int socketio_wouldblock(void)
{
#if defined(USE_WIN32_SOCKETS)
	return WSAGetLastError() == WSAEWOULDBLOCK;
#else
	return errno == EWOULDBLOCK;
#endif
}

/**
 * @return true for errno==EINTR.
 */
EXPORT int socketio_eintr(void)
{
#if defined(USE_WIN32_SOCKETS)
	return WSAGetLastError() == WSAEINTR;
#else
	return errno == EINTR;
#endif
}

#ifndef NTRACE
/** dump all the bits in fd_set. */
static void socketio_dump_fdset(fd_set *readfds, fd_set *writefds)
{
#if defined(USE_WIN32_SOCKETS)
	unsigned i;
	fprintf(stderr, "socketio_socket_count=%d\n", socketio_socket_count);

	for (i = 0; i < readfds->fd_count && i < writefds->fd_count; i++) {
		if (i < readfds->fd_count) {
			fprintf(stderr, "%s():READ:fd=%u  ", __func__, readfds->fd_array[i]);
		}

		if (i < writefds->fd_count) {
			fprintf(stderr, "%s():WRITE:fd=%u", __func__, writefds->fd_array[i]);
		}

		fprintf(stderr, "\n");
	}

#else
	SOCKET i;
	fprintf(stderr, "socketio_fdmax=%d\n", socketio_fdmax);

	for (i = 0; i <= socketio_fdmax; i++) {
		unsigned r = FD_ISSET(i, readfds), w = FD_ISSET(i, writefds);

		if (r || w) {
			fprintf(stderr, "%s():fd=%d (%c%c)\n", __func__, i, r ? 'r' : '-', w ? 'w' : '-');
		}
	}

#endif
}
#endif

/** initialize the socketio module. */
EXPORT int socketio_init(void)
{
#if defined(USE_WIN32_SOCKETS)
	WSADATA wsaData;
	int err;

	err = WSAStartup(MAKEWORD(2, 2), &wsaData);

	if (err != 0) {
		fprintf(stderr, "WSAStartup() failed (err=%d)\n", err);
		return 0;
	}

	DEBUG("Winsock: VERSION %u.%u\n",
	      LOBYTE(wsaData.wVersion),
	      HIBYTE(wsaData.wVersion)
	     );
#endif

	socketio_fdset_sz = FD_SETSIZE;

#if defined(USE_WIN32_SOCKETS)
	/* win32 winsock api */
	socketio_readfds = calloc(1, sizeof * socketio_readfds);
	socketio_writefds = calloc(1, sizeof * socketio_writefds);
#elif defined(NFDBITS)
	/* X/Open compatible APIs */
	socketio_readfds = calloc(1, socketio_fdset_sz / NFDBITS);
	socketio_writefds = calloc(1, socketio_fdset_sz / NFDBITS);
#else
	/* for non-BSD socket APIs */
#warning Using generic socket code. define _BSD_SOURCE for Unix socket code
	socketio_readfds = calloc(1, sizeof * socketio_readfds);
	socketio_writefds = calloc(1, sizeof * socketio_writefds);
#endif
	return 1;
}

/** clean up the socketio module. */
EXPORT void socketio_shutdown(void)
{
#if defined(USE_WIN32_SOCKETS)
	WSACleanup();
#endif
}

/** close a socket and write INVALID_SOCKET to its handle. */
EXPORT int socketio_close(SOCKET *fd)
{
	int res;
	assert(fd != 0);
	assert(*fd != INVALID_SOCKET);
#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count--; /* track number of open sockets for filling fd_set */
	res = closesocket(*fd);
#else
	res = close(*fd);
#endif

	if (res == -1) {
		ERROR_FMT("close(fd=%d):%s\n", *fd, socketio_strerror());
	}

	/* do not retain entries for closed fds */
	FD_CLR(*fd, socketio_readfds);
	FD_CLR(*fd, socketio_writefds);

	*fd = INVALID_SOCKET;
	return res;
}

/**
 * You should call this whenever opening a new socket.
 * checks the maximum count and updates socketio_fdmax
 */
EXPORT int socketio_check_count(SOCKET fd)
{
	assert(fd != INVALID_SOCKET);
#if defined(USE_WIN32_SOCKETS)

	if (socketio_socket_count >= socketio_fdset_sz) {
		DEBUG("too many open sockets (%d) for fd_set (fd_setsize=%d)\n", socketio_socket_count, socketio_fdset_sz);
		return 0; /* failure */
	}

#else

	if ((unsigned)fd >= socketio_fdset_sz) {
		DEBUG("too many open sockets (%d) for fd_set (fd_setsize=%d)\n", fd, socketio_fdset_sz);
		return 0; /* failure */
	}

	if (fd > socketio_fdmax) {
		DEBUG("Updating fdmax from %d to %d\n", socketio_fdmax, fd);
		socketio_fdmax = fd;
	}

#endif
	return 1; /* success */
}

/**
 * report that an fd is ready for read events, and update the fdmax value.
 */
EXPORT void socketio_readready(SOCKET fd)
{
	assert(fd != INVALID_SOCKET);
	FD_SET(fd, socketio_readfds);
}

/**
 * report that an fd is ready for write events, and update the fdmax value.
 */
EXPORT void socketio_writeready(SOCKET fd)
{
	assert(fd != INVALID_SOCKET);
	FD_SET(fd, socketio_writefds);
}

/** convert a sockaddr into a string.
 * used for processing the sockaddr from accept() or getpeername(). */
EXPORT int socketio_sockname(struct sockaddr *sa, socklen_t salen, char *name, size_t name_len)
{
	char servbuf[16];
	int res;
	size_t tmplen;

	/* leave room in name for ":servbuf" and at least 16 characters */
	if (name_len >= (16 + sizeof servbuf)) {
		name_len -= sizeof servbuf;
	}

	res = getnameinfo(sa, salen, name, name_len, servbuf, sizeof servbuf, NI_NUMERICHOST | NI_NUMERICSERV);
	SOCKETIO_FAILON(res != 0, "getnameinfo()", failure);

	tmplen = strlen(name);

	if (name_len > tmplen) {
		snprintf(name + tmplen, name_len - tmplen, "/%s", servbuf);
	}

	return 1; /* success */

failure:
	return 0;
}

/** gets the name of a socket's peer as a string. */
EXPORT int socketio_getpeername(SOCKET fd, char *name, size_t name_len)
{
	struct sockaddr_storage ss;
	socklen_t sslen;
	int res;

	assert(fd != INVALID_SOCKET);
	assert(name != NULL);

	sslen = sizeof ss;
	res = getpeername(fd, (struct sockaddr*)&ss, &sslen);

	if (res != 0) {
		ERROR_FMT("%s\n", socketio_strerror());
		return 0;
	}

	if (!socketio_sockname((struct sockaddr*)&ss, sslen, name, name_len)) {
		ERROR_FMT("Failed on fd %d\n", fd);
		return 0;
	}

	DEBUG("getpeername is %s\n", name);
	return 1;
}

/** set a socket to non-blocking I/O. */
static int socketio_nonblock(SOCKET fd)
{
	int res;
#if defined(USE_WIN32_SOCKETS)
	u_long iMode = 1;
	res = ioctlsocket(fd, (int)FIONBIO, &iMode);
#else
	res = fcntl(fd, F_SETFL, O_NONBLOCK);
#endif
	SOCKETIO_FAILON(res != 0, "setting non-blocking for accept() socket", failure);
	return 1;
failure:
	return 0;
}

/** low-level free of socketio_handle. */
static void socketio_ll_handle_free(struct socketio_handle *sh)
{
	assert(sh != NULL);

	if (!sh)
		return;

	DEBUG("freeing socket handle '%s'\n", sh->name);

	if (sh->extra) {
		if (sh->extra_free) {
			sh->extra_free(sh, sh->extra);
		} else {
			DEBUG_MSG("WARNING:extra data for socket handle is being leaked");
		}
	}

	if (sh->fd != INVALID_SOCKET) {
		socketio_close(&sh->fd);
	}

	LIST_REMOVE(sh, list);

	free(sh->name);

#ifndef NDEBUG
	memset(sh, 0xBB, sizeof * sh); /* fill with fake data before freeing */
#endif
	free(sh);
}

/** send raw data to a socket.
 * a short write is possible! */
EXPORT int socketio_send(SOCKET fd, const void *data, size_t len)
{
	int res;
	res = send(fd, data, len, 0);
	SOCKETIO_FAILON(res == -1, "send() to socket", failure);
	return res;
failure:
	return -1;
}

/** read raw data from a socket up to len in size. */
EXPORT int socketio_recv(SOCKET fd, void *data, size_t len)
{
	int res;
	res = recv(fd, data, len, 0);
	SOCKETIO_FAILON(res == -1, "recv() from socket", failure);
	return res;
failure:
	return -1;
}

/**
 * print a too many connections message to the socket and then close it.
 * this is used when there are more sockets than we can deal with (like on
 * Win32).
 */
static void socketio_toomany(SOCKET fd)
{
	const char buf[] = "Too many connections\r\n";

	eventlog_toomany(); /* report that we are refusing connections */

	if (socketio_nonblock(fd)) {
		send(fd, buf, (sizeof buf) - 1, 0);
		socketio_send(fd, buf, (sizeof buf) - 1);
	}

	socketio_close(&fd);
}

/**
 * copy an fd_set basiced on socketio_fdmax (for Unix systems) or
 * fd_count(Win32).
 */
static void socketio_fdset_copy(fd_set *dst, const fd_set *src)
{
	assert(dst != NULL);
	assert(src != NULL);
#if defined(USE_WIN32_SOCKETS)
	/* copy routine for Win32 */
	dst->fd_count = src->fd_count;
	memcpy(dst->fd_array, src->fd_array, src->fd_count * sizeof * src->fd_array);
#elif defined(NFDBITS)
	/* X/Open compatible APIs - copy just the used part of the structure */
	size_t fd_bytes;
	assert(socketio_fdmax != INVALID_SOCKET);

	if (socketio_fdmax != INVALID_SOCKET) {
		fd_bytes = ROUNDUP(socketio_fdmax + 1, NFDBITS) / 8; /* copy only the necessary bits */
	} else {
		fd_bytes = ROUNDUP(socketio_fdset_sz, NFDBITS) / 8; /* fdmax looked weird, copy the whole thing */
	}

	memcpy(dst, src, fd_bytes);
#else
	/* generic copy for non-BSD socket APIs */
	*dst = *src;
#endif

}

/** allocate a new socketio_handle. */
static struct socketio_handle *socketio_ll_newhandle(SOCKET fd, const char *name, unsigned type, void (*write_event)(struct socketio_handle *sh, SOCKET fd, void *p), void (*read_event)(struct socketio_handle *sh, SOCKET fd, void *p))
{
	struct socketio_handle *ret;

	assert(fd != INVALID_SOCKET);

	if (!socketio_check_count(fd)) {
		ERROR_MSG("too many open sockets. closing new connection!");
		socketio_toomany(fd); /* send a message to the socket */
		return NULL; /* failure */
	}

	ret = calloc(1, sizeof * ret);
	FAILON(!ret, "malloc()", failure);
	ret->type = type;
	ret->name = strdup(name);
	ret->fd = fd;
	ret->delete_flag = 0;
	ret->read_event = read_event;
	ret->write_event = write_event;
	LIST_INSERT_HEAD(&socketio_handle_list, ret, list);
	socketio_readready(fd); /* default to being ready for reads */
	return ret;
failure:
	return NULL;
}

/** wait for events on all sockets for up to msec.
 * the time can expire sooner.
 */
EXPORT int socketio_dispatch(long msec)
{
	struct socketio_handle *curr, *next;
	struct timeval timeout, *to;
	int nr;	/* number of sockets to process */
	fd_set out_readfds, out_writefds;

	if (msec < 0) {
		/* wait forever */
		to = NULL;
	} else {
		timeout.tv_usec = (msec % 1000) * 1000;
		timeout.tv_sec = msec / 1000;
		assert(timeout.tv_usec < 1000000);
		to = &timeout;
	}

	if (!LIST_TOP(socketio_handle_list)) {
		ERROR_MSG("No more sockets to watch");
		return 0;
	}

	/* loop through all sockets to check for deletion */
	for (curr = LIST_TOP(socketio_handle_list); socketio_delete_count && curr; curr = next) {
		next = LIST_NEXT(curr, list);

		if (curr->delete_flag) {
			/* this entry must be deleted */
			DEBUG("Deleting %s\n", curr->name);

			socketio_close(&curr->fd);
			socketio_ll_handle_free(curr);

			socketio_delete_count--;
		}
	}

	/* clean up if there was a mistake in the count */
	if (socketio_delete_count != 0) {
		ERROR_MSG("WARNING:socketio_delete_count is higher than number of marked sockets");
		socketio_delete_count = 0;
	}

	socketio_fdset_copy(&out_readfds, socketio_readfds);
	socketio_fdset_copy(&out_writefds, socketio_writefds);

#ifndef NTRACE
	socketio_dump_fdset(&out_readfds, &out_writefds);
#endif

	if (socketio_fdmax == INVALID_SOCKET) {
		DEBUG_MSG("WARNING:currently not waiting on any sockets");
	}

	nr = select(socketio_fdmax + 1, &out_readfds, &out_writefds, 0, to);

	if (nr == SOCKET_ERROR) {
		SOCKETIO_FAILON(socketio_eintr(), "select()", failure);
		return 1; /* EINTR occured */
	}

	DEBUG("select() returned %d results\n", nr);

	TODO("if fds_bits is available then base the loop on the fd_set and look up entries on the client list.");

	/* check all sockets */
	for (curr = LIST_TOP(socketio_handle_list); nr > 0 && curr; curr = next) {
		SOCKET fd = curr->fd;

		TRACE("Checking socket %s\n", curr->name);

		assert(fd != INVALID_SOCKET); /* verify consistency of datastructure */

		if (FD_ISSET(fd, &out_writefds)) {
			/* always disable an activated entry */
			assert(fd != INVALID_SOCKET);
			assert((unsigned)fd < socketio_fdset_sz);
			FD_CLR(fd, socketio_writefds);
			DEBUG("Write-ready %s\n", curr->name);

			if (curr->delete_flag) {
				/* ignore soon-to-be closed socket */
			} if (curr->write_event) {

				/* perform the write handler */
				curr->write_event(curr, fd, curr->extra);
			}

			nr--;
		}

		if (FD_ISSET(fd, &out_readfds)) {
			/* always disable an activated entry */
			assert(fd != INVALID_SOCKET);
			assert((unsigned)fd < socketio_fdset_sz);
			FD_CLR(fd, socketio_readfds);
			DEBUG("Read-ready %s\n", curr->name);

			if (curr->delete_flag) {
				/* ignore soon-to-be closed socket */
			} else if (curr->read_event) {
				/* perform the read handler */
				curr->read_event(curr, fd, curr->extra);
			}

			nr--;
		}

		next = LIST_NEXT(curr, list);
	}

	if (nr > 0) {
		ERROR_FMT("there were %d unhandled socket events\n", nr);
		goto failure;
	}

	assert(nr == 0);

	return 1;
failure:
	return 0; /* failure */
}

/******************************************************************************
 * Server
 ******************************************************************************/

/** specialized type of socketio_handle for doing accept(). */
struct server {
	void (*newclient)(struct socketio_handle *new_sh);
};

/** handler for read-ready events - calls accept(). */
EXPORT void server_read_event(struct socketio_handle *sh, SOCKET fd, void *p)
{
	struct sockaddr_storage ss;
	socklen_t sslen;
	struct server *serv = p;
	struct socketio_handle *newclient;
	char buf[64];
	assert(sh != NULL);
	assert(sh->fd != INVALID_SOCKET);
	sslen = sizeof ss;
	fd = accept(sh->fd, (struct sockaddr*)&ss, &sslen);
	SOCKETIO_FAILON(fd == INVALID_SOCKET, "accept()", failure);

#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count++; /* track number of open sockets for filling fd_set */
#endif

	if (!socketio_sockname((struct sockaddr*)&ss, sslen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}

	eventlog_connect(buf);

	newclient = socketio_ll_newhandle(fd, buf, 1, NULL, NULL);

	if (!newclient) {
		ERROR_FMT("could not allocate client, closing connection '%s'\n", buf);
		socketio_close(&fd);
		return; /* failure */
	}

	serv->newclient(newclient);
	assert(newclient->write_event != NULL || newclient->read_event != NULL);

	DEBUG("Accepted connection %s\n", newclient->name);
	socketio_readready(sh->fd); /* be ready for next accept() */
	return;
failure:
	return;
}

/** free a server socketio_handle. */
static void server_free(struct socketio_handle *sh, void *p)
{
	struct server *servdata = p;

	if (!sh->delete_flag) {
		ERROR_MSG("WARNING: delete_flag was not set before freeing");
	}

	/* break connection to the extra data pointer */
	sh->extra = NULL;

#ifndef NDEBUG
	memset(servdata, 0xBB, sizeof * servdata); /* fill with fake data before freeing */
#endif

	free(servdata);
}

/** create a listening socket for use with a server. */
static struct socketio_handle *socketio_listen_bind(struct addrinfo *ai, void (*newclient)(struct socketio_handle *new_sh))
{
	SOCKET fd;
	int res;
	char buf[64];
	struct socketio_handle *newserv;
	struct server *servdata;
	struct linger li;

	const int yes = 1;
	assert(ai != NULL);

	if (!ai || !ai->ai_addr) {
		ERROR_MSG("empty socket address");
		return 0;
	}

	fd = socket(ai->ai_family, ai->ai_socktype, 0);
	SOCKETIO_FAILON(fd == INVALID_SOCKET, "creating socket", failure_clean);

#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count++; /* track number of open sockets for filling fd_set */
#endif

	if (!socketio_check_count(fd)) {
		ERROR_MSG("too many open sockets. refusing new server!");
		goto failure;
	}

	if (ai->ai_family == AF_INET || ai->ai_family == AF_INET6) {
		SOCKETIO_FAILON(setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (const void*)&yes, sizeof yes) != 0, "setting SO_REUSEADDR", failure);
		li.l_onoff = 0; /* disable linger, except for exit() */
		li.l_linger = 10; /* 10 seconds */
		SOCKETIO_FAILON(setsockopt(fd, SOL_SOCKET, SO_LINGER, (const void*)&li, sizeof li) != 0, "setting SO_LINGER", failure);
	}

	SOCKETIO_FAILON(bind(fd, ai->ai_addr, (socklen_t)ai->ai_addrlen) != 0, "binding to port", failure);

	if (!socketio_nonblock(fd)) {
		goto failure;
	}

	res = listen(fd, SOCKETIO_LISTEN_QUEUE);
	SOCKETIO_FAILON(res != 0, "forming listening socket", failure);

	if (!socketio_sockname(ai->ai_addr, (socklen_t)ai->ai_addrlen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}

	/* add server to a list */
	newserv = socketio_ll_newhandle(fd, buf, 0, NULL, server_read_event);

	if (!newserv) {
		ERROR_FMT("could not allocate server, closing socket '%s'\n", buf);
		socketio_close(&fd);
		return 0; /* failure */
	}

	servdata = calloc(1, sizeof * servdata);
	servdata->newclient = newclient;

	newserv->extra = servdata;
	newserv->extra_free = server_free;

	DEBUG("Bind success: %s %s\n", ai->ai_family == AF_INET ? "IPv4" : ai->ai_family == AF_INET6 ? "IPv6" : "Unknown", buf);

	return newserv; /* success */

failure:
	socketio_close(&fd);
failure_clean:
	return 0;
}

/**
 * opens and binds a listening socket on a port.
 * @param family 0 or AF_INET or AF_INET6
 * @param socktype SOCK_STREAM or SOCK_DGRAM
 * @param host NULL or hostname/IP to bind to.
 * @param port port number or service name to use when binding the socket.
 * @param newclient callback to use on accept().
 * @return socketio_handle for the created listening socket.
 */
EXPORT struct socketio_handle *socketio_listen(int family, int socktype, const char *host, const char *port, void (*newclient)(struct socketio_handle *sh))
{
	int res;
	struct addrinfo *ai_res, *curr;
	struct addrinfo ai_hints;
	struct socketio_handle *ret;

	assert(port != NULL);
	assert(family == 0 || family == AF_INET || family == AF_INET6);
	assert(socktype == SOCK_STREAM || socktype == SOCK_DGRAM);

	memset(&ai_hints, 0, sizeof ai_hints);
	ai_hints.ai_flags = AI_PASSIVE;
	ai_hints.ai_family = family;
	ai_hints.ai_socktype = socktype;

	res = getaddrinfo(host, port, &ai_hints, &ai_res);

	if (res != 0) {
		ERROR_FMT("hostname parsing error:%s\n", gai_strerror(res));
		return 0;
	}

	/* looks for the first AF_INET or AF_INET6 entry */
	for (curr = ai_res; curr; curr = curr->ai_next) {
		TRACE("getaddrinfo():family=%d type=%d\n", curr->ai_family, curr->ai_socktype);

		if (curr->ai_family == AF_INET6 || curr->ai_family == AF_INET) {
			break;
		}
	}

	if (!curr) {
		freeaddrinfo(ai_res);
		ERROR_FMT("Could not find interface for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	assert(socktype == SOCK_STREAM || socktype == SOCK_DGRAM);

	ret = socketio_listen_bind(curr, newclient);

	if (!ret) {
		freeaddrinfo(ai_res);
		ERROR_FMT("Could bind socket for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	freeaddrinfo(ai_res);
	return ret; /* success */
}

/******************************************************************************
 * Client - handles client connections
 ******************************************************************************/

/** specialized socketio_handle for serving up telnet clients. */
struct telnetclient {
	struct socketio_handle *sh;
	struct buffer output, input;
	/** terminal information: width, height, terminale type. */
	struct terminal {
		int width, height;
		char name[32];
	} terminal;
	int prompt_flag; /* true if prompt has been sent */
	const char *prompt_string;
	void (*line_input)(struct telnetclient *cl, const char *line);
	void (*state_free)(struct telnetclient *cl);
	/** client's statue. */
	union state_data {
		/** undocumented - please add documentation. */
		struct login_state {
			char username[16];
		} login;
		struct form_state form;
		/** undocumented - please add documentation. */
		struct menu_state {
			const struct menuinfo *menu; /* current menu */
		} menu;
	} state;
	struct user *user;
	unsigned nr_channel; /**< number of channels monitoring. */
	struct channel **channel; /**< pointer to every monitoring channel. */
	struct channel_member channel_member;
};

/**
 * @return the username
 */
EXPORT const char *telnetclient_username(struct telnetclient *cl)
{
	return cl && cl->user && cl->user->username ? cl->user->username : "<UNKNOWN>";
}

/** write a null terminated string to a telnetclient buffer. */
int telnetclient_puts(struct telnetclient *cl, const char *str)
{
	int res;
	assert(cl != NULL);
	assert(cl->sh != NULL);
	res = buffer_puts(&cl->output, str);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag = 0;

	return res;
}

/** vprintf for a telnetclient output buffer. */
int telnetclient_vprintf(struct telnetclient *cl, const char *fmt, va_list ap)
{
	int res;

	assert(cl != NULL);
	assert(cl->sh != NULL);
	assert(fmt != NULL);

	res = buffer_vprintf(&cl->output, fmt, ap);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag = 0;

	return res;
}

/** printf for a telnetclient output buffer. */
int telnetclient_printf(struct telnetclient *cl, const char *fmt, ...)
{
	va_list ap;
	int res;

	assert(cl != NULL);
	assert(cl->sh != NULL);
	assert(fmt != NULL);

	va_start(ap, fmt);
	res = buffer_vprintf(&cl->output, fmt, ap);
	va_end(ap);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag = 0;
	return res;
}

/** releases current state (frees it). */
static void telnetclient_clear_statedata(struct telnetclient *cl)
{
	if (cl->state_free) {
		cl->state_free(cl);
		cl->state_free = NULL;
	}

	memset(&cl->state, 0, sizeof cl->state);
}

static int telnetclient_channel_add(struct telnetclient *cl, struct channel *ch)
{
	struct channel **newlist;

	assert(cl != NULL);

	if (!ch) return 1; /* adding NULL is ignored. */

	if (!channel.join(ch, &cl->channel_member)) return 0; /* could not join channel. */

	newlist = realloc(cl->channel, sizeof * cl->channel * (cl->nr_channel + 1));

	if (!newlist) {
		PERROR("realloc()");

		return 0; /* could not allocate. */
	}

	cl->channel = newlist;
	cl->channel[cl->nr_channel++] = ch;

	return 1; /* success */
}

static int telnetclient_channel_remove(struct telnetclient *cl, struct channel *ch)
{
	unsigned i;

	assert(cl != NULL);

	if (!ch) return 1; /* removng NULL is ignored. */

	for (i = 0; i < cl->nr_channel; i++) {
		if (cl->channel[i] == ch) {
			DEBUG("channel.part(%p, %p)\n", (void*)cl->channel[i], (void*)&cl->channel_member);

			channel.part(cl->channel[i], &cl->channel_member);

			cl->channel[i] = NULL;
			assert(cl->nr_channel > 0); /* can't enter this condition when no channels. */
			cl->channel[i] = cl->channel[--cl->nr_channel];

			if (!cl->nr_channel) {
				/* if not in any channels then free the array. */
				free(cl->channel);
				cl->channel = NULL;
			}

			return 1; /* success */
		}
	}

	return 0; /* not found. */
}

/** free a telnetclient structure. */
static void telnetclient_free(struct socketio_handle *sh, void *p)
{
	struct telnetclient *client = p;

	assert(client != NULL);

	if (!client)
		return;

	TODO("Determine if connection was logged in first");
	eventlog_signoff(telnetclient_username(client), sh->name); /** @todo fix the username field */

	DEBUG("freeing client '%s'\n", sh->name);

	if (sh->fd != INVALID_SOCKET) {
		TODO("I forget the purpose of this code");
		/* only call this if the client wasn't closed earlier */
		socketio_readready(sh->fd);
	}

	if (!sh->delete_flag) {
		ERROR_MSG("WARNING: delete_flag was not set before freeing");
	}

	/* forcefully leave all channels */
	/* TODO: nobody is notified that we left, this is not ideal. */
	client->channel_member.send = NULL;
	client->channel_member.p = NULL;
	DEBUG("client->nr_channel=%d\n", client->nr_channel);

	while (client->nr_channel) {
		telnetclient_channel_remove(client, client->channel[0]);
	}

	telnetclient_clear_statedata(client); /* free data associated with current state */

	/* break connection to the extra data pointer */
	sh->extra = NULL;
	client->sh = NULL;

	buffer_free(&client->output);
	buffer_free(&client->input);

	user_put(&client->user);

	TODO("free any other data structures associated with client"); /* be vigilant about memory leaks */

#ifndef NDEBUG
	memset(client, 0xBB, sizeof * client); /* fill with fake data before freeing */
#endif

	free(client);
}

static void telnetclient_channel_send(struct channel_member *cm, struct channel *ch, const char *msg)
{
	struct telnetclient *cl;

	assert(cm != NULL);
	assert(msg != NULL);

	if (!cm) return;

	cl = cm->p;

	/* TODO: fill in a channel name? */
	telnetclient_printf(cl, "[%p] %s\n", (void*)ch, msg);
}

/** allocate a new telnetclient based on an existing valid socketio_handle. */
static struct telnetclient *telnetclient_newclient(struct socketio_handle *sh)
{
	struct telnetclient *cl;
	cl = malloc(sizeof * cl);
	FAILON(!cl, "malloc()", failed);

	JUNKINIT(cl, sizeof * cl);

	buffer_init(&cl->output, TELNETCLIENT_OUTPUT_BUFFER_SZ);
	buffer_init(&cl->input, TELNETCLIENT_INPUT_BUFFER_SZ);
	cl->terminal.width = cl->terminal.height = 0;
	strcpy(cl->terminal.name, "");
	cl->state_free = NULL;
	telnetclient_clear_statedata(cl);
	cl->line_input = NULL;
	cl->prompt_flag = 0;
	cl->prompt_string = NULL;
	cl->sh = sh;
	cl->user = NULL;

	cl->nr_channel = 0;
	cl->channel = NULL;
	cl->channel_member.send = telnetclient_channel_send;
	cl->channel_member.p = cl;

	sh->extra = cl;
	sh->extra_free = telnetclient_free;

	telnetclient_channel_add(cl, channel.public(0));

	return cl;
failed:
	return NULL;
}

/**
 * replaces the current user with a different one and updates the reference counts.
 */
static void telnetclient_setuser(struct telnetclient *cl, struct user *u)
{
	struct user *old_user;
	assert(cl != NULL);
	old_user = cl->user;
	cl->user = u;
	user_get(u);
	user_put(&old_user);
}

/**
 * posts telnet protocol necessary to begin negotiation of options.
 */
static int telnetclient_telnet_init(struct telnetclient *cl)
{
	const char support[] = {
		IAC, DO, TELOPT_LINEMODE,
		IAC, DO, TELOPT_NAWS,		/* window size events */
		IAC, DO, TELOPT_TTYPE,		/* accept terminal-type infomation */
		IAC, SB, TELOPT_TTYPE, TELQUAL_SEND, IAC, SE, /* ask the terminal type */
	};

	if (buffer_write_noexpand(&cl->output, support, sizeof support) < 0) {
		DEBUG_MSG("write failure");
		telnetclient_close(cl);
		return 0; /* failure */
	}

	return 1; /* success */
}

/** send TELNET protocol messages to control echo mode. */
static int telnetclient_echomode(struct telnetclient *cl, int mode)
{
	static const char echo_off[] = { IAC, WILL, TELOPT_ECHO }; /* OFF */
	static const char echo_on[] = { IAC, WONT, TELOPT_ECHO }; /* ON */
	const char *s;
	size_t len;

	if (mode) {
		s = echo_on;
		len = sizeof echo_on;
	} else {
		s = echo_off;
		len = sizeof echo_off;
	}

	if (buffer_write_noexpand(&cl->output, s, len) < 0) {
		DEBUG_MSG("write failure");
		cl->sh->delete_flag = 1;
		return 0; /* failure */
	}

	return 1; /* success */
}

/** send TELNET protocol messages to control line mode. */
static int telnetclient_linemode(struct telnetclient *cl, int mode)
{
	const char enable[] = {
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_EDIT | MODE_TRAPSIG, IAC, SE
	};
	const char disable[] = { /* character at a time mode */
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_TRAPSIG, IAC, SE
	};
	const char *s;
	size_t len;

	if (mode) {
		s = enable;
		len = sizeof enable;
	} else {
		s = disable;
		len = sizeof disable;
	}

	if (buffer_write_noexpand(&cl->output, s, len) < 0) {
		DEBUG_MSG("write failure");
		cl->sh->delete_flag = 1;
		return 0; /* failure */
	}

	return 1; /* success */
}

/** callback used when a socketio_handle for a telnetclient is write-ready. */
EXPORT void telnetclient_write_event(struct socketio_handle *sh, SOCKET fd, void *p)
{
	const char *data;
	size_t len;
	int res;
	struct telnetclient *cl = p;

	assert(cl->sh->delete_flag == 0); /* we should never be called if already deleted */

	/* only call this if the client wasn't closed and we have data in our buffer */
	assert(cl != NULL);
	assert(sh == cl->sh);

	data = buffer_data(&cl->output, &len);
	res = socketio_send(fd, data, len);

	if (res < 0) {
		sh->delete_flag = 1;
		return; /* client write failure */
	}

	TRACE("len=%zu res=%zu\n", len, res);
	len = buffer_consume(&cl->output, (unsigned)res);

	if (len > 0) {
		/* there is still data in our buffer */
		socketio_writeready(fd);
	}
}

/**
 * for processing IAC SB.
 */
static void telnetclient_iac_process_sb(const char *iac, size_t len, struct telnetclient *cl)
{
	assert(cl != NULL);
	assert(iac[0] == IAC);
	assert(iac[1] == SB);

	if (!iac) return;

	if (!cl) return;

	switch(iac[2]) {
	case TELOPT_TTYPE:
		if (iac[3] == TELQUAL_IS) {
			if (len < 9) {
				ERROR_MSG("WARNING: short IAC SB TTYPE IS .. IAC SE");
				return;
			}

			snprintf(cl->terminal.name, sizeof cl->terminal.name, "%.*s", (int)len - 4 - 2, iac + 4);
			DEBUG("%s:Client terminal type is now \"%s\"\n", cl->sh->name, cl->terminal.name);
			/*
			telnetclient_printf(cl, "Terminal type: %s\n", cl->terminal.name);
			*/
		}

		break;

	case TELOPT_NAWS: {
		if (len < 9) {
			ERROR_MSG("WARNING: short IAC SB NAWS .. IAC SE");
			return;
		}

		assert(len == 9);
		cl->terminal.width = RD_BE16(iac, 3);
		cl->terminal.height = RD_BE16(iac, 5);
		DEBUG("%s:Client display size is now %ux%u\n", cl->sh->name, cl->terminal.width, cl->terminal.height);
		/*
		telnetclient_printf(cl, "display size is: %ux%u\n", cl->terminal.width, cl->terminal.height);
		*/
		break;
	}
	}
}

/**
 * @return 0 means "incomplete" data for this function
 */
static size_t telnetclient_iac_process(const char *iac, size_t len, void *p)
{
	struct telnetclient *cl = p;
	const char *endptr;

	assert(iac != NULL);
	assert(iac[0] == IAC);

	if (iac[0] != IAC) {
		ERROR_MSG("called on non-telnet data\n");
		return 0;
	}

	switch(iac[1]) {
	case IAC:
		return 1; /* consume the first IAC and leave the second behind */

	case WILL:
		if (len >= 3) {
			DEBUG("IAC WILL %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case WONT:
		if (len >= 3) {
			DEBUG("IAC WONT %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case DO:
		if (len >= 3) {
			DEBUG("IAC DO %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case DONT:
		if (len >= 3) {
			DEBUG("IAC DONT %hhu\n", iac[2]);
			return 3; /* 3-byte operations*/
		} else {
			return 0; /* not enough data */
		}

	case SB:
		/* look for IAC SE */
		TRACE("IAC SB %hhu found\n", iac[2]);
		endptr = iac + 2;

		while ((endptr = memchr(endptr, IAC, len - (endptr - iac)))) {
			assert(endptr[0] == IAC);
			TRACE("found IAC %hhu\n", endptr[1]);
			endptr++;

			if ((endptr - iac) >= (ptrdiff_t)len) {
				DEBUG_MSG("Unterminated IAC SB sequence");
				return 0; /* unterminated */
			}

			if (endptr[0] == SE) {
				endptr++;
				// DEBUG("IAC SB %hhu ... IAC SE\n", iac[2]);
				HEXDUMP(iac, endptr - iac, "%s():IAC SB %hhu: ", __func__, iac[2]);
				telnetclient_iac_process_sb(iac, (size_t)(endptr - iac), cl);
				return endptr - iac;
			} else if (endptr[0] == IAC) {
				TRACE_MSG("Found IAC IAC in IAC SB block");
				endptr++;
			}
		}

		return 0; /* unterminated IAC SB sequence */

	case SE:
		ERROR_MSG("found IAC SE without IAC SB, ignoring it.");

	/* fall through */
	default:
		if (len >= 3)
			return 2; /* treat anything we don't know about as a 2-byte operation */
		else
			return 0; /* not enough data */
	}

	/* we should never get to this point */

}

/**
 * pull data from socket into buffer.
 */
static int telnetclient_recv(struct socketio_handle *sh, struct telnetclient *cl)
{
	char *data;
	size_t len;
	int res;

	data = buffer_load(&cl->input, &len);

	if (len == 0) {
		ERROR_FMT("WARNING:input buffer full, closing connection %s\n", sh->name);
		goto failure;
	}

	res = socketio_recv(sh->fd, data, len);

	if (res <= 0) {
		/* close or error */
		goto failure;
	}

	DEBUG("res=%u\n", res);
	buffer_emit(&cl->input, (unsigned)res);

	DEBUG("Client %d(%s):received %d bytes (used=%zu)\n", sh->fd, sh->name, res, cl->input.used);

	return 1;
failure:
	/* close the socket and free the client */
	telnetclient_close(cl);

	return 0;
}

/** read event callback when a telnetclient is doing line oriented input. */
EXPORT void telnetclient_rdev_lineinput(struct socketio_handle *sh, SOCKET fd, void *extra)
{
	const char *line;
	size_t consumed;
	struct telnetclient *cl = extra;

	/* pull data from socket into buffer */
	if (!telnetclient_recv(sh, cl)) {
		return; /* failure */
	}

	/* getline triggers a special IAC parser that stops at a line */
	while ((line = buffer_getline(&cl->input, &consumed, telnetclient_iac_process, cl))) {
		DEBUG("client line: '%s'\n", line);

		if (cl->line_input) {
			cl->line_input(cl, line);
		}

		buffer_consume(&cl->input, consumed);

		if (sh->read_event != telnetclient_rdev_lineinput) break;
	}

	socketio_readready(fd); /* only call this if the client wasn't closed earlier */

	return;
}

/** configures the prompt string for telnetclient_rdev_lineinput. */
static void telnetclient_setprompt(struct telnetclient *cl, const char *prompt)
{
	cl->prompt_string = prompt ? prompt : "? ";
	telnetclient_puts(cl, cl->prompt_string);
	cl->prompt_flag = 1;
}

/** start line input mode on a telnetclient. */
static void telnetclient_start_lineinput(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt)
{
	assert(cl != NULL);
	telnetclient_setprompt(cl, prompt);
	cl->line_input = line_input;
	cl->sh->read_event = telnetclient_rdev_lineinput;
}

/**
 * @return true if client is still in this state
 */
static int telnetclient_isstate(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt)
{

	if (!cl) return 0;

	return cl->sh->read_event == telnetclient_rdev_lineinput && cl->line_input == line_input && cl->prompt_string == prompt;
}

/** callback to handle a line of input. */
static void menu_lineinput(struct telnetclient *cl, const char *line)
{
	menu_input(cl, cl->state.menu.menu, line);
}

/** start menu input mode for a telnet client. */
static void telnetclient_start_menuinput(struct telnetclient *cl, struct menuinfo *menu)
{
	telnetclient_clear_statedata(cl); /* this is a fresh state */
	cl->state.menu.menu = menu;
	menu_show(cl, cl->state.menu.menu);
	telnetclient_start_lineinput(cl, menu_lineinput, mud_config.menu_prompt);
}

/**
 * callback given to socketio_listen to create telnetclients on accept.
 */
EXPORT void telnetclient_new_event(struct socketio_handle *sh)
{
	struct telnetclient *cl;

	cl = telnetclient_newclient(sh);

	if (!cl) {
		return; /* failure */
	}

	sh->write_event = telnetclient_write_event;
	sh->read_event = NULL;

	if (!telnetclient_telnet_init(cl) || !telnetclient_linemode(cl, 1) || !telnetclient_echomode(cl, 1)) {
		return; /* failure, the client would have been deleted */
	}

	fprintf(stderr, "*** Connection %d: %s\n", sh->fd, sh->name);
	telnetclient_puts(cl, mud_config.msgfile_welcome);
	telnetclient_start_menuinput(cl, &gamemenu_login);
}

/** mark a telnetclient to be closed and freed. */
EXPORT void telnetclient_close(struct telnetclient *cl)
{
	if (cl && cl->sh && !cl->sh->delete_flag) {
		cl->sh->delete_flag = 1; /* cause deletetion later */
		socketio_delete_count++;
	}
}

/** display the currently configured prompt string again. */
EXPORT void telnetclient_prompt_refresh(struct telnetclient *cl)
{
	if (cl && cl->prompt_string && !cl->prompt_flag) {
		telnetclient_setprompt(cl, cl->prompt_string);
	}
}

/** update the prompts on all open sockets if they are type 1(client). */
EXPORT void telnetclient_prompt_refresh_all(void)
{
	struct socketio_handle *curr, *next;

	for (curr = LIST_TOP(socketio_handle_list); curr; curr = next) {
		next = LIST_NEXT(curr, list);

		if (curr->type == 1 && curr->extra) {
			telnetclient_prompt_refresh(curr->extra);
		}
	}
}

/******************************************************************************
 * Menus
 ******************************************************************************/

/** structure that defined an item in a menu. */
struct menuitem {
	LIST_ENTRY(struct menuitem) item;
	char *name;
	char key;
	void (*action_func)(void *p, long extra2, void *extra3);
	long extra2;
	void *extra3;
};

/** initialize a menuinfo structure. */
EXPORT void menu_create(struct menuinfo *mi, const char *title)
{
	assert(mi != NULL);
	LIST_INIT(&mi->items);
	mi->title_width = strlen(title);
	mi->title = malloc(mi->title_width + 1);
	FAILON(!mi->title, "malloc()", failed);
	strcpy(mi->title, title);
	mi->tail = NULL;
failed:
	return;
}

/** add a new menuitem to a menuinfo. */
EXPORT void menu_additem(struct menuinfo *mi, int ch, const char *name, void (*func)(void*, long, void*), long extra2, void *extra3)
{
	struct menuitem *newitem;
	newitem = malloc(sizeof * newitem);
	newitem->name = strdup(name);
	newitem->key = ch;
	TODO("check for duplicate keys");
	newitem->action_func = func;
	newitem->extra2 = extra2;
	newitem->extra3 = extra3;

	if (mi->tail) {
		LIST_INSERT_AFTER(mi->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&mi->items, newitem, item);
	}

	mi->tail = newitem;
}

/**
 * draw a little box around the string.
 */
static void menu_titledraw(struct telnetclient *cl, const char *title, size_t len)
{
#if __STDC_VERSION__ >= 199901L
	char buf[len + 2];
#else
	char buf[256];

	if (len > sizeof buf - 1)
		len = sizeof buf - 1;

#endif
	memset(buf, '=', len);
	buf[len] = '\n';
	buf[len + 1] = 0;

	if (cl)
		telnetclient_puts(cl, buf);

	DEBUG("%s>>%s", cl ? cl->sh->name : "", buf);

	if (cl)
		telnetclient_printf(cl, "%s\n", title);

	DEBUG("%s>>%s\n", cl ? cl->sh->name : "", title);

	if (cl)
		telnetclient_puts(cl, buf);

	DEBUG("%s>>%s", cl ? cl->sh->name : "", buf);
}

/** send the selection menu to a telnetclient. */
EXPORT void menu_show(struct telnetclient *cl, const struct menuinfo *mi)
{
	const struct menuitem *curr;

	assert(mi != NULL);
	menu_titledraw(cl, mi->title, mi->title_width);

	for (curr = LIST_TOP(mi->items); curr; curr = LIST_NEXT(curr, item)) {
		if (curr->key) {
			if (cl)
				telnetclient_printf(cl, "%c. %s\n", curr->key, curr->name);

			DEBUG("%s>>%c. %s\n", cl ? cl->sh->name : "", curr->key, curr->name);
		} else {
			if (cl)
				telnetclient_printf(cl, "%s\n", curr->name);

			DEBUG("%s>>%s\n", cl ? cl->sh->name : "", curr->name);
		}
	}
}

/** process input into the menu system. */
EXPORT void menu_input(struct telnetclient *cl, const struct menuinfo *mi, const char *line)
{
	const struct menuitem *curr;

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	for (curr = LIST_TOP(mi->items); curr; curr = LIST_NEXT(curr, item)) {
		if (tolower(*line) == tolower(curr->key)) {
			if (curr->action_func) {
				curr->action_func(cl, curr->extra2, curr->extra3);
			} else {
				telnetclient_puts(cl, mud_config.msg_unsupported);
				menu_show(cl, mi);
			}

			return;
		}
	}

	telnetclient_puts(cl, mud_config.msg_invalidselection);
	menu_show(cl, mi);
	telnetclient_setprompt(cl, mud_config.menu_prompt);
}

/**
 * used as a generic starting point for menus.
 */
static void menu_start(void *p, long unused2 UNUSED, void *extra3)
{
	struct telnetclient *cl = p;
	struct menuinfo *mi = extra3;
	telnetclient_start_menuinput(cl, mi);
}

/******************************************************************************
 * command - handles the command processing
 ******************************************************************************/

/** action callback to do the "pose" command. */
static int command_do_pose(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "yell" command. */
static int command_do_yell(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in yelling distance");
	telnetclient_printf(cl, "%s yells \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "say" command. */
static int command_do_say(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct channel *ch;
	struct channel_member *exclude_list[1];
	TODO("Get user name");
	telnetclient_printf(cl, "You say \"%s\"\n", arg);
	ch = channel.public(0);
	exclude_list[0] = &cl->channel_member; /* don't send message to self. */
	channel.broadcast(ch, exclude_list, 1, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "emote" command. */
static int command_do_emote(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "chsay" command. */
static int command_do_chsay(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	TODO("pass the channel name in a way that makes sense");
	TODO("Get user name");
	TODO("Broadcast to everyone in a channel");
	telnetclient_printf(cl, "%s says \"%s\"\n", telnetclient_username(cl), arg);

	return 1; /* success */
}

/** action callback to do the "quit" command. */
static int command_do_quit(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	/** @todo
	 * the close code needs to change the state so telnetclient_isstate
	 * does not end up being true for a future read?
	 */
	telnetclient_close(cl);

	return 1; /* success */
}

/** action callback to do the "roomget" command. */
static int command_do_roomget(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct room *r;
	char roomnum_str[64];
	unsigned roomnum;
	char attrname[64];
	const char *attrvalue;

	arg = util_getword(arg, roomnum_str, sizeof roomnum_str);
	roomnum = strtoul(roomnum_str, 0, 10); /* TODO: handle errors. */

	arg = util_getword(arg, attrname, sizeof attrname);

	r = room.get(roomnum);

	if (!r) {
		telnetclient_printf(cl, "room \"%s\" not found.\n", roomnum_str);
		return 0;
	}

	attrvalue = room.attr_get(r, attrname);

	if (attrvalue) {
		telnetclient_printf(cl, "room \"%s\" \"%s\" = \"%s\"\n", roomnum_str, attrname, attrvalue);
	} else {
		telnetclient_printf(cl, "room \"%s\" attribute \"%s\" not found.\n", roomnum_str, attrname);
	}

	room.put(r);

	return 1; /* success */
}

/** action callback to do the "char" command. */
static int command_do_character(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg)
{
	struct character *ch;
	char act[64];
	char tmp[64];
	unsigned ch_id;

	assert(arg != NULL);

	arg = util_getword(arg, act, sizeof act);

	if (!strcasecmp(act, "new")) {
		ch = character.new();
		telnetclient_printf(cl, "Created character %s.\n", character.attr_get(ch, "id"));
		character.put(ch);
	} else if (!strcasecmp(act, "get")) {
		arg = util_getword(arg, tmp, sizeof tmp);
		ch_id = strtoul(tmp, 0, 10); /* TODO: handle errors. */
		ch = character.get(ch_id);

		if (ch) {
			/* get attribute name. */
			arg = util_getword(arg, tmp, sizeof tmp);
			telnetclient_printf(cl, "Character %u \"%s\" = \"%s\"\n", ch_id, tmp, character.attr_get(ch, tmp));
			character.put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", tmp);
		}
	} else if (!strcasecmp(act, "set")) {
		arg = util_getword(arg, tmp, sizeof tmp);
		ch_id = strtoul(tmp, 0, 10); /* TODO: handle errors. */
		ch = character.get(ch_id);

		if (ch) {
			/* get attribute name. */
			arg = util_getword(arg, tmp, sizeof tmp);

			/* find start of value. */
			while (*arg && isspace(*arg)) arg++;

			if (!character.attr_set(ch, tmp, arg)) {
				telnetclient_printf(cl, "Could not set \"%s\" on character %u.\n", tmp, ch_id);
			}

			character.put(ch);
		} else {
			telnetclient_printf(cl, "Unknown character \"%s\"\n", tmp);
		}
	} else {
		telnetclient_printf(cl, "unknown action \"%s\"\n", act);
	}

	return 1; /* success */
}

/** action callback to do the "quit" command. */
static int command_do_time(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	show_gametime(cl);

	return 1; /* success */
}

/** action callback to remote that a command is not implemented. */
static int command_not_implemented(struct telnetclient *cl, struct user *u UNUSED, const char *cmd UNUSED, const char *arg UNUSED)
{
	telnetclient_puts(cl, "Not implemented\n");

	return 1; /* success */
}

/** table of every command string and its callback function. */
static const struct command_table {
	char *name; /**< full command name. */
	int (*cb)(struct telnetclient *cl, struct user *u, const char *cmd, const char *arg);
} command_table[] = {
	{ "who", command_not_implemented },
	{ "quit", command_do_quit },
	{ "page", command_not_implemented },
	{ "say", command_do_say },
	{ "yell", command_do_yell },
	{ "emote", command_do_emote },
	{ "pose", command_do_pose },
	{ "chsay", command_do_chsay },
	{ "sayto", command_not_implemented },
	{ "tell", command_not_implemented },
	{ "time", command_do_time },
	{ "whisper", command_not_implemented },
	{ "to", command_not_implemented },
	{ "help", command_not_implemented },
	{ "spoof", command_not_implemented },
	{ "roomget", command_do_roomget },
	{ "char", command_do_character },
};

/**
 * table of short commands, they must start with a punctuation. ispunct()
 * but they can be more than one character long, the table is first match.
 */
static const struct command_short_table {
	char *shname; /**< short commands. */
	char *name; /**< full command name. */
} command_short_table[] = {
	{ ":", "pose" },
	{ "'", "say" },
	{ "\"\"", "yell" },
	{ "\"", "say" },
	{ ",", "emote" },
	{ ".", "chsay" },
	{ ";", "spoof" },
};

/**
 * use cmd to run a command from the command_table array.
 */
static int command_run(struct telnetclient *cl, struct user *u, const char *cmd, const char *arg)
{
	unsigned i;

	/* search for a long command. */
	for (i = 0; i < NR(command_table); i++) {
		if (!strcasecmp(cmd, command_table[i].name)) {
			return command_table[i].cb(cl, u, cmd, arg);
		}
	}

	telnetclient_puts(cl, mud_config.msg_invalidcommand);

	return 0; /* failure */
}

/**
 * executes a command for user u.
 */
static int command_execute(struct telnetclient *cl, struct user *u, const char *line)
{
	char cmd[64];
	const char *e, *arg;
	unsigned i;

	assert(cl != NULL); /** @todo support cl as NULL for silent/offline commands */
	assert(line != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	TODO("Can we eliminate trailing spaces?");

	TODO("can we define these 1 character commands as aliases?");

	if (ispunct(line[0])) {
		for (i = 0; i < NR(command_short_table); i++) {
			const char *shname = command_short_table[i].shname;
			int shname_len = strlen(shname);

			if (!strncmp(line, shname, shname_len)) {
				/* find start of arguments, after the short command. */
				arg = line + shname_len;

				/* ignore leading spaces */
				while (*arg && isspace(*arg)) arg++;

				/* use the name as the cmd. */
				return command_run(cl, u, command_short_table[i].name, arg);
			}
		}
	}

	/* copy the first word into cmd[] */
	e = line + strcspn(line, " \t");
	arg = *e ? e + 1 + strspn(e + 1, " \t") : e; /* point to where the args start */

	while (*arg && isspace(*arg)) arg++; /* ignore leading spaces */

	assert(e >= line);

	if ((unsigned)(e - line) > sizeof cmd - 1) { /* first word is too long */
		DEBUG("Command length %td is too long, truncating\n", e - line);
		e = line + sizeof cmd - 1;
	}

	memcpy(cmd, line, (unsigned)(e - line));
	cmd[e - line] = 0;

	TODO("check for \"playername,\" syntax for directed speech");

	TODO("check user aliases");

	DEBUG("cmd=\"%s\"\n", cmd);

	return command_run(cl, u, cmd, arg);
}

/** callback to process line input. */
static void command_lineinput(struct telnetclient *cl, const char *line)
{
	assert(cl != NULL);
	assert(cl->sh != NULL);
	DEBUG("%s:entered command '%s'\n", telnetclient_username(cl), line);

	/* log command input */
	eventlog_commandinput(cl->sh->name, telnetclient_username(cl), line);

	/* do something with the command */
	command_execute(cl, NULL, line); /** @todo pass current user and character */

	/* check if we should update the prompt */
	if (telnetclient_isstate(cl, command_lineinput, mud_config.command_prompt)) {
		telnetclient_setprompt(cl, mud_config.command_prompt);
	}
}

/** start line input mode and send it to command_lineinput. */
static void command_start_lineinput(struct telnetclient *cl)
{
	telnetclient_printf(cl, "Terminal type: %s\n", cl->terminal.name);
	telnetclient_printf(cl, "display size is: %ux%u\n", cl->terminal.width, cl->terminal.height);

	show_gametime(cl);

	telnetclient_start_lineinput(cl, command_lineinput, mud_config.command_prompt);
}

/** wrapper callback for a menuitem to start command mode. */
EXPORT void command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	command_start_lineinput(p);
}

/******************************************************************************
 * login - handles the login process
 ******************************************************************************/

/** undocumented - please add documentation. */
static void login_password_lineinput(struct telnetclient *cl, const char *line)
{
	struct user *u;

	assert(cl != NULL);
	assert(line != NULL);
	assert(cl->state.login.username[0] != '\0'); /* must have a valid username */

	TODO("complete login process");
	DEBUG("Login attempt: Username='%s'\n", cl->state.login.username);

	u = user_lookup(cl->state.login.username);

	if (u) {
		/* verify the password */
		if (sha1crypt_checkpass(u->password_crypt, line)) {
			telnetclient_setuser(cl, u);
			eventlog_signon(cl->state.login.username, cl->sh->name);
			telnetclient_printf(cl, "Hello, %s.\n\n", u->username);
			telnetclient_start_menuinput(cl, &gamemenu_main);
			return; /* success */
		}

		telnetclient_puts(cl, mud_config.msgfile_badpassword);
	} else {
		telnetclient_puts(cl, mud_config.msgfile_noaccount);
	}

	/* report the attempt */
	eventlog_login_failattempt(cl->state.login.username, cl->sh->name);

	/* failed logins go back to the login menu or disconnect */
	telnetclient_start_menuinput(cl, &gamemenu_login);
}

/** undocumented - please add documentation. */
static void login_password_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	struct telnetclient *cl = p;
	telnetclient_start_lineinput(cl, login_password_lineinput, "Password: ");
}

/** undocumented - please add documentation. */
static void login_username_lineinput(struct telnetclient *cl, const char *line)
{
	assert(line != NULL);

	telnetclient_clear_statedata(cl); /* this is a fresh state */
	cl->state_free = 0; /* this state does not require anything special to free */

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (!*line) {
		telnetclient_puts(cl, mud_config.msg_invalidusername);
		telnetclient_start_menuinput(cl, &gamemenu_login);
		return;
	}

	/* store the username for the password state to use */
	snprintf(cl->state.login.username, sizeof cl->state.login.username, "%s", line);

	login_password_start(cl, 0, 0);
}

/** undocumented - please add documentation. */
static void login_username_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	struct telnetclient *cl = p;
	telnetclient_start_lineinput(cl, login_username_lineinput, "Username: ");
}

/** undocumented - please add documentation. */
static void signoff(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	struct telnetclient *cl = p;
	telnetclient_close(cl);
}

/******************************************************************************
 * form - handles processing input forms
 ******************************************************************************/
#define FORM_FLAG_HIDDEN 1
#define FORM_FLAG_INVISIBLE 2

/** undocumented - please add documentation. */
static struct form *form_newuser_app;

/** undocumented - please add documentation. */
EXPORT void form_init(struct form *f, const char *title, void (*form_close)(struct telnetclient *cl, struct form_state *fs))
{
	LIST_INIT(&f->items);
	f->form_title = strdup(title);
	f->tail = NULL;
	f->form_close = form_close;
	f->item_count = 0;
	f->message = 0;
}

/**
 * define a message to be displayed on start.
 */
EXPORT void form_setmessage(struct form *f, const char *message)
{
	f->message = message;
}

/** undocumented - please add documentation. */
EXPORT void form_free(struct form *f)
{
	struct formitem *curr;

	TRACE_ENTER();

	free(f->form_title);
	f->form_title = NULL;

	while ((curr = LIST_TOP(f->items))) {
		LIST_REMOVE(curr, item);
		free(curr->name);
		free(curr->prompt);
		free(curr->description);
#ifndef NDEBUG
		memset(curr, 0x55, sizeof * curr); /* fill with fake data before freeing */
#endif
		free(curr);
	}

	memset(f, 0x55, sizeof * f); /* fill with fake data before freeing */
}

/** undocumented - please add documentation. */
EXPORT void form_additem(struct form *f, unsigned flags, const char *name, const char *prompt, const char *description, int (*form_check)(struct telnetclient *cl, const char *str))
{
	struct formitem *newitem;

	newitem = malloc(sizeof * newitem);
	newitem->name = strdup(name);
	newitem->description = strdup(description);
	newitem->prompt = strdup(prompt);
	newitem->flags = flags;
	newitem->form_check = form_check;
	newitem->value_index = f->item_count++;

	if (f->tail) {
		LIST_INSERT_AFTER(f->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&f->items, newitem, item);
	}

	f->tail = newitem;
}

/** undocumented - please add documentation. */
static struct formitem *form_getitem(struct form *f, const char *name)
{
	struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for (curr = LIST_TOP(f->items); curr; curr = LIST_NEXT(curr, item)) {
		if (!strcasecmp(curr->name, name)) {
			/* found first matching entry */
			return curr;
		}
	}

	ERROR_FMT("Unknown form variable '%s'\n", name);

	return NULL; /* not found */
}

/**
 * look up the user value from a form.
 */
static const char *form_getvalue(const struct form *f, unsigned nr_value, char **value, const char *name)
{
	const struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for (curr = LIST_TOP(f->items); curr; curr = LIST_NEXT(curr, item)) {
		if (!strcasecmp(curr->name, name) && curr->value_index < nr_value) {
			/* found matching entry that was in range */
			return value[curr->value_index];
		}
	}

	ERROR_FMT("Unknown form variable '%s'\n", name);

	return NULL; /* not found */
}

/** undocumented - please add documentation. */
static void form_menu_show(struct telnetclient *cl, const struct form *f, struct form_state *fs)
{
	const struct formitem *curr;
	unsigned i;

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	for (i = 0, curr = LIST_TOP(f->items); curr && (!fs || i < fs->nr_value); curr = LIST_NEXT(curr, item), i++) {
		const char *user_value;

		/* skip over invisible items without altering the count/index */
		while (curr && (curr->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE)
			curr = LIST_NEXT(curr, item);

		if (!curr)
			break;

		user_value = fs ? fs->value[curr->value_index] ? fs->value[curr->value_index] : "" : 0;

		if ((curr->flags & FORM_FLAG_HIDDEN) == FORM_FLAG_HIDDEN) {
			user_value = "<hidden>";
		}

		telnetclient_printf(cl, "%d. %s %s\n", i + 1, curr->prompt, user_value ? user_value : "");
	}

	telnetclient_printf(cl, "A. accept\n");
}

/** undocumented - please add documentation. */
static void form_lineinput(struct telnetclient *cl, const char *line)
{
	struct form_state *fs = &cl->state.form;
	const struct form *f = fs->form;
	char **value = &fs->value[fs->curritem->value_index];

	assert(f != NULL);
	assert(fs->curritem != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (*line) {
		/* check the input */
		if (fs->curritem->form_check && !fs->curritem->form_check(cl, line)) {
			DEBUG("%s:Invalid form input\n", cl->sh->name);
			telnetclient_puts(cl, mud_config.msg_tryagain);
			telnetclient_setprompt(cl, fs->curritem->prompt);
			return;
		}

		if (*value) {
			free(*value);
			*value = NULL;
		}

		*value = strdup(line);
		fs->curritem = LIST_NEXT(fs->curritem, item);

		if (fs->curritem && (!fs->done || ((fs->curritem->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE))) {
			/* go to next item if not done or if next item is invisible */
			telnetclient_puts(cl, fs->curritem->description);
			telnetclient_setprompt(cl, fs->curritem->prompt);
		} else {
			fs->done = 1; /* causes form entry to bounce back to form menu */
			/* a menu for verifying the form */
			form_menu_show(cl, f, fs);
			telnetclient_start_lineinput(cl, form_menu_lineinput, mud_config.form_prompt);
		}
	}
}

/** undocumented - please add documentation. */
static void form_menu_lineinput(struct telnetclient *cl, const char *line)
{
	struct form_state *fs = &cl->state.form;
	const struct form *f = fs->form;
	char *endptr;

	assert(cl != NULL);
	assert(line != NULL);

	while (*line && isspace(*line)) line++; /* ignore leading spaces */

	if (tolower(*line) == 'a') { /* accept */
		TODO("callback to close out the form");

		if (f->form_close) {
			/* this call will switch states on success */
			f->form_close(cl, fs);
		} else {
			/* fallback */
			DEBUG("%s:ERROR:going to main menu\n", cl->sh->name);
			telnetclient_puts(cl, mud_config.msg_errormain);
			telnetclient_start_menuinput(cl, &gamemenu_login);
		}

		return; /* success */
	} else {
		long i;
		i = strtol(line, &endptr, 10);

		if (endptr != line && i > 0) {
			for (fs->curritem = LIST_TOP(f->items); fs->curritem; fs->curritem = LIST_NEXT(fs->curritem, item)) {
				/* skip invisible entries in selection */
				if ((fs->curritem->flags & FORM_FLAG_INVISIBLE) == FORM_FLAG_INVISIBLE) continue;

				if (--i == 0) {
					telnetclient_start_lineinput(cl, form_lineinput, fs->curritem->prompt);
					return; /* success */
				}
			}
		}
	}

	/* invalid_selection */
	telnetclient_puts(cl, mud_config.msg_invalidselection);
	form_menu_show(cl, f, fs);
	telnetclient_setprompt(cl, mud_config.form_prompt);
}

/** undocumented - please add documentation. */
static void form_state_free(struct telnetclient *cl)
{
	struct form_state *fs = &cl->state.form;
	unsigned i;
	DEBUG("%s:freeing state\n", cl->sh->name);

	if (fs->value) {
		for (i = 0; i < fs->nr_value; i++) {
			if (fs->value[i]) {
				size_t len; /* carefully erase the data from the heap, it may be private */
				len = strlen(fs->value[i]);
				memset(fs->value[i], 0, len);
				free(fs->value[i]);
				fs->value[i] = NULL;
			}
		}

		free(fs->value);
	}

	fs->value = 0;
	fs->nr_value = 0;
}

/** undocumented - please add documentation. */
EXPORT void form_state_init(struct form_state *fs, const struct form *f)
{
	fs->form = f;
	fs->nr_value = 0;
	fs->value = NULL;
	fs->done = 0;
}

/** undocumented - please add documentation. */
static int form_createaccount_username_check(struct telnetclient *cl, const char *str)
{
	int res;
	size_t len;
	const char *s;

	TRACE_ENTER();

	assert(cl != NULL);

	len = strlen(str);

	if (len < 3) {
		telnetclient_puts(cl, mud_config.msg_usermin3);
		DEBUG_MSG("failure: username too short.");
		goto failure;
	}

	for (s = str, res = isalpha(*s); *s; s++) {
		res = res && isalnum(*s);

		if (!res) {
			telnetclient_puts(cl, mud_config.msg_useralphanumeric);
			DEBUG_MSG("failure: bad characters");
			goto failure;
		}
	}

	if (user_exists(str)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		DEBUG_MSG("failure: user exists.");
		goto failure;
	}

	DEBUG_MSG("success.");

	return 1;
failure:
	telnetclient_puts(cl, mud_config.msg_tryagain);
	telnetclient_setprompt(cl, cl->state.form.curritem->prompt);

	return 0;
}

static int form_createaccount_password_check(struct telnetclient *cl, const char *str)
{
	TRACE_ENTER();

	assert(cl != NULL);
	assert(cl->state.form.form != NULL);

	if (str && strlen(str) > 3) {
		DEBUG_MSG("success.");
		return 1;
	}

	/* failure */
	telnetclient_puts(cl, mud_config.msg_tryagain);
	telnetclient_setprompt(cl, cl->state.form.curritem->prompt);

	return 0;
}

/** verify that the second password entry matches the first */
static int form_createaccount_password2_check(struct telnetclient *cl, const char *str)
{
	const char *password1;
	struct form_state *fs = &cl->state.form;

	TRACE_ENTER();

	assert(cl != NULL);
	assert(fs->form != NULL);

	password1 = form_getvalue(fs->form, fs->nr_value, fs->value, "PASSWORD");

	if (password1 && !strcmp(password1, str)) {
		DEBUG_MSG("success.");
		return 1;
	}

	telnetclient_puts(cl, mud_config.msg_tryagain);
	fs->curritem = form_getitem((struct form*)fs->form, "PASSWORD"); /* rewind to password entry */
	telnetclient_setprompt(cl, fs->curritem->prompt);

	return 0;
}

/** undocumented - please add documentation. */
static void form_createaccount_close(struct telnetclient *cl, struct form_state *fs)
{
	const char *username, *password, *email;
	struct user *u;
	const struct form *f = fs->form;

	username = form_getvalue(f, fs->nr_value, fs->value, "USERNAME");
	password = form_getvalue(f, fs->nr_value, fs->value, "PASSWORD");
	email = form_getvalue(f, fs->nr_value, fs->value, "EMAIL");

	DEBUG("%s:create account: '%s'\n", cl->sh->name, username);

	if (user_exists(username)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		return;
	}

	u = user_create(username, password, email);

	if (!u) {
		telnetclient_printf(cl, "Could not create user named '%s'\n", username);
		return;
	}

	user_free(u);

	telnetclient_puts(cl, mud_config.msg_usercreatesuccess);

	TODO("for approvable based systems, disconnect the user with a friendly message");
	telnetclient_start_menuinput(cl, &gamemenu_login);
}

/** undocumented - please add documentation. */
static void form_start(void *p, long unused2 UNUSED, void *form)
{
	struct telnetclient *cl = p;
	struct form *f = form;
	struct form_state *fs = &cl->state.form;

	telnetclient_clear_statedata(cl); /* this is a fresh state */

	if (!mud_config.newuser_allowed) {
		/* currently not accepting applications */
		telnetclient_puts(cl, mud_config.msgfile_newuser_deny);
		telnetclient_start_menuinput(cl, &gamemenu_login);
		return;
	}

	if (f->message)
		telnetclient_puts(cl, f->message);

	cl->state_free = form_state_free;
	fs->form = f;
	fs->curritem = LIST_TOP(f->items);
	fs->nr_value = f->item_count;
	fs->value = calloc(fs->nr_value, sizeof * fs->value);

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	telnetclient_puts(cl, fs->curritem->description);
	telnetclient_start_lineinput(cl, form_lineinput, fs->curritem->prompt);
}

/** undocumented - please add documentation. */
static void form_createaccount_start(void *p, long unused2 UNUSED, void *unused3 UNUSED)
{
	form_start(p, 0, form_newuser_app);
}

/** undocumented - please add documentation. */
EXPORT struct form *form_load(const char *buf, void (*form_close)(struct telnetclient *cl, struct form_state *fs))
{
	const char *p, *tmp;
	char *name, *prompt, *description, *title;
	struct form *f;
	struct util_strfile h;
	size_t e, len;

	name = 0;
	prompt = 0;
	description = 0;
	f = 0;

	util_strfile_open(&h, buf);

	p = util_strfile_readline(&h, &len);

	if (!p) {
		ERROR_MSG("Could not parse form.");
		goto failure;
	}

	title = malloc(len + 1);
	memcpy(title, p, len);
	title[len] = 0;

	f = calloc(1, sizeof * f);
	form_init(f, title, form_close);

	free(title);
	title = NULL;

	/* count number of entries */
	while (1) {

		/* look for the name */
		do {
			p = util_strfile_readline(&h, &len);

			if (!p)
				goto done;

			while (isspace(*p)) p++ ; /* skip leading blanks and blank lines */

			for (e = 0; e < len && !isspace(p[e]); e++) ;
		} while (!e);

		/* found a word */
		name = malloc(e + 1);
		memcpy(name, p, e);
		name[e] = 0;

		/* look for the prompt */
		p = util_strfile_readline(&h, &len);

		if (!p) break;

		prompt = malloc(len + 1);
		memcpy(prompt, p, len);
		prompt[len] = 0;

		/* find end of description */
		tmp = strstr(h.buf, "\n~");

		if (!tmp)
			tmp = strlen(h.buf) + h.buf;
		else
			tmp++;

		len = tmp - h.buf;
		description = malloc(len + 1);
		memcpy(description, h.buf, len);
		description[len] = 0;
		h.buf = *tmp ? tmp + 1 : tmp;

		DEBUG("name='%s'\n", name);
		DEBUG("prompt='%s'\n", prompt);
		DEBUG("description='%s'\n", description);
		form_additem(f, 0, name, prompt, description, NULL);
		free(name);
		name = 0;
		free(prompt);
		prompt = 0;
		free(description);
		description = 0;
	}

done:
	util_strfile_close(&h);
	free(name); /* with current loop will always be NULL */
	free(prompt); /* with current loop will always be NULL */
	free(description); /* with current loop will always be NULL */
	return f;
failure:
	ERROR_MSG("Error loading form");
	util_strfile_close(&h);
	free(name);
	free(prompt);
	free(description);

	if (f) {
		form_free(f);
	}

	return NULL;
}

/** undocumented - please add documentation. */
EXPORT struct form *form_load_from_file(const char *filename, void (*form_close)(struct telnetclient *cl, struct form_state *fs))
{
	struct form *ret;
	char *buf;

	buf = util_textfile_load(filename);

	if (!buf) return 0;

	ret = form_load(buf, form_close);
	free(buf);

	return ret;
}

/** undocumented - please add documentation. */
EXPORT int form_module_init(void)
{
	struct formitem *fi;

	form_newuser_app = form_load_from_file(mud_config.form_newuser_filename, form_createaccount_close);

	if (!form_newuser_app) {
		ERROR_FMT("could not load %s\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi = form_getitem(form_newuser_app, "USERNAME");

	if (!fi) {
		ERROR_FMT("%s does not have a USERNAME field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi->form_check = form_createaccount_username_check;

	fi = form_getitem(form_newuser_app, "PASSWORD");

	if (!fi) {
		ERROR_FMT("%s does not have a PASSWORD field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	}

	fi->flags |= FORM_FLAG_HIDDEN; /* hidden */
	fi->form_check = form_createaccount_password_check;

	fi = form_getitem(form_newuser_app, "PASSWORD2");

	if (!fi) {
		VERBOSE("warning: %s does not have a PASSWORD2 field.\n", mud_config.form_newuser_filename);
		return 0; /* failure */
	} else {
		fi->flags |= FORM_FLAG_INVISIBLE; /* invisible */
		fi->form_check = form_createaccount_password2_check;
	}

	return 1;
}

/** undocumented - please add documentation. */
EXPORT void form_module_shutdown(void)
{
	form_free(form_newuser_app);
	free(form_newuser_app);
	form_newuser_app = NULL;
}

/******************************************************************************
 * Game - game logic
 ******************************************************************************/

/** undocumented - please add documentation. */
EXPORT int game_init(void)
{
	if (worldclock_init())
		return 0;

	/*** The login menu ***/
	menu_create(&gamemenu_login, "Login Menu");

	menu_additem(&gamemenu_login, 'L', "Login", login_username_start, 0, NULL);
	menu_additem(&gamemenu_login, 'N', "New User", form_createaccount_start, 0, NULL);
	menu_additem(&gamemenu_login, 'Q', "Disconnect", signoff, 0, NULL);

	/*** The Main Menu ***/
	menu_create(&gamemenu_main, "Main Menu");
	menu_additem(&gamemenu_main, 'E', "Enter the game", command_start, 0, NULL);
	// menu_additem(&gamemenu_main, 'C', "Create Character", form_start, 0, &character_form);
	menu_additem(&gamemenu_main, 'B', "Back to login menu", menu_start, 0, &gamemenu_login);
	menu_additem(&gamemenu_main, 'Q', "Disconnect", signoff, 0, NULL);

	return 1;
}

/******************************************************************************
 * Http parser
 ******************************************************************************/

/* return 0 if more data is needed. return -1 on error. */
static int http_parse(const char *request, size_t len)
{
	const char *s, *end;

	s = request;
	end = request + len - 1;

	/* method */
	if (s > end)
		return 0;

	if (!isalpha(*s))
		return -1; /* improperly formed */

	for (; isalpha(*s); s++) {
		if (s > end)
			return 0;
	}

	DEBUG_MSG("HTTP Request: METHOD - TODO");

	/* a single space */
	if (s > end)
		return 0;

	if (*s != ' ')
		return -1; /* improperly formed */

	s++;

	/* URI */
	if (s > end)
		return 0;

	/* accept any non-whitespace into the URI */
	if (isspace(*s))
		return -1; /* improperly formed */

	for (; !isspace(*s); s++) {
		if (s > end)
			return 0;
	}

	DEBUG_MSG("HTTP Request: URI - TODO");

	/* a single space */
	if (s > end)
		return 0;

	if (*s != ' ')
		return -1; /* improperly formed */

	s++;

	/* http version */
	if (s > end)
		return 0;

	/** @todo check for exactly: HTTP/1.1 */
	if (isspace(*s))
		return -1; /* improperly formed */

	for (; !isspace(*s); s++) {
		if (s > end)
			return 0;
	}

	/* CRLF */
	if (s > end)
		return 0;

	if (*s != '\r')
		return -1; /* improperly formed */

	s++;

	if (s > end)
		return 0;

	if (*s != '\n')
		return -1; /* improperly formed */

	s++;
	DEBUG_MSG("HTTP Request - end of method line");

	/* message headers ... */
	while (s <= end) {
		/* terminated by line beginning with CRLF */
		if (*s == '\r') {
			s++;

			if (s > end)
				return 0;

			if (*s != '\n')
				return -1; /* improperly formed */

			DEBUG_MSG("HTTP request Success!");
			return 1; /* success! */
		}

		/* header field */
		if (s > end)
			return 0;

		/** @todo don't silently ignore the headers. */
		for (; *s != '\r'; s++) {
			if (s > end)
				return 0; /* short */
		}

		s++;

		if (s > end)
			return 0; /* short */

		if (*s == '\n') {
			s++;
			/** @todo do something with this header field */
			DEBUG_MSG("HTTP Header field: TODO");
		} else {
			return -1; /* improperly formed */
		}
	}

	return 0;
}

/******************************************************************************
 * Webserver
 ******************************************************************************/

/**
 * handle for a webserver client.
 * holds a socketio_handle that points back to this structure through the
 * void *extra field.
 */
struct webserver {
	struct socketio_handle *sh; /**< socketio_handle associated with this entry. */
	/** @todo add some kind of pointer and offset for a pre-written request.
	 * reference count the request blob so it is freed once everyone is done.
	 *
	 * use some kind of look-up for what makes up a request to find if a blob
	 * is already in cache. perhaps a SHA1 of the filename+parameters. if time
	 * is a factor then make it like a paramter, where it is scaled to the
	 * resolution where it is important. (like 1-5 minute intervals for most
	 * status updates.)
	 *
	 * fully expanded @ref shvar_eval caches of the output could be kept this
	 * way.
	 *
	 * We could just keep a very short duration cache. Just for the active connection only, that
	 * would be the least effort. And would fit in well with the reference
	 * counting scheme. Time duration caches can be messier because some event
	 * other than simple client connections would have to be used to take and
	 * put the refcounts to expire the cache entry.
	 *
	 */
	unsigned state;
	unsigned write_pos, read_pos;
	char request[8192];
};

/**
 * the listening socket for the webserver.
 */
static struct socketio_handle *webserver_listen_handle;

/**
 * marks a webserver socket as needing to be reaped.
 */
static void webserver_close(struct webserver *ws)
{
	if (ws && ws->sh && !ws->sh->delete_flag) {
		ws->sh->delete_flag = 1; /* cause deletetion later */
		socketio_delete_count++; /* tracks if clean-up phase should be done. */
	}
}

/**
 * try to fill the input buffers on a read-ready event.
 */
static void webserver_read_event(struct socketio_handle *sh, SOCKET fd, void *extra)
{
	struct webserver *ws = extra;
	int res;
	char data[60]; /**< parser input buffer. */
	const size_t len = sizeof data; /**< parser input buffer size. */

	assert(sh != NULL);
	assert(ws != NULL);
	assert(fd != INVALID_SOCKET);
	assert(!sh->delete_flag);

	res = socketio_recv(fd, data, len);

	if (res <= 0) {
		/* close or error */
		webserver_close(ws);
		return;
	}

	/** @todo implement something to parse the input. use an HTTP parser state machine. */
	if (ws->state == 0) { /* 0 = parsing request */
		if (ws->read_pos + res > sizeof(ws->request)) {
			webserver_close(ws);
			return;
		}

		memcpy(ws->request + ws->read_pos, data, res);
		ws->read_pos += res;

		int http_result = http_parse(ws->request, ws->read_pos);

		if (http_result < 0) {
			ERROR_MSG("WARNING: bad HTTP request header");
			webserver_close(ws);
			return;
		} else if (http_result > 0) {
			/* pretend we have read in a useful request and also pretened we have
			 * pushed some data into a buffer to deliever.
			 */

			eventlog_webserver_get(sh->name, "/"); /**< @todo log the right URI. */

			/** @todo made up some non-zero number to get webserver_write_event() to work. */
			ws->state = 2;
			/* go into write mode to send our message. */
			socketio_writeready(fd);
		}
	}

	if (!ws->state) {
		/* keep sucking down data. */
		socketio_readready(fd);
	}
}

/**
 * empty the buffers into a socket on a write-ready event.
 */
static void webserver_write_event(struct socketio_handle *sh, SOCKET fd, void *extra)
{
	struct webserver *ws = extra;
	int res;
	const char data[] =
	        "HTTP/1.1 200 OK\r\n"
	        "Server: " __FILE__ "\r\n"
	        "Connection: close\r\n"
	        "Content-Type: text/plain\r\n"
	        "\r\n"
	        "Hello World. This is my webserver!\r\n";
	size_t data_len = strlen(data);

	assert(sh != NULL);
	assert(ws != NULL);
	assert(fd != INVALID_SOCKET);
	assert(!sh->delete_flag);
	assert(ws->write_pos <= data_len);

	res = socketio_send(fd, data + ws->write_pos, data_len - ws->write_pos);

	if (res < 0) {
		sh->delete_flag = 1;
		return; /* client write failure */
	}

	/* update the position in our output buffer (data[]) */
	ws->write_pos += res;

	/**
	 * check if res<len. the buffer wasn't completely transfered then set the socket
	 * as write-ready, else close the completed connection.
	 */

	if (ws->write_pos < data_len) {
		socketio_writeready(sh->fd);
	} else if (ws->write_pos == data_len) {
		/*
		ws->write_pos = 0;
		ws->state = 0;
		*/
		webserver_close(ws);
	}
}

/**
 * free a struct webserver client connection.
 */
static void webserver_free(struct socketio_handle *sh, void *p)
{
	struct webserver *ws = p;

	if (sh->fd != INVALID_SOCKET) {
		/* force a future invocation when the remote socket closes. */
		socketio_readready(sh->fd);
	}

	if (!sh->delete_flag) {
		ERROR_MSG("WARNING: delete_flag was not set before freeing");
	}

	/* detach our special data from the socketio_handle. */
	sh->extra = NULL;
	ws->sh = NULL;

	free(ws);
}

/**
 * creates a new webserver client connections from a socketio_handle.
 */
static struct webserver *webserver_newclient(struct socketio_handle *sh)
{
	struct webserver *ws;
	ws = calloc(1, sizeof * ws);
	ws->sh = sh;

	sh->extra = ws;
	sh->extra_free = webserver_free;

	sh->write_event = webserver_write_event;
	sh->read_event = webserver_read_event;

	/* being parsing input. */
	socketio_readready(sh->fd);

	return ws;
}

/**
 * create a new webserver on a new connection event from a listening socket.
 */
static void webserver_new_event(struct socketio_handle *sh)
{
	struct webserver *ws; /**< client connected to our webserver. */

	ws = webserver_newclient(sh);

}

/**
 * initialize the webserver module by binding a listening socket for the server.
 */
EXPORT int webserver_init(int family, unsigned port)
{
	char port_str[16];
	snprintf(port_str, sizeof port_str, "%u", port);
	webserver_listen_handle = socketio_listen(family, SOCK_STREAM, NULL, port_str, webserver_new_event);

	if (!webserver_listen_handle) {
		return 0; /* */
	}

	return 1; /* success */
}

/**
 * delete the the server's socketio_handle.
 */
EXPORT void webserver_shutdown(void)
{
	if (webserver_listen_handle) {
		webserver_listen_handle->delete_flag = 1;
		socketio_delete_count++; /* tracks if clean-up phase should be done. */
		webserver_listen_handle = NULL;
	}
}

/******************************************************************************
 * Mud Config
 ******************************************************************************/

/** undocumented - please add documentation. */
static int fl_default_family = 0;

/** undocumented - please add documentation. */
static int do_config_prompt(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
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
		ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
		return 1; /* failure - continue looking for matches */
	}

	free(*target);
	len = strlen(value) + 2; /* leave room for a space */
	*target = malloc(len);
	snprintf(*target, len, "%s ", value);

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int do_config_msg(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
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

	ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int do_config_msgfile(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
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

	ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);

	return 1; /* failure - continue looking for matches */
}

/** undocumented - please add documentation. */
static int do_config_string(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
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
static int do_config_port(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	if (!socketio_listen(fl_default_family, SOCK_STREAM, NULL, value, telnetclient_new_event)) {
		ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
		return 1; /* failure - continue looking for matches */
	}

	return 0; /* success - terminate the callback chain */
}

/** undocumented - please add documentation. */
static int do_config_uint(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value)
{
	char *endptr;
	unsigned *uint_p = extra;
	assert(extra != NULL);

	if (!extra) return -1; /* error */

	if (!*value) {
		DEBUG_MSG("Empty string");
		return -1; /* error - empty string */
	}

	*uint_p = strtoul(value, &endptr, 0);

	if (*endptr != 0) {
		DEBUG_MSG("Not a number");
		return -1; /* error - empty string */
	}

	return 0; /* success - terminate the callback chain */
}

/**
 * intialize default configuration. Config file overrides these defaults.
 */
EXPORT void mud_config_init(void)
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
	mud_config.form_newuser_filename = strdup("data/forms/newuser.form");
	mud_config.plugins = NULL;
}

/**
 * free all configuration data.
 */
EXPORT void mud_config_shutdown(void)
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
		&mud_config.msgfile_welcome,
		&mud_config.eventlog_filename,
		&mud_config.eventlog_timeformat,
		&mud_config.msgfile_newuser_create,
		&mud_config.msgfile_newuser_deny,
		&mud_config.default_channels,
		&mud_config.form_newuser_filename,
		&mud_config.plugins,
	};
	unsigned i;

	for (i = 0; i < NR(targets); i++) {
		free(*targets[i]);
		*targets[i] = NULL;
	}
}

#if !defined(NDEBUG) && !defined(NTEST)
/** test routine to dump a config option. */
static int mud_config_show(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value)
{
	printf("MUD-CONFIG: %s=%s\n", id, value);

	return 1;
}
#endif

/**
 * setup config loging callback functions then reads in a configuration file.
 * @return 0 on failure, 1 on success.
 */
EXPORT int mud_config_process(void)
{
	struct config cfg;

	config_setup(&cfg);
	config_watch(&cfg, "server.port", do_config_port, 0);
	config_watch(&cfg, "server.plugins", do_config_string, &mud_config.plugins);
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

/******************************************************************************
 * Plugins
 ******************************************************************************/

#define PLUGIN_NAME_MAX 64

struct plugin {
	LIST_ENTRY(struct plugin) list;
	dll_handle_t h;
	char *name;
	const struct plugin_basic_class *plugin_class;
};

LIST_HEAD(struct plugin_list, struct plugin); /**< list of loaded plugin. */
static struct plugin_list plugin_list;

static struct plugin *plugin_find(const char *name)
{
	struct plugin *curr;
	assert(name != NULL);

	for (curr = LIST_TOP(plugin_list); curr; curr = LIST_NEXT(curr, list)) {
		assert(curr->name != NULL);

		if (!strcasecmp(name, curr->name)) {
			return curr;
		}
	}

	return NULL; /* not found. */
}

/**
 * @param name base name, with path or extension.
 */
EXPORT int plugin_load(const char *name)
{
	struct plugin *pi;
	dll_handle_t h;
	const struct plugin_basic_class *plugin_class;
	char path[PATH_MAX];

	/* look to see if it is loaded. */
	pi = plugin_find(name);

	if (pi) {
		ERROR_FMT("plugin already loaded: %s\n", name);
		return 0; /* can't decide if this is an error or not. */
	}

	/* force dlopen to look in current directory. */
	snprintf(path, sizeof path, "./%s", name);

	/* load it. */
	if (!dll_open(&h, path)) {
		ERROR_FMT("could not open plugin: %s\n", name);
		return 0;
	}

	/* initialize the plugin. */
	plugin_class = dll_symbol(h, "plugin_class");

	if (!plugin_class || plugin_class->api_version != PLUGIN_API || !plugin_class->initialize) {
		dll_close(h);
		ERROR_FMT("could not get class from plugin: %s\n", name);
		return 0;
	}

	/* found the class guts - initialize the plugin once and only once. */
	if (!plugin_class->initialize()) {
		dll_close(h);
		ERROR_FMT("could not initialize plugin: %s\n", name);
		return 0;
	}

	/* add plugin to a list now that it has been initialized. */
	pi = calloc(1, sizeof * pi);
	pi->h = h;
	pi->name = strdup(name);
	pi->plugin_class = plugin_class;
	LIST_INSERT_HEAD(&plugin_list, pi, list);

	VERBOSE("Loaded plugin: %s\n", name);

	return 1;
}

/**
 * go through a space seperated list and load all the plugins.
 * @param list string containing a list of plugins to load.
 */
EXPORT int plugin_load_list(const char *list)
{
	char name[PLUGIN_NAME_MAX]; /**< hold a substring. */

	while (*list) {
		const char *e;

		/* find start of next word. */
		while (*list && isspace(*list)) list++;

		for (e = list; *e && !isspace(*e); e++) ;

		/* copy word out of string list. */
		snprintf(name, sizeof name, "%.*s", (int)(e - list), list);
		/* move to next position. */
		list = e;

		if (*list) list++;

		if (!plugin_load(name)) {
			return 0; /**< failure. */
		}
	}

	return 1; /**< success. */
}

/******************************************************************************
 * Main - Option parsing and initialization
 ******************************************************************************/

void show_version(void)
{
	puts("Version " BORIS_VERSION_STR " (built " __DATE__ ")");
}

/**
 * flag used for the main loop, zero to terminated.
 */
static sig_atomic_t keep_going_fl = 1;

/**
 * signal handler to cause the main loop to terminated by clearing keep_going_fl.
 */
static void sh_quit(int s UNUSED)
{
	keep_going_fl = 0;
}

/**
 * display a program usage message and terminated with an exit code.
 */
static void usage(void)
{
	fprintf(stderr,
	        "usage: boris [-h46] [-p port]\n"
	        "-4      use IPv4-only server addresses\n"
	        "-6      use IPv6-only server addresses\n"
	        "-h      help\n"
	       );
	exit(EXIT_FAILURE);
}

/**
 * check if a flag needs a parameter and exits if next_arg is NULL.
 * @param ch flag currently processing, used for printing error message.
 * @param next_arg string holding the next argument, or NULL if no argument.
 */
static void need_parameter(int ch, const char *next_arg)
{
	if (!next_arg) {
		ERROR_FMT("option -%c takes a parameter\n", ch);
		usage();
	}
}

/**
 * called for each command-line flag passed to decode them.
 * A flag is an argument that starts with a -.
 * @param ch character found for this flag
 * @param next_arg following argument.
 * @return 0 if the following argument is not consumed. 1 if the argument was used.
 */
static int process_flag(int ch, const char *next_arg)
{
	switch(ch) {
	case '4':
		fl_default_family = AF_INET; /* default to IPv4 */
		return 0;

	case '6':
		fl_default_family = AF_INET6; /* default to IPv6 */
		return 0;

	case 'c':
		need_parameter(ch, next_arg);
		free(mud_config.config_filename);
		mud_config.config_filename = strdup(next_arg);
		return 1; /* uses next arg */

	case 'p':
		need_parameter(ch, next_arg);

		if (!socketio_listen(fl_default_family, SOCK_STREAM, NULL, next_arg, telnetclient_new_event)) {
			usage();
		}

		return 1; /* uses next arg */

	case 'V': /* print version and exit. */
		show_version();
		exit(0); /* */
		return 0;

	default:
		ERROR_FMT("Unknown option -%c\n", ch);

	/* fall through */
	case 'h':
		usage();
	}

	return 0; /* didn't use next_arg */
}

/**
 * process all command-line arguments.
 * @param argc count of arguments.
 * @param argv array of strings holding the arguments.
 */
static void process_args(int argc, char **argv)
{
	int i, j;

	for (i = 1; i < argc; i++) {
		if (argv[i][0] == '-') {
			for (j = 1; argv[i][j]; j++) {
				if (process_flag(argv[i][j], (i + 1) < argc ? argv[i + 1] : NULL)) {
					/* a flag used the next_arg */
					i++;
					break;
				}
			}
		} else {
			TODO("process arguments");
			fprintf(stderr, "TODO: process argument '%s'\n", argv[i]);
		}
	}
}

/**
 * main - where it all starts.
 */
int main(int argc, char **argv)
{
	show_version();

	signal(SIGINT, sh_quit);
	signal(SIGTERM, sh_quit);

#ifndef NTEST
	acs_test();
	config_test();
	bitmap_test();
	freelist_test();
	heapqueue_test();
	sha1_test();
	sha1crypt_test();
#endif

	srand((unsigned)time(NULL));

	if (MKDIR("data") == -1 && errno != EEXIST) {
		PERROR("data/");
		return EXIT_FAILURE;
	}

	if (!socketio_init()) {
		return EXIT_FAILURE;
	}

	atexit(socketio_shutdown);

	/* load default configuration into mud_config global */
	mud_config_init();
	atexit(mud_config_shutdown);

	/* parse options and load into mud_config global */
	process_args(argc, argv);

	/* process configuration file and load into mud_config global */
	if (!mud_config_process()) {
		ERROR_MSG("could not load configuration");
		return EXIT_FAILURE;
	}

	if (!plugin_load_list(mud_config.plugins)) {
		ERROR_MSG("could not load one or more plugins");
		return EXIT_FAILURE;
	}

	/* check for missing plugins because they won't have their function
	 * pointers initialized. */
	if (!room_owner) {
		b_log(B_LOG_CRIT, "room", "No room system loaded!");
		return EXIT_FAILURE;
	}

	if (!character_owner) {
		b_log(B_LOG_CRIT, "character", "No character system loaded!");
		return EXIT_FAILURE;
	}

	if (!channel_owner) {
		b_log(B_LOG_CRIT, "channel", "No channel system loaded!");
		return EXIT_FAILURE;
	}

	if (!eventlog_init()) {
		return EXIT_FAILURE;
	}

	atexit(eventlog_shutdown);

	if (!user_init()) {
		ERROR_MSG("could not initialize users");
		return EXIT_FAILURE;
	}

	atexit(user_shutdown);

	if (!form_module_init()) {
		ERROR_MSG("could not initialize forms");
		return EXIT_FAILURE;
	}

	atexit(form_module_shutdown);

	/* start the webserver if webserver.port is defined. */
	if (mud_config.webserver_port) {
		if (!webserver_init(fl_default_family, mud_config.webserver_port)) {
			ERROR_MSG("could not initialize webserver");
			return EXIT_FAILURE;
		}

		atexit(webserver_shutdown);
	}

	if (!game_init()) {
		ERROR_MSG("could not start game");
		return EXIT_FAILURE;
	}

	eventlog_server_startup();

	TODO("use the next event for the timer");

	while (keep_going_fl) {
		telnetclient_prompt_refresh_all();

		if (!socketio_dispatch(-1))
			break;

		fprintf(stderr, "Tick\n");
	}

	eventlog_server_shutdown();
	fprintf(stderr, "Server shutting down.\n");

	return 0;
}

/******************************************************************************
 * Notes
 ******************************************************************************/
