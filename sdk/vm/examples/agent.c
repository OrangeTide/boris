/* agent.c : a verb program (agent).
 *
 * It defines verb_event instead of main() and links the event-loop runtime,
 * which registers it as its object's handler and drives the loop. It greets
 * anyone who enters its room and echoes any user event it is notified with.
 * Built with the vendored skjegg RV32 toolchain. */

#include "verb.h"

void
verb_event(const vm_event_t *ev)
{
	switch (ev->kind) {
	case VM_EV_ENTER:
		sys_broadcast("A shadow stirs as you enter.");
		break;
	case VM_EV_USER:
		sys_broadcast(ev->str);
		break;
	default:
		break;
	}
}
