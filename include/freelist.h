#ifndef FREELIST_H_
#define FREELIST_H_

#include <list.h>

struct freelist_entry;
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

void freelist_init(struct freelist *fl);
void freelist_free(struct freelist *fl);
long freelist_alloc(struct freelist *fl, unsigned count);
void freelist_pool(struct freelist *fl, unsigned ofs, unsigned count);
int freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count);
#ifndef NTEST
void freelist_test(void);
#endif

#endif
