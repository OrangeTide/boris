/* pq.h - Priority Queue using a binary heap.
 *
 * Jon Mayo
 * PUBLIC DOMAIN or licensed under MIT-0.
 *
 * original: 19 Jun 2007
 * updated: 4 Apr 2026
 *
 * STB-style single-header priority queue using a flattened binary heap.
 * Configurable as min-heap or max-heap via PQ_COMPARE.
 *
 * The priority queues are limited in size at initialization. they can be
 * resized at some cost (realloc).
 *
 * QUICK START
 *
 *   In one C file:
 *     #define PQ_IMPLEMENTATION
 *     #include "pq.h"
 *
 *   Everywhere else:
 *     #include "pq.h"
 *
 * CUSTOMIZATION
 *
 *   Define before including pq.h:
 *     PQ_ENTRY_TYPE  - type stored in the queue (default: unsigned)
 *     PQ_KEY(e)      - extract sort key from entry (default: (e))
 *     PQ_COMPARE(a,b)- non-zero if a should be deeper than b
 *                       (default: min-heap, PQ_KEY(a) > PQ_KEY(b))
 *     PQ_STATIC      - make all functions static
 *     PQ_NAME        - prefix for struct and functions (default: pq)
 *
 * MULTIPLE QUEUE TYPES
 *
 *   All PQ_* macros are cleaned up after each inclusion, so you can
 *   re-include with different settings:
 *
 *     #define PQ_NAME       timer_pq
 *     #define PQ_ENTRY_TYPE struct timer
 *     #define PQ_KEY(e)     ((e).deadline)
 *     #define PQ_STATIC
 *     #define PQ_IMPLEMENTATION
 *     #include "pq.h"
 *     // creates: struct timer_pq, timer_pq_init(), timer_pq_enqueue(), ...
 *
 *     #define PQ_NAME       score_pq
 *     #define PQ_ENTRY_TYPE int
 *     #define PQ_COMPARE(a,b) ((a) < (b))
 *     #define PQ_STATIC
 *     #define PQ_IMPLEMENTATION
 *     #include "pq.h"
 *     // creates: struct score_pq, score_pq_init(), score_pq_enqueue(), ...
 */

/*** utility macros (include-guarded) ***/
#ifndef PQ__H_MACROS
#define PQ__H_MACROS
#define PQ__CAT2(a, b) a##_##b
#define PQ__CAT(a, b) PQ__CAT2(a, b)
#endif

/*** defaults ***/

#ifndef PQ_NAME
#  define PQ_NAME pq
#  define PQ__DEFAULT
#endif

#ifndef PQ_ENTRY_TYPE
#  define PQ_ENTRY_TYPE unsigned
#endif

#ifndef PQ_KEY
#  define PQ_KEY(e) (e)
#endif

#ifndef PQ_COMPARE
#  define PQ_COMPARE(a, b) (PQ_KEY(a) > PQ_KEY(b))
#endif

#ifdef PQ_STATIC
#  define PQ__API static
#else
#  define PQ__API extern
#endif

#define PQ__FUNC(n) PQ__CAT(PQ_NAME, n)

/*** declarations (default name is guarded against re-declaration) ***/
#if !defined(PQ__DEFAULT) || !defined(PQ__DEFAULT_DECLARED)
#ifdef PQ__DEFAULT
#  define PQ__DEFAULT_DECLARED
#endif

struct PQ_NAME {
	unsigned nr, max;
	PQ_ENTRY_TYPE *entry;
};

PQ__API int           PQ__FUNC(init)(struct PQ_NAME *pq, unsigned max);
PQ__API void          PQ__FUNC(free)(struct PQ_NAME *pq);
PQ__API int           PQ__FUNC(resize)(struct PQ_NAME *pq, unsigned newmax);
PQ__API int           PQ__FUNC(enqueue)(struct PQ_NAME *pq, PQ_ENTRY_TYPE e);
PQ__API int           PQ__FUNC(dequeue)(struct PQ_NAME *pq, PQ_ENTRY_TYPE *dst);
PQ__API int           PQ__FUNC(remove)(struct PQ_NAME *pq, unsigned i,
                                       PQ_ENTRY_TYPE *dst);
PQ__API PQ_ENTRY_TYPE *PQ__FUNC(peek)(struct PQ_NAME *pq, unsigned i);
PQ__API PQ_ENTRY_TYPE *PQ__FUNC(top)(struct PQ_NAME *pq);
PQ__API int           PQ__FUNC(find)(struct PQ_NAME *pq, PQ_ENTRY_TYPE e);
PQ__API unsigned      PQ__FUNC(size)(struct PQ_NAME *pq);
PQ__API unsigned      PQ__FUNC(available)(struct PQ_NAME *pq);

#ifndef NDEBUG
PQ__API int           PQ__FUNC(is_valid)(struct PQ_NAME *pq);
#endif

#endif /* declarations */

/*** implementation ***/
#ifdef PQ_IMPLEMENTATION

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#define PQ__PARENT(i) (((i) - 1) / 2)
#define PQ__LEFT(i)   (2 * (i) + 1)
#define PQ__RIGHT(i)  (2 * (i) + 2)

/* move a hole at position i upward until it finds the right place for elm.
 * returns the final position of the hole. */
static unsigned PQ__FUNC(siftup_)(struct PQ_NAME *pq, unsigned i,
                                   PQ_ENTRY_TYPE elm)
{
	while (i > 0 && PQ_COMPARE(pq->entry[PQ__PARENT(i)], elm)) {
		pq->entry[i] = pq->entry[PQ__PARENT(i)];
		i = PQ__PARENT(i);
	}
	return i;
}

