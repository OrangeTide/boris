/* vfscmd.c : in-world VFS file commands (FTP-like parity).
 *
 * A small family of wizard commands over the in-world filesystem (the VFS the
 * dispatcher is bound to), beside @fedit:
 *
 *   @fls   [path]   list a directory, or stat a single file
 *   @fcat  <path>   show a text file (refuses a binary or ELF file)
 *   @ftype <path>   classify a file as text, binary, or ELF
 *   @fput  <path>   upload client bytes into the VFS (web/MCP client)
 *   @fget  <path>   download a VFS file to the client (web/MCP client)
 *
 * All paths are absolute VFS paths. These read and write the shared in-world
 * tree that programs launch and compile from, so they are wizard only. */

#include "command.h"
#include <boris.h>
#include <user.h>
#include <telnetclient.h>
#include <util.h>

#include <verb_dispatch.h>
#include <vfs.h>
#include "web/server/webclient.h"

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* How much of a file to sniff when classifying it. */
#define FT_SNIFF 4096
/* Largest text file @fcat will print, to avoid flooding a connection. */
#define FCAT_MAX 65536

enum ftype { FT_TEXT, FT_BINARY, FT_ELF };

static const char *
ftype_name(enum ftype t)
{
	switch (t) {
	case FT_ELF:    return "ELF";
	case FT_BINARY: return "binary";
	default:        return "text";
	}
}

/* Classify bytes as text, binary, or ELF. ELF wins on the 4-byte magic. A NUL
 * byte, or too many bytes outside the printable-plus-whitespace set, marks it
 * binary; otherwise it is text. Deliberately simple: a dumbed-down file(1) that
 * only needs these three answers. */
static enum ftype
classify(const unsigned char *buf, size_t len)
{
	size_t n = len < FT_SNIFF ? len : FT_SNIFF;
	size_t i, odd = 0;

	if (len >= 4 && buf[0] == 0x7f && buf[1] == 'E' && buf[2] == 'L'
	    && buf[3] == 'F')
		return FT_ELF;
	for (i = 0; i < n; i++) {
		unsigned char c = buf[i];

		if (c == 0)
			return FT_BINARY;
		if (c == '\t' || c == '\n' || c == '\r' || c == '\f' || c == '\v')
			continue;
		if (c < 0x20 || c >= 0x7f)
			odd++;
	}
	/* Allow a few stray control/high bytes, but a tenth or more is binary. */
	if (n && odd * 10 >= n)
		return FT_BINARY;
	return FT_TEXT;
}

/* Common front matter: wizard gate, grab an absolute path, resolve the VFS.
 * Returns the VFS on success, or NULL after telling the user why not. */
static struct vfs *
setup(DESCRIPTOR_DATA *cl, const char *cmd, const char *arg, char *path,
	size_t pathsz, int path_required)
{
	struct vfs *v;

	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return NULL;
	}
	util_getword(arg, path, pathsz);
	if (!path[0]) {
		if (path_required) {
			telnetclient_printf(cl, "usage: %s <path>\n", cmd);
			return NULL;
		}
		snprintf(path, pathsz, "/");    /* @fls with no argument lists root */
	}
	if (path[0] != '/') {
		telnetclient_puts(cl, "The path must be absolute, e.g. /src/foo.kp\n");
		return NULL;
	}
	v = verb_dispatch_vfs();
	if (!v)
		telnetclient_puts(cl, "No in-world VFS is available.\n");
	return v;
}

/* Read a whole VFS file into a malloc'd buffer (caller frees). Returns the VFS
 * code; the data and length are set only on VFS_OK. */
static int
read_file(struct vfs *v, const char *path, void **data, size_t *len)
{
	return vfs_read(v, path, data, len);
}

/* ------------------------------------------------------------------ @fls -- */

struct fls_ctx {
	DESCRIPTOR_DATA *cl;
	unsigned count;
};

static int
fls_entry(const char *name, const struct vfs_stat *st, void *ctx)
{
	struct fls_ctx *fc = ctx;
	char kind = st->kind == VFS_KIND_DIR ? 'd' : '-';

	if (st->kind == VFS_KIND_DIR)
		telnetclient_printf(fc->cl, "  %c %10s  %s/\n", kind, "-", name);
	else
		telnetclient_printf(fc->cl, "  %c %10llu  %s\n", kind,
			(unsigned long long)st->size, name);
	fc->count++;
	return 0;
}

int
command_do_fls(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX];
	struct vfs *v;
	struct vfs_stat st;

	v = setup(cl, cmd, arg, path, sizeof path, 0);
	if (!v)
		return 0;

	if (vfs_stat(v, path, &st) != VFS_OK) {
		telnetclient_printf(cl, "No such path: %s\n", path);
		return 0;
	}
	if (st.kind != VFS_KIND_DIR) {
		/* A single file: show its one stat line, like ls of a file. */
		const char *leaf = strrchr(path, '/');

		telnetclient_printf(cl, "  - %10llu  %s\n",
			(unsigned long long)st.size, leaf && leaf[1] ? leaf + 1 : path);
		return 1;
	}
	{
		struct fls_ctx fc = { .cl = cl, .count = 0 };

		telnetclient_printf(cl, "%s:\n", path);
		vfs_readdir(v, path, fls_entry, &fc);
		telnetclient_printf(cl, "(%u %s)\n", fc.count,
			fc.count == 1 ? "entry" : "entries");
	}
	return 1;
}

/* ----------------------------------------------------------------- @fcat -- */

