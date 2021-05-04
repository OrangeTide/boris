#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ev.h"


static size_t nr_event_queue(struct event_queue *eq)
{
    int ret;
    ret=(eq->event_queue_tail-eq->event_queue_head);
    if(eq->event_queue_tail<eq->event_queue_head)
        ret+=eq->max_event_queue;
    return ret;
}


static void ev_put(eventqueue_t *eq, eventid_t eid)
{
    if(nr_event_queue(eq)>=eq->max_event_queue) {
        size_t new_sz;
        new_sz=(eq->max_event_queue*2+16)&~15;
        eq->event_queue=realloc(eq->event_queue,new_sz * sizeof *eq->event_queue);
        if(eq->event_queue_head>eq->event_queue_tail) {
            size_t len;
            len=eq->max_event_queue-eq->event_queue_head;
            memmove(eq->event_queue+new_sz-len, eq->event_queue+eq->event_queue_head, len);
        }
        eq->max_event_queue=new_sz;
    }
    eq->event_queue[eq->event_queue_tail++]=eid;
    if(eq->event_queue_tail>=eq->max_event_queue) eq->event_queue_tail-=eq->max_event_queue;
}

static eventid_t ev_take(struct event_queue *eq)
{
    eventid_t ret={0,0};

    if(nr_event_queue(eq)) {
        ret=eq->event_queue[eq->event_queue_head++];
        if(eq->event_queue_head>=eq->max_event_queue) eq->event_queue_head-=eq->max_event_queue;
    }

    return ret;
}

/*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*/

eventid_t evRecv(eventqueue_t *eq)
{
    return ev_take(eq);
}

void evSend(eventqueue_t *eq,eventid_t eid)
{
    ev_put(eq,eid);
}

int evInit(eventqueue_t *eq)
{
    *eq=(eventqueue_t){0,0,0,0};
    ev_put(eq,EVENT(1,0));
    ev_put(eq,EVENT(2,0));
    ev_put(eq,EVENT(3,0));
    ev_take(eq);
    ev_take(eq);
    ev_take(eq);

    return 0;
}

void evShutdown(eventqueue_t *eq)
{
}

/* for debugging visually. */
void evDump(struct event_queue *eq)
{
    int i;
    for(i=0;i<eq->max_event_queue;i++) {
        fprintf(stderr,"%5d", eq->event_queue[i].id);
    }
    fprintf(stderr,"\n");
    for(i=0;i<eq->max_event_queue;i++) {
        fprintf(stderr,"  %c_%c", 
        i==eq->event_queue_head?'H':' ', 
        i==eq->event_queue_tail?'T':' ');
    }
    fprintf(stderr,"\n");
}
