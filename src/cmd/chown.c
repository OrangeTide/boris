/* chown.c : @chown -- set an object's %owner (e.g. to make a program launchable
 * as an agent, which runs as its object's owner) */

#include "command.h"
#include <boris.h>
#include <obj.h>
#include <user.h>
#include <telnetclient.h>
#include <util.h>

#include <stdio.h>
#include <string.h>

/* @chown <object> <owner>: set the %owner of an object to an owner identity,
 * both given as cache ids (for example "programs/greeter" and "chars/1"). This
 * is how a program object gets an owner so it can be launched as an agent.
 * Wizard only; the index-maintaining obj_set_owner keeps per-owner counts
 * accurate. */
int
command_do_chown(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char objid[OBJ_PATH_MAX], owner[OBJ_PATH_MAX], extra[2];
	OBJ *o;

	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return 0;
	}

	arg = util_getword(arg, objid, sizeof objid);
	if (!arg)
		objid[0] = 0;
	arg = util_getword(arg, owner, sizeof owner);
	if (!arg)
		owner[0] = 0;
	if (!objid[0] || !owner[0] || util_getword(arg, extra, sizeof extra)) {
		telnetclient_printf(cl, "usage: %s <object> <owner>\n", cmd);
		return 0;
	}

	/* An owner is always a character: %owner carries a chars/ id throughout
	 * the authority model, so only a chars/ id is accepted here. */
	if (strncmp(owner, "chars/", 6) != 0) {
		telnetclient_printf(cl, "owner must be a character id (chars/...): %s\n",
			owner);
		return 0;
	}

	o = obj_get(objid);
	if (!o) {
		telnetclient_printf(cl, "No such object: %s\n", objid);
		return 0;
	}
	obj_release(o);

	/* The owner must name a real object, so a typo cannot leave an object
	 * owned by a dangling id. */
	o = obj_get(owner);
	if (!o) {
		telnetclient_printf(cl, "No such owner: %s\n", owner);
		return 0;
	}
	obj_release(o);

	if (obj_set_owner(objid, owner) != OBJ_OK) {
		telnetclient_puts(cl, "Could not set the owner.\n");
		return 0;
	}

	telnetclient_printf(cl, "%s is now owned by %s.\n", objid, owner);
	return 1;
}
