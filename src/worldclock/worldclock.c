/**
 * @file worldclock.c
 *
 * Virtual time keeping in a game world.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @date 2022 Aug 17
 *
 * Copyright (c) 2019-2022 Jon Mayo <jon@rm-f.net>
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

#include "worldclock.h"

#include <time.h>

#define LOG_SUBSYSTEM "worldclock"
#include "log.h"
#include "debug.h"

static worldclock_t worldclock_epoch = 914544000ll; // 1998 Dec 25
static const double worldclock_rate = 2.0; // game clock moves 2X faster than real clock
static time_t real_epoch;

/* worldclock_init records the real-time epoch for the game clock. */
int
worldclock_init(void)
{
	if (real_epoch) {
		LOG_ERROR("duplicate initialization of worldclock!");
		return -1;
	}

	time(&real_epoch);

	return 0;
}

/* worldclock_now returns the current in-game time. */
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

/* worldclock_strftime formats a game time using strftime conventions. */
static int
worldclock_strftime(char *s, size_t max, worldclock_t t, const char *fmt)
{
	// TODO: implement a portable time library - this depends heavily on Unix behavior
	time_t sys_t = t;
	struct tm *tm = gmtime(&sys_t);
	int result;

	result = strftime(s, max, fmt, tm);
	return result ? 0 : -1;
}

/* worldclock_datetimestr formats a game time as "YYYY-MM-DD HH:MM:SS". */
int
worldclock_datetimestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%Y-%m-%d %H:%M:%S");
}

/* worldclock_datestr formats a game time as "YYYY-MM-DD". */
int
worldclock_datestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%Y-%m-%d");
}

/* worldclock_timestr formats a game time as "HH:MM:SS". */
int
worldclock_timestr(char *s, size_t max, worldclock_t t)
{
	return worldclock_strftime(s, max, t, "%H:%M:%S");
}

/* worldclock_timeofdaystr writes a plain English description of the time of day (e.g. "dawn", "evening"). */
int
worldclock_timeofdaystr(char *s, size_t max, worldclock_t t)
{
	/* these two arrays (tod, hour_intervals) must be the same size */
	const char *tod[] = { /* time-of-day */
		"midnight",
		"after midnight",
		"early morning",
		"dawn",
		"morning",
		"late morning",
		"noon",
		"afternoon",
		"late afternoon",
		"early evening",
		"dusk",
		"evening",
		"late evening",
		"nighttime"
	};
	/* this list must be sorted, as we will binary search */
	const signed char hour_intervals[] = {
		0,	// midnight (12:00a to 12:05a)
		0,	// after midnight
		2,	// early morning
		6,	// dawn
		6,	// morning
		9,	// late morning
		12,	// noon
		12,	// afternoon
		16,	// late afternoon
		17,	// early evening
		19,	// dusk (or sunset) - 7:00p to 7:05p
		19,	// evening
		21,	// late evening
		23,	// nighttime
	};
	const char slack_min = 5; /* how much "slack" in minutes we have for exact matches */

	_Static_assert((sizeof (tod) / sizeof (*tod)) == (sizeof (hour_intervals) / sizeof (*hour_intervals)),
		       "Arrays tod and hour_intervals must contain the same number of elements");

	// TODO: implement a portable time library - this depends heavily on Unix behavior
	time_t sys_t = t;
	struct tm tm = *gmtime(&sys_t);
	unsigned entries = sizeof (tod) / sizeof (*tod);
	unsigned left = 0, right = entries - 1;

	/* binary search for rightmost entry where hour <= tm.tm_hour */
	while (left < right) {
		unsigned mid = left + (right - left + 1) / 2;

		if (hour_intervals[mid] <= tm.tm_hour)
			left = mid;
		else
			right = mid - 1;
	}

	if (left > 0 && hour_intervals[left - 1] == hour_intervals[left] && tm.tm_min < slack_min)
		left--;

	snprintf(s, max, "%s", tod[left]);
	return 0;
}
