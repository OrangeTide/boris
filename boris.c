/* boris.c :
 * example of a very tiny MUD
 */

/****************************************************************************** 
 * Configuration
 ******************************************************************************/

#define USE_BSD_SOCKETS
#undef USE_WIN32_SOCKETS

/* database file */ 
#define BIDB_FILE "boris.bidb"

#define BIDB_MAX_OBJECT_DEFAULT	131072 
#define BIDB_MAX_BLOCKS_DEFAULT	524288

/****************************************************************************** 
 * Headers
 ******************************************************************************/

#include <assert.h>
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
#define ROUNDUP(a,n) (((a)+(n)-1)/(n)*(n))
#define ROUNDDOWN(a,n) ((a)/(n)*(n))

#define make_name2(x,y) x##y
#define make_name(x,y) make_name2(x,y)

/* var() is used for making temp variables in macros */
#define var(x) make_name(x,__LINE__)

/** byte-order functions **/

/* WRite Big-Endian 32-bit value */
#define WR_BE32(dest, offset, value) do { \
		unsigned var(tmp)=value; \
		(dest)[offset]=(var(tmp)/16777216L)%256; \
		(dest)[(offset)+1]=(var(tmp)/65536L)%256; \
		(dest)[(offset)+2]=(var(tmp)/256)%256; \
		(dest)[(offset)+3]=var(tmp)%256; \
	} while(0)

/* WRite Big-Endian 16-bit value */
#define WR_BE16(dest, offset, value) do { \
		unsigned var(tmp)=value; \
		(dest)[offset]=(var(tmp)/256)%256; \
		(dest)[(offset)+1]=var(tmp)%256; \
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
}

