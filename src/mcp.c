/* mcp.c : MUD Client Protocol 2.1 with the simpleedit package */
/* Made by a machine. PUBLIC DOMAIN (CC0-1.0) */

/*
 * Implements the out-of-band MCP 2.1 protocol (https://www.moo.mud.org/mcp/)
 * on top of the telnet line stream. Lines starting with "#$#" are protocol
 * messages, everything else is normal in-band input.
 *
 * Supported packages:
 *   mcp-negotiate 1.0-2.0           (required by the spec)
 *   dns-org-mud-moo-simpleedit 1.0  (client-side editing of server text)
 *
 * The simpleedit flow: the server offers content with a reference string,
 * the client edits it in a local editor and sends the new content back with
 * the same reference. Only references handed out on the same connection are
 * accepted back.
 */

#include "mcp.h"
#include <ctype.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <telnetclient.h>
#include <grow.h>
#define LOG_SUBSYSTEM "mcp"
#include <log.h>

#define OK (0)
#define ERR (-1)

#define MCP_VERSION 2001 /* 2.1 as major * 1000 + minor */
#define MCP_AUTH_MAX 33
#define MCP_TAG_MAX 33
#define MCP_REF_MAX 160
#define MCP_NR_EDITS 8
#define MCP_KEYVALS_MAX 16
#define MCP_CONTENT_MAX (64u * 1024)

#define SIMPLEEDIT_PKG "dns-org-mud-moo-simpleedit"

struct mcp_pending {
	unsigned active:1;
	unsigned overflow:1;
	char tag[MCP_TAG_MAX];
	char reference[MCP_REF_MAX];
	char *content;
	unsigned content_len;
	unsigned content_max;
};

struct mcp {
	unsigned active:1; /* auth key received and versions matched */
	unsigned can_simpleedit:1;
	char auth[MCP_AUTH_MAX];
	char edit_ref[MCP_NR_EDITS][MCP_REF_MAX]; /* references handed out */
	unsigned edit_next;
	struct mcp_pending pending; /* one in-progress multiline message */
};

struct mcp_kv {
	const char *key;
	const char *val;
	unsigned multiline:1;
};

/****************************************************************
 * Parsing helpers
 ****************************************************************/

/* next_word null-terminates the word at *s and returns it, advancing *s
 * past any following spaces. Returns NULL at end of string.
 */
static char *
next_word(char **s)
{
	char *w = *s;

	while (*w == ' ')
		w++;

	if (!*w)
		return NULL;

	char *e = w;

	while (*e && *e != ' ')
		e++;

	if (*e)
		*e++ = 0;

	*s = e;

	return w;
}

/* word_ok returns true if s is a valid MCP unquoted word (auth keys and
 * data tags). Rejects empty strings and characters the spec reserves.
 */
static int
word_ok(const char *s)
{
	if (!*s)
		return 0;

	for (; *s; s++) {
		if (!isgraph((unsigned char)*s) || *s == '"' || *s == '\\' ||
		    *s == ':' || *s == '*')
			return 0;
	}

	return 1;
}

/* parse_keyvals splits "key: value" pairs in place. Values are either
 * unquoted words or double-quoted strings with backslash escapes. A key
 * ending in '*' is flagged as multiline and its inline value is ignored.
 * Returns the number of pairs or -1 on a syntax error.
 */
static int
parse_keyvals(char *s, struct mcp_kv *kv, int max)
{
	int n = 0;

	for (;;) {
		while (*s == ' ')
			s++;

		if (!*s)
			return n;

		if (n >= max)
			return -1;

		kv[n].key = s;
		kv[n].multiline = 0;

		while (*s && *s != ':' && *s != ' ')
			s++;

		if (*s != ':' || s == kv[n].key)
			return -1;

		if (s[-1] == '*') {
			s[-1] = 0;
			kv[n].multiline = 1;
		}

		*s++ = 0;

		if (*s != ' ')
			return -1;

		s++;

		if (*s == '"') {
			s++;
			char *out = s;
			kv[n].val = out;

			while (*s && *s != '"') {
				if (*s == '\\' && s[1])
					s++;

				*out++ = *s++;
			}

			if (*s != '"')
				return -1;

			s++;
			*out = 0;
		} else {
			kv[n].val = s;

			while (*s && *s != ' ')
				s++;

			if (*s)
				*s++ = 0;
		}

		n++;
	}
}

/* kv_find returns the value for key, or NULL if the key is absent. */
static const struct mcp_kv *
kv_find(const struct mcp_kv *kv, int n, const char *key)
{
	for (int i = 0; i < n; i++) {
		if (!strcmp(kv[i].key, key))
			return &kv[i];
	}

	return NULL;
}

