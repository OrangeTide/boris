/* test_verb_command.c : end-to-end command-verb dispatch.
 *
 * Exercises verb_dispatch_command: resolve verb.<word> in scope, match the
 * remainder against the spec, pre-seed object arguments as handles, and run the
 * bound program with the typed argument vector. Programs are hand-assembled ELF
 * images installed in a temporary image directory, so the test does not depend
 * on the SDK build. When the SDK has already built data/vm/look.elf, a final
 * case runs that real cmd.* program too. */

#define _XOPEN_SOURCE 500
#define _DEFAULT_SOURCE
#define LOG_SUBSYSTEM "test_verb_command"

#include "verb_dispatch.h"
#include "vm_sys.h"
#include "obj.h"
#include "muddb.h"

#include <elf32.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ftw.h>

#include <log.h>
#include "ctest.h"

MUDDB *mud_db;

static char tmpdir[] = "/tmp/test_verb_command_XXXXXX";

static int
rm_cb(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf)
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
 * Minimal ELF builder (same shape as test_verb_object.c).
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

/* emit "set a7 = VM_HOSTCALL_BASE + sel, then ecall" at seg+o; sel is a fixed
 * VM_CALL_* selector. Returns the new offset. */
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
 * Broadcast capture + store/program setup
 ****************************************************************/

static char g_room[64];
static char g_line[128];
static int  g_bcalls;

static void
stub_bcast(const char *room, const char *line)
{
	snprintf(g_room, sizeof g_room, "%s", room ? room : "");
	snprintf(g_line, sizeof g_line, "%s", line ? line : "");
	g_bcalls++;
}

/* Only chars/wiz is a wizard-capable account. */
static int
test_may_wizard(const char *id)
{
	return id && strcmp(id, "chars/wiz") == 0;
}

/* Write bytes to <tmpdir>/<name>, returning 0 on success. */
static int
write_image(const char *name, const uint8_t *buf, long len)
{
	char path[512];
	FILE *f;
	size_t n;

	snprintf(path, sizeof path, "%s/%s", tmpdir, name);
	f = fopen(path, "wb");
	if (!f)
		return -1;
	n = fwrite(buf, 1, (size_t)len, f);
	fclose(f);
	return n == (size_t)len ? 0 : -1;
}

/* Install a program object "programs/<id>" naming image file "<id>.elf". */
static void
install_program(const char *id, const uint8_t *elf, long len)
{
	char key[64], image[64];
	OBJ *o;

	snprintf(image, sizeof image, "%s.elf", id);
	if (write_image(image, elf, len) != 0)
		return;
	snprintf(key, sizeof key, "programs/%s", id);
	o = obj_create(key);
	if (!o)
		return;
	obj_prop_set(o, "image.path", image);
	obj_mark_dirty(o);
	obj_save(key);
	obj_release(o);
}

/* verb_program_list callback: count the entries and remember the last name. */
static int  g_prog_count;
static char g_prog_last[64];

static void
count_prog(const char *prog_id, const char *image, int from_vfs, void *ctx)
{
	(void)image;
	(void)from_vfs;
	(void)ctx;
	g_prog_count++;
	snprintf(g_prog_last, sizeof g_prog_last, "%s", prog_id ? prog_id : "");
}

static void
mkobj(const char *id, const char *name_short, const char *container)
{
	OBJ *o = obj_create(id);

	if (!o)
		return;
	if (name_short)
		obj_prop_set(o, "name.short", name_short);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
	if (container)
		obj_move(id, container);
}

static void
setverb(const char *id, const char *word, const char *packed)
{
	OBJ *o = obj_get(id);
	char prop[80];

	if (!o)
		return;
	snprintf(prop, sizeof prop, "verb.%s", word);
	obj_prop_set(o, prop, packed);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
}

static void
setowner(const char *id, const char *owner)
{
	OBJ *o = obj_get(id);

	if (!o)
		return;
	obj_prop_set_internal(o, "%owner", owner);
	obj_mark_dirty(o);
	obj_save(id);
	obj_release(o);
}

