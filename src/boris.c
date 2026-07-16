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
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <time.h>
#include <channel.h>
#include <character.h>
#include <daemonize.h>
#include <eventlog.h>
#include <muddb.h>
#include <obj.h>
#include <room.h>
#include <help.h>
#define LOG_SUBSYSTEM "server"
#include <log.h>
#include <debug.h>
#include <iox_loop.h>
#include <iox_signal.h>
#include <iox_timer.h>
#include <net.h>
#include <user.h>
#include <game.h>
#include <mth.h>
#include <form.h>
#include <webserver.h>
#include <webclient.h>
#include <security.h>
#include <obj_program.h>
#include <program.h>
#include <invite.h>
#include <unistd.h>

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

static struct iox_loop *g_loop;

/** set by SIGHUP handler, checked in idle callback to flush caches. */
static volatile sig_atomic_t sighup_fl;

MUDDB *mud_db;

static void
muddb_shutdown(void)
{
	if (mud_db) {
		muddb_close(mud_db);
		mud_db = NULL;
	}
}

static void
sh_quit(struct iox_loop *loop, int signo UNUSED, void *arg UNUSED)
{
	iox_loop_stop(loop);
}

/* periodic flush + commit for the CAS object backend. one-shot
 * timer, re-armed on every firing. */
static void
obj_commit_timer(struct iox_loop *loop, void *arg UNUSED)
{
	obj_commit();
	iox_timer_add(loop, (int)mud_config.cas_commit_seconds * 1000,
		obj_commit_timer, NULL);
}

static void
sh_hup(struct iox_loop *loop UNUSED, int signo UNUSED, void *arg UNUSED)
{
	sighup_fl = 1;
}

static void
main_idle(struct iox_loop *loop UNUSED, void *arg UNUSED)
{
	struct telnetserver *cur;

	if (sighup_fl) {
		sighup_fl = 0;
		LOG_INFO("SIGHUP received -- invalidating caches");
		help_cache_invalidate();
	}

	for (cur = telnetserver_first(); cur; cur = telnetserver_next(cur)) {
		telnetclient_prompt_refresh_all(cur);
	}

	for (struct web_client *wc = webclient_first(); wc; wc = wc->next) {
		if (wc->state == WC_SSE && wc->cl) {
			telnetclient_prompt_refresh(wc->cl);
			webclient_flush(wc);
		}
	}
}

/* remove the pidfile when done */
static void
pidfile_done(void)
{
	if (mud_config.pid_file) {
		unlink(mud_config.pid_file);
	}
}

static int
pidfile_init(void)
{
	if (mud_config.pid_file) {
		FILE *f = fopen(mud_config.pid_file, "w");
		if (!f) {
			LOG_PERROR(mud_config.pid_file);
			return -1;
		}
		fprintf(f, "%ld\n", (long)getpid());
		fclose(f);
		atexit(pidfile_done);
	}

	return 0;
}

/**
 * display a program usage message and terminated with an exit code.
 */