/* move a hole at position i downward until it finds the right place for elm.
 * returns the final position of the hole. */
static unsigned PQ__FUNC(siftdown_)(struct PQ_NAME *pq, unsigned i,
                                     PQ_ENTRY_TYPE elm)
{
	while (PQ__LEFT(i) < pq->nr) {
		unsigned child = PQ__LEFT(i);

		/* pick the child that should be higher in the heap */
		if (child + 1 < pq->nr &&
		    PQ_COMPARE(pq->entry[child], pq->entry[child + 1]))
			child++;

		/* if elm belongs above both children, stop */
		if (!PQ_COMPARE(elm, pq->entry[child]))
			break;

		pq->entry[i] = pq->entry[child];
		i = child;
	}
	return i;
}

PQ__API int PQ__FUNC(init)(struct PQ_NAME *pq, unsigned max)
{
	assert(pq != NULL);
	assert(max > 0);
	pq->entry = calloc(max, sizeof *pq->entry);
	if (!pq->entry) {
		pq->nr = 0;
		pq->max = 0;
		return 0;
	}
	pq->nr = 0;
	pq->max = max;
	return 1;
}

PQ__API void PQ__FUNC(free)(struct PQ_NAME *pq)
{
	assert(pq != NULL);
	free(pq->entry);
	pq->entry = NULL;
	pq->nr = 0;
	pq->max = 0;
}

PQ__API int PQ__FUNC(resize)(struct PQ_NAME *pq, unsigned newmax)
{
	PQ_ENTRY_TYPE *tmp;
	assert(pq != NULL);
	if (newmax < pq->nr)
		return 0; /* cannot shrink below current count */
	tmp = realloc(pq->entry, newmax * sizeof *pq->entry);
	if (!tmp && newmax > 0)
		return 0;
	pq->entry = tmp;
	pq->max = newmax;
	return 1;
}

PQ__API int PQ__FUNC(enqueue)(struct PQ_NAME *pq, PQ_ENTRY_TYPE e)
{
	unsigned i;
	assert(pq != NULL);
	if (pq->nr >= pq->max)
		return 0;
	i = pq->nr++;
	i = PQ__FUNC(siftup_)(pq, i, e);
	pq->entry[i] = e;
	return 1;
}

PQ__API int PQ__FUNC(dequeue)(struct PQ_NAME *pq, PQ_ENTRY_TYPE *dst)
{
	return PQ__FUNC(remove)(pq, 0, dst);
}

/* remove entry at index i. handles both sift-up and sift-down cases. */
PQ__API int PQ__FUNC(remove)(struct PQ_NAME *pq, unsigned i,
                              PQ_ENTRY_TYPE *dst)
{
	PQ_ENTRY_TYPE last;
	unsigned j;
	assert(pq != NULL);
	if (i >= pq->nr)
		return 0;
	if (dst)
		*dst = pq->entry[i];
	pq->nr--;
	if (i == pq->nr)
		return 1; /* removed the last element, nothing to fix */
	last = pq->entry[pq->nr];

	/* try sifting up first */
	if (i > 0 && PQ_COMPARE(pq->entry[PQ__PARENT(i)], last))
		j = PQ__FUNC(siftup_)(pq, i, last);
	else
		j = PQ__FUNC(siftdown_)(pq, i, last);
	pq->entry[j] = last;
	return 1;
}

PQ__API PQ_ENTRY_TYPE *PQ__FUNC(peek)(struct PQ_NAME *pq, unsigned i)
{
	assert(pq != NULL);
	if (i < pq->nr)
		return &pq->entry[i];
	return NULL;
}

PQ__API PQ_ENTRY_TYPE *PQ__FUNC(top)(struct PQ_NAME *pq)
{
	return PQ__FUNC(peek)(pq, 0);
}

/* linear search for an entry by value.
 * returns index on success, -1 on failure.
 * the index is only valid until the heap is modified. */
PQ__API int PQ__FUNC(find)(struct PQ_NAME *pq, PQ_ENTRY_TYPE e)
{
	unsigned i;
	assert(pq != NULL);
	for (i = 0; i < pq->nr; i++) {
		if (PQ_KEY(pq->entry[i]) == PQ_KEY(e))
			return (int)i;
	}
	return -1;
}

PQ__API unsigned PQ__FUNC(size)(struct PQ_NAME *pq)
{
	assert(pq != NULL);
	return pq->nr;
}

PQ__API unsigned PQ__FUNC(available)(struct PQ_NAME *pq)
{
	assert(pq != NULL);
	assert(pq->max >= pq->nr);
	return pq->max - pq->nr;
}

#ifndef NDEBUG

PQ__API int PQ__FUNC(is_valid)(struct PQ_NAME *pq)
{
	unsigned i;
	for (i = 1; i < pq->nr; i++) {
		if (PQ_COMPARE(pq->entry[PQ__PARENT(i)], pq->entry[i])) {
			fprintf(stderr, "heap violation at %u\n", i);
			return 0;
		}
	}
	return 1;
}

#endif /* !NDEBUG */

#undef PQ__PARENT
#undef PQ__LEFT
#undef PQ__RIGHT

#endif /* PQ_IMPLEMENTATION */

/*** cleanup ***/
#undef PQ__FUNC
#undef PQ__API
#undef PQ_NAME
#undef PQ_ENTRY_TYPE
#undef PQ_KEY
#undef PQ_COMPARE
#undef PQ_STATIC
#undef PQ_IMPLEMENTATION
#ifdef PQ__DEFAULT
#  undef PQ__DEFAULT
#endif
