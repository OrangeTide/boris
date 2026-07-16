/* test_mcp.c : unit tests for mcp.c */
/* PUBLIC DOMAIN (CC0-1.0) */

/* include the source directly for unit testing */
#include "mcp.c"

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

#include <log.h>

static int pass_count;
static int fail_count;

static inline void
check(const char *description, bool e)
{
	if (e) {
		LOG_INFO("%s: PASSED", description);
		pass_count++;
	} else {
		LOG_ERROR("%s: FAILED", description);
		fail_count++;
	}
}

/****************************************************************
 * Stubs capturing output and applied edits
 ****************************************************************/

static char out_buf[16384];
static char apply_ref[256];
static char apply_content[4096];
static int apply_count;

int
telnetclient_puts(DESCRIPTOR_DATA *cl, const char *s)
{
	(void)cl;
	size_t len = strlen(out_buf);
	snprintf(out_buf + len, sizeof(out_buf) - len, "%s", s);

	return 0;
}

const char *
telnetclient_socket_name(DESCRIPTOR_DATA *cl)
{
	(void)cl;

	return "test";
}

void
mcp_edit_apply(DESCRIPTOR_DATA *cl, const char *reference, const char *content)
{
	(void)cl;
	snprintf(apply_ref, sizeof(apply_ref), "%s", reference);
	snprintf(apply_content, sizeof(apply_content), "%s", content);
	apply_count++;
}

static void
reset_capture(void)
{
	out_buf[0] = 0;
	apply_ref[0] = 0;
	apply_content[0] = 0;
	apply_count = 0;
}

/****************************************************************
 * Helpers
 ****************************************************************/

/* client_new returns a descriptor with MCP state and captures cleared. */
static DESCRIPTOR_DATA *
client_new(void)
{
	DESCRIPTOR_DATA *cl = calloc(1, sizeof(*cl));

	reset_capture();
	mcp_banner(cl);

	return cl;
}

static void
client_free(DESCRIPTOR_DATA *cl)
{
	mcp_free(cl);
	free(cl);
}

/* handshake performs the client side of MCP session establishment. */
static void
handshake(DESCRIPTOR_DATA *cl, const char *key)
{
	char line[256];

	snprintf(line, sizeof(line),
	         "#$#mcp authentication-key: %s version: 1.0 to: 2.1", key);
	mcp_filter(cl, line);
	snprintf(line, sizeof(line),
	         "#$#mcp-negotiate-can %s package: " SIMPLEEDIT_PKG
	         " min-version: 1.0 max-version: 1.0", key);
	mcp_filter(cl, line);
	snprintf(line, sizeof(line), "#$#mcp-negotiate-end %s", key);
	mcp_filter(cl, line);
}

/****************************************************************
 * Tests
 ****************************************************************/

static void
test_version_parse(void)
{
	check("version 2.1", version_parse("2.1") == 2001);
	check("version 10.42", version_parse("10.42") == 10042);
	check("version 1.0", version_parse("1.0") == 1000);
	check("version junk", version_parse("junk") == -1);
	check("version missing minor", version_parse("2.") == -1);
	check("version bare int", version_parse("2") == -1);
}

static void
test_parse_keyvals(void)
{
	char line[] = "alpha: one beta*: \"\" gamma: \"two \\\"three\\\" \\\\four\"";
	struct mcp_kv kv[MCP_KEYVALS_MAX];
	int n = parse_keyvals(line, kv, MCP_KEYVALS_MAX);

	check("keyval count", n == 3);
	check("keyval word", n == 3 && !strcmp(kv[0].key, "alpha") &&
	      !strcmp(kv[0].val, "one") && !kv[0].multiline);
	check("keyval multiline flag", n == 3 && !strcmp(kv[1].key, "beta") &&
	      kv[1].multiline);
	check("keyval quoted escapes", n == 3 &&
	      !strcmp(kv[2].val, "two \"three\" \\four"));

	char bad[] = "noseparator";
	check("keyval syntax error", parse_keyvals(bad, kv, MCP_KEYVALS_MAX) == -1);
}

static void
test_banner_and_filter(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	check("banner allocates state", cl->mcp != NULL);
	check("banner output", strstr(out_buf, "#$#mcp version: 2.1 to: 2.1") != NULL);

	const char *line = "look around";
	check("in-band passthrough", mcp_filter(cl, line) == line);

	const char *quoted = "#$\"#$#not a message";
	check("unquote #$\" prefix", mcp_filter(cl, quoted) == quoted + 3);

	check("out-of-band consumed", mcp_filter(cl, "#$#garbage here") == NULL);

	client_free(cl);
}

