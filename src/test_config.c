/* unit test for config.c (config file parser + watchers) */
#define LOG_SUBSYSTEM "test_config"

/* include the source directly for unit testing */
#include "config.c"

#include "ctest.h"
#include <unistd.h>

/* record of a single id/value pair delivered to a watcher. */
struct capture {
	char last_id[128];
	char last_value[128];
	int hits;
};

static int
capture_cb(struct config *cfg UNUSED, void *extra, const char *id, const char *value)
{
	struct capture *cap = extra;

	snprintf(cap->last_id, sizeof cap->last_id, "%s", id);
	snprintf(cap->last_value, sizeof cap->last_value, "%s", value ? value : "");
	cap->hits++;
	return 1;
}

/* write a throwaway config file and return its path (static buffer). */
static const char *
write_tmp_config(void)
{
	static char path[64];
	FILE *f;

	snprintf(path, sizeof path, "test_config_%ld.cfg", (long)getpid());
	f = fopen(path, "w");
	if (!f)
		return NULL;
	fputs("# a comment\n", f);
	fputs("server.name = MUD\n", f);
	fputs("server.port = 4444\n", f);
	fputs("prompt.menu = Choose:\n", f);
	fclose(f);
	return path;
}

int
main(void)
{
	const char *path = write_tmp_config();
	struct config cfg;
	struct capture all = {0}, servers = {0};

	CHECK("temp config written", path != NULL);

	config_setup(&cfg);
	config_watch(&cfg, "*", capture_cb, &all);
	config_watch(&cfg, "server.*", capture_cb, &servers);

	CHECK("config loads successfully", config_load(path, &cfg) != 0);

	/* the wildcard watcher sees every non-comment line. */
	CHECK("wildcard watcher saw all three keys", all.hits == 3);

	/* the masked watcher only fires for matching ids. */
	CHECK("server.* watcher fired twice", servers.hits == 2);
	CHECK("server.* watcher last id matches mask",
		strncmp(servers.last_id, "server.", 7) == 0);
	CHECK("server.port value captured", strcmp(servers.last_value, "4444") == 0);

	config_free(&cfg);
	if (path)
		unlink(path);

	return ctest_report("test_config");
}
