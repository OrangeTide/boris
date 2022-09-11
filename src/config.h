/**
 * @file config.h
 *
 * Config loader
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Apr 27
 *
 * Copyright (c) 2009-2022 Jon Mayo <jon@rm-f.net>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifndef CONFIG_H_
#define CONFIG_H_
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
void config_watch(struct config *cfg, const char *mask, int (*func)(struct config *cfg, void *extra, const char *id, const char *value ), void *extra);
int config_load(const char *filename, struct config *cfg);

#if !defined(NDEBUG) && !defined(NTEST)
void config_test(void);
#endif
#endif
