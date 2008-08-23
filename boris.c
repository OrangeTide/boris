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
 * 	bitmap - manages block bitmap
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
#define BIDB_DEFAULT_MAX_BLOCKS 524288

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
static const char *convert_number(unsigned n, unsigned base) {
	static char number_buffer[65];
	static char tab[] = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-";
    char *o; /* output */
    if(base<2) base=2;
	if(base>sizeof tab) base=sizeof tab;
    o=number_buffer+sizeof number_buffer;
    *--o=0;
    do {
        *--o=tab[n%base];
        n/=base;
    } while(n);
    /* len=number_buffer+sizeof number_buffer-1-o; */
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
 * Block Bitmap
 ******************************************************************************/

#define BITMAP_BITSIZE ((sizeof *bitmap)*CHAR_BIT)

static unsigned *bitmap;
static size_t bitmap_allocbits;

/* newbits is in bits (not bytes) */
int bitmap_resize(size_t newbits) {
	unsigned *tmp;
	newbits=ROUNDUP(newbits, BITMAP_BITSIZE);
	fprintf(stderr, "%s():Allocating %d bytes\n", __func__, newbits/CHAR_BIT);
	tmp=realloc(bitmap, newbits/CHAR_BIT);
	if(!tmp) {
		perror("realloc()");
		return 0; /* failure */
	}
	bitmap=tmp;
	bitmap_allocbits=newbits;
	return 1; /* success */
}

void bitmap_clear(unsigned ofs, unsigned len) {
	unsigned *p, mask, word_count;
	unsigned bofs, bcnt;

	/* allocate more */
	if(ofs+len>bitmap_allocbits) {
		bitmap_resize(ofs+len);
	}

	p=bitmap+ofs/BITMAP_BITSIZE;
	bofs=ofs%BITMAP_BITSIZE;

	if(bofs) {
		mask=(~0U)<<(BITMAP_BITSIZE-bofs); /* make some 1s at the top */
	} else {
		/* shifting by the entire word size is not guarenteed to work */
		mask=0;
	}

	word_count=len/BITMAP_BITSIZE;
	bcnt=len%BITMAP_BITSIZE;

	if(word_count) {
		*p&=mask;
		p++;
		mask=0;

		while(word_count>1) {
			*p++=0;
			word_count--;
		}
	}

	mask|=(~0U)>>(bcnt+bofs); /* make some 1s at the bottom */

	*p&=mask;
}

void bitmap_set(unsigned ofs, unsigned len) {
	unsigned *p, mask, word_count;
	unsigned bofs, bcnt;

	/* allocate more */
	if(ofs+len>bitmap_allocbits) {
		bitmap_resize(ofs+len);
	}

	p=bitmap+ofs/BITMAP_BITSIZE;
	bofs=ofs%BITMAP_BITSIZE;
	bcnt=len%BITMAP_BITSIZE;

	mask=(~0U)>>(bcnt+bofs); /* make some 1s at the bottom */

	word_count=len/BITMAP_BITSIZE;

	if(word_count) {
		*p|=mask;
		p++;
		mask=0;

		while(word_count>1) {
			*p++=~0;
			word_count--;
		}
	}

	if(bofs) {
		/* shifting by the entire word size is not guarenteed to work */
		mask|=(~0U)<<(BITMAP_BITSIZE-bofs); /* make some 1s at the top */
	}

	*p|=mask;
}

int bitmap_get(unsigned ofs) {
}

/* loads a chunk of memory into the bitmap buffer
 * erases previous bitmap buffer
 * len is in bytes */
void bitmap_loadmem(unsigned char *d, size_t len) {
	unsigned *p, word_count, i;

	/* resize if too small */
	if((len*CHAR_BIT)>bitmap_allocbits) {
		bitmap_resize(len*CHAR_BIT);
	}

	p=bitmap;
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

/* returns the length */
unsigned bitmap_length(void) {
	return ROUNDUP(bitmap_allocbits, CHAR_BIT);
}

#ifndef NDEBUG
void bitmap_test(void) {
	int i;
	bitmap_resize(1024);
	/* fill in with a test pattern */
	for(i=0;i<5;i++) {
		bitmap[i]=0x12345678;
	}

	bitmap_set(12, 64);
	/* display the test pattern */
	printf("bitmap_set():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x\n", bitmap[i]);
	}

	bitmap_clear(12, 64);
	/* display the test pattern */
	printf("bitmap_clear():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x\n", bitmap[i]);
	}

	bitmap_set(0, BITMAP_BITSIZE*5);
	/* display the test pattern */
	printf("bitmap_set():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x\n", bitmap[i]);
	}

	bitmap_clear(0, BITMAP_BITSIZE*5);
	/* display the test pattern */
	printf("bitmap_clear():\n");
	for(i=0;i<5;i++) {
		printf("0x%08x\n", bitmap[i]);
	}
}
#endif

/****************************************************************************** 
 * Freelist
 ******************************************************************************/

/* allocates blocks from the bitmap
 * returns offset of the allocation */
long freelist_alloc(unsigned count) {
}

/* adds a piece to the freelist pool */
long freelist_pool(long ofs, unsigned count) {
}

/****************************************************************************** 
 * Record Cacheing - look up records and automatically load them
 ******************************************************************************/