/* version_parse converts "major.minor" into major * 1000 + minor.
 * Returns -1 if the string is not a version number.
 */
static int
version_parse(const char *s)
{
	char *end;
	long maj = strtol(s, &end, 10);

	if (end == s || *end != '.' || maj < 0)
		return -1;

	const char *minstr = end + 1;
	long min = strtol(minstr, &end, 10);

	if (end == minstr || *end || min < 0 || min >= 1000)
		return -1;

	return (int)(maj * 1000 + min);
}

/****************************************************************
 * Output helpers
 ****************************************************************/

/* send_quoted writes s to the client as a double-quoted MCP string,
 * escaping backslashes and double quotes.
 */
static void
send_quoted(DESCRIPTOR_DATA *cl, const char *s)
{
	char buf[256];
	unsigned pos = 0;

	buf[pos++] = '"';

	for (; *s; s++) {
		if (pos >= sizeof(buf) - 4) { /* room for escape + quote + nul */
			buf[pos] = 0;
			telnetclient_puts(cl, buf);
			pos = 0;
		}

		if (*s == '"' || *s == '\\')
			buf[pos++] = '\\';

		buf[pos++] = *s;
	}

	buf[pos++] = '"';
	buf[pos] = 0;
	telnetclient_puts(cl, buf);
}

/* make_tag fills out with an unpredictable data tag from /dev/urandom.
 * Unpredictability keeps in-band text from spoofing multiline data.
 */
static int
make_tag(char *out, size_t outlen)
{
	unsigned char buf[8];
	int fd = open("/dev/urandom", O_RDONLY);

	if (fd < 0)
		return ERR;

	ssize_t n = read(fd, buf, sizeof(buf));
	close(fd);

	if (n != (ssize_t)sizeof(buf))
		return ERR;

	if (outlen < sizeof(buf) * 2 + 1)
		return ERR;

	for (size_t i = 0; i < sizeof(buf); i++)
		snprintf(out + i * 2, 3, "%02x", buf[i]);

	return OK;
}

/****************************************************************
 * Pending multiline message
 ****************************************************************/

/* pending_clear releases the content buffer and deactivates the slot. */
static void
pending_clear(struct mcp_pending *p)
{
	free(p->content);
	memset(p, 0, sizeof(*p));
}

/* pending_append adds one line to the accumulated content, joining lines
 * with '\n'. Oversized content sets the overflow flag and is discarded
 * when the message ends.
 */
static int
pending_append(struct mcp_pending *p, const char *line)
{
	size_t linelen = strlen(line);

	if (p->overflow || p->content_len + linelen + 2 > MCP_CONTENT_MAX) {
		p->overflow = 1;

		return ERR;
	}

	if (grow((void**)&p->content, &p->content_max,
	         p->content_len + linelen + 2, 1))
		return ERR;

	if (p->content_len)
		p->content[p->content_len++] = '\n';

	memcpy(p->content + p->content_len, line, linelen);
	p->content_len += linelen;
	p->content[p->content_len] = 0;

	return OK;
}

/****************************************************************
 * Edit reference bookkeeping
 ****************************************************************/

/* edit_ref_ok returns true if ref was previously handed out to this
 * client by mcp_simpleedit_start.
 */
static int
edit_ref_ok(struct mcp *m, const char *ref)
{
	for (unsigned i = 0; i < MCP_NR_EDITS; i++) {
		if (m->edit_ref[i][0] && !strcmp(m->edit_ref[i], ref))
			return 1;
	}

	return 0;
}

/****************************************************************
 * Message handlers
 ****************************************************************/

/* handle_mcp processes the client's opening "mcp" message, which carries
 * the authentication key and the client's supported version range.
 */
static void
handle_mcp(DESCRIPTOR_DATA *cl, struct mcp *m, char *rest)
{
	struct mcp_kv kv[MCP_KEYVALS_MAX];
	int n = parse_keyvals(rest, kv, MCP_KEYVALS_MAX);

	if (m->active)
		return; /* session is already established */

	if (n < 0) {
		LOG_DEBUG("malformed mcp startup message");

		return;
	}

	const struct mcp_kv *auth = kv_find(kv, n, "authentication-key");
	const struct mcp_kv *from = kv_find(kv, n, "version");
	const struct mcp_kv *to = kv_find(kv, n, "to");

	if (!auth || !from || !to)
		return;

	if (!word_ok(auth->val) || strlen(auth->val) >= MCP_AUTH_MAX) {
		LOG_DEBUG("rejecting bad mcp authentication key");

		return;
	}

	int vmin = version_parse(from->val);
	int vmax = version_parse(to->val);

	if (vmin < 0 || vmax < 0 || vmin > MCP_VERSION || vmax < MCP_VERSION)
		return; /* no version overlap with 2.1 */

	strcpy(m->auth, auth->val);
	m->active = 1;

	char buf[128];
	snprintf(buf, sizeof(buf), "#$#mcp-negotiate-can %s package: "
	         "mcp-negotiate min-version: 1.0 max-version: 2.0\n", m->auth);
	telnetclient_puts(cl, buf);
	snprintf(buf, sizeof(buf), "#$#mcp-negotiate-can %s package: "
	         SIMPLEEDIT_PKG " min-version: 1.0 max-version: 1.0\n", m->auth);
	telnetclient_puts(cl, buf);
	snprintf(buf, sizeof(buf), "#$#mcp-negotiate-end %s\n", m->auth);
	telnetclient_puts(cl, buf);
}

