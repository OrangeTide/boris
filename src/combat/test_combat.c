/* test_combat.c - skeleton tests for combat scheduling
 *
 * These tests run with loop=NULL so we don't drag in the iox loop. The
 * scheduling/rearm logic that touches iox is exercised separately by
 * eyeballing combat.c -- here we verify that combat correctly drives
 * the underlying phaseq.
 *
 * Copyright (c) 2026 Jon Mayo
 * Licensed under MIT-0 OR PUBLIC DOMAIN
 */
#include "combat.h"

#include "iox/iox_timer.h"

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* iox stubs: combat_open(loop=NULL) means combat_rearm/close never call
 * these, but the linker still resolves the references. */
int  iox_timer_add(struct iox_loop *l, int ms, iox_timer_cb cb, void *a)
	{ (void)l; (void)ms; (void)cb; (void)a; return -1; }
void iox_timer_remove(struct iox_loop *l, int id)
	{ (void)l; (void)id; }

static int failures;

#define FAIL(fmt, ...) do { \
	fprintf(stderr, "FAIL %s:%d " fmt "\n", __func__, __LINE__, ##__VA_ARGS__); \
	failures++; \
} while (0)

#define OK(label) printf("ok   %s\n", (label))

#define EXPECT(cond, label) do { \
	if (!(cond)) FAIL("%s: expected (%s)", (label), #cond); \
	else OK(label); \
} while (0)

#define MAX_FIRED 16
#define MAX_TAG   16

struct fire_log {
	char  tag[MAX_FIRED][MAX_TAG];
	void *arg[MAX_FIRED];
	unsigned n;
};

static struct fire_log g_log;

static void
record_cb(void *arg, const char *str)
{
	if (g_log.n >= MAX_FIRED) {
		FAIL("fire_log overflow");
		return;
	}
	g_log.arg[g_log.n] = arg;
	if (str) {
		size_t n = strlen(str);
		if (n >= MAX_TAG) n = MAX_TAG - 1;
		memcpy(g_log.tag[g_log.n], str, n);
		g_log.tag[g_log.n][n] = '\0';
	} else {
		g_log.tag[g_log.n][0] = '\0';
	}
	g_log.n++;
}

static void
log_reset(void)
{
	memset(&g_log, 0, sizeof g_log);
}

static void
test_open_close_empty(void)
{
	struct combat c;
	EXPECT(combat_open(&c, NULL) == 0, "open returns 0");
	EXPECT(c.iox_timer_id == -1, "no timer scheduled initially");
	EXPECT(c.loop == NULL, "loop stored");
	EXPECT(combat_tick_at(&c, 1000) == -1, "empty tick returns -1");
	combat_close(&c);
	EXPECT(c.iox_timer_id == -1, "timer cleared on close");
}

static void
test_schedule_at_and_fire(void)
{
	struct combat c;
	combat_open(&c, NULL);

	poolid_t a = combat_schedule_at(&c, 5000, record_cb, (void *)1, "a");
	poolid_t b = combat_schedule_at(&c, 2000, record_cb, (void *)2, "b");
	poolid_t d = combat_schedule_at(&c, 8000, record_cb, (void *)3, "d");
	EXPECT(a && b && d, "all event_ids nonzero");

	log_reset();
	int64_t next = combat_tick_at(&c, 3000);
	EXPECT(g_log.n == 1, "one fired at t=3000");
	EXPECT(strcmp(g_log.tag[0], "b") == 0, "earliest fired");
	EXPECT(next == 2000, "next-head = 5000-3000");

	log_reset();
	next = combat_tick_at(&c, 9999);
	EXPECT(g_log.n == 2, "remaining two fire");
	EXPECT(next == -1, "drained");

	combat_close(&c);
}

static void
test_cancel_and_scrub(void)
{
	struct combat c;
	combat_open(&c, NULL);

	int alice = 0, bob = 0;
	poolid_t a1 = combat_schedule_at(&c, 1000, record_cb, &alice, "a1");
	combat_schedule_at(&c, 1500, record_cb, &bob,   "b1");
	combat_schedule_at(&c, 2000, record_cb, &alice, "a2");
	combat_schedule_at(&c, 2500, record_cb, &bob,   "b2");

	EXPECT(combat_cancel(&c, a1) == 1, "cancel a1");
	EXPECT(combat_cancel(&c, a1) == 0, "double-cancel returns 0");

	int n = combat_scrub(&c, &bob);
	EXPECT(n == 2, "scrub removed 2 of bob's");

	log_reset();
	combat_tick_at(&c, 9999);
	EXPECT(g_log.n == 1, "only a2 left to fire");
	if (g_log.n == 1)
		EXPECT(g_log.arg[0] == &alice, "fired arg=alice");

	combat_close(&c);
}

static void
test_independent_sessions(void)
{
	struct combat c1, c2;
	combat_open(&c1, NULL);
	combat_open(&c2, NULL);

	combat_schedule_at(&c1, 1000, record_cb, (void *)0xA, "c1");
	combat_schedule_at(&c2, 500,  record_cb, (void *)0xB, "c2");

	log_reset();
	combat_tick_at(&c2, 600);
	EXPECT(g_log.n == 1, "only c2 fires");
	if (g_log.n == 1)
		EXPECT(strcmp(g_log.tag[0], "c2") == 0, "tag=c2");

	log_reset();
	combat_tick_at(&c1, 1500);
	EXPECT(g_log.n == 1, "c1 fires independently");

	combat_close(&c1);
	combat_close(&c2);
}

int
main(void)
{
	test_open_close_empty();
	test_schedule_at_and_fire();
	test_cancel_and_scrub();
	test_independent_sessions();

	if (failures) {
		fprintf(stderr, "%d test(s) failed\n", failures);
		return 1;
	}
	printf("all tests passed\n");
	return 0;
}
