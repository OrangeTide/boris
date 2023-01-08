#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <libwebsockets.h>
#include <webserver.h>
#include <threads.h>
#include <signal.h>

#define OK  (0)
#define ERR (-1)

static struct lws_context *webserver_context;
static sig_atomic_t interrupted;
static thrd_t webserver_thread;

static const struct lws_http_mount mounts[] = {
	{
		.mount_next = NULL,
		.mountpoint = "/",
		.mountpoint_len = 1,
		.def = "index.html",
		.origin = "./bin/www/",
		.origin_protocol = LWSMPRO_FILE,
	},
};

void
webserver_log_emit(int level, const char *line)
{
	int emit_level = 0;
	switch (level) {
	case LLL_ERR: emit_level = LOG_LEVEL_ERROR; break;
	case LLL_WARN: emit_level = LOG_LEVEL_WARN; break;
	case LLL_NOTICE: emit_level = LOG_LEVEL_INFO; break;
	case LLL_INFO: emit_level = LOG_LEVEL_INFO; break;
	case LLL_DEBUG: emit_level = LOG_LEVEL_DEBUG; break;
	case LLL_USER: emit_level = LOG_LEVEL_INFO; break;
	default: emit_level = LOG_LEVEL_WARN; break;
	}
	log_logf(emit_level, LOG_SUBSYSTEM, "%s", line);
};

int
webserver_service(void *arg){
	int res = -1;
	while (!interrupted) {
		res = lws_service(webserver_context, 0);
		if (res < 0) {
			break;
		}
	}
	return res;
}

int
webserver_init(int family, unsigned port)
{
	lws_set_log_level(LLL_USER | LLL_ERR | LLL_WARN | LLL_NOTICE, webserver_log_emit);


	struct lws_context_creation_info info = {
		.port = port,
		.mounts = mounts,
		//.error_document_404 = "/404.html",
		//.options = LWS_SERVER_OPTION_HTTP_HEADERS_SECURITY_BEST_PRACTICES_ENFORCE,
	};

	webserver_context = lws_create_context(&info);

	int err = thrd_create(&webserver_thread, webserver_service, NULL);
	if (err) {
		lwsl_err("failed to start webserver service\n");
		return ERR;
	}
	lwsl_user("listening on port %d\n", port);

	thrd_detach(webserver_thread);

	return OK;
};

void
webserver_shutdown(void)
{
	lwsl_user("shutting down\n");
	lws_context_destroy(webserver_context);
	return;
};
