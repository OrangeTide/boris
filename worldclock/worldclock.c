/**
 * @file worldclock.c
 *
 * Virtual time keeping in a game world.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2020 Dec 9
 *
 * Copyright (c) 2019-2020, Jon Mayo
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
 * INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
 * LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */

#include "worldclock.h"

#include <time.h>
#include <errno.h>

static worldclock_t worldclock_epoch = 914544000ll; // 1998 Dec 25
static const double worldclock_rate = 2.0; // game clock moves 2X faster than real clock
static time_t real_epoch;

int
worldclock_init(void)
{
	if (real_epoch) {
		errno = EINVAL;
		return -1; // duplicate initialization of worldclock!
	}

	time(&real_epoch);

	return 0;
}

worldclock_t
worldclock_now(void)
{
	time_t now;
	worldclock_t result;

	time(&now);
	now -= real_epoch;

	result = ((worldclock_t)now * worldclock_rate) + worldclock_epoch;

	return result;
}

static int
worldclock_strftime(char *s, size_t max, worldclock_t t, const char *fmt)
{
	// TODO: implement a portable time - this depends heavily on Unix behavior
	time_t sys_t = t;
	struct tm *tm = gmtime(&sys_t);

	return strftime(s, max, fmt, tm) ? 0 : -1;
}

int
worldclock_datetimestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%Y-%m-%d %H:%M:%S");
}

int
worldclock_datestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%Y-%m-%d");
}

int
worldclock_timestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%H:%M:%S");
}
