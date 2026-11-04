/* test_verb_object.c : host calls that look up and iterate store objects.
 *
 * These exercise sys_getobj, sys_objfind, and sys_next, which unlike
 * getprop/setprop reach into the obj cache (obj_get, obj_contents) and the
 * resolve module. The programs run under a real muddb-backed store seeded with
 * a room, two characters, and an item. */

#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_verb_object"

#include "verb_dispatch.h"
#include "vm_sys.h"
#include "obj.h"
#include "muddb.h"

#include <elf32.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

MUDDB *mud_db;

static char tmpdir[] = "/tmp/test_verb_object_XXXXXX";

static int
rm_cb(const char *fpath, const struct stat *sb, int typeflag,
      struct FTW *ftwbuf)
{
	(void)sb;
	(void)typeflag;
	(void)ftwbuf;
	return remove(fpath);
}

static void
cleanup_tmpdir(void)
{
	nftw(tmpdir, rm_cb, 8, FTW_DEPTH | FTW_PHYS);
}

/****************************************************************
 * Minimal ELF builder (same shape as test_verb_dispatch.c): one PT_LOAD at
 * 0x1000 holding the code. Host calls reach the runtime by fixed selector
 * (a7 = VM_HOSTCALL_BASE + a VM_CALL_* value); there is no import table.
 ****************************************************************/

#define LOAD_VADDR 0x1000u

static void
le16(uint8_t *p, uint16_t v)
{
	p[0] = (uint8_t)v;
	p[1] = (uint8_t)(v >> 8);
}

static void
le32(uint8_t *p, uint32_t v)
{
	p[0] = (uint8_t)v;
	p[1] = (uint8_t)(v >> 8);
	p[2] = (uint8_t)(v >> 16);
	p[3] = (uint8_t)(v >> 24);
}

/* Emit "set a7 = VM_HOSTCALL_BASE + sel, then ecall"; sel is a VM_CALL_*. */
static uint32_t
emit_call(uint8_t *seg, uint32_t o, uint32_t sel)
{
	le32(seg + o, 0x001008B7u);             /* lui  a7, 0x100 */
	o += 4;
	if (sel) {
		le32(seg + o, 0x00088893u | (sel << 20));  /* addi a7, a7, sel */
		o += 4;
	}
	le32(seg + o, 0x00000073u);             /* ecall */
	return o + 4;
}

static long
build_prog(uint8_t *buf, const uint8_t *seg, uint32_t seglen)
{
	uint8_t *eh = buf;
	uint8_t *ph = buf + 52;
	uint32_t code_off = 84;
	uint8_t *body = buf + code_off;
	uint32_t total;

	memcpy(body, seg, seglen);
	total = seglen;

	memset(eh, 0, 84);
	eh[0] = 0x7f; eh[1] = 'E'; eh[2] = 'L'; eh[3] = 'F';
	eh[4] = 1; eh[5] = 1; eh[6] = 1;
	le16(eh + 16, 2);
	le16(eh + 18, EM_RISCV);
	le32(eh + 20, 1);
	le32(eh + 24, LOAD_VADDR);
	le32(eh + 28, 52);
	le16(eh + 40, 52);
	le16(eh + 42, 32);
	le16(eh + 44, 1);

	le32(ph + 0, 1);
	le32(ph + 4, code_off);
	le32(ph + 8, LOAD_VADDR);
	le32(ph + 12, LOAD_VADDR);
	le32(ph + 16, total);
	le32(ph + 20, total);
	le32(ph + 24, 4 | 1);
	le32(ph + 28, LOAD_VADDR);

	return (long)(code_off + total);
}

/****************************************************************
 * Store setup
 ****************************************************************/

/* Create an object with a name.short, set an arbitrary extra property, then
 * move it into container (NULL = leave in limbo). */
static void
mkobj(const char *id, const char *name_short, const char *prop,
      const char *prop_val, const char *container)
{
	OBJ *o = obj_create(id);

	if (!o)
		return;
	if (name_short)
		obj_prop_set(o, "name.short", name_short);
	if (prop)
		obj_prop_set(o, prop, prop_val);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
	if (container)
		obj_move(id, container);
}

/* Run a program whose `self` is the store object `self_id`, returning its exit
 * status. The handle is pinned for the run and released afterward. */
static int
run_with_self(const uint8_t *elf, long len, const char *self_id,
              const char *const *argv, int argc)
{
	OBJ *self = obj_get(self_id);
	int rc;

	if (!self)
		return -1;
	rc = verb_dispatch_run_image(elf, len, self, "rooms/cave", argv, argc);
	obj_release(self);
	return rc;
}

