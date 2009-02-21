/* boris.c :
 * example of a very tiny MUD
 */
/******************************************************************************
 * Design Documentation
 *
 * components:
 *  bitfield - manages small staticly sized bitmaps
 *  bitmap - manages large bitmaps
 *  buffer - manages an i/o buffer
 *  freelist - allocate ranges of numbers from a pool
 *  game_logic
 *  hash
 *  heapqueue - priority queue for implementing timers
 *  menu - draws menus to a telnetclient
 *  object_base - a generic object type
 *  object_cache - interface to recordcache for objects
 *  object_xxx - free/load/save routines for objects
 *  refcount - macros to provide reference counting
 *  server - accepts new connections
 *  shvar - process $() macros
 *  socketio - manages network sockets
 *  telnetclient - processes data from a socket for Telnet protocol
 *
 * dependency:
 *  socketio_handles - uses ref counts to determine when to free linked lists items
 *
 * types of records:
 *  objects - base objects for room, mob, or item
 *  instances - instance data for room, mob or item
 *  container - container data for room, mob or item (a type of instance data)
 *  stringmap - maps strings to a data structure (hash table)
 *  numbermap - maps integers to a data structure (hash table)
 *  strings - a large string that can span multiple blocks
 *
 * objects:
 *	base - the following types of objects are defined:
 *		room
 *		mob
 *		item
 *	instance - all instances are the same structure:
 *		id - object id
 *		count - all item instances are stackable 1 to 256.
 *		flags - 24 status flags [A-HJ-KM-Z]
 *		extra1..extra2 - control values that can be variable
 *
 * containers:
 *	instance parameter holds a id that holds an array of up to 64 objects.
 *
 * database saves the following types of blobs:
 *	player account
 *	room object
 *	mob object (also used for characters)
 *	item object
 *	instances
 *	container slots
 *	help text
 *
 ******************************************************************************/

/******************************************************************************
 * Configuration
 ******************************************************************************/

#if defined(_MSC_VER) || defined(WIN32) || defined(__WIN32__)
#define USE_WIN32_SOCKETS
#else
#define USE_BSD_SOCKETS
#endif

/* number of connections that can be queues waiting for accept() */
#define SOCKETIO_LISTEN_QUEUE 10
#define TELNETCLIENT_OUTPUT_BUFFER_SZ 4096
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
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#error Must define either USE_BSD_SOCKETS or USE_WIN32_SOCKETS
#endif

/******************************************************************************
 * Macros
 ******************************************************************************/
#if !defined(__STDC_VERSION__) || !(__STDC_VERSION__ >= 199901L)
#warning Requires C99
#endif

/*=* General purpose macros *=*/
/* get number of elements in an array */
#define NR(x) (sizeof(x)/sizeof*(x))

/* round up/down on a boundry */
#define ROUNDUP(a,n) (((a)+(n)-1)/(n)*(n))
#define ROUNDDOWN(a,n) ((a)-((a)%(n)))

/* make four ASCII characters into a 32-bit integer */
#define FOURCC(a,b,c,d)	( \
	((uint_least32_t)(d)<<24) \
	|((uint_least32_t)(c)<<16) \
	|((uint_least32_t)(b)<<8) \
	|(a))

/* used by var */
#define _make_name2(x,y) x##y
#define _make_name(x,y) _make_name2(x,y)

/* VAR() is used for making temp variables in macros */
#define VAR(x) _make_name(x,__LINE__)

/* controls how external functions are exported */
#ifndef NDEBUG
#define EXPORT
#else
/* fake out the export and keep the functions internal */
#define EXPORT static
#endif

/*=* Byte-order functions *=*/
/* WRite Big-Endian 32-bit value */
#define WR_BE32(dest, offset, value) do { \
		unsigned VAR(tmp)=value; \
		(dest)[offset]=(VAR(tmp)/16777216L)%256; \
		(dest)[(offset)+1]=(VAR(tmp)/65536L)%256; \
		(dest)[(offset)+2]=(VAR(tmp)/256)%256; \
		(dest)[(offset)+3]=VAR(tmp)%256; \
	} while(0)

/* WRite Big-Endian 16-bit value */
#define WR_BE16(dest, offset, value) do { \
		unsigned VAR(tmp)=value; \
		(dest)[offset]=(VAR(tmp)/256)%256; \
		(dest)[(offset)+1]=VAR(tmp)%256; \
	} while(0)

/* WRite Big-Endian 64-bit value */
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
	} while(0)

/* ReaD Big-Endian 16-bit value */
#define RD_BE16(src, offset) ((((src)[offset]&255u)<<8)|((src)[(offset)+1]&255u))

/* ReaD Big-Endian 32-bit value */
#define RD_BE32(src, offset) (\
	(((src)[offset]&255ul)<<24) \
	|(((src)[(offset)+1]&255ul)<<16) \
	|(((src)[(offset)+2]&255ul)<<8) \
	|((src)[(offset)+3]&255ul))

/* ReaD Big-Endian 64-bit value */
#define RD_BE64(src, offset) (\
		(((src)[offset]&255ull)<<56) \
		|(((src)[(offset)+1]&255ull)<<48) \
		|(((src)[(offset)+2]&255ull)<<40) \
		|(((src)[(offset)+3]&255ull)<<32) \
		|(((src)[(offset)+4]&255ull)<<24) \
		|(((src)[(offset)+5]&255ull)<<16) \
		|(((src)[(offset)+6]&255ull)<<8) \
		|((src)[(offset)+7]&255ull))

/*=* Rotate operations *=*/
#define ROL8(a,b) (((uint_least8_t)(a)<<(b))|((uint_least8_t)(a)>>(8-(b))))
#define ROL16(a,b) (((uint_least16_t)(a)<<(b))|((uint_least16_t)(a)>>(16-(b))))
#define ROL32(a,b) (((uint_least32_t)(a)<<(b))|((uint_least32_t)(a)>>(32-(b))))
#define ROL64(a,b) (((uint_least64_t)(a)<<(b))|((uint_least64_t)(a)>>(64-(b))))
#define ROR8(a,b) (((uint_least8_t)(a)>>(b))|((uint_least8_t)(a)<<(8-(b))))
#define ROR16(a,b) (((uint_least16_t)(a)>>(b))|((uint_least16_t)(a)<<(16-(b))))
#define ROR32(a,b) (((uint_least32_t)(a)>>(b))|((uint_least32_t)(a)<<(32-(b))))
#define ROR64(a,b) (((uint_least64_t)(a)>>(b))|((uint_least64_t)(a)<<(64-(b))))

/*=* Bitfield operations *=*/
/* return in type sized elements to create a bitfield of 'bits' bits */
#define BITFIELD(bits, type) (((bits)+(CHAR_BIT*sizeof(type))-1)/(CHAR_BIT*sizeof(type)))

/* set bit position 'bit' in bitfield x */
#define BITSET(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]|=1<<((bit)&((CHAR_BIT*sizeof *(x))-1))

/* clear bit position 'bit' in bitfield x */
#define BITCLR(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]&=~(1<<((bit)&((CHAR_BIT*sizeof *(x))-1)))

/* toggle bit position 'bit' in bitfield x */
#define BITINV(x, bit) (x)[(bit)/((CHAR_BIT*sizeof *(x)))]^=1<<((bit)&((CHAR_BIT*sizeof *(x))-1))

/* return a large non-zero number if the bit is set, zero if clear */
#define BITTEST(x, bit) ((x)[(bit)/((CHAR_BIT*sizeof *(x)))]&(1<<((bit)&((CHAR_BIT*sizeof *(x))-1))))

/* checks that bit is in range for bitfield x */
#define BITRANGE(x, bit) ((bit)<(sizeof(x)*CHAR_BIT))

/*=* DEBUG MACROS *=*/
/* VERBOSE(), DEBUG() and TRACE() macros.
 * DEBUG() does nothing if NDEBUG is defined
 * TRACE() does nothing if NTRACE is defined */
# define VERBOSE(...) fprintf(stderr, __VA_ARGS__)
# ifdef NDEBUG
#  define DEBUG(...) /* DEBUG disabled */
#  define DEBUG_MSG(msg) /* DEBUG_MSG disabled */
#  define HEXDUMP(data, len, ...) /* HEXDUMP disabled */
# else
#  define DEBUG(msg, ...) fprintf(stderr, "DEBUG:%s():%d:" msg, __func__, __LINE__, ## __VA_ARGS__);
#  define DEBUG_MSG(msg) fprintf(stderr, "ERROR:%s():%d:" msg "\n", __func__, __LINE__);
#  define HEXDUMP(data, len, ...) do { fprintf(stderr, __VA_ARGS__); hexdump(stderr, data, len); } while(0)
# endif
# ifdef NTRACE
#  define TRACE(...) /* TRACE disabled */
#  define HEXDUMP_TRACE(data, len, ...) /* HEXDUMP_TRACE disabled */
# else
#  define TRACE(...) fprintf(stderr, __VA_ARGS__)
#  define HEXDUMP_TRACE(data, len, ...) HEXDUMP(data, len, __VA_ARGS__)
# endif
# define ERROR_FMT(msg, ...) fprintf(stderr, "ERROR:%s():%d:" msg, __func__, __LINE__, __VA_ARGS__);

#define ERROR_MSG(msg) fprintf(stderr, "ERROR:%s():%d:" msg "\n", __func__, __LINE__);
#define TODO(msg) fprintf(stderr, "TODO:%s():%d:" msg "\n", __func__, __LINE__);
#define TRACE_ENTER() TRACE("%s():%u:ENTER\n", __func__, __LINE__);
#define TRACE_EXIT() TRACE("%s():%u:EXIT\n", __func__, __LINE__);
#define FAILON(e, reason, label) do { if(e) { fprintf(stderr, "FAILED:%s:%s\n", reason, strerror(errno)); goto label; } } while(0)
#define PERROR(msg) fprintf(stderr, "ERROR:%s():%d:%s:%s\n", __func__, __LINE__, msg, strerror(errno));


#ifndef NDEBUG
#include <string.h>
/* initialize with junk - used to find unitialized values */
# define JUNKINIT(ptr, len) memset((ptr), 0xBB, (len));
#else
# define JUNKINIT(ptr, len) /* do nothing */
#endif

/*=* reference counting macros *=*/
#define REFCOUNT_TYPE int
#define REFCOUNT_NAME _referencecount
#define REFCOUNT_INIT(obj) ((obj)->REFCOUNT_NAME=0)
#define REFCOUNT_TAKE(obj) ((obj)->REFCOUNT_NAME++)
#define REFCOUNT_PUT(obj, free_action) do { \
		assert((obj)->REFCOUNT_NAME>0); \
		if(--(obj)->REFCOUNT_NAME<=0) { \
			free_action; \
		} \
	} while(0)
#define REFCOUNT_GET(obj) do { (obj)->REFCOUNT_NAME++; } while(0)

/*=* Linked list macros *=*/
#define LIST_ENTRY(type) struct { type *_next, **_prev; }
#define LIST_HEAD(headname, type) headname { type *_head; }
#define LIST_INIT(head) ((head)->_head=NULL)
#define LIST_ENTRY_INIT(elm, name) do { (elm)->name._next=NULL; (elm)->name._prev=NULL; } while(0)
#define LIST_TOP(head) ((head)._head)
#define LIST_NEXT(elm, name) ((elm)->name._next)
#define LIST_PREVPTR(elm, name) ((elm)->name._prev)
#define LIST_INSERT_ATPTR(prevptr, elm, name) do { \
	(elm)->name._prev=(prevptr); \
	if(((elm)->name._next=*(prevptr))!=NULL) \
		(elm)->name._next->name._prev=&(elm)->name._next; \
	*(prevptr)=(elm); \
	} while(0)
#define LIST_INSERT_AFTER(where, elm, name) do { \
		(elm)->name._prev=&(where)->name._next; \
		if(((elm)->name._next=(where)->name._next)!=NULL) \
			(where)->name._next->name._prev=&(elm)->name._next; \
		*(elm)->name._prev=(elm); \
	} while(0)
#define LIST_INSERT_HEAD(head, elm, name) do { \
		(elm)->name._prev=&(head)->_head; \
		if(((elm)->name._next=(head)->_head)!=NULL) \
			(head)->_head->name._prev=&(elm)->name._next; \
		(head)->_head=(elm); \
	} while(0)
#define LIST_REMOVE(elm, name) do { \
		if((elm)->name._next!=NULL) \
			(elm)->name._next->name._prev=(elm)->name._prev; \
		if((elm)->name._prev) \
			*(elm)->name._prev=(elm)->name._next; \
	} while(0)
/******* TODO TODO TODO : write unit test for LIST_xxx macros *******/

/*=* Compiler macros *=*/
#ifdef __GNUC__
/* using GCC, enable special GCC options */
#define GCC_ONLY(x) x
#else
/* not using GCC */
#define GCC_ONLY(x)
#endif

#define UNUSED GCC_ONLY(__attribute__((unused)))

/******************************************************************************
 * Types and data structures
 ******************************************************************************/
struct telnetclient;
struct socketio_handle;
struct menuitem;
struct channel_group;
LIST_HEAD(struct channel_member_head, struct channel_member); /* membership for channels */

struct menuinfo {
	LIST_HEAD(struct, struct menuitem) items;
	char *title;
	size_t title_width;
	struct menuitem *tail;
};

struct formitem {
	LIST_ENTRY(struct formitem) item;
	unsigned value_index; /* used to index the form_state->value[] array */
	char *name;
	unsigned flags;
	int (*form_check)(struct telnetclient *cl, const char *str);
	char *description;
	char *prompt;
};

struct form_state {
	const struct form *form;
	const struct formitem *curritem;
	unsigned curr_i;
	unsigned nr_value;
	char **value;
	int done;
};

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
static struct menuinfo gamemenu_login, gamemenu_main;

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
} mud_config;

/******************************************************************************
 * Prototypes
 ******************************************************************************/
EXPORT void telnetclient_close(struct telnetclient *cl);
EXPORT void menu_show(struct telnetclient *cl, const struct menuinfo *mi);
EXPORT void menu_input(struct telnetclient *cl, const struct menuinfo *mi, const char *line);
static void form_menu_lineinput(struct telnetclient *cl, const char *line);
EXPORT int channel_member_part(struct channel_group *ch, struct channel_member_head *mh);
EXPORT void channel_member_part_all(struct channel_member_head *mh);
EXPORT int channel_member_join(struct channel_group *ch, struct channel_member_head *mh, struct telnetclient *cl);
EXPORT struct channel_group *channel_system_get(unsigned n);

/******************************************************************************
 * Util - utility routines
 ******************************************************************************/
#define UTIL_FNM_NOMATCH 1
#define UTIL_FNM_CASEFOLD 16	/* case insensitive matches */

/* clone of the fnmatch() function */
EXPORT int util_fnmatch(const char *pattern, const char *string, int flags) {
	char c;

	while((c=*pattern++)) switch(c) {
		case '?':
			if(*string++==0) return UTIL_FNM_NOMATCH;
			break;
		case '*':
			if(!*pattern) return 0; /* success */
			for(;*string;string++) {
				/* trace out any paths that match the first character */
			if(((flags&UTIL_FNM_CASEFOLD) ?  tolower(*string)==tolower(*pattern) : *string==*pattern) && util_fnmatch(pattern, string, flags)==0) {
					return 0; /* recursive check matched */
				}
			}
			return UTIL_FNM_NOMATCH; /* none of the tested paths worked */
			break;
		case '[': case ']': case '\\':
			TODO("support [] and \\");
		default:
			if((flags&UTIL_FNM_CASEFOLD) ? tolower(*string++)!=tolower(c) : *string++!=c) return UTIL_FNM_NOMATCH;
	}
	if(*string) return UTIL_FNM_NOMATCH;
	return 0; /* success */
}

/**
 * read the contents of a text file into an allocated string
 */
char *util_textfile_load(const char *filename) {
	FILE *f;
	char *ret;
	long len;
	size_t res;

	f=fopen(filename, "r");
	if(!f) {
		PERROR(filename);
		goto failure0;
	}

	if(fseek(f, 0l, SEEK_END)!=0) {
		PERROR(filename);
		goto failure1;
	}

	len=ftell(f);
	if(len==EOF) {
		PERROR(filename);
		goto failure1;
	}

	assert(len>=0); /* len must not be negative */

	if(fseek(f, 0l, SEEK_SET)!=0) {
		PERROR(filename);
		goto failure1;
	}

	ret=malloc((unsigned)len+1);
	if(!ret) {
		PERROR(filename);
		goto failure1;
	}

	res=fread(ret, 1, (unsigned)len, f);
	if(ferror(f)) {
		PERROR(filename);
		goto failure2;
	}

	ret[len]=0; /* null terminate the string */

	DEBUG("%s:loaded %ld bytes\n", filename, len);

	fclose(f);
	return ret;

failure2:
	free(ret);
failure1:
	fclose(f);
failure0:
	return 0; /* failure */
}

struct util_strfile {
	const char *buf;
};

void util_strfile_open(struct util_strfile *h, const char *buf) {
	assert(h != NULL);
	assert(buf != NULL);
	h->buf=buf;
}

void util_strfile_close(struct util_strfile *h) {
	h->buf=NULL;
}

const char *util_strfile_readline(struct util_strfile *h, size_t *len) {
	const char *ret;

	assert(h != NULL);
	assert(h->buf != NULL);
	ret=h->buf;

	while(*h->buf && *h->buf!='\n') h->buf++;
	if(len)
		*len=h->buf-ret;
	if(*h->buf)
		h->buf++;
	return h->buf==ret?NULL:ret; /* return EOF if the offset couldn't move forward */
}

/* removes a trailing newline if one exists */
void trim_nl(char *line) {
	line=strrchr(line, '\n');
	if(line) *line=0;
}

/* remove beginning and trailing whitespace */
char *trim_whitespace(char *line) {
	char *tmp;
	while(isspace(*line)) line++;
	for(tmp=line+strlen(line)-1;line<tmp && isspace(*tmp);tmp--) *tmp=0;
	return line;
}

/******************************************************************************
 * Debug routines
 ******************************************************************************/
#ifndef NDEBUG
static const char *convert_number(unsigned n, unsigned base, unsigned pad) {
	static char number_buffer[65];
	static const char tab[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-";
	char *o; /* output */
	size_t len;
	if(base<2) base=2;
	if(base>sizeof tab) base=sizeof tab;
	o=number_buffer+sizeof number_buffer;
	*--o=0;
	do {
		*--o=tab[n%base];
		n/=base;
	} while(n);
	len=number_buffer+sizeof number_buffer-1-o;
	if(pad && len<pad) {
		for(pad=pad-len;pad;pad--) {
			*--o=tab[0];
		}
	}
	return o;
}

static void hexdump(FILE *f, const void *data, int len) {
	fprintf(f, "[%d]", len);
	while(len>0) {
		unsigned char ch=*(unsigned char*)data;
		if(isprint(ch)) {
			fprintf(f, " '%c'", ch);
		} else {
			fprintf(f, " 0x%02hhx", ch);
		}
		len--;
		data=((unsigned char*)data)+1;
	}
	fprintf(f, "\n");
}
#endif

/******************************************************************************
 * shvar - shell variables
 ******************************************************************************/
#define SHVAR_ID_MAX 128	/* maximum number of characters in a $() */
#define SHVAR_ESCAPE '$'	/* escape character used */

EXPORT int shvar_eval(char *out, size_t len, const char *src, const char *(*match)(const char *key)) {
	const char *old;
	char key[SHVAR_ID_MAX];
	while(*src && len>0) {
		if(*src==SHVAR_ESCAPE) {
			const char *key_start, *key_end;
			old=src; /* save old position */
			src++;
			if(*src=='{' || *src=='(') {
				char end_char;
				end_char=*src=='{'?'}':')';
				src++;
				key_start=key_end=src;
				while(*src!=end_char) {
					if(!*src) {
						size_t tmplen;
						tmplen=strlen(old);
						if(tmplen>=len) tmplen=len-1;
						memcpy(out, old, tmplen);
						out[tmplen]=0;
						return 0; /* failure */
					}
					src++;
				}
				key_end=src;
				src++;
			} else if(*src==SHVAR_ESCAPE) {
				*out++=*src++;
				len--;
				continue;
			} else {
				key_start=src;
				while(*src && len>0) {
					if(!isalnum(*src) && *src!='_') {
						break;
					}
					src++;
				}
				key_end=src;
			}
			if(match && key_end>=key_start) {
				const char *tmp;
				size_t tmplen;
				assert(key_start<=key_end);
				memcpy(key, key_start, (size_t)(key_end-key_start));
				key[key_end-key_start]=0;
				tmp=match(key);
				if(tmp) {
					tmplen=strlen(tmp);
					if(tmplen>len) return 0; /* failure */
					memcpy(out, tmp, tmplen);
					out+=tmplen;
					len-=tmplen;
				}
			}
		} else {
			*out++=*src++;
			len--;
		}
	}
	if(len>0) {
		*out++=0;
		len--;
		return *src==0;
	}
	*out=0;
	return 0; /* failure */
}

/******************************************************************************
 * heapqueue - a binary heap used as a priority queue
 ******************************************************************************/

#define HEAPQUEUE_LEFT(i) (2*(i)+1)
#define HEAPQUEUE_RIGHT(i) (2*(i)+2)
#define HEAPQUEUE_PARENT(i) (((i)-1)/2)

struct heapqueue_elm {
	unsigned d; /* key */
	/* TODO: put useful data in here */
};

static struct heapqueue_elm heap[512]; /* test heap */
static unsigned heap_len;

/* min heap is sorted by lowest value at root
 * return non-zero if a>b
 */
static inline int heapqueue_greaterthan(struct heapqueue_elm *a, struct heapqueue_elm *b) {
	assert(a!=NULL);
	assert(b!=NULL);
	return a->d>b->d;
}

/* i is the "hole" location
 * elm is the value to compare against
 * return new position of hole */
static int heapqueue_ll_siftdown(unsigned i, struct heapqueue_elm *elm) {
	assert(elm!=NULL);
	assert(i<heap_len || i==0);
	while(HEAPQUEUE_LEFT(i)<heap_len) { /* keep going until at a leaf node */
		unsigned child=HEAPQUEUE_LEFT(i);

		/* compare left and right(child+1) - use the smaller of the two */
		if(child+1<heap_len && heapqueue_greaterthan(&heap[child], &heap[child+1])) {
			child++; /* left is bigger than right, use right */
		}

		/* child is the smallest child, if elm is smaller or equal then we're done */
		if(!(heapqueue_greaterthan(elm, &heap[child]))) { /* elm <= child */
			break;
		}
		/* swap "hole" and selected child */
		TRACE("%s():swap hole %d with entry %d\n", __func__, i, child);
		heap[i]=heap[child];
		i=child;
	}
	TRACE("%s():chosen position %d for hole.\n", __func__, i);
	return i;
}

/* i is the "hole" location
 * elm is the value to compare against
 * return the new position of the hole
 */
static int heapqueue_ll_siftup(unsigned i, struct heapqueue_elm *elm) {
	assert(elm!=NULL);
	assert(i<heap_len);
	while(i>0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], elm)) { /* Compare the element with parent */
		/* swap element with parent and keep going (keep tracking the "hole") */
		heap[i]=heap[HEAPQUEUE_PARENT(i)];
		i=HEAPQUEUE_PARENT(i);
	}
	return i;
}

