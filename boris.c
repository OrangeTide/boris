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
 * 	freelist - a malloc-like abstraction for the block bitmaps
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

#define USE_BSD_SOCKETS
#undef USE_WIN32_SOCKETS

/* database file */ 
#define BIDB_FILE "boris.bidb"

#define BIDB_DEFAULT_MAX_RECORDS 131072
#define BIDB_MAX_BLOCKS 4194304

/****************************************************************************** 
 * Headers
 ******************************************************************************/

#include <assert.h>
#include <inttypes.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef USE_BSD_SOCKETS
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#endif

/****************************************************************************** 
 * Macros 
 ******************************************************************************/

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

/** byte-order functions **/

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

/** Rotate operations **/
#define ROL8(a,b) (((uint_least8_t)(a)<<(b))|((uint_least8_t)(a)>>(8-(b))))
#define ROL16(a,b) (((uint_least16_t)(a)<<(b))|((uint_least16_t)(a)>>(16-(b))))
#define ROL32(a,b) (((uint_least32_t)(a)<<(b))|((uint_least32_t)(a)>>(32-(b))))
#define ROL64(a,b) (((uint_least64_t)(a)<<(b))|((uint_least64_t)(a)>>(64-(b))))
#define ROR8(a,b) (((uint_least8_t)(a)>>(b))|((uint_least8_t)(a)<<(8-(b))))
#define ROR16(a,b) (((uint_least16_t)(a)>>(b))|((uint_least16_t)(a)<<(16-(b))))
#define ROR32(a,b) (((uint_least32_t)(a)>>(b))|((uint_least32_t)(a)<<(32-(b))))
#define ROR64(a,b) (((uint_least64_t)(a)>>(b))|((uint_least64_t)(a)<<(64-(b))))

/** Bitfield operations **/
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

/** DEBUG MACROS **/
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

/****************************************************************************** 
 * Types and data structures
 ******************************************************************************/
typedef long bidb_blockofs_t;