/****************************************************************
 * Tests
 ****************************************************************/

/* sys_getobj follows a string property that names another object, then the
 * program reads name.short off the returned handle and exits with its length. */
static void
test_getobj_ok(void)
{
	static const char *const argv[] = { "link", "name.short" };
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0045A603u); o += 4;     /* lw   a2, 4(a1) -> argv[1] name */
	le32(seg + o, 0x0005A583u); o += 4;     /* lw   a1, 0(a1) -> argv[0] "link" */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_call(seg, o, VM_CALL_GETOBJ);  /* sys_getobj(self, "link") -> a0 */
	le32(seg + o, 0x00060593u); o += 4;     /* mv   a1, a2 (name.short ptr) */
	le32(seg + o, 0x00002637u); o += 4;     /* lui  a2, 2 (buf page) */
	le32(seg + o, 0x04000693u); o += 4;     /* addi a3, x0, 64 (buf cap) */
	o = emit_call(seg, o, VM_CALL_GETPROP); /* sys_getprop(handle, name, buf, 64) */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit with the length */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 2), 4,
	          "getobj followed link to the ruby (name.short length 4)");
}

/* sys_getobj returns 0 when the property is absent; the program exits with the
 * handle, so a miss exits 0. */
static void
test_getobj_missing(void)
{
	static const char *const argv[] = { "nosuchprop" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0005A583u); o += 4;     /* lw   a1, 0(a1) -> argv[0] */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_call(seg, o, VM_CALL_GETOBJ);  /* sys_getobj -> a0 = 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 1), 0,
	          "getobj on an absent property yields no handle");
}

/* sys_objfind resolves a name in the actor's scope; the actor is the self
 * object. The program reads name.short off the match and exits with its length. */
static void
test_objfind_ok(void)
{
	static const char *const argv[] = { "goblin", "name.short" };
	uint8_t seg[64];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0045A603u); o += 4;     /* lw   a2, 4(a1) -> argv[1] name */
	le32(seg + o, 0x0005A503u); o += 4;     /* lw   a0, 0(a1) -> argv[0] "goblin" */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (players_only = 0) */
	o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind("goblin", 0) -> a0 */
	le32(seg + o, 0x00060593u); o += 4;     /* mv   a1, a2 (name.short ptr) */
	le32(seg + o, 0x00002637u); o += 4;     /* lui  a2, 2 (buf page) */
	le32(seg + o, 0x04000693u); o += 4;     /* addi a3, x0, 64 (buf cap) */
	o = emit_call(seg, o, VM_CALL_GETPROP); /* sys_getprop(handle, name, buf, 64) */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit with the length */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 2), 6,
	          "objfind matched the Goblin occupant (name.short length 6)");
}

/* sys_objfind returns 0 when nothing in scope matches. */
static void
test_objfind_none(void)
{
	static const char *const argv[] = { "dragon" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0005A503u); o += 4;     /* lw   a0, 0(a1) -> argv[0] */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (players_only = 0) */
	o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind -> a0 = 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 1), 0,
	          "objfind on an unknown name yields no handle");
}

/* sys_next on the room (as self) returns the first member; the program exits
 * with the handle, which is the first dynamic slot (2). */
static void
test_next_found(void)
{
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (container = self) */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (ordinal 0) */
	o = emit_call(seg, o, VM_CALL_NEXT);    /* sys_next(self, 0) -> a0 = handle */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit with the handle */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "rooms/cave", NULL, 0), 2,
	          "next(0) opened a handle to the first member");
}

