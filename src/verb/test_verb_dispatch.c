/* test_verb_dispatch.c : unit tests for one-shot dispatch and resident agents */

#include "verb_dispatch.h"
#include "verb_agent.h"
#include "obj.h"
#include "vm.h"

#include <elf32.h>

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "ctest.h"

/****************************************************************
 * Minimal ELF builder (see src/vm/test_vm.c for the same shape).
 * One PT_LOAD at 0x1000 holding the code followed by the KPIMPT1 host-call
 * table, which the loader finds by scanning. Import index i is reached with
 * a7 = VM_HOSTCALL_BASE + i.
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

static uint32_t
emit_call(uint8_t *seg, uint32_t o, uint32_t idx)
{
	le32(seg + o, 0x001008B7u);             /* lui  a7, 0x100 */
	o += 4;
	if (idx) {
		le32(seg + o, 0x00088893u | (idx << 20));  /* addi a7, a7, idx */
		o += 4;
	}
	le32(seg + o, 0x00000073u);             /* ecall */
	return o + 4;
}

static long
build_prog(uint8_t *buf, const uint8_t *seg, uint32_t seglen,
           const char *const *imports, uint32_t nimports)
{
	uint8_t *eh = buf;
	uint8_t *ph = buf + 52;
	uint32_t code_off = 84;
	uint8_t *body = buf + code_off;
	uint32_t pad, tbl, i, total;

	memcpy(body, seg, seglen);
	pad = (seglen + 3) & ~3u;
	for (i = seglen; i < pad; i++)
		body[i] = 0;
	tbl = pad;
	memcpy(body + tbl, "KPIMPT1", 7);
	body[tbl + 7] = 0;
	le32(body + tbl + 8, nimports);
	total = tbl + 12;
	for (i = 0; i < nimports; i++) {
		uint32_t l = (uint32_t)strlen(imports[i]) + 1;
		memcpy(body + total, imports[i], l);
		total += l;
	}

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
 * Broadcast capture
 ****************************************************************/

static char g_room[64];
static char g_line[512];
static int  g_bcalls;

static void
stub_bcast(const char *room, const char *line)
{
	snprintf(g_room, sizeof g_room, "%s", room ? room : "");
	snprintf(g_line, sizeof g_line, "%s", line ? line : "");
	g_bcalls++;
}

/****************************************************************
 * Tests
 ****************************************************************/

/* sys_getprop reads a string property of the self object; the program exits
 * with the length it read. */
static void
test_getprop(void)
{
	static const char *const imp[] = { "sys_getprop", "sys_exit" };
	static const char *const argv[] = { "greeting" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	OBJ *self = obj_new("test/self");

	obj_prop_set(self, "greeting", "hello");

	le32(seg + o, 0x0005A583u);     /* lw   a1, 0(a1) -> a1 = argv[0] name */
	o += 4;
	le32(seg + o, 0x00100513u);     /* addi a0, x0, 1 -> a0 = VM_HANDLE_SELF */
	o += 4;
	le32(seg + o, 0x00002637u);     /* lui  a2, 2     -> a2 = 0x2000 (buf) */
	o += 4;
	le32(seg + o, 0x04000693u);     /* addi a3, x0, 64 (buf cap) */
	o += 4;
	o = emit_call(seg, o, 0);       /* sys_getprop(self, name, buf, 64) -> len */
	o = emit_call(seg, o, 1);       /* sys_exit with that length */
	len = build_prog(elf, seg, o, imp, 2);

	EXPECT_EQ(verb_dispatch_run_image(elf, len, self, "room", argv, 1), 5,
	          "getprop returned the property length");
	obj_free(self);
}

/* sys_setprop writes a string property on the self object. */
static void
test_setprop(void)
{
	static const char *const imp[] = { "sys_setprop", "sys_exit" };
	static const char *const argv[] = { "mood", "cheerful" };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	const char *got;
	OBJ *self = obj_new("test/self");

	le32(seg + o, 0x0045A603u);     /* lw   a2, 4(a1) -> a2 = argv[1] value */
	o += 4;
	le32(seg + o, 0x0005A583u);     /* lw   a1, 0(a1) -> a1 = argv[0] name */
	o += 4;
	le32(seg + o, 0x00100513u);     /* addi a0, x0, 1 -> a0 = VM_HANDLE_SELF */
	o += 4;
	o = emit_call(seg, o, 0);       /* sys_setprop(self, name, value) */
	le32(seg + o, 0x00000513u);     /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, 1);       /* sys_exit 0 */
	len = build_prog(elf, seg, o, imp, 2);

	EXPECT_EQ(verb_dispatch_run_image(elf, len, self, "room", argv, 2), 0,
	          "setprop program exited cleanly");
	got = obj_prop_get(self, "mood");
	EXPECT(got && strcmp(got, "cheerful") == 0, "property was written");
	obj_free(self);
}

/* sys_broadcast sends a line to the self object's room. */
static void
test_broadcast(void)
{
	static const char *const imp[] = { "sys_broadcast", "sys_exit" };
	static const char *const argv[] = { "the idol hums." };
	uint8_t seg[48];
	uint8_t elf[512];
	uint32_t o = 0;
	long len;
	OBJ *self = obj_new("test/self");

	g_bcalls = 0;
	le32(seg + o, 0x0005A503u);     /* lw   a0, 0(a1) -> a0 = argv[0] msg */
	o += 4;
	o = emit_call(seg, o, 0);       /* sys_broadcast */
	le32(seg + o, 0x00000513u);     /* addi a0, x0, 0 */
	o += 4;
	o = emit_call(seg, o, 1);       /* sys_exit 0 */
	len = build_prog(elf, seg, o, imp, 2);

	EXPECT_EQ(verb_dispatch_run_image(elf, len, self, "church", argv, 1), 0,
	          "broadcast program exited cleanly");
	EXPECT_EQ(g_bcalls, 1, "broadcast was delivered once");
	EXPECT(strcmp(g_room, "church") == 0, "delivered to the self room");
	EXPECT(strcmp(g_line, "the idol hums.") == 0, "delivered the message");
	obj_free(self);
}

/****************************************************************
 * Resident agents
 ****************************************************************/

/* A listening agent: register with sys_listen, block for one event, store its
 * payload on self with sys_setprop, then exit. Proves listen registration,
 * host-to-agent delivery, and payload marshalling. */
static void
test_agent_listen(void)
{
	static const char *const imp[] = {
		"sys_listen", "sys_suspend", "sys_getmsg", "sys_setprop", "sys_exit",
	};
	uint8_t seg[160];
	uint8_t elf[512];
	uint32_t o = 0, patch, got_off;
	long len;
	OBJ *self = obj_new("test/agent");
	uint32_t id;

	/* An agent runs as its object's owner, so self needs one to launch. */
	obj_prop_set_internal(self, "%owner", "chars/agent");
	const char *got;

	o = emit_call(seg, o, 0);               /* sys_listen */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (block for event) */
	o = emit_call(seg, o, 1);               /* sys_suspend -> blocks */
	le32(seg + o, 0x00002537u); o += 4;     /* lui  a0, 2 (record buffer) */
	le32(seg + o, 0x04000593u); o += 4;     /* addi a1, x0, 64 */
	o = emit_call(seg, o, 2);               /* sys_getmsg */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 (name page) */
	patch = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, got_off (patched) */
	le32(seg + o, 0x00002637u); o += 4;     /* lui  a2, 2 (record page) */
	le32(seg + o, 0x00C60613u); o += 4;     /* addi a2, a2, 12 (payload) */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_call(seg, o, 3);               /* sys_setprop(self, "got", payload) */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, 4);               /* sys_exit */
	got_off = o;
	memcpy(seg + o, "got", 4); o += 4;      /* "got\0" */
	le32(seg + patch, 0x00058593u | (got_off << 20));

	len = build_prog(elf, seg, o, imp, 5);

	id = verb_agent_launch_image(elf, len, self, "test/agent", "room");
	EXPECT(id != 0, "agent launched");
	EXPECT_EQ(verb_agent_tick(4096), 1, "agent listens, blocks, stays live");
	EXPECT_EQ(verb_agent_deliver("test/agent", VM_EV_USER, 0, "ping", 4), 0,
	          "event routed to the listener");
	EXPECT_EQ(verb_agent_tick(4096), 0, "agent handled the event and exited");
	got = obj_prop_get(self, "got");
	EXPECT(got && strcmp(got, "ping") == 0, "agent stored the payload");
	obj_free(self);
}

