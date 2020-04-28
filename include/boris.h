/**
 * @file boris.h
 *
 * 20th Century MUD.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2020 Apr 27
 *
 * Copyright (c) 2009-2020 Jon Mayo
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
#ifndef BORIS_H_
#define BORIS_H_

/* major, minor and patch level for version. */
#define BORIS_VERSION_MAJ 0
#define BORIS_VERSION_MIN 7
#define BORIS_VERSION_PAT 0

/******************************************************************************
 * Forward declarations
 ******************************************************************************/
struct channel;
struct channel_member;
struct freelist_entry;
struct menuinfo;
struct telnetclient;
struct user;
struct form;
struct form_state;

/******************************************************************************
 * Includes
 ******************************************************************************/
#include <stdarg.h>
#include <sys/socket.h>

#include "mudconfig.h"
#include "list.h"
#include "terminal.h"

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
 * Socket I/O
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

struct socketio_handle;

/******************************************************************************
 * Defines and macros
 ******************************************************************************/

/** get number of elements in an array. */
#define NR(x) (sizeof(x)/sizeof*(x))

/** round up on a boundry. */
#define ROUNDUP(a,n) (((a)+(n)-1)/(n)*(n))

/** round down on a boundry. */
#define ROUNDDOWN(a,n) ((a)-((a)%(n)))

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
 * Global variables
 ******************************************************************************/

/******************************************************************************
 * Protos
 ******************************************************************************/

int service_detach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));
void service_attach_log(void (*log)(int priority, const char *domain, const char *fmt, ...));

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

void telnetclient_new_event(struct socketio_handle *sh);
const char *telnetclient_username(struct telnetclient *cl);
int telnetclient_puts(struct telnetclient *cl, const char *str);
int telnetclient_vprintf(struct telnetclient *cl, const char *fmt, va_list ap);
int telnetclient_printf(struct telnetclient *cl, const char *fmt, ...);
void telnetclient_setprompt(struct telnetclient *cl, const char *prompt);
void telnetclient_start_lineinput(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt);
int telnetclient_isstate(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt);
void telnetclient_close(struct telnetclient *cl);
struct channel_member *telnetclient_channel_member(struct telnetclient *cl);
struct socketio_handle *telnetclient_socket_handle(struct telnetclient *cl);
const char *telnetclient_socket_name(struct telnetclient *cl);
const struct terminal *telnetclient_get_terminal(struct telnetclient *cl);
void telnetclient_prompt_refresh(struct telnetclient *cl);
void telnetclient_prompt_refresh_all(void);

void menu_show(struct telnetclient *cl, const struct menuinfo *mi);
void menu_input(struct telnetclient *cl, const struct menuinfo *mi, const char *line);

int form_module_init(void);
void form_module_shutdown(void);
struct form *form_load(const char *buf, void (*form_close)(struct telnetclient *cl, struct form_state *fs));
struct form *form_load_from_file(const char *filename, void (*form_close)(struct telnetclient *cl, struct form_state *fs));
void form_state_init(struct form_state *fs, const struct form *f);
void form_additem(struct form *f, unsigned flags, const char *name, const char *prompt, const char *description, int (*form_check)(struct telnetclient *cl, const char *str));
void form_init(struct form *f, const char *title, void (*form_close)(struct telnetclient *cl, struct form_state *fs));
void form_setmessage(struct form *f, const char *message);
void form_free(struct form *f);

void mud_config_init(void);
void mud_config_shutdown(void);
int mud_config_process(void);

int game_init(void);

int user_init(void);
void user_shutdown(void);
void user_put(struct user **user);
void user_get(struct user *user);

int socketio_init(void);
void socketio_shutdown(void);
int socketio_check_count(SOCKET fd);
void socketio_readready(SOCKET fd);
void socketio_writeready(SOCKET fd);
int socketio_sockname(struct sockaddr *sa, socklen_t salen, char *name, size_t name_len);
int socketio_getpeername(SOCKET fd, char *name, size_t name_len);
int socketio_send(SOCKET fd, const void *data, size_t len);
int socketio_recv(SOCKET fd, void *data, size_t len);
int socketio_dispatch(long msec);
const char *socketio_strerror(void);
int socketio_wouldblock(void);
int socketio_eintr(void);
struct socketio_handle *socketio_listen(int family, int socktype, const char *host, const char *port, void (*newclient)(struct socketio_handle *sh));

int webserver_init(int family, unsigned port);
void webserver_shutdown(void);
#endif
