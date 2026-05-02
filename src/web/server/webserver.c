/* webserver.c : SSE-based web server on net_stream layer */
/* PUBLIC DOMAIN (CC0-1.0) */

#include "mud.h"
#include "mudconfig.h"
#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <webserver.h>
#include <webclient.h>
#include <telnetclient.h>
#include <room.h>
#include <obj.h>
#include <net.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <ctype.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#define OK  (0)
#define ERR (-1)

static struct net_stream *web_listener;
static const char *web_root = "./bin/www";

/****************************************************************
 * URL decoding and query string parsing
 ****************************************************************/

static int
hex_digit(int c)
{
    if (c >= '0' && c <= '9') return c - '0';
    if (c >= 'a' && c <= 'f') return c - 'a' + 10;
    if (c >= 'A' && c <= 'F') return c - 'A' + 10;
    return -1;
}

static void
url_decode(char *dst, const char *src, int dsz)
{
    int i = 0;
    while (*src && i < dsz - 1) {
        if (*src == '%' && src[1] && src[2]) {
            int hi = hex_digit(src[1]);
            int lo = hex_digit(src[2]);
            if (hi >= 0 && lo >= 0) {
                dst[i++] = (char)(hi * 16 + lo);
                src += 3;
                continue;
            }
        }
        if (*src == '+')
            dst[i++] = ' ';
        else
            dst[i++] = *src;
        src++;
    }
    dst[i] = '\0';
}

static const char *
qs_get(const char *qs, const char *key, char *val, int vsz)
{
    if (!qs)
        return NULL;
    int klen = (int)strlen(key);
    const char *p = qs;
    while (*p) {
        if (strncmp(p, key, klen) == 0 && p[klen] == '=') {
            const char *v = p + klen + 1;
            const char *end = strchr(v, '&');
            int vlen = end ? (int)(end - v) : (int)strlen(v);
            if (vlen >= vsz) vlen = vsz - 1;
            char encoded[256];
            if (vlen >= (int)sizeof(encoded))
                vlen = (int)sizeof(encoded) - 1;
            memcpy(encoded, v, vlen);
            encoded[vlen] = '\0';
            url_decode(val, encoded, vsz);
            return val;
        }
        const char *amp = strchr(p, '&');
        if (!amp) break;
        p = amp + 1;
    }
    val[0] = '\0';
    return NULL;
}

/****************************************************************
 * SSE frame output
 ****************************************************************/

int
sse_write(struct web_client *wc, int cmd, const char *msg)
{
	if (!wc || !wc->stream || wc->state != WC_SSE)
		return ERR;

	const char *p = msg;
	const char *nl;
	int first = 1;
	do {
		nl = strchr(p, '\n');
		if (nl) {
			if (first) {
				net_writef(wc->stream, "data: %c%.*s\n",
				           cmd, (int)(nl - p), p);
				first = 0;
			} else {
				net_writef(wc->stream, "data: %.*s\n",
				           (int)(nl - p), p);
			}
			p = nl + 1;
		} else {
			if (first)
				net_writef(wc->stream, "data: %c%s\n\n",
				           cmd, p);
			else
				net_writef(wc->stream, "data: %s\n\n", p);
		}
	} while (nl);
	return OK;
}

/****************************************************************
 * client_ops callbacks for game integration
 ****************************************************************/

void
webclient_flush(struct web_client *wc)
{
	if (!wc || wc->outlen <= 0)
		return;
	wc->outbuf[wc->outlen] = '\0';
	int cmd = wc->outbuf[wc->outlen - 1] == '\n' ? 'm' : 'p';
	sse_write(wc, cmd, wc->outbuf);
	wc->outlen = 0;
}

