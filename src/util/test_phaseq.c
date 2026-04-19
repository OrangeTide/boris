/**
 * @file test_phaseq.c
 *
 * Unit tests for the per-instance phaseq API (post-refactor).
 *
 * Tests are written against the target API described in
 * doc/phaseq.md. They will not compile until the refactor lands.
 *
 * Copyright (c) 2026 Jon Mayo <jon@rm-f.net>
 */

#include "phaseq.h"

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

/* ---- callback recording ---- */

#define MAX_FIRED 32

struct fire_log {
	const char *tag[MAX_FIRED];
	void       *arg[MAX_FIRED];
	unsigned    n;
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
	g_log.tag[g_log.n] = str;
	g_log.n++;
}

static void
log_reset(void)
{
	memset(&g_log, 0, sizeof g_log);
}

/* ---- tests ---- */

static void
test_init_done_empty(void)
{
	struct phaseq q;
	EXPECT(phaseq_init(&q) == 0, "init returns 0");
	EXPECT(phaseq_head_deadline(&q) == 0, "empty queue head is 0");
	EXPECT(phaseq_process_at(&q, 1000) == -1, "empty process returns -1");
	phaseq_done(&q);
}

static void
test_ordered_insertion(void)
{
	struct phaseq q;
	phaseq_init(&q);

	/* insert in reverse-ish order; head should always be earliest */
	phaseq_add(&q, 5000, record_cb, (void *)1, "c");
	EXPECT(phaseq_head_deadline(&q) == 5000, "head=5000 after first add");

	phaseq_add(&q, 2000, record_cb, (void *)2, "a");
	EXPECT(phaseq_head_deadline(&q) == 2000, "head=2000 after earlier add");

	phaseq_add(&q, 3000, record_cb, (void *)3, "b");
	EXPECT(phaseq_head_deadline(&q) == 2000, "head unchanged on later add");

	phaseq_add(&q, 1000, record_cb, (void *)4, "z");
	EXPECT(phaseq_head_deadline(&q) == 1000, "head=1000 after earliest add");

	log_reset();
	int64_t next = phaseq_process_at(&q, 10000);
	EXPECT(next == -1, "all fired -> next=-1");
	EXPECT(g_log.n == 4, "fired 4 events");
	if (g_log.n == 4) {
		EXPECT(strcmp(g_log.tag[0], "z") == 0, "fire order [0]=z");
		EXPECT(strcmp(g_log.tag[1], "a") == 0, "fire order [1]=a");
		EXPECT(strcmp(g_log.tag[2], "b") == 0, "fire order [2]=b");
		EXPECT(strcmp(g_log.tag[3], "c") == 0, "fire order [3]=c");
	}

	phaseq_done(&q);
}

static void
test_process_partial(void)
{
	struct phaseq q;
	phaseq_init(&q);

	phaseq_add(&q, 1000, record_cb, NULL, "early");
	phaseq_add(&q, 2000, record_cb, NULL, "mid");
	phaseq_add(&q, 5000, record_cb, NULL, "late");

	log_reset();
	int64_t next = phaseq_process_at(&q, 2500);
	EXPECT(g_log.n == 2, "two early entries fired");
	EXPECT(next == 2500, "next-head reported as 5000-2500=2500");
	EXPECT(phaseq_head_deadline(&q) == 5000, "remaining head is 5000");

	log_reset();
	next = phaseq_process_at(&q, 4999);
	EXPECT(g_log.n == 0, "nothing due yet");
	EXPECT(next == 1, "1ms until head");

	log_reset();
	next = phaseq_process_at(&q, 5000);
	EXPECT(g_log.n == 1, "exact-deadline fires");
	EXPECT(next == -1, "queue drained");

	phaseq_done(&q);
}

static void
test_cancel(void)
{
	struct phaseq q;
	phaseq_init(&q);

	poolid_t a = phaseq_add(&q, 1000, record_cb, NULL, "a");
	poolid_t b = phaseq_add(&q, 2000, record_cb, NULL, "b");
	poolid_t c = phaseq_add(&q, 3000, record_cb, NULL, "c");
	EXPECT(a != 0 && b != 0 && c != 0, "all event_ids nonzero");

	EXPECT(phaseq_cancel(&q, b) == 1, "cancel middle returns 1");
	EXPECT(phaseq_cancel(&q, b) == 0, "second cancel returns 0");
	EXPECT(phaseq_cancel(&q, 0) == 0, "cancel id=0 is no-op");

	log_reset();
	phaseq_process_at(&q, 9999);
	EXPECT(g_log.n == 2, "only a and c fire");
	if (g_log.n == 2) {
		EXPECT(strcmp(g_log.tag[0], "a") == 0, "fired [0]=a");
		EXPECT(strcmp(g_log.tag[1], "c") == 0, "fired [1]=c");
	}

	(void)a; (void)c;
	phaseq_done(&q);
}

