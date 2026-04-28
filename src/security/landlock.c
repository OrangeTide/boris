/**
 * @file landlock.c
 *
 * Landlock filesystem sandbox for Linux 5.13+.
 *
 * Restricts filesystem access after initialization so that only the
 * directories boris needs at runtime are reachable. Uses direct syscalls
 * to avoid requiring glibc 2.36+ or <linux/landlock.h>.
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

#ifdef __linux__

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <unistd.h>

#define LOG_SUBSYSTEM "security"
#include <log.h>

#include "mudconfig.h"

#ifndef __NR_landlock_create_ruleset
#define __NR_landlock_create_ruleset 444
#endif
#ifndef __NR_landlock_add_rule
#define __NR_landlock_add_rule 445
#endif
#ifndef __NR_landlock_restrict_self
#define __NR_landlock_restrict_self 446
#endif

#define LL_CREATE_RULESET_VERSION (1U << 0)
#define LL_RULE_PATH_BENEATH 1

/* ABI v1 (Linux 5.13) */
#define LL_FS_EXECUTE      (1ULL << 0)
#define LL_FS_WRITE_FILE   (1ULL << 1)
#define LL_FS_READ_FILE    (1ULL << 2)
#define LL_FS_READ_DIR     (1ULL << 3)
#define LL_FS_REMOVE_DIR   (1ULL << 4)
#define LL_FS_REMOVE_FILE  (1ULL << 5)
#define LL_FS_MAKE_CHAR    (1ULL << 6)
#define LL_FS_MAKE_DIR     (1ULL << 7)
#define LL_FS_MAKE_REG     (1ULL << 8)
#define LL_FS_MAKE_SOCK    (1ULL << 9)
#define LL_FS_MAKE_FIFO    (1ULL << 10)
#define LL_FS_MAKE_BLOCK   (1ULL << 11)
#define LL_FS_MAKE_SYM     (1ULL << 12)
/* ABI v2 (Linux 5.19) */
#define LL_FS_REFER        (1ULL << 13)
/* ABI v3 (Linux 6.2) */
#define LL_FS_TRUNCATE     (1ULL << 14)

struct ll_ruleset_attr {
	uint64_t handled_access_fs;
};

struct ll_path_beneath_attr {
	uint64_t allowed_access;
	int32_t parent_fd;
} __attribute__((packed));

static uint64_t
access_rights_for_abi(int abi)
{
	uint64_t rights =
		LL_FS_EXECUTE | LL_FS_WRITE_FILE | LL_FS_READ_FILE |
		LL_FS_READ_DIR | LL_FS_REMOVE_DIR | LL_FS_REMOVE_FILE |
		LL_FS_MAKE_CHAR | LL_FS_MAKE_DIR | LL_FS_MAKE_REG |
		LL_FS_MAKE_SOCK | LL_FS_MAKE_FIFO | LL_FS_MAKE_BLOCK |
		LL_FS_MAKE_SYM;

	if (abi >= 2)
		rights |= LL_FS_REFER;
	if (abi >= 3)
		rights |= LL_FS_TRUNCATE;

	return rights;
}

static int
add_path_rule(int ruleset_fd, const char *path, uint64_t allowed,
              uint64_t handled)
{
	struct ll_path_beneath_attr attr;
	int fd, ret;

	fd = open(path, O_PATH | O_CLOEXEC);
	if (fd < 0) {
		LOG_WARNING("landlock: cannot open '%s': %s (rule skipped)",
		            path, strerror(errno));
		return 0;
	}

	attr.allowed_access = allowed & handled;
	attr.parent_fd = fd;

	ret = (int)syscall(__NR_landlock_add_rule, ruleset_fd,
	                   LL_RULE_PATH_BENEATH, &attr, 0);
	close(fd);

	if (ret < 0) {
		LOG_ERROR("landlock: add_rule failed for '%s': %s",
		          path, strerror(errno));
		return -1;
	}

	return 0;
}

int
security_landlock_apply(void)
{
	struct ll_ruleset_attr attr;
	uint64_t handled, fs_read, fs_readwrite;
	int abi, ruleset_fd, ret;

	abi = (int)syscall(__NR_landlock_create_ruleset, NULL, 0,
	                   LL_CREATE_RULESET_VERSION);
	if (abi < 0) {
		if (errno == ENOSYS)
			LOG_INFO("landlock: not supported by this kernel");
		else if (errno == EOPNOTSUPP)
			LOG_INFO("landlock: disabled in kernel configuration");
		else
			LOG_WARNING("landlock: version probe failed: %s",
			            strerror(errno));
		return 0;
	}

	LOG_INFO("landlock: kernel ABI version %d", abi);

	handled = access_rights_for_abi(abi);
	fs_read = LL_FS_READ_FILE | LL_FS_READ_DIR;
	fs_readwrite = LL_FS_READ_FILE | LL_FS_WRITE_FILE | LL_FS_READ_DIR |
	               LL_FS_MAKE_REG;
	if (abi >= 3)
		fs_readwrite |= LL_FS_TRUNCATE;

	attr.handled_access_fs = handled;

	ruleset_fd = (int)syscall(__NR_landlock_create_ruleset, &attr,
	                          sizeof(attr), 0);
	if (ruleset_fd < 0) {
		LOG_ERROR("landlock: create_ruleset: %s", strerror(errno));
		return -1;
	}

	/* LMDB database -- read, write, create, truncate */
	ret = add_path_rule(ruleset_fd, "data/muddb", fs_readwrite, handled);
	if (ret < 0)
		goto fail;

	/* read-only data directories */
	add_path_rule(ruleset_fd, "data/help", fs_read, handled);
	add_path_rule(ruleset_fd, "data/text", fs_read, handled);
	add_path_rule(ruleset_fd, "data/forms", fs_read, handled);
	add_path_rule(ruleset_fd, "data/unicode", fs_read, handled);
	add_path_rule(ruleset_fd, "data/machine", fs_read, handled);

	/* web server static files */
	if (mud_config.webserver_port > 0)
		add_path_rule(ruleset_fd, "bin/www", fs_read, handled);

	/* password salt generation */
	add_path_rule(ruleset_fd, "/dev/urandom", LL_FS_READ_FILE, handled);

	ret = (int)syscall(__NR_landlock_restrict_self, ruleset_fd, 0);
	close(ruleset_fd);
	if (ret < 0) {
		LOG_ERROR("landlock: restrict_self: %s", strerror(errno));
		return -1;
	}

	LOG_INFO("landlock: filesystem sandbox active");
	return 0;

fail:
	close(ruleset_fd);
	return -1;
}

#else /* !__linux__ */

int
security_landlock_apply(void)
{
	return 0;
}

#endif