static int
web_ops_puts(DESCRIPTOR_DATA *cl, const char *data, size_t len)
{
	struct web_client *wc = cl->client_ctx;
	if (!wc)
		return ERR;

	const char *p = data;
	size_t remain = len;

	while (remain > 0) {
		int avail = WC_OUTBUF_SIZE - wc->outlen - 1;
		if (avail <= 0) {
			webclient_flush(wc);
			avail = WC_OUTBUF_SIZE - 1;
		}

		size_t copy = remain < (size_t)avail ? remain : (size_t)avail;
		memcpy(wc->outbuf + wc->outlen, p, copy);
		wc->outlen += (int)copy;
		p += copy;
		remain -= copy;
	}

	if (!cl->buffered && wc->outlen > 0) {
		const char *last_nl = NULL;
		for (int i = wc->outlen - 1; i >= 0; i--) {
			if (wc->outbuf[i] == '\n') {
				last_nl = wc->outbuf + i;
				break;
			}
		}
		if (last_nl) {
			int flush_len = (int)(last_nl - wc->outbuf) + 1;
			char saved = wc->outbuf[flush_len];
			wc->outbuf[flush_len] = '\0';
			sse_write(wc, 'm', wc->outbuf);
			wc->outbuf[flush_len] = saved;

			int tail = wc->outlen - flush_len;
			if (tail > 0)
				memmove(wc->outbuf, wc->outbuf + flush_len, tail);
			wc->outlen = tail;
		}
	}

	return OK;
}

static void
web_ops_flush(DESCRIPTOR_DATA *cl)
{
	struct web_client *wc = cl->client_ctx;
	if (wc)
		webclient_flush(wc);
}

static void
web_ops_close(DESCRIPTOR_DATA *cl)
{
	struct web_client *wc = cl->client_ctx;
	if (!wc)
		return;
	wc->state = WC_CLOSING;
	if (wc->stream)
		net_close(wc->stream);
}

const struct client_ops web_client_ops = {
	.puts = web_ops_puts,
	.flush = web_ops_flush,
	.close = web_ops_close,
};

/****************************************************************
 * MIME type lookup
 ****************************************************************/

static const char *
mime_type(const char *path)
{
	const char *dot = strrchr(path, '.');
	if (!dot)
		return "application/octet-stream";
	if (strcasecmp(dot, ".html") == 0 || strcasecmp(dot, ".htm") == 0)
		return "text/html; charset=utf-8";
	if (strcasecmp(dot, ".css") == 0)
		return "text/css; charset=utf-8";
	if (strcasecmp(dot, ".js") == 0)
		return "text/javascript; charset=utf-8";
	if (strcasecmp(dot, ".json") == 0)
		return "application/json";
	if (strcasecmp(dot, ".png") == 0)
		return "image/png";
	if (strcasecmp(dot, ".jpg") == 0 || strcasecmp(dot, ".jpeg") == 0)
		return "image/jpeg";
	if (strcasecmp(dot, ".gif") == 0)
		return "image/gif";
	if (strcasecmp(dot, ".svg") == 0)
		return "image/svg+xml";
	if (strcasecmp(dot, ".ico") == 0)
		return "image/x-icon";
	if (strcasecmp(dot, ".ttf") == 0)
		return "font/ttf";
	if (strcasecmp(dot, ".woff") == 0)
		return "font/woff";
	if (strcasecmp(dot, ".woff2") == 0)
		return "font/woff2";
	return "application/octet-stream";
}

/****************************************************************
 * Static file serving
 ****************************************************************/

static int
serve_file(struct net_stream *stream, const char *url_path)
{
	char path[512];
	const char *serve = url_path;
	if (strcmp(serve, "/") == 0)
		serve = "/index.html";

	/* reject path traversal */
	if (strstr(serve, ".."))
		goto not_found;

	snprintf(path, sizeof(path), "%s%s", web_root, serve);

	struct stat st;
	if (stat(path, &st) < 0 || !S_ISREG(st.st_mode))
		goto not_found;

	int fd = open(path, O_RDONLY);
	if (fd < 0)
		goto not_found;

	net_writef(stream,
	           "HTTP/1.1 200 OK\r\n"
	           "Content-Type: %s\r\n"
	           "Content-Length: %ld\r\n"
	           "Connection: close\r\n"
	           "\r\n",
	           mime_type(path), (long)st.st_size);

	char buf[4096];
	ssize_t n;
	while ((n = read(fd, buf, sizeof(buf))) > 0)
		net_write(stream, buf, (int)n);
	close(fd);
	net_close_when_done(stream);
	return OK;

not_found:
	net_writef(stream,
	           "HTTP/1.1 404 Not Found\r\n"
	           "Content-Length: 14\r\n"
	           "Connection: close\r\n"
	           "\r\n"
	           "404 Not Found\n");
	net_close_when_done(stream);
	return ERR;
}

