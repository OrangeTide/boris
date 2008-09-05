/* boris.c :
 * example of a very tiny MUD
 */

/******************************************************************************
 * Design Documentation
 *
 * components:
 * 	recordcache - loads records into memory and caches them
 * 	bidb - low level file access fuctions. manages blocks for recordcache
 * 	object_base - a generic object type
 * 	object_xxx - free/load/save routines for objects
 * 	bitmap - manages large bitmaps
 * 	bitfield - manages small staticly sized bitmaps
 * 	freelist - allocate ranges of numbers from a pool
 * 	socketio - manages network sockets
 *
 * dependency:
 *  recordcache - uses bitfield to track dirty blocks
 *  bidb - uses freelist to track free blocks
 *  records - uses freelist to track record numbers (reserve first 100 records)
 *  clients - uses ref counts to determine when to free linked lists items
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
 * 	base - the following types of objects are defined:
 * 		room
 * 		mob
 * 		item
 * 	instance - all instances are the same structure:
 * 		id - object id
 * 		count - all item instances are stackable 1 to 256.
 * 		flags - 24 status flags [A-HJ-KM-Z]
 * 		extra1..extra2 - control values that can be variable
 *
 * containers:
 * 	instance parameter holds a id that holds an array of up to 64 objects.
 *
 * database saves the following types of blobs:
 * 	player account
 * 	room object
 * 	mob object (also used for characters)
 * 	item object
 * 	instances
 * 	container slots
 * 	help text
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

/* database file */
#define BIDB_FILE "boris.bidb"

#define BIDB_DEFAULT_MAX_RECORDS 131072
#define BIDB_MAX_BLOCKS 4194304
#define BIDB_GROW_BLOCKS 256 /* number of blocks to grow by */

/******************************************************************************
 * Headers
 ******************************************************************************/

#include <assert.h>
#include <inttypes.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/******************************************************************************
 * Macros
 ******************************************************************************/

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
#if 0
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

/* ReaD Big-Endian 16-bit value */
#define RD_BE16(src, offset) (((src)[offset]*256)|(src)[(offset)+1])

/* ReaD Big-Endian 32-bit value */
#define RD_BE32(src, offset) (((src)[offset]*16777216L)|((src)[(offset)+1]*65536L)|((src)[(offset)+2]*256)|(src)[(offset)+3])

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
#if defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 199901L)
# define VERBOSE(...) fprintf(stderr, __VA_ARGS__)
# ifdef NDEBUG
#  define DEBUG(...) /* DEBUG disabled */
# else
#  define DEBUG(...) fprintf(stderr, __VA_ARGS__)
# endif
# ifdef NTRACE
#  define TRACE(...) /* TRACE disabled */
# else
#  define TRACE(...) fprintf(stderr, __VA_ARGS__)
# endif
#else
/* TODO: prepare a solution for C89 */
# error Requires C99.
#endif
#define TRACE_ENTER() TRACE("%s():%u:ENTER\n", __func__, __LINE__);
#define TRACE_EXIT() TRACE("%s():%u:EXIT\n", __func__, __LINE__);
#define FAILON(e, reason, label) if(e) { fprintf(stderr, "FAILED:%s:%s\n", reason, strerror(errno)); goto label; } } while(0)

/*=* reference counting macros *=*/
#define REFCOUNT_TYPE int
#define REFCOUNT_NAME _referencecount
#define REFCOUNT_INIT(obj) ((obj)->REFCOUNT_NAME=0)
#define REFCOUNT_TAKE(obj) ((obj)->REFCOUNT_NAME++)
#define REFCOUNT_PUT(obj, free_func) do { \
		assert((obj)->REFCOUNT_NAME>0); \
		if(--(obj)->REFCOUNT_NAME<=0) \
			free_func((obj)); \
	} while(0)

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

/******************************************************************************
 * Types and data structures
 ******************************************************************************/
typedef long bidb_blockofs_t;

struct lru_entry {
	void (*free)(void *p);	/* function to free the item */
	void *data;
	LIST_ENTRY(struct lru_entry) queue;
};

struct bidb_extent {
	unsigned length, offset; /* both are in block-sized units */
};

/******************************************************************************
 * Globals
 ******************************************************************************/

/******************************************************************************
 * Prototypes
 ******************************************************************************/

/******************************************************************************
 * Debug routines
 ******************************************************************************/
