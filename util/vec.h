#ifndef VEC_H
#define VEC_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define GVEC_STATIC static
#define GVEC_EXPORT /* nothing */

/* generic list/array/stack/vector macros */
#define GVEC_TYPE(vecname,type) struct vecname { int len; int alloc; type *data; }
#define GVEC_DECLARE_ALL_PROTOTYPES(vecname,type) \
inline int vecname##Max(struct vecname *gv); \
int vecname##Bounds(struct vecname *gv, int idx); \
inline void vecname##Index(struct vecname *gv, int idx, type *item); \
inline int vecname##IndexSafe(struct vecname *gv, int idx, type *item); \
int vecname##Init(struct vecname *gv); \
int vecname##Free(struct vecname *gv); \
int vecname##Append(struct vecname *gv, type item); \
int vecname##Pop(struct vecname *gv, type *item); \
int vecname##Delete(struct vecname *gv, int idx, type *item); \
int vecname##DeleteSlow(struct vecname *gv, int idx, type *item); \
int vecname##Insert(struct vecname *gv, int idx, type item); \
/** END **/

#define GVEC_DECLARE_ALL_FUNCTIONS(vecname,type,staticexport) \
/* returns the total number of elements in the vector */ \
staticexport inline int vecname##Max(struct vecname *gv) \
{ \
	return gv->len; \
} \
/* bounds checking routine used by most(but not all) routines */ \
staticexport int vecname##Bounds(struct vecname *gv, int idx) \
{ \
	return (idx>=0 && idx<gv->len); \
} \
/* indexes the vector quickly */ \
staticexport inline void vecname##Index(struct vecname *gv, int idx, type *item) \
{ \
	*item=gv->data[idx]; \
} \
/* indexes the vector with bounds checking */ \
staticexport inline int vecname##IndexSafe(struct vecname *gv, int idx, type *item) \
{ \
	int result; \
	result=vecname##Bounds(gv,idx); \
	if(result) { \
		*item=gv->data[idx]; \
	} \
	return result; \
} \
/* initializes the structure */ \
staticexport int vecname##Init(struct vecname *gv) \
{ \
	gv->len=0; \
	gv->alloc=0; \
	gv->data=NULL; \
	return 1; \
} \
/* frees the whole thing. does not apply anything to every cell */ \
staticexport int vecname##Free(struct vecname *gv) \
{ \
	free(gv->data); \
	gv->data=NULL; \
	gv->len=0; \
	gv->alloc=0; \
	return 1; \
} \
/* attempts to do expand the size and do a realloc */ \
static int vecname##IncreaseSize(struct vecname *gv, int amount) \
{ \
	gv->len+=amount; \
	if(gv->len>=gv->alloc) { \
		type *tmp_data; \
		gv->alloc=gv->len*2+32; \
		tmp_data=realloc(gv->data,gv->alloc*sizeof(*tmp_data)); \
		if(!tmp_data) return 0; \
		gv->data=tmp_data; \
	} \
	return 1; \
} \
/* Places an entry on the end. goes well with Pop */ \
staticexport int vecname##Append(struct vecname *gv, type item) \
{ \
	vecname##IncreaseSize(gv,1); \
	gv->data[gv->len-1]=item; \
	return 1; \
} \
 \
/* adjust the allocation from length shortening */ \
static int vecname##Adjust(struct vecname *gv) \
{ \
	/* TODO: calculate the intersection of y=x*4+32 and y=x*2+32 */ \
	if(gv->len*4+32<gv->alloc) { \
		type *tmp_data; \
		gv->alloc=gv->len*2+32; \
		tmp_data=realloc(gv->data,gv->alloc*sizeof(*tmp_data)); \
		if(!tmp_data) return 0; \
		gv->data=tmp_data; \
	} \
	return 1; \
} \
/* pop an entry off like it was a stack. goes well with Append */ \
staticexport int vecname##Pop(struct vecname *gv, type *item) \
{ \
	if(gv->len<=0) { return 0; } \
	*item=gv->data[--gv->len]; \
	vecname##Adjust(gv); \
	return 1; \
} \
 \
/* copy the last item over the old item */ \
staticexport int vecname##Delete(struct vecname *gv, int idx, type *item) \
{ \
	if(!vecname##Bounds(gv,idx)) return 0; \
	if(item) *item=gv->data[idx]; \
	gv->data[idx]=gv->data[--gv->len]; \
	vecname##Adjust(gv); \
	return 1; \
} \
/* shift the entire list. this preserves the order */ \
staticexport int vecname##DeleteSlow(struct vecname *gv, int idx, type *item) \
{ \
	if(!vecname##Bounds(gv,idx)) return 0; \
	if(item) *item=gv->data[idx]; \
	gv->len--; \
	if(gv->len != idx) {  /* don't bother with the last element */ \
	memmove(gv->data+idx,gv->data+idx+1,sizeof(*gv->data)*(gv->len-idx)); \
	} \
	return 1; \
} \
/* insert an entry before */ \
staticexport int vecname##Insert(struct vecname *gv, int idx, type item) \
{ \
	if(!((idx>=0 && idx<=gv->len))) return 0; \
	vecname##IncreaseSize(gv,1); \
	memmove(gv->data+idx+1,gv->data+idx,sizeof(*gv->data)*(gv->len-idx+1)); \
	gv->data[idx]=item; \
	return 1; \
} \
/* index starts from the end. handy for stacks */ \
staticexport int vecname##Peek(struct vecname *gv, int idx, type *item) \
{ \
	return vecname##IndexSafe(gv,gv->len-idx-1,item); \
} \
/** END **/

#endif /* VEC_H */