/****************************************************************
 * HTTP request parsing
 ****************************************************************/

static int
find_header_end(const char *buf, int len)
{
	for (int i = 0; i + 3 < len; i++) {
		if (buf[i] == '\r' && buf[i + 1] == '\n' &&
		    buf[i + 2] == '\r' && buf[i + 3] == '\n')
			return i + 4;
	}
	return -1;
}

static int
parse_method(const char *buf, char *method, int msz,
             char *path, int psz, int *content_length)
{
	const char *sp1 = strchr(buf, ' ');
	if (!sp1)
		return ERR;
	int mlen = (int)(sp1 - buf);
	if (mlen >= msz)
		mlen = msz - 1;
	memcpy(method, buf, mlen);
	method[mlen] = '\0';

	sp1++;
	const char *sp2 = strchr(sp1, ' ');
	if (!sp2)
		return ERR;
	int plen = (int)(sp2 - sp1);
	if (plen >= psz)
		plen = psz - 1;
	memcpy(path, sp1, plen);
	path[plen] = '\0';

	*content_length = 0;
	const char *cl = strcasestr(buf, "\r\nContent-Length:");
	if (cl) {
		cl += 17;
		while (*cl == ' ')
			cl++;
		*content_length = atoi(cl);
	}
	return OK;
}

/****************************************************************
 * Request handlers
 ****************************************************************/

static void
handle_events(struct web_client *wc)
{
	wc->state = WC_SSE;
	net_writef(wc->stream,
	           "HTTP/1.1 200 OK\r\n"
	           "Content-Type: text/event-stream\r\n"
	           "Cache-Control: no-cache\r\n"
	           "Connection: keep-alive\r\n"
	           "\r\n");
	sse_write(wc, 'I', wc->session);

	wc->cl = telnetclient_webclient_new(wc, &web_client_ops);
	if (!wc->cl) {
		LOG_ERROR("could not create web client descriptor");
		wc->state = WC_CLOSING;
		net_close(wc->stream);
	}
}

static void
handle_cmd(struct web_client *wc, const char *body, int body_len)
{
	char line[1024];
	int len = body_len;
	if (len >= (int)sizeof(line))
		len = (int)sizeof(line) - 1;
	memcpy(line, body, len);
	line[len] = '\0';

	/* strip trailing newline */
	while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r'))
		line[--len] = '\0';

	/* format: "SESSION command" */
	char *sp = strchr(line, ' ');
	if (!sp) {
		net_writef(wc->stream,
		           "HTTP/1.1 400 Bad Request\r\n"
		           "Content-Length: 12\r\n"
		           "Connection: close\r\n"
		           "\r\n"
		           "Bad Request\n");
		net_close_when_done(wc->stream);
		return;
	}
	*sp = '\0';
	const char *token = line;
	const char *cmd = sp + 1;

	struct web_client *target = webclient_find_session(token);
	if (!target || !target->cl || target->state != WC_SSE) {
		net_writef(wc->stream,
		           "HTTP/1.1 403 Forbidden\r\n"
		           "Content-Length: 10\r\n"
		           "Connection: close\r\n"
		           "\r\n"
		           "Forbidden\n");
		net_close_when_done(wc->stream);
		return;
	}

	if (target->cl->line_input) {
		telnetclient_set_buffered(target->cl);
		telnetclient_printf(target->cl, "%s\n", cmd);
		target->cl->line_input(target->cl, cmd);
		telnetclient_clear_buffered(target->cl);
	}

	net_writef(wc->stream,
	           "HTTP/1.1 200 OK\r\n"
	           "Content-Length: 3\r\n"
	           "Connection: close\r\n"
	           "\r\n"
	           "OK\n");
	net_close_when_done(wc->stream);
}

/****************************************************************
 * Property read/write handlers (for editor)
 ****************************************************************/

