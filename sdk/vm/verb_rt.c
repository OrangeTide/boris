/* verb_rt.c : the event-loop runtime for verb programs (agents).
 *
 * This supplies main() so a verb program does not. It registers the task as its
 * object's event handler, then loops: drain every queued event and hand each to
 * the program's verb_event, then block until the next one arrives. The program
 * links this file plus its own verb_event; that link choice, not a VM feature,
 * is what makes it event-driven. See doc/mud-vm-design.md "Program vs Verb".
 *
 * When idle it sleeps for the dwell period; the host then delivers a
 * VM_EV_TIMER, which the program sees as a periodic tick. A real event arriving
 * during the sleep wakes it early, so events are never delayed by the dwell. */

#include "verb.h"

/* Dwell period in milliseconds: how often an idle agent gets a timer tick. */
#define VERB_DWELL_MS 1000

int
main(void)
{
	vm_event_t ev;

	sys_listen();
	for (;;) {
		while (sys_getmsg(&ev, sizeof ev) != VM_EV_NONE)
			verb_event(&ev);
		sys_suspend(VM_SUSPEND_SLEEP, VERB_DWELL_MS);
	}
	return 0;
}