#ifndef NDEBUG
static const char *convert_number(unsigned n, unsigned base, unsigned pad) {
	static char number_buffer[65];
	static char tab[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-";
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

#endif

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

struct freelist_entry {
	LIST_ENTRY(struct freelist_entry) global; /* global list */
	LIST_ENTRY(struct freelist_entry) bucket; /* bucket list */
	struct bidb_extent extent;
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
	ret=count/(fl->nr_buckets-1);
	if(ret>=fl->nr_buckets) {
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
	memset(e, 0x99, sizeof *e);
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
		perror("malloc()");
		return 0;
	}
	new->extent.offset=ofs;
	new->extent.length=count;
	LIST_ENTRY_INIT(new, bucket);
	LIST_INSERT_ATPTR(prev, new, global);
	return new;
}

/* returns true if a bridge is detected */
static int freelist_ll_isbridge(struct bidb_extent *prev_ext, unsigned ofs, unsigned count, struct bidb_extent *next_ext) {
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
	/* TODO: prioritize the order of the check. 1. exact size, 2. double size 3. ? */
	for(;bucketnr<=FREELIST_OVERFLOW_BUCKET(fl);bucketnr++) {
		assert(bucketnr<=FREELIST_OVERFLOW_BUCKET(fl));
		assert(bucketptr!=NULL);

		if(*bucketptr) { /* found an entry*/
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
			fprintf(stderr, "overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
			abort(); /* TODO: make something out of this */
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
				fprintf(stderr, "overlap detected in freelist %p at %u+%u!\n", (void*)fl, ofs, count);
				abort(); /* TODO: make something out of this */
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

#ifndef NDEBUG
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
		TRACE("alloc: %u+%u\n", ofs, 6);
	}

	freelist_dump(&fl);

	fprintf(stderr, "::: Allocating :::\n");
	for(n=0;n<60;n+=6) {
		long ofs;
		ofs=freelist_alloc(&fl, 6);
		TRACE("alloc: %u+%u\n", ofs, 6);
	}

	freelist_dump(&fl);

	freelist_free(&fl);
}
#endif

/******************************************************************************
 * Hashing Functions
 ******************************************************************************/

/* creates a 32-bit hash of a null terminated string */
static uint_least32_t hash_string32(const char *key) {
	uint_least32_t h=0;

	while(*key) {
		h=h*65599+*key++;
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+*key++;
		 */
	}
	return h;
}

/* creates a 32-bit hash of a blob of memory */
static uint_least32_t hash_mem32(const char *key, size_t len) {
	uint_least32_t h=0;

	while(len>0) {
		h=h*65599+*key++;
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+*key++;
		 */
		len--;
	}
	return h;
}

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
#endif

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
		perror("realloc()");
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

	len=bitmap->bitmap_allocbits/BITMAP_BITSIZE;
	/* TODO: check the head */
	for(i=ofs/BITMAP_BITSIZE;i<len;i++) {
		if(bitmap->bitmap[i]!=0) {
			/* found a set bit - scan the word to find the position */
			for(bofs=0;((bitmap->bitmap[i]>>bofs)&1)==0;bofs++) ;
			return i*BITMAP_BITSIZE+bofs;
		}
	}
	/* TODO: check the tail */
	return -1; /* outside of the range */
}

/* return the position of the next set bit
 * -1 if the end of the bits was reached */
EXPORT int bitmap_next_clear(struct bitmap *bitmap, unsigned ofs) {
	unsigned i, len, bofs;

	len=bitmap->bitmap_allocbits/BITMAP_BITSIZE;
	/* TODO: check the head */
	for(i=ofs/BITMAP_BITSIZE;i<len;i++) {
		if(bitmap->bitmap[i]!=~0U) {
			/* found a set bit - scan the word to find the position */
			for(bofs=0;((bitmap->bitmap[i]>>bofs)&1)==1;bofs++) ;
			return i*BITMAP_BITSIZE+bofs;
		}
	}
	/* TODO: check the tail */
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
 * Record Cacheing - look up records and automatically load them
 ******************************************************************************/

struct recordcache_entry {
	unsigned id;
	struct lru_entry lru; /* if data is not NULL, then the data is loaded */
};

static struct recordcache_entry **recordcache_table;
static size_t recordcache_table_nr, recordcache_table_mask;

/* rounds up 0 to 1 */
static size_t roundup2(size_t val) {
	size_t n;
	for(n=1;n<val;n<<=1) ;
	return n;
}

EXPORT int recordcache_init(unsigned max_entries) {
	struct recordcache_entry **tmp;
	assert(recordcache_table==NULL);
	if(recordcache_table) {
		fprintf(stderr, "hash table already initialized\n");
		return 0; /* failure */
	}
	max_entries=roundup2(max_entries);
	tmp=calloc(sizeof *tmp, max_entries);
	if(!tmp) {
		perror("malloc()");
		return 0; /* failure */
	}
	recordcache_table=tmp;
	recordcache_table_nr=max_entries;
	recordcache_table_mask=recordcache_table_nr-1;
	DEBUG("hash table size is %zu\n", recordcache_table_nr);
	return 1;
}

/******************************************************************************
 * Binary Database
 ******************************************************************************/

/*
 * Binary database
 * ===============
 * block size=1024. everything is in multiples of a block
 *
 * extents are 32-bits values. 22-bit offset, 10-bit length
 *
 * extent length is 1 to 1024. (0 is not a valid encoding)
 *
 * [ON-DISK]
 *
 * superblock
 * 	magic
 * 	record table extents [16]
 *
 * record table
 * 	record extent [n]
 *
 * [IN-MEMORY]
 *
 * max records
 * record table extents
 * hash table for id to extent
 * freelist
 * block bitmap
 *
 * [TYPES OF RECORDS]
 *
 * object_base/object_mob/object_item/object_room
 * sparse integer to record number table
 * string to record number table
 * sparse record number to string table
 *
 */

#define BIDB_BLOCK_SZ 1024
#define BIDB_SUPERBLOCK_SZ	1 /* size in blocks */

/* macros for manipulating extent descriptors */
#define BIDB_EXTENT_LENGTH_BITS 10U
#define BIDB_EXTENT_OFFSET_BITS (32U-BIDB_EXTENT_LENGTH_BITS)
#define BIDB_EXTENT(o,l) (((o)<<BIDB_EXTENT_LENGTH_BITS)|((l)-1))
#define BIDB_EXTENT_NONE 0U		/* this value means at block 0 you must be at least 2 blocks long */
#define BIDB_EXTENT_LENGTH(e)	(((e)&((1<<BIDB_EXTENT_LENGTH_BITS)-1))+1)
#define BIDB_EXTENT_OFFSET(e)	((uint_least32_t)(e)>>BIDB_EXTENT_LENGTH_BITS)
/* an extent is a 32 bit value */
#define BIDB_EXTENTPTR_SZ (32/CHAR_BIT)
/* size of a record pointer (1 extent) */
#define BIDB_RECPTR_SZ BIDB_EXTENTPTR_SZ
#define BIDB_RECORDS_PER_BLOCK (BIDB_BLOCK_SZ/BIDB_RECPTR_SZ)
#define BIDB_RECORDS_PER_EXTENT (BIDB_RECORDS_PER_BLOCK<<BIDB_EXTENT_LENGTH_BITS)

static struct {
	struct bidb_extent record_extents[16];
	unsigned record_dirty_blocks[BITFIELD(16<<BIDB_EXTENT_LENGTH_BITS,unsigned)]; /* one bit per block - 2Kbyte of bits total */
	unsigned record_max, block_max;
	struct bidb_stats {
		unsigned records_used;
	} stats;
	struct freelist freelist;
	FILE *file;
	char *filename;
} bidb_superblock;

EXPORT void bidb_close(void) {
#ifndef NDEBUG
	freelist_dump(&bidb_superblock.freelist);
#endif
	freelist_free(&bidb_superblock.freelist);
	if(bidb_superblock.file) {
		fclose(bidb_superblock.file);
		bidb_superblock.file=0;
	}
	free(bidb_superblock.filename);
	bidb_superblock.filename=0;
}

/* block_offset starts AFTER superblock */
static int bidb_read_blocks(unsigned char *data, bidb_blockofs_t block_offset, unsigned block_count) {
	size_t res;
	if(fseek(bidb_superblock.file, (block_offset+BIDB_SUPERBLOCK_SZ)*BIDB_BLOCK_SZ, SEEK_SET)) {
		perror(bidb_superblock.filename);
		return 0; /* failure */
	}
	res=fread(data, BIDB_BLOCK_SZ, block_count, bidb_superblock.file);
	if(res!=block_count) {
		if(ferror(bidb_superblock.file)) {
			perror(bidb_superblock.filename);
		}
		return 0; /* failure */
	}
	return 1; /* success */
}

/* block_offset starts AFTER superblock */
static int bidb_write_blocks(const unsigned char *data, bidb_blockofs_t block_offset, unsigned block_count) {
	size_t res;

	if(fseek(bidb_superblock.file, (block_offset+BIDB_SUPERBLOCK_SZ)*BIDB_BLOCK_SZ, SEEK_SET)) {
		perror(bidb_superblock.filename);
		return 0; /* failure */
	}
	res=fwrite(data, BIDB_BLOCK_SZ, block_count, bidb_superblock.file);
	if(res!=block_count) {
		if(ferror(bidb_superblock.file)) {
			perror(bidb_superblock.filename);
		}
		return 0; /* failure */
	}
	return 1; /* success */
}

static struct bidb_extent bidb_allocblocks(unsigned nr_blocks) {
	struct bidb_extent ret;
	long ofs;
	unsigned newlen;

	assert(nr_blocks>0);
	ofs=freelist_alloc(&bidb_superblock.freelist, nr_blocks);
	if(ofs==-1) {
		/* grow */
		if(BIDB_GROW_BLOCKS<nr_blocks) {
			newlen=bidb_superblock.block_max+nr_blocks+BIDB_GROW_BLOCKS;
		} else {
			newlen=bidb_superblock.block_max+BIDB_GROW_BLOCKS;
		}
		fprintf(stderr, "%s:growing file to %u blocks from %u blocks maximum.\n", bidb_superblock.filename, newlen, bidb_superblock.block_max);
		freelist_pool(&bidb_superblock.freelist, bidb_superblock.block_max, newlen-bidb_superblock.block_max);
		bidb_superblock.block_max=newlen;
		ofs=freelist_alloc(&bidb_superblock.freelist, nr_blocks);
		assert(ofs!=-1);
	}
	ret.offset=ofs;
	ret.length=nr_blocks;
	return ret;
}

/* check extent to see if it is in range of nr_blocks */
static int bidb_check_extent(struct bidb_extent *e, unsigned nr_blocks) {
	unsigned end;
	assert(e!=NULL);
	if(!e)
		return 1; /* ignore */
	if(e->length==0) {
		return 1; /* zero length extents don't exist */
	}
	end=(e->length+e->offset); /* end is last+1 */
	DEBUG("end:%u blocks:%u\n", end, nr_blocks);
	return (end<=nr_blocks);
}

static int bidb_load_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ*BIDB_SUPERBLOCK_SZ];
	uint_least32_t tmp;
	unsigned i, total_record_length;
	long filesize;
	int empty_fl;

	/* get the file size and check it */
	fseek(bidb_superblock.file, 0, SEEK_END);
	filesize=ftell(bidb_superblock.file);
	if((filesize%BIDB_BLOCK_SZ)!=0) {
		fprintf(stderr, "%s:database file is not a multiple of %u bytes\n", bidb_superblock.filename, BIDB_BLOCK_SZ);
		return 0;
	}
	bidb_superblock.block_max=filesize/BIDB_BLOCK_SZ;
	if(bidb_superblock.block_max>0) {
		bidb_superblock.block_max--; /* do not count the superblock */
	}

	if(bidb_read_blocks(data, -BIDB_SUPERBLOCK_SZ, BIDB_SUPERBLOCK_SZ)) {
		if(memcmp("BiDB", data, 4)) {
			fprintf(stderr, "%s:not a data file\n", bidb_superblock.filename);
			return 0; /* failure : invalid magic */
		}
		bidb_superblock.stats.records_used=0;

		memset(&bidb_superblock.record_dirty_blocks, 0, sizeof bidb_superblock.record_dirty_blocks);

		for(i=0,total_record_length=0;i<NR(bidb_superblock.record_extents);i++) {
			tmp=RD_BE32(data, 4+4*i);

			if(tmp==BIDB_EXTENT_NONE) { /* empty extent */
				bidb_superblock.record_extents[i].offset=0;
				bidb_superblock.record_extents[i].length=0;
			} else {
				bidb_superblock.record_extents[i].offset=BIDB_EXTENT_OFFSET(tmp);
				bidb_superblock.record_extents[i].length=BIDB_EXTENT_LENGTH(tmp);
			}
			total_record_length+=bidb_superblock.record_extents[i].length;
		}
		bidb_superblock.record_max=BIDB_BLOCK_SZ/BIDB_RECPTR_SZ*total_record_length;

		/** sanity checks **/

		for(i=0, empty_fl=0;i<NR(bidb_superblock.record_extents);i++) {
			if(bidb_superblock.record_extents[i].length==0) { /* empty extent */
				empty_fl=1;
			} else if(empty_fl) {
				fprintf(stderr, "%s:record table extent list has holes in it\n", bidb_superblock.filename);
				return 0;
			}
		}

		for(i=0;i<NR(bidb_superblock.record_extents);i++) {
			if(!bidb_check_extent(&bidb_superblock.record_extents[i], filesize/(unsigned)BIDB_BLOCK_SZ-BIDB_SUPERBLOCK_SZ)) {
				fprintf(stderr, "%s:record table %u extent exceeds file size\n", bidb_superblock.filename, i);
				return 0;
			}
		}

		return 1; /* success */
	}
	fprintf(stderr, "%s:could not load superblock\n", bidb_superblock.filename);
	return 0; /* failure : could not read superblock */
}

static int bidb_save_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	uint_least32_t tmp;
	unsigned i;

	fprintf(stderr, "%s:saving superblock\n", bidb_superblock.filename);

	memset(data, 0, sizeof data);
	memcpy(data, "BiDB", 4);

	for(i=0;i<NR(bidb_superblock.record_extents);i++) {
		if(bidb_superblock.record_extents[i].length==0) { /* empty extent */
			tmp=BIDB_EXTENT_NONE;
		} else {
			tmp=BIDB_EXTENT(bidb_superblock.record_extents[i].offset, bidb_superblock.record_extents[i].length);
		}
		WR_BE32(data, 4+4*i, tmp);
	}

	if(!bidb_write_blocks(data, -BIDB_SUPERBLOCK_SZ, 1)) {
		fprintf(stderr, "%s:could not write superblock\n", bidb_superblock.filename);
		return 0; /* failure */
	}
	return 1; /* success */
}

static int bidb_save_record_table(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	unsigned i, j, ofs;
	fprintf(stderr, "Saving record table\n");
	/* uses bitarray to save only blocks with dirty entries */
	for(i=0,ofs=0;i<NR(bidb_superblock.record_extents);i++) {
		for(j=0;j<bidb_superblock.record_extents[i].length;j++,ofs++) {
			if(BITTEST(bidb_superblock.record_dirty_blocks, ofs)) {
				/*
				DEBUG("%s:writing record block %d\n", bidb_superblock.filename, ofs);
				*/
				BITCLR(bidb_superblock.record_dirty_blocks, ofs);
				memset(data, 0, sizeof data); /* TODO: fill with record data */
				if(!bidb_write_blocks(data, (signed)(bidb_superblock.record_extents[i].offset+j), 1)) {
					DEBUG("%s:could not write record table\n", bidb_superblock.filename);
					return 0; /* failure */
				}
			}
		}
	}
	return 1;
}

static int bidb_create_record_table(void) {
	unsigned i, total, extentblks;
	assert(bidb_superblock.record_extents[0].offset==0); /* only safe to call if we have no table */

	/* create the record table on disk */
	fprintf(stderr, "Creating new record table\n");

	bidb_superblock.record_max=BIDB_DEFAULT_MAX_RECORDS;

	/* create all the extents necessary */
	for(i=0,total=0;i<NR(bidb_superblock.record_extents) && total<bidb_superblock.record_max;i++, total++) {
		extentblks=ROUNDUP((bidb_superblock.record_max-total)*BIDB_RECPTR_SZ, BIDB_BLOCK_SZ)/BIDB_BLOCK_SZ;
		if(extentblks>1U<<(BIDB_EXTENT_LENGTH_BITS)) {
			extentblks=1<<BIDB_EXTENT_LENGTH_BITS;
		}

		bidb_superblock.record_extents[i]=bidb_allocblocks(extentblks);

		DEBUG("%s:Record table allocating extent #%u @ %u+%u\n", bidb_superblock.filename, i, bidb_superblock.record_extents[i].offset, bidb_superblock.record_extents[i].length);

		total+=extentblks*BIDB_RECORDS_PER_BLOCK;
	}

	/* mark all the blocks for these new extents as dirty */
	for(i=0;i<bidb_superblock.record_max/BIDB_RECORDS_PER_BLOCK;i++) {
		BITSET(bidb_superblock.record_dirty_blocks, i);
	}

	bidb_save_record_table();

	/* updated the superblock with the record table */
	if(!bidb_save_superblock()) {
		bidb_close();
		return 0; /* failure */
	}

	return 1; /* success */
}

/* load a record table form disk */
static int bidb_load_record_table(void) {
	if(!recordcache_init(bidb_superblock.record_max)) {
		fprintf(stderr, "%s:could not initialize record table\n", bidb_superblock.filename);
		return 0;
	}
	if(bidb_superblock.record_extents[0].length==0) { /* no record table found .. create it */
		if(!bidb_create_record_table()) {
			return 0;
		}
	} else {
		/* TODO: read in record table entries */
		/* TODO: reserve entries */
	}
	return 1; /* */
}

/* mark a record as dirty due to modification */
EXPORT void bidb_record_dirty(unsigned record_number) {
	unsigned blknum;

	blknum=record_number/BIDB_RECORDS_PER_BLOCK;

	if(!BITRANGE(bidb_superblock.record_dirty_blocks, blknum)) {
		fprintf(stderr, "%s:Dirty block %u not in range!\n", bidb_superblock.filename, blknum);
		return;
	}

	DEBUG("%s:Dirty block %u\n", bidb_superblock.filename, blknum);
	BITSET(bidb_superblock.record_dirty_blocks, blknum);
}

/* create_fl will create if the superblock does not exist */
EXPORT int bidb_open(const char *filename) {
	int create_fl=0;
	if(bidb_superblock.file)
		bidb_close();
	bidb_superblock.file=fopen(filename, "r+b");
	if(!bidb_superblock.file) {
		fprintf(stderr, "%s:creating a new file\n", filename);
		bidb_superblock.file=fopen(filename, "w+b");
		if(!bidb_superblock.file) {
			perror(filename);
			return 0; /* failure */
		}
		create_fl=1;
	}
	bidb_superblock.filename=strdup(filename);

	if(create_fl) {
		fprintf(stderr, "%s:creating new superblock\n", bidb_superblock.filename);
		bidb_superblock.stats.records_used=0;
		bidb_superblock.record_max=0;
		bidb_superblock.block_max=0;
		if(!bidb_save_superblock()) {
			bidb_close();
			return 0; /* failure */
		}
	}

	if(!bidb_load_superblock()) {
		bidb_close();
		return 0; /* failure */
	}

	freelist_init(&bidb_superblock.freelist, 1<<BIDB_EXTENT_LENGTH_BITS);
	if(bidb_superblock.block_max>0) {
		freelist_pool(&bidb_superblock.freelist, 0, bidb_superblock.block_max);
	}

	if(!bidb_load_record_table()) {
		fprintf(stderr, "%s:could not load record table\n", bidb_superblock.filename);
		bidb_close();
		return 0; /* failure */
	}
	return 1; /* success */
}

EXPORT void bidb_show_info(void) {
#define BIDB_HIGHEST_RECORD
#define BIDB_HIGHEST_BLOCK
	const uint_least32_t
		max_extent_size=(BIDB_BLOCK_SZ<<BIDB_EXTENT_LENGTH_BITS)-1U,
		records_per_block=BIDB_BLOCK_SZ/BIDB_RECPTR_SZ,
		records_per_extent=records_per_block<<BIDB_EXTENT_LENGTH_BITS,
		max_records=NR(bidb_superblock.record_extents)*records_per_extent;

	printf(
		"BiDB configuration info:\n"
		"  block size: %u bytes\n"
		"  max extent size: %u blocks (%" PRIu32 " bytes)\n"
		"  records per block: %" PRIu32 " records\n"
		"  records per extent: %" PRIu32 " records\n"
		"  number of record extents: %zu extents\n"
		"  max number of record: %" PRIu32 " records\n"
		"  max total size for all records: %" PRIu64 " bytes\n"
		"  max blocks: %lu blocks (%" PRIu64 " bytes)\n",
		BIDB_BLOCK_SZ,
		1<<BIDB_EXTENT_LENGTH_BITS,
		max_extent_size,
		records_per_block,
		records_per_extent,
		NR(bidb_superblock.record_extents),
		max_records,
		(uint_least64_t)max_records<<BIDB_EXTENT_LENGTH_BITS,
		1L<<BIDB_EXTENT_OFFSET_BITS,
		(uint_least64_t)BIDB_BLOCK_SZ<<BIDB_EXTENT_OFFSET_BITS
	);
	printf(
		"  memory bytes for dirty records bitmap: %zu\n",
		sizeof bidb_superblock.record_dirty_blocks
	);
}

/******************************************************************************
 * Objects
 ******************************************************************************/

/* defines an object's class */
struct object_controller {
	char *type_name;		/* identifies the class of record */
	void (*load)(FILE *f);
	void (*save)(FILE *f, void *data);
	void (*free)(void *);			/* for freeing an object */
};

struct object_base {
	unsigned id;
	const struct object_controller *con;
};

struct object_mob {
	struct object_base base;
};

struct object_room {
	struct object_base base;
};

struct object_item {
	struct object_base base;
};

/* converts a mob to a base object */
EXPORT struct object_base *mob_to_base(struct object_mob *mob) {
	assert(mob!=NULL);
	return &mob->base;
}

/* converts a room to a base object */
EXPORT struct object_base *room_to_base(struct object_room *room) {
	assert(room!=NULL);
	return &room->base;
}

/* converts an item to a base object */
EXPORT struct object_base *item_to_base(struct object_item *item) {
	assert(item!=NULL);
	return &item->base;
}

/* frees an object of any type */
EXPORT void object_free(struct object_base *obj) {
	assert(obj!=NULL);
	assert(obj->con!=NULL);
	if(!obj)
		return; /* ignore NULL */
	if(obj->con->free) {
		obj->con->free(obj);
	} else {
		free(obj);
	}
}

/******************************************************************************
 * Object Cache
 ******************************************************************************/

EXPORT struct object_base *object_load(unsigned id) {
	abort();
	return 0;
}

EXPORT struct object_base *object_save(unsigned id) {
	abort();
	return 0;
}

EXPORT struct object_base *object_iscached(unsigned id) {
	abort();
	return 0;
}

/******************************************************************************
 * Socket I/O API
 ******************************************************************************/
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
#if !defined(SOCKET) || !defined(INVALID_SOCKET) || !defined(SOCKET_ERROR)
#define SOCKET int
#define INVALID_SOCKET (-1)
#define SOCKET_ERROR (-1)
#endif
#elif defined(USE_WIN32_SOCKETS)
#include <winsock2.h>
#include <ws2tcpip.h>
#else
#error Must define either USE_BSD_SOCKETS or USE_WIN32_SOCKETS
#endif

#define SOCKETIO_FAILON(e, reason, fail_label) do { if(e) { fprintf(stderr, "ERROR:%s:%s\n", reason, socketio_strerror()); goto fail_label; } } while(0)

struct socketio_server {
	SOCKET fd;
	LIST_ENTRY(struct socketio_server) list;
	char *name;
	REFCOUNT_TYPE REFCOUNT_NAME;
};

struct socketio_client {
	SOCKET fd;
	LIST_ENTRY(struct socketio_client) list;
	char *name;
	REFCOUNT_TYPE REFCOUNT_NAME;
};

static LIST_HEAD(struct socketio_server_list, struct socketio_server) socketio_server_list;
static LIST_HEAD(struct socketio_client_list, struct socketio_client) socketio_client_list;
static fd_set socketio_readfds[2], socketio_writefds[2]; /* ping-pong between fdsets */
static unsigned socketio_fdset; /* selects fdset 0 or 1 */
#if defined(USE_WIN32_SOCKETS)
#define socketio_fdmax 0 /* not used on Win32 */
#else
static SOCKET socketio_fdmax=INVALID_SOCKET; /* used by select() to limit the number of fds to check */
#endif

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
	memset(&socketio_readfds, 0, sizeof socketio_readfds);
	memset(&socketio_writefds, 0, sizeof socketio_writefds);
	return 1;
}

