/* test_machine.c : run a tiny ColdFire program through the machine.
 * The embedded image prints "Hi\n" via HC_PRINT then exits via HC_EXIT.
 */
#define LOG_SUBSYSTEM "test"
#include <log.h>

#include "machine.h"

#include <stdio.h>
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

#define EXPECT_EQ(actual, expected, label) do { \
	if ((actual) != (expected)) \
		FAIL("%s: got %d expected %d", (label), (int)(actual), (int)(expected)); \
	else OK(label); \
} while (0)

/* ------------------------------------------------------------------ */
/* Embedded hello-world image (loads at 0x1000)                       */
/*                                                                    */
/* 0x1000: moveq  #3, %d0            ; len = 3                       */
/* 0x1002: lea    (%pc, 0x0A), %a0   ; a0 -> string at 0x100E        */
/* 0x1006: LINE_A 0xA005             ; HC_PRINT                      */
/* 0x1008: moveq  #0, %d0            ; exit status = 0               */
/* 0x100A: LINE_A 0xA004             ; HC_EXIT                       */
/* 0x100C: bra.s  *                  ; safety loop                   */
/* 0x100E: "Hi\n"                    ; string data                   */
/* ------------------------------------------------------------------ */

#define IMAGE_ADDR 0x1000
#define RAM_SIZE   (64 * 1024)

static const uint8_t hello_image[] = {
	0x70, 0x03,                     /* moveq  #3, %d0            */
	0x41, 0xFA, 0x00, 0x0A,         /* lea    (%pc, 0x0A), %a0   */
	0xA0, 0x05,                     /* HC_PRINT                  */
	0x70, 0x00,                     /* moveq  #0, %d0            */
	0xA0, 0x04,                     /* HC_EXIT                   */
	0x60, 0xFE,                     /* bra.s  *                  */
	'H',  'i',  '\n',              /* "Hi\n"                    */
};

/* ------------------------------------------------------------------ */
/* Print callback -- captures output                                  */
/* ------------------------------------------------------------------ */

#define PRINT_BUF_SIZE 256

static char  print_buf[PRINT_BUF_SIZE];
static size_t print_len;

static void
capture_print(void *ctx, const char *buf, size_t len)
{
	(void)ctx;
	if (print_len + len > PRINT_BUF_SIZE)
		len = PRINT_BUF_SIZE - print_len;
	memcpy(print_buf + print_len, buf, len);
	print_len += len;
}

/* ------------------------------------------------------------------ */
/* Tests                                                              */
/* ------------------------------------------------------------------ */

static void
test_hello(void)
{
	machine_t *m;
	machine_run_result_t rc;

	print_len = 0;
	memset(print_buf, 0, sizeof(print_buf));

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "machine_new");
	if (!m)
		return;

	machine_set_print(m, capture_print, NULL);

	EXPECT_EQ(machine_load_image(m, IMAGE_ADDR,
	           hello_image, sizeof(hello_image)), 0, "load_image");

	EXPECT_EQ(machine_start(m, IMAGE_ADDR, RAM_SIZE), 0, "start");
	EXPECT_EQ(machine_state(m), MACHINE_INIT, "state=INIT");

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "run->EXIT");
	EXPECT_EQ(machine_state(m), MACHINE_DEAD, "state=DEAD");
	EXPECT_EQ(machine_exit_status(m), 0, "exit_status=0");

	EXPECT_EQ((int)print_len, 3, "print_len=3");
	EXPECT(print_len == 3 && memcmp(print_buf, "Hi\n", 3) == 0,
	       "print_buf=Hi\\n");

	machine_free(m);
}

