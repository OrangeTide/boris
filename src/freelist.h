#ifndef FREELIST_H_
#define FREELIST_H_

#include <list.h>

struct freelist;

struct freelist *freelist_new(unsigned start, unsigned count);
void freelist_free(struct freelist *fl);
long freelist_alloc(struct freelist *fl, unsigned count);
void freelist_pool(struct freelist *fl, unsigned ofs, unsigned count);
int freelist_thwack(struct freelist *fl, unsigned ofs, unsigned count);
#ifndef NTEST
void freelist_test(void);
#endif

#endif
