/**
 * @file security.c
 *
 * Security sandbox dispatcher.
 *
 * Applies OS-level security restrictions after boris has finished
 * initialization and opened all resources it needs. Currently supports
 * Landlock (filesystem restriction) on Linux 5.13+.
 *
 * Copyright (c) 2026, Jon Mayo <jon@rm-f.net>
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

#include "security.h"

#ifdef __linux__
#include <errno.h>
#include <string.h>
#include <sys/prctl.h>
#endif

#define LOG_SUBSYSTEM "security"
#include <log.h>

#include "mudconfig.h"

int security_landlock_apply(void);

int
security_init(void)
{
	if (!mud_config.security_landlock && !mud_config.security_seccomp) {
		LOG_INFO("security sandboxing disabled by configuration");
		return 0;
	}

#ifdef __linux__
	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) < 0) {
		LOG_ERROR("PR_SET_NO_NEW_PRIVS: %s", strerror(errno));
		return -1;
	}

	if (mud_config.security_landlock) {
		if (security_landlock_apply() < 0)
			return -1;
	}
#else
	LOG_INFO("security sandboxing: not available on this platform");
#endif

	return 0;
}

void
security_shutdown(void)
{
}