/* removes entry at i */
EXPORT int heapqueue_cancel(unsigned i, struct heapqueue_elm *ret) {
	/* 1. copy the value at i into ret
	 * 2. put last node into empty position
	 * 3. sift-up if moved node smaller than parent, sift-down if larger than either child
	 */
	struct heapqueue_elm *last;
	assert(ret!=NULL);
	assert(i<heap_len);
	assert(heap_len<NR(heap));
	*ret=heap[i]; /* copy the value at i into ret */
	TRACE("canceling entry #%d: val=%d (parent=%d:>%u) (left %d:>%u) (right %d:>%u) (last %d)\n",
		i, ret->d,
		i>0 ? (int)HEAPQUEUE_PARENT(i) : -1,
		i>0 ? heap[HEAPQUEUE_PARENT(i)].d : 0,
		HEAPQUEUE_LEFT(i)<heap_len ? (int)HEAPQUEUE_LEFT(i) : -1,
		HEAPQUEUE_LEFT(i)<heap_len ? heap[HEAPQUEUE_LEFT(i)].d : 0,
		HEAPQUEUE_RIGHT(i)<heap_len ? (int)HEAPQUEUE_RIGHT(i) : -1,
		HEAPQUEUE_RIGHT(i)<heap_len ? heap[HEAPQUEUE_RIGHT(i)].d : 0,
		heap[heap_len-1].d
	);

	/* move last entry to the empty position */
	heap_len--;
	last=&heap[heap_len];

	/* i now holds the position of the last entry, we will move this "hole" until
	 * it is in the correct place for last */

	if(i>0 && heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], last)) {
		/* we already did the compare, so we'll perform the first move here */
		TRACE("%s():swap hole %d with entry %d\n", __func__, i, HEAPQUEUE_PARENT(i));
		heap[i]=heap[HEAPQUEUE_PARENT(i)]; /* move parent down */
		i=heapqueue_ll_siftup(HEAPQUEUE_PARENT(i), last); /* sift the "hole" up */
	} else if(HEAPQUEUE_RIGHT(i)<heap_len && (heapqueue_greaterthan(last, &heap[HEAPQUEUE_RIGHT(i)]) || heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)]))) {
		/* if right is on the list, then left is as well */
		if(heapqueue_greaterthan(&heap[HEAPQUEUE_LEFT(i)], &heap[HEAPQUEUE_RIGHT(i)])) {
			/* left is larger - use the right hole */
			TRACE("%s():swap hole %d with entry %d\n", __func__, i, HEAPQUEUE_RIGHT(i));
			heap[i]=heap[HEAPQUEUE_RIGHT(i)]; /* move right up */
			i=heapqueue_ll_siftdown(HEAPQUEUE_RIGHT(i), last); /* sift the "hole" down */
		} else {
			/* right is the larger or equal - use the left hole */
			TRACE("%s():swap hole %d with entry %d\n", __func__, i, HEAPQUEUE_LEFT(i));
			heap[i]=heap[HEAPQUEUE_LEFT(i)]; /* move left up */
			i=heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
		}
	} else if(HEAPQUEUE_LEFT(i)<heap_len && heapqueue_greaterthan(last, &heap[HEAPQUEUE_LEFT(i)])) {
		/* at this point there is no right node */
		TRACE("%s():swap hole %d with entry %d\n", __func__, i, HEAPQUEUE_LEFT(i));
		heap[i]=heap[HEAPQUEUE_LEFT(i)]; /* move left up */
		i=heapqueue_ll_siftdown(HEAPQUEUE_LEFT(i), last); /* sift the "hole" down */
	}

	heap[i]=*last;
	return 1;
}

/* sift-up operation for enqueueing
 * 1. Add the element on the bottom level of the heap.
 * 2. Compare the added element with its parent; if they are in the correct order, stop.
 * 3. If not, swap the element with its parent and return to the previous step.
 */
EXPORT void heapqueue_enqueue(struct heapqueue_elm *elm) {
	unsigned i;
	assert(elm!=NULL);
	assert(heap_len<NR(heap));

	i=heap_len++; /* add the element to the bottom of the heap (create a "hole") */
	i=heapqueue_ll_siftup(i, elm);
	heap[i]=*elm; /* fill in the "hole" */
}

/* sift-down operation for dequeueing
 * removes the root entry and copies it to ret
 */
EXPORT int heapqueue_dequeue(struct heapqueue_elm *ret) {
	unsigned i;
	assert(ret!=NULL);
	if(heap_len<=0)
		return 0; /* nothing to dequeue */
	*ret=heap[0]; /* we have to copy the root element somewhere because we're removing it */

	/* move last entry to the root, then sift-down */
	heap_len--;
	i=heapqueue_ll_siftdown(0, &heap[heap_len]);
	heap[i]=heap[heap_len];
	return 1;
}

#ifndef NDEBUG

/* checks the heap to see that it is valid */
static int heapqueue_isvalid(void) {
	unsigned i;
	for(i=1;i<heap_len;i++) {
		if(heapqueue_greaterthan(&heap[HEAPQUEUE_PARENT(i)], &heap[i])) {
			DEBUG("Bad heap at %d\n", i);
			return 0; /* not a valid heap */
		}
	}
	return 1; /* success */
}

static void heapqueue_dump(void) {
	unsigned i;
	fprintf(stderr, "::: Dumping heapqueue :::\n");
	for(i=0;i<heap_len;i++) {
		printf("%03u = %4u (p:%d l:%d r:%d)\n", i, heap[i].d, i>0 ? (int)HEAPQUEUE_PARENT(i) : -1, HEAPQUEUE_LEFT(i), HEAPQUEUE_RIGHT(i));
	}
	printf("heap valid? %d (%d entries)\n", heapqueue_isvalid(), heap_len);
}

EXPORT void heapqueue_test(void) {
	struct heapqueue_elm elm, tmp;
	unsigned i;
	const unsigned testdata[] = {
		42, 2, 123, 88, 3, 3, 3, 3, 3, 1, 0,
	};

	/* initialize the array */
	heap_len=0;
#ifndef NDEBUG
	/* fill remaining with fake data */
	for(i=heap_len;i<NR(heap);i++) {
		heap[i].d=0xdead;
	}
#endif

	for(i=0;i<NR(testdata);i++) {
		elm.d=testdata[i];
		heapqueue_enqueue(&elm);
	}

	heapqueue_dump();

	/* test the cancel function and randomly delete everything */
	while(heap_len>0) {
		unsigned valid;
		i=rand()%heap_len;
		if(heapqueue_cancel(i, &tmp)) {
			printf("canceled at %d (data=%d)\n", i, tmp.d);
		} else {
			printf("canceled at %d failed!\n", i);
			break;
		}
		// heapqueue_dump();
		valid=heapqueue_isvalid();
		// printf("heap valid? %d (%d entries)\n", valid, heap_len);
		if(!valid) {
			printf("BAD HEAP!!!\n");
			heapqueue_dump();
			break;
		}
	}

	heapqueue_dump();

	/* load the queue with test data again */
	for(i=0;i<NR(testdata);i++) {
		elm.d=testdata[i];
		heapqueue_enqueue(&elm);
	}

	/* do a normal dequeue of everything */
	while(heapqueue_dequeue(&tmp)) {
		printf("removed head (data=%d)\n", tmp.d);
	}

	heapqueue_dump();
}
#endif

/******************************************************************************
 * Freelist
 ******************************************************************************/

/* bucket number to use for overflows */
#define FREELIST_OVERFLOW_BUCKET(flp) (NR((flp)->buckets)-1)

struct freelist_extent {
	unsigned length, offset; /* both are in block-sized units */
};

struct freelist_entry {
	LIST_ENTRY(struct freelist_entry) global; /* global list */
	LIST_ENTRY(struct freelist_entry) bucket; /* bucket list */
	struct freelist_extent extent;
};

LIST_HEAD(struct freelist_listhead, struct freelist_entry);

struct freelist {
	/* single list ordered by offset to find adjacent chunks. */
	struct freelist_listhead global;
	/* buckets for each size, last entry is a catch-all for huge chunks */
	unsigned nr_buckets;
	struct freelist_listhead *buckets;
};

static unsigned freelist_ll_bucketnr(struct freelist *fl, unsigned count) {
	unsigned ret;
	if(fl->nr_buckets>1) {
		ret=count/(fl->nr_buckets-1);
		if(ret>=fl->nr_buckets) {
			ret=FREELIST_OVERFLOW_BUCKET(fl);
		}
	} else {
		ret=FREELIST_OVERFLOW_BUCKET(fl);
	}
	return ret;
}

static void freelist_ll_bucketize(struct freelist *fl, struct freelist_entry *e) {
	unsigned bucket_nr;

	assert(e!=NULL);

	bucket_nr=freelist_ll_bucketnr(fl, e->extent.length);

	/* detach the entry */
	LIST_REMOVE(e, bucket);

	/* push entry on the top of the bucket */
	LIST_INSERT_HEAD(&fl->buckets[bucket_nr], e, bucket);
}

/* lowlevel - detach and free an entry */
static void freelist_ll_free(struct freelist_entry *e) {
	assert(e!=NULL);
	assert(e->global._prev!=NULL);
	assert(e->global._prev!=(void*)0x99999999);
	assert(e->bucket._prev!=NULL);
	LIST_REMOVE(e, global);
	LIST_REMOVE(e, bucket);
#ifndef NDEBUG
	memset(e, 0x99, sizeof *e); /* fill with fake data before freeing */
#endif
	free(e);
}

/* lowlevel - append an extra to the global list at prev */
static struct freelist_entry *freelist_ll_new(struct freelist_entry **prev, unsigned ofs, unsigned count) {
	struct freelist_entry *new;
	assert(prev!=NULL);
	assert(prev!=(void*)0x99999999);
	new=malloc(sizeof *new);
	assert(new!=NULL);
	if(!new) {
		PERROR("malloc()");
		return 0;
	}
	new->extent.offset=ofs;
	new->extent.length=count;
	LIST_ENTRY_INIT(new, bucket);
	LIST_INSERT_ATPTR(prev, new, global);
	return new;
}

/* returns true if a bridge is detected */
static int freelist_ll_isbridge(struct freelist_extent *prev_ext, unsigned ofs, unsigned count, struct freelist_extent *next_ext) {
	/*
	DEBUG("testing for bridge:\n"
			"  last:%6d+%d curr:%6d+%d ofs:%6d+%d\n",
			prev_ext->offset, prev_ext->length, next_ext->offset, next_ext->length,
			ofs, count
	);
	*/
	return prev_ext->offset+prev_ext->length==ofs && next_ext->offset==ofs+count;
}

EXPORT void freelist_init(struct freelist *fl, unsigned nr_buckets) {
	fl->nr_buckets=nr_buckets+1; /* add one for the overflow bucket */
	fl->buckets=calloc(fl->nr_buckets, sizeof *fl->buckets);
	LIST_INIT(&fl->global);
}

EXPORT void freelist_free(struct freelist *fl) {
	while(LIST_TOP(fl->global)) {
		freelist_ll_free(LIST_TOP(fl->global));
	}
	assert(LIST_TOP(fl->global)==NULL);

#ifndef NDEBUG
	{
		unsigned i;
		for(i=0;i<fl->nr_buckets;i++) {
			assert(LIST_TOP(fl->buckets[i])==NULL);
		}
	}
#endif
}

/* allocate memory from the pool
 * returns offset of the allocation
 * return -1 on failure */
EXPORT long freelist_alloc(struct freelist *fl, unsigned count) {
	unsigned bucketnr, ofs;
	struct freelist_entry **bucketptr, *curr;

	assert(count!=0);

	bucketnr=freelist_ll_bucketnr(fl, count);
	bucketptr=&LIST_TOP(fl->buckets[bucketnr]);

	for(;bucketnr<=FREELIST_OVERFLOW_BUCKET(fl);bucketnr++) {
		assert(bucketnr<=FREELIST_OVERFLOW_BUCKET(fl));
		assert(bucketptr!=NULL);

		if(*bucketptr) { /* found an entry - cut the front of it off to alloc */
			curr=*bucketptr;
			DEBUG("curr->extent.length:%u count:%u\n", curr->extent.length, count);
			assert(curr->extent.length>=count);
			ofs=curr->extent.offset;
			curr->extent.offset+=count;
			curr->extent.length-=count;
			if(curr->extent.length==0) {
				freelist_ll_free(curr);
			} else {
				/* place in a new bucket */
				freelist_ll_bucketize(fl, curr);
			}
			return ofs;
		}
	}
	return -1;
}

/* adds a piece to the freelist pool
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
 * */
