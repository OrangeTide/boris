/* program.c : @program -- register, unregister, and list program objects.
 *
 * A program object (programs/<id>) names an RV32 ELF image that @run and the
 * verb dispatcher launch. @compile produces one from source; @program is the
 * manual counterpart for an image someone already built:
 *
 *   @program register <id> <image> [ram]   bind programs/<id> to an image
 *   @program unregister <id>                delete programs/<id>
 *   @program list                           show the registered programs
 *
 * <image> is a VFS path when it begins with '/', else a host image relative to
 * the image directory (vm.image_path). [ram] is the guest RAM in bytes, 0 or
 * omitted for the default. Wizard only: a launched program runs code with its
 * owner's authority. */

#include "command.h"
#include <boris.h>
#include "util.h"
#include "user.h"
#include "acs.h"
#include "cmdutil.h"

#include <verb_dispatch.h>

#include <stdlib.h>
#include <string.h>

static void
prog_list_line(const char *prog_id, const char *image, int is_vfs, void *ctx)
{
	DESCRIPTOR_DATA *cl = ctx;

	if (image[0])
		telnetclient_printf(cl, "  %-20s %s %s\n", prog_id,
			is_vfs ? "vfs " : "host", image);
	else
		telnetclient_printf(cl, "  %-20s (no image bound)\n", prog_id);
}

int
command_do_program(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	char sub[32] = "", prog[64] = "", image[512] = "", ramw[32] = "";
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	char err[512] = "";
	uint32_t ram = 0;
	int rc, n;

	arg = util_getword(arg, sub, sizeof sub);
	if (!sub[0]) {
		telnetclient_puts(cl,
			"usage: @program register <id> <image> [ram]\n"
			"       @program unregister <id>\n"
			"       @program list\n");
		return 0;
	}
	if (!acs || !acs_check((struct acs_info *)acs, "fW")) {
		telnetclient_puts(cl, "You are not a wizard.\n");
		return 0;
	}

	if (strcasecmp(sub, "list") == 0) {
		telnetclient_puts(cl, "Registered programs:\n");
		n = verb_program_list(prog_list_line, cl);
		if (n <= 0)
			telnetclient_puts(cl, "  (none)\n");
		return 1;
	}

	if (strcasecmp(sub, "register") == 0) {
		arg = util_getword(arg, prog, sizeof prog);
		arg = util_getword(arg, image, sizeof image);
		arg = util_getword(arg, ramw, sizeof ramw);
		if (!prog[0] || !image[0]) {
			telnetclient_puts(cl,
				"usage: @program register <id> <image> [ram]\n");
			return 0;
		}
		if (ramw[0])
			ram = (uint32_t)strtoul(ramw, NULL, 10);
		rc = verb_program_register(prog, image, ram, err, sizeof err);
		if (rc == 0) {
			telnetclient_printf(cl, "Registered programs/%s -> %s.\n",
				prog, image);
			return 1;
		}
		telnetclient_printf(cl, "Register failed: %s\n",
			err[0] ? err : "unknown error");
		return 0;
	}

	if (strcasecmp(sub, "unregister") == 0) {
		arg = util_getword(arg, prog, sizeof prog);
		if (!prog[0]) {
			telnetclient_puts(cl, "usage: @program unregister <id>\n");
			return 0;
		}
		rc = verb_program_unregister(prog);
		if (rc == 0) {
			telnetclient_printf(cl, "Unregistered programs/%s.\n", prog);
			return 1;
		}
		if (rc == 1)
			telnetclient_printf(cl, "No such program: programs/%s\n", prog);
		else
			telnetclient_printf(cl,
				"Could not unregister programs/%s.\n", prog);
		return 0;
	}

	telnetclient_printf(cl, "Unknown subcommand: %s\n", sub);
	telnetclient_puts(cl, "Try: @program register|unregister|list\n");
	return 0;
}