/* handle_negotiate_can records the packages the client announces. */
static void
handle_negotiate_can(struct mcp *m, const struct mcp_kv *kv, int n)
{
	const struct mcp_kv *pkg = kv_find(kv, n, "package");
	const struct mcp_kv *vmin = kv_find(kv, n, "min-version");
	const struct mcp_kv *vmax = kv_find(kv, n, "max-version");

	if (!pkg || !vmin || !vmax)
		return;

	int lo = version_parse(vmin->val);
	int hi = version_parse(vmax->val);

	if (lo < 0 || hi < 0)
		return;

	if (!strcmp(pkg->val, SIMPLEEDIT_PKG) && lo <= 1000 && hi >= 1000)
		m->can_simpleedit = 1;
}

/* handle_simpleedit_set processes the client sending back edited content.
 * Content arrives either inline or as a multiline value collected under
 * a data tag.
 */
static void
handle_simpleedit_set(DESCRIPTOR_DATA *cl, struct mcp *m,
                      const struct mcp_kv *kv, int n)
{
	const struct mcp_kv *ref = kv_find(kv, n, "reference");
	const struct mcp_kv *content = kv_find(kv, n, "content");

	if (!ref || !content)
		return;

	if (strlen(ref->val) >= MCP_REF_MAX || !edit_ref_ok(m, ref->val)) {
		LOG_DEBUG("simpleedit-set for unknown reference ignored [%s]",
		          telnetclient_socket_name(cl));

		return;
	}

	if (!content->multiline) {
		mcp_edit_apply(cl, ref->val, content->val);

		return;
	}

	const struct mcp_kv *tag = kv_find(kv, n, "_data-tag");

	if (!tag || !word_ok(tag->val) || strlen(tag->val) >= MCP_TAG_MAX)
		return;

	if (m->pending.active) {
		LOG_DEBUG("discarding interrupted multiline message");
		pending_clear(&m->pending);
	}

	m->pending.active = 1;
	strcpy(m->pending.tag, tag->val);
	strcpy(m->pending.reference, ref->val);
}

/* input_continue processes a "#$#* <tag> <key>: <line>" continuation. */
static void
input_continue(struct mcp *m, char *rest)
{
	char *tag = next_word(&rest);

	if (!tag || !m->pending.active || strcmp(tag, m->pending.tag))
		return;

	/* key name ends with ':', value is the rest of the line verbatim */
	char *colon = strchr(rest, ':');

	if (!colon)
		return;

	*colon = 0;
	char *value = colon + 1;

	if (*value == ' ')
		value++;

	if (strcmp(rest, "content"))
		return; /* only the content key is multiline here */

	pending_append(&m->pending, value);
}

/* input_end processes a "#$#: <tag>" terminator, dispatching the
 * completed multiline message.
 */
static void
input_end(DESCRIPTOR_DATA *cl, struct mcp *m, char *rest)
{
	char *tag = next_word(&rest);

	if (!tag || !m->pending.active || strcmp(tag, m->pending.tag))
		return;

	if (m->pending.overflow) {
		LOG_INFO("oversized simpleedit content discarded [%s]",
		         telnetclient_socket_name(cl));
		telnetclient_puts(cl, "Edit too large, discarded.\n");
	} else {
		mcp_edit_apply(cl, m->pending.reference,
		               m->pending.content ? m->pending.content : "");
	}

	pending_clear(&m->pending);
}

