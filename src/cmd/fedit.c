/* fedit.c : @fedit -- edit (or create) a file in the in-world filesystem.
 *
 * `@fedit <path>` opens the online string editor (src/stred) on the VFS file
 * at an absolute path, seeded with its current contents, and on save writes it
 * back and commits. A path that does not exist yet is created on save. This is
 * the in-world way to author a source for @compile without host access. Wizard
 * only: it writes the shared in-world tree that programs launch and compile
 * from.
 *
 * This is the line-oriented editor boris already ships. A richer full-screen
 * editor (the vedit project) is a possible later upgrade for capable terminal
 * clients; see kanban/in-world-source-tooling.md. */

#include "command.h"
#include <boris.h>
#include <user.h>
#include <telnetclient.h>
#include <util.h>

#include <stred.h>
#include <verb_dispatch.h>
#include <vfs.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Carried across the asynchronous edit; freed when the editor finishes. */
struct fedit_ctx {
	char path[VFS_PATH_MAX];
};

/* The editor finished. On a real change write the buffer back to the VFS and
 * commit it; then always resume the command prompt and free the context. */
static void
fedit_done(DESCRIPTOR_DATA *cl, const char *result, int changed, void *ctx)
{
	struct fedit_ctx *fc = ctx;
	struct vfs *v = verb_dispatch_vfs();

	if (!changed) {
		telnetclient_printf(cl, "%s unchanged.\n", fc->path);
	} else if (!v) {
		telnetclient_puts(cl, "No in-world VFS is available; not saved.\n");
	} else if (vfs_write(v, fc->path, result, strlen(result)) != VFS_OK) {
		telnetclient_printf(cl, "Could not write %s.\n", fc->path);
	} else if (vfs_commit(v, "fedit") != VFS_OK) {
		telnetclient_printf(cl, "Wrote %s but could not commit it.\n", fc->path);
	} else {
		telnetclient_printf(cl, "Saved %s (%zu bytes).\n", fc->path,
			strlen(result));
	}

	free(fc);
	command_resume(cl);
}

int
command_do_fedit(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX];
	struct vfs *v;
	struct vfs_stat st;
	struct fedit_ctx *fc;
	void *data = NULL;
	size_t len = 0;
	const char *seed = "";
	int rc;

	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return 0;
	}

	arg = util_getword(arg, path, sizeof path);
	if (!path[0]) {
		telnetclient_printf(cl, "usage: %s <path>\n", cmd);
		telnetclient_puts(cl,
			"Edit a file in the in-world filesystem, e.g. /src/foo.kp\n");
		return 0;
	}
	if (path[0] != '/') {
		telnetclient_puts(cl,
			"The path must be absolute, e.g. /src/foo.kp\n");
		return 0;
	}

	v = verb_dispatch_vfs();
	if (!v) {
		telnetclient_puts(cl, "No in-world VFS is available.\n");
		return 0;
	}

	/* An existing path must be a file small enough for the editor; a new
	 * path (ENOTFOUND) starts empty. */
	rc = vfs_stat(v, path, &st);
	if (rc == VFS_OK) {
		if (st.kind == VFS_KIND_DIR) {
			telnetclient_printf(cl, "%s is a directory.\n", path);
			return 0;
		}
		if (st.size > STRED_BUF_MAX) {
			telnetclient_printf(cl,
				"%s is too large to edit here (%llu bytes; max %d).\n",
				path, (unsigned long long)st.size, STRED_BUF_MAX);
			return 0;
		}
		if (vfs_read(v, path, &data, &len) == VFS_OK && data)
			seed = data;            /* vfs_read NUL-terminates */
	} else if (rc != VFS_ENOTFOUND) {
		telnetclient_printf(cl, "Cannot open %s.\n", path);
		return 0;
	}

	fc = calloc(1, sizeof *fc);
	if (!fc) {
		free(data);
		telnetclient_puts(cl, "Out of memory.\n");
		return 0;
	}
	snprintf(fc->path, sizeof fc->path, "%s", path);

	/* stred_new copies the seed, so the read buffer can go once the editor
	 * has started. The editor takes over line input; fedit_done resumes it. */
	stred_start(cl, seed, STRED_MULTI, fedit_done, fc);
	free(data);
	return 1;
}