EXPORT void socketio_shutdown(void) {
#if defined(USE_WIN32_SOCKETS)
	WSACleanup();
#endif
}

EXPORT void socketio_close(SOCKET fd) {
#if defined(USE_WIN32_SOCKETS)
	closesocket(fd);
#else
	close(fd);
#endif
}

/* report that an fd is ready for read events, and update the fdmax value */
EXPORT void socketio_readready(SOCKET fd) {
	FD_SET(fd, &socketio_readfds[socketio_fdset]);
#if !defined(USE_WIN32_SOCKETS)
	if(fd>socketio_fdmax) {
		socketio_fdmax=fd;
	}
#endif
}

/* report that an fd is ready for write events, and update the fdmax value */
EXPORT void socketio_writeready(SOCKET fd) {
	FD_SET(fd, &socketio_writefds[socketio_fdset]);
#if !defined(USE_WIN32_SOCKETS)
	if(fd>socketio_fdmax) {
		socketio_fdmax=fd;
	}
#endif
}

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
		fprintf(stderr, "%s():%s\n", __func__, socketio_strerror());
		return 0;
	}
	if(!socketio_sockname((struct sockaddr*)&ss, sslen, name, name_len)) {
		fprintf(stderr, "Failed %s() on fd %d\n", __func__, fd);
		return 0;
	}
	DEBUG("getpeername is %s\n", name);
	return 1;
}

