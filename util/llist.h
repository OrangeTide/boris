/* ll.h : linked-list library */
/* the interface is patterned after the BSD4.4lite sys/queue.h file. a lot of
 * the * "code" is simular, but such simple code lends itself to a simple
 * solution
 */

/* CONVENTIONS:
 *	what		the element you are manipulating
 *	where		location in list to use
 *	field		name of field. ( LIST_ENTRY(type) field; )
 *	headlist	LIST_HEAD(name,type) headlist;
 *	name		struct name {} for headlist, used when passing to
 *			functions.
 */

/* doubly-linked list. this is the default in the sys/queue.h 
 * it's doublly linked, but we can't move forward in the list because prev
 * points to the previous next field. */

#ifndef LL_H
#define LL_H

#define LIST_HEAD(name, type)		struct name { struct type *head; }
#define LIST_ENTRY(type)		struct { struct type *next; struct type **prev; }
#define LIST_INIT(headlist)		(headlist)->head=NULL
#define LIST_ENTRY_INIT(what,field)	{(what)->field.next=NULL; (what)->field.prev=NULL;}
#define LIST_INSERT_AFTER(where, what, field)				\
			{						\
			(what)->field.next=(where)->field.next; 	\
			(what)->field.prev=&(where)->field.next;	\
			if((what)->field.next!=NULL)			\
				(where)->field.next->field.prev=	\
				&(what)->field.next;			\
			*(what)->field.prev=(what);			\
			}
						
#define LIST_INSERT_HEAD(headlist, what, field)				\
			{						\
			(what)->field.next=(headlist)->head;		\
			(what)->field.prev=&(headlist)->head;		\
			if((what)->field.next!=NULL)			\
				(headlist)->head->field.prev=		\
				&(what)->field.next;			\
			(headlist)->head=(what);			\
			}
#define LIST_REMOVE(what,field)						\
			{						\
			if((what)->field.next != NULL) 			\
				(what)->field.next->field.prev=		\
				(what)->field.prev;			\
			*(what)->field.prev=(what)->field.next;		\
			}
#define LIST_NEXT(what,field)		((what)->field.next)
#define LIST_FIRST(headlist)		((headlist)->head)

#if 0 /* INCOMPLETE */
/* doubly-linked list */
#define DLIST_HEAD(name,type)		struct name { struct type *head, *tail; }
#define DLIST_ENTRY(type)
#define DLIST_INIT(headlist)
#define DLIST_INSERT_AFTER(where,what,field)
#define DLIST_INSERT_HEAD(where,what,field)
#define DLIST_REMOVE(elm,field)
#define DLIST_NEXT(elm,field)
#define DLIST_PREV(elm,field)

/* singly-linked list */
#define SLIST_HEAD(name, type)		LIST_HEAD(name,type)
#define SLIST_ENTRY(type)		struct { struct type *next; }
#define SLIST_INIT(headlist)		LIST_INIT(headlist)
#define SLIST_INSERT_AFTER(where, what, field)				\
				{ 					\
				(what)->field.next =			\
				(where)->field.next; 			\
				(where)->field.next = (what);		\
				}
#define SLIST_INSERT_HEAD(head, elm, first)
#define SLIST_REMOVE(elm,prevelm,head,field) /* much more complicated to remove */
#define SLIST_NEXT(elm,field)		LIST_NEXT(elm,field)


/* for handling dynamic tables of pointers */
/* next_free is an integer for the next free entry+1 in the table. (so
 * initilizing to 0 will mean it's appropriately initialized) */
#define TABLE_HEAD(type)		struct {			\
						union { 		\
						struct type *data;	\
						int next_free;		\
					} *table; 			\
					int max;			\
					int first_free;			\
					}
#define TABLE_ADD(tab,what)		

#endif /* INCOMPLETE */

#endif /* LL_H */
