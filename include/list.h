/**
 * @file list.h
 *
 * Linked list macros.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2019 Dec 25
 *
 * Written in 2009 by Jon Mayo <jon@rm-f.net>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide.  This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with
 * this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
#ifndef LIST_H_
#define LIST_H_

#include <assert.h>

/*=* Linked list macros *=*/

/* internal macro to hide GCC warnings:
 * warning: the comparison will always evaluate as ‘true’ for the address of ‘foo’ will never be NULL [-Waddress]
 */
#define LIST_assert(e) \
	_Pragma("GCC diagnostic push"); \
	_Pragma("GCC diagnostic ignored \"-Waddress\""); \
	assert(e); \
	_Pragma("GCC diagnostic pop");

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
		LIST_assert(where != NULL && elm != NULL); \
		(elm)->name._prev=&(where)->name._next; \
		if(((elm)->name._next=(where)->name._next)!=NULL) \
			(where)->name._next->name._prev=&(elm)->name._next; \
		*(elm)->name._prev=(elm); \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_INSERT_HEAD(head, elm, name) do { \
		LIST_assert(head != NULL && elm != NULL); \
		(elm)->name._prev=&(head)->_head; \
		if(((elm)->name._next=(head)->_head)!=NULL) \
			(head)->_head->name._prev=&(elm)->name._next; \
		(head)->_head=(elm); \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_REMOVE(elm, name) do { \
		LIST_assert(elm != NULL); \
		if((elm)->name._next!=NULL) \
			(elm)->name._next->name._prev=(elm)->name._prev; \
		if((elm)->name._prev) \
			*(elm)->name._prev=(elm)->name._next; \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_TAIL_ADD(tailptr, elm, name) do { \
		LIST_assert(tailptr != NULL && elm != NULL); \
		(elm)->name._prev=(tailptr); \
		*(tailptr)=(elm); \
		(tailptr)=&(elm)->name._next; \
	} while(0)

/** undocumented - please add documentation. */
#define LIST_TAIL_INIT(head, tailptr) (tailptr)=&LIST_TOP(head)

/******* TODO TODO TODO : write unit test for LIST_xxx macros *******/
#endif
