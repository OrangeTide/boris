/* pool.h - numeric id pools
 * Keeps a sorted list of free number ranges. Always extracts the lowest
 * available number. Supports take-lowest, take-specific, and return.
 * PUBLIC DOMAIN - August 2005 - J.Mayo
 */
#ifndef POOL_H_
#define POOL_H_

#include <limits.h>

typedef unsigned poolid_t;
#define POOL_MAX UINT_MAX
#define POOLID_FMT "u"

struct id_pool;

struct id_pool_head {
	struct id_pool *head;
};

void pool_init(struct id_pool_head *head, poolid_t lower, poolid_t upper);
void pool_free(struct id_pool_head *head);
int pool_take_next(struct id_pool_head *head, poolid_t *id);
int pool_take(struct id_pool_head *head, poolid_t id);
void pool_return(struct id_pool_head *head, poolid_t id);
#ifndef NDEBUG
void pool_dump(const struct id_pool_head *head);
#endif

#endif
