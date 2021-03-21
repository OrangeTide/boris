/* darray.h : dynamic arrays */
#ifndef DARRAY_H
#define DARRAY_H
/******************************************************************************/
#define DARRAY_typedef(typename, itype) typedef struct typename { itype *data; unsigned nr; unsigned max; } typename
#define DARRAY_APPEND_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { if(dest->nr+1>=dest->max) { dest->max=(dest->nr+1)*2; dest->data=realloc(dest->data, sizeof *dest->data * dest->max); } dest->data[dest->nr++]=*item; } inline void funcname(typename *dest, const itype *item)

#define DARRAY_CAT_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { unsigned len=0; while(item[len++]) ; if(dest->nr+len>=dest->max) { dest->max=(dest->nr+len)*2; dest->data=realloc(dest->data, sizeof *dest->data * dest->max); } memcpy(dest->data+dest->nr,item,len * sizeof *item); dest->nr+=len; } inline void funcname(typename *dest, const itype *item)

#define DARRAY_COPY_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { unsigned len=0; while(item[len++]) ; dest->max=dest->nr=len; free(dest->data); dest->data=malloc(sizeof *dest->data * len); memcpy(dest->data,item,len * sizeof *item); } inline void funcname(typename *dest, const itype *item)

#define DARRAY_INIT_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { *dest=(typename){0}; } inline void funcname(typename *dest, const itype *item)

#define DARRAY_SET_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { dest->max=dest->nr=1; free(dest->data); dest->data=malloc(sizeof *dest->data); *dest->data=*item; } inline void funcname(typename *dest, const itype *item)

#define DARRAY_FREE_def(typename, itype, funcname) inline void funcname(typename *dest, const itype *item) { dest->max=dest->nr=0; free(dest->data); dest->data=0; } inline void funcname(typename *dest, const itype *item)

/******************************************************************************/
#endif /* DARRAY_H */