struct lru_entry {
	void (*free)(void *p);	/* function to free the item */
	void *data;
	struct lru_entry *next;
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

void bitmap_init(struct bitmap *bitmap) {
	assert(bitmap!=NULL);
	bitmap->bitmap=0;
	bitmap->bitmap_allocbits=0;
}

void bitmap_free(struct bitmap *bitmap) {
	assert(bitmap!=NULL); /* catch when calling free on NULL */
	if(bitmap) {
		free(bitmap->bitmap);
		bitmap_init(bitmap);
	}
}

/* newbits is in bits (not bytes) */
int bitmap_resize(struct bitmap *bitmap, size_t newbits) {
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

void bitmap_clear(struct bitmap *bitmap, unsigned ofs, unsigned len) {
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

void bitmap_set(struct bitmap *bitmap, unsigned ofs, unsigned len) {
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
int bitmap_get(struct bitmap *bitmap, unsigned ofs) {
	if(ofs<bitmap->bitmap_allocbits) {
		return (bitmap->bitmap[ofs/BITMAP_BITSIZE]>>(ofs%BITMAP_BITSIZE))&1;
	} else {
		return 0; /* outside of the range, the bits are cleared */
	}
}

/* return the position of the next set bit
 * -1 if the end of the bits was reached */ 
int bitmap_next_set(struct bitmap *bitmap, unsigned ofs) {
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
int bitmap_next_clear(struct bitmap *bitmap, unsigned ofs) {
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
void bitmap_loadmem(struct bitmap *bitmap, unsigned char *d, size_t len) {
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
unsigned bitmap_length(struct bitmap *bitmap) {
	return bitmap ? ROUNDUP(bitmap->bitmap_allocbits, CHAR_BIT)/CHAR_BIT : 0;
}

#ifndef NDEBUG
void bitmap_test(void) {
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

int recordcache_init(unsigned max_entries) {
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
struct bidb_extent {
	unsigned length, offset; /* both are in block-sized units */
};

static FILE *bidb_file;
static char *bidb_filename;
static struct {
	struct bidb_extent record_extents[16];
	/* one bit per block */
	unsigned record_dirty_blocks[BITFIELD(16<<BIDB_EXTENT_LENGTH_BITS,unsigned)];
	unsigned record_max, block_max;
	struct bidb_stats {
		unsigned records_used;
	} stats;
} bidb_superblock;

int bidb_close(void) {
	if(bidb_file) {
		fclose(bidb_file);
		bidb_file=0;
	}
	free(bidb_filename);
	bidb_filename=0;
	return 1;
}

/* block_offset starts AFTER superblock */
static int bidb_read_blocks(unsigned char *data, bidb_blockofs_t block_offset, unsigned block_count) {
	size_t res;
	if(fseek(bidb_file, (block_offset+BIDB_SUPERBLOCK_SZ)*BIDB_BLOCK_SZ, SEEK_SET)) {
		perror(bidb_filename);
		return 0; /* failure */
	}
	res=fread(data, BIDB_BLOCK_SZ, block_count, bidb_file);
	if(res!=block_count) {
		if(ferror(bidb_file)) {
			perror(bidb_filename);
		}
		return 0; /* failure */
	}
	return 1; /* success */
}

/* block_offset starts AFTER superblock */
static int bidb_write_blocks(const unsigned char *data, bidb_blockofs_t block_offset, unsigned block_count) {
	size_t res;

	if(fseek(bidb_file, (block_offset+BIDB_SUPERBLOCK_SZ)*BIDB_BLOCK_SZ, SEEK_SET)) {
		perror(bidb_filename);
		return 0; /* failure */
	}
	res=fwrite(data, BIDB_BLOCK_SZ, block_count, bidb_file);
	if(res!=block_count) {
		if(ferror(bidb_file)) {
			perror(bidb_filename);
		}
		return 0; /* failure */
	}
	return 1; /* success */
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
	fseek(bidb_file, 0, SEEK_END);
	filesize=ftell(bidb_file);
	if((filesize%BIDB_BLOCK_SZ)!=0) {
		fprintf(stderr, "%s:database file is not a multiple of %u bytes\n", bidb_filename, BIDB_BLOCK_SZ);
		return 0;
	}
	bidb_superblock.block_max=filesize/BIDB_BLOCK_SZ;

	if(bidb_read_blocks(data, -BIDB_SUPERBLOCK_SZ, BIDB_SUPERBLOCK_SZ)) {
		if(memcmp("BiDB", data, 4)) {
			fprintf(stderr, "%s:not a data file\n", bidb_filename);
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
				fprintf(stderr, "%s:record table extent list has holes in it\n", bidb_filename);
				return 0;
			}
		}

		for(i=0;i<NR(bidb_superblock.record_extents);i++) {
			if(!bidb_check_extent(&bidb_superblock.record_extents[i], filesize/(unsigned)BIDB_BLOCK_SZ-BIDB_SUPERBLOCK_SZ)) {
				fprintf(stderr, "%s:record table %u extent exceeds file size\n", bidb_filename, i);
				return 0;
			}
		}

		return 1; /* success */
	}
	fprintf(stderr, "%s:could not load superblock\n", bidb_filename);
	return 0; /* failure : could not read superblock */
}

static int bidb_save_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	uint_least32_t tmp;
	unsigned i;

	fprintf(stderr, "%s:saving superblock\n", bidb_filename);

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
		fprintf(stderr, "%s:could not write superblock\n", bidb_filename);		
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
				DEBUG("%s:writing record block %d\n", bidb_filename, ofs);
				*/
				BITCLR(bidb_superblock.record_dirty_blocks, ofs);
				memset(data, 0, sizeof data); /* TODO: fill with record data */
				if(!bidb_write_blocks(data, (signed)(bidb_superblock.record_extents[i].offset+j), 1)) {
					DEBUG("%s:could not write record table\n", bidb_filename);		
					return 0; /* failure */
				}
			}
		}
	}
	return 1;
}

static int bidb_create_record_table(void) {
	unsigned i, total, next_block, extentblks;
	assert(bidb_superblock.record_extents[0].offset==0); /* only safe to call if we have no table */

	/* create the record table on disk */
	fprintf(stderr, "Creating new record table\n");

	/* TODO: break it up into extent-sized pieces */
	bidb_superblock.record_max=BIDB_DEFAULT_MAX_RECORDS;

	next_block=0; /* TODO: allocate the next available block from freelist */

	/* create all the extents necessary */
	for(i=0,total=0;i<NR(bidb_superblock.record_extents) && total<bidb_superblock.record_max;i++, total++) {
		bidb_superblock.record_extents[i].offset=next_block;

		extentblks=ROUNDUP((bidb_superblock.record_max-total)*BIDB_RECPTR_SZ, BIDB_BLOCK_SZ)/BIDB_BLOCK_SZ;
		if(extentblks>1U<<(BIDB_EXTENT_LENGTH_BITS)) {
			extentblks=1<<BIDB_EXTENT_LENGTH_BITS;
		}

		bidb_superblock.record_extents[i].length=extentblks;

		DEBUG("%s:Record table allocating extent %d (%u %u %u)\n", bidb_filename, i, extentblks, total, next_block);

		next_block+=extentblks; /* TODO: allocate the next available block from freelist */
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
		fprintf(stderr, "%s:could not initialize record table\n", bidb_filename);		
		return 0;
	}
	if(bidb_superblock.record_extents[0].length==0) { /* no record table found .. create it */
		if(!bidb_create_record_table()) {
			return 0;
		}
	} else {
		/* TODO: read in record table entries */
	}
	return 1; /* */
}

/* mark a record as dirty due to modification */
void bidb_record_dirty(unsigned record_number) {
	unsigned blknum;

	blknum=record_number/BIDB_RECORDS_PER_BLOCK;

	if(!BITRANGE(bidb_superblock.record_dirty_blocks, blknum)) {
		fprintf(stderr, "%s:Dirty block %u not in range!\n", bidb_filename, blknum);
		return;
	}

	DEBUG("%s:Dirty block %u\n", bidb_filename, blknum);
	BITSET(bidb_superblock.record_dirty_blocks, blknum);
}

/* create_fl will create if the superblock does not exist */
int bidb_open(const char *filename) {
	int create_fl=0;
	if(bidb_file)
		bidb_close();
	bidb_file=fopen(filename, "r+b");
	if(!bidb_file) {
		fprintf(stderr, "%s:creating a new file\n", filename);
		bidb_file=fopen(filename, "w+b");
		if(!bidb_file) {
			perror(filename);
			return 0; /* failure */
		}
		create_fl=1;
	}
	bidb_filename=strdup(filename);
	
	if(!create_fl) {
		if(!bidb_load_superblock()) {
			bidb_close();
			return 0; /* failure */
		}
	} else {
		fprintf(stderr, "%s:creating new superblock\n", bidb_filename);
		bidb_superblock.stats.records_used=0;
		bidb_superblock.record_max=0;
		bidb_superblock.block_max=0;
		if(!bidb_save_superblock()) {
			bidb_close();
			return 0; /* failure */
		}
	}

	if(!bidb_load_record_table()) {
		fprintf(stderr, "%s:could not load record table\n", bidb_filename);
		bidb_close();
		return 0; /* failure */
	}
	return 1; /* success */
}

void bidb_show_info(void) {
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
 * Freelist
 ******************************************************************************/

/* bucket number to use for overflows */
#define FREELIST_OVERFLOW_BUCKET (NR(freelist_buckets)-1)

struct freelist_entry {
	struct freelist_entry *next_global, **prev_global; /* global lists */
	struct freelist_entry *next_bucket, **prev_bucket; /* bucket lists */
	struct bidb_extent extent;
};

/* single list ordered by offset. last entry is a catch-all for huge chunks */
static struct freelist_entry *freelist_global, *freelist_buckets[(1<<BIDB_EXTENT_LENGTH_BITS)+1];

static unsigned freelist_ll_bucketnr(unsigned count) {
	unsigned ret;
	ret=count/(NR(freelist_buckets)-1);
	if(ret>=NR(freelist_buckets)) {
		ret=FREELIST_OVERFLOW_BUCKET;
	}
	return ret;
}

static void freelist_ll_bucketize(struct freelist_entry *e) {
	struct freelist_entry **bucketptr;
	unsigned bucket_nr;

	assert(e!=NULL);

	bucket_nr=freelist_ll_bucketnr(e->extent.length);

	bucketptr=&freelist_buckets[bucket_nr];
	/* detach the entry */
	if(e->next_bucket) {
		e->next_bucket->prev_bucket=e->prev_bucket;
	}
	if(e->prev_bucket) {
		*e->prev_bucket=e->next_bucket;
	}

	/* push entry on the top of the bucket */
	e->next_bucket=*bucketptr;
	if(*bucketptr) {
		(*bucketptr)->prev_bucket=&e->next_bucket;
	}
	e->prev_bucket=bucketptr;
	*bucketptr=e;
}

/* lowlevel - detach and free an entry */
static void freelist_ll_free(struct freelist_entry *e) {
	assert(e!=NULL);
	assert(e->prev_global!=NULL);
	assert(e->prev_global!=(void*)0x99999999);
	assert(e->prev_bucket!=NULL);
	if(e->next_global) {
		e->next_global->prev_global=e->prev_global;
	}
	if(e->next_bucket) {
		e->next_bucket->prev_bucket=e->prev_bucket;
	}
	*e->prev_global=e->next_global;
	*e->prev_bucket=e->next_bucket;
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
	new->next_bucket=0;
	new->prev_bucket=0;
	new->next_global=*prev;
	new->prev_global=prev;
	if(*prev) {
		(*prev)->prev_global=&new->next_global;
	}
	*prev=new;
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

/* allocate memory from the pool
 * returns offset of the allocation
 * return -1 on failure */
long freelist_alloc(unsigned count) {
	unsigned bucketnr, ofs;
	struct freelist_entry **bucketptr, *curr;

	bucketnr=freelist_ll_bucketnr(count);
	bucketptr=&freelist_buckets[bucketnr];
	/* TODO: prioritize the order of the check. 1. exact size, 2. double size 3. ? */
	for(;bucketnr<=FREELIST_OVERFLOW_BUCKET;bucketnr++) {
		assert(bucketnr<=FREELIST_OVERFLOW_BUCKET);
		assert(bucketptr!=NULL);

		if(*bucketptr) { /* found an entry*/
			curr=*bucketptr;
			assert(curr->extent.length>=count);
			ofs=curr->extent.offset;
			curr->extent.offset+=count;
			curr->extent.length-=count;
			if(curr->extent.length==0) {
				freelist_ll_free(curr);
			} else {
				/* place in a new bucket */
				freelist_ll_bucketize(curr);
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
void freelist_pool(unsigned ofs, unsigned count) {
	struct freelist_entry *new, *curr, *last;

	TRACE_ENTER();

	last=NULL;
	new=NULL;
	for(curr=freelist_global;curr;curr=curr->next_global) {
		assert(curr!=last);
		assert(curr!=(void*)0x99999999);
		if(last) {
			assert(last->next_global==curr); /* sanity check */
		}
		/*
		printf(
			"c.ofs:%6d c.len:%6d l.ofs:%6d l.len:%6d ofs:%6d len:%6d\n",
			curr->extent.offset, curr->extent.length,
			last ? last->extent.offset : -1, last ? last->extent.length : -1,
			ofs, count
		);
		*/
		if(last && freelist_ll_isbridge(&last->extent, ofs, count, &curr->extent)) {
			/* |......|XXX|.......|		bridge */
			DEBUG("|......|XXX|.......|		bridge. last=%u+%u curr=%u+%u new=%u+%u\n", last->extent.length, last->extent.offset, curr->extent.offset, curr->extent.length, ofs, count);
			/* we are dealing with 3 entries, the last, the new and the current */
			/* merge the 3 entries into the last entry */
			last->extent.length+=curr->extent.length+count;
			assert(curr->prev_global==&last->next_global);
			freelist_ll_free(curr);
			assert(freelist_global!=curr);
			assert(last->next_global!=(void*)0x99999999);
			assert(last->next_global!=curr); /* deleting it must take it off the list */
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
			DEBUG("|.....|_XXX_|......|		normal new=%u+%u\n", ofs, count);
			/* create a new entry */
			new=freelist_ll_new(curr->prev_global, ofs, count);
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
				new=freelist_ll_new(&last->next_global, ofs, count);
			}
		} else {
			DEBUG("|XXX               |		initial. new=%u+%u\n", ofs, count);
			new=freelist_ll_new(&freelist_global, ofs, count);
		}
	}

	/* push entry into bucket */
	if(new) {
		freelist_ll_bucketize(new);
	}
}

#ifndef NDEBUG
void freelist_test(void) {
	struct freelist_entry *curr; 
	unsigned n;
	fprintf(stderr, "::: Making some fragments :::\n");
	for(n=0;n<60;n+=12) {
		freelist_pool(n, 6);
	}
	fprintf(stderr, "::: Filling in gaps :::\n");
	for(n=0;n<60;n+=12) {
		freelist_pool(n+6, 6);
	}
	fprintf(stderr, "::: Walking backwards :::\n");
	for(n=120;n>60;) {
		n-=6;
		freelist_pool(n, 6);
	}

	fprintf(stderr, "::: Dump freelist :::\n");
	for(curr=freelist_global,n=0;curr;curr=curr->next_global,n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}

	/* test freelist_alloc() */
	fprintf(stderr, "::: Allocating :::\n");
	for(n=0;n<60;n+=6) {
		long ofs;
		ofs=freelist_alloc(6);
		TRACE("alloc: %u+%u\n", ofs, 6);
	}

	fprintf(stderr, "::: Dump freelist :::\n");
	for(curr=freelist_global,n=0;curr;curr=curr->next_global,n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}

	fprintf(stderr, "::: Allocating :::\n");
	for(n=0;n<60;n+=6) {
		long ofs;
		ofs=freelist_alloc(6);
		TRACE("alloc: %u+%u\n", ofs, 6);
	}

	fprintf(stderr, "::: Dump freelist :::\n");
	for(curr=freelist_global,n=0;curr;curr=curr->next_global,n++) {
		printf("[%05u] ofs: %6d len: %6d\n", n, curr->extent.offset, curr->extent.length);
	}


}
#endif

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
struct object_base *mob_to_base(struct object_mob *mob) {
	assert(mob!=NULL);
	return &mob->base;
}

/* converts a room to a base object */
struct object_base *room_to_base(struct object_room *room) {
	assert(room!=NULL);
	return &room->base;
}

/* converts an item to a base object */
struct object_base *item_to_base(struct object_item *item) {
	assert(item!=NULL);
	return &item->base;
}

/* frees an object of any type */
void object_free(struct object_base *obj) {
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

struct object_base *object_load(unsigned id) {
	abort();
	return 0;
}

struct object_base *object_save(unsigned id) {
	abort();
	return 0;
}

struct object_base *object_iscached(unsigned id) {
	abort();
	return 0;
}

/****************************************************************************** 
 * Main
 ******************************************************************************/

int main(void) {
#ifndef NDEBUG
	/*
	bitmap_test();
	*/
	freelist_test();
#endif

	/*
	bidb_show_info();
	if(!bidb_open(BIDB_FILE)) {
		printf("Failed\n");
		return EXIT_FAILURE;
	}
	bidb_close();
	*/
	
	return 0;
}

/****************************************************************************** 
 * Notes
 ******************************************************************************/
