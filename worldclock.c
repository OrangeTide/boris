/**
 * @file worldclock.c
 *
 * Virtual time keeping in a game world.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @date 2019 Dec 25
 *
 * Copyright (c) 2019, Jon Mayo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the Boris MUD project.
 */

#include "worldclock.h"

#include <time.h>

#include "debug.h"

static worldclock_t worldclock_epoch = 914544000ll; // 1998 Dec 25
static const double worldclock_rate = 2.0; // game clock moves 2X faster than real clock
static time_t real_epoch;

int
worldclock_init(void)
{
	if (real_epoch) {
		ERROR_MSG("duplicate initialization of worldclock!");
		return -1;
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
	int result;

	result = strftime(s, max, fmt, tm);
	return result ? 0 : -1;
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
