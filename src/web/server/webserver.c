#include "mud.h"
#include "mudconfig.h"
#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <mongoose.h>
#include <webserver.h>
#include <webclient.h>
#include <msgqueue.h>
#include <pthread.h>
#include <signal.h>
#include <unistd.h>

#define OK  (0)
#define ERR (-1)

static struct webserver_context web_context;
static sig_atomic_t interrupted = 0;
static pthread_t webserver_thread;

static const char *web_root = "./bin/www";
static struct mg_mgr webserver_mgr;

static void
write_game_wakeup(void)
{
	char b = 1;
	int fd = webclient_get_wake_fd();
	if (fd >= 0) {
		if (write(fd, &b, 1) < 0) { /* best-effort wakeup */ }
	}
}

static void
drain_output_queues(void)
{
	int need_game_wakeup = 0;

	webclient_lock();
	for (struct web_client *wc = webclient_first(); wc; wc = wc->next) {
		if (!wc->ws_conn)
			continue;

		struct client_msg *msg;
		while ((msg = msgqueue_get(&wc->output_q)) != NULL) {
			mg_ws_send(wc->ws_conn, msg->data, msg->len,
				   WEBSOCKET_OP_TEXT);
			free(msg);
		}

		if (wc->state == WC_CLOSING) {
			struct mg_connection *conn = wc->ws_conn;
			wc->ws_conn = NULL;
			conn->fn_data = NULL;
			conn->is_closing = 1;
			need_game_wakeup = 1;
		}
	}
	webclient_unlock();

	if (need_game_wakeup)
		write_game_wakeup();
}

static void
wakeup_handler(struct mg_connection *c, int ev, void *ev_data,
	       void *fn_data)
{
	if (ev == MG_EV_READ) {
		c->recv.len = 0;
		drain_output_queues();
	}
	(void)ev_data;
	(void)fn_data;
}

static void
webserver_handler(struct mg_connection *c, int ev, void *ev_data,
		  void *fn_data)
{
	if (ev == MG_EV_WS_OPEN) {
		struct web_client *wc = webclient_new(c);
		if (!wc) {
			LOG_ERROR("could not create web client");
			c->is_closing = 1;
			return;
		}
		c->fn_data = wc;
		LOG_INFO("websocket client connected");
		write_game_wakeup();
	} else if (ev == MG_EV_HTTP_MSG) {
		struct mg_http_message *hm = (struct mg_http_message *)ev_data;
		if (mg_http_match_uri(hm, "/ws")) {
			mg_ws_upgrade(c, hm, NULL);
		} else if (mg_http_match_uri(hm, "/api")) {
			mg_http_reply(c, 200, "",
				      "{\"result\": \"%s\"}\n", "boris");
		} else {
			struct mg_http_serve_opts opts = {
				.root_dir = web_root
			};
			mg_http_serve_dir(c, ev_data, &opts);
		}
	} else if (ev == MG_EV_WS_MSG) {
		struct web_client *wc = (struct web_client *)c->fn_data;
		struct mg_ws_message *wm = (struct mg_ws_message *)ev_data;
		if (wc) {
			msgqueue_put(&wc->input_q, wm->data.ptr,
				     (int)wm->data.len);
			write_game_wakeup();
		}
	} else if (ev == MG_EV_CLOSE) {
		struct web_client *wc = (struct web_client *)c->fn_data;
		if (wc) {
			webclient_lock();
			wc->state = WC_CLOSING;
			wc->ws_conn = NULL;
			webclient_unlock();
			c->fn_data = NULL;
			write_game_wakeup();
		}
	}
	(void)fn_data;
}

static void *
webserver_service(void *arg)
{
	const struct webserver_context *options =
		(struct webserver_context *)arg;

	mg_wrapfd(&webserver_mgr, options->wake_fd, wakeup_handler, NULL);

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
	mg_http_listen(&webserver_mgr, webserver_addr,
		       webserver_handler, NULL);

	LOG_INFO("Starting webserver..");

	int err = pthread_create(&webserver_thread, NULL,
				 webserver_service, (void *)&web_context);
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
}