/* True if object `id` carries prop "mark" set to "1". */
static int
has_mark(const char *id)
{
	OBJ *o = obj_get(id);
	const char *v;
	int set;

	if (!o)
		return 0;
	v = obj_prop_get(o, "mark");
	set = v && strcmp(v, "1") == 0;
	obj_release(o);
	return set;
}

/* True if object `id` exists in the store. */
static int
obj_exists(const char *id)
{
	OBJ *o = obj_get(id);

	if (!o)
		return 0;
	obj_release(o);
	return 1;
}

/* True if object `id`'s property `name` equals `want`. */
static int
prop_eq(const char *id, const char *name, const char *want)
{
	OBJ *o = obj_get(id);
	const char *v;
	int eq;

	if (!o)
		return 0;
	v = obj_prop_get(o, name);
	eq = v && strcmp(v, want) == 0;
	obj_release(o);
	return eq;
}

/* Copy data/vm/look.elf into the image dir, returning 0 if it was present. */
static int
install_sdk_look(void)
{
	FILE *in, *out;
	char path[512];
	uint8_t buf[4096];
	size_t n;

	if (access("data/vm/look.elf", R_OK) != 0)
		return -1;
	in = fopen("data/vm/look.elf", "rb");
	if (!in)
		return -1;
	snprintf(path, sizeof path, "%s/look.elf", tmpdir);
	out = fopen(path, "wb");
	if (!out) {
		fclose(in);
		return -1;
	}
	while ((n = fread(buf, 1, sizeof buf, in)) > 0)
		fwrite(buf, 1, n, out);
	fclose(in);
	fclose(out);

	/* A program object the "look" verb dispatches to. */
	{
		OBJ *o = obj_create("programs/look");
		if (o) {
			obj_prop_set(o, "image.path", "look.elf");
			obj_mark_dirty(o);
			obj_save("programs/look");
			obj_release(o);
		}
	}
	return 0;
}

/****************************************************************
 * Tests
 ****************************************************************/

/* <obj> <any>: reads the resolved object handle and the free-form property
 * name, getprops through the handle into a scratch page, and broadcasts the
 * value. The written page is zero-filled beyond the copied bytes (the host
 * zeroes the image), so the value is NUL-terminated for the broadcast. */
static long
build_getprop_prog(uint8_t *elf)
{
	uint8_t seg[64];
	uint32_t o = 0;

	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1)  -> slot0 handle */
	le32(seg + o, 0x00C5A583u); o += 4;     /* lw   a1, 12(a1) -> slot1 str ptr */
	le32(seg + o, 0x00002637u); o += 4;     /* lui  a2, 2      -> buf page */
	le32(seg + o, 0x04000693u); o += 4;     /* addi a3, x0, 64 -> cap */
	o = emit_call(seg, o, VM_CALL_GETPROP); /* sys_getprop -> buf has value */
	le32(seg + o, 0x00002537u); o += 4;     /* lui  a0, 2      -> buf ptr */
	o = emit_call(seg, o, VM_CALL_BROADCAST); /* sys_broadcast(buf) */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	return build_prog(elf, seg, o);
}

/* <obj>: sets prop "mark" = "1" on the resolved object through its handle
 * (subject to the authority check). "mark" and "1" are embedded in the image
 * and addressed off LOAD_VADDR. */
static long
build_setprop_prog(uint8_t *elf)
{
	uint8_t seg[80];
	uint32_t o = 0, pa1, pa2, m, v;

	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1) -> slot0 handle */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	pa1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, m (patched) */
	le32(seg + o, 0x00001637u); o += 4;     /* lui  a2, 1 */
	pa2 = o;
	le32(seg + o, 0x00060613u); o += 4;     /* addi a2, a2, v (patched) */
	o = emit_call(seg, o, VM_CALL_SETPROP); /* sys_setprop(handle, "mark", "1") */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit */
	m = o;
	memcpy(seg + o, "mark", 5); o += 5;
	v = o;
	memcpy(seg + o, "1", 2); o += 2;
	le32(seg + pa1, 0x00058593u | (m << 20));
	le32(seg + pa2, 0x00060613u | (v << 20));
	return build_prog(elf, seg, o);
}

