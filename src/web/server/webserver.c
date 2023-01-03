#include <webserver.h>
#include <libwebsockets.h>

int webserver_init(int family, unsigned port)
{
	lws_set_log_level(LLL_USER | LLL_ERR | LLL_WARN | LLL_NOTICE, NULL);

	lwsl_user("Webserver NOT IMPLEMENTED, port = %d\n", port);
	return 1;
};

void webserver_shutdown(void)
{
	lwsl_user("Webserver shutting down\n");
	return;
};
