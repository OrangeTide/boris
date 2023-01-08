#include <lws_evlib_dyad.h>
#include <libwebsockets.h>

struct lws_event_loop_ops event_loop_ops_dyad = {

};

const struct lws_plugin_evlib evlib_dyad = {
	.hdr = {
		"dyad",
		"lws_evlib_plugin",
		LWS_BUILD_HASH,
		LWS_PLUGIN_API_MAGIC
	},

	.ops	= &event_loop_ops_dyad
};