static void
test_yield(void)
{
	/* Image: HC_YIELD, HC_EXIT(0) */
	static const uint8_t yield_image[] = {
		0xA0, 0x02,             /* HC_YIELD */
		0x70, 0x00,             /* moveq  #0, %d0 */
		0xA0, 0x04,             /* HC_EXIT */
		0x60, 0xFE,             /* bra.s  * */
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "yield: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, yield_image, sizeof(yield_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_YIELD, "yield: run->YIELD");

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "yield: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), 0, "yield: exit_status=0");

	machine_free(m);
}

static void
test_sleep(void)
{
	/* Image: moveq #10, %d0; HC_SLEEP */
	static const uint8_t sleep_image[] = {
		0x70, 0x0A,             /* moveq  #10, %d0 */
		0xA0, 0x03,             /* HC_SLEEP */
		0x60, 0xFE,             /* bra.s  * */
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "sleep: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, sleep_image, sizeof(sleep_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_SLEEP, "sleep: run->SLEEP");
	EXPECT_EQ(machine_state(m), MACHINE_SLEEPING, "sleep: state=SLEEPING");

	machine_free(m);
}

static void
test_abort(void)
{
	/* Image: HC_ABORT */
	static const uint8_t abort_image[] = {
		0xA0, 0x00,             /* HC_ABORT */
		0x60, 0xFE,             /* bra.s  * */
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "abort: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, abort_image, sizeof(abort_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "abort: run->EXIT");
	EXPECT_EQ(machine_state(m), MACHINE_DEAD, "abort: state=DEAD");
	EXPECT_EQ(machine_exit_status(m), -1, "abort: exit_status=-1");

	machine_free(m);
}

static void
test_open_close(void)
{
	/*
	 * HC_OPEN("verb:test", 0) -> fd (should be >= 128)
	 * HC_CLOSE(fd) -> kind (should be KIND_VERB = 2)
	 * HC_EXIT(kind) -> exit with status 2
	 */
	static const uint8_t oc_image[] = {
		0x41, 0xFA, 0x00, 0x0E, /* lea    (%pc, 0x0E), %a0  */
		0x70, 0x00,             /* moveq  #0, %d0 (flags)   */
		0x72, 0x00,             /* moveq  #0, %d1 (handler) */
		0xA0, 0x06,             /* HC_OPEN                  */
		0xA0, 0x07,             /* HC_CLOSE(d0)             */
		0xA0, 0x04,             /* HC_EXIT(d0 = kind)       */
		0x60, 0xFE,             /* bra.s  *                 */
		'v','e','r','b',':','t','e','s','t','\0',
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "open_close: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, oc_image, sizeof(oc_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "open_close: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), KIND_VERB,
	          "open_close: exit=KIND_VERB");

	machine_free(m);
}

static void
test_wait_sleep(void)
{
	/*
	 * HC_WAIT(0, NULL, 100) -- pure sleep for 100ms
	 * d0=ncount=0, d1=timeout_ms=100, a0=ignored
	 */
	static const uint8_t ws_image[] = {
		0x70, 0x00,             /* moveq  #0, %d0  (ncount)   */
		0x72, 0x64,             /* moveq  #100, %d1 (timeout) */
		0xA0, 0x08,             /* HC_WAIT                    */
		0xA0, 0x04,             /* HC_EXIT(d0)                */
		0x60, 0xFE,             /* bra.s  *                   */
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "wait_sleep: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, ws_image, sizeof(ws_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_SLEEP, "wait_sleep: run->SLEEP");
	EXPECT_EQ(machine_state(m), MACHINE_SLEEPING,
	          "wait_sleep: state=SLEEPING");
	EXPECT_EQ((int)machine_sleep_ms(m), 100,
	          "wait_sleep: sleep_ms=100");

	machine_wake(m);
	EXPECT_EQ(machine_state(m), MACHINE_INIT,
	          "wait_sleep: wake->INIT");

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "wait_sleep: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), -1,
	          "wait_sleep: exit=-1 (timeout)");

	machine_free(m);
}

static void
test_wait_exit(void)
{
	/*
	 * HC_WAIT(0, NULL, -1) -- no handles, infinite timeout.
	 * Returns immediately with d0=-1 (loop exit).
	 * Then HC_EXIT(d0) exits with -1.
	 */
	static const uint8_t we_image[] = {
		0x70, 0x00,             /* moveq  #0, %d0  (ncount)   */
		0x72, 0xFF,             /* moveq  #-1, %d1 (timeout)  */
		0xA0, 0x08,             /* HC_WAIT                    */
		0xA0, 0x04,             /* HC_EXIT(d0)                */
		0x60, 0xFE,             /* bra.s  *                   */
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "wait_exit: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, we_image, sizeof(we_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "wait_exit: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), -1, "wait_exit: exit=-1");

	machine_free(m);
}

static void
test_wait_ready(void)
{
	/*
	 * HC_OPEN("verb:test") -> fd 128
	 * move.w %d0, (0x2000).l  -- store fd in handles array
	 * HC_WAIT(1, 0x2000, -1)  -- park as READY
	 */
	static const uint8_t wr_image[] = {
		/* 0x1000: lea (%pc, +0x1C), %a0  -> "verb:test" at 0x101E */
		0x41, 0xFA, 0x00, 0x1C,
		/* 0x1004: moveq #0, %d0 (flags) */
		0x70, 0x00,
		/* 0x1006: moveq #0, %d1 (handler_pc) */
		0x72, 0x00,
		/* 0x1008: HC_OPEN -> d0 = fd */
		0xA0, 0x06,
		/* 0x100A: move.w %d0, (0x2000).l */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x00,
		/* 0x1010: moveq #1, %d0 (ncount) */
		0x70, 0x01,
		/* 0x1012: lea (0x2000).l, %a0 (handles array) */
		0x41, 0xF9, 0x00, 0x00, 0x20, 0x00,
		/* 0x1018: moveq #-1, %d1 (timeout) */
		0x72, 0xFF,
		/* 0x101A: HC_WAIT -> parks as READY */
		0xA0, 0x08,
		/* 0x101C: bra.s * (safety) */
		0x60, 0xFE,
		/* 0x101E: "verb:test\0" */
		'v','e','r','b',':','t','e','s','t','\0',
	};
	machine_t *m;
	machine_run_result_t rc;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "wait_ready: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, wr_image, sizeof(wr_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_READY, "wait_ready: run->READY");
	EXPECT_EQ(machine_state(m), MACHINE_READY,
	          "wait_ready: state=READY");

	machine_free(m);
}

static void
test_dispatch(void)
{
	/*
	 * HC_OPEN("verb:test") -> fd
	 * move.w %d0, (0x2000) -- store fd in handles array
	 * HC_WAIT(1, 0x2000, -1) -- park as READY
	 * --- host dispatches, d0 = index ---
	 * lea "ok\n", %a0
	 * moveq #3, %d0
	 * HC_PRINT
	 * moveq #0, %d0
	 * HC_EXIT
	 */
	static const uint8_t di_image[] = {
		/* 0x1000: lea (%pc, 0x28), %a0  -> "verb:test" at 0x102A */
		0x41, 0xFA, 0x00, 0x28,
		/* 0x1004: moveq #0, %d0 (flags) */
		0x70, 0x00,
		/* 0x1006: moveq #0, %d1 (handler_pc) */
		0x72, 0x00,
		/* 0x1008: HC_OPEN */
		0xA0, 0x06,
		/* 0x100A: move.w %d0, (0x2000).l */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x00,
		/* 0x1010: moveq #1, %d0 (ncount) */
		0x70, 0x01,
		/* 0x1012: lea (0x2000).l, %a0 */
		0x41, 0xF9, 0x00, 0x00, 0x20, 0x00,
		/* 0x1018: moveq #-1, %d1 (timeout) */
		0x72, 0xFF,
		/* 0x101A: HC_WAIT -> READY */
		0xA0, 0x08,

		/* After dispatch, d0 = 0 (index) */
		/* 0x101C: lea (%pc, 0x16), %a0  -> "ok\n" at 0x1034 */
		0x41, 0xFA, 0x00, 0x16,
		/* 0x1020: moveq #3, %d0 */
		0x70, 0x03,
		/* 0x1022: HC_PRINT */
		0xA0, 0x05,
		/* 0x1024: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1026: HC_EXIT */
		0xA0, 0x04,
		/* 0x1028: bra.s * */
		0x60, 0xFE,
		/* 0x102A: "verb:test\0" */
		'v','e','r','b',':','t','e','s','t','\0',
		/* 0x1034: "ok\n" */
		'o','k','\n',
	};
	machine_t *m;
	machine_run_result_t rc;

	print_len = 0;
	memset(print_buf, 0, sizeof(print_buf));

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "dispatch: machine_new");
	if (!m)
		return;

	machine_set_print(m, capture_print, NULL);
	machine_load_image(m, IMAGE_ADDR, di_image, sizeof(di_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_READY, "dispatch: run->READY");

	EXPECT_EQ(machine_dispatch(m, 128), 0, "dispatch: signal fd");
	EXPECT_EQ(machine_state(m), MACHINE_BUSY, "dispatch: state=BUSY");

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "dispatch: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), 0, "dispatch: exit=0");

	EXPECT_EQ((int)print_len, 3, "dispatch: print_len=3");
	EXPECT(print_len == 3 && memcmp(print_buf, "ok\n", 3) == 0,
	       "dispatch: buf=ok\\n");

	machine_free(m);
}

static void
test_find_verb(void)
{
	/*
	 * Register two verbs: "go" and "look".
	 * Verify find_verb locates each by name.
	 */
	static const uint8_t fv_image[] = {
		/* 0x1000: lea (%pc, 0x1E), %a0 -> "verb:go" at 0x1020 */
		0x41, 0xFA, 0x00, 0x1E,
		/* 0x1004: moveq #0, %d0 (flags) */
		0x70, 0x00,
		/* 0x1006: moveq #0, %d1 (handler_pc) */
		0x72, 0x00,
		/* 0x1008: HC_OPEN */
		0xA0, 0x06,
		/* 0x100A: lea (%pc, 0x1D), %a0 -> "verb:look" at 0x1029 */
		0x41, 0xFA, 0x00, 0x1D,
		/* 0x100E: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1010: moveq #0, %d1 */
		0x72, 0x00,
		/* 0x1012: HC_OPEN */
		0xA0, 0x06,
		/* 0x1014: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1016: moveq #-1, %d1 */
		0x72, 0xFF,
		/* 0x1018: HC_WAIT(0, -, -1) -> immediate exit */
		0xA0, 0x08,
		/* 0x101A: HC_EXIT(d0) */
		0xA0, 0x04,
		/* 0x101C: bra.s * */
		0x60, 0xFE,
		/* pad to 0x1020 */
		0x00, 0x00,
		/* 0x1020: "verb:go\0" (8 bytes) */
		'v','e','r','b',':','g','o','\0',
		/* 0x1028: pad */
		0x00,
		/* 0x1029: "verb:look\0" (10 bytes) */
		'v','e','r','b',':','l','o','o','k','\0',
	};
	machine_t *m;
	machine_run_result_t rc;
	int fd;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "find_verb: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, fv_image, sizeof(fv_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "find_verb: run->EXIT");

	fd = machine_find_verb(m, "go");
	EXPECT(fd >= 128, "find_verb: go found");

	fd = machine_find_verb(m, "look");
	EXPECT(fd >= 128, "find_verb: look found");

	fd = machine_find_verb(m, "missing");
	EXPECT_EQ(fd, -1, "find_verb: missing=-1");

	machine_free(m);
}

static void
test_context(void)
{
	/*
	 * Register "verb:go", park as READY.
	 * Host writes context, dispatches, handler reads context
	 * and prints the verb string via HC_PRINT.
	 *
	 * Handler code at 0x1040:
	 *   move.l  (0x0804).l, %a0   -- verb string pointer from context
	 *   moveq   #0, %d0
	 *   move.b  (%a0)+, %d0       -- count string length
	 *   ...loop...
	 *   HC_PRINT
	 *   HC_EXIT(0)
	 *
	 * Simplified: handler reads verb ptr from context at 0x0804,
	 * prints 2 bytes ("go"), then exits.
	 */
	static const uint8_t ctx_image[] = {
		/* 0x1000: lea (%pc, 0x2E), %a0 -> "verb:go" at 0x1030 */
		0x41, 0xFA, 0x00, 0x2E,
		/* 0x1004: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1006: move.l #0x1014, %d1 (handler_pc) */
		0x22, 0x3C, 0x00, 0x00, 0x10, 0x14,
		/* 0x100C: HC_OPEN */
		0xA0, 0x06,
		/* 0x100E: move.w %d0, (0x2000).l -- store fd */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x00,

		/* -- dispatch loop preamble at 0x1014 uses same addr for
		 *    both the handler and the wait point. The CRT handles
		 *    this but for the test, handler starts right after wait.
		 *    Actually, let me restructure: HC_WAIT parks, then
		 *    execution resumes after HC_WAIT. The handler is a
		 *    separate block we jump to. --
		 *
		 *    For simplicity: after HC_OPEN, store fd and do HC_WAIT.
		 *    After dispatch resume, jump to handler at 0x1030+N.
		 *    But that's complex. Let me do inline:
		 *
		 *    HC_WAIT parks. Dispatch resumes at instruction after
		 *    HC_WAIT. That code reads context and prints.
		 */

		/* 0x1014: moveq #1, %d0 (ncount) */
		0x70, 0x01,
		/* 0x1016: lea (0x2000).l, %a0 */
		0x41, 0xF9, 0x00, 0x00, 0x20, 0x00,
		/* 0x101C: moveq #-1, %d1 */
		0x72, 0xFF,
		/* 0x101E: HC_WAIT */
		0xA0, 0x08,

		/* -- after dispatch, d0 = 0 (index). read context. -- */
		/* 0x1020: move.l (0x0804).l, %a0  -- verb string ptr */
		0x20, 0x79, 0x00, 0x00, 0x08, 0x04,
		/* 0x1026: moveq #2, %d0 (len of "go") */
		0x70, 0x02,
		/* 0x1028: HC_PRINT */
		0xA0, 0x05,
		/* 0x102A: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x102C: HC_EXIT */
		0xA0, 0x04,
		/* 0x102E: bra.s * */
		0x60, 0xFE,
		/* 0x1030: "verb:go\0" */
		'v','e','r','b',':','g','o','\0',
	};
	machine_t *m;
	machine_run_result_t rc;
	int fd;

	print_len = 0;
	memset(print_buf, 0, sizeof(print_buf));

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "context: machine_new");
	if (!m)
		return;

	machine_set_print(m, capture_print, NULL);
	machine_load_image(m, IMAGE_ADDR, ctx_image, sizeof(ctx_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_READY, "context: run->READY");

	fd = machine_find_verb(m, "go");
	EXPECT(fd >= 128, "context: find go");

	EXPECT_EQ(machine_write_context(m, fd, "go", "test-room",
	          "player1", "n"), 0, "context: write_context");

	EXPECT_EQ(machine_dispatch(m, fd), 0, "context: dispatch");

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "context: run->EXIT");
	EXPECT_EQ(machine_exit_status(m), 0, "context: exit=0");

	EXPECT_EQ((int)print_len, 2, "context: print_len=2");
	EXPECT(print_len == 2 && memcmp(print_buf, "go", 2) == 0,
	       "context: buf=go");

	machine_free(m);
}

