/**
 * @file config.h
 *
 * Config loader
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2013 Apr 1
 *
 * Copyright 2009-2013 Jon Mayo
 * Ms-RL : See COPYING.txt for complete license text.
 *
 */
#ifndef CONFIG_H
#define CONFIG_H
#include "list.h"

struct config;

/** configuration callback that matches a wildcard to a config option. */
struct config_watcher {
	LIST_ENTRY(struct config_watcher) list;
	char *mask;
	int (*func)(struct config *cfg, void *extra, const char *id, const char *value);
	void *extra;
};

/** handle for processing configurations. */
struct config {
	LIST_HEAD(struct, struct config_watcher) watchers;
};

void config_setup(struct config *cfg);
void config_free(struct config *cfg);
void config_watch(struct config *cfg, const char *mask, int (*func)(struct config *cfg,void *extra,const char *id,const char *value ), void *extra);
int config_load(const char *filename, struct config *cfg);
#endif
