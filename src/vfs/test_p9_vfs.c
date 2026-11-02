/* test_p9_vfs.c : drive the CAS-backed 9P server directly with framed
 * 9P2000 messages over a scratch VFS, covering attach/walk/open/read/write/
 * create/stat/remove and the ".." confinement. */

#define _POSIX_C_SOURCE 200809L

#include "vfs.h"
#include "p9_vfs.h"

#include "cas.h"
#include "cas-tree.h"
#include "p9_server.h"          /* p9_server_create/destroy/handle prototypes */
#include "p9_wire.h"            /* p9 wire helpers and the P9_* constants */

#include "ctest.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static char tmpdir[] = "/tmp/test_p9_vfs_XXXXXX";
static uint8_t rx[8192];

static void
cleanup(void)
{
	char cmd[512];
	snprintf(cmd, sizeof cmd, "rm -rf %s", tmpdir);
	if (system(cmd)) { /* best effort */ }
}

/* Start a T-message of `type` with tag 1 into `o` over buffer `tx`. */
static void
tbegin(struct wire_out *o, uint8_t *tx, uint32_t cap, uint8_t type)
{
	wire_out_init(o, tx, cap);
	p9o_hdr(o, type, 1);
}

/* Dispatch the finished T-message and return the reply's message type (or
 * P9_RERROR). The reply stays in rx for the caller to parse further. */
static int
call(struct p9_server *s, struct wire_out *o, struct wire_in *rin)
{
	uint32_t txlen = p9o_finish(o);
	int rxlen = p9_server_handle(s, o->b, txlen, rx, sizeof rx);
	uint8_t type;
	wire_in_init(rin, rx, (uint32_t)rxlen);
	(void)wire_get_u32(rin);             /* size */
	type = wire_get_u8(rin);
	(void)wire_get_u16(rin);             /* tag */
	return type;
}

