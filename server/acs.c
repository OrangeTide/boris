/******************************************************************************
 * acs - access control string
 ******************************************************************************/
#include "acs.h"
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

