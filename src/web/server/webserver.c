#include "mud.h"
#include "mudconfig.h"
#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <mongoose.h>
#include <dyad.h>
#include <webserver.h>
#include <pthread.h>
#include <signal.h>

#define OK  (0)
#define ERR (-1)

static struct webserver_context web_context;
static struct mg_connection *upstream;
static sig_atomic_t interrupted = 0;
static pthread_t webserver_thread;

static const char *web_root = "./bin/www";
static struct mg_mgr webserver_mgr;

void
webserver_test_callback(dyad_Event *ev)
{
	char buf[48] = { 0 };

	snprintf(buf, 47, "Webserver Event: %s", ev->data);
	log_logf(LOG_LEVEL_INFO, "server", "%s", buf);
}

void
webserver_accept_callback(dyad_Event *ev)
{
	dyad_addListener(ev->remote, DYAD_EVENT_DATA, webserver_test_callback, NULL);
}

static void
webserver_handler(struct mg_connection *c, int ev, void *ev_data, void *fn_data)
{

	if (ev == MG_EV_WS_OPEN) {
		mg_send(upstream, "@NEWCLIENT@", 12);
		LOG_INFO("websocket client connected");
		mg_ws_send(c, mud_config.msgfile_welcome, strlen(mud_config.msgfile_welcome)+1, WEBSOCKET_OP_TEXT);
	} else if (ev == MG_EV_HTTP_MSG) {
		struct mg_http_message *hm = (struct mg_http_message *)ev_data;
		if (mg_http_match_uri(hm, "/ws")) {
			// Upgrade to websocket. From now on, a connection is a full-duplex
			// Websocket connection, which will receive MG_EV_WS_MSG events.
			mg_ws_upgrade(c, hm, NULL);
		} else if (mg_http_match_uri(hm, "/api")) {
			// Serve REST response
			mg_http_reply(c, 200, "", "{\"result\": \"%s\"}\n", "boris");
		} else {
			// Serve static files
			struct mg_http_serve_opts opts = { .root_dir = web_root };
			mg_http_serve_dir(c, ev_data, &opts);
		}
	} else if (ev == MG_EV_WS_MSG) {
		// Got websocket frame. Received data is wm->data. Echo it back!
		struct mg_ws_message *wm = (struct mg_ws_message *)ev_data;
		mg_ws_send(c, wm->data.ptr, wm->data.len, WEBSOCKET_OP_TEXT);
		mg_send(upstream, "@MESSAGE@", 10);
	}
	(void)fn_data;
}

static void
webserver_upstream_handler(struct mg_connection *c, int ev, void *ev_data, void *fn_data)
{
	if (ev == MG_EV_CONNECT) {
		LOG_INFO("Connected to main thread");
	} else if (ev == MG_EV_CLOSE) {
		LOG_INFO("Disconnected from main thread");
	} else if (ev == MG_EV_POLL) {
		// Nothing yet
	}
	(void)fn_data;
}

void *
webserver_service(void *arg)
{
	const struct webserver_context *options = (struct webserver_context *)arg;
	char upstream_addr[32] = { 0 };
	snprintf(upstream_addr, 31, "tcp://localhost:%d", options->upstream_port);

	upstream = mg_connect(&webserver_mgr, upstream_addr,
			      webserver_upstream_handler, NULL);
	while (!interrupted) {
		mg_mgr_poll(&webserver_mgr, 1000);
	}
	return NULL;
}

int
webserver_init(struct webserver_context ctx, unsigned port)
{
	static char webserver_addr[32] = { 0 };
	web_context = ctx;

	mg_mgr_init(&webserver_mgr);
	snprintf(webserver_addr, 31, "http://0.0.0.0:%d", port);
	mg_http_listen(&webserver_mgr, webserver_addr, webserver_handler, NULL);

	LOG_INFO("Starting webserver..");

	int err = pthread_create(&webserver_thread, NULL, webserver_service, (void *)&web_context);
	if (err) {
		LOG_ERROR("failed to start webserver service");
		return ERR;
	}
	LOG_INFO("static http/ws server http://localhost:%d", port);

	return OK;
}

void
webserver_shutdown(void)
{
	LOG_INFO("webserver shutting down...");
	interrupted = 1;

	int err = pthread_join(webserver_thread, NULL);
	if (err) {
		LOG_ERROR("failed to join webserver thread");
	}
	mg_mgr_free(&webserver_mgr);
	LOG_INFO("webserver ended");
	return;
}