static void
http_respond_text(struct net_stream *stream, int code,
                  const char *status, const char *body)
{
    int len = (int)strlen(body);
    net_writef(stream,
               "HTTP/1.1 %d %s\r\n"
               "Content-Type: text/plain; charset=utf-8\r\n"
               "Content-Length: %d\r\n"
               "Connection: close\r\n"
               "\r\n"
               "%s",
               code, status, len, body);
    net_close_when_done(stream);
}

static void
handle_prop_get(struct web_client *wc, const char *qs)
{
    char obj_id[64], prop_name[64], session[WC_SESSION_LEN + 1];

    if (!qs_get(qs, "obj", obj_id, sizeof(obj_id)) ||
        !qs_get(qs, "prop", prop_name, sizeof(prop_name)) ||
        !qs_get(qs, "sid", session, sizeof(session))) {
        http_respond_text(wc->stream, 400, "Bad Request",
                          "missing obj, prop, or sid\n");
        return;
    }

    struct web_client *target = webclient_find_session(session);
    if (!target || !target->cl || target->state != WC_SSE) {
        http_respond_text(wc->stream, 403, "Forbidden",
                          "invalid session\n");
        return;
    }

    OBJ *r = room_get(obj_id);
    if (!r) {
        http_respond_text(wc->stream, 404, "Not Found",
                          "object not found\n");
        return;
    }

    const char *value = obj_prop_get(r, prop_name);
    if (!value)
        value = "";

    http_respond_text(wc->stream, 200, "OK", value);
    room_put(r);
}

static void
handle_prop_post(struct web_client *wc, const char *qs,
                 const char *body, int body_len)
{
    char obj_id[64], prop_name[64], session[WC_SESSION_LEN + 1];

    if (!qs_get(qs, "obj", obj_id, sizeof(obj_id)) ||
        !qs_get(qs, "prop", prop_name, sizeof(prop_name)) ||
        !qs_get(qs, "sid", session, sizeof(session))) {
        http_respond_text(wc->stream, 400, "Bad Request",
                          "missing obj, prop, or sid\n");
        return;
    }

    struct web_client *target = webclient_find_session(session);
    if (!target || !target->cl || target->state != WC_SSE) {
        http_respond_text(wc->stream, 403, "Forbidden",
                          "invalid session\n");
        return;
    }

    OBJ *r = room_get(obj_id);
    if (!r) {
        http_respond_text(wc->stream, 404, "Not Found",
                          "object not found\n");
        return;
    }

    char *value = malloc(body_len + 1);
    if (!value) {
        room_put(r);
        http_respond_text(wc->stream, 500, "Internal Server Error",
                          "out of memory\n");
        return;
    }
    memcpy(value, body, body_len);
    value[body_len] = '\0';

    int rc = obj_prop_set(r, prop_name, value);
    free(value);
    room_put(r);

    if (rc == OBJ_ERR_PROTECTED) {
        http_respond_text(wc->stream, 403, "Forbidden",
                          "protected property\n");
        return;
    }
    if (rc != OBJ_OK) {
        http_respond_text(wc->stream, 500, "Internal Server Error",
                          "failed to set property\n");
        return;
    }

    http_respond_text(wc->stream, 200, "OK", "OK\n");

    if (target->cl)
        telnetclient_printf(target->cl, "Property %s.%s updated.\n",
                            obj_id, prop_name);
}

/****************************************************************
 * HTTP request dispatch
 ****************************************************************/