static void
usage(void)
{
	fprintf(stderr,
		"usage: boris [-h46] [-p port]\n"
		"-4	 use IPv4-only server addresses\n"
		"-6	 use IPv6-only server addresses\n"
		"-c	 use alternate config file\n"
		"-d	 daemonize\n"
		"-f	 foreground (don't daemonize)\n"
		"-p n	 listen on TCP port <n>\n"
		"-h	 help\n"
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
		LOG_ERROR("option -%c takes a parameter", ch);
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

	case 'd': /* daemonize */
		mud_config.daemonize = 1;
		return 0;

	case 'f': /* foreground */
		mud_config.daemonize = 0;
		return 0;

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
		LOG_ERROR("Unknown option -%c", ch);

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

	/* This needs to start atleast before seccomp takes away our ability to
	 * open /dev/null */
	if (mud_config.daemonize) {
		LOG_INFO("Backgrounding ...");
		if (daemonize() != 0) {
			LOG_ERROR("could not daemonize into background");
			return EXIT_FAILURE;
		}
	}

	fds_init();

	g_loop = iox_loop_new();
	if (!g_loop || net_init(g_loop) != 0) {
		LOG_ERROR("could not initialize event loop");
		return EXIT_FAILURE;
	}

	iox_signal_add(g_loop, SIGINT, sh_quit, NULL);
	iox_signal_add(g_loop, SIGTERM, sh_quit, NULL);
#ifndef WIN32
	iox_signal_add(g_loop, SIGHUP, sh_hup, NULL);
#endif

	if (log_init()) {
		LOG_ERROR("could not initialize logging");
		return EXIT_FAILURE;
	}

	atexit(log_done);

	if (pidfile_init() != 0) {
		LOG_ERROR("could not create pidfile");
		return EXIT_FAILURE;
	}

	mud_db = muddb_open("data/muddb", 0);
	if (!mud_db) {
		LOG_ERROR("could not open LMDB database");
		return EXIT_FAILURE;
	}

	atexit(muddb_shutdown);

	init_mth();
	atexit(uninit_mth);

	if (help_init()) {
		LOG_ERROR("could not load help sub-system");
		return EXIT_FAILURE;
	}

	atexit(help_shutdown);

	if (channel_initialize()) {
		LOG_ERROR("could not load channels");
		return EXIT_FAILURE;
	}

	atexit(channel_shutdown);

	if (strcmp(mud_config.db_backend, "cas") == 0) {
		if (obj_initialize_cas(mud_config.cas_path,
			mud_config.cas_ref, mud_config.obj_cache_size,
			mud_config.cas_retain)) {
			LOG_ERROR("could not load object cache");
			return EXIT_FAILURE;
		}

		if (mud_config.cas_commit_seconds > INT_MAX / 1000) {
			LOG_WARNING("database.cas.commit_seconds too large,"
				" clamping to %d", INT_MAX / 1000);
			mud_config.cas_commit_seconds = INT_MAX / 1000;
		}

		if (mud_config.cas_commit_seconds > 0)
			iox_timer_add(g_loop,
				(int)mud_config.cas_commit_seconds * 1000,
				obj_commit_timer, NULL);
		else
			LOG_WARNING("database.cas.commit_seconds is 0:"
				" objects commit only at shutdown; a crash"
				" loses all changes since boot");
	} else if (strcmp(mud_config.db_backend, "muddb") == 0) {
		if (obj_initialize(mud_db, mud_config.obj_cache_size)) {
			LOG_ERROR("could not load object cache");
			return EXIT_FAILURE;
		}
	} else {
		LOG_ERROR("unknown database.backend \"%s\""
			" (use muddb or cas)", mud_config.db_backend);
		return EXIT_FAILURE;
	}

	atexit(obj_shutdown);

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

	if (!form_module_init()) {
		LOG_ERROR("could not initialize forms");
		return EXIT_FAILURE;
	}

	atexit(form_module_shutdown);

	if (!invite_init()) {
		LOG_ERROR("could not initialize invite system");
		return EXIT_FAILURE;
	}

	atexit(invite_shutdown);

	if (mud_config.webserver_port > 0) {
		if (webserver_init(mud_config.webserver_port) != OK) {
			LOG_ERROR("could not initialize webserver");
			return EXIT_FAILURE;
		}
		atexit(webserver_shutdown);
	}

	if (!game_init()) {
		LOG_ERROR("could not start game");
		return EXIT_FAILURE;
	}

	atexit(game_shutdown);

	if (program_init() < 0)
		LOG_WARNING("program loader disabled (no image directory)");

	atexit(program_shutdown);

	if (obj_program_init(g_loop) < 0) {
		LOG_ERROR("could not initialize obj_program");
		return EXIT_FAILURE;
	}

	atexit(obj_program_shutdown);

	eventlog_server_startup();

	if (telnetserver_listen(mud.params.port)) {
		LOG_ERROR("could not listen to port %u", mud.params.port);
		return EXIT_FAILURE;
	}

	atexit(telnetserver_shutdown);

	if (security_init() < 0) {
		LOG_ERROR("could not initialize security sandbox");
		return EXIT_FAILURE;
	}

	atexit(security_shutdown);

	iox_loop_set_idle(g_loop, main_idle, NULL);
	iox_loop_run(g_loop);

	eventlog_server_shutdown();
	LOG_INFO("Server shutting down.");

	webserver_shutdown();
	telnetserver_shutdown();
	net_shutdown();
	iox_loop_free(g_loop);
	g_loop = NULL;

	return 0;
}
