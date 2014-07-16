/* hexdump.c - utility for streaming hexdumps. */
/* PUBLIC DOMAIN - Jon Mayo
 * original: May 21, 2008
 * updated: June 8, 2011 */
#include <ctype.h>
#include <stdio.h>
#include "hexdump.h"

void hexdump_start(struct hexdump_handle *hh, size_t base, FILE *out) {
	if(!hh) return; /* error */
	hh->out=out;
	hh->base=base;
	hh->linelen=0;
}

void hexdump_data(struct hexdump_handle *hh, const void *data, size_t len) {
	unsigned i;
	if(!data || !hh || !hh->out) return; /* ignore */

	while(len) {
		if(hh->linelen==0) {
			fprintf(hh->out, "%07zx:", hh->base);
		}

		for(;hh->linelen<sizeof hh->line;hh->linelen++, len--) {
			if(!len) return;
			hh->line[hh->linelen]=*(const unsigned char*)data;
			hh->base++;
			data++;
			if(hh->linelen%2==0) {
				fprintf(hh->out, " ");
			}
			fprintf(hh->out, "%02hhx", hh->line[hh->linelen]);
		}

		fprintf(hh->out, "  ");

		for(i=0;i<hh->linelen;i++) {
			fprintf(hh->out, "%c", isprint(hh->line[i])?hh->line[i]:'.');
		}

		fprintf(hh->out, "\n");

		hh->linelen=0;
	}
}

void hexdump_end(struct hexdump_handle *hh) {
	unsigned i;

	if(hh->linelen) {
		for(i=hh->linelen;i<sizeof hh->line;i++) {
			if(i%2==0) {
				fprintf(hh->out, "   ");
			} else {
				fprintf(hh->out, "  ");
			}
		}
		fprintf(hh->out, "  ");
		for(i=0;i<hh->linelen;i++) {
			fprintf(hh->out, "%c", isprint(hh->line[i])?hh->line[i]:'.');
		}
		fprintf(hh->out, "\n");
	}
	hh->out=0;
}

void hexdump(const void *data, size_t len, FILE *out) {
	struct hexdump_handle hh;
	hexdump_start(&hh, 0, stdout);
	hexdump_data(&hh, data, len);
	hexdump_end(&hh);
}

#ifdef STAND_ALONE
int main(int argc, char **argv) {
	struct hexdump_handle hh;
	FILE *f;
	char buf[57];
	int res, argi;


	for(argi=1;argi<argc;argi++) {
		f=fopen(argv[argi], "rb");
		if(!f) {
			perror(argv[argi]);
			return 1;
		}
		hexdump_start(&hh, 0, stdout);
		while((res=fread(buf, 1, sizeof buf, f))>0) {
			hexdump_data(&hh, buf, res);
		}
		if(res<0) {
			perror(argv[argi]);
		}
		hexdump_end(&hh);
		fclose(f);
	}

}
#endif