static int socketio_listen_bind(struct addrinfo *ai) {
	SOCKET fd;
	int res;
	char buf[64];
	struct socketio_server *newserv;

	const int yes=1;
	assert(ai!=NULL);
	if(!ai || !ai->ai_addr) {
		fprintf(stderr, "ERROR:empty socket address\n");
		return 0;
	}
	fd=socket(ai->ai_family, ai->ai_socktype, 0);
	SOCKETIO_FAILON(fd==INVALID_SOCKET, "creating socket", failure_clean);

	if(ai->ai_family==AF_INET) {
		SOCKETIO_FAILON(setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, (const void*)&yes, sizeof yes)!=0, "setting SO_REUSEADDR", failure);
	}

	SOCKETIO_FAILON(bind(fd, ai->ai_addr, ai->ai_addrlen)!=0, "binding to port", failure);

#if defined(USE_WIN32_SOCKETS)
	{
		u_long iMode=1;
		res=ioctlsocket(fd, FIONBIO, &iMode);
	}
#else
	res=fcntl(fd, F_SETFL, O_NONBLOCK);
#endif
	SOCKETIO_FAILON(res!=0, "setting non-blocking for accept() socket", failure);

	res=listen(fd, SOCKETIO_LISTEN_QUEUE);
	SOCKETIO_FAILON(res!=0, "forming listening socket", failure);

	if(!socketio_sockname(ai->ai_addr, ai->ai_addrlen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}

	/* add server to a list */
	newserv=calloc(1, sizeof *newserv);
	newserv->fd=fd;
	newserv->name=strdup(buf);
	REFCOUNT_INIT(newserv);
	REFCOUNT_TAKE(newserv);
	LIST_INSERT_HEAD(&socketio_server_list, newserv, list);

	socketio_readready(newserv->fd); /* be ready for accept() */

	DEBUG("Bind success: %s %s\n", ai->ai_family==AF_INET ? "IPv4" : ai->ai_family==AF_INET6 ? "IPv6" : "Unknown", buf);

	return 1; /* success */

failure:
	socketio_close(fd);
failure_clean:
	return 0;
}