static void
test_scrub_arg(void)
{
	struct phaseq q;
	phaseq_init(&q);

	int alice = 0, bob = 0;
	phaseq_add(&q, 1000, record_cb, &alice, "a1");
	phaseq_add(&q, 1500, record_cb, &bob,   "b1");
	phaseq_add(&q, 2000, record_cb, &alice, "a2");
	phaseq_add(&q, 2500, record_cb, &bob,   "b2");
	phaseq_add(&q, 3000, record_cb, &alice, "a3");

	int n = phaseq_scrub_arg(&q, &alice);
	EXPECT(n == 3, "scrub_arg removed 3");
	EXPECT(phaseq_head_deadline(&q) == 1500, "head is bob's first");

	log_reset();
	phaseq_process_at(&q, 9999);
	EXPECT(g_log.n == 2, "only bob's entries fire");
	if (g_log.n == 2) {
		EXPECT(g_log.arg[0] == &bob, "fired arg[0]=bob");
		EXPECT(g_log.arg[1] == &bob, "fired arg[1]=bob");
	}

	phaseq_done(&q);
}

static void
test_independent_instances(void)
{
	struct phaseq q1, q2;
	phaseq_init(&q1);
	phaseq_init(&q2);

	poolid_t e1 = phaseq_add(&q1, 1000, record_cb, (void *)0xA, "q1a");
	poolid_t e2 = phaseq_add(&q2, 500,  record_cb, (void *)0xB, "q2a");
	EXPECT(e1 != 0 && e2 != 0, "ids allocated in both queues");

	/* canceling e1 in q2 must not touch q1 */
	EXPECT(phaseq_cancel(&q2, e1) == 0, "cross-queue cancel is no-op");
	EXPECT(phaseq_head_deadline(&q1) == 1000, "q1 head intact");

	log_reset();
	phaseq_process_at(&q2, 600);
	EXPECT(g_log.n == 1, "only q2 entry fires");
	EXPECT(phaseq_head_deadline(&q1) == 1000, "q1 unaffected by q2 process");

	log_reset();
	phaseq_process_at(&q1, 1000);
	EXPECT(g_log.n == 1, "q1 entry fires");

	phaseq_done(&q1);
	phaseq_done(&q2);
}

static void
test_64bit_deadlines(void)
{
	struct phaseq q;
	phaseq_init(&q);

	/* deadlines well past UINT32_MAX must still order correctly */
	uint64_t base = (uint64_t)1 << 40;       /* ~34 years in ms */
	phaseq_add(&q, base + 3000, record_cb, NULL, "late");
	phaseq_add(&q, base + 1000, record_cb, NULL, "early");
	phaseq_add(&q, base + 2000, record_cb, NULL, "mid");

	EXPECT(phaseq_head_deadline(&q) == base + 1000, "head correct past 2^32");

	log_reset();
	int64_t next = phaseq_process_at(&q, base + 1500);
	EXPECT(g_log.n == 1, "one fired");
	EXPECT(strcmp(g_log.tag[0], "early") == 0, "earliest fired");
	EXPECT(next == 500, "500ms until next");

	phaseq_done(&q);
}

static void
test_null_str(void)
{
	struct phaseq q;
	phaseq_init(&q);

	phaseq_add(&q, 100, record_cb, NULL, NULL);
	log_reset();
	phaseq_process_at(&q, 200);
	EXPECT(g_log.n == 1, "NULL str entry fires");
	EXPECT(g_log.tag[0] == NULL, "NULL str preserved");

	phaseq_done(&q);
}

int
main(void)
{
	test_init_done_empty();
	test_ordered_insertion();
	test_process_partial();
	test_cancel();
	test_scrub_arg();
	test_independent_instances();
	test_64bit_deadlines();
	test_null_str();

	if (failures) {
		fprintf(stderr, "%d test(s) failed\n", failures);
		return 1;
	}
	printf("all tests passed\n");
	return 0;
}
