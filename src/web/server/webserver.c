#define LOG_SUBSYSTEM "webserver"
#include <log.h>

#include <mongoose.h>
#include <webserver.h>
#include <pthread.h>
#include <signal.h>

#define OK  (0)
#define ERR (-1)

static struct webserver_context web_context;
static sig_atomic_t interrupted = 0;
static pthread_t webserver_thread;


void *
webserver_service(void *arg){
	int res = -1;
	while (!interrupted) {
		if (res < 0) {
			break;
		}
	}
	return NULL;
}

int
webserver_init(struct webserver_context ctx, unsigned port)
{
	web_context = ctx;

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

	LOG_INFO("webserver ended");
	return;
};
