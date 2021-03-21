/* roomdraw.c : draws an ASCII art room
 * Copyright 2007-2020 Jon Mayo - Read LICENSE for licensing terms
 * initial: 2007-04-10 (Thu, 10 Apr 2007)
 * updated: 2020-12-10
 */
#include "roomdraw.h"

#include <stdio.h>
#include <stdlib.h>

#ifndef ROOM_BUF_SZ
/* returns the size of the buffer necessary to render a certain sized room */
#define ROOM_BUF_SZ(w, h) (((h)+2)*((w)+4)+1)
#endif

#define ADD_CH(buf, n, ch) do { if((n)>1) { *(buf)++=(ch); (n)--; } } while(0)
#define ADD_NL(buf, n) ADD_CH(buf, n, '\n')
void room_draw(char *buf, size_t n, int width, int height, unsigned exits) {
	int x,y;
	int pos[4];
	pos[0]=exits&1?rand()%width+1:-1;
	pos[1]=exits&2?rand()%width+1:-1;
	pos[2]=exits&4?rand()%height:-1;
	pos[3]=exits&8?rand()%height:-1;
	for(x=0;x<width+2;x++) {
		if(x==pos[0]) {
			ADD_CH(buf, n, '+');
		} else {
			ADD_CH(buf, n, '-');
		}
	}
	ADD_NL(buf, n);
	for(y=0;y<height;y++) {
		if(y==pos[2]) {
			ADD_CH(buf, n, '+');
		} else {
			ADD_CH(buf, n, '|');
		}
		for(x=0;x<width;x++) {
			ADD_CH(buf, n, '.');
		}
		if(y==pos[3]) {
			ADD_CH(buf, n, '+');
		} else {
			ADD_CH(buf, n, '|');
		}
		ADD_NL(buf, n);
	}
	for(x=0;x<width+2;x++) {
		if(x==pos[1]) {
			ADD_CH(buf, n, '+');
		} else {
			ADD_CH(buf, n, '-');
		}
	}
	ADD_NL(buf, n);
	*buf=0;
}

#ifdef UNIT_TEST
#include <time.h>
#include <stdlib.h>
int main() {
	char buf[ROOM_BUF_SZ(10, 6)];
	srand(time(0));
	room_draw(buf, sizeof buf, 10, 6, 0xf);
	fputs(buf, stdout);
	return 0;
}
#endif