int
command_do_fcat(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX];
	struct vfs *v;
	struct vfs_stat st;
	void *data = NULL;
	size_t len = 0;
	enum ftype t;

	v = setup(cl, cmd, arg, path, sizeof path, 1);
	if (!v)
		return 0;

	if (vfs_stat(v, path, &st) != VFS_OK) {
		telnetclient_printf(cl, "No such file: %s\n", path);
		return 0;
	}
	if (st.kind == VFS_KIND_DIR) {
		telnetclient_printf(cl, "%s is a directory; use @fls.\n", path);
		return 0;
	}
	if (read_file(v, path, &data, &len) != VFS_OK) {
		telnetclient_printf(cl, "Cannot read %s.\n", path);
		return 0;
	}

	t = classify(data, len);
	if (t != FT_TEXT) {
		telnetclient_printf(cl,
			"%s: %s file, not shown. Use @ftype or @fget.\n",
			path, ftype_name(t));
		free(data);
		return 0;
	}

	if (len > FCAT_MAX) {
		char save = ((char *)data)[FCAT_MAX];

		((char *)data)[FCAT_MAX] = '\0';
		telnetclient_puts(cl, data);
		((char *)data)[FCAT_MAX] = save;
		telnetclient_printf(cl,
			"\n... (%llu bytes total; showing the first %d)\n",
			(unsigned long long)len, FCAT_MAX);
	} else {
		telnetclient_puts(cl, data);
		if (len && ((char *)data)[len - 1] != '\n')
			telnetclient_puts(cl, "\n");
	}
	free(data);
	return 1;
}

/* ---------------------------------------------------------------- @ftype -- */

int
command_do_ftype(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX];
	struct vfs *v;
	struct vfs_stat st;
	void *data = NULL;
	size_t len = 0;

	v = setup(cl, cmd, arg, path, sizeof path, 1);
	if (!v)
		return 0;

	if (vfs_stat(v, path, &st) != VFS_OK) {
		telnetclient_printf(cl, "No such file: %s\n", path);
		return 0;
	}
	if (st.kind == VFS_KIND_DIR) {
		telnetclient_printf(cl, "%s: directory\n", path);
		return 1;
	}
	if (read_file(v, path, &data, &len) != VFS_OK) {
		telnetclient_printf(cl, "Cannot read %s.\n", path);
		return 0;
	}
	telnetclient_printf(cl, "%s: %s\n", path, ftype_name(classify(data, len)));
	free(data);
	return 1;
}

/* ------------------------------------------------------------ transfer -- */

/* A transfer path is carried in an HTTP query string, so keep it to characters
 * that need no URL-encoding and cannot break the query: letters, digits, and
 * the path punctuation '/', '.', '-', '_'. */
static int
url_safe(const char *p)
{
	for (; *p; p++)
		if (!isalnum((unsigned char)*p) && !strchr("/._-", *p))
			return 0;
	return 1;
}

/* Shared front matter for the transfer commands: wizard gate, an absolute
 * URL-safe path, and the web-client requirement. Returns the web_client, or
 * NULL after telling the user why not. */
static struct web_client *
transfer_setup(DESCRIPTOR_DATA *cl, const char *cmd, const char *arg,
	char *path, size_t pathsz, const char *what, const char *hint)
{
	if (!user_is_wizard(telnetclient_user(cl))) {
		telnetclient_puts(cl, "Permission denied.\n");
		return NULL;
	}
	util_getword(arg, path, pathsz);
	if (!path[0]) {
		telnetclient_printf(cl, "usage: %s <path>\n", cmd);
		return NULL;
	}
	if (path[0] != '/' || !url_safe(path)) {
		telnetclient_puts(cl, "The path must be an absolute VFS path of "
			"letters, digits, '/', '.', '-', '_'.\n");
		return NULL;
	}
	if (cl->type != CLIENT_TYPE_WEB || !cl->client_ctx) {
		telnetclient_printf(cl,
			"%s is only available from the web client.\n", what);
		if (hint)
			telnetclient_printf(cl, "%s\n", hint);
		return NULL;
	}
	return cl->client_ctx;
}

/* ----------------------------------------------------------------- @fget - */

int
command_do_fget(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX], url[VFS_PATH_MAX + 64];
	struct web_client *wc;
	struct vfs *v;
	struct vfs_stat st;

	wc = transfer_setup(cl, cmd, arg, path, sizeof path, "@fget (download)",
		NULL);
	if (!wc)
		return 0;

	v = verb_dispatch_vfs();
	if (!v) {
		telnetclient_puts(cl, "No in-world VFS is available.\n");
		return 0;
	}
	if (vfs_stat(v, path, &st) != VFS_OK || st.kind != VFS_KIND_FILE) {
		telnetclient_printf(cl, "No such file: %s\n", path);
		return 0;
	}
	snprintf(url, sizeof url, "/download?path=%s&sid=%s", path, wc->session);
	if (telnetclient_send_sse(cl, 'D', url) < 0) {
		telnetclient_puts(cl, "Failed to start the download.\n");
		return 0;
	}
	telnetclient_printf(cl, "Downloading %s.\n", path);
	return 1;
}

/* ----------------------------------------------------------------- @fput - */

int
command_do_fput(DESCRIPTOR_DATA *cl, struct user *u UNUSED, const char *cmd,
	const char *arg)
{
	char path[VFS_PATH_MAX], url[VFS_PATH_MAX + 64];
	struct web_client *wc;

	wc = transfer_setup(cl, cmd, arg, path, sizeof path, "@fput (upload)",
		"Use @fedit to author a text file here.");
	if (!wc)
		return 0;
	snprintf(url, sizeof url, "/upload?path=%s&sid=%s", path, wc->session);
	if (telnetclient_send_sse(cl, 'U', url) < 0) {
		telnetclient_puts(cl, "Failed to start the upload.\n");
		return 0;
	}
	telnetclient_printf(cl, "Choose a file to upload to %s.\n", path);
	return 1;
}
