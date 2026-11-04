/* test_vfs.c : unit tests for the content-addressed VFS. */

#define _POSIX_C_SOURCE 200809L

#include "vfs.h"

#include "cas.h"
#include "cas-tree.h"

#include "ctest.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static char tmpdir[] = "/tmp/test_vfs_XXXXXX";

static void
cleanup(void)
{
	char cmd[512];

	snprintf(cmd, sizeof cmd, "rm -rf %s", tmpdir);
	if (system(cmd)) { /* best effort */ }
}

/* Collect directory entry names for membership and count checks. */
struct namelist {
	char names[16][64];
	int  kinds[16];
	int  count;
};

static int
collect(const char *name, const struct vfs_stat *st, void *ctx)
{
	struct namelist *nl = ctx;

	if (nl->count < 16) {
		snprintf(nl->names[nl->count], sizeof nl->names[0], "%s", name);
		nl->kinds[nl->count] = (int)st->kind;
		nl->count++;
	}
	return 0;
}

static int
has_name(const struct namelist *nl, const char *name)
{
	for (int i = 0; i < nl->count; i++)
		if (strcmp(nl->names[i], name) == 0)
			return 1;
	return 0;
}

int
main(void)
{
	struct cas *store;
	struct cas_tree *ct;
	struct vfs *v;
	struct vfs_stat st;
	struct namelist nl;
	void *buf;
	size_t len;
	char depot[512];

	if (!mkdtemp(tmpdir)) {
		FAIL("mkdtemp");
		return ctest_report("vfs");
	}
	snprintf(depot, sizeof depot, "%s/depot", tmpdir);
	store = cas_new(depot);
	EXPECT(store != NULL, "cas depot opened");
	ct = cas_tree_new(store);
	EXPECT(ct != NULL, "cas tree created");
	v = vfs_new(ct, "vfs");
	EXPECT(v != NULL, "vfs opened on an empty ref");

	/* Empty tree: the root is a directory, and a lookup finds nothing. */
	EXPECT_EQ(vfs_stat(v, "/", &st), VFS_OK, "stat root");
	EXPECT(st.kind == VFS_KIND_DIR && st.size == 0, "root is an empty dir");
	EXPECT_EQ(vfs_stat(v, "/src/hello.pas", &st), VFS_ENOTFOUND,
	          "a missing path is not found");
	EXPECT_EQ(vfs_read(v, "/src/hello.pas", &buf, &len), VFS_ENOTFOUND,
	          "reading a missing file fails");

	/* Write a file; its parent directory is created on the way. */
	EXPECT_EQ(vfs_write(v, "/src/hello.pas", "writeln('hi')\n", 14), VFS_OK,
	          "write a source file");
	EXPECT_EQ(vfs_stat(v, "/src", &st), VFS_OK, "parent dir was created");
	EXPECT(st.kind == VFS_KIND_DIR, "parent is a directory");
	EXPECT_EQ(vfs_stat(v, "/src/hello.pas", &st), VFS_OK, "stat the file");
	EXPECT(st.kind == VFS_KIND_FILE && st.size == 14, "file kind and size");

	/* Read it back exactly. */
	EXPECT_EQ(vfs_read(v, "/src/hello.pas", &buf, &len), VFS_OK, "read it");
	EXPECT(len == 14 && memcmp(buf, "writeln('hi')\n", 14) == 0,
	       "read returns the written bytes");
	free(buf);

	/* mkdir, and its error cases. */
	EXPECT_EQ(vfs_mkdir(v, "/bin"), VFS_OK, "mkdir /bin");
	EXPECT_EQ(vfs_stat(v, "/bin", &st), VFS_OK, "stat /bin");
	EXPECT(st.kind == VFS_KIND_DIR, "/bin is a directory");
	EXPECT_EQ(vfs_mkdir(v, "/bin"), VFS_EEXIST, "mkdir existing fails");
	EXPECT_EQ(vfs_mkdir(v, "/nope/deep"), VFS_ENOTFOUND,
	          "mkdir with a missing parent fails");
	EXPECT_EQ(vfs_mkdir(v, "/src/hello.pas/x"), VFS_ENOTDIR,
	          "descending through a file fails");

	/* Directory listings. */
	EXPECT_EQ(vfs_write(v, "/bin/hello.elf", "\177ELF", 4), VFS_OK,
	          "write an elf");
	memset(&nl, 0, sizeof nl);
	EXPECT_EQ(vfs_readdir(v, "/", collect, &nl), VFS_OK, "readdir root");
	EXPECT(nl.count == 2 && has_name(&nl, "src") && has_name(&nl, "bin"),
	       "root lists src and bin");
	memset(&nl, 0, sizeof nl);
	EXPECT_EQ(vfs_readdir(v, "/src", collect, &nl), VFS_OK, "readdir /src");
	EXPECT(nl.count == 1 && has_name(&nl, "hello.pas"),
	       "/src lists hello.pas");

	/* Copy-on-write overwrite: the new content replaces the old. */
	EXPECT_EQ(vfs_write(v, "/src/hello.pas", "writeln('bye')\n", 15), VFS_OK,
	          "overwrite the source");
	EXPECT_EQ(vfs_read(v, "/src/hello.pas", &buf, &len), VFS_OK, "re-read");
	EXPECT(len == 15 && memcmp(buf, "writeln('bye')\n", 15) == 0,
	       "overwrite is visible");
	free(buf);

	/* unlink a file; the directory stays and loses the entry. */
	EXPECT_EQ(vfs_unlink(v, "/src/hello.pas"), VFS_OK, "unlink the file");
	EXPECT_EQ(vfs_stat(v, "/src/hello.pas", &st), VFS_ENOTFOUND,
	          "the file is gone");
	EXPECT_EQ(vfs_stat(v, "/src", &st), VFS_OK, "the directory remains");
	EXPECT(st.size == 0, "the directory is now empty");

	/* A non-empty directory cannot be unlinked. */
	EXPECT_EQ(vfs_unlink(v, "/bin"), VFS_ENOTEMPTY,
	          "unlink of a non-empty dir is refused");

	/* Path normalization. */
	EXPECT_EQ(vfs_read(v, "//bin///hello.elf", &buf, &len), VFS_OK,
	          "redundant separators normalize");
	free(buf);
	EXPECT_EQ(vfs_write(v, "/bin/../etc/passwd", "x", 1), VFS_EINVAL,
	          "a .. component is rejected");

	/* Persist, reopen on the same ref, and see the committed tree. */
	EXPECT_EQ(vfs_commit(v, "test snapshot"), VFS_OK, "commit");
	vfs_free(v);
	v = vfs_new(ct, "vfs");
	EXPECT(v != NULL, "reopened the committed vfs");
	EXPECT_EQ(vfs_read(v, "/bin/hello.elf", &buf, &len), VFS_OK,
	          "a committed file survives a reopen");
	EXPECT(len == 4 && memcmp(buf, "\177ELF", 4) == 0,
	       "its bytes are intact");
	free(buf);

	vfs_free(v);
	cas_tree_free(ct);
	cas_free(store);
	cleanup();
	return ctest_report("vfs");
}