/* A sequential task: no sys_listen, it blocks on sys_suspend and is resumed by
 * verb_agent_post to its id. It must not receive events aimed at a listener. */
static void
test_agent_post(void)
{
	static const char *const imp[] = {
		"sys_suspend", "sys_getmsg", "sys_setprop", "sys_exit",
	};
	uint8_t seg[160];
	uint8_t elf[512];
	uint32_t o = 0, patch_n, patch_v, woke_off, one_off;
	long len;
	OBJ *self = obj_new("test/seq");
	uint32_t id;
	const char *woke;

	obj_prop_set_internal(self, "%owner", "chars/agent");

	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (block for event) */
	o = emit_call(seg, o, 0);               /* sys_suspend -> blocks */
	le32(seg + o, 0x00002537u); o += 4;     /* lui  a0, 2 (record buffer) */
	le32(seg + o, 0x04000593u); o += 4;     /* addi a1, x0, 64 */
	o = emit_call(seg, o, 1);               /* sys_getmsg */
	le32(seg + o, 0x000015B7u); o += 4;     /* lui  a1, 1 (name page) */
	patch_n = o;
	le32(seg + o, 0x00058593u); o += 4;     /* addi a1, a1, woke_off (patched) */
	le32(seg + o, 0x00001637u); o += 4;     /* lui  a2, 1 (value page) */
	patch_v = o;
	le32(seg + o, 0x00060613u); o += 4;     /* addi a2, a2, one_off (patched) */
	le32(seg + o, 0x00100513u); o += 4;     /* addi a0, x0, 1 (VM_HANDLE_SELF) */
	o = emit_call(seg, o, 2);               /* sys_setprop(self, "woke", "1") */
	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, 3);               /* sys_exit */
	woke_off = o;
	memcpy(seg + o, "woke", 5); o += 5;     /* "woke\0" */
	one_off = o;
	memcpy(seg + o, "1", 2); o += 2;        /* "1\0" */
	le32(seg + patch_n, 0x00058593u | (woke_off << 20));
	le32(seg + patch_v, 0x00060613u | (one_off << 20));

	len = build_prog(elf, seg, o, imp, 4);

	id = verb_agent_launch_image(elf, len, self, "test/seq", "room");
	EXPECT(id != 0, "sequential task launched");
	EXPECT_EQ(verb_agent_tick(4096), 1, "task blocks and stays live");
	EXPECT_EQ(verb_agent_deliver("test/seq", VM_EV_USER, 0, "x", 1), -1,
	          "a non-listener does not receive routed events");
	EXPECT_EQ(verb_agent_post(id, VM_EV_WAKE, 0, NULL, 0), 0,
	          "post reaches it by id");
	EXPECT_EQ(verb_agent_tick(4096), 0, "task resumed and exited");
	woke = obj_prop_get(self, "woke");
	EXPECT(woke && strcmp(woke, "1") == 0, "task ran after the post");
	obj_free(self);
}