static void
process_request(struct web_client *wc, int hdr_end)
{
	char method[16], path[256];
	int content_length = 0;

	if (parse_method(wc->reqbuf, method, sizeof(method),
	                 path, sizeof(path), &content_length) < 0) {
		net_writef(wc->stream,
		           "HTTP/1.1 400 Bad Request\r\n"
		           "Content-Length: 12\r\n"
		           "Connection: close\r\n"
		           "\r\n"
		           "Bad Request\n");
		net_close_when_done(wc->stream);
		return;
	}

	/* split path from query string */
	char *qs = strchr(path, '?');
	if (qs)
		*qs++ = '\0';

	if (strcmp(method, "GET") == 0) {
		if (strcmp(path, "/events") == 0) {
			handle_events(wc);
		} else if (strcmp(path, "/edit") == 0 ||
		           strcmp(path, "/view") == 0) {
			serve_file(wc->stream, "/editor.html");
		} else if (strcmp(path, "/prop") == 0) {
			handle_prop_get(wc, qs);
		} else {
			serve_file(wc->stream, path);
		}
		return;
	}

	if (strcmp(method, "POST") == 0) {
		int total = hdr_end + content_length;
		if (wc->reqlen < total)
			return; /* need more body data */
		if (strcmp(path, "/cmd") == 0) {
			handle_cmd(wc, wc->reqbuf + hdr_end, content_length);
			return;
		}
		if (strcmp(path, "/prop") == 0) {
			handle_prop_post(wc, qs,
			                 wc->reqbuf + hdr_end, content_length);
			return;
		}
	}

	net_writef(wc->stream,
	           "HTTP/1.1 405 Method Not Allowed\r\n"
	           "Content-Length: 19\r\n"
	           "Connection: close\r\n"
	           "\r\n"
	           "Method Not Allowed\n");
	net_close_when_done(wc->stream);
}

/****************************************************************
 * net_stream event callbacks
 ****************************************************************/

static void
on_web_data(net_event *e)
{
	struct web_client *wc = e->udata;
	if (!wc || wc->state != WC_HTTP)
		return;

	int avail = WC_REQBUF_SIZE - wc->reqlen - 1;
	int copy = e->size < avail ? e->size : avail;
	if (copy > 0) {
		memcpy(wc->reqbuf + wc->reqlen, e->data, copy);
		wc->reqlen += copy;
		wc->reqbuf[wc->reqlen] = '\0';
	}

	int hdr_end = find_header_end(wc->reqbuf, wc->reqlen);
	if (hdr_end < 0) {
		if (wc->reqlen >= WC_REQBUF_SIZE - 1) {
			net_writef(wc->stream,
			           "HTTP/1.1 431 Request Header Fields Too Large\r\n"
			           "Content-Length: 16\r\n"
			           "Connection: close\r\n"
			           "\r\n"
			           "Headers too big\n");
			net_close_when_done(wc->stream);
		}
		return;
	}

	process_request(wc, hdr_end);
}

static void
on_web_close(net_event *e)
{
	struct web_client *wc = e->udata;
	if (!wc)
		return;

	if (wc->cl) {
		telnetclient_webclient_destroy(wc->cl);
		wc->cl = NULL;
	}
	wc->stream = NULL;
	webclient_destroy(wc);
}

static void
on_web_accept(net_event *e)
{
	struct net_stream *client = e->remote;

	struct web_client *wc = webclient_new(client);
	if (!wc) {
		LOG_ERROR("could not allocate web client");
		net_close(client);
		return;
	}

	net_add_listener(client, NET_EVENT_DATA, on_web_data, wc);
	net_add_listener(client, NET_EVENT_CLOSE, on_web_close, wc);
}

/****************************************************************
 * Public API
 ****************************************************************/

int
webserver_init(unsigned port)
{
	web_listener = net_new_stream();
	if (!web_listener) {
		LOG_ERROR("could not allocate listener stream");
		return ERR;
	}

	if (net_listen(web_listener, (int)port) < 0) {
		LOG_ERROR("could not listen on port %u", port);
		return ERR;
	}

	net_add_listener(web_listener, NET_EVENT_ACCEPT, on_web_accept, NULL);

	LOG_INFO("SSE web server listening on http://localhost:%u", port);
	return OK;
}

void
webserver_shutdown(void)
{
	if (web_listener) {
		net_close(web_listener);
		web_listener = NULL;
	}

	struct web_client *wc = webclient_first();
	while (wc) {
		struct web_client *next = wc->next;
		if (wc->cl) {
			telnetclient_webclient_destroy(wc->cl);
			wc->cl = NULL;
		}
		if (wc->stream) {
			net_close(wc->stream);
			wc->stream = NULL;
		}
		webclient_destroy(wc);
		wc = next;
	}

	LOG_INFO("web server shut down");
}