static void
test_find_event(void)
{
	/*
	 * Register "event:term", park as READY.
	 * Verify find_event locates it and find_verb does not.
	 */
	static const uint8_t fe_image[] = {
		/* 0x1000: lea (%pc, 0x24), %a0 -> "event:term" at 0x1026 */
		0x41, 0xFA, 0x00, 0x24,
		/* 0x1004: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1006: moveq #0, %d1 (handler_pc) */
		0x72, 0x00,
		/* 0x1008: HC_OPEN */
		0xA0, 0x06,
		/* 0x100A: move.w %d0, (0x2000).l -- store fd */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x00,
		/* 0x1010: moveq #1, %d0 (ncount) */
		0x70, 0x01,
		/* 0x1012: lea (0x2000).l, %a0 */
		0x41, 0xF9, 0x00, 0x00, 0x20, 0x00,
		/* 0x1018: moveq #-1, %d1 (timeout) */
		0x72, 0xFF,
		/* 0x101A: HC_WAIT -> READY */
		0xA0, 0x08,
		/* 0x101C: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x101E: HC_EXIT */
		0xA0, 0x04,
		/* 0x1020: bra.s * */
		0x60, 0xFE,
		/* pad to 0x1022 */
		0x00, 0x00, 0x00, 0x00,
		/* 0x1026: "event:term\0" */
		'e','v','e','n','t',':','t','e','r','m','\0',
	};
	machine_t *m;
	machine_run_result_t rc;
	int fd;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "find_event: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, fe_image, sizeof(fe_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_READY, "find_event: run->READY");

	fd = machine_find_event(m, "term");
	EXPECT(fd >= 128, "find_event: term found");

	fd = machine_find_event(m, "missing");
	EXPECT_EQ(fd, -1, "find_event: missing=-1");

	fd = machine_find_verb(m, "term");
	EXPECT_EQ(fd, -1, "find_event: not a verb");

	machine_free(m);
}