struct recordcache_entry {
	unsigned id;
	bidb_blockofs_t ofs;
	unsigned count;
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
	fprintf(stderr, "hash table size is %u\n", recordcache_table_nr);
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
#define BIDB_EXTENT(o,l) (((o)<<BIDB_EXTENT_LENGTH_BITS)|(l))
#define BIDB_EXTENT_NONE 0U
#define BIDB_EXTENT_LENGTH(e)	((e)&((1<<BIDB_EXTENT_LENGTH_BITS)-1))
#define BIDB_EXTENT_OFFSET(e)	((uint_least32_t)(e)>>BIDB_EXTENT_LENGTH_BITS)
/* an extent is a 32 bit value */
#define BIDB_EXTENTPTR_SZ (32/CHAR_BIT)
/* size of a record pointer (1 extent) */
#define BIDB_RECPTR_SZ BIDB_EXTENTPTR_SZ

struct bidb_extent {
	unsigned length, offset; /* both are in block-sized units */
};

static FILE *bidb_file;
static char *bidb_filename;
static struct {
	struct bidb_extent record_extents[16];
	unsigned record_max, block_max;
	struct bidb_stats {
		unsigned records_used;
	} stats;
} bidb_superblock;

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

		for(i=0,total_record_length=0;i<NR(bidb_superblock.record_extents);i++) {
			tmp=RD_BE32(data, 4+4*i);
			bidb_superblock.record_extents[i].offset=BIDB_EXTENT_OFFSET(tmp);
			bidb_superblock.record_extents[i].length=BIDB_EXTENT_LENGTH(tmp);
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
			if(!bidb_check_extent(&bidb_superblock.record_extents[i], filesize/(unsigned)BIDB_BLOCK_SZ)) {
				fprintf(stderr, "%s:record table extent exceeds file size\n", bidb_filename);
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

	memset(data, 0, sizeof data);
	memcpy(data, "BiDB", 4);

	for(i=0;i<NR(bidb_superblock.record_extents);i++) {
		tmp=BIDB_EXTENT(bidb_superblock.record_extents[i].offset, bidb_superblock.record_extents[i].length);
		WR_BE32(data, 4+4*i, tmp);
	}

	if(!bidb_write_blocks(data, -BIDB_SUPERBLOCK_SZ, 1)) {
		fprintf(stderr, "%s:could not write superblock\n", bidb_filename);		
		return 0; /* failure */
	}
	return 1; /* success */
}

static int bidb_load_record_table(void) {
	if(!recordcache_init(bidb_superblock.record_max)) {
		fprintf(stderr, "%s:could not initialize record table\n", bidb_filename);		
		return 0;
	}
	if(bidb_superblock.record_extents[0].length==0) { /* are there any extents? */
		/* create the record table on disk */
		/* TODO: find the next available size */
	}
	return 1; /* */
}

int bidb_close(void) {
	if(bidb_file) {
		fclose(bidb_file);
		bidb_file=0;
	}
	free(bidb_filename);
	bidb_filename=0;
}

/* create_fl will create if the superblock does not exist */
int bidb_open(const char *filename, int create_fl) {
	if(bidb_file)
		bidb_close();
	bidb_file=fopen(filename, create_fl ? "a+b" : "r+b");
	if(!bidb_file) {
		perror(filename);
		return 0; /* failure */
	}
	bidb_filename=strdup(filename);
	if(create_fl) {
		if(!bidb_load_superblock()) {
			fprintf(stderr, "%s:creating new superblock\n", bidb_filename);
			bidb_superblock.stats.records_used=0;
			bidb_superblock.record_max=BIDB_DEFAULT_MAX_RECORDS;
			bidb_superblock.block_max=BIDB_DEFAULT_MAX_BLOCKS;
			if(!bidb_save_superblock()) {
				bidb_close();
				return 0; /* failure */
			}
			return 0; /* failure */
		}
	} else {
		if(!bidb_load_superblock()) {
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
		"  number of record extents: %" PRIu32 " extents\n"
		"  max number of record: %" PRIu32 " records\n"
		"  max total size for all records: %" PRIu64 " bytes\n"
		"  max blocks: %u blocks (%" PRIu64 " bytes)\n", 
		BIDB_BLOCK_SZ,
		1<<BIDB_EXTENT_LENGTH_BITS,
		max_extent_size,
		records_per_block,
		records_per_extent,
		NR(bidb_superblock.record_extents),
		max_records,
		(uint_least64_t)max_records<<BIDB_EXTENT_LENGTH_BITS,
		1<<BIDB_EXTENT_OFFSET_BITS,
		(uint_least64_t)BIDB_BLOCK_SZ<<BIDB_EXTENT_OFFSET_BITS
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
}

struct object_base *object_save(unsigned id) {
}

struct object_base *object_iscached(unsigned id) {
}

/****************************************************************************** 
 * Main
 ******************************************************************************/

int main(void) {
#ifndef NDEBUG
	bitmap_test();
#endif

	/*
	bidb_open(BIDB_FILE, 1);
	bidb_close();
	bidb_show_info();
	*/
	
	return 0;
}

/****************************************************************************** 
 * Notes
 ******************************************************************************/
