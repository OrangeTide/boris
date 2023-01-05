#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <webserver.h>
#include <libwebsockets.h>

void webserver_log_emit(int level, const char *line)
{
	int emit_level = 0;
	switch (level)
	{
	case LLL_ERR:
		emit_level = LOG_LEVEL_ERROR;
		break;
	case LLL_WARN:
		emit_level = LOG_LEVEL_WARN;
		break;
	case LLL_NOTICE:
		emit_level = LOG_LEVEL_INFO;
		break;
	case LLL_INFO:
		emit_level = LOG_LEVEL_INFO;
		break;
	case LLL_USER:
		emit_level = LOG_LEVEL_INFO;
		break;
	case LLL_DEBUG:
		emit_level = LOG_LEVEL_DEBUG;
		break;
	default:
		emit_level = LOG_LEVEL_WARN;
		break;
	}
	log_logf(emit_level, LOG_SUBSYSTEM, "%s", line);
};

int webserver_init(int family, unsigned port)
{
	lws_set_log_level(LLL_USER | LLL_ERR | LLL_WARN | LLL_NOTICE, webserver_log_emit);

	lwsl_user("Webserver NOT IMPLEMENTED, port = %d\n", port);
	return 1;
};

void webserver_shutdown(void)
{
	lwsl_user("Webserver shutting down\n");
	return;
};
