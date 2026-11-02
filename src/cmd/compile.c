/* compile.c : @compile -- compile a VFS source to an RV32 ELF in the VFS.
 *
 * The in-world front door to the compile pipeline (doc/vm-hosting-proposal P3).
 * `@compile <src> [<out>]` reads a guest source at an absolute VFS path and
 * compiles it by its extension: .c is C, .s or .S is assembly. It runs the
 * skjegg toolchain -- itself RV32 guests under the embedded runtime, confined
 * to a build directory through a hostcap mount -- to produce an RV32 ELF at
 * <out> in the VFS (default /bin/<name>.elf). Because the toolchain stages run
 * as guests, not host subprocesses, the compile needs no execve and runs inside
 * the security sandbox. Binding and launching the result is @program / @run.
 *
 * A compiled program links the C start files and the confined libc, so it must
 * supply main(). Wizard only: it writes the shared in-world tree. */

#include "command.h"
#include <boris.h>
#include "mudconfig.h"
#include <util.h>
#include <user.h>
#include <acs.h>
#include "cmdutil.h"

#include <verb_dispatch.h>
#include <vfs.h>
#include <vfs_compile.h>

#include <stdio.h>
#include <string.h>

/* Derive /bin/<leaf-without-extension>.elf from a source VFS path. */
static void
default_out(const char *src, char *out, size_t outsz)
{
	const char *leaf = strrchr(src, '/');
	const char *dot;
	char base[64];
	size_t n;

	leaf = leaf ? leaf + 1 : src;
	dot = strrchr(leaf, '.');
	n = dot ? (size_t)(dot - leaf) : strlen(leaf);
	if (n == 0 || n >= sizeof base)
		n = 0;
	memcpy(base, leaf, n);
	base[n] = '\0';
	snprintf(out, outsz, "/bin/%s.elf", n ? base : "out");
}

int
command_do_compile(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd UNUSED,
	const char *arg)
{
	char src[512] = "", out[512] = "";
	struct user *user = telnetclient_user(cl);
	const struct acs_info *acs = user_acs(user);
	struct vfs *v = verb_dispatch_vfs();
	struct vfs_compile_cfg cfg;
	char err[2048] = "";
	int rc;

	arg = util_getword(arg, src, sizeof src);
	arg = util_getword(arg, out, sizeof out);
	if (!src[0]) {
		telnetclient_puts(cl,
			"usage: @compile <src> [<out>]   (src: .c or .s/.S)\n");
		return 0;
	}
	if (!acs || !acs_check((struct acs_info *)acs, "fW")) {
		telnetclient_puts(cl, "You are not a wizard.\n");
		return 0;
	}
	if (!v) {
		telnetclient_puts(cl, "The in-world filesystem is unavailable.\n");
		return 0;
	}
	if (src[0] != '/') {
		telnetclient_puts(cl,
			"The source must be an absolute VFS path, e.g. /src/foo.c\n");
		return 0;
	}
	if (!out[0])
		default_out(src, out, sizeof out);
	else if (out[0] != '/') {
		telnetclient_puts(cl,
			"The output must be an absolute VFS path, e.g. /bin/foo.elf\n");
		return 0;
	}

	memset(&cfg, 0, sizeof cfg);
	cfg.toolchain_dir = mud_config.vm_toolchain_dir;
	cfg.lib_dir = mud_config.vm_lib_dir;
	cfg.include_dir = mud_config.vm_include_dir;
	cfg.workdir = mud_config.vm_tmpdir;

	rc = vfs_compile(v, src, out, &cfg, err, sizeof err);
	if (rc == VFS_COMPILE_OK) {
		telnetclient_printf(cl, "Compiled %s -> %s.\n", src, out);
		return 1;
	}
	if (err[0])
		telnetclient_printf(cl, "Compile failed: %s\n", err);
	else
		telnetclient_printf(cl, "Compile failed (code %d).\n", rc);
	return 0;
}