/* Emit "set prop mark=1 on the handle already in a0", with "mark"/"1" embedded
 * at the end of seg and addressed off LOAD_VADDR. Returns the new offset. */
static uint32_t
emit_mark_write(uint8_t *seg, uint32_t o)
{
	uint32_t pa1, pa2, m, v;

	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	pa1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, m (patched) */
	le32(seg + o, 0x00001637u); o += 4;     /* lui  a2, 1 */
	pa2 = o;
	le32(seg + o, 0x00060613u); o += 4;     /* addi a2, a2, v (patched) */
	o = emit_call(seg, o, VM_CALL_SETPROP); /* sys_setprop(handle, "mark", "1") */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit */
	m = o;
	memcpy(seg + o, "mark", 5); o += 5;
	v = o;
	memcpy(seg + o, "1", 2); o += 2;
	le32(seg + pa1, 0x00058593u | (m << 20));
	le32(seg + pa2, 0x00060613u | (v << 20));
	return o;
}

/* <obj>: enable wizard, then set mark on the resolved object. */
static long
build_wizpoke_prog(uint8_t *elf)
{
	uint8_t seg[80];
	uint32_t o = 0;

	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_PRIV_WIZ_ON) */
	o = emit_call(seg, o, VM_CALL_SETPRIV); /* sys_setpriv */
	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1) -> slot0 handle */
	o = emit_mark_write(seg, o);
	return build_prog(elf, seg, o);
}

/* <obj>: enable then immediately drop wizard, then try to set mark. */
static long
build_wizdrop_prog(uint8_t *elf)
{
	uint8_t seg[80];
	uint32_t o = 0;

	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (WIZ_ON) */
	o = emit_call(seg, o, VM_CALL_SETPRIV);
	le32(seg + o, 0x00200513u); o += 4;     /* addi a0, x0, 2 (WIZ_OFF) */
	o = emit_call(seg, o, VM_CALL_SETPRIV);
	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1) -> slot0 handle */
	o = emit_mark_write(seg, o);
	return build_prog(elf, seg, o);
}

/* no args: assume the attached object's owner, then set mark on self. */
static long
build_tweak_prog(uint8_t *elf)
{
	uint8_t seg[80];
	uint32_t o = 0;

	le32(seg + o, 0x00300513u); o += 4;     /* addi a0, x0, 3 (VM_PRIV_AS_OWNER) */
	o = emit_call(seg, o, VM_CALL_SETPRIV); /* sys_setpriv */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_mark_write(seg, o);
	return build_prog(elf, seg, o);
}

/* no args: create `id` (parented to self when under_self) and exit. The id is
 * embedded and addressed off LOAD_VADDR. */
static long
build_create_prog(uint8_t *elf, const char *id, int under_self)
{
	uint8_t seg[96];
	uint32_t o = 0, pa1, off;
	size_t l;

	le32(seg + o, under_self ? 0x00100513u : 0x00000513u);
	o += 4;                                 /* addi a0, x0, 1|0 (parent) */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	pa1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, off (patched) */
	o = emit_call(seg, o, VM_CALL_CREATE);  /* sys_create -> handle */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit */
	off = o;
	l = strlen(id) + 1;
	memcpy(seg + o, id, l); o += (uint32_t)l;
	le32(seg + pa1, 0x00058593u | (off << 20));
	return build_prog(elf, seg, o);
}

/* no args: create items/tmp, then recycle the handle it returned, and exit. */
static long
build_maketmp_prog(uint8_t *elf)
{
	uint8_t seg[96];
	uint32_t o = 0, pa1, off;

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 (no parent) */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	pa1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, off (patched) */
	o = emit_call(seg, o, VM_CALL_CREATE);  /* sys_create -> handle in a0 */
	o = emit_call(seg, o, VM_CALL_RECYCLE); /* sys_recycle(handle) */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit */
	off = o;
	memcpy(seg + o, "items/tmp", 10); o += 10;
	le32(seg + pa1, 0x00058593u | (off << 20));
	return build_prog(elf, seg, o);
}