/* input_message parses and dispatches a normal "#$#<name> ..." message. */
static void
input_message(DESCRIPTOR_DATA *cl, struct mcp *m, char *msg)
{
	char *name = next_word(&msg);

	if (!name)
		return;

	if (!strcmp(name, "mcp")) {
		handle_mcp(cl, m, msg);

		return;
	}

	if (!m->active)
		return;

	char *auth = next_word(&msg);

	if (!auth || strcmp(auth, m->auth)) {
		LOG_DEBUG("mcp message with bad auth key ignored [%s]",
		          telnetclient_socket_name(cl));

		return;
	}

	struct mcp_kv kv[MCP_KEYVALS_MAX];
	int n = parse_keyvals(msg, kv, MCP_KEYVALS_MAX);

	if (n < 0)
		return;

	if (!strcmp(name, "mcp-negotiate-can"))
		handle_negotiate_can(m, kv, n);
	else if (!strcmp(name, SIMPLEEDIT_PKG "-set"))
		handle_simpleedit_set(cl, m, kv, n);

	/* unknown messages are ignored, per the spec */
}

/****************************************************************
 * Public interface
 ****************************************************************/

/* mcp_banner allocates protocol state and sends the MCP startup line.
 * Clients that do not speak MCP display it as one line of text.
 */
void
mcp_banner(DESCRIPTOR_DATA *cl)
{
	if (cl->mcp)
		return;

	cl->mcp = calloc(1, sizeof(*cl->mcp));

	if (!cl->mcp) {
		LOG_ERROR("could not allocate mcp state");

		return;
	}

	telnetclient_puts(cl, "#$#mcp version: 2.1 to: 2.1\n");
}

/* mcp_free releases the client's protocol state. */
void
mcp_free(DESCRIPTOR_DATA *cl)
{
	if (!cl->mcp)
		return;

	pending_clear(&cl->mcp->pending);
	free(cl->mcp);
	cl->mcp = NULL;
}

/* mcp_filter inspects one input line. Returns NULL if the line was
 * consumed as out-of-band MCP data, otherwise the line to process as
 * normal input (unquoting a leading "#$\"" per the spec).
 */
const char *
mcp_filter(DESCRIPTOR_DATA *cl, const char *line)
{
	if (line[0] != '#' || line[1] != '$')
		return line;

	if (line[2] == '"')
		return line + 3;

	if (line[2] != '#')
		return line;

	if (cl->mcp) {
		char *copy = strdup(line + 3);

		if (copy) {
			if (copy[0] == '*')
				input_continue(cl->mcp, copy + 1);
			else if (copy[0] == ':')
				input_end(cl, cl->mcp, copy + 1);
			else
				input_message(cl, cl->mcp, copy);

			free(copy);
		}
	}

	return NULL; /* out-of-band lines never reach command dispatch */
}

/* mcp_simpleedit_ok returns true if the client negotiated the
 * simpleedit package.
 */
int
mcp_simpleedit_ok(DESCRIPTOR_DATA *cl)
{
	return cl->mcp && cl->mcp->active && cl->mcp->can_simpleedit;
}

/* mcp_simpleedit_start offers content to the client for local editing.
 * reference is an opaque string the client echoes back on save; title is
 * shown by the client's editor. Returns OK if the offer was sent.
 */
int
mcp_simpleedit_start(DESCRIPTOR_DATA *cl, const char *reference,
                     const char *title, const char *content)
{
	struct mcp *m = cl->mcp;

	if (!mcp_simpleedit_ok(cl))
		return ERR;

	if (strlen(reference) >= MCP_REF_MAX)
		return ERR;

	char tag[MCP_TAG_MAX];

	if (make_tag(tag, sizeof(tag)) != OK)
		return ERR;

	/* remember the reference so the matching -set is accepted */
	strcpy(m->edit_ref[m->edit_next], reference);
	m->edit_next = (m->edit_next + 1) % MCP_NR_EDITS;

	char buf[256];
	snprintf(buf, sizeof(buf), "#$#" SIMPLEEDIT_PKG "-content %s reference: ",
	         m->auth);
	telnetclient_puts(cl, buf);
	send_quoted(cl, reference);
	telnetclient_puts(cl, " name: ");
	send_quoted(cl, title);
	snprintf(buf, sizeof(buf), " type: text content*: \"\" _data-tag: %s\n",
	         tag);
	telnetclient_puts(cl, buf);

	const char *p = content;

	while (*p) {
		const char *nl = strchr(p, '\n');
		size_t seg = nl ? (size_t)(nl - p) : strlen(p);
		size_t len = seg;

		if (len && p[len - 1] == '\r')
			len--;

		char *line = malloc(len + MCP_TAG_MAX + 16);

		if (!line)
			return ERR;

		int pos = snprintf(line, MCP_TAG_MAX + 16, "#$#* %s content: ", tag);
		memcpy(line + pos, p, len);
		line[pos + len] = '\n';
		line[pos + len + 1] = 0;
		telnetclient_puts(cl, line);
		free(line);

		p += seg + (nl ? 1 : 0);
	}

	snprintf(buf, sizeof(buf), "#$#: %s\n", tag);
	telnetclient_puts(cl, buf);

	return OK;
}
