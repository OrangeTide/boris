#include <libwebsockets.h>
#include <signal.h>

static int config_server_port = 8080;
static sig_atomic_t interrupted;

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
sigint_handler(int sig)
{
	(void)sig;
	interrupted = 1;
}

static void
process_args(int argc, char *argv[])
{
	const char *p;

	if ((p = lws_cmdline_option(argc, (const char**)argv, "-p")))
		config_server_port = atoi(p);
}

int
main(int argc, char *argv[])
{
	process_args(argc, argv);

	signal(SIGINT, sigint_handler);

	lws_set_log_level(LLL_USER | LLL_ERR | LLL_WARN | LLL_NOTICE, NULL);

	lwsl_user("static http server http://localhost:%d\n", config_server_port);

	struct lws_context_creation_info info = {
		.port = config_server_port,
		.mounts = mounts,
		//.error_document_404 = "/404.html",
		// .options = LWS_SERVER_OPTION_HTTP_HEADERS_SECURITY_BEST_PRACTICES_ENFORCE,
	};

	struct lws_context *context = lws_create_context(&info);
	if (!context) {
		lwsl_err("lws init failed\n");
		return 1;
	}

	while (!interrupted) {
		int res = lws_service(context, 0);
		if (res < 0) {
			break;
		}
	}
	interrupted = 0;

	lws_context_destroy(context);

	return 0;
}