/* no args: create id1 then id2 (no parent), then exit. For the per-task quota:
 * with a cap of 1, the first create succeeds and the second is refused. */
static long
build_create2_prog(uint8_t *elf, const char *id1, const char *id2)
{
	uint8_t seg[128];
	uint32_t o = 0, p1, p2, off1, off2;
	size_t l;

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 (no parent) */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	p1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, off1 (patched) */
	o = emit_call(seg, o, VM_CALL_CREATE);  /* sys_create id1 */

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	p2 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, off2 (patched) */
	o = emit_call(seg, o, VM_CALL_CREATE);  /* sys_create id2 */

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */

	off1 = o;
	l = strlen(id1) + 1;
	memcpy(seg + o, id1, l); o += (uint32_t)l;
	off2 = o;
	l = strlen(id2) + 1;
	memcpy(seg + o, id2, l); o += (uint32_t)l;
	le32(seg + p1, 0x00058593u | (off1 << 20));
	le32(seg + p2, 0x00058593u | (off2 << 20));
	return build_prog(elf, seg, o);
}

/* <obj>: recycle the resolved object and exit. */
static long
build_scrap_prog(uint8_t *elf)
{
	uint8_t seg[32];
	uint32_t o = 0;

	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1) -> slot0 handle */
	o = emit_call(seg, o, VM_CALL_RECYCLE); /* sys_recycle */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit */
	return build_prog(elf, seg, o);
}

/* no args: open handles until the table is full (32 objfinds of `findname`),
 * then try to create `newid` with no parent, then exit 0. The create must be
 * refused for lack of a handle slot, so afterwards `newid` must not exist. */
static long
build_overflow_create_prog(uint8_t *elf, const char *findname,
                           const char *newid)
{
	uint8_t seg[1024];
	uint32_t o = 0, ps0, pa1, noff, idoff;
	size_t l;
	int k;

	le32(seg + o, 0x00001437u); o += 4;     /* lui  s0, 1 (holds &findname) */
	ps0 = o;
	le32(seg + o, 0x00040413u); o += 4;     /* addi s0, s0, noff (patched) */

	for (k = 0; k < 32; k++) {
		le32(seg + o, 0x00040513u); o += 4;     /* addi a0, s0, 0 (mv a0,s0) */
		le32(seg + o, 0x00000593u); o += 4;     /* addi a1, x0, 0 */
		o = emit_call(seg, o, VM_CALL_OBJFIND); /* sys_objfind */
	}

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 (no parent) */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 */
	pa1 = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, idoff (patched) */
	o = emit_call(seg, o, VM_CALL_CREATE);  /* sys_create -> NOSPACE */

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */

	noff = o;
	l = strlen(findname) + 1;
	memcpy(seg + o, findname, l); o += (uint32_t)l;
	idoff = o;
	l = strlen(newid) + 1;
	memcpy(seg + o, newid, l); o += (uint32_t)l;

	le32(seg + ps0, 0x00040413u | (noff << 20));
	le32(seg + pa1, 0x00058593u | (idoff << 20));
	return build_prog(elf, seg, o);
}

/* <any>: broadcasts the free-form remainder. */
static long
build_bcast_prog(uint8_t *elf)
{
	uint8_t seg[32];
	uint32_t o = 0;

	le32(seg + o, 0x0045A503u); o += 4;     /* lw   a0, 4(a1) -> slot0 str ptr */
	o = emit_call(seg, o, VM_CALL_BROADCAST); /* sys_broadcast */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, VM_CALL_EXIT);    /* sys_exit 0 */
	return build_prog(elf, seg, o);
}

