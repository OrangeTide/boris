/**
 * @file boris.c
 *
 * 20th Century MUD.
 *
 * @author Jon Mayo <jon@rm-f.net>
 * @version 0.7
 * @date 2022 Aug 27
 *
 * Copyright (c) 2008-2022, Jon Mayo <jon@rm-f.net>
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

#include "boris.h"
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <time.h>
#include <channel.h>
#include <character.h>
#include <eventlog.h>
#include <fdb.h>
#include <room.h>
#define LOG_SUBSYSTEM "server"
#include <log.h>
#include <debug.h>
#include <dyad.h>
#include <user.h>
#include <game.h>
#include <mth.h>

/* make sure WIN32 is defined when building in a Windows environment */
#if (defined(_MSC_VER) || defined(__WIN32__)) && !defined(WIN32)
#define WIN32
#endif

#if defined(WIN32)
#ifndef _WIN32_WINNT
/** require at least NT5.1 API for getaddinfo() and others */
#define _WIN32_WINNT 0x0501
#endif
#include <windows.h>

/** macro used to wrap mkdir() function from UNIX and Windows */
#define MKDIR(d) mkdir(d)
#else
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>

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
		"-p n    listen on TCP port <n>\n"
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
		LOG_ERROR("option -%c takes a parameter\n", ch);
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

	case 'p': {
			char *endptr;

			need_parameter(ch, next_arg);

			errno = 0;
			mud.params.port = strtoul(next_arg, &endptr, 0);
			if (errno || *endptr != 0) {
				LOG_ERROR("Not a number. problem with paramter '%s'", next_arg);
				usage();
			}

			return 1; /* uses next arg */
		}
		break;

	case 'V': /* print version and exit. */
		show_version();
		exit(0); /* */
		return 0;

	default:
		LOG_ERROR("Unknown option -%c\n", ch);

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
			LOG_TODO("process arguments");
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
		LOG_PERROR("data/");
		return EXIT_FAILURE;
	}

	/* load default configuration into mud_config global */
	mud_config_init();
	atexit(mud_config_shutdown);

	/* parse options and load into mud_config global */
	process_args(argc, argv);

	/* process configuration file and load into mud_config global */
	if (!mud_config_process()) {
		LOG_ERROR("could not load configuration");
		return EXIT_FAILURE;
	}

	dyad_init();
	atexit(dyad_shutdown);

	if (log_init()) {
		LOG_ERROR("could not initialize logging");
		return EXIT_FAILURE;
	}

	atexit(log_done);

	if (fdb_initialize()) {
		LOG_ERROR("could not load database");
		return EXIT_FAILURE;
	}

	atexit(fdb_shutdown);

	init_mth();

	if (channel_initialize()) {
		LOG_ERROR("could not load channels");
		return EXIT_FAILURE;
	}

	atexit(channel_shutdown);

	if (room_initialize()) {
		LOG_ERROR("could not load room sub-system");
		return EXIT_FAILURE;
	}

	atexit(room_shutdown);

	if (character_initialize()) {
		LOG_ERROR("could not load character sub-system");
		return EXIT_FAILURE;
	}

	atexit(character_shutdown);

	if (!eventlog_init()) {
		return EXIT_FAILURE;
	}

	atexit(eventlog_shutdown);

	if (!user_init()) {
		LOG_ERROR("could not initialize users");
		return EXIT_FAILURE;
	}

	atexit(user_shutdown);

#if 0 // DISABLED
	if (!form_module_init()) {
		LOG_ERROR("could not initialize forms");
		return EXIT_FAILURE;
	}

	atexit(form_module_shutdown);
#endif

#if 0 // DISABLED
	/* start the webserver if webserver.port is defined. */
	if (mud_config.webserver_port > 0) {
		if (!webserver_init(mud_config.default_family, mud_config.webserver_port)) {
			LOG_ERROR("could not initialize webserver");
			return EXIT_FAILURE;
		}

		atexit(webserver_shutdown);
	}
#endif

	if (!game_init()) {
		LOG_ERROR("could not start game");
		return EXIT_FAILURE;
	}

	eventlog_server_startup();

	if (telnetserver_listen(mud.params.port)) {
		LOG_ERROR("could not listen to port %u", mud.params.port);
		return EXIT_FAILURE;
	}

	LOG_TODO("use the next event for the timer");

	dyad_setUpdateTimeout(10);

	while (keep_going_fl && dyad_getStreamCount() > 0) {
		/* TODO: fix prompt refresh code
		struct telnetserver *cur = telnetserver_first();
		for (; cur; cur = telnetserver_next(cur)) {
			telnetclient_prompt_refresh_all(cur);
		}
		*/

		dyad_update();

		LOG_INFO("Tick\n");
	}

	eventlog_server_shutdown();
	fprintf(stderr, "Server shutting down.\n");

	return 0;
}
