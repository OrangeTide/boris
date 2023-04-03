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
static sig_atomic_t interrupted = 0;
static pthread_t webserver_thread;

static const char *web_root = "./bin/www";
static struct mg_mgr webserver_mgr;

void 
webserver_test_callback(dyad_Event* ev)
{
	char buf[48] = {0};

	snprintf(buf, 47, "Webserver Event: %s", ev->data);
	LOG_INFO("%s", buf);
}

static void 
webserver_handler(struct mg_connection *c, int ev, void *ev_data, void *fn_data) 
{
	dyad_Stream *upstream = web_context.webserver_upstream;

	if (ev == MG_EV_WS_OPEN)
	{
		LOG_INFO("websocket client connected");
		dyad_write(upstream, (const void *)"@NEW_CLIENT@", 13);
	}
	else if (ev == MG_EV_HTTP_MSG) 
	{
		struct mg_http_message *hm = (struct mg_http_message *) ev_data;
		if (mg_http_match_uri(hm, "/ws")) 
		{
			// Upgrade to websocket. From now on, a connection is a full-duplex
			// Websocket connection, which will receive MG_EV_WS_MSG events.
			mg_ws_upgrade(c, hm, NULL);
		} 
		else if (mg_http_match_uri(hm, "/api")) 
		{
			// Serve REST response
			mg_http_reply(c, 200, "", "{\"result\": \"%s\"}\n", "boris");
    	} 
		else 
		{
			// Serve static files
			struct mg_http_serve_opts opts = {.root_dir = web_root};
			mg_http_serve_dir(c, ev_data, &opts);
    	}
	} 
	else if (ev == MG_EV_WS_MSG) 
	{
		// Got websocket frame. Received data is wm->data. Echo it back!
		struct mg_ws_message *wm = (struct mg_ws_message *) ev_data;
		mg_ws_send(c, wm->data.ptr, wm->data.len, WEBSOCKET_OP_TEXT);

		dyad_write(upstream, (const void *)"@MESSAGE@", 9);
	}
	(void) fn_data;
}

void *
webserver_service(void *arg)
{
	while (!interrupted) {
		mg_mgr_poll(&webserver_mgr, 1000);
	}
	return NULL;
}

int
webserver_init(struct webserver_context ctx, unsigned port)
{
	static char webserver_addr[32] = {0};
	web_context = ctx;

	mg_mgr_init(&webserver_mgr);
	snprintf(webserver_addr, 31, "http://localhost:%d", port);
	mg_http_listen(&webserver_mgr, webserver_addr, webserver_handler, NULL);

	LOG_INFO("Starting webserver on port %d", port);

	int err = pthread_create(&webserver_thread, NULL, webserver_service, NULL);
	if (err) {
		LOG_ERROR("failed to start webserver service");
		return ERR;
	}
	LOG_INFO("static http/ws server http://localhost:%d", port);

	return OK;
};

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
};
