/* look.c : an example command verb.
 *
 * Dispatched when a player types the word bound to this program. Its spec is
 * "<obj>" (optionally "<obj> <any>"): the host resolves the named object to a
 * handle and hands it over typed. The verb reads the object's short name and
 * broadcasts it, or falls back to any free-form text. Built with the vendored
 * skjegg RV32 toolchain, linking cmd_crt.o and cmd_rt.o in place of crt0.o. */

#include "cmd.h"

int
main(void)
{
	unsigned target = cmd_arg_obj();        /* <obj> -> handle, or none */
	const char *rest = cmd_arg_str();       /* <any> -> free-form tail */
	char name[64];

	if (target != VM_HANDLE_NONE &&
	    sys_getprop(target, "name.short", name, sizeof name) > 0)
		sys_broadcast(name);
	else if (rest)
		sys_broadcast(rest);
	return 0;
}
