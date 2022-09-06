/**
 * @file acs.c
 *
 * Access control strings.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
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

#include "acs.h"
#include <stdlib.h>
#include <ctype.h>
#include <limits.h>
#define LOG_SUBSYSTEM "acs"
#include <log.h>

/** initializes acs_info to some values. */
void
acs_init(struct acs_info *ai, unsigned level, unsigned flags)
{
	ai->level = level <= UCHAR_MAX ? level : UCHAR_MAX;
	ai->flags = flags;
}

/** test if a flag is set in acs_info. */
int
acs_testflag(struct acs_info *ai, unsigned flag)
{
	unsigned i;
	flag = tolower((char)flag);

	if (flag >= 'a' && flag <= 'z') {
		i = flag - 'a';
	} else if (flag >= '0' && flag <= '9') {
		i = flag - '0' + 26;
	} else {
		LOG_ERROR("unknown flag '%c'\n", flag);
		return 0;
	}

	return ((ai->flags >> i) & 1) == 1;
}

/** check a string against acs_info.
 * the string can contain levels (s) or flags(f).
 * use | to OR things toegether. */
int
acs_check(struct acs_info *ai, const char *acsstring)
{
	const char *s = acsstring;
	const char *endptr;
	unsigned long level;
retry:

	while (*s) switch(*s++) {
		case 's':
			level = strtoul(s, (char**)&endptr, 10);

			if (endptr == acsstring) {
				goto parse_failure;
			}

			if (ai->level < level) goto did_not_pass;

			s = endptr;
			break;

		case 'f':
			if (!acs_testflag(ai, (unsigned)*s)) goto did_not_pass;

			s++;
			break;

		case '|':
			return 1; /* short circuit the OR */

		default:
			goto parse_failure;
		}

	return 1; /* everything matched */
did_not_pass:

	while (*s) if (*s++ == '|') goto retry; /* look for an | */

	return 0;
parse_failure:
	LOG_ERROR("acs parser failure '%s' (off=%td)\n", acsstring, s - acsstring);
	return 0;
}

#ifndef NTEST

/** test routine for acs_info. */
void
acs_test(void)
{
	struct acs_info ai_test;

	acs_init(&ai_test, 4, 0);

	LOG_INFO("acs_check() %d\n", acs_check(&ai_test, "s6fA"));
	LOG_INFO("acs_check() %d\n", acs_check(&ai_test, "s2"));
	LOG_INFO("acs_check() %d\n", acs_check(&ai_test, "s2fA"));
	LOG_INFO("acs_check() %d\n", acs_check(&ai_test, "s8|s2"));
}
#endif

