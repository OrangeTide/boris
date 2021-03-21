/* moon.c - shows phase of the moon
 * Jon Mayo - PUBLIC DOMAIN - June 26, 2007
 *
 * I stole the moon pictures from Joan G. Stark's ascii art.
 * http://www.geocities.com/SoHo/7373/celestal.htm#moonphases
 *
 * I borrowed the quick and dirty formula from MIT.
 */
#include <time.h>
#include "moon.h"

static const char *moon[8][8] = {
			{
		"NEW MOON",
		"    _..._",
		"  .:::::::.",
		" :::::::::::",
		" :::::::::::",
		" `:::::::::'",
		"   `':::''",
				0,
			}, {
		"WAXING CRESCENT",
		"    _..._",
		"  .::::. `.",
		" :::::::.	:",
		" ::::::::	:",
		" `::::::' .'",
		"   `'::'-'",
				0,
			}, {
		"FIRST QUARTER",
		"    _..._",
		"  .::::  `.",
		" ::::::    :",
		" ::::::    :",
		" `:::::   .'",
		"   `'::.-'",
				0,
			}, {
		"WAXING GIBBOUS",
		"    _..._",
		"  .::'   `.",
		" :::       :",
		" :::       :",
		" `::.     .'",
		"  `':..-'",
				0,
			}, {
		"FULL MOON",
		"    _..._",
		"  .'     `.",
		" :         :",
		" :         :",
		" `.       .'",
		"   `-...-'",
				0,
			}, {
		"WANING GIBBOUS",
		"    _..._",
		"  .'   `::.",
		" :       :::",
		" :       :::",
		" `.     .::'",
		"   `-..:''",
				0,
			}, {
		"LAST QUARTER",
		"    _..._",
		"  .'  ::::.",
		" :    ::::::",
		" :    ::::::",
		" `.   :::::'",
		"   `-.::''",
				0,
			}, {
		"WANING CRESCENT",
		"    _..._",
		"  .' .::::.",
		" :  ::::::::",
		" :  ::::::::",
		" `. '::::::'",
		"   `-.::''",
				0,
			},
};

static int getphase(time_t now) {
	/* taken from:
	 * http://everything2.com/index.pl?node=phase%20of%20the%20moon */
	struct tm *tm;
	float yd, y;
	float p;

	tm=gmtime(&now);
	y=tm->tm_year+1900;
	yd=tm->tm_yday;

	p=((yd+365.25*(y-2001))*850.+5130.)/25101.;
	p-=(int)p; /* get the float part */

	return p*8;
}

void moon_show(int (*writeln)(void *extra, const char *line), void *extra) {
	int i, ph;
	ph=getphase(time(0));
	for(i=0;moon[ph][i];i++) {
		if (!writeln || writeln(extra, moon[ph][i]))
			break;
	}
}

/*** TEST ***/
#ifdef UNIT_TEST

#include <stdlib.h>
#include <stdio.h>

static int wrap_puts(void *extra, const char *line)
{
	(void)extra;
	puts(line);
}

int main() {
	moon_show(wrap_puts, NULL);

	return 0;
}
#endif