int
main(void)
{
	struct cas *store;
	struct cas_tree *ct;
	struct vfs *v;
	struct p9_server *s;
	struct wire_out o;
	struct wire_in in;
	uint8_t tx[8192];
	char depot[512];
	int rtype;

	if (!mkdtemp(tmpdir)) {
		FAIL("mkdtemp");
		return ctest_report("p9_vfs");
	}
	snprintf(depot, sizeof depot, "%s/depot", tmpdir);
	store = cas_new(depot);
	ct = store ? cas_tree_new(store) : NULL;
	v = ct ? vfs_new(ct, "p9") : NULL;
	EXPECT(v != NULL, "scratch vfs opened");
	if (!v) { cleanup(); return ctest_report("p9_vfs"); }

	/* Seed the tree: a top-level file, a subdir, a nested file. */
	EXPECT_EQ(vfs_write(v, "/greeting.txt", "hello\n", 6), VFS_OK, "seed file");
	EXPECT_EQ(vfs_mkdir(v, "/sub"), VFS_OK, "seed dir");
	EXPECT_EQ(vfs_write(v, "/sub/deep.txt", "deep", 4), VFS_OK, "seed nested");
	EXPECT_EQ(vfs_commit(v, "seed"), VFS_OK, "seed committed");

	s = p9_vfs_new(v);
	EXPECT(s != NULL, "server created");

	/* Tversion negotiates 9P2000. */
	tbegin(&o, tx, sizeof tx, P9_TVERSION);
	wire_put_u32(&o, 8192);
	wire_put_str(&o, P9_VERSION);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RVERSION, "version negotiated");

	/* Tattach binds fid 0 to the root, a directory. */
	tbegin(&o, tx, sizeof tx, P9_TATTACH);
	wire_put_u32(&o, 0);                 /* fid */
	wire_put_u32(&o, ~0u);               /* afid = NOFID */
	wire_put_str(&o, "u");               /* uname */
	wire_put_str(&o, "");                /* aname */
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RATTACH, "attached to root");
	{
		struct p9_qid q;
		p9i_qid(&in, &q);
		EXPECT(q.type == P9_QTDIR, "root qid is a directory");
	}

	/* Twalk fid 0 -> fid 1 along ["greeting.txt"]. */
	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);                 /* fid */
	wire_put_u32(&o, 1);                 /* newfid */
	wire_put_u16(&o, 1);                 /* nwname */
	wire_put_str(&o, "greeting.txt");
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RWALK, "walked to greeting.txt");
	EXPECT_EQ(wire_get_u16(&in), 1, "one walk qid");

	/* Topen fid 1 for reading, then Tread its bytes. */
	tbegin(&o, tx, sizeof tx, P9_TOPEN);
	wire_put_u32(&o, 1);
	wire_put_u8(&o, P9_OREAD);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_ROPEN, "opened greeting.txt");

	tbegin(&o, tx, sizeof tx, P9_TREAD);
	wire_put_u32(&o, 1);
	wire_put_u64(&o, 0);
	wire_put_u32(&o, 100);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RREAD, "read greeting.txt");
	{
		uint32_t n = wire_get_u32(&in);
		EXPECT_EQ(n, 6, "read six bytes");
		EXPECT(memcmp(in.b + in.p, "hello\n", 6) == 0, "bytes match");
	}

	/* Tstat fid 1 reports the leaf name and length. */
	tbegin(&o, tx, sizeof tx, P9_TSTAT);
	wire_put_u32(&o, 1);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RSTAT, "stat greeting.txt");

	/* A ".." walk from the root is refused (confinement). */
	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);
	wire_put_u32(&o, 5);
	wire_put_u16(&o, 1);
	wire_put_str(&o, "..");
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RERROR, "a .. above the root is denied");

	/* Clone the root (fid 0 -> fid 3, zero names), create a file under it,
	 * write to it, and clunk to flush. */
	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);
	wire_put_u32(&o, 3);
	wire_put_u16(&o, 0);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RWALK, "cloned the root fid");

	tbegin(&o, tx, sizeof tx, P9_TCREATE);
	wire_put_u32(&o, 3);
	wire_put_str(&o, "new.txt");
	wire_put_u32(&o, 0644);
	wire_put_u8(&o, P9_OWRITE);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RCREATE, "created new.txt");

	tbegin(&o, tx, sizeof tx, P9_TWRITE);
	wire_put_u32(&o, 3);
	wire_put_u64(&o, 0);
	wire_put_u32(&o, 5);
	wire_put_bytes(&o, "world", 5);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RWRITE, "wrote new.txt");
	EXPECT_EQ(wire_get_u32(&in), 5, "wrote five bytes");

	tbegin(&o, tx, sizeof tx, P9_TCLUNK);
	wire_put_u32(&o, 3);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RCLUNK, "clunked and flushed new.txt");

	/* The write is visible in the VFS after the clunk flush. */
	{
		void *data;
		size_t n;
		EXPECT_EQ(vfs_read(v, "/new.txt", &data, &n), VFS_OK, "new.txt exists");
		EXPECT(n == 5 && memcmp(data, "world", 5) == 0, "flushed bytes match");
		free(data);
	}

	/* Walk two levels into the subdir and read the nested file. */
	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);
	wire_put_u32(&o, 4);
	wire_put_u16(&o, 2);
	wire_put_str(&o, "sub");
	wire_put_str(&o, "deep.txt");
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RWALK, "walked into the subdir");
	EXPECT_EQ(wire_get_u16(&in), 2, "two walk qids");

	tbegin(&o, tx, sizeof tx, P9_TOPEN);
	wire_put_u32(&o, 4);
	wire_put_u8(&o, P9_OREAD);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_ROPEN, "opened the nested file");

	tbegin(&o, tx, sizeof tx, P9_TREAD);
	wire_put_u32(&o, 4);
	wire_put_u64(&o, 0);
	wire_put_u32(&o, 100);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RREAD, "read the nested file");
	{
		uint32_t n = wire_get_u32(&in);
		EXPECT(n == 4 && memcmp(in.b + in.p, "deep", 4) == 0, "nested bytes");
	}

	/* Remove new.txt: walk a fresh fid to it, Tremove, then confirm it is
	 * gone from the VFS and a fresh walk fails. */
	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);
	wire_put_u32(&o, 6);
	wire_put_u16(&o, 1);
	wire_put_str(&o, "new.txt");
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RWALK, "walked to new.txt for removal");

	tbegin(&o, tx, sizeof tx, P9_TREMOVE);
	wire_put_u32(&o, 6);
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RREMOVE, "removed new.txt");
	{
		void *data;
		size_t n;
		EXPECT_EQ(vfs_read(v, "/new.txt", &data, &n), VFS_ENOTFOUND,
		          "new.txt is gone from the VFS");
	}

	tbegin(&o, tx, sizeof tx, P9_TWALK);
	wire_put_u32(&o, 0);
	wire_put_u32(&o, 7);
	wire_put_u16(&o, 1);
	wire_put_str(&o, "new.txt");
	rtype = call(s, &o, &in);
	EXPECT_EQ(rtype, P9_RERROR, "a walk to the removed file fails");

	p9_server_destroy(s);
	vfs_free(v);
	cas_tree_free(ct);
	cas_free(store);
	cleanup();
	return ctest_report("p9_vfs");
}