static void socketio_ll_client_free(struct socketio_client *client) {
	assert(client!=NULL);
	if(!client)
		return;
	DEBUG("freeing client '%s'\n", client->name);
}

static void socketio_ll_server_free(struct socketio_server *serv) {
	assert(serv!=NULL);
	if(!serv)
		return;
	DEBUG("freeing server '%s'\n", serv->name);
}

/*
 * family : 0 or AF_INET or AF_INET6
 * socktype: SOCK_STREAM or SOCK_DGRAM
 */
EXPORT int socketio_listen(int family, int socktype, const char *host, const char *port) {
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
		fprintf(stderr, "ERROR:hostname parsing error:%s\n", gai_strerror(res));
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
		fprintf(stderr, "Could not find interface for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	assert(socktype==SOCK_STREAM || socktype==SOCK_DGRAM);

	if(!socketio_listen_bind(curr)) {
		freeaddrinfo(ai_res);
		fprintf(stderr, "Could bind socket for %s:%s\n", host ? host : "*", port);
		return 0; /* failure */
	}

	freeaddrinfo(ai_res);
	return 1; /* success */
}

static int socketio_accept(struct socketio_server *servcurr) {
	struct sockaddr_storage ss;
	socklen_t sslen;
	struct socketio_client *newclient;
	SOCKET fd;
	char buf[64];
	assert(servcurr!=NULL);
	assert(servcurr->fd!=INVALID_SOCKET);
	sslen=sizeof ss;
	fd=accept(servcurr->fd, (struct sockaddr*)&ss, &sslen);
	SOCKETIO_FAILON(fd==INVALID_SOCKET, "accept()", failure);
	newclient=calloc(1, sizeof *newclient);

	if(!socketio_sockname((struct sockaddr*)&ss, sslen, buf, sizeof buf)) {
		strcpy(buf, "<UNKNOWN>");
	}
	newclient->name=strdup(buf);
	newclient->fd=fd;
	REFCOUNT_INIT(newclient);
	REFCOUNT_TAKE(newclient);
	LIST_INSERT_HEAD(&socketio_client_list, newclient, list);
	socketio_readready(fd);
	DEBUG("Accepted connection %s\n", newclient->name);
	return 1;
failure:
	return 0;
}

EXPORT int socketio_dispatch(struct timeval timeout) {
	struct socketio_server *servcurr;
	struct socketio_client *clientcurr;
	int nr;	/* number of sockets to process */
	unsigned old_fdset;

	if(!LIST_TOP(socketio_server_list) && !LIST_TOP(socketio_client_list)) {
		fprintf(stderr, "No more sockets to watch\n");
		return 0;
	}

	nr=select(socketio_fdmax+1, &socketio_readfds[socketio_fdset], &socketio_writefds[socketio_fdset], 0, &timeout);
#if !defined(USE_WIN32_SOCKETS)
	socketio_fdmax=INVALID_SOCKET; /* reset the maximum before calling any handlers */
#endif
	old_fdset=socketio_fdset;
	socketio_fdset^=1; /* toggle between 0 and 1 */
	SOCKETIO_FAILON(nr==SOCKET_ERROR, "select()", failure);

	DEBUG("select() returned %d results\n", nr);

	/* check servers */
	for(servcurr=LIST_TOP(socketio_server_list);nr>0 && servcurr;servcurr=LIST_NEXT(servcurr, list)) {
		TRACE("Checking server %s\n", servcurr->name);
		if(FD_ISSET(servcurr->fd, &socketio_readfds[old_fdset])) {
			FD_CLR(servcurr->fd, &socketio_readfds[socketio_fdset]);
			/* we just ignore the write bits, listeners should never set */
			FD_CLR(servcurr->fd, &socketio_writefds[socketio_fdset]);
			REFCOUNT_TAKE(servcurr);
			DEBUG("Connection on %s\n", servcurr->name);
			socketio_accept(servcurr); /* new clients would set fd_set entries, and trigger in the following if we didn't use two fd_sets */
			REFCOUNT_PUT(servcurr, socketio_ll_server_free);
			nr--;
		}
	}
	/* check clients */
	for(clientcurr=LIST_TOP(socketio_client_list);nr>0 && clientcurr;clientcurr=LIST_NEXT(clientcurr, list)) {
		int rdfl, wrfl;

		TRACE("Checking client %s\n", clientcurr->name);

		wrfl=FD_ISSET(clientcurr->fd, &socketio_writefds[old_fdset]);
		rdfl=FD_ISSET(clientcurr->fd, &socketio_readfds[old_fdset]);

		if(wrfl || rdfl) {
			REFCOUNT_TAKE(clientcurr);
			if(wrfl) {
				FD_CLR(clientcurr->fd, &socketio_writefds[socketio_fdset]);
				DEBUG("Write-ready %s\n", clientcurr->name);
				/* TODO: perform the write handler */
			}

			if(rdfl) {
				FD_CLR(clientcurr->fd, &socketio_readfds[socketio_fdset]);
				DEBUG("Read-ready %s\n", clientcurr->name);
				/* TODO: perform the read handler */
			}
			nr--;	/* decrement socket count if read, write or both was done */
			REFCOUNT_PUT(clientcurr, socketio_ll_client_free);
		}

	}
	assert(nr==0);
	if(nr>0) {
		fprintf(stderr, "ERROR:Some sockets were not handled\n");
		goto failure;
	}

	return 1;
failure:
	return 0; /* failure */
}
/******************************************************************************
 * Main - Option parsing and initialization
 ******************************************************************************/
static int fl_default_family=0;

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
		fprintf(stderr, "ERROR: option -%c takes a parameter\n", ch);
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
		case 'p':
			need_parameter(ch, next_arg);
			if(!socketio_listen(fl_default_family, SOCK_STREAM, NULL, next_arg)) {
				usage();
			}
			return 1; /* uses next arg */
		default:
			fprintf(stderr, "ERROR: Unknown option -%c\n", ch);
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
			/* TODO: process arguments */
			fprintf(stderr, "TODO: process argument '%s'\n", argv[i]);
		}
	}
}

int main(int argc, char **argv) {
	struct timeval timeout;

#ifndef NDEBUG
	/*
	bitmap_test();
	freelist_test();
	bidb_show_info();
	heapqueue_test();
	*/
#endif

	if(!socketio_init()) {
		return EXIT_FAILURE;
	}
	atexit(socketio_shutdown);

	process_args(argc, argv);

	if(!bidb_open(BIDB_FILE)) {
		printf("Failed\n");
		return EXIT_FAILURE;
	}
	atexit(bidb_close);

	/* TODO: use the next event for the timer */
	timeout.tv_usec=0;
	timeout.tv_sec=10;
	while(socketio_dispatch(timeout)) {
		fprintf(stderr, "Tick\n");
	}
	return 0;
}

/******************************************************************************
 * Notes
 ******************************************************************************/
