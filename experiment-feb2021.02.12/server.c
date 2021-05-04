#include "server.h"

#include <string.h>
#include <libwebsockets.h>

#define ERR (-1)
#define OK (0)

static const struct lws_http_mount server_mount[] = {
	{
		.mount_next = NULL,
		.mountpoint = "/",
		.origin = "./mount-origin",
		.def = "index.html",
		.origin_protocol = LWSMPRO_FILE,
		.mountpoint_len = 1,
//		.basic_auth_login_file = NULL,
	},
};

static const struct lws_protocols server_protocols[] = {
	{ .name = NULL, .callback = NULL, } /* last entry */
};

int
server_init(void)
{
	struct lws_context_creation_info info;

	memset(&info, 0, sizeof(info));

	info.port = SERVER_PORT;
	info.protocols = server_protocols;
	info.mounts = server_mount;
//	info.error_document_404 = "/404.html";

	/// TODO: ...

	return OK;
}
