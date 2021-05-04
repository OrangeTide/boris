#include <mongoose.h>

static int g_count;

static void
cb(struct mg_connection *c, int ev, void *ev_data, void *fn_data)
{
	switch (ev) {
	case MG_EV_HTTP_MSG:
		mg_http_reply(c, 200, NULL, "Hello World %d", ++g_count);
		break;
//	case MG_EV_WS_MSG:
//		break;
//	case MG_EV_POLL:
//		break;
	}
}

int
main(int argc, char *argv[])
{
	struct mg_mgr mgr;

	mg_mgr_init(&mgr);

	const char *server_addr = "http://localhost:8000";
	mg_http_listen(&mgr, server_addr, cb, NULL);

	while (1)
		mg_mgr_poll(&mgr, 50);

	mg_mgr_free(&mgr);

	return 0;
}
