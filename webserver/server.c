#include <unistd.h>
#include <civetweb.h>

static int
simple_handler(struct mg_connection *conn, void *_not_used __attribute__((unused)))
{
	const char msg[] = "This is a test.";
	unsigned len = sizeof(msg) - 1;

	mg_send_http_ok(conn, "text/plain", len);
	mg_write(conn, msg, len);

	return 200;
}

int
main()
{
	mg_init_library(0);

	const char *options[] = {
		"listening_ports", "8080",
		NULL,
	};
	struct mg_context *ctx = mg_start(NULL, NULL, options);

	mg_set_request_handler(ctx, "/", simple_handler, "Hello World");

	while (1)
		sleep(60);

	mg_stop(ctx);

	mg_exit_library();

	return 0;
}
