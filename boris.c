/* boris.c :
 * example of a very tiny MUD
 */

/****************************************************************************** 
 * Configuration
 ******************************************************************************/

#define USE_BSD_SOCKETS
#undef USE_WIN32_SOCKETS

/* directory holding database files */
#define DB_PATH "muddb"

/****************************************************************************** 
 * Headers
 ******************************************************************************/

#include <assert.h>
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

/****************************************************************************** 
 * Globals 
 ******************************************************************************/

/****************************************************************************** 
 * Prototypes
 ******************************************************************************/

/****************************************************************************** 
 * Hashing
 ******************************************************************************/

static unsigned long hash_string(const char *key) {
	unsigned long h = 0;

	while(*key) {
		h=h*65599+*key++;
		/* this might be faster on some systems with fast shifts and slow mult:
		 * h=(h<<6)+(h<<16)-h+*key++;
		 */
	}
	return h;
}

static uint_least32_t hash_int32(uint_least32_t key) {
	key=(key^61)*ROR32(key,16);
	key+=key<<3;
	key^=ROR32(key, 4);
	key*=668265261;
	key^=ROR32(key, 15);
	return key;
}

static uint_least64_t hash_int64(uint_least64_t key) {
	key=~key+(key<<21);
	key^=ROR64(key, 24);
	key*=265;
	key^=ROR64(key,14);
	key*=21;
	key^=ROR64(key, 28);
	key+=key<<31;
	return key;
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
 *  hash
 *  item id (if top bit is set, then item is a string)
 *  block number
 *  block count
 */

#define BIDB_BLOCK_SZ 1024
static FILE *bidb_file;
static char *bidb_filename;
static struct {
	unsigned max_object_count, object_count;
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
		bidb_superblock.hash_off=RD_BE32(data, 8);
		bidb_superblock.bitmap_off=RD_BE32(data, 12);
		return 1; /* success */
	}
	fprintf(stderr, "%s:could not load superblock\n", bidb_filename);
	return 0; /* failure : could not read superblock */
}

static int bidb_save_superblock(void) {
	unsigned char data[BIDB_BLOCK_SZ];
	memcpy(data, "BiDB", 4);
	WR_BE32(data, 4, bidb_superblock.max_object_count);
	WR_BE32(data, 8, bidb_superblock.hash_off);
	WR_BE32(data, 12, bidb_superblock.bitmap_off);
	if(!bidb_write_blocks(data, 0, 1)) {
		fprintf(stderr, "%s:could not write superblock\n", bidb_filename);		
		return 0; /* failure */
	}
	return 1; /* success */
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
			bidb_superblock.max_object_count=0;
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
	bidb_open("boris.bidb", 1);
	bidb_close();
	return 0;
}

/****************************************************************************** 
 * Notes
 ******************************************************************************/