/* The resident supervisor parses its list, throttles repeated launch attempts,
 * and does not relaunch a resident that is already running. */
static void
test_supervisor(void)
{
	static const char *const imp[] = { "sys_exit" };
	uint8_t seg[16];
	uint8_t elf[512];
	uint32_t o;
	long len;
	OBJ *self;
	uint32_t id;

	/* Two ids (spaces trimmed). Neither program exists, so each launch fails,
	 * and the next attempt is held off by the respawn cooldown. */
	verb_agent_set_resident("ghost, phantom ");
	EXPECT_EQ(verb_agent_supervise(), 2, "both residents were attempted");
	EXPECT_EQ(verb_agent_count(), 0, "missing programs launch nothing");
	EXPECT_EQ(verb_agent_supervise(), 0, "cooldown throttles the retry");

	verb_agent_set_resident("");
	EXPECT_EQ(verb_agent_supervise(), 0, "an empty list does nothing");

	/* A running resident is left alone: supervise finds it by its self key. */
	o = emit_call(seg, 0, 0);               /* sys_exit (a0 = 0) */
	len = build_prog(elf, seg, o, imp, 1);
	self = obj_new("test/live");
	obj_prop_set_internal(self, "%owner", "chars/agent");
	id = verb_agent_launch_image(elf, len, self, "programs/live", "room");
	EXPECT(id != 0, "resident launched");
	verb_agent_set_resident("live");
	EXPECT_EQ(verb_agent_supervise(), 0, "a running resident is not relaunched");
	EXPECT_EQ(verb_agent_tick(1000), 0, "it runs and exits");
	obj_free(self);
	verb_agent_set_resident("");
}

/* An agent runs as its object's owner, so a self with no %owner is refused. */
static void
test_agent_requires_owner(void)
{
	static const char *const imp[] = { "sys_exit" };
	uint8_t seg[32];
	uint8_t elf[256];
	uint32_t o = 0;
	long len;
	OBJ *self = obj_new("test/noowner");
	uint32_t id;

	le32(seg + o, 0x00000513u); o += 4;     /* addi a0, x0, 0 */
	o = emit_call(seg, o, 0);               /* sys_exit 0 */
	len = build_prog(elf, seg, o, imp, 1);

	id = verb_agent_launch_image(elf, len, self, "test/noowner", "room");
	EXPECT(id == 0, "agent with an owner-less self is not launched");
	obj_free(self);
}

int
main(void)
{
	if (verb_dispatch_init("data/vm", stub_bcast) != 0) {
		FAIL("verb_dispatch_init failed");
		return ctest_report("verb_dispatch");
	}
	test_getprop();
	test_setprop();
	test_broadcast();
	test_agent_listen();
	test_agent_post();
	test_supervisor();
	test_agent_requires_owner();
	verb_dispatch_shutdown();
	return ctest_report("verb_dispatch");
}