void bitmap_set(unsigned ofs, unsigned len) {
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

/****************************************************************************** 
 * Hashing Cache
 ******************************************************************************/

struct hash_entry {
	unsigned id;
	bidb_blockofs_t ofs;
	unsigned count;
	struct lru_entry lru; /* if data is not NULL, then the data is loaded */
};

static struct hashcache_entry **hashcache_table;
static size_t hashcache_table_nr, hashcache_table_mask;

static size_t roundup2(size_t val) {
	size_t n;
	for(n=1;n<val;n<<=1) ;
	return n;
}

int hashcache_init(unsigned max_entries) {
	struct hashcache_entry **tmp;
	assert(hashcache_table==NULL);
	if(hashcache_table) {
		fprintf(stderr, "hash table already initialized\n");
		return 0; /* failure */
	}
	max_entries=roundup2(max_entries);
	tmp=calloc(sizeof *tmp, max_entries);
	if(!tmp) {
		perror("malloc()");
		return 0; /* failure */
	}
	hashcache_table=tmp;
	hashcache_table_nr=max_entries;
	hashcache_table_mask=hashcache_table_nr-1;
	fprintf(stderr, "hash table size is %u\n", hashcache_table_nr);
	return 1;
}

/****************************************************************************** 
 * Binary Database
 ******************************************************************************/

/*
 * 
 * Binary database
 * ===============
 * block size=every element is a block
 * 
 * superblock:
 * 	magic
 * 	maximum object count
 * 	hash table offset (size is based on max object count)
 * 	block bitmap offset	
 *
 * hash table:
 *  item id (if top bit is set, then item is a string)
 *  block number:22
 *  block count:10
 */

#define BIDB_BLOCK_SZ 1024
static FILE *bidb_file;
static char *bidb_filename;
static struct {
	unsigned max_object_count, max_block_count, object_count;
	bidb_blockofs_t hash_off, bitmap_off; /* in multiples of blocks */
} bidb_superblock;

static int bidb_read_blocks(unsigned char *data, bidb_blockofs_t block_number, unsigned block_count) {
	size_t res;
	if(fseek(bidb_file, block_number * BIDB_BLOCK_SZ, SEEK_SET)) {
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

static int bidb_write_blocks(const unsigned char *data, bidb_blockofs_t block_number, unsigned block_count) {
	size_t res;
	if(fseek(bidb_file, block_number * BIDB_BLOCK_SZ, SEEK_SET)) {
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

static int bidb_load_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	if(bidb_read_blocks(data, 0, 1)) {
		if(memcmp("BiDB", data, 4)) {
			fprintf(stderr, "%s:not a data file\n", bidb_filename);
			return 0; /* failure : invalid magic */
		}
		bidb_superblock.object_count=0;
		bidb_superblock.max_object_count=RD_BE32(data, 4);
		bidb_superblock.max_block_count=RD_BE32(data, 8);
		bidb_superblock.hash_off=RD_BE32(data, 12);
		bidb_superblock.bitmap_off=RD_BE32(data, 16);

		/** sanity checks **/
		if(roundup2(bidb_superblock.max_object_count)!=bidb_superblock.max_object_count) {
			fprintf(stderr, "%s:superblock error:max_object_count must be a power of 2\n", bidb_filename);
			return 0; /* failure : superblock data doesn't make sense */
		}
		if(bidb_superblock.hash_off!=0 && bidb_superblock.bitmap_off==0) {
			fprintf(stderr, "%s:superblock error:hash table allocated before block bitmap\n", bidb_filename);
			return 0;
		}

		return 1; /* success */
	}
	fprintf(stderr, "%s:could not load superblock\n", bidb_filename);
	return 0; /* failure : could not read superblock */
}

static int bidb_save_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	memcpy(data, "BiDB", 4);
	WR_BE32(data, 4, bidb_superblock.max_object_count);
	WR_BE32(data, 8, bidb_superblock.max_block_count);
	WR_BE32(data, 12, bidb_superblock.hash_off);
	WR_BE32(data, 16, bidb_superblock.bitmap_off);
	if(!bidb_write_blocks(data, 0, 1)) {
		fprintf(stderr, "%s:could not write superblock\n", bidb_filename);		
		return 0; /* failure */
	}
	return 1; /* success */
}

static int bidb_save_bitmap(void) {
	unsigned bitmap_block_count; /* number of blocks to store the bitmap */
	unsigned char tmp[BIDB_BLOCK_SZ];
	unsigned i;

	bitmap_block_count=ROUNDUP(bidb_superblock.max_block_count/CHAR_BIT, BIDB_BLOCK_SZ)/BIDB_BLOCK_SZ;

	for(i=0;i<bitmap_block_count;i++) {
		/* TODO: fill out tmp with data */
		if(!bidb_read_blocks(tmp, bidb_superblock.bitmap_off+(signed)i, 1)) {
		}
	}
}

static int bidb_load_bitmap(void) {
	long filesize;
	unsigned bitmap_block_count; /* number of blocks to store the bitmap */

	fseek(bidb_file, 0, SEEK_END);
	filesize=ftell(bidb_file);

	if((filesize%BIDB_BLOCK_SZ)!=0) {
		fprintf(stderr, "%s:database file is not a multiple of %u bytes\n", bidb_filename, BIDB_BLOCK_SZ);
		return 0;
	}

	/* round up bitmap count to fill entire blocks */
	bitmap_block_count=ROUNDUP(bidb_superblock.max_block_count/CHAR_BIT, BIDB_BLOCK_SZ)/BIDB_BLOCK_SZ;

	if(bidb_superblock.bitmap_off) {
		/* load the bitmap */
		unsigned char *tmp;
		tmp=calloc(BIDB_BLOCK_SZ, bitmap_block_count);
		if(!tmp) {
			perror("malloc()");
			return 0; /* failure - could not allocate memory */
		}
		if(!bidb_read_blocks(tmp, bidb_superblock.bitmap_off, bitmap_block_count)) {
			fprintf(stderr, "%s:could not load block bitmap\n", bidb_filename);
			free(tmp);
			return 0;
		}
		bitmap_loadmem(tmp, bitmap_block_count*BIDB_BLOCK_SZ*CHAR_BIT);
		free(tmp);
	} else {
		/* create a new one from scratch */
		fprintf(stderr, "%s:creating new block bitmap\n", bidb_filename);
		assert(bidb_superblock.hash_off==0); /* hash cannot be allocated yet */
		bitmap_resize(bidb_superblock.max_block_count);
		bitmap_set(0, 1); /* superblock is allocated by default */
		/* allocate the block bitmap in the block bitmap */
		assert(bidb_superblock.bitmap_off>0);
		bitmap_set((unsigned)bidb_superblock.bitmap_off, bitmap_block_count);

		bidb_save_bitmap();
	}
}

static int bidb_load_hash(void) {
	if(!hashcache_init(bidb_superblock.max_object_count)) {
		fprintf(stderr, "%s:could not initialize hash table\n", bidb_filename);		
		return 0;
	}
	if(bidb_superblock.hash_off==0) {
		/* create the hash table on disk */
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
			bidb_superblock.object_count=0;
			bidb_superblock.max_object_count=BIDB_MAX_OBJECT_DEFAULT;
			bidb_superblock.max_block_count=BIDB_MAX_BLOCKS_DEFAULT;
			bidb_superblock.hash_off=0;
			bidb_superblock.bitmap_off=0;
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

	if(!bidb_load_bitmap()) {
		fprintf(stderr, "%s:could not load bitmap\n", bidb_filename);
		bidb_close();
		return 0; /* failure */
	}

	if(!bidb_load_hash()) {
		fprintf(stderr, "%s:could not load hash\n", bidb_filename);
		bidb_close();
		return 0; /* failure */
	}
	return 1; /* success */
}

/****************************************************************************** 
 * Database Records
 ******************************************************************************/

/* typefile file format:
 * type
 * data...
 */

struct rec_controller {
	char *record_type_name;		/* identifies the class of record */
	void (*record_load)(FILE *f);
	void (*record_save)(FILE *f, void *data);
};

static struct rec_controller *rec_controller_head;

/* finds a Record Controller by name
 * NULL on failure */
const struct rec_controller *rec_controller_get(const char *name) {
}

/****************************************************************************** 
 * Objects
 ******************************************************************************/

struct object_base {
	unsigned id;
	const struct rec_controller *rec_con;
	void (*object_free)(void *);			/* for freeing an object */
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
	if(obj->object_free) {
		obj->object_free(obj);
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
	bidb_open(BIDB_FILE, 1);
	bidb_close();
	return 0;
}

/****************************************************************************** 
 * Notes
 ******************************************************************************/
