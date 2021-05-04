#ifndef EV_H
#define EV_H

#define EVENT_NONE              ((eventid_t){0,0})
#define EVENT(id,data)          ((eventid_t){(id),(data)})
#define EVENT_ID(ev)            ((ev).id)
#define EVENT_DATA(ev)          ((ev).data)

typedef struct event { 
    unsigned short id;
    unsigned short data;
} eventid_t;

typedef struct event_queue {
    eventid_t *event_queue;
    size_t event_queue_head, event_queue_tail; /* read from head, write to tail */
    size_t max_event_queue;
} eventqueue_t;

eventid_t evRecv(eventqueue_t *eq);
void evSend(eventqueue_t *eq, eventid_t eid);
int evInit(eventqueue_t *eq);
void evDump(struct event_queue *eq);
void evShutdown(eventqueue_t *eq);
#endif /* EV_H */
