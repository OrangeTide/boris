/* verb.h : the verb-program (agent) runtime contract.
 *
 * A one-shot program defines main(). A verb program does not: it links the
 * event-loop runtime (verb_rt.c), which supplies main(), registers the program
 * as its object's handler, and calls the function below once per event. This
 * is the "who supplies main()" split from doc/mud-vm-design.md, a link-time
 * choice, not a VM feature. */

#ifndef VM_VERB_H
#define VM_VERB_H

#include "vmsys.h"

/* Handle one event delivered to the program's object. Supplied by the verb
 * program in place of main(). */
void verb_event(const vm_event_t *ev);

#endif /* VM_VERB_H */
