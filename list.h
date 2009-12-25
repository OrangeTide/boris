#ifndef LIST_H
#define LIST_H

/*=* Linked list macros *=*/

/** undocumented - please add documentation. */
#define LIST_ENTRY(type) struct { type *_next, **_prev; }

/** undocumented - please add documentation. */
#define LIST_HEAD(headname, type) headname { type *_head; }

/** undocumented - please add documentation. */
#define LIST_INIT(head) ((head)->_head=NULL)

/** undocumented - please add documentation. */
#define LIST_ENTRY_INIT(elm, name) do { (elm)->name._next=NULL; (elm)->name._prev=NULL; } while(0)

/** undocumented - please add documentation. */
#define LIST_TOP(head) ((head)._head)

/** undocumented - please add documentation. */
#define LIST_NEXT(elm, name) ((elm)->name._next)

/** undocumented - please add documentation. */
#define LIST_PREVPTR(elm, name) ((elm)->name._prev)

/** undocumented - please add documentation. */
#define LIST_INSERT_ATPTR(prevptr, elm, name) do { \
	(elm)->name._prev=(prevptr); \
	if(((elm)->name._next=*(prevptr))!=NULL) \
		(elm)->name._next->name._prev=&(elm)->name._next; \
	*(prevptr)=(elm); \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_INSERT_AFTER(where, elm, name) do { \
		assert(where != NULL && elm != NULL); \
		(elm)->name._prev=&(where)->name._next; \
		if(((elm)->name._next=(where)->name._next)!=NULL) \
			(where)->name._next->name._prev=&(elm)->name._next; \
		*(elm)->name._prev=(elm); \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_INSERT_HEAD(head, elm, name) do { \
		assert(head != NULL && elm != NULL); \
		(elm)->name._prev=&(head)->_head; \
		if(((elm)->name._next=(head)->_head)!=NULL) \
			(head)->_head->name._prev=&(elm)->name._next; \
		(head)->_head=(elm); \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_REMOVE(elm, name) do { \
		assert(elm != NULL); \
		if((elm)->name._next!=NULL) \
			(elm)->name._next->name._prev=(elm)->name._prev; \
		if((elm)->name._prev) \
			*(elm)->name._prev=(elm)->name._next; \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_TAIL_ADD(tailptr, elm, name) do { \
		assert(tailptr != NULL && elm != NULL); \
		(elm)->name._prev=(tailptr); \
		*(tailptr)=(elm); \
		(tailptr)=&(elm)->name._next; \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_TAIL_INIT(head, tailptr) (tailptr)=&LIST_TOP(head)

/******* TODO TODO TODO : write unit test for LIST_xxx macros *******/
#endif
