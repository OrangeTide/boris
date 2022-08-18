/**
 * @file common.c
 *
 * 20th Century MUD.
 *
 * @author Jon Mayo <jon.mayo@gmail.com>
 * @version 0.7
 * @date 2020 Apr 27
 *
 * Copyright (c) 2008-2020, Jon Mayo
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

#include "boris.h"
#include "channel.h"
#include "character.h"
#include "debug.h"
#include "eventlog.h"
#include "fdb.h"
#include "room.h"
#include "logging.h"

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <time.h>

/* make sure WIN32 is defined when building in a Windows environment */
#if (defined(_MSC_VER) || defined(__WIN32__)) && !defined(WIN32)
#define WIN32
#endif

#if defined(WIN32)
#ifndef _WIN32_WINNT
/** require at least NT5.1 API for getaddinfo() and others */
#define _WIN32_WINNT 0x0501
#endif

/** macro used to wrap mkdir() function from UNIX and Windows */
#define MKDIR(d) mkdir(d)
#else
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>

/** macro used to wrap mkdir() function from UNIX and Windows */
#define MKDIR(d) mkdir(d, 0777)
#endif

/******************************************************************************
 * Main - Option parsing and initialization
 ******************************************************************************/

void
show_version(void)
{
	puts("Version " BORIS_VERSION_STR " (built " __DATE__ ")");
}

/**
 * flag used for the main loop, zero to terminated.
 */
static sig_atomic_t keep_going_fl = 1;

/**
 * signal handler to cause the main loop to terminated by clearing keep_going_fl.
 */
static void
sh_quit(int s UNUSED)
{
	keep_going_fl = 0;
}

/**
 * display a program usage message and terminated with an exit code.
 */
static void
usage(void)
{
	fprintf(stderr,
	        "usage: boris [-h46] [-p port]\n"
	        "-4      use IPv4-only server addresses\n"
	        "-6      use IPv6-only server addresses\n"
	        "-h      help\n"
	       );
	exit(EXIT_FAILURE);
}

/**
 * check if a flag needs a parameter and exits if next_arg is NULL.
 * @param ch flag currently processing, used for printing error message.
 * @param next_arg string holding the next argument, or NULL if no argument.
 */
static void
need_parameter(int ch, const char *next_arg)
{
	if (!next_arg) {
		ERROR_FMT("option -%c takes a parameter\n", ch);
		usage();
	}
}

/**
 * called for each command-line flag passed to decode them.
 * A flag is an argument that starts with a -.
 * @param ch character found for this flag
 * @param next_arg following argument.
 * @return 0 if the following argument is not consumed. 1 if the argument was used.
 */
static int
process_flag(int ch, const char *next_arg)
{
	switch(ch) {
	case '4':
		mud_config.default_family = AF_INET; /* default to IPv4 */
		return 0;

	case '6':
		mud_config.default_family = AF_INET6; /* default to IPv6 */
		return 0;

	case 'c':
		need_parameter(ch, next_arg);
		free(mud_config.config_filename);
		mud_config.config_filename = strdup(next_arg);
		return 1; /* uses next arg */

	case 'p':
		need_parameter(ch, next_arg);

		if (!socketio_listen(mud_config.default_family, SOCK_STREAM, NULL, next_arg, telnetclient_new_event)) {
			usage();
		}

		return 1; /* uses next arg */

	case 'V': /* print version and exit. */
		show_version();
		exit(0); /* */
		return 0;

	default:
		ERROR_FMT("Unknown option -%c\n", ch);

	/* fall through */
	case 'h':
		usage();
	}

	return 0; /* didn't use next_arg */
}

/**
 * process all command-line arguments.
 * @param argc count of arguments.
 * @param argv array of strings holding the arguments.
 */
static void
process_args(int argc, char **argv)
{
	int i, j;

	for (i = 1; i < argc; i++) {
		if (argv[i][0] == '-') {
			for (j = 1; argv[i][j]; j++) {
				if (process_flag(argv[i][j], (i + 1) < argc ? argv[i + 1] : NULL)) {
					/* a flag used the next_arg */
					i++;
					break;
				}
			}
		} else {
			TODO("process arguments");
			fprintf(stderr, "TODO: process argument '%s'\n", argv[i]);
		}
	}
}

/**
 * main - where it all starts.
 */
int
main(int argc, char **argv)
{
	show_version();

	signal(SIGINT, sh_quit);
	signal(SIGTERM, sh_quit);

#ifndef NTEST
	acs_test();
	config_test();
	bitmap_test();
	freelist_test();
	heapqueue_test();
	sha1_test();
	sha1crypt_test();
#endif

	srand((unsigned)time(NULL));

	if (MKDIR("data") == -1 && errno != EEXIST) {
		PERROR("data/");
		return EXIT_FAILURE;
	}

	if (!socketio_init()) {
		return EXIT_FAILURE;
	}

	atexit(socketio_shutdown);

	/* load default configuration into mud_config global */
	mud_config_init();
	atexit(mud_config_shutdown);

	/* parse options and load into mud_config global */
	process_args(argc, argv);

	/* process configuration file and load into mud_config global */
	if (!mud_config_process()) {
		ERROR_MSG("could not load configuration");
		return EXIT_FAILURE;
	}

	if (logging_initialize()) {
		ERROR_MSG("could not initialize logging");
		return EXIT_FAILURE;
	}

	atexit(logging_shutdown);

	if (fdb_initialize()) {
		ERROR_MSG("could not load database");
		return EXIT_FAILURE;
	}

	atexit(fdb_shutdown);

	if (channel_initialize()) {
		ERROR_MSG("could not load channels");
		return EXIT_FAILURE;
	}

	atexit(channel_shutdown);

	if (room_initialize()) {
		ERROR_MSG("could not load room sub-system");
		return EXIT_FAILURE;
	}

	atexit(room_shutdown);

	if (character_initialize()) {
		ERROR_MSG("could not load character sub-system");
		return EXIT_FAILURE;
	}

	atexit(character_shutdown);

	if (!eventlog_init()) {
		return EXIT_FAILURE;
	}

	atexit(eventlog_shutdown);

	if (!user_init()) {
		ERROR_MSG("could not initialize users");
		return EXIT_FAILURE;
	}

	atexit(user_shutdown);

	if (!form_module_init()) {
		ERROR_MSG("could not initialize forms");
		return EXIT_FAILURE;
	}

	atexit(form_module_shutdown);

	/* start the webserver if webserver.port is defined. */
	if (mud_config.webserver_port) {
		if (!webserver_init(mud_config.default_family, mud_config.webserver_port)) {
			ERROR_MSG("could not initialize webserver");
			return EXIT_FAILURE;
		}

		atexit(webserver_shutdown);
	}

	if (!game_init()) {
		ERROR_MSG("could not start game");
		return EXIT_FAILURE;
	}

	eventlog_server_startup();

	TODO("use the next event for the timer");

	while (keep_going_fl) {
		telnetclient_prompt_refresh_all();

		if (!socketio_dispatch(-1))
			break;

		fprintf(stderr, "Tick\n");
	}

	eventlog_server_shutdown();
	fprintf(stderr, "Server shutting down.\n");

	return 0;
}
