/* mkpass.c - command-line utility to encode SHA1 passwords */
/* Copyright 2009-2018, Jon Mayo <jon@rm-f.net> */
/* See COPYING.txt for complete license text. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

#include "passwd.h"

void print_hex(const void *p, size_t cnt) {
	size_t i;
	for(i=0;i<cnt;i++) {
		printf("%02hhX", ((unsigned char*)p)[i]);
	}
}

void print_password(const struct password *p) {
	print_hex(p->salt, sizeof p->salt);
	printf(" ");
	print_hex(p->digest, sizeof p->digest);
	printf("\n");
}

int main() {
	char plaintext[64];
	struct termios tios_orig, tios;
	struct password p[2];
	unsigned i;
	char *b;

	// if(!test()) return 0;
	srand(time(0));

	tcgetattr(STDIN_FILENO, &tios_orig);
	tios=tios_orig;
	/* echo off */
	tios.c_lflag&=~ECHO;
	tcsetattr(STDIN_FILENO, TCSANOW, &tios);

again:
	gensalt(p[0].salt, sizeof p[0].salt);
	p[1]=p[0];
	for(i=0;i<2;i++) {
		fputs(i?"Again: ":"Password: ", stdout); fflush(stdout);
		if(!fgets(plaintext, sizeof plaintext, stdin)) goto failure;
		printf("\n");
		for(b=plaintext+strlen(plaintext);b-->plaintext && *b=='\n';*b=0) ;
		mkpass(&p[i], p[i].salt, plaintext);
		memset(plaintext, 0, sizeof plaintext);
	}
	if(!ckpass(p, p+1)) { fputs("Bad match, try again.\n", stderr); goto again; }

	print_password(&p[0]);

	/* restore */
	tcsetattr(STDIN_FILENO, TCSADRAIN, &tios_orig);
	return 0;
failure:
	/* restore */
	tcsetattr(STDIN_FILENO, TCSADRAIN, &tios_orig);
	return 1;
}
