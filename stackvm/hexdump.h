/* hexdump.h - utility for streaming hexdumps. */
/* PUBLIC DOMAIN - Jon Mayo
 * original: May 21, 2008
 * updated: June 8, 2011 */
#ifndef HEXDUMP_H
#define HEXDUMP_H
#include <stdio.h>
#include <stddef.h>

struct hexdump_handle {
	unsigned char line[16];
	unsigned linelen;
	FILE *out;
	size_t base;
};

void hexdump_start(struct hexdump_handle *hh, size_t base, FILE *out);
void hexdump_data(struct hexdump_handle *hh, const void *data, size_t len);
void hexdump_end(struct hexdump_handle *hh);
void hexdump(const void *data, size_t len, FILE *out);
#endif