int
main(void)
{
	uint8_t getprop_elf[512], bcast_elf[512], setprop_elf[512];
	uint8_t wizpoke_elf[512], wizdrop_elf[512], tweak_elf[512];
	uint8_t make_elf[512], evil_elf[512], tmp_elf[512], scrap_elf[512];
	uint8_t over_elf[1024];
	long gl, bl, sl, wpl, wdl, twl, ml, el, tl, cl, ol;

	LOG_INFO("%%%%%%%%%%%% START-TEST : verb command dispatch");

	if (!mkdtemp(tmpdir)) {
		LOG_ERROR("mkdtemp failed");
		return EXIT_FAILURE;
	}
	mud_db = muddb_open(tmpdir, 0);
	if (!mud_db || obj_initialize(mud_db, 64) != 0 ||
	    verb_dispatch_init(tmpdir, stub_bcast) != 0) {
		LOG_ERROR("setup failed");
		cleanup_tmpdir();
		return EXIT_FAILURE;
	}
	verb_dispatch_set_wizard_check(test_may_wizard);

	/* A room holding the verbs, the actor in it, a nameable item, and three
	 * objects with different ownership for the authority check. */
	mkobj("rooms/cave", "a dark cave", NULL);
	mkobj("chars/1", "Hero", "rooms/cave");
	mkobj("items/lamp", "a brass lamp", "rooms/cave");
	mkobj("items/mine", "mine", "rooms/cave");
	mkobj("items/theirs", "theirs", "rooms/cave");
	mkobj("items/nobody", "nobody", "rooms/cave");
	setowner("items/mine", "chars/1");      /* the initiator owns this */
	setowner("items/theirs", "chars/2");    /* someone else owns this */
	/* items/nobody is left unowned */

	/* L7b fixtures: a wizard-capable actor, another owner's object, and an
	 * object whose own verb assumes its owner. */
	mkobj("chars/wiz", "Wizard", "rooms/cave");
	mkobj("items/locked", "locked", "rooms/cave");
	mkobj("items/gadget", "gadget", "rooms/cave");
	setowner("items/locked", "chars/2");
	setowner("items/gadget", "chars/3");

	/* L7c fixture: an owned, non-empty container (holds a pebble). */
	mkobj("items/box", "box", "rooms/cave");
	mkobj("items/pebble", "pebble", NULL);
	setowner("items/box", "chars/1");
	obj_move("items/pebble", "items/box");

	gl = build_getprop_prog(getprop_elf);
	bl = build_bcast_prog(bcast_elf);
	sl = build_setprop_prog(setprop_elf);
	wpl = build_wizpoke_prog(wizpoke_elf);
	wdl = build_wizdrop_prog(wizdrop_elf);
	twl = build_tweak_prog(tweak_elf);
	ml = build_create_prog(make_elf, "items/new1", 1);
	el = build_create_prog(evil_elf, "programs/evil", 0);
	tl = build_maketmp_prog(tmp_elf);
	cl = build_scrap_prog(scrap_elf);
	ol = build_overflow_create_prog(over_elf, "lamp", "items/overflow");
	install_program("lookprog", getprop_elf, gl);
	install_program("sayprog", bcast_elf, bl);
	install_program("pokeprog", setprop_elf, sl);
	install_program("wizpokeprog", wizpoke_elf, wpl);
	install_program("wizdropprog", wizdrop_elf, wdl);
	install_program("tweakprog", tweak_elf, twl);
	install_program("makeprog", make_elf, ml);
	install_program("evilprog", evil_elf, el);
	install_program("tmpprog", tmp_elf, tl);
	install_program("scrapprog", scrap_elf, cl);
	install_program("overflowprog", over_elf, ol);

	setverb("rooms/cave", "look", "lookprog\t<obj> <any>");
	setverb("rooms/cave", "say", "sayprog\t<any>");
	setverb("rooms/cave", "poke", "pokeprog\t<obj>");
	setverb("rooms/cave", "wpoke", "wizpokeprog\t<obj>");
	setverb("rooms/cave", "wdrop", "wizdropprog\t<obj>");
	setverb("items/gadget", "tweak", "tweakprog\t");
	setverb("rooms/cave", "make", "makeprog\t");
	setverb("rooms/cave", "makeevil", "evilprog\t");
	setverb("rooms/cave", "maketmp", "tmpprog\t");
	setverb("rooms/cave", "scrap", "scrapprog\t<obj>");
	setverb("rooms/cave", "overflow", "overflowprog\t");

	/* An object argument resolves to a handle the program reads through, then
	 * broadcasts the property it fetched. */
	g_bcalls = 0;
	EXPECT_EQ(verb_dispatch_command("chars/1", "look", "lamp name.short"),
	          VERB_CMD_OK, "object-arg verb ran");
	EXPECT(g_bcalls == 1 && strcmp(g_line, "a brass lamp") == 0,
	       "object arg resolved and read through its handle");

	/* A string argument reaches the program and broadcasts to the room. */
	g_bcalls = 0;
	EXPECT_EQ(verb_dispatch_command("chars/1", "say", "hello world"),
	          VERB_CMD_OK, "string verb ran cleanly");
	EXPECT_EQ(g_bcalls, 1, "broadcast delivered once");
	EXPECT(strcmp(g_line, "hello world") == 0, "free-form text reached the verb");
	EXPECT(strcmp(g_room, "rooms/cave") == 0, "output went to the actor's room");

	/* No verb.<word> anywhere in scope. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "frobnicate", ""),
	          VERB_CMD_NOVERB, "unknown word yields no verb");

	/* A verb matched the word but the arguments do not fit its spec. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "look", ""),
	          VERB_CMD_NOMATCH, "empty args do not satisfy <obj> <any>");

	/* An object argument that does not resolve fails the whole command, and no
	 * program runs (no broadcast). */
	g_bcalls = 0;
	EXPECT_EQ(verb_dispatch_command("chars/1", "look", "dragon name.short"),
	          VERB_CMD_BADARG, "unresolved object argument fails before dispatch");
	EXPECT_EQ(g_bcalls, 0, "a failed bind runs no program");

	/* Authority (L7a): a write succeeds only when the effective owner (the
	 * initiator) owns the target. The verb always runs; the write inside is
	 * what the check gates. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "poke", "mine"),
	          VERB_CMD_OK, "poke ran on an owned object");
	EXPECT(has_mark("items/mine"), "owner write was allowed");

	EXPECT_EQ(verb_dispatch_command("chars/1", "poke", "theirs"),
	          VERB_CMD_OK, "poke ran on another's object");
	EXPECT(!has_mark("items/theirs"), "write to another owner's object was denied");

	EXPECT_EQ(verb_dispatch_command("chars/1", "poke", "nobody"),
	          VERB_CMD_OK, "poke ran on an unowned object");
	EXPECT(!has_mark("items/nobody"), "write to an unowned object was denied");

	/* Elevation (L7b). A non-capable initiator cannot enable wizard, so the
	 * cross-owner write is still denied. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "wpoke", "locked"),
	          VERB_CMD_OK, "wpoke ran for a non-wizard");
	EXPECT(!has_mark("items/locked"), "denied elevation leaves the write denied");

	/* A capable initiator that enables then drops wizard before writing is
	 * back to un-elevated, so the write is denied. */
	EXPECT_EQ(verb_dispatch_command("chars/wiz", "wdrop", "locked"),
	          VERB_CMD_OK, "wdrop ran");
	EXPECT(!has_mark("items/locked"), "dropping wizard before the write denies it");

	/* A capable initiator that enables wizard writes across owners. */
	EXPECT_EQ(verb_dispatch_command("chars/wiz", "wpoke", "theirs"),
	          VERB_CMD_OK, "wpoke ran for a wizard");
	EXPECT(has_mark("items/theirs"), "wizard write across owners was allowed");

	/* Assuming the attached object's owner lets a verb modify its own object
	 * even though the initiator does not own it. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "tweak", ""),
	          VERB_CMD_OK, "tweak ran");
	EXPECT(has_mark("items/gadget"), "assuming the object owner allowed the write");

	/* Create (L7c). A guest-supplied id is created, owned by the initiator and
	 * parented to the holder passed as the parent handle. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "make", ""),
	          VERB_CMD_OK, "make ran");
	EXPECT(obj_exists("items/new1"), "created the guest-named object");
	EXPECT(prop_eq("items/new1", "%owner", "chars/1"),
	       "new object is owned by the initiator");
	EXPECT(prop_eq("items/new1", "%parent", "rooms/cave"),
	       "new object is parented to the handle object");

	/* A reserved namespace is refused. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "makeevil", ""),
	          VERB_CMD_OK, "makeevil ran");
	EXPECT(!obj_exists("programs/evil"),
	       "creating in a system namespace was refused");

	/* Recycle removes an object the caller owns. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "maketmp", ""),
	          VERB_CMD_OK, "maketmp ran");
	EXPECT(!obj_exists("items/tmp"), "owned object was recycled");

	/* Recycle is refused on another owner's object and on a non-empty one. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "scrap", "theirs"),
	          VERB_CMD_OK, "scrap ran on another's object");
	EXPECT(obj_exists("items/theirs"), "recycling another owner's object was denied");

	EXPECT_EQ(verb_dispatch_command("chars/1", "scrap", "box"),
	          VERB_CMD_OK, "scrap ran on a non-empty container");
	EXPECT(obj_exists("items/box"), "recycling a non-empty container was refused");

	/* A recycle refused because the object is still pinned by another handle
	 * must undo its move to limbo. The two <obj> tokens resolve the same name
	 * twice, so slot1 keeps a second pin while the program recycles slot0; the
	 * destroy is refused and the object must stay at its original location, not
	 * be stranded in limbo. */
	setverb("rooms/cave", "scrap2", "scrapprog\t<obj> <obj>");
	{
		char *loc;

		EXPECT_EQ(verb_dispatch_command("chars/1", "scrap2", "mine mine"),
		          VERB_CMD_OK, "scrap2 ran");
		EXPECT(obj_exists("items/mine"),
		       "a recycle refused by a second pin did not destroy the object");
		loc = obj_location("items/mine");
		EXPECT(loc && strcmp(loc, "rooms/cave") == 0,
		       "the refused recycle restored the object's location");
		free(loc);
	}

	/* A create refused because the handle table is full must leave nothing
	 * persisted (L7 review #7). The program opens handles until the table is
	 * full, then its sys_create returns NOSPACE. */
	EXPECT_EQ(verb_dispatch_command("chars/1", "overflow", ""),
	          VERB_CMD_OK, "overflow verb ran");
	EXPECT(!obj_exists("items/overflow"),
	       "a create refused by a full handle table persisted nothing");

	/* Creation quotas (verb-creation-quota card). Fresh owners keep the
	 * per-task and per-owner baselines clean and independent. */
	mkobj("chars/qt", "QuotaTask", "rooms/cave");
	mkobj("chars/qo", "QuotaOwner", "rooms/cave");
	{
		uint8_t p2_elf[256], q1_elf[256], q2_elf[256], q3_elf[256];
		long p2l = build_create2_prog(p2_elf, "items/pt1", "items/pt2");
		long q1l = build_create_prog(q1_elf, "items/q1", 0);
		long q2l = build_create_prog(q2_elf, "items/q2", 0);
		long q3l = build_create_prog(q3_elf, "items/q3", 0);

		install_program("ptwoprog", p2_elf, p2l);
		install_program("q1prog", q1_elf, q1l);
		install_program("q2prog", q2_elf, q2l);
		install_program("q3prog", q3_elf, q3l);
		setverb("rooms/cave", "ptwo", "ptwoprog\t");
		setverb("rooms/cave", "mkq1", "q1prog\t");
		setverb("rooms/cave", "mkq2", "q2prog\t");
		setverb("rooms/cave", "mkq3", "q3prog\t");

		/* Per-task cap of 1: one task's second create is refused. */
		verb_dispatch_set_quota(1, 0);
		EXPECT_EQ(verb_dispatch_command("chars/qt", "ptwo", ""),
		          VERB_CMD_OK, "ptwo ran");
		EXPECT(obj_exists("items/pt1"), "first create under the per-task cap");
		EXPECT(!obj_exists("items/pt2"), "second create hit the per-task cap");

		/* Per-owner cap of 2: the owner's third object is refused. */
		verb_dispatch_set_quota(0, 2);
		EXPECT_EQ(verb_dispatch_command("chars/qo", "mkq1", ""),
		          VERB_CMD_OK, "mkq1 ran");
		EXPECT_EQ(verb_dispatch_command("chars/qo", "mkq2", ""),
		          VERB_CMD_OK, "mkq2 ran");
		EXPECT_EQ(verb_dispatch_command("chars/qo", "mkq3", ""),
		          VERB_CMD_OK, "mkq3 ran");
		EXPECT(obj_exists("items/q1") && obj_exists("items/q2"),
		       "two owned creates allowed");
		EXPECT(!obj_exists("items/q3"), "third create hit the per-owner cap");
		EXPECT(obj_owner_count("chars/qo") == 2,
		       "owner index counts the owned objects");

		/* Destroying an owned object frees a slot: the next create is allowed. */
		obj_destroy("items/q1");
		EXPECT(obj_owner_count("chars/qo") == 1,
		       "destroy decremented the owner count");
		EXPECT_EQ(verb_dispatch_command("chars/qo", "mkq3", ""),
		          VERB_CMD_OK, "mkq3 ran again");
		EXPECT(obj_exists("items/q3"), "create allowed after a slot was freed");

		verb_dispatch_set_quota(0, 0);  /* lift the caps for any later cases */
	}

	/* When the SDK built look.elf, run the real cmd.* runtime end to end. */
	if (install_sdk_look() == 0) {
		setverb("rooms/cave", "examine", "look\t<obj>");
		g_bcalls = 0;
		EXPECT_EQ(verb_dispatch_command("chars/1", "examine", "lamp"),
		          VERB_CMD_OK, "SDK cmd verb ran");
		EXPECT(g_bcalls == 1 && strcmp(g_line, "a brass lamp") == 0,
		       "SDK verb read the handle and broadcast the name");
	} else {
		LOG_INFO("data/vm/look.elf not built; skipping the SDK cmd case");
	}

	/* Program registration (the @program layer). These touch only the object
	 * store, so they run with no SDK build. "lookprog.elf" was staged by
	 * install_program above, so it is a valid host image to register. */
	{
		char err[256] = "";

		EXPECT_EQ(verb_program_register("regprog", "lookprog.elf", 0,
		                                err, sizeof err), 0,
		          "register a program with an existing host image");
		EXPECT_EQ(verb_program_register("bad/id", "lookprog.elf", 0, NULL, 0),
		          -1, "register rejects an id with a slash");
		EXPECT_EQ(verb_program_register("missprog", "nope.elf", 0, NULL, 0),
		          -1, "register rejects a missing host image");

		EXPECT_EQ(verb_program_bind_vfs("vfsprog", "/bin/x.elf", 0), 0,
		          "bind_vfs sets a VFS image on a program");
		EXPECT_EQ(verb_program_bind_vfs("vfsprog", "relative", 0), -1,
		          "bind_vfs rejects a non-absolute VFS path");

		g_prog_count = 0;
		EXPECT(verb_program_list(count_prog, NULL) >= 0, "list enumerates");
		EXPECT(g_prog_count > 0, "the listed programs include the registered ones");

		EXPECT_EQ(verb_program_unregister("regprog"), 0, "unregister a program");
		EXPECT_EQ(verb_program_unregister("regprog"), 1,
		          "unregister a second time reports no such program");
	}

	verb_dispatch_shutdown();
	obj_shutdown();
	muddb_close(mud_db);
	cleanup_tmpdir();

	return ctest_report("test_verb_command");
}