EXPORT void freelist_pool(struct freelist *fl, unsigned ofs, unsigned count) {
	struct freelist_entry *new, *curr, *last;

	TRACE_ENTER();

	assert(count!=0);

	last=NULL;
	new=NULL;
	for(curr=LIST_TOP(fl->global);curr;curr=LIST_NEXT(curr, global)) {
		assert(curr!=last);
		assert(curr!=(void*)0x99999999);
		if(last) {
			assert(LIST_NEXT(last, global)==curr); /* sanity check */
		}
		/*
		printf(
			"c.ofs:%6d c.len:%6d l.ofs:%6d l.len:%6d ofs:%6d len:%6d\n",
			curr->extent.offset, curr->extent.length,
			last ? last->extent.offset : -1, last ? last->extent.length : -1,
			ofs, count
		);
		*/

		if(ofs==curr->extent.offset) {
			ERROR_FMT("overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
			TODO("make something out of this");
			abort();
		} else if(last && freelist_ll_isbridge(&last->extent, ofs, count, &curr->extent)) {
			/* |......|XXX|.......|		bridge */
			DEBUG("|......|XXX|.......|		bridge. last=%u+%u curr=%u+%u new=%u+%u\n", last->extent.length, last->extent.offset, curr->extent.offset, curr->extent.length, ofs, count);
			/* we are dealing with 3 entries, the last, the new and the current */
			/* merge the 3 entries into the last entry */
			last->extent.length+=curr->extent.length+count;
			assert(LIST_PREVPTR(curr, global)==&LIST_NEXT(last, global));
			freelist_ll_free(curr);
			assert(LIST_TOP(fl->global)!=curr);
			assert(LIST_NEXT(last, global)!=(void*)0x99999999);
			assert(LIST_NEXT(last, global)!=curr); /* deleting it must take it off the list */
			new=curr=last;
			break;
		} else if(curr->extent.offset==ofs+count) {
			/* |.....|_XXX|.......|		grow-next */
			DEBUG("|.....|_XXX|.......|		grow-next. curr=%u+%u new=%u+%u\n", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge new entry into a following entry */
			curr->extent.offset=ofs;
			curr->extent.length+=count;
			new=curr;
			break;
		} else if(last && curr->extent.offset+curr->extent.length==ofs) {
			/* |......|XXX_|......|		grow-prev */
			DEBUG("|......|XXX_|......|		grow-prev. curr=%u+%u new=%u+%u\n", curr->extent.offset, curr->extent.length, ofs, count);
			/* merge the new entry into the end of the previous entry */
			curr->extent.length+=count;
			new=curr;
			break;
		} else if(ofs<curr->extent.offset) {
			if(ofs+count>curr->extent.offset) {
				ERROR_FMT("overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
				TODO("make something out of this");
				abort();
			}
			DEBUG("|.....|_XXX_|......|		normal new=%u+%u\n", ofs, count);
			/* create a new entry */
			new=freelist_ll_new(LIST_PREVPTR(curr, global), ofs, count);
			break;
		}

		last=curr; /* save this for finding a bridge */
	}
	if(!curr) {
		if(last) {
			if(last->extent.offset+last->extent.length==ofs) {
				DEBUG("|......|XXX_|......|		grow-prev. last=%u+%u new=%u+%u\n", last->extent.offset, last->extent.length, ofs, count);
				last->extent.length+=count;
				new=last;
			} else {
				DEBUG("|............|XXX  |		end. new=%u+%u\n", ofs, count);
				new=freelist_ll_new(&LIST_NEXT(last, global), ofs, count);
			}
		} else {
			DEBUG("|XXX               |		initial. new=%u+%u\n", ofs, count);
			new=freelist_ll_new(&LIST_TOP(fl->global), ofs, count);
		}
	}

	/* push entry into bucket */
	if(new) {
		freelist_ll_bucketize(fl, new);
	}
}

/**
 * allocates a particular range
 * (assumes that freelist_pool assembles adjacent regions into the largest
 * possible contigious spaces)
 */
EXPORT int freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count) {
	unsigned bucketnr;
	struct freelist_entry **bucketptr, *curr;

	assert(count!=0);

	DEBUG("thwacking %u:%u\n", ofs, count);

	bucketnr=freelist_ll_bucketnr(fl, count);
	bucketptr=&LIST_TOP(fl->buckets[bucketnr]);
	for(;bucketnr<=FREELIST_OVERFLOW_BUCKET(fl);bucketnr++) {
		assert(bucketnr<=FREELIST_OVERFLOW_BUCKET(fl));
		assert(bucketptr!=NULL);

		for(curr=*bucketptr;curr;curr=LIST_NEXT(curr, global)) {
			if(curr->extent.offset<=ofs && curr->extent.length>=count+curr->extent.offset-ofs) {
				TRACE("Found entry to thwack at %u:%u for %u:%u\n", curr->extent.offset, curr->extent.length, ofs, count);

				/* four possible cases:
				 * 1. heads and lengths are the same - free extent
				 * 2. heads are the same, but lengths differ - shrink and rebucket
				 * 3. tails are the same - shrink and rebucket
				 * 4. extent gets split into two extents
				 */
				if(curr->extent.offset==ofs && curr->extent.length==count) {
					/* 1. heads and lengths are the same - free extent */
					freelist_ll_free(curr);
					return 1; /* success */
				} else if(curr->extent.offset==ofs) {
					/* 2. heads are the same, but lengths differ - shrink and rebucket */
					curr->extent.length-=count;
					freelist_ll_bucketize(fl, curr);
					return 1; /* success */
				} else if((curr->extent.offset+curr->extent.length)==(ofs+count)) {
					/* 3. tails are the same - shrink and rebucket */
					curr->extent.offset+=count;
					freelist_ll_bucketize(fl, curr);
					return 1; /* success */
				} else { /* 4. extent gets split into two extents */
					struct freelist_extent new; /* second part */

					/* make curr the first part, and create a new one after
					 * ofs:count for the second */

					new.offset=ofs+count;
					new.length=(curr->extent.offset+curr->extent.length)-new.offset;
					DEBUG("ofs=%d curr.offset=%d\n", ofs, curr->extent.offset);
					assert(ofs > curr->extent.offset);
					curr->extent.length=ofs-curr->extent.offset;
					freelist_ll_bucketize(fl, curr);
					freelist_pool(fl, new.offset, new.length);
					return 1; /* success */
				}
				DEBUG_MSG("Should not be possible to get here");
				abort();
			}
		}
	}
	return 0; /* failure */
}

#ifndef NTEST
EXPORT void freelist_dump(struct freelist *fl) {
	struct freelist_entry *curr;
	unsigned n;
	fprintf(stderr, "::: Dumping freelist :::\n");
	for(curr=LIST_TOP(fl->global),n=0;curr;curr=LIST_NEXT(curr, global),n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}
}

EXPORT void freelist_test(void) {
	struct freelist fl;
	unsigned n;
	freelist_init(&fl, 1024);
	fprintf(stderr, "::: Making some fragments :::\n");
	for(n=0;n<60;n+=12) {
		freelist_pool(&fl, n, 6);
	}
	fprintf(stderr, "::: Filling in gaps :::\n");
	for(n=0;n<60;n+=12) {
		freelist_pool(&fl, n+6, 6);
	}
	fprintf(stderr, "::: Walking backwards :::\n");
	for(n=120;n>60;) {
		n-=6;
		freelist_pool(&fl, n, 6);
	}

	freelist_dump(&fl);

	/* test freelist_alloc() */
	fprintf(stderr, "::: Allocating :::\n");
	for(n=0;n<60;n+=6) {
		long ofs;
		ofs=freelist_alloc(&fl, 6);
		TRACE("alloc: %lu+%u\n", ofs, 6);
	}

	freelist_dump(&fl);

	fprintf(stderr, "::: Allocating :::\n");
	for(n=0;n<60;n+=6) {
		long ofs;
		ofs=freelist_alloc(&fl, 6);
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
 * Hashing Functions
 ******************************************************************************/

/* a hash that ignores case */
static uint_least32_t hash_stringignorecase32(const char *key) {
	uint_least32_t h=0;

	while(*key) {
		h=h*65599u+(unsigned)tolower(*(const unsigned char*)key++);
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+tolower(*key++);
		 */
	}
	return h;
}

/* creates a 32-bit hash of a null terminated string */
static uint_least32_t hash_string32(const char *key) {
	uint_least32_t h=0;

	while(*key) {
		h=h*65599u+(unsigned)*key++;
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+*key++;
		 */
	}
	return h;
}

#if 0
/* creates a 32-bit hash of a blob of memory */
static uint_least32_t hash_mem32(const char *key, size_t len) {
	uint_least32_t h=0;

	while(len>0) {
		h=h*65599u+(unsigned)*key++;
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+*key++;
		 */
		len--;
	}
	return h;
}
#endif

/* creates a 32-bit hash of a 32-bit value */
static uint_least32_t hash_uint32(uint_least32_t key) {
	key=(key^61)*ROR32(key,16);
	key+=key<<3;
	key^=ROR32(key, 4);
	key*=668265261;
	key^=ROR32(key, 15);
	return key;
}

#if 0
/* creates a 64-bit hash of a 64-bit value */
static uint_least64_t hash64_uint64(uint_least64_t key) {
	key=~key+(key<<21);
	key^=ROR64(key, 24);
	key*=265;
	key^=ROR64(key,14);
	key*=21;
	key^=ROR64(key, 28);
	key+=key<<31;
	return key;
}

/* turns a 64-bit value into a 32-bit hash */
static uint_least32_t hash_uint64(uint_least64_t key) {
	key=(key<<18)-key-1;
	key^=ROR64(key, 31);
	key*=21;
	key^=ROR64(key, 11);
	key+=key<<6;
	key^=ROR64(key, 22);
	return (uint_least32_t)key;
}
#endif

/******************************************************************************
 * map
 ******************************************************************************/
union map_data {
	void *ptr;
	fpos_t pos;
	intptr_t i;
	uintptr_t u;
};

struct map_entry {
	LIST_ENTRY(struct map_entry) list;
	void *key;	/* key can point inside of data (and usually should) */
	union map_data data;
};

struct map {
	void (*free_entry)(void *key, union map_data *data);
	uint_least32_t (*hash)(const void *key);
	uint_least32_t table_mask;
	int (*compare)(const void *key1, const void *key2);
	LIST_HEAD(struct, struct map_entry) *table;
	long count;
};

/**
 * use this as a callback to init when you don't want to free
 */
static void _map_donotfree(void *key UNUSED, union map_data *data UNUSED) {
}

EXPORT uint_least32_t map_hash_stringignorecase(const void *key) {
	return hash_stringignorecase32(key);
}

EXPORT uint_least32_t map_hash_string(const void *key) {
	return hash_string32(key);
}

EXPORT uint_least32_t map_hash_unsigned(const void *key) {
	return hash_uint32(*(unsigned*)key);
}

EXPORT uint_least32_t map_hash_uintptr(const void *key) {
	return hash_uint32((uintptr_t)key);
}

EXPORT int map_compare_stringignorecase(const void *key1, const void *key2) {
	return strcasecmp(key1, key2);
}

EXPORT int map_compare_string(const void *key1, const void *key2) {
	return strcmp(key1, key2);
}

EXPORT int map_compare_unsigned(const void *key1, const void *key2) {
	unsigned a=*(unsigned*)key1, b=*(unsigned*)key2;
	return a<b?-1:a>b?1:0;
}

/**
 * treat argument as an unsigned instead of as a pointer */
EXPORT int map_compare_uintptr(const void *key1, const void *key2) {
	uintptr_t a=(uintptr_t)key1, b=(uintptr_t)key2;
	return a<b?-1:a>b?1:0;
}

EXPORT void map_init(struct map *m, unsigned initial_size_bits, void (*free_entry)(void *key, union map_data *data), uint_least32_t (*hash)(const void *key), int (*compare)(const void *key1, const void *key2)) {
	unsigned i;

	assert(initial_size_bits < 32); /* 2^32 hash entries will break this init function */

	/* calculate the table mask */
	m->table_mask=0;
	while(initial_size_bits--) {
		m->table_mask=(m->table_mask<<1)&1;
	}

	m->table=calloc(sizeof *m->table, m->table_mask+1);
	for(i=0;i<=m->table_mask;i++) {
		LIST_INIT(&m->table[i]);
	}

	m->count=0;
	m->free_entry=free_entry?free_entry:_map_donotfree;
	m->hash=hash;
	m->compare=compare;
}

/* adds an entry, and refuses to add more than one
 * exclusive prevents the same key from being added more than once
 * replace causes the old entry to be removed
 */
EXPORT int map_replace(struct map *m, void *key, const union map_data *data, int replace, int exclusive) {
	struct map_entry *e;
	uint_least32_t h;

	assert(m != NULL);
	assert(key != NULL);
	assert(m->compare != NULL);

	h=m->hash(key);

	if(exclusive) {
		/* look for a duplicate key and refuse to overwrite it */
		for(e=LIST_TOP(m->table[h&m->table_mask]);e;e=LIST_NEXT(e, list)) {
			assert(e->key != NULL);
			if(m->compare(key, e->key)==0) {
				if(replace) {
					LIST_REMOVE(e, list);
					m->free_entry(e->key, &e->data);
					free(e);
					m->count--;
					/* this will continue freeing ALL matching entries */
				} else {
					return 0; /* duplicate key found */
				}
			}
		}
	}

	e=malloc(sizeof *e);
	if(!e) {
		PERROR("malloc()");
		return 0;
	}
	e->key=key;
	e->data=*data;
	LIST_INSERT_HEAD(&m->table[h&m->table_mask], e, list);
	m->count++;

	return 1;
}

/* refuses to add more than one copy of the same key */
EXPORT int map_add_ptr(struct map *m, void *key, void *ptr) {
	const union map_data data={.ptr=ptr};
	return map_replace(m, key, &data, 0, 1);
}

EXPORT int map_replace_ptr(struct map *m, void *key, void *ptr) {
	const union map_data data={.ptr=ptr};
	return map_replace(m, key, &data, 1, 1);
}

/* refuses to add more than one copy of the same key */
EXPORT int map_add_uint(struct map *m, uintptr_t key, void *ptr) {
	const union map_data data={.ptr=ptr};
	return map_replace(m, (void*)key, &data, 0, 1);
}

EXPORT int map_replace_uint(struct map *m, uintptr_t key, void *ptr) {
	const union map_data data={.ptr=ptr};
	return map_replace(m, (void*)key, &data, 1, 1);
}

/**
 * if key matches then replace
 */
EXPORT int map_replace_fpos(struct map *m, uintptr_t key, const fpos_t *pos) {
	const union map_data data={.pos=*pos};
	DEBUG("key=%" PRIdPTR "\n", key);
	return map_replace(m, (void*)key, &data, 1, 1);
}

/* returns first matching entry */
EXPORT union map_data *map_lookup(struct map *m, const void *key) {
	struct map_entry *e;
	uint_least32_t h;

	assert(m != NULL);
	assert(key != NULL);
	assert(m->hash != NULL);
	assert(m->compare != NULL);

	h=m->hash(key);

	/* look for a duplicate key and refuse to overwrite it */
	for(e=LIST_TOP(m->table[h&m->table_mask]);e;e=LIST_NEXT(e, list)) {
		assert(e->key != NULL);
		/* DEBUG("%s():comparing '%s' '%s'\n", __func__, key, e->key); */
		if(m->compare(key, e->key)==0) {
			return &e->data;
		}
	}
	return NULL;
}

EXPORT fpos_t *map_lookup_fpos(struct map *m, uintptr_t key) {
	union map_data *data;
	data=map_lookup(m, (void*)key);
	return data ? &data->pos : NULL;
}

EXPORT void *map_lookup_ptr(struct map *m, const void *key) {
	const union map_data *data;
	data=map_lookup(m, key);
	return data ? data->ptr : NULL;
}

EXPORT void map_foreach(struct map *m, void *p, void (*callback)(void *p, void *key, union map_data *data)) {
	unsigned i;
	struct map_entry *curr;
	assert(callback != NULL);
	TODO("Does this function work?");
	TRACE("table_mask=%d\n", m->table_mask);
	for(i=0;i<=m->table_mask;i++) {
		TRACE("i=%u mask=%u\n", i, m->table_mask);
		for(curr=LIST_TOP(m->table[i]);curr;curr=LIST_NEXT(curr, list)) {
			TRACE("curr=%p\n", curr);
			callback(p, curr->key, &curr->data);
		}
	}
}

/* frees the entry */
EXPORT int map_remove(struct map *m, void *key) {
	struct map_entry *e, *tmp;
	uint_least32_t h;
	int res=0;

	assert(m != NULL);
	assert(key != NULL);
	assert(m->hash != NULL);
	assert(m->compare != NULL);

	h=m->hash(key);

	/* look for a duplicate key and refuse to overwrite it */
	for(e=LIST_TOP(m->table[h&m->table_mask]);e;) {
		assert(e->key != NULL);
		if(m->compare(key, e->key)==0) {
			tmp=LIST_NEXT(e, list);
			LIST_REMOVE(e, list);
			m->free_entry(e->key, &e->data);
			memset(e, 0x99, sizeof *e);
			free(e);
			m->count--;
			/* this will continue freeing ALL matching entries */
			res=1; /* freed an entry */
			e=tmp;
		} else {
			e=LIST_NEXT(e, list);
		}
	}

	return res; /* not found */
}

EXPORT int map_remove_uint(struct map *m, uintptr_t key) {
	return map_remove(m, (void*)key);
}

EXPORT void map_free(struct map *m) {
	struct map_entry *e;
	unsigned i;

	for(i=0;i<=m->table_mask;i++) {
		while((e=LIST_TOP(m->table[i]))) {
			LIST_REMOVE(e, list);
			m->free_entry(e->key, &e->data);
			free(e);
			m->count--;
		}
	}
	m->table_mask=0;
	free(m->table);
	m->table=NULL;
#ifndef NDEBUG
	memset(m, 0x55, sizeof *m); /* fill with fake data before freeing */
#endif
}

#ifndef NDEBUG
struct map_test_entry {
	char *str;
	unsigned value;
};

static void map_test_free(void *key UNUSED, union map_data *data) {
	struct map_test_entry *e=data->ptr;
	free(e->str);
	free(e);
}

static struct map_test_entry *map_test_alloc(const char *str, unsigned value) {
	struct map_test_entry *e;
	e=malloc(sizeof *e);
	e->str=strdup(str);
	e->value=value;
	return e;
}

EXPORT void map_test(void) {
	struct map m;
	struct map_test_entry *e;
	unsigned i;
	const char *test[] = {
		"foo",
		"bar",
		"",
		"z",
		"hi",
	};

	map_init(&m, 4, map_test_free, map_hash_stringignorecase, map_compare_stringignorecase);

	for(i=0;i<NR(test);i++) {
		e=map_test_alloc(test[i], 5*i);
		if(!map_add_ptr(&m, e->str, e)) {
			printf("map_add_ptr() failed\n");
		}
	}

	if(!map_remove(&m, "bar")) {
		printf("map_remove() failed\n");
	}

	for(i=0;i<NR(test);i++) {
		e=map_lookup_ptr(&m, test[i]);
		if(!e) {
			printf("map_lookup() failed\n");
		} else {
			printf("found '%s' -> '%s' %u\n", test[i], e->str, e->value);
		}
	}

	printf("removing 'foo'\n");
	if(!map_remove(&m, "foo")) {
		printf("map_remove() failed\n");
	}

	printf("removing 'hi'\n");
	if(!map_remove(&m, "hi")) {
		printf("map_remove() failed\n");
	}

	map_free(&m);
}
#endif

/******************************************************************************
 * eventlog - writes logging information based on events
 ******************************************************************************/
/*-* eventlog:globals *-*/
static FILE *eventlog_file;

/*-* eventlog:internal functions *-*/

/*-* eventlog:external functions *-*/

/** initialize */
int eventlog_init(void) {
	eventlog_file=fopen(mud_config.eventlog_filename, "a");
	if(!eventlog_file) {
		PERROR(mud_config.eventlog_filename);
		return 0; /* failure */
	}

	setvbuf(eventlog_file, NULL, _IOLBF, 0);

	return 1; /* success */
}

void eventlog_shutdown(void) {
	if(eventlog_file) {
		fclose(eventlog_file);
		eventlog_file=0;
	}
}

void eventlog(const char *type, const char *fmt, ...) {
	va_list ap;
	char buf[512];
	int n;
	time_t t;
	char timestamp[64];

	va_start(ap, fmt);
	n=vsnprintf(buf, sizeof buf, fmt, ap);
	va_end(ap);
	if(n<0) {
		ERROR_MSG("vsnprintf() failure");
		return; /* failure */
	}

	if(n>=(int)sizeof buf) { /* output was truncated */
		n=strlen(buf);
	}

	/* make certain the last character is a newline */
	if(n>0 && buf[n-1]!='\n') {
		if(n==sizeof buf) n--;
		buf[n]='\n';
		buf[n+1]=0;
		DEBUG_MSG("Adding newline to message");
	}

	time(&t);
	strftime(timestamp, sizeof timestamp, mud_config.eventlog_timeformat, gmtime(&t));
	if(fprintf(eventlog_file?eventlog_file:stderr, "%s:%s:%s", timestamp, type, buf)<0) {
		/* there was a write error */
		PERROR(eventlog_file?mud_config.eventlog_filename:"stderr");
	}
}

/** report that a connection has occured */
void eventlog_connect(const char *peer_str) {
	eventlog("CONNECT", "remote=%s\n", peer_str);
}

void eventlog_server_startup(void) {
	eventlog("STARTUP", "\n");
}

void eventlog_server_shutdown(void) {
	eventlog("SHUTDOWN", "\n");
}

void eventlog_login_failattempt(const char *username, const char *peer_str) {
	eventlog("LOGINFAIL", "remote=%s name='%s'\n", peer_str, username);
}

void eventlog_signon(const char *username, const char *peer_str) {
	eventlog("SIGNON", "remote=%s name='%s'\n", peer_str, username);
}

void eventlog_signoff(const char *username, const char *peer_str) {
	eventlog("SIGNOFF", "remote=%s name='%s'\n", peer_str, username);
}

void eventlog_toomany(void) {
	/* TODO: we could get the peername from the fd and log that? */
	eventlog("TOOMANY", "\n");
}

/**
 * log commands that a user enters
 */
void eventlog_commandinput(const char *remote, const char *username, const char *line) {
	eventlog("COMMAND", "remote=\"%s\" user=\"%s\" command=\"%s\"\n", remote, username, line);
}

void eventlog_channel_new(const char *channel_name) {
	eventlog("CHANNEL-NEW", "channel=\"%s\"\n", channel_name);
}

void eventlog_channel_remove(const char *channel_name) {
	eventlog("CHANNEL-REMOVE", "channel=\"%s\"\n", channel_name);
}

void eventlog_channel_join(const char *remote, const char *channel_name, const char *username) {
	if(!remote) {
		eventlog("CHANNEL-JOIN", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-JOIN", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

void eventlog_channel_part(const char *remote, const char *channel_name, const char *username) {
	if(!remote) {
		eventlog("CHANNEL-PART", "channel=\"%s\" user=\"%s\"\n", channel_name, username);
	} else  {
		eventlog("CHANNEL-PART", "remote=\"%s\" channel=\"%s\" user=\"%s\"\n", remote, channel_name, username);
	}
}

/******************************************************************************
 * Config loader
 ******************************************************************************/
struct config_watcher;
struct config {
	LIST_HEAD(struct, struct config_watcher) watchers;
};

struct config_watcher {
	LIST_ENTRY(struct config_watcher) list;
	char *mask;
	int (*func)(struct config *cfg, void *extra, const char *id, const char *value);
	void *extra;
};

EXPORT void config_setup(struct config *cfg) {
	LIST_INIT(&cfg->watchers);
}

EXPORT void config_free(struct config *cfg) {
	struct config_watcher *curr;
	assert(cfg != NULL);
	while((curr=LIST_TOP(cfg->watchers))) {
		LIST_REMOVE(curr, list);
		free(curr->mask);
		free(curr);
	}
}

/* adds a watcher with a shell style mask
 * func can return 0 to end the chain, or return 1 if the operation should continue on */
EXPORT void config_watch(struct config *cfg, const char *mask, int (*func)(struct config *cfg, void *extra, const char *id, const char *value), void *extra) {
	struct config_watcher *w;
	assert(mask != NULL);
	assert(cfg != NULL);
	w=malloc(sizeof *w);
	w->mask=strdup(mask);
	w->func=func;
	w->extra=extra;
	LIST_INSERT_HEAD(&cfg->watchers, w, list);
}

EXPORT int config_load(const char *filename, struct config *cfg) {
	char buf[1024];
	FILE *f;
	char *e, *value;
	unsigned line;
	char quote;
	struct config_watcher *curr;

	f=fopen(filename, "r");
	if(!f) {
		PERROR(filename);
		return 0;
	}
	line=0;
	while(line++,fgets(buf, sizeof buf, f)) {
		/* strip comments - honors '' and "" quoting */
		for(e=buf,quote=0;*e;e++) {
			if(!quote && *e=='"')
				quote=*e;
			else if(!quote && *e=='\'')
				quote=*e;
			else if(quote=='\'' && *e=='\'')
				quote=0;
			else if(quote=='"' && *e=='"')
				quote=0;
			else if(!quote && ( *e=='#' || (*e=='/' && e[1]=='/' ))) {
				*e=0; /* found a comment */
				break;
			}
		}

		/* strip trailing white space */
		e=buf+strlen(buf);
		while(e>buf && isspace(*--e)) {
			*e=0;
		}

		/* ignore blank lines */
		if(*buf==0) {
			TRACE("%s:%d:ignoring blank line\n", filename, line);
			continue;
		}

		e=strchr(buf, '=');
		if(!e) {
			/* invalid directive */
			ERROR_FMT("%s:%d:invalid directive\n", filename, line);
			goto failure;
		}

		/* move through the leading space of the value part */
		value=e+1;
		while(isspace(*value)) value++;

		/* strip trailing white space from id part */
		*e=0; /* null terminate the id part */
		while(e>buf && isspace(*--e)) {
			*e=0;
		}

		TODO("dequote the value part");

		/* printf("id='%s' value='%s'\n", buf, value); */

		/* check the masks */
		for(curr=LIST_TOP(cfg->watchers);curr;curr=LIST_NEXT(curr, list)) {
			if(!util_fnmatch(curr->mask, buf, UTIL_FNM_CASEFOLD) && curr->func) {
				int res;
				res=curr->func(cfg, curr->extra, buf, value);
				if(!res) {
					break; /* return 0 from the callback will terminate the list */
				} else if(res<0) {
					ERROR_FMT("%s:%u:error in loading file\n", filename, line);
					goto failure;
				}
			}
		}
	}
	fclose(f);
	return 1; /* success */
failure:
	fclose(f);
	return 0; /* failure */
}

#ifndef NTEST
static int config_test_show(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value) {
	printf("CONFIG SHOW: %s=%s\n", id, value);
	return 1;
}

static void config_test(void) {
	struct config cfg;
	config_setup(&cfg);
	config_watch(&cfg, "s*er.*", config_test_show, 0);
	config_load("test.cfg", &cfg);
	config_free(&cfg);
}
#endif


/******************************************************************************
 * Bitmap API
 ******************************************************************************/

#define BITMAP_BITSIZE (sizeof(unsigned)*CHAR_BIT)

struct bitmap {
	unsigned *bitmap;
	size_t bitmap_allocbits;
};

EXPORT void bitmap_init(struct bitmap *bitmap) {
	assert(bitmap!=NULL);
	bitmap->bitmap=0;
	bitmap->bitmap_allocbits=0;
}

EXPORT void bitmap_free(struct bitmap *bitmap) {
	assert(bitmap!=NULL); /* catch when calling free on NULL */
	if(bitmap) {
		free(bitmap->bitmap);
		bitmap_init(bitmap);
	}
}

/* newbits is in bits (not bytes) */
EXPORT int bitmap_resize(struct bitmap *bitmap, size_t newbits) {
	unsigned *tmp;

	newbits=ROUNDUP(newbits, BITMAP_BITSIZE);
	DEBUG("%s():Allocating %zd bytes\n", __func__, newbits/CHAR_BIT);
	tmp=realloc(bitmap->bitmap, newbits/CHAR_BIT);
	if(!tmp) {
		PERROR("realloc()");
		return 0; /* failure */
	}
	if(bitmap->bitmap_allocbits<newbits) {
		/* clear out the new bits */
		size_t len;
		len=(newbits-bitmap->bitmap_allocbits)/CHAR_BIT;
		DEBUG("%s():Clearing %zd bytes (ofs %zd)\n", __func__, len, bitmap->bitmap_allocbits/BITMAP_BITSIZE);
		memset(tmp+bitmap->bitmap_allocbits/BITMAP_BITSIZE, 0, len);
	}

	bitmap->bitmap=tmp;
	bitmap->bitmap_allocbits=newbits;
	return 1; /* success */
}

EXPORT void bitmap_clear(struct bitmap *bitmap, unsigned ofs, unsigned len) {
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if(ofs+len>bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs+len);
	}

	p=bitmap->bitmap+ofs/BITMAP_BITSIZE; /* point to the first word */

	head_ofs=ofs%BITMAP_BITSIZE;
	head_len=len>BITMAP_BITSIZE-ofs ? BITMAP_BITSIZE-ofs : len;

	/* head */
	if(head_len<BITMAP_BITSIZE) {
		len-=head_len;
		mask=~(~((~0U)<<head_len)<<head_ofs);
		*p++&=mask;
	}

	for(;len>=BITMAP_BITSIZE;len-=BITMAP_BITSIZE) {
		*p++=0U;
	}

	if(len>0) {
		/* tail */
		mask=~((~0U)>>(BITMAP_BITSIZE-len));
		mask=(~0U)>>len;
		*p&=mask;
	}
}

EXPORT void bitmap_set(struct bitmap *bitmap, unsigned ofs, unsigned len) {
	unsigned *p, mask;
	unsigned head_ofs, head_len;

	/* allocate more */
	if(ofs+len>bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, ofs+len);
	}

	p=bitmap->bitmap+ofs/BITMAP_BITSIZE; /* point to the first word */

	head_ofs=ofs%BITMAP_BITSIZE;
	head_len=len>BITMAP_BITSIZE-ofs ? BITMAP_BITSIZE-ofs : len;

	/* head */
	if(head_len<BITMAP_BITSIZE) {
		len-=head_len;
		mask=(~((~0U)<<head_len))<<head_ofs;
		*p++|=mask;
	}

	for(;len>=BITMAP_BITSIZE;len-=BITMAP_BITSIZE) {
		*p++=~0U;
	}

	if(len>0) {
		/* tail */
		mask=(~0U)>>(BITMAP_BITSIZE-len);
		*p|=mask;
	}
}

/* gets a single bit */
EXPORT int bitmap_get(struct bitmap *bitmap, unsigned ofs) {
	if(ofs<bitmap->bitmap_allocbits) {
		return (bitmap->bitmap[ofs/BITMAP_BITSIZE]>>(ofs%BITMAP_BITSIZE))&1;
	} else {
		return 0; /* outside of the range, the bits are cleared */
	}
}

/* return the position of the next set bit
 * -1 if the end of the bits was reached */
EXPORT int bitmap_next_set(struct bitmap *bitmap, unsigned ofs) {
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len=bitmap->bitmap_allocbits/BITMAP_BITSIZE;
	TODO("check the head"); /* I don't remember what these TODO's are for */
	for(i=ofs/BITMAP_BITSIZE;i<len;i++) {
		if(bitmap->bitmap[i]!=0) {
			/* found a set bit - scan the word to find the position */
			for(bofs=0;((bitmap->bitmap[i]>>bofs)&1)==0;bofs++) ;
			return i*BITMAP_BITSIZE+bofs;
		}
	}
	TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/* return the position of the next set bit
 * -1 if the end of the bits was reached */
EXPORT int bitmap_next_clear(struct bitmap *bitmap, unsigned ofs) {
	unsigned i, len, bofs;
	assert(bitmap != NULL);
	len=bitmap->bitmap_allocbits/BITMAP_BITSIZE;
	TODO("check the head"); /* I don't remember what these TODO's are for */
	for(i=ofs/BITMAP_BITSIZE;i<len;i++) {
		if(bitmap->bitmap[i]!=~0U) {
			/* found a set bit - scan the word to find the position */
			for(bofs=0;((bitmap->bitmap[i]>>bofs)&1)==1;bofs++) ;
			return i*BITMAP_BITSIZE+bofs;
		}
	}
	TODO("check the tail"); /* I don't remember what these TODO's are for */
	return -1; /* outside of the range */
}

/* loads a chunk of memory into the bitmap buffer
 * erases previous bitmap buffer
 * len is in bytes */
EXPORT void bitmap_loadmem(struct bitmap *bitmap, unsigned char *d, size_t len) {
	unsigned *p, word_count, i;

	/* resize if too small */
	if((len*CHAR_BIT)>bitmap->bitmap_allocbits) {
		bitmap_resize(bitmap, len*CHAR_BIT);
	}

	p=bitmap->bitmap;
	word_count=len/sizeof *p; /* number of words in d */

	/* first do the words */
	while(word_count>0) {
		i=sizeof *p-1;
		*p=0;
		do {
			*p|=*d<<(i*CHAR_BIT);
			d++;
		} while(--i);
		p++;
		word_count--;
		len-=sizeof *p;
	}

	/* finish the remaining */
	i=sizeof *p-1;
	while(len>0) {
		*p&=0xff<<(i*CHAR_BIT);
		*p|=*d<<(i*CHAR_BIT);
		i--;
		d++;
		len--;
	}
}

/* returns the length in bytes of the entire bitmap table */
EXPORT unsigned bitmap_length(struct bitmap *bitmap) {
	return bitmap ? ROUNDUP(bitmap->bitmap_allocbits, CHAR_BIT)/CHAR_BIT : 0;
}

#ifndef NDEBUG
EXPORT void bitmap_test(void) {
	int i;
	struct bitmap bitmap;

	bitmap_init(&bitmap);
	bitmap_resize(&bitmap, 1024);
	/* fill in with a test pattern */
	for(i=0;i<5;i++) {
		bitmap.bitmap[i]=0x12345678;
	}

	bitmap_set(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_set():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], convert_number(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_set():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], convert_number(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 7, 1);
	/* display the test pattern */
	printf("bitmap_clear():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], convert_number(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 12, 64);
	/* display the test pattern */
	printf("bitmap_clear():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], convert_number(bitmap.bitmap[i], 2, 32));
	}

	bitmap_set(&bitmap, 0, BITMAP_BITSIZE*5);
	/* display the test pattern */
	printf("bitmap_set():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x %s\n", bitmap.bitmap[i], convert_number(bitmap.bitmap[i], 2, 32));
	}

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE*5);
	bitmap_set(&bitmap, 101, 1);
	printf("word at bit 101 = 0x%08x\n", bitmap.bitmap[101/BITMAP_BITSIZE]);
	printf("next set starting at 9 = %d\n", bitmap_next_set(&bitmap, 9));
	bitmap_clear(&bitmap, 101, 1);

	bitmap_set(&bitmap, 0, 101);
	printf("next clear starting at 9 = %d\n", bitmap_next_clear(&bitmap, 9));
	bitmap_clear(&bitmap, 0, 101);

	bitmap_clear(&bitmap, 0, BITMAP_BITSIZE*5);
	printf("next set should return -1 = %d\n", bitmap_next_set(&bitmap, 0));

	bitmap_free(&bitmap);
}
#endif

/******************************************************************************
 * acs - access control string
 ******************************************************************************/
#include <limits.h>
struct acs_info {
	unsigned char level;
	unsigned flags;
};

static void acs_init(struct acs_info *ai, unsigned level, unsigned flags) {
	ai->level=level<=UCHAR_MAX?level:UCHAR_MAX;
	ai->flags=flags;
}

static int acs_testflag(struct acs_info *ai, unsigned flag) {
	unsigned i;
	flag=tolower((char)flag);
	if(flag>='a' && flag<='z') {
		i=flag-'a';
	} else if(flag>='0' && flag<='9') {
		i=flag-'0'+26;
	} else {
		ERROR_FMT("unknown flag '%c'\n", flag);
		return 0;
	}
	return ((ai->flags>>i)&1)==1;
}

static int acs_check(struct acs_info *ai, const char *acsstring) {
	const char *s=acsstring;
	const char *endptr;
	unsigned long level;
retry:
	while(*s) switch(*s++) {
		case 's':
			level=strtoul(s, (char**)&endptr, 10);
			if(endptr==acsstring) {
				goto parse_failure;
			}
			if(ai->level<level) goto did_not_pass;
			s=endptr;
			break;
		case 'f':
			if(!acs_testflag(ai, (unsigned)*s)) goto did_not_pass;
			s++;
			break;
		case '|':
			return 1; /* short circuit the OR */
		default:
			goto parse_failure;
	}
	return 1; /* everything matched */
did_not_pass:
	while(*s) if(*s++=='|') goto retry; /* look for an | */
	return 0;
parse_failure:
	ERROR_FMT("acs parser failure '%s' (off=%d)\n", acsstring, s-acsstring);
	return 0;
}

#ifndef NDEBUG
void acs_test(void) {
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
/* TODO: prefix these to clean up the namespace */
#define IAC '\377'
#define DONT '\376'
#define DO '\375'
#define WONT '\374'
#define WILL '\373'
#define SB '\372'
#define GA '\371'
#define EL '\370'
#define EC '\367'
#define AYT '\366'
#define AO '\365'
#define IP '\364'
#define BREAK '\363'
#define DM '\362'
#define NOP '\361'
#define SE '\360'
#define EOR '\357'
#define ABORT '\356'
#define SUSP '\355'
#define xEOF '\354' /* this is what BSD arpa/telnet.h calls the EOF */
#define SYNCH '\362'

#define TELOPT_ECHO 1
#define TELOPT_SGA 3
#define TELOPT_TTYPE 24		/* terminal type - rfc1091 */
#define TELOPT_NAWS 31		/* negotiate about window size - rfc1073 */
#define TELOPT_LINEMODE 34	/* line mode option - rfc1116 */

/* generic sub-options */
#define TELQUAL_IS 0
#define TELQUAL_SEND 1
#define TELQUAL_INFO 2

/** Linemode sub-options **/
#define	LM_MODE 1
#define	LM_FORWARDMASK 2
#define	LM_SLC 3

#define	MODE_EDIT 1
#define	MODE_TRAPSIG 2
#define	MODE_ACK 4
#define MODE_SOFT_TAB 8
#define MODE_LIT_ECHO 16

#define	MODE_MASK 31

/******************************************************************************
 * base64 : encode base64
 ******************************************************************************/
/* base64_encodes as ./0123456789a-zA-Z
 * length is the number of 32-bit words */
static inline void base64_encode(char *ret, size_t length, uint32_t *v) {
	uint32_t x; /* buffer for current value */
	int xlen, vlen;

	xlen=0;
	vlen=0;
	x=0;

	while(length>0 || xlen>0) {
		if(xlen<6) {
			if(length>0) {
				x|=(*v>>vlen)<<xlen;
				xlen+=16;
				vlen+=16;
				if(vlen>=32) {
					v++;
					length--;
					vlen=0;
				}
			} else {
				xlen=6; /* pad remaining */
			}
		}
		*ret=x&63;

		/* convert to a base64 system (this code only works for ASCII) */
		if(*ret>=0 && *ret<12) *ret+='.'; else
		if(*ret>=12 && *ret<38) *ret+='A'-12; else
		if(*ret>=38 && *ret<64) *ret+='a'-38;

		ret++;
		x>>=6;
		xlen-=6;
	}
	*ret=0;
}

/******************************************************************************
 * xxtcrypt : password hashing using XXT (improved version of TEA)
 ******************************************************************************/
#define XXTCRYPT_BITS 128
#define XXTCRYPT_GENSALT_LEN 6
#define XXTCRYPT_GENSALT_MAX 16
/* maximum length of crypted password */
#define XXTCRYPT_MAX (XXTCRYPT_GENSALT_MAX+1+(2+4*(XXTCRYPT_BITS/8))/3+1)

/**
 * expands copies of salt and plaintext into key space m
 */
static inline void xxtcrypt_salt_prepare(char *m, size_t len, const char *plaintext, const char salt[2]) {
	unsigned i;

	memset(m, 0, len);
	/* load salt */
	for(i=0;i<2;i++) {
		m[i]=salt[i];
	}
	/* load plaintext into remaining bytes, looping over them */
	for(;plaintext[i-2];i++) {
		int pos=i%len;
		/* swap nibbles of previous cell and add key */
		m[pos]=((m[pos]<<4)|((unsigned)m[pos]>>4))+plaintext[i-2];
	}
}

/**
 * XXT encrypt
 */
static inline void xxtcrypt_ll_enc(size_t length, uint32_t *v, uint32_t k[4]) {
	uint32_t z=v[length-1], y, sum=0, e;
	unsigned q, p;

	assert(length>1);

	// TRACE("len=%d\n", length);
	// TRACE("--- KEY --- k: 0x%08x 0x%08x 0x%08x 0x%08x\n", k[0], k[1], k[2], k[3]);
	// TRACE("--- ENC --- v0: 0x%08x v1: 0x%08x\n", v[0], v[1]);

	/* 32 cycles for a length=2, which is 64 rounds */
	q=6+52/length;
	// printf("%s(): %d cycles (%d rounds)\n", __func__, q, q*length);
	while(q-->0) {
		sum+=0x9e3779b9; /* delta */
		e=sum>>2&3;
		for(p=0;p<=length-1;p++) {
			if(p<length-1) {
				y=v[p+1];
			} else {
				y=v[0];
			}
			v[p]+=(((z>>5)^(y<<2))+((y>>3)^(z<<4)))^((sum^y)+(k[(p&3)^e]^z));
			z=v[p];
		}
	}
}

/* load keys returns new offset */
static inline unsigned xxtcrypt_ll_load_k4(unsigned ofs, uint32_t k[4], const char *plaintext, size_t saltlen, const char *salt) {
	unsigned ki, i;

	ki=0;

	k[0]=k[1]=k[2]=k[3]=0; /* clear the key space */

	for(;ofs<saltlen;ofs++) {
		k[ki/4]|=(uint32_t)salt[ofs]<<(8*ki);
		ki=(ki+1)%(4*4); /* 4 bytes per word, 4 words per key */
	}

	for(i=ofs-saltlen;plaintext[i];i++,ofs++) {
		k[ki/4]|=(uint32_t)plaintext[i]<<(8*ki);
		ki=(ki+1)%(4*4); /* 4 bytes per word, 4 words per key */
	}
	return ofs;
}

/**
 * format: salt!hash
 */
char *xxtcrypt(size_t max, char *dest, const char *plaintext, size_t saltlen, const char *salt, size_t bits) {
	unsigned ofs, i;
	uint32_t k[128/32]; /* 128-bit key */
#if __STDC_VERSION__ >= 199901L
	uint32_t v[bits/32], lastv[bits/32]; /* encrypted value */
#else
	uint32_t v[XXTCRYPT_BITS/32], lastv[XXTCRYPT_BITS/32]; /* encrypted value */
#endif

	if(max<saltlen+1+(2+4*(bits/8))/3+1) {
		printf("won't fit!!\n");
		return 0;
	}

	memset(v, 0, sizeof v); /* start with a hash of 0 */

	ofs=0;
	do {
		ofs=xxtcrypt_ll_load_k4(ofs, k, plaintext, saltlen, salt); /* load next chunk */

		memcpy(lastv, v, sizeof v); /* copy the old value of v */
		xxtcrypt_ll_enc(NR(v), v, k); /* modifies v to encrypt it */
		for(i=0;i<NR(v);i++) {
			v[i]^=lastv[i]; /* the XOR step in Davies-Meyer */
		}
		// TRACE("bits=%d vsz=%d ofs=%d saltlen=%d\n", bits, NR(v), ofs, saltlen);
	} while(plaintext[ofs-saltlen]);

	memset(k, 0, sizeof k); /* remove key data */

	memcpy(dest, salt, saltlen);
	i=saltlen;
	dest[i++]='!';

	base64_encode(dest+i, NR(v), v);
	return dest;
}

/* fills with salt data */
void xxtcrypt_gensalt(size_t salt_len, char *salt, int (*rand_func)(void), unsigned randomitity) {
	unsigned randness, i, pool;

	/* pool starts with no randomness */
	pool=time(NULL);
	randness=0;

	for(i=0;i<salt_len;i++) {
		if(randness<64) {
			pool^=rand_func();
			randness+=randomitity; /* rand_func adds a certain amount of randness */
		}

		/* */
		salt[i]=pool%64;
		pool/=64;
		randness/=64;

		/* convert to a base64 system (this code only works for ASCII) */
		if(salt[i]>=0 && salt[i]<12) salt[i]+='.'; else
		if(salt[i]>=12 && salt[i]<38) salt[i]+='A'-12; else
		if(salt[i]>=38 && salt[i]<64) salt[i]+='a'-38;
	}
}

/**
 * creates a random salt and applies it to the password
 */
int xxtcrypt_makepass(char *buf, size_t max, const char *plaintext) {
	char salt[XXTCRYPT_GENSALT_LEN];

	xxtcrypt_gensalt(sizeof salt, salt, rand, RAND_MAX/2);

	if(!xxtcrypt(max, buf, plaintext, sizeof salt, salt, XXTCRYPT_BITS)) {
		return 0; /* failure */
	}
	return 1; /* success */
}

/**
 * checks a password
 */
int xxtcrypt_checkpass(const char *crypttext, const char *plaintext) {
	const char *hashptr;
	size_t saltlen;
	char buf[XXTCRYPT_MAX+1], *res;

	hashptr=strchr(crypttext, '!');
	if(!hashptr) return 0; /* failure - not a valid password crypt */
	saltlen=hashptr-crypttext;
	hashptr++;

	if(saltlen>XXTCRYPT_GENSALT_MAX) {
		return 0; /* failure - this large salt size is unsupported */
	}

	res=xxtcrypt(sizeof buf, buf, plaintext, saltlen, crypttext, XXTCRYPT_BITS);
	if(!res) {
		return 0; /* failure - won't fit */
	}

	/* TODO: only compare the hashes and not the salts and formatting */
	return strcmp(buf, crypttext)==0; /* return 1 if passwords match */
}

#ifndef NTEST
static void xxtcrypt_test(void) {
	const char *test_pass[] = {
		"hello",
		"tHIs Is A tEst",
		"",
		"    "
		"xxxxxxxxxxxxxxxxyyyyy",
	};
	char buf[XXTCRYPT_MAX+1];
	unsigned i;

	srand((unsigned)time(NULL));

	for(i=0;i<NR(test_pass);i++) {
		if(!xxtcrypt_makepass(buf, sizeof buf, test_pass[i])) abort();
		if(!xxtcrypt_checkpass(buf, test_pass[i])) {
			fprintf(stderr, "ERROR:passwords do not match\n");
			abort();
		}
		fprintf(stderr, "crypted: %s plain: \"%s\"\n", buf, test_pass[i]);
	}
	if(xxtcrypt_checkpass(buf, "abc")) {
		fprintf(stderr, "ERROR:password shouldn't match\n");
		abort();
	}
}
#endif
/******************************************************************************
 * fdb
 ******************************************************************************/

/**
 * creates a filename based on component and id
 */
void fdb_makename_str(char *fn, size_t max, const char *base, const char *id) {
	char name[id?strlen(id)+1:6];
	unsigned i;

	if(!id) id="_nil_";

	/* process id into a good filename */
	for(i=0;i<sizeof name-1 && id[i];i++) {
		TRACE("id='%s' i=%d\n", id, i);
		if(isalnum(id[i])) {
			name[i]=tolower(id[i]);
		} else {
			name[i]='_';
		}
	}
	name[i]=0;
	TRACE("name='%s' i=%d max=%d name_sz=%d\n", name, i, max, sizeof name);

	snprintf(fn, max, "data/%s/%s", base, name);
	TRACE("res='%s'\n", fn);
}

/**
 * creates a filename based on component and id
 */
void fdb_getbasename(char *fn, size_t max, const char *base) {
	snprintf(fn, max, "data/%s/", base);
}

/**
 * return true if the file is a valid id filename
 */
int fdb_is_id(const char *filename) {
	for(;*filename;filename++) if(!isdigit(*filename)) return 0;
	return 1; /* success */
}

/******************************************************************************
 * users
 ******************************************************************************/
/** user:configuration **/

/* defaults for new users */
#define USER_LEVEL_NEWUSER mud_config.newuser_level
#define USER_FLAGS_NEWUSER mud_config.newuser_flags

/** user:types **/
struct user {
	unsigned id;
	char *username;
	char *password_crypt;
	char *email;
	struct acs_info acs;
	REFCOUNT_TYPE REFCOUNT_NAME;
};

struct user_name_map_entry {
	unsigned id;
	char *username;
};

/** user:globals **/
static struct map user_name_map; /* convert username to id */
static struct freelist user_id_freelist;
static struct map user_cache_id_map; /* cache table for looking up by id */
static struct map user_cache_name_map; /* cache table for looking up by username */

/** user:internal functions **/
static int user_cache_add(struct user *u) {
	int ret=1;
	if(!map_replace_uint(&user_cache_id_map, u->id, u)) {
		ERROR_FMT("map_add_ptr() for userid(%d) failed\n", u->id);
		ret=0; /* failure */
	}
	if(!map_replace_ptr(&user_cache_name_map, u->username, u)) {
		ERROR_FMT("map_add_ptr() for username(%s) failed\n", u->username);
		ret=0; /* failure */
	}
	return ret;
}

static int user_cache_remove(struct user *u) {
	int ret=1;
	if(!map_remove_uint(&user_cache_id_map, u->id)) {
		ERROR_FMT("map_remove() for userid(%d) failed\n", u->id);
		ret=0; /* failure */
	}
	if(!map_remove(&user_cache_name_map, u->username)) {
		ERROR_FMT("map_remove() for username(%s) failed\n", u->username);
		ret=0; /* failure */
	}
	return ret;
}

/* only free the structure data */
static void user_ll_free(struct user *u) {
	if(!u) return;
	free(u->username);
	u->username=0;
	free(u->password_crypt);
	u->password_crypt=0;
	free(u->email);
	u->email=0;
	free(u);
}

static void user_free(struct user *u) {
	if(!u) return;
	user_cache_remove(u);
	user_ll_free(u);
}

/* allocate a default struct */
static struct user *user_defaults(void) {
	struct user *u;
	u=calloc(1, sizeof *u);
	if(!u) {
		PERROR("malloc()");
		return NULL;
	}

	u->id=0;
	REFCOUNT_INIT(u);
	u->username=NULL;
	u->password_crypt=NULL;
	u->email=NULL;
	u->acs.level=USER_LEVEL_NEWUSER;
	u->acs.flags=USER_FLAGS_NEWUSER;
	return u;
}

static int user_ll_load_uint(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value) {
	char *endptr;
	unsigned *uint_p=extra;
	assert(extra != NULL);
	if(!extra) return -1; /* error */

	if(!*value) {
		DEBUG_MSG("Empty string");
		return -1; /* error - empty string */
	}
	*uint_p=strtoul(value, &endptr, 0);

	if(*endptr!=0) {
		DEBUG_MSG("Not a number");
		return -1; /* error - empty string */
	}

	return 0; /* success - terminate the callback chain */
}

static int user_ll_load_str(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value) {
	char **str_p=extra;
	assert(extra != NULL);
	if(!extra) return -1; /* error */

	if(*str_p) free(*str_p);
	*str_p=strdup(value);
	if(!*str_p) {
		PERROR("strdup()");
		return -1; /* error */
	}

	return 0; /* success - terminate the callback chain */
}

static struct user *user_load_byname(const char *username) {
	FILE *f;
	char filename[PATH_MAX];
	struct user *u;
	struct config cfg;

	fdb_makename_str(filename, sizeof filename, "users", username);

	config_setup(&cfg);

	u=user_defaults(); /* allocate a default struct */
	if(!u) {
		DEBUG_MSG("Could not allocate user structure\n");
		fclose(f);
		return 0; /* failure */
	}

	config_watch(&cfg, "id", user_ll_load_uint, &u->id);
	config_watch(&cfg, "username", user_ll_load_str, &u->username);
	config_watch(&cfg, "pwcrypt", user_ll_load_str, &u->password_crypt);
	config_watch(&cfg, "email", user_ll_load_str, &u->email);
	config_watch(&cfg, "acs.level", user_ll_load_uint, &u->acs.level);
	config_watch(&cfg, "acs.flags", user_ll_load_uint, &u->acs.flags);

	if(!config_load(filename, &cfg)) {
		config_free(&cfg);
		return 0; /* failure */
	}

	config_free(&cfg);

	if(!freelist_thwack(&user_id_freelist, u->id, 1)) {
		ERROR_FMT("Could not use user id %d (bad id or id already used?)\n", u->id);
		goto failure;
	}

	return u; /* success */

failure:
	user_ll_free(u);
	return 0; /* failure */
}

static int user_write(const struct user *u) {
	FILE *f;
	char filename[PATH_MAX];

	fdb_makename_str(filename, sizeof filename, "users", u->username);
	f=fopen(filename, "w");
	if(!f) {
		PERROR(filename);
		return 0; /* failure */
	}

	if(fprintf(f,
		"id          = %u\n"
		"username    = %s\n"
		"pwcrypt     = %s\n"
		"email       = %s\n"
		"acs.level   = %u\n"
		"acs.flags   = 0x%08x\n",
		u->id, u->username, u->password_crypt, u->email, u->acs.level, u->acs.flags
	)<0) {
		PERROR(filename);
		fclose(f);
		return 0; /* failure */
	}

	fclose(f);
	return 1; /* success */
}

static void user_name_map_entry_free(void *key UNUSED, union map_data *data) {
	struct user_name_map_entry *ne=data->ptr;
	free(ne->username);
	ne->username=NULL;
	ne->id=0;
	free(ne);
}

/**
 * add a new account to username to id lookup table
 */
static int user_name_map_add(unsigned id, const char *username) {
	struct user_name_map_entry *ne;
	ne=malloc(sizeof *ne);
	ne->id=id;
	ne->username=strdup(username);
	if(!map_add_ptr(&user_name_map, ne->username, ne)) {
		ERROR_FMT("Could not add username(%s) to map\n", username);
		free(ne->username);
		free(ne);
		return 0; /* failure */
	}
	return 1; /* success */
}

/** user:external functions **/
EXPORT int user_exists(const char *username) {
	union map_data *tmp;
	struct user_name_map_entry *ne;
	tmp=map_lookup(&user_name_map, username);
	if(tmp && tmp->ptr) {
		ne=tmp->ptr;
		return ne->id;
	}
	return 0; /* user not found */
}

/* loads a user into the cache */
EXPORT struct user *user_lookup(const char *username) {
	union map_data *tmp;
	struct user *u;

	/* check cache of loaded users */
	tmp=map_lookup(&user_cache_name_map, username);
	if(tmp && tmp->ptr) return tmp->ptr;

	/* load from disk */
	return user_load_byname(username);
}

EXPORT struct user *user_create(const char *username, const char *password, const char *email) {
	struct user *u;
	long id;
	char password_crypt[XXTCRYPT_MAX+1];

	if(!username) {
		ERROR_MSG("Username was NULL");
		return NULL; /* failure */
	}

	/* encrypt password */
	if(!xxtcrypt_makepass(password_crypt, sizeof password_crypt, password)) {
		ERROR_MSG("Could not hash password");
		return NULL; /* failure */
	}

	u=user_defaults(); /* allocate a default struct */
	if(!u) {
		DEBUG_MSG("Could not allocate user structure\n");
		return NULL; /* failure */
	}

	id=freelist_alloc(&user_id_freelist, 1);
	if(id<0) {
		ERROR_FMT("Could not allocate user id for username(%s)\n", username);
		user_free(u);
		return NULL; /* failure */
	}

	assert(id>=0);

	if(!user_name_map_add((unsigned)id, username)) {
		freelist_pool(&user_id_freelist, (unsigned)id, 1);
		user_free(u);
		return NULL; /* failure */
	}

	u->id=id;
	u->username=strdup(username);
	u->password_crypt=strdup(password_crypt);
	u->email=strdup(email);

	if(!user_write(u)) {
		ERROR_FMT("Could not save account username(%s)\n", u->username);
		user_free(u);
		return NULL; /* failure */
	}

	return u; /* success */
}

EXPORT int user_init(void) {
	char pathname[PATH_MAX];
	DIR *d;
	struct dirent *de;

	map_init(&user_name_map, 6, user_name_map_entry_free, map_hash_stringignorecase, map_compare_stringignorecase);

	/* the caches don't free because they share the same elements */
	map_init(&user_cache_name_map, 6, NULL, map_hash_stringignorecase, map_compare_stringignorecase);
	map_init(&user_cache_id_map, 6, NULL, map_hash_uintptr, map_compare_uintptr);

	freelist_init(&user_id_freelist, 0);
	freelist_pool(&user_id_freelist, 1, 32768);

	fdb_getbasename(pathname, sizeof pathname, "users");
	if(mkdir(pathname, 0777)==-1 && errno!=EEXIST) {
		PERROR(pathname);
		return 0;
	}

	/* scan for account files */
	d=opendir(pathname);
	if(!d) {
		PERROR(pathname);
		return 0; /* failure */
	}

	while((de=readdir(d))) {
		struct user *u;

		if(de->d_name[0]=='.') continue; /* ignore hidden files */

		TODO("skip directories and other things that don't look like user files.");

		DEBUG("Found user record '%s'\n", de->d_name);
		/* Load user file */
		u=user_load_byname(de->d_name);
		if(!u) {
			ERROR_FMT("Could not load user from file '%s'\n", de->d_name);
			closedir(d);
			return 0; /* failure */
		}
		user_name_map_add(u->id, u->username);
		user_free(u); /* we only wanted to load the data */
	}

	closedir(d);

	return 1; /* success */
}

EXPORT void user_shutdown(void) {
	map_free(&user_name_map);
	freelist_free(&user_id_freelist);
}

/* decrement a reference count */
EXPORT void user_put(struct user **user) {
	if(user && *user) {
		REFCOUNT_PUT(*user, user_free(*user); *user=NULL);
	}
}

/* increment the reference count */
EXPORT void user_get(struct user *user) {
	if(user) {
		REFCOUNT_GET(user);
		user_cache_add(user);

		DEBUG("user refcount=%d\n", user->REFCOUNT_NAME);
	}
}

/******************************************************************************
 * Socket Buffers
 ******************************************************************************/

struct buffer {
	char *data;
	size_t used, max;
};

EXPORT void buffer_init(struct buffer *b, size_t max) {
	assert(b != NULL);
	b->data=malloc(max+1); /* allocate an extra byte past max for null */
	b->used=0;
	b->max=max;
}

/* free the buffer */
EXPORT void buffer_free(struct buffer *b) {
	free(b->data);
	b->data=NULL;
	b->used=0;
	b->max=0;
}

/* expand newlines into CR/LF startin at used
 * return length of processed string or -1 on overflow */
static int buffer_ll_expandnl(struct buffer *b, size_t len) {
	size_t rem;
	char *p, *e;

	assert(b != NULL);

	for(p=b->data+b->used,rem=len;(e=memchr(p, '\n', rem));rem-=e-p,p=e+2) {
		/* check b->max for overflow */
		if(p-b->data>=(ptrdiff_t)b->max) {
			DEBUG("%s():Overflow detected\n", __func__);
			return -1;
		}
		memmove(e+1, e, rem);
		*e='\r';
		len++; /* grew by 1 byte */
	}

	assert(b->used+len <= b->max);
	return len;
}

/* special write that does not expand its input.
 * unlike the other calls, truncation will not load partial data into a buffer */
EXPORT int buffer_write_noexpand(struct buffer *b, const void *data, size_t len) {
	if(b->used+len>b->max) {
		DEBUG("%s():Overflow detected. refusing to send any data.\n", __func__);
		return -1;
	}

	memcpy(&b->data[b->used], data, len);
	b->used+=len;

	assert(b->used <= b->max);
	return len;
}

/* writes data and exapands newline to CR/LF */
EXPORT int buffer_write(struct buffer *b, const char *str, size_t len) {
	size_t i, j;
	int ret;
	assert(b != NULL);
	if(b->used>=b->max) {
		DEBUG("Buffer %p is full\n", (void*)b);
		return -1; /* buffer is full */
	}

	/* copy the data into the buffer, while expanding newlines */
	for(i=0,j=b->used;i<len && j<b->max;i++) {
		if(str[i]=='\n') {
			b->data[j++]='\r';
		}
		b->data[j++]=str[i];
	}
	ret=j-b->used;
	b->used=j;
	assert(ret>=0);
	assert(b->used <= b->max);

	if(i<len) {
		DEBUG("Truncation detected in buffer %p\n", (void*)b);
		return -1;
	}
	TRACE("Wrote %d bytes to buffer %p using %s()\n", j, (void*)b, __func__);
	return j;
}

/* puts data in a client's output buffer */
static int buffer_puts(struct buffer *b, const char *str) {
	return buffer_write(b, str, strlen(str));
}

/* printfs and expands newline to CR/LF */
EXPORT int buffer_vprintf(struct buffer *b, const char *fmt, va_list ap) {
	int res;
	assert(b != NULL);
	if(!b)
		return -1; /* failure */
	if(b->used>=b->max) {
		DEBUG("Buffer %p is full\n", (void*)b);
		return -1; /* buffer is full */
	}
	/* we allocated an extra byte past max for null terminators */
	res=vsnprintf(&b->data[b->used], b->max-b->used+1, fmt, ap);
	if(res<0) { /* some libcs return -1 on truncation */
		res=b->max-b->used+2; /* trigger the truncation code below */
	}
	/* snprintf does not include the null terminator in its count */
	if((unsigned)res>b->max-b->used) {
		/* truncation occured */
		TODO("grow the buffer and try again?");
		DEBUG("Truncation detected in buffer %p\n", (void*)b);
		res=b->max-b->used;
	}
	res=buffer_ll_expandnl(b, (unsigned)res);
	if(res==-1) {
		TODO("test this code");
		ERROR_FMT("%s():Overflow in buffer %p\n", __func__, (void*)b);
		return -1;
	}
	b->used+=res;
	TRACE("Wrote %d bytes to buffer %p using %s()\n", res, (void*)b, __func__);
	return res;
}

/* printfs data in a client's output buffer */
static int buffer_printf(struct buffer *b, const char *fmt, ...) {
	va_list ap;
	int res;
	va_start(ap, fmt);
	res=buffer_vprintf(b, fmt, ap);
	va_end(ap);
	return res;
}

EXPORT const char *buffer_data(struct buffer *b, size_t *len) {
	assert(b != NULL);
	assert(len != NULL);
	if(!b) {
		*len=0;
		return NULL;
	}

	*len=b->used;
	return b->data;
}

/* used for adding more data to the buffer
 * returns a pointer to the start of the buffer
 * len is the amount remaining in the buffer */
EXPORT char *buffer_load(struct buffer *b, size_t *len) {
	assert(b != NULL);
	assert(len != NULL);
	if(!b) {
		*len=0;
		return NULL;
	}

	*len=b->max-b->used; /* remaining */
	return b->data+b->used;
}

/* returns the remaining data in the buffer */
EXPORT unsigned buffer_consume(struct buffer *b, size_t len) {
	assert(b != NULL);
	DEBUG("len=%zu used=%zu rem=%zu\n", len, b->used, b->max-b->used);
	assert(len <= b->used);
	if(len>b->used) {
		ERROR_FMT("WARNING:attempted ovewflow of output buffer %p\n", (void*)b);
		len=b->used;
	}
	b->used-=len;
	assert((signed)b->used >= 0);
	memmove(b->data, b->data+len, b->used);
	return b->used;
}

/* commits data to buffer
 */
EXPORT void buffer_emit(struct buffer *b, size_t len) {
	assert(b != NULL);
	assert(b->used <= b->max);
	assert(b->used + len <= b->max);
	b->used+=len;
	if(b->used>b->max) {
		ERROR_FMT("WARNING:attempted ovewflow of input buffer %p\n", (void*)b);
		b->used=b->max;
	}
}

/*
 * callback returns the number of items consumed
 * if a line is incomplete (which it will be if an IAC is incomplete, then return NULL
 */
static char *buffer_findnl(char *d, size_t *len, size_t (*iac_process)(const char *data, size_t len, void *p), void *p) {
	size_t res, tmplen;

	assert(d != NULL);
	assert(len != NULL);

	/* just look for newlines if we aren't processing IACs */
	if(!iac_process) {
		return memchr(d, '\n', *len);
	}

	/* look for IACs and newlines */

	assert((int)*len>=0);
	for(tmplen=*len;tmplen;) {
		TRACE("%s():%d: len=%d tmplen=%d\n", __func__, __LINE__, *len, tmplen);
		assert((int)tmplen>0);
		if(*d==IAC) {
			assert(iac_process != NULL);
			res=iac_process(d, *len, p);
			if(!res) {
				/* incomplete IAC sequence, wait for more data */
				DEBUG_MSG("Incomplete IAC sequence, wait for more data\n");
				return NULL;
			}
			DEBUG("Telnet control data processed (%zd bytes)\n", res);
			TRACE("%s():%d: res=%d len=%d tmplen=%d\n", __func__, __LINE__, res, *len, tmplen);
			assert((int)res<=(int)*len);
			assert((int)tmplen>0);
			assert((int)res<=(int)tmplen);
			tmplen-=res;
			*len-=res; /* the overall length was just reduced */
			assert((int)tmplen>=0);
			memmove(d, d+res, tmplen);
			continue;
		}
		if(*d=='\n') {
			return d;
		}
		tmplen--;
		d++;
		assert((int)tmplen>=0);
	}

	return NULL; /* not found */
}

EXPORT const char *buffer_getline(struct buffer *b, size_t *consumed_len, size_t (*iac_process)(const char *data, size_t len, void *p), void *p) {
	char *d;
	assert(b != NULL);
	assert(consumed_len != NULL);
	d=buffer_findnl(b->data, &b->used, iac_process, p);
	if(!d) {
		/* no newline found */
		return NULL;
	}
	if(d>b->data && d[-1]=='\r') {
		d[-1]=0; /* rub out CR */
	}
	*d=0; /* rub out LF */
	*consumed_len=d-b->data+1;
	return b->data;
}

/******************************************************************************
 * Socket I/O API
 ******************************************************************************/
#if !defined(SOCKET) || !defined(INVALID_SOCKET) || !defined(SOCKET_ERROR)
#define SOCKET int
#define INVALID_SOCKET (-1)
#define SOCKET_ERROR (-1)
#endif

#define SOCKETIO_FAILON(e, reason, fail_label) do { if(e) { fprintf(stderr, "ERROR:%s:%s\n", reason, socketio_strerror()); goto fail_label; } } while(0)

struct socketio_handle {
	unsigned type; /* 0 = server, 1 = telnetclient */
	LIST_ENTRY(struct socketio_handle) list;
	SOCKET fd;
	char *name;
	unsigned delete_flag:1; /* if set, then this entry should be deleted */
	void (*write_event)(struct socketio_handle *sh, SOCKET fd, void *p);
	void (*read_event)(struct socketio_handle *sh, SOCKET fd, void *p);
	void *extra;
	void (*extra_free)(struct socketio_handle *sh, void *extra);
};

static LIST_HEAD(struct socketio_handle_list, struct socketio_handle) socketio_handle_list;
static fd_set *socketio_readfds, *socketio_writefds;
static unsigned socketio_fdset_sz; /* number of bits allocated */
#if defined(USE_WIN32_SOCKETS)
#define socketio_fdmax 0 /* not used on Win32 */
static unsigned socketio_socket_count; /* WIN32: the limit of fd_set is the count not the fd number */
#else
static SOCKET socketio_fdmax=INVALID_SOCKET; /* used by select() to limit the number of fds to check */
#endif
static unsigned socketio_delete_count=0; /* counts the number of pending deletions */

#if defined(USE_WIN32_SOCKETS) && !defined(gai_strerror)
static const char *gai_strerror(int err) {
	switch(err) {
		case EAI_AGAIN: return "Temporary failure in name resolution";
		case EAI_BADFLAGS: return "Bad value for ai_flags";
		case EAI_FAIL: return "Non-recoverable failure in name resolution";
		case EAI_FAMILY: return "ai_family not supported";
		case EAI_MEMORY: return "Memory allocation failure";
		case EAI_NONAME: return "Name or service not known";
		case EAI_SERVICE: return "Servname not supported for ai_socktype";
		case EAI_SOCKTYPE: return "ai_socktype not supported";
	}
	return "Unknown resolution error";
}
#endif

EXPORT const char *socketio_strerror(void) {
#if defined(USE_WIN32_SOCKETS)
	static char buf[64];
	int res;
	res=WSAGetLastError();
	if(res==0)
		return "winsock successful";
	snprintf(buf, sizeof buf, "winsock error %d", res);
	return buf;
#else
	return strerror(errno);
#endif
}

/* return true is the last recv()/send() call would have blocked */
EXPORT int socketio_wouldblock(void) {
#if defined(USE_WIN32_SOCKETS)
	return WSAGetLastError()==WSAEWOULDBLOCK;
#else
	return errno==EWOULDBLOCK;
#endif
}

#ifndef NTRACE
static void socketio_dump_fdset(fd_set *readfds, fd_set *writefds) {
#if defined(USE_WIN32_SOCKETS)
	unsigned i;
	fprintf(stderr, "socketio_socket_count=%d\n", socketio_socket_count);
	for(i=0;i<readfds->fd_count && i<writefds->fd_count;i++) {
		if(i<readfds->fd_count) {
			fprintf(stderr, "%s():READ:fd=%u  ", __func__, readfds->fd_array[i]);
		}
		if(i<writefds->fd_count) {
			fprintf(stderr, "%s():WRITE:fd=%u", __func__, writefds->fd_array[i]);
		}
		fprintf(stderr, "\n");
	}
#else
	SOCKET i;
	fprintf(stderr, "socketio_fdmax=%d\n", socketio_fdmax);
	for(i=0;i<=socketio_fdmax;i++) {
		unsigned r=FD_ISSET(i, readfds), w=FD_ISSET(i, writefds);
		if(r||w) {
			fprintf(stderr, "%s():fd=%d (%c%c)\n", __func__, i, r?'r':'-', w?'w':'-');
		}
	}
#endif
}
#endif

EXPORT int socketio_init(void) {
#if defined(USE_WIN32_SOCKETS)
	WSADATA wsaData;
	int err;

	err=WSAStartup(MAKEWORD(2,2), &wsaData);
	if(err!=0) {
		fprintf(stderr, "WSAStartup() failed (err=%d)\n", err);
		return 0;
	}
	DEBUG("Winsock: VERSION %u.%u\n",
		LOBYTE(wsaData.wVersion),
		HIBYTE(wsaData.wVersion)
	);
#endif

	socketio_fdset_sz=FD_SETSIZE;

#if defined(USE_WIN32_SOCKETS)
	/* win32 winsock api */
	socketio_readfds=calloc(1, sizeof *socketio_readfds);
	socketio_writefds=calloc(1, sizeof *socketio_writefds);
#elif defined(NFDBITS)
	/* X/Open compatible APIs */
	socketio_readfds=calloc(1, socketio_fdset_sz/NFDBITS);
	socketio_writefds=calloc(1, socketio_fdset_sz/NFDBITS);
#else
	/* for non-BSD socket APIs */
#warning Using generic socket code. define _BSD_SOURCE for Unix socket code
	socketio_readfds=calloc(1, sizeof *socketio_readfds);
	socketio_writefds=calloc(1, sizeof *socketio_writefds);
#endif
	return 1;
}

EXPORT void socketio_shutdown(void) {
#if defined(USE_WIN32_SOCKETS)
	WSACleanup();
#endif
}

EXPORT int socketio_close(SOCKET *fd) {
	int res;
	assert(fd!=0);
	assert(*fd!=INVALID_SOCKET);
#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count--; /* track number of open sockets for filling fd_set */
	res=closesocket(*fd);
#else
	res=close(*fd);
#endif
	if(res==-1) {
		ERROR_FMT("close(fd=%d):%s\n", *fd, socketio_strerror());
	}

	/* do not retain entries for closed fds */
	FD_CLR(*fd, socketio_readfds);
	FD_CLR(*fd, socketio_writefds);

	*fd=INVALID_SOCKET;
	return res;
}

/* You should call this whenever opening a new socket
 * checks the maximum count and updates socketio_fdmax */
EXPORT int socketio_check_count(SOCKET fd) {
	assert(fd!=INVALID_SOCKET);
#if defined(USE_WIN32_SOCKETS)
	if(socketio_socket_count>=socketio_fdset_sz) {
		DEBUG("too many open sockets (%d) for fd_set (fd_setsize=%d)\n", socketio_socket_count, socketio_fdset_sz);
		return 0; /* failure */
	}
#else
	if((unsigned)fd>=socketio_fdset_sz) {
		DEBUG("too many open sockets (%d) for fd_set (fd_setsize=%d)\n", fd, socketio_fdset_sz);
		return 0; /* failure */
	}
	if(fd>socketio_fdmax) {
		DEBUG("Updating fdmax from %d to %d\n", socketio_fdmax, fd);
		socketio_fdmax=fd;
	}
#endif
	return 1; /* success */
}

/* report that an fd is ready for read events, and update the fdmax value */
EXPORT void socketio_readready(SOCKET fd) {
	assert(fd!=INVALID_SOCKET);
	FD_SET(fd, socketio_readfds);
}

/* report that an fd is ready for write events, and update the fdmax value */
EXPORT void socketio_writeready(SOCKET fd) {
	assert(fd!=INVALID_SOCKET);
	FD_SET(fd, socketio_writefds);
}

EXPORT int socketio_sockname(struct sockaddr *sa, socklen_t salen, char *name, size_t name_len) {
	char servbuf[16];
	int res;
	size_t tmplen;

	/* leave room in name for ":servbuf" and at least 16 characters */
	if(name_len>=(16+sizeof servbuf)) {
		name_len-=sizeof servbuf;
	}
	res=getnameinfo(sa, salen, name, name_len, servbuf, sizeof servbuf, NI_NUMERICHOST|NI_NUMERICSERV);
	SOCKETIO_FAILON(res!=0, "getnameinfo()", failure);

	tmplen=strlen(name);
	if(name_len>tmplen) {
		snprintf(name+tmplen, name_len-tmplen, "/%s", servbuf);
	}

	return 1; /* success */

failure:
	return 0;
}

EXPORT int socketio_getpeername(SOCKET fd, char *name, size_t name_len) {
	struct sockaddr_storage ss;
	socklen_t sslen;
	int res;

	assert(fd!=INVALID_SOCKET);
	assert(name!=NULL);

	sslen=sizeof ss;
	res=getpeername(fd, (struct sockaddr*)&ss, &sslen);
	if(res!=0) {
		ERROR_FMT("%s():%s\n", __func__, socketio_strerror());
		return 0;
	}
	if(!socketio_sockname((struct sockaddr*)&ss, sslen, name, name_len)) {
		ERROR_FMT("Failed %s() on fd %d\n", __func__, fd);
		return 0;
	}
	DEBUG("getpeername is %s\n", name);
	return 1;
}

static int socketio_nonblock(SOCKET fd) {
	int res;
#if defined(USE_WIN32_SOCKETS)
	u_long iMode=1;
	res=ioctlsocket(fd, (int)FIONBIO, &iMode);
#else
	res=fcntl(fd, F_SETFL, O_NONBLOCK);
#endif
	SOCKETIO_FAILON(res!=0, "setting non-blocking for accept() socket", failure);
	return 1;
failure:
	return 0;
}

static void socketio_ll_handle_free(struct socketio_handle *sh) {
	assert(sh!=NULL);
	if(!sh)
		return;
	DEBUG("freeing socket handle '%s'\n", sh->name);

	if(sh->extra) {
		if(sh->extra_free) {
			sh->extra_free(sh, sh->extra);
		} else {
			DEBUG_MSG("WARNING:extra data for socket handle is being leaked");
		}
	}

	if(sh->fd!=INVALID_SOCKET) {
		socketio_close(&sh->fd);
	}

	LIST_REMOVE(sh, list);

	free(sh->name);

#ifndef NDEBUG
	memset(sh, 0xBB, sizeof *sh); /* fill with fake data before freeing */
#endif
	free(sh);
}

EXPORT int socketio_send(SOCKET fd, const void *data, size_t len) {
	int res;
	res=send(fd, data, len, 0);
	SOCKETIO_FAILON(res==-1, "send() to socket", failure);
	return res;
failure:
	return -1;
}

EXPORT int socketio_recv(SOCKET fd, void *data, size_t len) {
	int res;
	res=recv(fd, data, len, 0);
	SOCKETIO_FAILON(res==-1, "recv() from socket", failure);
	return res;
failure:
	return -1;
}

static void socketio_toomany(SOCKET fd) {
	const char buf[]="Too many connections\r\n";

	eventlog_toomany(); /* report that we are refusing connections */

	if(socketio_nonblock(fd)) {
		send(fd, buf, (sizeof buf)-1, 0);
		socketio_send(fd, buf, (sizeof buf)-1);
	}
	socketio_close(&fd);
}

static void socketio_fdset_copy(fd_set *dst, const fd_set *src) {
	assert(dst!=NULL);
	assert(src!=NULL);
#if defined(USE_WIN32_SOCKETS)
	/* copy routine for Win32 */
	dst->fd_count=src->fd_count;
	memcpy(dst->fd_array, src->fd_array, src->fd_count * sizeof *src->fd_array);
#elif defined(NFDBITS)
	/* X/Open compatible APIs - copy just the used part of the structure */
	size_t fd_bytes;
	assert(socketio_fdmax!=INVALID_SOCKET);
	if(socketio_fdmax!=INVALID_SOCKET) {
		fd_bytes=ROUNDUP(socketio_fdmax+1, NFDBITS)/8; /* copy only the necessary bits */
	} else {
		fd_bytes=ROUNDUP(socketio_fdset_sz, NFDBITS)/8; /* fdmax looked weird, copy the whole thing */
	}
	memcpy(dst, src, fd_bytes);
#else
	/* generic copy for non-BSD socket APIs */
	*dst=*src;
#endif

}

static struct socketio_handle *socketio_ll_newhandle(SOCKET fd, const char *name, unsigned type, void (*write_event)(struct socketio_handle *sh, SOCKET fd, void *p), void (*read_event)(struct socketio_handle *sh, SOCKET fd, void *p)) {
	struct socketio_handle *ret;

	assert(fd != INVALID_SOCKET);

	if(!socketio_check_count(fd)) {
		ERROR_MSG("too many open sockets. closing new connection!");
		socketio_toomany(fd); /* send a message to the socket */
		return NULL; /* failure */
	}

	ret=calloc(1, sizeof *ret);
	FAILON(!ret, "malloc()", failure);
	ret->type=type;
	ret->name=strdup(name);
	ret->fd=fd;
	ret->delete_flag=0;
	ret->read_event=read_event;
	ret->write_event=write_event;
	LIST_INSERT_HEAD(&socketio_handle_list, ret, list);
	socketio_readready(fd); /* default to being ready for reads */
	return ret;
failure:
	return NULL;
}

EXPORT int socketio_dispatch(long msec) {
	struct socketio_handle *curr, *next;
	struct timeval timeout, *to;
	int nr;	/* number of sockets to process */
	fd_set out_readfds, out_writefds;

	if(msec<0) {
		/* wait forever */
		to=NULL;
	} else {
		timeout.tv_usec=(msec%1000)*1000;
		timeout.tv_sec=msec/1000;
		assert(timeout.tv_usec < 1000000);
		to=&timeout;
	}

	if(!LIST_TOP(socketio_handle_list)) {
		ERROR_MSG("No more sockets to watch");
		return 0;
	}

	/* loop through all sockets to check for deletion */
	for(curr=LIST_TOP(socketio_handle_list);socketio_delete_count && curr;curr=next) {
		next=LIST_NEXT(curr, list);
		if(curr->delete_flag) {
			/* this entry must be deleted */
			DEBUG("Deleting %s\n", curr->name);

			socketio_close(&curr->fd);
			socketio_ll_handle_free(curr);

			socketio_delete_count--;
		}
	}

	/* clean up if there was a mistake in the count */
	if(socketio_delete_count!=0) {
		ERROR_MSG("WARNING:socketio_delete_count is higher than number of marked sockets");
		socketio_delete_count=0;
	}

	socketio_fdset_copy(&out_readfds, socketio_readfds);
	socketio_fdset_copy(&out_writefds, socketio_writefds);

#ifndef NTRACE
	socketio_dump_fdset(&out_readfds, &out_writefds);
#endif

	if(socketio_fdmax==INVALID_SOCKET) {
		DEBUG_MSG("WARNING:currently not waiting on any sockets");
	}
	nr=select(socketio_fdmax+1, &out_readfds, &out_writefds, 0, to);
	if(nr==SOCKET_ERROR) {
		SOCKETIO_FAILON(errno!=EINTR, "select()", failure);
		return 1; /* EINTR occured */
	}

	DEBUG("select() returned %d results\n", nr);

	TODO("if fds_bits is available then base the loop on the fd_set and look up entries on the client list.");

	/* check all sockets */
	for(curr=LIST_TOP(socketio_handle_list);nr>0 && curr;curr=next) {
		SOCKET fd=curr->fd;

		TRACE("Checking socket %s\n", curr->name);

		assert(fd!=INVALID_SOCKET); /* verify consistency of datastructure */

		if(FD_ISSET(fd, &out_writefds)) {
			/* always disable an activated entry */
			assert(fd!=INVALID_SOCKET);
			assert((unsigned)fd < socketio_fdset_sz);
			FD_CLR(fd, socketio_writefds);
			DEBUG("Write-ready %s\n", curr->name);
			/* perform the write handler */
			if(curr->write_event) {
				curr->write_event(curr, fd, curr->extra);
			}
			nr--;
		}

		if(FD_ISSET(fd, &out_readfds)) {
			/* always disable an activated entry */
			assert(fd!=INVALID_SOCKET);
			assert((unsigned)fd < socketio_fdset_sz);
			FD_CLR(fd, socketio_readfds);
			DEBUG("Read-ready %s\n", curr->name);
			/* perform the read handler */
			if(curr->read_event) {
				curr->read_event(curr, fd, curr->extra);
			}
			nr--;
		}
		next=LIST_NEXT(curr, list);
	}
	if(nr>0) {
		ERROR_FMT("there were %d unhandled socket events\n", nr);
		goto failure;
	}
	assert(nr==0);

	return 1;
failure:
	return 0; /* failure */
}

/******************************************************************************
 * Server
 ******************************************************************************/
struct server {
	void (*newclient)(struct socketio_handle *new_sh);
};

EXPORT void server_read_event(struct socketio_handle *sh, SOCKET fd, void *p) {
	struct sockaddr_storage ss;
	socklen_t sslen;
	struct server *serv=p;
	struct socketio_handle *newclient;
	char buf[64];
	assert(sh!=NULL);
	assert(sh->fd!=INVALID_SOCKET);
	sslen=sizeof ss;
	fd=accept(sh->fd, (struct sockaddr*)&ss, &sslen);
	SOCKETIO_FAILON(fd==INVALID_SOCKET, "accept()", failure);

#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count++; /* track number of open sockets for filling fd_set */
#endif

	if(!socketio_sockname((struct sockaddr*)&ss, sslen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}

	eventlog_connect(buf);

	newclient=socketio_ll_newhandle(fd, buf, 1, NULL, NULL);
	if(!newclient) {
		ERROR_FMT("could not allocate client, closing connection '%s'\n", buf);
		socketio_close(&fd);
		return; /* failure */
	}
	serv->newclient(newclient);
	assert(newclient->write_event!=NULL || newclient->read_event!=NULL);

	DEBUG("Accepted connection %s\n", newclient->name);
	socketio_readready(sh->fd); /* be ready for next accept() */
	return;
failure:
	return;
}

static void server_free(struct socketio_handle *sh, void *p) {
	struct server *servdata=p;

	if(!sh->delete_flag) {
		ERROR_MSG("WARNING: delete_flag was not set before freeing");
	}

	/* break connection to the extra data pointer */
	sh->extra=NULL;

#ifndef NDEBUG
	memset(servdata, 0xBB, sizeof *servdata); /* fill with fake data before freeing */
#endif

	free(servdata);
}

static int socketio_listen_bind(struct addrinfo *ai, void (*newclient)(struct socketio_handle *new_sh)) {
	SOCKET fd;
	int res;
	char buf[64];
	struct socketio_handle *newserv;
	struct server *servdata;
	struct linger li;

	const int yes=1;
	assert(ai!=NULL);
	if(!ai || !ai->ai_addr) {
		ERROR_MSG("empty socket address");
		return 0;
	}
	fd=socket(ai->ai_family, ai->ai_socktype, 0);
	SOCKETIO_FAILON(fd==INVALID_SOCKET, "creating socket", failure_clean);

#if defined(USE_WIN32_SOCKETS)
	socketio_socket_count++; /* track number of open sockets for filling fd_set */
#endif
	if(!socketio_check_count(fd)) {
		ERROR_MSG("too many open sockets. refusing new server!");
		goto failure;
	}

	if(ai->ai_family==AF_INET || ai->ai_family==AF_INET6) {
		SOCKETIO_FAILON(setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (const void*)&yes, sizeof yes)!=0, "setting SO_REUSEADDR", failure);
		li.l_onoff=0; /* disable linger, except for exit() */
		li.l_linger=10; /* 10 seconds */
		SOCKETIO_FAILON(setsockopt(fd, SOL_SOCKET, SO_LINGER, (const void*)&li, sizeof li)!=0, "setting SO_LINGER", failure);
	}

	SOCKETIO_FAILON(bind(fd, ai->ai_addr, (socklen_t)ai->ai_addrlen)!=0, "binding to port", failure);

	if(!socketio_nonblock(fd)) {
		goto failure;
	}

	res=listen(fd, SOCKETIO_LISTEN_QUEUE);
	SOCKETIO_FAILON(res!=0, "forming listening socket", failure);

	if(!socketio_sockname(ai->ai_addr, (socklen_t)ai->ai_addrlen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}

	/* add server to a list */
	newserv=socketio_ll_newhandle(fd, buf, 0, NULL, server_read_event);
	if(!newserv) {
		ERROR_FMT("could not allocate server, closing socket '%s'\n", buf);
		socketio_close(&fd);
		return 0; /* failure */
	}

	servdata=calloc(1, sizeof *servdata);
	servdata->newclient=newclient;

	newserv->extra=servdata;
	newserv->extra_free=server_free;

	DEBUG("Bind success: %s %s\n", ai->ai_family==AF_INET ? "IPv4" : ai->ai_family==AF_INET6 ? "IPv6" : "Unknown", buf);

	return 1; /* success */

failure:
	socketio_close(&fd);
failure_clean:
	return 0;
}

/*
 * family : 0 or AF_INET or AF_INET6
 * socktype: SOCK_STREAM or SOCK_DGRAM
 */
EXPORT int socketio_listen(int family, int socktype, const char *host, const char *port, void (*newclient)(struct socketio_handle *sh)) {
	int res;
	struct addrinfo *ai_res, *curr;
	struct addrinfo ai_hints;

	assert(port!=NULL);
	assert(family==0 || family==AF_INET || family==AF_INET6);
	assert(socktype==SOCK_STREAM || socktype==SOCK_DGRAM);

	memset(&ai_hints, 0, sizeof ai_hints);
	ai_hints.ai_flags=AI_PASSIVE;
	ai_hints.ai_family=family;
	ai_hints.ai_socktype=socktype;

	res=getaddrinfo(host, port, &ai_hints, &ai_res);

	if(res!=0) {
		ERROR_FMT("hostname parsing error:%s\n", gai_strerror(res));
		return 0;
	}

	/* looks for the first AF_INET or AF_INET6 entry */
	for(curr=ai_res;curr;curr=curr->ai_next) {
		TRACE("getaddrinfo():family=%d type=%d\n", curr->ai_family, curr->ai_socktype);
		if(curr->ai_family==AF_INET6 || curr->ai_family==AF_INET) {
			break;
		}
	}

	if(!curr) {
		freeaddrinfo(ai_res);
		ERROR_FMT("Could not find interface for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	assert(socktype==SOCK_STREAM || socktype==SOCK_DGRAM);

	if(!socketio_listen_bind(curr, newclient)) {
		freeaddrinfo(ai_res);
		ERROR_FMT("Could bind socket for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	freeaddrinfo(ai_res);
	return 1; /* success */
}

/******************************************************************************
 * Client - handles client connections
 ******************************************************************************/
struct telnetclient {
	struct socketio_handle *sh;
	struct buffer output, input;
	struct terminal {
		int width, height;
		char name[32];
	} terminal;
	int prompt_flag; /* true if prompt has been sent */
	const char *prompt_string;
	void (*line_input)(struct telnetclient *cl, const char *line);
	void (*state_free)(struct telnetclient *cl);
	union state_data {
		struct login_state {
			char username[16];
		} login;
		struct form_state form;
		struct menu_state {
			const struct menuinfo *menu; /* current menu */
		} menu;
	} state;
	struct user *user;
	struct channel_member_head member_list; /* membership for channels */
};

/* return the username */
EXPORT const char *telnetclient_username(struct telnetclient *cl) {
	return cl && cl->user && cl->user->username ? cl->user->username : "<UNKNOWN>";
}

EXPORT int telnetclient_puts(struct telnetclient *cl, const char *str) {
	int res;
	assert(cl != NULL);
	assert(cl->sh != NULL);
	res=buffer_puts(&cl->output, str);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag=0;
	return res;
}

EXPORT int telnetclient_vprintf(struct telnetclient *cl, const char *fmt, va_list ap) {
	int res;

	assert(cl != NULL);
	assert(cl->sh != NULL);
	assert(fmt != NULL);

	res=buffer_vprintf(&cl->output, fmt, ap);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag=0;
	return res;
}

EXPORT int telnetclient_printf(struct telnetclient *cl, const char *fmt, ...) {
	va_list ap;
	int res;

	assert(cl != NULL);
	assert(cl->sh != NULL);
	assert(fmt != NULL);

	va_start(ap, fmt);
	res=buffer_vprintf(&cl->output, fmt, ap);
	va_end(ap);
	socketio_writeready(cl->sh->fd);
	cl->prompt_flag=0;
	return res;
}

static void telnetclient_clear_statedata(struct telnetclient *cl) {
	if(cl->state_free) {
		cl->state_free(cl);
		cl->state_free=NULL;
	}
	memset(&cl->state, 0, sizeof cl->state);
}

static void telnetclient_free(struct socketio_handle *sh, void *p) {
	struct telnetclient *client=p;
	assert(client!=NULL);
	if(!client)
		return;

	TODO("Determine if connection was logged in first");
	eventlog_signoff(telnetclient_username(client), sh->name); /* TODO: fix the username field */

	DEBUG("freeing client '%s'\n", sh->name);

	if(sh->fd!=INVALID_SOCKET) {
		TODO("I forget the purpose of this code");
		/* only call this if the client wasn't closed earlier */
		socketio_readready(sh->fd);
	}

	if(!sh->delete_flag) {
		ERROR_MSG("WARNING: delete_flag was not set before freeing");
	}

	telnetclient_clear_statedata(client); /* free data associated with current state */

	/* break connection to the extra data pointer */
	sh->extra=NULL;
	client->sh=NULL;

	buffer_free(&client->output);
	buffer_free(&client->input);

	user_put(&client->user);

	channel_member_part_all(&client->member_list);

	TODO("free any other data structures associated with client"); /* be vigilant about memory leaks */

#ifndef NDEBUG
	memset(client, 0xBB, sizeof *client); /* fill with fake data before freeing */
#endif

	free(client);
}

static struct telnetclient *telnetclient_newclient(struct socketio_handle *sh) {
	struct telnetclient *cl;
	cl=malloc(sizeof *cl);
	FAILON(!cl, "malloc()", failed);

	JUNKINIT(cl, sizeof *cl);

	buffer_init(&cl->output, TELNETCLIENT_OUTPUT_BUFFER_SZ);
	buffer_init(&cl->input, TELNETCLIENT_INPUT_BUFFER_SZ);
	cl->terminal.width=cl->terminal.height=0;
	strcpy(cl->terminal.name, "");
	cl->state_free=NULL;
	telnetclient_clear_statedata(cl);
	cl->line_input=NULL;
	cl->prompt_flag=0;
	cl->prompt_string=NULL;
	cl->sh=sh;
	cl->user=NULL;
	LIST_INIT(&cl->member_list);

	sh->extra=cl;
	sh->extra_free=telnetclient_free;

	channel_member_join(channel_system_get(0), &cl->member_list, cl);

	return cl;
failed:
	return NULL;
}

/* replaces the current user with a different one and updates the reference counts */
static void telnetclient_setuser(struct telnetclient *cl, struct user *u) {
	struct user *old_user;
	assert(cl != NULL);
	old_user=cl->user;
	cl->user=u;
	user_get(u);
	user_put(&old_user);
}

/* posts telnet protocol necessary to begin negotiation of options */
static int telnetclient_telnet_init(struct telnetclient *cl) {
	const char support[] = {
		IAC, DO, TELOPT_LINEMODE,
		IAC, DO, TELOPT_NAWS,		/* window size events */
		IAC, DO, TELOPT_TTYPE,		/* accept terminal-type infomation */
		IAC, SB, TELOPT_TTYPE, TELQUAL_SEND, IAC, SE, /* ask the terminal type */
	};
	if(buffer_write_noexpand(&cl->output, support, sizeof support)<0) {
		DEBUG_MSG("write failure");
		telnetclient_close(cl);
		return 0; /* failure */
	}

	return 1; /* success */
}

static int telnetclient_echomode(struct telnetclient *cl, int mode) {
	static const char echo_off[] = { IAC, WILL, TELOPT_ECHO }; /* OFF */
	static const char echo_on[] = { IAC, WONT, TELOPT_ECHO }; /* ON */
	const char *s;
	size_t len;
	if(mode) {
		s=echo_on;
		len=sizeof echo_on;
	} else {
		s=echo_off;
		len=sizeof echo_off;
	}

	if(buffer_write_noexpand(&cl->output, s, len)<0) {
		DEBUG_MSG("write failure");
		cl->sh->delete_flag=1;
		return 0; /* failure */
	}
	return 1; /* success */
}

static int telnetclient_linemode(struct telnetclient *cl, int mode) {
	const char enable[] = {
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_EDIT|MODE_TRAPSIG, IAC, SE
	};
	const char disable[] = { /* character at a time mode */
		IAC, SB, TELOPT_LINEMODE, LM_MODE, MODE_TRAPSIG, IAC, SE
	};
	const char *s;
	size_t len;

	if(mode) {
		s=enable;
		len=sizeof enable;
	} else {
		s=disable;
		len=sizeof disable;
	}

	if(buffer_write_noexpand(&cl->output, s, len)<0) {
		DEBUG_MSG("write failure");
		cl->sh->delete_flag=1;
		return 0; /* failure */
	}
	return 1; /* success */
}

EXPORT void telnetclient_write_event(struct socketio_handle *sh, SOCKET fd, void *p) {
	const char *data;
	size_t len;
	int res;
	struct telnetclient *cl=p;

	assert(cl->sh->delete_flag == 0); /* we should never be called if already deleted */

	/* only call this if the client wasn't closed and we have data in our buffer */
	assert(cl != NULL);
	assert(sh == cl->sh);

	data=buffer_data(&cl->output, &len);
	res=socketio_send(fd, data, len);
	if(res<0) {
		sh->delete_flag=1;
		return; /* client write failure */
	}
	TRACE("%s():len=%zu res=%zu\n", __func__, len, res);
	len=buffer_consume(&cl->output, (unsigned)res);

	if(len>0) {
		/* there is still data in our buffer */
		socketio_writeready(fd);
	}
}

/* for processing IAC SB */
static void telnetclient_iac_process_sb(const char *iac, size_t len, struct telnetclient *cl) {
	assert(cl != NULL);
	assert(iac[0] == IAC);
	assert(iac[1] == SB);
	if(!iac) return;
	if(!cl) return;

	switch(iac[2]) {
		case TELOPT_TTYPE:
			if(iac[3]==TELQUAL_IS) {
				if(len<9) {
					ERROR_MSG("WARNING: short IAC SB TTYPE IS .. IAC SE");
					return;
				}
				snprintf(cl->terminal.name, sizeof cl->terminal.name, "%.*s", (int)len-4-2, iac+4);
				DEBUG("%s:Client terminal type is now \"%s\"\n", cl->sh->name, cl->terminal.name);
				/*
				telnetclient_printf(cl, "Terminal type: %s\n", cl->terminal.name);
				*/
			}
			break;
		case TELOPT_NAWS: {
			if(len<9) {
				ERROR_MSG("WARNING: short IAC SB NAWS .. IAC SE");
				return;
			}
			assert(len==9);
			cl->terminal.width=RD_BE16(iac, 3);
			cl->terminal.height=RD_BE16(iac, 5);
			DEBUG("%s:Client display size is now %ux%u\n", cl->sh->name, cl->terminal.width, cl->terminal.height);
			/*
			telnetclient_printf(cl, "display size is: %ux%u\n", cl->terminal.width, cl->terminal.height);
			*/
			break;
		}
	}
}

/* return: 0 means "incomplete" data for this function */
static size_t telnetclient_iac_process(const char *iac, size_t len, void *p) {
	struct telnetclient *cl=p;
	const char *endptr;

	assert(iac != NULL);
	assert(iac[0] == IAC);

	if(iac[0]!=IAC) {
		ERROR_FMT("%s() called on non-telnet data\n", __func__);
		return 0;
	}

	switch(iac[1]) {
		case IAC:
			return 1; /* consume the first IAC and leave the second behind */
		case WILL:
			if(len>=3) {
				DEBUG("%s():IAC WILL %hhu\n", __func__, iac[2]);
				return 3; /* 3-byte operations*/
			} else {
				return 0; /* not enough data */
			}
		case WONT:
			if(len>=3) {
				DEBUG("%s():IAC WONT %hhu\n", __func__, iac[2]);
				return 3; /* 3-byte operations*/
			} else {
				return 0; /* not enough data */
			}
		case DO:
			if(len>=3) {
				DEBUG("%s():IAC DO %hhu\n", __func__, iac[2]);
				return 3; /* 3-byte operations*/
			} else {
				return 0; /* not enough data */
			}
		case DONT:
			if(len>=3) {
				DEBUG("%s():IAC DONT %hhu\n", __func__, iac[2]);
				return 3; /* 3-byte operations*/
			} else {
				return 0; /* not enough data */
			}
		case SB:
			/* look for IAC SE */
			TRACE("IAC SB %hhu found\n", iac[2]);
			endptr=iac+2;
			while((endptr=memchr(endptr, IAC, len-(endptr-iac)))) {
				assert(endptr[0] == IAC);
				TRACE("found IAC %hhu\n", endptr[1]);
				endptr++;
				if((endptr-iac)>=(ptrdiff_t)len) {
					DEBUG_MSG("Unterminated IAC SB sequence");
					return 0; /* unterminated */
				}
				if(endptr[0]==SE) {
					endptr++;
					// DEBUG("%s():IAC SB %hhu ... IAC SE\n", __func__, iac[2]);
					HEXDUMP(iac, endptr-iac, "%s():IAC SB %hhu: ", __func__, iac[2]);
					telnetclient_iac_process_sb(iac, (size_t)(endptr-iac), cl);
					return endptr-iac;
				} else if(endptr[0]==IAC) {
					TRACE("Found IAC IAC in IAC SB block\n");
					endptr++;
				}
			}
			return 0; /* unterminated IAC SB sequence */
		case SE:
			ERROR_MSG("found IAC SE without IAC SB, ignoring it.");
		default:
			if(len>=3)
				return 2; /* treat anything we don't know about as a 2-byte operation */
			else
				return 0; /* not enough data */
	}

	/* we should never get to this point */

}

/* pull data from socket into buffer */
static int telnetclient_recv(struct socketio_handle *sh, struct telnetclient *cl) {
	char *data;
	size_t len;
	int res;

	data=buffer_load(&cl->input, &len);
	if(len==0) {
		ERROR_FMT("WARNING:input buffer full, closing connection %s\n", sh->name);
		goto failure;
	}
	res=socketio_recv(sh->fd, data, len);
	if(res<=0) {
		/* close or error */
		goto failure;
	}
	DEBUG("%s():res=%u\n", __func__, res);
	buffer_emit(&cl->input, (unsigned)res);

	DEBUG("Client %d(%s):received %d bytes (used=%zu)\n", sh->fd, sh->name, res, cl->input.used);
	return 1;
failure:
	/* close the socket and free the client */
	telnetclient_close(cl);
	return 0;
}

/* */
EXPORT void telnetclient_rdev_lineinput(struct socketio_handle *sh, SOCKET fd, void *extra) {
	const char *line;
	size_t consumed;
	struct telnetclient *cl=extra;

	/* pull data from socket into buffer */
	if(!telnetclient_recv(sh, cl)) {
		return; /* failure */
	}

	/* getline triggers a special IAC parser that stops at a line */
	while((line=buffer_getline(&cl->input, &consumed, telnetclient_iac_process, cl))) {
		DEBUG("client line:%s(): '%s'\n", __func__, line);

		if(cl->line_input) {
			cl->line_input(cl, line);
		}

		buffer_consume(&cl->input, consumed);

		if(sh->read_event!=telnetclient_rdev_lineinput) break;
	}
	socketio_readready(fd); /* only call this if the client wasn't closed earlier */
	return;
}

static void telnetclient_setprompt(struct telnetclient *cl, const char *prompt) {
	cl->prompt_string=prompt?prompt:"? ";
	telnetclient_puts(cl, cl->prompt_string);
	cl->prompt_flag=1;
}

static void telnetclient_start_lineinput(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt) {
	assert(cl != NULL);
	telnetclient_setprompt(cl, prompt);
	cl->line_input=line_input;
	cl->sh->read_event=telnetclient_rdev_lineinput;
}

/* return true if client is still in this state */
static int telnetclient_isstate(struct telnetclient *cl, void (*line_input)(struct telnetclient *cl, const char *line), const char *prompt) {

	if(!cl) return 0;

	return cl->sh->read_event==telnetclient_rdev_lineinput && cl->line_input==line_input && cl->prompt_string==prompt;
}

static void menu_lineinput(struct telnetclient *cl, const char *line) {
	menu_input(cl, cl->state.menu.menu, line);
}

static void telnetclient_start_menuinput(struct telnetclient *cl, struct menuinfo *menu) {
	telnetclient_clear_statedata(cl); /* this is a fresh state */
	cl->state.menu.menu=menu;
	menu_show(cl, cl->state.menu.menu);
	telnetclient_start_lineinput(cl, menu_lineinput, mud_config.menu_prompt);
}

EXPORT void telnetclient_new_event(struct socketio_handle *sh) {
	struct telnetclient *cl;

	cl=telnetclient_newclient(sh);
	if(!cl) {
		return; /* failure */
	}

	sh->write_event=telnetclient_write_event;
	sh->read_event=NULL;

	if(!telnetclient_telnet_init(cl) || !telnetclient_linemode(cl, 1) || !telnetclient_echomode(cl, 1)) {
		return; /* failure, the client would have been deleted */
	}

	fprintf(stderr, "*** Connection %d: %s\n", sh->fd, sh->name);
	telnetclient_puts(cl, mud_config.msgfile_welcome);
	telnetclient_start_menuinput(cl, &gamemenu_login);
}

EXPORT void telnetclient_close(struct telnetclient *cl) {
	if(cl && cl->sh) {
		cl->sh->delete_flag=1; /* cause deletetion later */
		socketio_delete_count++;
	}
}

EXPORT void telnetclient_prompt_refresh(struct telnetclient *cl) {
	if(cl && cl->prompt_string && !cl->prompt_flag) {
		telnetclient_setprompt(cl, cl->prompt_string);
	}
}

EXPORT void telnetclient_prompt_refresh_all(void) {
	struct socketio_handle *curr, *next;
	for(curr=LIST_TOP(socketio_handle_list);curr;curr=next) {
		next=LIST_NEXT(curr, list);
		if(curr->type==1 && curr->extra) {
			telnetclient_prompt_refresh(curr->extra);
		}
	}
}

/******************************************************************************
 * Channels
 ******************************************************************************/

/*
 * channel_member - a client has one of these for every channel they belong to
 * channel_group - head for list of members
 *   to delete this all members must be detached, because they have a reference to the head.
 */

#define CHANNEL_FLAG_PERMANENT 1

struct channel_member {
	LIST_ENTRY(struct channel_member) client_membership; /* client's list */
	struct telnetclient *cl; /* we could use a function pointer and void* to allow a more generic strategy */
	LIST_ENTRY(struct channel_member) groups; /* channel's list */
	struct channel_group *group_head; /* pointer to the channel head */
};

struct channel_group {
	/* TODO: work out how to use a channel group with a room */
	char *name; /* channel name */
	LIST_HEAD(struct, struct channel_member) member_list;
	LIST_ENTRY(struct channel_group) channels;
	unsigned flags[BITFIELD(32, unsigned)];
};

static LIST_HEAD(struct, struct channel_group) channel_global_list;
static struct channel_group **channel_system; /* array of system channels */
static unsigned nr_channel_system; /* number of system channels */

EXPORT struct channel_group *channel_group_lookup(const char *name) {
	struct channel_group *curr;
	for(curr=LIST_TOP(channel_global_list);curr;curr=LIST_NEXT(curr, channels)) {
		if(curr->name && !strcasecmp(curr->name, name)) {
			return curr;
		}
	}
	return NULL;
}

EXPORT struct channel_group *channel_group_create(const char *name) {
	struct channel_group *ret;

	/* check if channel exists and return that instead */
	if((ret=channel_group_lookup(name))) {
		ERROR_FMT("WARNING:channel '%s' already exists\n", name);
		return ret;
	}

	/* channel doesn't exist, create it */
	ret=malloc(sizeof *ret);
	if(!ret) {
		PERROR("malloc()");
		return NULL;
	}
	JUNKINIT(ret, sizeof *ret);

	ret->name=strdup(name);
	if(!ret->name) {
		PERROR("strdup()");
		free(ret);
		return NULL;
	}

	memset(ret->flags, 0, sizeof ret->flags);

	LIST_INIT(&ret->member_list);
	LIST_ENTRY_INIT(ret, channels);

	LIST_INSERT_HEAD(&channel_global_list, ret, channels);

	eventlog_channel_new(name);

	return ret;
}

EXPORT void channel_group_free(struct channel_group *ch) {
	struct channel_member *curr;
	if(!ch) return; /* ignore NULL */

	eventlog_channel_remove(ch->name);

	while((curr=LIST_TOP(ch->member_list))) {
		channel_member_part(ch, &curr->cl->member_list);
	}

	LIST_REMOVE(ch, channels);

	free(ch->name);
	free(ch);
}

/** fetch a system channel */
EXPORT struct channel_group *channel_system_get(unsigned n) {
	if(n<nr_channel_system) {
		return channel_system[n];
	}
	return 0;
}

/** initialize some default channels */
EXPORT int channel_module_init(void) {
	const char *s, *e;
	char buf[128];
	struct channel_group *g;
	unsigned count=0;

	assert(LIST_TOP(channel_global_list) == NULL);

	/* create some default groups */
	for(s=mud_config.default_channels;*s;s=*e?e+1:e) {

		while(isspace(*s)) s++; /* trim leading spaces */

		e=strchr(s, ','); /* find the next delimiter */
		if(!e) e=s+strlen(s); /* if not found use end of string */

		while(e>s && isspace(e[-1])) e--; /* trim trailing spaces */

		if(e-s>(int)sizeof buf-1) goto failure; /* confirm the length */

		/* copy string */
		assert(s <= e);
		memcpy(buf, s, (size_t)(e-s));
		buf[e-s]=0;

		if(!*buf) continue; /* ignore empty channel names */

		g=channel_group_create(buf);
		if(!g) goto failure;
		BITSET(g->flags, CHANNEL_FLAG_PERMANENT); /* default channels are permanent */
		count++;
	}

	/* make an array for looking up system channels */
	nr_channel_system=count;
	channel_system=calloc(count, sizeof *channel_system);

	/* load the system channels in the same order that they were specified in the configuration */
	for(g=LIST_TOP(channel_global_list);count>0;g=LIST_NEXT(g, channels)) {
		TRACE("count=%d g=%p name=%s\n", count, g, g->name);
		assert(g != NULL);
		channel_system[--count]=g;
	}

	return 1; /* success */
failure:
	ERROR_MSG("Could not create default channels.");
	return 0;
}

/** find membership in a channel */
EXPORT struct channel_member *channel_member_check(struct channel_group *ch, struct channel_member_head *mh) {
	struct channel_member *curr;
	for(curr=LIST_TOP(*mh);curr;curr=LIST_NEXT(curr, client_membership)) {
		if(curr->group_head==ch) {
			return curr; /* found membership */
		}
	}
	return 0; /* not a member of this channel */
}

/** add membership for a channel */
EXPORT int channel_member_join(struct channel_group *ch, struct channel_member_head *mh, struct telnetclient *cl) {
	struct channel_member *new;

	if(channel_member_check(ch, mh)) {
		return 0; /* already a member */
	}

	/* allocate the entry */
	new=malloc(sizeof *new);
	if(!new) {
		PERROR("malloc()");
		return 0;
	}
	JUNKINIT(new, sizeof *new);

	new->group_head=ch;
	new->cl=cl;

	LIST_INSERT_HEAD(mh, new, client_membership);
	LIST_INSERT_HEAD(&ch->member_list, new, groups);

	/* TODO: log the system channel number if there is no name */
	eventlog_channel_join(cl&&cl->sh?cl->sh->name:NULL, ch->name, "<USER>");

	TRACE("join (ch=%p) (mem=%p)\n", ch, new);

	return 1; /* success */
}

EXPORT int channel_member_part(struct channel_group *ch, struct channel_member_head *mh) {
	struct channel_member *curr;

	curr=channel_member_check(ch, mh);

	if(!curr) {
		return 0; /* failure */
	}

	/* TODO: log the system channel number if there is no name */
	eventlog_channel_part(curr->cl&&curr->cl->sh?curr->cl->sh->name:NULL, ch->name, "<USER>");

	LIST_REMOVE(curr, client_membership);
	LIST_REMOVE(curr, groups);
	free(curr);

	/* remove the channel if it is empty */
	if(!BITTEST(ch->flags, CHANNEL_FLAG_PERMANENT) && !LIST_TOP(ch->member_list)) {
		assert(LIST_TOP(ch->member_list) == NULL); /* recursion can occur between remove and part otherwise */
		channel_group_free(ch);
	}

	return 1; /* success */
}

/**
 */
EXPORT void channel_member_part_all(struct channel_member_head *mh) {
	struct channel_member *curr;
	while((curr=LIST_TOP(*mh))) {
		channel_member_part(curr->group_head, &curr->cl->member_list);
	}
}

/** send a message to a channel, excluding one member
 * return a count of the number receiving the message */
EXPORT int channel_broadcast(struct channel_group *ch, struct channel_member *exclude_member, const char *fmt, ...) {
	struct channel_member *curr, *next;
	int count;
	va_list ap;

	TRACE("Enter (ch=%p) (mem=%p)\n", ch, exclude_member);

	if(!ch) return 0; /* ignore NULL */

	va_start(ap, fmt);
	for(count=0,curr=LIST_TOP(ch->member_list);curr;curr=next,count++) {
		assert((void*)ch != (void*)curr); /* check that two different lists are not crossed */
		assert(ch == curr->group_head); /* member entries must match current channel */

		next=LIST_NEXT(curr, groups);

		TRACE("curr-member=%p\n", curr);

		if(curr!=exclude_member && curr->cl) {
			telnetclient_vprintf(curr->cl, fmt, ap);
		}
	}
	va_end(ap);

	TRACE("sent message to %d players\n", count);

	return count;
}

/******************************************************************************
 * Menus
 ******************************************************************************/
struct menuitem {
	LIST_ENTRY(struct menuitem) item;
	char *name;
	char key;
	void (*action_func)(void *p, long extra2, void *extra3);
	long extra2;
	void *extra3;
};

EXPORT void menu_create(struct menuinfo *mi, const char *title) {
	assert(mi!=NULL);
	LIST_INIT(&mi->items);
	mi->title_width=strlen(title);
	mi->title=malloc(mi->title_width+1);
	FAILON(!mi->title, "malloc()", failed);
	strcpy(mi->title, title);
	mi->tail=NULL;
failed:
	return;
}

EXPORT void menu_additem(struct menuinfo *mi, int ch, const char *name, void (*func)(void*, long, void*), long extra2, void *extra3) {
	struct menuitem *newitem;
	newitem=malloc(sizeof *newitem);
	newitem->name=strdup(name);
	newitem->key=ch;
	TODO("check for duplicate keys");
	newitem->action_func=func;
	newitem->extra2=extra2;
	newitem->extra3=extra3;
	if(mi->tail) {
		LIST_INSERT_AFTER(mi->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&mi->items, newitem, item);
	}
	mi->tail=newitem;
}

/* draw a little box around the string */
static void menu_titledraw(struct telnetclient *cl, const char *title, size_t len) {
#if __STDC_VERSION__ >= 199901L
	char buf[len+2];
#else
	char buf[256];
	if(len>sizeof buf-1)
		len=sizeof buf-1;
#endif
	memset(buf, '=', len);
	buf[len]='\n';
	buf[len+1]=0;
	if(cl)
		telnetclient_puts(cl, buf);
	DEBUG("%s>>%s", cl?cl->sh->name:"", buf);
	if(cl)
		telnetclient_printf(cl, "%s\n", title);
	DEBUG("%s>>%s\n", cl?cl->sh->name:"", title);
	if(cl)
		telnetclient_puts(cl, buf);
	DEBUG("%s>>%s", cl?cl->sh->name:"", buf);
}

EXPORT void menu_show(struct telnetclient *cl, const struct menuinfo *mi) {
	const struct menuitem *curr;

	assert(mi != NULL);
	menu_titledraw(cl, mi->title, mi->title_width);
	for(curr=LIST_TOP(mi->items);curr;curr=LIST_NEXT(curr, item)) {
		if(curr->key) {
			if(cl)
				telnetclient_printf(cl, "%c. %s\n", curr->key, curr->name);
			DEBUG("%s>>%c. %s\n", cl?cl->sh->name:"", curr->key, curr->name);
		} else {
			if(cl)
				telnetclient_printf(cl, "%s\n", curr->name);
			DEBUG("%s>>%s\n", cl?cl->sh->name:"", curr->name);
		}
	}
}

EXPORT void menu_input(struct telnetclient *cl, const struct menuinfo *mi, const char *line) {
	const struct menuitem *curr;
	while(*line && isspace(*line)) line++; /* ignore leading spaces */
	for(curr=LIST_TOP(mi->items);curr;curr=LIST_NEXT(curr, item)) {
		if(tolower(*line)==tolower(curr->key)) {
			if(curr->action_func) {
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

/* used as a generic starting point for menus */
static void menu_start(void *p, long unused2 UNUSED, void *extra3) {
	struct telnetclient *cl=p;
	struct menuinfo *mi=extra3;
	telnetclient_start_menuinput(cl, mi);
}

/******************************************************************************
 * command - handles the command processing
 ******************************************************************************/

static int command_do_pose(struct telnetclient *cl, struct user *u, const char *cmd UNUSED, const char *arg) {
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);
	return 1; /* success */
}

static int command_do_yell(struct telnetclient *cl, struct user *u, const char *cmd UNUSED, const char *arg) {
	TODO("Get user name");
	TODO("Broadcast to everyone in yelling distance");
	telnetclient_printf(cl, "%s yells \"%s\"\n", telnetclient_username(cl), arg);
	return 1; /* success */
}

static int command_do_say(struct telnetclient *cl, struct user *u, const char *cmd UNUSED, const char *arg) {
	struct channel_group *ch;
	TODO("Get user name");
	telnetclient_printf(cl, "You say \"%s\"\n", arg);
	ch=channel_system_get(0);
	channel_broadcast(ch, channel_member_check(ch, &cl->member_list), "%s says \"%s\"\n", telnetclient_username(cl), arg);
	return 1; /* success */
}

static int command_do_emote(struct telnetclient *cl, struct user *u, const char *cmd UNUSED, const char *arg) {
	TODO("Get user name");
	TODO("Broadcast to everyone in current room");
	telnetclient_printf(cl, "%s %s\n", telnetclient_username(cl), arg);
	return 1; /* success */
}

static int command_do_chsay(struct telnetclient *cl, struct user *u, const char *cmd, const char *arg) {
	TODO("Get user name");
	TODO("Broadcast to everyone in a channel");
	telnetclient_printf(cl, "%s says \"%s\"\n", telnetclient_username(cl), arg);
	return 1; /* success */
}

/* executes a command for user u */
static int command_execute(struct telnetclient *cl, struct user *u, const char *line) {
	char cmd[64];
	const char *e, *arg;

	assert(cl != NULL); /* TODO: support cl as NULL for silent/offline commands */
	assert(line != NULL);

	while(*line && isspace(*line)) line++; /* ignore leading spaces */

	TODO("Can we eliminate trailing spaces?");

	TODO("can we define these 1 character commands as aliases?");

	if(ispunct(line[0])) {
		cmd[0]=line[0];
		cmd[1]=0;
		arg=line+1; /* point to where the args start if it's a 1 character command */
		while(*arg && isspace(*arg)) arg++; /* ignore leading spaces */
		if(line[0]==':') { /* pose : */
			command_do_pose(cl, u, cmd, arg);
			return 1; /* success */
		} else if(line[0]=='"' && line[1]=='"') { /* yell "" */
			cmd[0]=line[0];
			cmd[1]=line[1];
			cmd[2]=0;
			arg=line+2; /* args start here for 2 character commands */
			while(*arg && isspace(*arg)) arg++; /* ignore leading spaces */
			return command_do_yell(cl, u, cmd, arg);
		} else if(line[0]=='"') { /* say " */
			return command_do_say(cl, u, cmd, arg);
		} else if(line[0]==';') { /* spoof ; */
			TODO("Implement this");
		} else if(line[0]==',') { /* emote , */
			return command_do_emote(cl, u, cmd, arg);
		} else if(line[0]=='\'') { /* say ' */
			return command_do_say(cl, u, cmd, arg);
		} else if(line[0]=='.') { /* channel say */
			TODO("check \".chan\" for CHSAY and copy into cmd");
			return command_do_chsay(cl, u, cmd, arg);
		} else {
			telnetclient_puts(cl, mud_config.msg_invalidcommand);
			return 0; /* failure */
		}
	}

	/* copy the first word into cmd[] */
	e=line+strcspn(line, " \t");
	arg=*e ? e+1+strspn(e+1, " \t") : e; /* point to where the args start */
	while(*arg && isspace(*arg)) arg++; /* ignore leading spaces */
	assert(e >= line);
	if((unsigned)(e-line)>sizeof cmd-1) { /* first word is too long */
		DEBUG("Command length %d is too long, truncating\n", e-line);
		e=line+sizeof cmd-1;
	}
	memcpy(cmd, line, (unsigned)(e-line));
	cmd[e-line]=0;

	TODO("check for \"playername,\" syntax for directed speech");

	TODO("check user aliases");

	DEBUG("cmd=\"%s\"\n", cmd);

	if(!strcmp(cmd, "who")) {
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else if(!strcmp(cmd, "quit")) {
		telnetclient_close(cl); /* TODO: the close code needs to change the state so telnetclient_isstate does not end up being true for a future read? */
		return 1; /* success */
	} else if(!strcmp(cmd, "page")) {
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else if(!strcmp(cmd, "say")) {
		return command_do_say(cl, u, cmd, arg);
	} else if(!strcmp(cmd, "emote")) {
		return command_do_emote(cl, u, cmd, arg);
	} else if(!strcmp(cmd, "pose")) {
		return command_do_pose(cl, u, cmd, arg);
	} else if(!strcmp(cmd, "chsay")) {
		TODO("pass the channel name in a way that makes sense");
		return command_do_chsay(cl, u, cmd, arg);
	} else if(!strcmp(cmd, "sayto")) {
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else if(!strcmp(cmd, "tell")) { /* can work over any distance */
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else if(!strcmp(cmd, "whisper")) { /* only works in current room */
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else if(!strcmp(cmd, "to")) {
		telnetclient_puts(cl, "Not implemented");
		return 1; /* success */
	} else {
		telnetclient_puts(cl, mud_config.msg_invalidcommand);
		return 0; /* failure */
	}

	ERROR_FMT("fell through command lookup on '%s'\n", line);
	telnetclient_puts(cl, mud_config.msg_invalidcommand);
	return 0; /* failure */
}

static void command_lineinput(struct telnetclient *cl, const char *line) {
	assert(cl != NULL);
	assert(cl->sh != NULL);
	DEBUG("%s:entered command '%s'\n", telnetclient_username(cl), line);

	/* log command input */
	eventlog_commandinput(cl->sh->name, telnetclient_username(cl), line);

	/* do something with the command */
	command_execute(cl, NULL, line); /* TODO: pass current user and character */

	/* check if we should update the prompt */
	if(telnetclient_isstate(cl, command_lineinput, mud_config.command_prompt)) {
		telnetclient_setprompt(cl, mud_config.command_prompt);
	}
}

static void command_start_lineinput(struct telnetclient *cl) {
	telnetclient_printf(cl, "Terminal type: %s\n", cl->terminal.name);
	telnetclient_printf(cl, "display size is: %ux%u\n", cl->terminal.width, cl->terminal.height);
	telnetclient_start_lineinput(cl, command_lineinput, mud_config.command_prompt);
}

EXPORT void command_start(void *p, long unused2 UNUSED, void *unused3 UNUSED) {
	command_start_lineinput(p);
}

/******************************************************************************
 * login - handles the login process
 ******************************************************************************/
static void login_password_lineinput(struct telnetclient *cl, const char *line) {
	struct user *u;

	assert(cl != NULL);
	assert(line != NULL);
	assert(cl->state.login.username[0] != '\0'); /* must have a valid username */

	TODO("complete login process");
	DEBUG("Login attempt: Username='%s'\n", cl->state.login.username);

	u=user_lookup(cl->state.login.username);
	if(u) {
		/* verify the password */
		if(xxtcrypt_checkpass(u->password_crypt, line)) {
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

static void login_password_start(void *p, long unused2 UNUSED, void *unused3 UNUSED) {
	struct telnetclient *cl=p;
	telnetclient_start_lineinput(cl, login_password_lineinput, "Password: ");
}

static void login_username_lineinput(struct telnetclient *cl, const char *line) {
	assert(line != NULL);

	telnetclient_clear_statedata(cl); /* this is a fresh state */
	cl->state_free=0; /* this state does not require anything special to free */

	while(*line && isspace(*line)) line++; /* ignore leading spaces */

	if(!*line) {
		telnetclient_puts(cl, mud_config.msg_invalidusername);
		telnetclient_start_menuinput(cl, &gamemenu_login);
		return;
	}

	/* store the username for the password state to use */
	snprintf(cl->state.login.username, sizeof cl->state.login.username, "%s", line);

	login_password_start(cl, 0, 0);
}

static void login_username_start(void *p, long unused2 UNUSED, void *unused3 UNUSED) {
	struct telnetclient *cl=p;
	telnetclient_start_lineinput(cl, login_username_lineinput, "Username: ");
}

static void signoff(void *p, long unused2 UNUSED, void *unused3 UNUSED) {
	struct telnetclient *cl=p;
	telnetclient_close(cl);
}

/******************************************************************************
 * form - handles processing input forms
 ******************************************************************************/
static struct form *form_newuser_app;

EXPORT void form_init(struct form *f, const char *title, void (*form_close)(struct telnetclient *cl, struct form_state *fs)) {
	LIST_INIT(&f->items);
	f->form_title=strdup(title);
	f->tail=NULL;
	f->form_close=form_close;
	f->item_count=0;
	f->message=0;
}

/** define a message to be displayed on start */
EXPORT void form_setmessage(struct form *f, const char *message) {
	f->message=message;
}

EXPORT void form_free(struct form *f) {
	struct formitem *curr;

	TRACE("*** %s() ***\n", __func__);

	free(f->form_title);
	f->form_title=NULL;

	while((curr=LIST_TOP(f->items))) {
		LIST_REMOVE(curr, item);
		free(curr->name);
		free(curr->prompt);
		free(curr->description);
#ifndef NDEBUG
		memset(curr, 0x55, sizeof *curr); /* fill with fake data before freeing */
#endif
		free(curr);
	}
	memset(f, 0x55, sizeof *f); /* fill with fake data before freeing */
}

EXPORT void form_additem(struct form *f, unsigned flags, const char *name, const char *prompt, const char *description, int (*form_check)(struct telnetclient *cl, const char *str)) {
	struct formitem *newitem;

	newitem=malloc(sizeof *newitem);
	newitem->name=strdup(name);
	newitem->description=strdup(description);
	newitem->prompt=strdup(prompt);
	newitem->flags=flags;
	newitem->form_check=form_check;
	newitem->value_index=f->item_count++;

	if(f->tail) {
		LIST_INSERT_AFTER(f->tail, newitem, item);
	} else {
		LIST_INSERT_HEAD(&f->items, newitem, item);
	}
	f->tail=newitem;
}

static struct formitem *form_getitem(struct form *f, const char *name) {
	struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for(curr=LIST_TOP(f->items);curr;curr=LIST_NEXT(curr, item)) {
		if(!strcasecmp(curr->name, name)) {
			/* found first matching entry */
			return curr;
		}
	}
	ERROR_FMT("Unknown form variable '%s'\n", name);
	return NULL; /* not found */
}

/** look up the user value from a form */
static const char *form_getvalue(const struct form *f, unsigned nr_value, char **value, const char *name) {
	const struct formitem *curr;

	assert(f != NULL);
	assert(name != NULL);

	for(curr=LIST_TOP(f->items);curr;curr=LIST_NEXT(curr, item)) {
		if(!strcasecmp(curr->name, name) && curr->value_index<nr_value) {
			/* found matching entry that was in range */
			return value[curr->value_index];
		}
	}
	ERROR_FMT("Unknown form variable '%s'\n", name);
	return NULL; /* not found */
}

static void form_menu_show(struct telnetclient *cl, const struct form *f, struct form_state *fs) {
	const struct formitem *curr;
	unsigned i;

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	for(i=0,curr=LIST_TOP(f->items);curr&&(!fs||i<fs->nr_value);curr=LIST_NEXT(curr, item),i++) {
		const char *user_value;

		user_value=fs ? fs->value[i] ? fs->value[i] : "" : 0;
		if((curr->flags&1)==1) {
			user_value="<hidden>";
		}
		telnetclient_printf(cl, "%d. %s %s\n", i+1, curr->prompt, user_value ? user_value : "");
	}
	telnetclient_printf(cl, "A. accept\n");
}

static void form_lineinput(struct telnetclient *cl, const char *line) {
	struct form_state *fs=&cl->state.form;
	const struct form *f=fs->form;
	char **value=&fs->value[fs->curritem->value_index];

	assert(f != NULL);
	assert(fs->curritem != NULL);

	while(*line && isspace(*line)) line++; /* ignore leading spaces */

	if(*line) {
		/* check the input */
		if(fs->curritem->form_check && !fs->curritem->form_check(cl, line)) {
			DEBUG("%s:Invalid form input\n", cl->sh->name);
			telnetclient_puts(cl, mud_config.msg_tryagain);
			telnetclient_setprompt(cl, fs->curritem->prompt);
			return;
		}
		if(*value) {
			free(*value);
			*value=NULL;
		}
		*value=strdup(line);
		fs->curritem=LIST_NEXT(fs->curritem, item);
		if(fs->curritem && !fs->done) {
			telnetclient_puts(cl, fs->curritem->description);
			telnetclient_setprompt(cl, fs->curritem->prompt);
		} else {
			fs->done=1; /* causes form entry to bounce back to form menu */
			/* a menu for verifying the form */
			form_menu_show(cl, f, fs);
			telnetclient_start_lineinput(cl, form_menu_lineinput, mud_config.form_prompt);
		}
	}
}

static void form_menu_lineinput(struct telnetclient *cl, const char *line) {
	struct form_state *fs=&cl->state.form;
	const struct form *f=fs->form;
	char *endptr;

	assert(cl != NULL);
	assert(line != NULL);

	while(*line && isspace(*line)) line++; /* ignore leading spaces */

	if(tolower(*line)=='a') { /* accept */
		TODO("callback to close out the form");
		if(f->form_close) {
			/* this call will switch states on success */
			f->form_close(cl, fs);
		} else {
			/* fallback */
			DEBUG("%s():%s:ERROR:going to main menu\n", __func__, cl->sh->name);
			telnetclient_puts(cl, mud_config.msg_errormain);
			telnetclient_start_menuinput(cl, &gamemenu_login);
		}
		return; /* success */
	} else {
		long i;
		i=strtol(line, &endptr, 10);
		if(endptr!=line && i>0) {
			for(fs->curritem=LIST_TOP(f->items);fs->curritem;fs->curritem=LIST_NEXT(fs->curritem, item)) {
				if(--i==0) {
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
	return;
}

static void form_state_free(struct telnetclient *cl) {
	struct form_state *fs=&cl->state.form;
	unsigned i;
	DEBUG("%s():%s:freeing state\n", __func__, cl->sh->name);

	if(fs->value) {
		for(i=0;i<fs->nr_value;i++) {
			if(fs->value[i]) {
				size_t len; /* carefully erase the data from the heap, it may be private */
				len=strlen(fs->value[i]);
				memset(fs->value[i], 0, len);
				free(fs->value[i]);
				fs->value[i]=NULL;
			}
		}
		free(fs->value);
	}
	fs->value=0;
	fs->nr_value=0;
}

EXPORT void form_state_init(struct form_state *fs, const struct form *f) {
	fs->form=f;
	fs->nr_value=0;
	fs->value=NULL;
	fs->done=0;
}

static int form_createaccount_username_check(struct telnetclient *cl, const char *str) {
	int res;
	size_t len;
	const char *s;

	TRACE_ENTER();

	len=strlen(str);
	if(len<3) {
		telnetclient_puts(cl, mud_config.msg_usermin3);
		DEBUG_MSG("failure: username too short.");
		return 0;
	}

	for(s=str,res=isalpha(*s);*s;s++) {
		res=res&&isalnum(*s);
		if(!res) {
			telnetclient_puts(cl, mud_config.msg_useralphanumeric);
			DEBUG_MSG("failure: bad characters");
			return 0;
		}
	}

	if(user_exists(str)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		DEBUG_MSG("failure: user exists.");
		return 0;
	}

	DEBUG_MSG("success.");
	return 1;
}

static void form_createaccount_close(struct telnetclient *cl, struct form_state *fs) {
	const char *username, *password, *email;
	struct user *u;
	const struct form *f=fs->form;

	username=form_getvalue(f, fs->nr_value, fs->value, "USERNAME");
	password=form_getvalue(f, fs->nr_value, fs->value, "PASSWORD");
	email=form_getvalue(f, fs->nr_value, fs->value, "EMAIL");

	DEBUG("%s:create account: '%s'\n", cl->sh->name, username);

	if(user_exists(username)) {
		telnetclient_puts(cl, mud_config.msg_userexists);
		return;
	}

	u=user_create(username, password, email);
	if(!u) {
		telnetclient_printf(cl, "Could not create user named '%s'\n", username);
		return;
	}
	user_free(u);

	telnetclient_puts(cl, mud_config.msg_usercreatesuccess);

	TODO("for approvable based systems, disconnect the user with a friendly message");
	telnetclient_start_menuinput(cl, &gamemenu_login);
}

static void form_start(void *p, long unused2 UNUSED, void *form) {
	struct telnetclient *cl=p;
	struct form *f=form;
	struct form_state *fs=&cl->state.form;

	telnetclient_clear_statedata(cl); /* this is a fresh state */

	if(!mud_config.newuser_allowed) {
		/* currently not accepting applications */
		telnetclient_puts(cl, mud_config.msgfile_newuser_deny);
		telnetclient_start_menuinput(cl, &gamemenu_login);
		return;
	}

	if(f->message)
		telnetclient_puts(cl, f->message);

	cl->state_free=form_state_free;
	fs->form=f;
	fs->curritem=LIST_TOP(f->items);
	fs->nr_value=f->item_count;
	fs->value=calloc(fs->nr_value, sizeof *fs->value);

	menu_titledraw(cl, f->form_title, strlen(f->form_title));

	telnetclient_puts(cl, fs->curritem->description);
	telnetclient_start_lineinput(cl, form_lineinput, fs->curritem->prompt);
}

static void form_createaccount_start(void *p, long unused2 UNUSED, void *unused3 UNUSED) {
	form_start(p, 0, form_newuser_app);
}

EXPORT struct form *form_load(const char *buf, void (*form_close)(struct telnetclient *cl, struct form_state *fs)) {
	const char *p, *tmp;
	char *name, *prompt, *description, *title;
	struct form *f;
	struct util_strfile h;
	size_t e, len;

	name=0;
	prompt=0;
	description=0;
	f=0;

	util_strfile_open(&h, buf);

	p=util_strfile_readline(&h, &len);
	if(!p) {
		ERROR_MSG("Could not parse form.");
		goto failure;
	}
	title=malloc(len+1);
	memcpy(title, p, len);
	title[len]=0;

	f=calloc(1, sizeof *f);
	form_init(f, title, form_close);

	free(title);
	title=NULL;

	/* count number of entries */
	while(1) {

		/* look for the name */
		do {
			p=util_strfile_readline(&h, &len);
			if(!p)
				goto done;
			while(isspace(*p)) p++ ; /* skip leading blanks and blank lines */
			for(e=0;e<len && !isspace(p[e]);e++) ;
		} while(!e);
		/* found a word */
		name=malloc(e+1);
		memcpy(name, p, e);
		name[e]=0;

		/* look for the prompt */
		p=util_strfile_readline(&h, &len);
		if(!p) break;
		prompt=malloc(len+1);
		memcpy(prompt, p, len);
		prompt[len]=0;

		/* find end of description */
		tmp=strstr(h.buf, "\n~");
		if(!tmp)
			tmp=strlen(h.buf)+h.buf;
		else
			tmp++;

		len=tmp-h.buf;
		description=malloc(len+1);
		memcpy(description, h.buf, len);
		description[len]=0;
		h.buf=*tmp?tmp+1:tmp;

		DEBUG("name='%s'\n", name);
		DEBUG("prompt='%s'\n", prompt);
		DEBUG("description='%s'\n", description);
		form_additem(f, 0, name, prompt, description, NULL);
		free(name);
		name=0;
		free(prompt);
		prompt=0;
		free(description);
		description=0;
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
	if(f) {
		form_free(f);
	}
	return NULL;
}

EXPORT struct form *form_load_from_file(const char *filename, void (*form_close)(struct telnetclient *cl, struct form_state *fs)) {
	struct form *ret;
	char *buf;

	buf=util_textfile_load(filename);
	if(!buf) return 0;
	ret=form_load(buf, form_close);
	free(buf);
	return ret;
}

EXPORT int form_module_init(void) {
	struct formitem *fi;

	form_newuser_app=form_load_from_file("newuser.form", form_createaccount_close);
	if(!form_newuser_app) {
		ERROR_MSG("could not load newuser.form");
		return 0; /* failure */
	}

	fi=form_getitem(form_newuser_app, "USERNAME");
	if(!fi) {
		ERROR_MSG("newuser.form does not have a USERNAME field.");
		return 0; /* failure */
	}
	fi->form_check=form_createaccount_username_check;

	fi=form_getitem(form_newuser_app, "PASSWORD");
	if(!fi) {
		ERROR_MSG("newuser.form does not have a PASSWORD field.");
		return 0; /* failure */
	}
	fi->flags|=1; /* hidden */

	return 1;
}

EXPORT void form_module_shutdown(void) {
	form_free(form_newuser_app);
	free(form_newuser_app);
	form_newuser_app=NULL;
}

/******************************************************************************
 * Game - game logic
 ******************************************************************************/
EXPORT int game_init(void) {

	/* The login menu */
	menu_create(&gamemenu_login, "Login Menu");

	menu_additem(&gamemenu_login, 'L', "Login", login_username_start, 0, NULL);
	menu_additem(&gamemenu_login, 'N', "New User", form_createaccount_start, 0, NULL);
	menu_additem(&gamemenu_login, 'Q', "Disconnect", signoff, 0, NULL);

	menu_create(&gamemenu_main, "Main Menu");
	menu_additem(&gamemenu_main, 'E', "Enter the game", command_start, 0, NULL);
	// menu_additem(&gamemenu_main, 'C', "Create Character", form_start, 0, &character_form);
	menu_additem(&gamemenu_main, 'B', "Back to login menu", menu_start, 0, &gamemenu_login);
	menu_additem(&gamemenu_main, 'Q', "Disconnect", signoff, 0, NULL);
	return 1;
}

/******************************************************************************
 * Mud Config
 ******************************************************************************/
static int fl_default_family=0;

static int do_config_prompt(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value) {
	char **target;
	size_t len;

	if(!strcmp(id, "prompt.menu")) {
		target=&mud_config.menu_prompt;
	} else if(!strcmp(id, "prompt.form")) {
		target=&mud_config.form_prompt;
	} else if(!strcmp(id, "prompt.command")) {
		target=&mud_config.command_prompt;
	} else {
		ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
		return 1; /* failure - continue looking for matches */
	}

	free(*target);
	len=strlen(value)+2; /* leave room for a space */
	*target=malloc(len);
	snprintf(*target, len, "%s ", value);
	return 0; /* success - terminate the callback chain */
}

static int do_config_msg(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value) {
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

	for(i=0;i<NR(info);i++) {
		if(!strcmp(id, info[i].id)) {
			free(*info[i].target);
			len=strlen(value)+2; /* leave room for a newline */
			*info[i].target=malloc(len);
			snprintf(*info[i].target, len, "%s\n", value);
			return 0; /* success - terminate the callback chain */
		}
	}
	ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
	return 1; /* failure - continue looking for matches */
}

static int do_config_msgfile(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value) {
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

	for(i=0;i<NR(info);i++) {
		if(!strcmp(id, info[i].id)) {
			free(*info[i].target);
			*info[i].target=util_textfile_load(value);

			/* if we could not load the file, install a fake message */
			if(!*info[i].target) {
				char buf[128];
				snprintf(buf, sizeof buf, "<<fileNotFound:%s>>\n", value);
				*info[i].target=strdup(buf);
			}
			return 0; /* success - terminate the callback chain */
		}
	}
	ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
	return 1; /* failure - continue looking for matches */
}

static int do_config_string(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value) {
	char **target=extra;
	assert(value != NULL);
	assert(target != NULL);

	free(*target);
	*target=strdup(value);
	return 0; /* success - terminate the callback chain */
}

/* handles the 'server.port' property */
static int do_config_port(struct config *cfg UNUSED, void *extra UNUSED, const char *id, const char *value) {
	if(!socketio_listen(fl_default_family, SOCK_STREAM, NULL, value, telnetclient_new_event)) {
		ERROR_FMT("problem with config option '%s' = '%s'\n", id, value);
		return 1; /* failure - continue looking for matches */
	}
	return 0; /* success - terminate the callback chain */
}

static int do_config_uint(struct config *cfg UNUSED, void *extra, const char *id UNUSED, const char *value) {
	char *endptr;
	unsigned *uint_p=extra;
	assert(extra != NULL);
	if(!extra) return -1; /* error */

	if(!*value) {
		DEBUG_MSG("Empty string");
		return -1; /* error - empty string */
	}
	*uint_p=strtoul(value, &endptr, 0);

	if(*endptr!=0) {
		DEBUG_MSG("Not a number");
		return -1; /* error - empty string */
	}

	return 0; /* success - terminate the callback chain */
}

EXPORT void mud_config_init(void) {
	mud_config.config_filename=strdup("boris.cfg");
	mud_config.menu_prompt=strdup("Selection: ");
	mud_config.form_prompt=strdup("Selection: ");
	mud_config.command_prompt=strdup("> ");
	mud_config.msg_errormain=strdup("ERROR: going back to main menu!\n");
	mud_config.msg_invalidselection=strdup("Invalid selection!\n");
	mud_config.msg_invalidusername=strdup("Invalid username\n");
	mud_config.msgfile_noaccount=strdup("\nInvalid password or account not found!\n\n");
	mud_config.msgfile_badpassword=strdup("\nInvalid password or account not found!\n\n");
	mud_config.msg_tryagain=strdup("Try again!\n");
	mud_config.msg_unsupported=strdup("Not supported!\n");
	mud_config.msg_useralphanumeric=strdup("Username must only contain alphanumeric characters and must start with a letter!\n");
	mud_config.msg_usercreatesuccess=strdup("Account successfully created!\n");
	mud_config.msg_userexists=strdup("Username already exists!\n");
	mud_config.msg_usermin3=strdup("Username must contain at least 3 characters!\n");
	mud_config.msg_invalidcommand=strdup("Invalid command!\n");
	mud_config.msgfile_welcome=strdup("Welcome\n\n");
	mud_config.newuser_level=5;
	mud_config.newuser_flags=0;
	mud_config.newuser_allowed=0;
	mud_config.eventlog_filename=strdup("boris.log\n");
	mud_config.eventlog_timeformat=strdup("%y%m%d-%H%M"); /* another good one: %Y.%j-%H%M */
	mud_config.msgfile_newuser_create=strdup("\nPlease enter only correct information in this application.\n\n");
	mud_config.msgfile_newuser_deny=strdup("\nNot accepting new user applications!\n\n");
	mud_config.default_channels=strdup("@system,@wiz,OOC,auction,chat,newbie");
}

EXPORT void mud_config_shutdown(void) {
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
	};
	unsigned i;
	for(i=0;i<NR(targets);i++) {
		free(*targets[i]);
		*targets[i]=NULL;
	}
}

EXPORT int mud_config_process(void) {
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
#if !defined(NDEBUG) && !defined(NTEST)
	config_watch(&cfg, "*", config_test_show, 0);
#endif
	if(!config_load(mud_config.config_filename, &cfg)) {
		config_free(&cfg);
		return 0; /* failure */
	}
	config_free(&cfg);
	return 1; /* success */
}

/******************************************************************************
 * Main - Option parsing and initialization
 ******************************************************************************/
static sig_atomic_t keep_going_fl=1;

/* signal handler - this causes the main loop to terminated */
static void sh_quit(int s UNUSED) {
	keep_going_fl=0;
}

static void usage(void) {
	fprintf(stderr,
		"usage: boris [-h46] [-p port]\n"
		"-4      use IPv4-only server addresses\n"
		"-6      use IPv6-only server addresses\n"
		"-h      help\n"
	);
	exit(EXIT_FAILURE);
}

/* exits if next_arg is NULL */
static void need_parameter(int ch, const char *next_arg) {
	if(!next_arg) {
		ERROR_FMT("option -%c takes a parameter\n", ch);
		usage();
	}
}

static int process_flag(int ch, const char *next_arg) {
	switch(ch) {
		case '4':
			fl_default_family=AF_INET; /* default to IPv4 */
			return 0;
		case '6':
			fl_default_family=AF_INET6; /* default to IPv6 */
			return 0;
		case 'c':
			need_parameter(ch, next_arg);
			free(mud_config.config_filename);
			mud_config.config_filename=strdup(next_arg);
			return 1; /* uses next arg */
		case 'p':
			need_parameter(ch, next_arg);
			if(!socketio_listen(fl_default_family, SOCK_STREAM, NULL, next_arg, telnetclient_new_event)) {
				usage();
			}
			return 1; /* uses next arg */
		default:
			ERROR_FMT("Unknown option -%c\n", ch);
		case 'h':
			usage();
	}
	return 0; /* didn't use next_arg */
}

/* process all arguments */
static void process_args(int argc, char **argv) {
	int i, j;

	for(i=1;i<argc;i++) {
		if(argv[i][0]=='-') {
			for(j=1;argv[i][j];j++) {
				if(process_flag(argv[i][j], (i+1)<argc ? argv[i+1] : NULL)) {
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

int main(int argc, char **argv) {
	signal(SIGINT, sh_quit);
	signal(SIGTERM, sh_quit);

#ifndef NTEST
	ieee754_test();
	acs_test();
	map_test();
	config_test();
	bitmap_test();
	freelist_test();
	heapqueue_test();
	xxtcrypt_test();
#endif

	srand((unsigned)time(NULL));

	if(mkdir("data", 0777)==-1 && errno!=EEXIST) {
		PERROR("data/");
		return EXIT_FAILURE;
	}

	if(!socketio_init()) {
		return EXIT_FAILURE;
	}
	atexit(socketio_shutdown);

	/* load default configuration into mud_config global */
	mud_config_init();
	atexit(mud_config_shutdown);

	/* parse options and load into mud_config global */
	process_args(argc, argv);

	/* process configuration file and load into mud_config global */
	if(!mud_config_process()) {
		ERROR_MSG("could not load configuration");
		return EXIT_FAILURE;
	}

	if(!eventlog_init()) {
		return EXIT_FAILURE;
	}
	atexit(eventlog_shutdown);

	if(!channel_module_init()) {
		return EXIT_FAILURE;
	}

	if(!user_init()) {
		ERROR_MSG("could not initialize users");
		return EXIT_FAILURE;
	}
	atexit(user_shutdown);

	if(!form_module_init()) {
		ERROR_MSG("could not initialize forms");
		return EXIT_FAILURE;
	}
	atexit(form_module_shutdown);

	if(!game_init()) {
		ERROR_MSG("could not start game");
		return EXIT_FAILURE;
	}

	eventlog_server_startup();

	TODO("use the next event for the timer");
	while(keep_going_fl) {
		telnetclient_prompt_refresh_all();
		if(!socketio_dispatch(-1))
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