static void
test_handshake(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	mcp_filter(cl, "#$#mcp authentication-key: K12 version: 1.0 to: 2.1");
	check("session active", cl->mcp->active);
	check("auth key stored", !strcmp(cl->mcp->auth, "K12"));
	check("announces simpleedit",
	      strstr(out_buf, "#$#mcp-negotiate-can K12 package: "
	             SIMPLEEDIT_PKG) != NULL);
	check("negotiation ends",
	      strstr(out_buf, "#$#mcp-negotiate-end K12") != NULL);
	check("simpleedit not yet negotiated", !mcp_simpleedit_ok(cl));

	mcp_filter(cl, "#$#mcp-negotiate-can K12 package: " SIMPLEEDIT_PKG
	           " min-version: 1.0 max-version: 1.0");
	check("simpleedit negotiated", mcp_simpleedit_ok(cl));

	client_free(cl);
}

static void
test_version_mismatch(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	mcp_filter(cl, "#$#mcp authentication-key: K12 version: 1.0 to: 2.0");
	check("no overlap rejected", !cl->mcp->active);

	client_free(cl);
}

static void
test_simpleedit_send(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	handshake(cl, "K12");
	reset_capture();
	int rc = mcp_simpleedit_start(cl, "room:foo:description", "foo.description",
	                              "line one\nline two\n");
	check("simpleedit send ok", rc == OK);
	check("send has reference",
	      strstr(out_buf, "reference: \"room:foo:description\"") != NULL);
	check("send has title", strstr(out_buf, "name: \"foo.description\"") != NULL);
	check("send line one", strstr(out_buf, "content: line one\n") != NULL);
	check("send line two", strstr(out_buf, "content: line two\n") != NULL);
	check("reference recorded", edit_ref_ok(cl->mcp, "room:foo:description"));

	client_free(cl);
}

static void
test_simpleedit_set_multiline(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	handshake(cl, "K12");
	mcp_simpleedit_start(cl, "room:foo:description", "foo.description", "old");
	reset_capture();

	mcp_filter(cl, "#$#" SIMPLEEDIT_PKG "-set K12 "
	           "reference: \"room:foo:description\" type: text "
	           "content*: \"\" _data-tag: T99");
	mcp_filter(cl, "#$#* T99 content: hello");
	mcp_filter(cl, "#$#* T99 content: world");
	check("no apply before end", apply_count == 0);
	mcp_filter(cl, "#$#: T99");

	check("edit applied once", apply_count == 1);
	check("applied reference", !strcmp(apply_ref, "room:foo:description"));
	check("applied content", !strcmp(apply_content, "hello\nworld"));

	client_free(cl);
}

static void
test_simpleedit_set_inline(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	handshake(cl, "K12");
	mcp_simpleedit_start(cl, "room:foo:name", "foo.name", "old");
	reset_capture();

	mcp_filter(cl, "#$#" SIMPLEEDIT_PKG "-set K12 "
	           "reference: \"room:foo:name\" type: string content: \"Town Square\"");

	check("inline edit applied", apply_count == 1);
	check("inline content", !strcmp(apply_content, "Town Square"));

	client_free(cl);
}

static void
test_simpleedit_set_rejected(void)
{
	DESCRIPTOR_DATA *cl = client_new();

	handshake(cl, "K12");
	mcp_simpleedit_start(cl, "room:foo:name", "foo.name", "old");
	reset_capture();

	/* reference that was never handed out */
	mcp_filter(cl, "#$#" SIMPLEEDIT_PKG "-set K12 "
	           "reference: \"room:bar:name\" type: string content: \"x\"");
	check("unknown reference rejected", apply_count == 0);

	/* wrong auth key */
	mcp_filter(cl, "#$#" SIMPLEEDIT_PKG "-set WRONG "
	           "reference: \"room:foo:name\" type: string content: \"x\"");
	check("bad auth key rejected", apply_count == 0);

	/* continuation for a tag that was never opened */
	mcp_filter(cl, "#$#* T00 content: sneak");
	mcp_filter(cl, "#$#: T00");
	check("stray continuation rejected", apply_count == 0);

	client_free(cl);
}

static void
test_no_state(void)
{
	DESCRIPTOR_DATA *cl = calloc(1, sizeof(*cl));

	reset_capture();
	check("oob dropped without state", mcp_filter(cl, "#$#mcp x: y") == NULL);
	check("simpleedit off without state", !mcp_simpleedit_ok(cl));
	check("send fails without state",
	      mcp_simpleedit_start(cl, "r", "t", "c") == ERR);

	mcp_free(cl); /* no-op on NULL state */
	free(cl);
}

int
main(void)
{
	LOG_INFO("%%%%%%%%%%%% START-TEST : mcp.c");

	test_version_parse();
	test_parse_keyvals();
	test_banner_and_filter();
	test_handshake();
	test_version_mismatch();
	test_simpleedit_send();
	test_simpleedit_set_multiline();
	test_simpleedit_set_inline();
	test_simpleedit_set_rejected();
	test_no_state();

	LOG_INFO("%%%%%%%%%%%% END-TEST : %d passed, %d failed",
		pass_count, fail_count);

	return fail_count ? EXIT_FAILURE : EXIT_SUCCESS;
}