/* sys_next past the last member returns 0 (end of iteration). */
static void
test_next_end(void)
{
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (container = self) */
	le32(seg + o, 0x00500593u); o += 4;     /* addi a1, x0, 5 (ordinal past end) */
	o = emit_call(seg, o, VM_CALL_NEXT);    /* sys_next(self, 5) -> a0 = 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "rooms/cave", NULL, 0), 0,
	          "next past the last member yields no handle");
}

/* Assert the current container id of member (NULL means limbo). */
static void
expect_location(const char *member, const char *want, const char *label)
{
	char *loc = obj_location(member);

	if (want)
		EXPECT(loc && strcmp(loc, want) == 0, label);
	else
		EXPECT(loc == NULL, label);
	free(loc);
}

/* sys_move relocates a member into a container handle, then (with the none
 * handle) to limbo. The program finds the gem by name, moves it into self, then
 * a second program moves it out to limbo. */
static void
test_move(void)
{
	static const char *const argv[] = { "ruby" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0005A503u); o += 4;     /* lw   a0, 0(a1) -> argv[0] "ruby" */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (players_only 0) */
	o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind("ruby", 0) -> a0 member */
	le32(seg + o, 0x00100593u); o += 4;     /* addi a1, x0, 1 (container = self) */
	o = emit_call(seg, o, VM_CALL_MOVE);    /* sys_move(member, self) -> a0 = 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 1), 0,
	          "move into self succeeded");
	expect_location("items/gem", "chars/1", "gem is now in the actor");

	o = 0;
	le32(seg + o, 0x0005A503u); o += 4;     /* lw   a0, 0(a1) -> argv[0] "ruby" */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (players_only 0) */
	o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind("ruby", 0) -> a0 member */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (container = none) */
	o = emit_call(seg, o, VM_CALL_MOVE);    /* sys_move(member, none) -> limbo */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "chars/1", argv, 1), 0,
	          "move to limbo succeeded");
	expect_location("items/gem", NULL, "gem is now in limbo");
}

/* sys_objfind sets sys_errno to distinguish a miss (NOTFOUND) from an
 * ambiguous name (AMBIGUOUS), and leaves it NONE on success. The program runs
 * objfind then exits with sys_errno's value. */
static void
test_errno(void)
{
	static const char *const miss[] = { "dragon" };
	static const char *const amb[] = { "coin" };
	static const char *const ok[] = { "goblin" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x0005A503u); o += 4;     /* lw   a0, 0(a1) -> argv[0] name */
	le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 (players_only 0) */
	o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind -> a0 handle (0 miss) */
	o = emit_call(seg, o, VM_CALL_ERRNO);   /* sys_errno -> a0 = code */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit with the code */
	len = build_prog(elf, seg, o);

	/* VM_ERR_NOTFOUND=2, VM_ERR_AMBIGUOUS=3, VM_ERR_NONE=0 (sdk vmsys.h). */
	EXPECT_EQ(run_with_self(elf, len, "chars/1", miss, 1), 2,
	          "a missing name reports NOTFOUND");
	EXPECT_EQ(run_with_self(elf, len, "chars/1", amb, 1), 3,
	          "an ambiguous name reports AMBIGUOUS");
	EXPECT_EQ(run_with_self(elf, len, "chars/1", ok, 1), 0,
	          "a successful lookup leaves errno NONE");
}

/* sys_contents_count returns the member count of the handle object. */
static void
test_contents_count(void)
{
	uint8_t seg[32];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;

	le32(seg + o, 0x00100513u); o += 4;             /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_call(seg, o, VM_CALL_CONTENTS_COUNT);  /* sys_contents_count -> a0 = count */
	o = emit_call(seg, o, VM_CALL_EXIT);            /* sys_exit with the count */
	len = build_prog(elf, seg, o);

	EXPECT_EQ(run_with_self(elf, len, "items/bag", NULL, 0), 2,
	          "contents_count returns the number of members");
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : verb object host calls");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}
	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 64) != 0) {
		LOG_ERROR("store setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}
	if (verb_dispatch_init("data/vm", NULL) != 0) {
		LOG_ERROR("verb_dispatch_init failed");
		obj_shutdown();
		muddb_close(mud_db);
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}

	/* A room, the actor in it (holding a link to the gem), an occupant, and the
	 * gem itself placed in the room so it is also a member for iteration. */
	mkobj("rooms/cave", "a dark cave", NULL, NULL, NULL);
	mkobj("chars/1", "Hero", "link", "items/gem", "rooms/cave");
	mkobj("chars/2", "Goblin", "aliases", "gob", "rooms/cave");
	mkobj("items/gem", "ruby", NULL, NULL, "rooms/cave");
	/* Two objects sharing the word "coin" make that name ambiguous. */
	mkobj("items/coin1", "gold coin", NULL, NULL, "rooms/cave");
	mkobj("items/coin2", "silver coin", NULL, NULL, "rooms/cave");
	/* A bag with exactly two members, for the count. */
	mkobj("items/bag", "bag", NULL, NULL, NULL);
	mkobj("items/a", "a", NULL, NULL, "items/bag");
	mkobj("items/b", "b", NULL, NULL, "items/bag");

	test_getobj_ok();
	test_getobj_missing();
	test_objfind_ok();
	test_objfind_none();
	test_next_found();
	test_next_end();
	test_errno();
	test_contents_count();
	test_move();                    /* last: it relocates the gem */

	verb_dispatch_shutdown();
	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_verb_object");
}