static void
test_termination(void)
{
	/*
	 * Register "verb:go" and "event:term", park as READY.
	 * Host dispatches event:term, handler exits with status 42.
	 * Verifies cooperative termination works.
	 *
	 * 0x1000: open "verb:go"
	 * 0x100A: store go_fd at 0x2000
	 * 0x1010: open "event:term"
	 * 0x101A: store term_fd at 0x2002
	 * 0x1020: HC_WAIT(2, 0x2000, -1) -> READY
	 * -- after dispatch --
	 * 0x102C: moveq #42, %d0
	 * 0x102E: HC_EXIT(42)
	 */
	static const uint8_t term_image[] = {
		/* 0x1000: lea (%pc, 0x30), %a0 -> "verb:go" at 0x1032 */
		0x41, 0xFA, 0x00, 0x30,
		/* 0x1004: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1006: moveq #0, %d1 */
		0x72, 0x00,
		/* 0x1008: HC_OPEN -> d0 = go_fd (128) */
		0xA0, 0x06,
		/* 0x100A: move.w %d0, (0x2000).l */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x00,

		/* 0x1010: lea (%pc, 0x28), %a0 -> "event:term" at 0x103A */
		0x41, 0xFA, 0x00, 0x28,
		/* 0x1014: moveq #0, %d0 */
		0x70, 0x00,
		/* 0x1016: moveq #0, %d1 */
		0x72, 0x00,
		/* 0x1018: HC_OPEN -> d0 = term_fd (129) */
		0xA0, 0x06,
		/* 0x101A: move.w %d0, (0x2002).l */
		0x33, 0xC0, 0x00, 0x00, 0x20, 0x02,

		/* 0x1020: moveq #2, %d0 (ncount) */
		0x70, 0x02,
		/* 0x1022: lea (0x2000).l, %a0 */
		0x41, 0xF9, 0x00, 0x00, 0x20, 0x00,
		/* 0x1028: moveq #-1, %d1 (timeout) */
		0x72, 0xFF,
		/* 0x102A: HC_WAIT -> READY */
		0xA0, 0x08,

		/* after dispatch, d0 = index */
		/* 0x102C: moveq #42, %d0 */
		0x70, 0x2A,
		/* 0x102E: HC_EXIT(42) */
		0xA0, 0x04,
		/* 0x1030: bra.s * */
		0x60, 0xFE,
		/* 0x1032: "verb:go\0" (8 bytes) */
		'v','e','r','b',':','g','o','\0',
		/* 0x103A: "event:term\0" (11 bytes) */
		'e','v','e','n','t',':','t','e','r','m','\0',
	};
	machine_t *m;
	machine_run_result_t rc;
	int efd;

	m = machine_new(RAM_SIZE);
	EXPECT(m != NULL, "term: machine_new");
	if (!m)
		return;

	machine_load_image(m, IMAGE_ADDR, term_image, sizeof(term_image));
	machine_start(m, IMAGE_ADDR, RAM_SIZE);

	rc = machine_run(m, 1000);
	EXPECT_EQ(rc, MACHINE_RUN_READY, "term: run->READY");

	efd = machine_find_event(m, "term");
	EXPECT(efd >= 128, "term: find event:term");

	EXPECT_EQ(machine_dispatch(m, efd), 0, "term: dispatch");
	EXPECT_EQ(machine_state(m), MACHINE_BUSY, "term: state=BUSY");

	rc = machine_run(m, 8192);
	EXPECT_EQ(rc, MACHINE_RUN_EXIT, "term: run->EXIT");
	EXPECT_EQ(machine_state(m), MACHINE_DEAD, "term: state=DEAD");
	EXPECT_EQ(machine_exit_status(m), 42, "term: exit=42");

	machine_free(m);
}

int
main(void)
{
	log_init();

	test_hello();
	test_yield();
	test_sleep();
	test_abort();
	test_open_close();
	test_wait_sleep();
	test_wait_exit();
	test_wait_ready();
	test_dispatch();
	test_find_verb();
	test_context();
	test_find_event();
	test_termination();

	log_done();

	printf("%s\n", failures ? "FAILED" : "PASSED");
	return failures > 0 ? 1 : 0;
}
